Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A9567903C
	for <lists+io-uring@lfdr.de>; Tue, 24 Jan 2023 06:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbjAXFqU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Jan 2023 00:46:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233034AbjAXFqN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Jan 2023 00:46:13 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on20607.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::607])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307623C296;
        Mon, 23 Jan 2023 21:45:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y83Wb++48zcYxpTmTfErEeOUIYe5bfikv+PKytGQVB2mdZC9b21ZPUejt1Dj7I2FVbiJiMvVJwljlzv6/Ri+3qRz6cRzy4mBr4MnRKgGJXpTNqZMn3VACEz1rWVee/W4eXgD0Ag/0YJuBfEltZhhZI2AUiJSkIyc4SCYdW4FgzZfZT28Gwn/pmGGpo2oDadvdXJtApjh6D3ftctHYI/BOx7ltE1UNGe1PPP2GNas3wxiCssoED40kJuykYRP/tGUmDThY9haN8HiG7mg7rirTJpDEpmjnx8MBq6bIz2x/v3a8OPHNY11NS9zwtscxyTwwE8mRzl93eLOi0/JGu5jbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lky1pwA9ndycQb0tInBuvcdP9GKU+97WFqRHP3U1Daw=;
 b=PyZUxZH0LQqra7Cf3OwBQ9w71iDWf4u4WIdUyamNk+k3HB/j9vc6aqFtgBdXWLfg3aXVBDvDQBMZeyVaJHyDwvLDnPT7vpw4Hsw+QbmLwm4FvyZ8J7p3eAwB8XfivJXY5Xvw2sp9MIo6g578R0QBJWzpAqXvKw2aEkqiFvwOM2E7Cb2sfJb7dB3MI0UnMgGWRK+r+XZ1UPmZ/0Zori4Y8v+Rz8EEVsdUNdVVwvqa4WG7Xviq8M788LIzN3kHJR90OTvZi2Mj3Cx2ZvA3dL/9iEKhhvLIdW9uRj3khjEw4ktxTRaJZR9dEORX3IOfOVfy66ai8NQLVk7Nllgs3xJcVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lky1pwA9ndycQb0tInBuvcdP9GKU+97WFqRHP3U1Daw=;
 b=YNhotQ56/PX/D+NqqAgqfCt2w5ovQb1AwXS86LtQCWt9SQ9hJjxOgH5XWHEUcbH7/dPgcUnBeVIbLEF9YEoXvGDpSuu1PCk/CiYR8ecIfAlhoHH8cRyFiIUQm1Lv+VSsoyA2KAcXgtj13O/2M1hpmFroDu4LJF/CKrJLWsmK2c6BRmZ6tyZOCziW6gfXlVX4M/AAXra2IW9Hsi2tqUlp2wTJo7txDnRWAuHpj/G5txbgXSSrFoxaa2TCUmjKHln2HqgabfcxQ6Ef+11/RE0Nzyv3HX4cTCRJVroIYua/xh4z3xLbW05AWEyCshNINEAOqx8Jb/LhO+4TF64JnIKnzA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by PH7PR12MB7793.namprd12.prod.outlook.com (2603:10b6:510:270::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 05:45:17 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::465a:6564:6198:2f4e]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::465a:6564:6198:2f4e%4]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 05:45:17 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     linux-mm@kvack.org, cgroups@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jgg@nvidia.com, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch,
        Alistair Popple <apopple@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Subject: [RFC PATCH 09/19] io_uring: convert to use vm_account
Date:   Tue, 24 Jan 2023 16:42:38 +1100
Message-Id: <9f63cf4ab74d6e56e434c1c3d7c98352bb282895.1674538665.git-series.apopple@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SYBPR01CA0107.ausprd01.prod.outlook.com
 (2603:10c6:10:1::23) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|PH7PR12MB7793:EE_
X-MS-Office365-Filtering-Correlation-Id: bc652ba4-ec3c-4172-eccc-08dafdce2c11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6dnj9Mp9wc5jcvJL2XaxCr1DLMU/lqeIFCLVQZDQy0Db82po2vq/u4nSS1BCKH+hTeCJkZHeO5UnYR2bNAskjkIWocL/8b2vXDYR8vTuhdTMWtrm57cbuSFZPJVdEmS9cbpeK8L3vclGY5dQMcseCNe1C3Ai3khh52sNTC7fZqjHyorSGsy4URIdrPvEbbWVu9OLtw5d7nK/cYYYqkgrG4EUvGDzRztYotJ/EWwJWhw2IaO0ubFKy3DcFZ15chWj/ut+m7ynr+Blbr0faPAwj9OcGtYT4nHWiNG9yFJBJYb0U9WyO8M7V501jCvXmg7CGVg2G35qBibIKO5g4tbbQw+uk/ivc3hjemrW9WmB7nLjC450AO2FvGdec0qIZDmXk5LVx0k9RBmwmk/TG65C+WBB0x9dk6Nbjvy3EcYRGMm/I81M/Zk1eGBRZOjbtb4ew7aBe+eyPbBAvG0BsyxVQJYL8SZE0JLJOnb8hnELfcch81eOqUpr5JV7NymIXSzQVR9A/RAiwmi8/DYZIxKVvYx1Vgv43nYL//9uOuNeB9toc3ztlwcFloH/TF+yadiMOFEw1jBYrQJW7yzoy48cJ4POLRwcmnJRKocVPZHDvtVKsVN3hZwWGgp0ilTlGI0zhcDSRc4E7K8kr6LPyw3XSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(451199015)(36756003)(316002)(4326008)(66556008)(66476007)(8676002)(86362001)(66946007)(186003)(54906003)(26005)(6512007)(6506007)(6666004)(83380400001)(6486002)(478600001)(2616005)(7416002)(5660300002)(8936002)(41300700001)(2906002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h50bbO1aOmvYgkgRIOy6pyojVPzHjKZnjlI6lpR5npwBm7T5czn1OrPR1v/4?=
 =?us-ascii?Q?sJDAuT7oPcdm0Hw8cxAVwcMb3qGW5tRnIm27JegVMW5I5FwQbzb6oFd1VX9a?=
 =?us-ascii?Q?h1f68Fl4SVquw81kSnrW5GBhujAYv1QtbcIBzdTB0+PajQ1OLgawGaUItOel?=
 =?us-ascii?Q?EIM2tFRrMflpLtlN2Q0u62Hger/1iEbDb36Qx4MsdqSk0P8etuYtYRmrEqk1?=
 =?us-ascii?Q?FBv+Z+Jqq2shDtFy3zzwdp489VYOPshzDwwHVuobKxbB9D4H3OxE7HwOW4Q1?=
 =?us-ascii?Q?r3BtCWSsWu2t6QmOKbYClbyhbdSyX13la7sLNWE1ka4PlT2jUEIN5YWNNRrn?=
 =?us-ascii?Q?IfXOKVVIsK4t2u0R6P8qCrU1u2QfkETgS5u8Zgtu3XqWhlqZlSRxtWw/+LX8?=
 =?us-ascii?Q?3A79sLtegA/jutY4dNpP7sloLEdqmF2ILhElJ48u9FaxRwscLNv593jtXZzA?=
 =?us-ascii?Q?iuE5ettP0DsQt0CtRbDZEfY2oGnHbzUt9ZlWwa1dVJyeROaxErGb3ZlcQsXz?=
 =?us-ascii?Q?DJHx+Q3j94lCH6018TOk38cFuf7YLZt+h+ma0snhtBDlQrctYfpz832jFX5N?=
 =?us-ascii?Q?aXhOXN7BjTHBTRVDbd+cxgi0SoK+eUN1AXgClzLRi1nlDfi9xO7r5kRJz8IO?=
 =?us-ascii?Q?N1YS54QEM+LylZgifewNj41rHD4lC3j4Cw+dK7SqcVJuw3APtD78U/UZkq4n?=
 =?us-ascii?Q?rkcUZoKZcikn5Yrs9cCaFqzIWoAlwEKawT3t20Eqdwz8YHYgClYvVcrdXlkj?=
 =?us-ascii?Q?XSNkJ1xKL1lwDygEEwaJe4Vt3WpIEyxa6c66ODFwwSLgs2rjKfxQyinq0DvG?=
 =?us-ascii?Q?ellIw2CV3rp/I4vu5x2RdetO0CXFXeUAe9JLgx7ICfYfjeHz908lQR1pp6Do?=
 =?us-ascii?Q?5yL/rUUWQBsdSdWlqajSoCBk8yp3iP3JQOIKnUOUKiVgSjEajILp4EOVIQzY?=
 =?us-ascii?Q?kjt4kg8UprEH4Lw+b2HRpbf6dQvhwVLlyUshxd/eCokyUQ/sRLqER+aOJMiC?=
 =?us-ascii?Q?o06E+U1bv5wFLNOfo7HgImHyfmyQIa1VeuJKzXzsnxUCacoTSV1DQmS+9UWq?=
 =?us-ascii?Q?+Ha5T6/03AoH6uDByJE4KCYPYDX8DJJd+rcI2J6umm5pUGk1DUY4VIhyupt2?=
 =?us-ascii?Q?uGZv+xJS5bCVSN7L6F62apFKe8Rno93VO4dM5XNqGTH6bBzxa5zUN0AuovL2?=
 =?us-ascii?Q?2e2XRIavMIlaK2bEq3ko/nIFMtywY3nlk1pc0NcMj5S8dpum2lSv/Cq2Iboo?=
 =?us-ascii?Q?o7HHsURaqTNS77/HqOUiwfpZLszyV3F15e6LKbBNUtaHzF8Vvzvi73F7dgoL?=
 =?us-ascii?Q?h33Rt5gfrAbLrT8DZcu0qyZP5nCxgo1hSacmGHKYtZ0gxw7LBBynitocPJ26?=
 =?us-ascii?Q?25SV1bmCIGBIpIzAjafrqBMaoep8UGSB2Psw3RpSd5xUhvWQROfbJQaAoshw?=
 =?us-ascii?Q?2WZaser6Vj/ebAbkg9sIzs+UelKI3GLZ03pMj4ouRVPX/ZFg+WPmKks3sOLK?=
 =?us-ascii?Q?hacxqn7xTBTGQrF5UFKjPIlmiIka57ZzmDu4mc9bQw+UEC9709vJp/X3zSp1?=
 =?us-ascii?Q?f/LkQFhxvl3JXNRdkzKymfGN8kJbGXQnBdZacFNY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc652ba4-ec3c-4172-eccc-08dafdce2c11
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 05:45:17.3933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4VHMQ9Li2qe2ASvzokp/FnjeS86gyvDwJPTIZ9bOyFtj1tVZ7fH8LGUAibhu9xXr4tEoK5tDW0XrytD6CU2S+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7793
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Convert io_uring to use vm_account instead of directly charging pages
against the user/mm. Rather than charge pages to both user->locked_vm
and mm->pinned_vm this will only charge pages to user->locked_vm.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/io_uring_types.h |  3 +--
 io_uring/io_uring.c            | 20 +++---------------
 io_uring/notif.c               |  4 ++--
 io_uring/notif.h               | 10 +++------
 io_uring/rsrc.c                | 38 +++--------------------------------
 io_uring/rsrc.h                |  9 +--------
 6 files changed, 16 insertions(+), 68 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 128a67a..d81aceb 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -343,8 +343,7 @@ struct io_ring_ctx {
 	struct io_wq_hash		*hash_map;
 
 	/* Only used for accounting purposes */
-	struct user_struct		*user;
-	struct mm_struct		*mm_account;
+	struct vm_account               vm_account;
 
 	/* ctx exit and cancelation */
 	struct llist_head		fallback_llist;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0a4efad..912da4f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2744,15 +2744,11 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 #endif
 	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
 
-	if (ctx->mm_account) {
-		mmdrop(ctx->mm_account);
-		ctx->mm_account = NULL;
-	}
+	vm_account_release(&ctx->vm_account);
 	io_mem_free(ctx->rings);
 	io_mem_free(ctx->sq_sqes);
 
 	percpu_ref_exit(&ctx->refs);
-	free_uid(ctx->user);
 	io_req_caches_free(ctx);
 	if (ctx->hash_map)
 		io_wq_put_hash(ctx->hash_map);
@@ -3585,8 +3581,9 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 		ctx->syscall_iopoll = 1;
 
 	ctx->compat = in_compat_syscall();
-	if (!capable(CAP_IPC_LOCK))
-		ctx->user = get_uid(current_user());
+	vm_account_init(&ctx->vm_account, current, current_user(),
+			VM_ACCOUNT_USER |
+			(capable(CAP_IPC_LOCK) ? VM_ACCOUNT_BYPASS : 0));
 
 	/*
 	 * For SQPOLL, we just need a wakeup, always. For !SQPOLL, if
@@ -3619,15 +3616,6 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 		goto err;
 	}
 
-	/*
-	 * This is just grabbed for accounting purposes. When a process exits,
-	 * the mm is exited and dropped before the files, hence we need to hang
-	 * on to this mm purely for the purposes of being able to unaccount
-	 * memory (locked/pinned vm). It's not used for anything else.
-	 */
-	mmgrab(current->mm);
-	ctx->mm_account = current->mm;
-
 	ret = io_allocate_scq_urings(ctx, p);
 	if (ret)
 		goto err;
diff --git a/io_uring/notif.c b/io_uring/notif.c
index c4bb793..0f589fa 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -17,8 +17,8 @@ static void io_notif_complete_tw_ext(struct io_kiocb *notif, bool *locked)
 	if (nd->zc_report && (nd->zc_copied || !nd->zc_used))
 		notif->cqe.res |= IORING_NOTIF_USAGE_ZC_COPIED;
 
-	if (nd->account_pages && ctx->user) {
-		__io_unaccount_mem(ctx->user, nd->account_pages);
+	if (nd->account_pages) {
+		vm_unaccount_pinned(&ctx->vm_account, nd->account_pages);
 		nd->account_pages = 0;
 	}
 	io_req_task_complete(notif, locked);
diff --git a/io_uring/notif.h b/io_uring/notif.h
index c88c800..e2cb44a 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -43,11 +43,9 @@ static inline int io_notif_account_mem(struct io_kiocb *notif, unsigned len)
 	unsigned nr_pages = (len >> PAGE_SHIFT) + 2;
 	int ret;
 
-	if (ctx->user) {
-		ret = __io_account_mem(ctx->user, nr_pages);
-		if (ret)
-			return ret;
-		nd->account_pages += nr_pages;
-	}
+	ret = __io_account_mem(&ctx->vm_account, nr_pages);
+	if (ret)
+		return ret;
+	nd->account_pages += nr_pages;
 	return 0;
 }
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 18de10c..aa44528 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -42,49 +42,19 @@ void io_rsrc_refs_drop(struct io_ring_ctx *ctx)
 	}
 }
 
-int __io_account_mem(struct user_struct *user, unsigned long nr_pages)
+int __io_account_mem(struct vm_account *vm_account, unsigned long nr_pages)
 {
-	unsigned long page_limit, cur_pages, new_pages;
-
-	if (!nr_pages)
-		return 0;
-
-	/* Don't allow more pages than we can safely lock */
-	page_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-
-	cur_pages = atomic_long_read(&user->locked_vm);
-	do {
-		new_pages = cur_pages + nr_pages;
-		if (new_pages > page_limit)
-			return -ENOMEM;
-	} while (!atomic_long_try_cmpxchg(&user->locked_vm,
-					  &cur_pages, new_pages));
-	return 0;
+	return vm_account_pinned(vm_account, nr_pages);
 }
 
 static void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
 {
-	if (ctx->user)
-		__io_unaccount_mem(ctx->user, nr_pages);
-
-	if (ctx->mm_account)
-		atomic64_sub(nr_pages, &ctx->mm_account->pinned_vm);
+	vm_unaccount_pinned(&ctx->vm_account, nr_pages);
 }
 
 static int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
 {
-	int ret;
-
-	if (ctx->user) {
-		ret = __io_account_mem(ctx->user, nr_pages);
-		if (ret)
-			return ret;
-	}
-
-	if (ctx->mm_account)
-		atomic64_add(nr_pages, &ctx->mm_account->pinned_vm);
-
-	return 0;
+	return vm_account_pinned(&ctx->vm_account, nr_pages);
 }
 
 static int io_copy_iov(struct io_ring_ctx *ctx, struct iovec *dst,
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 2b87436..d8833d0 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -167,12 +167,5 @@ static inline u64 *io_get_tag_slot(struct io_rsrc_data *data, unsigned int idx)
 int io_files_update(struct io_kiocb *req, unsigned int issue_flags);
 int io_files_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 
-int __io_account_mem(struct user_struct *user, unsigned long nr_pages);
-
-static inline void __io_unaccount_mem(struct user_struct *user,
-				      unsigned long nr_pages)
-{
-	atomic_long_sub(nr_pages, &user->locked_vm);
-}
-
+int __io_account_mem(struct vm_account *vm_account, unsigned long nr_pages);
 #endif
-- 
git-series 0.9.1
