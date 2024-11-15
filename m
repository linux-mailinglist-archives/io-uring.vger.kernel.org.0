Return-Path: <io-uring+bounces-4746-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A1FD9CF90E
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 23:06:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C4312821B9
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 22:06:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 240CF1FDFA3;
	Fri, 15 Nov 2024 21:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IuqDUir6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DBE1FDF8C
	for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 21:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731706409; cv=none; b=rz6BFgVi0HzLxq+lbjWkGatq+Gv5/jHHyhdaVPWghPaElAer/vO35N131BCaiNAhlVaGv5VGdl8VhlD1mN38hNUwLp9cp7FOcKJ4IgTTWTkcw+YKqTe43mD+Su7T73UdvR19bEGOC7VQggUozBYAxWnWXus5azURxYx+Mmg7XPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731706409; c=relaxed/simple;
	bh=oU/IDIGrC7pHswbHGlacBSqbj8OiD2Vv4/FkTISy8Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVvlN2nq8dFg2ozRrU226c465uO9C3I/bEaGiK9ZpXq8hsfxcIXtpIQAH/O/e6/GEPR6U4asX5keqfaCP3/mu3w6ciMqJt8LaXy65DGWQF0pMYg4eJ63TLfk8+oIfszuXY7I6TPtOWHXEC7OG5Gs2472jMKDzJCLaLp3BX5reMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IuqDUir6; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-37d538fe5f2so783434f8f.2
        for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 13:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731706405; x=1732311205; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P3X75yM8kxs9FzTe5Hfb8Yjb7xDP3WlYO8y+5i2/eDs=;
        b=IuqDUir6Dhd5/QRDs/UwQjg1krcxqQytMVl1vHc0Iq3KTn3moFFtSwyExRvKVDfxcE
         uZmvkrF7hLz1mQF1pIYJTD5Tr5MY4gr5Y2GwIuhiPxCDMkIcwmuJaHntWv0BP1xKAyo6
         epo/TeR9SVncxTRsEBFh6m38Dnjy12OTETLhrqko0joMcmuCL3vEK4+yKJXugUeKhqQk
         Fu7s/FTby/jGmahHS1z45o/lDIZ9KIBB4QSID2sIPl/dq8O/OFdOcDI5mz9oo7Di2CeC
         lrLbF1ZF1ecCvNREEytsJR5/zBaX6eyLn4OjMOWzr+ZH6iNp3suZ2GQ8USeQKMtUJwHu
         yU2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731706405; x=1732311205;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P3X75yM8kxs9FzTe5Hfb8Yjb7xDP3WlYO8y+5i2/eDs=;
        b=mtwNH4VTvezrB+hMFNYajfux7BAkF2D/YUwSVPUPPzGX2f74KjBQdIzUXhLeoNGxv+
         4NPD7AIQf+K84rPOe4qYc9Ojj+Sr5jzKiaOX26/aT4TukN2VBhXS4BM866NAhDtbt5zl
         JFqrXEsKji8r/jQ6+HEPkxQvHi4WSuLVA3zHoHLC8nuzVaCULqQw9uhM8UXiMzXThdXA
         EkkYoSkjkylpjvP1dENJ0w8s545EkAqNwqiErPtA0osX9G2OqDvbUXJ+1fibm5An5XoB
         WljRH2e2JI1eVCknSfRgim+uEarbHlg34aU0qStWmPQfvwP+QPAPJ3znHN8rPgyCpETC
         eUmA==
X-Gm-Message-State: AOJu0YxBHdIvK69/HpGu72L4HTIZHOorl8mNlCOAEGkHWJdcQjev3K5n
	+hWgRgUXfUOAZwDV7d82WA7Lqeit6XqZVSUiRihZ9duWmGLiVDjk66Iy4Q==
X-Google-Smtp-Source: AGHT+IHBFyYP+1EOPEwjyGQhEjNqxBLkwGNE5Ofo8/vklaBPe2b/aaaB1j08kHyRWP5oXqhtJhRrvA==
X-Received: by 2002:a05:6000:2c6:b0:382:5af:e99a with SMTP id ffacd0b85a97d-38225a9212emr3132999f8f.42.1731706405043;
        Fri, 15 Nov 2024 13:33:25 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.132.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-382247849b0sm3397258f8f.97.2024.11.15.13.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 13:33:21 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 6/8] tests: add region testing
Date: Fri, 15 Nov 2024 21:33:53 +0000
Message-ID: <806601a1247373694c6336f229c9b7ca168fca65.1731705935.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/reg-wait.c | 137 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 137 insertions(+)

diff --git a/test/reg-wait.c b/test/reg-wait.c
index 5f5a62a..13f6d51 100644
--- a/test/reg-wait.c
+++ b/test/reg-wait.c
@@ -178,6 +178,134 @@ err:
 	return ret;
 }
 
+static int test_try_register_region(struct io_uring_mem_region_reg *pr,
+				    bool disabled, bool reenable)
+{
+	struct io_uring ring;
+	int flags = 0;
+	int ret;
+
+	if (disabled)
+		flags = IORING_SETUP_R_DISABLED;
+
+	ret = io_uring_queue_init(8, &ring, flags);
+	if (ret) {
+		fprintf(stderr, "ring setup failed: %d\n", ret);
+		return 1;
+	}
+
+	if (reenable) {
+		ret = io_uring_enable_rings(&ring);
+		if (ret) {
+			fprintf(stderr, "io_uring_enable_rings failure %i\n", ret);
+			return 1;
+		}
+	}
+
+	ret = io_uring_register_region(&ring, pr);
+	io_uring_queue_exit(&ring);
+	return ret;
+}
+
+static int test_regions(void)
+{
+	struct io_uring_region_desc rd = {};
+	struct io_uring_mem_region_reg mr = {};
+	void *buffer;
+	int ret;
+
+	buffer = aligned_alloc(4096, 4096 * 4);
+	if (!buffer) {
+		fprintf(stderr, "allocation failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	rd.user_addr = (__u64)(unsigned long)buffer;
+	rd.size = 4096;
+	rd.flags = IORING_MEM_REGION_TYPE_USER;
+
+	mr.region_uptr = (__u64)(unsigned long)&rd;
+	mr.flags = IORING_MEM_REGION_REG_WAIT_ARG;
+
+	ret = test_try_register_region(&mr, true, false);
+	if (ret == -EINVAL)
+		return T_EXIT_SKIP;
+	if (ret) {
+		fprintf(stderr, "test_try_register_region(true, false) fail %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	ret = test_try_register_region(&mr, false, false);
+	if (ret != -EINVAL) {
+		fprintf(stderr, "test_try_register_region(false, false) fail %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	ret = test_try_register_region(&mr, true, true);
+	if (ret != -EINVAL) {
+		fprintf(stderr, "test_try_register_region(true, true) fail %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	rd.size = 4096 * 4;
+	ret = test_try_register_region(&mr, true, false);
+	if (ret) {
+		fprintf(stderr, "test_try_register_region() 16KB fail %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+	rd.size = 4096;
+
+	rd.user_addr = 0;
+	ret = test_try_register_region(&mr, true, false);
+	if (ret != -EFAULT) {
+		fprintf(stderr, "test_try_register_region() null uptr fail %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+	rd.user_addr = (__u64)(unsigned long)buffer;
+
+	rd.flags = 0;
+	ret = test_try_register_region(&mr, true, false);
+	if (!ret) {
+		fprintf(stderr, "test_try_register_region() kernel alloc with uptr fail %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+	rd.flags = IORING_MEM_REGION_TYPE_USER;
+
+	rd.size = 0;
+	ret = test_try_register_region(&mr, true, false);
+	if (!ret) {
+		fprintf(stderr, "test_try_register_region() 0-size fail %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+	rd.size = 4096;
+
+	mr.region_uptr = 0;
+	ret = test_try_register_region(&mr, true, false);
+	if (!ret) {
+		fprintf(stderr, "test_try_register_region() NULL region %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+	mr.region_uptr = (__u64)(unsigned long)&rd;
+
+	rd.user_addr += 16;
+	ret = test_try_register_region(&mr, true, false);
+	if (!ret) {
+		fprintf(stderr, "test_try_register_region() misaligned region %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	rd.user_addr = 0x1000;
+	ret = test_try_register_region(&mr, true, false);
+	if (!ret) {
+		fprintf(stderr, "test_try_register_region() bogus uptr %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+	rd.user_addr = (__u64)(unsigned long)buffer;
+
+	free(buffer);
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	int ret;
@@ -191,6 +319,15 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
+	ret = test_regions();
+	if (ret == T_EXIT_SKIP) {
+		printf("regions are not supported, skip\n");
+		return 0;
+	} else if (ret) {
+		fprintf(stderr, "test_region failed\n");
+		return 1;
+	}
+
 	ret = test_wait_arg();
 	if (ret == T_EXIT_FAIL) {
 		fprintf(stderr, "test_wait_arg failed\n");
-- 
2.46.0


