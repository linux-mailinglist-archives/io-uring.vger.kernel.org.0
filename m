Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C8E42024D
	for <lists+io-uring@lfdr.de>; Sun,  3 Oct 2021 17:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbhJCPhN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Oct 2021 11:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbhJCPhM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Oct 2021 11:37:12 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70543C0613EC
        for <io-uring@vger.kernel.org>; Sun,  3 Oct 2021 08:35:25 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id y5so9476671pll.3
        for <io-uring@vger.kernel.org>; Sun, 03 Oct 2021 08:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0rvkQDmhox/kHqrRd44qinkRpcry6FXqkJ7Wxxk/J+8=;
        b=Y+6xIAOGR2ldndYIslDHgDrLlMA4actysCoUPZvnLMncwndhHxEhLdGGEkwNoCR44V
         tkpLLedQ9luXXWNrGI2qUgbLc5K9PTkUSq4T/tPNA5DiCaEY/PykmuHaahN/HVIp/m04
         5RPlFAStpKbnYLDUen5VXKFCip+2Rf7ps8xxGz6W54yZL6ZMEHVr4NCOSfAMAt0g738r
         iRtdiK2PysCYPMu5u0VMjcVAPGlZcsHKl4hbVTSEpQEVSZyNi/iHeAdxLJhLxnaAeXDG
         8qqAYY4JxjfMF4SOryluVKAuCwsqTuSK4a4kN7t2en98hDBoScby3a5NogWVzzU8owgo
         rfNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0rvkQDmhox/kHqrRd44qinkRpcry6FXqkJ7Wxxk/J+8=;
        b=W5POhIUJmwROawqHeTCvR9m9PVsgcoTTG3PubNP5TkQgvfJc4J1YmxVaFi6oaGunnu
         pmBY/GWWA/6zWS8jqTO3CIF1Ezc4MxUXbYD2zWSSonZnZWA+pa93H2aC2PeuUz4Qayh9
         0SqzDD79m6c/GQxzqlYyAbnsqSLYKp6QKRU86Mn+5om0oaTe7p1qba3KTa09J/wsQp19
         mJ3mUGRrACPiTrPhd1xmaLtj+2BNiCBspYO5s2eG7Ltj4kiGDGBa91Cs0qrrrdVVkQIP
         4kzq3j3pzenfmvxEE+I+SwPSQiT5S0OPO/DFl5Pu8t7RgA3Hnn2sdcPWinNiHEn2Ymoh
         5u6g==
X-Gm-Message-State: AOAM530BeenktWkehAX+pVI34kzeAjaW9bTrg71yo/2cgdOOqjlcLCPp
        9GmlDlL9SmH3CxNdib7epkiIZUZbmLy0zo7H
X-Google-Smtp-Source: ABdhPJyhflyKON9BxTb8i+ClWlCyrwaG1+YwtG1gt9GK0phbWd849Zf5nhRo745XGGK4skyXjSUzMA==
X-Received: by 2002:a17:903:248f:b029:128:d5ea:18a7 with SMTP id p15-20020a170903248fb0290128d5ea18a7mr19291285plw.83.1633275324903;
        Sun, 03 Oct 2021 08:35:24 -0700 (PDT)
Received: from integral.. ([182.2.73.133])
        by smtp.gmail.com with ESMTPSA id y42sm2625075pfa.203.2021.10.03.08.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 08:35:24 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH v5 liburing 2/3] src/{queue,register,setup}: Don't use `__sys_io_uring*`
Date:   Sun,  3 Oct 2021 22:34:27 +0700
Message-Id: <20211003153428.369258-3-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211003153428.369258-1-ammar.faizi@students.amikom.ac.id>
References: <20211003153428.369258-1-ammar.faizi@students.amikom.ac.id>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't use `__sys_io_uring*` for liburing internal. These functions
are now supposed for user backward compatibility.

For now, we use `____sys_io_uring*` (4 underscores). These are
`static inline` functions that wrap the `errno` variable in a kernel
style return value (directly returns negative error code when errors).

The main purpose of this change is to make it possible to remove the
`errno` variable dependency from liburing C sources, so that later
we will be able to build liburing without libc which doesn't use
`errno` variable at all.

Cc: Bedirhan KURT <windowz414@gnuweeb.org>
Cc: Louvian Lyndal <louvianlyndal@gmail.com>
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 src/queue.c    |  27 +++----
 src/register.c | 187 +++++++++++++++----------------------------------
 src/setup.c    |   4 +-
 3 files changed, 70 insertions(+), 148 deletions(-)

diff --git a/src/queue.c b/src/queue.c
index 10ef31c..c2881e9 100644
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
+	return  ____sys_io_uring_enter(ring->ring_fd, 0, 0,
+				       IORING_ENTER_SQ_WAIT, NULL);
 }
diff --git a/src/register.c b/src/register.c
index 5ea4331..cb09dea 100644
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
@@ -44,11 +42,9 @@ int io_uring_register_buffers_tags(struct io_uring *ring,
 		.data = (unsigned long)iovecs,
 		.tags = (unsigned long)tags,
 	};
-	int ret;
 
-	ret = __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_BUFFERS2,
-				      &reg, sizeof(reg));
-	return ret < 0 ? -errno : ret;
+	return ____sys_io_uring_register(ring->ring_fd, IORING_REGISTER_BUFFERS2,
+					 &reg, sizeof(reg));
 }
 
 int io_uring_register_buffers(struct io_uring *ring, const struct iovec *iovecs,
@@ -56,24 +52,18 @@ int io_uring_register_buffers(struct io_uring *ring, const struct iovec *iovecs,
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
@@ -86,12 +76,10 @@ int io_uring_register_files_update_tag(struct io_uring *ring, unsigned off,
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
@@ -108,15 +96,10 @@ int io_uring_register_files_update(struct io_uring *ring, unsigned off,
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
@@ -133,9 +116,8 @@ static int increase_rlimit_nofile(unsigned nr)
 	return 0;
 }
 
-int io_uring_register_files_tags(struct io_uring *ring,
-				 const int *files, const __u64 *tags,
-				 unsigned nr)
+int io_uring_register_files_tags(struct io_uring *ring, const int *files,
+				 const __u64 *tags, unsigned nr)
 {
 	struct io_uring_rsrc_register reg = {
 		.nr = nr,
@@ -145,12 +127,12 @@ int io_uring_register_files_tags(struct io_uring *ring,
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
@@ -158,21 +140,21 @@ int io_uring_register_files_tags(struct io_uring *ring,
 		break;
 	} while (1);
 
-	return ret < 0 ? -errno : ret;
+	return ret;
 }
 
 int io_uring_register_files(struct io_uring *ring, const int *files,
-			      unsigned nr_files)
+			    unsigned nr_files)
 {
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
@@ -180,55 +162,44 @@ int io_uring_register_files(struct io_uring *ring, const int *files,
 		break;
 	} while (1);
 
-	return ret < 0 ? -errno : ret;
+	return ret;
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
+	ret = ____sys_io_uring_register(ring->ring_fd, IORING_UNREGISTER_EVENTFD,
 					NULL, 0);
-	if (ret < 0)
-		return -errno;
-
-	return 0;
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
@@ -236,36 +207,21 @@ int io_uring_register_probe(struct io_uring *ring, struct io_uring_probe *p,
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
+					 IORING_UNREGISTER_PERSONALITY, NULL, id);
 }
 
 int io_uring_register_restrictions(struct io_uring *ring,
@@ -274,61 +230,34 @@ int io_uring_register_restrictions(struct io_uring *ring,
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
+	return ____sys_io_uring_register(ring->ring_fd, IORING_REGISTER_IOWQ_AFF,
+					 mask, cpusz);
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
+	return  ____sys_io_uring_register(ring->ring_fd,
+					  IORING_REGISTER_IOWQ_AFF, NULL, 0);
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
-- 
2.30.2

