Return-Path: <io-uring+bounces-703-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29D29862895
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 01:39:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56F711C20E55
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 00:39:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84E111361;
	Sun, 25 Feb 2024 00:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CvFFqEj3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8217710F7
	for <io-uring@vger.kernel.org>; Sun, 25 Feb 2024 00:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708821591; cv=none; b=bauiF4J6+m/S2xhe+Y8FEkBLMRfRvdbOigUmFeCJqVMpsIOyzlzMpsisuDvXzcxOZRJkoZcYhg0AyOYR27nSJNnLTnmWzdH0gY6sIpJ19q2GLCTbnSVTsJ8ksfnmBK0qayWrIf8qfJjrKyCJ1N6FZ8riczBDaGh1T+w5MQqaSpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708821591; c=relaxed/simple;
	bh=2ayUOfaEYiRowwWtv7K6yBwCX1wE9nF3iDBASOdcNs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eeo5cr0y2JmuipJfJdD7YqTE0Y6mWhlp/8zM0YThuyXLlbeoV8K5XoZYnXV8zBk1p+YDva3bdHFDuc0milYfDmjZHCs4IluFsNdg+/ktIPqheZdY5hApJL4Uq3ExnlVlHotSGfTirD9g8uZjD4w5Iys+OSxo37zXQRN4Lq5v2/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CvFFqEj3; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-55b5a37acb6so861972a12.0
        for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 16:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708821588; x=1709426388; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jw0Je0tw5r/73HhCk/nGFBZB/5kheAEr7X7sZwheg6c=;
        b=CvFFqEj3nVzqx7eMV4b5DfXbfIV4CyHL7ngdALhfFUZtvM2Ckgw5x5SQfWgf6Z5UfP
         7cMKvNcG6xP10X2fkwwa2zbXQtsB6bfyrZkqsnyHuDlrHyIy2c0SVzdh0+t8BrsirL3D
         hUshslxf8j233Qpw3CIWEQ739qCRER8tfU7D620LC0FdeQxroUAwDc3iH8Pbd1rQZazt
         0bPekmgghI1tBFoWCPgp9NQQ0EUt3wmcPUVwLOOAOngxhiMqTX994TiOTR9eJ7eBAvfA
         Vmzfiiy6WmtuAYEdtrrd9PZyer5u7Q6gI4ji67nARty5VnUCcRt5TyDk6M1+bxV5Qo2K
         3DmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708821588; x=1709426388;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jw0Je0tw5r/73HhCk/nGFBZB/5kheAEr7X7sZwheg6c=;
        b=KUmz1yA2/hdZLKpIbWqo2rXqsVQajWYkSOr3/p0+MUMDJ6Oau10ZBC0uyXJ/I2kHDQ
         GhcwVWbeYQTMV25vuZgv2cryhdLbma92s/u62cnxLgXNAXj0arCAkVgTc726HK71fgIB
         v+1tEyBPqvNVPe318sveG8hlhFJqAJTNpOdR3E/RLXpj9GoUM6k9BZQz1xC0Np2LoiNd
         gvjKXdGlZCeq6A30P1OrVVSWksR+BqDhsDkWgPg/zu0fVaaBebQuww7Qq4cqq2aNDum6
         7wz4cdHUw2Q0Bq1rQqndWmoYr88qly/ZBTEQreA7lpVbXGL0JUFB/z9JjJWBS9kQ/3Vn
         VHlg==
X-Gm-Message-State: AOJu0YzMNwSQYedUmdOVt/s+MgXcryloy+CRj2rI94Cr4h0jz7E0CRme
	gKTGOidtku/8wNo53JdXhITlpcss5wLEjEDa+8M3Z1AOyrHWGtAnqnvVfWJMblXj8vbT5pycHzo
	M
X-Google-Smtp-Source: AGHT+IELZ4VD+XueMRFyiRqpUYJPAJXStnJ+ZlOcLbf60lZEWC2dGGOi16ZEep1dPCAEdJeTXzTU4g==
X-Received: by 2002:aa7:881a:0:b0:6e4:cdef:7d95 with SMTP id c26-20020aa7881a000000b006e4cdef7d95mr4557903pfo.3.1708821588158;
        Sat, 24 Feb 2024 16:39:48 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id u3-20020a62d443000000b006e24991dd5bsm1716170pfl.98.2024.02.24.16.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Feb 2024 16:39:46 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/8] net: remove {revc,send}msg_copy_msghdr() from exports
Date: Sat, 24 Feb 2024 17:35:48 -0700
Message-ID: <20240225003941.129030-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240225003941.129030-1-axboe@kernel.dk>
References: <20240225003941.129030-1-axboe@kernel.dk>
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


