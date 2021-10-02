Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2582C41F92B
	for <lists+io-uring@lfdr.de>; Sat,  2 Oct 2021 03:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbhJBBbR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Oct 2021 21:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbhJBBbQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Oct 2021 21:31:16 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40BEC061775
        for <io-uring@vger.kernel.org>; Fri,  1 Oct 2021 18:29:31 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id a73so8019310pge.0
        for <io-uring@vger.kernel.org>; Fri, 01 Oct 2021 18:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AQIuX3Xq9n2y7a4RNbqWviFcLlR/fNVwf+qGpprsJZU=;
        b=dMBH2JFCi3DimIOJ2DIJ/xvH47GOsNObz+tizmSsXyXpxHOyhSetIBFimoM0kqUsSV
         v5y4BfaisWbmlST50cIZxclxVpslJriYJwM28LRyyQR/n6qcSGPOIHqkskVzn842Rw3F
         /3oB1XaGAqInWxGSyHSPv2CqQak9TuinhIfcWe9L6zyzFVeZ7Lfx2/JquA0k0BKsPR4D
         V6gcIpwDcrG2yroJDTisTnAR4YbTbxhl9PQGTbTUUTLjdsEz8Vsjju3wqOgy4SwXz9g2
         HrWEKCWDDzhbn+gLI79uzpiBAQmjnLOIUodefppHF0/F/+X9WqP6Q7nnkSNSiBFY82UC
         Rypw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AQIuX3Xq9n2y7a4RNbqWviFcLlR/fNVwf+qGpprsJZU=;
        b=mnnp9h5n6bu7nX7UcNc2MtlxMssbFIxLssWz1p+HCN4D+pukiT7cJu7N3UR5GnLUVH
         grYxxRJUsZ0aV6mX85OLLTzxbwsgopACQ3+PlEdRLEpEFOlp8phKvwF4TSoUJfSKYyTv
         7xasXmPCq+kTEGkc41YblmUE6ChXyaOavsWQLtsI0hS338syYtL2/DohY5DpnAQgtA53
         /Oc36+luwU/11kMXn/Ro8YqSwIc59AgRRL1pf2ve4/3KAjZMtUPb4FR2MwEO1+DIsJPe
         R5QWj0q04g4/PFTVpRDaLAwMSsefef4AilACyHU9E0f0CHxhkjCD3xChRkp4vXv6FKuT
         Zgkw==
X-Gm-Message-State: AOAM530m5+eP2OlrXfQ/UfYCGJd1IkE5Os8AVOv8hgjyBvILg6dQLWdJ
        EZgPyKqHx9Xp2fqQ+ltFdhmzZHqGn2Vt/EUEZd0=
X-Google-Smtp-Source: ABdhPJz/w9m50ZxowE+TReUthJhXe0nT1ctMzmRMxubswgqJ1fkl0Gckl7v7ve94jIWloplYnJVMtQ==
X-Received: by 2002:a63:d250:: with SMTP id t16mr934071pgi.95.1633138171177;
        Fri, 01 Oct 2021 18:29:31 -0700 (PDT)
Received: from integral.. ([182.2.69.211])
        by smtp.gmail.com with ESMTPSA id b13sm867654pjl.15.2021.10.01.18.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 18:29:30 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Ammar Faizi <ammarfaizi2@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH v2 RFC liburing 2/4] src/{queue,register,setup}: Don't use `__sys_io_uring*`
Date:   Sat,  2 Oct 2021 08:28:15 +0700
Message-Id: <20211002012817.107517-3-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211002012817.107517-1-ammar.faizi@students.amikom.ac.id>
References: <20211002012817.107517-1-ammar.faizi@students.amikom.ac.id>
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
Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
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

