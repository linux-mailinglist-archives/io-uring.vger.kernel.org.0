Return-Path: <io-uring+bounces-4950-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 11F979D5659
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 00:44:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8DB551F23EA5
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 23:44:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F11861DED7C;
	Thu, 21 Nov 2024 23:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="z7mQHW6o"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AF41DE887;
	Thu, 21 Nov 2024 23:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732232654; cv=fail; b=QMUwJQynC3DIetUubBpKgA+m81vSFFY1ZV6gO37un4GXw5Jg3GF2m/UPZVXLeKDChpN0m2PBu2nWjTi9iCq1t/LWJrhejelwzK9BjgpXHu7wvejeC8VmBQ5QjOyq9SfaKM0jb4uFYSXWLKB2NGR7dr7knQ2QQx1+OMvSDkYS6mE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732232654; c=relaxed/simple;
	bh=GCId+RDUEffzIBUHtzowycYurRMNb0KURktFRP35iLc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BLZF2iJ2YLHbrI+Qh25DbT6ZdeIgn39PyYU5QpA7i34q3tAtc0Wd/dAuiF0AIoMZYtNGH9+CYw39NeRUEpouXw28pDUTT+wZNefdltlY3PbiIQ1J7Lx7i/uFm2raNfaZwAejSbQTFKM9tXp6dKqJvNWMiakD0wrAy4lABNrv/tg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=z7mQHW6o; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2043.outbound.protection.outlook.com [104.47.55.43]) by mx-outbound44-164.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 21 Nov 2024 23:44:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tt01KSY2YGpXm4daxCBYmpIa4rPsy6b1REGr4pNTaKqpdo5WqHaQ8gYyf5xbtgcJS9qPNyE56ONzIt5ycZjEqmzbAmcC8/FIWq68Y1bynVCQ5wFwR/3cU4fxLQurRVb9YWoRXnc+4jrqFB8pUgVrEaSRFXSwRix/4/QT6H8XI/2qVCC7OS9kKEtFJxWbmqh72aQQSnLq5HVrzQ90e9JlR2ekSGQV08SHfcgTpd8usitTJ1+uFMVb0Qi60NPYlpmAvqVv4bxnJfnlWhCZAAKUIsny2uOfUT2yn7780XlHmh64GD+iKg4YMNbsQkN2Lex+dc61m8ONvAvwx1cUa8Cz9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WZNXfBou4nGFjf0CyPDiEneLINkxSvP6uiBRQ/+zuGs=;
 b=ZQdoUC3hKJaUl6Zkh42RmmyZv2KPNxJE7hl+OLJg7VP4cK4EC40byWJ3bcODSRGKAhlyOkLr9+k76rhnCuq1QtaBtkcgQ0gjJMUiBZM7sHMnGWC/BkHkv91WQdhO4VVE2OV75rx/2JdkEk4ShngDiJ7Z9BoOm4AsM7pcp0mjBKJysISVM1lQUif7nPyTOid3+1yhDGIevMrYEPZv6j6ElwfNtZOQdC4ANZB2y+LXicid2ay2+JvuVzWx1X5eFMSPpjma0Y9gDP3KnPb+D+TGUJn3ekDynIsUeLkmwuKwwoBeIIK0+Jvcs5Xykxv6d9VMVzmc3vPqORP7k3RZ1JMWMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZNXfBou4nGFjf0CyPDiEneLINkxSvP6uiBRQ/+zuGs=;
 b=z7mQHW6oAAtzW+q7F6LmhPCQfaYkxgUKWU63bpppnYNdEINLxtwlq18cohQokSOZgT0+13514L1oUU/dQCve0j+ERBLGgxHqv9acRP3ibpUhBYjIQ9CYTEKn5qcwDjZKQDDv0PXNjo53aNFE3pRfHnRi8ZfHgPSyy92eFxlHvc8=
Received: from BN9PR03CA0881.namprd03.prod.outlook.com (2603:10b6:408:13c::16)
 by SA3PR19MB8217.namprd19.prod.outlook.com (2603:10b6:806:39d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.20; Thu, 21 Nov
 2024 23:44:02 +0000
Received: from BL02EPF0002992E.namprd02.prod.outlook.com
 (2603:10b6:408:13c:cafe::18) by BN9PR03CA0881.outlook.office365.com
 (2603:10b6:408:13c::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.24 via Frontend
 Transport; Thu, 21 Nov 2024 23:44:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BL02EPF0002992E.mail.protection.outlook.com (10.167.249.59) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8182.16
 via Frontend Transport; Thu, 21 Nov 2024 23:44:01 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id A0E342D;
	Thu, 21 Nov 2024 23:44:00 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Fri, 22 Nov 2024 00:43:27 +0100
Subject: [PATCH RFC v6 11/16] fuse: {uring} Allow to queue fg requests
 through io-uring
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241122-fuse-uring-for-6-10-rfc4-v6-11-28e6cdd0e914@ddn.com>
References: <20241122-fuse-uring-for-6-10-rfc4-v6-0-28e6cdd0e914@ddn.com>
In-Reply-To: <20241122-fuse-uring-for-6-10-rfc4-v6-0-28e6cdd0e914@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732232629; l=8742;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=GCId+RDUEffzIBUHtzowycYurRMNb0KURktFRP35iLc=;
 b=mXsJLneynssq+37jB7noyfuOQLlvdKa0jWBkI0vCzF6X4+o1FUil6qJal4+obTaV5qcr2XBkj
 xKouZZ08UrFBSEBDJxrc33IqPbhBZ/NkFdAcxS2ow53VhJ2Fwh8+lzb
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992E:EE_|SA3PR19MB8217:EE_
X-MS-Office365-Filtering-Correlation-Id: 0730f57b-87a8-4d3a-c2e4-08dd0a8660ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?citZeWFweGFieWgxMWpHOVd0YnUrdmxEMmhST05NY3A3L1lsV05nbXpTb1px?=
 =?utf-8?B?dk1ueis5eWFQZDMwc1hkWkRXQUU3ZFF5dWp5OWVOYUMxVTBuMWtLSExnZ3ll?=
 =?utf-8?B?MkM0WkFXT3ZsaFRNVTRnbU9tQythcTQvU3V1NlNTQVJ1RjFXZHlxTC9CMGJa?=
 =?utf-8?B?NzFCUVg5c0tLbktaZkxockNnb1lXQmxrT1BCa0pUNCtRSXM3cXNGazl0MFp0?=
 =?utf-8?B?WVJmSjIzclcwakp0K3JwcXNVdXBIdWdHNmViMDF5VzBoKzgreHRZSThUenp3?=
 =?utf-8?B?ZkwrVGY3Um5jdFc2SENuaUZYUXpCd0c4QWZkL1ViUE9pai9rRmUva1lWMDVy?=
 =?utf-8?B?Y1ZmYU9DUEtraU1ndXFaMzduTFlFc3VZU2tSbWNSb3B3eXpxbTNKVDV3T2tK?=
 =?utf-8?B?Y1U3NU83K0s0VXRoZ1pSUXpsTXlSS0wxeUZIK3duY3dTVnNFemd6Y1JSMDM1?=
 =?utf-8?B?UTN4RGZ3aERGN0pMZjk4UGp1WWc5MGgvUjhYbmVsb3YrSm9JUDZYVjY3M2lB?=
 =?utf-8?B?RVB3bXZWQzZZK2VYNUowcHVSUGJDVkxiS2lPQlk0OUludHhMd0JwS0VPSWRw?=
 =?utf-8?B?cGZoNjkrVFNxUGFtd04rc1p6RStzbmdiMjFGR3NYWDlpeExrT0ZFelFJNk1N?=
 =?utf-8?B?bFI5NTZDbE95cXR1WW5Vdkt2QVVxUXcwZVBVSndLUzhvcFlRZVFjNkNhdVMz?=
 =?utf-8?B?aERoNFJ3WUxWYk80dDN1eG4vWVAwRGFNWWdwZ3QxcWhhZWx4ZzZXRUltby9y?=
 =?utf-8?B?QUhRTHl3cGE3OUxvb2NibCtKTmYrUDY2aElxN1paR2VWRDhiVXNNcWNFSlZC?=
 =?utf-8?B?OXI1MmRIWWxvQXVYM0dVZGtiTk9qNHpYVXVyTW40RmdrNG1ZK3AzUDliSUdq?=
 =?utf-8?B?NEFscTJZcmNrcnNvTU9PQ2l2RUJEVkYxeHYvNmo3T1VzRVhpeFRnZ1RTNUZh?=
 =?utf-8?B?L2RsVW9QRzgrWkpMWEUzY3R0OFFlTEkvbmhjUGNuQytDSzVMQ0R6SHNkcXQ4?=
 =?utf-8?B?RFlqRXpjb3BQYlVBQzdKR0c3NXB3Z3JPYldUN0ZzOS9PeDhwTzA4UXEvL3pl?=
 =?utf-8?B?TVJaNTRGUVVpQk51bGdGbjI0OXJNaUE0ajlvSGh1bHRQUkd5SzlkNTBvMkpS?=
 =?utf-8?B?eU96dnltRjBmM3dqbjIxcldIUEhwMEJzcHQwU3MzUWp1c0l2RUNIOEtwK3JK?=
 =?utf-8?B?eGYvWmptTG8yRzl3NlhCd0d0M3h0M1ZvSzdmQ3VyYXdFL1VLZkh0R3hZVXAy?=
 =?utf-8?B?dFVjQ0VZU2pMbjdXaHJkbDRCb2xzYVlmRXJSQ3J6cGY3dzd2Yy9aUURaMFF1?=
 =?utf-8?B?YTNiMkZLMXIwakUrMTVFU3Y1QUF1dGlld0V2ak80TzV2eTl1WjkveFlKSEFX?=
 =?utf-8?B?SjIzcldzNDA5ZGcrS2xyMktMMEJTcDloTnFaSEppQUEwWGJpM29CYmxKM01O?=
 =?utf-8?B?S2RjK0FjYXhCRmFZcTAvUnlzMnNUNjBGbnY4c2JTcFViVmlvTnlHc3V1Q0J1?=
 =?utf-8?B?b0ZuOTAzejZLUFNURXZjeVVhT2lCb1RmYUFsL0drM3V6WXk3MjQ5N0xOamNm?=
 =?utf-8?B?aXgraTI1L1d1SDJRcnB1L1FXZXE5c0k1V2VQdHFMMkxRZUhEWFVTUFpHbmZ4?=
 =?utf-8?B?YWwyMmxPZ3JGdXBBN2FBT0N4RWVJMnk4MW1sZE1zY1p1TXlwTkE1WElUN1Vp?=
 =?utf-8?B?cVoyTXBKNWF3NWFCYWh4ajVUcDc4azZpckFqcXhDQlY2VDUvelJacWtCanRK?=
 =?utf-8?B?TXZ6K2IzcmJIVmE1SCtRamhtUUZocWlCR2VWdnF3TWxOUkxmS0tHbUpBTWdG?=
 =?utf-8?B?TEF4OGFHb3VnQjk1bFFjeGZxK2FkekFUTHVUbWd5MDVEV1pRckJXUDk0bXZn?=
 =?utf-8?B?eEZURmpmQ1VpdU15bVdQZjdyYnQ3UW0zeGZ1R3J2WGxtdlE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Q+ZlUWzrUcZLGLSyFye4rgWdQpNme7dOqD/ooMLtS0fBldnAFn6/+CDGM0WhW8RvNVGjmwSOd952Kvi7EiO8dW1xnlQOgvdU8T98aCrXoOFohsVFK38PwuwFIYsQW6QCXNUdjnIBioGurZ4txCDIKH5lO0XU5q7NeOhbpNg2zOriBISTyr11CYjAo8SybkjWtIxfCC4TKBV19kBX1QMC+Qm8CnSSp2X4Qv3Um+K7gaXcIj11IkU/TqLQHSuiiQ61OXKJr4jGt8vswtSw4/wFlHa3Ja/64oXvHJ/e82soMVZYgyZLVk/RWQiBdIE9M5DSyLQDMEx3HyK39hDpOG3iofs1kB3bPHc0QvEeEcyPKfX+4pXsS9dFkubOwHYdYMj4/peTyJmT/xR1iKw/31PWefaSbgwXTgGpi4C6hto6Tecp6AtLjqPMgb6scPhxkXJ3XXMGijCWykhyH8MJ7kUByeT40sD0rs23KwXW8cijhUx0rqRhw+6XpnzJkyNZptn9kWK1ty9YQ8p0oKF23p0yQQ4sDq33a+8EWQ1iclrie/l3/r3VrHbyKKamLuOksbd0ExSnASjKh/6jQM9bD9ZsBk5qs+0MZZQdaOgqIKl7TmTbkEaa0k9vUaGI3BMkGXrIvs1X1zPELHEyPleqdgttZQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 23:44:01.9351
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0730f57b-87a8-4d3a-c2e4-08dd0a8660ba
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR19MB8217
X-BESS-ID: 1732232645-111428-21133-25879-1
X-BESS-VER: 2019.1_20241121.1615
X-BESS-Apparent-Source-IP: 104.47.55.43
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVhYmJoZAVgZQ0NwwySLVLNEgNS
	nFwsLUINE80cDEMiXNyMDEwsjA0sBYqTYWAK0oQN9BAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260587 [from 
	cloudscan8-154.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This prepares queueing and sending foreground requests through
io-uring.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c         |   5 +-
 fs/fuse/dev_uring.c   | 159 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h |  11 ++++
 fs/fuse/fuse_dev_i.h  |   5 ++
 4 files changed, 178 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 17a76d0c964f1ecd27dd447504c94646f4ba6b6e..ff7fd5c1096e8bb1f3479c2ac353c9a14fbf7ecd 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -237,7 +237,8 @@ __releases(fiq->lock)
 	spin_unlock(&fiq->lock);
 }
 
-static void fuse_dev_queue_forget(struct fuse_iqueue *fiq, struct fuse_forget_link *forget)
+void fuse_dev_queue_forget(struct fuse_iqueue *fiq,
+			   struct fuse_forget_link *forget)
 {
 	spin_lock(&fiq->lock);
 	if (fiq->connected) {
@@ -250,7 +251,7 @@ static void fuse_dev_queue_forget(struct fuse_iqueue *fiq, struct fuse_forget_li
 	}
 }
 
-static void fuse_dev_queue_interrupt(struct fuse_iqueue *fiq, struct fuse_req *req)
+void fuse_dev_queue_interrupt(struct fuse_iqueue *fiq, struct fuse_req *req)
 {
 	spin_lock(&fiq->lock);
 	if (list_empty(&req->intr_entry)) {
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 19d5d3eafced090a84651b21a9f65cd8b3414435..d8653b4fd990000c8de073089416944877b4a3a8 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -21,6 +21,12 @@ MODULE_PARM_DESC(enable_uring,
 
 #define FUSE_URING_IOV_SEGS 2 /* header and payload */
 
+struct fuse_uring_cmd_pdu {
+	struct fuse_ring_ent *ring_ent;
+};
+
+const struct fuse_iqueue_ops fuse_io_uring_ops;
+
 /*
  * Finalize a fuse request, then fetch and send the next entry, if available
  */
@@ -820,6 +826,31 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 	return 0;
 }
 
+static bool is_ring_ready(struct fuse_ring *ring, int current_qid)
+{
+	int qid;
+	struct fuse_ring_queue *queue;
+	bool ready = true;
+
+	for (qid = 0; qid < ring->nr_queues && ready; qid++) {
+		if (current_qid == qid)
+			continue;
+
+		queue = ring->queues[qid];
+		if (!queue) {
+			ready = false;
+			break;
+		}
+
+		spin_lock(&queue->lock);
+		if (list_empty(&queue->ent_avail_queue))
+			ready = false;
+		spin_unlock(&queue->lock);
+	}
+
+	return ready;
+}
+
 /*
  * fuse_uring_req_fetch command handling
  */
@@ -828,11 +859,23 @@ static void _fuse_uring_fetch(struct fuse_ring_ent *ring_ent,
 			      unsigned int issue_flags)
 {
 	struct fuse_ring_queue *queue = ring_ent->queue;
+	struct fuse_ring *ring = queue->ring;
+	struct fuse_conn *fc = ring->fc;
+	struct fuse_iqueue *fiq = &fc->iq;
 
 	spin_lock(&queue->lock);
 	fuse_uring_ent_avail(ring_ent, queue);
 	ring_ent->cmd = cmd;
 	spin_unlock(&queue->lock);
+
+	if (!ring->ready) {
+		bool ready = is_ring_ready(ring, queue->qid);
+
+		if (ready) {
+			WRITE_ONCE(ring->ready, true);
+			fiq->ops = &fuse_io_uring_ops;
+		}
+	}
 }
 
 /*
@@ -1013,3 +1056,119 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 
 	return -EIOCBQUEUED;
 }
+
+/*
+ * This prepares and sends the ring request in fuse-uring task context.
+ * User buffers are not mapped yet - the application does not have permission
+ * to write to it - this has to be executed in ring task context.
+ */
+static void
+fuse_uring_send_req_in_task(struct io_uring_cmd *cmd,
+			    unsigned int issue_flags)
+{
+	struct fuse_uring_cmd_pdu *pdu = (struct fuse_uring_cmd_pdu *)cmd->pdu;
+	struct fuse_ring_ent *ring_ent = pdu->ring_ent;
+	struct fuse_ring_queue *queue = ring_ent->queue;
+	int err;
+
+	BUILD_BUG_ON(sizeof(pdu) > sizeof(cmd->pdu));
+
+	err = fuse_uring_prepare_send(ring_ent);
+	if (err)
+		goto err;
+
+	io_uring_cmd_done(cmd, 0, 0, issue_flags);
+
+	spin_lock(&queue->lock);
+	ring_ent->state = FRRS_USERSPACE;
+	list_move(&ring_ent->list, &queue->ent_in_userspace);
+	spin_unlock(&queue->lock);
+	return;
+err:
+	fuse_uring_next_fuse_req(ring_ent, queue);
+}
+
+static struct fuse_ring_queue *fuse_uring_task_to_queue(struct fuse_ring *ring)
+{
+	unsigned int qid;
+	struct fuse_ring_queue *queue;
+
+	qid = task_cpu(current);
+
+	if (WARN_ONCE(qid >= ring->nr_queues,
+		      "Core number (%u) exceeds nr ueues (%zu)\n", qid,
+		      ring->nr_queues))
+		qid = 0;
+
+	queue = ring->queues[qid];
+	if (WARN_ONCE(!queue, "Missing queue for qid %d\n", qid))
+		return NULL;
+
+	return queue;
+}
+
+/* queue a fuse request and send it if a ring entry is available */
+void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req)
+{
+	struct fuse_conn *fc = req->fm->fc;
+	struct fuse_ring *ring = fc->ring;
+	struct fuse_ring_queue *queue;
+	struct fuse_ring_ent *ring_ent = NULL;
+	int err;
+
+	err = -EINVAL;
+	queue = fuse_uring_task_to_queue(ring);
+	if (!queue)
+		goto err;
+
+	if (req->in.h.opcode != FUSE_NOTIFY_REPLY)
+		req->in.h.unique = fuse_get_unique(fiq);
+	spin_lock(&queue->lock);
+	err = -ENOTCONN;
+	if (unlikely(queue->stopped))
+		goto err_unlock;
+
+	if (!list_empty(&queue->ent_avail_queue)) {
+		ring_ent = list_first_entry(&queue->ent_avail_queue,
+					    struct fuse_ring_ent, list);
+
+		fuse_uring_add_req_to_ring_ent(ring_ent, req);
+	} else {
+		list_add_tail(&req->list, &queue->fuse_req_queue);
+	}
+	spin_unlock(&queue->lock);
+
+	if (ring_ent) {
+		struct io_uring_cmd *cmd = ring_ent->cmd;
+		struct fuse_uring_cmd_pdu *pdu =
+			(struct fuse_uring_cmd_pdu *)cmd->pdu;
+
+		err = -EIO;
+		if (WARN_ON_ONCE(ring_ent->state != FRRS_FUSE_REQ))
+			goto err;
+
+		pdu->ring_ent = ring_ent;
+		io_uring_cmd_complete_in_task(cmd, fuse_uring_send_req_in_task);
+	}
+
+	return;
+
+err_unlock:
+	spin_unlock(&queue->lock);
+err:
+	req->out.h.error = err;
+	clear_bit(FR_PENDING, &req->flags);
+	fuse_request_end(req);
+}
+
+const struct fuse_iqueue_ops fuse_io_uring_ops = {
+	/* should be send over io-uring as enhancement */
+	.send_forget = fuse_dev_queue_forget,
+
+	/*
+	 * could be send over io-uring, but interrupts should be rare,
+	 * no need to make the code complex
+	 */
+	.send_interrupt = fuse_dev_queue_interrupt,
+	.send_req = fuse_uring_queue_fuse_req,
+};
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index e567a20731d76f47b7ebe3f31da4a9348f6d2bc8..57aa3ed04447eb832e5a0463f06969a04154b181 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -119,12 +119,15 @@ struct fuse_ring {
 	unsigned long teardown_time;
 
 	atomic_t queue_refs;
+
+	bool ready;
 };
 
 void fuse_uring_destruct(struct fuse_conn *fc);
 void fuse_uring_stop_queues(struct fuse_ring *ring);
 void fuse_uring_abort_end_requests(struct fuse_ring *ring);
 int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
+void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req);
 
 static inline void fuse_uring_abort(struct fuse_conn *fc)
 {
@@ -133,6 +136,8 @@ static inline void fuse_uring_abort(struct fuse_conn *fc)
 	if (ring == NULL)
 		return;
 
+	WRITE_ONCE(ring->ready, false);
+
 	if (atomic_read(&ring->queue_refs) > 0) {
 		fuse_uring_abort_end_requests(ring);
 		fuse_uring_stop_queues(ring);
@@ -148,6 +153,11 @@ static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
 			   atomic_read(&ring->queue_refs) == 0);
 }
 
+static inline bool fuse_uring_ready(struct fuse_conn *fc)
+{
+	return fc->ring && fc->ring->ready;
+}
+
 #else /* CONFIG_FUSE_IO_URING */
 
 struct fuse_ring;
@@ -167,6 +177,7 @@ static inline void fuse_uring_abort(struct fuse_conn *fc)
 static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
 {
 }
+
 #endif /* CONFIG_FUSE_IO_URING */
 
 #endif /* _FS_FUSE_DEV_URING_I_H */
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index a8d578b99a14239c05b4a496a4b3b1396eb768dd..545aeae93400c6b3ba49c8fc17993a9692665416 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -17,6 +17,8 @@ struct fuse_arg;
 struct fuse_args;
 struct fuse_pqueue;
 struct fuse_req;
+struct fuse_iqueue *fiq;
+struct fuse_forget_link *forget;
 
 struct fuse_copy_state {
 	int write;
@@ -58,6 +60,9 @@ int fuse_copy_args(struct fuse_copy_state *cs, unsigned int numargs,
 		   int zeroing);
 int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
 		       unsigned int nbytes);
+void fuse_dev_queue_forget(struct fuse_iqueue *fiq,
+			   struct fuse_forget_link *forget);
+void fuse_dev_queue_interrupt(struct fuse_iqueue *fiq, struct fuse_req *req);
 
 #endif
 

-- 
2.43.0


