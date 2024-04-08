Return-Path: <io-uring+bounces-1459-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5303389C701
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 16:24:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA5041F21BCF
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 14:24:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D66B0224C9;
	Mon,  8 Apr 2024 14:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lwm9Ioub"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C6E128370
	for <io-uring@vger.kernel.org>; Mon,  8 Apr 2024 14:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712586279; cv=none; b=McZ7SnNwCf0DWiMfK8cF+iQ6hOx1x/oO5k0EWYaoGLUIahawq8Lg89rx3idV08CgHyql5o71XDkAJdQFN4y2qbff4N9FiNILmivK3Q2z1JGKCiApF4xiQ5ZofIP4ip8oHlRNUmxq63qqa948yVV7MU2R3plnGIRdp2pVEOpBC0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712586279; c=relaxed/simple;
	bh=M4ATQ1sbm2RL2eHgaaohsbvVU5PBOypORZjR9K/TtHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJX/RhmTSIpMB52Dq1PwnsCVFpVTBV3w7OIEMCi3aBnpoL0wRdJeU37c3bjmzNHHXbsG9H6hesIfZikfOKuwtdJ5K7WfsCkcn3TEUT92gPcZGZnMMCRiWou5PED0UkUPFslu0EXWiwgBIIvq7mAsdxylxzCbWG9AdmsZci3L9do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lwm9Ioub; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-56e6affdd21so194418a12.3
        for <io-uring@vger.kernel.org>; Mon, 08 Apr 2024 07:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712586276; x=1713191076; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y65CuKMgg25XG0Xg3kbEUXjWah7bHKu3dyEjBXl47eo=;
        b=Lwm9Ioub9a3ZiuZW8E74w+gIVcd/53f/+NyqujbBS9fH932HqBNkI/zujXgr4Mmoe/
         RiPLnel2wEPmzlirWKz8Ckr0wOfhXK/2wx5Lz3z80r96vzbrxgSyVU+Vjy8Kdk+dEZ7r
         7dSX9RfinN9gnH8P2vVwaFCpymJCW7RyWzf2mL/V1Xs4aV/fTtJ8d/FlzJv9vf1jW85n
         giLWmhi6P13QhY+j2rpObJLukzHfZRhetu1K9D1+HOgoOC0GWdZ6Vr/VoOVk7LNB2r9s
         sKRupiQ0knvcdjkKVyNlpRrrzk6AfMd1orhEtKOzNNZqXoADtvG8IzOZlDYcPcl5C/DO
         DHCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712586276; x=1713191076;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y65CuKMgg25XG0Xg3kbEUXjWah7bHKu3dyEjBXl47eo=;
        b=T91zJMtKUJHqBNOqGI7RZvXet3MYW4EBWYiYSdlXrc4jxgBmHD3A3iLJRiLfd1Aow5
         of42kTO01bfRLMPwaQPej/niv7O1aAx70cWre9Ovi7voRTgjePeJg8u6MbkLVC3zPdmC
         3ughhbytKsMbUpykGvbtRuctfHo86Mv7FFzyAhsevyk/TEAK68tnHAvb9Gjeik7KraXw
         /MTWrC7UmqvARGS7n3fa51ksqbwdxl+A15yWGsqXdTpxePy37bZd/9H8I5+f1vBONm49
         +i+E9FSOV8In2G6Rg23UTd+OaVI6rS/vWJtReU3VmF6rQ31SW51P5xdWmsSRtd1GRRvv
         S2KA==
X-Gm-Message-State: AOJu0Yz4eebsZNBFNPTQ6LoAcQ5Uv5wh7QjmkOUTBrw1yCwvB115XcQg
	QnCwhyQPWIxwmMd+dgGOZBa5Ka1q60x5YYuqHfgNkLd6h9Un6aHfHO+wlXUO
X-Google-Smtp-Source: AGHT+IGb1XMPOE0p1jXQsJqqnnqD0IUMOgcDCDRgxB3+uXTkg5UtCmaN98XSMloodbEHhESSwGNAOA==
X-Received: by 2002:a50:9313:0:b0:568:abe3:52b2 with SMTP id m19-20020a509313000000b00568abe352b2mr8998275eda.23.1712586275767;
        Mon, 08 Apr 2024 07:24:35 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id p2-20020a056402500200b0056c051e59bfsm4215931eda.9.2024.04.08.07.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 07:24:31 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing 1/3] test: handle test_send_faults()'s cases one by one
Date: Mon,  8 Apr 2024 15:24:20 +0100
Message-ID: <d9b3f41c15dbe993f7bec1d058c480375f6d852e.1712585927.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1712585927.git.asml.silence@gmail.com>
References: <cover.1712585927.git.asml.silence@gmail.com>
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


