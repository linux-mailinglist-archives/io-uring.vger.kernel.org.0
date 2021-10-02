Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9615741F942
	for <lists+io-uring@lfdr.de>; Sat,  2 Oct 2021 03:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbhJBBym (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Oct 2021 21:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbhJBBym (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Oct 2021 21:54:42 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D22C061775
        for <io-uring@vger.kernel.org>; Fri,  1 Oct 2021 18:52:57 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 75so10995097pga.3
        for <io-uring@vger.kernel.org>; Fri, 01 Oct 2021 18:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MIxcqCy97TjdhEt5Y0qD9d6+T0WPosXSHMeLqoha+nc=;
        b=T5gWqxy8GJAB6ElOb7XWadaZuLfGfD4uZxSMLA8AwSkEto0ONGk5yXWPeLka7HDOwv
         y7vWn5HmUiH4ZhRo3xQjJ1rXqFPhTgSYXGlaPf/KCGMtX37aOu88avKWFTGrJ+foal9d
         zfoWpxfIaAz8X7TrU60mmESbRpLb4nEPnczExIe/CptcppBDZX6K0p5Keo107aGFZ9LM
         9WZQH7r2a/odYotsXXRqf0cS1fLo2OUFJPQqlE+nUlvPdeGJcnXF0A6omyS1Fq8ZWVj4
         g1r4Jz+TcQHLE5uIiWVMpsI7Urq0QX7GMEpm6hA+y3IZuaGNkspRhdfg+hwW7otkd00i
         jzNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MIxcqCy97TjdhEt5Y0qD9d6+T0WPosXSHMeLqoha+nc=;
        b=ka52/35Xu4lrgm5A9QtQ5RawsuyKrjT8ivX9RPVa0tN/n/6q7POhJYfa5wIJiiESEI
         NlcX2+tBZCFXaUDg/XgdfiGeBbdmEknVjHP82M4oH4JX+ZkZjAtQ3wIqngkXmPTemNPt
         PUnrUgLYCA3ghpO9cz0N6dBVGZQfq7p3zTUrsBoZzGnwjLoo/Hn8qy4CoLUpGAI7AFsT
         iJgxdxC7yCoYrUKqL6nl8HicfK41qutSI8V4tk1myqVgWi8me06uCKr3+HrIcrtr+NtJ
         F3bpBUTR+IgxFm9z7dpe/JBvGPDM2rvDRcoU3Yw36R73C7J6E9vcg2NgG1+keWJyiap9
         4oHQ==
X-Gm-Message-State: AOAM532AWbK6+Z9B628H9kaCG2vR7Einia5Xi4kerdYRPeJfgNao+y72
        6jk3n/6Irrbws0I0BvOPivzGZodyjqVIe/zf6OY=
X-Google-Smtp-Source: ABdhPJzXFx4NTjHqGrW+zgrWxCZrSIegwpls41VFOlG9jBIdUKPBI5J4BEswmpeANguYMPZknxyA7Q==
X-Received: by 2002:a63:cc08:: with SMTP id x8mr1023733pgf.166.1633139577154;
        Fri, 01 Oct 2021 18:52:57 -0700 (PDT)
Received: from integral.. ([182.2.69.211])
        by smtp.gmail.com with ESMTPSA id u4sm6989804pfn.190.2021.10.01.18.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 18:52:56 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Ammar Faizi <ammarfaizi2@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH v3 RFC liburing 2/4] src/{queue,register,setup}: Don't use `__sys_io_uring*`
Date:   Sat,  2 Oct 2021 08:48:27 +0700
Message-Id: <20211002014829.109096-3-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211002014829.109096-1-ammar.faizi@students.amikom.ac.id>
References: <20211002014829.109096-1-ammar.faizi@students.amikom.ac.id>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't use `__sys_io_uring*` for liburing internal. These functions
are now supposed for user backward compatibility. Instead, we use
`____sys_io_uring*` (4 underscores). These are `static inline`
functions that wrap the `errno` variable with the kernel style return
value (directly returns negative error code when errors).

The main purpose of this change is to make it possible to remove the
`errno` variable dependency from liburing C sources, so that later
we will be able to implement no libc environment which doesn't use
`errno` variable at all.

Cc: Bedirhan KURT <windowz414@gnuweeb.org>
Cc: Louvian Lyndal <louvianlyndal@gmail.com>
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 src/queue.c    |  27 +++-----
 src/register.c | 184 ++++++++++++++++---------------------------------
 src/setup.c    |   4 +-
 src/syscall.c  |   6 +-
 4 files changed, 73 insertions(+), 148 deletions(-)

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
index 221f0f1..dfadf83 100644
--- a/src/syscall.c
+++ b/src/syscall.c
@@ -25,13 +25,13 @@ int __sys_io_uring_setup(unsigned entries, struct io_uring_params *p)
 int __sys_io_uring_enter2(int fd, unsigned to_submit, unsigned min_complete,
 			 unsigned flags, sigset_t *sig, int sz)
 {
-	return syscall(__NR_io_uring_enter, fd, to_submit, min_complete,
-			flags, sig, sz);
+	return syscall(__NR_io_uring_enter, fd, to_submit, min_complete, flags,
+		       sig, sz);
 }
 
 int __sys_io_uring_enter(int fd, unsigned to_submit, unsigned min_complete,
 			 unsigned flags, sigset_t *sig)
 {
 	return __sys_io_uring_enter2(fd, to_submit, min_complete, flags, sig,
-					_NSIG / 8);
+				     _NSIG / 8);
 }
-- 
2.30.2

