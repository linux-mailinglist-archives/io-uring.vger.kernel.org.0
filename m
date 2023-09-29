Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904847B3251
	for <lists+io-uring@lfdr.de>; Fri, 29 Sep 2023 14:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbjI2MTe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Sep 2023 08:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233104AbjI2MTd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Sep 2023 08:19:33 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71B41AA
        for <io-uring@vger.kernel.org>; Fri, 29 Sep 2023 05:19:30 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-9b2a3fd5764so917529766b.3
        for <io-uring@vger.kernel.org>; Fri, 29 Sep 2023 05:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695989969; x=1696594769; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ulVvW615VPsTtfY/4LxyFFeBHjVL6ceIjRQf5PNOTeo=;
        b=KFl+nZMvGZw4BFf9wyoH2wwVbHrMeY1jSk3KVOyKJc71Ii4Dd3dhynpl7PA552OkCu
         6Ch/02B2oQchSL7LWAbaXoVUCpI6KJ2SsgpnrsxkKPYJNhJX7h+8VYh9xEozPGnPYULw
         4m3iQN4Z2+PcvGVcOh+F0h0QXKZDbUK9lOxDTgaDirSJkUZuZhkFezXdSGjNYfE6DqWL
         +9ECl9B/F0eP7Xc5nJ5csAZkxKTVuWYGKL1dCWpe69prKG/B8cX3m4WD98hQppN3ak6S
         6hBNAcTtuB3lnthl7Y8awuLU4QLX6De1WsA7MBsEVb9+6fp8xaK5Dra+nAsKqq8Aexyh
         aO0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695989969; x=1696594769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ulVvW615VPsTtfY/4LxyFFeBHjVL6ceIjRQf5PNOTeo=;
        b=Hz74CWcDZSewYsliFR9lTVOIN0PoQOGMH1P+3/t0BPZz14p0rweaDfVaK2m404kqMf
         BS7StL0Ls2irPA/axJ0CCfkIHB4eRj55XvkTfyYNwlCXmQLKuvK86KqsrerBm5pr6MjQ
         n+i9LbD3F7vR4NBdwHX1cwXys4j3gDd+dsMZp5km2w3DIIaNR+UNOs8IU7v8yDb4rW6K
         sSWB5iDa1GdxcnsYLEluR6wTv6BXRZUDiyoxwt/wjVBodrFzfJBC3QRxMGFzLynKGMpL
         5WeTAthUEXbLjf0ieuzwidUNu7lm2iX/zv4HWAUVaXQHlN9HWITs/dM983DNB/Xk9uwT
         VyYQ==
X-Gm-Message-State: AOJu0YzT2SAxDyl0ev1IAeZ+Wb1lpWzyUEgsT99d08t6cA894cLDnc8O
        VY0j4ruMdhQtkb/2/uXGEtqXosnBlYLiqQ==
X-Google-Smtp-Source: AGHT+IED76XbNXp6cpCl/mcYD4G1uptKlB/J9+3+rdHYwAoyYZt3vUJbrYtgYPbDbUdxDm+Sn4JmZQ==
X-Received: by 2002:a17:906:2da:b0:9b2:b2f8:85d9 with SMTP id 26-20020a17090602da00b009b2b2f885d9mr3698268ejk.56.1695989968917;
        Fri, 29 Sep 2023 05:19:28 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-229-128.dab.02.net. [82.132.229.128])
        by smtp.gmail.com with ESMTPSA id jx10-20020a170906ca4a00b009ad87d1be17sm12211878ejb.22.2023.09.29.05.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Sep 2023 05:19:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 2/2] setup: default to IORING_SETUP_NO_SQARRAY
Date:   Fri, 29 Sep 2023 13:09:41 +0100
Message-ID: <3320b1472ff8bf5af73a17796fd6b103ed4f3e11.1695988793.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1695988793.git.asml.silence@gmail.com>
References: <cover.1695988793.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have never exposed sq_array to users, so we can safely add
IORING_SETUP_NO_SQARRAY to all rings. If the kernel is too old and it
fails, we'll retry creating a ring without it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/setup.c           | 28 +++++++++++++++++++++++-----
 test/accept-reuse.c   |  2 +-
 test/helpers.h        | 13 +++++++++++++
 test/io_uring_enter.c |  7 +++++--
 4 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/src/setup.c b/src/setup.c
index a0e8296..6b3f538 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -287,9 +287,9 @@ static int io_uring_alloc_huge(unsigned entries, struct io_uring_params *p,
 	return (int) mem_used;
 }
 
-static int __io_uring_queue_init_params(unsigned entries, struct io_uring *ring,
-					struct io_uring_params *p, void *buf,
-					size_t buf_size)
+int __io_uring_queue_init_params(unsigned entries, struct io_uring *ring,
+				 struct io_uring_params *p, void *buf,
+				 size_t buf_size)
 {
 	int fd, ret = 0;
 	unsigned *sq_array;
@@ -357,6 +357,24 @@ static int __io_uring_queue_init_params(unsigned entries, struct io_uring *ring,
 	return ret;
 }
 
+static int io_uring_queue_init_try_nosqarr(unsigned entries, struct io_uring *ring,
+					   struct io_uring_params *p, void *buf,
+					   size_t buf_size)
+{
+	unsigned flags = p->flags;
+	int ret;
+
+	p->flags |= IORING_SETUP_NO_SQARRAY;
+	ret = __io_uring_queue_init_params(entries, ring, p, buf, buf_size);
+
+	/* don't fallback if explicitly asked for NOSQARRAY */
+	if (ret != -EINVAL || (flags & IORING_SETUP_NO_SQARRAY))
+		return ret;
+
+	p->flags = flags;
+	return __io_uring_queue_init_params(entries, ring, p, buf, buf_size);
+}
+
 /*
  * Like io_uring_queue_init_params(), except it allows the application to pass
  * in a pre-allocated memory range that is used for the shared data between
@@ -375,7 +393,7 @@ int io_uring_queue_init_mem(unsigned entries, struct io_uring *ring,
 {
 	/* should already be set... */
 	p->flags |= IORING_SETUP_NO_MMAP;
-	return __io_uring_queue_init_params(entries, ring, p, buf, buf_size);
+	return io_uring_queue_init_try_nosqarr(entries, ring, p, buf, buf_size);
 }
 
 int io_uring_queue_init_params(unsigned entries, struct io_uring *ring,
@@ -383,7 +401,7 @@ int io_uring_queue_init_params(unsigned entries, struct io_uring *ring,
 {
 	int ret;
 
-	ret = __io_uring_queue_init_params(entries, ring, p, NULL, 0);
+	ret = io_uring_queue_init_try_nosqarr(entries, ring, p, NULL, 0);
 	return ret >= 0 ? 0 : ret;
 }
 
diff --git a/test/accept-reuse.c b/test/accept-reuse.c
index 1f10b45..716f201 100644
--- a/test/accept-reuse.c
+++ b/test/accept-reuse.c
@@ -45,7 +45,7 @@ int main(int argc, char **argv)
 		return T_EXIT_SKIP;
 
 	memset(&params, 0, sizeof(params));
-	ret = io_uring_queue_init_params(4, &io_uring, &params);
+	ret = t_io_uring_init_sqarray(4, &io_uring, &params);
 	if (ret) {
 		fprintf(stderr, "io_uring_init_failed: %d\n", ret);
 		return T_EXIT_FAIL;
diff --git a/test/helpers.h b/test/helpers.h
index 5307324..d91c1dc 100644
--- a/test/helpers.h
+++ b/test/helpers.h
@@ -87,6 +87,19 @@ bool t_probe_defer_taskrun(void);
 
 unsigned __io_uring_flush_sq(struct io_uring *ring);
 
+int __io_uring_queue_init_params(unsigned entries, struct io_uring *ring,
+				 struct io_uring_params *p, void *buf,
+				 size_t buf_size);
+
+static inline int t_io_uring_init_sqarray(unsigned entries, struct io_uring *ring,
+					struct io_uring_params *p)
+{
+	int ret;
+
+	ret = __io_uring_queue_init_params(entries, ring, p, NULL, 0);
+	return ret >= 0 ? 0 : ret;
+}
+
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 
 void t_error(int status, int errnum, const char *format, ...);
diff --git a/test/io_uring_enter.c b/test/io_uring_enter.c
index ecd54ff..2a6b6be 100644
--- a/test/io_uring_enter.c
+++ b/test/io_uring_enter.c
@@ -183,13 +183,16 @@ int main(int argc, char **argv)
 	unsigned ktail, mask, index;
 	unsigned sq_entries;
 	unsigned completed, dropped;
+	struct io_uring_params p;
 
 	if (argc > 1)
 		return T_EXIT_SKIP;
 
-	ret = io_uring_queue_init(IORING_MAX_ENTRIES, &ring, 0);
+	memset(&p, 0, sizeof(p));
+	ret = t_io_uring_init_sqarray(IORING_MAX_ENTRIES, &ring, &p);
 	if (ret == -ENOMEM)
-		ret = io_uring_queue_init(IORING_MAX_ENTRIES_FALLBACK, &ring, 0);
+		ret = t_io_uring_init_sqarray(IORING_MAX_ENTRIES_FALLBACK,
+					      &ring, &p);
 	if (ret < 0) {
 		perror("io_uring_queue_init");
 		exit(T_EXIT_FAIL);
-- 
2.41.0

