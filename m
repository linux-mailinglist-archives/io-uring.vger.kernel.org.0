Return-Path: <io-uring+bounces-6079-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F3A69A1A63C
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:52:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E2885188B4AE
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:52:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C068211A23;
	Thu, 23 Jan 2025 14:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="WpT94mkS"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88F9211706;
	Thu, 23 Jan 2025 14:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643906; cv=fail; b=aPKE3LeZk9k4EeJkstLH90A1uuVvAJXNNdMAtmvhhjIASSrPUMMwAKh6pqbkYUrSTCyv1thzNXgjL/lUO4iSrgE+v6uacnBZNPNEmm3PrfzTI9FHR5WHxfJCYQUGig9ZYmbZLQeyuHk0nv25eEUV3TlEA0+M37+iRgQ+pxsJ/30=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643906; c=relaxed/simple;
	bh=/Yt/EX8kA38iCrg1WVD46jKJjkBgQ15K1tvsd8PfPUs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QvT0748Fry2mLP6qUTgUkdPc0+5J7Fnm7VU2DxE69WjQkUhXqT9ubrWLades3uJxisIPVjPrDt4OW+AkZB/8+lE3xbKRedAyunuyo9a9f6rr8cWbCR0Rf4tUBvUg6/1JIeNPVVH4J2OLB/owTS47/kumMELeWWuYEsMeEWcGwt4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=WpT94mkS; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42]) by mx-outbound18-177.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 23 Jan 2025 14:51:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BOiR7wt8idPD8QWHCi7MydNM31kOTSkJCpKwWRf1xFzrSzDuEUcVYTywGcuJwxosoQH8WqF7Pp82a6PwTkgh1/E+O9jukGmvlfxU4EOHwNx20Rcs9lP8AJoKkraV67I2gkn+FbJzKjNUBK5/HBdSe6jaUP0125z8yBETOITl73znxKX3mB9aYdqbRlOcN0asM7sRN32yMlkr64L9FENGgQH+mqkC5sFlL5Q2b2MxcSNEPB81Nn1dNYOHQsZwjxstFbfyUrD7yK7ZRsKBt05rSt8Qtwoe1E9avyzl8j3CHTgesz/T43uX5T1GNG4kWxr8+8r/3elAupG5Kl5AIoOgrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TQ1LHx6FaVNeh3uf/cVqA3oWUfVcLLj2luayb4hLK4Q=;
 b=aiF3wkdGiTM93de2+nLLWVGRJNBrRRwLN+TWBqJ9DOYCU91OjSqfkdhr4OPnLD6P2+pQw2JWai11jY7F4ADYXTQOecezK0xlB2DjGEtSC3jam6ui+p8GrDCF1xdUahUfJ9HINXYnsbjftRSfrTzVS4mPq0+kwrtcnAStoupuh7XO0LFlbWXXRyuOI8wgy/pl9WJJ8SaEJdl6PbNp/VhHhrTvDG4Wqf68ge6ZhPcQbmk0AWy9KcBGKT3LWjUkcvhZPM73B4hsYG9EmNU1buPDEyy1C5/QxAUh6w3+Q0JNhg4qdMuOAIz1F9zz+ZIB7+mluNlfYrPmSNgBkRUyYYYBIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TQ1LHx6FaVNeh3uf/cVqA3oWUfVcLLj2luayb4hLK4Q=;
 b=WpT94mkS7GBU2fQeBgYmIyxzXYBGZIkl5rAbGo1sld5iaxYHfNkf/7PNbKZwR7uIFG/yi+bcDaTyPDq7P8F8GCk9efYPYMTZDyuO8ogCYki42GnB0lUMP3JZVStiqfGq2UGw5tg6A8x/08KdaIrBaGaGeppPFPMFOvLUEgAKm6U=
Received: from SA9PR13CA0117.namprd13.prod.outlook.com (2603:10b6:806:24::32)
 by IA1PR19MB7879.namprd19.prod.outlook.com (2603:10b6:208:455::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.22; Thu, 23 Jan
 2025 14:51:28 +0000
Received: from SA2PEPF00001505.namprd04.prod.outlook.com
 (2603:10b6:806:24:cafe::d7) by SA9PR13CA0117.outlook.office365.com
 (2603:10b6:806:24::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.14 via Frontend Transport; Thu,
 23 Jan 2025 14:51:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SA2PEPF00001505.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Thu, 23 Jan 2025 14:51:27 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id BC7FF58;
	Thu, 23 Jan 2025 14:51:26 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 23 Jan 2025 15:51:14 +0100
Subject: [PATCH v11 15/18] fuse: {io-uring} Prevent mount point hang on
 fuse-server termination
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250123-fuse-uring-for-6-10-rfc4-v11-15-11e9cecf4cfb@ddn.com>
References: <20250123-fuse-uring-for-6-10-rfc4-v11-0-11e9cecf4cfb@ddn.com>
In-Reply-To: <20250123-fuse-uring-for-6-10-rfc4-v11-0-11e9cecf4cfb@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Luis Henriques <luis@igalia.com>, Dan Carpenter <dan.carpenter@linaro.org>, 
 Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <mszeredi@redhat.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737643871; l=6316;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=/Yt/EX8kA38iCrg1WVD46jKJjkBgQ15K1tvsd8PfPUs=;
 b=SpgTv5ZN8aGzBIQ/iAHr19XZ25FcB8WC44UQiWFiIqyHBHDcXNwHEXIVvInND8Q8H5YioE2Lx
 PxMgsngKoKpBAzwFmXTtFkYjH537ubhg4v61bIclNNmikeNP0m4w17q
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001505:EE_|IA1PR19MB7879:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fc6a2c8-8cf5-43e3-ca84-08dd3bbd6a77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?THpZVFNiRWdzblk1L01Rdkg3ODFieWVOUUF6bXNOYkZHK3BxUXl4MUZYZWMx?=
 =?utf-8?B?Q25yaTZ5cjUwUmtpN3cyUzQwQlNCcGJvcFc0SmcvR3pwVHduZ2xOWkFmZCt6?=
 =?utf-8?B?TmdSSExDSlpLdEd3azZLWVZJVkRiQUFHOFZ6c09VRmhhS3BXNlU1Tk13WEFw?=
 =?utf-8?B?TlFFVWR1UkpsRDhmY2RTNThwVHVSd2dpRkRhRmE4aUlrUWFJQVlCRVNHektP?=
 =?utf-8?B?QVQ3TmVUNVRTNEs1QWhyRVdsc2QyV3g5dy9JZXpPQkk4ZlVKSElURVg5L3dj?=
 =?utf-8?B?UjBYd3BqK2wxdmpKMTdxMkJxaDZ2MTYwbXQ4WHBEbXAzMW0zQmozUUk3dHl4?=
 =?utf-8?B?MGFYd2NMbzZDaHpyYWozZE9GeUIzZE1YejBPRzlUbEZxdSsrQXVGdDNqT2My?=
 =?utf-8?B?NkJXczlLSmdSTmZ5T3JtK3A1TzgxRUdhaGdCSkNFWWVxTzJmdTViSEQ3M2Ja?=
 =?utf-8?B?ZXR2TTU2REtGbkx5TnQxQkhkdXo3anI3RlhidVVENFFwQkMxQnBZdkNNTk10?=
 =?utf-8?B?VmxFdDQ1aXFoOEFBaU1ETXVVcGwrY2hMK1BrV1B2YW1sbEZuWG9LaExpRlU0?=
 =?utf-8?B?Zm9TdGhURVM0MVVyTmdTWElkOFNXcXdNSkJPWFN6QWpHVklJUlR3Rzdneng2?=
 =?utf-8?B?cDlwZDRtVm1DVVJoM2x3b1FCVFFCNC9qWmoxY3JIK3FIS2FHNWlDeHlFUzM2?=
 =?utf-8?B?Zm9kdnExTktVR2V0Rm9uU3BYQTNiaHp4OU9YOXpRSG1JeE9zOHFzVHY3NkxF?=
 =?utf-8?B?UG14QlNGODFva2dvTGVoa1lJNmgwVTZlb2tYakR3SUYxVW5mUS9VUUJsVlVU?=
 =?utf-8?B?cXI1K1Q0b1U4QkRmYVVSeENPcGpQWVlwc041RVRDcmNsSTVncXhyakZ1c2lJ?=
 =?utf-8?B?S2lUaW5rWTRTM1ZPRHVZb0F4Z0l4bmZ1R1ErZnhqNmRvblMzdElKVU5Xd2tn?=
 =?utf-8?B?YVNPWWhmZURKa1JGYU9TWXZteENRWFVUZmxBQkZGOXZLNTVoUG9SUFFGQ042?=
 =?utf-8?B?d3VYd1RadSs2aVJ1OE40ZzMxb0prWGRleFZpOXJnTjJ4K2JoWVNESmRiRXha?=
 =?utf-8?B?YzNLUGVreDdmT1pKbGxnNSthVFlnV1lRQVBITmxQK1hmNm5lWndNbXZ3RjVJ?=
 =?utf-8?B?dExOcXJRUlkyQTg0d0FYMGphekNvTERJcG1YVlRhdDdwVG5oL1EzQzRGTWE2?=
 =?utf-8?B?UVY0dWxKUzdHV2Q3QXhqdHRDSHgzSnRZa1RzQ08xMWhjZVVzblJjVXhOaFBj?=
 =?utf-8?B?emJ0RmhNSnU5NGxsOTR3NWYvdHJzb3FoZDJKT050cTFPai9GMTN6b1N3RzhX?=
 =?utf-8?B?ckRCUyt2NFFOazdzV3ZSU0VlNE95NGlza2QxYXgxRERaSDJmN2NiaUV6SXZU?=
 =?utf-8?B?MlhPRElZcFNIQlB1amJabU1pSzZNOSs1c1oxOHMySG5lZFFLbFM3WkRJVjZo?=
 =?utf-8?B?VDdIRCsvbUl6dTkwWHRwU0xJRXFaYS9odkh0Z091K0pnV0JEeDYxL29nRHQz?=
 =?utf-8?B?VnBmN0FQdnltN0FDbE9zdExOdG41dHdIeE91aThudExtUFo5dVdMT3RBSDhM?=
 =?utf-8?B?L09TRHVEanpTUTdZK0NPMk5HZytKeXRZcGk3K1pKdXUzSkRDWnRsTkpXdnc1?=
 =?utf-8?B?a3FKTmFBTzlHdGRsYm9iZVJPWm9KTG84eWc5K29IMHd3KzhWdGwzdWpvY0hh?=
 =?utf-8?B?RU5yNG9za2ZpOCtQR1BEVUZOSHFvcDRNWS9BNU1nZGxmTzV6b05RaG5vNEhs?=
 =?utf-8?B?ZHFMVFF4Y2xBeHRiRnlyZG12Z0VNQXh5MzB3RS94blZaUG5JaFMvS3ZNRTdx?=
 =?utf-8?B?V3ptcjV4TVpLS0pCVEVNbVkrZnZCaGNqeU1QRFlUYWsvY09uOFFFdktKUG82?=
 =?utf-8?B?RTFNQ0Zwa2JXa0p2aUJRbzRuUW5PbFBoUStNL1BQMGxtVW03a1RrOXJPaE5q?=
 =?utf-8?B?K2VoWUhqYUZCNXJuT3dFZEwzYVRJUWRrMVNPRTdFV1NYMjJPWVlHaWdmRHN6?=
 =?utf-8?Q?blJSCvOPRK8HU8lQgGUB2nz957FDaw=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Q01tw5HQAMfg8O1rJoZEyX46iPS6QcLZuaE4c14A2UPqjvx0n6B7AfIAAqLipEIFqiUJAmFCLPrSX6rgTwai5Z1yyoXHhK/rmsfVoGUv7qCfCoXI7+us5VPS7zXCNzYtOd3njScdOEE5qeDLWT40bKL22LsUFCv+cBSAKpDiv/102mPbnQ8XhIiuvgEsmRrMaZ8BiBc+LUsYWr83J1MLdrgqWkyyxWPH/zmMEAuEC8puXqYyoukf8zFNu3oM9PD1NcmyoRfrU2L1WmY3wiCyEKVF7i6VDPxoxwsFWda0biAX7UqtfzxJS0wj99HOwaeTO7HBzO0r00y7F8e5XZQIf9xEdXS49oS9cI1Jglq8YQXcvvgkXmBm3Rhb79RX3Z7E8LUgTvRre1JRx2bl2kdXykInjCTG0ie0+GVzkKSIcNyUJjhB578MV9SxfsI3FDJV5XoZrhotv/EH1/Q4ZWN3fzLVm29v2KFJkI7yB5MUI7uwMpx45S0QWJEbls/Z1PrZBmVF7y6YLUlYLeDGfSLWj5OfDYN3YciWRL90f+wWwm3PhQZFpT6RPIXM7iC2KJIymMrYA5erktjBA1T5isqzrzG4lXulBrg7lABCpY46eSt/q5lOUxmB4/ysKNkb7711aFRz3RjeupbL80kPHzldwg==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 14:51:27.4446
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fc6a2c8-8cf5-43e3-ca84-08dd3bbd6a77
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001505.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR19MB7879
X-BESS-ID: 1737643890-104785-13348-20876-1
X-BESS-VER: 2019.1_20250122.1822
X-BESS-Apparent-Source-IP: 104.47.66.42
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVmaGRqZAVgZQ0MLQJNncLMk40T
	TNLNnc3MQizTLVMC3Z0tTQNCXJMC1FqTYWAA1g6BxBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.262002 [from 
	cloudscan18-66.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

When the fuse-server terminates while the fuse-client or kernel
still has queued URING_CMDs, these commands retain references
to the struct file used by the fuse connection. This prevents
fuse_dev_release() from being invoked, resulting in a hung mount
point.

This patch addresses the issue by making queued URING_CMDs
cancelable, allowing fuse_dev_release() to proceed as expected
and preventing the mount point from hanging.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com> # io_uring
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/dev_uring.c   | 70 +++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/fuse/dev_uring_i.h |  9 +++++++
 2 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 93360fb4ee3c686e38ce041bffaf5ccd4b6cec65..fd8c368371e69637323f99c07e54e0365d38abe3 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -150,6 +150,7 @@ void fuse_uring_destruct(struct fuse_conn *fc)
 
 	for (qid = 0; qid < ring->nr_queues; qid++) {
 		struct fuse_ring_queue *queue = ring->queues[qid];
+		struct fuse_ring_ent *ent, *next;
 
 		if (!queue)
 			continue;
@@ -159,6 +160,12 @@ void fuse_uring_destruct(struct fuse_conn *fc)
 		WARN_ON(!list_empty(&queue->ent_commit_queue));
 		WARN_ON(!list_empty(&queue->ent_in_userspace));
 
+		list_for_each_entry_safe(ent, next, &queue->ent_released,
+					 list) {
+			list_del_init(&ent->list);
+			kfree(ent);
+		}
+
 		kfree(queue->fpq.processing);
 		kfree(queue);
 		ring->queues[qid] = NULL;
@@ -242,6 +249,7 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 	INIT_LIST_HEAD(&queue->ent_in_userspace);
 	INIT_LIST_HEAD(&queue->fuse_req_queue);
 	INIT_LIST_HEAD(&queue->fuse_req_bg_queue);
+	INIT_LIST_HEAD(&queue->ent_released);
 
 	queue->fpq.processing = pq;
 	fuse_pqueue_init(&queue->fpq);
@@ -280,6 +288,7 @@ static void fuse_uring_stop_fuse_req_end(struct fuse_ring_ent *ent)
  */
 static void fuse_uring_entry_teardown(struct fuse_ring_ent *ent)
 {
+	struct fuse_ring_queue *queue = ent->queue;
 	if (ent->cmd) {
 		io_uring_cmd_done(ent->cmd, -ENOTCONN, 0, IO_URING_F_UNLOCKED);
 		ent->cmd = NULL;
@@ -288,8 +297,16 @@ static void fuse_uring_entry_teardown(struct fuse_ring_ent *ent)
 	if (ent->fuse_req)
 		fuse_uring_stop_fuse_req_end(ent);
 
-	list_del_init(&ent->list);
-	kfree(ent);
+	/*
+	 * The entry must not be freed immediately, due to access of direct
+	 * pointer access of entries through IO_URING_F_CANCEL - there is a risk
+	 * of race between daemon termination (which triggers IO_URING_F_CANCEL
+	 * and accesses entries without checking the list state first
+	 */
+	spin_lock(&queue->lock);
+	list_move(&ent->list, &queue->ent_released);
+	ent->state = FRRS_RELEASED;
+	spin_unlock(&queue->lock);
 }
 
 static void fuse_uring_stop_list_entries(struct list_head *head,
@@ -309,6 +326,7 @@ static void fuse_uring_stop_list_entries(struct list_head *head,
 			continue;
 		}
 
+		ent->state = FRRS_TEARDOWN;
 		list_move(&ent->list, &to_teardown);
 	}
 	spin_unlock(&queue->lock);
@@ -423,6 +441,46 @@ void fuse_uring_stop_queues(struct fuse_ring *ring)
 	}
 }
 
+/*
+ * Handle IO_URING_F_CANCEL, typically should come on daemon termination.
+ *
+ * Releasing the last entry should trigger fuse_dev_release() if
+ * the daemon was terminated
+ */
+static void fuse_uring_cancel(struct io_uring_cmd *cmd,
+			      unsigned int issue_flags)
+{
+	struct fuse_ring_ent *ent = uring_cmd_to_ring_ent(cmd);
+	struct fuse_ring_queue *queue;
+	bool need_cmd_done = false;
+
+	/*
+	 * direct access on ent - it must not be destructed as long as
+	 * IO_URING_F_CANCEL might come up
+	 */
+	queue = ent->queue;
+	spin_lock(&queue->lock);
+	if (ent->state == FRRS_AVAILABLE) {
+		ent->state = FRRS_USERSPACE;
+		list_move(&ent->list, &queue->ent_in_userspace);
+		need_cmd_done = true;
+		ent->cmd = NULL;
+	}
+	spin_unlock(&queue->lock);
+
+	if (need_cmd_done) {
+		/* no queue lock to avoid lock order issues */
+		io_uring_cmd_done(cmd, -ENOTCONN, 0, issue_flags);
+	}
+}
+
+static void fuse_uring_prepare_cancel(struct io_uring_cmd *cmd, int issue_flags,
+				      struct fuse_ring_ent *ring_ent)
+{
+	uring_cmd_set_ring_ent(cmd, ring_ent);
+	io_uring_cmd_mark_cancelable(cmd, issue_flags);
+}
+
 /*
  * Checks for errors and stores it into the request
  */
@@ -836,6 +894,7 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 	spin_unlock(&queue->lock);
 
 	/* without the queue lock, as other locks are taken */
+	fuse_uring_prepare_cancel(cmd, issue_flags, ent);
 	fuse_uring_commit(ent, issue_flags);
 
 	/*
@@ -885,6 +944,8 @@ static void fuse_uring_do_register(struct fuse_ring_ent *ent,
 	struct fuse_conn *fc = ring->fc;
 	struct fuse_iqueue *fiq = &fc->iq;
 
+	fuse_uring_prepare_cancel(cmd, issue_flags, ent);
+
 	spin_lock(&queue->lock);
 	ent->cmd = cmd;
 	fuse_uring_ent_avail(ent, queue);
@@ -1035,6 +1096,11 @@ int __maybe_unused fuse_uring_cmd(struct io_uring_cmd *cmd,
 		return -EOPNOTSUPP;
 	}
 
+	if ((unlikely(issue_flags & IO_URING_F_CANCEL))) {
+		fuse_uring_cancel(cmd, issue_flags);
+		return 0;
+	}
+
 	/* This extra SQE size holds struct fuse_uring_cmd_req */
 	if (!(issue_flags & IO_URING_F_SQE128))
 		return -EINVAL;
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 0182be61778b26a94bda2607289a7b668df6362f..2102b3d0c1aed1105e9c1200c91e1cb497b9a597 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -28,6 +28,12 @@ enum fuse_ring_req_state {
 
 	/* The ring entry is in or on the way to user space */
 	FRRS_USERSPACE,
+
+	/* The ring entry is in teardown */
+	FRRS_TEARDOWN,
+
+	/* The ring entry is released, but not freed yet */
+	FRRS_RELEASED,
 };
 
 /** A fuse ring entry, part of the ring queue */
@@ -79,6 +85,9 @@ struct fuse_ring_queue {
 	/* entries in userspace */
 	struct list_head ent_in_userspace;
 
+	/* entries that are released */
+	struct list_head ent_released;
+
 	/* fuse requests waiting for an entry slot */
 	struct list_head fuse_req_queue;
 

-- 
2.43.0


