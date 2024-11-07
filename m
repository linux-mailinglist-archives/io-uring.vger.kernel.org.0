Return-Path: <io-uring+bounces-4551-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 42E479C0D13
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 18:38:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C73AD1F24112
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 17:38:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B17A121620A;
	Thu,  7 Nov 2024 17:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="HLzAnvnc"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE930191F6A;
	Thu,  7 Nov 2024 17:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731001104; cv=fail; b=mvjUEr6nb1rfT0D71dZJpRYD+hm4RDnbLEobH/zSUEgVyLkTKRujE1OurpmqqCENmwrUTEdpFnC6hBl05pVgaeejSEBE7pOclZvGaVEwhF5HZPcmxEvzHyGW3pB0oaiwNGllV/JQ4EmiIrsRNYc4ElmPnPjsemLd0IOL+CN/RqE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731001104; c=relaxed/simple;
	bh=qp3XmdsI95RnpqhMvcQU6Y6BK+0DGMicc5TzsLF6qBE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gwpeDF30XFfTzU9sW7A17Wl8InzaRdXSWcIp3QGSJFuYDVhVucVsK2PPeq43WP80QM4nDwMS2e9cBhsTeVZU9AOUGQSXxc4WCt24wvPjiZCstcvJt6fvagOEisQoq//6TDdFmAviMxFEHL4G6raoGQ2PiieITx+TWIcvwbHStgc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=HLzAnvnc; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42]) by mx-outbound-ea15-210.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 07 Nov 2024 17:38:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IjapuIfAlLah4nyqs/n7NKsWSrOHLllLZNr1abqckID1baybjNcZShfQaVToj0tHQ1jbSTQQ9A/C/oLpVxKAXufqRgDME1G8sbQ6C0o8ZwxDsB5OH/Nn4uCxqOoQpahWd4UZ5z6ykBtKMPJa+zcECzrB5DVdbwNnNef7zqgDc1C3q/+cjn9uuTRJlJAYJTrW4++lZi8PJJS5CURC0xN5AS1YdFZn2X3RjEPZHTvJElv8NAdN7wbiROh18egCtwsqeOpVjpX/VfbQWBxSKADOBTl3ep2bXTzQgdUZnXPBuou4vcahvbx5ygGDHQc4vLGdIb8hd2BK30HcnI2jwPgHLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/oNa4TMLLXFZIwEaJyUIRnKy/4MYwHse8Yj0xKhVyRI=;
 b=SxpKiO5sR1yfXBdPfo3w6JKw7RnTo5MaEgN4lYF9Cza/qU1sIBPmmrsmzo9P327C+vIoG+P0Rex28AEt+Lhe13brC+DnKW+43FS4mjeMmMqXsrG9F97nc02gFFQgE077YUgRxzbHg7XV2pJK+hgkl/z6N18eG7+Ur+qVmea1KWK/xMKs1aFYDKLsvaJm9mRx9LIrMnNdxQpoJTrNX+hS/1fzgfApJyUpNkyCjy+SUYLVDl3VdY4VSXU9+XMvh5VRR3ku1WwNOaxCE3SXtNXrtl7sWxRe8rZi0WW0b5mI45X+PwAkZ19A3/WqIMeclvm8MwFFh1fsxj837zL/r+lcRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/oNa4TMLLXFZIwEaJyUIRnKy/4MYwHse8Yj0xKhVyRI=;
 b=HLzAnvncUScne/fb7Rry8IpMTnjTv8rbcaxYJq8pe0Y9lIQ04Vqvu7TvUrBzKyjzs1hxy+WYij5NLqPtYjNmJqA/4dvKWUWO6L6M4fFBeDv7LnoK9Z2y9lp3TG4+fw4fmcRq5uhHgiQTYHDByKUM3wzy4xGqwtcYW6pyHHJad5Y=
Received: from BYAPR01CA0007.prod.exchangelabs.com (2603:10b6:a02:80::20) by
 DS0PR19MB8749.namprd19.prod.outlook.com (2603:10b6:8:1ff::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.19; Thu, 7 Nov 2024 17:04:13 +0000
Received: from CO1PEPF000044F1.namprd05.prod.outlook.com
 (2603:10b6:a02:80:cafe::32) by BYAPR01CA0007.outlook.office365.com
 (2603:10b6:a02:80::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18 via Frontend
 Transport; Thu, 7 Nov 2024 17:04:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CO1PEPF000044F1.mail.protection.outlook.com (10.167.241.71) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8137.17
 via Frontend Transport; Thu, 7 Nov 2024 17:04:13 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 49B2B7D;
	Thu,  7 Nov 2024 17:04:12 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 07 Nov 2024 18:03:46 +0100
Subject: [PATCH RFC v5 02/16] fuse: Move fuse_get_dev to header file
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-fuse-uring-for-6-10-rfc4-v5-2-e8660a991499@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730999049; l=1579;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=qp3XmdsI95RnpqhMvcQU6Y6BK+0DGMicc5TzsLF6qBE=;
 b=WdtX6jvPrGXeH0CIEnqyxYhzp7DmDXXoviz+bR8tnWYLjEbkzO7pVmUtG/njrwOazjvbM+N/J
 JBv502HOGnfApFznfFY3YqAqscVOOH8onD0CznZ3Y5Yn5wn7WSeNQmg
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F1:EE_|DS0PR19MB8749:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b2638c8-6d06-4079-9c87-08dcff4e3466
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T3BMaTRoMFJnWjAxNVpYYit6eEVETVRYV3piMlJ1VWZKSGVtTmJWelZXZGw5?=
 =?utf-8?B?S0hEOVdHT0V4cDRCSGxQRDVrdng4QTUyRi9SL3o5RUFvTzQwVk9hWWJRRjJE?=
 =?utf-8?B?ZVptNi9wZXpuSjlrQmxBWDhxSER2R0xkVlZ4UFErdzRLSFFQR09CZi9RSjZY?=
 =?utf-8?B?ZXYvTlo1R3hKVmVPQ2taZHh3cHdUMEhCWCtRcHhVeEN0RlZHOE13VE9kZCtr?=
 =?utf-8?B?VVYyemJLUm5FL2NiY3MzaWhKVmttUjlndjRjSGpmeVBrTzA1OHR5dE5SaHdQ?=
 =?utf-8?B?cVpUNTZFZ0ZacEZ3dmsxd0lPM1UrQUtnZFRHZWZ1dmNHRUN5elRDTjBLOEtK?=
 =?utf-8?B?VFczZG1aaEJIaU9uUzRHQWpEM2JrN29lZmJvNktJNEc0RGxRbjZXcWNaYzZk?=
 =?utf-8?B?VXNzRjFQL3MyZ2grenFsa2QwRDhCcmlWRkw2cFNEY1FDS3ZSckQzekFaelV3?=
 =?utf-8?B?emRSL0RySjA0N2w3Y1R4bUtGVVFnb21rZEhrNWcxb1Fhdys3OFhhTDFTOHZK?=
 =?utf-8?B?eHBRWU9mR2cvc2JPRTVKVndXYWFadUZiS1dDaFBKeGhKMWlEcFlDN0dhb3Y2?=
 =?utf-8?B?Yzd3WVlUbEhqWm9LL0dIajJsM0wxU2YvNy9RYmVqVzRkMG9SeSthRGZGb0NR?=
 =?utf-8?B?eGFTMmlwZ3FRVGVZREZEOG5pZCswdjRDQVpjL3NMaWVLQjdvUGpyQTZhQWhp?=
 =?utf-8?B?a3E4eWY4aVJIUTJwQjFJMGpwVTBRUXErb0hJcUZjUEgrSURCeE1UcU92dktZ?=
 =?utf-8?B?Vy9oMHRncVYrMW1HUmttWUJoUW1waG9xdkFlQjE5RmVHdTRVdnJ4NG1Hd212?=
 =?utf-8?B?ckVmdXJFUk9ieHAybUY3Nk9kdVl4Szk5alUvSDFSdW9nVTY1SkFxNGJKaWVZ?=
 =?utf-8?B?TUFRYmQwMm5ZcC9ZSnpyZkNWeU16T1BVTDJwWmxEVFdTTlZ3Q1VPQWlHenRH?=
 =?utf-8?B?bStBQ1U4N2wyQXdWNmxCOWw5U2U4UGhLUi9Ed0RwYko1Z1hycERqMW1KS25U?=
 =?utf-8?B?SEtnamdHS2FkTHBrcTV6WEZmK2MxQjZOVUJpaE5EU25OWWU5bG1jTkYwSWZH?=
 =?utf-8?B?YmtMdTZzT1NJb0ZpVEtqUVVoSk16WHRmRHlLS1p6R0J4R1FLbWpsS1d5MjdS?=
 =?utf-8?B?b3d0d3FSNzR0T2ZDRTF6SDYzNEhCemE2dWJnOXFhZ3dTa00vUDB6T0hTWjhm?=
 =?utf-8?B?ekFvSWQrbWZTRi9nSTNJYUZOQWpkY2RYY3VTd2RHcUdTZGZOcElwbS9Gb2hz?=
 =?utf-8?B?UWZTKzRpTHA5K2pMM1NRblFLZEI5aTFYZTQrbWRDYkh1aG13amd4QlhhYkln?=
 =?utf-8?B?YloxQXBraSt0Q3NnbkJ0UjBFTXFPZ1Q1bmhrTlNFb1hjQndmc1Q0Q3VtOHgv?=
 =?utf-8?B?UkM5akd1TmlnZkp2UzI3bnlMV25LclRhVlRNbWU4a0kzWFNocFVLSnFvUHV6?=
 =?utf-8?B?MnRCV09OdkVtSTNGS21hc29FWVpDRmx0aDAwdXFiQmFmK2NuTmZHc011YlUy?=
 =?utf-8?B?WjFLbVByRlBESVZ3Q0IwWDNMNmJwN0Nwd1p0WWdmTUpFV3h1QStqWks4SzFP?=
 =?utf-8?B?a3pyZWsrdThoVWs0ZUd0VjExb0dTL0I1Q1FmTHlQVlQ3cXVTeitodmROUm1s?=
 =?utf-8?B?a2hKK3IyVlY3NTQvWm9uZ3JOVSs3c3h6UEQ2dzN6L000MUkzSjVWS09qejJU?=
 =?utf-8?B?VGFwOTlMcnJNaUNTcHNQSWJUajh3V3BHdU95QTlGWjVYR25sUWtPYjF5NGxq?=
 =?utf-8?B?QkE1cWV3S2FQWXZrb3JlbWpKZFpmVzJ1UUhvZm1PVjFWRzRFM2VlZlRQUk9q?=
 =?utf-8?B?MlJvbFhUbTJTL1VsMVAzL3cvdkRRSm94VkZFT05NV00zVmFtbTNvOWE3V2tF?=
 =?utf-8?B?WFY1aFZLWW1VUVY2Z3Q5VUlvUWgzMlFDeCtWNytSS0dua2c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LPY/WRhrkQyVpVww5HnsmUwo5CEuvpPhr/CqhEvarDlg03VYIJieP+U9XsAXJbOhexB6IOY/YPY0Q3Kwb7xmXYHrpMivkL0ZaWJ9owB+sLeq64ivbOy73dzQyjz4hApdPcI9w2sqkASRTts/ELQPAgHhPpCn1WPiPYS8edTIr0fCbtjNnRpjCjhDEYqyvM0Ltqr+PyRqvC3GLCe95ayNsNse/y1KRsPl5VXHL0NVKhS0zKphOOm65cdoAnjS/vvb7n1gMOEVK5K4xHc3ftQDIlzzRBg2cQ8FBl/Wq/G4Iv3et+5ntJxUG/z/Ogwhv+T148KE+pV4MC0nX2GA48+M1dL7ILzd8ZRXqbSGlKm37Bo6mN0vCFt3DpZWQ+itYDJBhBT3PBCBwzfVeORToVLU+QnBrD5GP0H2vDf7R7/K9S82ZNOR2pUvZnMYoBxWS5MuIzDsFdxKna4MlyTvI6W74RaKyJpEwkgzflayBzX7sBxqH8bmKSAx+F5UDK2gunZjB7f4QSBZhuEuBh0Ej1bhBZGTGPObGBKHamDcOgCl4yxd+yJQz96fQdVegEG+JUCllGr3c7cOK15BeRNKXIETiiE9SCB4j7SNxqBUx0GcvAMsUVu8aSFWjQvklHPG/u3kIOKKd7rS3+Ed0aERCclNcA==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 17:04:13.0502
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b2638c8-6d06-4079-9c87-08dcff4e3466
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR19MB8749
X-OriginatorOrg: ddn.com
X-BESS-ID: 1731001095-104050-19924-4508-1
X-BESS-VER: 2019.3_20241105.1723
X-BESS-Apparent-Source-IP: 104.47.66.42
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoamRuZAVgZQ0NzY2DzZLNUyyS
	DV3CIpNdk8NdEixSwxxdjSNMXE3CBRqTYWAE+IqGRBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260269 [from 
	cloudscan20-190.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Another preparation patch, as this function will be needed by
fuse/dev.c and fuse/dev_uring.c.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/fuse/dev.c        | 9 ---------
 fs/fuse/fuse_dev_i.h | 9 +++++++++
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 74cb9ae900525890543e0d79a5a89e5d43d31c9c..9ac69fd2cead0d1fe062dc3405a7dedcd1d36691 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -32,15 +32,6 @@ MODULE_ALIAS("devname:fuse");
 
 static struct kmem_cache *fuse_req_cachep;
 
-static struct fuse_dev *fuse_get_dev(struct file *file)
-{
-	/*
-	 * Lockless access is OK, because file->private data is set
-	 * once during mount and is valid until the file is released.
-	 */
-	return READ_ONCE(file->private_data);
-}
-
 static void fuse_request_init(struct fuse_mount *fm, struct fuse_req *req)
 {
 	INIT_LIST_HEAD(&req->list);
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 5a1b8a2775d84274abee46eabb3000345b2d9da0..b38e67b3f889f3fa08f7279e3309cde908527146 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -8,6 +8,15 @@
 
 #include <linux/types.h>
 
+static inline struct fuse_dev *fuse_get_dev(struct file *file)
+{
+	/*
+	 * Lockless access is OK, because file->private data is set
+	 * once during mount and is valid until the file is released.
+	 */
+	return READ_ONCE(file->private_data);
+}
+
 void fuse_dev_end_requests(struct list_head *head);
 
 #endif

-- 
2.43.0


