Return-Path: <io-uring+bounces-5328-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DFF09E99B7
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 15:59:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DA82163674
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 14:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 096D3222584;
	Mon,  9 Dec 2024 14:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="FPnP6l7H"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3AF1F0E4C;
	Mon,  9 Dec 2024 14:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733756226; cv=fail; b=l59x8HkFSfJQLJLT7HW5+YfI9JDBE1NUH1ipihX5JRijEyE21pOeklKKvXl6aIm72KPR1d3bbbsKwDpwXA7hmSdcs18sIVB3+UIPXaWQ+pQ90GZC5ZNO66jKybTD4w3Ai7x6idSukshvGp9ofG/djZRAxwYj0dsRlb+uTrg2oog=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733756226; c=relaxed/simple;
	bh=rL+rJumJZVQv3keV6fOiXKdgnPwMmzm2pZxEFS7KX9A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=m8R0xRFnI5FmW6vmxvNbSMvRIfOFW4B2JYonKSFkOD5cjLFn1aeq8lmZKkWRyh2+kVuwtmRzHWVKPdt4y9tiCmXMGyV7/8088UX1OQ7UiQ1dmcFhjuNqxtQheYJUnKtQudK9G5uUj/5Eu09J5lNFf97ydJrNCUeE9t4Jd5Ao15o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=FPnP6l7H; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40]) by mx-outbound45-178.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 09 Dec 2024 14:56:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gsfFw2fk+JiowSrYneG6Wvw+GDmAABlmVMbiew4oXe4sp21XBCayKULWzVQ/yegSoISiiVqX2eDLFk48fjZrjSM8WcB5KycdnHm4xm0s51PdjDmBMx8Vye9lghVRLFM8RVyS9N0CrZuzBmepWE8Fd0kY+azypWMdLQQFzHE6B9/F6EWlkW83d+ldU7oXQC6JfYcolxVJaKzEmd4zwFQmxCEZ/KwT8cbF99O4SOt8NcH0M14cu8u5JFaLJcbKS8aPbSo2touwRgZ3BmRMSvyJvdJoms5Qj6VeYfTv1L5MCl/FGMVxaA3EwYlBdOhrT/04M/OUGrtePk7xxYio+sL8wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QyPiP7KMk4/OOskRuTiWdKJCJbVy8Vzg024X8lSSfpY=;
 b=uuFdDmvId6jkchVGlF28fwzl7l00T9cifqU3z1C1SZ6GsQLv0qRxW6j9vV9MpDZahXZiPLLLim6lA6EnGeqXVgCo7Ldnr2tIxpq+CgN63uBPg1FYXiD2rixwe6j4PkzIh7macPPPIQCDVy95WhxckBYxeifFXSMyRNsw+fMVChWWWt+oRHoUDd/SduX0b48/zqNmIqa4Fy2QBXem4FQxfO+LUdVsd/5ldueWDHkhWti/wexWlfYv5mgltjdeaJ5bsyq5WLCcDfltiRdYflgti0MB8a1PvCwGATrKJGsKy2A5Xj4CEIl/wrWzMVoegr8fRE5JssuuGkaXFw9e4Jv0aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QyPiP7KMk4/OOskRuTiWdKJCJbVy8Vzg024X8lSSfpY=;
 b=FPnP6l7HxbaXqcNenkjKRKQmWRPh8Ovfqb4KejQNq3Bew3mdWvapLaaJHXFnGvr+i5UHn3iG8z9nYsOHnAQ4BCHuQrAceRjHGQfR+rZOJQc4e4vQMH5+hrKLRHM6273Tib040o3gJgGcTEpFd1Ih5tOPn+QQ3mWrc4FjffpSLtQ=
Received: from CH2PR18CA0041.namprd18.prod.outlook.com (2603:10b6:610:55::21)
 by MW4PR19MB6675.namprd19.prod.outlook.com (2603:10b6:303:20f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Mon, 9 Dec
 2024 14:56:53 +0000
Received: from CH2PEPF00000140.namprd02.prod.outlook.com
 (2603:10b6:610:55:cafe::71) by CH2PR18CA0041.outlook.office365.com
 (2603:10b6:610:55::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.12 via Frontend Transport; Mon,
 9 Dec 2024 14:56:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CH2PEPF00000140.mail.protection.outlook.com (10.167.244.72) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.7
 via Frontend Transport; Mon, 9 Dec 2024 14:56:53 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 771C818B;
	Mon,  9 Dec 2024 14:56:52 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 09 Dec 2024 15:56:35 +0100
Subject: [PATCH v8 13/16] fuse: Allow to queue fg requests through io-uring
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241209-fuse-uring-for-6-10-rfc4-v8-13-d9f9f2642be3@ddn.com>
References: <20241209-fuse-uring-for-6-10-rfc4-v8-0-d9f9f2642be3@ddn.com>
In-Reply-To: <20241209-fuse-uring-for-6-10-rfc4-v8-0-d9f9f2642be3@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733756199; l=6858;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=rL+rJumJZVQv3keV6fOiXKdgnPwMmzm2pZxEFS7KX9A=;
 b=mP/GYTNuuHw8TS++cPZjFUVTscmj1ArWqFsFEXwW6lQdviPSxARp0vc+XU+Rkpj1t06sFG5d6
 y5HpSDlw/quA1lm78tJXcWV5zrpB4Vsi93dpJcC7UqE2yg3AE9qMRAU
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000140:EE_|MW4PR19MB6675:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c00660b-9ad8-4cf5-6a00-08dd1861b7e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K3NoRXpkMHVHRHI1dVFqSVExT01jNU95QzJlazdvUkJYeHZTZzFMTUhjaFBz?=
 =?utf-8?B?Rm9QQXU1bzdXVTg4K2wrTHorQ0h4ZkxMdEV4SHhaM2FvengvOU9URUVaOVlz?=
 =?utf-8?B?NzVyRjlwMHBma1huL2s0Q3ZuZkVMVU9yL0dtcUg1eTBodzlodDd4QktyL1Fw?=
 =?utf-8?B?YXZCbTU1MmVteFJ5MmVLWnFGeUJSVHYvRnF3Q2RIZUlLTzZhMHBvZTVLTmhM?=
 =?utf-8?B?Q01tL2pXMlJwb0lnTlJjaDRySzJlNjVheVZ1b3A5Z3FYQndZTjhsclNpR01Z?=
 =?utf-8?B?MjBVcTZVM1NMK0F1clFNOWlWdjI3NnNzUU9EQ1g4SHR5emF5NkpxL2hGSG5j?=
 =?utf-8?B?NWt2S0hoWGZEbzBuMFRwQlZydWZQU0JYT3c5MTIvQmdPVHdTMGlsN0w4ZHFT?=
 =?utf-8?B?NzFwbk9MckdIbi9wK3czNUEvc3dwV1pjZzR5TmZpanI2bkpzRzNWZXNzN3RS?=
 =?utf-8?B?U1JodUo2Nk9Cek8zRFd0VFBsRkJvSHhXM0dUVWVWdVZHTzA5a3ViTTVnZUU3?=
 =?utf-8?B?Y3FIRHRmQ0FxZ1ZoamZEQng3QlF3MW8xTDdGNGdpc2NFeFFwVEtGZ2tmcE8r?=
 =?utf-8?B?UndITGorVHM3MkRUYkJINkpjNThjTGwzdUwzbjdSR2dzU0RFV1ZLYm9qWVd1?=
 =?utf-8?B?bVlSeWtWbjBMQjBQWXZtVXFlOUFhM3FaRE1LQklURGlrS1lWT2JGMmc2dXBu?=
 =?utf-8?B?MFNTd2NKdExyU2hIM3I1UnltMThUU1lsaWo2ZUR4Z0JrU2lRYTNmYUhiNDda?=
 =?utf-8?B?UTdKZHVVczIrQWFhUm5XOS9nT1VMdkxMVU5rMS8vSUlHNGFScGp4emJhM283?=
 =?utf-8?B?T1NuNUFseDM1V0pKemJRV0dldzl6QnlGWDBkVmJ0WmhqM2xFdkRET0RlTTk3?=
 =?utf-8?B?WXFVelh1MHlBSzgvdFdaWnY3dHpOckh0OEtoay81cE55eEFPSFQyNkpwUktC?=
 =?utf-8?B?M3R5b09Hdmd0MFF6dWFsd2o2Z1ZIb2RHMjVIWnJOdHpVcDFDSENqRDdLWGFH?=
 =?utf-8?B?NGZjdk44SkhRZ1duWDZMeklDV2dscWVvSDZES0hNMHlkeUFvTjNUV2I4bkJH?=
 =?utf-8?B?TFMrU0trWjVWb3JFQ1lkTXp6enpVRnRkeHFCVWl1dXNvbGcvNVpyZysrdWJZ?=
 =?utf-8?B?S3hHKzdWMnZzSDNwS3Z4MVhPNGt6a1NBaHZWMURlOWpDc1NZcGJab1FOMkhQ?=
 =?utf-8?B?WjY4RGFwdFFwaUJvbUxveCtoalp3aWM0cUxtem1WYzVrdUFWOGprdFhhMjc4?=
 =?utf-8?B?MTFtM0FqZHIrYkJjWTJZZmZUMC9UNzZmdGtWVlVLL3JHNjQ4TjlrTkhuUlAx?=
 =?utf-8?B?MTJWRysrWGNIWWtGRnVpdk12Qk5qSHprcjdxMnE5ZzVoVElyb05LS3BqZjdr?=
 =?utf-8?B?NGVFZWxlc3FCT0YzRVo3VEJEYVNMTmlkL3Z4YVJlU0U3SFMyQU5HeU1GNXpm?=
 =?utf-8?B?VjF2dXRNMlBWQ3pMRUJSekJRc1p3OVZZWWR3cmptZ0tWZUorcm9sSVZxMC9l?=
 =?utf-8?B?akkzcWhGM1JSa202NW15TXIvYUdEOEx0N0Q1M3JrN1UrY3NPejZRdE92UjZR?=
 =?utf-8?B?cXdVUXFaOTBTTTZ1QUdldFl5bWl1SWg3WURacldna3RQV3dBeElpMnI1SFFs?=
 =?utf-8?B?TTE2bjQ4L0VYN0RLQWtHYTgzaGYyVkJ0NmlyRkw0QVFzUTlERUNURnpZWUNX?=
 =?utf-8?B?Qnorby9zSTVRckF6RUNoZVN4ODNIOFhadFJvR2thQ1RkNmkyZTV6MXVvK1Y2?=
 =?utf-8?B?NituNlhSSllsK1F1djZ1Z252M0IzS1ZKeVpyQjVaU0dXczhqMVFpU3BzcmE4?=
 =?utf-8?B?Q3dUVkQwempDSURnQTNPdWNMSzJGOHlNQ1E2ak1kWTRra21PTzV0dlZ6Ym4x?=
 =?utf-8?B?Y3lQTlhJTWJCd3E3QmlmYTBncXFrb2dMdGJkV21oKzhnLy9ua2JFYXJhNVNi?=
 =?utf-8?Q?tUpEpHMfDJHK8pST3FWME7AL5ibRN3eD?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eCKg/K58MmjnZBGwYZHlPkFUjySLZweQaSuiJLHx3+VsShGCBj/tY7sCaEVP5Q8t4+NNAJEl6oGOUpAT/ER6THhrYs1TKirqXOCBmPBKVPoHaVUPa3nqJLOJVqpgLJpgjMtd0sr+ADknBq1HGG9vlQiUcuScDTTIDi3qpmCEj0EbKQuC6PzTa1jXF/prSdE37F8wz6kG//ebho34xwbLEBmUKOaQVoZRP/viMsvChrfBtNdLgnwrGqWM6CHG0VJKYVkHrbIkkQ0PdhxAg8CKl24DVJnltslD/UiYpmr+w/AtHn+F0WAFrIQV+OTFvKeu2ay98jQXXBr2g/e9AzXpxjm7Bd7q8E2eVlqU6lJFW7IFysiv9rdf4w8UUr3GexGwORAe+KP0JwduhgvvF8cXXo2A7cEdFCfoyzgWS276nqf/TJnJcx7mAuFvhDnbl7hIXLuM5T8YRYxXbMMvK54Xeax00Bt32lApYTdvo67FJCjx9Ld6GD20opaXi1ggmj0YQXwTIqJCQ+uLA2bJfGm5ZoYNawRfIy6IQ0NcM7SC7UKLBY8qiyecA0qihDHrrY/alvM5G+ikyiQrIte8Izd19z+Z5IzZdFqN11hmeD8qJl1CyhpVjYegyUbXOKrLTDa1bM+KexzvjFCIEbKTsb4fBQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 14:56:53.1766
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c00660b-9ad8-4cf5-6a00-08dd1861b7e6
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000140.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR19MB6675
X-BESS-ID: 1733756217-111698-13393-4879-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.66.40
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVmZmBmZAVgZQMNkw2cIoxcDSNN
	nQyDjFzNLMNDHVLCkx1cLEGIjTjJVqYwHFTwIRQQAAAA==
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260997 [from 
	cloudscan18-0.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This prepares queueing and sending foreground requests through
io-uring.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev_uring.c   | 175 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h |   8 +++
 2 files changed, 183 insertions(+)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 60bcddec773d1cf3bbefc674fdbdfb7823b7fbc1..5767fb7a501ac7253aa8a598a1aba87b65da0898 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -26,6 +26,29 @@ bool fuse_uring_enabled(void)
 	return enable_uring;
 }
 
+struct fuse_uring_cmd_pdu {
+	struct fuse_ring_ent *ring_ent;
+};
+
+const struct fuse_iqueue_ops fuse_io_uring_ops;
+
+static void fuse_uring_cmd_set_ring_ent(struct io_uring_cmd *cmd,
+				      struct fuse_ring_ent *ring_ent)
+{
+	struct fuse_uring_cmd_pdu *pdu =
+		io_uring_cmd_to_pdu(cmd, struct fuse_uring_cmd_pdu);
+
+	pdu->ring_ent = ring_ent;
+}
+
+static struct fuse_ring_ent *fuse_uring_cmd_to_ring_ent(struct io_uring_cmd *cmd)
+{
+	struct fuse_uring_cmd_pdu *pdu =
+		io_uring_cmd_to_pdu(cmd, struct fuse_uring_cmd_pdu);
+
+	return pdu->ring_ent;
+}
+
 static void fuse_uring_req_end(struct fuse_ring_ent *ring_ent, bool set_err,
 			       int error)
 {
@@ -779,6 +802,31 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
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
@@ -787,10 +835,22 @@ static void _fuse_uring_register(struct fuse_ring_ent *ring_ent,
 				 unsigned int issue_flags)
 {
 	struct fuse_ring_queue *queue = ring_ent->queue;
+	struct fuse_ring *ring = queue->ring;
+	struct fuse_conn *fc = ring->fc;
+	struct fuse_iqueue *fiq = &fc->iq;
 
 	spin_lock(&queue->lock);
 	fuse_uring_ent_avail(ring_ent, queue);
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
@@ -974,3 +1034,118 @@ int __maybe_unused fuse_uring_cmd(struct io_uring_cmd *cmd,
 
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
+	struct fuse_ring_ent *ring_ent = fuse_uring_cmd_to_ring_ent(cmd);
+	struct fuse_ring_queue *queue = ring_ent->queue;
+	int err;
+
+	if (unlikely(issue_flags & IO_URING_F_TASK_DEAD)) {
+		err = -ECANCELED;
+		goto terminating;
+	}
+
+	err = fuse_uring_prepare_send(ring_ent);
+	if (err)
+		goto err;
+
+terminating:
+	spin_lock(&queue->lock);
+	ring_ent->state = FRRS_USERSPACE;
+	list_move(&ring_ent->list, &queue->ent_in_userspace);
+	spin_unlock(&queue->lock);
+	io_uring_cmd_done(cmd, err, 0, issue_flags);
+	return;
+err:
+	fuse_uring_next_fuse_req(ring_ent, queue, issue_flags);
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
+
+	spin_lock(&queue->lock);
+	err = -ENOTCONN;
+	if (unlikely(queue->stopped))
+		goto err_unlock;
+
+	ring_ent = list_first_entry_or_null(&queue->ent_avail_queue,
+					    struct fuse_ring_ent, list);
+	if (ring_ent)
+		fuse_uring_add_req_to_ring_ent(ring_ent, req);
+	else
+		list_add_tail(&req->list, &queue->fuse_req_queue);
+	spin_unlock(&queue->lock);
+
+	if (ring_ent) {
+		struct io_uring_cmd *cmd = ring_ent->cmd;
+
+		err = -EIO;
+		if (WARN_ON_ONCE(ring_ent->state != FRRS_FUSE_REQ))
+			goto err;
+
+		fuse_uring_cmd_set_ring_ent(cmd, ring_ent);
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
index 392894d7b6fb15472d72945150517a9f0a029253..bea4fd1532083b98dc04ba65c9a6cae2d7e36714 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -122,6 +122,8 @@ struct fuse_ring {
 	unsigned long teardown_time;
 
 	atomic_t queue_refs;
+
+	bool ready;
 };
 
 bool fuse_uring_enabled(void);
@@ -129,6 +131,7 @@ void fuse_uring_destruct(struct fuse_conn *fc);
 void fuse_uring_stop_queues(struct fuse_ring *ring);
 void fuse_uring_abort_end_requests(struct fuse_ring *ring);
 int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
+void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req);
 
 static inline void fuse_uring_abort(struct fuse_conn *fc)
 {
@@ -152,6 +155,11 @@ static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
 			   atomic_read(&ring->queue_refs) == 0);
 }
 
+static inline bool fuse_uring_ready(struct fuse_conn *fc)
+{
+	return fc->ring && fc->ring->ready;
+}
+
 #else /* CONFIG_FUSE_IO_URING */
 
 struct fuse_ring;

-- 
2.43.0


