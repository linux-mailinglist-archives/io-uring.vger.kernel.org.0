Return-Path: <io-uring+bounces-1460-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 65C3089C702
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 16:24:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6C611F23F46
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 14:24:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29B0B126F3F;
	Mon,  8 Apr 2024 14:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mbQM54uk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F05128826
	for <io-uring@vger.kernel.org>; Mon,  8 Apr 2024 14:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712586281; cv=none; b=mbzM6pyACx6WdxN+luhFrd1+HnTJ+ya+caZscUS82xfkWGP9YskP73yJmC/wtr/ooYQ6uTRvtUGEiRONbcWJ6/khBhNkxO5wWiYcbMHpSGIpyHqmN82RORN2k1OMQuxLSfbz8WJEaNfwcrBbDiI7GdqgUrAhLk4VxR1P5mGe8uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712586281; c=relaxed/simple;
	bh=6sxvctNB1MFWCMZ3AEMKNrkwAGhQkYQk5pwhhPQSNdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NbmWDC1YIz0hQay1OINyuIl1j9SeUO4zV9AAxvOuqDnItOC5OYANNoDgGzfbKDyx5QLgu/RvQUtZr14E4CE79eO+9b0+DrmH4em/3j09Hg6jF9XTXoTEGXLgSRx0b1ucVrQmJsWx8+++GWHLZ0AswCP+LLjXrdeIK/BCKiKoy7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mbQM54uk; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-56e346224bdso2596841a12.1
        for <io-uring@vger.kernel.org>; Mon, 08 Apr 2024 07:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712586277; x=1713191077; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=56MtQnlxZ37Dx+mxQgx8+kGEzWzmbJcVyicBWxdegjM=;
        b=mbQM54ukhs1g2qvC38ksKeUKVZz4W1egkT6M1Ayn/TR50smdFZQVfGj4gMAT0XLdKE
         R6X7awPwtn7uR2qzMJDujvbmfyd84+BkMZmDQ8vh4AzZw7tEw+mgjhDcqd3HlrWC+PEK
         pua2qAN0jIGVa6sSBCfcUqb2PzXm88zfEOLBm/RvKY3Gob7kQreSZ4nuhyanPvBBNTRJ
         PQpNgH229dYv5CL3cqO4Fy7GMDpy2TzNSjuz1Sa3HCvu8fVYIzpKK7iQYzp4VMEjeT9G
         p14RY4y/KCW5hmXLdFlEJ/SnULUVsi2EdzEC9XjjQPLIzmcM9TkC7u2UxoW6n4NqOdpQ
         z69w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712586277; x=1713191077;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=56MtQnlxZ37Dx+mxQgx8+kGEzWzmbJcVyicBWxdegjM=;
        b=IfU45ZDbZQuKs0xBOlm3Tz8wUWdpLi9LCZoO7C+M/hT/fl6S7TcOWNf85hBxyy2j24
         ZmpcOFOhYoYJKuUj8MC5pRUkY/GVWvk5Ut/QLUmVXLznX+NFUDs0W/CFLYWCLFzLc1WL
         9PsN5VOunbTQeueOPUsAakB1mLN3K9EB5feiNfx7nzJNaZiphiMScUQw6gpi4UGFOxC6
         EfYqFSyqHJcm4ZleCE6nkcIsOp/UtLuAq8s/Wz1vPx4sqIyQKj0Em6TO+6S/FFihjknL
         OZAM8FT0Hoc608r/FTO+qKXwN33bGVJ/1K9lnVykb0I/Skgr0TIyjY1eqXXopBn5WL3/
         tZpg==
X-Gm-Message-State: AOJu0YyPLnQxpAnx8P1VduA8LvV93Mls5awOJF+p+YBdupF8PCPKpU7c
	Om0CLEXQV2bOuhvlj7GCLNwkoyGwJXlhxEOj+UowcMdKXUkbV9U25zXQlPq5
X-Google-Smtp-Source: AGHT+IGScGV9yT6oO9zqiCGwAEL1q2gQf9TaRyM11k9DOkQ0+1qFC1aw8KBGW81XZNnFF5Gr2WU+8g==
X-Received: by 2002:a50:8d50:0:b0:56d:c548:6af8 with SMTP id t16-20020a508d50000000b0056dc5486af8mr6524128edt.9.1712586276836;
        Mon, 08 Apr 2024 07:24:36 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id p2-20020a056402500200b0056c051e59bfsm4215931eda.9.2024.04.08.07.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 07:24:36 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing 2/3] test/sendzc: improve zc support probing
Date: Mon,  8 Apr 2024 15:24:21 +0100
Message-ID: <03c9abafbf8d00d8f5f44fb61ce990cac0960121.1712585927.git.asml.silence@gmail.com>
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


