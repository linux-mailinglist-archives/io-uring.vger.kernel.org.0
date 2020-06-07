Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D41F21F0CBB
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2020 18:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgFGQCu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Jun 2020 12:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgFGQCt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Jun 2020 12:02:49 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16915C08C5C3
        for <io-uring@vger.kernel.org>; Sun,  7 Jun 2020 09:02:48 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id x6so14714898wrm.13
        for <io-uring@vger.kernel.org>; Sun, 07 Jun 2020 09:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=eV26UY3HUxRVp8eu8Pm0JXvbzn5JWeCOMxq4MsnuVtE=;
        b=u8mOXxDIzNnHP4bESHi9GsYTuIY1G8QTZBVBGgabfuXvGjt7gEUi2nZ3w5vlm9qW7G
         Izlyg3HIpcoTYb+NBj619Xh3z+SDfj8BFq+1US69l7rh6O1B3VG5UXlFeU1lzeeh61YY
         TalruWnJunB21ho86mc1poW2c+zgw/ifQpxnXE3oCRdBqD2tpBKvMI8LeVnUUtUNTSxg
         iqVZayYVAiDxeCapi7aeJlL8FHL8xo2w+lIYf44f9N7J5w9kc82jMNiRtwZwAQ+vS/xm
         i1VGVHsNjTqFNf9/Fa2m1Hrx63kjKrJW+xlL9g+HOlf/KLcwiLszsOMZx6O3VCdJNI04
         Rj4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:autocrypt:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=eV26UY3HUxRVp8eu8Pm0JXvbzn5JWeCOMxq4MsnuVtE=;
        b=ItZh6ZP6OfsvmSk1sDOD8hrJ4RwWSJPl1geEHr8pazRfp3sf08X6hgHCeKoI40YWhU
         l2q7KudUVjtkAta1NhXLGY4xGVdLChJJMDY/w5IqTY5vXfaoQhgb3My2YTxlByobqtRy
         IvC4vt1EQGQeViPW5fMhPleCOoj8wO4YZznwBkCjytYxQVacoZGrhOXNZOBjvNwBqCNf
         e0nPFkmyu8w/sgfmCKAgbCMZX87BVUfA4kmlxDF3lwWp29DJ6G9E9Z0eWVrjr6PgP+di
         9z7X/SYQ1Z77KTvOErFWIJ7r5VsDMlPnB2K/FKV52HRqDdswgbWu3IpfDcMUJpxz8alX
         5PLA==
X-Gm-Message-State: AOAM531kGc9pXft+H3xk0CXb8NJqMW59gW3MIsSyuLqnkQ8tHDGoIuXT
        Qdf6MGQQQVOG4wLs7CmgWab8Od5m
X-Google-Smtp-Source: ABdhPJxWYOw2ZOWPdXmYVsGt0wJsvtMs2Bs6pCY+Dj0WtzGm3uoYYQhl5h9DXxq5MG5iI3tRCD4hrw==
X-Received: by 2002:adf:d84a:: with SMTP id k10mr19186075wrl.336.1591545766755;
        Sun, 07 Jun 2020 09:02:46 -0700 (PDT)
Received: from [192.168.43.101] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id k26sm19825738wmi.27.2020.06.07.09.02.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2020 09:02:46 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: [BUG] ->flush and links
Message-ID: <34eb5e5a-8d37-0cae-be6c-c6ac4d85b5d4@gmail.com>
Date:   Sun, 7 Jun 2020 19:01:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is a problem with io_uring_cancel_files -- it doesn't care about
links. If a request with ->files is not a head of a link, it won't be
found it in io-wq or elsewhere, and will wait for the head to be completed.
The problem is when the head won't ever complete.

e.g. req1: read empty pipe -> req2: openat
This leaves an uninterruptedly and indefinitely sleeping process.
see liburing patch below.

I was thinking about making dependant links traversable by io-wq cancel().

The similar problem can manifest itself with pending drained requests,
but solving this one would need cancellation of every prior request
in the drain queue, that's kind of nasty side effect for closing an
fd alias.

Any thoughts how to better deal with it?

diff --git a/test/lfs-openat.c b/test/lfs-openat.c
index d69096e..9fb96b7 100644
--- a/test/lfs-openat.c
+++ b/test/lfs-openat.c
@@ -75,6 +75,58 @@ static int prepare_file(int dfd, const char* fn)
 	return res < 0 ? res : 0;
 }
 
+static int test_linked_files(int dfd, const char *fn)
+{
+	struct io_uring ring;
+	struct io_uring_sqe *sqe;
+	char buffer[128];
+	struct iovec iov = {.iov_base = buffer, .iov_len = sizeof(buffer), };
+	int ret, fd;
+	int fds[2];
+
+	ret = io_uring_queue_init(10, &ring, 0);
+	if (ret < 0)
+		DIE("failed to init io_uring: %s\n", strerror(-ret));
+
+	if (pipe(fds)) {
+		perror("pipe");
+		return 1;
+	}
+
+	sqe = io_uring_get_sqe(&ring);
+	if (!sqe) {
+		printf("get sqe failed\n");
+		return -1;
+	}
+	io_uring_prep_readv(sqe, fds[0], &iov, 1, 0);
+	sqe->flags |= IOSQE_IO_LINK;
+
+	sqe = io_uring_get_sqe(&ring);
+	if (!sqe) {
+		fprintf(stderr, "failed to get sqe\n");
+		return 1;
+	}
+	io_uring_prep_openat(sqe, dfd, fn, OPEN_FLAGS, OPEN_MODE);
+
+	ret = io_uring_submit(&ring);
+	if (ret != 2) {
+		fprintf(stderr, "failed to submit openat: %s\n", strerror(-ret));
+		return 1;
+	}
+
+	fd = dup(ring.ring_fd);
+	if (fd < 0) {
+		fprintf(stderr, "dup() failed: %s\n", strerror(-fd));
+		return 1;
+	}
+
+	/* io_uring->flush() */
+	close(fd);
+
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	const char *fn = "io_uring_openat_test";
@@ -93,7 +145,17 @@ int main(int argc, char *argv[])
 		return 1;
 
 	ret = open_io_uring(&ring, dfd, fn);
+	if (ret) {
+		fprintf(stderr, "open_io_uring() failed\n");
+		goto out;
+	}
 
+	ret = test_linked_files(dfd, fn);
+	if (ret) {
+		fprintf(stderr, "test_linked_files() failed\n");
+		goto out;
+	}
+out:
 	io_uring_queue_exit(&ring);
 	close(dfd);
 	unlink("/tmp/io_uring_openat_test");


-- 
Pavel Begunkov
