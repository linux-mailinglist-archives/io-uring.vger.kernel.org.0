Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAC562E482
	for <lists+io-uring@lfdr.de>; Thu, 17 Nov 2022 19:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240611AbiKQSlA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Nov 2022 13:41:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240553AbiKQSk7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Nov 2022 13:40:59 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73D586A4F
        for <io-uring@vger.kernel.org>; Thu, 17 Nov 2022 10:40:57 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id f18so7331722ejz.5
        for <io-uring@vger.kernel.org>; Thu, 17 Nov 2022 10:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y6Z0SPcVqf6KFw9P518DzIETwXTgw/Rbg1NCnVPBSGc=;
        b=F0sBZcB1JZ7ooxF5YyildTPp2j84kwE2bRoh/Lo6nYGMI6Mcls1/szoRCAQom5VsUc
         uTP2CDcHA9awyEweH0i0VkxvDS5pq/rAVWrhlfmNf6xganTc4gGidoCEFZuwttaCdA30
         gzCoAw4vpLYC19cdW9SGRaImeDBcM4FR0XIUNulWOuIbMiCLXZYLbMIeL2jYwMx8qYe1
         6NE0iaLVjmIIUS2lS5n/OfQXFiFjfxWG7CoNAdmiu3sCGIDyM9Zc4LszFOe48WvbYHJH
         GIauEJaY7M27+WJL63AcyxSz2iv9EqabPrT15DcEE0joN/58ZIvI+db8JYT3tc8O4a1Y
         nFDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y6Z0SPcVqf6KFw9P518DzIETwXTgw/Rbg1NCnVPBSGc=;
        b=Giq/Iofx312Mjk/YOM5FESDrnIuzXPTxzxfDdo96VeIOhGFf/NSf9zuclRNR6Iqqtb
         e7DLfqRyMVa5w5S8bFmQ7C1fF0U5wEq6AwkRlVrxBsUW+u4AfbGvgyl8S+rXrpocWiP8
         FZrlAwsv+yRn6RNEJzfHelOX+VMNqsTubkoQCKrfK+PU8gjD8/FRDx5k4kSIerxfABBK
         Pbzd/g/sZKzyfNpC3S4PsSt4QoZxZHIepIGP1+frJG+H9ZQMwSbcbZ7kSYOWmGHsTZA1
         FlJbFfwp5l9brJlQZoM6erkX9tzgOmnmtH4XqJ3Yi7UswGreNi0v2EfhCkLMzAu1PRc/
         Xihw==
X-Gm-Message-State: ANoB5pmIlIXZv19EcHMOtTEV17RR48pUH2zudB5Yw+EGLz38LCz9JBzG
        UDzF2Yxqm+910CBiuG7qvBjJqm/AisI=
X-Google-Smtp-Source: AA0mqf4HqKX7zg51dJblyaoE77nw4XD9qbIsHPBufc+ZLUY7cR/cVH7uNGLYkbHqc6oUUInRQxqOWg==
X-Received: by 2002:a17:907:98ea:b0:7ae:c1af:89af with SMTP id ke10-20020a17090798ea00b007aec1af89afmr3133502ejc.550.1668710456259;
        Thu, 17 Nov 2022 10:40:56 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.224.148.threembb.co.uk. [188.28.224.148])
        by smtp.gmail.com with ESMTPSA id kx4-20020a170907774400b007838e332d78sm685486ejc.128.2022.11.17.10.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 10:40:55 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-6.1 3/4] io_uring: fix multishot accept request leaks
Date:   Thu, 17 Nov 2022 18:40:16 +0000
Message-Id: <7700ac57653f2823e30b34dc74da68678c0c5f13.1668710222.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1668710222.git.asml.silence@gmail.com>
References: <cover.1668710222.git.asml.silence@gmail.com>
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

Having REQ_F_POLLED set doesn't guarantee that the request is
executed as a multishot from the polling path. Fortunately for us, if
the code thinks it's multishot issue when it's not, it can only ask to
skip completion so leaking the request. Use issue_flags to mark
multipoll issues.

Cc: stable@vger.kernel.org
Fixes: 390ed29b5e425 ("io_uring: add IORING_ACCEPT_MULTISHOT for accept")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring.h | 3 +++
 io_uring/io_uring.c      | 2 +-
 io_uring/io_uring.h      | 4 ++--
 io_uring/net.c           | 7 ++-----
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 43bc8a2edccf..0ded9e271523 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -16,6 +16,9 @@ enum io_uring_cmd_flags {
 	IO_URING_F_SQE128		= 4,
 	IO_URING_F_CQE32		= 8,
 	IO_URING_F_IOPOLL		= 16,
+
+	/* the request is executed from poll, it should not be freed */
+	IO_URING_F_MULTISHOT		= 32,
 };
 
 struct io_uring_cmd {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4a1e482747cc..8840cf3e20f2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1768,7 +1768,7 @@ int io_poll_issue(struct io_kiocb *req, bool *locked)
 	io_tw_lock(req->ctx, locked);
 	if (unlikely(req->task->flags & PF_EXITING))
 		return -EFAULT;
-	return io_issue_sqe(req, IO_URING_F_NONBLOCK);
+	return io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_MULTISHOT);
 }
 
 struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index e99a79f2df9b..cef5ff924e63 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -17,8 +17,8 @@ enum {
 	IOU_ISSUE_SKIP_COMPLETE	= -EIOCBQUEUED,
 
 	/*
-	 * Intended only when both REQ_F_POLLED and REQ_F_APOLL_MULTISHOT
-	 * are set to indicate to the poll runner that multishot should be
+	 * Intended only when both IO_URING_F_MULTISHOT is passed
+	 * to indicate to the poll runner that multishot should be
 	 * removed and the result is set on req->cqe.res.
 	 */
 	IOU_STOP_MULTISHOT	= -ECANCELED,
diff --git a/io_uring/net.c b/io_uring/net.c
index 15dea91625e2..a390d3ea486c 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1289,8 +1289,7 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 			 * return EAGAIN to arm the poll infra since it
 			 * has already been done
 			 */
-			if ((req->flags & IO_APOLL_MULTI_POLLED) ==
-			    IO_APOLL_MULTI_POLLED)
+			if (issue_flags & IO_URING_F_MULTISHOT)
 				ret = IOU_ISSUE_SKIP_COMPLETE;
 			return ret;
 		}
@@ -1315,9 +1314,7 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 		goto retry;
 
 	io_req_set_res(req, ret, 0);
-	if (req->flags & REQ_F_POLLED)
-		return IOU_STOP_MULTISHOT;
-	return IOU_OK;
+	return (issue_flags & IO_URING_F_MULTISHOT) ? IOU_STOP_MULTISHOT : IOU_OK;
 }
 
 int io_socket_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-- 
2.38.1

