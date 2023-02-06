Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5528C68B6CB
	for <lists+io-uring@lfdr.de>; Mon,  6 Feb 2023 08:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjBFHuz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Feb 2023 02:50:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjBFHup (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Feb 2023 02:50:45 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2083.outbound.protection.outlook.com [40.107.95.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97D11D917;
        Sun,  5 Feb 2023 23:50:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tto6HDLH7veTHgG9SgcxScWU8/ZVYhlCZNpKm0CL8b/NkVFJ7mxrz2j2ozWxv8bhr5B2K6LM7xOgWRgWNgE83eRhzhAwY+TCPDrzbUVLSEAKcZuvxj7+muE8+6a73MJ5f72vKTmzAXnYDfX4Gm7ui0L3mC5QXX/WSpF1xjRqmNU5GG9pLeQU8eZIaiWWgtfjRGfnzpSD/oOe4Ou8wQ3cDlJT0xyb1I/0MWEMRK7WsD82+ClKnPP4EzxVuUoE1pq2m/4oA/4G+DX+3LifWs8opySTBxkUGgc97DVN2yKb0mi8D6OQubT2YkjKL6lBhGVbkZ+9jsKE2YgwKQFtcx9cUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r9iLlWenkXS+qWZNyDxmBNuM9bHSYN74X2PJc4f6L4s=;
 b=US4drmNjS2dMnPKb1UZzmNp7bdWqcuZGJy7ui+bE9RCN2vl9KjlZKq5PzGdzZyPUgw0iX3XjFKFryyzCxHuevZUltMSWyAxyyYctKsi3v91ftLDg5euJbgsQjdVhtf+O87qMSe+qq2Fd2ebTjg7bq6/eBKfAzLpcepPFcNU41TnF8SNc7MjeEqKleRSHxH3/+u4LH/7ixlp4gIvuiSu3Dt4oEyxv2xX54c0zAXpk5was2XHvWeY+05DxeH+5Jmg0OIs7ziHxKAypoD02DJTAwnBOD26i4hejAGPSWGSisg5OFIZBqoWFVrISLlFSUTZnHAkZXMEYxuJQK47fbWwudQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r9iLlWenkXS+qWZNyDxmBNuM9bHSYN74X2PJc4f6L4s=;
 b=Gf8LWJbGXqVUQFIga30K7D5qcFdSDCuAnHvDMezj8AWMzPHRlHJmHv/EgBw3+Pek+2ot4lkY6DzrLks7zPkBQc0mKU7N/HXV7xHUHNFXe/FjnT4ImGnQ26NfbptOrwfbPeylxKJquBK2fUlZUBJFgqjueq6jhj9Ndn42XPKFEL2403dAn3q+H8JGNR3Rc+nAG+Y5bOrcbt7BXB7TdIJhzQDUiESy9IEcx2aKaP9ZQGlk6F2V1Bdp1RfcVhmntk2GLmBchLbVhbgS63AFirVVKjYGHbKotlZw1pKWYxqYi/KkYXUd4gYpnPeE0n5GIN+7ze1yk7KsDLIBPsE4ccatcw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by DM4PR12MB5118.namprd12.prod.outlook.com (2603:10b6:5:391::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Mon, 6 Feb
 2023 07:49:14 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4bd4:de67:b676:67df]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4bd4:de67:b676:67df%6]) with mapi id 15.20.6064.032; Mon, 6 Feb 2023
 07:49:14 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     linux-mm@kvack.org, cgroups@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jgg@nvidia.com, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alistair Popple <apopple@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Subject: [PATCH 09/19] io_uring: convert to use vm_account
Date:   Mon,  6 Feb 2023 18:47:46 +1100
Message-Id: <44e6ead48bc53789191b22b0e140aeb82459e75f.1675669136.git-series.apopple@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SYCPR01CA0027.ausprd01.prod.outlook.com
 (2603:10c6:10:e::15) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|DM4PR12MB5118:EE_
X-MS-Office365-Filtering-Correlation-Id: e6c72ef4-683f-4fab-e4ad-08db0816a3f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W9IdeFq7Vrg8CD9yMMSSYTG9kGqws1YS8W2dUbffEu98uQ1Gi2Z3B6t9juAX1RdjSfZyBFpNzopuwa7jw6/x+SrXzlgcGw8isGBU+2pohoLvR01U9OX+Ml94XuHAHlblXkXIDxOJNoR4EMs4dgN1/tU21Ec4rpCw6qItcq1F4oHigpXlANsPg3/5hihtPXhGCr87JDpK6aUE6t27QIB6WMo+DqLVnxgKoRRBnYpkxcHQzMqmTEyfhuQC7Bm62o8mNGBx1I4JK9Gk1KKbPWKn/yXEaQ1VsO/4kH0WyJiWAAed/zs7hMDmKwjPjBfyOxtgmadSUSKsmjZoLjAgX/t/gbyDEEY4fYHP+okBJlHgb8vJ9Yog/ZuBJOBZ0kx/llNFtslu7PYpIpxrEeLjUaP8OmRe+jecSjMb/fhJUp2NVPG9jON6L7+V00IQdalw6NF21h5uc09+CJCtTBl47kGidM3yohwuB59O61B7TXrDZpEjZmuTgFSzA0IVwnZv1nju7x59YaTOW+XOv3mMSdBN2IBdDVFP2/a7B+h1aIyqnd8nSQggTIsEC7KqiStReFR8h+WtvIgOM/CRTzDJ13AsMoqJNt56/eDzxzmLTnTBRbbmaOldDHcWfsbYpBUNy10hjQQ6rVexiYY6IdMcVHdO7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(366004)(396003)(346002)(136003)(451199018)(66946007)(66476007)(4326008)(41300700001)(8676002)(38100700002)(8936002)(6506007)(6512007)(26005)(316002)(54906003)(7416002)(66556008)(6666004)(5660300002)(478600001)(6486002)(83380400001)(186003)(2616005)(86362001)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sJB/lu8SsYSUOQ3U33wUhkBHtA5BcV+QZ1uLtPiwnJiVJHTZQVsIF6mIvext?=
 =?us-ascii?Q?THE/AK9JGcVBH01l9E0igxUfiaJ1F9CooEZA/oxVGED5x7I2uI+w3gvHdaE0?=
 =?us-ascii?Q?J5CPvKJ49e5AmIXuMJucfkCzoemYHXKJ7YtogPikDfMAVySwYs+4Iuwp8Eun?=
 =?us-ascii?Q?OGxhScOVZgz98aToCyeANKipNjLexBg8RoAOjIs6IU93uLI8r3G1lkIx+SS1?=
 =?us-ascii?Q?A6wUOS5pC+1quwX0EtcS0lE2CoeRV1RWNAz2+Higf8Co3Y904daEpX9B9oaV?=
 =?us-ascii?Q?ua0T0HBASCZzamhLEmCuTR+wRbk080IjRkeaAsGUU//Rmf5LMZTOW+lBsVYu?=
 =?us-ascii?Q?RAd5KEtYxmdSDfftbu7zwId76wzC3wszaXdBDUjqvWJys46gJGIl23LWR150?=
 =?us-ascii?Q?HD+WLtpd4iStikgsKl3sUBIlkgONau7dvNbiCbyUwDYLSrv+aOSy9HTSMVbh?=
 =?us-ascii?Q?QyKnbW0fA45JwuBZB+G8wiVtFlwJ4K6mIk06mvAfq3HEHYKhQXdu66gBEkYC?=
 =?us-ascii?Q?UueVVcwv/daULbcZOSYE3di9UCclnhpf3az3qXX1bYD/tblPtltnz1NIZSza?=
 =?us-ascii?Q?9qStOUhEKyb88Mb0iqFT0+cROULMRDc1X8B5Lt7LqTs12CPYWGNHk4gmuAn+?=
 =?us-ascii?Q?DdQdKS+IwZIC5ZhoTM/NDmpTmi/0+ghuIcUqjkFB4v4o2c8tKExlbnce3caW?=
 =?us-ascii?Q?Ilwxmz0MmPKs2p9Bkucyx0tYJPUmjjeJRMdixdYybMrtITDR8amSkmpAWLq+?=
 =?us-ascii?Q?8+VG82Rn4Xxd6LzZ++Zq8vtiaF1ZHxbuFuHfJD9QbEOsQhiWQNwkdoMai3g5?=
 =?us-ascii?Q?uxcEQl/pyYmzSR6/05IwgIZWbL7RP+H/sWzqFftzBefkZKgM9znPhU/rlp9n?=
 =?us-ascii?Q?J+Jjk2zwgqrFBJRYPB7VQnZGELtveM4YZQGe365Gtd9nLLszNWXudTzPKkjM?=
 =?us-ascii?Q?FzVt6p01+YafFolfyynU1Y3z4oAy9eQv+T7cHb/izOxsG3B6ygKHxooP0OGl?=
 =?us-ascii?Q?GPQssUGVIrlPZ7434g7rpOn6/RubZoQdbP61QRc6P1mmMNMgEvRTj72nidTC?=
 =?us-ascii?Q?yES9CyHkEmhd3m3p5h+5MHHZOBNIdTnynbBpY0upXHOf36MLhbdiAe2k9k/3?=
 =?us-ascii?Q?J+NPSm+UfEaRWERCFs3fSkivY2l4YfjAMSYzexKbpGlNMv7aPhJOWtZe6uFN?=
 =?us-ascii?Q?Y+X0ktTB5RPrx+h40MjrF+S++7HzmkNoY76YxITq2J+yI5HOkx5Pg7gRjCSY?=
 =?us-ascii?Q?X0Vq6UOt+1FTHwg2A7XDBR70/zplgj7nS5aPZHxBoXsZM2soI4plGyNgJox4?=
 =?us-ascii?Q?Yd34JGVDmsfZrc/YLVl8RthC+o/kkLPGl0TPCK4WfGKY64Dd06GewbV/UGwZ?=
 =?us-ascii?Q?KHN+hopKXw07i7KXiNyI7xDy4OhkvU/02Ga2kPahSq9pBIo5lCIlDMD24I3D?=
 =?us-ascii?Q?Hg+ahuAdDGC+B80zYArW1qUR87+23ccG8j7yR/Rl1qBzr92LBFjYneJMdBYJ?=
 =?us-ascii?Q?fpKf9wu2UJYBkHLgLp7/Tgbf7tE8QHf1ExoR3vPzs8QC5QhhK+sHiycjFIpk?=
 =?us-ascii?Q?ctXOxQaJ/SoK4GIRqPrkoA+G1VXwuXoQC509DCGh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6c72ef4-683f-4fab-e4ad-08db0816a3f1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 07:49:13.7304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nCGlYGM5jkLy5MtbClu9G5nINFV9C9n+5uWcbYP52urB5fWT5ZaxjYfStseduUlIEppg6KcFL2431p/aXlfS9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5118
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
 include/linux/io_uring_types.h |  4 ++--
 io_uring/io_uring.c            | 20 +++---------------
 io_uring/notif.c               |  4 ++--
 io_uring/notif.h               | 10 +++------
 io_uring/rsrc.c                | 38 +++--------------------------------
 io_uring/rsrc.h                |  9 +--------
 6 files changed, 17 insertions(+), 68 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 128a67a..45ac75d 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -5,6 +5,7 @@
 #include <linux/task_work.h>
 #include <linux/bitmap.h>
 #include <linux/llist.h>
+#include <linux/vm_account.h>
 #include <uapi/linux/io_uring.h>
 
 struct io_wq_work_node {
@@ -343,8 +344,7 @@ struct io_ring_ctx {
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
