Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 928F325B8B8
	for <lists+io-uring@lfdr.de>; Thu,  3 Sep 2020 04:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgICCVK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Sep 2020 22:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbgICCVJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Sep 2020 22:21:09 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1E8C061245
        for <io-uring@vger.kernel.org>; Wed,  2 Sep 2020 19:21:09 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id k15so942844pfc.12
        for <io-uring@vger.kernel.org>; Wed, 02 Sep 2020 19:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9g7RtwVCTrkh9qi8douF+65xnwooZxp22rKnIV2uaeg=;
        b=Cdpcdr8AS28Og/CGhvDpw8XX4gPDuwTCrSkAUY6nWaSsnUevelexF6mBrCohcLnmP+
         ohLjS8BTxx+JjvejJR0VVyczSuxbqP3nhXrB/Y1LOjiJatUCSv2XIu12sX9z2JXHY0Dp
         3dC4+qULJUHGxBBYh3QFCAfz27kOi7L5buT9dBfSZ7cKkWxE9O/dyE7Y+hSyfjj+ByRZ
         QwSarXrj4M/xYx2SfC64MdsM+iYHu3M0UIvEdYqYcqT03ca53rkPfW/XaDtgroViZusy
         A4HgHJChA9YrpWxSxyFrYEBl/58F+Q+wfIDt6lKRlKaMOZXwuwE7wsPYUQcKvCllrKCB
         O6wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9g7RtwVCTrkh9qi8douF+65xnwooZxp22rKnIV2uaeg=;
        b=nAmsoMYdVScJ5m55wNNNsbNKhV5V286lCrK7lZ5XWrpR7J6odYDTAzdX5DjtMLCTI/
         sCd13JOk9be67zTedJ6OavYBtqsMTvh0fAjqZ5IlHTVTVlNCNviY5MFnulGXcNciS8hC
         aT47T7C7x55Y7E5IGatm4JyWYbpdj31GqQI6cv8xlSd2jGiJ232OIU5i7M8qbQQeVssz
         vZtdf8OrjxwG+WCgreAVpfSoT8dqmHBd7T0eqqs5go3vo1MpEeG3o2NWXSxZEzqC00KQ
         P74lu5z6KPh7rrz3w12Ub5yfcy/h1hZXgMdvBhsJaKnbaQ08AZokLGjBfGSlG7gAkXe2
         IwXw==
X-Gm-Message-State: AOAM532dYtGRrLIk8KiPdye+W1n6P/YqT1monPIy9ye534QjOAYyB+bU
        LTjw3mm4O29hAVoANEPXErs8fRodF54crFIS
X-Google-Smtp-Source: ABdhPJziw/HdrXB1p7FtQLuvhAj6UKlznDlSV+BmJppfeP5dCB9wt3e3xQMjb7K+BGizW4YDrH9lSg==
X-Received: by 2002:a62:4d41:: with SMTP id a62mr1448960pfb.234.1599099668337;
        Wed, 02 Sep 2020 19:21:08 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id ie13sm663102pjb.5.2020.09.02.19.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 19:21:07 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 8/8] io_uring: enable IORING_SETUP_ATTACH_WQ to attach to SQPOLL thread too
Date:   Wed,  2 Sep 2020 20:20:53 -0600
Message-Id: <20200903022053.912968-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200903022053.912968-1-axboe@kernel.dk>
References: <20200903022053.912968-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We support using IORING_SETUP_ATTACH_WQ to share async backends between
rings created by the same process, this now also allows the same to
happen with SQPOLL. The setup procedure remains the same, the caller
sets io_uring_params->wq_fd to the 'parent' context, and then the newly
created ring will attach to that async backend.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5bafc7a2c65c..07e16049e62d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -232,6 +232,10 @@ struct io_restriction {
 struct io_sq_data {
 	refcount_t		refs;
 
+	/* global sqd lookup */
+	struct list_head	all_sqd_list;
+	int			attach_fd;
+
 	/* ctx's that are using this sqd */
 	struct list_head	ctx_list;
 	struct list_head	ctx_new_list;
@@ -241,6 +245,9 @@ struct io_sq_data {
 	struct wait_queue_head	wait;
 };
 
+static LIST_HEAD(sqd_list);
+static DEFINE_MUTEX(sqd_lock);
+
 struct io_ring_ctx {
 	struct {
 		struct percpu_ref	refs;
@@ -6975,14 +6982,38 @@ static void io_put_sq_data(struct io_sq_data *sqd)
 			kthread_stop(sqd->thread);
 		}
 
+		mutex_lock(&sqd_lock);
+		list_del(&sqd->all_sqd_list);
+		mutex_unlock(&sqd_lock);
+
 		kfree(sqd);
 	}
 }
 
+static struct io_sq_data *io_attach_sq_data(struct io_uring_params *p)
+{
+	struct io_sq_data *sqd, *ret = ERR_PTR(-ENXIO);
+
+	mutex_lock(&sqd_lock);
+	list_for_each_entry(sqd, &sqd_list, all_sqd_list) {
+		if (sqd->attach_fd == p->wq_fd) {
+			refcount_inc(&sqd->refs);
+			ret = sqd;
+			break;
+		}
+	}
+	mutex_unlock(&sqd_lock);
+
+	return ret;
+}
+
 static struct io_sq_data *io_get_sq_data(struct io_uring_params *p)
 {
 	struct io_sq_data *sqd;
 
+	if (p->flags & IORING_SETUP_ATTACH_WQ)
+		return io_attach_sq_data(p);
+
 	sqd = kzalloc(sizeof(*sqd), GFP_KERNEL);
 	if (!sqd)
 		return ERR_PTR(-ENOMEM);
@@ -6992,6 +7023,10 @@ static struct io_sq_data *io_get_sq_data(struct io_uring_params *p)
 	INIT_LIST_HEAD(&sqd->ctx_new_list);
 	mutex_init(&sqd->ctx_lock);
 	init_waitqueue_head(&sqd->wait);
+
+	mutex_lock(&sqd_lock);
+	list_add_tail(&sqd->all_sqd_list, &sqd_list);
+	mutex_unlock(&sqd_lock);
 	return sqd;
 }
 
@@ -7675,6 +7710,9 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		if (!ctx->sq_thread_idle)
 			ctx->sq_thread_idle = HZ;
 
+		if (sqd->thread)
+			goto done;
+
 		if (p->flags & IORING_SETUP_SQ_AFF) {
 			int cpu = p->sq_thread_cpu;
 
@@ -7701,6 +7739,7 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		goto err;
 	}
 
+done:
 	ret = io_init_wq_offload(ctx, p);
 	if (ret)
 		goto err;
@@ -8831,6 +8870,10 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (ret < 0)
 		goto err;
 
+	if ((ctx->flags & (IORING_SETUP_SQPOLL | IORING_SETUP_ATTACH_WQ)) ==
+	    IORING_SETUP_SQPOLL)
+		ctx->sq_data->attach_fd = ret;
+
 	trace_io_uring_create(ret, ctx, p->sq_entries, p->cq_entries, p->flags);
 	return ret;
 err:
-- 
2.28.0

