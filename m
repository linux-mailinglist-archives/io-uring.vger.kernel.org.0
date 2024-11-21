Return-Path: <io-uring+bounces-4956-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EC2B9D56A1
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 01:17:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1363B1F225E8
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 00:17:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF6E615A8;
	Fri, 22 Nov 2024 00:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="N2iWj4g0"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E224A04
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 00:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732234628; cv=fail; b=jBEoDEZgRM6IMMXf6Pd5nsCltEPDHxDcV0UAA7sZUQyn78rTycaEPvG045XZiLT2qm0CQuyG5WhN+A70fjaWhMc2gefoNukAvEjrYRrc9Uprk7QNMJL9VI6Ga0yYuCqD1MNGAaBrHeGEJxqQEakGfdKxHpvswJgqJq3YJqPVj8Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732234628; c=relaxed/simple;
	bh=+WrcrOS7S19aGaDDvqYM7mR3M0AYD6vNepObBY/hSHc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PD4+AcoGubUn98VJFi2GJLX3grO/OgL+McpEIZyczJe0SbsUDEb99mjyf6fgRvRBI8e8qbYUTZBs50hlkbhG5bhPaf3R5+EWOJ5d4M0Qj5ogxKvzyHgJSVYm8IOOz5siBEkji7ZxfISN6xd3WZYWCsCc4k9xy6cOyNwhynePCns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=N2iWj4g0; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2174.outbound.protection.outlook.com [104.47.73.174]) by mx-outbound20-244.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 22 Nov 2024 00:17:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DS9+sb7IoztOLiPl5x69R/B0UnQatBEZfIfBLGwzn/7mMGyU70pATCS5j+kgosURx9Lq/jChX8v7ueDTQdA8GobWIspjmDaia7XmxgkMKr1sAcbDbjisYaNS50no/mBiSJe3vH9iRSNNmw/mDPC140XZy/zSTmVXCQvCUuSZvYVnKui5R/vMKEY+eCpZhZD0cUHBXAnE9TuQbjwShKTqwI6XCgMiJ6MTsNI7NquEAicTI9MqqjaQYSWodMOy6YGXfoyIJDVw32N9WPtG48FR9wCzPk7/YYNGfaPX9LEXqGTdWHoVkZxDVy0sgKdrU/h8EnZEWfhTTyuUr1xp2g8z0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OGwHhHgxLXrT76ri17FP1dSIOhhMaSHHNs95wieBHF4=;
 b=ea5bFWGu7+r6nLGee8n9j/1pns0Tbu/Mp/WxIyt1TQReJR/5XoxFEFEHJPh3dZu9N3sdMIGmCj+zAARP2B4mX8uy7MezZddl/IUrIZ7wYFVZgycNhvt161IvbX9uZ0OF8PEuwup4nAUP6480KdbNAfHiE1Bvjgia/n0qYkrc3sQOGucIC4VVFJgpgUUajHAlJA7PJgZ/6QJDNxFt0iZ/BTs0MyFjHsBNfaw4UkCaEm1d1ZaXzyr8CXzUTTojEUjp3qjaCrynLKKm0anXq541CL2QWCf6+qYQDZ+7oxeR9K3Ic/E3/STT4fnYS0vahaOlnXN+8txdHX8ZFYa313Zgfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OGwHhHgxLXrT76ri17FP1dSIOhhMaSHHNs95wieBHF4=;
 b=N2iWj4g0mBS/M3G3HF7h5K3RsQZbzrT0Qfj9LQrLdxKUt2tLTe9n0lQeuwSt7BsWLQ2pwCpEVZ8j57sN3vp9rIEsGmzk2w6z+y+NIJ7tLP+AW/gUVpTsU1Kqr2dxQNtCJuX+CC6YJzxT7+Mlgd0B3ghhXSCQpOeZqcW89cdCVXg=
Received: from SJ0PR13CA0183.namprd13.prod.outlook.com (2603:10b6:a03:2c3::8)
 by CO1PR19MB4918.namprd19.prod.outlook.com (2603:10b6:303:db::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.17; Thu, 21 Nov
 2024 23:43:54 +0000
Received: from SJ5PEPF000001D3.namprd05.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::e5) by SJ0PR13CA0183.outlook.office365.com
 (2603:10b6:a03:2c3::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.14 via Frontend
 Transport; Thu, 21 Nov 2024 23:43:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SJ5PEPF000001D3.mail.protection.outlook.com (10.167.242.55) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8182.16
 via Frontend Transport; Thu, 21 Nov 2024 23:43:53 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id DD62732;
	Thu, 21 Nov 2024 23:43:52 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Fri, 22 Nov 2024 00:43:19 +0100
Subject: [PATCH RFC v6 03/16] fuse: Move request bits
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241122-fuse-uring-for-6-10-rfc4-v6-3-28e6cdd0e914@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732232629; l=1326;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=+WrcrOS7S19aGaDDvqYM7mR3M0AYD6vNepObBY/hSHc=;
 b=r8+ixa7MdtUUyQTP7c2EEFhEqb693rzECsQs+yYsrA6YOet75wvcO1n8F2yYsuxs2qykv8DuD
 IctOsq3HfIbBwLZga4E6n0pJs6kFny/xrjrQCfS+734xmWvhUIxeOan
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D3:EE_|CO1PR19MB4918:EE_
X-MS-Office365-Filtering-Correlation-Id: e907f289-0d7a-40c2-b213-08dd0a865bdb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K3VjM01KTGNTNUpGQ0tnbUdteTVrNDFyODlNSHU1SHlYczNnbkh5MmRmZHYx?=
 =?utf-8?B?VW1zWUNVNjhnVXN2UHg1OWg0RTVHUkgxUkg4Z2VaOGNuZ2M2RDdYVS9JckRl?=
 =?utf-8?B?OFFJdWFXZjhCdzZWUG1ON0lDT0tpT3U1aDFQOHpjSmhHWDR0blpCKzBRK3h0?=
 =?utf-8?B?Rk9JUzZBenpqc29HOHRCYkpjWUNJVElSQ2luMXM3Mk1aUjN2VkxBNzlvRk13?=
 =?utf-8?B?NlpvbGY4WHFvSURZNElaV21LYmgxTHkxUnY4YzdGb2lYcG5nUEJEMmUrcVcw?=
 =?utf-8?B?ZUFXWkozMXljSEI1VUZCRmhkZTRVQ2FESDNOclJVd1MwTTZtam5JQlV3TWlk?=
 =?utf-8?B?T3JabmtJb1JQamladFNhdXNYODZ5L0VSQ0hETHhpYTkvSDJxOXZQSWU1SSsy?=
 =?utf-8?B?dEJTZCtLSzQ5RXJiUjFKS0p0VGNEV3hDb0grSjA0V2hGQjNSU3pDL0wvVGJ5?=
 =?utf-8?B?eEpSQjd3NDRiTEFGcEcrVitmT2RKUG1TcWhzOEVRdmRlT2hOYlZvZFZHU25q?=
 =?utf-8?B?Ulg4THN0ZkY3QjNmSGs5NnBRSi9wRVA5YzlZa1JqRTJ3K2tQYXFNMjFNaEgx?=
 =?utf-8?B?OTArYmV5cStYUVVHVENVUWlyREtjWjFCVEk5WTZUa2FxdTJXTVBOSExkNk5y?=
 =?utf-8?B?YjJnLzRqZ2lNZUlKSHM1TzJoUEdrVGxWbEZaZlBiR1FXbDhjQTIxcTdlUmxq?=
 =?utf-8?B?L21lVXU2QTNRczZySUxxMFVLM2Q4TEhDNjlyRGNSUnhBV053blRLVlRPZnlr?=
 =?utf-8?B?aWxPMm1zeFBRYmplYm5QS2UwMkVlSHRxaFRPeXNVZng4ZmhCTFltWVgveUhn?=
 =?utf-8?B?bGJicUUrRVgyYUtjMmZpd2RTaCtISnRyYTl6aE5jR0NaVmQ2bGRaZWliYVFw?=
 =?utf-8?B?L2FEU3d5Q3daaldHU0R2NEE4TkpNb0xGRW5iaVFFRW9BNG9tM3ByOEloeFQy?=
 =?utf-8?B?NUxaelVXMGVkL3hrVzFnTjVIQVVJampnRmRCOEcrd2J3ZXE5djY4c2tRUTEw?=
 =?utf-8?B?Ty9KZm9ib01FTkswM0RkOTY5TVNMZnRqWHZlM0w3TFBHQkFTL3g5cUJlR3E4?=
 =?utf-8?B?V3oyNVBRU2NIK3hrUy9HNVFpWkxNaUpCT1ltOThNeExKQngxNWpUT0VRYzVo?=
 =?utf-8?B?T3E4NjB1N1lpRld5ZmVvMklkMmJPbXhwQjByajR3SzdRcVZFakRhQ2tOR1ZY?=
 =?utf-8?B?TjBYYnVORHU3aTNaZjhnRkRDRzRnT0w3bG1JTStEN0gvZnQ1SVZ4bHMwZlZ6?=
 =?utf-8?B?bTk5N2N2aXZ2bElhaUVhYTRQQng4KytQZGtCcnp0dFA1OUlkOEFWTXJsZ2R6?=
 =?utf-8?B?Q0FzUkU5M2ZqQkUwckErbm05ZVdYQSsweVRvMlRnY1RBT0RBY0JlbVI5QjdG?=
 =?utf-8?B?KzErSTBrdyt4NDd2U3JWWVZuZm9qeDlYdmlCSFljWk9CU29CK1VPbmNDUXYw?=
 =?utf-8?B?bVEwVGJDV0QwVlJTd1pxK1ArV2lhSENPVElUeVZEZE5KblkrQjNueUNHUmx0?=
 =?utf-8?B?dzl4Vk5YSDMzYlgvN0xZVGpBSFVPWHhTTmd4a29YeVNVZUw5QVRVb09KR1JE?=
 =?utf-8?B?SGJOZ09PdUFnMVc2Y01sUi9VcWptTWtjWEtidUFQSVFhWXIrVUptc21uWUc5?=
 =?utf-8?B?OVR0Y2RpejlFVWtCbDJnbnJKWDcxK3Y2RnlRcytobnRmN0ZXQ0s2Y2lpKzQw?=
 =?utf-8?B?a21SVlhFRHZKWHlaU1cyVk5OWmFwb1VuZVduV3RoOVdFR2RwVTJKYng4akYw?=
 =?utf-8?B?OXFpOERGQUE4OXJvc2JOSUxUa2dhWjJveVBZTTNyZXRkZXRYWStTRFREZ2Rl?=
 =?utf-8?B?ekxSMWxlcmc0NGhVUVFJNGVxNHJJdFk3K2pWNVIwL25PVG1jWUozdmlRZ0FV?=
 =?utf-8?B?V3QrbW4xMnpIZ3NMQ3VPdE93YkRrMForYzlPdEZvV2tKWGc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	a7oRsqiTtLpHyUjhSWAx1fDVIHVCIh+iIMgQptVo+LQ3Nt7+geWF8z86pqocBAh65/BIvLgoIZpP/E1/q/ebOctgND7a3n51bKGlpwmHhrDqS9CTRFC0dLujHuRc0j23bYZhb0GmkVp//XeokCrBk+b5SN91S9H4E066zReMRhhU5nqntiYe33qGPwJtRrnO+yTPRQ56M9j0TU82XFA6YKp6glYFgPKhu0DyxuQt3X9UNl4nhD1MCMq/a9QpQ7H0RPgOOH8rfLF4Iitx1RFsifydxAAeGvvIDgd0gBRcziJZo8NFG+xQRxKQf7+PeCN8r0fIADrw8cIk1Q0qJXqnDVBC4IZNTqcWudiKZmO1KV6AVO0lV1gTJjlz3yqmJjnU8F57x3PcqpELoLaIt+6SA89N820fO+gRsh7k+4oTUK5rGmqFNUjruqGuxfbGnveSALA4ES4ui6N4BMDituaCcr4PMLNex5a/MPdCAnycIbyCaXIJNcerS/Yj9Gqz2aRdDaaUcwbKbDzxl1oubPvP0YHotWbmtzDVkfZ6+i9Nyy1v27WQLFgrUPEvL0eso7J/wKGhNlVAL6BKfSm5c6KSdQLPCzIfuN+UgMyrw5iwwLdIY/mQnkMB4nkZ1JTsispKfJl4foKOmFhXpMCIn8wsEA==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 23:43:53.8561
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e907f289-0d7a-40c2-b213-08dd0a865bdb
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR19MB4918
X-OriginatorOrg: ddn.com
X-BESS-ID: 1732234625-105364-29563-6014-1
X-BESS-VER: 2019.1_20241121.1615
X-BESS-Apparent-Source-IP: 104.47.73.174
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoZGFqZAVgZQ0CIl2czU1Dw1LT
	HJLDElJdXSxDjZyDw10TLR0DDR3MBUqTYWACnVpbpBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260587 [from 
	cloudscan13-74.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND, BSF_SC0_MISMATCH_TO
X-BESS-BRTS-Status:1

These are needed by dev_uring functions as well

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/fuse/dev.c        | 4 ----
 fs/fuse/fuse_dev_i.h | 4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 649513b55906d2aef99f79a942c2c63113796b5a..fd8898b0c1cca4d117982d5208d78078472b0dfb 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -29,10 +29,6 @@
 MODULE_ALIAS_MISCDEV(FUSE_MINOR);
 MODULE_ALIAS("devname:fuse");
 
-/* Ordinary requests have even IDs, while interrupts IDs are odd */
-#define FUSE_INT_REQ_BIT (1ULL << 0)
-#define FUSE_REQ_ID_STEP (1ULL << 1)
-
 static struct kmem_cache *fuse_req_cachep;
 
 static void fuse_request_init(struct fuse_mount *fm, struct fuse_req *req)
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index b38e67b3f889f3fa08f7279e3309cde908527146..6c506f040d5fb57dae746880c657a95637ac50ce 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -8,6 +8,10 @@
 
 #include <linux/types.h>
 
+/* Ordinary requests have even IDs, while interrupts IDs are odd */
+#define FUSE_INT_REQ_BIT (1ULL << 0)
+#define FUSE_REQ_ID_STEP (1ULL << 1)
+
 static inline struct fuse_dev *fuse_get_dev(struct file *file)
 {
 	/*

-- 
2.43.0


