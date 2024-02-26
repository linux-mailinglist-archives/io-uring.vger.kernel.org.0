Return-Path: <io-uring+bounces-756-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 42B608680F7
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 20:26:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3E0F6B2352E
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 19:25:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 982DA12F5A6;
	Mon, 26 Feb 2024 19:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CWXIvkz8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B996C12F39C
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 19:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708975509; cv=none; b=SeHkWg+NOqIhvhaKQWKC9DiTo4C3nkCUg9dPefseZiB/mNkBLwgzaiXjD/4F0WvEtz8ucFrTp/oLILdHqT1Zn+l7fQmVGKe4NpgwsjzgnyZp/CodryD6RFhpiskYc38AhHLS7bJ1iGCQfHMRS+uXDdZfXmF4qEnjzJcYB/Cnegg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708975509; c=relaxed/simple;
	bh=2ayUOfaEYiRowwWtv7K6yBwCX1wE9nF3iDBASOdcNs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPW7Z3bXNIqhxLbDUEuXbV1odZpGVDNL78ImPb+ofiT6IY2DMJFykhXYVQuUvu+iEOLQLrUSlFrPNQ0FU+s0gd0IaP6RJBrQX8MdD7lPPIeik09iJq3T6NqoUZAm+nGR7DPdKFCXEnI4YbdSnHQH+0ETg1ZnTPljHXLWpw+EsM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CWXIvkz8; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7c7bd118546so12300339f.1
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 11:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708975506; x=1709580306; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jw0Je0tw5r/73HhCk/nGFBZB/5kheAEr7X7sZwheg6c=;
        b=CWXIvkz8mIobmAuHg+LSl1TqGViGhEvf+qXGAl6BdSNp4xvEFySV6rfsmsQo5AhOf2
         Rik9GrF4lCou2LfGZYt8FjjuzxVvN2v19QZmFtDbO67NmLJC+tF3JW8Kqd3D2jcB/wjL
         TwsmyWLSRjV/Ft8KovykkfVSiqge3fBBgw5LgjZ5HvTuCFn+3R1PFjJ0N6f5CaW+7mIZ
         aK3DvB+IU0VGe2SiDMvJzmKb075C7M/6XB72UpJIa19nnRek7Xt3ZL4RdMgn0HEuUCEh
         GIGUV7Y5DukOV0gjfFQERfjZTvrRkLKHm3XJQrhV6NJ6pDUMWx7QeaDK7pGUezGQ1Zig
         VEfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708975506; x=1709580306;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jw0Je0tw5r/73HhCk/nGFBZB/5kheAEr7X7sZwheg6c=;
        b=Xh37E/Q2CbakpPz1yxXlZQQ1UIY9j3148S1evtfz+25i3QMXQ1Yb/FFIT63OqNDChw
         JCVeMuNH0py6SmcDio7zoEvul3HonwY7gIs9Dv7y6X5pXQMWRUihjglW83RdkgLikryi
         Id86mzHGf5QTnc/3ZKIKpz3U4zF2mifDByeu4eIgHZHYklWeDxGDFBUyIyK2EATCmDQi
         O1K5+KwfcVKL8kvtOedmTY8j6AnnqLHpEh+LikKLcy51K0ouP/qbIO/N82WImE70Hkds
         twsSFTie5GMzGvLxiHkGwV2q+zwHRyZOCDY/n26ui1dbD1HBWba15RUB11/yLIbgIxM+
         DoLg==
X-Gm-Message-State: AOJu0YwNnbu+GAvxGGnO0zB9/AU94187jZpFCehJiJSESoeE1GR16Rd3
	hKRz9iu0zBzWQGBmfUBw5T3l7xPTMCHWVi/hgltgKo21Tea7MofnB9HKbDKTGTvBZe0kiwxJOeU
	W
X-Google-Smtp-Source: AGHT+IHcaLFu8QbwdEtmuhQUKbkvfE27L0G0aQH8G3GIJ/M79XPZmCO9sEYYJzmavAjAq14aZmUsfg==
X-Received: by 2002:a6b:5d0b:0:b0:7c7:b8fb:8922 with SMTP id r11-20020a6b5d0b000000b007c7b8fb8922mr4560752iob.0.1708975506517;
        Mon, 26 Feb 2024 11:25:06 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id eh3-20020a056638298300b0047466fd3b1dsm1370484jab.22.2024.02.26.11.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 11:25:05 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dyudaken@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/9] net: remove {revc,send}msg_copy_msghdr() from exports
Date: Mon, 26 Feb 2024 12:21:13 -0700
Message-ID: <20240226192458.396832-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240226192458.396832-1-axboe@kernel.dk>
References: <20240226192458.396832-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The only user of these was io_uring, and it's not using them anymore.
Make them static and remove them from the socket header file.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/socket.h                         |  7 -------
 net/socket.c                                   | 14 +++++++-------
 tools/perf/trace/beauty/include/linux/socket.h |  7 -------
 3 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index cfcb7e2c3813..139c330ccf2c 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -422,13 +422,6 @@ extern long __sys_recvmsg_sock(struct socket *sock, struct msghdr *msg,
 			       struct user_msghdr __user *umsg,
 			       struct sockaddr __user *uaddr,
 			       unsigned int flags);
-extern int sendmsg_copy_msghdr(struct msghdr *msg,
-			       struct user_msghdr __user *umsg, unsigned flags,
-			       struct iovec **iov);
-extern int recvmsg_copy_msghdr(struct msghdr *msg,
-			       struct user_msghdr __user *umsg, unsigned flags,
-			       struct sockaddr __user **uaddr,
-			       struct iovec **iov);
 extern int __copy_msghdr(struct msghdr *kmsg,
 			 struct user_msghdr *umsg,
 			 struct sockaddr __user **save_addr);
diff --git a/net/socket.c b/net/socket.c
index ed3df2f749bf..0f5d5079fd91 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2600,9 +2600,9 @@ static int ____sys_sendmsg(struct socket *sock, struct msghdr *msg_sys,
 	return err;
 }
 
-int sendmsg_copy_msghdr(struct msghdr *msg,
-			struct user_msghdr __user *umsg, unsigned flags,
-			struct iovec **iov)
+static int sendmsg_copy_msghdr(struct msghdr *msg,
+			       struct user_msghdr __user *umsg, unsigned flags,
+			       struct iovec **iov)
 {
 	int err;
 
@@ -2753,10 +2753,10 @@ SYSCALL_DEFINE4(sendmmsg, int, fd, struct mmsghdr __user *, mmsg,
 	return __sys_sendmmsg(fd, mmsg, vlen, flags, true);
 }
 
-int recvmsg_copy_msghdr(struct msghdr *msg,
-			struct user_msghdr __user *umsg, unsigned flags,
-			struct sockaddr __user **uaddr,
-			struct iovec **iov)
+static int recvmsg_copy_msghdr(struct msghdr *msg,
+			       struct user_msghdr __user *umsg, unsigned flags,
+			       struct sockaddr __user **uaddr,
+			       struct iovec **iov)
 {
 	ssize_t err;
 
diff --git a/tools/perf/trace/beauty/include/linux/socket.h b/tools/perf/trace/beauty/include/linux/socket.h
index cfcb7e2c3813..139c330ccf2c 100644
--- a/tools/perf/trace/beauty/include/linux/socket.h
+++ b/tools/perf/trace/beauty/include/linux/socket.h
@@ -422,13 +422,6 @@ extern long __sys_recvmsg_sock(struct socket *sock, struct msghdr *msg,
 			       struct user_msghdr __user *umsg,
 			       struct sockaddr __user *uaddr,
 			       unsigned int flags);
-extern int sendmsg_copy_msghdr(struct msghdr *msg,
-			       struct user_msghdr __user *umsg, unsigned flags,
-			       struct iovec **iov);
-extern int recvmsg_copy_msghdr(struct msghdr *msg,
-			       struct user_msghdr __user *umsg, unsigned flags,
-			       struct sockaddr __user **uaddr,
-			       struct iovec **iov);
 extern int __copy_msghdr(struct msghdr *kmsg,
 			 struct user_msghdr *umsg,
 			 struct sockaddr __user **save_addr);
-- 
2.43.0


