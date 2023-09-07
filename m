Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 227E17978F4
	for <lists+io-uring@lfdr.de>; Thu,  7 Sep 2023 18:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236287AbjIGQ7c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Sep 2023 12:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243634AbjIGQm5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Sep 2023 12:42:57 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CD61BC9
        for <io-uring@vger.kernel.org>; Thu,  7 Sep 2023 09:41:55 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-52e5900cf77so1591674a12.2
        for <io-uring@vger.kernel.org>; Thu, 07 Sep 2023 09:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694104859; x=1694709659; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MSrZuUeNMuob64GpbHLuDyuPGaYxErAJAjtjCoeRfL0=;
        b=Tsruertx/Cw2zGs0edaRFI3BiFpuMEx3+IZJRAq9k50ntsgn/hNKK9ZflNKnx85qSb
         Jb2MWYo8qZb0CArgpVHMo1oyUQmThSzqmtGJ7K0GIU78tzWzb9zmqlKiDsopJ3E4GBsp
         +9YjVF0XBUlzCMM2TkxDbeUFBWvNV8p/Qw5Rvrosrk1XVxyPbyeU5yFtCbNcf3x1zBJd
         vuxVwx81cIyJqJu56Btkw5NYD1aUI4Bn8iYVJEw9iuFCSzRGZi8SUL5ggfpKR8Uf2f+U
         89Mh+xP4fJIKeyuCb1zcr1el66JCLeILowuyVs+VP083AHHAC2I8o2GzIM1hHv0NJeZ/
         Z9tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694104859; x=1694709659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MSrZuUeNMuob64GpbHLuDyuPGaYxErAJAjtjCoeRfL0=;
        b=MQgcy8xJchNPdt+uPddK8DqYH1YhqSjOTpCv+o6M3ptHQxBUol6hZHL3a5OO5Gk08D
         oJonWdyrQL0aWT2Hihm4002BCpy5Xy9lKb5qC8WfYHf8Q11GB3PRNrbcKMBMxOSYzJKr
         k3+KfcYb8/3ELCUE4HOVzE2t0CwszufKd+3WXA4grP+gbI569Ii0UMcrg85pKJyeus7I
         MRH97396mV0eI5DlK7bhiEP2AiqAFHKdSenxOOxuezSjnQbGAMXdXP2E9yhBH9/6Zxym
         ATWMpZ4QwDr/qhSslFx6SzHhYl1qKwsTXN2yTdasOdiw8jTFz9OVuriDRfD2bgRlYBKs
         UviA==
X-Gm-Message-State: AOJu0YzkSR4rXMualKG5vlp1juJuBuNsjFG2m49DB8K5uaBKVn8fedLA
        DY8rqto7CIy3TLCVUsKNdp47F4PHcX8=
X-Google-Smtp-Source: AGHT+IFZp/xoc6auc0uhRtQNkoA2V+g6WlYajwVPXk2id26mVku3eVwu09eUpbW4F33NLWw7DA531A==
X-Received: by 2002:aa7:d402:0:b0:514:9ab4:3524 with SMTP id z2-20020aa7d402000000b005149ab43524mr4994167edq.7.1694091034410;
        Thu, 07 Sep 2023 05:50:34 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.16])
        by smtp.gmail.com with ESMTPSA id p11-20020a056402074b00b005231e1780aasm9612279edy.91.2023.09.07.05.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Sep 2023 05:50:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/2] io_uring: break out of iowq iopoll on teardown
Date:   Thu,  7 Sep 2023 13:50:07 +0100
Message-ID: <f7d23640756976a5aabb135cd464753b482e767c.1694054436.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1694054436.git.asml.silence@gmail.com>
References: <cover.1694054436.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io-wq will retry iopoll even when it failed with -EAGAIN. If that
races with task exit, which sets TIF_NOTIFY_SIGNAL for all its workers,
such workers might potentially infinitely spin retrying iopoll again and
again and each time failing on some allocation / waiting / etc. Don't
keep spinning if io-wq is dying.

Fixes: 561fb04a6a225 ("io_uring: replace workqueue usage with io-wq")
Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io-wq.c    | 10 ++++++++++
 io_uring/io-wq.h    |  1 +
 io_uring/io_uring.c |  2 ++
 3 files changed, 13 insertions(+)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 62f345587df5..1ecc8c748768 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -174,6 +174,16 @@ static void io_worker_ref_put(struct io_wq *wq)
 		complete(&wq->worker_done);
 }
 
+bool io_wq_worker_stopped(void)
+{
+	struct io_worker *worker = current->worker_private;
+
+	if (WARN_ON_ONCE(!io_wq_current_is_worker()))
+		return true;
+
+	return test_bit(IO_WQ_BIT_EXIT, &worker->wq->state);
+}
+
 static void io_worker_cancel_cb(struct io_worker *worker)
 {
 	struct io_wq_acct *acct = io_wq_get_acct(worker);
diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index 06d9ca90c577..2b2a6406dd8e 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -52,6 +52,7 @@ void io_wq_hash_work(struct io_wq_work *work, void *val);
 
 int io_wq_cpu_affinity(struct io_uring_task *tctx, cpumask_var_t mask);
 int io_wq_max_workers(struct io_wq *wq, int *new_count);
+bool io_wq_worker_stopped(void);
 
 static inline bool io_wq_is_hashed(struct io_wq_work *work)
 {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 88599852af82..4674203c1cac 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1942,6 +1942,8 @@ void io_wq_submit_work(struct io_wq_work *work)
 		if (!needs_poll) {
 			if (!(req->ctx->flags & IORING_SETUP_IOPOLL))
 				break;
+			if (io_wq_worker_stopped())
+				break;
 			cond_resched();
 			continue;
 		}
-- 
2.41.0

