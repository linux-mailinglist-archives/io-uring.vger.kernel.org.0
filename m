Return-Path: <io-uring+bounces-4951-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D89D9D5696
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 01:16:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AA8B5B2145B
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 00:16:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 857C515A8;
	Fri, 22 Nov 2024 00:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="up+IvFbB"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9015810F1
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 00:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732234585; cv=fail; b=LGYR/MayivJyWptuQXFBHxkNr7rKruL3Pt0DmurG1vPrrLhUxLYDmcxE019jNy0gTVG04oTjQ5Cl+UkHt1lJ8JdD88YkWle1tYOuT//6xRbFKJtUVINN2qSCESo04tyMt+8kUXlLWJ6rGUil1N33KBBm4DMWFBtV4+Ua5zExM14=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732234585; c=relaxed/simple;
	bh=tie4NxDKix394rRPWJuOycw76UDfRN09D0r3BvuIHOQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=loPctPPOsOnqrNgXPn61NrWfC7vN0DxO7zKcg/fgt5vMtoOgrO2hG3dtMQxYHS8FQ660G7nlUcSJnGoVp5m1ZSf2XgzqLXtwTJzyWhXhvnBaBWYdDCY3VxXuKmm1fsfbEfX8kP8MHPAUK9wH/CXGxtR0sSscJ7sTQOHhM8xW/KI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=up+IvFbB; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172]) by mx-outbound47-71.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 22 Nov 2024 00:16:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wrXaI3RCIreWQtNyv9H8T1M5bUBR+O3gr7zckK8bVQGtoJ9httUiYN34UVUanJTEER3Lk12WbYFmGcPBYic4KOtzzc7sl9WG71I2XZcaiS3wZaoGLvn0kn9urQdZCgXwza7AZW+rOmPJG1MO1CgErvXwL7Z/oviF90gSoLSr36B18W3KYFUl8m14vellkUDgVTGS41bR6ZfBWtGCUmLGCZScZaC2L6cx2mOm61SICVDabNjEVsaQAvY9dICCF8NyIt//KPjHjTDdIuAd4h2ChrVxns7H3vZ/nIfWz44nT9kGELRbQByr3bnMuMP+9a+wXsGoj4iBfwHgXaR/otYJ5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d0AtFXclGgSjW8xzix/Sf7JMTbM7+vqZyQi1Ti3SUdg=;
 b=meE3fmIQSjIr8cfeW0+rdW2BcXiJ65OiCyHCiT7/c3oF2/guhlpVVuKsROX6ol9yuswG6u5Na0KC5lGEOY+imCc7gtf7V3pMPobc+ra76Ey43d5o17wOmVCso9sU6aHNeflngXnBhUf22QkC374tGI3IQBl6r9dWQiLlS5MNKc1yPG3frnfVl/jfSxp+uZbKCv8b1YXWyZrKpbqe+rRk7XQWHJpO7mlRAP9uxJ2GhGVygAY3ecrOSx4GHFHqYHWMYID2izYf7rGjjmkFArzGhKPOFseY8CHdhZELcToOrW54HdK4DFlbpmRkzN9kbSZCNMJ3NfCqqp2J2g0H4MIBtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d0AtFXclGgSjW8xzix/Sf7JMTbM7+vqZyQi1Ti3SUdg=;
 b=up+IvFbBpUW1rX6x+8v/fxr2VkXWhKDDHzfOgMJeeo1PA8Gn04rdDxuZm4zdOCw6ec8UZHJsZuePenp0OAN8J7GkmB6iPpg/P+s8E21+z+kI+V2wLvjWQk2SPXgK6Vp0F7mFOBrEtl9FyrB+FkFV+uI3Rms6cVaerJdhu296Xug=
Received: from BN8PR03CA0034.namprd03.prod.outlook.com (2603:10b6:408:94::47)
 by PH0PR19MB4822.namprd19.prod.outlook.com (2603:10b6:510:25::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.17; Thu, 21 Nov
 2024 23:44:04 +0000
Received: from BL02EPF0002992A.namprd02.prod.outlook.com
 (2603:10b6:408:94:cafe::5c) by BN8PR03CA0034.outlook.office365.com
 (2603:10b6:408:94::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.24 via Frontend
 Transport; Thu, 21 Nov 2024 23:44:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BL02EPF0002992A.mail.protection.outlook.com (10.167.249.55) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8182.16
 via Frontend Transport; Thu, 21 Nov 2024 23:44:04 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 8927032;
	Thu, 21 Nov 2024 23:44:03 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Fri, 22 Nov 2024 00:43:30 +0100
Subject: [PATCH RFC v6 14/16] fuse: {uring} Handle IO_URING_F_TASK_DEAD
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241122-fuse-uring-for-6-10-rfc4-v6-14-28e6cdd0e914@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732232629; l=1124;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=tie4NxDKix394rRPWJuOycw76UDfRN09D0r3BvuIHOQ=;
 b=OnypkaFUeK8VHtC5GUHuUBc3I1jB1gpNXXZ6FGc9Dgo5c4bt2UtHgJG1p199WZ+ic8nY2sDJH
 nUY+dujSkZuAm3LglFb1nz9ruIetL0VclnKnWB2FZ9+4kWXKLx0+aO+
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992A:EE_|PH0PR19MB4822:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d9275c8-5462-4c98-7cc7-08dd0a866248
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z3NlWVJIVTJwcmVYV1c0SCtZbTRYb1h6eEN0aXdZQlNxb0FoZXRyQnZhRFVj?=
 =?utf-8?B?N0pjQVdIOVIzcFF6NVA4K1Q2OGpaeXMxQUhaUDI1V25Jb09Hc2Q1Y1hKV2FR?=
 =?utf-8?B?MmR0RkgvVHdQdHBmZFV4dVF3aDFPRmRuVysvZGN2dENkdTB4RXhVU0lKMjlr?=
 =?utf-8?B?TGdwL1VBeTdQVGtkSWlUVmNaeHFXTlpLSnJMa3o5YU1ac3Jyck9BMTdBaG1u?=
 =?utf-8?B?bndPZTZ2R2xjVTVNbW9yMXE1Y3N0bDhXbUZ0cnJhcXY4eW00cStoZmMvVTg3?=
 =?utf-8?B?c2FYREpSRjB3Z2IyYWYvTFVBaUlQRlVHMGlVRyszck44ZTFodjh4MGFzVyta?=
 =?utf-8?B?WnIralBDd3hvcWJtLzRHQWZ4TkN3QXBwa2lMWkxlZFRjMzJLLzRWbnNMRnpx?=
 =?utf-8?B?Nk9RMEdIZXFJVHV3V2NRSGNBcnRMbVY2OTZ4eHZwREtMTHhYb1AyOGx5YVpj?=
 =?utf-8?B?SDJRODFrbzFLTzQzUXc5Q2hpLzB5WHlnSkwvV2xVQXVqbTloeUh1TElYMXpL?=
 =?utf-8?B?R1hKOGNDT0hxOGVqWC90bjl0QjUxeU5JajdwWG9EWXBrMDVOckRvR2ZiNlhE?=
 =?utf-8?B?VDlkNW1HT0EzcGg4Yk1lWjVNcE5WOGJXMWYzd3k0enJ4T1JJQk5oRzh2c09w?=
 =?utf-8?B?c0E5SDhISnZOVGF5U2hsUlI1d2xmSVRzYkc5ZFNPUGgvZlJ6cEF3L01lWDlM?=
 =?utf-8?B?VWFhSU5tTVIrS1hWRnl4RHRPaXk5N3BkblJ4L09ONHh6Z1o5UzNMVHZiekg3?=
 =?utf-8?B?U1N5VzV1ZkNjKzB1eTM4R1BsVGZ6WGpGUDlSY2VZc0txcXBydmc5eityTFJZ?=
 =?utf-8?B?eFN6ZTZQM1hlTmZodkJ0NVZFRUQxL3c0Vng1OHJ6MFgyQW04Z2UwUHNXSDRV?=
 =?utf-8?B?emFwUlN3VmpzY1RqdjFILy8wdXdZYUZURnJkQW04TjNvUUlzTGtwR1F0ajJS?=
 =?utf-8?B?MTB4UW41aHEvL3VleVA4Mlc4L0l6ZElzZE83bjBFUzA0Unk4VWlzclBZWXQ1?=
 =?utf-8?B?ajY0ZGlKVHZEODdCQytYQTdvanNGWnBIUDR3eXNBUVI5SmsyUmd3RENyZXhD?=
 =?utf-8?B?K2ZpeFJkR2YyeURaWmR1aXJNMWo0bU5ZQjdiNlB6UHRxQXpBeVdka3dmRUlE?=
 =?utf-8?B?RUlJUTdEY3NJUlJzNGpid0R5Y3R0bzhWK1liUEJicVMvc25CZlJGV0xLdDlJ?=
 =?utf-8?B?aDgzMldQcGFPbzlPWFRLaG5OWURjMzhXK1hEdGpraU91SmNHRCt3UmZRTjN3?=
 =?utf-8?B?Lzh6MjVjbzJocU0xTWRjTEp2MXdhcVpKMlJDK0Rjc2VnVFppdDJkMy9RQm1U?=
 =?utf-8?B?Y2tmM2RxTU43Yi8yNm1obHgvSEJTZCs5Zmlpb3BFd0FURlc5bXgrQ01FZGpy?=
 =?utf-8?B?a1BXWTZnbitrWjA2WTR1YUpLMkRKbGVhUk1INkYxVUxrWHR5UVZmTVp1UHl1?=
 =?utf-8?B?anNsYWR3eXV2ZUhJUE1SZzhvajNYdG5TOWhTTUFxdHFDdFo2bWErUUgxd2N3?=
 =?utf-8?B?ZWZWSWxUMVU4bjd1VnZvUVF1dTk1NmZrcWx0bFRXcVFTV0V5eUVVcm5pTWRx?=
 =?utf-8?B?amE2SFZJTkNmM0JsOHVNNis1Uy84cGRwMjY0U25uU0haQ3ZmMWt2TTNMaE5z?=
 =?utf-8?B?aFZtMTVrOEx4VnhwclBVK2crSUkrN2lyZU4zdzZxajRJNkhoaGlyMmRrOVpl?=
 =?utf-8?B?ZEFyUVpOb0R1ZFRmUWJvVFViV3ZGbEl3MXkrZ2NOc3JTRzNNWXdoWlpxWkxE?=
 =?utf-8?B?NXBvYjdxY0hyTmg5L2pUWVVlN3NnamJxRksxdnZrM3lQNi9xbDdWUnBUWW9B?=
 =?utf-8?B?QXNUNlNJVHIvNFRmUElxT28vdzJDUVVRUXgxeVJmRTFmazlFdDRvSHRTUkxF?=
 =?utf-8?B?SXpYZWJEaEhmR2Vta1QxQkdMTUhkYUxudm51dC9DczJ5VlE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ytEPAm7OHtYk/Gqrd1yPOpi4d+ZzKvJfzdUfYHxXsC4yl2bb9I4uI3QVF+PpGV8Cd2xHxS3ZD0bCbH/woWjl5okQW1v6EMC2q9KgHwM0Yu2QsF/N2ID8Kwajdk7D7OHydZ7AQVltiKPIBiPBL/NtiWKpdw2MKJWAw2gBrSLi5cRczdGC7SGFJjRH56wox7H0RmKZLke8IuXMYmezvBzu9vDSjH9ccrqwRftzNthIZOw/n5psYvGByyCCXNrudkJZOWz8Ut8ofMP912FcShFkcsPkpmxF78TEXqayniK6U3JfCsDMufw+BTLkGW9WnCFMFdvAgv/wajKLiKRYDNkSdMNF6WGJSckERDzBKBHTJ27o1qAsVbDvdUwyaUJF/x3a+N3ASLhqkfzHVj1xybstLZondYnb/B3NJYEnDGjh6adIjVeCoDycO82iEu41wxCaRZpxo1AdvaDGdi5XR23WBBueA/b4hBIOP9nT124Y7shoxa8p+l/N4GaGEOVcKx7IBdLr3h3J+TfbMmQ7RQckbYvZl0NLuhWMcf7syVACMtTr4SjET4+uW3CUQcxsPl0EnllgpbMI5xtbgnVIpH992EQI87jJw9WY0NdXKogS/b/RMdcq7rsFM3t2ANXfsLryThkLhMD0OinPOkqjj8RIFg==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 23:44:04.5885
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d9275c8-5462-4c98-7cc7-08dd0a866248
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR19MB4822
X-OriginatorOrg: ddn.com
X-BESS-ID: 1732234581-112103-13737-60706-1
X-BESS-VER: 2019.1_20241121.1615
X-BESS-Apparent-Source-IP: 104.47.58.172
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoYGFqZAVgZQ0CjFLNXYMNnUxM
	zIKDk52dg4JcnYwMw8zSzJzCLN0tJCqTYWAKE8JYBBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260588 [from 
	cloudscan-ea17-231.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

The ring task is terminating, it not safe to still access
its resources. Also no need for further actions.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev_uring.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 36ff1df1633880d66c23b13b425f70c6796c1c2c..d0f8f0932e1715babebbc715c1846a5052419eb9 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -1124,16 +1124,22 @@ fuse_uring_send_req_in_task(struct io_uring_cmd *cmd,
 
 	BUILD_BUG_ON(sizeof(pdu) > sizeof(cmd->pdu));
 
+	if (unlikely(issue_flags & IO_URING_F_TASK_DEAD)) {
+		err = -ECANCELED;
+		goto terminating;
+	}
+
 	err = fuse_uring_prepare_send(ring_ent);
 	if (err)
 		goto err;
 
-	io_uring_cmd_done(cmd, 0, 0, issue_flags);
-
+terminating:
 	spin_lock(&queue->lock);
 	ring_ent->state = FRRS_USERSPACE;
 	list_move(&ring_ent->list, &queue->ent_in_userspace);
 	spin_unlock(&queue->lock);
+	io_uring_cmd_done(cmd, err, 0, issue_flags);
+
 	return;
 err:
 	fuse_uring_next_fuse_req(ring_ent, queue);

-- 
2.43.0


