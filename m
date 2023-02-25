Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D36C76A2BC2
	for <lists+io-uring@lfdr.de>; Sat, 25 Feb 2023 21:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjBYUxu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Feb 2023 15:53:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBYUxu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Feb 2023 15:53:50 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39ED7D8B
        for <io-uring@vger.kernel.org>; Sat, 25 Feb 2023 12:53:48 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id n2so1401351pfo.12
        for <io-uring@vger.kernel.org>; Sat, 25 Feb 2023 12:53:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vN+WR8+k+IMsUGb3Uu7fIsFhttnqDEhmMfMUeb3cs5U=;
        b=YG5hczmcgtuzd865q+48tNoJfDqwIIFs71BwdI3XZ6J+WySFvJ7o6OWqMjoxUVTdkK
         hcEq1kj3y1HZDlBfXYJSt1zj7/HQjtxk0dYXyy0/gXKVFBjO/Z4shdY5yF9lIqEkaZHZ
         M+UcPeaAXkdHqO55665s5KGdXE/breovrn8udNBEzC4GkWfOPrjtMew9sUXXAn1ndl+t
         a3rKIG/187iXxNXeUpkznJQ+lf54ren7qI/Fak4NTeEpG469S/W/7LMG48yc6m7SQWXQ
         17e2F34yW0RkRyTGwvsW6RhAzLkAUuX2KsZvaWH9p/M64/aZhFNQmybf24KzzoO6yTEm
         x8Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vN+WR8+k+IMsUGb3Uu7fIsFhttnqDEhmMfMUeb3cs5U=;
        b=0v+4PkoCIp6bVMcwu3VBzPnNhiq7uKHmu+osXgQgOPOrO+/sfEJD+2Q1/zcIIRQYYY
         BF6+WiTfMbxj+V0AdqBn5LYlu/O6Qc6swfAXY3TwxVMRWXTIv66wHF7CE5mgJOFwKn+D
         /YDXQ+lCkA7VyabmTVK6qdZiCuPtr8/MJZffTg4mcTfgokdnbryC2BNeutbDjv6SbQMv
         lYDWotK6+lJP+J3k+ntbfwIGX7/yHugP9TkiEKvxd9DnlwFvuoFERlF39nlH8LB+GeNo
         In4jMoS3jAap+VDi5xw+G1NPwMmFB5IQn7clSrsZpJIKa8HjnLMSZ58W9aoh7UHdFlZg
         5zlg==
X-Gm-Message-State: AO0yUKW9AbsSe1AKLN0oW0JeTPCLcW0648O7JyOZG4EIsIdLk4nbKFsl
        8iO+u8U09aQGsLufZI5GpJ8E5sSQmEfj7qc5
X-Google-Smtp-Source: AK7set8tYZCLWhPDkGr3Dmf6spDgrLT6lq67AEMRId/gLEAKh4WJuG6xpJSz+xN9LNKpn69U9wjTxw==
X-Received: by 2002:a05:6a00:1d20:b0:5e4:f141:568b with SMTP id a32-20020a056a001d2000b005e4f141568bmr5470347pfx.3.1677358427727;
        Sat, 25 Feb 2023 12:53:47 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c22-20020a62e816000000b0056bc5ad4862sm1589329pfi.28.2023.02.25.12.53.46
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Feb 2023 12:53:46 -0800 (PST)
Message-ID: <8a746fe0-dd72-568c-e601-19c9192c38fb@kernel.dk>
Date:   Sat, 25 Feb 2023 13:53:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/poll: allow some retries for poll triggering
 spuriously
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

If we get woken spuriously when polling and fail the operation with
-EAGAIN again, then we generally only allow polling again if data
had been transferred at some point. This is indicated with
REQ_F_PARTIAL_IO. However, if the spurious poll triggers when the socket
was originally empty, then we haven't transferred data yet and we will
fail the poll re-arm. This either punts the socket to io-wq if it's
blocking, or it fails the request with -EAGAIN if not. Neither condition
is desirable, as the former will slow things down, while the latter
will make the application confused.

We want to ensure that a repeated poll trigger doesn't lead to infinite
work making no progress, that's what the REQ_F_PARTIAL_IO check was
for. But it doesn't protect against a loop post the first receive, and
it's unnecessarily strict if we started out with an empty socket.

Add a somewhat random retry count, just to put an upper limit on the
potential number of retries that will be done. This should be high enough
that we won't really hit it in practice, unless something needs to be
aborted anyway.

Cc: stable@vger.kernel.org # v5.10+
Link: https://github.com/axboe/liburing/issues/364
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 8339a92b4510..a1d7e8d0b3ac 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -650,6 +650,14 @@ static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
 	__io_queue_proc(&apoll->poll, pt, head, &apoll->double_poll);
 }
 
+/*
+ * We can't reliably detect loops in repeated poll triggers and issue
+ * subsequently failing. But rather than fail these immediately, allow a
+ * certain amount of retries before we give up. Given that this condition
+ * should _rarely_ trigger even once, we should be fine with a larger value.
+ */
+#define APOLL_MAX_RETRY		128
+
 static struct async_poll *io_req_alloc_apoll(struct io_kiocb *req,
 					     unsigned issue_flags)
 {
@@ -665,14 +673,18 @@ static struct async_poll *io_req_alloc_apoll(struct io_kiocb *req,
 		if (entry == NULL)
 			goto alloc_apoll;
 		apoll = container_of(entry, struct async_poll, cache);
+		apoll->poll.retries = 0;
 	} else {
 alloc_apoll:
 		apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
 		if (unlikely(!apoll))
 			return NULL;
+		apoll->poll.retries = 0;
 	}
 	apoll->double_poll = NULL;
 	req->apoll = apoll;
+	if (unlikely(++apoll->poll.retries >= APOLL_MAX_RETRY))
+		return NULL;
 	return apoll;
 }
 
@@ -694,8 +706,6 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 		return IO_APOLL_ABORTED;
 	if (!file_can_poll(req->file))
 		return IO_APOLL_ABORTED;
-	if ((req->flags & (REQ_F_POLLED|REQ_F_PARTIAL_IO)) == REQ_F_POLLED)
-		return IO_APOLL_ABORTED;
 	if (!(req->flags & REQ_F_APOLL_MULTISHOT))
 		mask |= EPOLLONESHOT;
 
diff --git a/io_uring/poll.h b/io_uring/poll.h
index 5f3bae50fc81..b51b9095ecf8 100644
--- a/io_uring/poll.h
+++ b/io_uring/poll.h
@@ -12,6 +12,7 @@ struct io_poll {
 	struct file			*file;
 	struct wait_queue_head		*head;
 	__poll_t			events;
+	unsigned			retries;
 	struct wait_queue_entry		wait;
 };
 
-- 
Jens Axboe

