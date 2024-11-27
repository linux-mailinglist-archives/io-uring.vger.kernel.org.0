Return-Path: <io-uring+bounces-5078-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB6A69DA8C3
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 14:41:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B46A282698
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 13:41:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3523E1FE446;
	Wed, 27 Nov 2024 13:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="stMuNVxV"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAD11FCFEF;
	Wed, 27 Nov 2024 13:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732714866; cv=fail; b=XLU9+sXdjbb7RnLIsKSJ1OFtp2a71DcuO8okZ+3mYKmx8DyJKKpmp6Hwwef/EwdhJSJYkXU4eDXxI/yfvDYi2CCGGAjiqLDbyPAT7KUT8pTZgqJYB12ZAkvkJyXy0/wN+3M62fOL8qgQgMsm4IXY0Tba817octLboNZTjF1EbW4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732714866; c=relaxed/simple;
	bh=6nCe00M/Y2uCOcEBUSArlvpHb6TYuQLIjdmKElKH1AA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Osu/sFLO4gORcPYm1ubYmAlsQvsr2XX3VmI/gBfxH0nbbN3eGMoMG4BIb0xxh7mm+Mrgud21i6D8gcc65EH0Jc1OrIRtNZ+ZmdSuR9G6F6fuve4IxtEggCYkN6ab2V/iu2qvD/Y7K8iI0N+9N4OCMhCvimzFvtgw3iAiAfkqHB8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=stMuNVxV; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40]) by mx-outbound42-26.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 27 Nov 2024 13:40:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IvgFL98xKvVUZdG6RSfnNjFQtI+Kt7nyiwVpTvZ02Zi+t/EA1tDjL2SBD1sRKyuZbFW/dx4wMBKRhC7MXCZzxbTV3NhtMpZShT6hvX+4Obnih0uAIx6gDlQ5nQEG/HuEOg3cI+PGVDS/PuxWRnyj7OiPFH2KCYp2cNBtqsOKgPt6w3/PfP2je3nBWaEGHyTA4CaZJ+QkM+0zHaeN+5tCv93HoXFGoZTxS43pRl+wWwM8Qq5lUi3Yv78Lzm3A4dwcBe/AtRDzSkIGNLk7UVG8PtxHXO3XyQwRgJM7QPQnyMvjuadhECa1+xpFjHor7+T2p+hG2QrPuBpcbcLcfr2DQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x7BlkzNG8aHLR53QUwTWM4fzHMjHh2RA6stjJUMt1vU=;
 b=t5vP5rG/V0kktY0KnGuflrdIwac7PaEOYPIYtuJP4ChIQPgTZW6UNHUT1HxoFZ/VNTVlHFSA9wb8nIyMiTZlbNZ/bvDigIc7ex481evzJ8ccRiNBjS164L+jmY/DBLxkVObn6R387EZW+D22dritO3kJLtshR0FU1LFhZAM1ROxcaXgHntGZyg2+A0/o/XVoZV56JgJhkafrr9kaZrLOBFPu5PYCvkjkYdPqizN2TLM0jz/G4ulG0XqYels9l+K4Pvr7o1F4GMQbjy5mLtNme2UvT9c1PcgwaVQeCNOeaeOuw4Qzcq4yzd8oJMK7bhytXXh8rINzZhRRm1gf+BrWYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7BlkzNG8aHLR53QUwTWM4fzHMjHh2RA6stjJUMt1vU=;
 b=stMuNVxV3sF5KdM9wr0mr0D32oM3crYrHjU2XCDMLWp9WoEY0azWWRbhj5xl0ChXFppg/QW1fKfNYGFnyJkfMKOV48+BmAX2EJv20j+HNDANnEi2Q5kbL1Mtcd+bgs8mwyppjRQChXDaq9fAzHQikKUzhfTRqyuN7096ZPiNrbs=
Received: from SJ0PR13CA0170.namprd13.prod.outlook.com (2603:10b6:a03:2c7::25)
 by SJ0PR19MB4778.namprd19.prod.outlook.com (2603:10b6:a03:2ca::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.13; Wed, 27 Nov
 2024 13:40:47 +0000
Received: from MWH0EPF000971E2.namprd02.prod.outlook.com
 (2603:10b6:a03:2c7:cafe::ce) by SJ0PR13CA0170.outlook.office365.com
 (2603:10b6:a03:2c7::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.12 via Frontend Transport; Wed,
 27 Nov 2024 13:40:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 MWH0EPF000971E2.mail.protection.outlook.com (10.167.243.69) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.12
 via Frontend Transport; Wed, 27 Nov 2024 13:40:46 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 2598A2D;
	Wed, 27 Nov 2024 13:40:46 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 27 Nov 2024 14:40:24 +0100
Subject: [PATCH RFC v7 07/16] fuse: Make fuse_copy non static
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241127-fuse-uring-for-6-10-rfc4-v7-7-934b3a69baca@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732714838; l=3662;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=6nCe00M/Y2uCOcEBUSArlvpHb6TYuQLIjdmKElKH1AA=;
 b=xtT3OFn6dWbl5bVBInOJ5HpG07A4aoVfVt5fTk3y24Li0pxcp1B5Thhh0epFeIOl5lMYI9igF
 JB6icG1FwxfAOCjTu+LRvFL/i0K8vv3UvmgpUz6vmy9xaKSHeNtHGMx
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E2:EE_|SJ0PR19MB4778:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ea8ca2f-c009-44f0-696d-08dd0ee91939
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U0Q5a05RemZSem5MWDZlc2xxcXFPd0NUcGwxZ2ZYdHllV0RrRWI1NldyTG1Y?=
 =?utf-8?B?Ulo1d050VlBXWmRNSmgzbHRFaWxxWWRob3Fnb3Rva2FwUjBvSXpWYmsycUh3?=
 =?utf-8?B?WjN3Uk5GQkh4QzNxTjVCYVovRnMwOFBVS0hXc1FkQnhCNElpMHBaQ3B2NDdL?=
 =?utf-8?B?ekVWL1d1dXVvZUs3aEh3MmNDa1RQTXhZbDgrZTYwSHRYeFZ2Y1F3R1ljTkc3?=
 =?utf-8?B?UVM5WnRDdXFWS24xcjd1a0RSVG9WNm1PSzhMQ3Fyd1hmakNveEdwTWhBVmRo?=
 =?utf-8?B?U280TitMUGtkZktoazIwYlBkL2VrWmZlUGpSSWZPUFNvUkQrWCs4VlQvSllq?=
 =?utf-8?B?VnZKdWIwb0NKNTA5V2srR0F6dC9jc0dIQzJYUnJva0FBRjY5NDRpbUdLS1dY?=
 =?utf-8?B?ZmNJNnRzUFBrTEpjYlIxc3hYTDZEYmJ4blAvQ3ZHeFZuZUhDQjVCM0o4Ymc5?=
 =?utf-8?B?SjluaDZMS3BsM1pOWjVhOVp6SG1CVnV0VXpKbGJXdm9oZUZWQ3ZXZzVWaVlB?=
 =?utf-8?B?dnIydEFndCt2NS9VVTdBVzgxcDlWUHlIQldTdjh6d3ljV0NYNWIyUkhXRHk4?=
 =?utf-8?B?WllhcTNyZms0VXVtK0VhU2F0TjNmcm5NUUFJU2FYVml5Skx3RkZ5b0p1cnlW?=
 =?utf-8?B?NnVRVWNJb3hqU3ZueHVoVmN4RlhpaEtvUHgyUzllUTZEZnIrWE1hNFNveVJa?=
 =?utf-8?B?QnpyQktjYjM3MDlDTXBkcmpnTjlTK3FpTFZEd3NHT0lGMWZpdGdjdjdqb2tP?=
 =?utf-8?B?Rlk5RmVkNlIzYlc5SmJBdXNmV1ZVM3JLWXJ2Q0haT29aNm5oOGpBcWx5V2hB?=
 =?utf-8?B?dlRuaVJiZ3dOT2N0R3JtTkxORFdONHUySFdMQndSQnhtdFdtSCtzL2JKbTRs?=
 =?utf-8?B?MGhNS085VDJmaXJXS0JvSUg4MmFhczVFeXFmaHg3YjVUNWt1WGtjeFhDOXZ4?=
 =?utf-8?B?UmN1RUlsNmlCTnA4NGJvQTRzSElrVVNKZG9nb2p0NVJSVVVCa2ZOcVRDakpO?=
 =?utf-8?B?YmVHeldiQXVRcUxrVFBuNDdvbzVwaDl5UUdrUW1GbkNvRUZGUWFuSXRqaHhs?=
 =?utf-8?B?YVdUQkk4V3BYUDViUCtJNGl6Mytzbkt2cjF1bGV1QW9DeEZ4bEZhelRST2Js?=
 =?utf-8?B?bWJ3ZThKTnJERDh1YTBhenhyK1g0TmpIaEVKeTFHWkF3dTdmOGpsN1gyQ3ZQ?=
 =?utf-8?B?OXVhK0VlN3JPM2xySGUxYU1GVDR5VzZLVUxadWtsamxEbXZ0MXlmYTVJNmxw?=
 =?utf-8?B?a1YrRDdwQU9nU2xRU290UnU0ZVpOWEdjekk5KzNLOU5odHdESmsyNWFYeENW?=
 =?utf-8?B?bGxiSC9IZ0JiZ0lJY0w2UmhISjZpMDBnUFh5dEhLR2d6dlNkT0VwTTZoZloy?=
 =?utf-8?B?V0VJTDZFYXpGWEhwd2hHdjBPMXFRZ09MVXdMQ0pFR1dMTmlFYzU5QVNib205?=
 =?utf-8?B?TlBnbHlxc2VobzlMSmdIQkhPdDkwUllXaE1iSjBPZ2taR1pJRFVTUFB4Wmpk?=
 =?utf-8?B?Y0N5RVdRVm9TZ0dLUlFZb1pFYW1HQkFmYm9hZGFJeDFtTlZFYStDRWllUDN0?=
 =?utf-8?B?VUdFbkplWndJYklmOXNnQmo2dzY5M3czMnE2SzhCZkZXdURjcjk4cnZkcnd6?=
 =?utf-8?B?WHNwakhaMm5TR3AwVE4wSTBlRHpXTnBlUVFPd1RVOWZaRkRjcXdvSVhJbXdE?=
 =?utf-8?B?amR5U3Y0VnY0Vm9pdXNqL0xldWUzTGl4WXlJNE5rakFHOFVCNzVBRUIwek1Y?=
 =?utf-8?B?Z3pqM0oxcllMYXhuTUluSjRtMWJDamJoUFpSU1NTTlVhRU14d1dFR0p2Zm5h?=
 =?utf-8?B?b0VpcEFWMHpuaE8yc1RiZzZaMlBnY0tRVmZXbUI0anJPVnhodXpLMTIzajJq?=
 =?utf-8?B?VVRjaXlKaGdpZmJYeUFvMWtsRkgvRGE4TG9CNDlvMzhHT0d5U1RBZjIvRWx1?=
 =?utf-8?Q?Na1EwABg2lD8d1CyvrfsTtkd+BrSWpyE?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	shcZWThaRaRbDTD90U+9ozzKOOGfK0tWYAv/612syOqI6EjhE3tOW028j3glQ8+vTnB2GzdSXb7zqcCnQSAJl+8g1aCPG8AVbnRyDMFjkoJGHpunFoSNjn6roH1wsb4cplJMbqpFC+VRLRNVxtuPYvqm6789dTh0s2l6X9J2bvNn7Nk7SEKglmnbz8h9IZlxc6HASnmqy06hFr98KV1vdcLtB5RtNvnp9KmW7SkDdUU0hXJD6UbfWTEnUmqptCRyU/2QGQdB3RpT0Z8j+dFZGjcaGhEPht1KyOVGvgtXWmfuK/b+v0Q4pwLtWlsT6SCrt6iXPWCG1U93aDJCmkPjlnjQ+RgjmMRMCwv9VACMvRvanWgouKs8zQZh4ipzqmM/THZfoPb5xjuBu74RgwOiqC5looKTWGi5cdGgQhTw6h0QNffoqCxMgOffwS3eFt3P3zs6DK2prBkrRLjLLAZael4MjxBurjTv+xF2Tlj0AL7ytWjfgDtadrGZetL/oe6qPuS2/7Fq2lZ74zVC7I8CgKgtN8KT4SUKNwz1v5h6ynZncHvUN2fEqAOnzU/TcHXwF8UHBloTmOFCMB6228ZBET/Km/vtGQzACvpWiaiScFjWiRIngEb4cvnE+iuQozEKBuOoVbMDLD/SH5XvFqUgoQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 13:40:46.8902
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ea8ca2f-c009-44f0-696d-08dd0ee91939
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR19MB4778
X-BESS-ID: 1732714851-110778-13452-2181-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.66.40
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVsamJmZAVgZQ0NDUPNXQ1DIxJc
	k4zcw42djSLDHRMMXU0twwOTXJzDBVqTYWAN8UqONBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260718 [from 
	cloudscan15-58.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Move 'struct fuse_copy_state' and fuse_copy_* functions
to fuse_dev_i.h to make it available for fuse-uring.
'copy_out_args()' is renamed to 'fuse_copy_out_args'.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c        | 30 ++++++++----------------------
 fs/fuse/fuse_dev_i.h | 25 +++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 0770373492ae9ee83c4154fede9dcfd7be9fb33d..94314bb61ea16b1ea4a42a1a4b36fbf5cbf7ef70 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -679,22 +679,8 @@ static int unlock_request(struct fuse_req *req)
 	return err;
 }
 
-struct fuse_copy_state {
-	int write;
-	struct fuse_req *req;
-	struct iov_iter *iter;
-	struct pipe_buffer *pipebufs;
-	struct pipe_buffer *currbuf;
-	struct pipe_inode_info *pipe;
-	unsigned long nr_segs;
-	struct page *pg;
-	unsigned len;
-	unsigned offset;
-	unsigned move_pages:1;
-};
-
-static void fuse_copy_init(struct fuse_copy_state *cs, int write,
-			   struct iov_iter *iter)
+void fuse_copy_init(struct fuse_copy_state *cs, int write,
+		    struct iov_iter *iter)
 {
 	memset(cs, 0, sizeof(*cs));
 	cs->write = write;
@@ -1045,9 +1031,9 @@ static int fuse_copy_one(struct fuse_copy_state *cs, void *val, unsigned size)
 }
 
 /* Copy request arguments to/from userspace buffer */
-static int fuse_copy_args(struct fuse_copy_state *cs, unsigned numargs,
-			  unsigned argpages, struct fuse_arg *args,
-			  int zeroing)
+int fuse_copy_args(struct fuse_copy_state *cs, unsigned numargs,
+		   unsigned argpages, struct fuse_arg *args,
+		   int zeroing)
 {
 	int err = 0;
 	unsigned i;
@@ -1922,8 +1908,8 @@ static struct fuse_req *request_find(struct fuse_pqueue *fpq, u64 unique)
 	return NULL;
 }
 
-static int copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
-			 unsigned nbytes)
+int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
+		       unsigned nbytes)
 {
 	unsigned reqsize = sizeof(struct fuse_out_header);
 
@@ -2025,7 +2011,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
 	if (oh.error)
 		err = nbytes != sizeof(oh) ? -EINVAL : 0;
 	else
-		err = copy_out_args(cs, req->args, nbytes);
+		err = fuse_copy_out_args(cs, req->args, nbytes);
 	fuse_copy_finish(cs);
 
 	spin_lock(&fpq->lock);
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 08a7e88e002773fcd18c25a229c7aa6450831401..21eb1bdb492d04f0a406d25bb8d300b34244dce2 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -12,6 +12,23 @@
 #define FUSE_INT_REQ_BIT (1ULL << 0)
 #define FUSE_REQ_ID_STEP (1ULL << 1)
 
+struct fuse_arg;
+struct fuse_args;
+
+struct fuse_copy_state {
+	int write;
+	struct fuse_req *req;
+	struct iov_iter *iter;
+	struct pipe_buffer *pipebufs;
+	struct pipe_buffer *currbuf;
+	struct pipe_inode_info *pipe;
+	unsigned long nr_segs;
+	struct page *pg;
+	unsigned int len;
+	unsigned int offset;
+	unsigned int move_pages:1;
+};
+
 static inline struct fuse_dev *fuse_get_dev(struct file *file)
 {
 	/*
@@ -23,5 +40,13 @@ static inline struct fuse_dev *fuse_get_dev(struct file *file)
 
 void fuse_dev_end_requests(struct list_head *head);
 
+void fuse_copy_init(struct fuse_copy_state *cs, int write,
+			   struct iov_iter *iter);
+int fuse_copy_args(struct fuse_copy_state *cs, unsigned int numargs,
+		   unsigned int argpages, struct fuse_arg *args,
+		   int zeroing);
+int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
+		       unsigned int nbytes);
+
 #endif
 

-- 
2.43.0


