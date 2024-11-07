Return-Path: <io-uring+bounces-4542-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 331799C0C82
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 18:10:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B8FBF1F22BE5
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 17:10:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB626217446;
	Thu,  7 Nov 2024 17:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="KSUctOe9"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522BE216A15;
	Thu,  7 Nov 2024 17:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730999083; cv=fail; b=qdpR8qg9lrwOrQ/H9851I/BPaHquMq55e02ksgGyZTpurHLgqNA7UuyZXuUrq8muFL7hw1FgfVKeGTwOKcoSl6DLd3b/TTCIZuJyd5W1ibZo4fj+BwikSQkeHbvwxOGRKz0s0xa9V70phrTloRF2mpXKDHTQx0sOmsc4WLf8tIc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730999083; c=relaxed/simple;
	bh=jKm4kFdU3Tezi0StqAjPcOzsAyE8qzZlYpZuvcYeiH4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZYNihAKWbq4wCxb85mhuRqKFe1qzhMdOZlNdGfARMcaoceojVGpiY/uod8pV4jR6NNpn8qYcda+PaqU/IWwMyxQbnqTOCprD8HRbfNSz1HSvXANyoMLEbtdR5kCC/MO8Oo+LWLR/pMJ3R9DFqoDM/SZ2oWoUfVtTy5N1FIgo8DU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=KSUctOe9; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173]) by mx-outbound16-173.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 07 Nov 2024 17:04:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lydtX+dkOFDZj0FWI93tESCnCAbHNfuGUCuoEPJi+VpXIJZFo3Os8bYU8GqyoLtH9YmAEYyobOZgOUVJWNXTJBj5aJpe8AIuFO32K14W13RlFqPmqKHptki081etDv90Xix2vzKSZvi5SpJdrTQg9utNNxqTI7T3D26kQrAvgS633BDMRXs9K4bT0tsmklx64EjTnTMegwd4BK5Mo+E2MHYJcH7EUZRIrEIKFMzyh1lAkzfv0LKV2lR3noor1ghMk5PCDGSJXh4L62FrE/3TPKgQhHi0D3/kfe4Qf2u5VXdaw+5F7u6+eF1ddvR8RK9YvKkwMGHAWFO9F6aSooHfPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T30O5KHmapOuYwSuCcKCgLAgQIV7XE97QiyqOtVMWcI=;
 b=KlIH+hVKV6CO518nQ+Q+OkgBF/Ny/zADDR77GWmcC4BPzj+VOgBxSEgRcunpJx0DtoLu3D0jmP3zXMKxRKL1uLudeueZ0+CXnEjBVSWwiTEYWIcnPO97Wfcgqe8PeNvkFlryWpxB/URG4AJbx7xsMOaqZZ7wZ2yKA52YCUdGwRgW3y6ld74bSay+bqDD77ZZgfs7nkq0e46DV7coNfxQ9SIcd41LpZe5UUcc1Y8AAXUz39kjggRnfouMuH+il/dRxj5bfbPrqn4PSVca+UqLIzJBhPUHPVuFK/X4tv/mvR0FEeyrjXQretWWUmnDjJNm9/rP4lM8T27npyMLs/xdoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T30O5KHmapOuYwSuCcKCgLAgQIV7XE97QiyqOtVMWcI=;
 b=KSUctOe9MVgRjxF3LfgnCOnlx3/34uWEVtaPNZO58q9hK0ll1SUn0kF/wvcy7BxgolSpokK4qGA18YHfpY2MDc9TUK2VQIMP/gtXtrf0mUu3HwqcCAAs2GeIEkg7WuNQUM8JjNV6oSVdfbrdaa9BSh6D/9CYzFZKFGXAA5rZvDs=
Received: from BYAPR11CA0070.namprd11.prod.outlook.com (2603:10b6:a03:80::47)
 by CH3PR19MB7905.namprd19.prod.outlook.com (2603:10b6:610:155::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18; Thu, 7 Nov
 2024 17:04:27 +0000
Received: from SJ5PEPF000001CA.namprd05.prod.outlook.com
 (2603:10b6:a03:80:cafe::56) by BYAPR11CA0070.outlook.office365.com
 (2603:10b6:a03:80::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18 via Frontend
 Transport; Thu, 7 Nov 2024 17:04:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SJ5PEPF000001CA.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8137.17
 via Frontend Transport; Thu, 7 Nov 2024 17:04:26 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id CDF2D121;
	Thu,  7 Nov 2024 17:04:25 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 07 Nov 2024 18:04:00 +0100
Subject: [PATCH RFC v5 16/16] fuse: enable fuse-over-io-uring
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-fuse-uring-for-6-10-rfc4-v5-16-e8660a991499@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730999049; l=828;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=jKm4kFdU3Tezi0StqAjPcOzsAyE8qzZlYpZuvcYeiH4=;
 b=U4crFgrXTlvp5HvayLFG7IvTG9rO6ywbdsEpLQKmy6oXqMxhtVfTvcxGw5Oxt1jxItVjpF9LN
 /CVg7ZutoPyD92ksxA/tYtQfDXOUMMP69cd04LeUIUuVZaUol6LL1kK
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CA:EE_|CH3PR19MB7905:EE_
X-MS-Office365-Filtering-Correlation-Id: 02e91e8c-2ccc-46f5-54a8-08dcff4e3c77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dktxZjEvOWxpLzQzem0rZkIwb0JYNWs1VVlRcHc4TFBXcEFBUnVnbXpabVA2?=
 =?utf-8?B?MmVvTGRZU1JwZUhsYyt0UFdha1lrU1RVa21MMUFGMFpEYXhxd05vMWNBdExY?=
 =?utf-8?B?YW5aS3h1TzZvMzNPbzVEKzEyUGNoV281L20xVVhQM0d1THNMM3p1dTFyajBV?=
 =?utf-8?B?TEtQY1J5UlkxdW8rQWUzK2FuMXNoNXRlM2hQYmcrU0J0VndzVVVuT0I2ejE0?=
 =?utf-8?B?ZFVjbXVGWVNocVpTeXhhVXMveDJSc2NtUEJPZ0x4TTZrRnBoL2VHQ3h3OXBB?=
 =?utf-8?B?WmVTU0tsNHhqUTdKVmRQT1RsQ1EybG1JUER5aUZ3TzBRL2JRdXYzaFA5RFpz?=
 =?utf-8?B?c2dDN1ZPUllsUVFiN05Ld3FQSVJ4SC9GS0lxdzNPZGs5QmRKajJvM3E1MlND?=
 =?utf-8?B?Nzh5dmFnRW9qVlV0YjNCMWtCVTQvM2VSYlJzMGM0WHU4dFYyZEdEb1ZoZER3?=
 =?utf-8?B?VENVdS9DZU9vVmVVdE55RUMrejc5Vk9KMHl3RWJyd1hJVjNteS90WWJ4VWtz?=
 =?utf-8?B?SGppNEtLbW8wYTFUMUt3azc2eTRBQndTSlhmakdxUkhWTml1Znp0OEFnaDQ3?=
 =?utf-8?B?aEp4U1VNRWxPd0hRUHJNWFFvUmtDaUo2OFYrZHVxaStFcFU3RzBhVE9xUXZs?=
 =?utf-8?B?WDhPNW1QU3dlTHpDajBKTmRKaFB3aDM4TGRGQWoybFRzVUgvOWdPb0JkSXVp?=
 =?utf-8?B?ZWY1cUIwZGdzS2ljMWVMbEtrcGlBR2diL0hoNlNzbFUyOHVtZDl1T1ZtZDZa?=
 =?utf-8?B?aWFyMit1SC9qd2o3SGdoUEVtc3hkRHl6YzErNzhZV0l5QkJtUnJMVVdFNUlX?=
 =?utf-8?B?RFdXY0JhQVB6NnZicnU3T3dmN083Vm1VRGZ6VE9rQ09vbmhCQnlXRzBvVk9o?=
 =?utf-8?B?S0JCdmFTTSthR01sSFU5YllSbDI5RlVQUHE4eDU2ejdUdzZUT1BKdkRUc09s?=
 =?utf-8?B?UnBWNzJFUzhRT0hocThLNjVIWi9oZ09NZDRnVlFXRXF0ZFlQeUUxaWZ0Z3Vm?=
 =?utf-8?B?WUwwNmJQM0U4K2JFNzJKYllhSVJ3TEQ0YVpuOFhpdWVFUTN6SlM5cVA1eHhl?=
 =?utf-8?B?azNlTEptdkFKMnhjZFpGNU9xY0l1eHVuOFR2VXFmUE8yNk90TWNaeEU2SkJp?=
 =?utf-8?B?bDhXOUl2MnVqbDhOU1pYQ3RUMnVRendxWkR6ZUNub2ZQUkJvZ3BCU2tOVVdS?=
 =?utf-8?B?eXlQdVF5bHpoWE0rZE1KUFNmZEZycjdDL2dYUEF2NjlVd3dCVXQ5VG5hTXJ6?=
 =?utf-8?B?b0krY1FUdGRhRFBsQXU5Z1hnUVdMak1MOXkwdUZSYi92T3hJTHl3MGN4aldi?=
 =?utf-8?B?OGkxU0wrWnRnakhiZGpYVGNiNUZ5d1JNaHZNM1g2cG40ZDc5SGRNTW9OenVS?=
 =?utf-8?B?cjcvR29wRTdFOFBxTEs4UjlhT0dGaUVuS3UvRHpXV1ZrUy9aRythWHpHU1cy?=
 =?utf-8?B?Q3ZFOU5YQTZoQ2ZCZkV4S0pNclJxSkUyRE9yY2dkWWRXaWhrTXdoQ1ErOXZP?=
 =?utf-8?B?REJ2K2E0L01ZanA3cEpwZVY3NkVtSDBzUjZKb2xoTGZ6T0dReGRQcW5kbTgz?=
 =?utf-8?B?NzZHRllsL1hsWm5GRmppL2h2b051bllGSTVTb0ptbnU4Mm9rSmNqTjFzRW5I?=
 =?utf-8?B?aVNNbVA2MU1lSVdrSnp4enlVYkh4VUt5YkNKdVg4NlhqMklCeWcyQlA2eTBx?=
 =?utf-8?B?cisyM25CM2xyMFI1ajZFUkFWaXhJcm8vUmJYdDRUOUlMSHBYOW5kMGxZeGJn?=
 =?utf-8?B?b3RBZzB5TFdsSkZVeHJJbTNrV1Z0SXlzcERKUmJDdXJWNUdFbTVteHFvQng2?=
 =?utf-8?B?WmJGbkw3WWYydUd2aFNrSy9WWWJvLzMxUmVTWExWK3p2NzdCUzZQVlhGVEta?=
 =?utf-8?B?T09kdmsyQlQrRUdaTHNWVi9HU1BWWlY2bE9tZVMxeVFWMEE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2FWEAK43CapPaiQASyh+tgO6mh7JbgjZeFYk76ZRL0WZJf6RhN8T+6TTWDUkmwAKLQAVu2IvkVhxYt6YeAGRDMv7Pq8ItqYZoBH4tJpVylwGej8B89vlglNT/6Jbtx+dkXqeGjnNjM94zKqTNGsATnjXT4+AuEuyRq1QUEpCfcocuskH6LZ6jfeGQVkTVoe+IRU+b+1AsTcKT87ex+2bU/K1fgJkOrDRqgIVF/C81MzIO4USk9wYQ+2ZzDUKhhwgNLs91wvKOT+K2Fz73MIX2TFgnAOlrrCDUcn5n4MfV/uWr9oaOQxSmayEHSQq1JWNSMgJiLHGD36lvGn/M4aK/lInGtMDTePPBtFyvGhvTwM1pvS2AabKA6LyeqPGb09K8mc7rL0cAgcP8HsAxD2z1VSYyih/dGOYT2MTA3Nv92Z/RPUBJyzvydRLiikRER3P8XQjtVgCfJMvnUrbkxQoFDyBUMZfzKUZgh9Vg8xHxVx0FJZeTAKfIVe7w1TaYOnS7Qp1g1bVzS5ffzj0ipuDLAefW7mH3IgJsdF38u7IEC/QKueek3m2LncwgqtlEMsIIarmw0m9sojqUWxCO1QB5xpDmd691ho/m8sXgAb9DndWvFVb2sh0C36U2cgK1r0YNThACGEiwAkY4CugFrsl2g==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 17:04:26.5815
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02e91e8c-2ccc-46f5-54a8-08dcff4e3c77
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR19MB7905
X-BESS-ID: 1730999074-104269-31157-18924-1
X-BESS-VER: 2019.1_20241029.2310
X-BESS-Apparent-Source-IP: 104.47.59.173
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVhYGRkBGBlDMwjAxxdQi0Tw50c
	Qk0TLNMs3AIs0sMS0tzcAoLTnRLFWpNhYAQx2E80AAAAA=
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260269 [from 
	cloudscan15-150.us-east-2a.ess.aws.cudaops.com]
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
 fs/fuse/dev_uring.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index b465da41c42c47eaf69f09bab1423061bc8fcc68..2ee7d5ba260bc4b54927af1a856dabcf7d725edb 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -1056,11 +1056,6 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	u32 cmd_op = cmd->cmd_op;
 	int err = 0;
 
-	/* Disabled for now, especially as teardown is not implemented yet */
-	err = -EOPNOTSUPP;
-	pr_info_ratelimited("fuse-io-uring is not enabled yet\n");
-	goto out;
-
 	pr_devel("%s:%d received: cmd op %d\n", __func__, __LINE__, cmd_op);
 
 	err = -EOPNOTSUPP;

-- 
2.43.0


