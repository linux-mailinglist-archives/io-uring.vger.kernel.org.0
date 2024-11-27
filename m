Return-Path: <io-uring+bounces-5079-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65CF59DA8C7
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 14:42:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27583282A18
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 13:42:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7211D1FE453;
	Wed, 27 Nov 2024 13:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="azuh3GJN"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09161FDE06;
	Wed, 27 Nov 2024 13:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732714867; cv=fail; b=j50zC0R4wwIlpY1WnaN6kbndBiMWZdcQMmCDMOMQMYOi4BjuaV1l10UmfqFmVSQYVURS2uWGkbXt6bMnb11qFm55T5dGNJ3dSZZLIgwk8CPfPqffPs51u+FTICcpKxqn3W8H1hMAWrmsRD/bkpVGgXph7tWfMQliAXJQPFTrORk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732714867; c=relaxed/simple;
	bh=XFkl+WqqLAjH6uZixQ2rg5NnynNvDs2uyYFQqVLociU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=feOQsxZ/m/5H7CjhDdraMamWjdquiKcBUzagwdqkOKxoPMzHvdwpL24uF1yE8WU2lXKUXlBdTVE8FEl8Mr35MQqEt14/jDtuUI9MAx7LES0JSmUzpxdPse3XvXk6XSwi22SpQxRHNfTkYQQxaSqF5OGwYnTiP5hA/tLSKUA/JzY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=azuh3GJN; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2043.outbound.protection.outlook.com [104.47.70.43]) by mx-outbound-ea15-210.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 27 Nov 2024 13:40:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u1ZP5SLd4wYtt7gmBUp30KIkeqfOMovMnUWR5y15c5hjq3KtKmCBorSEoPf9GoCTlFLc9aXivGplTOq8LKfmXCiQKk0ox9MVy+n9FXhzo/tn+ENIYVDOiyOxyWn1Zf/2zBpvJ5ju0/Gt+A+TxqtuKXQetpeudvFFQ3crmdu7gnBuzVQoN+PpPHs9rrNlI1aOWrkncSALaPBxjvC0ux96uZ4/XDwWLYtk80su4UvgmbMTSvQ9RaiZUuPcNAaLgo1AqFONwY1MmCiIGMxcYsyd+RfAGe1TMMOFi0SHqOuB0phmM0Qy87pA/qLRQXwQTNR9pkyPrM43/8J6JrtcOkVlWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b4VLP1XaRYFNFwbgS1qN7TjUIiDTirnRrvGk/dJeL6s=;
 b=QMZCD+UoBUAiH5h9XLILR3N7sXoUP4flxsTxOC3+uKnKar/9sk/CeZ9o4sJNUIoe7mN7pGEyajGR6So1/OycUYb+BRuyJFIXoGAYDtXnEAHdvgqXW7Ed16VcgM/gdTjXnoBydWSVVgXvpas+L2jPDkjow++D4gsQAYBzYQhPSXqnj05hJbf3s9wqr+5gSM1YoB3Wu75HJIg1Tr59A8GWIjMJbZ+gzSyWwclPnup4t/rvVKwtFbK+YN8m/gNq2nFC0V+bbK2V/vAeBOEXJlk3m/aWLbuhMkUyrSU4BfFnqjBhvuKfnCxhjfFeml614AfBNZB64MDpnA0eerG+eswnCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b4VLP1XaRYFNFwbgS1qN7TjUIiDTirnRrvGk/dJeL6s=;
 b=azuh3GJNGshEw4uPL0M04JV1dDbFaBMC/AQREytGLphcNBoHBN5JQPG3zD1e0ZI/peiBtFTVllDVcy+jiImGSr6UEOWFLuicolse44+nHzWvAb7WpXe3esNkLzZbFsd6Z2QqAjJPX896dLsy2sc01nJwcS0lqm8v2hTSvVYCoEY=
Received: from MN2PR18CA0010.namprd18.prod.outlook.com (2603:10b6:208:23c::15)
 by CO6PR19MB5404.namprd19.prod.outlook.com (2603:10b6:303:14b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.19; Wed, 27 Nov
 2024 13:40:56 +0000
Received: from BN2PEPF00004FC0.namprd04.prod.outlook.com
 (2603:10b6:208:23c:cafe::39) by MN2PR18CA0010.outlook.office365.com
 (2603:10b6:208:23c::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.13 via Frontend Transport; Wed,
 27 Nov 2024 13:40:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BN2PEPF00004FC0.mail.protection.outlook.com (10.167.243.186) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.12
 via Frontend Transport; Wed, 27 Nov 2024 13:40:56 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id D268E32;
	Wed, 27 Nov 2024 13:40:54 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 27 Nov 2024 14:40:33 +0100
Subject: [PATCH RFC v7 16/16] fuse: enable fuse-over-io-uring
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241127-fuse-uring-for-6-10-rfc4-v7-16-934b3a69baca@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732714838; l=792;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=XFkl+WqqLAjH6uZixQ2rg5NnynNvDs2uyYFQqVLociU=;
 b=s2XOCt1BmL9fC9ZzO1CL+uPFRZqtCFmjugLG5zxAzmiEoSr6ihs8aXhX37+ExQdTIHFiSyYsA
 8Zo5t9FORoJD5em4IFRmnIgAhiVFNQE728rXGRWRTkAwHBNqUzKtVGP
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FC0:EE_|CO6PR19MB5404:EE_
X-MS-Office365-Filtering-Correlation-Id: 84763ebc-f8c4-49f2-114d-08dd0ee91eb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R0ZJTURNdXcvdmVHMGtIS0Y4MzNueU9vQm5KaGdIMGsreEk3cmdzMk83Y3Iy?=
 =?utf-8?B?SG9nQWNlWnJmMXlXcnJBaWcvT2V0UWZJYmlqS3ZCRk9VOFVta2Y4a0xYVlpj?=
 =?utf-8?B?emNUUjdldy9KMDVEYXJuNFBvY1RFRmFvYkkrajljYWVOeGFLQXVXWU8rcFZ2?=
 =?utf-8?B?b3NucWRSNUxwa3REeVRhTHVYb1FjQWlqNnpmcGN5c2thRUNOc0Y2OGlMdzVN?=
 =?utf-8?B?NHd6TGdDTVNPNitZTmpwQTQ5RUJhcVhaeWkrYytRVFZsRVNnR0U3TTFBZnI4?=
 =?utf-8?B?b2FpREJnM1k2Mm5QQW1UQlBNbk9ENCs0elFUSUs1MTg2OFhXMXBVZTVzTFBK?=
 =?utf-8?B?M1RmaEpEM09LeE42dzhicW5heklWZXE1TE9GaGVSZHVrQWUvTVhRWitmVWcz?=
 =?utf-8?B?YXFKMlVlZ2UzemJhQ0Q3STVPRWNHNEJHWkE4N0QxRy9NaUtiQ1JLVEs5Tmc1?=
 =?utf-8?B?QUEyaGRqSGJmWm13L0hZVjRUS2dYTjl1MW5YZnA4Y21HaHZXb2NkbEVCd1NI?=
 =?utf-8?B?a1RrRzl1d1AyKzdtdDdQNTBheW5wWlRQOXFwT2dkTFJ5YmczVXRpc0lzeXNW?=
 =?utf-8?B?UEJMdkJKVHB0UG1XK1NBaS9nN2dPRHF0STY3bTFPRjJiaEE0MHNtOWNqWVhU?=
 =?utf-8?B?amJEU1JMWGpvdkFiaGt5bkkzTm5KL2Q4ck1zYVZMK2F6R2RSY2dqVEs4M0JN?=
 =?utf-8?B?NEp5UTlxblVpME1pWHNOQ3BCbStPdkc0REFVMGo4UHpvT1BZS2lYaG1Yb3kw?=
 =?utf-8?B?S3h1YWJobllhdUZUZEJCUHUvdnMrL24wREhSYnZOVFFLMVhSV2NUZ2w3UFJz?=
 =?utf-8?B?UGJNWUtvMmNPK3UrNzJHd3ZkQWxobFhwc1U0NUUzVjhLd01paEtWcWRZc0M3?=
 =?utf-8?B?SVJzZHl1cXZxQ3VuWWF5WlVZcXdxZWxMek5CK0lCVFNtK0kvUDFWME13OElt?=
 =?utf-8?B?WWJIcjFrSlQxVkp1UkRSQkphRFUzT0JiZWU2ZVIxb0pVUHpmcGtvbTdVM2RY?=
 =?utf-8?B?YzAzY2huOGk5emplSVkxZVN3RTFkUG0rWTR5M2ZRN0ltaXhMdHhieVR0V0Nh?=
 =?utf-8?B?c04weGxWRnJtaGFQRjl0cHlkZWFWMWlOcDFRYVFUK3gvOWs2QnpRQkpFK2Zz?=
 =?utf-8?B?RmNYQ2dqTWUzSjFsRGdTYlNHYUg4YkxOeTlwVHl3UFg0dlJHOFNtTXBlTnVT?=
 =?utf-8?B?SHpLUDdNcnZvWEVMU3dFblQ3bG5GTUJxcUlkZktpUW1KQlNZVVRyTXBja3dv?=
 =?utf-8?B?TDRGQ280Mk9WVk9qRlo5OHFzeGJEYnJYRVI3V0VQRGRWQ0NGNTRlR3V6Rlhx?=
 =?utf-8?B?SkRkRFZQdWFQaVpHTW00Z3ZVZVV3eThNVTBYeUhIc1ZoK2NxMGxaNTdnaU9B?=
 =?utf-8?B?dTlrLzhpYzQxdUNadXY5RFFaREh3Y1gxTFdtNUt4dEI2c2hzMG5ROFBYbHk5?=
 =?utf-8?B?QXpjT2FDRU8yTUtWenFmKzg1UHJqL3AvZmZpR0RKUlIvQXRqY2Uxd05PWlI2?=
 =?utf-8?B?RkNJQjJBbTYxQTBOcTB5dGpUZ25YWEdxREhHUmYwaXJSeCtrWHlrR3UzT3lC?=
 =?utf-8?B?TWtzcmhPeDRjdDN6NFNmM2lUZFRmeEo1WXp1YUw0ZnBaQWh2eUpmMFBWaWlv?=
 =?utf-8?B?MmZ6cEFyaXlxTjdsekd0VmFsN1kvZk9DQVQ5S3NZd2ZYVTk1d2tQTmRDdlN5?=
 =?utf-8?B?RU1SNlpNUWEzY0RxeGtHcm5ET1hUaDcxZG5jQ0tOa3FVQ29NK1QybExxZjYy?=
 =?utf-8?B?MW1lWEVzRGR4aVA0NGxrT2ppVVB3R2NTNC9VRFJ0MW1EVTNWdmI0MHZCUUR0?=
 =?utf-8?B?RXN1L2t5Q3dqT1EzMm1jWFhoOFNWRHBOeCtvVFI5VEVWUTJJak5DOGRuSnJC?=
 =?utf-8?B?clEyVWFNQkp1MVUveVpMaTI5c3FYdm1jOEl2bUZRaTlDa0hSLzVDck5idzFZ?=
 =?utf-8?Q?s3+1ve5ZSg85c6I46iqW1hjo9Yi6hWJD?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Mw1rF3RJaQ6EQ62X6F4f/QIy0MI2oKhdEWhHPQKgRAzM1EK094chgIzRSginsFRQu+GYbsKxMVrCIzmjQdT6xhxHtPv1r0+6+6P3xqXQvj0ts4XMgGpLUe+s1TfahhlWPMqaNgT5XQ6fJ++Dgq053DXcdXZWtReNA0OwERkeBlNTVgnoGuuYkm5ZiWdrMl06J3mV8LQocPd+sIMfhdz+7noz4EGXYD/hsfmrGaOLsVdlOz+SmVJlSy+dtQJFAoZS2lXWBNeyLxvrmOGmiyj2oIy1g36b7CPkhjFYnkCSizivLYBg1dbDnr+9q8NtoM+YYLWJ32KvyXzGPQk4v7rMjWcfO/xKOp2+yOviQOIU1voVxFclOwlFz/0eSlLTTV51/4yjFCifHwF9l2OGKF0/k/PPoVpYLBNovUTHZODe5bZ62ZexOvzmMEa4j6ugsNgteHiiwT2J+kI7eYGAEGf7vcTlqw4DPz/X9zywnbcqBshYqVuqsJBrSpt/s3bhdvO0K59c3jHLsZp1QZYGXlNyljTiKi3KQni07dumBcmjdE7fLUehjVNimk8mKFT7ryG6RvDQjEyquyJSE1dQW6lXCRAF/ysemO6h9k84cEB6rdJEaCO1B2+8eqEPOeYuvRlHHovubibJ3H9Fbnqr4BzqtA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 13:40:56.0292
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84763ebc-f8c4-49f2-114d-08dd0ee91eb3
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FC0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR19MB5404
X-BESS-ID: 1732714858-104050-2072-13680-1
X-BESS-VER: 2019.3_20241126.2120
X-BESS-Apparent-Source-IP: 104.47.70.43
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVuZmFkBGBlDMyDLJ3DjF1DzJ0i
	QxyTw1zdI8NTE5OdEs0cw00SzNNEWpNhYAW8SOqUAAAAA=
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260718 [from 
	cloudscan19-166.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

All required parts are handled now, fuse-io-uring can
be enabled.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev_uring.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index fe24e31bbfecec526f88bc5b82b0aa132357c1cc..0039be997ededd29b094d84001958de3de91fe5a 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -1060,9 +1060,6 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	u32 cmd_op = cmd->cmd_op;
 	int err;
 
-	/* Disabled for now, especially as teardown is not implemented yet */
-	pr_info_ratelimited("fuse-io-uring is not enabled yet\n");
-	return -EOPNOTSUPP;
 
 	if (!enable_uring) {
 		pr_info_ratelimited("fuse-io-uring is disabled\n");

-- 
2.43.0


