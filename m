Return-Path: <io-uring+bounces-4955-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A8C019D56A0
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 01:17:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 685DD282E33
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 00:17:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D6EA5223;
	Fri, 22 Nov 2024 00:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="m9Vic+pI"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0425661
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 00:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732234616; cv=fail; b=rt5V20T2dD3E90rmB+fYY5HeNBxp6qGwsVVEy8bTKiJ4tHSafTdKXpGi/sFtBlfL74B7jz2EWVy45Pd/6wyuYho/QPFOLiqmP6G5yP3nf0JWDxmKzNl0ErpVgnFkwHafQ2T+9iONyzi7qPps4pSJ0Y4iCpKsYu7JnLOt/xx7L2A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732234616; c=relaxed/simple;
	bh=wFhm78xifGsHJGTcPsAEgLJbclAp6ONom1hnh4n4ZrY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=szDSKfJE6RrC/nMY6wA8dk4VenE9yvqWLD03q8wZFJM8+hSTMVr0W/NEzRcWukiHsgWWTmrHTC2sB00TJB+Ifc82+W42jRS2gu0EiSzmE+ioDgteEsp8GNIjLiVS9SyQ/aztgX63U6TGZM0HfP20JSr8Br8k2t40ALOe6WWKWgM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=m9Vic+pI; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40]) by mx-outbound47-71.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 22 Nov 2024 00:16:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rehRA671jj3crVULfIPkC9JqA+OSaJg4q/Jvv7kM7zgoQXV+ajUJVyAO9bY+IPndeOrdVw/ZJDr6lKfxV93VYIBG2IFYQiV6TxoppuNRISKvaD7Tc116iCz8ZknAR4pFvNnsuPa3isi2trGQlk9NyHJzV2Efb5lvs676CV9hAlXCBwks77cI2YJ7ti2LEwDLB4MrMQe8cWyMcOmcVpTXdD3Mq1TmmGv2UpgDXnZvaw4ko8dLXRMB+cVbkREWtRK/fgZmFKZ3M3QStOCbd+BIFTnCyfdv7koqvHVTahN5Re3BgbC1F0obhrE00O/6EgxdQ14c+Wm+UdgBvZJkIddeOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=07wxmk+cK13LRNaYc1CIxXnkiT+Ze2z+1SUsQA8ZH68=;
 b=ILFKtPd17PUXUfuYUB2TrbFwy8gQ3+kgEEMcjjOBwVhZCCyRXk+3azjMDUhYNn7RuC3zK54ZbHK5xPDoqwu6s9rd3zyVBv8a8TvOlpgz8wOasTlj127s5ONwN3PZS8nc7wVRFM2Zlg6SUYAXdV90eCEbhYiii56rldHt6RHdLBAuitNNc3pzmI+quXyVxbaaGUYXXsbgcRrNOqc8+kpM0dfsF/FRFtH5sajmny7HxesmcEw0ayXzwX1WrZeAUZxOl70w2UXkDUTLO/ltlvrNDHOuD1hcsxn2MXqBR8ujBj/HLpXLvjIqIyDQtaWnGx8Zci3ZlbCaCdUCBsjpywh/Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=07wxmk+cK13LRNaYc1CIxXnkiT+Ze2z+1SUsQA8ZH68=;
 b=m9Vic+pIxcyvWnclMZjmOyCcdPRP7QbZX7px3AxcdyQZvTcmy7GbYvkqVmq8N532fTeGfqbEZvboN40OCzsvBRiQwSl4ORa3JVW3AZW6I2FxWZ4OzkooLeqgQlXQT6YnXs/bGn2b1fiksk3ZfZtt5XhpH3F4BDIWRrh+MbrkKlA=
Received: from MW4PR04CA0176.namprd04.prod.outlook.com (2603:10b6:303:85::31)
 by BY5PR19MB3956.namprd19.prod.outlook.com (2603:10b6:a03:22c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.27; Thu, 21 Nov
 2024 23:43:53 +0000
Received: from SJ5PEPF000001D2.namprd05.prod.outlook.com
 (2603:10b6:303:85:cafe::c7) by MW4PR04CA0176.outlook.office365.com
 (2603:10b6:303:85::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.16 via Frontend
 Transport; Thu, 21 Nov 2024 23:43:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SJ5PEPF000001D2.mail.protection.outlook.com (10.167.242.54) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8182.16
 via Frontend Transport; Thu, 21 Nov 2024 23:43:52 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id E4ADB2D;
	Thu, 21 Nov 2024 23:43:51 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Fri, 22 Nov 2024 00:43:18 +0100
Subject: [PATCH RFC v6 02/16] fuse: Move fuse_get_dev to header file
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241122-fuse-uring-for-6-10-rfc4-v6-2-28e6cdd0e914@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732232629; l=1579;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=wFhm78xifGsHJGTcPsAEgLJbclAp6ONom1hnh4n4ZrY=;
 b=Gp+HMW97ZkmO2L+kypCqE181j7rO1F5aJVjwrYcXEbOHuZaP5U15+2rWyxHWBgpqPzEm1VrCj
 d5AP8aCwrv9DdUoVX7EWyhAKoGxSdeNwMcQqqLJzjnSOIvl76dFDJ6n
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D2:EE_|BY5PR19MB3956:EE_
X-MS-Office365-Filtering-Correlation-Id: ad81115e-ab08-4b14-f7b4-08dd0a865b66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?cjJ1ZnVtZEdPWGFNRWpNcDIvZnU5MGZRNVJRS2FSRDF5bnp3SC9lWWdGNlB6?=
 =?utf-8?B?dmhXbDM3Snl3Sm5YZ1ptSU5lRlpOYlo0dUhvZW53c0RkKzNPbzVrZCs0TXh1?=
 =?utf-8?B?dmorQnFEZGcxY0ZodCt4SXRQT08rMC9MMW1kRHRZdzZCQTVTTWNyVlJRVmlC?=
 =?utf-8?B?SjNjWGtMTElFL2kzSHM1NE1uQkdEV09MTEtzMEFNSUFWWjAyVDVGQmRWL3po?=
 =?utf-8?B?UDhQTm1VbTFUVUxPN0RDOEl0bmhNQjFueTZuTVYxL0dBa1grQmNodEc0Y1Rp?=
 =?utf-8?B?N0s1QjIra1ZGQWVSZDdzUmk2Wm1zRzZlMHZPSkVoenBFVk1KQmZnVStaYUxz?=
 =?utf-8?B?bDdZbkdMMGcreUNRdVptdVhKRk91SXNocnUxTlVKQmNkdlpCQ0pRQitTdjNV?=
 =?utf-8?B?d20zTlZtRjVTTFhYRkFMZHhZc3pJVy9GNGo1MDZ1Tk0xNm94U0lXaUZKOVl3?=
 =?utf-8?B?TFNCVWtRVThjbWRaR2RKMHhBd2l2TFNVTnJjOU5pZDZkVlY5YUZxTlRid25B?=
 =?utf-8?B?cG1kblpiblVQeVpSRUdFcGZWUXpyRk15ck9TOFk4ZlhRaUpMMVoxKzFSVnBR?=
 =?utf-8?B?WURXSGgyWmRxaHJla1V6TTNGVnJxOGJIaUc2MUQ1Q1hwOE1oaDV5UGhRYnlV?=
 =?utf-8?B?VXU3Sjl3OGEwTC9WVkpQR1RHSDlBK0Qwc2xzdjhGMUJBVVVkamE5Q0JDeXVL?=
 =?utf-8?B?RUpNZzhmK21XakpGZ1RpVzZFbWZ5bFRINkFkczNyT1VaVVh4bGMyRnRaQXVO?=
 =?utf-8?B?L0EyQkloSjFTY2h2c1FmRkZKOXB2TzZ2SlNoZHZla1VmZ0FUYmkyZXExVlU0?=
 =?utf-8?B?Z2lBMnJGU0k3cUhsUXpadTZsK29JM051Wmk1OU92ZElRM1M0eEQ0Y2htb1d1?=
 =?utf-8?B?UWZML2N0YUpKYzhJVVJWMXRBKzZDZHJJRUYrMnIrNnNUZWxyb2xHaEZ1YWZW?=
 =?utf-8?B?SmduR0J3MWlSbW5PSDBMYko4akNzYUdON0FiN1hBaDQ2TEdNWTJHRGwxbEI2?=
 =?utf-8?B?TkVnNXdON21jdGxhdDRGTXl0YjJ3QUYvLzNaWkU0Ykl2VFZtaFFWdlpEOENY?=
 =?utf-8?B?VWdIY2prZi9xdTdEVWxKU2pySU1ub2ZxYXNOcVFualNmWW9ZNTBrOFp3R1VO?=
 =?utf-8?B?RmUraHRMV2Ftd3Q0MUdGMFJubUE4UzFaUXFuT2lWVk12aGVLN3VaM0NsYi9o?=
 =?utf-8?B?cTRWRW9xWVlCMm5kTkVtbWp1Szh6b20veFdUMlhyaWxjeUpuaVprNThHYmJr?=
 =?utf-8?B?dUhTQk5KdTFPNm5sYTErcW96VmpPYUF2RTI2QXpBOTZSQ0h1NG1TaXFOMlo1?=
 =?utf-8?B?dDIySWtNclFlRHBRTFdBUzZnUlZjVUxTM2lMakxBZ1hJZnUxTVE5YW1qdkZJ?=
 =?utf-8?B?WTRrZlQ3SWdTdDF3V1lBQmthcXkwanMwbmpsZUZrL0o0MXBhTjJOTkZQTElP?=
 =?utf-8?B?Yi95NHVSa3JyQXhlbUtMTVRoWXFmN1c3NE83U0MrK1ZQdkNOTWtMTFB4WWJh?=
 =?utf-8?B?Rm50WjVUTWsxc0UyMVVoQll3T1JYeWVpSWp5eFhzR1c0NEVmakV0Q1FLODNS?=
 =?utf-8?B?TFBuZlgzdXVGeDZxK2VUb28wR0dDbFhDWjZOUllqTkNsYXlBcm8zK2ZjczhE?=
 =?utf-8?B?dVI1aExzRUFFYmFmYjB3NW50RHdoblFGUk9YMjl1UXFJYjkwdWhXSDRtQUJM?=
 =?utf-8?B?bmRDMVJ6YzBHeHZ4SFczQnd2bFEzTEVraTV4K3Nmelc4MmxwRXVZcEpqaTUy?=
 =?utf-8?B?dW9MdklRU3dQNmRhNVJnWGZhdDEyUWw0SDZVOHE4andRVXpOS1d6RnZqNTRV?=
 =?utf-8?B?QkZMTVVGanNDQkprQTl0bUQvRG5mNkZ6MGxNdG91WTNjd3g2NElsZjkwYnVz?=
 =?utf-8?B?TGl4NVhmSUtRRU82Szd0ZmFsNlZhY1V2VEt3L2ZKTjRxcWc9PQ==?=
X-Forefront-Antispam-Report:
 CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 D7mMqs+jVAZi0cCOQX4KPm1MzMGq1pMbycfyrDEE2xPI8tOli34s3cN6iyTGydOA2rwsz5dkgTlerugjUSh/8W+BKBUIdZFTjxomlpZSVPJBv18KqnDxgQ8XwwDkJ9//0sdF8NDjt7M94y/M6rBKcqRbS5lF8bZETl5bb9SzeP262CCLv8m5bs/SL5W9DpfNZslSY6ZR+WtZm/5NDkzuSXERSgm+UaVJh9qWAusC05YWIWzXql6/zj7TTJqgTWhzrhKHTqY5v+hXf7zNhoIGh4d/ylwwkcSwQxd0ZyC7i/G0H2L7cm4iZiwJkka33PycnlYvM8672j51xU8y+IdQ/t3hwy8FjsPDLXhRJp64Q0kxGHCu/PIqQ8lvW+Ll8ufG0JLbuJMmCbJl/Zh5HqyGPqTnpoc0aOH+bWdsUpJo5cPToIkV6QVSjmcuuUDdM3TMUfXWw0gXWzwlfZebPgvAI6plRNnE38OmuiSUB882WCYXgr0e3hx3lAh/2XrGfd133LTwOBoGrY7+6mA+/tvfsjkZ1fUgmF1pRvXak0aSqBBgUIIZemOlt7VnYLce22uGTH3ESDkSrgdcYmRpZ1i9EfElSMLR5DJGHKebjOcHjuX/fcU/WRDZu4heYEqAjDT5w1mnydNLzSprXsMU25pSVA==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 23:43:52.8879
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad81115e-ab08-4b14-f7b4-08dd0a865b66
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
 SJ5PEPF000001D2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR19MB3956
X-OriginatorOrg: ddn.com
X-BESS-ID: 1732234612-112103-13741-60793-1
X-BESS-VER: 2019.1_20241121.1615
X-BESS-Apparent-Source-IP: 104.47.73.40
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoamRuZAVgZQ0DLFxMzUINXExM
	LIJCnNMiXJyDApxdI8NTXZINk41ThZqTYWAFd7jrdBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260588 [from 
	cloudscan22-111.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Another preparation patch, as this function will be needed by
fuse/dev.c and fuse/dev_uring.c.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/fuse/dev.c        | 9 ---------
 fs/fuse/fuse_dev_i.h | 9 +++++++++
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 09b73044a9b6748767d2479dda0a09a97b8b4c0f..649513b55906d2aef99f79a942c2c63113796b5a 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -35,15 +35,6 @@ MODULE_ALIAS("devname:fuse");
 
 static struct kmem_cache *fuse_req_cachep;
 
-static struct fuse_dev *fuse_get_dev(struct file *file)
-{
-	/*
-	 * Lockless access is OK, because file->private data is set
-	 * once during mount and is valid until the file is released.
-	 */
-	return READ_ONCE(file->private_data);
-}
-
 static void fuse_request_init(struct fuse_mount *fm, struct fuse_req *req)
 {
 	INIT_LIST_HEAD(&req->list);
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 5a1b8a2775d84274abee46eabb3000345b2d9da0..b38e67b3f889f3fa08f7279e3309cde908527146 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -8,6 +8,15 @@
 
 #include <linux/types.h>
 
+static inline struct fuse_dev *fuse_get_dev(struct file *file)
+{
+	/*
+	 * Lockless access is OK, because file->private data is set
+	 * once during mount and is valid until the file is released.
+	 */
+	return READ_ONCE(file->private_data);
+}
+
 void fuse_dev_end_requests(struct list_head *head);
 
 #endif

-- 
2.43.0


