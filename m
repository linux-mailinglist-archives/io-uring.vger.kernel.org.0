Return-Path: <io-uring+bounces-7399-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E89B1A7C100
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 17:54:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7F773AC515
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 15:52:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 005F61F5835;
	Fri,  4 Apr 2025 15:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QxMozxkm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385A71F582D
	for <io-uring@vger.kernel.org>; Fri,  4 Apr 2025 15:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743781976; cv=none; b=HjtokHq3a+rd72/cm7QXO1K2UKYR6B6NsM7Ji0so61GBkNk5teE2uo4pW4iExej0yzJUfLBc4Yer04YJn8/mfVhnNq6SX93MP/x79FCWGkgqvsEX1v3z3Vg44oLEGHhfdtflrkwCwaLR0m03HW/1NAyLXlXJcODDSkPauGhj1CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743781976; c=relaxed/simple;
	bh=rbtnVk58sEuu69YS9d5W4gSfdgeNgzHwL3yrvYagMSo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SYyAupO9QXLjorpRksNcDlTICTCjdiBOPAfDbt3gHzuhJUgoewYi9RkGQaZviDvfE2y1h67F3wmjeHygWOPMlgMAMKVCZZ+eSOx8/0WuYTHgcT9YxxFHnFURAMBrZVl3Zvw4oRoZgam2LyOD/0mlY8FhSgVUw8LhpGxt9BQZZwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QxMozxkm; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-aaf0f1adef8so343702066b.3
        for <io-uring@vger.kernel.org>; Fri, 04 Apr 2025 08:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743781972; x=1744386772; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fmoEzpjtepWPvv10dlSiXv/dczbDBSLRpMxYpHnMwX4=;
        b=QxMozxkmU+zCOSD7qZroqkH01trsLgPufgPyc/EqUzPJfi1g4vcjE/rXaPsqJwDuUo
         NcV6aAtE5C79/jjwzm33G4ni8TYvsRbVpfXFDwg1jA/mr5lolXXrqyPL72jiyFkLLgy3
         YmuV7oH7tqdlnc5LG7I02Sn4MUwhm+khh94qrC2KxNESP0yeKGCEWASHQZXsWaVw520k
         74YBdbEEIbNT6gpgb6xlXRtJZEOicIvkd6Aa2cN85gF2VCwcTc9Bo7X+RF1l8IDoU8WY
         i8zT/YvI2fzG+FcV/78Q92zlVX/DAyGESrqxPDFmE9MYtBtxdVf1SB7GtYcCYyqIlDBa
         sOlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743781972; x=1744386772;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fmoEzpjtepWPvv10dlSiXv/dczbDBSLRpMxYpHnMwX4=;
        b=PaIEizKqSgnwPeb17w8PL8IXHMt3DrOGGrYr7Im+rufDrz8p7tlKZT9Z89k+x3R0ce
         aSDkK4+DJRtTSi9cEiUtm/mZ2HmmVJge1YFZ3MlHbQXij1bXiSx/ILM2mNZjfIE5frJz
         zd57tA9bCLn6sKVW6Zis0xR51Vy9oZFq3V05AmvDr3+ye+5eOl/2IJqihPyfxT8K5qnb
         TdLaacVAp8f/3IdybmVVNYA7hqCuvlGNZ6xVnOEOoWKR3DIvELEPHRwoboNrK0g3s9xQ
         nRuxz/lYUYvSCHiGp/vR2l1hs/LIcktK39gfOAHeJ7IaqNoEEAVpmLwH4W/zusdYJ83m
         Tvaw==
X-Gm-Message-State: AOJu0YyTWt4FssTGvUuSgZf2Z5o8t5iOdY8z47BP8ObJQOjBjSx82/C7
	D08uoM/m4oDgjIWxuDr7YJUx7G7XsUjZYkGI9LKjKW5B2SifLDmERI4FZA==
X-Gm-Gg: ASbGncsdRWhqzMAe2UTBUZt6EMxFMiczBK5nM0iimD8d2alvqbFOClceIWG+Oj9P6Qr
	4LWA2Y1iEmQ72/QzsbAAu14qlCNUBK2bSPK9Ivi2LCJ1p+UxBIoOatvqA6CsPdbA2JTrJhIU0eQ
	gNfrHzRmKllKtK5wXQ9LowUgu0jK2jWHb/oucB+iDWOrLPMBL7S00lV160h3NSmPsuM7cTj01zC
	KG3Lo6h9uw9ezvxhWMIBppjUnls3rRQbDEKSLYelnLiJki7QEgvPd8fKDIBYY8AJ+pRc6Tn9W7k
	sbgJjEkGvgagi31DTNk97iN51EvAZ8e/gOM0WXM=
X-Google-Smtp-Source: AGHT+IEbRDYKzFoqCNL7rGOdMQN8+uENyDEjABNqtXaQJjvq8XASnmo0IBbfxC24u1a0olm5Tr4CQw==
X-Received: by 2002:a17:907:96a0:b0:ac3:c56c:26ca with SMTP id a640c23a62f3a-ac7d6c9e90cmr221833566b.8.1743781971826;
        Fri, 04 Apr 2025 08:52:51 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:ce28])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c01c21d0sm281630466b.175.2025.04.04.08.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 08:52:51 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 1/1] tests/rsrc_tags: partial registration failure tags
Date: Fri,  4 Apr 2025 16:54:03 +0100
Message-ID: <8791bcaf3c7d444724055a719c98903a83d7c731.1743782006.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make sure we don't post tags for a failed table registration.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/rsrc_tags.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/test/rsrc_tags.c b/test/rsrc_tags.c
index e78cfe40..0f7d9b69 100644
--- a/test/rsrc_tags.c
+++ b/test/rsrc_tags.c
@@ -408,6 +408,53 @@ static int test_notag(void)
 	return 0;
 }
 
+static char buffer[16];
+
+static int test_tagged_register_partial_fail(void)
+{
+	__u64 tags[2] = { 1, 2 };
+	int fds[2] = { pipes[0], -1 };
+	struct iovec iovec[2];
+	struct io_uring ring;
+	int ret;
+
+	iovec[0].iov_base = buffer;
+	iovec[0].iov_len = 1;
+	iovec[1].iov_base = (void *)1UL;
+	iovec[1].iov_len = 1;
+
+	ret = io_uring_queue_init(1, &ring, 0);
+	if (ret) {
+		printf("ring setup failed\n");
+		return 1;
+	}
+
+	ret = io_uring_register_buffers_tags(&ring, iovec, tags, 2);
+	if (ret >= 0) {
+		fprintf(stderr, "io_uring_register_buffers_tags returned %i\n", ret);
+		return -EFAULT;
+	}
+
+	if (!check_cq_empty(&ring)) {
+		fprintf(stderr, "stray buffer CQEs found\n");
+		return -EFAULT;
+	}
+
+	ret = io_uring_register_files_tags(&ring, fds, tags, 2);
+	if (ret >= 0) {
+		fprintf(stderr, "io_uring_register_files_tags returned %i\n", ret);
+		return -EFAULT;
+	}
+
+	if (!check_cq_empty(&ring)) {
+		fprintf(stderr, "stray file CQEs found\n");
+		return -EFAULT;
+	}
+
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	int ring_flags[] = {0, IORING_SETUP_IOPOLL, IORING_SETUP_SQPOLL,
@@ -426,6 +473,12 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
+	ret = test_tagged_register_partial_fail();
+	if (ret) {
+		printf("test_tagged_register_partial_fail() failed\n");
+		return ret;
+	}
+
 	ret = test_notag();
 	if (ret) {
 		printf("test_notag failed\n");
-- 
2.48.1


