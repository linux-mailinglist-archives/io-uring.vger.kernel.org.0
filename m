Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A910041C288
	for <lists+io-uring@lfdr.de>; Wed, 29 Sep 2021 12:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245351AbhI2KTL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Sep 2021 06:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245527AbhI2KSw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Sep 2021 06:18:52 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F0EC06161C
        for <io-uring@vger.kernel.org>; Wed, 29 Sep 2021 03:17:07 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 133so2214599pgb.1
        for <io-uring@vger.kernel.org>; Wed, 29 Sep 2021 03:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MFQgDk8mbszwP/XZDQ50oeWvtfgsBw8oAJUU0ivlq5g=;
        b=TCFylJpPnhE3Guv1QwOgkZaolIrNhF25X9kZ3r85NeY/nQb6C5NEi6xWfHRzmY5PuJ
         lcXQI1G3sneaScJh0U2um+VDP4p+UvCqW0lvtpXW1IYzOF2Guf9Ml3vVX5eVkK7oLBz6
         TuWAr/fmVnCMkzV38jASCetriX311pi2rp/svdZb28e9JmrRhOBL5ssmeAahFW53odav
         Z/PCMp2lodKG+QUBRrCWC5LXbc+l4LYy3M2cTUMy9sbAMcz1Tcr7OZMcT2oPwJrzuR7y
         8JYLsFTYkj80k8ddlquoW9HfbuzTGbDa2CIC3ptvIQEOkFpUooXda0myYTinKTBHm4jn
         wR2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MFQgDk8mbszwP/XZDQ50oeWvtfgsBw8oAJUU0ivlq5g=;
        b=dWi41HMfOPnoJPLMUs1nOaNQNcQFnbatRnnG9QYW+nNLcBvYRA+N7bRBQxW+8KXSyL
         A/a0m3IY/b5GmZKPYlvptPLxGdn+2EFhJnOiMIhdlEef8vq4dOgBeNJVHkw2WsbuWgd5
         DoAVdcmC9cXpjF7d0Z5GjkvBw6ytRy9RXRuXDV76087JRiHVQAJ9hFfjvpTn0mDxVKxJ
         KG2t1PlPPCBM3gTR11UULPE9CjXZpDxod+ksGFfqLQM2vZLwoU5Qqc4z9AbuXIe2C2QL
         8/UJb+88QXhXIwOWkgJMkk3UOXlD9Z3oJwDzJbrNASuJvRJN/sB8ebrJ1pdVHL7VlhLI
         6hyA==
X-Gm-Message-State: AOAM531WZ80LZuX/4vd1d+mLS1ErNIkFIhHa8NR0XXd4sWc+iNiGsjgM
        quQ6023Wvdkapvid47rx+1ex4w==
X-Google-Smtp-Source: ABdhPJwmVpOOth/0vFWWgTZxnp1oYDV+Jir8PFZQcUA7ZKA5NrDcp7IY+k+v9SZA4zkrXenTRqr/2w==
X-Received: by 2002:a62:7dd3:0:b0:438:a22:a49c with SMTP id y202-20020a627dd3000000b004380a22a49cmr10084005pfc.44.1632910627156;
        Wed, 29 Sep 2021 03:17:07 -0700 (PDT)
Received: from integral.. ([68.183.184.174])
        by smtp.gmail.com with ESMTPSA id f16sm2001512pfk.110.2021.09.29.03.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 03:17:06 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammarfaizi2@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCHSET v1 RFC liburing 3/6] Add `liburing_mmap()` and `liburing_munmap()`
Date:   Wed, 29 Sep 2021 17:16:03 +0700
Message-Id: <20210929101606.62822-4-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210929101606.62822-1-ammar.faizi@students.amikom.ac.id>
References: <20210929101606.62822-1-ammar.faizi@students.amikom.ac.id>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Do not use `mmap()` and `mumap()` directly from the libc in the
liburing internal sources. Wrap them in `src/syscall.c`. This is the
part of implementing the kernel style return value (which later is
supposed to support no libc environment).

`liburing_mmap()` and `liburing_munmap()` do the same thing with
`mmap()` and `munmap()` from the libc. The only different is when
error happens, the return value is of `liburing_{mmap,munmap}()` will
be a negative error code.

Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 src/setup.c   | 37 +++++++++++++++++++++----------------
 src/syscall.c | 23 +++++++++++++++++++++++
 src/syscall.h |  5 +++++
 3 files changed, 49 insertions(+), 16 deletions(-)

diff --git a/src/setup.c b/src/setup.c
index edfe94e..01cb151 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -15,12 +15,13 @@
 #include "liburing.h"
 
 #include "syscall.h"
+#include "kernel_err.h"
 
 static void io_uring_unmap_rings(struct io_uring_sq *sq, struct io_uring_cq *cq)
 {
-	munmap(sq->ring_ptr, sq->ring_sz);
+	liburing_munmap(sq->ring_ptr, sq->ring_sz);
 	if (cq->ring_ptr && cq->ring_ptr != sq->ring_ptr)
-		munmap(cq->ring_ptr, cq->ring_sz);
+		liburing_munmap(cq->ring_ptr, cq->ring_sz);
 }
 
 static int io_uring_mmap(int fd, struct io_uring_params *p,
@@ -37,19 +38,22 @@ static int io_uring_mmap(int fd, struct io_uring_params *p,
 			sq->ring_sz = cq->ring_sz;
 		cq->ring_sz = sq->ring_sz;
 	}
-	sq->ring_ptr = mmap(0, sq->ring_sz, PROT_READ | PROT_WRITE,
-			MAP_SHARED | MAP_POPULATE, fd, IORING_OFF_SQ_RING);
-	if (sq->ring_ptr == MAP_FAILED)
-		return -errno;
+	sq->ring_ptr = liburing_mmap(0, sq->ring_sz, PROT_READ | PROT_WRITE,
+				     MAP_SHARED | MAP_POPULATE, fd,
+				     IORING_OFF_SQ_RING);
+	if (IS_ERR(sq->ring_ptr))
+		return PTR_ERR(sq->ring_ptr);
 
 	if (p->features & IORING_FEAT_SINGLE_MMAP) {
 		cq->ring_ptr = sq->ring_ptr;
 	} else {
-		cq->ring_ptr = mmap(0, cq->ring_sz, PROT_READ | PROT_WRITE,
-				MAP_SHARED | MAP_POPULATE, fd, IORING_OFF_CQ_RING);
-		if (cq->ring_ptr == MAP_FAILED) {
+		cq->ring_ptr = liburing_mmap(0, cq->ring_sz,
+					     PROT_READ | PROT_WRITE,
+					     MAP_SHARED | MAP_POPULATE, fd,
+					     IORING_OFF_CQ_RING);
+		if (IS_ERR(cq->ring_ptr)) {
+			ret = PTR_ERR(cq->ring_ptr);
 			cq->ring_ptr = NULL;
-			ret = -errno;
 			goto err;
 		}
 	}
@@ -63,11 +67,11 @@ static int io_uring_mmap(int fd, struct io_uring_params *p,
 	sq->array = sq->ring_ptr + p->sq_off.array;
 
 	size = p->sq_entries * sizeof(struct io_uring_sqe);
-	sq->sqes = mmap(0, size, PROT_READ | PROT_WRITE,
-				MAP_SHARED | MAP_POPULATE, fd,
-				IORING_OFF_SQES);
-	if (sq->sqes == MAP_FAILED) {
-		ret = -errno;
+	sq->sqes = liburing_mmap(0, size, PROT_READ | PROT_WRITE,
+				 MAP_SHARED | MAP_POPULATE, fd,
+				 IORING_OFF_SQES);
+	if (IS_ERR(sq->sqes)) {
+		ret = PTR_ERR(sq->sqes);
 err:
 		io_uring_unmap_rings(sq, cq);
 		return ret;
@@ -173,7 +177,8 @@ void io_uring_queue_exit(struct io_uring *ring)
 	struct io_uring_sq *sq = &ring->sq;
 	struct io_uring_cq *cq = &ring->cq;
 
-	munmap(sq->sqes, *sq->kring_entries * sizeof(struct io_uring_sqe));
+	liburing_munmap(sq->sqes,
+			*sq->kring_entries * sizeof(struct io_uring_sqe));
 	io_uring_unmap_rings(sq, cq);
 	close(ring->ring_fd);
 }
diff --git a/src/syscall.c b/src/syscall.c
index 0ecc17b..cb48a94 100644
--- a/src/syscall.c
+++ b/src/syscall.c
@@ -8,9 +8,12 @@
 #include <unistd.h>
 #include <sys/syscall.h>
 #include <sys/uio.h>
+#include <sys/mman.h>
+
 #include "liburing/compat.h"
 #include "liburing/io_uring.h"
 #include "syscall.h"
+#include "kernel_err.h"
 
 #ifdef __alpha__
 /*
@@ -110,3 +113,23 @@ int ____sys_io_uring_enter(int fd, unsigned to_submit, unsigned min_complete,
 	return ____sys_io_uring_enter2(fd, to_submit, min_complete, flags, sig,
 				       _NSIG / 8);
 }
+
+void *liburing_mmap(void *addr, size_t length, int prot, int flags, int fd,
+		    off_t offset)
+{
+	void *ret;
+
+	ret = mmap(addr, length, prot, flags, fd, offset);
+	if (ret == MAP_FAILED)
+		ret = ERR_PTR(-errno);
+
+	return ret;
+}
+
+int liburing_munmap(void *addr, size_t length)
+{
+	int ret;
+
+	ret = munmap(addr, length);
+	return (ret < 0) ? -errno : ret;
+}
diff --git a/src/syscall.h b/src/syscall.h
index 8cd2d4c..feccf67 100644
--- a/src/syscall.h
+++ b/src/syscall.h
@@ -3,6 +3,7 @@
 #define LIBURING_SYSCALL_H
 
 #include <signal.h>
+#include "kernel_err.h"
 
 struct io_uring_params;
 
@@ -25,4 +26,8 @@ int ____sys_io_uring_enter2(int fd, unsigned to_submit, unsigned min_complete,
 int ____sys_io_uring_register(int fd, unsigned int opcode, const void *arg,
 			      unsigned int nr_args);
 
+void *liburing_mmap(void *addr, size_t length, int prot, int flags, int fd,
+		    off_t offset);
+int liburing_munmap(void *addr, size_t length);
+
 #endif
-- 
2.30.2

