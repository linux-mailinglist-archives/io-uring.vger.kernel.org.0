Return-Path: <io-uring+bounces-4541-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BABB89C0C7F
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 18:09:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 251D6B22E13
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 17:09:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07726217322;
	Thu,  7 Nov 2024 17:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="ELc9gS8B"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC54216A24;
	Thu,  7 Nov 2024 17:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730999081; cv=fail; b=Iwq/mw8Nd2hGO4kJgDK+sX9iKmvUkynypeipAmGfdUPvfGeibY1qb7FLFgK0R2l0EeJlq1rBV648NJ9P4kN4VlJVFwNLGqJ2fer64UpaF/OFE1R6FNHWZrBIPFPbLM9MOTQN6RhkPgOcgXYc9Z0CgZ4eyN7LMhGwqWZW1zCGjgQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730999081; c=relaxed/simple;
	bh=7Xi4hyG04KMKxPwnWaeikRjAaezWNIGfJ7G/TvVGmzw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qu3gO3Qzm2Ih8P2kTaELIIRcVbt5YhOO7casO323MVwbyK1iMNaZF+rQiuQxZFqYtAXy8NYhJcgN1orDeZiFmb7N48Le4ONikI8P9sbznAR1A+E5lBSQ5FDUgls5P2kwGTawMQiYX+Q4qBj1gKXbKziNwYORvrOGQHG/Wo3AEWQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=ELc9gS8B; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171]) by mx-outbound42-115.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 07 Nov 2024 17:04:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U3WPe6CoJWkrsOVXURIwAcObtkbYf6K8MtpjNBeD6PLUK2trB2sy2nCntZoIcpF4uiWOmbCXsaD+L7uEeqV5CZHsDSBHvMibFe9GWqeFT//nkPalrU9h/oatMpgK6rzKbqeqNgBveXSpQJ1iJtE7H1Q0GELc/oA+ZfKuwrvXN8KPRurwiwMwCA6OaRYUH+g3ISDZi+dZE63sZGBGIP/hRSsCoM7mRRpwMeZ4eXLRUc/BXygZHG93qDn4j3y4Z1OPlcuFEkyZPZ/wgjwDw+Q7cQ9Z+sKVD7a7j9FDwzMZaRLKVPZUMffhYPa41CKBA2Rr39ApDwK52qQ0pQGXdZHAww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oJZGXDrF/qYt5U60QDosKDvI8xNwlWRog24xMY9CxGo=;
 b=IxCCnWYOfEANhUfKWSr0Eh7lzDCOadV8KTuMBIIm+tcCmF1Hn5XnqB6p9DWBG8yI4z6ugBZTCkgF+Sg7T0Gjd/0v1EzVyt+/2r1sAQMVR0oRi9Az0dGB0/6wzwTAaUnWMwkB7Ta+ZJplEsmTo4lWfsbsCtDSU5m3BS3txHGiUUqPbNqxSBMJ7oYjRBvsJL4zjRLTu+tovzaO3ZWI9zTsFTWCELxILKoIhaIXsmUW8d07jMyEGNjQ8dL7rQ+mwgGuUAcBxNfvcgOx4gnnnvJhV7PXN1SyeMjDNGiFEKc7xM/eq204KNmHS5xFo3hvA8QeFSG0t26eD3Tylq1bCN+Cxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oJZGXDrF/qYt5U60QDosKDvI8xNwlWRog24xMY9CxGo=;
 b=ELc9gS8BUowqo4dyAQtD+0jIJtEvTmPGPtkQAfCUMbZtN15RSSnOOGaWkAdPdQjfXyMIWMOOdoaFojZhM20pbmYKA8bK80ihUmdwIJYmdQOMys08bMK8vB/MUhI5aoLoz6emxJO+6WDMol+c5nU0sgwP45m6KdT5H1IYOeReoTI=
Received: from SN6PR04CA0087.namprd04.prod.outlook.com (2603:10b6:805:f2::28)
 by DM6PR19MB3788.namprd19.prod.outlook.com (2603:10b6:5:248::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Thu, 7 Nov
 2024 17:04:12 +0000
Received: from SN1PEPF000397B0.namprd05.prod.outlook.com
 (2603:10b6:805:f2:cafe::b7) by SN6PR04CA0087.outlook.office365.com
 (2603:10b6:805:f2::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18 via Frontend
 Transport; Thu, 7 Nov 2024 17:04:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SN1PEPF000397B0.mail.protection.outlook.com (10.167.248.54) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8137.17
 via Frontend Transport; Thu, 7 Nov 2024 17:04:11 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 50FAFC6;
	Thu,  7 Nov 2024 17:04:11 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 07 Nov 2024 18:03:45 +0100
Subject: [PATCH RFC v5 01/16] fuse: rename to fuse_dev_end_requests and
 make non-static
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-fuse-uring-for-6-10-rfc4-v5-1-e8660a991499@ddn.com>
References: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com>
In-Reply-To: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730999049; l=2183;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=7Xi4hyG04KMKxPwnWaeikRjAaezWNIGfJ7G/TvVGmzw=;
 b=aYCNaa2Q++ZUQmBXaEHouma6n3Adn9vZaOZvL/uQ0pMmC+TqfEh5vKOYYIToqEtmSlEwmupD/
 +rehjzjXLHdDvR/E/dxYgdrv8WdEGpk4P+uYhoBLmX1doqrWDPQ9MIk
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B0:EE_|DM6PR19MB3788:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d8ab1c7-a05b-413a-b681-08dcff4e33c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MEpFZEJ5aldhaDQ0NFZENW5IWVhYSUI5Z252R3NTa0N6dk5VWUtFQzkrcVFo?=
 =?utf-8?B?a2I0WTAyL3E3WkY0S3h6d2VWWVk5TEJJQU9KOG1wVGRzZExkWHJLNE9WcEl5?=
 =?utf-8?B?YldUSWZYWGc0YnVJYm9TNldteDNjbGNha1QrMEp6RDBUeDNldDIxakZKQzF0?=
 =?utf-8?B?TFdOZUc5NEd2ZEdqYUVkS3dLd09VMFc4M0RLeDhVK3k3ZFRobSs4SzR5ek9Y?=
 =?utf-8?B?ZjNadnh4QiswVUJ4LzFSclRXVlFmS2tsNEtMVFNqeDZhaW9LSE9SQmJYeGZK?=
 =?utf-8?B?YnhMZ0FwL0l2ZkQ5NmRpWnd6a05MYWJLUkp0aUJVeUwxNTkrYjhGOEUwcTEy?=
 =?utf-8?B?blQ1QTZuN0psOXRjb2pjWGJuRFNISVIvMGlIL0ZpdUtYdWgrZ0IzUUR1NWY1?=
 =?utf-8?B?RDk1Vk5XaGVNdWxTWDlodldUNEREWnZxWGlKeUI0RE9oc0NybXIxQ3FROTAy?=
 =?utf-8?B?YXRkN0dTSjVjZFFQaDlKM1M0SXRKTjZqMlpvWElPZmIyY3BqQTRxMWlkRDkx?=
 =?utf-8?B?V0syOTdEVWx6Y1BBOWdLVmlhWmVOdE0rd05NbHBFWXNPakQ0UXNZSnhONXkx?=
 =?utf-8?B?UlgxMlNFWEIyaUh2L3laVHN0cVA5N081SURvbE1zNXVia3RUMDVIYTN4THJt?=
 =?utf-8?B?RUVYWW5RTzU3MEJUNGZYMktuaXBZd2daek55T3lsRVMwRCs0c0FPM2x3c2ZN?=
 =?utf-8?B?MHZmQVFjUUhpK3BaMk5wMnBvOWZFV0tTOTdwK3VSZVhIUGs4L0d6dkJ5eTZJ?=
 =?utf-8?B?VWl3OUxZQ2pEM3J4M0NVM01kU1pna3hkTnA0Rzl3bkY0enM5VFVGOEJQNk9C?=
 =?utf-8?B?ZmhoUGhoNU00L1VDTDhhYlBnWkxUVU5WTHdMTTlUZlJyaXNGRHFWMEVlbnJ3?=
 =?utf-8?B?M2pTZGhwZXZWNFZiMnE4TzRndmxiMkR0N1dVdStNWFZraW1McjQ4eis0aGdN?=
 =?utf-8?B?RTNNR3BCZVRzWVlRRTQvN2tDbFZnMFNlRXNOUG1UR1A3dXFHaXBPR0FESTJV?=
 =?utf-8?B?UnYxNCtLZ1g1RE9nNzBqYWRxTTFERDg4ZWswQ1ZFSXRMaUlnOHRHQ1ZTcGUz?=
 =?utf-8?B?ekhpVm5QQ0g1cGZzYU1yWkV5YW1iejk4NlJCTVVRYy82SEJlZXpTNjdRNXNV?=
 =?utf-8?B?aDM0Wjk3ZTVwL0NQMWtyeWxmdFN0RGNNUWxzMlRFc3V2TThkdkJ4am9MU2V4?=
 =?utf-8?B?SFhzTkQ3ZW1UYVFSZzdIdTZrTHRIWWdKdllZNitObEd6VGpUYkQraHp2ZVhQ?=
 =?utf-8?B?eENUTGtWVlMvQ1ZnbGdnbExKTHM0Wmk0cnBXL2hZSFBUODBYTzFWdzNuNU9q?=
 =?utf-8?B?M0YvcUl3VkliN1Vsd0Z0OWNzUGFJWkg4WG81K3RVc3k3Y2xnUDliM21zb1lv?=
 =?utf-8?B?OUVWK1NoYlR2dXRPVkJGS1lNRXNibTkzeEJIZ1lzOE5YMDk3ZzlvRFp0Q3py?=
 =?utf-8?B?bTRNWlVYcGR6N0p6cDRjSjVvamEydFN1dVY4Nk02Y3RzaVB2MGxIMGQvTGsy?=
 =?utf-8?B?bFV5dStNb0ZqbStIVjJpM3l3NHpaeDlGbHl0SG9CdHNQMnpRYVE3aUgrWmwy?=
 =?utf-8?B?UXRuTG41YmxIZ1lIVEsyd1FleE1laGFZWk1VdVA2MWpwT01qL3V2M0pYbnJr?=
 =?utf-8?B?S2VaZE9MQ1NYRStXNjlEVjdua04zRUx0ajdUVGNOUnRZLzN0Rnp1VWpyQlR0?=
 =?utf-8?B?YW1OZkxLM3A3YWRRa3l1SkRZM1BpeFdBaXBsKy9CalovNUpuSmdoQmxSWHpu?=
 =?utf-8?B?akF3T2ZwU1VyeVZLODhBM1BXb05EYSsvWGFkYjZKL04wNGpDMW1zcmcxMExy?=
 =?utf-8?B?NGlraG9QZlFxM2hpVUhRdFp2WXVINlk0NGxkdXZwUU93RVlEaytjZWxjWFd0?=
 =?utf-8?B?eW9DRCtyV0VLTDFTdHVRYVBwdlBtYk9oYkhuS2ZJMk02SlE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(82310400026)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GZ63f9Rw8XYSPHLIfzTnv0/QTqeWmb9bniqneHp8uzDL9arG7Lt2e82aYiJxOm48uooQxqPfcCfl1ksiTp286yUZPnRcHqQz64YIRLPWwg9DbCt17nm7xmRfoSwMWsxzOFKDAwxNN4c/DMGImIpEaA26iG3ad20NtHULw6YLj1XmmZ6Z8MMHlsxa9lUa9Pg9nc4FOmRXCrp7iQitjG+EPR6G5HAxmEG5bzRJ1U/a3PsmWvtDHVnaU4dSngP+cE7MGho4T5BYHz/Y9V70TIHEsF5QjErRGB38DsGk7SKzuEMup5PreeMHKABPu6pmyV6u0tPXoVYfc/mev8hTSW1Bfonix2Cf7gFsozzVwetgOypnz6xWqAwynjInleYFk8NtbFv+m4RHFyRj2yVEHE0hq71OOK2ljeRyUlQEQKbP/BAGrSgd79H6Xwb/Wxe82xz31mkKpG/e8rv4fabPtwbFoUBeppc0Wnkn5qrLZB+i5AL43JN1ug+RPqwsL2ZYXwmsAe5DtuhRbC/d7ZshuImxi4YdciiWOc8IG0BulUwa048JdcsFD2dbl2IRHR1QjkskroDsJsJVhtMyZw6ZPrj63Wq8/7DtG1bKst6BbxxbbUkltl0g2R8BB1gS4rV0U/+d/iesvbSdIZQeT06SgYm4/w==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 17:04:11.9892
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d8ab1c7-a05b-413a-b681-08dcff4e33c4
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR19MB3788
X-BESS-ID: 1730999059-110867-12748-13473-1
X-BESS-VER: 2019.1_20241029.2310
X-BESS-Apparent-Source-IP: 104.47.59.171
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkaGhgZAVgZQ0MLS2DLN2NLQ1M
	TcMNXcyNwoMcXY0jzNJMnA0sgsJdlUqTYWADHjmkBBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260269 [from 
	cloudscan12-251.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This function is needed by fuse_uring.c to clean ring queues,
so make it non static. Especially in non-static mode the function
name 'end_requests' should be prefixed with fuse_

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/fuse/dev.c        |  7 ++++---
 fs/fuse/fuse_dev_i.h | 15 +++++++++++++++
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 9eb191b5c4de124b3b469f5487beebbaf7630eb3..74cb9ae900525890543e0d79a5a89e5d43d31c9c 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -7,6 +7,7 @@
 */
 
 #include "fuse_i.h"
+#include "fuse_dev_i.h"
 
 #include <linux/init.h>
 #include <linux/module.h>
@@ -2136,7 +2137,7 @@ static __poll_t fuse_dev_poll(struct file *file, poll_table *wait)
 }
 
 /* Abort all requests on the given list (pending or processing) */
-static void end_requests(struct list_head *head)
+void fuse_dev_end_requests(struct list_head *head)
 {
 	while (!list_empty(head)) {
 		struct fuse_req *req;
@@ -2239,7 +2240,7 @@ void fuse_abort_conn(struct fuse_conn *fc)
 		wake_up_all(&fc->blocked_waitq);
 		spin_unlock(&fc->lock);
 
-		end_requests(&to_end);
+		fuse_dev_end_requests(&to_end);
 	} else {
 		spin_unlock(&fc->lock);
 	}
@@ -2269,7 +2270,7 @@ int fuse_dev_release(struct inode *inode, struct file *file)
 			list_splice_init(&fpq->processing[i], &to_end);
 		spin_unlock(&fpq->lock);
 
-		end_requests(&to_end);
+		fuse_dev_end_requests(&to_end);
 
 		/* Are we the last open device? */
 		if (atomic_dec_and_test(&fc->dev_count)) {
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
new file mode 100644
index 0000000000000000000000000000000000000000..5a1b8a2775d84274abee46eabb3000345b2d9da0
--- /dev/null
+++ b/fs/fuse/fuse_dev_i.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * FUSE: Filesystem in Userspace
+ * Copyright (C) 2001-2008  Miklos Szeredi <miklos@szeredi.hu>
+ */
+#ifndef _FS_FUSE_DEV_I_H
+#define _FS_FUSE_DEV_I_H
+
+#include <linux/types.h>
+
+void fuse_dev_end_requests(struct list_head *head);
+
+#endif
+
+

-- 
2.43.0


