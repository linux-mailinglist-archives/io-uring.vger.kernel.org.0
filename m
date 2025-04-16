Return-Path: <io-uring+bounces-7477-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F320A8B497
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 11:00:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 82C9D18978C1
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 09:00:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3DFCA32;
	Wed, 16 Apr 2025 09:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J8l9VTqN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF3D3A1BA
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 09:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744794018; cv=none; b=PfqTgYKJKAv9rNSO7j0GCkEpBHf2OZuwTP2cO4sxx+gS/KEvXQhnBc4chT5eM7BBLj8j2qR7wrG0Q6M+GXGxCwTc5UdWj6omwk9B2Vn6disq40tut1XfaaPngR/0bl3ZwWINinQuO6jmYYb9jli86Bq3kPGhHsJb4p6dvR2YkcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744794018; c=relaxed/simple;
	bh=JqOe2gPOo8M/vdlc4QywENu0rHRwwK9NAfCTN6kppaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCOeCdfxAB94pP30IHUGe1A9DKt+P/pL18kRInYMT0QJsclaq8tciLkKV6VbXq420wpVV97v50Cj1GHdAmbwAdAImOkUYd6dgdkpw5Kj0Pvpt0QLqjdm3Bza+KMWzShGcJjYSuD/uJ+P2q9z2yj8paPnD/xVcJrkyWM/efJejzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J8l9VTqN; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5e5e8274a74so10308274a12.1
        for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 02:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744794014; x=1745398814; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vsahYySjn2dnTF+BnX7aEwA3uf0JFvZMd2a9/zJK7sg=;
        b=J8l9VTqNZKa7oy21VWFw4IBjJCbg+pVA0yryv73QZrFlw0CURiC71ia3HItJ/mXmDp
         XdOY0Z2osAaOJiTbtpZvamkz4YXhKs424S5FRrDA5iiFhbixP+H25u/7RFLyPvztE5q4
         WxCmBrBlRoBAySWSMJ6WQVlD9p1q2h7tUrkeiVu7ls+75AI7kAZQdXqk48Uaqkjh6Bz5
         rGEhHefDSICR/b3jxOJRki4mBcjFgLn8xZ0kSngpOXTLz4mIxzvaJL0c8fHQ5JLnrnBZ
         9+PQyqTN3rvxivtry6d2sd881K59yeu1ta6Lngrj6tlxEN210nVtu64K1SLwYpPEbErR
         fplg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744794014; x=1745398814;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vsahYySjn2dnTF+BnX7aEwA3uf0JFvZMd2a9/zJK7sg=;
        b=e9q4WoW42L7qmmny1QdRQtVud3T0+Njjqj21kCq65+0kCglhmL38tdWuI9+NFLaI9B
         RQXp9MD29d1FFdz2X6rf0skVs46o7+1tqIH6mpbpoxLomDTE6gQAjIcFpo/WvhS2EsaU
         JBVjwrIJ1uA0t3Tp9dGAw0QqstdUy3cb/tainElb/g32QxXd7rFqKpzpJMm+fBO0VI9Y
         PsEPivrYJlXSziRldtnANZ+LeHI5CE45KfF91bZIf5fUpS9Cx5YyISGOTgEh05FViem/
         7rGdu+stHXo/IKUJmh06zoriTAaonR3ld00hRbkI023ph8AhkArDDJLkpRN4Qx+u1Tpu
         oLwA==
X-Gm-Message-State: AOJu0YyWKju+G/gxk+hrllEk0knr83BKJ/h7SDW58NW3zdULRO1zI5yt
	pOZvyfNqMFBPitEZdclQfwyqpEYZFxM8XpgJnqonFZPV2EKt6ILUW8eGHQ==
X-Gm-Gg: ASbGncv8byu9v3+zErbCX1rO4Lg7P0NBwp83uRQ5cxOOaGjSMwFT8kjJAx/PBFYmZcq
	VaRii04+7EKFbPxD1MOrekgzCKfuV1d7MJMU98Q/cmUS7w0YNNHUhj8JOgz/fscSaV0vET3myOv
	CrF9MiKrHJ6/5JvdqAr20SxUqo+28rTdGbhoFat8mq2PPM1xmULWtu1HjScIBEWcFxB9OCNpAqS
	BlmJ1Jo8VfkZR75rr8i3W6V8CsAkKAzPv9DybLt0pJqlKgbkAjFeDVCXNglSRQHz1GpuulQeiDu
	jlQ/1FdMWsrEFf6EHUKDEPn7
X-Google-Smtp-Source: AGHT+IEg12JlEYdPs/LodbOjJsm30uY+7p014xtWNm07hW08jo88rItTnrEW5fidP8fc/gnqAykIIw==
X-Received: by 2002:a05:6402:90e:b0:5f3:4ac5:9b84 with SMTP id 4fb4d7f45d1cf-5f4b733f025mr949187a12.17.1744794013820;
        Wed, 16 Apr 2025 02:00:13 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:d39e])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f45bc75b4fsm3378097a12.18.2025.04.16.02.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 02:00:12 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH liburing 3/5] tests/zcrx: use returned right zcrx id
Date: Wed, 16 Apr 2025 10:01:15 +0100
Message-ID: <9ea2bd6f45b22e559327c235a6a44d5fe2c521b0.1744793980.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1744793980.git.asml.silence@gmail.com>
References: <cover.1744793980.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now we return the zcrx id back to the user, use it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/zcrx.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/test/zcrx.c b/test/zcrx.c
index 0fa8f2bd..b60462a6 100644
--- a/test/zcrx.c
+++ b/test/zcrx.c
@@ -344,7 +344,7 @@ static int test_area_access(void)
 	return T_EXIT_PASS;
 }
 
-static int create_ring_with_ifq(struct io_uring *ring, void *area)
+static int create_ring_with_ifq(struct io_uring *ring, void *area, __u32 *id)
 {
 	struct io_uring_zcrx_area_reg area_reg = {
 		.addr = (__u64)(unsigned long)area,
@@ -371,6 +371,7 @@ static int create_ring_with_ifq(struct io_uring *ring, void *area)
 		fprintf(stderr, "ifq register failed %d\n", ret);
 		return T_EXIT_FAIL;
 	}
+	*id = reg.zcrx_id;
 	return 0;
 }
 
@@ -406,9 +407,10 @@ static int test_invalid_zcrx_request(void *area)
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
 	struct io_uring ring;
+	__u32 zcrx_id;
 	int ret, fds[2];
 
-	ret = create_ring_with_ifq(&ring, area);
+	ret = create_ring_with_ifq(&ring, area, &zcrx_id);
 	if (ret != T_SETUP_OK) {
 		fprintf(stderr, "ifq-ring create failed: %d\n", ret);
 		return T_EXIT_FAIL;
@@ -422,7 +424,7 @@ static int test_invalid_zcrx_request(void *area)
 
 	/* invalid file */
 	sqe = io_uring_get_sqe(&ring);
-	test_io_uring_prep_zcrx(sqe, ring.ring_fd, 0);
+	test_io_uring_prep_zcrx(sqe, ring.ring_fd, zcrx_id);
 
 	cqe = submit_and_wait_one(&ring);
 	if (!cqe) {
@@ -441,7 +443,7 @@ static int test_invalid_zcrx_request(void *area)
 
 	/* invalid ifq idx */
 	sqe = io_uring_get_sqe(&ring);
-	test_io_uring_prep_zcrx(sqe, fds[0], 1);
+	test_io_uring_prep_zcrx(sqe, fds[0], zcrx_id + 1);
 
 	cqe = submit_and_wait_one(&ring);
 	if (!cqe) {
@@ -478,7 +480,8 @@ struct recv_data {
 	struct io_uring_zcrx_rq rq_ring;
 };
 
-static int recv_prep(struct io_uring *ring, struct recv_data *rd, int *sock)
+static int recv_prep(struct io_uring *ring, struct recv_data *rd, int *sock,
+		     __u32 zcrx_id)
 {
 	struct sockaddr_in saddr;
 	struct io_uring_sqe *sqe;
@@ -526,7 +529,7 @@ static int recv_prep(struct io_uring *ring, struct recv_data *rd, int *sock)
 
 	sqe = io_uring_get_sqe(ring);
 	io_uring_prep_rw(IORING_OP_RECV_ZC, sqe, use_fd, NULL, 0, 0);
-	sqe->zcrx_ifq_idx = 0;
+	sqe->zcrx_ifq_idx = zcrx_id;
 	sqe->ioprio |= IORING_RECV_MULTISHOT;
 	sqe->user_data = 2;
 
@@ -693,7 +696,7 @@ static void *recv_fn(void *data)
 	rd->rq_ring.rq_tail = 0;
 	rd->rq_ring.ring_entries = reg.rq_entries;
 
-	ret = recv_prep(&ring, rd, &sock);
+	ret = recv_prep(&ring, rd, &sock, reg.zcrx_id);
 	if (ret) {
 		fprintf(stderr, "recv_prep failed: %d\n", ret);
 		goto err;
-- 
2.48.1


