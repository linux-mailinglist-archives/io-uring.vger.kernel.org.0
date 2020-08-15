Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200D32453AA
	for <lists+io-uring@lfdr.de>; Sun, 16 Aug 2020 00:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbgHOVvD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Aug 2020 17:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728483AbgHOVuy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Aug 2020 17:50:54 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B7EC004596
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 11:49:34 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id h12so6062948pgm.7
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 11:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ypW/qp3EFS6XvMcsSvKo5xeBkyB36mGGU5opoB45HhI=;
        b=sjznKTDikuDyjiBMbjnEsvBVQ9LyYKthtpiDG3rS1ISXD4jwidCvlnnqto3vDDbVBC
         7XN4ZS3IsUXf8TvrGfOzNWg0hO/2P54m2Zoa9tSLPYg5fxZNt5olqT18FTJwTUvgOm65
         AT4SvzkT/oeHJVkWr+XCTC2wFHlGgXhog+MlHWYftxsrAhuRok8uYiYS3N4FNXbwx/xQ
         onXaXPCsCIq8qqJq+Kw72+rQw9cjmvjw3MWKOKTGlnC59GsatnHOdAJspn1F4nwirLHT
         xpl+QS4fyDDvM/HwTKLTG88iqJxGvqWzLrFtDJep3wNm73o9cfdXLdqpeHoErkG3mpwJ
         YDpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ypW/qp3EFS6XvMcsSvKo5xeBkyB36mGGU5opoB45HhI=;
        b=mLcI5IVEnIjp/W0suPxFkx/VrCr1tF98jS8XEuQIVpyyEtCW+HzhP5+VJTFYJ6Xqmc
         hMdCjK5TOFQyzC3XgU6MS46wfpo1zO5A38jtqxEomxtewPvyquSFutbNPKoVRyVgQgZP
         V5h3GZz7RitgE61SqTQLJ0kC2UhYRYMFh1z4l/9THwbp6aAJx6yuBEw+EsYb+hfWp0lk
         o47nkoVS/sCrRF5O2giBC3c2WlSPNLDLlsLMfts4/y7Dwlly1cZ1jbdf5iSjYYgsg/IH
         Xjm9wvB+TRc9GDZN77tuPt/Ls0RY06Nn9ciwsxDbp5IqPmzJ4uB2wtaooO7jlVs6H5Qr
         pV8Q==
X-Gm-Message-State: AOAM533yFfTJ33re1mAcMrY9l7hsm0s1luLJznOmjYldm2KDnbfULg8p
        Ph1tis3Syc6lGK3W/5w49tsilPlk91jG+A==
X-Google-Smtp-Source: ABdhPJxeG8Xp8nBmGNCGMx5Zb8nrJTVFQ8aOJorZXfWkzhr4taeltW3t4PSWEptVDBXlbC3ejTo3vQ==
X-Received: by 2002:aa7:9d85:: with SMTP id f5mr6047693pfq.218.1597517373776;
        Sat, 15 Aug 2020 11:49:33 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:6299:2df1:e468:6351? ([2605:e000:100e:8c61:6299:2df1:e468:6351])
        by smtp.gmail.com with ESMTPSA id r77sm13020672pfc.193.2020.08.15.11.49.32
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Aug 2020 11:49:33 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: sanitize double poll handling
Message-ID: <94e050ea-ab3d-3ebf-4ecc-e7ce7f376219@kernel.dk>
Date:   Sat, 15 Aug 2020 11:49:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There's a bit of confusion on the matching pairs of poll vs double poll,
depending on if the request is a pure poll (IORING_OP_POLL_ADD) or
poll driven retry.

Add io_poll_get_double() that returns the double poll waitqueue, if any,
and io_poll_get_single() that returns the original poll waitqueue. With
that, remove the argument to io_poll_remove_double().

Finally ensure that wait->private is cleared once the double poll handler
has run, so that remove knows it's already been seen.

Cc: stable@vger.kernel.org # v5.8
Reported-by: syzbot+7f617d4a9369028b8a2c@syzkaller.appspotmail.com
Fixes: 18bceab101ad ("io_uring: allow POLL_ADD with double poll_wait() users")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7dd6df15bc49..cb030912bf5e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4649,9 +4649,24 @@ static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
 	return false;
 }
 
-static void io_poll_remove_double(struct io_kiocb *req, void *data)
+static struct io_poll_iocb *io_poll_get_double(struct io_kiocb *req)
 {
-	struct io_poll_iocb *poll = data;
+	/* pure poll stashes this in ->io, poll driven retry elsewhere */
+	if (req->opcode == IORING_OP_POLL_ADD)
+		return (struct io_poll_iocb *) req->io;
+	return req->apoll->double_poll;
+}
+
+static struct io_poll_iocb *io_poll_get_single(struct io_kiocb *req)
+{
+	if (req->opcode == IORING_OP_POLL_ADD)
+		return &req->poll;
+	return &req->apoll->poll;
+}
+
+static void io_poll_remove_double(struct io_kiocb *req)
+{
+	struct io_poll_iocb *poll = io_poll_get_double(req);
 
 	lockdep_assert_held(&req->ctx->completion_lock);
 
@@ -4671,7 +4686,7 @@ static void io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	io_poll_remove_double(req, req->io);
+	io_poll_remove_double(req);
 	req->poll.done = true;
 	io_cqring_fill_event(req, error ? error : mangle_poll(mask));
 	io_commit_cqring(ctx);
@@ -4711,7 +4726,7 @@ static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
 			       int sync, void *key)
 {
 	struct io_kiocb *req = wait->private;
-	struct io_poll_iocb *poll = req->apoll->double_poll;
+	struct io_poll_iocb *poll = io_poll_get_single(req);
 	__poll_t mask = key_to_poll(key);
 
 	/* for instances that support it check for an event match first: */
@@ -4725,6 +4740,8 @@ static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
 		done = list_empty(&poll->wait.entry);
 		if (!done)
 			list_del_init(&poll->wait.entry);
+		/* make sure double remove sees this as being gone */
+		wait->private = NULL;
 		spin_unlock(&poll->head->lock);
 		if (!done)
 			__io_async_wake(req, poll, mask, io_poll_task_func);
@@ -4808,7 +4825,7 @@ static void io_async_task_func(struct callback_head *cb)
 	if (hash_hashed(&req->hash_node))
 		hash_del(&req->hash_node);
 
-	io_poll_remove_double(req, apoll->double_poll);
+	io_poll_remove_double(req);
 	spin_unlock_irq(&ctx->completion_lock);
 
 	if (!READ_ONCE(apoll->poll.canceled))
@@ -4919,7 +4936,7 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
 					io_async_wake);
 	if (ret || ipt.error) {
-		io_poll_remove_double(req, apoll->double_poll);
+		io_poll_remove_double(req);
 		spin_unlock_irq(&ctx->completion_lock);
 		kfree(apoll->double_poll);
 		kfree(apoll);
@@ -4951,14 +4968,13 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 {
 	bool do_complete;
 
+	io_poll_remove_double(req);
+
 	if (req->opcode == IORING_OP_POLL_ADD) {
-		io_poll_remove_double(req, req->io);
 		do_complete = __io_poll_remove_one(req, &req->poll);
 	} else {
 		struct async_poll *apoll = req->apoll;
 
-		io_poll_remove_double(req, apoll->double_poll);
-
 		/* non-poll requests have submit ref still */
 		do_complete = __io_poll_remove_one(req, &apoll->poll);
 		if (do_complete) {
-- 
2.28.0

-- 
Jens Axboe

