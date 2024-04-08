Return-Path: <io-uring+bounces-1466-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5188089C9D3
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 18:38:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AA190B2865A
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 16:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B03C14387B;
	Mon,  8 Apr 2024 16:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XlGf2/Ev"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B6714263A
	for <io-uring@vger.kernel.org>; Mon,  8 Apr 2024 16:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712594301; cv=none; b=LOjmY0Ce6u5JNmwhzUuJTwC4fTFZ4MIakZL+1a+EieWO4CrDC8Q55yAl7KSlXtgsTOnkQqxMZ8va0jv24PJrJS7m2VX/rwaTpudz7R7cXdem+XlxQS1TwTJT3v8wjQS35COeHgolms9zAJ0vQ1MNKGwP4XvCKxbjj2jO6DBHpiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712594301; c=relaxed/simple;
	bh=/xAzunz5QJb/gej6uMTzTd1gJw9R7sqb4Eg9a6v9Ris=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDlFHFCKS+L2WXPjKjSI86IHCRneGtDqcKn40OfIK5S2SS28KiYpMvIJ15+A2GhntGH9gzUzZFF4ln5itbHU0XY/5SKLG+UOXJQ/P1DDZPPREbX5j9b6K94aaHz/qSWtruR+/LfwXlqEIR2G00KQq5nVOktcmrwmf39UvN5VzVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XlGf2/Ev; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-56e6acb39d4so937632a12.1
        for <io-uring@vger.kernel.org>; Mon, 08 Apr 2024 09:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712594297; x=1713199097; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/77+9xmRbUnNHDqDUdWfHJeRMdFLPAxJFhvezOU4KeI=;
        b=XlGf2/EvzdL9der7wA36htTtTeMSNM3eqT07nnxLiL2OY6oXJuJqEm6YSLNro428FS
         WqLlU+S654d+4Gj0jt03IGpTzGS3y+hYpe5PVrlL0McJZdF3LQl93J/J2O2CmvWhXTbg
         R18czlbJ7zKsXcQ+ocUAkSrhJjJeMkcAEMBN9vryVfDB+BdIq4yM1fKkuX2lXGsikq0C
         4pQNGQiHk7/FQx//+AVyICB+icrQWcerUVhw9FOsFYwYqVPwmeKksTRu1XmaEkARa7fI
         iWlugO0twAHZXyYoA+BuSogaf6u4eFF7gxbam3NqqgHKLWU7UHbK3PU1jbNqc3G0D8NS
         u8fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712594297; x=1713199097;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/77+9xmRbUnNHDqDUdWfHJeRMdFLPAxJFhvezOU4KeI=;
        b=H/a2/BmAMw9W4v0a2W896m96sXhui+qN+bxzrpeErr4ISxL8z0qTdGi+ooKsLOdPll
         czNs6BUe4FJ/7b/+I0rTfxF2q9BGebRPeDLrtWH/4o/ffIzz+pAGddZ5sJzDwn5BcU/F
         tzth4tVsOcHaqIi5nDR0A9T4aWbz7uZZvisZHlkfHGV98stZ+1z4yUAL2NxLtp+bhJo1
         jaYf1pGKOk7JjdML52Wgwb2QNc4j/R4hl9ecIxXUjnAj17vmRgzCOOJCFmzWit68CJqt
         12WLn4F1lK6aj/RMZcfvTMKN7uJCxJDTNmJ6seTn3mj8lh9EGmCcssnpeFDxti8tk/q7
         SxeQ==
X-Gm-Message-State: AOJu0YwbHPuwAbEy9m2NR8PnZ03Obx2/j3bkdeYyTZ1woLI9YO6aECFG
	9yZFa2sn1C72oxs9Lc9azUTRpdQZ4zAbF3zgw02lnyDvAdiUKbtn1HnjpX7c
X-Google-Smtp-Source: AGHT+IFfRbGnKSsq9WvL+NczbHYBDLHeYUwmLthbyH2+Vj8plqy/Mg2xunYpLyxNDa04ammHtUi3PQ==
X-Received: by 2002:a50:f69a:0:b0:56e:3034:1d4a with SMTP id d26-20020a50f69a000000b0056e30341d4amr6453451edn.9.1712594297508;
        Mon, 08 Apr 2024 09:38:17 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a9-20020a05640233c900b0056db8d09436sm4143363edc.94.2024.04.08.09.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 09:38:16 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing v2 3/3] io_uring/sendzc: add DEFER_TASKRUN testing
Date: Mon,  8 Apr 2024 17:38:12 +0100
Message-ID: <a0d822f0e8ebb5e78856457c126dea25b9a517b9.1712594147.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 167 +++++++++++++++++++++++++++----------------
 1 file changed, 107 insertions(+), 60 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index bfb15d2..ad214bb 100644
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
@@ -847,65 +897,62 @@ int main(int argc, char *argv[])
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
+			ring_flags |= IORING_SETUP_SINGLE_ISSUER |
+				      IORING_SETUP_DEFER_TASKRUN;
 
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


