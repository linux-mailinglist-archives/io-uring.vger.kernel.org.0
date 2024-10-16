Return-Path: <io-uring+bounces-3702-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D088799FD39
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 02:37:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5DA521F25162
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 00:37:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3D0A1097B;
	Wed, 16 Oct 2024 00:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="Sbc0OFB1"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE17DE574
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 00:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729039067; cv=fail; b=Md+ZzDwSbVXZrEvJLZuYPNbqVdNCzlKlePGr/ESkqTBoMIPjPIUH7vjrLNqubuQi2sxF7vE62kCsdjniNfhGRZu9XkF6B1LtQuxh0kMhz2p0sfAkaVdBO2UdgAwAbvdHQIfQ5dmOYi3pqS8JBoS/RuBAfDak8aRioMlmldNuLKs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729039067; c=relaxed/simple;
	bh=IE8QCr28JAiz4NNIavd24adYQOb1l5pJXij9/+pcj8M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iHAQvfl6yL6qo8zeRYtxkP7N7JgSU/rl9/I9qVSlla4v+qCx0Gt2QYgtWG9MQ3A1eVxZv34rpGR+ATnNsnx8AKCBV/c4YqBeXUSb7XAsRprOWJAGslkCdz0haXVUj6q+df0wsv8qc8g5LqXYq2LA0YdiVc7kyF2PpmuUBgmMAK0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=Sbc0OFB1; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171]) by mx-outbound10-224.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 16 Oct 2024 00:37:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c7Wu2+fr+ljQMdl0JEPpiXAejk9SQkoHI9+46VO3MxQDXD3b4zc7OX9ows+f4d+3oZLL+TazS1NmLOzmjlA/BeUpCjsrJ8H8ZkH6+OyPSO2kKXB9ZFiA2HV4qFyaN7ffw6ZCVB6oUKFkjPniYHy5z0iKkiyo8ZiMlI7ciUTbIgXsO+3O/USiWdulLX+NjZE/1fvDSCWRMseWSM8PvHseVkhHMC0uSb81pSLTYsItizhpcYDd3Eolm0olIwfAvtwgbwgjESofuyYQCtK5X9RmOGI0Rlri2QwOzmftUHIhbQ7eDkFkZ2DEYfhV+pwrROkwGS+da4uyV7M4KnNNvHml1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XolP/wFDM5oXFa4Iva8NqB4zQqiZdfPjrPeeAZh1SS8=;
 b=BlHYQ9pfxVU3VPTkNv58KNX5WuOfjk1agd5og5sk01AmIKtIjAS47HtA14EOegfaatR/E6GA751NBygsVCtfcciXPr1dunqkCfPJw5bx/LHq85N3bTTjJr70CRjAq1lvT3VQrzqm2plUI5yDnQkII11/sucIj1QHjzwocVMAOPZV0UmpJZo4HYi0svdxBANk7p3vYMIixgZcDLF8wKbBNT2HLNCbw+pUS9pxiJT5awUOkYkU4jGH8uKHtQ/1TPv42ikn099rdY4APa0H+76avyLXWT9cW7zlXlDCS2cGqLInb7Qc21skywKfoOV6msCVwfurx86+PpL+u+bcr+ED0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XolP/wFDM5oXFa4Iva8NqB4zQqiZdfPjrPeeAZh1SS8=;
 b=Sbc0OFB1zzXUKqSd1066d9TuAHycotipcZJpFjuErNSq0/wxv49XE39Vnx8UofKiN/yTLuNAGOW6VKgOw6GaCW1/2vCln3nmBEIww6A3cWRJOXkZfYTMrCE2zZxmYw8hsCYovPDGonND9LtGeIwxoAjaN7LM9vsSYPQTBUqDIpU=
Received: from BN9PR03CA0435.namprd03.prod.outlook.com (2603:10b6:408:113::20)
 by PH7PR19MB6061.namprd19.prod.outlook.com (2603:10b6:510:1dc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17; Wed, 16 Oct
 2024 00:05:34 +0000
Received: from BL02EPF00021F6C.namprd02.prod.outlook.com
 (2603:10b6:408:113:cafe::a7) by BN9PR03CA0435.outlook.office365.com
 (2603:10b6:408:113::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.18 via Frontend
 Transport; Wed, 16 Oct 2024 00:05:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BL02EPF00021F6C.mail.protection.outlook.com (10.167.249.8) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8069.17
 via Frontend Transport; Wed, 16 Oct 2024 00:05:34 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id D7ABC7D;
	Wed, 16 Oct 2024 00:05:32 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 16 Oct 2024 02:05:21 +0200
Subject: [PATCH RFC v4 09/15] fuse: {uring} Handle teardown of ring entries
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241016-fuse-uring-for-6-10-rfc4-v4-9-9739c753666e@ddn.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
In-Reply-To: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>, 
 Ming Lei <tom.leiming@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1729037122; l=12675;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=IE8QCr28JAiz4NNIavd24adYQOb1l5pJXij9/+pcj8M=;
 b=pA7u1c6vCNOB3TZWyd3LjZpaa8GP+Z2kziUarTld9q+oEEVvdeeGzA81dYvY1FkoqS+NpBZbT
 hLLku1rJ59sBnNBfo84dTWp4KoCq4EsBLb9oLgENWkJGW309OBkyBF7
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6C:EE_|PH7PR19MB6061:EE_
X-MS-Office365-Filtering-Correlation-Id: c4678d82-ced5-4cf2-c4a0-08dced76418f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OW9VWVN2cGZUc0M5WDl0Y3gxeXQrSTB6bWg4Z05wN0txa2pHVWdjaEdxdXhJ?=
 =?utf-8?B?bFJlYlFzRFZUUGdJRWlLZERUcVJVajRKdDVWTzRvbHFIWmgzaUFYTHhSV0NC?=
 =?utf-8?B?WlFHc0p2STNOcGNiRUtXdytPYXhDcVBiakQxVnZjN3M4enFBUzkwTFk2ZXlK?=
 =?utf-8?B?WHphNUxXZytGd3FRR1hoTXZmNWErMHJ2WSt4MUVONFZOaGNXNmVaMHdJL2lm?=
 =?utf-8?B?VVd3VVgxM051cEgyVnhCZXBuaGtTM0diK00vR0RKSU4rL0lVb0dHY0lZUnd2?=
 =?utf-8?B?alk5emg3VThmUjhzdmFSbTcrQXJZNkRDSklmVnl3aEJReHVMcXcwakJOOWd2?=
 =?utf-8?B?K00yazZpa1lSS1ZkWHJRZE5zSTE3a1VNVWNrYzM1NlZraSt6Y0RMcU9Vd2RE?=
 =?utf-8?B?N0VqOHJwcXZZVkgvdmE3QXpQMkdJbmRPWEVNeHZZcVpBRXdaNEpPOXRKd0o3?=
 =?utf-8?B?dXpUQUxIQ2xkV28vdWsxZWs2U01YWVZwQUgzYlN6RVpaVm1paUF5S0d0TklP?=
 =?utf-8?B?bmY1QTR6TXo2dmhHdXhiZGFrbGNndC8zUmtMajF0aWhVQjlBU2FJN1hIbXZX?=
 =?utf-8?B?WlFqUkdyNFMzc1FJWk1kdUxqWjBtV1hQY2NPa3FOZ09JbUI5WFBTakxsY0dx?=
 =?utf-8?B?aitPdms5cFR3bFQ3bzdSZnpKeUwrTW5NanM4dGMyVlYzNjBXNGZacG5VdU14?=
 =?utf-8?B?WXIwOUIrUmVmTUFIS0VGN2ViWlFoR3ovbEFpdVRGVm9BOWRJTmVHNnUyVkx0?=
 =?utf-8?B?cGh1SlM1ems5QXo5MnR4WW5rNi9PZ2FEU0h5TUNJUXVFMU5UUFB3VDNvb0Iv?=
 =?utf-8?B?SkMrUnFyVytncUt0cEtFNkgwVUdDY2ZDZnBETk9MV2JBODRXV2x5b01TVHlj?=
 =?utf-8?B?cExIQmk5cmZ6dnVCSWZzekZiaVhRYjFvVTVxRUJqdmlTQ29KNisySFQxZDZZ?=
 =?utf-8?B?cmJwamI4RWovbEs5eEZQVmZhQ1MvY09GUUVzR256UWFZMUxKWGFzVnQxeWt1?=
 =?utf-8?B?YlBUa0UrR1RIYmI4a2dGR3BHY0huYUxwUUxhNWZGMXhuQWN4ZE1XZ2tZZmdH?=
 =?utf-8?B?ZTAwRFBSb0NrZ0doZXBrNGR1Rno1U2lWTStuQWhDWmRCQlROZVhXR0dHbHBX?=
 =?utf-8?B?T3JUZXYwVmk5Q0FPVGhXcHVQNGprNEdvdElRWmpnZ2ZyeUFIRkdNNnd3ZDJT?=
 =?utf-8?B?bHI5U0ZXd3JMajBTK2prZ3Fnbk1KOCtpU2RHeWRHWFVxRUpRQkozdWdQaXQz?=
 =?utf-8?B?cHFEQnNzN3ljd240QjF4bG5pSUFqOU1RTFZ0b2gyVW85cllFNm51NjAyOGxG?=
 =?utf-8?B?eUF1RzdLQVZNNlVGcW5GaVg2bndxN3RSbHJ3WktXUHZyM2pKWk91cW1LWnVF?=
 =?utf-8?B?ZDhJVGpLMllSR2l3cFNCRHhpM0x6V0lTQ08wQkU0UytPQ3A4S1NhY3dvOGZ2?=
 =?utf-8?B?cUNRdTRSalQ3bUtZL1ZJcm9maURhdFgwUnU3VzJ1VjVnZityWGFQS1JIb2xl?=
 =?utf-8?B?Sysydk9EbjY5SFJjOU5ETzZSajJsazUyQnlVdWo2QXRQUDRYeUN1cWtsZzk1?=
 =?utf-8?B?UjllQVZEaXFWZEpqTzFLb1ZVVC8rUzNrNnV5NldTWm5PaHF6RE93ZHpDN0FW?=
 =?utf-8?B?Ti9HVytmQ1k3ejJqanZLOFBNME13a3RaNTZCclNpaXZpNzkySVRsL2wwd291?=
 =?utf-8?B?VnVYQnYvdVRXRWFyUmFDMEQ0NUQxd2JHRlN3Yk5CU3YxSnF2QVFlaHpySzh6?=
 =?utf-8?B?RC9HT3NHOFp4YWJiNzU5Y2VkTkoyYUFkU2QrRmZRbTNZdHhYSk1ScUlvSnFv?=
 =?utf-8?B?a3hNb2c2NGxLdnl4eVB2clUxYlBmVkU4WGUxVWpHRDBDZ2QrSFo3SmI0ek9x?=
 =?utf-8?Q?HN3jY3nqKwRFJ?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	J1D3Y/x14X75TCuTSAzzeYrXpH4sWKAPk4Q7ss9qFOvIYQQq0kw1vZJBiHxtRAQi/HpGFKZwcIhxxtQWK/VBGqVR6q1QN1kN4f/z+CZCx+JRRRdQo/WDxYzyINU2nurunKy++NETcvwZQ0+wcRdG4MXlP8a+7YG5OdOtMnZYnvmzP+HBMZssKaKfMAz40vAc5M8k8f5Wz3covP9EKuan06Xe8gg6MXAnbyUyVJ0jNCK5Smpx2kTzU7q1uelPIKfZUt0NcbrILHAedV/F7RhhD65pI7BDgn6+waHhgNDAWwbfv+OhOy0pHj7dmkkh/M5jV31jUvXw+aTCSZJroYZ+BchFSYSHKR3vIPo/ZA7vjq9ctj3ZVTH6WiBY2yGDvt9BcAKqLfrAtc62kvZpG2cxvG5ns5B4HN3EpjWZ0jJgbGi5+FQmqxtwFubrIhbNbm+cgmj37JenNKJJVHLbJawESwIchsBTFl3dONm+MUS0P54b/5uHJvo7+ouUtn1tSjUoX/fXJ8/XKk3cOZlFkDzfO9cld6b0q/JwmEBUJxvV6Ckb0Ssi9rodnMlCR4I4q1KUYR8tMNAN6XyFT7OJF1T433TgzacCcg+Ezyac1QHVsQ3p6TxSiHaO/le/83H3cJGH7peBE2jnzqeZisJyQm+gPg==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:05:34.0070
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c4678d82-ced5-4cf2-c4a0-08dced76418f
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR19MB6061
X-OriginatorOrg: ddn.com
X-BESS-ID: 1729039064-102784-17746-3315-1
X-BESS-VER: 2019.1_20241015.1627
X-BESS-Apparent-Source-IP: 104.47.57.171
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoZGRsamQGYGUNTSzMLA2MDE1C
	wpycIy1TIlxcLQyNzA2NTcyMjc2DDNSKk2FgBNBTWkQgAAAA==
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.259752 [from 
	cloudscan8-195.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, BSF_SC0_MISMATCH_TO
X-BESS-BRTS-Status:1

On teardown struct file_operations::uring_cmd requests
need to be completed by calling io_uring_cmd_done().
Not completing all ring entries would result in busy io-uring
tasks giving warning messages in intervals and unreleased
struct file.

Additionally the fuse connection and with that the ring can
only get released when all io-uring commands are completed.

Completion is done with ring entries that are
a) in waiting state for new fuse requests - io_uring_cmd_done
is needed

b) already in userspace - io_uring_cmd_done through teardown
is not needed, the request can just get released. If fuse server
is still active and commits such a ring entry, fuse_uring_cmd()
already checks if the connection is active and then complete the
io-uring itself with -ENOTCONN. I.e. special handling is not
needed.

This scheme is basically represented by the ring entry state
FRRS_WAIT and FRRS_USERSPACE.

Entries in state:
- FRRS_INIT: No action needed, do not contribute to
  ring->queue_refs yet
- All other states: Are currently processed by other tasks,
  async teardown is needed and it has to wait for the two
  states above. It could be also solved without an async
  teardown task, but would require additional if conditions
  in hot code paths. Also in my personal opinion the code
  looks cleaner with async teardown.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c         |   8 ++
 fs/fuse/dev_uring.c   | 212 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/fuse/dev_uring_i.h |  62 +++++++++++++++
 3 files changed, 279 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index fdb43640db5fdbe6b6232e1b2e2259e3117d237d..c8cc5fb2cfada29226f578a6273e8d6d34ab59ab 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -2226,6 +2226,12 @@ void fuse_abort_conn(struct fuse_conn *fc)
 		spin_unlock(&fc->lock);
 
 		fuse_dev_end_requests(&to_end);
+
+		/*
+		 * fc->lock must not be taken to avoid conflicts with io-uring
+		 * locks
+		 */
+		fuse_uring_abort(fc);
 	} else {
 		spin_unlock(&fc->lock);
 	}
@@ -2237,6 +2243,8 @@ void fuse_wait_aborted(struct fuse_conn *fc)
 	/* matches implicit memory barrier in fuse_drop_waiting() */
 	smp_mb();
 	wait_event(fc->blocked_waitq, atomic_read(&fc->num_waiting) == 0);
+
+	fuse_uring_wait_stopped_queues(fc);
 }
 
 int fuse_dev_release(struct inode *inode, struct file *file)
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 0c39d5c1c62a1c496782e5c54b9f72a70cffdfa2..455a42a6b9348dda15dd082d3bfd778279f61e0b 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -50,6 +50,36 @@ static int fuse_ring_ring_ent_unset_userspace(struct fuse_ring_ent *ent)
 	return 0;
 }
 
+/* Abort all list queued request on the given ring queue */
+static void fuse_uring_abort_end_queue_requests(struct fuse_ring_queue *queue)
+{
+	struct fuse_req *req;
+	LIST_HEAD(req_list);
+
+	spin_lock(&queue->lock);
+	list_for_each_entry(req, &queue->fuse_req_queue, list)
+		clear_bit(FR_PENDING, &req->flags);
+	list_splice_init(&queue->fuse_req_queue, &req_list);
+	spin_unlock(&queue->lock);
+
+	/* must not hold queue lock to avoid order issues with fi->lock */
+	fuse_dev_end_requests(&req_list);
+}
+
+void fuse_uring_abort_end_requests(struct fuse_ring *ring)
+{
+	int qid;
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = ring->queues[qid];
+
+		if (!queue)
+			continue;
+
+		fuse_uring_abort_end_queue_requests(queue);
+	}
+}
+
 void fuse_uring_destruct(struct fuse_conn *fc)
 {
 	struct fuse_ring *ring = fc->ring;
@@ -106,9 +136,12 @@ static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
 		goto out_err;
 	}
 
+	init_waitqueue_head(&ring->stop_waitq);
+
 	fc->ring = ring;
 	ring->nr_queues = nr_queues;
 	ring->fc = fc;
+	atomic_set(&ring->queue_refs, 0);
 
 	spin_unlock(&fc->lock);
 	return ring;
@@ -168,6 +201,175 @@ fuse_uring_async_send_to_ring(struct io_uring_cmd *cmd,
 	io_uring_cmd_done(cmd, 0, 0, issue_flags);
 }
 
+static void fuse_uring_stop_fuse_req_end(struct fuse_ring_ent *ent)
+{
+	struct fuse_req *req = ent->fuse_req;
+
+	ent->fuse_req = NULL;
+	clear_bit(FR_SENT, &req->flags);
+	req->out.h.error = -ECONNABORTED;
+	fuse_request_end(req);
+}
+
+/*
+ * Release a request/entry on connection tear down
+ */
+static void fuse_uring_entry_teardown(struct fuse_ring_ent *ent,
+					 bool need_cmd_done)
+{
+	struct fuse_ring_queue *queue = ent->queue;
+
+	/*
+	 * fuse_request_end() might take other locks like fi->lock and
+	 * can lead to lock ordering issues
+	 */
+	lockdep_assert_not_held(&ent->queue->lock);
+
+	if (need_cmd_done) {
+		pr_devel("qid=%d sending cmd_done\n", queue->qid);
+
+		io_uring_cmd_done(ent->cmd, -ENOTCONN, 0,
+				  IO_URING_F_UNLOCKED);
+	}
+
+	if (ent->fuse_req)
+		fuse_uring_stop_fuse_req_end(ent);
+
+	list_del_init(&ent->list);
+	kfree(ent);
+}
+
+static void fuse_uring_stop_list_entries(struct list_head *head,
+					 struct fuse_ring_queue *queue,
+					 enum fuse_ring_req_state exp_state)
+{
+	struct fuse_ring *ring = queue->ring;
+	struct fuse_ring_ent *ent, *next;
+	ssize_t queue_refs = SSIZE_MAX;
+	LIST_HEAD(to_teardown);
+
+	spin_lock(&queue->lock);
+	list_for_each_entry_safe(ent, next, head, list) {
+		if (ent->state != exp_state) {
+			pr_warn("entry teardown qid=%d state=%d expected=%d",
+				queue->qid, ent->state, exp_state);
+			continue;
+		}
+
+		list_move(&ent->list, &to_teardown);
+	}
+	spin_unlock(&queue->lock);
+
+	/* no queue lock to avoid lock order issues */
+	list_for_each_entry_safe(ent, next, &to_teardown, list) {
+		bool need_cmd_done = ent->state != FRRS_USERSPACE;
+
+		fuse_uring_entry_teardown(ent, need_cmd_done);
+		queue_refs = atomic_dec_return(&ring->queue_refs);
+
+		if (WARN_ON_ONCE(queue_refs < 0))
+			pr_warn("qid=%d queue_refs=%zd", queue->qid,
+				queue_refs);
+	}
+}
+
+static void fuse_uring_stop_queue(struct fuse_ring_queue *queue)
+{
+	fuse_uring_stop_list_entries(&queue->ent_in_userspace, queue,
+				     FRRS_USERSPACE);
+	fuse_uring_stop_list_entries(&queue->ent_avail_queue, queue, FRRS_WAIT);
+}
+
+/*
+ * Log state debug info
+ */
+static void fuse_uring_log_ent_state(struct fuse_ring *ring)
+{
+	int qid;
+	struct fuse_ring_ent *ent;
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = ring->queues[qid];
+
+		if (!queue)
+			continue;
+
+		spin_lock(&queue->lock);
+		/*
+		 * Log entries from the intermediate queue, the other queues
+		 * should be empty
+		 */
+		list_for_each_entry(ent, &queue->ent_intermediate_queue, list) {
+			pr_info("ring=%p qid=%d ent=%p state=%d\n", ring, qid,
+				ent, ent->state);
+		}
+		spin_lock(&queue->lock);
+	}
+	ring->stop_debug_log = 1;
+}
+
+static void fuse_uring_async_stop_queues(struct work_struct *work)
+{
+	int qid;
+	struct fuse_ring *ring =
+		container_of(work, struct fuse_ring, async_teardown_work.work);
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = ring->queues[qid];
+
+		if (!queue)
+			continue;
+
+		fuse_uring_stop_queue(queue);
+	}
+
+	/*
+	 * Some ring entries are might be in the middle of IO operations,
+	 * i.e. in process to get handled by file_operations::uring_cmd
+	 * or on the way to userspace - we could handle that with conditions in
+	 * run time code, but easier/cleaner to have an async tear down handler
+	 * If there are still queue references left
+	 */
+	if (atomic_read(&ring->queue_refs) > 0) {
+		if (time_after(jiffies,
+			       ring->teardown_time + FUSE_URING_TEARDOWN_TIMEOUT))
+			fuse_uring_log_ent_state(ring);
+
+		schedule_delayed_work(&ring->async_teardown_work,
+				      FUSE_URING_TEARDOWN_INTERVAL);
+	} else {
+		wake_up_all(&ring->stop_waitq);
+	}
+}
+
+/*
+ * Stop the ring queues
+ */
+void fuse_uring_stop_queues(struct fuse_ring *ring)
+{
+	int qid;
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = ring->queues[qid];
+
+		if (!queue)
+			continue;
+
+		fuse_uring_stop_queue(queue);
+	}
+
+	if (atomic_read(&ring->queue_refs) > 0) {
+		pr_info("ring=%p scheduling async queue stop\n", ring);
+		ring->teardown_time = jiffies;
+		INIT_DELAYED_WORK(&ring->async_teardown_work,
+				  fuse_uring_async_stop_queues);
+		schedule_delayed_work(&ring->async_teardown_work,
+				      FUSE_URING_TEARDOWN_INTERVAL);
+	} else {
+		wake_up_all(&ring->stop_waitq);
+	}
+}
+
 /*
  * Checks for errors and stores it into the request
  */
@@ -542,6 +744,9 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 		return err;
 	fpq = queue->fpq;
 
+	if (!READ_ONCE(fc->connected) || READ_ONCE(queue->stopped))
+		return err;
+
 	spin_lock(&queue->lock);
 	/* Find a request based on the unique ID of the fuse request
 	 * This should get revised, as it needs a hash calculation and list
@@ -659,6 +864,7 @@ static int fuse_uring_fetch(struct io_uring_cmd *cmd, unsigned int issue_flags,
 	if (WARN_ON_ONCE(err != 0))
 		goto err;
 
+	atomic_inc(&ring->queue_refs);
 	_fuse_uring_fetch(ring_ent, cmd, issue_flags);
 
 	return 0;
@@ -680,13 +886,13 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	u32 cmd_op = cmd->cmd_op;
 	int err = 0;
 
-	pr_devel("%s:%d received: cmd op %d\n", __func__, __LINE__, cmd_op);
-
 	/* Disabled for now, especially as teardown is not implemented yet */
 	err = -EOPNOTSUPP;
 	pr_info_ratelimited("fuse-io-uring is not enabled yet\n");
 	goto out;
 
+	pr_devel("%s:%d received: cmd op %d\n", __func__, __LINE__, cmd_op);
+
 	err = -EOPNOTSUPP;
 	if (!enable_uring) {
 		pr_info_ratelimited("uring is disabled\n");
@@ -709,7 +915,7 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 		err = fuse_uring_fetch(cmd, issue_flags, fc);
 		break;
 	case FUSE_URING_REQ_COMMIT_AND_FETCH:
-		ret = fuse_uring_commit_fetch(cmd, issue_flags, fc);
+		err = fuse_uring_commit_fetch(cmd, issue_flags, fc);
 		break;
 	default:
 		err = -EINVAL;
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 9bc7f490b02acb46aa7bbb31d5ce55a4d2787a60..c19e439cd51316bdabdd16901659e97b2ff90875 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -11,6 +11,9 @@
 
 #ifdef CONFIG_FUSE_IO_URING
 
+#define FUSE_URING_TEARDOWN_TIMEOUT (5 * HZ)
+#define FUSE_URING_TEARDOWN_INTERVAL (HZ/20)
+
 enum fuse_ring_req_state {
 
 	/* ring entry received from userspace and it being processed */
@@ -82,6 +85,8 @@ struct fuse_ring_queue {
 	struct list_head fuse_req_queue;
 
 	struct fuse_pqueue fpq;
+
+	bool stopped;
 };
 
 /**
@@ -96,11 +101,61 @@ struct fuse_ring {
 	size_t nr_queues;
 
 	struct fuse_ring_queue **queues;
+	/*
+	 * Log ring entry states onces on stop when entries cannot be
+	 * released
+	 */
+	unsigned int stop_debug_log : 1;
+
+	wait_queue_head_t stop_waitq;
+
+	/* async tear down */
+	struct delayed_work async_teardown_work;
+
+	/* log */
+	unsigned long teardown_time;
+
+	atomic_t queue_refs;
 };
 
 void fuse_uring_destruct(struct fuse_conn *fc);
+void fuse_uring_stop_queues(struct fuse_ring *ring);
+void fuse_uring_abort_end_requests(struct fuse_ring *ring);
 int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
 
+static inline void fuse_uring_set_stopped_queues(struct fuse_ring *ring)
+{
+	int qid;
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = ring->queues[qid];
+
+		WRITE_ONCE(queue->stopped, true);
+	}
+}
+
+static inline void fuse_uring_abort(struct fuse_conn *fc)
+{
+	struct fuse_ring *ring = fc->ring;
+
+	if (ring == NULL)
+		return;
+
+	if (atomic_read(&ring->queue_refs) > 0) {
+		fuse_uring_abort_end_requests(ring);
+		fuse_uring_stop_queues(ring);
+	}
+}
+
+static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
+{
+	struct fuse_ring *ring = fc->ring;
+
+	if (ring)
+		wait_event(ring->stop_waitq,
+			   atomic_read(&ring->queue_refs) == 0);
+}
+
 #else /* CONFIG_FUSE_IO_URING */
 
 struct fuse_ring;
@@ -113,6 +168,13 @@ static inline void fuse_uring_destruct(struct fuse_conn *fc)
 {
 }
 
+static inline void fuse_uring_abort(struct fuse_conn *fc)
+{
+}
+
+static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
+{
+}
 #endif /* CONFIG_FUSE_IO_URING */
 
 #endif /* _FS_FUSE_DEV_URING_I_H */

-- 
2.43.0


