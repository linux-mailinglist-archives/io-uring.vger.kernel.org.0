Return-Path: <io-uring+bounces-6823-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA477A46C89
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 21:36:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C692B16EB05
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 20:36:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88D771E1DE7;
	Wed, 26 Feb 2025 20:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bDQ6VbwK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90AE19E98C
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 20:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740602179; cv=none; b=K3is4O8ph2iS9T0z1nyjDD2v/RuULAbsrBtA5Kjx01LoGxjt+Z1dX/yT34uQFIQOgDaJD5feKbzgFKH0ratmlrkzQ5UWCysUETZluVQfO9J1zCvSu4pxGy7Wo5whQFsi7CCOjLY/8qp3U9easmHLSibi5l/XN7qLL4q8z4lEUaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740602179; c=relaxed/simple;
	bh=bSfCnBGLpKHCnCtdnfko3eEoettMod/zsg0lwnGfS7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=je6P22DWlMOrdvBnupnX1pQreBUsJVYFUVDE8fZ8iM6CWBTr74ptVwac0lix/C0lzt3PbMwPzeIjJSQNFrS77mjuYGOEyx874q5TPqweyLEaQg7tOTM/kq1QubUNferHz14jmsEoLq/wrGhTVAliGKKBk8G2yoakv5kuOQB8l/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bDQ6VbwK; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ab78e6edb99so24561366b.2
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 12:36:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740602176; x=1741206976; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8pfVb2jJwmxIauVKaI2S3DqVyZkb4z9/MscMiM2buxM=;
        b=bDQ6VbwKN5sCc01/NVYKZ+yXtSkc6d10LjYAlhDG4wfI5lXiebZdh8mFs9QhAXB8AL
         DH7mf5BD1snf5B3J6NpX6FFcNeRfFlKduIyvx9lu8fw3Iov/+8IZHkMMlvgWbCMO5t8l
         IG3Ec83xyyqMXqhwqUU68NDgHAovoz1ryx2Vck6s6KPLEF77LpJ7kPkWAuw/57nwI631
         XB+Vp4TT9OR9IYpL2F8jc4OvOh7YOj00GN8vhbRMogeJaIRU1B2RznjzpDVceRf4pQdR
         laS5Yr1IHL3boaUP98OtXhbgS/jus6G20UHilyiCABbVWkZwpB9cn62wMvfTQfTYPQQ2
         6DKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740602176; x=1741206976;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8pfVb2jJwmxIauVKaI2S3DqVyZkb4z9/MscMiM2buxM=;
        b=LyE9PK8BcEJF4Er12QTbmfnDv7NvGLY+W7y3UI4hfagZYe6BPzYLW7zQF+Xea/m2Hc
         zKglwBhFl77xso1IQyjWQfBsYCXJ+47xSLXeLp0jBhiqk/XocMWir2Kls1R387E+Iidc
         D0xgu0Fq8rQM5XX3e9akLi6ow8TqgraxYqxyl/Fwa5mc4mCyeHoMWFDHyfu892a9lqS3
         aOYX8vctkFartMcayd/Eo2TlaOSGdaLJt/5SCZ+g+tJrNmfp3rtj0ol/K167l3ykvzxP
         e3egyqvX5Br/NM25tXzmHIQ/qX/qhxdh38GLrbFmtQNOeNd215vhe+RbMSUbHGFlJxPK
         uTXQ==
X-Gm-Message-State: AOJu0YwoyQmaxPc0BCt/0xQKmEE+chOQzVuvkIT7eWMpMfKkRP4GXy4s
	JzgCC3/MWU4F3owaK/nFrx4tF8cmM+lqNp8SmIMH5Ub5P+c2FHbzX6aB9w==
X-Gm-Gg: ASbGncvQhq/kHEjwRkyZIGhNkj1qMbSLZKHSkQXYF/OVeos8LSQbwuqJfkFTLFIiGPs
	I9ThZuI+6g/YMRbsWuTKUgfyTshB6Gv/qkMNzF694MDrrt3KJDqrh2EzPBRybfRWME7y+GVxYqZ
	zXNk78DaIyQPPVieR0S9hktbxvRu6IubTGeTJRx+n/KGGJ0iXSlc2tTT5uHc9ozBqIxliwCMNCc
	ajepqtJs4jMh9rMCv8EBQ9aprsk7+lO1H/Q+nBklflgMzWzGTVtdL5683o/iupqbCFg1Sssae3i
	8tJZNvuFSY3s8cwRKlSHIL5ht+Av54jB7Q5Nlg==
X-Google-Smtp-Source: AGHT+IGnq0n1Uj7EFUNqvmWANZUTfQJpwaTwAASd6c/INOrDJioAvS816rYI+Cpmp/GTyhDh5n5HHA==
X-Received: by 2002:a17:907:7f0c:b0:abc:269d:d534 with SMTP id a640c23a62f3a-abeeef34ed6mr692356066b.40.1740602175269;
        Wed, 26 Feb 2025 12:36:15 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.21])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c0b92a4sm1327066b.8.2025.02.26.12.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 12:36:14 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH liburing 1/1] tests/rw: test iowq offload
Date: Wed, 26 Feb 2025 20:37:09 +0000
Message-ID: <0ba2c9c8302b4d2318bd33580e6170e3bce90e86.1740602134.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We miss fixed read/write + IOSQE_ASYNC tests, so add it

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/read-write.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/test/read-write.c b/test/read-write.c
index 23f1d582..ba98c744 100644
--- a/test/read-write.c
+++ b/test/read-write.c
@@ -46,7 +46,7 @@ static int create_nonaligned_buffers(void)
 
 static int _test_io(const char *file, struct io_uring *ring, int write,
 		    int buffered, int sqthread, int fixed, int nonvec,
-		    int buf_select, int seq, int exp_len)
+		    int buf_select, int seq, int exp_len, bool worker_offload)
 {
 	struct io_uring_sqe *sqe;
 	struct io_uring_cqe *cqe;
@@ -144,6 +144,10 @@ static int _test_io(const char *file, struct io_uring *ring, int write,
 		sqe->user_data = i;
 		if (sqthread)
 			sqe->flags |= IOSQE_FIXED_FILE;
+
+		if (worker_offload)
+			sqe->flags |= IOSQE_ASYNC;
+
 		if (buf_select) {
 			if (nonvec)
 				sqe->addr = 0;
@@ -227,12 +231,12 @@ err:
 
 static int __test_io(const char *file, struct io_uring *ring, int write,
 		     int buffered, int sqthread, int fixed, int nonvec,
-		     int buf_select, int seq, int exp_len)
+		     int buf_select, int seq, int exp_len, bool worker_offload)
 {
 	int ret;
 
 	ret = _test_io(file, ring, write, buffered, sqthread, fixed, nonvec,
-		       buf_select, seq, exp_len);
+		       buf_select, seq, exp_len, worker_offload);
 	if (ret)
 		return ret;
 
@@ -263,7 +267,7 @@ static int __test_io(const char *file, struct io_uring *ring, int write,
 			return ret;
 		}
 		ret = _test_io(file, &ring2, write, buffered, sqthread, 2,
-			       nonvec, buf_select, seq, exp_len);
+			       nonvec, buf_select, seq, exp_len, worker_offload);
 		if (ret)
 			return ret;
 
@@ -284,7 +288,7 @@ static int __test_io(const char *file, struct io_uring *ring, int write,
 }
 
 static int test_io(const char *file, int write, int buffered, int sqthread,
-		   int fixed, int nonvec, int exp_len)
+		   int fixed, int nonvec, int exp_len, bool worker_offload)
 {
 	struct io_uring ring;
 	int ret, ring_flags = 0;
@@ -301,7 +305,7 @@ static int test_io(const char *file, int write, int buffered, int sqthread,
 	}
 
 	ret = __test_io(file, &ring, write, buffered, sqthread, fixed, nonvec,
-			0, 0, exp_len);
+			0, 0, exp_len, worker_offload);
 	io_uring_queue_exit(&ring);
 	return ret;
 }
@@ -481,7 +485,8 @@ static int test_buf_select_short(const char *filename, int nonvec)
 		io_uring_cqe_seen(&ring, cqe);
 	}
 
-	ret = __test_io(filename, &ring, 0, 0, 0, 0, nonvec, 1, 1, exp_len);
+	ret = __test_io(filename, &ring, 0, 0, 0, 0, nonvec, 1, 1, exp_len,
+			false);
 
 	io_uring_queue_exit(&ring);
 	return ret;
@@ -620,7 +625,7 @@ static int test_buf_select(const char *filename, int nonvec)
 	for (i = 0; i < BUFFERS; i++)
 		memset(vecs[i].iov_base, i, vecs[i].iov_len);
 
-	ret = __test_io(filename, &ring, 1, 0, 0, 0, 0, 0, 1, BS);
+	ret = __test_io(filename, &ring, 1, 0, 0, 0, 0, 0, 1, BS, false);
 	if (ret) {
 		fprintf(stderr, "failed writing data\n");
 		return 1;
@@ -633,7 +638,7 @@ static int test_buf_select(const char *filename, int nonvec)
 	if (ret)
 		return ret;
 
-	ret = __test_io(filename, &ring, 0, 0, 0, 0, nonvec, 1, 1, BS);
+	ret = __test_io(filename, &ring, 0, 0, 0, 0, nonvec, 1, 1, BS, false);
 	io_uring_queue_exit(&ring);
 	return ret;
 }
@@ -933,17 +938,18 @@ int main(int argc, char *argv[])
 	vecs = t_create_buffers(BUFFERS, BS);
 
 	/* if we don't have nonvec read, skip testing that */
-	nr = has_nonvec_read() ? 32 : 16;
+	nr = has_nonvec_read() ? 64 : 32;
 
 	for (i = 0; i < nr; i++) {
 		int write = (i & 1) != 0;
 		int buffered = (i & 2) != 0;
 		int sqthread = (i & 4) != 0;
 		int fixed = (i & 8) != 0;
-		int nonvec = (i & 16) != 0;
+		int offload = (i & 16) != 0;
+		int nonvec = (i & 32) != 0;
 
 		ret = test_io(fname, write, buffered, sqthread, fixed, nonvec,
-			      BS);
+			      BS, offload);
 		if (ret) {
 			fprintf(stderr, "test_io failed %d/%d/%d/%d/%d\n",
 				write, buffered, sqthread, fixed, nonvec);
@@ -1047,14 +1053,15 @@ int main(int argc, char *argv[])
 		int buffered = (i & 2) != 0;
 		int sqthread = (i & 4) != 0;
 		int fixed = (i & 8) != 0;
-		int nonvec = (i & 16) != 0;
+		int offload = (i & 16) != 0;
+		int nonvec = (i & 32) != 0;
 
 		/* direct IO requires alignment, skip it */
 		if (!buffered || !fixed || nonvec)
 			continue;
 
 		ret = test_io(fname, write, buffered, sqthread, fixed, nonvec,
-			      -1);
+			      -1, offload);
 		if (ret) {
 			fprintf(stderr, "test_io failed %d/%d/%d/%d/%d\n",
 				write, buffered, sqthread, fixed, nonvec);
-- 
2.48.1


