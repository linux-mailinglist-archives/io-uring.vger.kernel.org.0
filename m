Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0B9427F5C
	for <lists+io-uring@lfdr.de>; Sun, 10 Oct 2021 08:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhJJGna (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Oct 2021 02:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbhJJGna (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 Oct 2021 02:43:30 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26729C061570
        for <io-uring@vger.kernel.org>; Sat,  9 Oct 2021 23:41:32 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id np13so10718139pjb.4
        for <io-uring@vger.kernel.org>; Sat, 09 Oct 2021 23:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kMwVvo4brrv5PNEwydXuxmSlXI/78hci5Kdr2RDGtGY=;
        b=eLeZqMv8b+hKE+K+Sk21AGVMSmzgDEEntksMpf5EjV3X2i8d0eyG2tx55zTGyUFOQY
         FTzhWbIehxcrT/tEdPIxfr5FJNdhlTvYwV8nBylTxyzbW9n0mm3sBybabUO7+xdnwQkR
         gu4Q/CsQAkZWsVPJTsEYDUKaiCkafPm6KkUVnX0iaInFIHlyqbzNQPF61bp+X+aqWJpn
         5l+s2rAsRKb1pMotNOwWMrgj1PZYSs9RamYe6AU8+6vePmQa5sVyZjMJ/W98ZQzker9b
         8uefFYYsU9FRm2a6UnREn77BJA4c7wgZ3FjQv7kZzl7rMQfwoEvslHdvVgSbCGoIlIVA
         iEyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kMwVvo4brrv5PNEwydXuxmSlXI/78hci5Kdr2RDGtGY=;
        b=ecN8uRDaAJ4f059w9+Ldg5hH7Qvk1njNvh+BBOI/GJNqu+8CCDV+sGOy7bwBgBmaF2
         B8s62hO6WYdmokZPKXMn64g8e7PyepM7T38EI0V2REwXkkJdb+yvoCIgOxX0T6CtgAyD
         GaZRH7otqnMbkkXhg0FoWrk+pYh1D7ZBk6p9CdIM+XQK826c5Jybja73EX2ESPY65jM2
         JFenP/3NSML7o3wMHI+QueTc8iAPKLlSYn+DiZvvFvaY61zwOCo5vzKMHt21O9tN2252
         oQwd7Pnwc1KpTeMmBNr8R/kAIQg7DByM+KLwqNDx59v6+zZy/xryyB9cAFgLCDvgMxQK
         +fpg==
X-Gm-Message-State: AOAM531zeIyvdjCRzC1GRu9Z39ZRT6eLUci/hT/tbN1AUtvr1kE6HBcl
        ndDGb9pbSTAf+iJERW0PYTJCyw==
X-Google-Smtp-Source: ABdhPJzChHtfeukQntRnjnn2UckghlhqhfKPdP/+d6+Cqlu6j+6BE64hCQgllcbyM+Pkw9hHBmaXug==
X-Received: by 2002:a17:90b:1e4a:: with SMTP id pi10mr22592430pjb.142.1633848091654;
        Sat, 09 Oct 2021 23:41:31 -0700 (PDT)
Received: from integral.. ([182.2.39.79])
        by smtp.gmail.com with ESMTPSA id s25sm3742225pfm.138.2021.10.09.23.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 23:41:31 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH v2 liburing 1/4] test/thread-exit: Fix use after free bug
Date:   Sun, 10 Oct 2021 13:39:03 +0700
Message-Id: <20211010063906.341014-2-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211010063906.341014-1-ammar.faizi@students.amikom.ac.id>
References: <20211010063906.341014-1-ammar.faizi@students.amikom.ac.id>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When I add support for nolibc x86-64, I find this test failed.

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
index 7f66028..b26d4aa 100644
--- a/test/thread-exit.c
+++ b/test/thread-exit.c
@@ -26,8 +26,18 @@ struct d {
 	unsigned long off;
 	int pipe_fd;
 	int err;
+	int i;
 };
 
+static char *g_buf[NR_IOS] = {NULL};
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

