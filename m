Return-Path: <io-uring+bounces-4901-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A72E19D449B
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 00:39:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1F95FB21FA5
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 23:39:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 353521C1F12;
	Wed, 20 Nov 2024 23:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OW244mQq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88ACB1BC07B
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 23:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732145958; cv=none; b=jgfEKe81M1Rzpu0se2WWXW0A/mWl+AGTb7Eb73hzpQNXG2klMpw9HAPFzXt8+WNZ6tb2eJeB+gT4nx7pErcsUt7/FFBrvwNApdFg9H+13GUlEJVlf03X1QHywKO7Ez+YGqKbF3feMzYnxJwhm6RxMlK9fw6Nv+C42vM5YR43OLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732145958; c=relaxed/simple;
	bh=X93e4P6TrNChfhJFSS8kzIWDocqiqJKXRoBJmTVTOAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJAaijFS7Wo1SZrMYUpavpzmhZzbte4XMFg0M+d4mwZicOnyhKkHW05GNcJR5njbLEsmuXa5g5qzVwYBwgW8an5Fh90yNSyx86w6fiZ+hK+TCWd4fNykj+WncbOMJjRdvk2j01dsnRPAJNY54dzhFAAozb0bjphT/K0WERzKAz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OW244mQq; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a9ed49edd41so53456166b.0
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 15:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732145954; x=1732750754; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wctm1ym+mS1Y4xYRtSWfz2pW8kjA6AZFpy5byKN9nvA=;
        b=OW244mQqzZYvjVhyrlNZX5M6Cxj2nrsuhI8LFP1Wt2G8jopUHvoDgqFb0cP/3g/1zb
         s4Ju53Yi5aGBTD7ewyALEl4H9RNMCgX15HUnvveE9T3C7oOIpQszpcBKBcAiBtHKlTAx
         PGlRLSPYzNqcPByj3qGcLtbU+bvKFb6Eb7UsV9VDShEUNN7/oAH/xpnJ869ZXcyNrRLE
         8yqYVfOl/xXsB8nFLN0OqWrt2D/awPPlSKzZ4M043K33C/a5YslaGdXSwRSBe0TCFQVp
         Qbo4YX9vhmYauWN+qOENFC1R8/67Lgd5pE7uxnBbGx2ziCpE0LV5QJaP2WcNkM18y+Lm
         Mclw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732145954; x=1732750754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wctm1ym+mS1Y4xYRtSWfz2pW8kjA6AZFpy5byKN9nvA=;
        b=msQEZIApbzz+lCnvfyJAXwBQvdwDcEJV+Va4+kLUOSmXL55QoMunaOLQM0AsimlwbV
         0xKCQyJJCZVLIoLE48sdCsjdFYbteM5Ee4gBaA+2YRB5z3ix6PdAHLqUF3TFGTiOD5IK
         zWdvxhWXqjg28Hd6CcWwbC3TG1Dl/kknVMuhfgp4iZpDW38zu9daUzQN7RNMoZFRoO2Q
         qls5knQXro5p//wxn9VQQ0yX5j6Mg3swQ25EyaCaFJap4weuIlQ5+HcvSGxzwomeR1TO
         t++tX3Q+AQAXzJrCyQ8QBVtWviEGUtI8QIY9T8dhgUeFPe5ZGO583Dz5bvtBpFso/rvc
         iVdQ==
X-Gm-Message-State: AOJu0YwAIbMSNtVk+yleJ1c6S7jbkG/APIk/mOrZIMTANh1PXI4wR4cP
	QQ/flc7tjTLLzmjhBD1qb/LrFidlICVs8jTLJ2LkagPCvKAUZd2KfUnlMA==
X-Gm-Gg: ASbGncuqrOawWwcS4IIKJAS0rOdq4S/xoN/eoKJiwSDOAwG2qvknqOEDzwqCJg4M8q+
	9pZGLUoBUG5xD3YzbChVgfi62RdYj5YR0rELPgtNLDKPrL2OvtEF0bzbddm/KSmFO2pHdeKTnlA
	AAvjf1UcrUcKAZx4QQ5hkU81OE2Yxik2AvdxFkJ3Z0yNMi6D3Ag15UhgoXx3HcqThhuIJ9RPg/F
	+DKw9hvo3n8N3wFdaRWiuLrRi00sVWsHh0gGcLI7BkCgI5xoxq6OzWhtVdqg6J2
X-Google-Smtp-Source: AGHT+IF6ojHr7YeOYwFHqfyXJvgsynhEM7aND1VU2+A7a8VLDld5B4aEFjRBhTFhpVe3qQFzbzoT2A==
X-Received: by 2002:a17:907:3f99:b0:a9e:c947:8c5e with SMTP id a640c23a62f3a-aa4dd749167mr491479666b.57.1732145954222;
        Wed, 20 Nov 2024 15:39:14 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.141.165])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f418120fsm12544566b.78.2024.11.20.15.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 15:39:13 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 2/4] test/reg-wait: basic test + probing of kernel regions
Date: Wed, 20 Nov 2024 23:39:49 +0000
Message-ID: <8a525a846002b2a899addbae52f922d9034b4257.1731987026.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731987026.git.asml.silence@gmail.com>
References: <cover.1731987026.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/reg-wait.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/test/reg-wait.c b/test/reg-wait.c
index 544cd48..9b18ab1 100644
--- a/test/reg-wait.c
+++ b/test/reg-wait.c
@@ -23,6 +23,8 @@ static const struct io_uring_reg_wait brief_wait = {
 	.ts.tv_nsec = 1000,
 };
 
+static bool has_kernel_regions;
+
 static int test_wait_reg_offset(struct io_uring *ring,
 				 unsigned wait_nr, unsigned long offset)
 {
@@ -380,6 +382,27 @@ static int test_regions(void)
 		return T_EXIT_FAIL;
 	}
 
+	rd.flags = 0;
+	rd.user_addr = 0;
+	ret = test_try_register_region(&mr, true);
+	if (ret == -EINVAL) {
+		has_kernel_regions = false;
+		goto out;
+	}
+	if (ret) {
+		fprintf(stderr, "test_try_register_region() failed kernel alloc %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	has_kernel_regions = true;
+	rd.flags = 0;
+	rd.user_addr = (__u64)(unsigned long)buffer;
+	ret = test_try_register_region(&mr, true);
+	if (!ret) {
+		fprintf(stderr, "test_try_register_region() failed uptr w kernel alloc %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+out:
 	munmap(buffer, page_size);
 	return 0;
 }
-- 
2.46.0


