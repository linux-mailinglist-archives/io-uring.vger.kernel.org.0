Return-Path: <io-uring+bounces-8065-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0234AABF812
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 16:43:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 915FC9E27F9
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 14:42:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECAC71E32D3;
	Wed, 21 May 2025 14:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="21Cyo8U0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EF41DE2C2
	for <io-uring@vger.kernel.org>; Wed, 21 May 2025 14:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747838543; cv=none; b=fZENYcEpgJhzkrRbBm3Q2djwK6tCtvGH83pblcoyK+9N5kz7ix/34dW4CXq5wdDxKEUygV/DceLwy19AAqRirRb5EqSMrflMjZF6FMtWGhXmC0Bt/cIBxVGT35oIkWtRKuzyCA+d4SuXoA1qRam5beaK26ZzdZeZF2a0FyoBSWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747838543; c=relaxed/simple;
	bh=s5RI1cAlOSZTK574+W6Xa+p07W3JxDuPCdEjP7bKNEk=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=XlZVHSsyvaQ0SAgtBhWkyspOVj273GmfcabN7B0IJBRjUnpuvXaInMWj7uNxNHVRWmm6CQg0cM6WJIXoJtIMTxi9Q3wV/7FVbquM5BrBDuq+mnV8Ukns7VHH85+iv4jpDRCJWmaUJZehkzkE91FMrwalda6qcWKhwdEczGRXBCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=21Cyo8U0; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-85d9a87660fso819688939f.1
        for <io-uring@vger.kernel.org>; Wed, 21 May 2025 07:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747838538; x=1748443338; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3QUznESCoUfjwF/oxPY0mh13Pp/1QOa5I1E14bv7WP4=;
        b=21Cyo8U0kk2VKfwf2m2LBqE8O7GvaZNuX+PbTKO+R3f8NgXVzomi4nKXyiYkbqetx3
         L2DzeEXvxiBgzG477tufBV7iU5tMgLadDTDt9gJxs7GlUkZagks3mfsC8IL84Z/oseTl
         dd25G/Ip3v48rqiLHWxfBryxawulHKaAm/b4mppJn6U9p/Ipz/1Gi3r09OSIwU/Jv2vV
         0Y/BuWxKiezwIHcXL3dvNYUnpbyQHpTts5f2MPxcEmdViIh9jgBgXwM7t8puJNZjFnQx
         6ZtqLBjvMbRstE87N/MBCmnAoAucmwZpLktofB0uC5jOgVeGpA5AmOLm/7xuqeuC77PL
         X6mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747838538; x=1748443338;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3QUznESCoUfjwF/oxPY0mh13Pp/1QOa5I1E14bv7WP4=;
        b=Neew7s59ztPe3SCmfZs/+hN/+RZ8gBGZS4Orrk9GqEz8Aa/ZYeT8SqlXV3sAZamcp6
         5zBF2hvdLl+xRxdYfnqdx96i3cxP19ExXT3m/bdLpqbc20A9wJMGn4Kh+uphqQ0NaX+v
         /L+LBihCo1emkuFKLNIOi8qdpg1mmHVAgzbzE8+LemEB1eJRqRL0rUSZgdHsZa/svPuQ
         UKl2pa+1yI/rT70xKkHvupG9rVDfBWjtDmdpoNtyAkYLI6cEJq/rPWaH7Oj4H+ant3EY
         Sc5RhDsgIQgTtTJ+g8QGaOolKcm1+YcG0OvriEW2+sxfNKUayxjSLgBTzQIaK12/A9Rc
         gU+Q==
X-Gm-Message-State: AOJu0YyQ+C+pqL1Yhz8Qxtk3gxNolItQsvfORkkqvA5ecZh2wdyTKq2V
	yhzN6vD7a5uPIE9C2PsyJnwCivoUzIjsvbZftGw8n97ouU8Pn6zgLVYN6QaR9O9qY7DAyZtBgWH
	Yht/F
X-Gm-Gg: ASbGnct6GlJ4WdOKCE5Mx03awoOn7t34lpT7ybxAgyXj2TGhU7LfYwhWIGY1LNdHH3y
	FBcyhN3lHFn9KDwMP2tZDmXuakitVa5T6F9VHO94fmXWx0AGFEMWLWBKSa4gAGVKSlmnZO6qxAy
	6r5HqDQB2oMK3cwxQrv0+Dix+H0qLEsgg4eqioZgzhddMLB8qFy2BSwNgYTI2mZtdM73pU5TSAi
	+mVZ1LdGgdIF34Z+mitP7FksonGYNZoGBg/fg8V/QKtDfwMztprWeK9iHyELVnNwncQ1YPJBN7+
	CFBj7qrx1qgWeXOs6mRBWFtJx77tdSNvzTiZzXhgy2YUO4Y=
X-Google-Smtp-Source: AGHT+IFjKQR5A1GNmhlm8aBPvZ2vyCFl+Au3LNKqF02ZTAdgNpXSbjzcQxoHGCibfVpciwX+tD/wWg==
X-Received: by 2002:a05:6602:6a46:b0:861:d8ca:3587 with SMTP id ca18e2360f4ac-86a24bdc7f8mr3060572439f.4.1747838538136;
        Wed, 21 May 2025 07:42:18 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc38a365sm2755204173.18.2025.05.21.07.42.17
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 07:42:17 -0700 (PDT)
Message-ID: <1a5ae53f-a54e-462e-b9d7-58ed2a6d8818@kernel.dk>
Date: Wed, 21 May 2025 08:42:17 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: finish IOU_OK -> IOU_COMPLETE transition
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

IOU_COMPLETE is more descriptive, in that it explicitly says that the
return value means "please post a completion for this request". This
patch completes the transition from IOU_OK to IOU_COMPLETE, replacing
existing IOU_OK users.

This is a purely mechanical change.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Thought I had posted this one a few weeks ago when I did it, but I had
not. Let's finish this one up, don't like letting these things linger.

diff --git a/io_uring/advise.c b/io_uring/advise.c
index cb7b881665e5..0073f74e3658 100644
--- a/io_uring/advise.c
+++ b/io_uring/advise.c
@@ -58,7 +58,7 @@ int io_madvise(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = do_madvise(current->mm, ma->addr, ma->len, ma->advice);
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 #else
 	return -EOPNOTSUPP;
 #endif
@@ -104,5 +104,5 @@ int io_fadvise(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 0870060bac7c..6d57602304df 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -229,7 +229,7 @@ int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 static int __io_sync_cancel(struct io_uring_task *tctx,
diff --git a/io_uring/epoll.c b/io_uring/epoll.c
index 6d2c48ba1923..8d4610246ba0 100644
--- a/io_uring/epoll.c
+++ b/io_uring/epoll.c
@@ -61,7 +61,7 @@ int io_epoll_ctl(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 int io_epoll_wait_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -88,5 +88,5 @@ int io_epoll_wait(struct io_kiocb *req, unsigned int issue_flags)
 		req_set_fail(req);
 
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
diff --git a/io_uring/fs.c b/io_uring/fs.c
index eccea851dd5a..37079a414eab 100644
--- a/io_uring/fs.c
+++ b/io_uring/fs.c
@@ -90,7 +90,7 @@ int io_renameat(struct io_kiocb *req, unsigned int issue_flags)
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 void io_renameat_cleanup(struct io_kiocb *req)
@@ -141,7 +141,7 @@ int io_unlinkat(struct io_kiocb *req, unsigned int issue_flags)
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 void io_unlinkat_cleanup(struct io_kiocb *req)
@@ -185,7 +185,7 @@ int io_mkdirat(struct io_kiocb *req, unsigned int issue_flags)
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 void io_mkdirat_cleanup(struct io_kiocb *req)
@@ -235,7 +235,7 @@ int io_symlinkat(struct io_kiocb *req, unsigned int issue_flags)
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 int io_linkat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -281,7 +281,7 @@ int io_linkat(struct io_kiocb *req, unsigned int issue_flags)
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 void io_link_cleanup(struct io_kiocb *req)
diff --git a/io_uring/futex.c b/io_uring/futex.c
index 0ea4820cd8ff..b34695022baa 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -234,7 +234,7 @@ int io_futexv_wait(struct io_kiocb *req, unsigned int issue_flags)
 		kfree(futexv);
 		req->async_data = NULL;
 		req->flags &= ~REQ_F_ASYNC_DATA;
-		return IOU_OK;
+		return IOU_COMPLETE;
 	}
 
 	/*
@@ -311,7 +311,7 @@ int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
 	kfree(ifd);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 int io_futex_wake(struct io_kiocb *req, unsigned int issue_flags)
@@ -328,5 +328,5 @@ int io_futex_wake(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3c4a9561941f..5cdccf65c652 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1751,7 +1751,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = __io_issue_sqe(req, issue_flags, def);
 
-	if (ret == IOU_OK) {
+	if (ret == IOU_COMPLETE) {
 		if (issue_flags & IO_URING_F_COMPLETE_DEFER)
 			io_req_complete_defer(req);
 		else
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 81f22196a57d..0ea7a435d1de 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -19,7 +19,6 @@
 #endif
 
 enum {
-	IOU_OK			= 0, /* deprecated, use IOU_COMPLETE */
 	IOU_COMPLETE		= 0,
 
 	IOU_ISSUE_SKIP_COMPLETE	= -EIOCBQUEUED,
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 823e7eb15fb2..8cce3ebd813f 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -554,7 +554,7 @@ int io_manage_buffers_legacy(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 50a958e9c921..71400d6cefc8 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -328,7 +328,7 @@ int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
 		req_set_fail(req);
 	}
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 int io_uring_sync_msg_ring(struct io_uring_sqe *sqe)
diff --git a/io_uring/net.c b/io_uring/net.c
index 1fbdb2bbb3f3..ee3f721ad758 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -128,7 +128,7 @@ int io_shutdown(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = __sys_shutdown_sock(sock, shutdown->how);
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 static bool io_net_retry(struct socket *sock, int flags)
@@ -502,7 +502,7 @@ static inline bool io_send_finish(struct io_kiocb *req, int *ret,
 	/* Otherwise stop bundle and use the current result. */
 finish:
 	io_req_set_res(req, *ret, cflags);
-	*ret = IOU_OK;
+	*ret = IOU_COMPLETE;
 	return true;
 }
 
@@ -553,7 +553,7 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	else if (sr->done_io)
 		ret = sr->done_io;
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 static int io_send_select_buffer(struct io_kiocb *req, unsigned int issue_flags,
@@ -1459,7 +1459,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 		io_req_msg_cleanup(req, 0);
 	}
 	io_req_set_res(req, ret, IORING_CQE_F_MORE);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
@@ -1530,7 +1530,7 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 		io_req_msg_cleanup(req, 0);
 	}
 	io_req_set_res(req, ret, IORING_CQE_F_MORE);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 void io_sendrecv_fail(struct io_kiocb *req)
@@ -1694,7 +1694,7 @@ int io_socket(struct io_kiocb *req, unsigned int issue_flags)
 					    sock->file_slot);
 	}
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -1761,7 +1761,7 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 		req_set_fail(req);
 	io_req_msg_cleanup(req, issue_flags);
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 int io_bind_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
diff --git a/io_uring/nop.c b/io_uring/nop.c
index 28f06285fdc2..6ac2de761fd3 100644
--- a/io_uring/nop.c
+++ b/io_uring/nop.c
@@ -68,5 +68,5 @@ int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, nop->result, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index 4dd461163457..83e36ad4e31b 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -171,7 +171,7 @@ int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 int io_openat(struct io_kiocb *req, unsigned int issue_flags)
@@ -259,7 +259,7 @@ int io_close(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 int io_install_fixed_fd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -302,7 +302,7 @@ int io_install_fixed_fd(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 struct io_pipe {
@@ -426,7 +426,7 @@ int io_pipe(struct io_kiocb *req, unsigned int issue_flags)
 
 	io_req_set_res(req, ret, 0);
 	if (!ret)
-		return IOU_OK;
+		return IOU_COMPLETE;
 
 	req_set_fail(req);
 	if (files[0])
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 8eb744eb9f4c..0526062e2f81 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -893,7 +893,7 @@ int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 	ret = __io_arm_poll_handler(req, poll, &ipt, poll->events, issue_flags);
 	if (ret > 0) {
 		io_req_set_res(req, ipt.result_mask, 0);
-		return IOU_OK;
+		return IOU_COMPLETE;
 	}
 	return ret ?: IOU_ISSUE_SKIP_COMPLETE;
 }
@@ -948,5 +948,5 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 	}
 	/* complete update request, we're done with it */
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 1657d775c8ba..c592ceace97d 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -500,7 +500,7 @@ int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 void io_free_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 17a12a1cf3a6..8857b8445e46 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -660,7 +660,7 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 		io_req_io_end(req);
 		io_req_set_res(req, final_ret, io_put_kbuf(req, ret, issue_flags));
 		io_req_rw_cleanup(req, issue_flags);
-		return IOU_OK;
+		return IOU_COMPLETE;
 	} else {
 		io_rw_done(req, ret);
 	}
diff --git a/io_uring/splice.c b/io_uring/splice.c
index 7b89bd84d486..35ce4e60b495 100644
--- a/io_uring/splice.c
+++ b/io_uring/splice.c
@@ -103,7 +103,7 @@ int io_tee(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret != sp->len)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -144,5 +144,5 @@ int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret != sp->len)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
diff --git a/io_uring/statx.c b/io_uring/statx.c
index 6bc4651700a2..5111e9befbfe 100644
--- a/io_uring/statx.c
+++ b/io_uring/statx.c
@@ -59,7 +59,7 @@ int io_statx(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = do_statx(sx->dfd, sx->filename, sx->flags, sx->mask, sx->buffer);
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 void io_statx_cleanup(struct io_kiocb *req)
diff --git a/io_uring/sync.c b/io_uring/sync.c
index 255f68c37e55..cea2d381ffd2 100644
--- a/io_uring/sync.c
+++ b/io_uring/sync.c
@@ -47,7 +47,7 @@ int io_sync_file_range(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = sync_file_range(req->file, sync->off, sync->len, sync->flags);
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -79,7 +79,7 @@ int io_fsync(struct io_kiocb *req, unsigned int issue_flags)
 	ret = vfs_fsync_range(req->file, sync->off, end > 0 ? end : LLONG_MAX,
 				sync->flags & IORING_FSYNC_DATASYNC);
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 int io_fallocate_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -108,5 +108,5 @@ int io_fallocate(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret >= 0)
 		fsnotify_modify(req->file);
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index a6ff8c026b1f..7f13bfa9f2b6 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -505,7 +505,7 @@ int io_timeout_remove(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 static int __io_timeout_prep(struct io_kiocb *req,
diff --git a/io_uring/truncate.c b/io_uring/truncate.c
index 62ee73d34d72..487baf23b44e 100644
--- a/io_uring/truncate.c
+++ b/io_uring/truncate.c
@@ -44,5 +44,5 @@ int io_ftruncate(struct io_kiocb *req, unsigned int issue_flags)
 	ret = do_ftruncate(req->file, ft->len, 1);
 
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 8a6b0ddef796..fe84c934734e 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -265,7 +265,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 		req_set_fail(req);
 	io_req_uring_cleanup(req, issue_flags);
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index 54e69984cd8a..e07a94694397 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -323,5 +323,5 @@ int io_waitid(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
diff --git a/io_uring/xattr.c b/io_uring/xattr.c
index de5064fcae8a..322b94ff9e4b 100644
--- a/io_uring/xattr.c
+++ b/io_uring/xattr.c
@@ -109,7 +109,7 @@ int io_fgetxattr(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = file_getxattr(req->file, &ix->ctx);
 	io_xattr_finish(req, ret);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 int io_getxattr(struct io_kiocb *req, unsigned int issue_flags)
@@ -122,7 +122,7 @@ int io_getxattr(struct io_kiocb *req, unsigned int issue_flags)
 	ret = filename_getxattr(AT_FDCWD, ix->filename, LOOKUP_FOLLOW, &ix->ctx);
 	ix->filename = NULL;
 	io_xattr_finish(req, ret);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 static int __io_setxattr_prep(struct io_kiocb *req,
@@ -190,7 +190,7 @@ int io_fsetxattr(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = file_setxattr(req->file, &ix->ctx);
 	io_xattr_finish(req, ret);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 int io_setxattr(struct io_kiocb *req, unsigned int issue_flags)
@@ -203,5 +203,5 @@ int io_setxattr(struct io_kiocb *req, unsigned int issue_flags)
 	ret = filename_setxattr(AT_FDCWD, ix->filename, LOOKUP_FOLLOW, &ix->ctx);
 	ix->filename = NULL;
 	io_xattr_finish(req, ret);
-	return IOU_OK;
+	return IOU_COMPLETE;
 }

-- 
Jens Axboe


