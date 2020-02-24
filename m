Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33FA116ACA0
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 18:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgBXRG2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 12:06:28 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:35521 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727727AbgBXRG2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 12:06:28 -0500
Received: by mail-il1-f196.google.com with SMTP id g12so8341785ild.2
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 09:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y97+ajHS+f7CTLXW+WxCpRSPWgrtjWvym02w/Sob+dU=;
        b=wD14er7DJhdfyBFM6b30B/EeAE3dGf7edMtz4Up6YZbrXMW2XUsnFXuyWKJuprayhV
         Cqo7NOYjg5xK8H3oPq/c5wZPu6u5xWe/oKD2/fYYg10Fp10+krupb56NyQ4eL3r0SF78
         GvLW5LUsl2vCyIw6VKYSDj+RYQSVjpPHrPdrewr0BqZmSjocN4s1U2TOAqG7ZsCQ6qzE
         i36dQj1R+J2APRUtFG19z3J3oYSe+1QEEWxoUJXuvS9WPtcNTz8OhjMXAykI09aUZ/4I
         I7y6XxfhTBDkf3vGVX4i6jSSZVBtUaaAjpEknIVqak1Bnkm8EArsYasPPC+/vVD0WpVd
         Nuvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y97+ajHS+f7CTLXW+WxCpRSPWgrtjWvym02w/Sob+dU=;
        b=Egmthp33DLJTx37moiaLitQlrPJHAad72NgtAR2YwrF9pmCF2UIze4oQ1GkF2rKYAD
         LMegRRhnAVWElFmCdUaNNrr/WPJQE924dBxN2nyrdrJrg3GLsmvm+emlHjLYkaX3mc+6
         PhaOhfhu7ZReCkX6RVbLs9kjQiDi/qy1Vj55Pzkbza8Jn0Mnrd+5/FON5fuE8N0YeuSh
         R6kHhXLyq03NoXvkgIRkNRByv/3N1rV+LZ6ybSmIua/GRee1DDeyU6xSqwI4bVgqSKae
         2vuR7Nex5hoUjA5LjE1lGHjTJQPvOdojzTa1juNFqubHhqGohQkQRTm9ohXe/765S196
         OvqQ==
X-Gm-Message-State: APjAAAVl5a8CRUm2gVUinHbd9xJ2a1wnSR95Y4ZglaWLFOsblePTc77M
        FTWq39lwZsKIlhs37zsy3V3N8w==
X-Google-Smtp-Source: APXvYqw6qnaiixlVsS+mcmdMK+C1s13q5DNA26sRa0GRvcoBMywBkUorTxC0a6A50OQ68TO+ZiAAMw==
X-Received: by 2002:a92:5e8b:: with SMTP id f11mr43413315ilg.178.1582563985617;
        Mon, 24 Feb 2020 09:06:25 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c15sm1739099ilq.88.2020.02.24.09.06.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 09:06:24 -0800 (PST)
Subject: Re: [PATCH 3/3] io_uring: support buffer selection
From:   Jens Axboe <axboe@kernel.dk>
To:     Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>, andres@anarazel.de
References: <20200224025607.22244-1-axboe@kernel.dk>
 <20200224025607.22244-4-axboe@kernel.dk>
 <CAG48ez2UDoAOnGaVzXkdZGikc+=0mreMD=57LoGf6bG6uRh6hw@mail.gmail.com>
 <cd9960e7-ad0e-826b-b7c4-bcc8001326dd@kernel.dk>
Message-ID: <24522474-986e-892a-1ece-76e28b2b6af1@kernel.dk>
Date:   Mon, 24 Feb 2020 10:06:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <cd9960e7-ad0e-826b-b7c4-bcc8001326dd@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/20 8:57 AM, Jens Axboe wrote:
>> ... and call io_send_recv_buffer_select() from here without holding
>> any extra locks in this function. This function is then called from
>> io_issue_sqe() (no extra locks held there either), which is called
>> from __io_queue_sqe() (no extra locks AFAICS), which is called from
>> places like task work.
>>
>> Am I missing something?
> 
> Submission is all done under the ctx->uring_lock mutex, though the async
> stuff does not. So for the normal path we should all be fine, as we'll
> be serialized for that. We just need to ensure we do buffer select when
> we prep the request for async execution, so the workers never have to do
> it. Either that, or ensure the workers grab the mutex before doing the
> grab (less ideal).
> 
>> It might in general be helpful to have more lockdep assertions in this
>> code, both to help the reader understand the locking rules and to help
>> verify locking correctness.
> 
> Agree, that'd be a good addition.

Tried to cater to both, here's an incremental that ensures we also grab
the uring_lock mutex for the async offload case, and adds lockdep
annotation for this particular case.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index ba8d4e2d9f99..792ef01a521c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2173,7 +2173,7 @@ static ssize_t io_import_fixed(struct io_kiocb *req, int rw,
 }
 
 static struct io_buffer *io_buffer_select(struct io_kiocb *req, int gid,
-					  void *buf)
+					  void *buf, bool needs_lock)
 {
 	struct list_head *list;
 	struct io_buffer *kbuf;
@@ -2181,17 +2181,34 @@ static struct io_buffer *io_buffer_select(struct io_kiocb *req, int gid,
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		return buf;
 
+	/*
+	 * "Normal" inline submissions always hold the uring_lock, since we
+	 * grab it from the system call. Same is true for the SQPOLL offload.
+	 * The only exception is when we've detached the request and issue it
+	 * from an async worker thread, grab the lock for that case.
+	 */
+	if (needs_lock)
+		mutex_lock(&req->ctx->uring_lock);
+
+	lockdep_assert_held(&req->ctx->uring_lock);
+
 	list = idr_find(&req->ctx->io_buffer_idr, gid);
-	if (!list || list_empty(list))
-		return ERR_PTR(-ENOBUFS);
+	if (list && !list_empty(list)) {
+		kbuf = list_first_entry(list, struct io_buffer, list);
+		list_del(&kbuf->list);
+	} else {
+		kbuf = ERR_PTR(-ENOBUFS);
+	}
+
+	if (needs_lock)
+		mutex_unlock(&req->ctx->uring_lock);
 
-	kbuf = list_first_entry(list, struct io_buffer, list);
-	list_del(&kbuf->list);
 	return kbuf;
 }
 
 static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
-			       struct iovec **iovec, struct iov_iter *iter)
+			       struct iovec **iovec, struct iov_iter *iter,
+			       bool needs_lock)
 {
 	void __user *buf = u64_to_user_ptr(req->rw.addr);
 	size_t sqe_len = req->rw.len;
@@ -2215,7 +2232,7 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 			int gid;
 
 			gid = (int) (unsigned long) req->rw.kiocb.private;
-			kbuf = io_buffer_select(req, gid, buf);
+			kbuf = io_buffer_select(req, gid, buf, needs_lock);
 			if (IS_ERR(kbuf)) {
 				*iovec = NULL;
 				return PTR_ERR(kbuf);
@@ -2369,7 +2386,7 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	io = req->io;
 	io->rw.iov = io->rw.fast_iov;
 	req->io = NULL;
-	ret = io_import_iovec(READ, req, &io->rw.iov, &iter);
+	ret = io_import_iovec(READ, req, &io->rw.iov, &iter, !force_nonblock);
 	req->io = io;
 	if (ret < 0)
 		return ret;
@@ -2387,7 +2404,7 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 	size_t iov_count;
 	ssize_t io_size, ret;
 
-	ret = io_import_iovec(READ, req, &iovec, &iter);
+	ret = io_import_iovec(READ, req, &iovec, &iter, !force_nonblock);
 	if (ret < 0)
 		return ret;
 
@@ -2459,7 +2476,7 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	io = req->io;
 	io->rw.iov = io->rw.fast_iov;
 	req->io = NULL;
-	ret = io_import_iovec(WRITE, req, &io->rw.iov, &iter);
+	ret = io_import_iovec(WRITE, req, &io->rw.iov, &iter, !force_nonblock);
 	req->io = io;
 	if (ret < 0)
 		return ret;
@@ -2477,7 +2494,7 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 	size_t iov_count;
 	ssize_t ret, io_size;
 
-	ret = io_import_iovec(WRITE, req, &iovec, &iter);
+	ret = io_import_iovec(WRITE, req, &iovec, &iter, !force_nonblock);
 	if (ret < 0)
 		return ret;
 
@@ -2910,7 +2927,8 @@ static int io_provide_buffer_prep(struct io_kiocb *req,
 	return 0;
 }
 
-static int io_provide_buffer(struct io_kiocb *req, struct io_kiocb **nxt)
+static int io_provide_buffer(struct io_kiocb *req, struct io_kiocb **nxt,
+			     bool force_nonblock)
 {
 	struct io_provide_buf *p = &req->pbuf;
 	struct io_ring_ctx *ctx = req->ctx;
@@ -2918,6 +2936,17 @@ static int io_provide_buffer(struct io_kiocb *req, struct io_kiocb **nxt)
 	struct io_buffer *buf;
 	int ret = 0;
 
+	/*
+	 * "Normal" inline submissions always hold the uring_lock, since we
+	 * grab it from the system call. Same is true for the SQPOLL offload.
+	 * The only exception is when we've detached the request and issue it
+	 * from an async worker thread, grab the lock for that case.
+	 */
+	if (!force_nonblock)
+		mutex_lock(&ctx->uring_lock);
+
+	lockdep_assert_held(&ctx->uring_lock);
+
 	list = idr_find(&ctx->io_buffer_idr, p->gid);
 	if (!list) {
 		list = kmalloc(sizeof(*list), GFP_KERNEL);
@@ -2950,6 +2979,8 @@ static int io_provide_buffer(struct io_kiocb *req, struct io_kiocb **nxt)
 	list_add(&buf->list, list);
 	ret = buf->bid;
 out:
+	if (!force_nonblock)
+		mutex_unlock(&ctx->uring_lock);
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
@@ -3387,14 +3418,15 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 
 static struct io_buffer *io_send_recv_buffer_select(struct io_kiocb *req,
 						    struct io_buffer **kbuf,
-						    int *cflags)
+						    int *cflags,
+						    bool needs_lock)
 {
 	struct io_sr_msg *sr = &req->sr_msg;
 
 	if (!(req->flags & REQ_F_BUFFER_SELECT))
 		return req->sr_msg.buf;
 
-	*kbuf = io_buffer_select(req, sr->gid, sr->kbuf);
+	*kbuf = io_buffer_select(req, sr->gid, sr->kbuf, needs_lock);
 	if (IS_ERR(*kbuf))
 		return *kbuf;
 
@@ -3427,7 +3459,8 @@ static int io_send(struct io_kiocb *req, struct io_kiocb **nxt,
 		void __user *buf;
 		unsigned flags;
 
-		buf = io_send_recv_buffer_select(req, &kbuf, &cflags);
+		buf = io_send_recv_buffer_select(req, &kbuf, &cflags,
+							!force_nonblock);
 		if (IS_ERR(buf)) {
 			ret = PTR_ERR(buf);
 			goto out;
@@ -3592,7 +3625,8 @@ static int io_recv(struct io_kiocb *req, struct io_kiocb **nxt,
 		void __user *buf;
 		unsigned flags;
 
-		buf = io_send_recv_buffer_select(req, &kbuf, &cflags);
+		buf = io_send_recv_buffer_select(req, &kbuf, &cflags,
+							!force_nonblock);
 		if (IS_ERR(buf)) {
 			ret = PTR_ERR(buf);
 			goto out;
@@ -4903,7 +4937,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_provide_buffer(req, nxt);
+		ret = io_provide_buffer(req, nxt, force_nonblock);
 		break;
 	default:
 		ret = -EINVAL;

-- 
Jens Axboe

