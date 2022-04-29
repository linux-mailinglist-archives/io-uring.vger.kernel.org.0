Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B73D4514940
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 14:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359137AbiD2Mbe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 08:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359129AbiD2Mbd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 08:31:33 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6567CC8BED
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 05:28:11 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id n14so125607plf.3
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 05:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L+edS0BhxkaTKfLd0Ao2ma1FeM/nRsP7AEjYtUpwwY4=;
        b=QQ/1dB1nlgq5BIIZdbMQ9zI+zy2XGyZBX5lrYXk0ZIrotsjuO7eykMqtfWo64jPl7i
         FuiKGXQkwistsZSeLdz7sJ0NCWiOAv7l7H2kbopuSt0LpBJAUCsyYMKZsNsiSWsIInHs
         Dod8HjGfqAlpMxFJcZLbVWWgAg3IBy8yk/WZ7n/nJQSKFEY57aAYDrA0NGDTj1oLonRy
         2xdD8Bv+BNpWX9x/D39wbWZGIdbIHfxSCHGqduBcCp+ShYhouQw4fjpISmkTdry6QCfO
         ybwAyDGwlJRrywGDEUwujzQz/rhvVxKNG9b9Zi7mJcdToOwABbxV/RNXtjCuwqR93paM
         fXgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L+edS0BhxkaTKfLd0Ao2ma1FeM/nRsP7AEjYtUpwwY4=;
        b=WVTs37VNuhJBikjHW/JhxKIXDrn46LwlU0Qg+73ahsfEsf0Hf2mNHNccjFSomkmZYE
         8yuYRSAvcebuHmhM+wl1CgeOU8ptpC8CTDQgu6H6HhopByKKEdRa1PzC0/1KJr+33SZp
         8t4pH3C8Ryl8H1kmYdLYavNXZnbNLdt2ZSCxiDNtJMQlCMHmiCmTzp1TZREDVezn0/oO
         Obogb8fb++8/sZqcbuf5Ogtv7IJqvHaXSpsrkg5iXAwFb4frtS9NX+QWz9aaug23SRYw
         HYxii7jnAn3vDTfvrLcoOcExkhzoUt91iH6jSIS09nJW+j0OFmSaQaMddbeaFF2CXcFy
         qATw==
X-Gm-Message-State: AOAM532p6nWJjfedQcUBJzyfJycyWKrbi+/lUIJ6YasVUHLPJhcTtgTQ
        GO6T6J1KL3+xEPNlwSf2jaeGNVEmcQmtpC1T
X-Google-Smtp-Source: ABdhPJwU7tYWPq+Jmp74NsWg782OFcyR3XoTtJuLxd1Oxzxdwfcmhdz4Px8uiFezTsneQAmE9UupqQ==
X-Received: by 2002:a17:902:7884:b0:158:b5b6:572c with SMTP id q4-20020a170902788400b00158b5b6572cmr38879969pll.144.1651235290566;
        Fri, 29 Apr 2022 05:28:10 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o26-20020a629a1a000000b0050d5d7a02b8sm2895837pfe.192.2022.04.29.05.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 05:28:09 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 02/10] io_uring: make io_buffer_select() return the user address directly
Date:   Fri, 29 Apr 2022 06:27:55 -0600
Message-Id: <20220429122803.41101-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220429122803.41101-1-axboe@kernel.dk>
References: <20220429122803.41101-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There's no point in having callers provide a kbuf, we're just returning
the address anyway.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 42 ++++++++++++++++++------------------------
 1 file changed, 18 insertions(+), 24 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 12f61ce429dc..19dfa974ebcf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3571,15 +3571,15 @@ static void io_buffer_add_list(struct io_ring_ctx *ctx,
 	list_add(&bl->list, list);
 }
 
-static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
-					  int bgid, unsigned int issue_flags)
+static void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
+				     int bgid, unsigned int issue_flags)
 {
 	struct io_buffer *kbuf = req->kbuf;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer_list *bl;
 
 	if (req->flags & REQ_F_BUFFER_SELECTED)
-		return kbuf;
+		return u64_to_user_ptr(kbuf->addr);
 
 	io_ring_submit_lock(req->ctx, issue_flags);
 
@@ -3591,25 +3591,18 @@ static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
 			*len = kbuf->len;
 		req->flags |= REQ_F_BUFFER_SELECTED;
 		req->kbuf = kbuf;
-	} else {
-		kbuf = ERR_PTR(-ENOBUFS);
+		io_ring_submit_unlock(req->ctx, issue_flags);
+		return u64_to_user_ptr(kbuf->addr);
 	}
 
 	io_ring_submit_unlock(req->ctx, issue_flags);
-	return kbuf;
+	return ERR_PTR(-ENOBUFS);
 }
 
 static void __user *io_rw_buffer_select(struct io_kiocb *req, size_t *len,
 					unsigned int issue_flags)
 {
-	struct io_buffer *kbuf;
-	u16 bgid;
-
-	bgid = req->buf_index;
-	kbuf = io_buffer_select(req, len, bgid, issue_flags);
-	if (IS_ERR(kbuf))
-		return kbuf;
-	return u64_to_user_ptr(kbuf->addr);
+	return io_buffer_select(req, len, req->buf_index, issue_flags);
 }
 
 #ifdef CONFIG_COMPAT
@@ -5934,7 +5927,6 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_async_msghdr iomsg, *kmsg;
 	struct io_sr_msg *sr = &req->sr_msg;
 	struct socket *sock;
-	struct io_buffer *kbuf;
 	unsigned flags;
 	int ret, min_ret = 0;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
@@ -5953,10 +5945,12 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	if (req->flags & REQ_F_BUFFER_SELECT) {
-		kbuf = io_buffer_select(req, &sr->len, sr->bgid, issue_flags);
-		if (IS_ERR(kbuf))
-			return PTR_ERR(kbuf);
-		kmsg->fast_iov[0].iov_base = u64_to_user_ptr(kbuf->addr);
+		void __user *buf;
+
+		buf = io_buffer_select(req, &sr->len, sr->bgid, issue_flags);
+		if (IS_ERR(buf))
+			return PTR_ERR(buf);
+		kmsg->fast_iov[0].iov_base = buf;
 		kmsg->fast_iov[0].iov_len = req->sr_msg.len;
 		iov_iter_init(&kmsg->msg.msg_iter, READ, kmsg->fast_iov,
 				1, req->sr_msg.len);
@@ -5999,7 +5993,6 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_buffer *kbuf;
 	struct io_sr_msg *sr = &req->sr_msg;
 	struct msghdr msg;
 	void __user *buf = sr->buf;
@@ -6014,10 +6007,11 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 		return -ENOTSOCK;
 
 	if (req->flags & REQ_F_BUFFER_SELECT) {
-		kbuf = io_buffer_select(req, &sr->len, sr->bgid, issue_flags);
-		if (IS_ERR(kbuf))
-			return PTR_ERR(kbuf);
-		buf = u64_to_user_ptr(kbuf->addr);
+		void __user *buf;
+
+		buf = io_buffer_select(req, &sr->len, sr->bgid, issue_flags);
+		if (IS_ERR(buf))
+			return PTR_ERR(buf);
 	}
 
 	ret = import_single_range(READ, buf, sr->len, &iov, &msg.msg_iter);
-- 
2.35.1

