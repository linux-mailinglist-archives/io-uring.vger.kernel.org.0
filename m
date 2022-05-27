Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8E753663D
	for <lists+io-uring@lfdr.de>; Fri, 27 May 2022 18:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243542AbiE0Q7x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 May 2022 12:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240823AbiE0Q7w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 May 2022 12:59:52 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5905122B57
        for <io-uring@vger.kernel.org>; Fri, 27 May 2022 09:59:50 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id j15so3469674ilo.5
        for <io-uring@vger.kernel.org>; Fri, 27 May 2022 09:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:cc:content-transfer-encoding;
        bh=P99tpbGRsmjzVaw5Qg8oN9jqoiIKjuvZTVLQshwhi7c=;
        b=7J9qcNvvM82ulQtnSOtqC0tEsCZPuPeoomTJZp5PbWEFP3/eQr+M2v5hxoCmqG1gqG
         0gJ8Qag7M0Sgg5zi+xSKo2MHPXtFlYzgZZG87s5ZaHimNCNMPxNgZMJtAnSCkELZ5aEH
         VzaRxTVwOn2ODK4wXSP7XNg2CLLeqfTOxCE36yxx0GeHpWRX9ZJNKzN87id4xsKvx41+
         4CIqeYn35vNv9aH8+QZ+/gOBhYCm8WpvIys8YKHdxYYanodOl+yEGIotkZrtR0lONKe2
         sGLPh858qljq5AGMGsidcxAxEIQEWDxdsiHEbuDeoGAAZABeKFUwNSEf9evwPUn21Vgg
         GN6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:cc:content-transfer-encoding;
        bh=P99tpbGRsmjzVaw5Qg8oN9jqoiIKjuvZTVLQshwhi7c=;
        b=cDVfCiFYQEg+XGlMrGADvte8L/GXMZjk/Ul95bxuvP/mVBSjcLBMjnAlsTfZs1184+
         FO0IEF+0SXuKVjIq4kfjSauUSxugUQs4D+RuC2iJmVuid5QvZHcgf8CyquyzbxTk4p6I
         yskRATwLiaphHBSCDDjOVl00OZUkAYxOMr5U4Ju3j4U5lp0gaynj1D4zkBRvbUZ590tu
         YrXXiJqd40K/eX48x17wAdccDg9N9tyujaholiwFkBySAeEWl7ALOImqfP9DHX09c24v
         PQW+M7eh7v2fBS04fPJwVcP1bydxi7MVr4rBf6KwvKduD8AbnPVNOa/NcRMU/hkgRxyM
         kstw==
X-Gm-Message-State: AOAM532J6+gVC4/mNx0TQbfAz4w0NDFnoqvpOVPJwvOrjt6Snwog7w2I
        bpsid2nQWi7vmZ5LyCAC/oH2ehEBgX++ig==
X-Google-Smtp-Source: ABdhPJx2HqR6aSwfpxcIMytWA+0tlELA2UBh1j4K83OpCwNEmJCY9uGtbZfINPEvrbKxXPLe7MYuJg==
X-Received: by 2002:a92:2c11:0:b0:2d0:e874:636 with SMTP id t17-20020a922c11000000b002d0e8740636mr22967562ile.318.1653670789981;
        Fri, 27 May 2022 09:59:49 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b18-20020a92a052000000b002cc20b48163sm1427763ilm.3.2022.05.27.09.59.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 May 2022 09:59:49 -0700 (PDT)
Message-ID: <d97a5792-aeef-7303-6b3d-9fae18fc46c8@kernel.dk>
Date:   Fri, 27 May 2022 10:59:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH RFC -next] io_uring: add support for level triggered poll
Cc:     Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

By default, the POLL_ADD command does edge triggered poll - if we get
a non-zero mask on the initial poll attempt, we complete the request
successfully.

Support level triggered by always waiting for a notification, regardless
of whether or not the initial mask matches the file state.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Wrote a test case and it seems to work as it should, and the usual
regressions pass as well.

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 53e7dae92e42..1d176f935f5d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -226,10 +226,13 @@ enum io_uring_op {
  *
  * IORING_POLL_UPDATE		Update existing poll request, matching
  *				sqe->addr as the old user_data field.
+ *
+ * IORING_POLL_LEVEL		Level triggered poll.
  */
 #define IORING_POLL_ADD_MULTI	(1U << 0)
 #define IORING_POLL_UPDATE_EVENTS	(1U << 1)
 #define IORING_POLL_UPDATE_USER_DATA	(1U << 2)
+#define IORING_POLL_ADD_LEVEL		(1U << 3)
 
 /*
  * ASYNC_CANCEL flags.
diff --git a/io_uring/poll.c b/io_uring/poll.c
index ed9f74403d89..7a98d934428e 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -425,11 +425,13 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 	atomic_set(&req->poll_refs, 1);
 	mask = vfs_poll(req->file, &ipt->pt) & poll->events;
 
-	if (mask && (poll->events & EPOLLONESHOT)) {
+	if (mask &&
+	   ((poll->events & (EPOLLET|EPOLLONESHOT)) == (EPOLLET|EPOLLONESHOT))) {
 		io_poll_remove_entries(req);
 		/* no one else has access to the req, forget about the ref */
 		return mask;
 	}
+
 	if (!mask && unlikely(ipt->error || !ipt->nr_entries)) {
 		io_poll_remove_entries(req);
 		if (!ipt->error)
@@ -441,7 +443,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 	io_poll_req_insert(req);
 	spin_unlock(&ctx->completion_lock);
 
-	if (mask) {
+	if (mask && (poll->events & EPOLLET)) {
 		/* can't multishot if failed, just queue the event we've got */
 		if (unlikely(ipt->error || !ipt->nr_entries))
 			poll->events |= EPOLLONESHOT;
@@ -474,7 +476,7 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
-	__poll_t mask = POLLPRI | POLLERR;
+	__poll_t mask = POLLPRI | POLLERR | EPOLLET;
 	int ret;
 
 	if (!def->pollin && !def->pollout)
@@ -636,7 +638,10 @@ static __poll_t io_poll_parse_events(const struct io_uring_sqe *sqe,
 #endif
 	if (!(flags & IORING_POLL_ADD_MULTI))
 		events |= EPOLLONESHOT;
-	return demangle_poll(events) | (events & (EPOLLEXCLUSIVE|EPOLLONESHOT));
+	if (!(flags & IORING_POLL_ADD_LEVEL))
+		events |= EPOLLET;
+	return demangle_poll(events) |
+		(events & (EPOLLEXCLUSIVE|EPOLLONESHOT|EPOLLET));
 }
 
 int io_poll_remove_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -677,7 +682,7 @@ int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (sqe->buf_index || sqe->off || sqe->addr)
 		return -EINVAL;
 	flags = READ_ONCE(sqe->len);
-	if (flags & ~IORING_POLL_ADD_MULTI)
+	if (flags & ~(IORING_POLL_ADD_MULTI|IORING_POLL_ADD_LEVEL))
 		return -EINVAL;
 	if ((flags & IORING_POLL_ADD_MULTI) && (req->flags & REQ_F_CQE_SKIP))
 		return -EINVAL;

-- 
Jens Axboe

