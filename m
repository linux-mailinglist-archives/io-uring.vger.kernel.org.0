Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB2F5B1CBD
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 14:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbiIHMWv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 08:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbiIHMWr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 08:22:47 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9C511C178
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 05:22:39 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id bj12so37540269ejb.13
        for <io-uring@vger.kernel.org>; Thu, 08 Sep 2022 05:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=TfGYSpotZEYF5vK2eLSyOzJp4EwTzlwApilpzC9vhkA=;
        b=PWiTxdDfR2FdfN7GGQvtwct7KR7BysxxwSJYzlxv7lvUd5OPlslrRlLIK0nPAKiVVh
         ZnbPifyuu2TpOZ0WT4mKn144O6fMqSsl+Q7+6ywISDxpc1cwR2pPlQnaDqLm57ZSHIcT
         mikwvt65E/rlUexnjUe/qcchLqaVbwshw9MeTK9zDkYjiTOsBPvNg1s8JCFkAQfTgKti
         QkiUmZb/7hNOI38IK1JgzucQmxJZQvnxHufG+SDPGjH6/5qx51T8M5UEVU0u3rttVd6p
         5cl+q2TmY/ob6GOxQIcqQphl5EYrCaoFQ2MAsqPXGzCGzclZiR+bNTkob0IlOU8rkpEt
         /YoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=TfGYSpotZEYF5vK2eLSyOzJp4EwTzlwApilpzC9vhkA=;
        b=kCGDEXinwDuHFls+ht4oUCmH26oyuEjtmswIfgPRmavf0MArYB40cP+0chg628mFLE
         591BFS4+I30q8ELJznnjqr98/HGmmpGbapnE7Lz7EIFDW4FRUSj2yhNEJU/0N9GBVwta
         gpOq7lm3q5C4PA/gbPwkj8KP5sNJJSbF46k7uD2ytWMptxs2ckFDGPWBhhErkdLqHJfC
         5EWZQH3q92BbaWcLdIcF1SJxqEv2YjgFo8O2wgz30TladzOVlfSHeCIzZSLsxvVGzVaJ
         iB9h0I+4Z33DOoX61KsfufNX2AO4UPmAZKIic+BAlP1ijDh9fb2hpoFuoWnovxnW0IhQ
         3K+A==
X-Gm-Message-State: ACgBeo3yLoSXrlUw2GxRX7tFAJFfSSJClTB9AdXfTjKKc378kapjMVi8
        1WuRKqkiFobTCpAkor56/XtVmn1rTqg=
X-Google-Smtp-Source: AA6agR6OsC84dKTCA8zulVu7bFyP/cyhXJPv5mWJapsDU2ol4wpPW1qZlCMX+Yiyml10NsD1d8XqLA==
X-Received: by 2002:a17:907:a422:b0:73f:18a8:4137 with SMTP id sg34-20020a170907a42200b0073f18a84137mr6094427ejc.10.1662639756992;
        Thu, 08 Sep 2022 05:22:36 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:cfb9])
        by smtp.gmail.com with ESMTPSA id p9-20020a17090653c900b0074a82932e3bsm1191791ejo.77.2022.09.08.05.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 05:22:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 3/8] io_uring/net: reshuffle error handling
Date:   Thu,  8 Sep 2022 13:20:29 +0100
Message-Id: <d9059691b30d0963b7269fa4a0c81ee7720555e6.1662639236.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662639236.git.asml.silence@gmail.com>
References: <cover.1662639236.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We should prioritise send/recv retry cases over failures, they're more
important. Shuffle -ERESTARTSYS after we handled retries.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 7047c1342541..0bba804a955d 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -291,13 +291,13 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
 			return io_setup_async_msg(req, kmsg, issue_flags);
-		if (ret == -ERESTARTSYS)
-			ret = -EINTR;
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->done_io += ret;
 			req->flags |= REQ_F_PARTIAL_IO;
 			return io_setup_async_msg(req, kmsg, issue_flags);
 		}
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
 		req_set_fail(req);
 	}
 	/* fast path, check for non-NULL to avoid function call */
@@ -352,8 +352,6 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
 			return -EAGAIN;
-		if (ret == -ERESTARTSYS)
-			ret = -EINTR;
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->len -= ret;
 			sr->buf += ret;
@@ -361,6 +359,8 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 			req->flags |= REQ_F_PARTIAL_IO;
 			return -EAGAIN;
 		}
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
 		req_set_fail(req);
 	}
 	if (ret >= 0)
@@ -751,13 +751,13 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 			}
 			return ret;
 		}
-		if (ret == -ERESTARTSYS)
-			ret = -EINTR;
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->done_io += ret;
 			req->flags |= REQ_F_PARTIAL_IO;
 			return io_setup_async_msg(req, kmsg, issue_flags);
 		}
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
 		req_set_fail(req);
 	} else if ((flags & MSG_WAITALL) && (kmsg->msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
 		req_set_fail(req);
@@ -847,8 +847,6 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 
 			return -EAGAIN;
 		}
-		if (ret == -ERESTARTSYS)
-			ret = -EINTR;
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->len -= ret;
 			sr->buf += ret;
@@ -856,6 +854,8 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 			req->flags |= REQ_F_PARTIAL_IO;
 			return -EAGAIN;
 		}
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
 		req_set_fail(req);
 	} else if ((flags & MSG_WAITALL) && (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
 out_free:
-- 
2.37.2

