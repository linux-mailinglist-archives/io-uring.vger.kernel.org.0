Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062272DE76C
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 17:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730653AbgLRQZO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 11:25:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730337AbgLRQZN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 11:25:13 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4D3C061282
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 08:24:23 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id w79so2482708qkb.5
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 08:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IXyhe05jx9ER1J89EjvBSieilttxcWGK3r2i1+5rlFw=;
        b=fqXTj8PItsNFNkBxe3choDzIC1vwLAHFuZxa4QI+Q+cPZmHyywi28j4pX2HMuAsa4U
         fSYpRETwZ+MrEbwM8P/qu/4p3S6rULVxCHKTERBKAtauqYd5jqb9absj2vK/AkEnaEvZ
         ajgIlTBWmCqTFaC01GYMgaApz08KBeybsFkOBCQ8ZG6zrgvfAVbH1Q67uifwPy+YqNl2
         tpiLc+6Ucf/tVqhVh/yr3j/L5JQtKOsZOc9Gl8vjgcUN76+BoL8NBqAzyz6RLmEgvtZ3
         4jJIJMqiqDVo47bOlf1xkuWdpmd83qk44bXB+XOAW0koWjd4Og9pGvgLeGYK7EPAYMHv
         58FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IXyhe05jx9ER1J89EjvBSieilttxcWGK3r2i1+5rlFw=;
        b=ryf9dLhF/nbbdUG+VZIS6kCi+XdU37/dLgRPoNHJ3jZyZRgm1baSORFozc70IoGPC/
         74gbxMCEy6dXx7oz9uxwOlVG99zWWx9ssMvdGbRUofVz//W/wr6ATZz7q3zhWBYyqo5N
         hjdEGGWhVwAD8J3O/UFZfVV/68zuJ6t5+rfkKmcYd0iSLiwr7HJDNiPIHuH53aIhhM3D
         mhOgIqyV8pgTW2kDEn/4XZiymBjAuPKDyuOl7pl2arVMZ2kvkrO1M5AxK9K5LRVEtE2T
         ++gaWRZsrLg0X/BDABIS70Gv0OW0VsCKGtzHQZVzQBN+VVx07s3uzyJh7TSPBMS3T2LV
         8m2A==
X-Gm-Message-State: AOAM533q2vGne1p848e9vC2XXS8vPUwbChKD0MJsDJfwg0NeOuezlvtE
        rR4ZnpioJ3bpU4bvkRP4cys=
X-Google-Smtp-Source: ABdhPJxrSQ8WbuuvekVMbmUuTKC1cgc6Qfv9A21PiSDJ4jYLm9Un9McKrB2OwNZper81kIPfxq+ziw==
X-Received: by 2002:a05:620a:673:: with SMTP id a19mr5424293qkh.353.1608308662956;
        Fri, 18 Dec 2020 08:24:22 -0800 (PST)
Received: from marcelo-debian.domain (cpe-184-152-69-119.nyc.res.rr.com. [184.152.69.119])
        by smtp.gmail.com with ESMTPSA id i68sm5994975qkc.82.2020.12.18.08.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 08:24:22 -0800 (PST)
From:   Marcelo Diop-Gonzalez <marcelo827@gmail.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org,
        Marcelo Diop-Gonzalez <marcelo827@gmail.com>
Subject: [PATCH] io_uring: flush timeouts that should already have expired
Date:   Fri, 18 Dec 2020 11:24:04 -0500
Message-Id: <20201218162404.45567-1-marcelo827@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Right now io_flush_timeouts() checks if the current number of events
is equal to ->timeout.target_seq, but this will miss some timeouts if
there have been more than 1 event added since the last time they were
flushed (possible in io_submit_flush_completions(), for example). The
test below hangs before this change (unless you run with
$ ./a.out ~/somefile 1)

int main(int argc, char **argv) {
	if (argc < 2)
		return 1;

	int fd = open(argv[1], O_RDONLY);
	if (fd < 0) {
		perror("open");
		return 1;
	}

	struct io_uring ring;
	io_uring_queue_init(4, &ring, 0);

	struct io_uring_sqe *sqe = io_uring_get_sqe(&ring);

	struct __kernel_timespec ts = { .tv_sec = 9999999 };
	io_uring_prep_timeout(sqe, &ts, 1, 0);
	sqe->user_data = 123;
	int ret = io_uring_submit(&ring);
	if (ret < 0) {
		fprintf(stderr, "submit(timeout_sqe): %d\n", ret);
		return 1;
	}

	int n = 2;
	if (argc > 2)
		n = atoi(argv[2]);

	char buf;
	for (int i = 0; i < n; i++) {
		sqe = io_uring_get_sqe(&ring);
		if (!sqe) {
			fprintf(stderr, "too many\n");
			exit(1);
		}
		io_uring_prep_read(sqe, fd, &buf, 1, 0);
	}
	ret = io_uring_submit(&ring);
	if (ret < 0) {
		fprintf(stderr, "submit(read_sqe): %d\n", ret);
		exit(1);
	}

	struct io_uring_cqe *cqe;
	for (int i = 0; i < n+1; i++) {
		struct io_uring_cqe *cqe;
		int ret = io_uring_wait_cqe(&ring, &cqe);
		if (ret < 0) {
			fprintf(stderr, "wait_cqe(): %d\n", ret);
			return 1;
		}
		if (cqe->user_data == 123)
			printf("timeout found\n");
		io_uring_cqe_seen(&ring, cqe);
	}
}

Signed-off-by: Marcelo Diop-Gonzalez <marcelo827@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b74957856e68..ae7244f8e842 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1639,7 +1639,7 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
 
 		if (io_is_timeout_noseq(req))
 			break;
-		if (req->timeout.target_seq != ctx->cached_cq_tail
+		if (req->timeout.target_seq > ctx->cached_cq_tail
 					- atomic_read(&ctx->cq_timeouts))
 			break;
 
-- 
2.20.1

