Return-Path: <io-uring+bounces-5066-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DC329DA8AA
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 14:41:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06864161323
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 13:41:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 797B71FCFC7;
	Wed, 27 Nov 2024 13:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="lmEYKcuH"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22765B1FB;
	Wed, 27 Nov 2024 13:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732714861; cv=fail; b=gTMAgMDoGVYCeuukXM3Jl/cOtNHSi0f/NUiY0EdbZK41gYUE6SiuJVRFsLqgmZTaT/xKK4y2RnvH6FxuSYznCBOb6crJe1++LPrI5MdZQ8N7RkDZ/uReXFpZDNRtbY0+BhQZN2ID2VY5ojKs65nb1KfnQ8ybZmYmf1yU2zy4ako=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732714861; c=relaxed/simple;
	bh=sEIiB7AIiRc3jMjR3gv1PdToWrjtBVAJ4sQGmmcVMqk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ErA8fTpPYzasqFfLwKkJcRUdOROqqJ5DpY+r1zHe1QyQf68I6i6RRL7NfZyjsXbOcGSkDTLtQjjZ9Y8CsAhMp3WmBGHwlG/IsAMKXyDjAJ2sY63/fGpOfubbjuOUx/wQQK4dmjB88LTY1DxO4XePPswjEv5irixZ7BkpVHoi4ag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=lmEYKcuH; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173]) by mx-outbound20-30.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 27 Nov 2024 13:40:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ODFXl9wobYrrcG0TfpaQXDJIC+ZFWfbqjqUVF/toGNAHXm7No9K9z9vqUIoEMYp5e/HXr7xqptJXSdVvtonjluCS1MrtIhNEMwd9H/eXfNGFWO+G8WA7vNI7MN4RhQvoWvqU1w3Sq/H56d0w2sc+uMNQDY6iUTP2jy6ywnHmB6TSda0e8c+APSoL0suMSYCH0CqR4FovDMWwsZVAQKgZbq0fDYhp/oaRnBHyVIlbCA9g5dZVT8WNN8qcSrySR3OIFa3Hw6xqBCQ02YbsrykDo0i9mAheM1QGyOaX2qwug1CrdFfAFJWiJPNwpKBgq/Rga8MSBoy8OZHkMdtvBHuYKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZOj4aqAydY/9noAr2EY9n3L9DL+3fCRE1kSPSGv99KU=;
 b=Eua9vrRk6sJaIbIdCrTvUv2Y5jQSKaQaIgR/z+fco71P9RwLB7rfsKlasEGdaNjKzv8G/55rf+GHUbb8EhbzT4xUoOkrCTawoGu582ANcE0Nz3u/aKu3v9MoxofnKE/DiAdwcQWw2cDQKCvvM2uMx21kl3n8orpsvvZeSstfK1P/Y7PasEg+rkB0+k/0xGKL+kFN1akCquHvcS1Jnng0wehR+rpZfcD07OG3BLDDJIkBx9D2fUv6cOXkhw4zpD2T/ehEFnjxgCkdDC6IIXfmwjCF1zxoFUgEfrOQjKPs8x8AIftYIXpXFWAXK5DR0xdHloPTBUojV8ACmNE7bXry1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOj4aqAydY/9noAr2EY9n3L9DL+3fCRE1kSPSGv99KU=;
 b=lmEYKcuHMjVdxHXDE46VtC4v1/V+PV1fRxm9aOQbw+rqtvjYiWBgWlTGmayn3WSlQG1FaAyPVbFA4uge3rgUqal8B9DPPLyLs0Tle8ivTqHQd4cZ6f7+uwjIgu+GC55lsCGQrO1qdQorRupSo/Jw3e02d/U34eLNOEJG+jvx5mg=
Received: from MW4PR03CA0012.namprd03.prod.outlook.com (2603:10b6:303:8f::17)
 by SJ0PR19MB4637.namprd19.prod.outlook.com (2603:10b6:a03:286::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.13; Wed, 27 Nov
 2024 13:40:41 +0000
Received: from CO1PEPF000044FA.namprd21.prod.outlook.com
 (2603:10b6:303:8f:cafe::80) by MW4PR03CA0012.outlook.office365.com
 (2603:10b6:303:8f::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8182.19 via Frontend Transport; Wed,
 27 Nov 2024 13:40:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CO1PEPF000044FA.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.0
 via Frontend Transport; Wed, 27 Nov 2024 13:40:41 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 5311732;
	Wed, 27 Nov 2024 13:40:40 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 27 Nov 2024 14:40:18 +0100
Subject: [PATCH RFC v7 01/16] fuse: rename to fuse_dev_end_requests and
 make non-static
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241127-fuse-uring-for-6-10-rfc4-v7-1-934b3a69baca@ddn.com>
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
In-Reply-To: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732714838; l=2729;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=sEIiB7AIiRc3jMjR3gv1PdToWrjtBVAJ4sQGmmcVMqk=;
 b=m3DkHEAypBLj9lFlU8yLNiwkbe1aHTj28w9wSIhk44sdF/kXBSAM5OfmSWU9A1SNaLeb3Hf7e
 ozws6m0VSs1Chxe5JHZm0XrZeEGK1N6HmHEiUaYYcVnaPYPTnGuQK9t
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FA:EE_|SJ0PR19MB4637:EE_
X-MS-Office365-Filtering-Correlation-Id: be88f5cc-0f32-4ab7-fc3c-08dd0ee915c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U0lMdCtoUGZqdzIvSE5rZUl1U2VuOUZWWGh4aDJmOFk4RkFQN2UwOCtoOS9q?=
 =?utf-8?B?NDlEeHBsMUdjZUJna3c2eDUvalNXczlRM013bFpNOEZwazE0S3daSlNqZERP?=
 =?utf-8?B?RURFaWZmL0JSSDQ5UHpzQ3JsRU9MbVJmQStDdTBxUXl2Y3UzbGM0ZlJ1NGNQ?=
 =?utf-8?B?SEZtRmxSY015cGpsck5KeDlEWUFXMkFsV25qV21UQVhBV0dIVktOZzk3UW5u?=
 =?utf-8?B?MmRoRUZpT2YzeHNyT1NCWlhmUXRYWDVMZ0cxUHJ4T2ZKN2tDZUo2KytTR0ts?=
 =?utf-8?B?emlYODlSb2pEMGovL25iYk1xMGtFUUhSRnhWN29OVytxOU96a2FnTHFIaFZE?=
 =?utf-8?B?T24vOW1ONWpoVzEySnc0dUc2UExHdGhyWHNjb0dlS0t3U3hiUnZxTHowUTJV?=
 =?utf-8?B?UURvMGJMVDFyZVBWUkhrU2VJVG42c3ZnMU9SbE5ycWxicUhOb0V6K0xoVnF3?=
 =?utf-8?B?czQwaGJ6R0hrbzR0aHh1cVY2RFNjaXBPbTlQY0RKVEUyTzBkc3FlOHdQbzlH?=
 =?utf-8?B?bGQzcnN5TDlpT09lRlYrRGVhS2RSZEhpWDJkdUV3WlRPZnhobVdQUHhKTXRZ?=
 =?utf-8?B?a1lxYnQ3aHR6UUZVYUJuRDQwQWg5dEtSb3R5VFhxYnNSWS9nU0UydENlcVE1?=
 =?utf-8?B?U2JwcmlSajc2RkErZEFyc2EvK0w5RzJERGRiQkErS3ZjVjBsaS8xMmVtdUU2?=
 =?utf-8?B?WGV3dFlaOWhydUFEd1NTa1NWVjBjOGxPYkJXeDFuOEFvMXI4TUR5Rys5ODBT?=
 =?utf-8?B?bG1jbTR1Ujdsc0NhY2MrMVp6OTVWTTltQnRzVHJOOXcvaFFXRVJGV0JHYzYv?=
 =?utf-8?B?eUNFVGE2dndsM1kzVWFGMzlhcVB0dW93ZEtpSU10NTlzUEtFT096WHpUWlg2?=
 =?utf-8?B?UElFRWtObzVkcEF0RkRvRnhLTEp4NmFRVllwRE1kYXMwVTkrTld4cTFOcnZM?=
 =?utf-8?B?Y05XQW5FZ1NJcm9GNURZckxUdXBGcXdseXp0OWFTM1FyRi9OVmNZdExIT1NJ?=
 =?utf-8?B?Q1F3cWY3SkJMeG5YRml2RTJoc0pSREx1VFpadE1EK1BkSTh3eHJOZU52WWVN?=
 =?utf-8?B?M2NkK3NsRWVCL3o2enE3MEtVZXJDeW1Ta1BDTG0rNndZaHJNdXVHK2t2TS82?=
 =?utf-8?B?T0NkU3ViVzBuVXBEUFF5ZXlnb3pFVmJBWFpURlJxV29NM01SOFNRclBSQ2U3?=
 =?utf-8?B?ZGFTY3FXQVVMT3JjK0lHTTRMTE56VUtqd3NLdFhQZE1NZUhYOXRCUEYzR081?=
 =?utf-8?B?YzBpMVFoRmJnOVN4aFE0ZHpWMHZXNUVHajcwQ3FjdVUxSE9wRVQzdUpJc29O?=
 =?utf-8?B?b0FKVkYxTzQwMWRqaVJVK1BGSDhKVjhXbkgrNDRoYXZ2ZXhNYmxDZ0hjMDRC?=
 =?utf-8?B?c1AyZ3BKVnR6Z01tL1Bpb2JHdnRWQVVCQ2NUODNmVFhUM2NiWFJVSGpJemsr?=
 =?utf-8?B?UkdCWmI0cVlsc1pma3JTV1JtV1NxRUtvVzdyMjIxd3ZZMGpPc2hPS0Q2ZC9m?=
 =?utf-8?B?UFoxbHlDZ1o3MVVpeGNOV2EwWDZvSlN1SGFxTytUS1J6Ym8rakdjcTlVMzNM?=
 =?utf-8?B?SC9PbGdCRXdyUHpLcWx5YmNZN1BxNTlGSnlLUGdGcFRjeEhxZWJYK0IrcmVx?=
 =?utf-8?B?RlloeVRsblRwb1JvekZoT015dmlnbWNFRUFPaVhxTGFEWmhUaWZJWWNsdnMw?=
 =?utf-8?B?UGpCcmZSeklQbm9heHRKMEhCUzFKNG04QXhnWnF1YUdranZHZ0ZDVzdXVlA5?=
 =?utf-8?B?SUMweTFLVGNvZW1WUVNFZlgrUGc0RnNKbE05clhnOUZESXhyazhaQTRFSFc5?=
 =?utf-8?B?SnJvMXFsUnQxZ3JpVEFJbXNKT09ibFJCam5KWjhhZkY2NlZoYUJyVTdUV0JL?=
 =?utf-8?B?VjI3L1pyQnFrVFN0Zk5yVFhKQmpXSWZWcDZuQ01zaUZTTjRjREZ5anZ4RzM4?=
 =?utf-8?Q?aaV1J6DiK5qfutdftEJA0zm8tGPa+qvZ?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HuEHe5qTtdlk/i60LDB7oi36cKN+YqBGQM0vODLSNKDwZihzb/A4Yin5ZSUYp59RXmJAOw2X7ZKwReC9yuvTA62D/a7GCytRlY3B8sTaGyJQQRrZhFfOuN1PLV8z1pADSPRGsF0rHeb0JLRk9HQ0fb5Xk6Gxvpk/GmE73T7vwALuSoLo1HZKCIJOt/co1hMVyHTbv4OTWURGm4Mp8+XFB5ayd6lLXwcH5fJRLMdlLSxY1rIK/FVmi8ZWn0EjAgxNZ/rlhAeHTdvul2E60BYCawgKkBEsdVl6Ex3fZO5DfPQ39fkP9MxALXZlBDWuy/s8YbT8mGUztExxTmKA9RSIlHYZSLJSun9BcEdcaqwtu3ib8MaxrSifn/oArU85pVViB6hPAvQRVXQknNe8Jltqm9ePpr1an270EMVDWNQNv25xxmgPQtRzOWY6/xTOnUEhUdLh+rM0WBrzKDOYY0P9VwtxlAv/ky9L4tf17PHqYhnCkj6gO38hfVCahasnBI0w1IdukfBSTavzlP9V/X7UxnK5E7yhayb/RgP0Py2m0FNo/SuxZOirnSHehS9560znWXp/zwFK1SJki3zTGR4Gldb21deAc2U4gxuatqtt1xqieejqRFVTXItoCqmZWBdR9FEhAqBmMDj3fcHyWCll9A==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 13:40:41.0678
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be88f5cc-0f32-4ab7-fc3c-08dd0ee915c0
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FA.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR19MB4637
X-BESS-ID: 1732714844-105150-13382-4953-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.58.173
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkZmxpZAVgZQ0CQlzTAtNck8Kd
	HIINHCwjAxzczYMDU5KcUgOSkpydRAqTYWADEYJS5BAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260718 [from 
	cloudscan18-239.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This function is needed by fuse_uring.c to clean ring queues,
so make it non static. Especially in non-static mode the function
name 'end_requests' should be prefixed with fuse_

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/fuse/dev.c        | 11 +++++------
 fs/fuse/fuse_dev_i.h | 14 ++++++++++++++
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 1f64ae6d7a69e53c8d96f2e1f5caca3ff2b4ab26..09b73044a9b6748767d2479dda0a09a97b8b4c0f 100644
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
@@ -1873,7 +1872,7 @@ static void fuse_resend(struct fuse_conn *fc)
 		spin_unlock(&fiq->lock);
 		list_for_each_entry(req, &to_queue, list)
 			clear_bit(FR_PENDING, &req->flags);
-		end_requests(&to_queue);
+		fuse_dev_end_requests(&to_queue);
 		return;
 	}
 	/* iq and pq requests are both oldest to newest */
@@ -2192,7 +2191,7 @@ static __poll_t fuse_dev_poll(struct file *file, poll_table *wait)
 }
 
 /* Abort all requests on the given list (pending or processing) */
-static void end_requests(struct list_head *head)
+void fuse_dev_end_requests(struct list_head *head)
 {
 	while (!list_empty(head)) {
 		struct fuse_req *req;
@@ -2295,7 +2294,7 @@ void fuse_abort_conn(struct fuse_conn *fc)
 		wake_up_all(&fc->blocked_waitq);
 		spin_unlock(&fc->lock);
 
-		end_requests(&to_end);
+		fuse_dev_end_requests(&to_end);
 	} else {
 		spin_unlock(&fc->lock);
 	}
@@ -2325,7 +2324,7 @@ int fuse_dev_release(struct inode *inode, struct file *file)
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


