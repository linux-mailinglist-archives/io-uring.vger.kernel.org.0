Return-Path: <io-uring+bounces-5323-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 731479E99AE
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 15:59:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3EC29161ED9
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 14:59:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6217F1F0E56;
	Mon,  9 Dec 2024 14:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="MeVyT3xF"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0804E1B4251;
	Mon,  9 Dec 2024 14:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733756225; cv=fail; b=rKoE2Y4CPxcHo93ytWRZmngjZsR4LBE+oh7f0qqmnQhd5WRHOo7qA0A0TE3EHbieB/d6ZOcPjz9BqOI0jmCRpFySlxqEWQdXGibwk7tT+yJYQfTt1gt/WbvYnVGh3HMgadChB/DtvUW0NoGSwnFKExlOGiiwafsr40Mm/g+hvIk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733756225; c=relaxed/simple;
	bh=M3GcQWwOaa8BbwZh7SUIGaTx+lkvQ0F1YCuEjX2dKV0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=C4X+RFX1rYcs1IpRvu7DX6WjQeBNuhlYI78E51ktarGIstAco9YKYCto5sXuv7rTVNBWXRQIsVkdFUeftSTC5r+cYSldjFBPwqbzdADmg4GMKArjVTCoFWXMauYS3zx0ecn5SmhYgZVECwsrO/Bg54gzkWJR8Au1NJ3N1D0p4is=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=MeVyT3xF; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2044.outbound.protection.outlook.com [104.47.70.44]) by mx-outbound19-133.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 09 Dec 2024 14:56:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OOd033/4MsM30aGmYdBu1PtVYZBACEdDXg1QPNe4koHmLAwp10CSvOT1MUsWe9alZZgdecIu3tCKmEUW39oO1/TBR0ytGHJyH8UiFnEx6b1iAjXrKG79bjEIqqBC61ILAcHxcZibH5UGxxXY9lDN09sfalFRARQWjKc3dziwA3ZFbZTFVN+4PuWkEW4rGt4U5PgyOgEqSUVSrLPJ9xgaNS6EpgDESkZt210Vo0tLHNbZ7gIDaD+i6iqfWXZJ6vw86uWQRuWeepo2rzGwZHsWuSB4DtjePauesYw+MSCAjcrdwK/a0HaUsctPqyyv55nuAZSVvQpVA1od2xeGxF1vCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OHfDcEdVZVOJHvupseE7n5zjDtvZEF9X34YNo8Rsf3U=;
 b=oDI+TgQKF2z9Gv4sC8bbQN3kZ0XF487zLTLucEDXWNxdM2ydHqYZ8BQLMDPj9ph7nsX6x/xllFFZDbAf/oOFn9yZyXxMVbdCfQ75WyzmaeMH8fu9p3tffVT+1O39XPeldvzj4OMH+nGV6yXuSGAxsyY91pjCJsE6/1xm/gquQoyNpxcbU+T16TVeGKvz97DNihU5h/ta+TfmNNmi1o2vm4f86DGV556Kvk8/tCo9MEj41hwY2GFaBwCBxChDStT1edqZgz+scIsnOB7si14JAjVdFkPHKLMERe7x4CHuCnCZz9K2gZiCg0UTei0Ueo40SFoz/emFusUpEABSodHxcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHfDcEdVZVOJHvupseE7n5zjDtvZEF9X34YNo8Rsf3U=;
 b=MeVyT3xFso6RNgb2fRszVtzGFY6NoJi0g7JAWnS5b7Jiw48+4nxdia66mTpCHbscjKDoUFpwZwwvkloY6lG/mAj6gzZHuEh2Nt+4byKTSILWn5+f6zPWc1rgemSVBzQAW1YnGMvgb2Wkgz+XZQzRClHer4fV/xZJR9lo23aqT/c=
Received: from MW4PR04CA0210.namprd04.prod.outlook.com (2603:10b6:303:86::35)
 by BLAPR19MB4292.namprd19.prod.outlook.com (2603:10b6:208:254::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.12; Mon, 9 Dec
 2024 14:56:42 +0000
Received: from MWH0EPF000989EA.namprd02.prod.outlook.com
 (2603:10b6:303:86:cafe::45) by MW4PR04CA0210.outlook.office365.com
 (2603:10b6:303:86::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.15 via Frontend Transport; Mon,
 9 Dec 2024 14:56:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 MWH0EPF000989EA.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.7
 via Frontend Transport; Mon, 9 Dec 2024 14:56:41 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id B954455;
	Mon,  9 Dec 2024 14:56:40 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 09 Dec 2024 15:56:23 +0100
Subject: [PATCH v8 01/16] fuse: rename to fuse_dev_end_requests and make
 non-static
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241209-fuse-uring-for-6-10-rfc4-v8-1-d9f9f2642be3@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733756199; l=2781;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=M3GcQWwOaa8BbwZh7SUIGaTx+lkvQ0F1YCuEjX2dKV0=;
 b=uXt/u269srlQTUf3vf3DEX68VGyc873fLpAYiFAYU0oERCz6HLt08hDfN32UFc0C86bFj7Bon
 BkhYB51G6ihBnQ4//TFezUVC4tdJtmU+3rYU8fV2DmEPUEdH3JoLMSL
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989EA:EE_|BLAPR19MB4292:EE_
X-MS-Office365-Filtering-Correlation-Id: 25f3a080-a420-483a-725a-08dd1861b0f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bWRZVkxtWlQ3YW9DUmpweHV1YW1MT3F3QTNVYVNXalhSMnQ5TllZR2FHbnJ1?=
 =?utf-8?B?K2Z4Mi9wS2UvcXBBK3RCM1hJaTIrcklUY2xNQ09HQzJJWVNaVnpSZHhCOUI2?=
 =?utf-8?B?M0ZGa3hycitIOUgxZWtiY0FxUUFBQ0FwY2sweHJkS0hDMy9HOCtCWGxqVUtM?=
 =?utf-8?B?bG9oY2d4ckFnL0psMHcydmJld0Z3cERmMG05Q25wTkVabWh1WkVGYzQwM05H?=
 =?utf-8?B?a2VBTEJYNlBLakttRUdkY2FPbWl3L2hKU21hcHFEekNZZWpkUGE4K2thdW03?=
 =?utf-8?B?Y2RVa1NaV2xWMVRUakM5dEQ0TDRsU2lDdUN0aTk3MklvRFB4Z29oL2VkTG9G?=
 =?utf-8?B?UmRPc2hkdERjcktnNlFzQzNjKzMwYkwxN05vaENFWlpTTGVtVkxxQjVEZEg3?=
 =?utf-8?B?RFlKaUVOZ3N1djZjU2hOSWNpZFZST1JreHpPTTdBejl2bGVTMENoek5mOER3?=
 =?utf-8?B?LysvSUxwQkNEVEZtelZ4aU9aYVFCWTRQK2JNK3huVG9BemNVWFQ3L0t1enBp?=
 =?utf-8?B?dmVoSzR3L1grNTdORUt5RXd1NjZxVVRNTzM0Y3lvUElYVE5QK3hWM3YvWGxE?=
 =?utf-8?B?Ti9mcVVibzZaTkpibXR2RFJFVmdsVG5ILzFIR2VieWgxeEVLRU1TRDBuOU1a?=
 =?utf-8?B?bTVMZmxNOWU2ZkZiVmd6WUM3VFZlY1YrcXZWT3dwVWZxaU0zMWNoeDY0cGJy?=
 =?utf-8?B?cjI5dU4vMnBmTUFBQ0pDZ3UrUXB3NHRta2I0VzQvQ3R4a1FUQ0VLYXNZNUNm?=
 =?utf-8?B?ZnNKaFBvcWhHTHRZdGMveW4xaWJLdUpjVVNtZ3dGRnNYNzFmTnVkRzJJY2ZC?=
 =?utf-8?B?V2wzK1Q2RnBxRVExQlk0VXF6cGNIeW5uMGkxZ3JzcElySjQ1UTM0cit5ZXZh?=
 =?utf-8?B?ellWSzVjaDk5NFNKZHorYVZ5a1NQdjJHcHFnK2QrVnVjTXFMWTFCQlVCWDBM?=
 =?utf-8?B?dGJHRFRDdkdtVlFvZjEzUFEwZkI1dmNuRzlCcHBQNlRNVFdpRUFta2N4M2lO?=
 =?utf-8?B?RTNuUkJMVmJlNWxIb1dvdjk2TjI2T2F3KzBVNkl5TVBrbGZZYk1maWE5SVVX?=
 =?utf-8?B?VENJaFhrbVhhemxhSmpaK25MeGk5ZUkwOFlqbFNtd3F5RjBRY1dSdEdjNmk3?=
 =?utf-8?B?ZFFWVjZDVlBXcEoyaTF5L2tnV3ExeXdJNnJvNGE0blRObU1ESFc1NXQ1c0sx?=
 =?utf-8?B?eGVMWVZiNS9tS3pKcDh3aVp3SWg2eGZEcWZvS3ROZUoxYWYvTm5pVzdURTJG?=
 =?utf-8?B?NnQrYk5WeS9LbjI4MmFzR3p0ek5DMkNrMGMrVzhvbDFPUnNjdENRNldWVGpI?=
 =?utf-8?B?aC9iNWhHYzBXOVgvL05qMUFzTUd3Nk5JVE5BZk84OGI0NlBUeWFtemJBNWJC?=
 =?utf-8?B?U25sUXN4NDlFNTh4SHZ4OEo1RmdyNlJ5RS85ekhrT2ZtRHhxUTB6b3U3OUhK?=
 =?utf-8?B?RHp2U3VWU2YrN2ovZXFES01CK3VPenFaQW9RTXY4Tm5WMitURk9kZmxYZXcz?=
 =?utf-8?B?ejIwdEoxdzMwbmFLcXpiZkVsV3pqUmQ3UjN6VUd5YmJFRGdmNnpMZS9hVTlT?=
 =?utf-8?B?YVY0VHZiRkU1dzhQSjFIVmVoOGZRNG9SSklQWDRXNXdTZlFYWHJtQmNvd05E?=
 =?utf-8?B?QytmbEVSaU5BQnB2L3ZPS0Q3MkY4YTg5Q2ZhR3NoTThaTmdlWk82c2R3THpV?=
 =?utf-8?B?UG5aK0N0azdKNjVEUURQWUtjUUpxT3JpRS9DdmNCTUZOdDBZR0JxdzRsT013?=
 =?utf-8?B?VmFqMlJBNzRPMDVYcGdqaW4yTEVmTTI1Y2w3VGtrQ2lIam8xRE1rUWxaVnVy?=
 =?utf-8?B?SXpyUU9DR1c0MWlqZkI4SjZydC9McFNxUzFIY1pibEtTT1RvVHZCNXZna1pm?=
 =?utf-8?B?QjdzOVVBUVBHWXNCbHlTb0l1TXhmSWNocnd2Y0xTQlhOc0o1aU9ZUVY5K2kz?=
 =?utf-8?Q?wiC51uJhEU8lBsvDEndw57BEQxj7OwzR?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sWl2Mx/iDZR+cW4tEUOdLQvZRPrUKX2k+hKfX4XFfjiFHz6xhXETvtevk5pg+VwcVlpiFlYq1F5AelMSUKwGyLPN1Q60qOv974/obmOdnTpAI/XKoaBsmRUwatLaSqbnigo0aCZERsl+75Q545yvYUaXinterNoMhi81XbnIMP0mhBlbfmt+uXnz21ZVrKew5hz7WEyHzqkEImtBkzMes8omXu+MB5uRs5fU9ek0UCEuu9ehlNEtCt5iG+c/oeocYHIzPsD9vG6z3NqxNAWaWo2WLRHsm0y/AEgJBD6Kl4TX17TyBj0wJ3RNNF+qbiuP98sE8fVYGUEaBuT8/aBXVVUPr0pK8iZMt3+bQuWfFWRcqTA333z5TAwyp2rV4bcFTH6Nkllc9jCPwtPo3Wz+ZDx4sSJSxLTuwlUaMbGiJzagP5E2kACSvFz4t5lAj3xCUOCVaMPKV7D9lZ3fG6OCh73wsEDsU8d/7O361f2xWzlyBryD4wLy4CcNXIo43gE/UmFsg8dpbHY6Yg1Dzde8ann6tzRNr/qQvNgzLGPCCtIr53fXiyfRMHOlAxEwsN82ipqYg0aGO4dxwsgZUU6Vq5QCtYy+I8AGOPhxKpAwC0CM/YdPeU3Dsq8XSpNCLYOZw+l8Cs/XrqnBx4A7oHM0bw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 14:56:41.5114
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 25f3a080-a420-483a-725a-08dd1861b0f2
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989EA.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR19MB4292
X-BESS-ID: 1733756204-104997-13364-6650-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.70.44
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkZmlgZAVgZQ0CjJLNncItHAwC
	Q5ydLcNM0wzczYJMXIOCUxKck42SBJqTYWANiVMFtBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260997 [from 
	cloudscan16-51.us-east-2b.ess.aws.cudaops.com]
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
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dev.c        | 11 +++++------
 fs/fuse/fuse_dev_i.h | 14 ++++++++++++++
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 27ccae63495d14ea339aa6c8da63d0ac44fc8885..757f2c797d68aa217c0e120f6f16e4a24808ecae 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -7,6 +7,7 @@
 */
 
 #include "fuse_i.h"
+#include "fuse_dev_i.h"
 
 #include <linux/init.h>
 #include <linux/module.h>
@@ -34,8 +35,6 @@ MODULE_ALIAS("devname:fuse");
 
 static struct kmem_cache *fuse_req_cachep;
 
-static void end_requests(struct list_head *head);
-
 static struct fuse_dev *fuse_get_dev(struct file *file)
 {
 	/*
@@ -1885,7 +1884,7 @@ static void fuse_resend(struct fuse_conn *fc)
 		spin_unlock(&fiq->lock);
 		list_for_each_entry(req, &to_queue, list)
 			clear_bit(FR_PENDING, &req->flags);
-		end_requests(&to_queue);
+		fuse_dev_end_requests(&to_queue);
 		return;
 	}
 	/* iq and pq requests are both oldest to newest */
@@ -2204,7 +2203,7 @@ static __poll_t fuse_dev_poll(struct file *file, poll_table *wait)
 }
 
 /* Abort all requests on the given list (pending or processing) */
-static void end_requests(struct list_head *head)
+void fuse_dev_end_requests(struct list_head *head)
 {
 	while (!list_empty(head)) {
 		struct fuse_req *req;
@@ -2307,7 +2306,7 @@ void fuse_abort_conn(struct fuse_conn *fc)
 		wake_up_all(&fc->blocked_waitq);
 		spin_unlock(&fc->lock);
 
-		end_requests(&to_end);
+		fuse_dev_end_requests(&to_end);
 	} else {
 		spin_unlock(&fc->lock);
 	}
@@ -2337,7 +2336,7 @@ int fuse_dev_release(struct inode *inode, struct file *file)
 			list_splice_init(&fpq->processing[i], &to_end);
 		spin_unlock(&fpq->lock);
 
-		end_requests(&to_end);
+		fuse_dev_end_requests(&to_end);
 
 		/* Are we the last open device? */
 		if (atomic_dec_and_test(&fc->dev_count)) {
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
new file mode 100644
index 0000000000000000000000000000000000000000..4fcff2223fa60fbfb844a3f8e1252a523c4c01af
--- /dev/null
+++ b/fs/fuse/fuse_dev_i.h
@@ -0,0 +1,14 @@
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

-- 
2.43.0


