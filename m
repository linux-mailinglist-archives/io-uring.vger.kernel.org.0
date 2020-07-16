Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999D3222CD6
	for <lists+io-uring@lfdr.de>; Thu, 16 Jul 2020 22:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbgGPUaN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jul 2020 16:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgGPUaN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jul 2020 16:30:13 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF29DC061755
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 13:30:12 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id j18so11532942wmi.3
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 13:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=bd5YwfYBnD2e7RFCsF9/crf/aCBJ/H0ho5U0ZLaAiNM=;
        b=AVGKyGEfMxR5VvF14xc6kbWbpaco37IEaj5iiLWkbuIWUJ4VCXpO6vKUwA//THYoOM
         Be6iWV7ITRUDdCk+NVoSfVEDQ18uBEsJPE76C+lCq3Ox5gWn+c9pKqQlfFeuRgJLb8yp
         hT3krOmDbZm6VsPuk/7H4pL36e8fdF87fMF+2/DlfQxym4JQ8rs5gs77H/zDFir136KK
         i9xR/Bzc35/1CEGysgiNsCg3QfU7p3mEfjUCurVfgcL7Y1WwnylyG3jUSUvd2uK0rctS
         DhxLF64XzcHfSKPd/DyueYwKyIle0akNzbCFeIvzfJeNXN4YVUWqqdy3Aya24xe/MSB8
         a6IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bd5YwfYBnD2e7RFCsF9/crf/aCBJ/H0ho5U0ZLaAiNM=;
        b=D+cJRJLkfjfFIOMbifyKYBBdduicMHJZxFIvqMwnbq2AZrg2w92E/aajLbmst+lvm8
         Pw6FQ9t2M/k4S+DFg+4nQNZHkry37UN73ftJRR6R9P03L3y3xlvco7NfC1PXShaixdm3
         GoeLqhXmN2o7LrcVrcQ6Xn2xprc6v+7ok9atF4V3HmQ15e4BPfW04XMuo09/YBm0e8FH
         M9lTWFhTThgABnP58Bd6hto48RlacmM0KmphMb2LlIN3ncwa5ke6NMwZw3Kj71l9H+om
         spGleE6kZBMthrSFQRC2/HRmN0jIQDWNSkAM1VvI4Ll3L663OCoqT0uVF/329laUFtWI
         fmmA==
X-Gm-Message-State: AOAM5335k5ViVnvNqV9lXmt7LzirncsXHAXAVUENK1KOVw1PgjCjaADX
        P5JVXloccCHrnH6yu30BOQA5A7B8wdo=
X-Google-Smtp-Source: ABdhPJzmutzJJVPMLqdt6yW4/Hk0HkLu1JRTdfXSj6c8+diqeiUVb9Z8QYszbHq89HjhSB8ETQXx+w==
X-Received: by 2002:a1c:1b0d:: with SMTP id b13mr5648229wmb.169.1594931411588;
        Thu, 16 Jul 2020 13:30:11 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id v5sm9939823wmh.12.2020.07.16.13.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 13:30:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 7/7] io_uring: don't open-code recv kbuf managment
Date:   Thu, 16 Jul 2020 23:28:05 +0300
Message-Id: <9d0def3d71bba5410dfcb70f409fd4873c858245.1594930020.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594930020.git.asml.silence@gmail.com>
References: <cover.1594930020.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't implement fast path of kbuf free'ing and management
inlined into io_recv{,msg}(), that's error prone and duplicates
handling. Replace it with a helper io_put_recv_kbuf(), which
mimics io_put_rw_kbuf() in the io_read/write().

This also keeps cflags calculation in one place, removing duplication
between rw and recv/send.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c723f15c5463..e4ffb9c3f04d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4101,7 +4101,7 @@ static int io_recvmsg_copy_hdr(struct io_kiocb *req,
 }
 
 static struct io_buffer *io_recv_buffer_select(struct io_kiocb *req,
-					       int *cflags, bool needs_lock)
+					       bool needs_lock)
 {
 	struct io_sr_msg *sr = &req->sr_msg;
 	struct io_buffer *kbuf;
@@ -4112,12 +4112,14 @@ static struct io_buffer *io_recv_buffer_select(struct io_kiocb *req,
 
 	sr->kbuf = kbuf;
 	req->flags |= REQ_F_BUFFER_SELECTED;
-
-	*cflags = kbuf->bid << IORING_CQE_BUFFER_SHIFT;
-	*cflags |= IORING_CQE_F_BUFFER;
 	return kbuf;
 }
 
+static inline unsigned int io_put_recv_kbuf(struct io_kiocb *req)
+{
+	return io_put_kbuf(req, req->sr_msg.kbuf);
+}
+
 static int io_recvmsg_prep(struct io_kiocb *req,
 			   const struct io_uring_sqe *sqe)
 {
@@ -4155,7 +4157,7 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 {
 	struct io_async_msghdr iomsg, *kmsg;
 	struct socket *sock;
-	struct io_buffer *kbuf = NULL;
+	struct io_buffer *kbuf;
 	unsigned flags;
 	int ret, cflags = 0;
 
@@ -4178,7 +4180,7 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 	}
 
 	if (req->flags & REQ_F_BUFFER_SELECT) {
-		kbuf = io_recv_buffer_select(req, &cflags, !force_nonblock);
+		kbuf = io_recv_buffer_select(req, !force_nonblock);
 		if (IS_ERR(kbuf))
 			return PTR_ERR(kbuf);
 		kmsg->fast_iov[0].iov_base = u64_to_user_ptr(kbuf->addr);
@@ -4199,12 +4201,11 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
 
-	if (kbuf)
-		kfree(kbuf);
+	if (req->flags & REQ_F_BUFFER_SELECTED)
+		cflags = io_put_recv_kbuf(req);
 	if (kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
-	req->flags &= ~(REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED);
-
+	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
 		req_set_fail_links(req);
 	__io_req_complete(req, ret, cflags, cs);
@@ -4228,7 +4229,7 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock,
 		return ret;
 
 	if (req->flags & REQ_F_BUFFER_SELECT) {
-		kbuf = io_recv_buffer_select(req, &cflags, !force_nonblock);
+		kbuf = io_recv_buffer_select(req, !force_nonblock);
 		if (IS_ERR(kbuf))
 			return PTR_ERR(kbuf);
 		buf = u64_to_user_ptr(kbuf->addr);
@@ -4257,9 +4258,8 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock,
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
 out_free:
-	if (kbuf)
-		kfree(kbuf);
-	req->flags &= ~REQ_F_NEED_CLEANUP;
+	if (req->flags & REQ_F_BUFFER_SELECTED)
+		cflags = io_put_recv_kbuf(req);
 	if (ret < 0)
 		req_set_fail_links(req);
 	__io_req_complete(req, ret, cflags, cs);
-- 
2.24.0

