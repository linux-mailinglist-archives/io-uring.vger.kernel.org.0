Return-Path: <io-uring+bounces-9734-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D710CB53055
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 13:27:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 941AA17FAA5
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 11:26:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AC6431B108;
	Thu, 11 Sep 2025 11:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LSeqxNGu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A0031B10F
	for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 11:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757589908; cv=none; b=RPL21Rh+Nj6r5qPiwjPieanGwd+2Mte5KPP047qdV4TznRXcsIarrkRJVOll/6ihFWa8m0OHYdajdOeQSZXnUv2DG1Rla9nNa+TZXspPJnkBNM6p1IUAcEqxAa4dyISoSNhkyb+8vDnAvsGctpwFITVKic1Wl88gq4BtlAtuI7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757589908; c=relaxed/simple;
	bh=wY43XbjxSYGbOWKtdkH38PrwMqAWlAUSHnA7MvTGkyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gr4BV2VNAbKx9k7ph+Er5B6UTxT8QqQzHqZORVeb8NhxMqizl2qvWmChhp+BCoSh8UAGuKBofWQSDU/T/sTnltjK6KuwFX5Kd4B0pCR1wGgxK9qHC1cy/UKFK1YqhuO97klIgQCMZSJOO7cbIxAJpiy0l0tqVac+ekEuBsA0KFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LSeqxNGu; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3df726ecff3so370988f8f.3
        for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 04:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757589904; x=1758194704; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/8RnRpA20eXDfDYnnmJVhUg0MFwJmitOrreT53pbUXo=;
        b=LSeqxNGusiI0NVmrAkELI5l+SkLcrNsG/OPUikKSWJloBQ3p8Gam98jSbCeI46AG4J
         wRwIvrfulPjehhOtpgqSKbBpBHswGtRPJOgjEsh4YAIPJp3TZGJueiVZG7dcqe1C1cT9
         Jp8aIsVlldw5uenpTq32LPWRA/JeBM3tq6US/isVUYUKltjvFUl9MKPDn9EpOpolboGW
         JCPFXUD4CpmsZRyXJwcAZvncMoXRDrfivmwWYagnBYMolJA4p/L4T3+u+46fT/VTeHos
         9iiQvQm5bCrTyfKXK/XVvcEIf5aNULGwtLhgEHxdejWLHE693rxtTWvkx82MOUhLjA65
         JNgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757589904; x=1758194704;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/8RnRpA20eXDfDYnnmJVhUg0MFwJmitOrreT53pbUXo=;
        b=cwEKVDbzmSqadDxnILstk3Ti26qMEPKIMBMmh1qRz0Ku3IzJIi/M49s13wANliOr7V
         aT8Nny1ktU4+uH/YWb8VarjFDO2YdDAsgnILvwrtjvBcRQapnBhHSzWOMt3fbD3oAO5/
         yRW1kk5Ae4te0qjtv6f4gJU9i+ttXfpaVPpk0BGppruYoaPA59cOd2yNl1yP/Th3uexs
         g7VIGRf+CVnpU1IJQsC61F/eM567wNCGurPDb9JY+vcCOfsp44srzV9h3JaP6PNo5gRi
         zNW7EofTXBn50yHeWy4i6+8TLgKO4aNKmMlYu5OXfTv028ldJXh9dAnChsS/W5U41W6U
         RLVw==
X-Gm-Message-State: AOJu0Yz8kzFwvLjBtOi4+CHSEdBjO3I6J9DmXqp2BRpD+HhY8rM4hB+c
	nLt+nnFza/V1FnBihdF8CHc6lWfVvGgxA2SMoa2zn896y92obW0GiU/arRFAOg==
X-Gm-Gg: ASbGncvuOsBTaw4XaXLLsqRL9mBs2FJ8y0eLR+gWQFS+ufunNboOZTUDqCrK5saHwtZ
	0iicGJQlXTOVKVEUfVAjHUntzIi/DTUkJsCFNOHVmAmUEOmf+z8VDVV8+NzkuStydm2nA49rdQw
	7g7Ifjplw5n4Q6aj39cgYWZffmN4VvZx4lImvvMRAh1AiSXAO4CuCE90UgaOGNmzy30cuPrdKSc
	kMIFxnXrh0anFJSwsE308Zl3JgGmASmsfu8YcrIW07njYhvHeD3oqT1MdBBhTOR9ynal0zO3P4n
	CK7dSrH8jcoxBk2koKDEq+WJ9oBwhzLbbxjnRIhzAm7n0ZLvF686+hpjJRTBtADn9uFXCBXn2SA
	XxMphiMtMME0XASpiMxNsgEUzHmQ=
X-Google-Smtp-Source: AGHT+IFr5M6LJhHfxFQQK8mV969ZS8fio8emOkwWg5x8qmfnoFqn3yCegX+xEXCxqFiZ0Ht3viE61A==
X-Received: by 2002:a05:6000:2c0d:b0:3e7:441e:c9e1 with SMTP id ffacd0b85a97d-3e7441ecde8mr11981015f8f.18.1757589904342;
        Thu, 11 Sep 2025 04:25:04 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a309])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607d822fsm2095608f8f.53.2025.09.11.04.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 04:25:03 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 3/6] tests: introduce t_iovec_data_length helper
Date: Thu, 11 Sep 2025 12:26:28 +0100
Message-ID: <197a9ef7cdee6cd1704f75b9d80b788751db78c6.1757589613.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1757589613.git.asml.silence@gmail.com>
References: <cover.1757589613.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/helpers.c    | 10 ++++++++++
 test/helpers.h    |  2 ++
 test/vec-regbuf.c |  6 ++----
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/test/helpers.c b/test/helpers.c
index 18af2be8..15ceb17a 100644
--- a/test/helpers.c
+++ b/test/helpers.c
@@ -526,3 +526,13 @@ int t_submit_and_wait_single(struct io_uring *ring, struct io_uring_cqe **cqe)
 	}
 	return 0;
 }
+
+size_t t_iovec_data_length(struct iovec *iov, unsigned iov_len)
+{
+	size_t sz = 0;
+	int i;
+
+	for (i = 0; i < iov_len; i++)
+		sz += iov[i].iov_len;
+	return sz;
+}
diff --git a/test/helpers.h b/test/helpers.h
index b7465890..a45b8683 100644
--- a/test/helpers.h
+++ b/test/helpers.h
@@ -124,6 +124,8 @@ unsigned long long utime_since_now(struct timeval *tv);
 
 int t_submit_and_wait_single(struct io_uring *ring, struct io_uring_cqe **cqe);
 
+size_t t_iovec_data_length(struct iovec *iov, unsigned iov_len);
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/test/vec-regbuf.c b/test/vec-regbuf.c
index 286b78c6..0cbe2c74 100644
--- a/test/vec-regbuf.c
+++ b/test/vec-regbuf.c
@@ -269,7 +269,7 @@ static int test_vec(struct buf_desc *bd, struct iovec *vecs, int nr_vec,
 	struct sockaddr_storage addr;
 	int sock_server, sock_client;
 	struct verify_data vd;
-	size_t total_len = 0;
+	size_t total_len;
 	int i, ret;
 	void *verify_res;
 	pthread_t th;
@@ -284,9 +284,7 @@ static int test_vec(struct buf_desc *bd, struct iovec *vecs, int nr_vec,
 	for (i = 0; i < bd->size; i++)
 		bd->buf_wr[i] = i;
 	memset(bd->buf_rd, 0, bd->size);
-
-	for (i = 0; i < nr_vec; i++)
-		total_len += vecs[i].iov_len;
+	total_len = t_iovec_data_length(vecs, nr_vec);
 
 	vd.bd = bd;
 	vd.vecs = vecs;
-- 
2.49.0


