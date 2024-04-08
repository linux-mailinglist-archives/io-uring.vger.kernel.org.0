Return-Path: <io-uring+bounces-1464-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9981D89C9D1
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 18:38:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 148F01F23AC5
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 16:38:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C12C142652;
	Mon,  8 Apr 2024 16:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aAcBMAks"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D861142E9D
	for <io-uring@vger.kernel.org>; Mon,  8 Apr 2024 16:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712594299; cv=none; b=sriMkGsT7p2KCYy9THEZRXGgOXi6cZ59ab7Vi5HMN2MgSjb/QVQpYePyDj9IabFf06zIiFbzqUgJCwGOlvbEz6SyyIJJQpauWSOV6PMoCuHo4eLn3C06Hgj892URGU+czciMhsebIEdrG6bRVrV7SGlJg9u81Xby/3O/wYae8EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712594299; c=relaxed/simple;
	bh=M4ATQ1sbm2RL2eHgaaohsbvVU5PBOypORZjR9K/TtHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XyQE7In+o4NvxXgedTUjbe1tZo7UlH4wGwkwsIri5hlLnevZQetkqG5zB8QkjtYq040U3J2hxsBNcIkKaQYIQm6T74dN85H+1SFyowWxbqHQTh39emWkiqRhQ7MAxcmmk5IHH4BZbbnHtHv0oeYGqpWbru7GMxws+bnpgPsebqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aAcBMAks; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-56e2e09fc27so6247193a12.0
        for <io-uring@vger.kernel.org>; Mon, 08 Apr 2024 09:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712594296; x=1713199096; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y65CuKMgg25XG0Xg3kbEUXjWah7bHKu3dyEjBXl47eo=;
        b=aAcBMAksT0x6pFJgWkXF7H6q8aYeseP02XJYlkF4pDKO8wg/oOduNUjpJ6a8UfYI4H
         zpBGGfySRMA8XPzzIUL4yA/8dh2PeAtVY/6/P/qpHRb7EVEL68AX3W30ZhlawIr0CAD5
         Xn2GZqKlZtNoW/VaRqWINalD2RmtKwc4oqVH3IsDIyhUebjr9FoIUbJHMY7CP6ufozJk
         Smj5DuYaMO13MPDZXCbEaodbfcYRVguZAEID5U6bAdd3yVv65QuTX9SnbT9Vn/Qx9knB
         3WXspx9PZ5aM6YT3iUQUmOX1CRlwUEgGFPBVuwAJ6MGzPFGtlBspfYDiL5EeFt7epzqd
         JOhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712594296; x=1713199096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y65CuKMgg25XG0Xg3kbEUXjWah7bHKu3dyEjBXl47eo=;
        b=jsJx6pCpXO4XxF7u268VsBNcm/nc8AuwF3oicV8rM/jN0fkQkbiojxn8XHtrCwc23N
         u+Nb6Ly/EchBNebHAsxx64NmMqDZczOgF3yr2m7O1VRv+HhMFdImF5K8YAXv2BgWzYZe
         r2v9qlXFqzamXJMBmq7ndHWi+MGc4AOoZtMSbEgrCQ/JN9EH867nA98JpmOsxNLqXe/K
         Q/RgPRwNVtPLPahsE/XKL9KXPaYAQPYnADV3MqE6qaBNhYRMWsuzB7X/ei33NFQJdjjU
         SHrvW7SrnOKmrRfKPGEAXHaOcFsoVdOlsAgIQmivWKWU96BLK4F6R6BhdxboVxxXO7fz
         ZqaA==
X-Gm-Message-State: AOJu0Yz9HkIz/uAkEJDkiixp3/HvXVbP9o0ozwiHNcO3Qr4kSwNKRPWi
	5rKt9oi1VKKD026skcbBG01OEbRcuwSV07yTauoVX9y+t2dU/nLPRkpRdYWQ
X-Google-Smtp-Source: AGHT+IHOo6mV3UqANtvy0yVQ38id5NBrahOHaW42Zw0+H0lOEMYY0uR1UPQDtpwQxSWAffC5RfiX3g==
X-Received: by 2002:a50:f610:0:b0:56c:195d:b162 with SMTP id c16-20020a50f610000000b0056c195db162mr228486edn.6.1712594295567;
        Mon, 08 Apr 2024 09:38:15 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a9-20020a05640233c900b0056db8d09436sm4143363edc.94.2024.04.08.09.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 09:38:15 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing v2 1/3] test: handle test_send_faults()'s cases one by one
Date: Mon,  8 Apr 2024 17:38:10 +0100
Message-ID: <d9b3f41c15dbe993f7bec1d058c480375f6d852e.1712594147.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1712594147.git.asml.silence@gmail.com>
References: <cover.1712594147.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are 3 different cases tested by test_send_faults(), requests for
which are sent together. That's not too convenient, complicates CQEs
checking and opens some space for error. Do them one at a time.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 105 +++++++++++++++++++++++++++++--------------
 1 file changed, 71 insertions(+), 34 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 1b6dd77..78ec3d7 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -122,17 +122,60 @@ static int test_basic_send(struct io_uring *ring, int sock_tx, int sock_rx)
 	return T_EXIT_PASS;
 }
 
+static int test_send_faults_check(struct io_uring *ring, int expected)
+{
+	struct io_uring_cqe *cqe;
+	int ret, nr_cqes = 0;
+	bool more = true;
+
+	while (more) {
+		nr_cqes++;
+		ret = io_uring_wait_cqe(ring, &cqe);
+		assert(!ret);
+		assert(cqe->user_data == 1);
+
+		if (nr_cqes == 1 && (cqe->flags & IORING_CQE_F_NOTIF)) {
+			fprintf(stderr, "test_send_faults_check notif came first\n");
+			return -1;
+		}
+
+		if (!(cqe->flags & IORING_CQE_F_NOTIF)) {
+			if (cqe->res != expected) {
+				fprintf(stderr, "invalid cqe res %i vs expected %i, "
+					"user_data %i\n",
+					cqe->res, expected, (int)cqe->user_data);
+				return -1;
+			}
+		} else {
+			if (cqe->res != 0 || cqe->flags != IORING_CQE_F_NOTIF) {
+				fprintf(stderr, "invalid notif cqe %i %i\n",
+					cqe->res, cqe->flags);
+				return -1;
+			}
+		}
+
+		more = cqe->flags & IORING_CQE_F_MORE;
+		io_uring_cqe_seen(ring, cqe);
+	}
+
+	if (nr_cqes > 2) {
+		fprintf(stderr, "test_send_faults_check() too many CQEs %i\n",
+				nr_cqes);
+		return -1;
+	}
+	assert(check_cq_empty(ring));
+	return 0;
+}
+
 static int test_send_faults(int sock_tx, int sock_rx)
 {
 	struct io_uring_sqe *sqe;
-	struct io_uring_cqe *cqe;
 	int msg_flags = 0;
 	unsigned zc_flags = 0;
-	int payload_size = 100;
-	int ret, i, nr_cqes, nr_reqs = 3;
+	int ret, payload_size = 100;
 	struct io_uring ring;
 
-	ret = io_uring_queue_init(32, &ring, IORING_SETUP_SUBMIT_ALL);
+	ret = io_uring_queue_init(32, &ring, 0);
 	if (ret) {
 		fprintf(stderr, "queue init failed: %d\n", ret);
 		return -1;
@@ -143,6 +186,14 @@ static int test_send_faults(int sock_tx, int sock_rx)
 	io_uring_prep_send_zc(sqe, sock_tx, (void *)1UL, payload_size,
 			      msg_flags, zc_flags);
 	sqe->user_data = 1;
+	ret = io_uring_submit(&ring);
+	assert(ret == 1);
+
+	ret = test_send_faults_check(&ring, -EFAULT);
+	if (ret) {
+		fprintf(stderr, "test_send_faults with invalid buf failed\n");
+		return -1;
+	}
 
 	/* invalid address */
 	sqe = io_uring_get_sqe(&ring);
@@ -150,44 +201,30 @@ static int test_send_faults(int sock_tx, int sock_rx)
 			      msg_flags, zc_flags);
 	io_uring_prep_send_set_addr(sqe, (const struct sockaddr *)1UL,
 				    sizeof(struct sockaddr_in6));
-	sqe->user_data = 2;
+	sqe->user_data = 1;
+	ret = io_uring_submit(&ring);
+	assert(ret == 1);
+
+	ret = test_send_faults_check(&ring, -EFAULT);
+	if (ret) {
+		fprintf(stderr, "test_send_faults with invalid addr failed\n");
+		return -1;
+	}
 
 	/* invalid send/recv flags */
 	sqe = io_uring_get_sqe(&ring);
 	io_uring_prep_send_zc(sqe, sock_tx, tx_buffer, payload_size,
 			      msg_flags, ~0U);
-	sqe->user_data = 3;
-
+	sqe->user_data = 1;
 	ret = io_uring_submit(&ring);
-	assert(ret == nr_reqs);
-
-	nr_cqes = nr_reqs;
-	for (i = 0; i < nr_cqes; i++) {
-		ret = io_uring_wait_cqe(&ring, &cqe);
-		assert(!ret);
-		assert(cqe->user_data <= nr_reqs);
-
-		if (!(cqe->flags & IORING_CQE_F_NOTIF)) {
-			int expected = (cqe->user_data == 3) ? -EINVAL : -EFAULT;
+	assert(ret == 1);
 
-			if (cqe->res != expected) {
-				fprintf(stderr, "invalid cqe res %i vs expected %i, "
-					"user_data %i\n",
-					cqe->res, expected, (int)cqe->user_data);
-				return -1;
-			}
-			if (cqe->flags & IORING_CQE_F_MORE)
-				nr_cqes++;
-		} else {
-			if (cqe->res != 0 || cqe->flags != IORING_CQE_F_NOTIF) {
-				fprintf(stderr, "invalid notif cqe %i %i\n",
-					cqe->res, cqe->flags);
-				return -1;
-			}
-		}
-		io_uring_cqe_seen(&ring, cqe);
+	ret = test_send_faults_check(&ring, -EINVAL);
+	if (ret) {
+		fprintf(stderr, "test_send_faults with invalid flags failed\n");
+		return -1;
 	}
-	assert(check_cq_empty(&ring));
+
 	return T_EXIT_PASS;
 }
 
-- 
2.44.0


