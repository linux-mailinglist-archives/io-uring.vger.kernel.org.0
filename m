Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB79318C540
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2020 03:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbgCTCWa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Mar 2020 22:22:30 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35167 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727338AbgCTCW3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Mar 2020 22:22:29 -0400
Received: by mail-pg1-f193.google.com with SMTP id 7so2313187pgr.2
        for <io-uring@vger.kernel.org>; Thu, 19 Mar 2020 19:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kXGOntefvjB2Y8QtfqDQM++Ajt9qSrFSAqP+s5iPWxI=;
        b=SN2hH+qpbPr8WVIJNADvlQrWgrmW5MUFeRgVywttTgRd+/OWtml4JU6s7cuV/tmzxe
         ntmT7VI3ZkQanYcZl0QIOISbANfajfDkzlfOY/Tn0QwBkW5MTbS6OOrl+NtSK2H813bI
         eCh3dXi37YYgcNXF7sfdaichLlf5dyNxPTYaoKNa7B2k3h21C+LN3zyzQBxn9gK8nM0o
         DAxCb9QXvbEOcgAUQA0jqwViJi5KWbzDfnMhTFQZBTHHTKrZiwS7fP3R28UdvbmbfVQG
         ujWCBszvHRzvSTOLmWmEyRyK6qGK1VMSJ4WS9tngqqAQF43Qi7iBXPizfbDgN17eQals
         BFKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kXGOntefvjB2Y8QtfqDQM++Ajt9qSrFSAqP+s5iPWxI=;
        b=shu3RomnyIv823uu51RBj3je2LE451rbkT6aAVAtTnqh8XOVMU0zBd0tFsRw3jQofW
         ozBjtlSqktdV+vKBAAFK9YdLBg69UDJ3CMNj1JA+G8VoV5N6GAMfN+mXv5qeb0yn7ZZJ
         4Z3hQBDl8L4LsHFfWcaJ81TzoQ9mZvBAdpLZlaSNWnaGWTB9Ep6iL97AVMUPPZwOWMG1
         ltgUXXnKxVK+YV4rxQLJWRk1nZ1NxZU34bOH8ZoUXA89AE5DiolnS4NkGuH6cUAzUv5j
         E/rarwIKRyVDcz0RB49A+L393MCOm03FfftM2eNuo9Z7qh95ii9TjrXc0WJ1tyoWf360
         4gTA==
X-Gm-Message-State: ANhLgQ0gxCr3sG+HfXYzNWXErtngxU8zvhBIl5iPonbZdCwCM1Rf3k2C
        xQEtYfwTFDq5WtQWxZUWtX8oplbeiJcGXQ==
X-Google-Smtp-Source: ADFU+vto/8eO6YBD6Y1LtqhicFAhZVCZanz3cpeiXC3Q3c8O0INPr0fGWAt4ZSdxk3oGLkqA9RKh/g==
X-Received: by 2002:aa7:85d3:: with SMTP id z19mr7100239pfn.13.1584670945886;
        Thu, 19 Mar 2020 19:22:25 -0700 (PDT)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id mq18sm3423993pjb.6.2020.03.19.19.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 19:22:25 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: make sure accept honor rlimit nofile
Date:   Thu, 19 Mar 2020 20:22:16 -0600
Message-Id: <20200320022216.20993-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200320022216.20993-1-axboe@kernel.dk>
References: <20200320022216.20993-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Just like commit 21ec2da35ce3, this fixes the fact that
IORING_OP_ACCEPT ends up using get_unused_fd_flags(), which checks
current->signal->rlim[] for limits.

Add an extra argument to __sys_accept4_file() that allows us to pass
in the proper nofile limit, and grab it at request prep time.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c          | 5 ++++-
 include/linux/socket.h | 3 ++-
 net/socket.c           | 8 +++++---
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fe5ded7c74ef..3affd96a98ba 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -343,6 +343,7 @@ struct io_accept {
 	struct sockaddr __user		*addr;
 	int __user			*addr_len;
 	int				flags;
+	unsigned long			nofile;
 };
 
 struct io_sync {
@@ -3324,6 +3325,7 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	accept->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	accept->addr_len = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	accept->flags = READ_ONCE(sqe->accept_flags);
+	accept->nofile = rlimit(RLIMIT_NOFILE);
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -3340,7 +3342,8 @@ static int __io_accept(struct io_kiocb *req, struct io_kiocb **nxt,
 
 	file_flags = force_nonblock ? O_NONBLOCK : 0;
 	ret = __sys_accept4_file(req->file, file_flags, accept->addr,
-					accept->addr_len, accept->flags);
+					accept->addr_len, accept->flags,
+					accept->nofile);
 	if (ret == -EAGAIN && force_nonblock)
 		return -EAGAIN;
 	if (ret == -ERESTARTSYS)
diff --git a/include/linux/socket.h b/include/linux/socket.h
index 2d2313403101..15f3412d481e 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -401,7 +401,8 @@ extern int __sys_sendto(int fd, void __user *buff, size_t len,
 			int addr_len);
 extern int __sys_accept4_file(struct file *file, unsigned file_flags,
 			struct sockaddr __user *upeer_sockaddr,
-			 int __user *upeer_addrlen, int flags);
+			 int __user *upeer_addrlen, int flags,
+			 unsigned long nofile);
 extern int __sys_accept4(int fd, struct sockaddr __user *upeer_sockaddr,
 			 int __user *upeer_addrlen, int flags);
 extern int __sys_socket(int family, int type, int protocol);
diff --git a/net/socket.c b/net/socket.c
index b79a05de7c6e..2eecf1517f76 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1707,7 +1707,8 @@ SYSCALL_DEFINE2(listen, int, fd, int, backlog)
 
 int __sys_accept4_file(struct file *file, unsigned file_flags,
 		       struct sockaddr __user *upeer_sockaddr,
-		       int __user *upeer_addrlen, int flags)
+		       int __user *upeer_addrlen, int flags,
+		       unsigned long nofile)
 {
 	struct socket *sock, *newsock;
 	struct file *newfile;
@@ -1738,7 +1739,7 @@ int __sys_accept4_file(struct file *file, unsigned file_flags,
 	 */
 	__module_get(newsock->ops->owner);
 
-	newfd = get_unused_fd_flags(flags);
+	newfd = __get_unused_fd_flags(flags, nofile);
 	if (unlikely(newfd < 0)) {
 		err = newfd;
 		sock_release(newsock);
@@ -1807,7 +1808,8 @@ int __sys_accept4(int fd, struct sockaddr __user *upeer_sockaddr,
 	f = fdget(fd);
 	if (f.file) {
 		ret = __sys_accept4_file(f.file, 0, upeer_sockaddr,
-						upeer_addrlen, flags);
+						upeer_addrlen, flags,
+						rlimit(RLIMIT_NOFILE));
 		if (f.flags)
 			fput(f.file);
 	}
-- 
2.25.2

