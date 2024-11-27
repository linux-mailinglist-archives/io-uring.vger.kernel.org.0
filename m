Return-Path: <io-uring+bounces-5076-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 245AF9DA8BF
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 14:41:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8A93AB2381A
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 13:41:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBC2B1FCF6D;
	Wed, 27 Nov 2024 13:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="HlImQ77j"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CC51FCF71;
	Wed, 27 Nov 2024 13:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732714864; cv=fail; b=PFLNpP66uprZBmabr6cRZPAOHiS1ammDBKoemWtumDIUwccoVuah8Qni9FkfctONApbIBYfx7rdhXDFQkQMc2lrlmQqLRExRj3pXZD0U7OSGdF58/e+hf3WRuhshcEXH2Ki4zXqmb2Bgii19HOYGx3v7v3UKA5PecEJJWL7lp6Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732714864; c=relaxed/simple;
	bh=lk+GOLceA/m4U6xVHEXUcPbTehzUGN295elqdpRFwHM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iVCFPBwt5nmruQ8/Kn2RumDcd7K9myVkaZIRnpJu2bRu8YQlD/YiaKRCjTGteX49i9FXBQYRhS8JvgK45AFnDVJsAWAmQNuO93kDxkSS+tchp97cgTyrOGVepvaghKH6KkT84q3f/Xq1jxp4xSlYUlSquJaWtU49K9J9DqAycRY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=HlImQ77j; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169]) by mx-outbound19-109.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 27 Nov 2024 13:40:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Snqexsm1C9XbU9mkqO+CkmuQPOQ8QnP7ftyPwgAbndBw7nwcNU1j1Dezgj0gP371JIH0HAK3LQk3w83+LmMvT/HHoBWDTEOF04zr69wNIKYGgGF6GjaeFcf02AfILXKJWWHYV4wXQIwdPGuIN1YFMNo03NxDi1qdshHiD8By7xDGn8MMAbdGNmm6RNNYclAHq7tGU8qCklEsVoRyag6/Wp//Gwpz/9MAXqf8vP3Zde8mzyrS+lGSjCEgJd0TqYtJzXUQxCJdmayW7agVso+5xw6sIOJUQ62pQWwRtbicCN1EvuR+MjboJNXloscvwJfeq20S9v+hBHFbWFuOcAmH5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WsE01SpG6PNiWZe/CyqupLxZiKyJ2MHJDW56MaI/U7w=;
 b=xOsvsgpfFFJ7F7ClhkhyZShuHo65gnahKEI1qDi7GlbSn7HMsDH7ivZ1a1SNCsPwKzqTJgpPg6KpbEEXNCkFMaHK7rdI/DOS3ISHUXXeYNOoIIb/wanuthnk3ejXXrF7Ps7NBGZBYPW+pHU98DF3RRrLKTA5GkVD3/Xj8iBj7cesy4r2g57JdkaItLABMKHuZeGLMmSHLa/ENfsmyQHI66rAyMDPfEo7Lu2+Huebse7Hs44tXkknwNZqdiBY7XHzoDG1ZVBr9RDy3nZkuBLEZv2rLoBf1M+y0vVf0XNqYvw3KB/5D+/52NiM2JG3dZrj9uwZHcdajbRoYzqNGELHvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WsE01SpG6PNiWZe/CyqupLxZiKyJ2MHJDW56MaI/U7w=;
 b=HlImQ77jC0lVmG+SXhq1ya2T9ertLthBGB3phVp0S6WhqytweAkCeHKTbD9SjyiB5f/l1ygaKj0TqYEF/NMkxjIquGs+KSj80/1yPP2l6dickeaAIWNNhgJuadDtjkxgzfuSVPTAWfY6LHeeLia3Kd2lmsRHYEsn+9sLFolVEzw=
Received: from DM6PR07CA0046.namprd07.prod.outlook.com (2603:10b6:5:74::23) by
 SJ0PR19MB5384.namprd19.prod.outlook.com (2603:10b6:a03:3d7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.14; Wed, 27 Nov
 2024 13:40:46 +0000
Received: from DS3PEPF000099DE.namprd04.prod.outlook.com
 (2603:10b6:5:74:cafe::da) by DM6PR07CA0046.outlook.office365.com
 (2603:10b6:5:74::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8182.17 via Frontend Transport; Wed,
 27 Nov 2024 13:40:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 DS3PEPF000099DE.mail.protection.outlook.com (10.167.17.200) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.12
 via Frontend Transport; Wed, 27 Nov 2024 13:40:45 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 2D8DD32;
	Wed, 27 Nov 2024 13:40:45 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 27 Nov 2024 14:40:23 +0100
Subject: [PATCH RFC v7 06/16] fuse: {uring} Handle SQEs - register commands
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241127-fuse-uring-for-6-10-rfc4-v7-6-934b3a69baca@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732714838; l=17027;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=lk+GOLceA/m4U6xVHEXUcPbTehzUGN295elqdpRFwHM=;
 b=QG/7V9sxLogML1nLRv9+jZTHaK/XCc7FVXAQ0sAI/UB4xfQYQ49C3inreKIjtxzNonu/gPMhl
 EzbRT3tjASzAAGtfSEtcF0O11DYIzuAxEfSg1xGUEQVZB+YUMiKklVZ
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DE:EE_|SJ0PR19MB5384:EE_
X-MS-Office365-Filtering-Correlation-Id: d1023143-068d-4028-1636-08dd0ee918a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NlNnaFBXSWZXOHd0T2o0M1N1SzAySTRyeDh6S3hQZlpiYk9PZitYdnJhNFhu?=
 =?utf-8?B?NnRHU1E5MlhvbG1XMnJTQWhkeWJxU1FpTENBa2hhKzlGeElFNkYwQjRLVm5t?=
 =?utf-8?B?emk5QmV4SG02QzJ1YkVhaStkMnpkMG12TDBsSWtZcEY1ZmxKM3djRTBXTDR5?=
 =?utf-8?B?eVBGNXV1QllHMTFrd1JmbWYwb1pPdkZTbGxKUHJYbVVkMGdIaE1RNy9JbTBl?=
 =?utf-8?B?UmZKZ3hVa2ZVQk1aS0EwclFEU2pUWHg4eWJNM28wUDJwRC9xUFlKSkx0dVdQ?=
 =?utf-8?B?V0RBK3cvYVNpTFFnaUlqQjBNeWMyYThJemtNUzlIeWwxQ2FwUDhlOUU2WWtG?=
 =?utf-8?B?eWFRN2pWd0I2WTVjMmR3MkxHNWFUeklaaDU4YlExMXRFVjVuVlpGajJHSU9u?=
 =?utf-8?B?L2ZFVlE5YjBiekxaWTN2aXhUU1M0RStibmlxV2NJNmNkOG9SM1pMZnEvaXFO?=
 =?utf-8?B?MTFsVDhwbGFibWJTMTNwQytSQS9lYjF4bkFMaDRrTC9KVDNBS3lZVGxHU0hs?=
 =?utf-8?B?a09OaktOU0loUi81UmNqbng2aERsb3VLbGdhNXdETWpGT3Byc3JqTzdxQXVp?=
 =?utf-8?B?YVZkRDA4Tk14V0RXOXFGNStnYXhnc0E1ZkQwUURhRDN2VDU3VVJnR1J1cFhW?=
 =?utf-8?B?bFJUbDBnQ1V5UE0wQzNYOVJKL1lGengyM28wbXlyalh2WjMzSTlxcG51N1Vq?=
 =?utf-8?B?U3BJZWtzdDlkTnFPSkxpZ0pweWNZV05QeTdvM1diK1Q0eHFoYkFBcHdkNGh1?=
 =?utf-8?B?V1l2Qlh4VUNpOEFKb0ZPQW9Ua3RYY1V1SXFHQXU5bkhkdzU1dFMveFhkVHJq?=
 =?utf-8?B?aW0reXZDTVAxSUszNlM4ZXE1L1lCZk5JQm1XUlVnaXFadFJJTDdtVDBialJC?=
 =?utf-8?B?YTBtd2dLNmJ2QTBkZnNCdjdHM01ZK2J3WFZkSE5JNmFiUHhncUVrUTh5bThE?=
 =?utf-8?B?a2lsNzdEZnBSakVhTHZGdk9ZRmp0b1lIYVZmT2UxZkUwbE1XSzlxSlYzL0JG?=
 =?utf-8?B?dFFwQWdseHRselVmZmdNRWVkbk5OWFRveWhUZzY2SFFhOWVpMmsrV2l4eGpu?=
 =?utf-8?B?b0dvZGVOUDFkMWhOeWlnN2hTbmZnSllsTkZMeEpoYmljZmlZSkRpU0xDVW9n?=
 =?utf-8?B?N0VQR0IwM0EvalNGNWo4YmlCWGllNC84MXJVV3p3eXpCdGxvLzgxaTUxcEh3?=
 =?utf-8?B?d3NBL29PVWxwY2Z5NHErcHlaQTBGMUx3MVJNVEppb3EvaEl1N1dFUGFjUGto?=
 =?utf-8?B?RGVDOENJa1B6SmNEakE4MlA1N0xBbXUzenBRVTRnVHkremw1N0QrYk1aNXll?=
 =?utf-8?B?YnMrbmxvdmpKK1M5SzU1dHc4THZoeEk5RnlFQ1R0T2RSWWtYVmQrZ0F5U3Nq?=
 =?utf-8?B?MG9tZEJWKzUrZ09xOE9VSUVQdWxOZkcxNTZtSXF6aVRaSjdWT1Z3WVN6RE5R?=
 =?utf-8?B?Sk1sZDV3amtsZWhhWWpySzZSa21mQ1lRZFg4WDdURngxTlZEVUZIbnJYdXZj?=
 =?utf-8?B?Y0ZRZ2xlYkZGbGlLdlZueGI0U0tySUx2ZHA2RHV2RVVBWEIyZ3VES2F0dFZT?=
 =?utf-8?B?NklFalRQMS9OZXUxNE8xVVRjUlR0MkRVOGl4UDIyME1MancrY2ZLcUJGZm5a?=
 =?utf-8?B?RERiVUFyV1Q5TGxsRmhOaW4rWi82bjVoekUvZy9CTEVROUJ6U2ZuOXZ5ZkI0?=
 =?utf-8?B?elB2b200UWVSM2NIUGJWazRKU2NKUW52a0ZRV1V3UEx1NjdHc013SjE5b1JN?=
 =?utf-8?B?UFYraFJ4bVRObVhZbXNTQlF0dFVJTHJ2TWI5TC9UVktOWDBSOGFQenB1cEd5?=
 =?utf-8?B?WW1JR0xILzRqQXRuS1RmdjhJdk9WNXcwcitXdUJVUm1aYzdkM0t0M2FYOVVY?=
 =?utf-8?B?V042NkdYa0hsZHlKeURzZzFXMHJzamtXR09uQlBsNE0vTnp3S1VtR1c5U090?=
 =?utf-8?Q?tImlCSbMJMy7GlS4skz79vBCpH7YFqjD?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bTRi5g6t6AfJ/EFsY//xZEGcTLRVy7IaXuM+lee7fxq2/57lUVyWZTdMrTPvhlGk+NF6WT6H+Cb+RL3EoHTvroByRT9klKSsMf4FuQB3YCClJoggqVJ9OzyJaoXj7zPNfmL7U5pNOsuONFv7miQxhfqcMMyT4gSRWxzeJsjzWFtq3O3+xjplpe7TLBRU3zF8wn1jreoMNanygHUsYe22bBjga24tilwup2Lr0bGGnCUj6weEoGPTU/UrYtJ4XIHptS3zIhcHIEkUvAMnXx6z99jdVQko83oB3W0HonLsciGSvKWcDn6HDnbivLOOSCMyArnsi7VWCsCJEpqpIT40hbopf/lJj/zryUFYNbGjnqGCImJ11gasWsG7qiUslUZOj0zrQMzfTp0xgG5OFWADve3Z+VI/NPJAylIfDhsPlL30/VmJqItbULRHqbTGHlXV9haVlWfwZZhUizHilE2TugsPCoP4DA7jWXsifYTC9SRLa+QCpvZTBShQZ+/8/EK/CFGR7hPjw8Yd4out7cZr1dmIP4F7ERfxlAD862Yvq5kSJo9B0x1c4+koaS8PxwzeVB+U7P5M13LYQzaAUYjpuhVyTtHAPAowSgCOuGvoAhGctlfXNL4m2yGIu1r6pnuF7+EvYGxnAajac/BaUq1ZJw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 13:40:45.8022
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1023143-068d-4028-1636-08dd0ee918a4
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR19MB5384
X-BESS-ID: 1732714849-104973-13465-2348-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.59.169
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoZmxmYmQGYGUNQ0xcjM1MLU0C
	g11cLSLDHRwjjRwjzJ0jDRwMLMNDXZXKk2FgAT8Eo1QgAAAA==
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260718 [from 
	cloudscan19-72.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This adds basic support for ring SQEs (with opcode=IORING_OP_URING_CMD).
For now only FUSE_URING_REQ_FETCH is handled to register queue entries.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/Kconfig           |  12 ++
 fs/fuse/Makefile          |   1 +
 fs/fuse/dev.c             |   4 +
 fs/fuse/dev_uring.c       | 318 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h     | 115 +++++++++++++++++
 fs/fuse/fuse_i.h          |   5 +
 fs/fuse/inode.c           |  10 ++
 include/uapi/linux/fuse.h |  67 ++++++++++
 8 files changed, 532 insertions(+)

diff --git a/fs/fuse/Kconfig b/fs/fuse/Kconfig
index 8674dbfbe59dbf79c304c587b08ebba3cfe405be..11f37cefc94b2af5a675c238801560c822b95f1a 100644
--- a/fs/fuse/Kconfig
+++ b/fs/fuse/Kconfig
@@ -63,3 +63,15 @@ config FUSE_PASSTHROUGH
 	  to be performed directly on a backing file.
 
 	  If you want to allow passthrough operations, answer Y.
+
+config FUSE_IO_URING
+	bool "FUSE communication over io-uring"
+	default y
+	depends on FUSE_FS
+	depends on IO_URING
+	help
+	  This allows sending FUSE requests over the IO uring interface and
+          also adds request core affinity.
+
+	  If you want to allow fuse server/client communication through io-uring,
+	  answer Y
diff --git a/fs/fuse/Makefile b/fs/fuse/Makefile
index ce0ff7a9007b94b4ab246b5271f227d126c768e8..fcf16b1c391a9bf11ca9f3a25b137acdb203ac47 100644
--- a/fs/fuse/Makefile
+++ b/fs/fuse/Makefile
@@ -14,5 +14,6 @@ fuse-y := dev.o dir.o file.o inode.o control.o xattr.o acl.o readdir.o ioctl.o
 fuse-y += iomode.o
 fuse-$(CONFIG_FUSE_DAX) += dax.o
 fuse-$(CONFIG_FUSE_PASSTHROUGH) += passthrough.o
+fuse-$(CONFIG_FUSE_IO_URING) += dev_uring.o
 
 virtiofs-y := virtio_fs.o
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 63c3865aebb7811fdf4a5729b2181ee8321421dc..0770373492ae9ee83c4154fede9dcfd7be9fb33d 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -6,6 +6,7 @@
   See the file COPYING.
 */
 
+#include "dev_uring_i.h"
 #include "fuse_i.h"
 #include "fuse_dev_i.h"
 
@@ -2452,6 +2453,9 @@ const struct file_operations fuse_dev_operations = {
 	.fasync		= fuse_dev_fasync,
 	.unlocked_ioctl = fuse_dev_ioctl,
 	.compat_ioctl   = compat_ptr_ioctl,
+#ifdef CONFIG_FUSE_IO_URING
+	.uring_cmd	= fuse_uring_cmd,
+#endif
 };
 EXPORT_SYMBOL_GPL(fuse_dev_operations);
 
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
new file mode 100644
index 0000000000000000000000000000000000000000..af9c5f116ba1dcf6c01d0359d1a06491c92c32f9
--- /dev/null
+++ b/fs/fuse/dev_uring.c
@@ -0,0 +1,318 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * FUSE: Filesystem in Userspace
+ * Copyright (c) 2023-2024 DataDirect Networks.
+ */
+
+#include <linux/fs.h>
+
+#include "fuse_i.h"
+#include "dev_uring_i.h"
+#include "fuse_dev_i.h"
+
+#include <linux/io_uring/cmd.h>
+
+#ifdef CONFIG_FUSE_IO_URING
+static bool __read_mostly enable_uring;
+module_param(enable_uring, bool, 0644);
+MODULE_PARM_DESC(enable_uring,
+		 "Enable uring userspace communication through uring.");
+#endif
+
+bool fuse_uring_enabled(void)
+{
+	return enable_uring;
+}
+
+static int fuse_ring_ent_unset_userspace(struct fuse_ring_ent *ent)
+{
+	struct fuse_ring_queue *queue = ent->queue;
+
+	lockdep_assert_held(&queue->lock);
+
+	if (WARN_ON_ONCE(ent->state != FRRS_USERSPACE))
+		return -EIO;
+
+	ent->state = FRRS_COMMIT;
+	list_move(&ent->list, &queue->ent_commit_queue);
+
+	return 0;
+}
+
+void fuse_uring_destruct(struct fuse_conn *fc)
+{
+	struct fuse_ring *ring = fc->ring;
+	int qid;
+
+	if (!ring)
+		return;
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = ring->queues[qid];
+
+		if (!queue)
+			continue;
+
+		WARN_ON(!list_empty(&queue->ent_avail_queue));
+		WARN_ON(!list_empty(&queue->ent_commit_queue));
+
+		kfree(queue);
+		ring->queues[qid] = NULL;
+	}
+
+	kfree(ring->queues);
+	kfree(ring);
+	fc->ring = NULL;
+}
+
+#define FUSE_URING_IOV_SEGS 2 /* header and payload */
+
+/*
+ * Basic ring setup for this connection based on the provided configuration
+ */
+static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
+{
+	struct fuse_ring *ring = NULL;
+	size_t nr_queues = num_possible_cpus();
+	struct fuse_ring *res = NULL;
+
+	ring = kzalloc(sizeof(*fc->ring) +
+			       nr_queues * sizeof(struct fuse_ring_queue),
+		       GFP_KERNEL_ACCOUNT);
+	if (!ring)
+		return NULL;
+
+	ring->queues = kcalloc(nr_queues, sizeof(struct fuse_ring_queue *),
+			       GFP_KERNEL_ACCOUNT);
+	if (!ring->queues)
+		goto out_err;
+
+	spin_lock(&fc->lock);
+	if (fc->ring) {
+		/* race, another thread created the ring in the mean time */
+		spin_unlock(&fc->lock);
+		res = fc->ring;
+		goto out_err;
+	}
+
+	fc->ring = ring;
+	ring->nr_queues = nr_queues;
+	ring->fc = fc;
+
+	spin_unlock(&fc->lock);
+	return ring;
+
+out_err:
+	if (ring)
+		kfree(ring->queues);
+	kfree(ring);
+	return res;
+}
+
+static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
+						       int qid)
+{
+	struct fuse_conn *fc = ring->fc;
+	struct fuse_ring_queue *queue;
+
+	queue = kzalloc(sizeof(*queue), GFP_KERNEL_ACCOUNT);
+	if (!queue)
+		return ERR_PTR(-ENOMEM);
+	spin_lock(&fc->lock);
+	if (ring->queues[qid]) {
+		spin_unlock(&fc->lock);
+		kfree(queue);
+		return ring->queues[qid];
+	}
+
+	queue->qid = qid;
+	queue->ring = ring;
+	spin_lock_init(&queue->lock);
+
+	INIT_LIST_HEAD(&queue->ent_avail_queue);
+	INIT_LIST_HEAD(&queue->ent_commit_queue);
+
+	WRITE_ONCE(ring->queues[qid], queue);
+	spin_unlock(&fc->lock);
+
+	return queue;
+}
+
+/*
+ * Make a ring entry available for fuse_req assignment
+ */
+static void fuse_uring_ent_avail(struct fuse_ring_ent *ring_ent,
+				 struct fuse_ring_queue *queue)
+{
+	list_move(&ring_ent->list, &queue->ent_avail_queue);
+	ring_ent->state = FRRS_WAIT;
+}
+
+/*
+ * fuse_uring_req_fetch command handling
+ */
+static void _fuse_uring_fetch(struct fuse_ring_ent *ring_ent,
+			      struct io_uring_cmd *cmd,
+			      unsigned int issue_flags)
+{
+	struct fuse_ring_queue *queue = ring_ent->queue;
+
+	spin_lock(&queue->lock);
+	fuse_uring_ent_avail(ring_ent, queue);
+	ring_ent->cmd = cmd;
+	spin_unlock(&queue->lock);
+}
+
+/*
+ * sqe->addr is a ptr to an iovec array, iov[0] has the headers, iov[1]
+ * the payload
+ */
+static int fuse_uring_get_iovec_from_sqe(const struct io_uring_sqe *sqe,
+					 struct iovec iov[FUSE_URING_IOV_SEGS])
+{
+	struct iovec __user *uiov = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	struct iov_iter iter;
+	ssize_t ret;
+
+	if (sqe->len != FUSE_URING_IOV_SEGS)
+		return -EINVAL;
+
+	/*
+	 * Direction for buffer access will actually be READ and WRITE,
+	 * using write for the import should include READ access as well.
+	 */
+	ret = import_iovec(WRITE, uiov, FUSE_URING_IOV_SEGS,
+			   FUSE_URING_IOV_SEGS, &iov, &iter);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int fuse_uring_fetch(struct io_uring_cmd *cmd, unsigned int issue_flags,
+			    struct fuse_conn *fc)
+{
+	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
+	struct fuse_ring *ring = fc->ring;
+	struct fuse_ring_queue *queue;
+	struct fuse_ring_ent *ring_ent;
+	int err;
+	struct iovec iov[FUSE_URING_IOV_SEGS];
+
+	err = fuse_uring_get_iovec_from_sqe(cmd->sqe, iov);
+	if (err) {
+		pr_info_ratelimited("Failed to get iovec from sqe, err=%d\n",
+				    err);
+		return err;
+	}
+
+	err = -ENOMEM;
+	if (!ring) {
+		ring = fuse_uring_create(fc);
+		if (!ring)
+			return err;
+	}
+
+	queue = ring->queues[cmd_req->qid];
+	if (!queue) {
+		queue = fuse_uring_create_queue(ring, cmd_req->qid);
+		if (!queue)
+			return err;
+	}
+
+	/*
+	 * The created queue above does not need to be destructed in
+	 * case of entry errors below, will be done at ring destruction time.
+	 */
+
+	ring_ent = kzalloc(sizeof(*ring_ent), GFP_KERNEL_ACCOUNT);
+	if (ring_ent == NULL)
+		return err;
+
+	INIT_LIST_HEAD(&ring_ent->list);
+
+	ring_ent->queue = queue;
+	ring_ent->cmd = cmd;
+
+	err = -EINVAL;
+	if (iov[0].iov_len < sizeof(struct fuse_uring_req_header)) {
+		pr_info_ratelimited("Invalid header len %zu\n", iov[0].iov_len);
+		goto err;
+	}
+
+	ring_ent->headers = iov[0].iov_base;
+	ring_ent->payload = iov[1].iov_base;
+	ring_ent->max_arg_len = iov[1].iov_len;
+
+	if (ring_ent->max_arg_len <
+	    max_t(size_t, FUSE_MIN_READ_BUFFER, fc->max_write)) {
+		pr_info_ratelimited("Invalid req payload len %zu\n",
+				    ring_ent->max_arg_len);
+		goto err;
+	}
+
+	spin_lock(&queue->lock);
+
+	/*
+	 * FUSE_URING_REQ_FETCH is an initialization exception, needs
+	 * state override
+	 */
+	ring_ent->state = FRRS_USERSPACE;
+	err = fuse_ring_ent_unset_userspace(ring_ent);
+	spin_unlock(&queue->lock);
+	if (WARN_ON_ONCE(err != 0))
+		goto err;
+
+	_fuse_uring_fetch(ring_ent, cmd, issue_flags);
+
+	return 0;
+err:
+	list_del_init(&ring_ent->list);
+	kfree(ring_ent);
+	return err;
+}
+
+/*
+ * Entry function from io_uring to handle the given passthrough command
+ * (op cocde IORING_OP_URING_CMD)
+ */
+int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
+{
+	struct fuse_dev *fud;
+	struct fuse_conn *fc;
+	u32 cmd_op = cmd->cmd_op;
+	int err;
+
+	/* Disabled for now, especially as teardown is not implemented yet */
+	pr_info_ratelimited("fuse-io-uring is not enabled yet\n");
+	return -EOPNOTSUPP;
+
+	if (!enable_uring) {
+		pr_info_ratelimited("fuse-io-uring is disabled\n");
+		return -EOPNOTSUPP;
+	}
+
+	fud = fuse_get_dev(cmd->file);
+	if (!fud) {
+		pr_info_ratelimited("No fuse device found\n");
+		return -ENOTCONN;
+	}
+	fc = fud->fc;
+
+	if (!fc->connected || fc->aborted)
+		return fc->aborted ? -ECONNABORTED : -ENOTCONN;
+
+	switch (cmd_op) {
+	case FUSE_URING_REQ_FETCH:
+		err = fuse_uring_fetch(cmd, issue_flags, fc);
+		if (err) {
+			pr_info_once("fuse_uring_fetch failed err=%d\n", err);
+			return err;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return -EIOCBQUEUED;
+}
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
new file mode 100644
index 0000000000000000000000000000000000000000..75c644cc0b2bb3721b08f8695964815d53f46e92
--- /dev/null
+++ b/fs/fuse/dev_uring_i.h
@@ -0,0 +1,115 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * FUSE: Filesystem in Userspace
+ * Copyright (c) 2023-2024 DataDirect Networks.
+ */
+
+#ifndef _FS_FUSE_DEV_URING_I_H
+#define _FS_FUSE_DEV_URING_I_H
+
+#include "fuse_i.h"
+
+#ifdef CONFIG_FUSE_IO_URING
+
+enum fuse_ring_req_state {
+	FRRS_INVALID = 0,
+
+	/* The ring entry received from userspace and it being processed */
+	FRRS_COMMIT,
+
+	/* The ring entry is waiting for new fuse requests */
+	FRRS_WAIT,
+
+	/* The ring entry is in or on the way to user space */
+	FRRS_USERSPACE,
+};
+
+/** A fuse ring entry, part of the ring queue */
+struct fuse_ring_ent {
+	/* userspace buffer */
+	struct fuse_uring_req_header __user *headers;
+	void *__user *payload;
+
+	/* the ring queue that owns the request */
+	struct fuse_ring_queue *queue;
+
+	struct io_uring_cmd *cmd;
+
+	struct list_head list;
+
+	/* size of payload buffer */
+	size_t max_arg_len;
+
+	/*
+	 * state the request is currently in
+	 * (enum fuse_ring_req_state)
+	 */
+	unsigned int state;
+
+	struct fuse_req *fuse_req;
+};
+
+struct fuse_ring_queue {
+	/*
+	 * back pointer to the main fuse uring structure that holds this
+	 * queue
+	 */
+	struct fuse_ring *ring;
+
+	/* queue id, typically also corresponds to the cpu core */
+	unsigned int qid;
+
+	/*
+	 * queue lock, taken when any value in the queue changes _and_ also
+	 * a ring entry state changes.
+	 */
+	spinlock_t lock;
+
+	/* available ring entries (struct fuse_ring_ent) */
+	struct list_head ent_avail_queue;
+
+	/*
+	 * entries in the process of being committed or in the process
+	 * to be send to userspace
+	 */
+	struct list_head ent_commit_queue;
+};
+
+/**
+ * Describes if uring is for communication and holds alls the data needed
+ * for uring communication
+ */
+struct fuse_ring {
+	/* back pointer */
+	struct fuse_conn *fc;
+
+	/* number of ring queues */
+	size_t nr_queues;
+
+	struct fuse_ring_queue **queues;
+};
+
+bool fuse_uring_enabled(void);
+void fuse_uring_destruct(struct fuse_conn *fc);
+int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
+
+#else /* CONFIG_FUSE_IO_URING */
+
+struct fuse_ring;
+
+static inline void fuse_uring_create(struct fuse_conn *fc)
+{
+}
+
+static inline void fuse_uring_destruct(struct fuse_conn *fc)
+{
+}
+
+static inline bool fuse_uring_enabled(void)
+{
+	return false;
+}
+
+#endif /* CONFIG_FUSE_IO_URING */
+
+#endif /* _FS_FUSE_DEV_URING_I_H */
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index e3748751e231d0991c050b31bdd84db0b8016f9f..a21256ec4c3b4bd7c67eae2d03b68d87dcc8234b 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -914,6 +914,11 @@ struct fuse_conn {
 	/** IDR for backing files ids */
 	struct idr backing_files_map;
 #endif
+
+#ifdef CONFIG_FUSE_IO_URING
+	/**  uring connection information*/
+	struct fuse_ring *ring;
+#endif
 };
 
 /*
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index fd3321e29a3e569bf06be22a5383cf34fd42c051..76267c79e920204175e5713853de8214c5555d46 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -7,6 +7,7 @@
 */
 
 #include "fuse_i.h"
+#include "dev_uring_i.h"
 
 #include <linux/pagemap.h>
 #include <linux/slab.h>
@@ -959,6 +960,8 @@ static void delayed_release(struct rcu_head *p)
 {
 	struct fuse_conn *fc = container_of(p, struct fuse_conn, rcu);
 
+	fuse_uring_destruct(fc);
+
 	put_user_ns(fc->user_ns);
 	fc->release(fc);
 }
@@ -1413,6 +1416,13 @@ void fuse_send_init(struct fuse_mount *fm)
 	if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
 		flags |= FUSE_PASSTHROUGH;
 
+	/*
+	 * This is just an information flag for fuse server. No need to check
+	 * the reply - server is either sending IORING_OP_URING_CMD or not.
+	 */
+	if (fuse_uring_enabled())
+		flags |= FUSE_OVER_IO_URING;
+
 	ia->in.flags = flags;
 	ia->in.flags2 = flags >> 32;
 
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index f1e99458e29e4fdce5273bc3def242342f207ebd..6d39077edf8cde4fa77130efcec16323839a676c 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -220,6 +220,14 @@
  *
  *  7.41
  *  - add FUSE_ALLOW_IDMAP
+ *  7.42
+ *  - Add FUSE_OVER_IO_URING and all other io-uring related flags and data
+ *    structures:
+ *    - fuse_uring_ent_in_out
+ *    - fuse_uring_req_header
+ *    - fuse_uring_cmd_req
+ *    - FUSE_URING_IN_OUT_HEADER_SZ
+ *    - FUSE_URING_OP_IN_OUT_SZ
  */
 
 #ifndef _LINUX_FUSE_H
@@ -425,6 +433,7 @@ struct fuse_file_lock {
  * FUSE_HAS_RESEND: kernel supports resending pending requests, and the high bit
  *		    of the request ID indicates resend requests
  * FUSE_ALLOW_IDMAP: allow creation of idmapped mounts
+ * FUSE_OVER_IO_URING: Indicate that Client supports io-uring
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -471,6 +480,7 @@ struct fuse_file_lock {
 /* Obsolete alias for FUSE_DIRECT_IO_ALLOW_MMAP */
 #define FUSE_DIRECT_IO_RELAX	FUSE_DIRECT_IO_ALLOW_MMAP
 #define FUSE_ALLOW_IDMAP	(1ULL << 40)
+#define FUSE_OVER_IO_URING	(1ULL << 41)
 
 /**
  * CUSE INIT request/reply flags
@@ -1206,4 +1216,61 @@ struct fuse_supp_groups {
 	uint32_t	groups[];
 };
 
+/**
+ * Size of the ring buffer header
+ */
+#define FUSE_URING_IN_OUT_HEADER_SZ 128
+#define FUSE_URING_OP_IN_OUT_SZ 128
+
+struct fuse_uring_ent_in_out {
+	uint64_t flags;
+
+	/* size of use payload buffer */
+	uint32_t payload_sz;
+	uint32_t padding;
+
+	uint8_t reserved[30];
+};
+
+/**
+ * This structure mapped onto the
+ */
+struct fuse_uring_req_header {
+	/* struct fuse_in / struct fuse_out */
+	char in_out[FUSE_URING_IN_OUT_HEADER_SZ];
+
+	/* per op code structs */
+	char op_in[FUSE_URING_OP_IN_OUT_SZ];
+
+	/* struct fuse_ring_in_out */
+	char ring_ent_in_out[sizeof(struct fuse_uring_ent_in_out)];
+};
+
+/**
+ * sqe commands to the kernel
+ */
+enum fuse_uring_cmd {
+	FUSE_URING_REQ_INVALID = 0,
+
+	/* submit sqe to kernel to get a request */
+	FUSE_URING_REQ_FETCH = 1,
+
+	/* commit result and fetch next request */
+	FUSE_URING_REQ_COMMIT_AND_FETCH = 2,
+};
+
+/**
+ * In the 80B command area of the SQE.
+ */
+struct fuse_uring_cmd_req {
+	uint64_t flags;
+
+	/* entry identifier */
+	uint64_t commit_id;
+
+	/* queue the command is for (queue index) */
+	uint16_t qid;
+	uint8_t padding[6];
+};
+
 #endif /* _LINUX_FUSE_H */

-- 
2.43.0


