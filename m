Return-Path: <io-uring+bounces-6068-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CD6C6A1A621
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:51:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 882423A4A03
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:51:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68B0421170D;
	Thu, 23 Jan 2025 14:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="nq8OH/Ti"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A7C38B;
	Thu, 23 Jan 2025 14:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643897; cv=fail; b=UivoJMb6L2a99uThTWo/4Hc1LwSO0MaaW3o4EEFuhAb2x8Nz7OfoVtoT/iukDieOQmhj6NgD2bhQuEHqn3UqCNP4dbDekh8aYBwUIZhQOKqhWs8VMBe3dFx89/8+ky2NDXZxGVfeDJVJbRAxA0jppDsMyc2DBNUvAN/iYcXDWko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643897; c=relaxed/simple;
	bh=ELv4vSTFz4Kcn3bHANr7CBpZcX2A/Icg2hIwG22ixq8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VVu6wWDBk02rCMRktIdRH1CdoebXH9OOBVCnawhMtkMeYowYPnEMjhNATtMtawbbxrQbysCefZYqgSQKYnmUH+ZLiCDMQc9LrNY6FiwrWrMWLy9NHxBakhJRUDINz2a8oJEc54hpAKUDVI3KPMqJ8dZclpm3bpSxNEEqoG+XsHw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=nq8OH/Ti; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2049.outbound.protection.outlook.com [104.47.55.49]) by mx-outbound46-42.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 23 Jan 2025 14:51:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mu0vRIcfk70dXb63kSj88akvzu5RaL0MIL1MOc0GBTrbfWSQ2sd43/Mh6qSunCXHTVvIpJwfLeGIDKhXpidpEsyVVMD1vPFWc8Mvtq4YGQpVtgqvAx7mfxuYospNq9CE9/QDnCYwVhvqiOKJxBQ49xMulqlbn1BdEGe3ZDGImRPQbuutEoO0jVds5JWQ3DvItUEpCDtsRgEBtOD+p9reB8KtTQsE8O4RWfXMIaVGseDjwnnkqsCvzlJXJRPue0vr09CP+VHpjw6UQVGY52XqOQOTobxDpSNTEYHHvaGiVquromuASvknTWXvWUDytNPJSIW7pj5jdAyBsuusucm3RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iGELuObFK/+DdXqUXO2N8sJPzYyf9lE/8hbC0uxMblI=;
 b=YND9g0jVXtORmatihS8Qry7r3f14jprPIU+3Sceif/3HWp+dlVnei0tcVY5Oamzi9Lq6zCtOiSvFGxqTilu4yr9Fx5rXfGbe+A0yS5V4Vq758fd9J3OJjmruRFf1Cv8FQIRG75RIYR1gAEtThM9XSaR8RHVblAcpOVlQMogwO0CHmRDK85C/arlZDflDZyBeaVD2mjceDPUOBTsJI70qSVBunKZl0mkYYDDyZOXsOAVh1P1KuGEUMBVpcD+wu0hJR60tpc5c6sDe96CAPGiuObsER0wvOwe7IU35XSW8XVSoNEL/OySZL7kdZUx7ab40NKvvvQr0ZgWvfbsOcmz5TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iGELuObFK/+DdXqUXO2N8sJPzYyf9lE/8hbC0uxMblI=;
 b=nq8OH/TiPjJ+HhtrxIaQ4R1ZbGaTKHVLsJxvkw4q+PHgh+YIPx7tFv/106twWQUexQoYrI7uPLY7PZJ5DdlRJWYwvm+eSJQiAZCAhTFRKkqqJ3ICeDCIjfdJ14h23B8i+f1eirpmRLnUfPZEMRiE4mUcF4EWFCBi2VIAy4ENn9g=
Received: from CH2PR12CA0001.namprd12.prod.outlook.com (2603:10b6:610:57::11)
 by CH4PR19MB8769.namprd19.prod.outlook.com (2603:10b6:610:23e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.22; Thu, 23 Jan
 2025 14:51:14 +0000
Received: from CH1PEPF0000AD82.namprd04.prod.outlook.com
 (2603:10b6:610:57:cafe::7f) by CH2PR12CA0001.outlook.office365.com
 (2603:10b6:610:57::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.18 via Frontend Transport; Thu,
 23 Jan 2025 14:51:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CH1PEPF0000AD82.mail.protection.outlook.com (10.167.244.91) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Thu, 23 Jan 2025 14:51:13 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 2B3E780;
	Thu, 23 Jan 2025 14:51:13 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 23 Jan 2025 15:51:00 +0100
Subject: [PATCH v11 01/18] fuse: rename to fuse_dev_end_requests and make
 non-static
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250123-fuse-uring-for-6-10-rfc4-v11-1-11e9cecf4cfb@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737643871; l=2834;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=ELv4vSTFz4Kcn3bHANr7CBpZcX2A/Icg2hIwG22ixq8=;
 b=5BzHXF/Zv+Thzn/80JFZi/sj6aGZSowx/42B6pD42AwyXOOH8wiuQ05zZP5dfs6lT+uC5APHe
 65ulp+YDLGfD71n/F9jQQIMn3fzP8Ripf/5S3if5Jk5og/F37Mr14ia
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD82:EE_|CH4PR19MB8769:EE_
X-MS-Office365-Filtering-Correlation-Id: 91c5cb5c-13f3-4ebe-bb4c-08dd3bbd6240
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TUtrMnRLK3JKNVF1UWdBYVE3YTJxTldjVnBqdmErSEFUZVNYeEF4L3dFcytV?=
 =?utf-8?B?YlliZ041MEJmb2h0OGNJUDJhYkJZekNaWEdZWmZvQk1TbDlnQWNHb05mNklx?=
 =?utf-8?B?QTl5aVQ1WmlTSGxTd0JZOFF5RlZKdVllNkQ0cjA0cEwyRnlYKytRb3hEdTFq?=
 =?utf-8?B?eGtCYmFwcVRwUVF2VFRlbGNPK3RIcWo0UjNsbHY2dnhRRVYvSnhWTHhTTS9B?=
 =?utf-8?B?M0xteGN0Q1FQdEo0YXAyYXR6bzJPM00rdFNjQkxaODI2Uk1kVTBtRFBKQ1Nq?=
 =?utf-8?B?MEd1cUpZOXZmWlRmUUdzK283SDFpY0pwWlkraXN1UDFKZ2cwajEvaE8rbzhw?=
 =?utf-8?B?ZmxTaUVoWm0zUzJtQlFnL0ZMZ1lKQ1BmSGJGUkVQWWFvcVMrNEs4VGtSVUtv?=
 =?utf-8?B?SGwyK2NFbVVuMTFiaHVvdTFQTGlISWkxYlFxdjQxcm1KaUtLT0Fha29tR3RQ?=
 =?utf-8?B?S0ozT3pLZ2Z3NGlRZ1ZwQTRGN25EQ0UxNW5sUHFJOU40V1hBZFpTeUVRdXQz?=
 =?utf-8?B?OEFIaWJFcHBmL3Z2NFEvQWRTVGtERGRUNjZMUFI3d1lCU0ZHYXNnUmdaRmVv?=
 =?utf-8?B?QmdkRkZFOERaTWVWdkJmb1hrR1dLZk9QRUpydGs2bmE2QUVqcXB4b1ZDSTBS?=
 =?utf-8?B?YlpFTVNEa0NIRUxvTE11Szc2amNVN1dBNi9hVmUzb1EvcnNNdzhvMWI2ZWtH?=
 =?utf-8?B?UVY5dVRVdDlGOVVsMURHcGhoa3puTlNUMmdvQzNEeDl5cG9DM2xEYmRRZmdV?=
 =?utf-8?B?bUxXZGNEamxqdHJUTjdFcHRzUm1DWnJzT3ZlZ3VqMityZzlYa3RGR3ROV2g3?=
 =?utf-8?B?SXoxZ1IrRTJvTHlhMFVzUEhLREM1NWlKRXNycm1uS2xaenFTVlRsMG9zaTVH?=
 =?utf-8?B?ek1UNmJlT1VpQjFuYUhzZCtNSHgzUjlFWEVjc0NyeWk2aVlMOWxVQkxUY2FT?=
 =?utf-8?B?bmI0Tk1Ra0RQalVQMzZqeGhzQ1pPcVZWM21aZ2hiaWxKOWxtNldINHhIcmNL?=
 =?utf-8?B?K01nbHU4NnprNlVoRzF0OFlTTHdFbitaZDE3SG95NitNa0puRS9rYWNRRFo4?=
 =?utf-8?B?UTduQVdMOUdCU0NlMnhRK0dwN1dzbnU2aGFyZ3ZUKzFUTWQrb0xHUlIvNmRR?=
 =?utf-8?B?WXltMC92V3FlZzR5TWRoeGovOEZrM0xYRzkxMElwbWVPOS9oa0ltYkNQbDhZ?=
 =?utf-8?B?T3ZDMDlIRkVIbVNXOVpCM1pwUFRKTUJKUitUem03d2t3c1hhNWNMVUlFdVBY?=
 =?utf-8?B?NVI1VzJjRFRPY3NrQWNQQjFEdmlXKzM1eDF5Rm11OUZNSXdKaWtKcHlLQnJS?=
 =?utf-8?B?dkN2UDhCNWZCdlB1KzdnZGdueE9RZ1NNV3dMY0tXSkwwcGlzOTJkRjcvVVFX?=
 =?utf-8?B?NUh3dzQ4MmdUMzRHeUhYbU9SYlFnU296alBFbEtFcUNqTG9xbFBHMEF6MXRp?=
 =?utf-8?B?c0RoRk56S3g5azd5YWF3SEpkNmNJUVEvMmFmUWNLWnlWbVE2WnM3WHRnN0dh?=
 =?utf-8?B?ZklIZWI3cHZ3QzBJWTRldm5qRENldkRlcUJjU2g1RzhYdkNielJnblZiSmJr?=
 =?utf-8?B?N3g4eVNIb3BwY0hPU2N5R052djZITHgvQUhRYXRlOC9hdzE4NWt4dVpaTXJn?=
 =?utf-8?B?V3lHZzdOWjFzNFhLcDdNRElRTjF1UFRZN0VTdi8vL3pGVUYyMXVaaGdkeXVl?=
 =?utf-8?B?dTdrZTQxakY1a2huU2UydzBTb2MveDlYejdSN1VVdDJJWmRQbkpQT1p3WFNj?=
 =?utf-8?B?d24ya2tRdDliaW5HWlVwSFJ4NDFPVlpEcW5DRTd4YmNvVnFxUzljZytpUC9I?=
 =?utf-8?B?ZU5iTlZ4TWtPVVgrK3duTW94KzFXYW1sU056REhBSThjcmdwZVRMczh2SzBz?=
 =?utf-8?B?YVdmY3huWXp1Um0vSEE5OGN3Y1RvUTJGWStqL2w0QytxdU9kQTd0YjNUaC9y?=
 =?utf-8?B?aDUzZTFLK29jcUZNMzlKWnl3QkREUE4waS9NclY4KzNwUU9OOHk0RzZaUE5D?=
 =?utf-8?B?WDJCK3V3Y1BRPT0=?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	M7ys4QPtXNlWuclnVX0SB5sgh8e17BPr4vUR3jAFLERqXvLDUF0+lKvuTxzzKcUfwDxovT95z53GcWsSZbUMg8sC773KTZUsIYDpcS8xbJfjtWH1ISkoYwWf9BB5OyS0xy/5bwiAr5yN21dC4r2dZISPWuMlOlRTcG5On2IgfFOVxjkIYtCxI6bYLdWH5B6g2j0Ov6yZvIEknA59fySTfXa0a9QcQNUqzZzpcxYwz+FdUvn0Q9a3qv/ppRexpb/RJNK7RyVMADP4NH/6Ak+L1Y/owESToQmivddLx4nLLmmzsj3YEA8c7pukCMRO6+7056YhUfFAgbAMM4Ix1/7vnpBNLe1i8mNFG9jncRQC9Dtl+y0/zRkgXFUgEUhjCKYHVs2mNhErh9SuSiboCkGSYEm6Yfm9SVFO759GjS7dzauITJotT6gMpwf28rvMz7iC7M4SeW02j3Q/Hh+3JDZC7GJXkreRQFDbsKK3d0LOWjdjWhkgwFYOaBEQq5q2HC1B/x2yGS8k+uh43CcJOe8HQA+bx2DGnfw08gkBev+e2MhfBtnq8L+TYPJ2O+6ze2Uil5gB4uj0ynoxrzKodyNzel5/AbJ/6d748VYhqzAidTSGbo2eXJiIuoW9aWw7JjWjiLTrMCIR8HxBLWc0ALx1WA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 14:51:13.8808
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91c5cb5c-13f3-4ebe-bb4c-08dd3bbd6240
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD82.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR19MB8769
X-BESS-ID: 1737643877-111818-13400-6438-1
X-BESS-VER: 2019.1_20250122.1822
X-BESS-Apparent-Source-IP: 104.47.55.49
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkbmJkZAVgZQMM0gOSkx2djCyM
	DAIinJxCLNPNUsKdnQzMQ4McUy1chEqTYWAEbCYh1BAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.262002 [from 
	cloudscan18-232.us-east-2b.ess.aws.cudaops.com]
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
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
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


