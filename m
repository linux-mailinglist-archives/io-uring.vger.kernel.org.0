Return-Path: <io-uring+bounces-7844-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EF8EAAC133
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 12:20:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B14353B2EA4
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 10:20:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8FCA275869;
	Tue,  6 May 2025 10:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XhE3uB4j"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086872641EA
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 10:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746526844; cv=none; b=u3+BZLE9StP/ssxvTQesHLWcl21sKv7Tedd3XQz6AxGRvaf1rbrQBOfjjDOtk7pyHXPCAI0MTOVW+qZaLhBfjZwuM5kuX4nG5c9wtI8RpuDSQgUwWQIO9oFk0+sLynBAXyeCpgSBo3kIwb6KnVg6yFoRYKVhn7vLlwPK7Dwtnzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746526844; c=relaxed/simple;
	bh=dA+oNPgFY6mBu3MQ9jN08HGSvfOjY1D3Lp8vRlnILfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUReYXYV2R0RMAJwyL2mZZd2+7AsKZ2gvD83ULBtUhuTYES4hG9Lc4N9ZdstFyNUJvaDMjp6HCx2qrhH2jh0UyYQDMjAtcjOVTHLb8spTnabBZaNhP7Xlx7I+CtSmWWLAi6+WD0Nc000E8EuxOClEIU/XUtf3/+n3a3qJ9XM/r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XhE3uB4j; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5e5e0caa151so31050a12.0
        for <io-uring@vger.kernel.org>; Tue, 06 May 2025 03:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746526841; x=1747131641; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q9QDnCKQXaAF5znur9Umh7vXy96O5oYSHXpUUcyI3Mw=;
        b=XhE3uB4jsSOCQtt/q8vzpq2J448oufK7994OXEXppNxmwyZXHrDNxIXpUOSL2RuXDe
         gYX2FU1khbipqGuH2gQOBs/6EYV9joG4levTN0/ZI49yzI1LXBP5Se6fnr+Ht2sdMkPh
         oVnhqxOX66GKqddvCQ/tsTT9BRx1GLPDxaWnyPvZGkqGnbVftpOb+PmYE4hEQwURByEO
         t4tkZIL/7awS6GQS3bUxPHdCYWL0Sul6iGoQyu/Xrhnd63dxseJH1G7z9b2wwfzP0LBn
         9ZyKRAqkbCo+qPLh7UP6t6iiLXfBmMeRCv9OlMrp/WrYI5C1KUVA2+m1ubXlXfkCjMzs
         DziA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746526841; x=1747131641;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q9QDnCKQXaAF5znur9Umh7vXy96O5oYSHXpUUcyI3Mw=;
        b=OmKA/ChxyM+3pJZj/PUG3Pe5gzafV5VOTJDsaKCNrLST49fApo6jCXjTRwsBUf9Hay
         sfc32NiYgxEyvmLsqn6CWx7x8aoR+l4qzS9mJ8Ll/wx3aQhtLTvhnnIK4OSStxqI2hVS
         saWCXcBlDb8DE0AGos+/o0ET4hQ7ws5GRUHA6IhkiLyP7H/9cx0AuWsvApNwby8l+ARf
         ICR3iAQykh4o2/HdrXjLRKoW9VeSOKR9ngruoQMVnax4Z8J+HAH9cepmyESVRQsWKlEt
         1oAkjiDa//eFMvDo51iwLWgZMCWv9aEGn/tigsHyYNHdfypC2fjKOVrOMpM1mo/03CAe
         ArGw==
X-Gm-Message-State: AOJu0Ywr32F+RdCg7449vcMJT8c/yP3LuSVutlQnHGBmSP3g0huuosh1
	kyDweSQxHTIz1MMyCVtMDiynvYTRarpuIdV8aYaI/wxXe2gLFX3JWeemYw==
X-Gm-Gg: ASbGncuM4bJkfCIZUktfephgnMiYqndfuRmwHc7D39U3rOazOaPhuyJyM0duVf0dnbH
	RBRszH13wHlQrdCThyNLKEU6x2h2Mpt7N9Mtu2yC4vtAqKXJdtkXbPcl9LyYz8hU/7eNPBmnSk+
	zqVsLNmJjeiRFQpVlCjaE8PRtzGY6E9CQoJZO3Jjw7B8RG/8zNny25m/RC5zJuq/BzQG3k+dZaO
	afb6ZPKb0Zr9cZcSSr7BrSqMuHMPyPrNBVtJWABBZg0AkJcd+B0+m9AWnk8VkeDew4oOFg1aEFa
	0QOzXJ92eCD+Kdb+CW9r3OiP
X-Google-Smtp-Source: AGHT+IE+6VX8itFjO4054qHFlU4PV3uUyYPR6K3jtMn+bAnF1dJxOkudHnN8dSnwBzsT0mEJ13ecDg==
X-Received: by 2002:a17:906:dc92:b0:ace:d957:d6d8 with SMTP id a640c23a62f3a-ad1a49fefe2mr975455066b.34.1746526840712;
        Tue, 06 May 2025 03:20:40 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:b5bd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad1891a2df5sm671750566b.38.2025.05.06.03.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 03:20:39 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 2/2] examples/zcrx: udmabuf backed areas
Date: Tue,  6 May 2025 11:21:51 +0100
Message-ID: <73c4937901b2d874f651ff0fa1d6b0cf632f3f01.1746526793.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1746526793.git.asml.silence@gmail.com>
References: <cover.1746526793.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add an example of how to create dmabuf backed area. For that we use
udmabuf and mmap it into user space, however in more realistic scenarios
won't have direct access to the memory and will need to use dmabuf
provider specific api, e.g. OpenCl.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/zcrx.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/examples/zcrx.c b/examples/zcrx.c
index 6b06e4fa..c5e1b42f 100644
--- a/examples/zcrx.c
+++ b/examples/zcrx.c
@@ -37,6 +37,10 @@
 #include <sys/wait.h>
 #include <linux/mman.h>
 
+#include <linux/memfd.h>
+#include <linux/dma-buf.h>
+#include <linux/udmabuf.h>
+
 #include "liburing.h"
 #include "helpers.h"
 
@@ -56,6 +60,7 @@ static long page_size;
 enum {
 	AREA_TYPE_NORMAL,
 	AREA_TYPE_HUGE_PAGES,
+	AREA_TYPE_DMABUF,
 	__AREA_TYPE_MAX,
 };
 
@@ -83,6 +88,9 @@ static bool stop;
 static size_t received;
 static __u32 zcrx_id;
 
+static int dmabuf_fd;
+static int memfd;
+
 static inline size_t get_refill_ring_size(unsigned int rq_entries)
 {
 	ring_size = rq_entries * sizeof(struct io_uring_zcrx_rqe);
@@ -91,11 +99,58 @@ static inline size_t get_refill_ring_size(unsigned int rq_entries)
 	return T_ALIGN_UP(ring_size, page_size);
 }
 
+static void zcrx_populate_area_udmabuf(struct io_uring_zcrx_area_reg *area_reg)
+{
+	struct udmabuf_create create;
+	int ret, devfd;
+
+	devfd = open("/dev/udmabuf", O_RDWR);
+	if (devfd < 0)
+		t_error(1, devfd, "Failed to open udmabuf dev");
+
+	memfd = memfd_create("udmabuf-test", MFD_ALLOW_SEALING);
+	if (memfd < 0)
+		t_error(1, memfd, "Failed to open udmabuf dev");
+
+	ret = fcntl(memfd, F_ADD_SEALS, F_SEAL_SHRINK);
+	if (ret < 0)
+		t_error(1, 0, "Failed to set seals");
+
+	ret = ftruncate(memfd, AREA_SIZE);
+	if (ret == -1)
+		t_error(1, 0, "Failed to resize udmabuf");
+
+	memset(&create, 0, sizeof(create));
+	create.memfd = memfd;
+	create.offset = 0;
+	create.size = AREA_SIZE;
+	dmabuf_fd = ioctl(devfd, UDMABUF_CREATE, &create);
+	if (dmabuf_fd < 0)
+		t_error(1, dmabuf_fd, "Failed to create udmabuf");
+
+	area_ptr = mmap(NULL, AREA_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED,
+			dmabuf_fd, 0);
+	if (area_ptr == MAP_FAILED)
+		t_error(1, 0, "Failed to mmap udmabuf");
+
+	memset(area_reg, 0, sizeof(*area_reg));
+	area_reg->addr = 0; /* offset into dmabuf */
+	area_reg->len = AREA_SIZE;
+	area_reg->flags |= IORING_ZCRX_AREA_DMABUF;
+	area_reg->dmabuf_fd = dmabuf_fd;
+
+	close(devfd);
+}
+
 static void zcrx_populate_area(struct io_uring_zcrx_area_reg *area_reg)
 {
 	unsigned flags = MAP_PRIVATE | MAP_ANONYMOUS;
 	unsigned prot = PROT_READ | PROT_WRITE;
 
+	if (cfg_area_type == AREA_TYPE_DMABUF) {
+		zcrx_populate_area_udmabuf(area_reg);
+		return;
+	}
 	if (cfg_area_type == AREA_TYPE_NORMAL) {
 		area_ptr = mmap(NULL, AREA_SIZE, prot,
 				flags, 0, 0);
-- 
2.48.1


