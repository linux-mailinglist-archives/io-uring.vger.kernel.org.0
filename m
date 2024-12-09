Return-Path: <io-uring+bounces-5322-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0D3E9E99A9
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 15:58:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87ACF282C42
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 14:58:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 271441C5CA7;
	Mon,  9 Dec 2024 14:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="Pp/yWJeJ"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B88B1BEF9D;
	Mon,  9 Dec 2024 14:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733756222; cv=fail; b=agsjdntJRcNTleemNu0BPZykILYrwMKrawKWVyrCWxUn7SNtRpEDC1n4UZyg2uvZ+t0FTm0ZzaT5GtHmcSazhnEAUR3kBZHZ0nmyDyJ+rV9sLx+gxtYvWdtpwet6qir4D3FAwKH9t7Q244dFZyHCAYOxSbbVOiCSXGKSrYGe9ik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733756222; c=relaxed/simple;
	bh=RdW8CNS5KhJWzICWUZhnzVTBQaF0htre3+ISX55U/Tc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oMVmyyIalUDsAzy22iEw3jPcC/i+SpFNty686fdD6ZZ/kj05oDtaLQvhD/zEo3PITW7shlpdAkjRKLThmlyYYh1mI4kISVb9N2IbBhbzTuiZuoTM3jCI8W7ora8D0gsIS84PVsNFtmAGFfeSO6elch2yjygSb9U8e8WAObzQ7sg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=Pp/yWJeJ; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40]) by mx-outbound14-107.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 09 Dec 2024 14:56:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hBq5RhFrbRiFLTskIvqQ0QKxSKxWfAOeYe+ABZzrVa/GgZbG+XcoumZRZAcMJPN+3zz5smIMPra7enoKcc/iIcu7V1z2AMyuBN+eLrp0NOwuAYjzxnhQMK+QIvhPtFib09WZ42ox4vtgm6VvlHoBt2zy5d7+V8JL0l5wZXp+SvpV6/4BdvIOv8dkEdAEDAX5dwf0nA9OXTYJq62tD9o9xChAc2YhdgNsVGVkedXKYvpdFqp57E1LXiagS1PsgGCGtW/sAFBvio5JfPGVsjmHGOAl9XTEbArU2oPhLYnFO/7aALdrLFESEEy6RuoVCx2wVfwkK3CnMRkzgTZcx5Aicw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UjuaugDaR1JCbtHQLuBm9QFC1+Jpx/W+88lLdtt89Mw=;
 b=vbJHB2o78Rjz6ChTs0qwN5VkP0tzIVvHUlQn08eSgFxbVTcdbkaMIenUChA+ThMAtQkIdqxirxlgGyNUP+6Dr5Qz952vXC/tcHMon4ptyEZH5SRvXg4Y90SMKoxrby/QBXADK+sWaVaMY5RGMzpTCZoR4YFiH6T9IcCAcD366HhmSMjODRQ5u0gOH2m6HEMhErRoBC74TuiDkhPUDPEUpToq3G6xpY6k8LGivxk9wMD5GNP/NEtOUJUi2EGMbuzetmDdBsZdXiODjfzyHBowRxIzFn3hcLwTmNj65TsG5zuTf1mQXLkOgjfO4hAsSCGP4rIGhwCndnBwNpbjihra9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UjuaugDaR1JCbtHQLuBm9QFC1+Jpx/W+88lLdtt89Mw=;
 b=Pp/yWJeJaRjPjGJ/BRlGiXYq4dSxVgwJiVA/8glhPADOXSahqH/l63qXG9bw7GX2DpEOl6uPs67PBUK73ZAEb29gURZTPLS3/GlXGkaRzvbsKcNKNlCM8m8LYrtI2r+PIyxQBvpJ2A5hDEYcNw5hp9y9HaBGOxC6l56Mtuhtxgw=
Received: from SN6PR08CA0028.namprd08.prod.outlook.com (2603:10b6:805:66::41)
 by LV8PR19MB8422.namprd19.prod.outlook.com (2603:10b6:408:20b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.17; Mon, 9 Dec
 2024 14:56:48 +0000
Received: from SA2PEPF00003F62.namprd04.prod.outlook.com
 (2603:10b6:805:66:cafe::f1) by SN6PR08CA0028.outlook.office365.com
 (2603:10b6:805:66::41) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.10 via Frontend Transport; Mon,
 9 Dec 2024 14:56:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SA2PEPF00003F62.mail.protection.outlook.com (10.167.248.37) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.7
 via Frontend Transport; Mon, 9 Dec 2024 14:56:48 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 8ECB955;
	Mon,  9 Dec 2024 14:56:47 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 09 Dec 2024 15:56:30 +0100
Subject: [PATCH v8 08/16] fuse: Add fuse-io-uring handling into fuse_copy
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241209-fuse-uring-for-6-10-rfc4-v8-8-d9f9f2642be3@ddn.com>
References: <20241209-fuse-uring-for-6-10-rfc4-v8-0-d9f9f2642be3@ddn.com>
In-Reply-To: <20241209-fuse-uring-for-6-10-rfc4-v8-0-d9f9f2642be3@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733756199; l=1731;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=RdW8CNS5KhJWzICWUZhnzVTBQaF0htre3+ISX55U/Tc=;
 b=tOOJRivkiSuFANMwGn/JjpTB21PJ2mhn5+IlP1rzXoxiYILg2hcBkL4EGv9ghlWhGOebXKYeF
 8QQ0NeVo0v+BrIwIFr7GtlpJWBGI8Jyo8EW148nq0BYbvB8YVMsswqq
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F62:EE_|LV8PR19MB8422:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f437dc0-768d-487f-7611-08dd1861b500
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RXBOc01MV0lGZk12YldLL3FIVU9TWmgySDVtdVl3VERWVUVJTW04V1pDQXcw?=
 =?utf-8?B?Mi9OaHpJRDMxRnhrN0JpVlFNTnY5Vm81b1k4MWVwNDNXd0ZGNVI2cmZVNUNC?=
 =?utf-8?B?dmtFZ3pDZXpENmQyTlRtWnR3MEl0dWlKRFJ0b255TktrUWlNWXVFUXpxd245?=
 =?utf-8?B?ZHFWb1hDeTZ0dHNieVo1MDVHM2o3dFlmTU9VSStQcHBQeFFyM0J1UDN5REYw?=
 =?utf-8?B?dnVyRW8xd2ttOEoyeGliWGdLc0FCYnVYZGhZSXF4MHl2d2wxT1hhWjRZNGlL?=
 =?utf-8?B?bkYxMzFJVmVuVmRqR3RxYURBZnE5ZDBSaXJiekZNVEo5SVVNZ3puNGZKRFFR?=
 =?utf-8?B?MWVjZ2tKTmdLTmJIcnBoZjh0ZHFadFlRbk1qdVMyVEhyQlc4b2V2SFJ6WmJn?=
 =?utf-8?B?UVFudTMzSHB3VUdZc1R4K3RJcGpaOVBoNUpBTS9lMnFDU2xwbTRDa2NOdXQz?=
 =?utf-8?B?REZSWmUrYkJTZFNyRzJQNHpMSGorWnZPZEFYMlgrYk1ERUxmbDhvOENXbXBy?=
 =?utf-8?B?SzZ0Q29vc3JrYzFqaGtWS2NJTTlLb0QyTDFxaVhoQi9vY3pMbTY1bjkwR0Vv?=
 =?utf-8?B?a0tJZmZHbnY5UEV0dlhONXRuYTVTK1ZZUGUyb1JTQWVNd3R5V1lwcXhXTUJV?=
 =?utf-8?B?VzVqMWZhQ2Z5Vk16WHVOVW5XdWtYRTN2dEUzaWx5bnBJeStwZnZ2dHpnUzI0?=
 =?utf-8?B?MWNPVDNuNkhHQm4vU1pJQWxFM2pFY2N6QVpySzBnVzNvSTFRM0hqSzcrOFlV?=
 =?utf-8?B?QmNRMmU2ejlEOTFkYTU5MTNGSW5vOCtSZFk2SGZZSEc4eWE5NmlHQVFpOHBB?=
 =?utf-8?B?YmNJUDNEa1A4WE1iOVdtTzFveG5kKzVoRjZLY0E1RUlzaXpuSFRzbGkvVFJR?=
 =?utf-8?B?M1Z2MFYraEdoRXdiampMSmV6ZExSdGFYcGRGV0pTZERGQ2JpZTdubXV6YjZM?=
 =?utf-8?B?YkQrUytET09YR1Buekg4ME5kWGgwdUQ4aFlrbjVQaGFKdzZHTnR5NEhSYU9y?=
 =?utf-8?B?WUZTNkVLUEZoQjNjeVJNcCtMR05ySFhiZEVzV0FmVG03QUN6UDVCZkRtS1d4?=
 =?utf-8?B?TWR1eWxvWUVNU0o1bmRGeU5sZnBnRVU4ei85enluUVlqak5SQm1Pc0ZPMTk4?=
 =?utf-8?B?T0ZmSVBGSDdrdXRLVHRDcStNRmFQYTdXK2dIVUFZNVY3VHQwcVNUZGh0dno3?=
 =?utf-8?B?Q1hjZWpwMDE4TVpKTW9qcGVSelpqRGdRQy9JYkE4NHgzOVlkaHdvekYxMnJI?=
 =?utf-8?B?SnMvRkg3azNTQVlPckRNOG4vSE1VVHdwTWJVYm9Bcno1YlVoQlFEZGYvSUpl?=
 =?utf-8?B?RFdqYzFqMEVUSENUSks5YlVZRWhQRnJjd09nanBpVC9rWmZoR09ScWlyaVZQ?=
 =?utf-8?B?dG9lNHdNR2FMNkdaUlZjbkVmNTl0dEc5Rjl3WTBkY3ZuamJwVkVRdi85WGJ0?=
 =?utf-8?B?aXREdFArdkFocDYxNUxHQmMzV2NIUThUMFp4WC9LSTU2eGh6N0U0R09ZRDYr?=
 =?utf-8?B?N1ZqREF3SW9RYUlJZUwwVVd5c2hJcXNkSytDY3pTbFA5UVBHZmtrc1JOYkpa?=
 =?utf-8?B?cTNQNHNnamhCZk9ualhMZGRWRWpWOGowckg5VXlTbHdJUDJTWm1EUzlHdXE1?=
 =?utf-8?B?UEVoMGFGdjM4YndienNEQWNOVURybW93eDRLRVMxZjk0MWJRUDVFbFN1cGpj?=
 =?utf-8?B?Rm0vOWpQblM5TExGZTZrWGk0NUVicWZ1czdpV0hWQVpRRFc5R1E0ZCtMQk9Q?=
 =?utf-8?B?M1ZxVURoa2tta01UTmJvQ3hRUHNQQy9qWDJlaWFXSHJuVmJyWlVoQ2pnTlpM?=
 =?utf-8?B?VThlQjc2SmhyL2V6VU02WFVCRGhOdkUrbXhia1h3T0lVQWl4OHpLeEU3blVL?=
 =?utf-8?B?WksvcC82bmQ4MVlvZnZoVVRmTWlFSmV1aG90MzJmNm55MEc0QnRFZXoyL2VG?=
 =?utf-8?Q?5xud1kDqiaS31V1o3zT3AnbKCyyUu6lo?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nvYWpXvb3BavEBB+gwUH7ZbmMMGd/7k1N32NvZMg2Kz5Gy0k3QInEiUyq1gcB2noYAZ+l4l30COe9tRg2bYw/K9au3+E4v6osQp3hIHG95vHrg8ESCmxXM87qOo9JekLjuiR3FDfZ3WZpUQyiLFhlQP2GDzh9fnnEX3S9G3l/AnYx73vhi+JaV3I7px7k5HRElacToljKH3QMFxe5/g6ggD0b0qdJnU5TsbUHx6NxP4BzTIpUDIzuz25z/wj0ziM4xFEuHAJ+NhUTLwKNf2Gocf9Uh+ft20A9PV3ARL6I1ll/LDsQPGyfg4+GPL4URw1poK/whySkeNDXW+9iGIAvBxZbNYB5UBk66M5WiKqDw6RXeHRWxT6q4Hm7zOrDaLaC8YDmapxJw46kd1mwWWkHPeFoKtDH/gRSfI+nroUeGnHNhaqfvVb0qDDAkFKZ1niFj4iQieq4atDC3BF9q9efbw3TrkR6fKOcUNRAnvClNT3f23u/h24TehMdok0Hp1Cs2skau+Kp175mzpDtCD9rY+HOMoZAXzqqZLrHA5pj9qh7jt+r6XmHHkRI9AUsp4vKlSNx+KhBPfZ6ijPzAN1YI2yZbqCOp2uAHH9/ZdrV6//H1pRmLgnn3+I89LBWUkciPLMu2l/Gq4jJzVIaoN0TQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 14:56:48.2204
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f437dc0-768d-487f-7611-08dd1861b500
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F62.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR19MB8422
X-BESS-ID: 1733756212-103691-13593-2143-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.51.40
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoZm5iZAVgZQMMk00dTQMNHE0j
	DN0MzIxMjMItXM3NQ0NSXZ2DLZ0jJJqTYWAL2ZUExBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260997 [from 
	cloudscan22-230.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Add special fuse-io-uring into the fuse argument
copy handler.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c        | 12 +++++++++++-
 fs/fuse/fuse_dev_i.h |  5 +++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 6ee7e28a84c80a3e7c8dc933986c0388371ff6cd..2ba153054f7ba61a870c847cb87d81168220661f 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -786,6 +786,9 @@ static int fuse_copy_do(struct fuse_copy_state *cs, void **val, unsigned *size)
 	*size -= ncpy;
 	cs->len -= ncpy;
 	cs->offset += ncpy;
+	if (cs->is_uring)
+		cs->ring.offset += ncpy;
+
 	return ncpy;
 }
 
@@ -1922,7 +1925,14 @@ static struct fuse_req *request_find(struct fuse_pqueue *fpq, u64 unique)
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
index 21eb1bdb492d04f0a406d25bb8d300b34244dce2..0708730b656b97071de9a5331ef4d51a112c602c 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -27,6 +27,11 @@ struct fuse_copy_state {
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


