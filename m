Return-Path: <io-uring+bounces-1465-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52B9A89C9D2
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 18:38:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 774701C21A1B
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 16:38:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 813C6142E9D;
	Mon,  8 Apr 2024 16:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RABu6RwY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98823142645
	for <io-uring@vger.kernel.org>; Mon,  8 Apr 2024 16:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712594300; cv=none; b=Glxh1mfHEfWrfXVKkRI8Uszj0ZE+Uhj76hSpMkcCzpuFPW750fKUT4NgEv5oUibWZUDMP9CUlias+jccK2M/vuOEapT8kneZTwezts0UFxUFBPnw78l0BLx9udfpdzruQEcGqSasLxWDnoykJ/4Dm0YiouirLBzXtsRYhkBgEJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712594300; c=relaxed/simple;
	bh=6sxvctNB1MFWCMZ3AEMKNrkwAGhQkYQk5pwhhPQSNdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MAmfYaa0BNzeSdiX/nOri+31mlMURu9PZE4SM+dfGg+xNpwrYmdojPIwefaCZpIp+b9eYYZ2PsALkrs0QcqQzx8UoVsdeN3ACmCXry1gtP7ACHG7PiZ5xVzg4mhUWnV3DeCAPCQczrDPowaGI9zdlOwZ3FtMH8JUT5E/n15Q+/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RABu6RwY; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-563cb3ba9daso4666102a12.3
        for <io-uring@vger.kernel.org>; Mon, 08 Apr 2024 09:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712594296; x=1713199096; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=56MtQnlxZ37Dx+mxQgx8+kGEzWzmbJcVyicBWxdegjM=;
        b=RABu6RwYchhX9FxlOgJpB07Bsah/KOwzIWK+V7dbwCtnXpIQStz0Bg0qjqjbIyWrVd
         jr7atcxy9KmLMqbmxNMQp12bc905pOKU5l8CHillOiijV1AVfHuuuDdMZ+1lSXNyPqD1
         wAwZxhp2tuKlHuquuPx9s+fWGHL/gumT5iZNuH1B+E0ptzdQa71H5uDPktrpc0hKtd3d
         rpBmZtMtxguFu+3rO+4xLUDtN3FSTRadeG9iU4a8FZIPzMtCsXc4vP7xhQ+1tL8OxFwJ
         snuQR7flmgyMnPbqSB92+z7e75+5lmZ0e6zjN4kZ3sBZ/YbgOSFsXcnt4PFsH2Q4sd6t
         RWYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712594296; x=1713199096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=56MtQnlxZ37Dx+mxQgx8+kGEzWzmbJcVyicBWxdegjM=;
        b=pwr2pxBrz2txWc/od26VfbqpsQKzaRnFBQNHkU6PemBSiHJ4GL8EToOlkg8f1TU/C+
         2mZ7oI87UkV7cl09GzzuqsLqIcc0rwi/g1LTsASza9gREhOpMVsve8znDTbmeBJ2uUPf
         4R1wrN4ltXH+/kbi7OMAF4eAqYLvSM9gdcEFFRpF28YEovDpI8CZr0cTY3n0oXhY5A7d
         Q8vIjHRzmiJ/xaq3z6lEgIOLolT60Qvs19RxgFygs8lS0v0NeBGcaEswgGZDx3rJ1ctl
         1XPlBAinJevRZrv9BJ5aMi8qgHg2UTs5gM9t2Mpg61zw9XcOYRP69aN50Eha8iCOtbq1
         grxA==
X-Gm-Message-State: AOJu0Yxsu3tWQqqGc4L3ETyJgYd/HTglfo93VZOez7KxMg3f4SEc+OSX
	Kt4CILVTmPM9h78wzq2DLX6aAyaTzL+SwuiLTuj+Nc0lWvmQ6xKtthYO7FBi
X-Google-Smtp-Source: AGHT+IEgznayZtobV36B4buHkfIzz2mA+mxVlPH7s63dzHdwSvrlJP+ovciHbhb1rgU94tLtFUTIzw==
X-Received: by 2002:a50:9e44:0:b0:56e:2d93:3f8a with SMTP id z62-20020a509e44000000b0056e2d933f8amr6674166ede.28.1712594295985;
        Mon, 08 Apr 2024 09:38:15 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a9-20020a05640233c900b0056db8d09436sm4143363edc.94.2024.04.08.09.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 09:38:15 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing v2 2/3] test/sendzc: improve zc support probing
Date: Mon,  8 Apr 2024 17:38:11 +0100
Message-ID: <03c9abafbf8d00d8f5f44fb61ce990cac0960121.1712594147.git.asml.silence@gmail.com>
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

Move probing whether we support zerocopy send or not to the beginning
instead of relying on test_basic_send().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 64 +++++++++++++++++++++++++++-----------------
 1 file changed, 40 insertions(+), 24 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 78ec3d7..bfb15d2 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -68,8 +68,37 @@ enum {
 static size_t page_sz;
 static char *tx_buffer, *rx_buffer;
 static struct iovec buffers_iov[__BUF_NR];
+
+static bool has_sendzc;
 static bool has_sendmsg;
 
+static int probe_zc_support(void)
+{
+	struct io_uring ring;
+	struct io_uring_probe *p;
+	int ret;
+
+	has_sendzc = has_sendmsg = false;
+
+	ret = io_uring_queue_init(1, &ring, 0);
+	if (ret)
+		return -1;
+
+	p = t_calloc(1, sizeof(*p) + 256 * sizeof(struct io_uring_probe_op));
+	if (!p)
+		return -1;
+
+	ret = io_uring_register_probe(&ring, p, 256);
+	if (ret)
+		return -1;
+
+	has_sendzc = p->ops_len > IORING_OP_SEND_ZC;
+	has_sendmsg = p->ops_len > IORING_OP_SENDMSG_ZC;
+	io_uring_queue_exit(&ring);
+	free(p);
+	return 0;
+}
+
 static bool check_cq_empty(struct io_uring *ring)
 {
 	struct io_uring_cqe *cqe = NULL;
@@ -98,10 +127,7 @@ static int test_basic_send(struct io_uring *ring, int sock_tx, int sock_rx)
 
 	ret = io_uring_wait_cqe(ring, &cqe);
 	assert(!ret && cqe->user_data == 1);
-	if (cqe->res == -EINVAL) {
-		assert(!(cqe->flags & IORING_CQE_F_MORE));
-		return T_EXIT_SKIP;
-	} else if (cqe->res != payload_size) {
+	if (cqe->res != payload_size) {
 		fprintf(stderr, "send failed %i\n", cqe->res);
 		return T_EXIT_FAIL;
 	}
@@ -700,22 +726,6 @@ static int test_async_addr(struct io_uring *ring)
 	return 0;
 }
 
-static bool io_check_zc_sendmsg(struct io_uring *ring)
-{
-	struct io_uring_probe *p;
-	int ret;
-
-	p = t_calloc(1, sizeof(*p) + 256 * sizeof(struct io_uring_probe_op));
-	if (!p) {
-		fprintf(stderr, "probe allocation failed\n");
-		return false;
-	}
-	ret = io_uring_register_probe(ring, p, 256);
-	if (ret)
-		return false;
-	return p->ops_len > IORING_OP_SENDMSG_ZC;
-}
-
 /* see also send_recv.c:test_invalid */
 static int test_invalid_zc(int fds[2])
 {
@@ -769,6 +779,16 @@ int main(int argc, char *argv[])
 	if (argc > 1)
 		return T_EXIT_SKIP;
 
+	ret = probe_zc_support();
+	if (ret) {
+		printf("probe failed\n");
+		return T_EXIT_FAIL;
+	}
+	if (!has_sendzc) {
+		printf("no IORING_OP_SEND_ZC support, skip\n");
+		return T_EXIT_SKIP;
+	}
+
 	page_sz = sysconf(_SC_PAGESIZE);
 
 	/* create TCP IPv6 pair */
@@ -834,15 +854,11 @@ int main(int argc, char *argv[])
 	}
 
 	ret = test_basic_send(&ring, sp[0], sp[1]);
-	if (ret == T_EXIT_SKIP)
-		return ret;
 	if (ret) {
 		fprintf(stderr, "test_basic_send() failed\n");
 		return T_EXIT_FAIL;
 	}
 
-	has_sendmsg = io_check_zc_sendmsg(&ring);
-
 	ret = test_send_faults(sp[0], sp[1]);
 	if (ret) {
 		fprintf(stderr, "test_send_faults() failed\n");
-- 
2.44.0


