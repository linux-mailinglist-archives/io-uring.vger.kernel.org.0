Return-Path: <io-uring+bounces-10005-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B36ABDA351
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 17:04:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA6F43AC19F
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 15:02:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15FCA2FFDD4;
	Tue, 14 Oct 2025 15:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HDr4RLYn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49586278772
	for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 15:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760454111; cv=none; b=jGcp/WT3HrpT1fDz+UWvetLtuR2JmWTfq6U9V38B4v/r57pSgX9Zg5y2wuCEw3gNBA3hvcdMVEwHgXMjm5xk+eCxavyyHgViXjOdZFX3QSaLa1mI98oMOZFvSUfIq/MZhtTPiHIq4SfuNRw7aMbl8TK/skfu9PybESWVhdZMG0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760454111; c=relaxed/simple;
	bh=8CBKQ+xkCR4hzJpn9s7KY4kzeYFCVYt0xrgXy9KSJBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQb9k1A2bzTiZsfIiq+14wADiSyKyyiJ+yi2sCb1Ogrffn+4neCE9AVlxzjBxCGkUbh9Lu+4GLpQkJLcSv25IgA33KK6X8KMZKvIhWkdy4pIGvgKRCSI1FAexkIN8tB9SQX69kDL9YjIhRyKhwbqRIzqHgeD83wu5ImMlV5ZZyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HDr4RLYn; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-46e3a50bc0fso40949625e9.3
        for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 08:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760454107; x=1761058907; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SrYu44JadHRt7GuwzjcxjZ0wn2Xq6CWmDu0PRz9ln7A=;
        b=HDr4RLYnR07xujJ8fATRP1iYJvQJ9Ni6pYXvsufAnSUVyRooxbhcoRCheY8KFBWzCR
         fnHT1B4LNLeMQ2RteY7Pob0sVQh0Ff1vyRGrqS0H/U/j5MO+taaeLCvDZJtsq0FxlX8c
         4ZkW+uWS06hmt49Kegn1JHTuw1vdhklCNgGit6kCrp18nxf0C71+Rjd5Ei4T29NT9Ydi
         TfmB7v+QCOit5OunPh79jGyYzgDZlUTbkApWpNiXiYXDWpfGfzQkdGq8KyWATr5XQgNB
         ixgshF/oxVlaYi6CZ4Rx9aP+MoUNfnxwLGDMsWX3REkRmqpES4MUrUDsIlUCjVGPMa1i
         JWuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760454107; x=1761058907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SrYu44JadHRt7GuwzjcxjZ0wn2Xq6CWmDu0PRz9ln7A=;
        b=C3+K+S9L+Lg6CSKBQNXR+LUJmN8CEz0m0E3sPTL1BN6ssPniDPotNzWy4czvb5DXfW
         Lnq4lj6VznhN7eX5tohwqfkWNR8ZatFmIaYpf9EvV34IuluTMn+pURw6sXsY/L6A3OK1
         P8EG7Vz1PKe1cWtVFW/ipt9n6Y4c+fjxPMP1xf2nfARoELTLv3agnLWANPEcfnb4WRm9
         +HzFmX1ljzJt2uepSZQNuLdkxJICAkPio0izNPN8zhY4pXxDm6QA2pcxE/+YnOaSK55r
         qJK5BG+NY+R5n1xp0m0gt/+mYVazB4JT3+9p5eYohSFdAjDxmpPTJDtz69VpyXs64XWx
         J5Zw==
X-Gm-Message-State: AOJu0Yz3GbupT3sMebtDgQwVv1SEdnbmMefOOkRkLpr8mSPg60DV9EAV
	0KlXaOk3+ufJt5ddMgZQ60x4WHdnXet8G1ECSqYb8ZfqnggJfGg0xxPmuTG/ww==
X-Gm-Gg: ASbGncv6I6Na6/I6p7XfXt3zOHqwTgDiIijcluvBQt2/bOHZM0tPz/CTz1IGQ7YZIgr
	sWgSJy3+3BPxMxzYldJKTSEfazMOUvD62KJdUAXbBiZf2k9eRsVwYzfb+8zqoXf70K/4tnGn6gv
	iV4iPpJq8oeDAbphoBi/wfYrNyc6atm/cSwwVnsPOSDLM9wHBeaojk4dMIRF4m61iSv3O4dXh38
	4KAHqTtNIlVAAz0TIgM66UGlS822KGmRpszFtSDmXmlO1kDUZT/83eX4juCdKK9RATrPAqM3dM/
	ifciW2hvJzcIPUy3Ri9bsuPlpSfR8gsFtUO0YIYhRr7FzJN4DaXZSFXqOPfbGIGi2h3WvhMDmi2
	ddkyTi4+xjnK/jcyZNLBVOeFO
X-Google-Smtp-Source: AGHT+IFiGfALc5TbjMFF0GxVv5cid486Iy+fX6Whxe9g52wanymbsg6UPF2zoFuZx8vQe5OyZvo7cw==
X-Received: by 2002:a05:600c:a43:b0:46f:b32e:5094 with SMTP id 5b1f17b1804b1-46fb32e50fcmr168461215e9.32.1760454106746;
        Tue, 14 Oct 2025 08:01:46 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:75fd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb4983053sm243910975e9.8.2025.10.14.08.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 08:01:45 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing v4 3/3] test/query: signal query loop
Date: Tue, 14 Oct 2025 16:02:57 +0100
Message-ID: <d81ccb3c3e3114cedf9434033c0ad496c7186650.1760453798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1760453798.git.asml.silence@gmail.com>
References: <cover.1760453798.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of relying on the kernel limiting the number of queries in a
chain, send a signal. That must be able to abort the syscall.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/ring-query.c | 41 ++++++++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 15 deletions(-)

diff --git a/test/ring-query.c b/test/ring-query.c
index e266b4a9..4c335d64 100644
--- a/test/ring-query.c
+++ b/test/ring-query.c
@@ -5,11 +5,14 @@
 #include <stdlib.h>
 #include <string.h>
 #include <fcntl.h>
+#include <pthread.h>
 
 #include "liburing.h"
 #include "test.h"
 #include "helpers.h"
 
+pthread_barrier_t barrier;
+
 struct io_uring_query_opcode_short {
 	__u32	nr_request_opcodes;
 	__u32	nr_register_opcodes;
@@ -153,9 +156,8 @@ static int test_chain(void)
 	return T_EXIT_PASS;
 }
 
-static int test_chain_loop(void)
+static void *chain_loop_thread(void *arg)
 {
-	int ret;
 	struct io_uring_query_opcode op1 = {}, op2 = {};
 	struct io_uring_query_hdr hdr2 = {
 		.query_op = IO_URING_QUERY_OPCODES,
@@ -167,27 +169,36 @@ static int test_chain_loop(void)
 		.query_data = uring_ptr_to_u64(&op1),
 		.size = sizeof(struct io_uring_query_opcode),
 	};
-	struct io_uring_query_hdr hdr_self_circular = {
-		.query_op = IO_URING_QUERY_OPCODES,
-		.query_data = uring_ptr_to_u64(&op1),
-		.size = sizeof(struct io_uring_query_opcode),
-		.next_entry = uring_ptr_to_u64(&hdr_self_circular),
-	};
 
 	hdr1.next_entry = uring_ptr_to_u64(&hdr2);
 	hdr2.next_entry = uring_ptr_to_u64(&hdr1);
-	ret = io_uring_query(NULL, &hdr1);
-	if (!ret) {
-		fprintf(stderr, "chain loop failed %i\n", ret);
+
+	pthread_barrier_wait(&barrier);
+
+	(void)io_uring_query(NULL, &hdr1);
+	return NULL;
+}
+
+static int test_chain_loop(void)
+{
+	pthread_t thread;
+	int ret;
+
+	ret = pthread_barrier_init(&barrier, NULL, 2);
+	if (ret != 0) {
+		fprintf(stderr, "pthread_barrier_init failed %i\n", ret);
 		return T_EXIT_FAIL;
 	}
-
-	ret = io_uring_query(NULL, &hdr_self_circular);
-	if (!ret) {
-		fprintf(stderr, "chain loop failed %i\n", ret);
+	if (pthread_create(&thread, NULL, chain_loop_thread, NULL) != 0) {
+		fprintf(stderr, "pthread_create failed %i\n", ret);
 		return T_EXIT_FAIL;
 	}
 
+	pthread_barrier_wait(&barrier);
+	sleep(1);
+	pthread_kill(thread, SIGKILL);
+	pthread_join(thread, NULL);
+	pthread_barrier_destroy(&barrier);
 	return T_EXIT_PASS;
 }
 
-- 
2.49.0


