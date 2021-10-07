Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E734255F5
	for <lists+io-uring@lfdr.de>; Thu,  7 Oct 2021 17:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233341AbhJGPE6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Oct 2021 11:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242052AbhJGPE5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Oct 2021 11:04:57 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C5DC061570
        for <io-uring@vger.kernel.org>; Thu,  7 Oct 2021 08:03:04 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id qe4-20020a17090b4f8400b0019f663cfcd1so7131252pjb.1
        for <io-uring@vger.kernel.org>; Thu, 07 Oct 2021 08:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GP3Fjj24bmh3jIKMrih3hy/PY/cNqt4aIoh6xa/tGCo=;
        b=B3HL+9FC9e6rVPDMFe97ERdp6FSTpKCVEC7WkeWHNuzlSUHjaL3BMgJnUy7hMhTU2D
         r4Ml8svom5joutZrsiGblt2LJ55ssAW2ZyS8gcnDx+uX1a9Gd6DIJiAp63igZTxHKEnm
         eMCqUETRDQY4Mgezrf8MbSd/lIQM+bqmvvPLnyo27pbXHGRHDD53nnVLErZoA5vDjb6I
         8GmeqFTmLoyh/rmKkO4SQ8PqL/pfP6m9OEkqSgZlARUn9Bo2KfVUExtlAj38BpJpF1F2
         XhY8NrvV8xzOLP5EfZVoWf9HAKQB2OrbeHYJ4kDT0xXFfMUgNDWOnPL5xOwcSuV+pBWh
         el1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GP3Fjj24bmh3jIKMrih3hy/PY/cNqt4aIoh6xa/tGCo=;
        b=Ovo/s/p+OpUH221FaCmIbJrRFZK+PI49q5sI2PbkvmyH+TBQkCuMXFU70Dk0qsAmVM
         49avwywnmQilRT3AypEswLCIn8cIE4OWtoQCv8GEXsRRIafMXXFCxO7QLljW5+0sh1nq
         6avOqrdxHlC/cn+a/I8bmA+zSZ7nt5gIAlg8n4cAAFNxwt9XCe7t5tU+Jq795rOnz3TM
         sk4woHl7ncPv0eMumsQMkNWTmBaY1eFRq2MpxaJ4QxfLIX6Z/nSzrM5IPc/DiMZfHiq+
         7rTN0ct6rpv1zcxa5mcOJY7cXH81wEU4oIKAfxcIffVTZzwQbI0zop7ApKWh/xMiAfx6
         rMJQ==
X-Gm-Message-State: AOAM530cepkPcU0CwoWuSPxxtSi5Q+nmwNNByFvZYR/F3/3rjGc0QOCn
        sgSoyRoFr5Flay6YKxHNtqsDBU/TyUZOg2S/
X-Google-Smtp-Source: ABdhPJzwMY2y1uMcIpttbig59CYaN7guACvFugG/CEz+i34T8NnpBZq90SnAHq6Tzu0/ZW/Jg4uIWg==
X-Received: by 2002:a17:90a:d904:: with SMTP id c4mr6027970pjv.7.1633618983486;
        Thu, 07 Oct 2021 08:03:03 -0700 (PDT)
Received: from integral.. ([182.2.71.117])
        by smtp.gmail.com with ESMTPSA id z23sm25078983pgv.45.2021.10.07.08.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 08:03:02 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH liburing 1/4] test/thread-exit: Fix use after free bug
Date:   Thu,  7 Oct 2021 22:02:07 +0700
Message-Id: <20211007150210.1390189-2-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211007150210.1390189-1-ammar.faizi@students.amikom.ac.id>
References: <20211007063157.1311033-1-ammar.faizi@students.amikom.ac.id>
 <20211007150210.1390189-1-ammar.faizi@students.amikom.ac.id>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When I added support for nolibc x86-64, I found this test failed.

Long story short, we provide our own `free()` that always unmaps the VM
with `munmap()`. It makes the CQE return -EFAULT because the kernel
reads unmapped user memory from the pending `write()` SQE.

I believe this test can run properly with libc build because `free()`
from libc doesn't always unmap the memory, instead it uses free list on
the userspace and the freed heap may still be userspace addressable.

Fix this by deferring the free.

Cc: Jens Axboe <axboe@kernel.dk>
Fixes: 2edfa3f84bcc44612b7a04caf1f048f5406fcc7a ("Add test case for thread exiting with pending IO")
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 test/thread-exit.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/test/thread-exit.c b/test/thread-exit.c
index 7f66028..05509fb 100644
--- a/test/thread-exit.c
+++ b/test/thread-exit.c
@@ -26,8 +26,18 @@ struct d {
 	unsigned long off;
 	int pipe_fd;
 	int err;
+	int i;
 };
 
+char *g_buf[NR_IOS] = {NULL};
+
+static void free_g_buf(void)
+{
+	int i;
+	for (i = 0; i < NR_IOS; i++)
+		free(g_buf[i]);
+}
+
 static void *do_io(void *data)
 {
 	struct d *d = data;
@@ -36,6 +46,7 @@ static void *do_io(void *data)
 	int ret;
 
 	buffer = t_malloc(WSIZE);
+	g_buf[d->i] = buffer;
 	memset(buffer, 0x5a, WSIZE);
 	sqe = io_uring_get_sqe(d->ring);
 	if (!sqe) {
@@ -55,8 +66,6 @@ static void *do_io(void *data)
 	ret = io_uring_submit(d->ring);
 	if (ret != 2)
 		d->err++;
-
-	free(buffer);
 	return NULL;
 }
 
@@ -103,6 +112,7 @@ int main(int argc, char *argv[])
 	d.pipe_fd = fds[0];
 	d.err = 0;
 	for (i = 0; i < NR_IOS; i++) {
+		d.i = i;
 		memset(&thread, 0, sizeof(thread));
 		pthread_create(&thread, NULL, do_io, &d);
 		pthread_join(thread, NULL);
@@ -125,7 +135,9 @@ int main(int argc, char *argv[])
 		io_uring_cqe_seen(&ring, cqe);
 	}
 
+	free_g_buf();
 	return d.err;
 err:
+	free_g_buf();
 	return 1;
 }
-- 
2.30.2

