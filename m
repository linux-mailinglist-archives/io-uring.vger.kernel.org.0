Return-Path: <io-uring+bounces-7580-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75E5DA94790
	for <lists+io-uring@lfdr.de>; Sun, 20 Apr 2025 13:24:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7303616784E
	for <lists+io-uring@lfdr.de>; Sun, 20 Apr 2025 11:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2F5D1DE2C4;
	Sun, 20 Apr 2025 11:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hoS2ENhO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B05155A25
	for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 11:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745148227; cv=none; b=knj3yXzDXxhDSH0qneeTLxSyZevd/vCTmfkYkdcKZ5/h/W9iXaOCgyWyY/kYmWjn970SnxjNCfIGss3+GlXC0qjDR8T40ZQI5zQQ9U+RSxPcnK3dEP/v1jS4Z4Rb4vbm0QNmxfv/3USnqDnWdcmDkHZwyqlBby6aytCmRWTfI4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745148227; c=relaxed/simple;
	bh=Yu9NVkee18tvLvvwGgsUG3lNVLsKzLO2V7QhCBLi7kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a01sFDuQvbmMl5k0oxLfGPvsgNoqsKHT7kmVFRBOE97l5JU5UzHq29NykFO4VTfuokQfgQfiGQVv6z+yY3CZUZh7L3+OL3CtyMxVL2PGu4ghMWJZfLEiJOBFucAlpqNMwj+/TKiC4fJlrChd9AyoKRrciKSfAb+0TkAxocECIe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hoS2ENhO; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43d04dc73b7so30976885e9.3
        for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 04:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745148224; x=1745753024; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tUq/qT+SuteLb7W+q57HQ36Hw/1RghJOJqDvLq0jZVk=;
        b=hoS2ENhOg+Hu4H3XAIoxbYaMCbxogJ1kS5VsrfBpgs2c1/RKpYfNPRA20F6s/LIatl
         Q4vu1ejXZC/RpV0czuK/RdgBRGGG+TRC4BC04npZ2+NP3xsbIYwEyFkXW8fyrpWGJzyE
         hAQhmlH4y02FZvsMW5qGr25yGYC3Mf4hcKRBYvrHjGMrrORqZgs1FQiSv+DGxkPxLLC5
         SdLmSitwipLRiQGJS5v6Zgs1WYTbsgJR/UYgpyrVDNwXct6/x+0EApMkkIlJ8egAvWtY
         agL3Jtqz0QO1Nwugo1kiN6kBzmGp06Swk/ZrbM5kYaV9EbjMZK6oEwYLZNmJ8ItN0RDA
         TY6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745148224; x=1745753024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tUq/qT+SuteLb7W+q57HQ36Hw/1RghJOJqDvLq0jZVk=;
        b=SrNaF4dvNcg12h60bVY3H/glh3cYsGnLrN6GjgqCQ5drMGlCxz6nuptIPKXiic0B/c
         h2rV9DFEJ20r8NkIEKLZ7ppiVq6nLYQVfZ81nYd7eL5+q9trPHki8c2l4QLZqylWHF25
         yV2SYzIgyKdrMzXFFCbfuV+H7fc1nv+f4FOvLFRZKGt+1Kprq/s+2NZam18mpjZtaAHf
         ItJh7YCt+cHAtOB4xLGh9D5iTeBxjtI0ARBS2S5VnCp1rJWx4YLSoq90XKq8HbZKsFVx
         6CgRkghTZ1MQqBEFVA5qjDgz4oO+JbhtQdwsugfAHNI5jtf2cJ/jVbRzyXLvyDrtVqVS
         la0A==
X-Gm-Message-State: AOJu0YwyJTUj+l+TlEyZ7Q0IV+khuPaAiohjvKFYYGKlPzym3ul+GZ75
	5E/Q4czI4IUMORreny+nfbieWQMiH/UhruyeTiNmoUmIKpMO5g+TsB6bfQ==
X-Gm-Gg: ASbGnctlqyZAN2rc+cUJDqZVP/ROeE2e4S4qwzN6IfYWvLYRDkkfuHSTq99IInc/aoT
	+wY6udhkSZ2g5nbquikze4EqtVoX1NbVC1J9zGfSsnKIHi9Fd9mascn4pdvcv1DLDrBi4n7DC6H
	VAwwleh7mkaEAF4JYE0+Nfauqu5DrXPI72IMZJA3VL5RY55UpkEhcMsT70Q3PyQJFvCHJkExOJP
	U01wy8Ain9VTqDjOXsmICkQ1NWfdkRzWFYcw1ueuvWP7F64lVd6Ed2EXrwmAmuTVPw08W7juuz0
	735+WOZeqUnAsX7CXagT5LWAZDkuJNmPX+GcNOpzsGWMmjwIpqHa1vevadxYXe/U
X-Google-Smtp-Source: AGHT+IH0nCxWVmH1zezON/xiD8uiaWeZk7hlf5uoRRnPBWyupocbaLMpqBojWMvJvHST82j7iMa/sQ==
X-Received: by 2002:a05:600c:3d86:b0:43d:aed:f7d0 with SMTP id 5b1f17b1804b1-4406ac115d4mr52619425e9.28.1745148223503;
        Sun, 20 Apr 2025 04:23:43 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4406d5bbd35sm94447125e9.22.2025.04.20.04.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Apr 2025 04:23:42 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH liburing 1/3] examples: remove zcrx size limiting
Date: Sun, 20 Apr 2025 12:24:46 +0100
Message-ID: <64f4734fbd7722e87a21959ac668b066bd984717.1745146129.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745146129.git.asml.silence@gmail.com>
References: <cover.1745146129.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's not handled too well and is not great at show casing the feature,
remove it for now, we may add it back later in a different form.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/zcrx.c | 34 ++++------------------------------
 1 file changed, 4 insertions(+), 30 deletions(-)

diff --git a/examples/zcrx.c b/examples/zcrx.c
index 32d9e4ae..afc05642 100644
--- a/examples/zcrx.c
+++ b/examples/zcrx.c
@@ -46,8 +46,6 @@ static long page_size;
 static int cfg_port = 8000;
 static const char *cfg_ifname;
 static int cfg_queue_id = -1;
-static bool cfg_oneshot;
-static int cfg_oneshot_recvs;
 static bool cfg_verify_data = false;
 static struct sockaddr_in6 cfg_addr;
 
@@ -150,16 +148,6 @@ static void add_recvzc(struct io_uring *ring, int sockfd)
 	sqe->user_data = 2;
 }
 
-static void add_recvzc_oneshot(struct io_uring *ring, int sockfd, size_t len)
-{
-	struct io_uring_sqe *sqe = io_uring_get_sqe(ring);
-
-	io_uring_prep_rw(IORING_OP_RECV_ZC, sqe, sockfd, NULL, len, 0);
-	sqe->ioprio |= IORING_RECV_MULTISHOT;
-	sqe->zcrx_ifq_idx = zcrx_id;
-	sqe->user_data = 2;
-}
-
 static void process_accept(struct io_uring *ring, struct io_uring_cqe *cqe)
 {
 	if (cqe->res < 0)
@@ -168,10 +156,7 @@ static void process_accept(struct io_uring *ring, struct io_uring_cqe *cqe)
 		t_error(1, 0, "Unexpected second connection");
 
 	connfd = cqe->res;
-	if (cfg_oneshot)
-		add_recvzc_oneshot(ring, connfd, page_size);
-	else
-		add_recvzc(ring, connfd);
+	add_recvzc(ring, connfd);
 }
 
 static void verify_data(char *data, size_t size, unsigned long seq)
@@ -200,19 +185,13 @@ static void process_recvzc(struct io_uring *ring, struct io_uring_cqe *cqe)
 	if (cqe->res < 0)
 		t_error(1, 0, "recvzc(): %d", cqe->res);
 
-	if (cqe->res == 0 && cqe->flags == 0 && cfg_oneshot_recvs == 0) {
+	if (cqe->res == 0 && cqe->flags == 0) {
 		stop = true;
 		return;
 	}
 
-	if (cfg_oneshot) {
-		if (cqe->res == 0 && cqe->flags == 0 && cfg_oneshot_recvs) {
-			add_recvzc_oneshot(ring, connfd, page_size);
-			cfg_oneshot_recvs--;
-		}
-	} else if (!(cqe->flags & IORING_CQE_F_MORE)) {
+	if (!(cqe->flags & IORING_CQE_F_MORE))
 		add_recvzc(ring, connfd);
-	}
 
 	rcqe = (struct io_uring_zcrx_cqe *)(cqe + 1);
 	mask = (1ULL << IORING_ZCRX_AREA_SHIFT) - 1;
@@ -299,7 +278,7 @@ static void parse_opts(int argc, char **argv)
 	if (argc <= 1)
 		usage(argv[0]);
 
-	while ((c = getopt(argc, argv, "vp:i:q:o:")) != -1) {
+	while ((c = getopt(argc, argv, "vp:i:q:")) != -1) {
 		switch (c) {
 		case 'p':
 			cfg_port = strtoul(optarg, NULL, 0);
@@ -307,11 +286,6 @@ static void parse_opts(int argc, char **argv)
 		case 'i':
 			cfg_ifname = optarg;
 			break;
-		case 'o': {
-			cfg_oneshot = true;
-			cfg_oneshot_recvs = strtoul(optarg, NULL, 0);
-			break;
-		}
 		case 'q':
 			cfg_queue_id = strtoul(optarg, NULL, 0);
 			break;
-- 
2.48.1


