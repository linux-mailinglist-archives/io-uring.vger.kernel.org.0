Return-Path: <io-uring+bounces-785-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5A5D869F68
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 19:49:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70CC528C839
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 18:48:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8487F3C490;
	Tue, 27 Feb 2024 18:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CsLsyx1k"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE254F896
	for <io-uring@vger.kernel.org>; Tue, 27 Feb 2024 18:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709059737; cv=none; b=VvGTMQG7TPVP8ESw/sMjvqbs0eYVYi7erNrNsKDJpOxKzT44lv8iuMfurPwyISTfWYvHVnK+L8Ommhplna5K7PyWcXQUxEQ7soSYJtNEGtOGfXZ1BYkUC8x6/ImdGjGeTPX4R9i99FAXE9Or3KAbS33iGstpmGyNk+teVdvHAjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709059737; c=relaxed/simple;
	bh=+TR7Gj4IDHGabPQKAC7eX4UVTyWISGUtkHQ8RKdbcQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJ5MFTuPJ7Uv6KHGzjjTz9YbHcTpGo85MHTvscVH84QuUYRfA8T8QfXKxdBhRlWNYRtw095P5ja0GDIpWsdnGyjg7KgoWTkQGHqFsZ/rJXI/GGrVfKckCWOhMQclBtOxJvb1hGQ2ONT9gg5YY42STebmYamEZgaLnqdxD1AFEng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CsLsyx1k; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-35d374bebe3so1489075ab.1
        for <io-uring@vger.kernel.org>; Tue, 27 Feb 2024 10:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709059734; x=1709664534; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p3sTQnA9zVQdLoH6FC615OvBI7Wkv91f4wZIK5mstHo=;
        b=CsLsyx1kvzA+zbYt/YNwoXtQtH9tAhurfkEL+B4jbGSNg48qpu2fcmuQS52tlkfqkX
         gpwBMoTJGV2VnWqHounAJHyDLNug4qvxPLZrz6hetwgpKq3knTMNSeu9DKTRmrNe6YE5
         vj7TwyLy0EBr8n7QXZcUNFB86nvvi5uyth2iQsXgH9LspvAnhrSRN/8jhfpTQvoAxii+
         lGTe9aKZPprm05gO3soXszPcAdWpO8C9u0KDha1rcixbLy35AjUQQ00hJQ8EuNlwKZYd
         5tMWJdaS9wyFPgFLN/DG3ZqIZYRjHS7hF84T4v3bbz2pZa0orBYK4CjLfAy8qQk2MqWE
         eXEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709059734; x=1709664534;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p3sTQnA9zVQdLoH6FC615OvBI7Wkv91f4wZIK5mstHo=;
        b=wJAsm+cdwSgyL80LKfWE2EeFMi3zPiAzdFr17IdTtqtWpqU7DAgPc0Xm6zLiuLbxst
         9hEIVN7ER74w41zeCg8JPqZehdg/2bjV9lRDu1eQ/AaMfEuzGxOVnlwsJKRaNX/+TYUS
         NfW5W6S+/6CuA0R6MLn3gphUsYnxyEOf1aWZR09uZVEBRpo9e4CTcVuJ+Zi5RcyGAVGZ
         xWbiDg5uJSix3LsvD+SvtUDO5gJQAUOqnVctlJ3HLwzxgBTYHALlNTKfJfG/h5o9oEeA
         moEZsbCtB+j8nUHK5PpdMEerpQuTuW+Pm7MFtb6dazM8ffWsJEPiFuo9FgRV28tyQHtG
         TdnA==
X-Gm-Message-State: AOJu0YyRpwOD2uK6oN/teNqPQrECshUYkHRQk1+fzaLr5nG++Boys7uH
	dddV16mCnnHIjWVqBDQRHlx7U6t59PAirnUBFE5pcVS/2LZsfZUwvu8JaxzuNR3eHdc63nyb8Qm
	V
X-Google-Smtp-Source: AGHT+IFec3DgfjSGRkuStsPiVwx0WR8MXgqoiHuTHdKI3Xaj92LbMeOtJuGm1B2tqx+DQBfjlEsiOg==
X-Received: by 2002:a05:6e02:1aa3:b0:365:aeb8:26d1 with SMTP id l3-20020a056e021aa300b00365aeb826d1mr1847773ilv.0.1709059734166;
        Tue, 27 Feb 2024 10:48:54 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id it2-20020a056a00458200b006e543b59587sm2282119pfb.126.2024.02.27.10.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 10:48:52 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring/net: improve the usercopy for sendmsg/recvmsg
Date: Tue, 27 Feb 2024 11:46:32 -0700
Message-ID: <20240227184845.985268-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240227184845.985268-1-axboe@kernel.dk>
References: <20240227184845.985268-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We're spending a considerable amount of the sendmsg/recvmsg time just
copying in the message header. And for provided buffers, the known
single entry iovec.

Be a bit smarter about it and enable/disable user access around our
copying. In a test case that does both sendmsg and recvmsg, the
runtime before this change (averaged over multiple runs, very stable
times however):

Kernel		Time		Diff
====================================
-git		4720 usec
-git+commit	4311 usec	-8.7%

and looking at a profile diff, we see the following:

0.25%     +9.33%  [kernel.kallsyms]     [k] _copy_from_user
4.47%     -3.32%  [kernel.kallsyms]     [k] __io_msg_copy_hdr.constprop.0

where we drop more than 9% of _copy_from_user() time, and consequently
add time to __io_msg_copy_hdr() where the copies are now attributed to,
but with a net win of 6%.

In comparison, the same test case with send/recv runs in 3745 usec, which
is (expectedly) still quite a bit faster. But at least sendmsg/recvmsg is
now only ~13% slower, where it was ~21% slower before.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 7a07c5563d66..83fba2882720 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -255,27 +255,42 @@ static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	int ret;
 
-	if (copy_from_user(msg, sr->umsg, sizeof(*sr->umsg)))
+	if (!user_access_begin(sr->umsg, sizeof(*sr->umsg)))
 		return -EFAULT;
 
+	ret = -EFAULT;
+	unsafe_get_user(msg->msg_name, &sr->umsg->msg_name, ua_end);
+	unsafe_get_user(msg->msg_namelen, &sr->umsg->msg_namelen, ua_end);
+	unsafe_get_user(msg->msg_iov, &sr->umsg->msg_iov, ua_end);
+	unsafe_get_user(msg->msg_iovlen, &sr->umsg->msg_iovlen, ua_end);
+	unsafe_get_user(msg->msg_control, &sr->umsg->msg_control, ua_end);
+	unsafe_get_user(msg->msg_controllen, &sr->umsg->msg_controllen, ua_end);
+	msg->msg_flags = 0;
+
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		if (msg->msg_iovlen == 0) {
 			sr->len = iomsg->fast_iov[0].iov_len = 0;
 			iomsg->fast_iov[0].iov_base = NULL;
 			iomsg->free_iov = NULL;
 		} else if (msg->msg_iovlen > 1) {
-			return -EINVAL;
+			ret = -EINVAL;
+			goto ua_end;
 		} else {
-			if (copy_from_user(iomsg->fast_iov, msg->msg_iov,
-					   sizeof(*msg->msg_iov)))
-				return -EFAULT;
+			/* we only need the length for provided buffers */
+			if (!access_ok(&msg->msg_iov[0].iov_len, sizeof(__kernel_size_t)))
+				goto ua_end;
+			unsafe_get_user(iomsg->fast_iov[0].iov_len,
+					&msg->msg_iov[0].iov_len, ua_end);
 			sr->len = iomsg->fast_iov[0].iov_len;
 			iomsg->free_iov = NULL;
 		}
-
-		return 0;
+		ret = 0;
+ua_end:
+		user_access_end();
+		return ret;
 	}
 
+	user_access_end();
 	iomsg->free_iov = iomsg->fast_iov;
 	ret = __import_iovec(ddir, msg->msg_iov, msg->msg_iovlen, UIO_FASTIOV,
 				&iomsg->free_iov, &iomsg->msg.msg_iter, false);
-- 
2.43.0


