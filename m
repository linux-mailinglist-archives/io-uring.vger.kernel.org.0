Return-Path: <io-uring+bounces-6328-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96905A2D7D6
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 18:51:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28B031666A0
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 17:50:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFFDC241120;
	Sat,  8 Feb 2025 17:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qP4M5M4Y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7273241103
	for <io-uring@vger.kernel.org>; Sat,  8 Feb 2025 17:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739037055; cv=none; b=Ang25GXU7mtSKV97t94oxwNunhYnvCXRy4blbIpbxjGOpIrRxcMUBXVivsQCFJw1ZjU6kbAcNpRgGK4SfOzv4D1C1ZZYTO3c0aOSP7FZWLFlY4mvjxJnORkaOVyCcppCwETN1CTvmPre3sqgUP5rth+oJ6JS/g+P3NlJUTdSANM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739037055; c=relaxed/simple;
	bh=5ImuewTfy2hnmROQQx8WVQrO+ZRDXJoeV5T4/w2KdYo=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=hA5kbBP+VnUGFScl08mbTCdJrWo8vL+FE46vf2X6Yl3vYXy2Fsev/DzX0If5jU9lXtknRaDyAuT2gWyLPKVE3xRVReB+BI9em0BDoexxEw+yfuR0WpTdh5hn/f65vXtT5TUQhtxc51IYBR1s+wm+J+k7daECKfXrkP7Yp5xxdXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qP4M5M4Y; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3cf880d90bdso9570745ab.3
        for <io-uring@vger.kernel.org>; Sat, 08 Feb 2025 09:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739037036; x=1739641836; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+KgKsNKhhkCD/+18y08J/Xo1NN1mI4t+vTxkoP7kn5g=;
        b=qP4M5M4Yls8MJpIsTwQSmx5br5JOA8H1D+1hXjSNLzjOi0aI9TKH7vvIvRz0xIGa77
         vzKcdxD7iUbj7is/xPH9H0kh0zoe+Ggbc2pr4ADtRpAzy7rGjn2L6aIEgeSVeUzQBGo9
         MhoKkjB8q1za249idVgEAoOAxGw/d2YqD4Q5QJMZb6VClLUOpUWfDh8HecFUAXudNBgx
         2BPQC6Q9p69u9Urm+XksYCBJkBwO33D7Dj0VXaY+PnZIL+9gCOiPfen9ln9n4iGVT6fQ
         VV51nd825ZvfkqvJ2WK6cGEttoBp2DkILaNrk/tBg4RxjMfG/laDUio6TkrdzvWfy4tC
         U3fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739037036; x=1739641836;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+KgKsNKhhkCD/+18y08J/Xo1NN1mI4t+vTxkoP7kn5g=;
        b=eoDkhPnRQFuF3tmJasFU1y0uOAIAXTK2qGKK8Q0Ng251QGx2E7nh2eLz4si5xcL9Gg
         xLP0w+KSynpzM66KdY71PgU4RmWghyPBXLJ+0nEVOOU7kbjM7zIxeNEZmEHAXkPh98Hk
         CGkdoZaz6pK73kf9jmpCGaL/kLo9+Trm/HzQkoCuFEYtqgM8KoQcgTQaQcPRht6/RYc4
         N0pBj+/IfJAo0ZtLtFK+OJvwpcWMyk8guNeXsTGq5EC1Q6/z6R/HHRaYBXdnz0R8AJMX
         arIxHE0b5CaGwbeio68Hkc36Lj/00KeShbMS1vGJNqibScRkhtU3K12hIu84BwA8s1MM
         BYmw==
X-Gm-Message-State: AOJu0Yytw8EsE0x7yEhQM18M/LiOxh5pqtT2ZX68TvMuEVHG0SgWR52L
	rb57XDp4wdKg/VaIcjEr8lBXKozV9FMgjLE88lfIOpD1BL9k3uD5LhoiQKTyyGMu61NU6Hho4DV
	W
X-Gm-Gg: ASbGnculsxvln3U4CYwXPmn3PPoDrL+6qVQgBQih5lJ/CHrdHlxProeJIbz+ovbLAF2
	wMOVG0wOxlo/8RB0CNBDDaQZfHLB4qoXq3js9EJz+oWD3bL4jzu8UlP4qyGII7L4MPL7TrPS+sL
	G5S/7mKB2SnMIuyvwbqSR0m95G2jUuFyBXl/hlQFFg5Sk+Sx2Z7lVS4FuCtvNH2aiXxOdwcG454
	Vm8P7diGkL82G/xDmomSUgZM12OVXw6lcTt5wON9wBIUEgk+ez+lGj5UR029XEpnpX3HZg7DP6g
	et4ZydBcpqR1
X-Google-Smtp-Source: AGHT+IFepd5UWtCtftLEFgxlBYQfNrWTOudHoZAP8tcnpxZYONpKs1W9T2gjRXNGNycgg9OoHGdvmQ==
X-Received: by 2002:a05:6e02:1c0e:b0:3d0:4e57:bbd3 with SMTP id e9e14a558f8ab-3d13dfa2297mr68912565ab.22.1739037035800;
        Sat, 08 Feb 2025 09:50:35 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d05e87923bsm13370525ab.9.2025.02.08.09.50.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Feb 2025 09:50:35 -0800 (PST)
Message-ID: <184f9f92-a682-4205-a15d-89e18f664502@kernel.dk>
Date: Sat, 8 Feb 2025 10:50:34 -0700
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
Subject: [PATCH RFC] io_uring/net: improve recv bundles
Cc: norman_maurer@apple.com, David Wei <dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Current recv bundles are only supported for multishot receives, and
additionally they also always post at least 2 CQEs if more data is
available than what a buffer will hold. This happens because the initial
bundle recv will do a single buffer, and then do the rest of what is in
the socket as a followup receive. As shown in a test program, if 1k
buffers are available and 32k is available to receive in the socket,
you'd get the following completions:

bundle=1, mshot=0
cqe res 1024
cqe res 1024
[...]
cqe res 1024

bundle=1, mshot=1
cqe res 1024
cqe res 31744

where bundle=1 && mshot=0 will post 32 1k completions, and bundle=1 &&
mshot=1 will post a 1k completion and then a 31k completion.

To support bundle recv without multishot, it's possible to simply retry
the recv immediately and post a single completion, rather than split it
into two completions. With the below patch, the same test looks as
follows:

bundle=1, mshot=0
cqe res 32768

bundle=1, mshot=1
cqe res 32768

where mshot=0 works fine for bundles, and both of them post just a
single 32k completion rather than split it into separate completions.
Posting fewer completions is always a nice win, and not needing
multishot for proper bundle efficiency is nice for cases that can't
necessarily use multishot.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.c b/io_uring/net.c
index 17852a6616ff..10344b3a6d89 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -76,6 +76,7 @@ struct io_sr_msg {
 	/* initialised and used only by !msg send variants */
 	u16				buf_group;
 	u16				buf_index;
+	bool				retry;
 	void __user			*msg_control;
 	/* used only for send zerocopy */
 	struct io_kiocb 		*notif;
@@ -187,6 +188,7 @@ static inline void io_mshot_prep_retry(struct io_kiocb *req,
 
 	req->flags &= ~REQ_F_BL_EMPTY;
 	sr->done_io = 0;
+	sr->retry = false;
 	sr->len = 0; /* get from the provided buffer */
 	req->buf_index = sr->buf_group;
 }
@@ -402,6 +404,7 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
 	sr->done_io = 0;
+	sr->retry = false;
 
 	if (req->opcode != IORING_OP_SEND) {
 		if (sqe->addr2 || sqe->file_index)
@@ -785,6 +788,7 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
 	sr->done_io = 0;
+	sr->retry = false;
 
 	if (unlikely(sqe->file_index || sqe->addr2))
 		return -EINVAL;
@@ -833,6 +837,9 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return io_recvmsg_prep_setup(req);
 }
 
+/* bits to clear in old and inherit in new cflags on bundle retry */
+#define CQE_F_MASK	(IORING_CQE_F_SOCK_NONEMPTY|IORING_CQE_F_MORE)
+
 /*
  * Finishes io_recv and io_recvmsg.
  *
@@ -852,9 +859,19 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 	if (sr->flags & IORING_RECVSEND_BUNDLE) {
 		cflags |= io_put_kbufs(req, *ret, io_bundle_nbufs(kmsg, *ret),
 				      issue_flags);
+		if (sr->retry)
+			cflags = req->cqe.flags | (cflags & CQE_F_MASK);
 		/* bundle with no more immediate buffers, we're done */
 		if (req->flags & REQ_F_BL_EMPTY)
 			goto finish;
+		/* if more is available, retry and append to this one */
+		if (!sr->retry && kmsg->msg.msg_inq > 0 && *ret > 0) {
+			req->cqe.flags = cflags & ~CQE_F_MASK;
+			sr->len = kmsg->msg.msg_inq;
+			sr->done_io += *ret;
+			sr->retry = true;
+			return false;
+		}
 	} else {
 		cflags |= io_put_kbuf(req, *ret, issue_flags);
 	}
@@ -1233,6 +1250,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_kiocb *notif;
 
 	zc->done_io = 0;
+	zc->retry = false;
 	req->flags |= REQ_F_POLL_NO_LAZY;
 
 	if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))

-- 
Jens Axboe


