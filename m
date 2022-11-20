Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70CAD63154D
	for <lists+io-uring@lfdr.de>; Sun, 20 Nov 2022 17:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiKTQ63 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Nov 2022 11:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiKTQ62 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Nov 2022 11:58:28 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44618178B0
        for <io-uring@vger.kernel.org>; Sun, 20 Nov 2022 08:58:27 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id f18so23837880ejz.5
        for <io-uring@vger.kernel.org>; Sun, 20 Nov 2022 08:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=swluOry14rTDh4yFsU4zi4iP0lHsu3KYnQAhJzgV3AM=;
        b=DgSdLG1q0WBTlHsQOWJtGs4DmLdpaZf4rYqJHEheJHhhvOKHaJ4Z+VQmWHenPKTfiI
         oFij1iyJ4ildZrso3UqxVhJBxpJ7iKUzvtceCjeYf/y3BmmMsS540H3MbyQkjoNqt2i6
         6VW0R01pORWGvdlw4n3CcPeDGYiO+/O37jJwcpA5OAmgEn09oMKMmhGAs07sbA6my4B3
         +ww7t6OzqYpASbLdPNnDIQSURjs4nUajxx2CBFIeuE/hNr5rwYA0ckHgJEjZsTszozf8
         Wf23KGfa5q9QicycE9JMZ51jCHG6b1Ykm3k2P77oYoCznAwO31xllSmOdcyOfhWSbTYI
         koHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=swluOry14rTDh4yFsU4zi4iP0lHsu3KYnQAhJzgV3AM=;
        b=NAbKVjZBxrhCvnuIH+6tZHE5wkemg88xbSKdNJoAnGP8J+EDIDQIfgtMNbdd/YyPOK
         od0C/AH9AwMs1//674ieF4s6E57IKS/9UkuWoOsMvLrD9g67aD1TvonPyXYcGDNR1bwI
         EHeEmI2qLonMFGNvYNROp/neHXAR2e+plN3RgZRJk+zNqGkmkVDPTmkBAfTR2V/HFyJn
         P8LqpYu0SN9WQJzVKNBvSXVNJ77bUX24fk9Uz23Nastet3MkGcacRXJ8jCBg5pzPz5fo
         8nQXpCrXigu79dfvZuTGGoX6TcrBHvJoJ5dzzpzer6sstxcLsEYPPJcQn4wX0e4LDNWi
         pjyA==
X-Gm-Message-State: ANoB5plfXAfwjLrWd2DdkecVPPeh5h0UgwoPxBf4c6qRBybZJomeZYDr
        1lkGDscR1UzR4mExlz8zyiaMlTG8sxs=
X-Google-Smtp-Source: AA0mqf4alHUyEJIalAjGodfZhG8M/v7YMGYF9k9mCPKOcSkB8KjGuVcjmw8sHLXqq+aueL8Cyhrr1w==
X-Received: by 2002:a17:906:fc9:b0:7ae:ef99:6fb2 with SMTP id c9-20020a1709060fc900b007aeef996fb2mr12338757ejk.761.1668963505572;
        Sun, 20 Nov 2022 08:58:25 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.224.148.threembb.co.uk. [188.28.224.148])
        by smtp.gmail.com with ESMTPSA id l9-20020a1709060cc900b007b47749838asm1904618ejh.45.2022.11.20.08.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Nov 2022 08:58:25 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Lin Ma <linma@zju.edu.cn>
Subject: [PATCH v3 2/2] io_uring: make poll refs more robust
Date:   Sun, 20 Nov 2022 16:57:42 +0000
Message-Id: <c762bc31f8683b3270f3587691348a7119ef9c9d.1668963050.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1668963050.git.asml.silence@gmail.com>
References: <cover.1668963050.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

poll_refs carry two functions, the first is ownership over the request.
The second is notifying the io_poll_check_events() that there was an
event but wake up couldn't grab the ownership, so io_poll_check_events()
should retry.

We want to make poll_refs more robust against overflows. Instead of
always incrementing it, which covers two purposes with one atomic, check
if poll_refs is elevated enough and if so set a retry flag without
attempts to grab ownership. The gap between the bias check and following
atomics may seem racy, but we don't need it to be strict. Moreover there
might only be maximum 4 parallel updates: by the first and the second
poll entries, __io_arm_poll_handler() and cancellation. From those four,
only poll wake ups may be executed multiple times, but they're protected
by a spin.

Cc: stable@vger.kernel.org
Reported-by: Lin Ma <linma@zju.edu.cn>
Fixes: aa43477b04025 ("io_uring: poll rework")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 1b78b527075d..b444b7d87697 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -40,7 +40,14 @@ struct io_poll_table {
 };
 
 #define IO_POLL_CANCEL_FLAG	BIT(31)
-#define IO_POLL_REF_MASK	GENMASK(30, 0)
+#define IO_POLL_RETRY_FLAG	BIT(30)
+#define IO_POLL_REF_MASK	GENMASK(29, 0)
+
+/*
+ * We usually have 1-2 refs taken, 128 is more than enough and we want to
+ * maximise the margin between this amount and the moment when it overflows.
+ */
+#define IO_POLL_REF_BIAS	128
 
 #define IO_WQE_F_DOUBLE		1
 
@@ -58,6 +65,21 @@ static inline bool wqe_is_double(struct wait_queue_entry *wqe)
 	return priv & IO_WQE_F_DOUBLE;
 }
 
+static bool io_poll_get_ownership_slowpath(struct io_kiocb *req)
+{
+	int v;
+
+	/*
+	 * poll_refs are already elevated and we don't have much hope for
+	 * grabbing the ownership. Instead of incrementing set a retry flag
+	 * to notify the loop that there might have been some change.
+	 */
+	v = atomic_fetch_or(IO_POLL_RETRY_FLAG, &req->poll_refs);
+	if (v & IO_POLL_REF_MASK)
+		return false;
+	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
+}
+
 /*
  * If refs part of ->poll_refs (see IO_POLL_REF_MASK) is 0, it's free. We can
  * bump it and acquire ownership. It's disallowed to modify requests while not
@@ -66,6 +88,8 @@ static inline bool wqe_is_double(struct wait_queue_entry *wqe)
  */
 static inline bool io_poll_get_ownership(struct io_kiocb *req)
 {
+	if (unlikely(atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))
+		return io_poll_get_ownership_slowpath(req);
 	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
 }
 
@@ -235,6 +259,16 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 		 */
 		if ((v & IO_POLL_REF_MASK) != 1)
 			req->cqe.res = 0;
+		if (v & IO_POLL_RETRY_FLAG) {
+			req->cqe.res = 0;
+			/*
+			 * We won't find new events that came in between
+			 * vfs_poll and the ref put unless we clear the flag
+			 * in advance.
+			 */
+			atomic_andnot(IO_POLL_RETRY_FLAG, &req->poll_refs);
+			v &= ~IO_POLL_RETRY_FLAG;
+		}
 
 		/* the mask was stashed in __io_poll_execute */
 		if (!req->cqe.res) {
-- 
2.38.1

