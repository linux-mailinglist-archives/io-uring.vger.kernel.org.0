Return-Path: <io-uring+bounces-5715-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C1DCA034CA
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 02:59:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A96D163D6A
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 01:59:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E5696A33B;
	Tue,  7 Jan 2025 01:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="FbpYPDAY"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B24F7DA7F
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 01:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215188; cv=fail; b=QFsK5EplArcVP497WknLrhmdzd6Zg3fAwsnuVzJNPsW11i+KbTJryAa83MEeoJGu2OhMcj7iFTOirxMkkc/hJvN8e2yS8eKa3/SBisS5J3opTfbxNQdnLvT3g4mKQaNGLm5COVxgx2mM4plw1b9qump8Y5nnsMhEWVO/kH9z1r8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215188; c=relaxed/simple;
	bh=bpz9jYdZQEOQdBfiKXiZwRgnp9oHesOsIHgalszfXPs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dKvnvz105PBTqkOTAJKugRcxNwaDxjTjdxDmrscBAAK5A3fEhXouKsp3KgeCtUKT5RbiZR4zHD2FNHdfUQLMdLjaTlHFKqoQ/tJcu7mC+rTWELH9gF2jk2cdTgmC8IsYXmpE9sdNsSr11H1efogwFcFN9e0Q+OeUVtpNJB3BIeM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=FbpYPDAY; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177]) by mx-outbound22-188.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Tue, 07 Jan 2025 01:59:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=efvdhDF5tbENwYliJ7IkEpY6CEIcq4KpPh2mkr9GW4/xkpxUvGHpoAqnteFYazRoPAFN1wKRk4QKi/aX4Vc7Z5/NkhcmBdqvKwNaC+4RN1i8n5DawbXQSTnDwlt+kQG4loVltnBsgeK2nyt6Y/SdyOfuBI68rBZFFjinkryGhqCsVtmFLV2Kt10oTKaICIbaQKRanMnK00b80BJTCxfBy6WQRCOEIoX9y53Z6kibdldCkzacSdTcOeppmMnB427cFGZEYnR73f/7VL6kP7L3tgSICOc4x5AoDHLcLqy3OwmOB7n4ZBjwMSIxpLJgMyZKvki6l4L/hjuqLxGRNDtXTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OzB207LVFcHhSySR/O8OdAO8erEuw9C7AZx6YrWeNEk=;
 b=ID1wC12pKu8iTYs1nAsMPN2kP5gqT9pexAu9fqs5UOJbXBwG7t7dah8nAZ/wm3Rh8xW919GrHzLurdKV3nvF3aTcypgkjU66NJ7XWfheOqZIdttFzWwNO2X5DQ+8IYHfMuOFiuB8r09LkliWKMqMCYikknPf+wn9DfflB6b6JfpFDriSIQru5b3wullOGsmV3HhmX5w4m/gq6HLkaDjunONAAwp9WHCjQ8pMSXDzWFDlMLFBaMLa8oe4RJ6qi8PtVRFVqLqs6ntCR1SYB2T0fU+RxvkrmIjJQg2gecPKFZCyH8dblSPWu7G/dVACSOealKtgP6oxW53Xn5IMeC9WBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OzB207LVFcHhSySR/O8OdAO8erEuw9C7AZx6YrWeNEk=;
 b=FbpYPDAYXxmwcbvyEuu6ohI41gwAXHI3BRGOnQXxcWNkEna/tcLloztDFkn3k1oEhhstFnzZpEBWfKhnmjziSlrmzw1Lxu0ZvgEQIXoD6+V88mzuAU02qPFlTKoqZwoDfTuhAU1HlB27viWl3Le4PjjQx3Kr1Ng6wIebgXM0FJs=
Received: from MW4PR04CA0260.namprd04.prod.outlook.com (2603:10b6:303:88::25)
 by SJ0PR19MB4745.namprd19.prod.outlook.com (2603:10b6:a03:2e1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.15; Tue, 7 Jan
 2025 00:25:15 +0000
Received: from SJ5PEPF000001E8.namprd05.prod.outlook.com
 (2603:10b6:303:88:cafe::e4) by MW4PR04CA0260.outlook.office365.com
 (2603:10b6:303:88::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.17 via Frontend Transport; Tue,
 7 Jan 2025 00:25:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SJ5PEPF000001E8.mail.protection.outlook.com (10.167.242.196) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8335.7
 via Frontend Transport; Tue, 7 Jan 2025 00:25:14 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 4128A55;
	Tue,  7 Jan 2025 00:25:14 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Tue, 07 Jan 2025 01:25:09 +0100
Subject: [PATCH v9 04/17] fuse: Add fuse-io-uring design documentation
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250107-fuse-uring-for-6-10-rfc4-v9-4-9c786f9a7a9d@ddn.com>
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
In-Reply-To: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1736209509; l=4852;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=bpz9jYdZQEOQdBfiKXiZwRgnp9oHesOsIHgalszfXPs=;
 b=G7B1sLQ/y2nSkL57GcSfXTFBXioxAH8aGJQYI+uGoHOycHgpUrj8BMadzEQKhK7hn1sOAoOjy
 xeogM0YrdB2DVx6kHn9XyD/xwYoFUx2ZhLWMWRm8xofbTmtscWLR6VY
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001E8:EE_|SJ0PR19MB4745:EE_
X-MS-Office365-Filtering-Correlation-Id: 4993da01-bc4f-4b6d-a48c-08dd2eb1c1af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?YWcrYzYwZGZZV2M1MXBIYTgzdDMrT3grRGNHRG5lTjJWdDFlc0taZjlnUUxn?=
 =?utf-8?B?RjFMbEFycDVzRFdqaW5wWjV0NDNvWDdqajZ3T2VpVlQ0OHhNYm8rOU9qUUJq?=
 =?utf-8?B?Mkl6MGpMem1FUVh3eWlMQUR4STlvamNjNzhlWXM1bWpDQTlnbEkvSHNXRHFW?=
 =?utf-8?B?NllYVTBSY3BCS3o1eVFGWXMyTXN4c3VpbFhORVRGSytzYzQ4MmxmYWxmMVdk?=
 =?utf-8?B?YkhxbEtod3JVRGY4Q25LMlhOZGtYTFVaaHZTaWpGSnh6R0NRcDdBeUFpZGZm?=
 =?utf-8?B?V1RzZ3M5U3NDczloc1VCYVpCb2xHWGNyR1poSDBKMDJkbHJyQ3RkMXVlN1hs?=
 =?utf-8?B?b285dS9Ld09KYTQ5K3FyRzhOTURRU1VRdk9ZeFBRNVhyOUZxWXVmeHJnYmto?=
 =?utf-8?B?UEVmblpBWlovN2dOU0J5SksxcEJFdzliR0ZwenpUSjNyNWdnUnZoK201SlF5?=
 =?utf-8?B?ckgyeWlLSGJKOXVpb0lZZkRCRk90MG8wN0F2ZTdUU3F4SEYzNk5PM3lJMWtD?=
 =?utf-8?B?dVJIYUxJSjZ0NVFBQmtDY2ZuZWtYcE5sbDZUMVVLVTd2SnJlSkRiV1JZZFJS?=
 =?utf-8?B?SkRDZU5ORUVWK1prM25CeENxY3AwY0o1RUFMOExMZ0kyUTI2bmp0VkZUbnNF?=
 =?utf-8?B?bnB1bXZlenFicmFLRE1GaU5pcXRQNWYzV1NSTTlyUkwzUWFxMGxqNjR1M0FF?=
 =?utf-8?B?cEg3bDY1YllIbUE4eG44UWJuY0p2TEN5c0lIK0Fidkc1UkJVSTNaVDNjcHUw?=
 =?utf-8?B?SVBQb3d4UW96SlpSN012SUxYMHdhWnJzMS9nR285d1ozVVllczhuN2xRVzBI?=
 =?utf-8?B?K3gvOWtNN0toVUJiZjF4T0N1bE8vektIb1VtdzA1alpQRnNWWEdZMzBaRWlT?=
 =?utf-8?B?V3piZEx3RFY0ME4zZlJKekx1Z0ptK2NUK2UxQWp6bjJHS2dFUVc4cnlXTitl?=
 =?utf-8?B?ZFZZSDlWSU9ISXJtT2dabDNSS3NVRkVuK1ZESU1CNzRlcy91azNpTGNmM2l6?=
 =?utf-8?B?Q3ltV1JCdDM5WDN3cFhsSzYwRzJZUGI5MEUweERKVlZxYmlzdXBPVW82dFdv?=
 =?utf-8?B?S1BzNkRQN3JDSEZDY0NreVhGNFJBMmtLN1dlK0xzSGFJYUVNR04yNkQ4Kytk?=
 =?utf-8?B?elEyT1VnNzY1bHlOL2hjNEVzS1kzYVMrTnZmTkhRakdkbnFLV0RRdHVkM2V2?=
 =?utf-8?B?dTg3OS83cDJrUnY5OE9MTXFHY25IdVpOSFU2K3Q5UWM3VnV0cGZTUk9qNXE5?=
 =?utf-8?B?TXhHU0lqZkxaT2lZVGE3dDJFUEdQRzA4dWN1TS8wTGgwQ2dJdEN3KzlaV3Bs?=
 =?utf-8?B?OThnNGsvcEpXWnJRQlZzempzYWpSbTZTQ2JJY2xFaVo2T2RlVmdPdUM5cmlS?=
 =?utf-8?B?K0VTR29RNW5TUHVwMXY0VmNFS1VPanpGWlVscmxDaE1LVnBIcWg5amNxZzVI?=
 =?utf-8?B?UzZyK1RCT1JkN2t4L29teVlrMFA3N05PNHJBQnY0ZXFEODQwaUdPMmU5eC94?=
 =?utf-8?B?UElJanhkRXkyQStsSWVyMzNqRHBreXVSMHVrT01pVzlydmU5UGRrOVZEOHBN?=
 =?utf-8?B?S0huYm1EZUdtdng5N1g5a3p2MHc0VzVvNER1ZGpBWmJFSGxIUzJoVFJwQmpk?=
 =?utf-8?B?WUMzK2dtRlZ6bGs0a1YwVXY4ZXZWZTlQMWJ4OGxITTU4bFBBMndEa2wyZGxZ?=
 =?utf-8?B?SE5nanp0R0JSMFF1TitKcU1LcmczSXYxNlRmam5ad1EvOGFGYVNnQ2NUU3ZL?=
 =?utf-8?B?MnZaTUxsMHZaNG9oa3I4L1UvOFVTNy9PLzBRVjJiMHlFTHVJQ2xidDdwZTdS?=
 =?utf-8?B?WGtXK0l5ODVqSFkwdEJKd3hyWWQzNVJSVVZ5YzhWUlZ6ZGl0eEsxci9BUUdC?=
 =?utf-8?B?ZHpFaTFOTjRhd2todmNyMmI3NVJEb1hFV0lIMHM2L0kzRGUzMk4vQXhRR1NB?=
 =?utf-8?B?VHhmVmRPcUx6cnVmc29VcGdCeGRIRTlGRzRtYmJXY21wSWMrN0cvTkxkc1BT?=
 =?utf-8?Q?Wczb7bOrDBtQt3xG/TFbN4r0nW8jHM=3D?=
X-Forefront-Antispam-Report:
 CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 CZiltpXed6QmX+ffHagWdXgalE1mwsX0J/N+KARWwK0uwEOTirV8vmKoChp0QX74g0idzXt16Su6pVotHZZpDYckTAdHuln04WmXxHf7TFEoVdgTqO49+z7LLo7qdDKyF3yC5oZK4H5iqtNtI4Srnxlo1s0Iv+N+oXmfS5bX6dF7BKz3fjcYZXHTZahmxW2gzDnNXFA6pGu4RQ/AgWSNgCvLUuhGp/KTpDl3hfrSau3z8rzrK3mO2fUs5f/pGLWUMe7IlmsZTw3UCttzIDNu1Pk3WuGG+QToGdDoyOslWhesmQ/VPjetC3k13hJsHzr/HGATG1SCJZ15MlNoajISUpbyft+61HMn6YK/C+cOr7hXCkQH4hcmWAIIZF2GmxXT9RF5YG7nK9E2OrVX7Vikp7HwI3srr2d9g8/I47/vF8D5UdUMS534UoyLuPzqJXIy4jJZWM6G7qFasospa9xx3Cja/Zgpbosf30WkAqmGg9V0w2TIeqRExWEHIp2tUO4yEgqipl7P3Z3WpQ9s0l+kDd2GyQqHVbZLOyiET5voLgf9J3ZtP+qBhsEjhbZMb4gRffdV5KkgnWK6XNrOA5cfG+KDOVe8Qt4KMg6nXC+32pOGGsux8737PD9FjL+xJKCfZiqj6jQ0hqp6Q0mGVu1BKA==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 00:25:14.9143
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4993da01-bc4f-4b6d-a48c-08dd2eb1c1af
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
 SJ5PEPF000001E8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR19MB4745
X-OriginatorOrg: ddn.com
X-BESS-ID: 1736215183-105820-13356-90362-1
X-BESS-VER: 2019.1_20241219.1759
X-BESS-Apparent-Source-IP: 104.47.58.177
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVibmxhZAVgZQ0CDJIs0oOS05Kc
	0kydAszTzRyCgx0dAiLTHZzNgkydhYqTYWAHzkAYFBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261637 [from 
	cloudscan8-241.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 Documentation/filesystems/fuse-io-uring.rst | 101 ++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/Documentation/filesystems/fuse-io-uring.rst b/Documentation/filesystems/fuse-io-uring.rst
new file mode 100644
index 0000000000000000000000000000000000000000..6299b65072a8468f08cc4f6978c386546bb9559a
--- /dev/null
+++ b/Documentation/filesystems/fuse-io-uring.rst
@@ -0,0 +1,101 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=======================================
+FUSE-over-io-uring design documentation
+=======================================
+
+This documentation covers basic details how the fuse
+kernel/userspace communication through io-uring is configured
+and works. For generic details about FUSE see fuse.rst.
+
+This document also covers the current interface, which is
+still in development and might change.
+
+Limitations
+===========
+As of now not all requests types are supported through io-uring, userspace
+is required to also handle requests through /dev/fuse after io-uring setup
+is complete.  Specifically notifications (initiated from the daemon side)
+ and interrupts.
+
+Fuse io-uring configuration
+===========================
+
+Fuse kernel requests are queued through the classical /dev/fuse
+read/write interface - until io-uring setup is complete.
+
+In order to set up fuse-over-io-uring fuse-server (user-space)
+needs to submit SQEs (opcode = IORING_OP_URING_CMD) to the /dev/fuse
+connection file descriptor. Initial submit is with the sub command
+FUSE_URING_REQ_REGISTER, which will just register entries to be
+available in the kernel.
+
+Once at least one entry per queue is submitted, kernel starts
+to enqueue to ring queues.
+Note, every CPU core has its own fuse-io-uring queue.
+Userspace handles the CQE/fuse-request and submits the result as
+subcommand FUSE_URING_REQ_COMMIT_AND_FETCH - kernel completes
+the requests and also marks the entry available again. If there are
+pending requests waiting the request will be immediately submitted
+to the daemon again.
+
+Initial SQE
+-----------
+
+ |                                    |  FUSE filesystem daemon
+ |                                    |
+ |                                    |  >io_uring_submit()
+ |                                    |   IORING_OP_URING_CMD /
+ |                                    |   FUSE_URING_REQ_FETCH
+ |                                    |  [wait cqe]
+ |                                    |   >io_uring_wait_cqe() or
+ |                                    |   >io_uring_submit_and_wait()
+ |                                    |
+ |  >fuse_uring_cmd()                 |
+ |   >fuse_uring_fetch()              |
+ |    >fuse_uring_ent_release()       |
+
+
+Sending requests with CQEs
+--------------------------
+
+ |                                         |  FUSE filesystem daemon
+ |                                         |  [waiting for CQEs]
+ |  "rm /mnt/fuse/file"                    |
+ |                                         |
+ |  >sys_unlink()                          |
+ |    >fuse_unlink()                       |
+ |      [allocate request]                 |
+ |      >__fuse_request_send()             |
+ |        ...                              |
+ |       >fuse_uring_queue_fuse_req        |
+ |        [queue request on fg or          |
+ |          bg queue]                      |
+ |         >fuse_uring_assign_ring_entry() |
+ |         >fuse_uring_send_to_ring()      |
+ |          >fuse_uring_copy_to_ring()     |
+ |          >io_uring_cmd_done()           |
+ |          >request_wait_answer()         |
+ |           [sleep on req->waitq]         |
+ |                                         |  [receives and handles CQE]
+ |                                         |  [submit result and fetch next]
+ |                                         |  >io_uring_submit()
+ |                                         |   IORING_OP_URING_CMD/
+ |                                         |   FUSE_URING_REQ_COMMIT_AND_FETCH
+ |  >fuse_uring_cmd()                      |
+ |   >fuse_uring_commit_and_release()      |
+ |    >fuse_uring_copy_from_ring()         |
+ |     [ copy the result to the fuse req]  |
+ |     >fuse_uring_req_end_and_get_next()  |
+ |      >fuse_request_end()                |
+ |       [wake up req->waitq]              |
+ |      >fuse_uring_ent_release_and_fetch()|
+ |       [wait or handle next req]         |
+ |                                         |
+ |                                         |
+ |       [req->waitq woken up]             |
+ |    <fuse_unlink()                       |
+ |  <sys_unlink()                          |
+
+
+

-- 
2.43.0


