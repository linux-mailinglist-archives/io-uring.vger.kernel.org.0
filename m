Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 900985EA983
	for <lists+io-uring@lfdr.de>; Mon, 26 Sep 2022 17:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbiIZPEo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 11:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235824AbiIZPEL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 11:04:11 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E7098D06
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 06:36:21 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id t4so4509069wmj.5
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 06:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=BlWLvM8JQzb2J2hCtIaJ2q7OGFOLh+/VoUp8BBJZ8Jg=;
        b=PYnr+6Xk6SHOsS7XyVRCVDWcJSMdfLdMXTRtRXu1L/9VR/Pd8woi2SZ88Wf9VhmwTi
         oJVaRXDM/BF9pqWJ/k5OdQVcZc3BAoozrXG2zgox60l6otp3YGg51tYTluoVdk+NGWjs
         Jn4xL9y3O7KD41/vte4t/yU2fN8smdQGufr+zN3oQoNUE1HWNi5j30UGl2659sPw4wu5
         rMAZxIrCcCg38rmv+ayZZ3ylFMA7IcjeAP0hgtw6mDkh52JDFWLOj9O6G1FJ8er0mLql
         Pd3UIluzUSqVQhuz8vyGVMc9ga7oCYjfK6nwebOx9sCgz3zWbhm3bcAKTN0y1vFIUvsO
         VBtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=BlWLvM8JQzb2J2hCtIaJ2q7OGFOLh+/VoUp8BBJZ8Jg=;
        b=b1sFJQ1fwYhugHlCT8Rw/YZ402Te2B1/fbzyqAGk0dAA0MHPlMibAeqTalb6U1lFP3
         wjB89hNDSfDwfN+JepzhEobNppcW+bjWT7JVVCPRUN7V36qiRvFd91scYhfaZEFezZcd
         Zxk/azt2r9Y75wfIZxatIHyt2oeRr6wxX9pubPDQMZUE6x+RikK22arQCc/tW2lljUdi
         e13XOzkaNU+Ity205tA9o8eBDIHqaEo8FYQrN+8QxhbLcWgCk+XNekALMCKvsAqKWvxd
         M83Ckdq1d6lXP1gucUDwsIynI0J1nZacQVV7ctK5AWG7TwtH4Uy0odClpP52lIrPOnAS
         17Tw==
X-Gm-Message-State: ACrzQf1ZyQIY4A5+E5lV2346kCNa8y5mubk4CT46RUX7DlUT2lYETIG4
        4Dedx8j6RGzG6hl1tgIumZhlKgO/lns=
X-Google-Smtp-Source: AMsMyM7yTkJTppiNztZfyCe99mOySfkTND53+NHohymR9BqkWWLyTjjB2ujQHx7lOpNAi4CK2xMHgw==
X-Received: by 2002:a05:600c:4e0a:b0:3b4:91fe:80e3 with SMTP id b10-20020a05600c4e0a00b003b491fe80e3mr15151798wmq.91.1664199379320;
        Mon, 26 Sep 2022 06:36:19 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.209.34.threembb.co.uk. [188.28.209.34])
        by smtp.gmail.com with ESMTPSA id g21-20020a05600c4c9500b003b476cabf1csm10937045wmp.26.2022.09.26.06.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 06:36:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        syzbot+edfd15cd4246a3fc615a@syzkaller.appspotmail.com
Subject: [PATCH for-next 1/1] io_uring/net: fix cleanup double free free_iov init
Date:   Mon, 26 Sep 2022 14:35:09 +0100
Message-Id: <f159b763c92ef80496ee6e33457b460f41d88651.1664199279.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
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

Having ->async_data doesn't mean it's initialised and previously we vere
relying on setting F_CLEANUP at the right moment. With zc sendmsg
though, we set F_CLEANUP early in prep when we alloc a notif and so we
may allocate async_data, fail in copy_msg_hdr() leaving
struct io_async_msghdr not initialised correctly but with F_CLEANUP
set, which causes a ->free_iov double free and probably other nastiness.

Always initialise ->free_iov. Also, now it might point to fast_iov when
fails, so avoid freeing it during cleanups.

Reported-by: syzbot+edfd15cd4246a3fc615a@syzkaller.appspotmail.com
Fixes: 493108d95f146 ("io_uring/net: zerocopy sendmsg")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 2af56661590a..6b69eff6887e 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -124,20 +124,22 @@ static struct io_async_msghdr *io_msg_alloc_async(struct io_kiocb *req,
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_cache_entry *entry;
+	struct io_async_msghdr *hdr;
 
 	if (!(issue_flags & IO_URING_F_UNLOCKED) &&
 	    (entry = io_alloc_cache_get(&ctx->netmsg_cache)) != NULL) {
-		struct io_async_msghdr *hdr;
-
 		hdr = container_of(entry, struct io_async_msghdr, cache);
+		hdr->free_iov = NULL;
 		req->flags |= REQ_F_ASYNC_DATA;
 		req->async_data = hdr;
 		return hdr;
 	}
 
-	if (!io_alloc_async_data(req))
-		return req->async_data;
-
+	if (!io_alloc_async_data(req)) {
+		hdr = req->async_data;
+		hdr->free_iov = NULL;
+		return hdr;
+	}
 	return NULL;
 }
 
@@ -192,7 +194,6 @@ int io_send_prep_async(struct io_kiocb *req)
 	io = io_msg_alloc_async_prep(req);
 	if (!io)
 		return -ENOMEM;
-	io->free_iov = NULL;
 	ret = move_addr_to_kernel(zc->addr, zc->addr_len, &io->addr);
 	return ret;
 }
@@ -209,7 +210,6 @@ static int io_setup_async_addr(struct io_kiocb *req,
 	io = io_msg_alloc_async(req, issue_flags);
 	if (!io)
 		return -ENOMEM;
-	io->free_iov = NULL;
 	memcpy(&io->addr, addr_storage, sizeof(io->addr));
 	return -EAGAIN;
 }
@@ -479,7 +479,6 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
 
 		if (msg.msg_iovlen == 0) {
 			sr->len = 0;
-			iomsg->free_iov = NULL;
 		} else if (msg.msg_iovlen > 1) {
 			return -EINVAL;
 		} else {
@@ -490,7 +489,6 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
 			if (clen < 0)
 				return -EINVAL;
 			sr->len = clen;
-			iomsg->free_iov = NULL;
 		}
 
 		if (req->flags & REQ_F_APOLL_MULTISHOT) {
@@ -913,7 +911,9 @@ void io_send_zc_cleanup(struct io_kiocb *req)
 
 	if (req_has_async_data(req)) {
 		io = req->async_data;
-		kfree(io->free_iov);
+		/* might be ->fast_iov if *msg_copy_hdr failed */
+		if (io->free_iov != io->fast_iov)
+			kfree(io->free_iov);
 	}
 	if (zc->notif) {
 		zc->notif->flags |= REQ_F_CQE_SKIP;
-- 
2.37.2

