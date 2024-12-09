Return-Path: <io-uring+bounces-5342-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A9DDE9E9BB3
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 17:30:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B46DB166FCE
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 16:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6DE0139579;
	Mon,  9 Dec 2024 16:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="RZz92bn2"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72BA1534EC;
	Mon,  9 Dec 2024 16:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733761820; cv=fail; b=tE0qStImdMOO+pMdG1zazw/mmOHM2ahuz7biiJ5Hxe/OXErm/aAOJRPtWwH6JpLqK7qhDnS3HO+ylU4cptCvWnzu5XCwoOegbNwCKK+mKG8Y9+W8e+Q27LDmDBX9w6ruabgGDvWrc7w9FQN1jQPNtaanBi+c1jHZZMXvm5PV0Xo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733761820; c=relaxed/simple;
	bh=dvX5MNc2XuYprMqXPx3CWRrFkQa5S+Flf+icX9eFsOw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=riVNONxh5NVVpucmnxWQdOELUOst7Vvn5rnBI1INnk2uGjNLJV8uv15+64Wgcubt5SnlvRWqHV6QeQMetkWrw2wjGGYGniw2UUTxUZ6h8Jb+3oFKXPF2aJS+6iah0sByZ99WD2rmfcmX2yibxTdrFvE9DmTrmChnKHffrAnyzp8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=RZz92bn2; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2048.outbound.protection.outlook.com [104.47.70.48]) by mx-outbound18-195.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 09 Dec 2024 16:30:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RHFO7VJYB2VbDr7wYNb/4yHE3qPrMzkRDdHN99omaxqV6VR4izzi/Tjd+VY6J63DRC1pRbB0rgirKT6m3lm6Na+LGd2Hf/0yMaNw9gm6kIAzXVUW8Dl+DiGsqq8rZv61knn6VxHE5zqSglAJ0RuSPiGdQpOQmQBMC7y9aIVR454KV2Oo0rFcDAzW2Pi25BhzMs0reApIIDwYOFAPQnS2WbJW+Q5+TwMuVldT3ZTczEwMoIxLe5JL485Y0zxl1SDwAle06RcSQV4EcrUqlR/PEun+K5UXx4w5UjITPQ10hI4CzcIVwEaXy4L1NJ5ZqCC/KKvpm5t8G9qTM/0asY8bGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A62xMnV752j5Wo6JRvqqVO9QrbSHTe33Xvng/kBU9j0=;
 b=vRDZp6wZm1JKeXBn+zh+10rDNUlY+FFFqof7EnSUX5bI5sUJBJ8vcp9o00osPwR4P12AHeIdMFykQi7OX65Q445VQ3wSwvXbozO6iL3+fSOFzWC0WMBJSrWIEtRHhl41ePDBrTL9n75iYQnsRyjb8o/VvLJH3mZ8FeFYzHxC4rc6mgq2+OxzqaF6e+VlGZwUPtVCC50WKgEYwxeUQ16lpcSpr+nii90wG7XTG/BDRLOSVu0emKXiu50iRgoNOqa3i1pLrjMD8fFcr1XN/NIXjc8Qo7akZ45gfbuMpfaYYUr7v95M+116IrN34XWntp9aDrBDWg6kb0ho5f7HYiI79w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A62xMnV752j5Wo6JRvqqVO9QrbSHTe33Xvng/kBU9j0=;
 b=RZz92bn2GXWvo+T6JKqe6xkd5Gy1+UXQP+ppsBLRJnL4R59mxCyYKMb4JlFmx/5d5mXE2fHnuZqK18Ih3RKeJvhrwhrfXFJeJnsUN2BPL6pYi3//sMfc9pEgavPl2wXwEFdfP+4SpjLQH0HG+VgfQoKTdH9Nbj22NQffn6G0CTw=
Received: from SA9PR13CA0063.namprd13.prod.outlook.com (2603:10b6:806:23::8)
 by BLAPR19MB4228.namprd19.prod.outlook.com (2603:10b6:208:278::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Mon, 9 Dec
 2024 14:56:56 +0000
Received: from SA2PEPF0000150B.namprd04.prod.outlook.com
 (2603:10b6:806:23:cafe::68) by SA9PR13CA0063.outlook.office365.com
 (2603:10b6:806:23::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.12 via Frontend Transport; Mon,
 9 Dec 2024 14:56:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SA2PEPF0000150B.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.7
 via Frontend Transport; Mon, 9 Dec 2024 14:56:56 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 6B65418B;
	Mon,  9 Dec 2024 14:56:54 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 09 Dec 2024 15:56:37 +0100
Subject: [PATCH v8 15/16] fuse: {io-uring} Prevent mount point hang on
 fuse-server termination
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241209-fuse-uring-for-6-10-rfc4-v8-15-d9f9f2642be3@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733756199; l=7432;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=dvX5MNc2XuYprMqXPx3CWRrFkQa5S+Flf+icX9eFsOw=;
 b=zzaRkfvmRBskxsD1zt+/kNS4vlRR2ISIhWeGE4b3X7FiwzBf9FDDPblR/ecEthOUPg7AEH/oX
 XYD/1p1QPVgDJzFitFupHdXgrZvpxdtiriXtLdkbhbzHlQBqNXmYbPo
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF0000150B:EE_|BLAPR19MB4228:EE_
X-MS-Office365-Filtering-Correlation-Id: e10e36d2-3f48-4cad-eb46-08dd1861b9ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?R08rS1RKSXJaN0hmN3FvejNTaGhPTnFHYklCOTFCWjZMYjkyNFJUSXYvZTJR?=
 =?utf-8?B?VzhkdkZnU25uY0ZxdTZ4OFhVTnBQL2tNQUlndkJGNW1rYXRFd3JDLzZNbWxT?=
 =?utf-8?B?NHEvOXY0aWRMbDMwVCtYYmdiMVNtZ1VBLzZNcWFxMU9OZ2R2VklJaW1VZWhq?=
 =?utf-8?B?bjI5NXBQY0pWMlhLY3FVN0U5TmhZekxNN0Y0aXBidmw2a2lKSDQ3aEtGTllV?=
 =?utf-8?B?c1MvdVBJeDQzRFBUMjVxUThwVnV6QU04Qk82dkxrZk91RmpBOGk2anNTZVRN?=
 =?utf-8?B?ZWd4UzhxU3NYdjhQNVo2ajM3WVlFWHlQODNCUElpOFVsSjV1ZERaeWRsTmE3?=
 =?utf-8?B?UDFrcGhVSXdrNFN0dVNRWmdzcm14OG5uemhuc1YrT2JzM0trYnZxK0ZVN05J?=
 =?utf-8?B?b2M4d1VGRHZ5bjJBWG45UFRmeEl1a05Pd3hqeFpwckYwZm1IYXVnb25mdHRq?=
 =?utf-8?B?Qk1GTGhYeWlHeDg1NTBPOXNXQjJpR2UrR2p5Tkh4ekozc1pDVWo2Z1ZBNEw5?=
 =?utf-8?B?dmJ2dlFhdUR4QXpxRXFBTjdXZGExeEFNemNPSmZKK3hpUm1aMGwwaVpKeUpy?=
 =?utf-8?B?dHZ1L05iQit5Z21hVFpsUFpQNktVWGNtSmNVaUxUcHJ4MFErQUllN3Uzb0VX?=
 =?utf-8?B?UFBaNjFsYUFVT3E5N3REZlU0ZXJPUjBFTE5xYkdKYStQN3NXUU1KZ1lZVEdZ?=
 =?utf-8?B?N2kya0o1YlhKRWNBRm54d3ZKbjFlZWhka0g2NTJBWjFRNFN2MVNscUw5ZzBN?=
 =?utf-8?B?ZVB0b1N0K1VXeHp6Q3prNzR6UFBBZ3pOU2dOejRNNXRTUlVINWtNSTJ2Y3Er?=
 =?utf-8?B?TmJ6bGtzeHpxRDBoYmlqWVJhQzRJRUdGNDNJVjNPaXh6azlVQ2c3SzdTaE9M?=
 =?utf-8?B?ZjZGRzlPMTRmQUJ2Snc4U2ZHQTlQUkxOcGg1TWNRQlA2ZVAyRmVqcWh1Q3A1?=
 =?utf-8?B?RWpkY0VIc0tTMjJJZHc1YWdqYkh2WjIxbXVYWDkvM2tjT2ZSSElmdlB3Q0pT?=
 =?utf-8?B?Vm5FdENpWnM5aU9lS2dDVS9oYkJNTjlnQXFhRVd2RFkybENQUm5kb2ZoQXFr?=
 =?utf-8?B?SlZNN240U1J2QmtzL1lGOFJ3UFE1N2dQUnBYU3d6VXhGUnBVWGxNdVc1aWZB?=
 =?utf-8?B?RUJEbFcwUTlQVG1NUTFLbEM5c2hZU2JyZm1MQWl4UkI5T0RRV0liSXhKN2E2?=
 =?utf-8?B?NThsS2xxcmltRlU4WElOVmgzeENFc1YyRFNhYUlLU2ducCtoTWVvcFovOHI3?=
 =?utf-8?B?OFV4bjV4TkpMblVhUlU2ZHBKZWtpdE90TmZxRHFFdnhvSjVNamN0RVp0V3ht?=
 =?utf-8?B?dEJ0cE5hNmVYY3ZZdTBpTU8yUEtmaVlOUFM0MkRnRjVleFA3V0ZEVnBENkxD?=
 =?utf-8?B?NSs0K1pycko1TnJWSEZpL0xOQ0lqZXJBaXFCdFFqd214RjMwVHgxTVVJaHN0?=
 =?utf-8?B?NU9YeThXQ2t1MHV3dGJVdkVldUcra1VqQk9FSmZWdnJFTzMwbU9TZVNxMFV3?=
 =?utf-8?B?QWF4MzdMZW9rdUdDMEVnRkt6dFJqT0R0TkRjdTB2Q2EyNDRGamZrZnhrb1F5?=
 =?utf-8?B?elV1QUVJcXcxQktjNzNLMndKYUtkMzJKbEhQUzUrRG5tQ1RSQVN4N1oyWHd2?=
 =?utf-8?B?MG1YbzFoN2hGdWx6MENsaUhZckdKcVVzb1M3QUhrT3hiUXcrQW05c1E3M3Mw?=
 =?utf-8?B?VnQ0ejJTVWE1anRBa2ZZMURsUnZBcEE5VDIyWGVyYzJ4U2JlbG1XVHV1OVFn?=
 =?utf-8?B?Y3ZDUzlvc2pDaXpsT0FSSDFMMzVVYTZsTGYyT3FjYkdUanVMV3hHMllvaFZl?=
 =?utf-8?B?cTlsQ0pGNXVsR2wvTVBhcXpiZDh4SnFNcS9NMXdUTk5WSlRpZlFmUTBLZzJO?=
 =?utf-8?B?Y1UycU9UcmIxVW10ZFd0aHkrZzUybzRhM1JpL2tWSTJjc1V2R3VLc01wRWpG?=
 =?utf-8?Q?YCajyZF5MOXXRdFQo7xOJVo9f1Yjl7Ye?=
X-Forefront-Antispam-Report:
 CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 4Fwd16utALMORYePbfWPySLEGFrchEcQL1HJB0WxvE5zvtrrzintyYoAj1o63Vcpk8KrZXiDJZIkfbAjrDt+uGjQw1HW0Y2iAmNU2qwc8MZWQMwyCxFQPG0LWAnMHK0qBEhM1j6QksjiEnTnohgqaeu48r4lQR06nia62K2oYigGYa1U4eYn3OfU+U7sXoxlTtdnHjMh7RTVZ7ZuGlBRgJmD+YzhFv9/Hver4kHVplZGxzFJ47GtSUMAWYLoeA1HpaZiYHJe6ciNc4uRQFxCwGGGGKKGuMjC731QInn+nqqQVph3dPEfgK4NHWS59bhcAVaZ/tX3mkY1cbcjtbS0Z+5mdpIXlm8drqPJ5E3v4BLlbKYW93ViNCEPFMQHyBEz8MnF68WOqzykfiUREWTg7zoXKTG7HSW7xo46Mp0ZFPUlJcOw4H0nBQpMdaqh0S0qJOos5yXvRxUEExL9YIRkbiE0qjYqcoCfj/n9QM3BXKTS8ZkZsdBwNqwjoAXZHWTdhSn/PIKWGTjRfBnBhoHsoxxF9lRmkhvLjqbtUE5HjsYci88O1e0AWJfYp3mSbMDBIc6EJp5hAie1gSWfYZKhjd7zLDEx8IqnF0Fy6MKHw7ugIGwDKZXxSaG7HbYD+hqxC8j8iBVpI0YT18wtKkma1A==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 14:56:56.1330
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e10e36d2-3f48-4cad-eb46-08dd1861b9ab
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
 SA2PEPF0000150B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR19MB4228
X-OriginatorOrg: ddn.com
X-BESS-ID: 1733761804-104803-13418-14614-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.70.48
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVuZGBkZAVgZQ0Dg1JdnM2MLcPN
	HMNM0w0TQ5NcXM2Mg0LdkiJSnFIC1VqTYWAGw4wEBBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260998 [from 
	cloudscan9-122.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
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
---
 fs/fuse/dev_uring.c   | 87 ++++++++++++++++++++++++++++++++++++++++++---------
 fs/fuse/dev_uring_i.h | 12 +++++++
 2 files changed, 85 insertions(+), 14 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 8bdfb6fcfa51976cd121bee7f2e8dec1ff9aa916..be7eaf7cc569ff77f8ebdff323634b84ea0a3f63 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -168,6 +168,7 @@ void fuse_uring_destruct(struct fuse_conn *fc)
 
 	for (qid = 0; qid < ring->nr_queues; qid++) {
 		struct fuse_ring_queue *queue = ring->queues[qid];
+		struct fuse_ring_ent *ent, *next;
 
 		if (!queue)
 			continue;
@@ -177,6 +178,12 @@ void fuse_uring_destruct(struct fuse_conn *fc)
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
@@ -262,6 +269,7 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 	INIT_LIST_HEAD(&queue->ent_in_userspace);
 	INIT_LIST_HEAD(&queue->fuse_req_queue);
 	INIT_LIST_HEAD(&queue->fuse_req_bg_queue);
+	INIT_LIST_HEAD(&queue->ent_released);
 
 	queue->fpq.processing = pq;
 	fuse_pqueue_init(&queue->fpq);
@@ -294,24 +302,27 @@ static void fuse_uring_stop_fuse_req_end(struct fuse_ring_ent *ent)
 /*
  * Release a request/entry on connection tear down
  */
-static void fuse_uring_entry_teardown(struct fuse_ring_ent *ent,
-					 bool need_cmd_done)
+static void fuse_uring_entry_teardown(struct fuse_ring_ent *ent)
 {
-	/*
-	 * fuse_request_end() might take other locks like fi->lock and
-	 * can lead to lock ordering issues
-	 */
-	lockdep_assert_not_held(&ent->queue->lock);
+	struct fuse_ring_queue *queue = ent->queue;
 
-	if (need_cmd_done)
+	if (ent->need_cmd_done)
 		io_uring_cmd_done(ent->cmd, -ENOTCONN, 0,
 				  IO_URING_F_UNLOCKED);
 
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
@@ -331,15 +342,15 @@ static void fuse_uring_stop_list_entries(struct list_head *head,
 			continue;
 		}
 
+		ent->need_cmd_done = ent->state != FRRS_USERSPACE;
+		ent->state = FRRS_TEARDOWN;
 		list_move(&ent->list, &to_teardown);
 	}
 	spin_unlock(&queue->lock);
 
 	/* no queue lock to avoid lock order issues */
 	list_for_each_entry_safe(ent, next, &to_teardown, list) {
-		bool need_cmd_done = ent->state != FRRS_USERSPACE;
-
-		fuse_uring_entry_teardown(ent, need_cmd_done);
+		fuse_uring_entry_teardown(ent);
 		queue_refs = atomic_dec_return(&ring->queue_refs);
 
 		WARN_ON_ONCE(queue_refs < 0);
@@ -447,6 +458,49 @@ void fuse_uring_stop_queues(struct fuse_ring *ring)
 	}
 }
 
+/*
+ * Handle IO_URING_F_CANCEL, typically should come on daemon termination.
+ *
+ * Releasing the last entry should trigger fuse_dev_release() if
+ * the daemon was terminated
+ */
+static int fuse_uring_cancel(struct io_uring_cmd *cmd, unsigned int issue_flags)
+{
+	struct fuse_ring_ent *ent = fuse_uring_cmd_to_ring_ent(cmd);
+	struct fuse_ring_queue *queue;
+	bool need_cmd_done = false;
+	int ret = 0;
+
+	/*
+	 * direct access on ent - it must not be destructed as long as
+	 * IO_URING_F_CANCEL might come up
+	 */
+	queue = ent->queue;
+	spin_lock(&queue->lock);
+	if (ent->state == FRRS_WAIT) {
+		ent->state = FRRS_USERSPACE;
+		list_move(&ent->list, &queue->ent_in_userspace);
+		need_cmd_done = true;
+	}
+	spin_unlock(&queue->lock);
+
+	if (need_cmd_done) {
+		io_uring_cmd_done(cmd, -ENOTCONN, 0, issue_flags);
+	} else {
+		/* io-uring handles resending */
+		ret = -EAGAIN;
+	}
+
+	return ret;
+}
+
+static void fuse_uring_prepare_cancel(struct io_uring_cmd *cmd, int issue_flags,
+				      struct fuse_ring_ent *ring_ent)
+{
+	fuse_uring_cmd_set_ring_ent(cmd, ring_ent);
+	io_uring_cmd_mark_cancelable(cmd, issue_flags);
+}
+
 /*
  * Checks for errors and stores it into the request
  */
@@ -841,6 +895,7 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 	spin_unlock(&queue->lock);
 
 	/* without the queue lock, as other locks are taken */
+	fuse_uring_prepare_cancel(ring_ent->cmd, issue_flags, ring_ent);
 	fuse_uring_commit(ring_ent, issue_flags);
 
 	/*
@@ -890,6 +945,8 @@ static void _fuse_uring_register(struct fuse_ring_ent *ring_ent,
 	struct fuse_conn *fc = ring->fc;
 	struct fuse_iqueue *fiq = &fc->iq;
 
+	fuse_uring_prepare_cancel(ring_ent->cmd, issue_flags, ring_ent);
+
 	spin_lock(&queue->lock);
 	fuse_uring_ent_avail(ring_ent, queue);
 	spin_unlock(&queue->lock);
@@ -1039,6 +1096,9 @@ int __maybe_unused fuse_uring_cmd(struct io_uring_cmd *cmd,
 		return -EOPNOTSUPP;
 	}
 
+	if ((unlikely(issue_flags & IO_URING_F_CANCEL)))
+		return fuse_uring_cancel(cmd, issue_flags);
+
 	/* This extra SQE size holds struct fuse_uring_cmd_req */
 	if (!(issue_flags & IO_URING_F_SQE128))
 		return -EINVAL;
@@ -1170,7 +1230,6 @@ void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req)
 
 	if (ring_ent) {
 		struct io_uring_cmd *cmd = ring_ent->cmd;
-
 		err = -EIO;
 		if (WARN_ON_ONCE(ring_ent->state != FRRS_FUSE_REQ))
 			goto err;
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 8c5e3ac630f245192c380d132b665d95b8f446a4..4e670022ada2827657feec8e5165e56dbfb86037 100644
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
@@ -49,6 +55,9 @@ struct fuse_ring_ent {
 	 */
 	unsigned int state;
 
+	/* The entry needs io_uring_cmd_done for teardown */
+	unsigned int need_cmd_done:1;
+
 	struct fuse_req *fuse_req;
 
 	/* commit id to identify the server reply */
@@ -84,6 +93,9 @@ struct fuse_ring_queue {
 	/* entries in userspace */
 	struct list_head ent_in_userspace;
 
+	/* entries that are released */
+	struct list_head ent_released;
+
 	/* fuse requests waiting for an entry slot */
 	struct list_head fuse_req_queue;
 

-- 
2.43.0


