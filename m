Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0174A7520
	for <lists+io-uring@lfdr.de>; Wed,  2 Feb 2022 17:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237198AbiBBP7r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Feb 2022 10:59:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233587AbiBBP7r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Feb 2022 10:59:47 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3375C06173B
        for <io-uring@vger.kernel.org>; Wed,  2 Feb 2022 07:59:46 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id k18so39264992wrg.11
        for <io-uring@vger.kernel.org>; Wed, 02 Feb 2022 07:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GGdeOsZzuLs+0MhgGI3q1ydhumFVoaDll7p251gfuzY=;
        b=Xo4mJlrO7IZTeUrR8//wRJx2R8eAk2W54lNpkfQiddlaXlHKiRFu+LEQybNTg6zrTg
         TlbC2o4ITIE9Ez9h9cH4nAoWfeLloQMTSraHnIp+8jfXi6Esrukrenblw3nf+BzgKJeg
         CkYZHz8D9Af99nn6ANzXJ7CDcyflZ3+R1qGCFsSWZec9yi0zHshT94cxUYzBWgSAJlVm
         /6rwOH+3d9WWwEhe4JP22kHORcebR/gkl2HXQYyOtlrw1pD9+c7tM++GMdIWKMDDhpkt
         lvWsX/Sv8N4Cr10I+YVJr4IbZnwol1BymWKBEB5QUpPtenqlotOa8wE79XAXWbupYuBr
         /q+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GGdeOsZzuLs+0MhgGI3q1ydhumFVoaDll7p251gfuzY=;
        b=Gg2Y9tVH1nY+loNY2du8L4/oIRqqUOzcYSdHhMsUckX8FGo1+rj3Butu5nfF5EMidA
         FMT3pH4pxNHdc2mip9d9OoYhyB8AoCVj8RZo1gKXycwZ0/H+HXdFr2lM4lM0/3kT49un
         JOhjAjQzNJT9dsnYIxZMT/Ug4qMPw57VrEh/6fUiQjPg18drvh6h88Kfzr6WV5OjTsso
         52gGXg4abF5vLGg6NOmVBpyKgRsMnJiNsxGHqTgew4K5AscSdiEguf/5F4iaKAvwGxxk
         /cc0kV9anTyqM8Y0V9rt7/folEPwZjPO/zHVH9FfY4Aj0Z9y6AqMQg6lQNSorYdOOvof
         9IGA==
X-Gm-Message-State: AOAM532HNHTQkRpngcCvs8C1r3kbnmOAaluQuL8FAGrb9q2MNld+xqXc
        SrGToPRYUwpECDM3LLm9I21sxkBVl+q6Aw==
X-Google-Smtp-Source: ABdhPJxZXCHOAhPWn5VYATQ9ICdHQMcZi0NJlR+lERMtPqUWWayC6PBubeAtzigcUtqgTipxbeMDgw==
X-Received: by 2002:adf:f44a:: with SMTP id f10mr25373533wrp.653.1643817585179;
        Wed, 02 Feb 2022 07:59:45 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6d:f804:0:18da:9567:5ef:1a19])
        by smtp.gmail.com with ESMTPSA id k25sm5374033wms.23.2022.02.02.07.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 07:59:44 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [RFC] io_uring: avoid ring quiesce while registering/unregistering eventfd
Date:   Wed,  2 Feb 2022 15:59:23 +0000
Message-Id: <20220202155923.4117285-1-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Acquire completion_lock at the start of __io_uring_register before
registering/unregistering eventfd and release it at the end. Hence
all calls to io_cqring_ev_posted which adds to the eventfd counter
will finish before acquiring the spin_lock in io_uring_register, and
all new calls will wait till the eventfd is registered. This avoids
ring quiesce which is much more expensive than acquiring the spin_lock.

On the system tested with this patch, io_uring_reigster with
IORING_REGISTER_EVENTFD takes less than 1ms, compared to 15ms before.

Signed-off-by: Usama Arif <usama.arif@bytedance.com>
Reviewed-by: Fam Zheng <fam.zheng@bytedance.com>
---
 fs/io_uring.c | 50 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 16 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2e04f718319d..e75d8abd225a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1803,11 +1803,11 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 			   ctx->rings->sq_flags & ~IORING_SQ_CQ_OVERFLOW);
 	}
 
-	if (posted)
+	if (posted) {
 		io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
-	if (posted)
 		io_cqring_ev_posted(ctx);
+	}
+	spin_unlock(&ctx->completion_lock);
 	return all_flushed;
 }
 
@@ -1971,8 +1971,8 @@ static void io_req_complete_post(struct io_kiocb *req, s32 res,
 	spin_lock(&ctx->completion_lock);
 	__io_req_complete_post(req, res, cflags);
 	io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
+	spin_unlock(&ctx->completion_lock);
 }
 
 static inline void io_req_complete_state(struct io_kiocb *req, s32 res,
@@ -2231,11 +2231,11 @@ static void __io_req_find_next_prep(struct io_kiocb *req)
 
 	spin_lock(&ctx->completion_lock);
 	posted = io_disarm_next(req);
-	if (posted)
+	if (posted) {
 		io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
-	if (posted)
 		io_cqring_ev_posted(ctx);
+	}
+	spin_unlock(&ctx->completion_lock);
 }
 
 static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
@@ -2272,8 +2272,8 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, bool *locked)
 static inline void ctx_commit_and_unlock(struct io_ring_ctx *ctx)
 {
 	io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
+	spin_unlock(&ctx->completion_lock);
 }
 
 static void handle_prev_tw_list(struct io_wq_work_node *node,
@@ -2535,8 +2535,8 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		}
 
 		io_commit_cqring(ctx);
-		spin_unlock(&ctx->completion_lock);
 		io_cqring_ev_posted(ctx);
+		spin_unlock(&ctx->completion_lock);
 		state->flush_cqes = false;
 	}
 
@@ -5541,10 +5541,12 @@ static int io_poll_check_events(struct io_kiocb *req)
 			filled = io_fill_cqe_aux(ctx, req->user_data, mask,
 						 IORING_CQE_F_MORE);
 			io_commit_cqring(ctx);
-			spin_unlock(&ctx->completion_lock);
-			if (unlikely(!filled))
+			if (unlikely(!filled)) {
+				spin_unlock(&ctx->completion_lock);
 				return -ECANCELED;
+			}
 			io_cqring_ev_posted(ctx);
+			spin_unlock(&ctx->completion_lock);
 		} else if (req->result) {
 			return 0;
 		}
@@ -5579,8 +5581,8 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 	hash_del(&req->hash_node);
 	__io_req_complete_post(req, req->result, 0);
 	io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
+	spin_unlock(&ctx->completion_lock);
 }
 
 static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
@@ -8351,8 +8353,8 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 			spin_lock(&ctx->completion_lock);
 			io_fill_cqe_aux(ctx, prsrc->tag, 0, 0);
 			io_commit_cqring(ctx);
-			spin_unlock(&ctx->completion_lock);
 			io_cqring_ev_posted(ctx);
+			spin_unlock(&ctx->completion_lock);
 			io_ring_submit_unlock(ctx, lock_ring);
 		}
 
@@ -9639,11 +9641,11 @@ static __cold bool io_kill_timeouts(struct io_ring_ctx *ctx,
 		}
 	}
 	spin_unlock_irq(&ctx->timeout_lock);
-	if (canceled != 0)
+	if (canceled != 0) {
 		io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
-	if (canceled != 0)
 		io_cqring_ev_posted(ctx);
+	}
+	spin_unlock(&ctx->completion_lock);
 	return canceled != 0;
 }
 
@@ -10970,6 +10972,8 @@ static bool io_register_op_must_quiesce(int op)
 	case IORING_REGISTER_IOWQ_AFF:
 	case IORING_UNREGISTER_IOWQ_AFF:
 	case IORING_REGISTER_IOWQ_MAX_WORKERS:
+	case IORING_REGISTER_EVENTFD:
+	case IORING_UNREGISTER_EVENTFD:
 		return false;
 	default:
 		return true;
@@ -11030,6 +11034,17 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			return -EACCES;
 	}
 
+	/*
+	 * Acquire completion_lock at the start of __io_uring_register before
+	 * registering/unregistering eventfd and release it at the end. Any
+	 * completion events pending before this call will finish before acquiring
+	 * the spin_lock here, and all new completion events will wait till the
+	 * eventfd is registered. This avoids ring quiesce which is much more
+	 * expensive then acquiring spin_lock.
+	 */
+	if (opcode == IORING_REGISTER_EVENTFD || opcode == IORING_UNREGISTER_EVENTFD)
+		spin_lock(&ctx->completion_lock);
+
 	if (io_register_op_must_quiesce(opcode)) {
 		ret = io_ctx_quiesce(ctx);
 		if (ret)
@@ -11141,6 +11156,9 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		break;
 	}
 
+	if (opcode == IORING_REGISTER_EVENTFD || opcode == IORING_UNREGISTER_EVENTFD)
+		spin_unlock(&ctx->completion_lock);
+
 	if (io_register_op_must_quiesce(opcode)) {
 		/* bring the ctx back to life */
 		percpu_ref_reinit(&ctx->refs);
-- 
2.25.1

