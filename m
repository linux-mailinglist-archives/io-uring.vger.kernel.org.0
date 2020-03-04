Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2994017975C
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 19:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbgCDSA0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 13:00:26 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:33614 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbgCDSA0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 13:00:26 -0500
Received: by mail-il1-f194.google.com with SMTP id r4so2616529iln.0
        for <io-uring@vger.kernel.org>; Wed, 04 Mar 2020 10:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mR3TrvpVVZQlbagH3ZPAWF3NV70KboS1J1RIOrknCkw=;
        b=m4KB946UJ7WBAS3bcXiDgvenDQCqG/RAt4Kta8nLBjtwOjWQ2w0Xuni328CQU1tAuT
         GUVRITisA86m381GBsNYIKk+4th/kDRolFuy2Z3mKC/9XYMhTyIETc78Xr8VggNRQ5it
         krk7LGDiiHf9tJIEjWZVPKTF7QLQsBjewwQ3B6v+c2XIXf3oa7Kp3n4lgiYKAViuZbZA
         zN7OTFoSL0etURQw8qzjGFir8fe/YvPlmNZrkhUeigqM9F5Oc333g5iClcPMgD2HISPG
         e2aqIOQJJv+jFNkz0ubY+EzwjZuK9ojxctmqe+gpQM8fC1rL2r8YNPJbk7YarNnwHSIe
         P1lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mR3TrvpVVZQlbagH3ZPAWF3NV70KboS1J1RIOrknCkw=;
        b=HPlj1aOUVSsK7fN9ruCASEjdnZ7Xxhik4Fyhbsc9+zjrinxRvDLirqF/qREaT7Z9Bx
         Nwp+zGJkeiBECXIvqJ8pDWYe3FQ1kLPCDbkyVh7+P3f/udv6sCjh6oZCNEa6MBZsEWM0
         fWtsTBrOJqVIfzeMAcULi8ZuRvKymdOaq4qjUPgVQ/aMapIGVSV+Qg1W9HEtKSzSri8r
         YCtWVoH4EOb038X84Zeevpokg/j6O5gZBaoH0z2T1gtcFDv+/1XUx6g/YrHGQeDJhrhN
         x5Iw8CgI3Qc4lAoldpINAHcGYBf486iG1xJYz7gbdy8xHPN4fTJJGj/g3sQSBA5SvIbJ
         VeXg==
X-Gm-Message-State: ANhLgQ0usbcvRzV66Tmo2fhveYYldp67ByBoD6iW5IemylhVfscYCGX3
        e2qetA8/SUdYrTQj8DlSxp1GImKj5YU=
X-Google-Smtp-Source: ADFU+vutT9y/oz9KAJvKfhXgeIWmvo0HgmjZSiaD77d3EWUE+PgPgeMFlo40BCohP8jWCze7RDzkGg==
X-Received: by 2002:a92:a198:: with SMTP id b24mr3943873ill.79.1583344824392;
        Wed, 04 Mar 2020 10:00:24 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p23sm6715187ioo.54.2020.03.04.10.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 10:00:23 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     jlayton@kernel.org, josh@joshtriplett.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/6] net: allow specific fd selection for __sys_accept4_file()
Date:   Wed,  4 Mar 2020 11:00:15 -0700
Message-Id: <20200304180016.28212-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200304180016.28212-1-axboe@kernel.dk>
References: <20200304180016.28212-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If 'open_fd' being passed in is != -1, make accept4() use the specific
fd instead of finding a free unused one.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/socket.h | 2 +-
 net/socket.c           | 8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index fc59ac825561..ce6c97d4a439 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -405,7 +405,7 @@ extern int __sys_sendto(int fd, void __user *buff, size_t len,
 			int addr_len);
 extern int __sys_accept4_file(struct file *file, unsigned file_flags,
 			struct sockaddr __user *upeer_sockaddr,
-			 int __user *upeer_addrlen, int flags);
+			 int __user *upeer_addrlen, int flags, int open_fd);
 extern int __sys_accept4(int fd, struct sockaddr __user *upeer_sockaddr,
 			 int __user *upeer_addrlen, int flags);
 extern int __sys_socket(int family, int type, int protocol);
diff --git a/net/socket.c b/net/socket.c
index 70ede74ab24b..a9793b778701 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1707,7 +1707,7 @@ SYSCALL_DEFINE2(listen, int, fd, int, backlog)
 
 int __sys_accept4_file(struct file *file, unsigned file_flags,
 		       struct sockaddr __user *upeer_sockaddr,
-		       int __user *upeer_addrlen, int flags)
+		       int __user *upeer_addrlen, int flags, int open_fd)
 {
 	struct socket *sock, *newsock;
 	struct file *newfile;
@@ -1719,6 +1719,8 @@ int __sys_accept4_file(struct file *file, unsigned file_flags,
 
 	if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
 		flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
+	if (open_fd != -1)
+		flags |= O_SPECIFIC_FD;
 
 	sock = sock_from_file(file, &err);
 	if (!sock)
@@ -1738,7 +1740,7 @@ int __sys_accept4_file(struct file *file, unsigned file_flags,
 	 */
 	__module_get(newsock->ops->owner);
 
-	newfd = get_unused_fd_flags(flags);
+	newfd = get_specific_unused_fd_flags(open_fd, flags);
 	if (unlikely(newfd < 0)) {
 		err = newfd;
 		sock_release(newsock);
@@ -1807,7 +1809,7 @@ int __sys_accept4(int fd, struct sockaddr __user *upeer_sockaddr,
 	f = fdget(fd);
 	if (f.file) {
 		ret = __sys_accept4_file(f.file, 0, upeer_sockaddr,
-						upeer_addrlen, flags);
+						upeer_addrlen, flags, -1);
 		if (f.flags)
 			fput(f.file);
 	}
-- 
2.25.1

