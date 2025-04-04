Return-Path: <io-uring+bounces-7401-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CEEBA7C168
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 18:17:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A551177A86
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 16:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88DB01FECAA;
	Fri,  4 Apr 2025 16:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tunx884I"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C611F3C38
	for <io-uring@vger.kernel.org>; Fri,  4 Apr 2025 16:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743783434; cv=none; b=o7nFxA69JULI0OxAIghFj3QHJcxC1dabV4JGY/8FuuMFOovs4p89mECWNJxS45eG69lzpab6DKSaW/1h3pKHbW7BAKHQ3IbrsvMnQiyWyJJ99zs3+pPsGkIfYKs4JaUlgTmvz7AOeN1NILZAcSGosDrdOMlCMjltIW66oo4vvZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743783434; c=relaxed/simple;
	bh=rbtnVk58sEuu69YS9d5W4gSfdgeNgzHwL3yrvYagMSo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IpABh4JRKkeNEaT+Bfuc4G56UdfAsk+cawQy2tlpcVvTu8SEBSXd451tbktYrHSVhDOJLi3rpkDglSq57mkbqCHSjJJ18foNk+EWTx1zo5Tk3KwwvrvaX3NdBANZ7qUBmNxSI0G92dC/4omBfpMNSuovU41t8ClSaW3WAhzZqS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tunx884I; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-aaf0f1adef8so347764766b.3
        for <io-uring@vger.kernel.org>; Fri, 04 Apr 2025 09:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743783431; x=1744388231; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fmoEzpjtepWPvv10dlSiXv/dczbDBSLRpMxYpHnMwX4=;
        b=Tunx884IBNYkft0ByO5OCG6YHkfqU60u9CO30eGvo1HlxbtFirpyaYg5WIGiPctp7S
         0dJ4zTtXl321dy8zKyOyYHcqxAsMxqJr6bL1QrHuhcZXzaWtQc4vKSao38hyDYHMUeQe
         Hw560nagt5say2XNBV20fqui87SiRvB764m8PsNLRoPHurZb4GDYAO/u2wo6HRWNVBUD
         Pe5mTgTKaOIV3zjdzx49IVpXkFoOKkfXkQVzpbMzynftnxC/49bt6EM2rUknVRx8Bl6A
         ezktsxUIZ7J86qEGZXR//mMVs1puGxTjgR1TYyfSH/i0JWQBd0AXz0BWINry9sqCZXXG
         6QlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743783431; x=1744388231;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fmoEzpjtepWPvv10dlSiXv/dczbDBSLRpMxYpHnMwX4=;
        b=SB3MQzsBzg8R+kOlKKce9rqFZEnrF89J1ZaP/VF4NU3WfvpDymHBgrAVpZTCO+8Ecc
         183GvoiVMTR91A7QqIKKvfEsMJRIQxfh2c8Gr2F9dmm3qKqm5b7uYQGDTT1XKN05uRvR
         kAgwEMlwoge3ulzSA5T71Rn4zk+/SwpSghezrgC3VZ3HfAgPU5aE9ZO69ORobE1TR8wF
         fnmJaOFRLAE3p6vlYgmWsVkr6KwxAs1TIPMsRspFjJ7B9vuK9hYyYFpfcDtrQpmiSO9V
         XDR25FixmuhYBxM3YT4yaOiSIZ24f8pRTnfofumEDenGbPULN0TD4lue9zG2VwcpuM7Y
         KexA==
X-Gm-Message-State: AOJu0YzeLrU2NvEvCkqHlFl1WUrbjcxGIVJvIKQr7W4AA7Bx32eac6JY
	qNGq12TiTOZ0VwpbrGthI+pSoIGYI7QI+eN5HgMskxAiJ2QtmvniFK0TMA==
X-Gm-Gg: ASbGncsrQV4TO3vgh59CXEUujLe9zQVYhfwoBb54yVZvQ2f4UQVIhG9QcxkpzIUsNBk
	VbK/87i1leL1kJ7J5hCIzzI/JLty25cw+5+NEZ6MQN7iT1eiDIPivb9ClnPIABvqR8QpG2GQm3G
	G1WRygos8PSrlPaC3ysX7uoPPyoM5P0IYlBTKOlet/i5l0LLuMLCDZpoqKQpYbTe++n2gIYNcK8
	iQWAn0j8LDhly3IP+JkKozkbC+YemqruWmFk6ELi8ujfWRivx442RF3TMn2pkE/pDA5tkylJYt1
	mznRgNvaj/uh+1s0JyJxaI+Goi54
X-Google-Smtp-Source: AGHT+IH82FAfJrX9yEvUKN7VhMoD7L1gqHwJ6aia0IW8pzQzOnbmo/n/E/W6pye9d28LOQ3bGCF0NA==
X-Received: by 2002:a17:907:3da3:b0:ac7:794e:1dbf with SMTP id a640c23a62f3a-ac7d6ec8d9cmr293281066b.57.1743783430479;
        Fri, 04 Apr 2025 09:17:10 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:ce28])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c013f685sm282700766b.102.2025.04.04.09.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 09:17:09 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 1/1] tests/rsrc_tags: partial registration failure tags
Date: Fri,  4 Apr 2025 17:18:21 +0100
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


