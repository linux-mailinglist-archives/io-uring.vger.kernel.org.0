Return-Path: <io-uring+bounces-4538-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AB5E9C0C77
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 18:09:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A96A284574
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 17:09:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D48922170CC;
	Thu,  7 Nov 2024 17:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="rnVQ75rQ"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB93216A00;
	Thu,  7 Nov 2024 17:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730999079; cv=fail; b=RDfsG7EiymGhvGMiJX8S/VtMVUmT08vjBOu3l1NmPcPBlpq69Aunaitc24GssyHwaifmnrJ/9JJNG9Ey4as1hslnISXKytO1nPnyZMA1r5le7A8mS6B9qLuRjJghpwL2VCRaNKzj3Q7tAAf4R8oP+yvKe+FRYu9EYdBn0AXtGe4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730999079; c=relaxed/simple;
	bh=ikGif04sjep7rEQpVSE2ac++O9XaMsyCGtY4Tkd2gKQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Moglyyw7PhIDzGw2OTldUOWOMUA0nQHYysUIW7n/NV4HCsFN5tC2H2XXzqOUAgtjQwZLkk5IWNzvRcNOAG+vxlyAGLn9l0U6m1TkkjYMABvai9thd/sj/tQwS0IDBMj9pSftaZnnGlLyxhrc+5f2CBnkoHKxKvOSwBxQIC4/hsM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=rnVQ75rQ; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2043.outbound.protection.outlook.com [104.47.57.43]) by mx-outbound19-226.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 07 Nov 2024 17:04:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BZ6l3VCk8cHszcGeoiriMmYMm0DFSBMITnflnyfo2+LYfd9HUs/R6Q00E+2A1xN6r6s3nbt0ii+sT+bl+6yabQs3WIc/4XzgTrV461pROgzH4zoO/kD9QvtNvkC6jfBGXNyzOx/0R5Z8abJpC8zdIImsd8lGErYaI1PeY1xIMw7FGX0ZePOIYvtYqM10Gz0XEsmFpyUrFyZsGjIC/svmHSpG2AvT1Z7qmA7lhCy+a1/Fa8U5/aLXbNxMmkM8V+yxtdhVvPs1ZNZ5XXjQ+ls9RezOw6K6wdftqt/co4wbmAiknnqp96AKCz4/R9ztl6h6LWq122ZuebA2LXctUYBjQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dlTPtALK3niaLVj2kv4g4nP435uSf0fpIWA5KQAMXQ0=;
 b=uJO3G9S9o627w9v0CEMi+e3n7iSBO1CoY8SKzl6k0CV1RuU4q7XWZt9f/hz/pFiz+fj7sLywgz2i2X0DJV35OD9/7qGpNyMPwr06+lqI+QM+s8tyukMpIxLqHkeczhAii2chlYuTD2+TP8ib2ocvWY6fkECNUV905Etls3wPT0ujtdzMM+mBWM5xtQHmwiJ3wKfRM5u/v6L5LjG1U11mJlKjFY1EtR6LhKwjhnGAoaDUwipIXF/RrKvWZlltIZ40abB/kRDa062anOjgquu+Sw/hpDu+9Njt+pi0ZnXVQu67IgdusjQk01gL1z5QUAEfuSeQ3GQKAadQo6HS46bcZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dlTPtALK3niaLVj2kv4g4nP435uSf0fpIWA5KQAMXQ0=;
 b=rnVQ75rQIliOpLwg2r19vO6n6ZA1WYiJL1A7gVlEBLUGNopVsScBfsdksfHaDfPTGdHI0//M9PQT0J30VN1pNBtRFA4UrIXeCTKjOzQFSwDI4JHvisqw63fz6dQZ6iNimaVFF7/ndPRtFhwF7sXh1KC8NHUDd5XnKSQFSmHWU18=
Received: from SJ0PR13CA0152.namprd13.prod.outlook.com (2603:10b6:a03:2c7::7)
 by LV3PR19MB8703.namprd19.prod.outlook.com (2603:10b6:408:26e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Thu, 7 Nov
 2024 17:04:19 +0000
Received: from CO1PEPF000044EE.namprd05.prod.outlook.com
 (2603:10b6:a03:2c7:cafe::81) by SJ0PR13CA0152.outlook.office365.com
 (2603:10b6:a03:2c7::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.10 via Frontend
 Transport; Thu, 7 Nov 2024 17:04:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CO1PEPF000044EE.mail.protection.outlook.com (10.167.241.68) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8137.17
 via Frontend Transport; Thu, 7 Nov 2024 17:04:18 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 1B47D7D;
	Thu,  7 Nov 2024 17:04:17 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 07 Nov 2024 18:03:52 +0100
Subject: [PATCH RFC v5 08/16] fuse: Add fuse-io-uring handling into
 fuse_copy
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-fuse-uring-for-6-10-rfc4-v5-8-e8660a991499@ddn.com>
References: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com>
In-Reply-To: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730999049; l=1731;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=ikGif04sjep7rEQpVSE2ac++O9XaMsyCGtY4Tkd2gKQ=;
 b=YUMvQYM7HsqSUNxBxsK3bpnaL3UEuzVyKv9wJeOzyr17zsxSPjGlSxKvRrK1qyMTWeAqky9DX
 8tiNC6skGlEAMOHvjV3uweMR5nq+NVOij/wSXYBBeWnBwiwqkJBYDuk
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044EE:EE_|LV3PR19MB8703:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ba1a087-ec80-43ed-4952-08dcff4e37dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T3pkZS9lazBqQ3VWVVBtSlVUQjY4bDJuMmkyakN3K01wMVRJSk00bEIrZTdz?=
 =?utf-8?B?a2RxaEJtSDg5cWw4L3k0V3BrUFZkcktRM09PQ3BYekV2ajZBRk9YaHBmU3Zt?=
 =?utf-8?B?dk9GOTlwVGpTWDB6ZGdKUWZlOGVCb2pwMmJybmpWOVdYV2xWQ2ZVMURmVWNh?=
 =?utf-8?B?TUZ2RU5aSmVXZmVaT1htVXNUSFZHYXFhZVNYNzhUcGhxZlU4VU9xKzc2RTM4?=
 =?utf-8?B?NlNMRzUzaFBFTnVPbXFwWmxwaVpKRnlDa25FeUxTWkpzQ2NVOEdmR2x2aDFp?=
 =?utf-8?B?bGZiZllYODV3WFNVemhXVFlUclJkc01ONWtDMzNmeUZvMllveHRuSjRZcUNn?=
 =?utf-8?B?L3hkVnpFSWNSMkN6Z0ZSWmFmb1JUSWhFQzlGd1BlYTltVFQwUUtzWFlWUE1J?=
 =?utf-8?B?aHptV2w5YklPQlFFTjNZRDJtWmZJLzNHejA2MFVyclpaVElqKzlQaTNVQWtT?=
 =?utf-8?B?UC9vdTcwZmF0RHdZY25UVldHa050NXVqS01aYlNZNW00MEZPNy9vZkRzTk8r?=
 =?utf-8?B?eVRDL3ZOSGREcjFXdWE3RGJ6a0VOSnRqOEZLMFZpTWNHd2tteW9HbW5OOE51?=
 =?utf-8?B?eTVNZTV4aWdwbjhNbTFPdEdrV3Z4R3QyVE9uOEpMb3U4K05MV0EycEJEUXZW?=
 =?utf-8?B?eGxKOHIrUGh5TjN0UXpJbjE2b1B0UnVzV3lJVDRtR2x5RUZSZ0J1emw3WHVQ?=
 =?utf-8?B?T050TkRSOE00NWVhV0I0SnNlb2phT3hkc1ovR0RuMUVkQU8vWjVndHZTNlNo?=
 =?utf-8?B?WkJCbnBHZGdKajdMeElkU3o2ek5XY0NkdmJQN0UwTVNkRjJERGJrekpzZWtM?=
 =?utf-8?B?WjNYK0Z2Ui93TmdDQkVXQzQycC9PN09vT3l4T1FMaWVabkNzS1dwUEJONEdG?=
 =?utf-8?B?KzgvZ2M3RFpnVWJ1aW5Pb210bThWTGx3TWc0bE5ML1lXSnhoOW9MVXFkVVBK?=
 =?utf-8?B?Uzh3RldNVmtpY0c5ZG5UOUxRZXlLNmQzRWRaVlhFR0QzWHRkWFl4eHE4ejV2?=
 =?utf-8?B?QUhoWWF6cWJsbTBkbmZ4eVlMY2JxMGdla2swZkhrbUwwaGVYdHpTU1VBME9r?=
 =?utf-8?B?TVRoUGhoWlF1ZWw1Sm1wOXBBWHQ0TVQ3bnNGcFEzRGt0VTFON3NxSUNEb2dj?=
 =?utf-8?B?YS9McmJSckhrTFBuNWo4L0NiQkVVOGcyNVRLMS8zL3NYZklRQWp2em82MDFZ?=
 =?utf-8?B?cmFodXpUek1qUjJJQUR0a3RCdDVEZDErOHpQRDNiZnhlNlhBWlhwbnFOUmZE?=
 =?utf-8?B?cVZjeEJIMEF6S0dmaENESVc0Y2pFZmxNUWhiQ2lYT2hJYkJuV3pJT2l1NnEz?=
 =?utf-8?B?WDMvZVJWdWFXM0FNQ0FHTktSWDBJVWtkWVBXdkF2d01yQ1N1bnNmTkdMZ0tO?=
 =?utf-8?B?cS9jNkhBWDBHWWppUTBEZmZJK3pvQjdHdWJMb1BoVWd6dS91MW1xYTBwZ3Qz?=
 =?utf-8?B?RGhTemFoR1owSGZNclhVR3ZENDAxdTZORnczWDJEQ1BjM1NMQm5nU0FCaC9Q?=
 =?utf-8?B?c0FvTzBQM3MvbDVUdjRCLzQyNXZvL0pEdlh6UmplekVvT0d0T3NqVnYweGxv?=
 =?utf-8?B?TkFQenVGckpaS2lyZ3hnYnNZL21RdGtMVHZpUnlMK0dxMXR3djhOZC96eDdm?=
 =?utf-8?B?a3Z5WXRJc1RUTldGRzBCYkFnYmNDb294d3hhTTRIREVEOFkxZ3JrRFg3aUFC?=
 =?utf-8?B?cDZqNDB6SkxHSEJPdVJFaWRZV0p5UmQxQ2NRNW5mbHc1Y29BYndkbnVJUDIr?=
 =?utf-8?B?dVBaSytaNDhZYUk3eitEL20wL3QwaEZrdWlOS21TWEd1S2hxbERocWpKYXVs?=
 =?utf-8?B?L1R5aDY3QThUTDFaS1ZEaW9pekhLVEhoaGFCenJ5NG5ZWUt4dDViQlBvQ3JS?=
 =?utf-8?B?ejJodTdaRDV6WVkvQkFsa0RSRE54M3V4ZFZKNHVxM1BYWEE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Q0bRsVKGefZl/tCPFD+oyxaIKznCf37dXObkb04xt2pRhd0DRMW6Eq8TZmP1Qcp40iBWR3fzBanpPp4uL/SV0gtiz0juFjS8nBbjriVMJV4CROWBHeSKLtLxyBraPxbU7vWqRpziMyADySI8au8DYOlWN+44U64oVtHp9h1aGe4iafubMl2X0gRZK1U45zAR+Xykm+SdX/6+hRB0G1O4lxcp/B5cOG2zU1i0OFGGgBqr5BetDrmYuUuUfrMzpC7Rrb1ZnLyC8NtlWH46rWoetjPYIkZCm9Avh9UeR8Z8+OvF1allhMmDMmzoul6YhcGcI30nUXeHPZPhiDvI+LJcEuzffXLd/2lftRcsS+vfZiwEeNtBCXJfbdvOROmWsQjre8+L2P2gEqfqBjqIjnEgnDcyLu1c7GE+QwyN3nMdk7V/CJUfcMkRFoAiQNssjkt6LZNJcVgAxeUpDW+1ecPaXBYuy7bVvch1ZoOVg5HoSbcsyB9dbiHIiSGNnEtiez1Ntn39HaYYrJmwU5JGs8+7D7jjsVhFKJvRsXbN9sFuMTo/QluDwFGEutVe4uojwmFKR1HrYLFGgoXq8EeWaqsiGNoi1cSgF9cwKrLLBZGj0+227RsuRxi4R/ZlTPN+1aaBmbB7+G0bhPem+S6sHr0Scg==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 17:04:18.8545
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ba1a087-ec80-43ed-4952-08dcff4e37dc
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR19MB8703
X-BESS-ID: 1730999068-105090-12691-30408-1
X-BESS-VER: 2019.1_20241029.2310
X-BESS-Apparent-Source-IP: 104.47.57.43
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoZm5iZAVgZQMNHAMs3UyNQ80R
	xIJ6eZWRqmphqmJaYaGlpYJhmamSrVxgIAlFF8U0EAAAA=
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260269 [from 
	cloudscan17-186.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Add special fuse-io-uring into the fuse argument
copy handler.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c        | 12 +++++++++++-
 fs/fuse/fuse_dev_i.h |  5 +++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index f210f91a937b24e75a467e943cdec4581900e061..4ca67c8ae0e28072383478d6ee7ad7791566b6ce 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -738,6 +738,9 @@ static int fuse_copy_do(struct fuse_copy_state *cs, void **val, unsigned *size)
 	*size -= ncpy;
 	cs->len -= ncpy;
 	cs->offset += ncpy;
+	if (cs->is_uring)
+		cs->ring.offset += ncpy;
+
 	return ncpy;
 }
 
@@ -1872,7 +1875,14 @@ static struct fuse_req *request_find(struct fuse_pqueue *fpq, u64 unique)
 int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
 		       unsigned nbytes)
 {
-	unsigned reqsize = sizeof(struct fuse_out_header);
+
+	unsigned int reqsize = 0;
+
+	/*
+	 * Uring has all headers separated from args - args is payload only
+	 */
+	if (!cs->is_uring)
+		reqsize = sizeof(struct fuse_out_header);
 
 	reqsize += fuse_len_args(args->out_numargs, args->out_args);
 
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index f36e304cd62c8302aed95de89926fc894f602cfd..7ecb103af6f0feca99eb8940872c6a5ccf2e5186 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -28,6 +28,11 @@ struct fuse_copy_state {
 	unsigned int len;
 	unsigned int offset;
 	unsigned int move_pages:1;
+	unsigned int is_uring:1;
+	struct {
+		/* overall offset with the user buffer */
+		unsigned int offset;
+	} ring;
 };
 
 static inline struct fuse_dev *fuse_get_dev(struct file *file)

-- 
2.43.0


