Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5451A1740F5
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2020 21:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbgB1UbC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 15:31:02 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:39579 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgB1UbC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 15:31:02 -0500
Received: by mail-il1-f195.google.com with SMTP id w69so3905153ilk.6
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2020 12:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=opzF/Xl5cy64UVZeXK0Pqdm7F7EKZVDIMZ22vwBunKE=;
        b=P/1Ijdq2PTdCj+mbJQxRPLRGwssmBuIxQDU3YPW31UNkBdLBsU8K+W8p3AdAyLwWfI
         buJsbrqJNgcMCH72ftp1a6l4/L318Sc1HnHTDYvJiMwPQG8wCzj+hVgLp/Ps9IATAeMm
         9LXZ7LCvTnhcMp24YnuuErFdXqeu1Chp/Uq+357G/OcXdfGc+xLzLa7hq9WniDxulWjx
         LHzlWz8ecZyX8xCFHXXBXhRvOQ3iYNjVHQkMV9Y1ZP96TFqvh7mqSWcU7iE6E0nCP3dY
         4+4NAVpkEO+FIaqDtUxnffFUq4VjQghy9rPZ3b3FQJh9czIuqyX6ZYO8mCP7sZLENsZN
         yllg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=opzF/Xl5cy64UVZeXK0Pqdm7F7EKZVDIMZ22vwBunKE=;
        b=JumNF8aQYBdfFYKw6LmlV4qalUqt4T2PJe3c5+Jf90h3uBh0VevxdZ8WGSWSOpqzrL
         yljIkPQLC641G2Uny87VP9gVeUn+Ur0GBpth7wCSJcBA5+VI8nDpnrJ5QLL/YQ0efC1n
         0uVfg7DGis8dMP13A2D+NK6lidjaowP2TvZA38w95HAosGmV+a4YnKdBwG5sQq2xnXce
         DxUWSWo8Qw5H2mlvuIYQPltdZ4k/DzF61N2zvXadGIeAqRsg9UwXlZ7+p9ksqiuc4iq9
         qNCLaeDJXtEan72Jpz2Kt7F5ApUgsx9DXd3q7ccSsWeUBAXrMVbhRBFcW6zjOCIFWrmM
         kmog==
X-Gm-Message-State: APjAAAXP8HR0nedJCV+gGbfU46raD7/CRHCkcrMJ2TyxjU1JF6ueklWs
        UiA7wLAAXT3t25KScMZqk7lNkNJGv6U=
X-Google-Smtp-Source: APXvYqwoXQ+gpbjza5/lScF0KJ/94foRPhXaU87u2mzGb82j9FXD1LM38L5eRH53cVyNQVuIQxhssg==
X-Received: by 2002:a92:b68a:: with SMTP id m10mr6276862ill.255.1582921861037;
        Fri, 28 Feb 2020 12:31:01 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t15sm3397611ili.50.2020.02.28.12.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 12:31:00 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/6] net: abstract out normal and compat msghdr import
Date:   Fri, 28 Feb 2020 13:30:52 -0700
Message-Id: <20200228203053.25023-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200228203053.25023-1-axboe@kernel.dk>
References: <20200228203053.25023-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This splits it into two parts, one that imports the message, and one
that imports the iovec. This allows a caller to only do the first part,
and import the iovec manually afterwards.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/socket.h |  4 ++++
 include/net/compat.h   |  3 +++
 net/compat.c           | 30 +++++++++++++++++++++++-------
 net/socket.c           | 25 +++++++++++++++++++++----
 4 files changed, 51 insertions(+), 11 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 2d2313403101..fc59ac825561 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -391,6 +391,10 @@ extern int recvmsg_copy_msghdr(struct msghdr *msg,
 			       struct user_msghdr __user *umsg, unsigned flags,
 			       struct sockaddr __user **uaddr,
 			       struct iovec **iov);
+extern int __copy_msghdr_from_user(struct msghdr *kmsg,
+				   struct user_msghdr __user *umsg,
+				   struct sockaddr __user **save_addr,
+				   struct iovec __user **uiov, size_t *nsegs);
 
 /* helpers which do the actual work for syscalls */
 extern int __sys_recvfrom(int fd, void __user *ubuf, size_t size,
diff --git a/include/net/compat.h b/include/net/compat.h
index f277653c7e17..e341260642fe 100644
--- a/include/net/compat.h
+++ b/include/net/compat.h
@@ -38,6 +38,9 @@ struct compat_cmsghdr {
 #define compat_mmsghdr	mmsghdr
 #endif /* defined(CONFIG_COMPAT) */
 
+int __get_compat_msghdr(struct msghdr *kmsg, struct compat_msghdr __user *umsg,
+			struct sockaddr __user **save_addr, compat_uptr_t *ptr,
+			compat_size_t *len);
 int get_compat_msghdr(struct msghdr *, struct compat_msghdr __user *,
 		      struct sockaddr __user **, struct iovec **);
 struct sock_fprog __user *get_compat_bpf_fprog(char __user *optval);
diff --git a/net/compat.c b/net/compat.c
index 47d99c784947..4bed96e84d9a 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -33,10 +33,10 @@
 #include <linux/uaccess.h>
 #include <net/compat.h>
 
-int get_compat_msghdr(struct msghdr *kmsg,
-		      struct compat_msghdr __user *umsg,
-		      struct sockaddr __user **save_addr,
-		      struct iovec **iov)
+int __get_compat_msghdr(struct msghdr *kmsg,
+			struct compat_msghdr __user *umsg,
+			struct sockaddr __user **save_addr,
+			compat_uptr_t *ptr, compat_size_t *len)
 {
 	struct compat_msghdr msg;
 	ssize_t err;
@@ -79,10 +79,26 @@ int get_compat_msghdr(struct msghdr *kmsg,
 		return -EMSGSIZE;
 
 	kmsg->msg_iocb = NULL;
+	*ptr = msg.msg_iov;
+	*len = msg.msg_iovlen;
+	return 0;
+}
+
+int get_compat_msghdr(struct msghdr *kmsg,
+		      struct compat_msghdr __user *umsg,
+		      struct sockaddr __user **save_addr,
+		      struct iovec **iov)
+{
+	compat_uptr_t ptr;
+	compat_size_t len;
+	ssize_t err;
+
+	err = __get_compat_msghdr(kmsg, umsg, save_addr, &ptr, &len);
+	if (err)
+		return err;
 
-	err = compat_import_iovec(save_addr ? READ : WRITE,
-				   compat_ptr(msg.msg_iov), msg.msg_iovlen,
-				   UIO_FASTIOV, iov, &kmsg->msg_iter);
+	err = compat_import_iovec(save_addr ? READ : WRITE, compat_ptr(ptr),
+				   len, UIO_FASTIOV, iov, &kmsg->msg_iter);
 	return err < 0 ? err : 0;
 }
 
diff --git a/net/socket.c b/net/socket.c
index b79a05de7c6e..70ede74ab24b 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2226,10 +2226,10 @@ struct used_address {
 	unsigned int name_len;
 };
 
-static int copy_msghdr_from_user(struct msghdr *kmsg,
-				 struct user_msghdr __user *umsg,
-				 struct sockaddr __user **save_addr,
-				 struct iovec **iov)
+int __copy_msghdr_from_user(struct msghdr *kmsg,
+			    struct user_msghdr __user *umsg,
+			    struct sockaddr __user **save_addr,
+			    struct iovec __user **uiov, size_t *nsegs)
 {
 	struct user_msghdr msg;
 	ssize_t err;
@@ -2271,6 +2271,23 @@ static int copy_msghdr_from_user(struct msghdr *kmsg,
 		return -EMSGSIZE;
 
 	kmsg->msg_iocb = NULL;
+	*uiov = msg.msg_iov;
+	*nsegs = msg.msg_iovlen;
+	return 0;
+}
+
+static int copy_msghdr_from_user(struct msghdr *kmsg,
+				 struct user_msghdr __user *umsg,
+				 struct sockaddr __user **save_addr,
+				 struct iovec **iov)
+{
+	struct user_msghdr msg;
+	ssize_t err;
+
+	err = __copy_msghdr_from_user(kmsg, umsg, save_addr, &msg.msg_iov,
+					&msg.msg_iovlen);
+	if (err)
+		return err;
 
 	err = import_iovec(save_addr ? READ : WRITE,
 			    msg.msg_iov, msg.msg_iovlen,
-- 
2.25.1

