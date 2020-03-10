Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27974180115
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2020 16:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbgCJPEk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Mar 2020 11:04:40 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:39163 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727714AbgCJPEk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Mar 2020 11:04:40 -0400
Received: by mail-il1-f193.google.com with SMTP id a14so9161505ilk.6
        for <io-uring@vger.kernel.org>; Tue, 10 Mar 2020 08:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yyOEnf49QhhLVKOTyuwvQLPuRjRYfOr/CFDh0kb+/U0=;
        b=y/mYhcUuHZ4rWxQfiIceZRUX94FeuOpijzA10FC/eRXmEHlyRnYzTi2PvllEPQX5qh
         kpDfv6nqHAt0s+2GtDjqm/pU8ZsY1s6a/OebkcZ7FI9W3lzubty+E/0bV9GiSdouTjRd
         abzABaagbovNbN+5ZheyJc5uwhxT2J5/Al57AQv7sYA1tc9Gwffl8nKxcIsw+e8AvK/l
         DZmyHzlvXrMnHwrDAGiAZB8TGMeOxETWkn54NY8IKYeIYlw5y0e3KSgECx2e4fiHeGbP
         YwJXXyBGx+Ui06rQ1b9KC8AnaA5rDRwKfR9vom4ir883jMI2Ejp9zdKD1ivbvlt0VEkC
         w2ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yyOEnf49QhhLVKOTyuwvQLPuRjRYfOr/CFDh0kb+/U0=;
        b=GtIkVhYQD9CqyoC1l3xM1GXKZvI19OHg9mHRQHCfTC7o9ujet6j47YbpnoGs94nvic
         +4q3SACi0P/6OvZBHUPiDeqlVjny9Isq3vqnfAgUkxdaRa86vb7PCJlWPdlCxCwpAbJ2
         KlIxBQGDs9qm6hjx6evVv3aIqEtIfxH4YbWVuJ2oD9cagYwuh9pCT/VNKSebMzI2iy7N
         oNzS9+FNX8iFjG5uqCn1XtIYERomgpo66NGRXVz06nqjPWm5E05QHS5cMflEfW5JZjMg
         bMQYcYxuDm5KugtLrr/cJILjdm2bwUWxYXTCRW0CeMfCOc7vXV+W9iih/1IJHufpa17K
         zG+Q==
X-Gm-Message-State: ANhLgQ0djKkYVQFIPZ4E/yqiSit1vTHT1oKgevpyOkbqaR2aOJiqkbM4
        P/RiKwjVNtbEVxjl5B79cnL+WmipI0SC8Q==
X-Google-Smtp-Source: ADFU+vvGUkgoaPSlSEo0yU/VBRmhaWK3f9Uzxdj2bMGO3AGWuwu66/sc1I7yIlsG7FhIeFbV3qo9nQ==
X-Received: by 2002:a92:5e44:: with SMTP id s65mr20259156ilb.148.1583852677423;
        Tue, 10 Mar 2020 08:04:37 -0700 (PDT)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e16sm4684750ioh.7.2020.03.10.08.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 08:04:36 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de, Jens Axboe <axboe@kernel.dk>,
        David Miller <davem@davemloft.net>
Subject: [PATCH 5/9] net: abstract out normal and compat msghdr import
Date:   Tue, 10 Mar 2020 09:04:22 -0600
Message-Id: <20200310150427.28489-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310150427.28489-1-axboe@kernel.dk>
References: <20200310150427.28489-1-axboe@kernel.dk>
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

Acked-by: David Miller <davem@davemloft.net>
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

