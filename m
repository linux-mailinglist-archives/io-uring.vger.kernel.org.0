Return-Path: <io-uring+bounces-4747-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 39BD19CF90F
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 23:06:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5C531F211FD
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 22:06:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D50171E1C05;
	Fri, 15 Nov 2024 21:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FOZDz4qE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190F31FDFB4
	for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 21:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731706411; cv=none; b=EPmtyrhO2/DUrIZ5E0wIqonrzBALQMDgji52iLPG+ARCIx1bEUJjbP3CBnVAoR8ZzdGThYBkiZLdy5QHA3eWQWud6oDMTGpf9dRO47Wx1j4YSGPJTWTe3eo+MbsGpfEyKdTuk8vE8bhA+iiHbYD3/7RSX4lY5SSxtTSqsoXbLyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731706411; c=relaxed/simple;
	bh=8lkh7IXVW2x74zu8FZ+tdrwsQfn2yNTgfXQ6r9BOhrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kuVWr+YAmFxlFfMX2fM16rQgnvsMgt65kc3GPYk9awoz2/4gL0kh75I49coXdw6ctx5YDB1keTmzxSzwWdXNk9YFaKF8a38045EqxzMCPpgsOwCSmSI7cTfkpRdVqs8fvdCypeG9bp5XDyRmMNiA7a/1ZbIP0Omxang3yQCbYIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FOZDz4qE; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3821e0b2262so20732f8f.1
        for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 13:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731706407; x=1732311207; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=11e7qU4kQ61tSaPvLT2OJZBarIpf9G++UX8GnZvzR20=;
        b=FOZDz4qEljgjVyRe71+OPcPsGRUqmBKDOWp9TAYUOC06wGZ+WW2i3Z07lIzmY7NGFl
         0Z/f3qp/ZEhfD3hiO2EfaUlWLP1HT66JGxueI04vu6KgdHl8stm5XKZlqAXeiQbRACZ1
         zJO4f94gIBOu8KS1e8q+6p5bMemIcje16tgUVKS0jJEvLvG9tjBnsPQ08P5LkuNEX/FZ
         H6UgsO1wo9BBw6gnRdhWiFVld5ozrqtfK8QrnraZnc5VnVr0uJ/qGmzvUbvLcxSn3E/c
         4FIFNar3A0ekptlOtvg8fd4tDsMJt1dtIHZHdVLMNlYNHgQyGRUndKBrTL25r48LeEKZ
         Rjjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731706407; x=1732311207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=11e7qU4kQ61tSaPvLT2OJZBarIpf9G++UX8GnZvzR20=;
        b=tDuNIKjwNNJGwt4bJ7SAdbaZjw7EpFMhmZkYKtg8c77dlqR5JLoM6IhHMXEDpUw2/e
         Oj4Up86BEX8wYZR3coy1BLmW085DQf9N/EOzM9jrm1JcOypehPDCjL8vZC0+/1fx/46a
         MTRUaSUCqU4iKf29cBP536zQYz58RT8QkO7d7N9yYCTB7OhPbnfclbXoItM7gtBZODu2
         oLoMicX8SXoF1SyAP9BA7r+OuhGxXXxwv6BYk87DYafy2J6aMDDC9fuWyFvhESezWjRS
         2Ct+hDndUlpsBNkrDEnp8vQfJfJpKY6c5V0yUM0WGqxvJIyu7qLpLaUzpKF9m1ugymIT
         2wUQ==
X-Gm-Message-State: AOJu0YzbGq01DizG926lEzngFdgizNQ/y2bZt7Y8PcK4ySw4Iln/4E12
	CtLx/qhmtTK97iIfgc004Rqn3603dewuls9o8GCZSDH42bSb7CHND6raEw==
X-Google-Smtp-Source: AGHT+IFgR55kj/tQU1Aar9Rk9S9DcaKXaEHcuzteUUaAolJs066MvfcI0C1RnoAvvLTJ0w7BU+iRnQ==
X-Received: by 2002:a05:6000:a11:b0:37c:d53a:6132 with SMTP id ffacd0b85a97d-38225a8589cmr3544067f8f.31.1731706406625;
        Fri, 15 Nov 2024 13:33:26 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.132.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-382247849b0sm3397258f8f.97.2024.11.15.13.33.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 13:33:25 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 7/8] tests: test arbitrary offset reg waits
Date: Fri, 15 Nov 2024 21:33:54 +0000
Message-ID: <576e9ca1ad794c648af9754ef1c7f4ba5cbed1ab.1731705935.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731705935.git.asml.silence@gmail.com>
References: <cover.1731705935.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The exported io_uring API operates with wait index, which is safer, but
the kernel takes byte offsets. Add a local raw syscall helper passing
byte offsets and add edge testing of more edge cases.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/reg-wait.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/test/reg-wait.c b/test/reg-wait.c
index 13f6d51..aef4546 100644
--- a/test/reg-wait.c
+++ b/test/reg-wait.c
@@ -13,6 +13,18 @@
 #include "liburing.h"
 #include "helpers.h"
 #include "test.h"
+#include "../src/syscall.h"
+
+static int test_wait_reg_offset(struct io_uring *ring,
+				 unsigned wait_nr, unsigned long offset)
+{
+	return __sys_io_uring_enter2(ring->ring_fd, 0, wait_nr,
+				     IORING_ENTER_GETEVENTS |
+				     IORING_ENTER_EXT_ARG |
+				     IORING_ENTER_EXT_ARG_REG,
+				     (void *)offset,
+				     sizeof(struct io_uring_reg_wait));
+}
 
 static int page_size;
 static struct io_uring_reg_wait *reg;
@@ -55,6 +67,7 @@ static int test_offsets(struct io_uring *ring)
 	struct io_uring_cqe *cqe;
 	int max_index = page_size / sizeof(struct io_uring_reg_wait);
 	struct io_uring_reg_wait *rw;
+	unsigned long offset;
 	int ret;
 
 	rw = reg + max_index;
@@ -80,6 +93,36 @@ static int test_offsets(struct io_uring *ring)
 		return T_EXIT_FAIL;
 	}
 
+	offset = 0UL - sizeof(long);
+	ret = test_wait_reg_offset(ring, 1, offset);
+	if (ret != -EFAULT) {
+		fprintf(stderr, "overflow offset failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	offset = 4096 - sizeof(long);
+	rw = (void *)reg + offset;
+	memset(rw, 0, sizeof(*rw));
+	rw->flags = IORING_REG_WAIT_TS;
+	rw->ts.tv_sec = 0;
+	rw->ts.tv_nsec = 1000;
+
+	ret = test_wait_reg_offset(ring, 1, offset);
+	if (ret != -EFAULT) {
+		fprintf(stderr, "OOB offset failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	offset = 1;
+	rw = (void *)reg + offset;
+	memset(rw, 0, sizeof(*rw));
+	rw->flags = IORING_REG_WAIT_TS;
+	rw->ts.tv_sec = 0;
+	rw->ts.tv_nsec = 1000;
+
+	/* undefined behaviour, check the kernel doesn't crash */
+	(void)test_wait_reg_offset(ring, 1, offset);
+
 	return 0;
 }
 
-- 
2.46.0


