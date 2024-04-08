Return-Path: <io-uring+bounces-1461-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8001689C703
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 16:24:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EDFF71F2274B
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 14:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 124C9128370;
	Mon,  8 Apr 2024 14:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jpP9HoXT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198341292D5
	for <io-uring@vger.kernel.org>; Mon,  8 Apr 2024 14:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712586282; cv=none; b=FfLxOEqd6EGDVpONaY7exbbdEwtTCGNntk1pgcAngw8aEZQTX6dkZ8CsL8GTKXKgjh79pRZPBolpUoaNXXQg21tC1vo4VfVNRyiTXaEAjHRBYEUoIcGzz0VQ4+hejdyp2QrIuzTeUWK7xLtj0SPpSzF+S3liR5ZM6+i6l5aZNZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712586282; c=relaxed/simple;
	bh=zeM9kKKhN8rNtMO2kXk/RwlTqwIP9ZTfeJJZ+c69srk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZrPMRAbh0QrqP7R8+JiodXocYSUJSPv9nfU9oYmmDbBSKrPEK5RjVpg2Jk8xQDO3oJyR/++Onuuu9lG/35YLsiW8DMeNGL9QvgrHJ1R6U3vIDkKyC1NlKwhLgrQxpLDh4dYM9oYiKmOwVQnEKhd99azLGDbAHvLVRs9snuY3UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jpP9HoXT; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5684db9147dso6065479a12.2
        for <io-uring@vger.kernel.org>; Mon, 08 Apr 2024 07:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712586278; x=1713191078; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lr4O3znenP67qTm2+G0rxhUamOBYj7bHIbNbdowf5Uw=;
        b=jpP9HoXTrQQPXWHah3F8yI84UQQW+aQzrDkc8Fh6UXjeUoa7AePmvMXS0QUTWHK0ws
         5F2IHudzgM02ZXYV1u7z0+Y0ZrBlM8jjCxOZSVyozS1cLSlKYqEHwRX8p+Bxj6xr4Udg
         LQyyPZgEDaruwf4HpoNlg2Up+QMZ5OKBRqkZCUecX87QCaISJpdpY6Htr3HmKYOF1wnk
         opvof/QMmP43Hr3a7jQOuooUJIRBPfQqULYfj4T4leh8svZOh6tVfDnuDVARMDlSBdie
         hca3wrZpuJmL0iKbyXg2JX2SE5srOgQbbs1wOvGw2HnX7+f2AVXUKGhegy5kVKUB0knb
         coQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712586278; x=1713191078;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lr4O3znenP67qTm2+G0rxhUamOBYj7bHIbNbdowf5Uw=;
        b=OXu5vtEaxLHyJLr1y57RR3t1UJYigD3wBOjjc2SMqdfNZOC0HH2PFfRd+DSeV7/AY1
         rnhABL+J49VjbVDZDxrGAhjLdW/O6VSlwJb2Q2EWdjSfnX6K6QxLAOPcc9Kc7T8IKXUc
         LgFF3vrsV+eGXWQZ+NtPv06zNG4RjSvYdDSOk8oVuxV88QBkLJoMAXwVSONEr8yysv1e
         tTocW334nFRpQhGq7RtVChpNZG4oLZoNQJT11phJwOWd0YY1wx8TkoBSyzRnohvA1k/+
         KVPoHN6bmlshITQeO6tMWFh4XownpfKetOH/kzWefLK7FxZ0Cpf+aj7dkFa+V1ZCq6SE
         zxTQ==
X-Gm-Message-State: AOJu0YxUmbPUoBMdEHN1/2re3OIZZPOwAacUUBRHtc9HiRY4kBUhgr5l
	zJGnSTmNK7TqZZmbo4EOVOHS2oz7zeYbAWYg4Bi8s1vbqK/xtQCVkXcx6NiZ
X-Google-Smtp-Source: AGHT+IG/iicnjVO7F9SaSDiGEbAGS39P3t0u2Zz38ia6o8yiNekIsdyip8KR/mqMzc+UQ8N+W1JX9Q==
X-Received: by 2002:a50:d691:0:b0:56c:3b74:ea4 with SMTP id r17-20020a50d691000000b0056c3b740ea4mr6076227edi.21.1712586278241;
        Mon, 08 Apr 2024 07:24:38 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id p2-20020a056402500200b0056c051e59bfsm4215931eda.9.2024.04.08.07.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 07:24:37 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing 3/3] io_uring/sendzc: add DEFER_TASKRUN testing
Date: Mon,  8 Apr 2024 15:24:22 +0100
Message-ID: <83567247122f6b3d4206dcd8f874651703184792.1712585927.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 166 +++++++++++++++++++++++++++----------------
 1 file changed, 106 insertions(+), 60 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index bfb15d2..4699cf6 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -769,12 +769,69 @@ static int test_invalid_zc(int fds[2])
 	return 0;
 }
 
-int main(int argc, char *argv[])
+static int run_basic_tests(void)
 {
 	struct sockaddr_storage addr;
-	struct io_uring ring;
-	int i, ret, sp[2];
+	int ret, i, sp[2];
+
+	/* create TCP IPv6 pair */
+	ret = create_socketpair_ip(&addr, &sp[0], &sp[1], true, true, false, true);
+	if (ret) {
+		fprintf(stderr, "sock prep failed %d\n", ret);
+		return -1;
+	}
+
+	for (i = 0; i < 2; i++) {
+		struct io_uring ring;
+		unsigned ring_flags = 0;
+
+		if (i & 1)
+			ring_flags |= IORING_SETUP_DEFER_TASKRUN;
+
+		ret = io_uring_queue_init(32, &ring, ring_flags);
+		if (ret) {
+			if (ret == -EINVAL)
+				continue;
+			fprintf(stderr, "queue init failed: %d\n", ret);
+			return -1;
+		}
+
+		ret = test_basic_send(&ring, sp[0], sp[1]);
+		if (ret) {
+			fprintf(stderr, "test_basic_send() failed\n");
+			return -1;
+		}
+
+		ret = test_send_faults(sp[0], sp[1]);
+		if (ret) {
+			fprintf(stderr, "test_send_faults() failed\n");
+			return -1;
+		}
+
+		ret = test_invalid_zc(sp);
+		if (ret) {
+			fprintf(stderr, "test_invalid_zc() failed\n");
+			return -1;
+		}
+
+		ret = test_async_addr(&ring);
+		if (ret) {
+			fprintf(stderr, "test_async_addr() failed\n");
+			return T_EXIT_FAIL;
+		}
+
+		io_uring_queue_exit(&ring);
+	}
+
+	close(sp[0]);
+	close(sp[1]);
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
 	size_t len;
+	int ret, i;
 
 	if (argc > 1)
 		return T_EXIT_SKIP;
@@ -791,13 +848,6 @@ int main(int argc, char *argv[])
 
 	page_sz = sysconf(_SC_PAGESIZE);
 
-	/* create TCP IPv6 pair */
-	ret = create_socketpair_ip(&addr, &sp[0], &sp[1], true, true, false, true);
-	if (ret) {
-		fprintf(stderr, "sock prep failed %d\n", ret);
-		return T_EXIT_FAIL;
-	}
-
 	len = LARGE_BUF_SIZE;
 	tx_buffer = aligned_alloc(page_sz, len);
 	rx_buffer = aligned_alloc(page_sz, len);
@@ -847,65 +897,61 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	ret = io_uring_queue_init(32, &ring, 0);
-	if (ret) {
-		fprintf(stderr, "queue init failed: %d\n", ret);
+	ret = run_basic_tests();
+	if (ret)
 		return T_EXIT_FAIL;
-	}
 
-	ret = test_basic_send(&ring, sp[0], sp[1]);
-	if (ret) {
-		fprintf(stderr, "test_basic_send() failed\n");
-		return T_EXIT_FAIL;
-	}
+	for (i = 0; i < 2; i++) {
+		struct io_uring ring;
+		unsigned ring_flags = 0;
 
-	ret = test_send_faults(sp[0], sp[1]);
-	if (ret) {
-		fprintf(stderr, "test_send_faults() failed\n");
-		return T_EXIT_FAIL;
-	}
+		if (i & 1)
+			ring_flags |= IORING_SETUP_DEFER_TASKRUN;
 
-	ret = test_invalid_zc(sp);
-	if (ret) {
-		fprintf(stderr, "test_invalid_zc() failed\n");
-		return T_EXIT_FAIL;
-	}
+		ret = io_uring_queue_init(32, &ring, ring_flags);
+		if (ret) {
+			if (ret == -EINVAL)
+				continue;
+			fprintf(stderr, "queue init failed: %d\n", ret);
+			return -1;
+		}
 
-	close(sp[0]);
-	close(sp[1]);
+		ret = t_register_buffers(&ring, buffers_iov, ARRAY_SIZE(buffers_iov));
+		if (ret == T_SETUP_SKIP) {
+			fprintf(stderr, "can't register bufs, skip\n");
+			goto out;
+		} else if (ret != T_SETUP_OK) {
+			fprintf(stderr, "buffer registration failed %i\n", ret);
+			return T_EXIT_FAIL;
+		}
 
-	ret = test_async_addr(&ring);
-	if (ret) {
-		fprintf(stderr, "test_async_addr() failed\n");
-		return T_EXIT_FAIL;
-	}
+		if (buffers_iov[BUF_T_HUGETLB].iov_base) {
+			buffers_iov[BUF_T_HUGETLB].iov_base += 13;
+			buffers_iov[BUF_T_HUGETLB].iov_len -= 26;
+		}
+		if (buffers_iov[BUF_T_LARGE].iov_base) {
+			buffers_iov[BUF_T_LARGE].iov_base += 13;
+			buffers_iov[BUF_T_LARGE].iov_len -= 26;
+		}
 
-	ret = t_register_buffers(&ring, buffers_iov, ARRAY_SIZE(buffers_iov));
-	if (ret == T_SETUP_SKIP) {
-		fprintf(stderr, "can't register bufs, skip\n");
-		goto out;
-	} else if (ret != T_SETUP_OK) {
-		fprintf(stderr, "buffer registration failed %i\n", ret);
-		return T_EXIT_FAIL;
-	}
+		ret = test_inet_send(&ring);
+		if (ret) {
+			fprintf(stderr, "test_inet_send() failed (defer_taskrun %i)\n",
+					 ring_flags & IORING_SETUP_DEFER_TASKRUN);
+			return T_EXIT_FAIL;
+		}
 
-	if (buffers_iov[BUF_T_HUGETLB].iov_base) {
-		buffers_iov[BUF_T_HUGETLB].iov_base += 13;
-		buffers_iov[BUF_T_HUGETLB].iov_len -= 26;
-	}
-	if (buffers_iov[BUF_T_LARGE].iov_base) {
-		buffers_iov[BUF_T_LARGE].iov_base += 13;
-		buffers_iov[BUF_T_LARGE].iov_len -= 26;
+		if (buffers_iov[BUF_T_HUGETLB].iov_base) {
+			buffers_iov[BUF_T_HUGETLB].iov_base -= 13;
+			buffers_iov[BUF_T_HUGETLB].iov_len += 26;
+		}
+		if (buffers_iov[BUF_T_LARGE].iov_base) {
+			buffers_iov[BUF_T_LARGE].iov_base -= 13;
+			buffers_iov[BUF_T_LARGE].iov_len += 26;
+		}
+out:
+		io_uring_queue_exit(&ring);
 	}
 
-	ret = test_inet_send(&ring);
-	if (ret) {
-		fprintf(stderr, "test_inet_send() failed\n");
-		return T_EXIT_FAIL;
-	}
-out:
-	io_uring_queue_exit(&ring);
-	close(sp[0]);
-	close(sp[1]);
 	return T_EXIT_PASS;
 }
-- 
2.44.0


