Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8310141C27F
	for <lists+io-uring@lfdr.de>; Wed, 29 Sep 2021 12:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245507AbhI2KSt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Sep 2021 06:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245463AbhI2KSj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Sep 2021 06:18:39 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2BEC061767
        for <io-uring@vger.kernel.org>; Wed, 29 Sep 2021 03:16:58 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id j14so1177092plx.4
        for <io-uring@vger.kernel.org>; Wed, 29 Sep 2021 03:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ukSpxW1kJm4Y0+ny6+jyMBy1d0ElyecBwOucBVx6n0Y=;
        b=E7muDRXf7NMiD9gRHPjzXbsAS7rHU4zTWPDiHGWw8gcM1PsideDeqjpbcHrhghwNjv
         /yEUBaSE+P6U/ArrJSAluismV5Xu7mvKoQ2SJd5sIeMjIkYTnHQWF0uev+4uuUXix0GZ
         Bc/QmZR/2OO0ALi0LLyitUxNLwaVfik0K1fqW6a0UOrlPBx6ryhLEJcJHSitLAoLUPIm
         BJhyzjAPFYBux+kLXV6kEetVSoTq0Rj9zr7iNHVOCao70/bOSngCyOZqNUFOdV6dw8TV
         YpBpZ5a+NkkaPAnZSYV0N9eNu3JLdrXDqK5CZjgUAvk1/nS4Wyxcz3k/zD90+ekkW8w3
         9/Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ukSpxW1kJm4Y0+ny6+jyMBy1d0ElyecBwOucBVx6n0Y=;
        b=PZo2wFQp0es1uh91KdJz3B6M9+NYEnzfIXkLSeKUZQvWENzyT8a9MC7rLksCfyBIrD
         LbEc0N6h5vmv4brL/Atq09JAQzQFPRq8iMy0gcN7tAX+20uW4fsLaN1q3SGqBrN8IVYb
         ZGyJcVRGSps4Vi0Uhnfa5A5MQd1L6NUKBUBLrFnDwEwgI6PKMp6uJdg27DsEgH0zJpbp
         5HrJJEEiv17qZnlaDo3KBLMaVISegISKN7eIS3r11obWIyccLk2GYA1LvJKiXitzjft9
         /fhiuAZUkl6q09NX+KAuCoyj1HGNgmH5qF/GHof87B3Yxz4ggAH0qnvpQCAboKFoS2+/
         SBrQ==
X-Gm-Message-State: AOAM532W3p8b9ZpswzilgSpEFPjx2EmJH4P4Qsv/Ez7ihg8VEVgMhc2w
        4qoCLycZMVV6Z/idYbsXueHWcg==
X-Google-Smtp-Source: ABdhPJzS3B+V/6+tXTv0w6qDDHIIb/UXX8i7Ebe7qrTzL0bUm2PAvRC6BGcx0wtpVbTJOKtFN87aaQ==
X-Received: by 2002:a17:902:a3c1:b0:13a:47a:1c5a with SMTP id q1-20020a170902a3c100b0013a047a1c5amr9449608plb.13.1632910617738;
        Wed, 29 Sep 2021 03:16:57 -0700 (PDT)
Received: from integral.. ([68.183.184.174])
        by smtp.gmail.com with ESMTPSA id f16sm2001512pfk.110.2021.09.29.03.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 03:16:57 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammarfaizi2@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCHSET v1 RFC liburing 1/6] src/syscall: Implement the kernel style return value
Date:   Wed, 29 Sep 2021 17:16:01 +0700
Message-Id: <20210929101606.62822-2-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210929101606.62822-1-ammar.faizi@students.amikom.ac.id>
References: <20210929101606.62822-1-ammar.faizi@students.amikom.ac.id>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It is the starting point to make liburing can work without the libc.
Make it possible to remove the dependency of `errno` variable (which
comes from libc). Do it incrementally, start from `__sys_io_uring_*`
functions.

@@ Notes:
  1) We do not plan to remove the libc support.
  2) The return value for each syscall API to indicate error is a
     negative value within range [-4095, -1].
  3) In the liburing sources, the `errno` variable is only allowed to
     be used in file `src/syscall.c` (just to emulate the kernel
     style return value).

@@ Extra notes for backward compatibility:
Currently, we expose these functions (**AAA**) to userland:
**AAA**:
  1) `__sys_io_uring_register`
  2) `__sys_io_uring_setup`
  3) `__sys_io_uring_enter2`
  4) `__sys_io_uring_enter`

As the userland needs to check the `errno` value to use them properly,
this means those functions always depend on libc. So we cannot change
their behavior.

As such, only for the **no libc** environment case, we remove those
functions (**AAA**).

Then we introduce new functions (**BBB**) with the same name (with
extra underscore as prefix, 4 underscores). These functions do not
use `errno` variable on the caller (they use the kernel style return
value) and always exist regardless the libc existence.

**BBB**:
  1) `____sys_io_uring_register`
  2) `____sys_io_uring_setup`
  3) `____sys_io_uring_enter2`
  4) `____sys_io_uring_enter`

@@ Summary
 1) **AAA** will only exist for the libc environment.
 2) **BBB** always exists.
 3) Do not use **AAA** for the liburing internal (it's just for the
    userland backward compatibility).
 4) For the libc environment, **BBB** may use `syscall(2)` and
    `errno` variable, only to emulate the kernel style return value.
 5) For the no libc environment, **BBB** will use Assembly interface
    to perform the syscall (arch dependent).
 6) Tests should not be affected, this is because of (1) and (4),
    which keep the compatibility.

Link: https://github.com/axboe/liburing/issues/443
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 src/queue.c    |  27 +++-----
 src/register.c | 184 ++++++++++++++++---------------------------------
 src/setup.c    |   4 +-
 src/syscall.c  |  45 +++++++++++-
 src/syscall.h  |   8 +++
 5 files changed, 120 insertions(+), 148 deletions(-)

diff --git a/src/queue.c b/src/queue.c
index 10ef31c..e85ea1d 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -117,11 +117,11 @@ static int _io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_pt
 		if (!need_enter)
 			break;
 
-		ret = __sys_io_uring_enter2(ring->ring_fd, data->submit,
-				data->wait_nr, flags, data->arg,
-				data->sz);
+		ret = ____sys_io_uring_enter2(ring->ring_fd, data->submit,
+					      data->wait_nr, flags, data->arg,
+					      data->sz);
 		if (ret < 0) {
-			err = -errno;
+			err = ret;
 			break;
 		}
 
@@ -178,8 +178,8 @@ again:
 		goto done;
 
 	if (cq_ring_needs_flush(ring)) {
-		__sys_io_uring_enter(ring->ring_fd, 0, 0,
-				     IORING_ENTER_GETEVENTS, NULL);
+		____sys_io_uring_enter(ring->ring_fd, 0, 0,
+				       IORING_ENTER_GETEVENTS, NULL);
 		overflow_checked = true;
 		goto again;
 	}
@@ -333,10 +333,8 @@ static int __io_uring_submit(struct io_uring *ring, unsigned submitted,
 		if (wait_nr || (ring->flags & IORING_SETUP_IOPOLL))
 			flags |= IORING_ENTER_GETEVENTS;
 
-		ret = __sys_io_uring_enter(ring->ring_fd, submitted, wait_nr,
-						flags, NULL);
-		if (ret < 0)
-			return -errno;
+		ret = ____sys_io_uring_enter(ring->ring_fd, submitted, wait_nr,
+					     flags, NULL);
 	} else
 		ret = submitted;
 
@@ -391,11 +389,6 @@ struct io_uring_sqe *io_uring_get_sqe(struct io_uring *ring)
 
 int __io_uring_sqring_wait(struct io_uring *ring)
 {
-	int ret;
-
-	ret = __sys_io_uring_enter(ring->ring_fd, 0, 0, IORING_ENTER_SQ_WAIT,
-					NULL);
-	if (ret < 0)
-		ret = -errno;
-	return ret;
+	return ____sys_io_uring_enter(ring->ring_fd, 0, 0, IORING_ENTER_SQ_WAIT,
+				      NULL);
 }
diff --git a/src/register.c b/src/register.c
index 5ea4331..944852e 100644
--- a/src/register.c
+++ b/src/register.c
@@ -26,12 +26,10 @@ int io_uring_register_buffers_update_tag(struct io_uring *ring, unsigned off,
 		.tags = (unsigned long)tags,
 		.nr = nr,
 	};
-	int ret;
 
-	ret = __sys_io_uring_register(ring->ring_fd,
-				      IORING_REGISTER_BUFFERS_UPDATE,
-				      &up, sizeof(up));
-	return ret < 0 ? -errno : ret;
+	return ____sys_io_uring_register(ring->ring_fd,
+					 IORING_REGISTER_BUFFERS_UPDATE, &up,
+					 sizeof(up));
 }
 
 int io_uring_register_buffers_tags(struct io_uring *ring,
@@ -44,11 +42,10 @@ int io_uring_register_buffers_tags(struct io_uring *ring,
 		.data = (unsigned long)iovecs,
 		.tags = (unsigned long)tags,
 	};
-	int ret;
 
-	ret = __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_BUFFERS2,
-				      &reg, sizeof(reg));
-	return ret < 0 ? -errno : ret;
+	return ____sys_io_uring_register(ring->ring_fd,
+					 IORING_REGISTER_BUFFERS2, &reg,
+					 sizeof(reg));
 }
 
 int io_uring_register_buffers(struct io_uring *ring, const struct iovec *iovecs,
@@ -56,24 +53,18 @@ int io_uring_register_buffers(struct io_uring *ring, const struct iovec *iovecs,
 {
 	int ret;
 
-	ret = __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_BUFFERS,
+	ret = ____sys_io_uring_register(ring->ring_fd, IORING_REGISTER_BUFFERS,
 					iovecs, nr_iovecs);
-	if (ret < 0)
-		return -errno;
-
-	return 0;
+	return (ret < 0) ? ret : 0;
 }
 
 int io_uring_unregister_buffers(struct io_uring *ring)
 {
 	int ret;
 
-	ret = __sys_io_uring_register(ring->ring_fd, IORING_UNREGISTER_BUFFERS,
+	ret = ____sys_io_uring_register(ring->ring_fd, IORING_UNREGISTER_BUFFERS,
 					NULL, 0);
-	if (ret < 0)
-		return -errno;
-
-	return 0;
+	return (ret < 0) ? ret : 0;
 }
 
 int io_uring_register_files_update_tag(struct io_uring *ring, unsigned off,
@@ -86,12 +77,10 @@ int io_uring_register_files_update_tag(struct io_uring *ring, unsigned off,
 		.tags = (unsigned long)tags,
 		.nr = nr_files,
 	};
-	int ret;
 
-	ret = __sys_io_uring_register(ring->ring_fd,
-					IORING_REGISTER_FILES_UPDATE2,
-					&up, sizeof(up));
-	return ret < 0 ? -errno : ret;
+	return ____sys_io_uring_register(ring->ring_fd,
+					 IORING_REGISTER_FILES_UPDATE2, &up,
+					 sizeof(up));
 }
 
 /*
@@ -108,15 +97,10 @@ int io_uring_register_files_update(struct io_uring *ring, unsigned off,
 		.offset	= off,
 		.fds	= (unsigned long) files,
 	};
-	int ret;
-
-	ret = __sys_io_uring_register(ring->ring_fd,
-					IORING_REGISTER_FILES_UPDATE, &up,
-					nr_files);
-	if (ret < 0)
-		return -errno;
 
-	return ret;
+	return ____sys_io_uring_register(ring->ring_fd,
+					 IORING_REGISTER_FILES_UPDATE, &up,
+					 nr_files);
 }
 
 static int increase_rlimit_nofile(unsigned nr)
@@ -145,12 +129,12 @@ int io_uring_register_files_tags(struct io_uring *ring,
 	int ret, did_increase = 0;
 
 	do {
-		ret = __sys_io_uring_register(ring->ring_fd,
-					      IORING_REGISTER_FILES2, &reg,
-					      sizeof(reg));
+		ret = ____sys_io_uring_register(ring->ring_fd,
+						IORING_REGISTER_FILES2, &reg,
+						sizeof(reg));
 		if (ret >= 0)
 			break;
-		if (errno == EMFILE && !did_increase) {
+		if (ret == -EMFILE && !did_increase) {
 			did_increase = 1;
 			increase_rlimit_nofile(nr);
 			continue;
@@ -158,7 +142,7 @@ int io_uring_register_files_tags(struct io_uring *ring,
 		break;
 	} while (1);
 
-	return ret < 0 ? -errno : ret;
+	return (ret < 0) ? ret : 0;
 }
 
 int io_uring_register_files(struct io_uring *ring, const int *files,
@@ -167,12 +151,12 @@ int io_uring_register_files(struct io_uring *ring, const int *files,
 	int ret, did_increase = 0;
 
 	do {
-		ret = __sys_io_uring_register(ring->ring_fd,
-					      IORING_REGISTER_FILES, files,
-					      nr_files);
+		ret = ____sys_io_uring_register(ring->ring_fd,
+						IORING_REGISTER_FILES, files,
+						nr_files);
 		if (ret >= 0)
 			break;
-		if (errno == EMFILE && !did_increase) {
+		if (ret == -EMFILE && !did_increase) {
 			did_increase = 1;
 			increase_rlimit_nofile(nr_files);
 			continue;
@@ -180,55 +164,44 @@ int io_uring_register_files(struct io_uring *ring, const int *files,
 		break;
 	} while (1);
 
-	return ret < 0 ? -errno : ret;
+	return (ret < 0) ? ret : 0;
 }
 
 int io_uring_unregister_files(struct io_uring *ring)
 {
 	int ret;
 
-	ret = __sys_io_uring_register(ring->ring_fd, IORING_UNREGISTER_FILES,
+	ret = ____sys_io_uring_register(ring->ring_fd, IORING_UNREGISTER_FILES,
 					NULL, 0);
-	if (ret < 0)
-		return -errno;
-
-	return 0;
+	return (ret < 0) ? ret : 0;
 }
 
 int io_uring_register_eventfd(struct io_uring *ring, int event_fd)
 {
 	int ret;
 
-	ret = __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_EVENTFD,
+	ret = ____sys_io_uring_register(ring->ring_fd, IORING_REGISTER_EVENTFD,
 					&event_fd, 1);
-	if (ret < 0)
-		return -errno;
-
-	return 0;
+	return (ret < 0) ? ret : 0;
 }
 
 int io_uring_unregister_eventfd(struct io_uring *ring)
 {
 	int ret;
 
-	ret = __sys_io_uring_register(ring->ring_fd, IORING_UNREGISTER_EVENTFD,
-					NULL, 0);
-	if (ret < 0)
-		return -errno;
-
-	return 0;
+	ret = ____sys_io_uring_register(ring->ring_fd,
+					IORING_UNREGISTER_EVENTFD, NULL, 0);
+	return (ret < 0) ? ret : 0;
 }
 
 int io_uring_register_eventfd_async(struct io_uring *ring, int event_fd)
 {
 	int ret;
 
-	ret = __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_EVENTFD_ASYNC,
-			&event_fd, 1);
-	if (ret < 0)
-		return -errno;
-
-	return 0;
+	ret = ____sys_io_uring_register(ring->ring_fd,
+					IORING_REGISTER_EVENTFD_ASYNC,
+					&event_fd, 1);
+	return (ret < 0) ? ret : 0;
 }
 
 int io_uring_register_probe(struct io_uring *ring, struct io_uring_probe *p,
@@ -236,36 +209,22 @@ int io_uring_register_probe(struct io_uring *ring, struct io_uring_probe *p,
 {
 	int ret;
 
-	ret = __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_PROBE,
-					p, nr_ops);
-	if (ret < 0)
-		return -errno;
-
-	return 0;
+	ret = ____sys_io_uring_register(ring->ring_fd, IORING_REGISTER_PROBE, p,
+					nr_ops);
+	return (ret < 0) ? ret : 0;
 }
 
 int io_uring_register_personality(struct io_uring *ring)
 {
-	int ret;
-
-	ret = __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_PERSONALITY,
-					NULL, 0);
-	if (ret < 0)
-		return -errno;
-
-	return ret;
+	return ____sys_io_uring_register(ring->ring_fd,
+					 IORING_REGISTER_PERSONALITY, NULL, 0);
 }
 
 int io_uring_unregister_personality(struct io_uring *ring, int id)
 {
-	int ret;
-
-	ret = __sys_io_uring_register(ring->ring_fd, IORING_UNREGISTER_PERSONALITY,
-					NULL, id);
-	if (ret < 0)
-		return -errno;
-
-	return ret;
+	return ____sys_io_uring_register(ring->ring_fd,
+					 IORING_UNREGISTER_PERSONALITY, NULL,
+					 id);
 }
 
 int io_uring_register_restrictions(struct io_uring *ring,
@@ -274,61 +233,34 @@ int io_uring_register_restrictions(struct io_uring *ring,
 {
 	int ret;
 
-	ret = __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_RESTRICTIONS,
-				      res, nr_res);
-	if (ret < 0)
-		return -errno;
-
-	return 0;
+	ret = ____sys_io_uring_register(ring->ring_fd,
+					IORING_REGISTER_RESTRICTIONS, res,
+					nr_res);
+	return (ret < 0) ? ret : 0;
 }
 
 int io_uring_enable_rings(struct io_uring *ring)
 {
-	int ret;
-
-	ret = __sys_io_uring_register(ring->ring_fd,
-				      IORING_REGISTER_ENABLE_RINGS, NULL, 0);
-	if (ret < 0)
-		return -errno;
-
-	return ret;
+	return ____sys_io_uring_register(ring->ring_fd,
+					 IORING_REGISTER_ENABLE_RINGS, NULL, 0);
 }
 
 int io_uring_register_iowq_aff(struct io_uring *ring, size_t cpusz,
 			       const cpu_set_t *mask)
 {
-	int ret;
-
-	ret = __sys_io_uring_register(ring->ring_fd,
-					IORING_REGISTER_IOWQ_AFF, mask, cpusz);
-	if (ret < 0)
-		return -errno;
-
-	return ret;
+	return ____sys_io_uring_register(ring->ring_fd,
+					 IORING_REGISTER_IOWQ_AFF, mask, cpusz);
 }
 
 int io_uring_unregister_iowq_aff(struct io_uring *ring)
 {
-	int ret;
-
-	ret = __sys_io_uring_register(ring->ring_fd,
-					IORING_REGISTER_IOWQ_AFF, NULL, 0);
-	if (ret < 0)
-		return -errno;
-
-	return ret;
+	return ____sys_io_uring_register(ring->ring_fd,
+					 IORING_REGISTER_IOWQ_AFF, NULL, 0);
 }
 
 int io_uring_register_iowq_max_workers(struct io_uring *ring, unsigned int *val)
 {
-	int ret;
-
-	ret = __sys_io_uring_register(ring->ring_fd,
-					IORING_REGISTER_IOWQ_MAX_WORKERS,
-					val, 2);
-	if (ret < 0)
-		return -errno;
-
-	return ret;
-
+	return ____sys_io_uring_register(ring->ring_fd,
+					 IORING_REGISTER_IOWQ_MAX_WORKERS, val,
+					 2);
 }
diff --git a/src/setup.c b/src/setup.c
index 54225e8..edfe94e 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -140,9 +140,9 @@ int io_uring_queue_init_params(unsigned entries, struct io_uring *ring,
 {
 	int fd, ret;
 
-	fd = __sys_io_uring_setup(entries, p);
+	fd = ____sys_io_uring_setup(entries, p);
 	if (fd < 0)
-		return -errno;
+		return fd;
 
 	ret = io_uring_queue_mmap(fd, p, ring);
 	if (ret) {
diff --git a/src/syscall.c b/src/syscall.c
index 69027e5..0ecc17b 100644
--- a/src/syscall.c
+++ b/src/syscall.c
@@ -4,6 +4,7 @@
 /*
  * Will go away once libc support is there
  */
+#include <errno.h>
 #include <unistd.h>
 #include <sys/syscall.h>
 #include <sys/uio.h>
@@ -59,15 +60,53 @@ int __sys_io_uring_setup(unsigned entries, struct io_uring_params *p)
 }
 
 int __sys_io_uring_enter2(int fd, unsigned to_submit, unsigned min_complete,
-			 unsigned flags, sigset_t *sig, int sz)
+			  unsigned flags, sigset_t *sig, int sz)
 {
 	return syscall(__NR_io_uring_enter, fd, to_submit, min_complete,
-			flags, sig, sz);
+		       flags, sig, sz);
 }
 
 int __sys_io_uring_enter(int fd, unsigned to_submit, unsigned min_complete,
 			 unsigned flags, sigset_t *sig)
 {
 	return __sys_io_uring_enter2(fd, to_submit, min_complete, flags, sig,
-					_NSIG / 8);
+				     _NSIG / 8);
+}
+
+
+/*
+ * Syscall with kernel style return value.
+ */
+int ____sys_io_uring_register(int fd, unsigned opcode, const void *arg,
+			      unsigned nr_args)
+{
+	int ret;
+
+	ret = syscall(__NR_io_uring_register, fd, opcode, arg, nr_args);
+	return (ret < 0) ? -errno : ret;
+}
+
+int ____sys_io_uring_setup(unsigned entries, struct io_uring_params *p)
+{
+	int ret;
+
+	ret = syscall(__NR_io_uring_setup, entries, p);
+	return (ret < 0) ? -errno : ret;
+}
+
+int ____sys_io_uring_enter2(int fd, unsigned to_submit, unsigned min_complete,
+			    unsigned flags, sigset_t *sig, int sz)
+{
+	int ret;
+
+	ret = syscall(__NR_io_uring_enter, fd, to_submit, min_complete,
+		      flags, sig, sz);
+	return (ret < 0) ? -errno : ret;
+}
+
+int ____sys_io_uring_enter(int fd, unsigned to_submit, unsigned min_complete,
+			   unsigned flags, sigset_t *sig)
+{
+	return ____sys_io_uring_enter2(fd, to_submit, min_complete, flags, sig,
+				       _NSIG / 8);
 }
diff --git a/src/syscall.h b/src/syscall.h
index 2368f83..8cd2d4c 100644
--- a/src/syscall.h
+++ b/src/syscall.h
@@ -17,4 +17,12 @@ int __sys_io_uring_enter2(int fd, unsigned to_submit, unsigned min_complete,
 int __sys_io_uring_register(int fd, unsigned int opcode, const void *arg,
 			    unsigned int nr_args);
 
+int ____sys_io_uring_setup(unsigned entries, struct io_uring_params *p);
+int ____sys_io_uring_enter(int fd, unsigned to_submit, unsigned min_complete,
+			   unsigned flags, sigset_t *sig);
+int ____sys_io_uring_enter2(int fd, unsigned to_submit, unsigned min_complete,
+			    unsigned flags, sigset_t *sig, int sz);
+int ____sys_io_uring_register(int fd, unsigned int opcode, const void *arg,
+			      unsigned int nr_args);
+
 #endif
-- 
2.30.2

