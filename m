Return-Path: <io-uring+bounces-4953-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C3889D569D
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 01:17:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D6DE282E41
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 00:17:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 293B6230996;
	Fri, 22 Nov 2024 00:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="OPwL+G4u"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07489AD5A;
	Fri, 22 Nov 2024 00:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732234610; cv=fail; b=Ot/Y+0vIOF2DBjjKteOxIqjGeoTbYpxY1QODm0L0v4gz7q5hqLFKv4XXIJc5v4r2OXeDHuv0rU4vwc9IRzj87HELSjuqteAifRMWK0kIfQnd2VfJEUE8xXdxIEskYy9mcdP5LWHmWrNNaPZIhxwytNkYeoW8fToUluk4VUk/hgI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732234610; c=relaxed/simple;
	bh=4bknGJU3Wtna32FhrLjaYmZZ7ul1Xvbj4NehlIfcX8Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WJGQbYB8GFcyZnfhakO+duhMQIcgcpn2UdjfWNAI554VYfS4E6QqV9SkiIHiiJ2K2NIqI3kX59QaIkRxq/v+0P+n+iJ8jxKgfbCoLBtSBd21kdqFM1nmhjufoa9y7lSecd/rnvNBbQUAw+w7nKuyP9dtuZpczbaqux6po3j98II=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=OPwL+G4u; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2045.outbound.protection.outlook.com [104.47.70.45]) by mx-outbound14-193.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 22 Nov 2024 00:16:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XOH+qbKIw+HkncgJyMpfjOafJDcHl6ZeS73vNNDmgVx/EcpwH4ajSe/bkd0gb3k5C/7hee5H6en/UIX29IWbcQ4UE/VEV5DfYbYXZuF7V750IXRzSIBCbnTJXzGHcqX+qxw2rD3bqE6hcbqBiPmKMzUGHZ0aEQZOrIhxvbPhWZxzRxzD0RTtFmL/mDg/BADJQUZDZscmkt47B2lORSpa2eUOkthdYD8vWFzvU+m2h43cgShBuSJOi03Sz7ndvja0yOm3p9IeeDUAineIPZHCD/ZlCrl5cjXtBKG03XPXXiyCGEhyY/LyxazddxHvl8atuzMDmjWf7A4Ly4JznseR9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AUhMVX+vTQG7wSMt986dWKXMtGIoAEkPHd4+2ghPkgc=;
 b=qnRkYLDIEcSDjWW7LNzvmdUeZrYscA4cntehzBPf2S9m2gLB5DSHlP0qzF0y8EXIHQB7QEF+swo3183Vr6wi1jbXAJdZ2Fo/QLW1z5fD3Hsq4/mOvUAphbM7ScqI2dbi2cngrSt3n3LbhdF6TH8MXK7aAxjnLJ3aEutXBgo1r5GXr+rLIMta8JPrdWgUYokj6LOGT4nUiCNZnhGQrw/thuBaxFlfQFimUrtacOAurIxmLpg6OdGMUKLG7ucyvKM4Buz8lfIjC8eC7iA1IxNqYcA5VO1krpaQRoUbuvKZN5ovE9Xy0QwDKa6ECL53REm9oNRmsrP3RQye8FkHWZD8Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AUhMVX+vTQG7wSMt986dWKXMtGIoAEkPHd4+2ghPkgc=;
 b=OPwL+G4uOIIaaT+S0MvJSXjiE7FjBEWO3jrCCGrJ6+cdidiJHLmzRDf3EFwxqjF2hgmH33PzXIdOrCMipsB823JPF7qnp608If1iT3CHfnB1T34S/C8VrxKCQCzXTJOPRURlYwSrCR04aOdZFFiEk15h41xkXUXIjJTcCUx+iUI=
Received: from MW4PR03CA0132.namprd03.prod.outlook.com (2603:10b6:303:8c::17)
 by CH3PR19MB8212.namprd19.prod.outlook.com (2603:10b6:610:198::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.21; Thu, 21 Nov
 2024 23:44:03 +0000
Received: from CO1PEPF000044FD.namprd21.prod.outlook.com
 (2603:10b6:303:8c:cafe::d) by MW4PR03CA0132.outlook.office365.com
 (2603:10b6:303:8c::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8182.15 via Frontend Transport; Thu,
 21 Nov 2024 23:44:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CO1PEPF000044FD.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.0
 via Frontend Transport; Thu, 21 Nov 2024 23:44:02 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 9906B32;
	Thu, 21 Nov 2024 23:44:01 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Fri, 22 Nov 2024 00:43:28 +0100
Subject: [PATCH RFC v6 12/16] fuse: {uring} Allow to queue to the ring
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241122-fuse-uring-for-6-10-rfc4-v6-12-28e6cdd0e914@ddn.com>
References: <20241122-fuse-uring-for-6-10-rfc4-v6-0-28e6cdd0e914@ddn.com>
In-Reply-To: <20241122-fuse-uring-for-6-10-rfc4-v6-0-28e6cdd0e914@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732232629; l=8077;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=4bknGJU3Wtna32FhrLjaYmZZ7ul1Xvbj4NehlIfcX8Q=;
 b=D8x7r9wDttQWb+XKsvOxtPJhnCuhagiyL8RHsNi4O7kmhko/GSn3HzEX3Esp4mcCVT+cmKyRi
 paU4F2msefwBMOrmobQ07iZdcxTy81NJcCHBVSyDb2ljAIgWCiCTSPE
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FD:EE_|CH3PR19MB8212:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fc038a8-58ad-4723-7a28-08dd0a866118
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?clhZcUt5Z1BFam5WQ01FSEtkaWQycHFJb283Z3FJNEdDMU51Y1JVbFdobWZa?=
 =?utf-8?B?TGtrViszbEdoQkNSYVV5Y3U3SWhWYTFqSVNnZVdmMVNZVFFxNlhQRnBwWjRF?=
 =?utf-8?B?czQrVWRLSWRXWGhsZnlCWnFNYjF3MjF0TUgwTGtDRGFacS9TZFE4Q096blpj?=
 =?utf-8?B?R0V4dHJvckpyOGliNGlMdVVyMjFEaDZDV3EzYStmc0VHbGZIYWZDbEVSQjlk?=
 =?utf-8?B?OUNST0h0SUo0dklNd1JTNzBvRTdMVWVxRkptSUxhNkdRbkhKNzFPMWx0Tmlt?=
 =?utf-8?B?b0d1dXovQXkwRE85dzloZS9Uai93ZUhtdEkrMjNDalBrNXRKcmFYUHZ3VHZU?=
 =?utf-8?B?YXpkVmhRSElyT09HNXVDczFMSmEwTzZVZWZKTVVVWHlJL3Awb0tkUi9Lb2xC?=
 =?utf-8?B?NXc3bmh1NVVtOC9GSW00KzZ1cHQvMTZjM1hIRExZdkRZWGVzVFY4NTh0MCt2?=
 =?utf-8?B?eG9kdzVCVzN2bFBpOGtHNWFHcDB0NDh6Tno3anAwWlJOU1ZldGxGSVJsNkQ2?=
 =?utf-8?B?U0tKbUUvcTFEMlFOQnk4MHJQMnFuaG9QbHQ2SlRleWorTy9RNzZLcTRjbXd5?=
 =?utf-8?B?Wk5EZ05wUzFVWmZ6S3RSdnFsMTN2WDZzUzd3QnlleEo0MlBGdzJ5TXBqV2VI?=
 =?utf-8?B?REM1Uk93N0FIaFNJY2NDWEZZTlh1WGNDK1FQWkN4M1UrRVhaZ0FEeUVBeUpj?=
 =?utf-8?B?elRXdEtDTTJvSThWcll3WG1EbmFWaEtmZ05RWldnTlZLa0ZtQ0I2S2ZkQkkx?=
 =?utf-8?B?eVVobWlXTkVxaEJZdUUvZzFjcWFqdWJ6S296V001MEFROVZKaVRySHJLTnY0?=
 =?utf-8?B?RkdFUTlVU3RMZkNadzRyUzgwQ2ZhdlRyNEorSDQzRjJXWkMxOVVEU3VzMHN1?=
 =?utf-8?B?OGRsUS9mQXovbEpJbGxzb215Z0t0M1BaMTlvTzVMZEkwSjRYeVF4MFdlS05B?=
 =?utf-8?B?eDlybzEwNWZYSXpYWncvVGFwdEcrbzFVSE0wMUxPM2VUWWVLSnFBSVVzaW9I?=
 =?utf-8?B?UEVvOUlrNXIrMEVscHNRS1pkUzczYUVDdXBHNzYrd1FMajlWZzVVYi9TbDFl?=
 =?utf-8?B?VHdEQTc2TE8xaVRGczhEaVVWS3hRUTE1M3JGYTI4MjVhckc3VEhFVXU2Wkpy?=
 =?utf-8?B?ZE5VQ21NT0E1NHRhUjk2RHp3TnpqTVlGNnFxUWZFRDY3aVVDUlRVM2ZMQ3VU?=
 =?utf-8?B?V09VT2JFRWZTdWM5YndJLzRxb1IxZjJ1b09jU2daVzZBaDlSeUFxSjFkMklq?=
 =?utf-8?B?dksxRlZGZGRDYWhpZzhDa2s0MW5vMk9pU0hQTExIK1pEV1lyTE5xSnVHeTFq?=
 =?utf-8?B?NWRzMmlCV2tCOURTenlKWjdKVGFrRWhGMmluWVVoTE5WdTRGRThwQWJDSmFw?=
 =?utf-8?B?ZVo3NFJ6Qk1ER1owYkdwVG5RU0ZHeWxJNzNhN3Z1a3hmQ2NXVFdnb09nZEdI?=
 =?utf-8?B?b3BmUDZWaHExWkFQaGZPdGNuY3hwcmxYQm5md3RETGdoNlgwVG1Bai9KY1pH?=
 =?utf-8?B?NjByYzBVUE04Ty96MCtuSlFlTUhCS0lMTkxWN3dDZXVlSk1NeUtUTUtHZy82?=
 =?utf-8?B?MjUyMzcyL0Z0RXpGUmVUVms0WUh5bG1mY3pLakJrdGwrQWNwd3NvcUVtaWVv?=
 =?utf-8?B?eWF5Z0Y3eXI3WTRRVjNISUNRVFMreExuNWp5emxrL2V5VGRUU0p2NGtoSzFL?=
 =?utf-8?B?Q0F6SEpUNmNjNFBna1AxbVVIdWxQSzI4eHlyVXhNalZFVXpwb2Q3ejRUdEhD?=
 =?utf-8?B?SDJUdXVoRXo5NjdCbTh2aTVSZHg3eld0ZUx6L2RjczJhL1poTVZKbFdBbHZq?=
 =?utf-8?B?VDBkVmNQbENYRjY4VzNjd0ZJcTcrRWQrdUR6azBRbEdaeHNpSmVqenVGaWp1?=
 =?utf-8?B?ME9xRDFiUXBKcEJCdmRmelAvWjVxQU1qeDVIZUNnS3pGN3c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Yp6JeGVYL+P0MRKDKmSygj45wrThCOsu1tv2Q9vYnpaCv0qSxaCgfJRDgBSaAgmMMlhHXE+68yMQ7zxCAQhhTsOx961G/gi78KojHiHK3YBRYGxZywRU+sNJ27m3HXn1vjPWgrN2jgten32SckcWBBNOFm6vZ3DavNlfP2n00Ek0MyGvA97Y9NpgKspbPkNlf9+MiMfshB0PA1erd6MATGoFmb2DxoY3eiG1tg69NJG0Y3/jZoWmvM09jCdZVYeZlp76q/x4w1TpVm3j3ja92KGvYxup5TyjZd7pD39ZgKpTALX0F07mca6ICt7suj58BtDe3aT+e7T2xSRNEIyHirgULw7yjE61bpJ5Ua0832KLBa3GhRBPKC19tFgolpqEeUP4y945RxdkXVCHyrDGufLqwuMwMUM9qyIFRzsbyYDtAVS7jsaOo3ZULdtY40hz4DPm5vEeszhdnAws9gxXc8Ld5qliVOjBYq7dwS1jrh5mpjCd1PJ5g5YiIyFr8yGbQn8V0fKmF22GA1NuBef2Tv89yKsEUtOWMz59jhG28ERthnHDQgGv51X9vidQPUSH18B2HPOVaxAXQ/G9FutgOiamM4meJkHjhLNrQAY2vFpRpd5mdd/UlldX3qGKCdD6IS/7BU13n7KZ0EhzTBMyug==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 23:44:02.6430
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fc038a8-58ad-4723-7a28-08dd0a866118
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FD.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR19MB8212
X-OriginatorOrg: ddn.com
X-BESS-ID: 1732234605-103777-13372-24003-1
X-BESS-VER: 2019.1_20241121.1615
X-BESS-Apparent-Source-IP: 104.47.70.45
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVuYWRqZAVgZQMDHN0Dg50dTcyN
	jQNM3ALCnV0MAkLS3FxCgp2TI5yTBNqTYWAMznbdhBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260587 [from 
	cloudscan9-145.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This enables enqueuing requests through fuse uring queues.

For initial simplicity requests are always allocated the normal way
then added to ring queues lists and only then copied to ring queue
entries. Later on the allocation and adding the requests to a list
can be avoided, by directly using a ring entry. This introduces
some code complexity and is therefore not done for now.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c         |  26 ++++++++++++-
 fs/fuse/dev_uring.c   | 103 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h |   6 +++
 fs/fuse/fuse_dev_i.h  |   4 +-
 4 files changed, 136 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index ff7fd5c1096e8bb1f3479c2ac353c9a14fbf7ecd..dc8fc46efca82d30afb64b6c0e6a361fd951ca33 100644
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
index d8653b4fd990000c8de073089416944877b4a3a8..36ff1df1633880d66c23b13b425f70c6796c1c2c 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -27,13 +27,55 @@ struct fuse_uring_cmd_pdu {
 
 const struct fuse_iqueue_ops fuse_io_uring_ops;
 
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
 /*
  * Finalize a fuse request, then fetch and send the next entry, if available
  */
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
@@ -78,6 +120,7 @@ void fuse_uring_abort_end_requests(struct fuse_ring *ring)
 {
 	int qid;
 	struct fuse_ring_queue *queue;
+	struct fuse_conn *fc = ring->fc;
 
 	for (qid = 0; qid < ring->nr_queues; qid++) {
 		queue = READ_ONCE(ring->queues[qid]);
@@ -85,6 +128,13 @@ void fuse_uring_abort_end_requests(struct fuse_ring *ring)
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
@@ -198,6 +248,7 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 	INIT_LIST_HEAD(&queue->ent_w_req_queue);
 	INIT_LIST_HEAD(&queue->ent_in_userspace);
 	INIT_LIST_HEAD(&queue->fuse_req_queue);
+	INIT_LIST_HEAD(&queue->fuse_req_bg_queue);
 
 	queue->fpq.processing = pq;
 	fuse_pqueue_init(&queue->fpq);
@@ -1161,6 +1212,58 @@ void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req)
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
+	if (!list_empty(&queue->ent_avail_queue))
+		ring_ent = list_first_entry(&queue->ent_avail_queue,
+					    struct fuse_ring_ent, list);
+
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
+		struct fuse_uring_cmd_pdu *pdu =
+			(struct fuse_uring_cmd_pdu *)cmd->pdu;
+
+		fuse_uring_add_req_to_ring_ent(ring_ent, req);
+
+		pdu->ring_ent = ring_ent;
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
index 57aa3ed04447eb832e5a0463f06969a04154b181..8426337361c72a30dca8f6fd9012ea3827160091 100644
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
 
@@ -128,6 +133,7 @@ void fuse_uring_stop_queues(struct fuse_ring *ring);
 void fuse_uring_abort_end_requests(struct fuse_ring *ring);
 int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
 void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req);
+bool fuse_uring_queue_bq_req(struct fuse_req *req);
 
 static inline void fuse_uring_abort(struct fuse_conn *fc)
 {
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 545aeae93400c6b3ba49c8fc17993a9692665416..853333d6fcd3382286532d03ef3cec8ab4979fe7 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -17,8 +17,8 @@ struct fuse_arg;
 struct fuse_args;
 struct fuse_pqueue;
 struct fuse_req;
-struct fuse_iqueue *fiq;
-struct fuse_forget_link *forget;
+struct fuse_iqueue;
+struct fuse_forget_link;
 
 struct fuse_copy_state {
 	int write;

-- 
2.43.0


