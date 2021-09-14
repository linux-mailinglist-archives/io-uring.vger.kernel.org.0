Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB2A40B4D7
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 18:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhINQgz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 12:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhINQgi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 12:36:38 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291C1C061574
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 09:35:18 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id y17so12785713pfl.13
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 09:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=cXdqgOgM3zyGVDpg8rFKVZ+EzFmGbl9hnXvMZY5TjL4=;
        b=Z0JwEyrl3tToVhFXghDqjA9EjX3rYLBJ4ZP9kkGKZQ/EbwVa9raR4Del6PKsuteMzn
         A79fskT0hxa8jwSJWNBKi2jNJpSJtJE/lNCx90cwLAx+1Jljkk/aQK7C/cV4slCudICc
         UV/bsSlvipRvfe4PY/xeP6QeafoXoam3q3NAeYxx/LoyqUvay+p6B3TWCRMw8CX8dGCh
         SIWGkc+RtaT6NpVhkIoCT61BNCkDwHtCpVSXSWTSAppIGHif8A+3HR0JRgMM1gIvF6V7
         0tN9xJ1EmkmVLfSN7j7T0zKNwnkgFbiEypScKgvhiBs4FMkgE4mbWFZ0kK1IP+8/6oMU
         enlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=cXdqgOgM3zyGVDpg8rFKVZ+EzFmGbl9hnXvMZY5TjL4=;
        b=QesugVeOT/cEqb1A9QVImN8pBB0BfdEhVWgRsvvu7znVFJS7wKChTQ/29+hq3Wqd/t
         KGUvdOpd04cd1JkyeMQrnRlY7CpqYlGSLc+jxjOsAEK3o8l+OFIQAmqG0zP4iY4eggSY
         9HvcB3hiREwBsQ/pLIwt4h9IzW9wTiGFCEW/Plk4tOReaJfEPzShKsH8qw8ZTt/SI4Rh
         x530Q/jk/leObgU6S4zabeIbRNs8AIXN5f4aybchHZhYo1LJCXqb2lz7qJoS6oJCZO+5
         qZUKHbMennx5eGCkuyz8kB/rhIypCu76luDm5u8GVyjQkt5hewkk3rGS/W63ag/20CjD
         +Wug==
X-Gm-Message-State: AOAM530xXOO7Eb+9KcIusCPQ1Wwvjxi2qtTrkEfOVZY9oBoYfti8byyz
        hclJa8Ob+3C7jEsTari/4UttXlmT20nz/g==
X-Google-Smtp-Source: ABdhPJxT1LQ7c/fE++ghDXqbFTknJ3/VWyw0yQBY6z0dTbpAAP62pL8H3HOS7UBbFu1dgRZrPkiUZQ==
X-Received: by 2002:a62:1408:0:b0:412:44ab:750e with SMTP id 8-20020a621408000000b0041244ab750emr5490781pfu.82.1631637317173;
        Tue, 14 Sep 2021 09:35:17 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21c8::160b? ([2620:10d:c090:400::5:f3dc])
        by smtp.gmail.com with ESMTPSA id p9sm11011921pfn.97.2021.09.14.09.35.16
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 09:35:16 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: allow retry for O_NONBLOCK if async is support
Message-ID: <9f5329fb-d378-d45c-a638-7ebc6ff29f69@kernel.dk>
Date:   Tue, 14 Sep 2021 10:35:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A common complaint is that using O_NONBLOCK files with io_uring can be a
bit of a pain. Be a bit nicer and allow normal retry IFF the file does
support async behavior. This makes it possible to use io_uring more
reliably with O_NONBLOCK files, for use cases where it either isn't
possible or feasible to modify the file flags.

Cc: stable@vger.kernel.org
Reported--by: Dan Melnic <dmm@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d306ef0f4c10..722af90c74f2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2843,7 +2843,8 @@ static bool io_file_supports_nowait(struct io_kiocb *req, int rw)
 	return __io_file_supports_nowait(req->file, rw);
 }
 
-static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+		      int rw)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct kiocb *kiocb = &req->rw.kiocb;
@@ -2865,8 +2866,13 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (unlikely(ret))
 		return ret;
 
-	/* don't allow async punt for O_NONBLOCK or RWF_NOWAIT */
-	if ((kiocb->ki_flags & IOCB_NOWAIT) || (file->f_flags & O_NONBLOCK))
+	/*
+	 * If the file is marked O_NONBLOCK, still allow retry for it if it
+	 * supports async. Otherwise it's impossible to use O_NONBLOCK files
+	 * reliably. If not, or it IOCB_NOWAIT is set, don't retry.
+	 */
+	if ((kiocb->ki_flags & IOCB_NOWAIT) ||
+	    ((file->f_flags & O_NONBLOCK) && !io_file_supports_nowait(req, rw)))
 		req->flags |= REQ_F_NOWAIT;
 
 	ioprio = READ_ONCE(sqe->ioprio);
@@ -3354,7 +3360,7 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	if (unlikely(!(req->file->f_mode & FMODE_READ)))
 		return -EBADF;
-	return io_prep_rw(req, sqe);
+	return io_prep_rw(req, sqe, READ);
 }
 
 /*
@@ -3557,7 +3563,7 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
 		return -EBADF;
-	return io_prep_rw(req, sqe);
+	return io_prep_rw(req, sqe, WRITE);
 }
 
 static int io_write(struct io_kiocb *req, unsigned int issue_flags)

-- 
Jens Axboe

