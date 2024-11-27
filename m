Return-Path: <io-uring+bounces-5073-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D88729DA8BB
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 14:41:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2F93AB2359C
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 13:41:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 602621FDE18;
	Wed, 27 Nov 2024 13:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="YM2j8pde"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613211FCF77;
	Wed, 27 Nov 2024 13:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732714864; cv=fail; b=qn7yoBjhqg6e7bThg0vWBn6TA9+QaHDJeYyhBXmKH7+a21MzsxmJkKkvqgIc5a9/5TkTSuCHX8mO8LJ5Ey3Q1Rx/7++TFMUB0iXNlq7dfTKimw1PjqsZuI6aLL8KVCaM0QR3NAUgV0CML8l/3hs8j6DpXfTDg6shm8cA50VonPQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732714864; c=relaxed/simple;
	bh=dGbzULYkqOY3NK86k6Rinuh/+I8xRP4zoFWvH/ef4YA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=trnt+Mk0yCfSctJP4mcXo73j31kF+uvBkBCCNwtyz3NWi/PVzOlJDemaxazZVvCPAghqowo7dMU5ycs+2abgzl34posiPOp00MObg11clM67h/tDjglz0P8qDB19R7fFj8KtnEOAJ86X6gn4zisjGOCEfaspBMq4TQ8nNMXj/yo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=YM2j8pde; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42]) by mx-outbound9-173.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 27 Nov 2024 13:40:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fded+kwjapyS1NkAt9br4kcAnZFyewhx7m7u6UP199VjzG9SwObMSa/hbXcCW1Ve+nrjPEwVsVE17QkS8ObGGHr0vmA6CkHyh0gJTkg/BQYkDkU6zStHWOvLeIAnV5fnaWgGvbp0p8QplhjyLwB+Pk+QUbmrzO8mh0IxY12j7zILvEV7d9NOJgfEOVJ2K3qprxCyM4oJ0AT5GJAYyUTQoWAMui5ZRXJzPcuJSw6JMyru+lR2fWjpSBn/qF391AR2pyzkp4bkrynwDq9RP0wxdl6FedDSRUCjdnzsM+ADe+TW1qyyBKlJHl2gYulJRXljpEOUXd7lZCGxbUJb/JrR5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u9NIVFwmQYGwLNqCJ0zYiwK+OdfgBdC/041D4/2Yym8=;
 b=AziGBhD85018dCZ7ksUDe9Kh4EqXx3nnTxv8IEupNDoq92x2g7qGMLeAUWrNz3MCoTZ0wo58UzZBZzlRorkJBl3sDwjmK1EoZN7Ke4PehiDE5kgoY+1Fz5F5YSQlpMcDXTclDZCCE0wgIqhMD9L8HsgQMMkUHxp5/9JqWOhD3KCDynfM9HOVrAZjOcayYFWR5x+WHPa/OEezKkLV+4Lj/KGXnwJbD5YDGoQsVJ30pIhnIErRlC2N8tMnVRHQYn1cfxP/1i7wyE4v18pUO+tzOPLtFzMCFC6o58lm2MkoENvrGsIlJNAjlZQtOuy2IgVjor5OngdtuEnpRbQNYvYIiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u9NIVFwmQYGwLNqCJ0zYiwK+OdfgBdC/041D4/2Yym8=;
 b=YM2j8pdevtbiCg95Z6j2Fv6fxTonuguoCB7QZUysdaaSW0sU9UTlobSVKpGcJ9XlRDjapwuyIUYXF6ihs5v1mzs0Dwwcv7R0/hL+byeX9XRt0HWgYcdw0rzBZaN/UrsWvoy64KXmPs83fd2VrkfNh9kRLOxcbpYm0TeWUa0N11A=
Received: from CH3P220CA0015.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1e8::8)
 by DM4PR19MB6558.namprd19.prod.outlook.com (2603:10b6:8:bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.13; Wed, 27 Nov
 2024 13:40:51 +0000
Received: from CH3PEPF00000011.namprd21.prod.outlook.com
 (2603:10b6:610:1e8:cafe::f9) by CH3P220CA0015.outlook.office365.com
 (2603:10b6:610:1e8::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.12 via Frontend Transport; Wed,
 27 Nov 2024 13:40:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CH3PEPF00000011.mail.protection.outlook.com (10.167.244.116) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.0
 via Frontend Transport; Wed, 27 Nov 2024 13:40:50 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 04C412D;
	Wed, 27 Nov 2024 13:40:49 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 27 Nov 2024 14:40:28 +0100
Subject: [PATCH RFC v7 11/16] fuse: {uring} Allow to queue fg requests
 through io-uring
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241127-fuse-uring-for-6-10-rfc4-v7-11-934b3a69baca@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732714838; l=8245;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=dGbzULYkqOY3NK86k6Rinuh/+I8xRP4zoFWvH/ef4YA=;
 b=iI8pNMYi7gpIM7QIHwmQL0fq64gNMEtOVFMvVvwVwUanx1DOiL5lKeRbt3oCULuqHxVDYZLx1
 /CggSxQGJhsB3jjExYe2emlcSrsU/7gyacxE/sTSvg+C3z6rkIdFsA7
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000011:EE_|DM4PR19MB6558:EE_
X-MS-Office365-Filtering-Correlation-Id: 744e52bb-44ca-4014-c232-08dd0ee91b9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aHN2UVZQcUVRTlgvT3NTdGc1VjBRVzFqK1FrdUJRRlFGK21JdVlldWcwdGpo?=
 =?utf-8?B?MnlsQ1U2TTVMSzZQcXA0am1jeFFoRDYvaE5hR0h2cVk2Z0xBeDFLZlBrNnJE?=
 =?utf-8?B?N3NCTURrRWVmZVFEbDJkbFR2THd4enhzcXEzeHFBY29Db0VnZVkzdldBM21x?=
 =?utf-8?B?NCtiY1VOa2xSMi96TlQwdjFJVXhPR2JsYmVGWEJvS1BaV2t6UFN4azFWWDkr?=
 =?utf-8?B?K1pZRHdaVGJsWE9uV2xKUC8rWVZMSmlDZnhUYlM3NmlpNjFyUXZyUDg2QU5m?=
 =?utf-8?B?NWdwRkQyNkpiemZPSU5QUzYyVEh4Zm9ZSUttVjV4MW80QTVpN0Ftbnk5Zjlu?=
 =?utf-8?B?UElzTHFLNFZGSVBrOUlLQlJzcjMzVlVyc3NXSTlOeVJDZDUyMEk2ZDZDcnhj?=
 =?utf-8?B?Y0dIcEw4SytXS3lmOUNhNUJjbnJDbXdLY2YvaVI2cS9vd0tSdzhKY3ByYkpr?=
 =?utf-8?B?VncxRkx3R0FzenBDb1ZFNVdSd1k2MTFvVFdnZmZzKzBENzhVeG51QWNTQ2tp?=
 =?utf-8?B?V01FVzdsS29tZmtmUmhSYVZVYk1TeU83OWI1SUJhYzM2Qnp3YVlLeXVuUFBw?=
 =?utf-8?B?dWdwdUZKQ21yLzVJOS9pTUtTK3NWSnpFdE5XOWdKZG5rNFRSeTRqYWxwNmt6?=
 =?utf-8?B?U1M3bkZjMVVnWlU5T2FncTN6WWxMY3JyajBCZHEzNzI0ZFZXdXJXOWFJeElP?=
 =?utf-8?B?cU5kZUlzemJNdDJnK2VmYjNNSFZ2b1owdWNvcDUvN2E2dm9HdVVrbUlIUXI1?=
 =?utf-8?B?T09uS005VWQ4U2VSMkJUYWZ6S29ZWEhLdjNGaXhoMUJrTW1SaHhSZjk1eFpG?=
 =?utf-8?B?U0ZZbm55ekFYTjY0Kzg1MElpRWk1Qkl1SVNxYW53ZmlMSWdPRGc4LzRtMFBt?=
 =?utf-8?B?UjYwUHZFdTNOMHMyYzdVeTBQcTFLeFltOEU1a1huTkVJcWJPdWw5STlrYWRq?=
 =?utf-8?B?RzZ0K1BSb1BaUDJ4MlE4amxKUXdOT01maHlkOGt2Tk43MXlGY3BvM0tUbytG?=
 =?utf-8?B?TUdwRUJQN0hHdzhXT0gzWWlyTHgwbHVBQlFHdCtFOERTQUZDRjIvcmUzcGha?=
 =?utf-8?B?cy9wb2REUjluczZ6d0V5WWRIQ1JBRVMzREhsNkdGM2hQUDVtWGR5UnZYWFhi?=
 =?utf-8?B?bG9xUHluaHB0NW1pMjZoSnJwYWUrWm9oZW13RWlQNTMwQ3lndStITWw1dmYy?=
 =?utf-8?B?YVY1RlpGZkh1RDF5bThFNlFzcjg5dGR6cVQ1dXVnSFhqUURjTmcwV01mM1JP?=
 =?utf-8?B?YjhxN3BRV1FEV2tRSmpISnM0bEFlL2pPZm1qVGJsUGR1TFZHL0xKaVd0elBS?=
 =?utf-8?B?R0xJTFpHQ0ovNDlwczBpS0VCcXBrLy94Z2UrYk1XWjB1ams2R3BNbmptTFBp?=
 =?utf-8?B?QSthMkZOMWVRVmtMeEVsSnlJNG0vanlUdnQ2VFVMT2RxYTlOdFlLb1FHWGpD?=
 =?utf-8?B?S3FSVVBlTENCVGpVQjMwZ0xGUjlJZXFsMVNvb2FIYmgrZVU3VS9BN0V4dENy?=
 =?utf-8?B?V05IOHVtdTVuLzdKeHdXVzVkZ21DVURyeGVwYWRTUWoyeWNzdWZZMXpIeWlI?=
 =?utf-8?B?cnFEaXBaZFBFK1oxelpCcEJsajNIUWNRL0QxaHljK0ZlcXpTbmJOVFJENmtN?=
 =?utf-8?B?VVFGa0pyRXZUZ2t1S2o5OWpEeUxaYURycUd1U3JqZExPay9lcHNrRGVTc3V3?=
 =?utf-8?B?MU4wVkRZN3VyNnQ5a1o4WnlTMjRsZ1hEWnN0T3ZjOENmKzNnK3FMVlJNN2hp?=
 =?utf-8?B?aUNGWm4wR3ZBZTU4V08xV2RhZmZFWlFHVXdWaEFxSkJTZkthQTNNcVhHSXMx?=
 =?utf-8?B?YUNYQ1RHdThsSkdSaU1YYkRRekU5YnJPSHE0VmJOQlZ1eTVDNG4rUHNOOEFM?=
 =?utf-8?B?NEp1NXQ1a1RFUURsRWNLcUpZanVib2FTd3RVUy9wcjFHaVNabnd2NVZIKzR5?=
 =?utf-8?Q?4I4OsNBLR4nr4+yjQqLBpBQKqu+8OVC4?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Vo8rzA8gMIc1fp6NoQINxML81SvjasR9vHSM2JQNMpdcXG25X/oh6ybsS+OqnfCP1b0b8Aq52BM3IcU0bfS6bHT0SoPMIIM3ArsGoLjoUByBCBiq01BDxqpZOyljwE4/sZXiHl+uodcVe7oyyUFTPORLRccZxDyad8OE3UFNmFcnnytH88pI5FnaHPEvz3lOaJUMFmttc4FrvUJfXFjWG5cWmswVs/5J7+BPuyIgyOzj6q+v24Lmm3FV6YrtbFuS9D08Cqx3AYH+nyYBVF+r4kn4UkBXs7cIvcnyUh7oVll51uZ2+mEf1e5biqRh5jRtCW8/ACc5qPNZaLawKhLnjIVgK8t/J3M/MjrOoT/twz8rZ9AxXcuT9vY/qkt6jcgWP3t4w07WgirI7h68qaIfuQr8+pAWmkljfetWJ+WzysX/gDGonVpQWRz/XCMRgZPIJE1DBEw+fmRgbSS9nvvM+3anjzeIKc3EomXmJF5GeoPnumRHnB7nysW7MYtxArd0p87yTUW1EJvDiFYz59ttgvZQgFx7b7ITG/mutp0FIGl6ruKa/oH6pqx0RKpIN+ZKjIB/fNa86yiDVVeUpu87SogLmoIoegVWY8/HyO60VW34e7PTSAQLsO6xg2jQ+wGUPARV+uOTwgSpSvBy4y/9ow==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 13:40:50.7339
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 744e52bb-44ca-4014-c232-08dd0ee91b9b
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000011.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR19MB6558
X-BESS-ID: 1732714855-102477-13345-4658-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.66.42
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVuaWZgZAVgZQMNUg2TTJPNHSNN
	XYLMnU0sLSwjAxKTHN3MzY0tTIyDxNqTYWAKYLWcpBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260718 [from 
	cloudscan8-156.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This prepares queueing and sending foreground requests through
io-uring.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c         |   5 +-
 fs/fuse/dev_uring.c   | 159 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h |   8 +++
 fs/fuse/fuse_dev_i.h  |   5 ++
 4 files changed, 175 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index ed85a5f2d6c360b8401b174bc97cc135d87e90d9..c53deb690cc9c7958741cd144fcad166b5721e11 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -237,7 +237,8 @@ __releases(fiq->lock)
 	spin_unlock(&fiq->lock);
 }
 
-static void fuse_dev_queue_forget(struct fuse_iqueue *fiq, struct fuse_forget_link *forget)
+void fuse_dev_queue_forget(struct fuse_iqueue *fiq,
+			   struct fuse_forget_link *forget)
 {
 	spin_lock(&fiq->lock);
 	if (fiq->connected) {
@@ -250,7 +251,7 @@ static void fuse_dev_queue_forget(struct fuse_iqueue *fiq, struct fuse_forget_li
 	}
 }
 
-static void fuse_dev_queue_interrupt(struct fuse_iqueue *fiq, struct fuse_req *req)
+void fuse_dev_queue_interrupt(struct fuse_iqueue *fiq, struct fuse_req *req)
 {
 	spin_lock(&fiq->lock);
 	if (list_empty(&req->intr_entry)) {
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index b5bb78b5f5902c8b87f3e196baaa05640380046d..b1c56ccf828ec2d4cd921906fb42901fefcc6cc5 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -24,6 +24,12 @@ bool fuse_uring_enabled(void)
 	return enable_uring;
 }
 
+struct fuse_uring_cmd_pdu {
+	struct fuse_ring_ent *ring_ent;
+};
+
+const struct fuse_iqueue_ops fuse_io_uring_ops;
+
 static void fuse_uring_req_end(struct fuse_ring_ent *ring_ent, bool set_err,
 			       int error)
 {
@@ -773,6 +779,31 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
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
@@ -781,11 +812,23 @@ static void _fuse_uring_fetch(struct fuse_ring_ent *ring_ent,
 			      unsigned int issue_flags)
 {
 	struct fuse_ring_queue *queue = ring_ent->queue;
+	struct fuse_ring *ring = queue->ring;
+	struct fuse_conn *fc = ring->fc;
+	struct fuse_iqueue *fiq = &fc->iq;
 
 	spin_lock(&queue->lock);
 	fuse_uring_ent_avail(ring_ent, queue);
 	ring_ent->cmd = cmd;
 	spin_unlock(&queue->lock);
+
+	if (!ring->ready) {
+		bool ready = is_ring_ready(ring, queue->qid);
+
+		if (ready) {
+			WRITE_ONCE(ring->ready, true);
+			fiq->ops = &fuse_io_uring_ops;
+		}
+	}
 }
 
 /*
@@ -945,3 +988,119 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 
 	return -EIOCBQUEUED;
 }
+
+/*
+ * This prepares and sends the ring request in fuse-uring task context.
+ * User buffers are not mapped yet - the application does not have permission
+ * to write to it - this has to be executed in ring task context.
+ */
+static void
+fuse_uring_send_req_in_task(struct io_uring_cmd *cmd,
+			    unsigned int issue_flags)
+{
+	struct fuse_uring_cmd_pdu *pdu = (struct fuse_uring_cmd_pdu *)cmd->pdu;
+	struct fuse_ring_ent *ring_ent = pdu->ring_ent;
+	struct fuse_ring_queue *queue = ring_ent->queue;
+	int err;
+
+	BUILD_BUG_ON(sizeof(pdu) > sizeof(cmd->pdu));
+
+	err = fuse_uring_prepare_send(ring_ent);
+	if (err)
+		goto err;
+
+	io_uring_cmd_done(cmd, 0, 0, issue_flags);
+
+	spin_lock(&queue->lock);
+	ring_ent->state = FRRS_USERSPACE;
+	list_move(&ring_ent->list, &queue->ent_in_userspace);
+	spin_unlock(&queue->lock);
+	return;
+err:
+	fuse_uring_next_fuse_req(ring_ent, queue);
+}
+
+static struct fuse_ring_queue *fuse_uring_task_to_queue(struct fuse_ring *ring)
+{
+	unsigned int qid;
+	struct fuse_ring_queue *queue;
+
+	qid = task_cpu(current);
+
+	if (WARN_ONCE(qid >= ring->nr_queues,
+		      "Core number (%u) exceeds nr ueues (%zu)\n", qid,
+		      ring->nr_queues))
+		qid = 0;
+
+	queue = ring->queues[qid];
+	if (WARN_ONCE(!queue, "Missing queue for qid %d\n", qid))
+		return NULL;
+
+	return queue;
+}
+
+/* queue a fuse request and send it if a ring entry is available */
+void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req)
+{
+	struct fuse_conn *fc = req->fm->fc;
+	struct fuse_ring *ring = fc->ring;
+	struct fuse_ring_queue *queue;
+	struct fuse_ring_ent *ring_ent = NULL;
+	int err;
+
+	err = -EINVAL;
+	queue = fuse_uring_task_to_queue(ring);
+	if (!queue)
+		goto err;
+
+	if (req->in.h.opcode != FUSE_NOTIFY_REPLY)
+		req->in.h.unique = fuse_get_unique(fiq);
+	spin_lock(&queue->lock);
+	err = -ENOTCONN;
+	if (unlikely(queue->stopped))
+		goto err_unlock;
+
+	if (!list_empty(&queue->ent_avail_queue)) {
+		ring_ent = list_first_entry(&queue->ent_avail_queue,
+					    struct fuse_ring_ent, list);
+
+		fuse_uring_add_req_to_ring_ent(ring_ent, req);
+	} else {
+		list_add_tail(&req->list, &queue->fuse_req_queue);
+	}
+	spin_unlock(&queue->lock);
+
+	if (ring_ent) {
+		struct io_uring_cmd *cmd = ring_ent->cmd;
+		struct fuse_uring_cmd_pdu *pdu =
+			(struct fuse_uring_cmd_pdu *)cmd->pdu;
+
+		err = -EIO;
+		if (WARN_ON_ONCE(ring_ent->state != FRRS_FUSE_REQ))
+			goto err;
+
+		pdu->ring_ent = ring_ent;
+		io_uring_cmd_complete_in_task(cmd, fuse_uring_send_req_in_task);
+	}
+
+	return;
+
+err_unlock:
+	spin_unlock(&queue->lock);
+err:
+	req->out.h.error = err;
+	clear_bit(FR_PENDING, &req->flags);
+	fuse_request_end(req);
+}
+
+const struct fuse_iqueue_ops fuse_io_uring_ops = {
+	/* should be send over io-uring as enhancement */
+	.send_forget = fuse_dev_queue_forget,
+
+	/*
+	 * could be send over io-uring, but interrupts should be rare,
+	 * no need to make the code complex
+	 */
+	.send_interrupt = fuse_dev_queue_interrupt,
+	.send_req = fuse_uring_queue_fuse_req,
+};
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 52259714ffc59a38b21f834ae5e317fe818863dc..19867d27894f9d985e224111ea586c82b4b4cfe8 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -119,6 +119,8 @@ struct fuse_ring {
 	unsigned long teardown_time;
 
 	atomic_t queue_refs;
+
+	bool ready;
 };
 
 bool fuse_uring_enabled(void);
@@ -126,6 +128,7 @@ void fuse_uring_destruct(struct fuse_conn *fc);
 void fuse_uring_stop_queues(struct fuse_ring *ring);
 void fuse_uring_abort_end_requests(struct fuse_ring *ring);
 int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
+void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req);
 
 static inline void fuse_uring_abort(struct fuse_conn *fc)
 {
@@ -149,6 +152,11 @@ static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
 			   atomic_read(&ring->queue_refs) == 0);
 }
 
+static inline bool fuse_uring_ready(struct fuse_conn *fc)
+{
+	return fc->ring && fc->ring->ready;
+}
+
 #else /* CONFIG_FUSE_IO_URING */
 
 struct fuse_ring;
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index d7bf72dabd84c3896d1447380649e2f4d20b0643..1d1c1e9848fba8dae46651e28809f73e165e74fe 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -17,6 +17,8 @@ struct fuse_arg;
 struct fuse_args;
 struct fuse_pqueue;
 struct fuse_req;
+struct fuse_iqueue;
+struct fuse_forget_link;
 
 struct fuse_copy_state {
 	int write;
@@ -58,6 +60,9 @@ int fuse_copy_args(struct fuse_copy_state *cs, unsigned int numargs,
 		   int zeroing);
 int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
 		       unsigned int nbytes);
+void fuse_dev_queue_forget(struct fuse_iqueue *fiq,
+			   struct fuse_forget_link *forget);
+void fuse_dev_queue_interrupt(struct fuse_iqueue *fiq, struct fuse_req *req);
 
 #endif
 

-- 
2.43.0


