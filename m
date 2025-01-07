Return-Path: <io-uring+bounces-5714-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 852A7A034C8
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 02:59:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BEBAC1882EFB
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 01:59:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B17086329;
	Tue,  7 Jan 2025 01:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="Lo195aKx"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EFB481A3
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 01:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215176; cv=fail; b=F5omtecEv9E8AowJobe8ECRrX6boa68eJ8bjhCY2YDQgLNsL0nGEx4gBQ0NL4KIlupeisMAqz06PdGrizc8k5oweq13MEpF62UOqxSV8FssnY3+2XZ0Aepe6byaiD5oXgDY88FzGWTMACAER4WYToLfLRTTE+LRhnroQa3DJn1o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215176; c=relaxed/simple;
	bh=MxfJjh+KWyLM/pBEqZ+TVduRkvAsbRDO2XTjnbrCNS8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HLhIm+w3Qg9TIQLKVc8YtPEH11xPgsG9evzmv1m13Hc7CdbxUxs4ww8kHFnMiWPGYA4DNchsHooah6AFxQcYe9XHwYimXsEwD7uBpkGXeonNdguGo8NQ7V1bbvdWVlGn76UVIQrk/ercvw56oNQdRrmnJGjA8rc2WA1HlpngBMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=Lo195aKx; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2049.outbound.protection.outlook.com [104.47.58.49]) by mx-outbound40-113.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Tue, 07 Jan 2025 01:59:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i5e/mLwl0wohpyVpUtvX+xjbu45kNT43+ay7RMl4zVshunEwyeku64lTcGx0aVrN40tvMRxtv6qH7yXzoUj5vs1CBdmYoLEHejb24YWV9sfQqBtIhxVuYwZujsBoLLYuuBE02Bag32k/cr7MvNQcD/rmsFKKcj1bjjEYiJbzwCpNw+thz/Q0A/DkABN2tuTBYc2MEI8N8jKsybIxH1RFSTkQOR9Z4Lfw7r8Egv6n5PhanRGwAGSqg+QKaFOErisqTOgIu/wlNTlylp/XQTPcYE12xd4Z+utvKwMcIZwmpVOHERjomgsJ7N9eq5uY15X1v1sRofvtldlH9033IyLAoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ROJ/GyNgfYoF7z0FAlOmFhvKYoHCgYvO1Q08mJI7h60=;
 b=whKnNa2hw1Mut3bWTNcp9d1VxrX1AlkcXxoDxEnPg5nc6kc5KjxWmpYk7SXaqPKFQJOZcXePz46jAWzr0ap0FA5jxGPQ4nzFCqOI586aJkQmQDikUF/+i+0EvyWVJVhUqAj/7GQfKKK+ypxCXvdCwZJ7/8lfOPFfpEPfjyhonaqYcZH/FrwnLxCZEctwSPYZ8PzoHhYPaukL7RB2wIfzCDMyAPQ8QD5keP7Ykf7KMwlLvCm+fMxVb8hHf8G6jw0SHYYBT+rPKOJOgT0aaFwx2Hk4hznGyKcpg22qhWDHtcPQaXIxMBT+RWVLGWVWTuDl5gNjYEm5vl2OgRZps6AcWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ROJ/GyNgfYoF7z0FAlOmFhvKYoHCgYvO1Q08mJI7h60=;
 b=Lo195aKxSqeri+45WAsmxN9sKEhBOYyeNjIDi7GzFLabv+aFse+tfLyKXBiEvbR4VrdyMWTCe5H+teDjf9vEKOv0I9l0Feds2Uab0vUpa3CCbYaQGWjvHraPW2RAWPCGeQQL2JfWalw6nGN/8DN/wEbMrUZFgrADZ7ABT0U8+L4=
Received: from BYAPR05CA0011.namprd05.prod.outlook.com (2603:10b6:a03:c0::24)
 by BY3PR19MB5220.namprd19.prod.outlook.com (2603:10b6:a03:355::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.18; Tue, 7 Jan
 2025 00:25:16 +0000
Received: from SJ1PEPF00001CEB.namprd03.prod.outlook.com
 (2603:10b6:a03:c0:cafe::44) by BYAPR05CA0011.outlook.office365.com
 (2603:10b6:a03:c0::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8335.9 via Frontend Transport; Tue, 7
 Jan 2025 00:25:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SJ1PEPF00001CEB.mail.protection.outlook.com (10.167.242.27) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8335.7
 via Frontend Transport; Tue, 7 Jan 2025 00:25:15 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 39E414D;
	Tue,  7 Jan 2025 00:25:15 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Tue, 07 Jan 2025 01:25:10 +0100
Subject: [PATCH v9 05/17] fuse: make args->in_args[0] to be always the
 header
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250107-fuse-uring-for-6-10-rfc4-v9-5-9c786f9a7a9d@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1736209509; l=6974;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=MxfJjh+KWyLM/pBEqZ+TVduRkvAsbRDO2XTjnbrCNS8=;
 b=X/Z+pTmLJSQyZkINYpCSdpTQDQc1c75LrCUe12sS+K2woqldpYc0PbYOLHIhsNDoAyG6Yu/M5
 +YUlMs/7P4wBRRaNztvPLU1rZtVyaouVvIiLmhN28BG7kEWnrLF7hkP
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CEB:EE_|BY3PR19MB5220:EE_
X-MS-Office365-Filtering-Correlation-Id: 8900b0c3-0c17-4f9e-22a8-08dd2eb1c262
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MFJTeHQwTUJnci93Q2FERVpVQkFZMHdZMTZacWZyM3MwYktGTVlwSHU2d2Y4?=
 =?utf-8?B?OVo1aEpvVmEycExmdWg0WjU1OERkbmxwTm9kV2RCOW5KZDNjTDZzTWtkS1Vv?=
 =?utf-8?B?QU5EUGtCTjAzOWZFb0NteGMyWGNDcm15bUZTbDhRc1hpcHRFUWxQZzdjdlFz?=
 =?utf-8?B?QXJoczRMYmtRa255bkozZFFyVUswamhka3ZuZWRsRmdUOWdYeXVEOE9LNHVz?=
 =?utf-8?B?QVBpMTVqTTFkOU10aTk3eUdWYmV1WUtkakVNeHZ0ZEIwSGdhdjZmRVkzR0dO?=
 =?utf-8?B?NUlmQ1NYQnNNKy9uVzdVaFVvZ25vaTgyZHBRUjNVVTRMZmRCcUtLd0szZnR0?=
 =?utf-8?B?TmVJQkkvaVFiUWcyZUFvUloxVis1cTYyOCtMMlBqc1EvaWVubEVLc3Rrakkz?=
 =?utf-8?B?Rmt3R2dNY3VWRDBUMzE1Q21PSzhNb1JHN2E2Y2tQcG5YOEovTERTaEY1cGR3?=
 =?utf-8?B?VWlKK0dVeSsrRHkzVkpSb2pHQVdVTXIvbUh6NWY1cDZRWXZKTkFkS3ZkQndG?=
 =?utf-8?B?Y1VRcDJXZEVGUWpRVjdyVFdQc2pmbGlOQXQ1TGgySy9qZm5NcncxSXdxUmtU?=
 =?utf-8?B?MkpiOHVFYjQySTBSSWRRSGJXVmo1Zm5yeTRVbFNSNzBxOWtxNWZFTG1uRktJ?=
 =?utf-8?B?dHFqVGptZExtaE4wR2x1WmlsY2YvL0o2TER1SXNtSWZjT1plcnlqQ0RIbEtW?=
 =?utf-8?B?MTAxbjc2aXNpUXNiV29uVEoyT2FqZ1dVNlhCL0RmLzNXUjFUbmQ4cjJVVDFt?=
 =?utf-8?B?bFhsT2YwdGRvbU1VbjRrTVg3QVdJSzFkUlkzdzg1THdNcUlEcWFSV1ZLNXA5?=
 =?utf-8?B?aUhiRDFockN6U0ZTOWhheEdBaHBGUDBMaGthT3NKR21HMjcyZVlxVDA3bE9N?=
 =?utf-8?B?MElNNWFaUGNIRFJNMmNhdWxxSG9lWEdxNGNvd0JDdFNoMlhBcEJyQnpvV2dR?=
 =?utf-8?B?Uk1VKytFOTBIa3VRekYrMngzQXBRRC9QNHgwMU9mYWF5a3VIbkJGZkR6WUw1?=
 =?utf-8?B?UTlOQzJJRTJNRXJaM1RLTzhUdFYzVmpka1lDV2dLYkJmMWlhSDJUSm1ETVVi?=
 =?utf-8?B?bS9aTitoQ3ZXd0hrUHZpSjRzS25nSXNkdEhBRjBNMCs1RERWMXgxNGIzT1ps?=
 =?utf-8?B?SUFGTVVqMm1pTFhtTDYvQTMxMWRJSk9EMUJ0TW9pWUFJRTlkRzNWTm1BYWVa?=
 =?utf-8?B?NHNZcjI1ZWVWSWFaZnJYeEM1WUVwcVFSbzVyb3VMZVZhZjM3andpVVVSekFY?=
 =?utf-8?B?YUM4bnZ4K29UNUJ2YlBQL21Db0xMREcyaWJhd05zRDhkd3ZYRm10SFNnWTBV?=
 =?utf-8?B?NVV5aFN5anRaNTc2UEMvQlN3RjZMcklldC9NeWE1OFBxVld1U3V3Sm9wR2o2?=
 =?utf-8?B?aHRXMDZpVzV0WWZ4a2VBQ05EVEc3Snp6QTFYZzdTdXkwUFo3c3dIQStieXdy?=
 =?utf-8?B?SkNmL1NvdzI0TXlTOXhsR3BGNXBMYWhzN3RpangyaFFNejhCZ1k5Q3VuZ1p3?=
 =?utf-8?B?WThpSC8wWWdVQVo1cWxlNEExSDhIV2FoUElqWnlabVlRV2NSNEpmOXR6U3VU?=
 =?utf-8?B?czBlWUhNYmpFa0x2L2VjbndQelpudWMzZERJeTN1T0dGdGxkbXVUNWQwbjY1?=
 =?utf-8?B?TmVJRitrSjV5RUhSS1hJeU5mTU1HM2hoMTBtSWtSTDBBS0ZCbGg5VmpqdVli?=
 =?utf-8?B?SXRWUzJoci9DRE45ZXc5R3pZMGxJRVVKaWVpTTV3TWJRT0F0R21Gc1NCVW5D?=
 =?utf-8?B?cDlFNnFKZjgxV0VUUVhFVlZpUlc5QkRGc1BDbVUyR0lqYU44NVFSUXdEeXg0?=
 =?utf-8?B?aWNZYXJmL2M1UndFdjJmZVFHUzRTdlpsWjQ0UmxBampQeWxNQVFPckgvSEVD?=
 =?utf-8?B?WloySHRQUzlLZkFpN29STVN5QXNqRGpXK1lSYUhidE5xY1hPU3g3VnZNSVVr?=
 =?utf-8?B?NXRvMUswR05sc0JZeFc2ZzVUMzJ2M3hZY2dwYTNScEZmbU1uamFtSGtSZVRH?=
 =?utf-8?B?c0RBYkp3K3FnPT0=?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yMamfJ/DqhH3doeQtXyr0l4xWHA0AJvhOsk2WrrxUsLFpU0o5NeGr4O8oW9IljsEOjopSvAzAlyRkwwNbAH+Nj54GjCK+j8Zp/UQPVZXzUtWbFK3WITMj1FCeRfbelL3e3D+foG20BfCEB/nyrnBkTQKsr1W18E29NuS31etnmo3TaiIxQR4BVVAW61pB4y7T6NlnAoTl3cNO/IQmwGVhw81C2PEEotpefuIs10hD6o/KiBLNuWCslRMK9A2J99V8rfKLG4i4pVats/EBB+pQTGXxHXM6HWTVO7FEBC2xJWeDQ5fvnEXi5F+n6MvzzdssVK5kn2mJEnczPqNYo424j/6lxPg6OnX40hUcGOi039Atuu88wHklRb3KcsCt/J93/skBBlSs1IULJlxQryzb5F1/9rL7xxLz+MEhxWeF4PiSE4lvV3Qq4STsess60Wz469OIIPFuh943wFJuoQlOJqT+Fd6EIiDjTudOhHK62A/eIRPXKDPT6A5V9TBUZadwDEGQZykYB/B0Q5pIJmc9Oi1LFuIUnzWX8y3DEE7ihy31/TTmLC+zQTz5YnbzcVKnhkQKF5r1wQxqvbzkEv4cghc/hOaNAPphLbjX9zBvlZyVBnJBoY29kXFBwpKc+rvwwRt0kYWycnYslKNdGowEw==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 00:25:15.9278
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8900b0c3-0c17-4f9e-22a8-08dd2eb1c262
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CEB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR19MB5220
X-OriginatorOrg: ddn.com
X-BESS-ID: 1736215171-110353-13429-34696-1
X-BESS-VER: 2019.1_20241219.1759
X-BESS-Apparent-Source-IP: 104.47.58.49
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVmbmFuZAVgZQ0NAo2dDA0NTUJN
	UyzSA5ydTE3NQwMcnSICXJ0CTFKNlEqTYWAKK1z+hBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261637 [from 
	cloudscan8-192.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND, BSF_SC0_MISMATCH_TO
X-BESS-BRTS-Status:1

This change sets up FUSE operations to always have headers in
args.in_args[0], even for opcodes without an actual header.
This step prepares for a clean separation of payload from headers,
initially it is used by fuse-over-io-uring.

For opcodes without a header, we use a zero-sized struct as a
placeholder. This approach:
- Keeps things consistent across all FUSE operations
- Will help with payload alignment later
- Avoids future issues when header sizes change

Op codes that already have an op code specific header do not
need modification.
Op codes that have neither payload nor op code headers
are not modified either (FUSE_READLINK and FUSE_DESTROY).
FUSE_BATCH_FORGET already has the header in the right place,
but is not using fuse_copy_args - as -over-uring is currently
not handling forgets it does not matter for now, but header
separation will later need special attention for that op code.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dax.c    | 11 ++++++-----
 fs/fuse/dev.c    |  9 +++++----
 fs/fuse/dir.c    | 32 ++++++++++++++++++--------------
 fs/fuse/fuse_i.h | 13 +++++++++++++
 fs/fuse/xattr.c  |  7 ++++---
 5 files changed, 46 insertions(+), 26 deletions(-)

diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index 9abbc2f2894f905099b48862d776083e6075fbba..0b6ee6dd1fd6569a12f1a44c24ca178163b0da81 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -240,11 +240,12 @@ static int fuse_send_removemapping(struct inode *inode,
 
 	args.opcode = FUSE_REMOVEMAPPING;
 	args.nodeid = fi->nodeid;
-	args.in_numargs = 2;
-	args.in_args[0].size = sizeof(*inargp);
-	args.in_args[0].value = inargp;
-	args.in_args[1].size = inargp->count * sizeof(*remove_one);
-	args.in_args[1].value = remove_one;
+	args.in_numargs = 3;
+	fuse_set_zero_arg0(&args);
+	args.in_args[1].size = sizeof(*inargp);
+	args.in_args[1].value = inargp;
+	args.in_args[2].size = inargp->count * sizeof(*remove_one);
+	args.in_args[2].value = remove_one;
 	return fuse_simple_request(fm, &args);
 }
 
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 4f8825de9e05b9ffd291ac5bff747a10a70df0b4..623c5a067c1841e8210b5b4e063e7b6690f1825a 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1746,7 +1746,7 @@ static int fuse_retrieve(struct fuse_mount *fm, struct inode *inode,
 	args = &ap->args;
 	args->nodeid = outarg->nodeid;
 	args->opcode = FUSE_NOTIFY_REPLY;
-	args->in_numargs = 2;
+	args->in_numargs = 3;
 	args->in_pages = true;
 	args->end = fuse_retrieve_end;
 
@@ -1774,9 +1774,10 @@ static int fuse_retrieve(struct fuse_mount *fm, struct inode *inode,
 	}
 	ra->inarg.offset = outarg->offset;
 	ra->inarg.size = total_len;
-	args->in_args[0].size = sizeof(ra->inarg);
-	args->in_args[0].value = &ra->inarg;
-	args->in_args[1].size = total_len;
+	fuse_set_zero_arg0(args);
+	args->in_args[1].size = sizeof(ra->inarg);
+	args->in_args[1].value = &ra->inarg;
+	args->in_args[2].size = total_len;
 
 	err = fuse_simple_notify_reply(fm, args, outarg->notify_unique);
 	if (err)
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 494ac372ace07ab4ea06c13a404ecc1d2ccb4f23..1c6126069ee7fcce522fbb7bcec21c9392982413 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -175,9 +175,10 @@ static void fuse_lookup_init(struct fuse_conn *fc, struct fuse_args *args,
 	memset(outarg, 0, sizeof(struct fuse_entry_out));
 	args->opcode = FUSE_LOOKUP;
 	args->nodeid = nodeid;
-	args->in_numargs = 1;
-	args->in_args[0].size = name->len + 1;
-	args->in_args[0].value = name->name;
+	args->in_numargs = 2;
+	fuse_set_zero_arg0(args);
+	args->in_args[1].size = name->len + 1;
+	args->in_args[1].value = name->name;
 	args->out_numargs = 1;
 	args->out_args[0].size = sizeof(struct fuse_entry_out);
 	args->out_args[0].value = outarg;
@@ -928,11 +929,12 @@ static int fuse_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	FUSE_ARGS(args);
 
 	args.opcode = FUSE_SYMLINK;
-	args.in_numargs = 2;
-	args.in_args[0].size = entry->d_name.len + 1;
-	args.in_args[0].value = entry->d_name.name;
-	args.in_args[1].size = len;
-	args.in_args[1].value = link;
+	args.in_numargs = 3;
+	fuse_set_zero_arg0(&args);
+	args.in_args[1].size = entry->d_name.len + 1;
+	args.in_args[1].value = entry->d_name.name;
+	args.in_args[2].size = len;
+	args.in_args[2].value = link;
 	return create_new_entry(idmap, fm, &args, dir, entry, S_IFLNK);
 }
 
@@ -992,9 +994,10 @@ static int fuse_unlink(struct inode *dir, struct dentry *entry)
 
 	args.opcode = FUSE_UNLINK;
 	args.nodeid = get_node_id(dir);
-	args.in_numargs = 1;
-	args.in_args[0].size = entry->d_name.len + 1;
-	args.in_args[0].value = entry->d_name.name;
+	args.in_numargs = 2;
+	fuse_set_zero_arg0(&args);
+	args.in_args[1].size = entry->d_name.len + 1;
+	args.in_args[1].value = entry->d_name.name;
 	err = fuse_simple_request(fm, &args);
 	if (!err) {
 		fuse_dir_changed(dir);
@@ -1015,9 +1018,10 @@ static int fuse_rmdir(struct inode *dir, struct dentry *entry)
 
 	args.opcode = FUSE_RMDIR;
 	args.nodeid = get_node_id(dir);
-	args.in_numargs = 1;
-	args.in_args[0].size = entry->d_name.len + 1;
-	args.in_args[0].value = entry->d_name.name;
+	args.in_numargs = 2;
+	fuse_set_zero_arg0(&args);
+	args.in_args[1].size = entry->d_name.len + 1;
+	args.in_args[1].value = entry->d_name.name;
 	err = fuse_simple_request(fm, &args);
 	if (!err) {
 		fuse_dir_changed(dir);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 74744c6f286003251564d1235f4d2ca8654d661b..babddd05303796d689a64f0f5a890066b43170ac 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -947,6 +947,19 @@ struct fuse_mount {
 	struct rcu_head rcu;
 };
 
+/*
+ * Empty header for FUSE opcodes without specific header needs.
+ * Used as a placeholder in args->in_args[0] for consistency
+ * across all FUSE operations, simplifying request handling.
+ */
+struct fuse_zero_header {};
+
+static inline void fuse_set_zero_arg0(struct fuse_args *args)
+{
+	args->in_args[0].size = sizeof(struct fuse_zero_header);
+	args->in_args[0].value = NULL;
+}
+
 static inline struct fuse_mount *get_fuse_mount_super(struct super_block *sb)
 {
 	return sb->s_fs_info;
diff --git a/fs/fuse/xattr.c b/fs/fuse/xattr.c
index 9f568d345c51236ddd421b162820a4ea9b0734f4..93dfb06b6cea045d6df90c61c900680968bda39f 100644
--- a/fs/fuse/xattr.c
+++ b/fs/fuse/xattr.c
@@ -164,9 +164,10 @@ int fuse_removexattr(struct inode *inode, const char *name)
 
 	args.opcode = FUSE_REMOVEXATTR;
 	args.nodeid = get_node_id(inode);
-	args.in_numargs = 1;
-	args.in_args[0].size = strlen(name) + 1;
-	args.in_args[0].value = name;
+	args.in_numargs = 2;
+	fuse_set_zero_arg0(&args);
+	args.in_args[1].size = strlen(name) + 1;
+	args.in_args[1].value = name;
 	err = fuse_simple_request(fm, &args);
 	if (err == -ENOSYS) {
 		fm->fc->no_removexattr = 1;

-- 
2.43.0


