Return-Path: <io-uring+bounces-3014-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E8A4E969F1A
	for <lists+io-uring@lfdr.de>; Tue,  3 Sep 2024 15:34:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 76A7A1F23CA8
	for <lists+io-uring@lfdr.de>; Tue,  3 Sep 2024 13:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D48115C3;
	Tue,  3 Sep 2024 13:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ra+mFpSb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6498D817
	for <io-uring@vger.kernel.org>; Tue,  3 Sep 2024 13:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725370444; cv=none; b=qok0fFPkgSZVRztvSaVfr3CMux8pr7R1v+FFdGfEeHhQA5y7OD/w7dmS6Jm15aKxSwCDIEMnaqAPwQTtZIvm52cZFdA8aoYcZ1ZDeslBESs+IGgsjnF4LKIg/ZBALMn87kGq8oDV4EAkAsIij0oIOCrgz1o+MYQM08CmloZroBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725370444; c=relaxed/simple;
	bh=VbSGKvW77GdAqPNc1mLvY1fw2uBjWHVcJTttxEiUf/s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YtaplP3tQuXp87Uy9OB9tIuisqw8ogiXxI8ydzA6Aiqke/6sPhrhxqxjHGei4LFcnBr37oyJ7hCsvUGzbgm9w37sckgp75AC4dW7TbVcKKdwdZJikFljT8WKYf3WSR/BkzusYtJPAwhZY8XgPw2+oPlORkmJq35McUWAQACop70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ra+mFpSb; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-367990aaef3so3177936f8f.0
        for <io-uring@vger.kernel.org>; Tue, 03 Sep 2024 06:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725370440; x=1725975240; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FQHWnC3OCkDzi2bxdi8f0cT2O1FubNonom1yC4gjYXs=;
        b=Ra+mFpSbX1+3AjTTvBHl/x3Y2z3jefU5Z2Ek2Li/HuGI3ooQd5kx2KFGWtK13LkF+d
         vKRY/RyD+vU6qwwpA3fzqnMLkLCYHbo9skLvnEYE/vmt6/1RIilLdxK4LaXfLy4muDjN
         iershtd5JEdOdWRVqsc+xzO8O4OfFunl8v0xGoGo13067vf3wHH2VVAp+fHwSFPFDffh
         iidgzkguHYQ88Ugf8TnswCDz3qUjs6Xg1zJW6aZPgye0WipupQx6ydwW1TLvIe/5Xux5
         wl5qm0ztwWkIO0zT6xeV3xxMHYH5WtWUnw5YytxTnDsqj+pW/v/TOl5aXnX9OhhKbJ9n
         DeaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725370440; x=1725975240;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FQHWnC3OCkDzi2bxdi8f0cT2O1FubNonom1yC4gjYXs=;
        b=aHEARrQvhtQwJ1RMQBGKJy3ednOP6FRkguL7uJrLkLPaQzjfHJzGEWFRnjAcK1HTcf
         kh65F+MgX8f62rPnXK+yhMfG8Mlixj3XddQuWJMWDkgrIcyeNo2Iv2UyxmPl9Xf993kR
         bBlP7hSvKwDobmUftYkuACr4ag2hHCOsRr7vafgRLWvWMY9DEdck59kBU6s6Hp4Toe/f
         okDAyUmrMTkb53ngH869Hoc0pkuafFcq+QEsZvJoe+v4rnqKT4EruKCgpqgd/QDSVOno
         hnl0oa585h68VEk4N5eSO3v5CJsLTAhbK6q9eksuLkwhay07o6XW3dU8Ivjtxx3Iwip8
         FXDA==
X-Gm-Message-State: AOJu0Yykx88AcUqdU/k/g15Aiv1UTqdnysZP/b/6ouYq5fK3gETpLkww
	BTtxUiB7/V8HEMfl1nJJO/suK9/adzEQyinibSS0AvftfbMeIZ03/XS5Rg==
X-Google-Smtp-Source: AGHT+IGqAgpILTmjmp3fN/JgaPFWC7cx5RsHD8XmgB6XRBGKYqpp29LlgznBuaug+kxbfYVKLrlqhQ==
X-Received: by 2002:adf:ab18:0:b0:374:b69f:8 with SMTP id ffacd0b85a97d-376dd71aademr669822f8f.33.1725370439865;
        Tue, 03 Sep 2024 06:33:59 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.144.59])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c251a8719fsm3292515a12.31.2024.09.03.06.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 06:33:59 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing 1/1] test/sendzc: test copy reporting
Date: Tue,  3 Sep 2024 14:34:19 +0100
Message-ID: <7c342889eb41c5f5385699dfc8e33b4d51902382.1725370415.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 59 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 597ecf1..7135f57 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -739,6 +739,59 @@ static int test_async_addr(struct io_uring *ring)
 	return 0;
 }
 
+static int test_sendzc_report(struct io_uring *ring)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct sockaddr_storage addr;
+	int sock_tx, sock_rx;
+	int ret;
+
+	ret = create_socketpair_ip(&addr, &sock_tx, &sock_rx, true, true, false, true);
+	if (ret) {
+		fprintf(stderr, "sock prep failed %d\n", ret);
+		return 1;
+	}
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_send_zc(sqe, sock_tx, tx_buffer, 1, 0,
+				IORING_SEND_ZC_REPORT_USAGE);
+	ret = io_uring_submit(ring);
+	if (ret != 1) {
+		fprintf(stderr, "io_uring_submit failed %i\n", ret);
+		return 1;
+	}
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "io_uring_wait_cqe failed %i\n", ret);
+		return 1;
+	}
+	if (cqe->res != 1 && cqe->res != -EINVAL) {
+		fprintf(stderr, "sendzc report failed %u\n", cqe->res);
+		return 1;
+	}
+	if (!(cqe->flags & IORING_CQE_F_MORE)) {
+		fprintf(stderr, "expected notification %i\n", cqe->res);
+		return 1;
+	}
+	io_uring_cqe_seen(ring, cqe);
+
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "io_uring_wait_cqe failed %i\n", ret);
+		return 1;
+	}
+	if (cqe->flags & IORING_CQE_F_MORE) {
+		fprintf(stderr, "F_MORE after notification\n");
+		return 1;
+	}
+	io_uring_cqe_seen(ring, cqe);
+
+	close(sock_tx);
+	close(sock_rx);
+	return 0;
+}
+
 /* see also send_recv.c:test_invalid */
 static int test_invalid_zc(int fds[2])
 {
@@ -833,6 +886,12 @@ static int run_basic_tests(void)
 			return T_EXIT_FAIL;
 		}
 
+		ret = test_sendzc_report(&ring);
+		if (ret) {
+			fprintf(stderr, "test_sendzc_report() failed\n");
+			return T_EXIT_FAIL;
+		}
+
 		io_uring_queue_exit(&ring);
 	}
 
-- 
2.45.2


