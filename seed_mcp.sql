INSERT INTO mcp_servers (
    id, name, display_name, transport, command, args, enabled, created_by, tenant_id
) VALUES (
    '0193b111-1111-2222-3333-000000000001', 'memory-mcp', 'Memory MCP', 'stdio', 'sh', '["/Volumes/Workspace/0-Working/bkplus/ios-memory/tooling/memory-mcp/start.sh"]', 1, 'system', '0193a5b0-7000-7000-8000-000000000001'
);

INSERT INTO mcp_servers (
    id, name, display_name, transport, command, args, enabled, created_by, tenant_id
) VALUES (
    '0193b111-1111-2222-3333-000000000002', 'agent-mail', 'Agent Mail', 'stdio', 'am', '["serve"]', 1, 'system', '0193a5b0-7000-7000-8000-000000000001'
);

INSERT INTO mcp_agent_grants (
    id, server_id, agent_id, enabled, granted_by, tenant_id
) VALUES (
    '0193b222-1111-2222-3333-000000000001', '0193b111-1111-2222-3333-000000000001', '0193b000-1111-2222-3333-000000000001', 1, 'system', '0193a5b0-7000-7000-8000-000000000001'
);

INSERT INTO mcp_agent_grants (
    id, server_id, agent_id, enabled, granted_by, tenant_id
) VALUES (
    '0193b222-1111-2222-3333-000000000002', '0193b111-1111-2222-3333-000000000002', '0193b000-1111-2222-3333-000000000001', 1, 'system', '0193a5b0-7000-7000-8000-000000000001'
);
