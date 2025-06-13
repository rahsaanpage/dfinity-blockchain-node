json = require("json")
http = require("http")

function BuildUrl(endpoint)
    base = RPCBaseURL
    if string.sub(base, -1, -1) ~= "/" then
        base = base .. "/"
    end
    return base .. endpoint
end

function HttpPost(url, body_json)
    result, status = http.post(url, { body = body_json, headers = {
      ["Content-Type"] = "application/json";
    }})

    if status ~= nil then
        error(string.format("error: %s", status))
    end

    if result.status_code ~= 200 then
        error(string.format("error: %s : %s", result.status_code, result.body))
    end

    json_response, status = json.decode(result.body)
    if status ~= nil then
        error(status)
    end

    return json_response
end

function NetworkList()
    url = BuildUrl("network/list")
    body_json = "{}"
    return HttpPost(url, body_json)
end

function NetworkStatus(network_identifier)
    body = {
        network_identifier = network_identifier
    }

    body_json, status = json.encode(body)
    if status ~= nil then
        error(status)
    end

    url = BuildUrl("network/status")
    return HttpPost(url, body_json)
end

function PopulateResponse(network_status)
    -- last block hash
    Response.BlockHash = network_status.current_block_identifier.hash
    -- last block height
    Response.BlockHeight = network_status.current_block_identifier.index
    -- last peer count
    Response.PeerCount = #network_status.peers
    timestamp_in_milliseconds = network_status.current_block_timestamp
    -- last block timestamp
    Response.LastBlockTime.Seconds = timestamp_in_milliseconds / 1000
end

status, network_list = pcall(NetworkList)
if status and network_list ~= nil then
    network_identifiers = network_list.network_identifiers
    if #network_identifiers == 1 then
        network_identifier = network_identifiers[1]
        status, network_status = pcall(NetworkStatus, network_identifier)
        if status and network_status ~= nil then
            PopulateResponse(network_status)
        end
    end
end
