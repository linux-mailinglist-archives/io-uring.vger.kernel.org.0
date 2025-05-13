Return-Path: <io-uring+bounces-7966-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1538CAB5B2A
	for <lists+io-uring@lfdr.de>; Tue, 13 May 2025 19:26:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C6CB1B447F7
	for <lists+io-uring@lfdr.de>; Tue, 13 May 2025 17:26:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 929582BE7CA;
	Tue, 13 May 2025 17:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ibhAbNlY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BEF15B54C
	for <io-uring@vger.kernel.org>; Tue, 13 May 2025 17:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747157154; cv=none; b=lFQkhlrDv+Pnc/QvLof8YP3dq1pRl9EET/C9NlL6We/k+deSlPkjd+9PfiKTYvb3Ih69wpe1K4IiY7096GaWdMx9krVXEiMSyAx+6R6BsajHYrs1P8OQW5AOVMtmoOphHQVoH1ULwI/UQc6XHMqyI5FEubdnvO02qjkbSkiwicA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747157154; c=relaxed/simple;
	bh=Ol5cVmB5/tIA+tQErZrMxzu5jnT3KfVrQ8Kv1d0sZas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCoNnPoCQlmc1ONYdEUQxmSJxslsk1NdNFZ1lz2r7MQMZixFpBket90//W8ATlOs5SeG3fWW0rB4b4p8tsWmcZb3evv7KdKpIEVjT0bL3NQyuSb6l/PAkbDO7N8MQn8VNxcbSnhr99D4Zr2VN63N2JCmVLBz3WVTtaDQZzFqtbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ibhAbNlY; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-441ab63a415so61364655e9.3
        for <io-uring@vger.kernel.org>; Tue, 13 May 2025 10:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747157150; x=1747761950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oFldgbVQq4dzZsJJBX5DGmmBJacGvrF+og+aTvfPdpw=;
        b=ibhAbNlY4N9yQVqzLMYdS6M7LJ2ojxOMxfkZ+JpXsM/x1t7ePn0B6EEnhRs3sRYq29
         uq1O53ndAzAvhyvsy5eyE5jKZvSXZyEn9imnemBiDRFySmzgOU7eNZloqTIV94JfGmRu
         U8PYp1GQwh60+p08BGHj5/wqs0GQk8PXdLwMBo19+iibrd0fOmqK8ZiaXsEuQK9km9nw
         1cEbYV1l0Xnt8g2+nPQlWMcpPm4DXbwlXqstZTpMRPhmYUy2YONkK7ZOrqlhiLcUz5rm
         fWRCTqJCS+cIR843m3FrGScfTXIFH52MfoR6lDzbEcWxwGjLXa/9/keQKS6BU2+qfNDC
         TPCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747157150; x=1747761950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oFldgbVQq4dzZsJJBX5DGmmBJacGvrF+og+aTvfPdpw=;
        b=MgYOeub1/6/1+/wwLzbThPqEir74gHvOtzogFpZ8g/4zBI4k9CyqL31uzVKNY4YsiU
         FIQCObPTUZ3tHeVAx5jFNGvkzs0TJ6YTTsg1m/gOXNucLu4lc3FbNfAisVHBMoASseTY
         VE4M1wAAvlekkE0FKpvVK2gN2RclRFPK7FAuu8YrjnuzdOT9kZUzAi7vW9LqNp4/bOUs
         SrpWnoZ263J994wN5PgbpTu7qwT6Hum0fybK/C+mK/FnqFfdKYXvI8DbuBYqwXVSe6dZ
         7ByWiIUvv8DjhR5k62pQIuFVQ81t8j9NMJoa/RpUBdQ5ahege2ReWQOhRe9kqQ2OmiPz
         GTPA==
X-Gm-Message-State: AOJu0YwA8bD/mYIKotmGt8I1gE68shT46neE8795qr6oFPbDuS6fNP7j
	cCFQ3WgH2UltINR09cIMpZqKafkHPPB/qfFSDoZGPdLwAeyRiiXlXioHLQ==
X-Gm-Gg: ASbGncu71ps9WT38jrTQf5uaF5spI1KXkBi774ARrvRo/pDc4TSj/l10CY5NDAjK99G
	1BVHmdEKjSOIsbrRH65183U9i61iJzXG/wqz38VQbpmlA2eVugYC2J1RYsg82+BZJwQjS7WgGJ7
	MXFNhI98aMe9IdAUxEG4FnG/XTbDaBzQm9ZwS/wq3Smk0NNunebJm4ykfGClqpg9FyadxGa1rvl
	5TQJGntp6EtF0E2IdFEV57A+6A0/+mcRLUl/v+YlcKpTJcXSk6K9lqGpuikEM0O+4aDFrDmhFPv
	xHU4e8BkpvfvMRx7hfETL2eWmNF+4bo6rEUFUfoeLOPonEyzfR4ohnsxFZCITXwg9Q==
X-Google-Smtp-Source: AGHT+IEBmn+iqhO049Ar7U+lFOGT3HipjzfwpLO3ShISxWcQXZFdiNH/XEBAJnJYEfw6eHRclwM2IQ==
X-Received: by 2002:a05:600c:6692:b0:43c:e7a7:aea0 with SMTP id 5b1f17b1804b1-442f2168c36mr1564735e9.26.1747157150355;
        Tue, 13 May 2025 10:25:50 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.146.237])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d67e0ff1sm173034745e9.14.2025.05.13.10.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 10:25:49 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 3/6] io_uring/kbuf: drop extra vars in io_register_pbuf_ring
Date: Tue, 13 May 2025 18:26:48 +0100
Message-ID: <d45c3342d74c9030f99376c777a4b3d59089074d.1747150490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1747150490.git.asml.silence@gmail.com>
References: <cover.1747150490.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bl and free_bl variables in io_register_pbuf_ring() always point to the
same list since we started to reallocate the pre-existent list. Drop
free_bl.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/kbuf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 344517d1d921..406e8a9b42c3 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -591,7 +591,7 @@ int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 {
 	struct io_uring_buf_reg reg;
-	struct io_buffer_list *bl, *free_bl = NULL;
+	struct io_buffer_list *bl;
 	struct io_uring_region_desc rd;
 	struct io_uring_buf_ring *br;
 	unsigned long mmap_offset;
@@ -620,7 +620,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 		io_destroy_bl(ctx, bl);
 	}
 
-	free_bl = bl = kzalloc(sizeof(*bl), GFP_KERNEL_ACCOUNT);
+	bl = kzalloc(sizeof(*bl), GFP_KERNEL_ACCOUNT);
 	if (!bl)
 		return -ENOMEM;
 
@@ -665,7 +665,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	return 0;
 fail:
 	io_free_region(ctx, &bl->region);
-	kfree(free_bl);
+	kfree(bl);
 	return ret;
 }
 
-- 
2.49.0


