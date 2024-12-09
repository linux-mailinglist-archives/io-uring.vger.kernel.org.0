Return-Path: <io-uring+bounces-5330-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8764F9E99BD
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 16:00:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DFAB918893A3
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 14:59:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95352222D66;
	Mon,  9 Dec 2024 14:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="Nnn8VMR9"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063611F0E54;
	Mon,  9 Dec 2024 14:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733756229; cv=fail; b=mnVGm99CKVHIjJNOmBDuebXjQwdPfzAGGVNcBm6zaqiWZuSsLFtxek29wZmKmDs3aetn2yXec/IFmqe+0OaNjnUlG8YSNl3pq787qNzzXuAP1svYxiKS3yylrEAXaujT2yROigzFxJ1ZEEQeaL3XRjrp6/YUhLyspPtBszsNYqA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733756229; c=relaxed/simple;
	bh=IBtFZfkLCG2fc0bSnwFdChR2irmJWWPIqSSm4VNXsiA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=a/z3QfXXZSQDseRoZs/yHrj/Ddz7GhGy1y8uvsaGf0oKKSfcGU1MyK3nvt7J24OwyXU8XS/BR4mZc/8fwqiJCNsf7lJ5mtRa3OLIKTVpx/pz5Qy5bckQCrgW337ypIr3L9qiOPscNKKeHs9BaE1duRrZ4bDLCduPsaBTPYPBk3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=Nnn8VMR9; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168]) by mx-outbound12-196.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 09 Dec 2024 14:56:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FoNA4ixchfjpVRUQNMhiRR33yhWGfXicokCywNnXVcDf0Yn9AxtxzGIuydNBKWOcRCLcW+MZGtdQ9KGG7C+Wx2tejtpRiw8x65c7NKXO3RW2XT3GXq0D5zGE9BGzDkW2mIm9BM2Kv/vk6ZM7+iZSlXirlbitr91iVwzkpUOGrWETkYXcQ8rNB64yR+W1vL8aL6B/oCIbmih6G4af5j8NhSRTl3fXSImAmAjAX9vVvAPwEKr2IeGs0SdbRGyRnaGozmCKDhTejPk9iQQX43OEKqAZb3lN0bieFLMcCKeLm/EP0OUCFUfAdJ5bgZbNrOjx0m1LlQgo3u/yt0fyk+ZF0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A3Rhwr+YML1ti0F6RX7ueIl02XEWTedI9bT1g3RxC6o=;
 b=VnVIUxtvJEnFmuUYzW32vOSNs5gUZ0Qqp6mGq6Q1qEuNG4Y4YolA5NkGA6CA9URMi54AXlauOiohA743mMUt7Na0cOFb5Gkb9Ha4PemIHpr8bj7l1etAqHF6765fvucVp4XPt2GntwTad1BbwK93DviHG0W1sEq5qQZLsXN2BThta127yPlvoXMwrNGRTctnWJKAAFi6KgfdXnB45eXgs/vMeCHftlphEjHBKyVUD41tJ24xeUOKMPNxOZFiVlq/kImQwZQnm+3OE69b6NNZLk7voNFwPtoxovs4nypqgzRo809jE2C/xJpR8yfx59Lb3HrcTadTSEIK+F4+YNnusQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A3Rhwr+YML1ti0F6RX7ueIl02XEWTedI9bT1g3RxC6o=;
 b=Nnn8VMR9FasHM1wmGX0creOK1AYAj/o/xxV5MF7jVhAY5oBl+zryYSdwh/RgLQD7ygO6jsS1wbHP+p4Sc9IVu3aE/fvHdnfiXKOOI7+69WwQw497KUBDQuCFhUNElpzR+Hxz8TjEticH9r2Frhi5m8dplohFp9UxWgKIaNfPfv8=
Received: from CH2PR14CA0005.namprd14.prod.outlook.com (2603:10b6:610:60::15)
 by PH0PR19MB5364.namprd19.prod.outlook.com (2603:10b6:510:f6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Mon, 9 Dec
 2024 14:56:55 +0000
Received: from CH2PEPF0000013B.namprd02.prod.outlook.com
 (2603:10b6:610:60:cafe::25) by CH2PR14CA0005.outlook.office365.com
 (2603:10b6:610:60::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.14 via Frontend Transport; Mon,
 9 Dec 2024 14:56:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CH2PEPF0000013B.mail.protection.outlook.com (10.167.244.68) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.7
 via Frontend Transport; Mon, 9 Dec 2024 14:56:54 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 71B314A;
	Mon,  9 Dec 2024 14:56:53 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 09 Dec 2024 15:56:36 +0100
Subject: [PATCH v8 14/16] fuse: Allow to queue bg requests through io-uring
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241209-fuse-uring-for-6-10-rfc4-v8-14-d9f9f2642be3@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733756199; l=7102;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=IBtFZfkLCG2fc0bSnwFdChR2irmJWWPIqSSm4VNXsiA=;
 b=w1OCg2JJEuR3HbNXo1jpQ0ZtXDqb0ws180QPYsBW9KvhZm7s9osxim8qJgBpSlr9e38Ku48cv
 r5+nAYyK2z9A7SvA7KC2BIjyVehIjHXsC7olKOJ0+FGpYvYlGSreLLH
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013B:EE_|PH0PR19MB5364:EE_
X-MS-Office365-Filtering-Correlation-Id: 943612b4-d742-4e8a-fc2e-08dd1861b883
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YkNxOEtGOFNIZEQyaFcxWVlnRmZZU0crSjJSdHMrSFk2Y2I4aXZCb2VsWjZL?=
 =?utf-8?B?N25wYW8rTkdjTzV3ODBEYml6cEJpUlRBa2Y2SnhMUUtHSzhBTFc0SVRmeVZt?=
 =?utf-8?B?NDJ0QkZFdlhaUTQ5dk1ld2U2R3lrelhFbDVnMVZTOVJsT1J2aU82VmZ3cEFn?=
 =?utf-8?B?RGMxVW9TamVqMFBjQnNDbWs2c0loN3RJK3BnNjBFc0lCa3FXRW5pK0dvMUV0?=
 =?utf-8?B?NHNhbVA2TkZmM1Q1TkNDS0FhR3JTQy96MkFkNTllbFdicWNwaVB4TTR4TjdM?=
 =?utf-8?B?c290TmJhWmJHUjJaYkpoVmRVbU16eEhWTW5QQzZyWkJkdjM3enZZd281VFMx?=
 =?utf-8?B?QjB2dWhoTEMwbXlVc2gwdklDWHcyU1JNOFE4MVFFTzFNTjBnclFzRFppdC9i?=
 =?utf-8?B?dUlMa3FhVlFSU0tqN05UUzBaaFBINC9CMzNrZ3NlYkZDcWQ1WTZmTTl3RnZO?=
 =?utf-8?B?TnFYMFJXS0xHUFp6TmdDaFdlRFJkVk9lU1V5QWIvbkxIL0NwT0x2WHhVWEt6?=
 =?utf-8?B?M2dydHUxNTVURXl2ZnhKOTIwamIyV0JLUUgwbVU2dk1KZ1FqU3laNko3SThH?=
 =?utf-8?B?OTBLb2R6ZjNIdkQ5aUthTEsrMHN2YmFwWXpzR280cEp2aEIvcURETlN3TTBq?=
 =?utf-8?B?VTFWamIwWFFrWmxKdjhNRDVQR2VrTlNoOEc5K0NtSkI3OWJCaWtYU2RGTE1E?=
 =?utf-8?B?cXg1TEd1dGF4aXlLYXk0NXhzaS9KalUrdTFjTzR2ZEd1aFdkb093blNGcWNp?=
 =?utf-8?B?Y0VUK1lMNnFKeUhGZnF0SEVieVl2VGd1dzNDSVF2KzFMVitVV1VpTkVCcHk1?=
 =?utf-8?B?V3pVYUhFZVZOekdSR1NrRVd3Y01ReWk1dU5HMzk0bFZGRXRNMWJ2WkpQdk1z?=
 =?utf-8?B?MnB2RGZTRlVpYkZHejB1NmRDaVFsTUUyZERUbEVlQjVpOUxCdUlVSGJrQXlk?=
 =?utf-8?B?QmVmSE96dlhBZmJKYnpsWEZaa1lQajNFcnFzZEMwbVd5MjVuVitlY3E1T3Vj?=
 =?utf-8?B?Nk16VklkZDdDU2dJSVNReUZYRk15Z01kblJvWis0NmI0dUNhalh3ZDJGVWlY?=
 =?utf-8?B?Z1V1RnUwL25VYmZZdG0xaklZcWkxNHN0V1RoZDRKam1aOWZWQ0o2cmM2WU5n?=
 =?utf-8?B?L2U0SkkrMU8yamRvbCs3cVQ1VVhHM2VUQmVyOFdJVktlYU5JYzNEaDNEWTVD?=
 =?utf-8?B?ZVptZ1c2K0RUQkhQWEhoQS8zZC8rTTRObGNrWEtNalpyeVRRTnhkUzM3Y0Jh?=
 =?utf-8?B?aEs1VFF3SjVJWG1KRXZ3dWFNRkc1cUczN1h1czFHVG1ERUdyUm93K2F2UkVN?=
 =?utf-8?B?aHRqQW1Kd2dVVXdVUjhGOUcrSUpBVDdOQ3VnV1NwOEpVZ2hsMHdFcVhtOWN3?=
 =?utf-8?B?bHdyRGZmOEtKREo2YzZEQ3RJY0N2M3BEN1o2WEdzY0NzRzhJZUVvNlNlTkJS?=
 =?utf-8?B?QTNnanVEWEdxa2hGTjk0N1B2WkJmYTRWaFFFZ0dsT1BCYm5oci90VE8zcUo0?=
 =?utf-8?B?RWNtV29vQ2JzR29kWS9zKy9XbVR6UldNRmZSejQrSjNkQ1cyWFROWklHNU9h?=
 =?utf-8?B?YWVYLzJnVU9laDNEZFlYYzByMnpzWDVpUnlZUnMzNFI3T1FVcHB0Sk9GWUVo?=
 =?utf-8?B?aDNuYUNQWTlJTm0zT0VSY3lxMWZ6d044Ky9BTlM0UXJScDV3NjVoWTBPZnkv?=
 =?utf-8?B?aEFsZ3FDVzNvY3oxOHpkOHhyMGhmSHh1QVRhWmwwcGZieisrd3FCMjlvUUM4?=
 =?utf-8?B?amYyUkYxdk0xY0FsWVlBOU1acnlOZENRRmxtUUNtbmc5YWZ2dVZ5Z2tPMXhU?=
 =?utf-8?B?TUpwSi9uWGdRVkxvV1dBcU1mWFcrNDhBMWFjWmF1TzZ1Wk40TVZVWFFPeDRk?=
 =?utf-8?B?L3JYYzdLbjRIMHdkMXJNSEN1RHNqSndWaUQ5OTNkMjJ3eW5RdUo4ZCt2bkNn?=
 =?utf-8?Q?Q8JFtCRaU8d5xcqbkatnNu5AEwqUo5I1?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Z6RqpChtq/L8dAY22m78o+mOzqFdW/5F8jtPW2Ddrg8yZ+Jy+a77DvsMPNZPp0+Hrphf6ZiIuehH/s720u8XIOa78aJGJ8urZxWkGXrsa7dE3u2O0jtXxFKYIdutJgzxTUSIL620OSgdXKWavzCNwODCUEV1gN53SF5KXOzJ/3ijWX4JB3j37r1uiB2GSYgj6JQ3OIaX49vAgKAOYc78CLa5FVl0yjgEEGbdAcpucHmK38iMOekJIDPvbkKLbmBmang7ou7mTIljIl6hhltjjDZT8VTLkTKZ/ErDk30lSpL1xkaM7eqSeY0GLSVJQhhNLLDinxiyog3xHrVr/dqOR3CZvZQqhgtJZWfFoawt8ATLFUXmyiFAgNmlsF8Q+hMG482WqS0RWoM2Ul+QA2+9w4y91jJr9GsDw+LgW/tJBp61Tgp6axYN6F9tXYJSuRS1+DrAvClr9wzmK2ToXB44b2qZ8i8hs3avnmrTpvF4kATcWQ6rJsqsWv5HJmnHRoe7FL40zGmqk9Ex1yCFsOjL+33fdcAT5wLYyo8neUEf4VCuDJoGGqqAueBao16/j4bkDn2SYADQFwY82o4hqWQNF2jB9X28iXjOHubB0rtovktMdxLR5pIYB/gJEJk4vSvxIufawCSuCo08Yb+2pHUBhA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 14:56:54.1936
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 943612b4-d742-4e8a-fc2e-08dd1861b883
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR19MB5364
X-BESS-ID: 1733756219-103268-13464-5361-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.55.168
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVmYW5hZAVgZQMMUs0cIsKdXQON
	HUJMnAyMQk1dTMNMXU2NzSOM3cMs1cqTYWABE09VJBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260997 [from 
	cloudscan13-203.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This prepares queueing and sending background requests through
io-uring.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c         | 26 +++++++++++++-
 fs/fuse/dev_uring.c   | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h |  6 ++++
 3 files changed, 130 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 71f2baf1481b95b7fe10250e348cfba427199720..8f8aaf74ee8dfbe8837f48811138d4ff99b44bba 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -568,7 +568,25 @@ ssize_t __fuse_simple_request(struct mnt_idmap *idmap,
 	return ret;
 }
 
-static bool fuse_request_queue_background(struct fuse_req *req)
+#ifdef CONFIG_FUSE_IO_URING
+static bool fuse_request_queue_background_uring(struct fuse_conn *fc,
+					       struct fuse_req *req)
+{
+	struct fuse_iqueue *fiq = &fc->iq;
+
+	req->in.h.unique = fuse_get_unique(fiq);
+	req->in.h.len = sizeof(struct fuse_in_header) +
+		fuse_len_args(req->args->in_numargs,
+			      (struct fuse_arg *) req->args->in_args);
+
+	return fuse_uring_queue_bq_req(req);
+}
+#endif
+
+/*
+ * @return true if queued
+ */
+static int fuse_request_queue_background(struct fuse_req *req)
 {
 	struct fuse_mount *fm = req->fm;
 	struct fuse_conn *fc = fm->fc;
@@ -580,6 +598,12 @@ static bool fuse_request_queue_background(struct fuse_req *req)
 		atomic_inc(&fc->num_waiting);
 	}
 	__set_bit(FR_ISREPLY, &req->flags);
+
+#ifdef CONFIG_FUSE_IO_URING
+	if (fuse_uring_ready(fc))
+		return fuse_request_queue_background_uring(fc, req);
+#endif
+
 	spin_lock(&fc->bg_lock);
 	if (likely(fc->connected)) {
 		fc->num_background++;
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 5767fb7a501ac7253aa8a598a1aba87b65da0898..8bdfb6fcfa51976cd121bee7f2e8dec1ff9aa916 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -49,10 +49,52 @@ static struct fuse_ring_ent *fuse_uring_cmd_to_ring_ent(struct io_uring_cmd *cmd
 	return pdu->ring_ent;
 }
 
+static void fuse_uring_flush_bg(struct fuse_ring_queue *queue)
+{
+	struct fuse_ring *ring = queue->ring;
+	struct fuse_conn *fc = ring->fc;
+
+	lockdep_assert_held(&queue->lock);
+	lockdep_assert_held(&fc->bg_lock);
+
+	/*
+	 * Allow one bg request per queue, ignoring global fc limits.
+	 * This prevents a single queue from consuming all resources and
+	 * eliminates the need for remote queue wake-ups when global
+	 * limits are met but this queue has no more waiting requests.
+	 */
+	while ((fc->active_background < fc->max_background ||
+		!queue->active_background) &&
+	       (!list_empty(&queue->fuse_req_bg_queue))) {
+		struct fuse_req *req;
+
+		req = list_first_entry(&queue->fuse_req_bg_queue,
+				       struct fuse_req, list);
+		fc->active_background++;
+		queue->active_background++;
+
+		list_move_tail(&req->list, &queue->fuse_req_queue);
+	}
+}
+
 static void fuse_uring_req_end(struct fuse_ring_ent *ring_ent, bool set_err,
 			       int error)
 {
+	struct fuse_ring_queue *queue = ring_ent->queue;
 	struct fuse_req *req = ring_ent->fuse_req;
+	struct fuse_ring *ring = queue->ring;
+	struct fuse_conn *fc = ring->fc;
+
+	lockdep_assert_not_held(&queue->lock);
+	spin_lock(&queue->lock);
+	if (test_bit(FR_BACKGROUND, &req->flags)) {
+		queue->active_background--;
+		spin_lock(&fc->bg_lock);
+		fuse_uring_flush_bg(queue);
+		spin_unlock(&fc->bg_lock);
+	}
+
+	spin_unlock(&queue->lock);
 
 	if (set_err)
 		req->out.h.error = error;
@@ -97,6 +139,7 @@ void fuse_uring_abort_end_requests(struct fuse_ring *ring)
 {
 	int qid;
 	struct fuse_ring_queue *queue;
+	struct fuse_conn *fc = ring->fc;
 
 	for (qid = 0; qid < ring->nr_queues; qid++) {
 		queue = READ_ONCE(ring->queues[qid]);
@@ -104,6 +147,13 @@ void fuse_uring_abort_end_requests(struct fuse_ring *ring)
 			continue;
 
 		queue->stopped = true;
+
+		WARN_ON_ONCE(ring->fc->max_background != UINT_MAX);
+		spin_lock(&queue->lock);
+		spin_lock(&fc->bg_lock);
+		fuse_uring_flush_bg(queue);
+		spin_unlock(&fc->bg_lock);
+		spin_unlock(&queue->lock);
 		fuse_uring_abort_end_queue_requests(queue);
 	}
 }
@@ -211,6 +261,7 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 	INIT_LIST_HEAD(&queue->ent_w_req_queue);
 	INIT_LIST_HEAD(&queue->ent_in_userspace);
 	INIT_LIST_HEAD(&queue->fuse_req_queue);
+	INIT_LIST_HEAD(&queue->fuse_req_bg_queue);
 
 	queue->fpq.processing = pq;
 	fuse_pqueue_init(&queue->fpq);
@@ -1138,6 +1189,54 @@ void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req)
 	fuse_request_end(req);
 }
 
+bool fuse_uring_queue_bq_req(struct fuse_req *req)
+{
+	struct fuse_conn *fc = req->fm->fc;
+	struct fuse_ring *ring = fc->ring;
+	struct fuse_ring_queue *queue;
+	struct fuse_ring_ent *ring_ent = NULL;
+
+	queue = fuse_uring_task_to_queue(ring);
+	if (!queue)
+		return false;
+
+	spin_lock(&queue->lock);
+	if (unlikely(queue->stopped)) {
+		spin_unlock(&queue->lock);
+		return false;
+	}
+
+	list_add_tail(&req->list, &queue->fuse_req_bg_queue);
+
+	ring_ent = list_first_entry_or_null(&queue->ent_avail_queue,
+					    struct fuse_ring_ent, list);
+	spin_lock(&fc->bg_lock);
+	fc->num_background++;
+	if (fc->num_background == fc->max_background)
+		fc->blocked = 1;
+	fuse_uring_flush_bg(queue);
+	spin_unlock(&fc->bg_lock);
+
+	/*
+	 * Due to bg_queue flush limits there might be other bg requests
+	 * in the queue that need to be handled first. Or no further req
+	 * might be available.
+	 */
+	req = list_first_entry_or_null(&queue->fuse_req_queue, struct fuse_req,
+				       list);
+	if (ring_ent && req) {
+		struct io_uring_cmd *cmd = ring_ent->cmd;
+
+		fuse_uring_add_req_to_ring_ent(ring_ent, req);
+
+		fuse_uring_cmd_set_ring_ent(cmd, ring_ent);
+		io_uring_cmd_complete_in_task(cmd, fuse_uring_send_req_in_task);
+	}
+	spin_unlock(&queue->lock);
+
+	return true;
+}
+
 const struct fuse_iqueue_ops fuse_io_uring_ops = {
 	/* should be send over io-uring as enhancement */
 	.send_forget = fuse_dev_queue_forget,
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index bea4fd1532083b98dc04ba65c9a6cae2d7e36714..8c5e3ac630f245192c380d132b665d95b8f446a4 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -87,8 +87,13 @@ struct fuse_ring_queue {
 	/* fuse requests waiting for an entry slot */
 	struct list_head fuse_req_queue;
 
+	/* background fuse requests */
+	struct list_head fuse_req_bg_queue;
+
 	struct fuse_pqueue fpq;
 
+	unsigned int active_background;
+
 	bool stopped;
 };
 
@@ -132,6 +137,7 @@ void fuse_uring_stop_queues(struct fuse_ring *ring);
 void fuse_uring_abort_end_requests(struct fuse_ring *ring);
 int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
 void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req);
+bool fuse_uring_queue_bq_req(struct fuse_req *req);
 
 static inline void fuse_uring_abort(struct fuse_conn *fc)
 {

-- 
2.43.0


