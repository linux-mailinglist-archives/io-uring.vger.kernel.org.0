Return-Path: <io-uring+bounces-6098-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D6BCA1A7CA
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 17:23:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C29C0188C890
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 16:23:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7C79212FB4;
	Thu, 23 Jan 2025 16:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="tR9c/HaJ"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F064C212D96;
	Thu, 23 Jan 2025 16:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737649389; cv=fail; b=G0JvijhmXATwXTu1V/eKt7Pt+Rscn0nzCdHkY6krq5OQJ/4dxFHsSwV7UoJRE5yQReUhPA1t7lgQUswib0Hs2ufcWwlSf0Ei7Sa7S2JKpCusAPF6wKGClfs9mwIkbF+NimeieFxhjT+vdtqut0kbGTaXRDhzHVg55IeX1N9M9qo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737649389; c=relaxed/simple;
	bh=VUTEUPRcw3V5aeOBH9r551fvsJ4Wki8D1Oxwek6VJ4g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JBtorMM6E/JSPS8ki3uxXeOJ1jaxSVhuNqVz1GP6pN+nMbzxe9oILIIphF/6T++QkIBIm/5/miuua7/hCuGJgITZFsv25NHtxRc6ORoUV1/VmS1wy3tB34Xejy5/zZl7eZihYamZcJ3Mw5WVE0tHOLDPWGnwEZs7o796Jt7UjVY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=tR9c/HaJ; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172]) by mx-outbound44-0.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 23 Jan 2025 16:22:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pcM3+tzKFdhGFT3lWsnvWfRnxJErRSAIDJoXkmG+x52MRs5ofmQ2ofOfN1cuhaBXx51vV1h5lcJCBQz3aKecd/B/CBiL5YCz248CCk6VcfROD3BPoV4k8g4eUlfBx+73sk3N66e0i9dUBkaErtU8o9Zbks7iqC6HN48aTPeDk69njg1s30ddX8yqbFEE/1PFoaK0gmNMmbBnZj8cmG3b+BL8bKrzlLblcQfHCbC7cXYpLO/6je4SiNjmsavJkUhUJd+SVFtUZjQd4d7uiDCy4kTnpHUAgG2RwyYvH1WHRbuxuMKJ9aZjRQHpRKj78I9WXTMQcYmOas69MHQ17Nl0uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XhEtUo08MsEkn39Ly++YNJlv7pISHVszgv4WKcxzRF4=;
 b=iMrYwBCSgRVxqkOJDs4ATPLHBail3Qcry215PDEOjJr/9Ff0XSHfIOaJk3iog16dG9jW/y4pbNRLY1mrrkPPz5VcFw+LwwJGsN1/EuT0HCDM2eY8+KluD//fMOMBrVuWBjBdzK5ZDatpbvQmX3r6TPLAsEOJmq38md4TvsiC0vdIaYZvF5BfWqLObr/xTCS58iJ7KqBNSQHKclGo05bE+WAi2UWX0grvMfaJ18bQQiWedGUzk5b3KvnSm3hA/FMjqlRaqKnbQvUYTT2rC6NziikJAiE5BeBtCdKv34QwG05CpYPfb8da2Lf7rLQLEZTS4hoKLjiQHi6ygTMFLe/Z0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XhEtUo08MsEkn39Ly++YNJlv7pISHVszgv4WKcxzRF4=;
 b=tR9c/HaJgrJoLnuABlldzUYOW+1/M256Sy0QhWEDbY44s9NY5Hb2wtV4E3pMjymSmLnJbLMGXI65YZ8mG7YaPhk4ZW0tjhYo1TqGPqytkl145zns0WSCTPJGEr54uvgnTGIFYBG2KXO8tdjuGYDql6EZo2Tb51thE0KZQf2U6TQ=
Received: from BL6PEPF00013E00.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:1a) by PH7PR19MB6657.namprd19.prod.outlook.com
 (2603:10b6:510:1ab::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.20; Thu, 23 Jan
 2025 14:51:22 +0000
Received: from BN2PEPF000044A2.namprd02.prod.outlook.com
 (2a01:111:f403:c803::9) by BL6PEPF00013E00.outlook.office365.com
 (2603:1036:903:4::4) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.21 via Frontend Transport; Thu,
 23 Jan 2025 14:51:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BN2PEPF000044A2.mail.protection.outlook.com (10.167.243.153) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Thu, 23 Jan 2025 14:51:21 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id E7F1B34;
	Thu, 23 Jan 2025 14:51:20 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 23 Jan 2025 15:51:08 +0100
Subject: [PATCH v11 09/18] fuse: {io-uring} Make hash-list req unique
 finding functions non-static
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250123-fuse-uring-for-6-10-rfc4-v11-9-11e9cecf4cfb@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737643871; l=3290;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=VUTEUPRcw3V5aeOBH9r551fvsJ4Wki8D1Oxwek6VJ4g=;
 b=PpAqIlEzQcJWtuPyC8ONMH2TCE2tC8l1izzBwVkVTRol2v3K2PYKiwhvOMMJRH3HzzfIx5O2V
 KFu3WgQOThnDiGtm8A1eAeQgxWWi/WCLirWNLFnCeXWxCAQCnJ/dB86
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A2:EE_|PH7PR19MB6657:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c6aa0ff-540c-4024-d1bd-08dd3bbd671c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013|7416014;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?ZkZxTDNLSkRHMmMxTGVQOEJBQlhLb1JUN2xJS0RJdlBFaTQ2VXo4VzFpTzU1?=
 =?utf-8?B?ME45QjIwNjZJZUNqV2dwSklLNk80RXB2eGY3ekN6R1R5ejhuNS9SckZHNU9t?=
 =?utf-8?B?cWlrMS9uQm8zbEk5eWVMOXExbXp4eXlHY0Z2WXdpaFRYZndoL2ZZYVF3OTgy?=
 =?utf-8?B?cjcvTWVNUWJrZGZPeGJMSFJKRmlUU0FDaDNXcTVWL3ROYWJsaGdmUnA0Z1hE?=
 =?utf-8?B?ekVyOW1YaTVFOVJCSnRZTlh4eUJqZzF5L2RZRE5Pb1E4dHZzSy9Delg3dkk1?=
 =?utf-8?B?ZGlya0VnQ2ZCZ1FaTmF0TW0zUlFLTDhQVFRic3pPbmlmbjNlYVpFYVFiVDhS?=
 =?utf-8?B?VEp4MVg3Ymk3SUpHOE83ajNRMkttWitJNERmYjV6TUowQjMrc0VWUDk3YVhE?=
 =?utf-8?B?UFl1TlBBbXc0OTZjS2JydGNRQ0YzTW92Z1IvbmYwOG54d2ZtWW9MZS9OMTVh?=
 =?utf-8?B?V2JQcmZhcUJTOHhlZ1FGYUh0RTRrRWhDeU10dERYeFk0NGFBYk8xL2dBMlJa?=
 =?utf-8?B?OEUxMTJaYzAwN2c5bTdnWkdJOEtzNEpXZmNGQkFsUGl6NXJoL1hZc0tjcTg2?=
 =?utf-8?B?clk2Ull6TlNWbzNXbUh1RFBrMFVyTU5NNUR3V3RILzdQZVUrNzVrcThJclRF?=
 =?utf-8?B?ZEY5MHRlaHdIN09ZVzhEK0NWYmVyc0c2TmVBd1hPak90MnlmV3FoVXpkSGlv?=
 =?utf-8?B?RUEvNlhwYzFPOEFWdnlOdnQ2OXRiNXJINkZjN25mM1JLUFZqbjVFRFlzb3BK?=
 =?utf-8?B?WkhjWWx1anNmS3hYcXR1UFJIMFB1a0JPYVNPcWRIZWFmNW0wVDdLVnN2dDRC?=
 =?utf-8?B?ZS8vb29LaDhBMm56SHl3cFlzc2FTZlVRZVRzazI0U3dyR0s5b1hYZGs0Nmhy?=
 =?utf-8?B?RkJncG40Q0t1MzJpaUNNdFphWmZRengxOGRsU1owejhlVHNQYjBsMFZxRWFH?=
 =?utf-8?B?SW5qQzllWGRLbVU5MjV6THBpMlNETjV3aWRhRXdRWi9yTHQyYiszWEhYV0dC?=
 =?utf-8?B?amRPbjltVGNacGJIMnVFc2l6VVppWkJuTzRtSUJGTUlWcmtKQzgzNDNRS1RC?=
 =?utf-8?B?bHZ2RjI5YXIrd1FGdUtTU2E4d2tFeTVObjN3Z3ZxdWl6TEs1RnpNZVFacHlu?=
 =?utf-8?B?dmRkYm5XMmNOZlFyL1BaOUh5TzJFV0Q2VS9oTGJnN2lndlNnVzhIZUZJNzc4?=
 =?utf-8?B?SGFHWlI3Mm5Ock9BR1hpb3ladDBjTUxBM1JsMzJPc2d6czNlVjZiQXBjR0ln?=
 =?utf-8?B?V25uQTB5c1JSdDBDTHMraG1ua1htOHErbWIreUZBZFZ3VkxkdksyOHduYnU5?=
 =?utf-8?B?RkJEeHdva3huenoyenNjYjdleEJ1QmE1a0RkaWxBR015bFA3aTJZR2QvZHpv?=
 =?utf-8?B?MkZBTGRLZ28xVEJ5K0VuTlVETzVZOWl2Y1o0V1RyREp5eUFvNElhdU5WNHEz?=
 =?utf-8?B?QnVRbGhWdC85R2t4Uk5iMkJQT2NjSmVJMU0yK0Y0a3J5RzBUZjhkT1pqWjlq?=
 =?utf-8?B?VDlDVTZmVWwrWC9jc2djK1FsRlFTRk14ZGtTZGpxWHNYY2IvTzBjOGg2V0VL?=
 =?utf-8?B?Ris2VlpsdGZkOUs4bk1rczZ4RnBwend2bjZXWkFTS0NDaXZQV2txTStCdk1M?=
 =?utf-8?B?K1BmMlBEZEE1TXVqVjVQQVhHbzd2Unl4UVZnQnVieUcyUFhZY2w0aUdCT29E?=
 =?utf-8?B?cTR4dlhnMkF5Qy9WSWtXK2pKelk2NmJtcDZ5UzBWM3BBYi91S2RTQzVMeHFu?=
 =?utf-8?B?cGtLajFmMU5DQk0xcllNUTBkRFJ1WXVGbkZNWDkwNUJ5UXpOVjFlYjUxd0tD?=
 =?utf-8?B?OUxvSUR1M3JCUlZ0K1pFWDlSbDdXengxVGp0aU8yai8xZWQzT05jbisyTW9D?=
 =?utf-8?B?R2JzSFJ5bmxiZG1WZWFUd3IyVnM0V0c1U3ZEUXc3ckJRYlN4c3FuYndodWxP?=
 =?utf-8?B?VTgyZ2RacHo2eTJxRDQ0a3hRWHRqbEtYTitpNFZFMjN3czBNbWRpQlJhZmtT?=
 =?utf-8?Q?nTUYXdvH78JdD2jADIkZtmzaTbN8Cg=3D?=
X-Forefront-Antispam-Report:
 CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013)(7416014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 qvX817lOvAGeoKiDSvbVXsaTDyWf0Y1ugFjfBM/z1qMD8Aw6dQR9tpYvEhmsFLVq94EwudtJLqVzPxGf2cfPbve7+DMDyNKtVFm7tqyBE39O6icPGKGVij+utqctsbyKhhwZdXsIbQqbPBc6cYjenZ3aIZ6J8Z9+JtDdea5SVeS/jT5t6Pgnofo+zJ0wmXkrrVKl8/vEcFiAALITJQvvnnH1DE2MCQHadCWFwF30AlvLF9hr/A9itEyRkj6eg1+E7DMJJiQAqtnR68QPdoIweObI2KGwfJ/4Ua24pn6FK3pY9kG5mQQPHcdLol3a0Gbf/5cHHh91ZL5Q5cp6OW5FdFsq77X/BvQLVEl8lxWDydPyVgSb/bRaFCiI4oDpmPqZ0TxvTjmGRK4Gfq3YSHk5uvCUia4Wc6HG4jSQypkz/VZlrVxHH43TNwzim3YFkPvcHpZUVXbDPdj0C7hR6vGEyczweQBhi1dwUN6OFTncl8/dRNBPYcEnGAHNEhQWAgQh2dfj3TxVP0di+9981eZYsjYl4cESlgJIV+8l5+EsX44v1Bn2sKl4peSxvVqsfjgExOGVzT2nAlGWtF5kW1d21ueGMKofZVSWf21/KRHgb4A15AmSGmcNysSIkTHEYPk4e88t3BN4nUPDlFmZQV8W+g==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 14:51:21.8778
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c6aa0ff-540c-4024-d1bd-08dd3bbd671c
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
 BN2PEPF000044A2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR19MB6657
X-OriginatorOrg: ddn.com
X-BESS-ID: 1737649371-111264-13450-11660-1
X-BESS-VER: 2019.1_20250122.1822
X-BESS-Apparent-Source-IP: 104.47.55.172
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVsaGlkZAVgZQMNnMIDEpxcDAwM
	zc1Dgl2dwozdTA2CzF0sjQEqjIyFSpNhYAg+jL+kEAAAA=
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.262004 [from 
	cloudscan18-57.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

fuse-over-io-uring uses existing functions to find requests based
on their unique id - make these functions non-static.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/dev.c        | 6 +++---
 fs/fuse/fuse_dev_i.h | 5 +++++
 fs/fuse/fuse_i.h     | 5 +++++
 fs/fuse/inode.c      | 2 +-
 4 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 8b03a540e151daa1f62986aa79030e9e7a456059..aa33eba51c51dff6af2cdcf60bed9c3f6b4bc0d0 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -220,7 +220,7 @@ u64 fuse_get_unique(struct fuse_iqueue *fiq)
 }
 EXPORT_SYMBOL_GPL(fuse_get_unique);
 
-static unsigned int fuse_req_hash(u64 unique)
+unsigned int fuse_req_hash(u64 unique)
 {
 	return hash_long(unique & ~FUSE_INT_REQ_BIT, FUSE_PQ_HASH_BITS);
 }
@@ -1910,7 +1910,7 @@ static int fuse_notify(struct fuse_conn *fc, enum fuse_notify_code code,
 }
 
 /* Look up request on processing list by unique ID */
-static struct fuse_req *request_find(struct fuse_pqueue *fpq, u64 unique)
+struct fuse_req *fuse_request_find(struct fuse_pqueue *fpq, u64 unique)
 {
 	unsigned int hash = fuse_req_hash(unique);
 	struct fuse_req *req;
@@ -1994,7 +1994,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
 	spin_lock(&fpq->lock);
 	req = NULL;
 	if (fpq->connected)
-		req = request_find(fpq, oh.unique & ~FUSE_INT_REQ_BIT);
+		req = fuse_request_find(fpq, oh.unique & ~FUSE_INT_REQ_BIT);
 
 	err = -ENOENT;
 	if (!req) {
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 4a8a4feb2df53fb84938a6711e6bcfd0f1b9f615..b64ab84cbc0d5189882b043aa564934135cef756 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -14,6 +14,8 @@
 
 struct fuse_arg;
 struct fuse_args;
+struct fuse_pqueue;
+struct fuse_req;
 
 struct fuse_copy_state {
 	int write;
@@ -42,6 +44,9 @@ static inline struct fuse_dev *fuse_get_dev(struct file *file)
 	return READ_ONCE(file->private_data);
 }
 
+unsigned int fuse_req_hash(u64 unique);
+struct fuse_req *fuse_request_find(struct fuse_pqueue *fpq, u64 unique);
+
 void fuse_dev_end_requests(struct list_head *head);
 
 void fuse_copy_init(struct fuse_copy_state *cs, int write,
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index bce8cc482d6425a64c930c9b646d2f74e81323c8..fb981002287d331b55546838865580e5f575d166 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1237,6 +1237,11 @@ void fuse_change_entry_timeout(struct dentry *entry, struct fuse_entry_out *o);
  */
 struct fuse_conn *fuse_conn_get(struct fuse_conn *fc);
 
+/**
+ * Initialize the fuse processing queue
+ */
+void fuse_pqueue_init(struct fuse_pqueue *fpq);
+
 /**
  * Initialize fuse_conn
  */
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index e4f9bbacfc1bc6f51d5d01b4c47b42cc159ed783..328797b9aac9a816a4ad2c69b6880dc6ef6222b0 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -938,7 +938,7 @@ static void fuse_iqueue_init(struct fuse_iqueue *fiq,
 	fiq->priv = priv;
 }
 
-static void fuse_pqueue_init(struct fuse_pqueue *fpq)
+void fuse_pqueue_init(struct fuse_pqueue *fpq)
 {
 	unsigned int i;
 

-- 
2.43.0


