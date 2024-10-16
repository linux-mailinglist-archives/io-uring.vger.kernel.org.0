Return-Path: <io-uring+bounces-3715-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C291099FD4C
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 02:40:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 45C6E1F21A49
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 00:40:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B8B31078B;
	Wed, 16 Oct 2024 00:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="NN8M7UnA"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687D710A0E
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 00:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729039229; cv=fail; b=YXJV4CKOBvuve1RurZApSq1AdDgUUY9mqA34In2zuHBdGONYilQPkbf1dIRtF9UKrdrygpdqqn6Engjb8C/B5f88+LRRLNUHIQpIfHAcaHFtKWFoZyqWSo/BEEGpVb93IgEHeHZKyJNScJw9W4Ys3b0nqIqr4Sr5yOTunpgMcT4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729039229; c=relaxed/simple;
	bh=0Y1IyT/hgBu6I3Aqfc5RI8c5rxwN7dwCeZDd51oJbXI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=suM1FmG+FelqNximHHZAAGalx1D5xhs21KAVIkTfpnGHq2m81Uyq2W2Oip5bjudu4H/XbvkztVJAKL+DRzGmfX5TFB5diRQCWsYVC+iHhoa5RPkdHQoHBu6D/04UNCUvJjXkU8Hq/M88wpXMuFZqgYO5+rDtTdfhW/4SSfADGSY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=NN8M7UnA; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2043.outbound.protection.outlook.com [104.47.73.43]) by mx-outbound46-22.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 16 Oct 2024 00:40:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Le6lTfaJ4oPN/4uJrxL07MFOeuCw6b0vtowskeXiGzVaiq1RIHv372cAexUF9Hc30EM2yLKP1XG2uyYOxj0UI4pUVwYNRF2hhPYBtdS3hYk6lFfAtTaUb4nUF0R8NToJoNwqGUM8j+P5OA1qtWjlTmNeUJYf4F80z9KVzgvQxpsKmKAnpaZ/Xi3mdUTw6b9TNqmyA5Ll+ejvY4Uk6QduXUeAFFe8cK4whLuOB7HUsonOFLenCSY2Jwop0cLJFK7HvrMZBOg34dK+5NnEnByduGkhrlwKJox3cK4aB5J3Vlf226liMCNMG2k3xOUp3xYk2FRra07MpIurJUjScyzt3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HrZRMOmZDYRIPpnMY/X+kOnoUjYjGoSGV152UAnWirU=;
 b=baBN/LCw3qcPEINQFWSWg5VQ/tQzwR9Xle8wNVUiAcIYgq54erIHKXHxJFAm/eWw011LFmkItqWjFoNLcckzzneHHAqBAFSAGWryKV2upXf4qTZKQQKEjJkFfKAoqy+fm0gYZ7RN9Q6b3S2715/3D0eJMCnCkD1qf0ilmCoujlPgu8engy2FpvhqW2n9iSR0KFrmKDpDsOB3FHps6/4gnb5qfkrFYUlmP6j4lB0AjUR9I7RD9zHa8FcT4R0Q3zhY4AjzmZDBs20ND+kNkbpw+4F3NNk+62rgyC7gMPsbqj73mlv60CK8Pl5+fXVilRTeGS3yJAYrhxCNZTajD6cosw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HrZRMOmZDYRIPpnMY/X+kOnoUjYjGoSGV152UAnWirU=;
 b=NN8M7UnAoU/JK6Q24GKxFBpY76GvhnaUxyguwHddrEDFmKH++lv5lgvBPpMcGdY3c7hA9XK/Pt1+yMN90xy1PVtmc/zd2RbpZNlU0mv34zp//1WX+nbcEXQxZstYhkxw3JBe75XHMy1ZgtgFvDZs7bgGwPXwXnWddChEBb1HK6s=
Received: from BN9PR03CA0570.namprd03.prod.outlook.com (2603:10b6:408:138::35)
 by SA0PR19MB4175.namprd19.prod.outlook.com (2603:10b6:806:84::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Wed, 16 Oct
 2024 00:05:36 +0000
Received: from BN1PEPF00004682.namprd03.prod.outlook.com
 (2603:10b6:408:138:cafe::3) by BN9PR03CA0570.outlook.office365.com
 (2603:10b6:408:138::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27 via Frontend
 Transport; Wed, 16 Oct 2024 00:05:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BN1PEPF00004682.mail.protection.outlook.com (10.167.243.88) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8069.17
 via Frontend Transport; Wed, 16 Oct 2024 00:05:36 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 1626A7D;
	Wed, 16 Oct 2024 00:05:34 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 16 Oct 2024 02:05:23 +0200
Subject: [PATCH RFC v4 11/15] fuse: {uring} Allow to queue to the ring
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241016-fuse-uring-for-6-10-rfc4-v4-11-9739c753666e@ddn.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
In-Reply-To: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>, 
 Ming Lei <tom.leiming@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1729037122; l=7954;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=0Y1IyT/hgBu6I3Aqfc5RI8c5rxwN7dwCeZDd51oJbXI=;
 b=UyvA/t6gjKTMEB6m2rFhXIiBAIBqR7mi8BFxkMRNytO3ZAZZCwubzumIKqwhRozzspoH9bNZi
 a45F3XYSqVmApjafRG1LaSP2JxOx+exDgR59CEZQ4xFmJeZ83bJnsR4
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004682:EE_|SA0PR19MB4175:EE_
X-MS-Office365-Filtering-Correlation-Id: e23260a3-2a19-412d-fffa-08dced7642eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TmF6KzgvVWFQTjVrVEtEVndJSWpXcWUrdWkwQVhmS1RvQnJPeHJMSWMyQlR5?=
 =?utf-8?B?ZFJ4d1F3V0wxS1l2N0ZoWG16L0ZUa0JOVXA0dlV2MjBvd2J5cGN5REpRMDBl?=
 =?utf-8?B?dUtOSUs3SUtzcThKYSs5SHJqeE5vSDZVMHIyaTdDQWVGQ2ZsbFl1cGk5eDJq?=
 =?utf-8?B?Z3ZvN0NsMk9hZzMzbzIzVE9wb3dsT01aemZFTy81UTIwcTFMczJDWEp5NDVE?=
 =?utf-8?B?WGxWa3NISXA3a2o3RUJMbm55cHRIaTA4bjVBbHgyMjkzYmZ0K1NzMjFIMm41?=
 =?utf-8?B?R3dkVnFWSmFuMGpWUkVHSjlZVmxOd2NNTVExTW11R0l3KzRlNm1Hd1hLbFFl?=
 =?utf-8?B?WGtxNnY4RlpKb241WGZHcmRDSG5SNE85ZEszdXJ1SHZ0b2VlMk5DTmswQVdK?=
 =?utf-8?B?UGZtS1RlWGh1SFRGbmdZd0hEQnFZVjNlZGpFN2U4MWFVM2Fpcm55VUhGVzRY?=
 =?utf-8?B?UE1pYW5pMXl2YnRRWVRiSjVENEUvVTQ3N3BYamZCWSs4MC9SSFhBSktIVlBi?=
 =?utf-8?B?Q2tJMHp5cW9YRXpRTGhyTEZQWTNBMjRZaUNsbFErRklHQlIwSzFtWXNBWXV1?=
 =?utf-8?B?cGx0bnRpU2J5YjUvTlRuc1N6bHBMTXlXY0ZKTDFxT1lSVTRBR1V5d1pEQkVN?=
 =?utf-8?B?a3RHOWUxcitTSmlpTGkySi9FQmVobGc4YWc2b2Z3cU1PanY1cXVTUU5mbDlj?=
 =?utf-8?B?NXFhNFIyaDY5VTNKdEFITEpWdWJOb0JvZzRiWVJIOXd6VWF2TWF4eVg3Vjc3?=
 =?utf-8?B?c2tPdTN1cFZaczhVSGZ5eWxEME5wejA4YXBCTy9ZcWZoaVpvNTUxOHo1Z1d0?=
 =?utf-8?B?MSszaUpJMVRFY2pGcmhoeDQyUTc1WThHK1h0MmVrYjE1R3Z5ekNvaWJudm1m?=
 =?utf-8?B?dHhwTS9ZVFR2OHp0VmhFUkZIZlp1YWhmT2loMktVR0FKY1hpUysxdi8yaDhx?=
 =?utf-8?B?YlBnMEw4dDY0K045UWdjTTJOc3BWVTNkMTd6dFgxdzM5UjBkdnJ6a2Z6R0s3?=
 =?utf-8?B?cGN4cTVISmNJaDlCZjYzdGRNSUs5RWFyNVpST1BKRFpHem05VHJWNmNCMTlm?=
 =?utf-8?B?MzVKWDFaeFQza01nekFNdnZqeitCSDYvVWpHVURGMVR3elRna0k5Q204Ym5F?=
 =?utf-8?B?Ym9BcHltdE5OZlhyUUx5K3Rtb21BWjV3OWJvZVFkZXlLM1RpT1Bqb1FkQlRx?=
 =?utf-8?B?bmwrOVBRUDU1UHhzUCtOUTBrODZNSjMxNW1QbktSUXErUzdBZzE2ZDBMV29r?=
 =?utf-8?B?T0Q3dnBvdmpiendHM2U2ZmxYMC9OQ0FIMVVwZjZKZEl0eXI1bWFqOFNyYWdE?=
 =?utf-8?B?Z2RxK2xPSjVlRXJRSEk4U0llZ3hRdTVJciswc1QwcXF3bFpSNFJqenptVVlF?=
 =?utf-8?B?OVRvQUlUMHlBRVVNeVl0Y2Yyc2lzVmFpb0RGempXZjNBaG5lV044T00rSUQx?=
 =?utf-8?B?NncrM0xjL3Y4SmZNMndhUDNROEJuSFNUeEpuQ0N1MVVKNTR4VGQ5OFA0WGVQ?=
 =?utf-8?B?bFg1YlBQelBVQmg1cVZHVnJ4a2hKbXdEOWM1RXVzL1lCbzRXdXlSS2d1amtI?=
 =?utf-8?B?dTdqY0VITnora056aVhNaXJhSkVLNm5Jc3hNRHNuU281L0ZpZ25IT0ZKclVL?=
 =?utf-8?B?SlhrUGQ2S2FmYTNDT216Ym5Db2lXQkE3RkFKU3JvVFFRSmRwSHF0MnRTRTl3?=
 =?utf-8?B?aFZqUk1Pb2Q4U09XU0xyZGJJb1doVjlyV1pNVmZQaG52ZENzdzExRlliSlds?=
 =?utf-8?B?Ui82c3BDMEswTUovanVCVVZoTGJBOWEvOFFMYVp6VzQ3OWtoOERsaVdRdVBY?=
 =?utf-8?B?RU1MNlB4eUcxZEJkd01HdG1tY1RkQTUvREZoTDhudUtxZ1Fjeko1ZzErQkxw?=
 =?utf-8?Q?EHmAZWszMwFC5?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VkRF8cXbDTsbT0EoM9Q3amzewjHuWIbw1kMaJYwc4frdl/I4PGbFPi1YucViJujl9e5nDVQVZOsnfQccP5yF65FDwdJwgn8bMQoq3Tv28L03beijHJbwsL8civoRtj9mDnW9pmIS+JhhYUeuPI/2zFExSmpv3SdrDGkFkQPkBX/L9Xi08zMcn2MH4sJizU/TTFR9RQLzmnhTwBd9QJUOe3b57C67Tnt1vIwGOfsSXWWS1L2MeJEpBT7OLBhnDyIT56raN4pFeKOer5+TCXZC3Ga4icMxwR6UXBFGmsEUHFHFbNriz/oRtIT4rbv3WEHG2BUMuLfVVrpU/eWQl49KdEbL7VQDO89clhNfAd29D8pDzoUS4yy2s/vX5GEvYKfQKhiVzCcU0RqmUAL1f4CukVPkHBKeuqCBxKC/JVgJZjDr3AJXSoc1Em8hHlt7zDOPSST09uDkal+qxjFs+r7qyZ5ZnzRKsEiWGNbuMpVAyo7DDtDYjEgNaBBkJRD6davxTrC11WLl5FBOZ5RBo13Mthw+lwA5z67QD8EouiLxhVz47bP1gulA/i2qb38apCtuESP9cKNhzLTBm+h52UQ+/xbTmlEkDJwQaUWh8UcOpXKlVycWTLwDbdh/Y3PdoqAs6H4RFEgHwO+P05DpFhGWLw==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:05:36.2891
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e23260a3-2a19-412d-fffa-08dced7642eb
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004682.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR19MB4175
X-OriginatorOrg: ddn.com
X-BESS-ID: 1729039226-111798-10777-62662-1
X-BESS-VER: 2019.1_20241015.1627
X-BESS-Apparent-Source-IP: 104.47.73.43
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVuZmFuZAVgZQMNnc1MzExMgsyT
	w5zcAkKc3UKNks1djQxMjU2DQ10dRMqTYWALY8tCdBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.259752 [from 
	cloudscan13-246.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This enables enqueuing requests through fuse uring queues.

For initial simplicity requests are always allocated the normal way
then added to ring queues lists and only then copied to ring queue
entries. Later on the allocation and adding the requests to a list
can be avoided, by directly using a ring entry. This introduces
some code complexity and is therefore not done for now.

FIXME: Needs update with new function pointers in fuse-next.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c         | 74 +++++++++++++++++++++++++++++++++++++++++++++------
 fs/fuse/dev_uring.c   | 33 +++++++++++++++++++++++
 fs/fuse/dev_uring_i.h | 12 +++++++++
 3 files changed, 111 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index c8cc5fb2cfada29226f578a6273e8d6d34ab59ab..a8b261ae0290ab1fae9c8c0de293d699e16dab2c 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -211,13 +211,24 @@ const struct fuse_iqueue_ops fuse_dev_fiq_ops = {
 };
 EXPORT_SYMBOL_GPL(fuse_dev_fiq_ops);
 
-static void queue_request_and_unlock(struct fuse_iqueue *fiq,
-				     struct fuse_req *req)
+
+static void queue_request_and_unlock(struct fuse_conn *fc,
+				     struct fuse_req *req, bool allow_uring)
 __releases(fiq->lock)
 {
+	struct fuse_iqueue *fiq = &fc->iq;
+
 	req->in.h.len = sizeof(struct fuse_in_header) +
 		fuse_len_args(req->args->in_numargs,
 			      (struct fuse_arg *) req->args->in_args);
+
+	if (allow_uring && fuse_uring_ready(fc)) {
+		/* this lock is not needed at all for ring req handling */
+		spin_unlock(&fiq->lock);
+		fuse_uring_queue_fuse_req(fc, req);
+		return;
+	}
+
 	list_add_tail(&req->list, &fiq->pending);
 	fiq->ops->wake_pending_and_unlock(fiq);
 }
@@ -254,7 +265,7 @@ static void flush_bg_queue(struct fuse_conn *fc)
 		fc->active_background++;
 		spin_lock(&fiq->lock);
 		req->in.h.unique = fuse_get_unique(fiq);
-		queue_request_and_unlock(fiq, req);
+		queue_request_and_unlock(fc, req, true);
 	}
 }
 
@@ -398,7 +409,8 @@ static void request_wait_answer(struct fuse_req *req)
 
 static void __fuse_request_send(struct fuse_req *req)
 {
-	struct fuse_iqueue *fiq = &req->fm->fc->iq;
+	struct fuse_conn *fc = req->fm->fc;
+	struct fuse_iqueue *fiq = &fc->iq;
 
 	BUG_ON(test_bit(FR_BACKGROUND, &req->flags));
 	spin_lock(&fiq->lock);
@@ -410,7 +422,7 @@ static void __fuse_request_send(struct fuse_req *req)
 		/* acquire extra reference, since request is still needed
 		   after fuse_request_end() */
 		__fuse_get_request(req);
-		queue_request_and_unlock(fiq, req);
+		queue_request_and_unlock(fc, req, true);
 
 		request_wait_answer(req);
 		/* Pairs with smp_wmb() in fuse_request_end() */
@@ -480,6 +492,10 @@ ssize_t fuse_simple_request(struct fuse_mount *fm, struct fuse_args *args)
 	if (args->force) {
 		atomic_inc(&fc->num_waiting);
 		req = fuse_request_alloc(fm, GFP_KERNEL | __GFP_NOFAIL);
+		if (unlikely(!req)) {
+			ret = -ENOTCONN;
+			goto err;
+		}
 
 		if (!args->nocreds)
 			fuse_force_creds(req);
@@ -507,16 +523,55 @@ ssize_t fuse_simple_request(struct fuse_mount *fm, struct fuse_args *args)
 	}
 	fuse_put_request(req);
 
+err:
 	return ret;
 }
 
-static bool fuse_request_queue_background(struct fuse_req *req)
+static bool fuse_request_queue_background_uring(struct fuse_conn *fc,
+					       struct fuse_req *req)
+{
+	struct fuse_iqueue *fiq = &fc->iq;
+	int err;
+
+	req->in.h.unique = fuse_get_unique(fiq);
+	req->in.h.len = sizeof(struct fuse_in_header) +
+		fuse_len_args(req->args->in_numargs,
+			      (struct fuse_arg *) req->args->in_args);
+
+	err = fuse_uring_queue_fuse_req(fc, req);
+	if (!err) {
+		/* XXX remove and lets the users of that use per queue values -
+		 * avoid the shared spin lock...
+		 * Is this needed at all?
+		 */
+		spin_lock(&fc->bg_lock);
+		fc->num_background++;
+		fc->active_background++;
+
+
+		/* XXX block when per ring queues get occupied */
+		if (fc->num_background == fc->max_background)
+			fc->blocked = 1;
+		spin_unlock(&fc->bg_lock);
+	}
+
+	return err ? false : true;
+}
+
+/*
+ * @return true if queued
+ */
+static int fuse_request_queue_background(struct fuse_req *req)
 {
 	struct fuse_mount *fm = req->fm;
 	struct fuse_conn *fc = fm->fc;
 	bool queued = false;
 
 	WARN_ON(!test_bit(FR_BACKGROUND, &req->flags));
+
+	if (fuse_uring_ready(fc))
+		return fuse_request_queue_background_uring(fc, req);
+
 	if (!test_bit(FR_WAITING, &req->flags)) {
 		__set_bit(FR_WAITING, &req->flags);
 		atomic_inc(&fc->num_waiting);
@@ -569,7 +624,8 @@ static int fuse_simple_notify_reply(struct fuse_mount *fm,
 				    struct fuse_args *args, u64 unique)
 {
 	struct fuse_req *req;
-	struct fuse_iqueue *fiq = &fm->fc->iq;
+	struct fuse_conn *fc = fm->fc;
+	struct fuse_iqueue *fiq = &fc->iq;
 	int err = 0;
 
 	req = fuse_get_req(fm, false);
@@ -583,7 +639,8 @@ static int fuse_simple_notify_reply(struct fuse_mount *fm,
 
 	spin_lock(&fiq->lock);
 	if (fiq->connected) {
-		queue_request_and_unlock(fiq, req);
+		/* uring for notify not supported yet */
+		queue_request_and_unlock(fc, req, false);
 	} else {
 		err = -ENODEV;
 		spin_unlock(&fiq->lock);
@@ -2184,6 +2241,7 @@ void fuse_abort_conn(struct fuse_conn *fc)
 		spin_unlock(&fc->bg_lock);
 
 		fuse_set_initialized(fc);
+
 		list_for_each_entry(fud, &fc->devices, entry) {
 			struct fuse_pqueue *fpq = &fud->pq;
 
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 3f1c39bb43e24a7f9c5d4cdd507f56fe6358f2fd..6af14a32e908bcb82767ab1bf1f78d83329f801a 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -793,6 +793,31 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
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
@@ -801,11 +826,19 @@ static void _fuse_uring_fetch(struct fuse_ring_ent *ring_ent,
 			      unsigned int issue_flags)
 {
 	struct fuse_ring_queue *queue = ring_ent->queue;
+	struct fuse_ring *ring = queue->ring;
 
 	spin_lock(&queue->lock);
 	fuse_uring_ent_avail(ring_ent, queue);
 	ring_ent->cmd = cmd;
 	spin_unlock(&queue->lock);
+
+	if (!ring->ready) {
+		bool ready = is_ring_ready(ring, queue->qid);
+
+		if (ready)
+			WRITE_ONCE(ring->ready, true);
+	}
 }
 
 static int fuse_uring_fetch(struct io_uring_cmd *cmd, unsigned int issue_flags,
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 4f5586684cb8fec3ddc825511cb6b935f5cf85d6..931eef6f770e967784bbe9b354bc61d9bfe7ff8d 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -116,6 +116,8 @@ struct fuse_ring {
 	unsigned long teardown_time;
 
 	atomic_t queue_refs;
+
+	bool ready;
 };
 
 void fuse_uring_destruct(struct fuse_conn *fc);
@@ -157,6 +159,11 @@ static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
 			   atomic_read(&ring->queue_refs) == 0);
 }
 
+static inline bool fuse_uring_ready(struct fuse_conn *fc)
+{
+	return fc->ring && fc->ring->ready;
+}
+
 #else /* CONFIG_FUSE_IO_URING */
 
 struct fuse_ring;
@@ -177,6 +184,11 @@ static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
 {
 }
 
+static inline bool fuse_uring_ready(struct fuse_conn *fc)
+{
+	return false;
+}
+
 static inline int
 fuse_uring_queue_fuse_req(struct fuse_conn *fc, struct fuse_req *req)
 {

-- 
2.43.0


