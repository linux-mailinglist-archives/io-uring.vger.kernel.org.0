Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2A76A71CC
	for <lists+io-uring@lfdr.de>; Wed,  1 Mar 2023 18:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjCARF7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Mar 2023 12:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjCARF6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Mar 2023 12:05:58 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD9B43474
        for <io-uring@vger.kernel.org>; Wed,  1 Mar 2023 09:05:56 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id bf15so5643233iob.7
        for <io-uring@vger.kernel.org>; Wed, 01 Mar 2023 09:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1677690355;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lrVme9zUuhM3n0ohg9muamn/zjCrIjyVumbkjbDF958=;
        b=7NzMCtKm13svw5cfMxNr6WfxhqgBhXfiEXNUywZUxOIbdH8uJPoxpAceSTIxh1a4fZ
         9yCcPq4aWV9t8R5kvUY+fueML1GUiFo/470VyanPjxc8aMl5s8RktaFmn91UHKPeoLl5
         rsB/Ql2ZdtLwYJOzSrVIAcvEv5LSpZXAv4fTJGNyp8ZsC2S1BxHzwUUVRD7yXy9DOHhR
         2vp/bH/Ym7g2HRrN3HBXQ1CpiChq9vJ52kkJIirYfmTMKtpfZpoPGK6k3ktqpze3P/1m
         BpZ8sjUxmyHXicsh8tB8tXDufdtz2jfR4LSINKmAnYvj/Fk1QIzzJKW1mGcjd+7b6s9q
         Qjfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677690355;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lrVme9zUuhM3n0ohg9muamn/zjCrIjyVumbkjbDF958=;
        b=ZHspfbBEiVLSWeDSQyWCs4a8uHtJBFDfjuXefY6o3AZyM6pW82lpE4niZASjt6W/GN
         1aHxeVHo5tv87NtA4ofWN0WOt8isCQ7DF6D7m3/R8PorPiBjquExAmKBOsuaAOyLKF/t
         ddX5eeHOVbCoDv/6F5rHSe+cSEkgL62BwSIv9G53jxXML/l1yyQnhbgOugUOVRe9uIvm
         Xvu1rMTMSGDUB+NtZckmMNNH8JNwXTLywpFo41FJYDaWY45QAITkCC1LmOtGWfI51XXj
         BMMqYWbdqni3uie1XE25Y4Nq3Qm+hjLoHqJgkLrLQM/d8Z0/DDOoN0zB9Jqqg1B4PnP3
         jFpw==
X-Gm-Message-State: AO0yUKVjj4rqa4pWa+1w0Cv1RPB9rJ3tVM8IzpVkuTzAG/IVmQlewYVg
        aH5002kzWuhWyet9jlTckEasIo25d1Yl7Z2v
X-Google-Smtp-Source: AK7set8BPMCKUoid1D4gf4m0jMfmFw7CZcqStCQDU+JaohOLJKff5YyFGW0zsUfelcaAapg9Fo3inQ==
X-Received: by 2002:a6b:14c7:0:b0:74c:9cc4:647 with SMTP id 190-20020a6b14c7000000b0074c9cc40647mr5050741iou.1.1677690355419;
        Wed, 01 Mar 2023 09:05:55 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e2-20020a02caa2000000b003c4e1bfbab8sm4047185jap.44.2023.03.01.09.05.54
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 09:05:54 -0800 (PST)
Message-ID: <f7f8fd3e-a810-d9d7-5433-32957e880652@kernel.dk>
Date:   Wed, 1 Mar 2023 10:05:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/poll: don't pass in wake func to io_init_poll_iocb()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We only use one, and it's io_poll_wake(). Hardwire that in the initial
init, as well as in __io_queue_proc() if we're setting up for double
poll.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/poll.c b/io_uring/poll.c
index a82d6830bdfd..795facbd0e9f 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -51,6 +51,9 @@ struct io_poll_table {
 
 #define IO_WQE_F_DOUBLE		1
 
+static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
+			void *key);
+
 static inline struct io_kiocb *wqe_to_req(struct wait_queue_entry *wqe)
 {
 	unsigned long priv = (unsigned long)wqe->private;
@@ -164,15 +167,14 @@ static void io_poll_tw_hash_eject(struct io_kiocb *req, bool *locked)
 	}
 }
 
-static void io_init_poll_iocb(struct io_poll *poll, __poll_t events,
-			      wait_queue_func_t wake_func)
+static void io_init_poll_iocb(struct io_poll *poll, __poll_t events)
 {
 	poll->head = NULL;
 #define IO_POLL_UNMASK	(EPOLLERR|EPOLLHUP|EPOLLNVAL|EPOLLRDHUP)
 	/* mask in events that we always want/need */
 	poll->events = events | IO_POLL_UNMASK;
 	INIT_LIST_HEAD(&poll->wait.entry);
-	init_waitqueue_func_entry(&poll->wait, wake_func);
+	init_waitqueue_func_entry(&poll->wait, io_poll_wake);
 }
 
 static inline void io_poll_remove_entry(struct io_poll *poll)
@@ -508,7 +510,7 @@ static void __io_queue_proc(struct io_poll *poll, struct io_poll_table *pt,
 
 		/* mark as double wq entry */
 		wqe_private |= IO_WQE_F_DOUBLE;
-		io_init_poll_iocb(poll, first->events, first->wait.func);
+		io_init_poll_iocb(poll, first->events);
 		if (!io_poll_double_prepare(req)) {
 			/* the request is completing, just back off */
 			kfree(poll);
@@ -569,7 +571,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 
 	INIT_HLIST_NODE(&req->hash_node);
 	req->work.cancel_seq = atomic_read(&ctx->cancel_seq);
-	io_init_poll_iocb(poll, mask, io_poll_wake);
+	io_init_poll_iocb(poll, mask);
 	poll->file = req->file;
 	req->apoll_events = poll->events;
 
-- 
Jens Axboe

