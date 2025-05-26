Return-Path: <io-uring+bounces-8112-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BEC2AC3ABD
	for <lists+io-uring@lfdr.de>; Mon, 26 May 2025 09:35:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B8333A5EC2
	for <lists+io-uring@lfdr.de>; Mon, 26 May 2025 07:34:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E80AF1B0420;
	Mon, 26 May 2025 07:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mS/S6gyv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC00219CD0B
	for <io-uring@vger.kernel.org>; Mon, 26 May 2025 07:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748244916; cv=none; b=Iq+W6zirTwr7HefRprW48FwwlZU2MA2qZUnPr8ng2gwb43GkfZVPqpGqWzF3lvf8Ib8tmLA2IVv++AmYVd5Wqg228yaoAIGn8FkLr5Zl8RRYsxJnSKjtObUlF2lXc/ugJ/xUtMYaoqKNZrEbsIQfIVTp+9we4UwvaLIQoIrENQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748244916; c=relaxed/simple;
	bh=cDugQITuqxGymnyFhzDyU4kunyiMzbVaRbs2IqJzcAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PAAimCCWharU1alI9Rn20jcT4jkyJjL8fNh6YcW6s1KGVuomUo6l7sL5gja+JQhn3Q3RIfkrL8kd+8TFE2+UPGWoic2F7V3kUacveXpkQ5ip/8uU6eTc8p4K/cUL4SyL+7dAI6sfSG/j0Mo5sEd90W58RVO/KPQVGuLPZEtbyM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mS/S6gyv; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6020ff8d54bso3097437a12.2
        for <io-uring@vger.kernel.org>; Mon, 26 May 2025 00:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748244913; x=1748849713; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yi+1//IBzitMe9zA0P97DUcnE5DsvwxbXwJS0SXruf8=;
        b=mS/S6gyvuOmdfpURaxL41dBlej8XaHQmN77BvItSyCaXJhXqisktoHPe3Jq+Dain2P
         9Rm5FdjeZ5G65bfY02IxAwNNuvoYuP6T9b8UdSR/O9yH9Z8KJaIUVIf4XCXyIOZCQM+6
         B7iQZ51G5quIswRJIBQRL8PdoAgmALBDqVnJ/c5Cn1bo1qZ3MgMTR4busnboddnqmhW8
         J46XDca9VTBNMA2JFoUeFpJgtClwes+p7Jqc0WhiPniaWMx/G2un5gNWpiTwJ7JGV0LO
         vg3lb+NKeknQe221XjDadEfp4Nk9JrIRelUPU/WKxahUOJrGOhfPUVYHQKqZ8mElNo53
         yp/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748244913; x=1748849713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yi+1//IBzitMe9zA0P97DUcnE5DsvwxbXwJS0SXruf8=;
        b=Gk+5YDhF8AhjM6ewyIEPUV4G3/dXJPH8EaePpQwyhGBd0MRXOEoXZXz2wT8djRjqiJ
         GRw9WvNGiGFQkCcPFMopUz4lHVt0O4LE5f3uU9WwIXPIWDsaEeOSiJ4Fo8TqomsgaE4R
         tsAZril12Q2rvIfewjNoZYacZi1yZQ9WVmr8LOf6RBhIBa3valrVUQLsRVrlbG/VT81M
         1AhE4Y8Watb40SMd2u0h6g56Uv/7dXcMdj4nEsNq4VBjDQFg2/MskEuHZPNffGeFR03z
         wP3RTfYrqXT5xIh2KUy6NY5nxug7j8zhpr45gv8Oz7Q4bHzf3f1d+1iQ7Fpfqk/b90I2
         v+SQ==
X-Gm-Message-State: AOJu0YywQl2VZ217+q4wG6LFAbLkoLfgxrVLsBxivzW+7AsAPUfy/OUo
	3NKZPQ2MNsppvNOgK43+iEOzJ8/3P6Ndd15JC+aEqrDlO+vgBBjvHqtmzqZrIQ==
X-Gm-Gg: ASbGncsNG/ygRjP+lKPOcvB5AA9ZI1cETUVcCChFk4SxTvbu8iMTRZvz4XgX7EmGxvE
	sadMAAldFAQPSe+N9KCfNWRnMsYxx3X1P19GQ7r67HMrgu7PXH1a+Ww8vd4p1ZI6oNDF5EhNWj0
	UPfX0XRKCa1/g3WyZM5m8fcWuE3uK+KsXvLb9a88c+0d5f6twe08ixM7/B2j23Wupmi7xKAN1QG
	IBeGnnvK26DkdO3f6gRt8mGLe3wBM97BZUX1uWmJmA7HDJJvEYhIylGMeF8kRazyF1IDpGad/ta
	Eqe9gDX9+gprPvEU0wb1/1DMNtXfu8a6QgMmVNSwbAoPpIZ7O5/T5FJk9IRKQSxeg7DoNSQ4kFc
	=
X-Google-Smtp-Source: AGHT+IEZbXTu/8+FYDjhfl4ggGcXf8qhTgL9VqChmCbun/qfmFZdQ0Bay1gaH2NyaBvfQvFFBpGaCw==
X-Received: by 2002:a17:907:3faa:b0:ad5:8414:497 with SMTP id a640c23a62f3a-ad85b07b7acmr732079966b.16.1748244912648;
        Mon, 26 May 2025 00:35:12 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.132.24])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad52d43840esm1622780266b.87.2025.05.26.00.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 May 2025 00:35:11 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 2/2] io_uring/tests: add read/write mock file tests
Date: Mon, 26 May 2025 08:36:18 +0100
Message-ID: <564def2932f88ec166fd494eed5b19d51b9ab58b.1748244826.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1748244826.git.asml.silence@gmail.com>
References: <cover.1748244826.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/mock_tests.c | 115 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 114 insertions(+), 1 deletion(-)

diff --git a/test/mock_tests.c b/test/mock_tests.c
index 5f3063ff..d1253ebb 100644
--- a/test/mock_tests.c
+++ b/test/mock_tests.c
@@ -17,6 +17,11 @@ static struct io_uring mgr_ring;
 static __u64 mock_features;
 static int mgr_fd;
 
+static bool has_feature(int feature)
+{
+	return mock_features >= feature;
+}
+
 static int setup_mgr(void)
 {
 	struct io_uring_mock_probe mp;
@@ -228,7 +233,7 @@ static int test_cmds(void)
 		return 1;
 	}
 
-	if (IORING_MOCK_FEAT_CMD_COPY < mock_features) {
+	if (has_feature(IORING_MOCK_FEAT_CMD_COPY)) {
 		ret = test_regvec_cmd(&ring, mock_fd);
 		if (ret) {
 			fprintf(stderr, "test_regvec_cmd() failed\n");
@@ -242,6 +247,108 @@ static int test_cmds(void)
 	return 0;
 }
 
+static int test_reads(struct io_uring *ring, int mock_fd, void *buffer)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int io_len = 4096;
+	int nr_reqs = 16;
+	int i, ret;
+
+	for (i = 0; i < nr_reqs; i++) {
+		sqe = io_uring_get_sqe(ring);
+		io_uring_prep_read(sqe, mock_fd, buffer, io_len, 0);
+		sqe->user_data = i;
+	}
+
+	ret = io_uring_submit(ring);
+	if (ret != nr_reqs) {
+		fprintf(stderr, "submit got %d, wanted %d\n", ret, nr_reqs);
+		return T_EXIT_FAIL;
+	}
+
+	for (i = 0; i < nr_reqs; i++) {
+		ret = io_uring_wait_cqe(ring, &cqe);
+		if (ret) {
+			fprintf(stderr, "wait_cqe=%d\n", ret);
+			return T_EXIT_FAIL;
+		}
+		if (cqe->res != io_len) {
+			fprintf(stderr, "unexpected cqe res %i, data %i\n",
+				cqe->res, (int)cqe->user_data);
+			return T_EXIT_FAIL;
+		}
+		io_uring_cqe_seen(ring, cqe);
+	}
+	return 0;
+}
+
+static int test_rw(void)
+{
+	void *buffer;
+	struct io_uring ring;
+	int ret, i;
+
+	if (!has_feature(IORING_MOCK_FEAT_RW_ZERO)) {
+		printf("no mock read-write support, skip\n");
+		return T_EXIT_SKIP;
+	}
+
+	buffer = malloc(4096);
+	if (!buffer) {
+		fprintf(stderr, "can't allocate buffers\n");
+		return T_EXIT_FAIL;
+	}
+
+	ret = io_uring_queue_init(32, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring setup failed: %d\n", ret);
+		return 1;
+	}
+
+	for (i = 0; i < 8; i++) {
+		struct io_uring_mock_create mc;
+		bool nowait = i & 1;
+		bool async = i & 2;
+		bool poll = i & 4;
+		int mock_fd;
+
+		memset(&mc, 0, sizeof(mc));
+		if (poll) {
+			if (!has_feature(IORING_MOCK_FEAT_POLL))
+				continue;
+			mc.flags |= IORING_MOCK_CREATE_F_POLL;
+		}
+		if (nowait) {
+			if (!has_feature(IORING_MOCK_FEAT_RW_NOWAIT))
+				continue;
+			mc.flags |= IORING_MOCK_CREATE_F_SUPPORT_NOWAIT;
+		}
+		if (async) {
+			if (!has_feature(IORING_MOCK_FEAT_RW_ASYNC))
+				continue;
+			mc.rw_delay_ns = 1000 * 1000 * 50;
+		}
+		mc.file_size = 10 * (1UL << 20);
+		if (create_mock_file(&mc))
+			return T_EXIT_FAIL;
+		mock_fd = mc.out_fd;
+
+		ret = test_reads(&ring, mock_fd, buffer);
+		if (ret) {
+			fprintf(stderr, "rw failed %i/%i/%i\n",
+				nowait, async, poll);
+			return T_EXIT_FAIL;
+		}
+
+		close(mock_fd);
+	}
+
+	free(buffer);
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	int ret;
@@ -254,6 +361,12 @@ int main(int argc, char *argv[])
 	if (ret)
 		return T_EXIT_FAIL;
 
+	ret = test_rw();
+	if (ret) {
+		fprintf(stderr, "test_rw failed %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
 	io_uring_queue_exit(&mgr_ring);
 	close(mgr_fd);
 	return 0;
-- 
2.49.0


