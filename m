Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1C03FCB87
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 18:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240000AbhHaQbu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 12:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbhHaQbu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 12:31:50 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96288C061575
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 09:30:54 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 79-20020a1c0452000000b002e6cf79e572so2645619wme.1
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 09:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=l1m392aoGmvQzBa6pxyQRu844u6pZ8I+6+jcGk/TBcM=;
        b=JQuA9yUuuJlAwVmmGySpFGEO20ftGA4FNgjjRbG/pPDaltYGnOM2U/qzg92TGyF/qD
         Lh0yF7B+ZTBdyYOUnaDRjU/FFyDsx4KQTYsS+Ayjw7OofLrWLPFMWIIZHhQxNi0g2PY3
         gBlJJSrO1tNveDTtx0b7kXQai0TIdGTC5MtY4CdQ+bg3MOl9I4je/86izhr68E3dmNUX
         1Zhc6nKZN9aLiNhazDFnorixnbh02tJHqsEjx9vXsRhtO4XnuEi+meTQD68kU3Q7yoLI
         rkGWZ1OLs65WQjLja5PJUCAuBUtGUcMfTMrj2ZomsUIfIiFBk5gUly5vGBS35MRuOtqN
         wJgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l1m392aoGmvQzBa6pxyQRu844u6pZ8I+6+jcGk/TBcM=;
        b=rfKFYCl2NQ6k8cb5yvXUREONY4v/2Spi3CIpOJTIKxY1LP2M4quHKGwOaTebmP+Kzn
         HudWj9gsXRnxBWggrTWIX4xj6Mr02RtoR1ekWNojo/P+Lf4ltBhWtQPki0mPXD3fOHxO
         Xb5v8hVTGJFnGkJ0B1KzHubJFMgAvKBUaAPQ493SRaoReJSY0CKgo5fq7BMm2W88r/jI
         0rcr5skAzH/eZE6/ovDl43EJmMT296h5bs4VVhQjFzE14T+3eHjYtkW1ZYDpa+ug2Qt8
         Q6e/4m8PBdr9S2OltfflAuHqsExnqgT7lPZMec3xyw/B0Vt8rNl35oCQJ/FJVCSyimbz
         0dzQ==
X-Gm-Message-State: AOAM533Zobn84NWOJw1XC6K6hnky/vLrOmItXM6khJMeNtZb7n9NPY93
        QxcGwms2aN41Ga1UngAwv9gOYxBxdy8=
X-Google-Smtp-Source: ABdhPJxE2wJ/hQ6hfhFDQu7TQRx+Lw9gozeDa80aLKF5YDgaoqP8lNQcOIFS1DIcH5Eps0pknSY1nA==
X-Received: by 2002:a7b:c114:: with SMTP id w20mr5046281wmi.80.1630427453276;
        Tue, 31 Aug 2021 09:30:53 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.138])
        by smtp.gmail.com with ESMTPSA id n4sm22403209wro.81.2021.08.31.09.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 09:30:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 1/2] liburing: add helpers for direct open/accept
Date:   Tue, 31 Aug 2021 17:30:12 +0100
Message-Id: <1508fe7ab545d52d1849daceb07e8a349ebfa08d.1630427247.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1630427247.git.asml.silence@gmail.com>
References: <cover.1630427247.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We allow openat/openat2/accept to place new files right into the
internal fixed table, add helpers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing.h | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 7b364ce..3b9cfb5 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -231,6 +231,13 @@ static inline void io_uring_sqe_set_flags(struct io_uring_sqe *sqe,
 	sqe->flags = flags;
 }
 
+static inline void __io_uring_set_target_fixed_file(struct io_uring_sqe *sqe,
+						    unsigned int file_index)
+{
+	/* 0 means no fixed files, indexes should be encoded as "index + 1" */
+	sqe->file_index = file_index + 1;
+}
+
 static inline void io_uring_prep_rw(int op, struct io_uring_sqe *sqe, int fd,
 				    const void *addr, unsigned len,
 				    __u64 offset)
@@ -423,6 +430,16 @@ static inline void io_uring_prep_accept(struct io_uring_sqe *sqe, int fd,
 	sqe->accept_flags = flags;
 }
 
+/* accept directly into the fixed file table */
+static inline void io_uring_prep_accept_direct(struct io_uring_sqe *sqe, int fd,
+					       struct sockaddr *addr,
+					       socklen_t *addrlen, int flags,
+					       unsigned int file_index)
+{
+	io_uring_prep_accept(sqe, fd, addr, addrlen, flags);
+	__io_uring_set_target_fixed_file(sqe, file_index);
+}
+
 static inline void io_uring_prep_cancel(struct io_uring_sqe *sqe, void *user_data,
 					int flags)
 {
@@ -467,6 +484,17 @@ static inline void io_uring_prep_openat(struct io_uring_sqe *sqe, int dfd,
 	sqe->open_flags = flags;
 }
 
+/* open directly into the fixed file table */
+static inline void io_uring_prep_openat_direct(struct io_uring_sqe *sqe,
+					       int dfd, const char *path,
+					       int flags, mode_t mode,
+					       unsigned file_index)
+{
+	io_uring_prep_openat(sqe, dfd, path, flags, mode);
+	__io_uring_set_target_fixed_file(sqe, file_index);
+}
+
+
 static inline void io_uring_prep_close(struct io_uring_sqe *sqe, int fd)
 {
 	io_uring_prep_rw(IORING_OP_CLOSE, sqe, fd, NULL, 0, 0);
@@ -529,6 +557,16 @@ static inline void io_uring_prep_openat2(struct io_uring_sqe *sqe, int dfd,
 				(uint64_t) (uintptr_t) how);
 }
 
+/* open directly into the fixed file table */
+static inline void io_uring_prep_openat2_direct(struct io_uring_sqe *sqe,
+						int dfd, const char *path,
+						struct open_how *how,
+						unsigned file_index)
+{
+	io_uring_prep_openat2(sqe, dfd, path, how);
+	__io_uring_set_target_fixed_file(sqe, file_index);
+}
+
 struct epoll_event;
 static inline void io_uring_prep_epoll_ctl(struct io_uring_sqe *sqe, int epfd,
 					   int fd, int op,
-- 
2.33.0

