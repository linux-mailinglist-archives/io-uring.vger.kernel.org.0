Return-Path: <io-uring+bounces-6072-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 315A5A1A62A
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:52:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA0CE18880E4
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:52:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BA68212D6E;
	Thu, 23 Jan 2025 14:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="cDk4R8Lw"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B394D2101B5;
	Thu, 23 Jan 2025 14:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643903; cv=fail; b=Rw3Vgyzo0TwrQO3dwjt8oUZ+WLNFmxPKP0TrtZqz/wMT8HvSH89kL9zJ804g/adpr1IM+fy5TPOPsvsgicbxhev9Z7jGFsmnokRuTNzgNqS44AxI5KyzLRgYl20CVcOZc8AOsjoYQfrslLIvRLB/6q8blfHWqVQeSixT7toXRLk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643903; c=relaxed/simple;
	bh=cpG2tW4gS67CInkjpiCPqBASFzNUKDKa6i0KW1WSL9Y=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Ot64S0qUkYCrwEiqBKS15QTWVDBfiAWgyrU0mhH5M2E25WeuuJpPtEd7T8Th9CIHsUn8AP2bP5Wyb8yVv6rt9RC67vGJ+/dFIwXpMD6sU53aeXl7sHE59AH/9Dv3awItRGJ+JHHRT24o5lMb2ixwkofOC9qVxjv9zppEpf2V/do=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=cDk4R8Lw; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176]) by mx-outbound47-74.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 23 Jan 2025 14:51:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YRsVroMQJlTFwTGaYZjsTfB+h0uAt/G4PDEMRQHGJmRmGtEdYR7zomagg1tlVgp5noJag3diVNJg8fshdNvBsZJpIydJ3QGpYkYLOWOAWZveXIQ1Qve9PE9JAYtq44Nbicvl56GEStG4T0XWe/VQwgx1Qw1hkywEgF8YlILyfjyim8faq2QFzL9q+kqUZ712XUo/gSHIYsj+eMnGx2fkD6yley6YfL2ERh5y34OUDIs+u8eTlWfenRqotJGJKEmknXnqhH2QqwpyJSX3Z8NvscRhT45Q1uoi8khZrRuPICwHi+F3uw7EjXE1wbEONgW8xUhyBUEsefGcVImDYx5wtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dwt+EcZS1YUXHxYGmv72xe9/UPdUipHSuY5WaR8Mx98=;
 b=dTdW8F4niGiYOyrgIcW87NEoRSJZu7+DOHaUsYs6tm/mzgMTaVzBNMYERawz6ERkrBw+AEYgBWCWOp1ktgUsWX+dvAR7sYiDmHgCTs6tb8soJaVa45Po1km23LdwBcnM70f4Px7AcfQ4WbcUwzufYoFvKOJmw2ZE9h7XfXGE3JOmkurQO2UZCVr5Qp3gzXyC3v3VboVJcEDoPkTn2fOmzOyJm9mVEiYI4rCS0XmGHFvzrRP1B3ehhPOBOYFSvoPcLvnNOgqidGCPzu+b2lToKTbNfihghF/zSiGWrHpZnMcf6yHgNBXsYjb8SxpgCH1mEDnazvMOoPvCOegR4hp8bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dwt+EcZS1YUXHxYGmv72xe9/UPdUipHSuY5WaR8Mx98=;
 b=cDk4R8LwKOBNwfaQQFMooWe4u+WhJilvpKs0JVRP4ZLGezJns1JStEoe/wJj7OY4c2opd+mmbZndqY8qqk5h2Xu1IVtGIvzwcoyPpAwBrIw7Qica1G8jC5I8SJwMMN/th8GK1mvgUBICNx4ggLnXezHQ0pEhe2rUclqa+rfrvN8=
Received: from CH5PR05CA0004.namprd05.prod.outlook.com (2603:10b6:610:1f0::9)
 by SN7PR19MB6662.namprd19.prod.outlook.com (2603:10b6:806:26a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.17; Thu, 23 Jan
 2025 14:51:14 +0000
Received: from CH1PEPF0000AD7E.namprd04.prod.outlook.com
 (2603:10b6:610:1f0:cafe::b6) by CH5PR05CA0004.outlook.office365.com
 (2603:10b6:610:1f0::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.13 via Frontend Transport; Thu,
 23 Jan 2025 14:51:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CH1PEPF0000AD7E.mail.protection.outlook.com (10.167.244.87) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Thu, 23 Jan 2025 14:51:12 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 2FBE958;
	Thu, 23 Jan 2025 14:51:12 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Subject: [PATCH v11 00/18] fuse: fuse-over-io-uring
Date: Thu, 23 Jan 2025 15:50:59 +0100
Message-Id: <20250123-fuse-uring-for-6-10-rfc4-v11-0-11e9cecf4cfb@ddn.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFRXkmcC/33QTW7DIBAF4KtEXneqAcPAdNV7VF1gfhoWsSOcu
 K2i3L04ahN7Ue8YpPfNg0szxpLj2LzsLk2JUx7z0NdBiKdd4/eu/4iQQ71oJEolUGhI5zHCueT
 +A9JQgEAglOQVkAiYPFktkm1q/Fhiyl83++29zvs8nobyfVs1qfn2hiKjgE4t3cpNLXzm0344n
 +BwcEeoMwJLNMm0LJRSryH0z344zJt+u9H/3SY1x2vUG90SUbzH52aTvrcRAs0GoysTLRE6ri2
 Y1wwtGCk3GKqMtJF8CBgrtGbMktlqY+ZHtaprHXHnvFsz9sFI5A3GViZw4iRJyS62a4b/GI3bf
 8NzG28sJXbGcVgzAheOxA2nHhC8M14HgWg8PqDr9foDD7APi7ICAAA=
X-Change-ID: 20241015-fuse-uring-for-6-10-rfc4-61d0fc6851f8
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Luis Henriques <luis@igalia.com>, Dan Carpenter <dan.carpenter@linaro.org>, 
 Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <mszeredi@redhat.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737643871; l=15174;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=cpG2tW4gS67CInkjpiCPqBASFzNUKDKa6i0KW1WSL9Y=;
 b=jT/+hPS4PaOiARFdH4lgyYR8fFQUq3XnKGs/qjuqER6cHug6cchHr3H/Aa7Nt+kU6VMUBasAQ
 s7h692pSd4WBSTPyl3MmjVzkiWcboa/8NA1owCg9uY8eshFH+pelEb0
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7E:EE_|SN7PR19MB6662:EE_
X-MS-Office365-Filtering-Correlation-Id: 69171c96-ca7e-4d03-4bc5-08dd3bbd61b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MXdwZTl0NUNkbVVGanhFV2x0ZmFwQThLaTZCdWpkaDNuUWFVT3dFY1NtZmtM?=
 =?utf-8?B?blpid1BIUldBZWp1UDlab1YwUzVJV01EdjM5ZFJmZXZWTEpuUGpHWkYxdkNO?=
 =?utf-8?B?MDFnWENRd0xBTy80TVBXUWl3WFhmRUdpRHBpK3BEMEltc2V1aUZ1dStaT0pG?=
 =?utf-8?B?WkdxS2szNHVtSE0vMjBWT0JYdU9uaUE3OTE2azhRdm80ZzJNTWlnTXRMUldX?=
 =?utf-8?B?SHVMWi9GOXhFNTBYMjJOVW5rSDNsY3R2Wk0rdVlxdUVtOHY2bVk5Zk5nQkQ2?=
 =?utf-8?B?VzNmdCtpZGNyMksrT0Y5VkpabTMybldWYml4eTZUemg4dWFKdURWYTlleXVY?=
 =?utf-8?B?c25qYWtiMFoxYjE3bExjSUlVMFlMMVZNQzFqS1hqa0RxU3BMMWxETW9Pa2tk?=
 =?utf-8?B?UlM0SVl1Y3piV3R0cENEQVB5RjlXeXVIQzNkUU9tcHR3eThKZlVDdWl4OWJR?=
 =?utf-8?B?SS94SkxHK1ZBVTU2MTc2SWRvVEpZdVNqSldBZ0RQTTJJSXVnMEZDdm55RHFP?=
 =?utf-8?B?c290R3NnajkvazU2TVBIazZySmhFQnN5Z3JjYlMxRnpydXVhVWpuRjdHWjA4?=
 =?utf-8?B?QUxhUWJaSG9DWkdpdWl2Y0RUOUIxKzdIeFFkMjZLK2plRzRZb0IzVFlyWnFQ?=
 =?utf-8?B?WEpES2toNG5sQ3ZEL3R6R0VwVXNwakxmSU9CQVd1NXArTkRFZGo2YlpNdmdw?=
 =?utf-8?B?a1JJU2ZuTjNBYnc5bGxJU1RMd1NxWXFGUkNFZ0pFTmdwZ1haVnRpZ1BiT2tO?=
 =?utf-8?B?KzdpeFJERWdRVWFUMFZnVTJJd3Vra0RsSlpLbWNYVHQyazRKZmVjT0hOVlph?=
 =?utf-8?B?ZVpjY09hMEJRaEVjcWlxRE1vSzh6cFA4MEREY3RDZkRrR1ptOEJsNGdjNkp1?=
 =?utf-8?B?L2JJUXBiZ3FVSU51dzdFNWRycmloWlk3WEhNWHFhUGV2VDRJQnNkUXV2cHdG?=
 =?utf-8?B?VDYrZ21yaGtTeThsUXlXWFhhNzdvdFdmeFFhSExpaXlsRittbHBFUUl4bXYr?=
 =?utf-8?B?cEFEZm9GVXBqaTdVamVURjlReWFYWmxmUHdKbTVpSXZ5b00vWGc5b1d6Qkxz?=
 =?utf-8?B?ZHNCU0l3QnJ3QVplK0FPMGFub0Rwb3I0MzM0VXZoWS9LT09UcEVoV3N5K3Ny?=
 =?utf-8?B?cHFYUGQwQWN6T2loeHQ3ck1CckJUQ21xbmdkZ1VBSmtKek11U1BrZlN2Ymlt?=
 =?utf-8?B?YTM5UEZsanVvMW5NS0NVYjVjT3lPTTJoL3RtL0crcnhWa1ZqTEtQamU5TG92?=
 =?utf-8?B?QmNYV1JleVd5Y3V4dE5Db1VkWG5Xejl0c3h3MHVLVGlCeGZhVlFkd0k1K3dJ?=
 =?utf-8?B?ckZxdE5yN0Y1cGhLRVlzekVwY3krQmpNa1lDdFhSZmZ1UXRVYzA4dW9OdDF2?=
 =?utf-8?B?ZEg2a3BGcUFJVkZhK243aXRDeGRaY2ZkSHB3WjlVNU45UkFRbVN0YU5jbVFP?=
 =?utf-8?B?K2pNSWZ2bGpMRWZTTWViVUNYQUJwYlI2MlhuTXp1MGxpWUUyemlUNTk1dlFX?=
 =?utf-8?B?YlBkTkwrTGJjd0ZOQ0hRQ3IySksrdkJReHo3VktCY0pCcUlaVXhqcUdCcFZZ?=
 =?utf-8?B?VjFQMTRidjB5Z2NZaHZnM0NvTWEzREpTUnFYd1pzSURlS2V3ejFQZzJmNDh2?=
 =?utf-8?B?TUVXVUpzK0R2V0dwaW1DYXJXdVRYS3RJTm1EQ3M3dUthK21aVWpCODFValds?=
 =?utf-8?B?NVpRWGV1WDlEQ2FrTS9YQ0N4aklFYUxPS01BSG5YUVVuZnJDS2hwRVl5a2dF?=
 =?utf-8?B?eUxBYWQrMVJPQk8zTTZUT21WNVJuWUdnUDZGbmRJZE5KczhOOWxyMHlrMlpn?=
 =?utf-8?B?WHJNdjI4U2tLdmZZT2FTZXBRenZIa1lGdU1vdEdNSks1Kyt6RS8vVWdtWitY?=
 =?utf-8?B?cFJxWjB2T05TdGdmWGhJZFZYTzRrUGI3ZWlmRXdNQWZjQjhCLzlVV1pqbHpL?=
 =?utf-8?B?d3doS3ZYV0duQkxkcWxUOEM5ajBZSXI1MDlHZHNES1RHYUpZdDhRaHNLMUM0?=
 =?utf-8?Q?VNnYQi8j3lCGhieG8t5IO0swkjEFjA=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014)(13003099007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5LSNCMqTjPQH7z5pbBo02uEiQ4n4XspRBuNDDS+haTH0MOVI+ugZx3vkTujCbYO63XouYheSJLQXhUlPDReDhFI4CJki8SnvWMvw0YMdMHe6zt1n7AvrSyoPy6qS6/sqtn0INMO6nbS5PbeK46DBVWRm55L9MyJ09t3PR9XDalNOnqZolRSNirWldLD23l+yWsODkZoAPxNoqb7vQAbQc8f1x3cLOUK1ulEgT2C1mSRTu8oahoCfkyCqUgyhde2fcdiZeRU46yR6N9P/MBHqBxcYH3INILGZm+8GnrNLUmAxtqSwGfPlpbCtOz4ARDHXE7VrXtV6XbJMxY6m7n3RW1Nlu1wrnJMwnkxDA8kudqdowGIPFoC3eji4sbujVr0x+CmgIa5o3C5Z9pEui2iXs2qsyt7bxjluIqnSm4yeFcJ5+i5ud40QEOnX9VfWF9Qz/5LSXVqa3qCJ4knieh830NGA8RF5TVpAI8MImmo8CRYyYCZC9CldDw93D0QoCJtYL/IvyAaM84om9EMtXbXmGd/f97iVH5zgPXhfUT7MPd9D3rmPuL8m6xcNtjC1r7dV6sbefb75XHaYgcdd73XFbCMeB9CCU8mb3UPTKzxSvSuJlGQJhW5bRL+qqHS4meqlsUeD7pn0/4qQ9+7LP0I5QQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 14:51:12.9554
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 69171c96-ca7e-4d03-4bc5-08dd3bbd61b8
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR19MB6662
X-BESS-ID: 1737643877-112106-13384-21403-1
X-BESS-VER: 2019.1_20250122.1822
X-BESS-Apparent-Source-IP: 104.47.58.176
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoYmFuYGQGYGUNTcPNHAzCDFPN
	EwyTTVLM3U0iQlzdA8Kck02cwy1cAkWak2FgC6Y+8EQgAAAA==
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.262002 [from 
	cloudscan20-47.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This adds support for io-uring communication between kernel and
userspace daemon using opcode the IORING_OP_URING_CMD. The basic
approach was taken from ublk.

Motivation for these patches is all to increase fuse performance,
by:
- Reducing kernel/userspace context switches
    - Part of that is given by the ring ring - handling multiple
      requests on either side of kernel/userspace without the need
      to switch per request
    - Part of that is FUSE_URING_REQ_COMMIT_AND_FETCH, i.e. submitting
      the result of a request and fetching the next fuse request
      in one step. In contrary to legacy read/write to /dev/fuse
- Core and numa affinity - one ring per core, which allows to
  avoid cpu core context switches

A more detailed motivation description can be found in the
introction of previous patch series
https://lore.kernel.org/r/20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com
That description also includes benchmark results with RFCv1.
Performance with the current series needs to be tested, but will
be lower, as several optimization patches are missing, like
wake-up on the same core. These optimizations will be submitted
after merging the main changes.

The corresponding libfuse patches are on my uring branch, but needs
cleanup for submission - that will be done once the kernel design
will not change anymore
https://github.com/bsbernd/libfuse/tree/uring

Testing with that libfuse branch is possible by running something
like:

example/passthrough_hp -o allow_other --debug-fuse --nopassthrough \
--uring  --uring-q-depth=128 /scratch/source /scratch/dest

With the --debug-fuse option one should see CQE in the request type,
if requests are received via io-uring:

cqe unique: 4, opcode: GETATTR (3), nodeid: 1, insize: 16, pid: 7060
    unique: 4, result=104

Without the --uring option "cqe" is replaced by the default "dev"

dev unique: 4, opcode: GETATTR (3), nodeid: 1, insize: 56, pid: 7117
   unique: 4, success, outsize: 120

Future work
- different payload sizes per ring
- zero copy

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
Changes in v11:
- Avoid a bad state when module parameter for io-uring gets disabled,
  but the connection already has io-uring enabled, new patch (Luis)
- Fix error return code for copy_from_user (Luis)
- Move a comment (Luis)
- Avoid an unneeded include in fuse_dev_i.h (Luis)
- Remove a redundant err=-ENOMEM (Luis)
- Increase array size of struct fuse_args::in_args to 4
  (Dan/smatch)
- Link to v10: https://lore.kernel.org/r/20250120-fuse-uring-for-6-10-rfc4-v10-0-ca7c5d1007c0@ddn.com

Changes in v10:
- Updated fuse-io-uring.rst (had missed the rename to
  FUSE_URING_CMD_REGISTER / FUSE_URING_CMD_COMMIT_AND_FETCH
- Removal of ifdef CONFIG_FUSE_IO_URING in dev_uring.c (Luis)
- Rename of all remaining '*ring_ent' to '*ent'
- Fixed a startup race and added WARN_ON_ONCE(!ent->cmd)
  in fuse_uring_ent_avail. That race actually looks more like
  compiler reordering - 'ent->cmd' was not set immediately.
  The issue was found by an additional patch (not part of this series)
  that does pinning of header/payload buffers, which slows down
  startup
- All 'ent->cmd' is now set/unset while hold queue->lock
  (for the issue above and also noticed by Pavel)
- fuse_uring_add_req_to_ring_ent() must take fiq->lock, to avoid
  a possible race with request_wait_answer()
- fuse_request_queue_background_uring() was in the wrong patch (Pavel)
- fuse_uring_get_iovec_from_sqe() in fuse_uring_register() was
  an accidental leftover, the actual caller since v9 is 
  fuse_uring_create_ring_ent() (Pavel)
- Simplication of fuse_uring_req_end() and callers, removes  bool set_err, 
  (although might set the error twice) (Joanne)
- Rename of subfunctions of fuse_uring_copy_to_ring(), as that
  reduces changes with an additional page pinning patch
- New helper function fuse_uring_dispatch_ent(), called by
  fuse_uring_queue_fuse_req() and fuse_uring_queue_bq_req()
- Removal of an error check in fuse_uring_queue_fuse_req(),
  impossible condition and if it would have happened, it would
  have left a bad ring_ent state.
- Several "nit" fixes (Luis)
- Just return of -EFAULT on copy_{from/to}_user failures (Luis)
- Add missing fuse_request_end() in fuse_uring_commit_fetch()
  in error case (Luis)
- WRITE_ONCE() to set fiq->ops = &fuse_io_uring_ops (Luis)
- Simplified flow in fuse_uring_send_req_in_task() (Luis)
- Link to v9: https://lore.kernel.org/r/20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com

Changes in v9:
- Fixed a queue->lock/fc->bg_lock order issue, fuse_block_alloc() now waits
  until fc->io_uring is ready
- Renamed fuse_ring_ent_unset_userspace to fuse_ring_ent_set_commit (Joanne)
- No need to initialize *ring to NULL in fuse_uring_create (Joanne)
- Use max() instead of max_t in fuse_uring_create (Joanne)
- Rename FRRS_WAIT to FRRS_AVAILABLE (Joanne)
- Add comment for WRITE_ONCE(ring->queues[qid], ...) (Joanne)
- Rename _fuse_uring_register to fuse_uring_do_register (Joanne)
- Split out fuse_uring_create_ring_ent() (Joanne)
- Use 'struct fuse_uring_ent_in_out' instead of char[] in
  fuse_uring_req_header (Joanne)
- Set fuse_ring_ent->cmd to NULL to ensure io-uring commands cannot
  be used two times (Pavel). That also allows to simplify
  fuse_uring_entry_teardown().
- Fix return value on allocation failure in fuse_uring_create_queue (Joanne)
- Renamed struct fuse_copy_state.ring.offset to .copied_sz
- static const struct fuse_iqueue_ops fuse_io_uring_ops (kernel test robot)
- ring_ent->commit_id was removed and req->in.h.unique is set in the request
  header as commit id.
- Rename of "ring_ent" to "ent" in several functions
- Rename struct fuse_uring_cmd_pdu to struct fuse_uring_pdu
- Link to v8: https://lore.kernel.org/r/20241209-fuse-uring-for-6-10-rfc4-v8-0-d9f9f2642be3@ddn.com
- No return code from fuse_uring_cancel(), io-uring handles
  resending IO_URING_F_CANCEL on its own (Pavel)

Changes in v8:
- Move the lock in fuse_uring_create_queue to have initialization before
  taking fc->lock (Joanne)
- Avoid double assignment of ring_ent->cmd (Pavel)
- Set a global ring may_payload size instead of per ring-entry (Joanne)
- Also consider fc->max_pages for the max payload size (instead of
  fc->max_write only) (Joanne)
- Fix freeing of ring->queues in error case in fuse_uring_create (Joanne)
- Fix allocation size of the ring, including queues was a leftover from
  previous patches (Miklos, Joanne)
- Move FUSE_URING_IOV_SEGS definiton to the top of dev_uring.c (Joanne)a
- Update Documentation/filesystems/fuse-io-uring.rst and use 'io-uring'
  instead of 'uring' (Pavel)
- Rename SQE op codes to FUSE_IO_URING_CMD_REGISTER and
  FUSE_IO_URING_CMD_COMMIT_AND_FETCH
- Use READ_ONCE on data in 80B SQE section (struct fuse_uring_cmd_req)
  (Pavel)
- Add back sanity check for IO_URING_F_SQE128 (had been initially there,
  but got lost between different version updates) (Pavel)
- Remove pr_devel logs (Miklos)
- Only set fuse_uring_cmd() in to file_operations in the last patch
  and mark that function with __maybe_unused before, to avoid potential
  compiler warnings (Pavel)
- Add missing sanity for qid < ring->nr_queues
- Add check for fc->initialized - FUSE_IO_URING_CMD_REGISTER must only
  arrive after FUSE_INIT in order to know the max payload size
- Add in 'struct fuse_uring_ent_in_out' and add in the commit id.
  For now the commit id is the request unique, but any number
  that can identify the corresponding struct fuse_ring_ent object.
  The current way via struct fuse_req needs struct fuse_pqueue per
  queue (>2kb per core/queue), has hash overhead and is not suitable
  for requests types without a unique (like future updates for notify
- Increase FUSE_KERNEL_MINOR_VERSION to 42
- Separate out make fuse_request_find/fuse_req_hash/fuse_pqueue_init
  non-static to simplify review
- Don't return too early in fuse_uring_copy_to_ring, to always update
  'ring_ent_in_out'
- Code simplification of fuse_uring_next_fuse_req()
- fuse_uring_commit_fetch was accidentally doing a full copy on stack
  of queue->fpq
- Separate out setting and getting values from io_uring_cmd *cmd->pdu
  into functions
- Fix freeing of queue->ent_released (was accidentally in the wrong
  function)
- Remove the queue from fuse_uring_cmd_pdu, ring_ent is enough since
  v7
- Return -EAGAIN for IO_URING_F_CANCEL when ring-entries are in the
  wrong state. To be clarified with io-uring upstream if that is right.
- Slight simplifaction by using list_first_entry_or_null instead of
  extra checks if the list is empty
- Link to v7: https://lore.kernel.org/r/20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com

Changes in v7:
- Bug fixes:
   - Removed unsetting ring->ready as that brought up a lock
     order violation for fc->bg_lock/queue->lock
   - Check for !fc->connected in fuse_uring_cmd(), tear down issues
     came up with large ring sizes without that.
   - Removal of (arg->size == 0) condition and warning in fuse_copy_args
     as that is actually expected for some op codes.
- New init flag: FUSE_OVER_IO_URING to tell fuse-server about over-io-uring
                 capability
- Use fuse_set_zero_arg0() to set arg0 and rename to struct fuse_zero_header
  (I hope I got Miklos suggestion right)
- Simplification of fuse_uring_ent_avail()
- Renamed some structs in uapi/linux/fuse.h to fuse_uring
  (from fuse_ring) to be consistent
- Removal of 'if 0' in fuse_uring_cmd()
- Return -E... directly in fuse_uring_cmd() instead of setting err first
  and removal of goto's in that function.
- Just a simple WARN_ON_ONCE() for (oh->unique & FUSE_INT_REQ_BIT) as
  that code should be unreachable
- Removal of several pr_devel and some pr_warn() messages
- Removed RFC as it passed several xfstests runs now
- Link to v6: https://lore.kernel.org/r/20241122-fuse-uring-for-6-10-rfc4-v6-0-28e6cdd0e914@ddn.com

Changes in v6:
- Update to linux-6.12
- Use 'struct fuse_iqueue_ops' and redirect fiq->ops once
  the ring is ready.
- Fix return code from fuse_uring_copy_from_ring on
  copy_from_user failure (Dan Carpenter / kernel test robot)
- Avoid list iteration in fuse_uring_cancel (Joanne)
- Simplified struct fuse_ring_req_header
	- Adds a new 'struct struct fuse_ring_ent_in_out'
- Fix assigning ring->queues[qid] in fuse_uring_create_queue,
  it was too early, resulting in races
- Add back 'FRRS_INVALID = 0' to ensure ring-ent states always
  have a value > 0
- Avoid assigning struct io_uring_cmd *cmd->pdu multiple times,
  once on settings up IO_URING_F_CANCEL is sufficient for sending
  the request as well.
- Link to v5: https://lore.kernel.org/r/20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com

Changes in v5:
- Main focus in v5 is the separation of headers from payload,
  which required to introduce 'struct fuse_zero_in'.
- Addressed several teardown issues, that were a regression in v4.
- Fixed "BUG: sleeping function called" due to allocation while
  holding a lock reported by David Wei
- Fix function comment reported by kernel test rebot
- Fix set but unused variabled reported by test robot
- Link to v4: https://lore.kernel.org/r/20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com

Changes in v4:
- Removal of ioctls, all configuration is done dynamically
  on the arrival of FUSE_URING_REQ_FETCH
- ring entries are not (and cannot be without config ioctls)
  allocated as array of the ring/queue - removal of the tag
  variable. Finding ring entries on FUSE_URING_REQ_COMMIT_AND_FETCH
  is more cumbersome now and needs an almost unused
  struct fuse_pqueue per fuse_ring_queue and uses the unique
  id of fuse requests.
- No device clones needed for to workaroung hanging mounts
  on fuse-server/daemon termination, handled by IO_URING_F_CANCEL
- Removal of sync/async ring entry types
- Addressed some of Joannes comments, but probably not all
- Only very basic tests run for v3, as more updates should follow quickly.

Changes in v3
- Removed the __wake_on_current_cpu optimization (for now
  as that needs to go through another subsystem/tree) ,
  removing it means a significant performance drop)
- Removed MMAP (Miklos)
- Switched to two IOCTLs, instead of one ioctl that had a field
  for subcommands (ring and queue config) (Miklos)
- The ring entry state is a single state and not a bitmask anymore
  (Josef)
- Addressed several other comments from Josef (I need to go over
  the RFCv2 review again, I'm not sure if everything is addressed
  already)

- Link to v3: https://lore.kernel.org/r/20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com
- Link to v2: https://lore.kernel.org/all/20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com/
- Link to v1: https://lore.kernel.org/r/20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com

---
Bernd Schubert (18):
      fuse: rename to fuse_dev_end_requests and make non-static
      fuse: Move fuse_get_dev to header file
      fuse: Move request bits
      fuse: Add fuse-io-uring design documentation
      fuse: make args->in_args[0] to be always the header
      fuse: {io-uring} Handle SQEs - register commands
      fuse: Make fuse_copy non static
      fuse: Add fuse-io-uring handling into fuse_copy
      fuse: {io-uring} Make hash-list req unique finding functions non-static
      fuse: Add io-uring sqe commit and fetch support
      fuse: {io-uring} Handle teardown of ring entries
      fuse: {io-uring} Make fuse_dev_queue_{interrupt,forget} non-static
      fuse: Allow to queue fg requests through io-uring
      fuse: Allow to queue bg requests through io-uring
      fuse: {io-uring} Prevent mount point hang on fuse-server termination
      fuse: block request allocation until io-uring init is complete
      fuse: prevent disabling io-uring on active connections
      fuse: enable fuse-over-io-uring

 Documentation/filesystems/fuse-io-uring.rst |   99 ++
 Documentation/filesystems/index.rst         |    1 +
 fs/fuse/Kconfig                             |   12 +
 fs/fuse/Makefile                            |    1 +
 fs/fuse/dax.c                               |   11 +-
 fs/fuse/dev.c                               |  127 +--
 fs/fuse/dev_uring.c                         | 1319 +++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h                       |  205 +++++
 fs/fuse/dir.c                               |   32 +-
 fs/fuse/fuse_dev_i.h                        |   66 ++
 fs/fuse/fuse_i.h                            |   32 +-
 fs/fuse/inode.c                             |   14 +-
 fs/fuse/xattr.c                             |    7 +-
 include/uapi/linux/fuse.h                   |   76 +-
 14 files changed, 1924 insertions(+), 78 deletions(-)
---
base-commit: ffd294d346d185b70e28b1a28abe367bbfe53c04
change-id: 20241015-fuse-uring-for-6-10-rfc4-61d0fc6851f8

Best regards,
-- 
Bernd Schubert <bschubert@ddn.com>


