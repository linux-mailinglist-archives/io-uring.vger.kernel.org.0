Return-Path: <io-uring+bounces-10088-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AF4BBF8B82
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 22:31:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 662DB18A5AC5
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 20:32:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32AE320468E;
	Tue, 21 Oct 2025 20:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="XivLEcEK"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2031D61B7;
	Tue, 21 Oct 2025 20:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761078705; cv=fail; b=ARDZNuAOXBMprJuVyfyJwpbGhmq61afWA5sieDhis99gNxr+hu0wA50y4AsCu9ZCLqog+TBE54Tv8eRcxTG6i+Z+DCYPfDBnptYnWiKDBJWykeSlZ5LNP7Qx9AUQD0fgB83NcP4BIhUlpaJUUvGjj8emaB3AVZ+yzc5tCBTfwIM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761078705; c=relaxed/simple;
	bh=snu0btEFYl1YGL3kcqLILGCBCXnsNCwtMMopkX8KWu0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Pz9pxvbPd7ja9Xk5EGRykcZ9Zzs9bPVnBzZGQpIofRuqpwLoHn8YRVr9hTg+HWZzm873Y5cJI1JRe3AOhjxfjW0IvYTOylQ9YD/eeqMRTx0+mX6FObd2qqwLcv9PmGv3prQ+EE0sQoEyvbXGyWjo95VaOnlDGPxCtXDm3CuGbtc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=XivLEcEK; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11020110.outbound.protection.outlook.com [52.101.85.110]) by mx-outbound40-133.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Tue, 21 Oct 2025 20:31:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uXAr0NPI9NuUQldC6GuhzqFQqLDcVD5olBWigxbuavzxVfyd319bqfQm+iINyrGTg1t41mIBFGKvHh70sKzMkslEIJufTdAGLgbEf1Fz8JqfS3yXCs0VfcYS5vHVoT/m6NYTCWT1Wir1dc9kGR7EFfNrY2jhDR7r4rvUEx3Fqy6vyNIcczSkxpJM/fM9pIK0jKICUfijz+dLArWuerwjnG/M9N/6PBfAQLy7Z4hbaJtH43eE1Ci98KYBX+z1+7h1qNxaqm2VY8e+85RcCEwum8mX6QMMTkjO3T1XL4nh97ywmAAsF9Pts44rjWENO6upklhhwPcJieftGs8LVQ5nGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FFQ9d3CCt3WkoQf8aibTcLPKC6G3eAgcENZBzRV1uhQ=;
 b=gBbNvrX9kHdG1OYki+vAnlv3l9O52rmuvv5bHDwb5GJ2EuLtY839gvm+V+c2JDmDGr3JzNIy+AKf0Xim+ma28JWXbuiVrQyolBgg/1GYpgMLBf4V+I9IwSrsGPfscZ8D/3+Z1RyxeuXlezFlqK4DYiqD1baZQ6Dw8hUkhkRbanMpwe5lt2Yit04vDa42AAGMiLloxFRoUkOmgQ6YZpnNKiKPpxRiFJB2zh+Z2ldE70jZh/75gxr9KrC2M+m68Utdj/ad0Zwk5qBDRnIsLkEqIF1G4xCyHuG0Zhm48QiCNq8frIlAUG3qLK1B0Ic4d66o664X6dUvJNOEezOlAcC79w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FFQ9d3CCt3WkoQf8aibTcLPKC6G3eAgcENZBzRV1uhQ=;
 b=XivLEcEKsAzmQ5ha30dfO2V7KGV82Gv80X/N4gsPGIHIyQLBPIpo3DHiOcrQxpdIofuouOlUk8SUVF5K8YEzXfmCLRheEkNdvqbZHt5vJ8MfPceseFTrfj9G7UBtjXFER0ysp6jlUKeVHUCkbqvaMzQalCo67KMleR/brHAxo40=
Received: from SA1P222CA0052.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:2d0::28)
 by DS3PR19MB9295.namprd19.prod.outlook.com (2603:10b6:8:2dc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Tue, 21 Oct
 2025 20:31:27 +0000
Received: from SA2PEPF00003AEA.namprd02.prod.outlook.com
 (2603:10b6:806:2d0:cafe::20) by SA1P222CA0052.outlook.office365.com
 (2603:10b6:806:2d0::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.12 via Frontend Transport; Tue,
 21 Oct 2025 20:31:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SA2PEPF00003AEA.mail.protection.outlook.com (10.167.248.10) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.7
 via Frontend Transport; Tue, 21 Oct 2025 20:31:27 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id ECF024C;
	Tue, 21 Oct 2025 20:31:26 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Tue, 21 Oct 2025 22:31:25 +0200
Subject: [PATCH RFC] fuse: check if system-wide io_uring is enabled
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251021-io-uring-fix-check-systemwide-io-uring-enable-v1-1-01d4b4a8ef4f@ddn.com>
X-B4-Tracking: v=1; b=H4sIAJzt92gC/0WNSwqDQBAFryK9TsNMg4jZBnKAbIMLHZ/aJBnDd
 L6Id3fIJsviUa8WMiSF0b5YKOGlpnPM4HcFhamNI1j7zCROSu/Es878TBpHHvTDYUK4sH3tgdt
 be/xXxLa7ggepHaqyg0hN+fOekL1f70yn44Gadd0AZHUHR4QAAAA=
X-Change-ID: 20251021-io-uring-fix-check-systemwide-io-uring-enable-f290e75be229
To: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Pavel Begunkov <asml.silence@gmail.com>, 
 Joanne Koong <joannelkoong@gmail.com>, Luis Henriques <luis@igalia.com>, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761078686; l=6127;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=snu0btEFYl1YGL3kcqLILGCBCXnsNCwtMMopkX8KWu0=;
 b=YLMSjkaKlbaP7lkqiCCnl5sQzA7k7k7Jw9GDjzfgTpr9mxQnXeL++TP8fV2Afp4GoNqRE6Y/+
 IRfBAoIOprcDXljvAbyObskXa1Y4Lh/RmdjHlk3zTVVtI6+MxGJoKZR
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003AEA:EE_|DS3PR19MB9295:EE_
X-MS-Office365-Filtering-Correlation-Id: bb489727-abe3-4081-de0e-08de10e0cfaf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|19092799006|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MzR2M3VyTjRnZFdXdXdvKzZHcVRNbTlSdlpIZC92N1IzeUtpZm45UUYvTlp1?=
 =?utf-8?B?UG91eUpXc3JleHowcUhIdFphV1FlSU5icFdoVDdiYXBoSm1TZFFkeGQ3aVls?=
 =?utf-8?B?SnY3UWJ5N3RTUWM1ZUxmVXhXcXdiZ01rVDQ1bldmdld3QVBIRXR0QUQydjFB?=
 =?utf-8?B?bmQrdEJUdko3c2cxNU9zT2k4dDlkSlBRcUdCSmxjV1NzVmNlVDRtbE9iZ0R4?=
 =?utf-8?B?eEdYajNJSjRxdEIrcFJ4MnQwRFc0MnMxcksvWFJwcnhvN2JBWS9Pb1Q3TWJj?=
 =?utf-8?B?MVVPYmRYTW43eWFYb296VWlLRkllcXd6L2xIaFZZM0xyTEgzZFRrTXBSOG1r?=
 =?utf-8?B?NCtXa0dJR2R4c2VvbjRBTGZRYjF4Ny9RdklOZjNWSFdKalg2b3FFbHlHWFpl?=
 =?utf-8?B?bjJ6ZnA3cGFqOEsvczRoMTl2QS91cVVrMDRyaUlqUnRLUms4SWJ1U3JPYXlX?=
 =?utf-8?B?ZlMxbGoyT1N2Q0VFaUw2NXp1QXcvTXRlaDJIMXJEbkljMDN5ZWYzUGtaSFhG?=
 =?utf-8?B?MDdlbW1YbkExMFJwOEwwSEhMekRzc3BuQ3dlZnl1TlVnTlp2aW9HdGI4SGY2?=
 =?utf-8?B?TmtRdmJYUGZSZFBUNm9FcExWL09YVTlqU2RYY3duUDVMTy9wSEpBbStKVmZZ?=
 =?utf-8?B?YUYvOVc2dVBuQUdPV3JLK053ajhvZWorc05oVlphUDB1MTdpSVRUWmxDbDBV?=
 =?utf-8?B?NFVLZWprRExWQlY3RWVKcUp5azV3NFZIWE5OanVVRjlzSFFpZE83SUY4VmV1?=
 =?utf-8?B?VTIwb2VvaElObHZ3TEZpU1FqS1hoMUdRRUVrSFNTTTNHeFQzTkZ5clFSTE56?=
 =?utf-8?B?TlZMMHR5ZWZjRHdFN0d3bnhTQjdBRGJSWlBYVVNpRFI0WnRQKzVMN0NORjY0?=
 =?utf-8?B?eFQ0NzluWGYwWGpTcjNWUFdHOGhkbk5ZaTVZemdSV2R6ZTRVcFNlLzEvRmhP?=
 =?utf-8?B?Nkhzb2d2Y3dianN5NDlKcG1VZDlMLzIyNVUzODFHS3ZTSFRjdmNWOUpFRFlG?=
 =?utf-8?B?dm03R2MwdFFLZDZkbjYrc3lXVHlYRk5FczI0c3NsVzNyc3hNSzNUUmZvTllZ?=
 =?utf-8?B?QS9kVjVvcnRObFNKbU5QWjBiS3NPZS9KYkoxUktjbmJNSmcwOFk0Q0poT0Zz?=
 =?utf-8?B?UTR1MHNWZTlTTXFDZ2ZQc2QvM0I3a2VGSHoyNHNJMFJqTTViSTdQeGw5OVRZ?=
 =?utf-8?B?Q21LdHZ0SmNSQVF5Y3ZDQ1pwZW5pVFVwMk1iREhIMnIzOVJ3QU5CdW4zWjYw?=
 =?utf-8?B?Qk1IRkVtZlVJK2t6b29hSDhWcU1aam5HV0FvUGpLdXhaT1ZtdU9uZDh0M1pa?=
 =?utf-8?B?MS9aRGVMYmhmeDZRMUlabVlxTEJ1M1lFWUtkbXhrRTFYV0xWU1lnRk8zeExB?=
 =?utf-8?B?eldidDN2M1VWQk5RenVhWlRTYjh6MVpmZC94M1ppUkZJYmFldEkyM0UvRXZN?=
 =?utf-8?B?bUczcitVaDgyNjJUUE84SWRyNWpVVUMvY0FKVVNGYjRKMGx1S1d4M2xHYWF6?=
 =?utf-8?B?YzlkWWVYU3VHSDBGSUFrci9URGllckl1enJ0YVFrd3FzcGtuTkN1MEsyS1U4?=
 =?utf-8?B?MklYd012ZCt4OXA3THRJeUExSkIvbnRqMXRLSVR5M3p2R1paVmFLd1Z5UWZW?=
 =?utf-8?B?bTB2ZDNQTkdCT21GMlczL25iREV1VDFNUkxZb0JuZFJXMkdseGQyZE5VV2NP?=
 =?utf-8?B?SUs0Rmw5RERYTXYxdjFGUFlrUnM2Zk5pK3N0U293eTJ6VFNtMm1uQ2xTSXlD?=
 =?utf-8?B?M3ZIVkZwdVJONnhkWkpINCtEMGtZeFNZdFFyeXNKK3FpM3hDdVVIckFoVWM2?=
 =?utf-8?B?eVlJUU5kZWo1TGRyb0VaUmFmOW50ejV2ajdWM2o2UVJucHNkcTdiM3EyK0hF?=
 =?utf-8?B?dUhVZEdwdS9WRzFrS3dvdXQ4UXdzNzFYRWRwUkNZRkRJVVVGRGd1eGNVN2tI?=
 =?utf-8?B?V1IwL3kvZ2tCNS93eWc2blJFWThFb1BnN0E4Uk1TUmNRZWV2VjQ2Y2JJMXN2?=
 =?utf-8?B?NmtGRjNORTFEVnNtbzhyeUUyWFY2ckZLNnhVSmpHcGNnZHdqWk9OTGlqZFd1?=
 =?utf-8?B?T0F6SVJjL2tIZWtpdHg5eTFTMnV4RkNJRTZnWWhTb0NrbmFZQWR2T2FtSCto?=
 =?utf-8?Q?Z6Z4=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(19092799006)(1800799024)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	v065Bg24rmf09iLOGXDGsD2waRov2/urIWR7XIm6k3TkrmmXLXlUTAyHBmcH/S7evCU7sTQzwUW5xLTk9C+G/O5oa63ZLjRC9cvs4vxdZGsLpIYyvtmXuCYohWPh7FLxeVcbufmgSXBgdRFRDWwclyGcIVh5Cu1uwMgFClLXqrfjaHGmb8V05tFA2SzgpJh7aRtYnvoNHSVRgn9j37KnmTmCoJTor292FbitxvyY64sjYGZZ3y3FPFNRjkY5oEB7a6iWOXK4mxD9r1McO1xGQGPoo2mfx+XIbcHVAv4gO4mKLVem+rOyajP6DYHBRII/v4yPtZqoDEP/sSh/gIQm0SXDAWCuv2CP8gAJXzsFGaheBYYwWeJmONmyWNrF/KD30Xk+lQ+ImbCfOOV14/pwO4kmMEc872Jr4ZL746/b9eOM/4BfII57fsIdt2nHIBwiviv5+pMCm5X9Hx27DwEtl7ABpWQxYyxmk9V52xxRc7vJuj5mEg8/amuG+bZ8V5/0r8stID4SplaQ4wAJMHDx54YQJ68d1Jy9G1snh3sWNVvabBtpc9E0+1ByVNrhDj7RuNG7wOfjlA4ZMr8J08s2nq0LVDDSTOx7KTWL9buzT9mKKuwsH5xU3H6HbylzTyo/4TxN+wdlM8fYff5fLQpadw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 20:31:27.5239
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb489727-abe3-4081-de0e-08de10e0cfaf
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003AEA.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR19MB9295
X-BESS-ID: 1761078689-110373-7605-24104-1
X-BESS-VER: 2019.1_20251001.1803
X-BESS-Apparent-Source-IP: 52.101.85.110
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVqaWpgZAVgZQ0NQkLdHSwjTRMs
	UsJdHQMtXUwiDVMsnIOC3NIi0xLclEqTYWAFlaRitBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.268376 [from 
	cloudscan11-90.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Add check_system_io_uring() to determine if system-wide io_uring is
available for a FUSE mount. This is useful because FUSE io_uring
can only be enabled if the system allows it. Main issue with
fuse-io-uring is that the mount point hangs until queues are
initialized. If system wide io-uring is disabled queues cannot
be initialized and the mount will hang till forcefully umounted.
Libfuse solves that by setting up the ring before replying
to FUSE_INIT, but we also have to consider other implementations
and might get easily missed in development.

When mount specifies user_id and group_id (e.g., via unprivileged
fusermount with s-bit) not equal 0, the permission check must use
the daemon's credentials, not the mount task's (root) credentials.
Otherwise io_uring_allowed() incorrectly allows io_uring due to
root's CAP_SYS_ADMIN capability.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/fuse_i.h                  |  3 +++
 fs/fuse/inode.c                   | 45 ++++++++++++++++++++++++++++++++++++++-
 include/linux/io_uring.h          |  1 +
 include/linux/io_uring/io_uring.h |  7 ++++++
 io_uring/io_uring.c               |  4 +++-
 5 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index c2f2a48156d6c52c8db87a5c092f51d1627deae9..d566e6d3fd19c0eb0d2ee384b734f3950e2e105a 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -907,6 +907,9 @@ struct fuse_conn {
 	/* Is synchronous FUSE_INIT allowed? */
 	unsigned int sync_init:1;
 
+	/* If system IO-uring possible */
+	unsigned int system_io_uring:1;
+
 	/* Use io_uring for communication */
 	unsigned int io_uring;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index d1babf56f25470fcc08fe400467b3450e8b7464a..6dcbaec9b369c689bc423da64b95f16e38ac0311 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -25,6 +25,7 @@
 #include <linux/sched.h>
 #include <linux/exportfs.h>
 #include <linux/posix_acl.h>
+#include <linux/io_uring/io_uring.h>
 #include <linux/pid_namespace.h>
 #include <uapi/linux/magic.h>
 
@@ -1519,7 +1520,7 @@ static struct fuse_init_args *fuse_new_init(struct fuse_mount *fm)
 	 * This is just an information flag for fuse server. No need to check
 	 * the reply - server is either sending IORING_OP_URING_CMD or not.
 	 */
-	if (fuse_uring_enabled())
+	if (fm->fc->system_io_uring && fuse_uring_enabled())
 		flags |= FUSE_OVER_IO_URING;
 
 	ia->in.flags = flags;
@@ -1935,6 +1936,46 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
 }
 EXPORT_SYMBOL_GPL(fuse_fill_super_common);
 
+/* Check if system wide io-uring is enabled */
+static void check_system_io_uring(struct fuse_conn *fc, struct fuse_fs_context *ctx)
+{
+	struct cred *new_cred = NULL;
+	const struct cred *old_cred = NULL;
+	int allowed;
+
+	/*
+	 * Mount might be from an unprivileged user using s-bit
+	 * fusermount, the check if system wide io-uring is enabled
+	 * needs to drop privileges
+	 * then.
+	 */
+	if (ctx->user_id.val != 0 && ctx->group_id.val != 0) {
+		new_cred = prepare_creds();
+		if (!new_cred)
+			return;
+
+		cap_clear(new_cred->cap_effective);
+		cap_clear(new_cred->cap_permitted);
+		cap_clear(new_cred->cap_inheritable);
+
+		if (ctx->user_id_present)
+			new_cred->uid = new_cred->euid = ctx->user_id;
+
+		if (ctx->group_id_present)
+			new_cred->gid = new_cred->egid = new_cred->fsgid = ctx->group_id;
+
+		old_cred = override_creds(new_cred);
+	}
+
+	allowed = io_uring_allowed();
+	fc->system_io_uring = io_uring_allowed() == 0;
+
+	if (old_cred)
+		revert_creds(old_cred);
+	if (new_cred)
+		put_cred(new_cred);
+}
+
 static int fuse_fill_super(struct super_block *sb, struct fs_context *fsc)
 {
 	struct fuse_fs_context *ctx = fsc->fs_private;
@@ -1962,6 +2003,8 @@ static int fuse_fill_super(struct super_block *sb, struct fs_context *fsc)
 
 	fm = get_fuse_mount_super(sb);
 
+	check_system_io_uring(fm->fc, ctx);
+
 	return fuse_send_init(fm);
 }
 
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 85fe4e6b275c7de260ea9a8552b8e1c3e7f7e5ec..eaee221b1ed566fcba5a01885e6a4b9073026f93 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -12,6 +12,7 @@ void __io_uring_free(struct task_struct *tsk);
 void io_uring_unreg_ringfd(void);
 const char *io_uring_get_opcode(u8 opcode);
 bool io_is_uring_fops(struct file *file);
+int io_uring_allowed(void);
 
 static inline void io_uring_files_cancel(void)
 {
diff --git a/include/linux/io_uring/io_uring.h b/include/linux/io_uring/io_uring.h
new file mode 100644
index 0000000000000000000000000000000000000000..a28d58ea218ff7cc7518a66bd37ece1eacee30fb
--- /dev/null
+++ b/include/linux/io_uring/io_uring.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _LINUX_IO_URING_H
+#define _LINUX_IO_URING_H
+
+int io_uring_allowed(void);
+
+#endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 820ef05276667e74c259723bf9f3c605cf9d0505..52cb209d4c7499620ae5d8b7ad1362810e84821f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -76,6 +76,7 @@
 #include <trace/events/io_uring.h>
 
 #include <uapi/linux/io_uring.h>
+#include <linux/io_uring/io_uring.h>
 
 #include "io-wq.h"
 
@@ -3936,7 +3937,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 	return io_uring_create(entries, &p, params);
 }
 
-static inline int io_uring_allowed(void)
+int io_uring_allowed(void)
 {
 	int disabled = READ_ONCE(sysctl_io_uring_disabled);
 	kgid_t io_uring_group;
@@ -3957,6 +3958,7 @@ static inline int io_uring_allowed(void)
 allowed_lsm:
 	return security_uring_allowed();
 }
+EXPORT_SYMBOL_GPL(io_uring_allowed);
 
 SYSCALL_DEFINE2(io_uring_setup, u32, entries,
 		struct io_uring_params __user *, params)

---
base-commit: 6548d364a3e850326831799d7e3ea2d7bb97ba08
change-id: 20251021-io-uring-fix-check-systemwide-io-uring-enable-f290e75be229

Best regards,
-- 
Bernd Schubert <bschubert@ddn.com>


