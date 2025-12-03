Return-Path: <io-uring+bounces-10897-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5127C9D66D
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:36:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CD163A9878
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC2E82153EA;
	Wed,  3 Dec 2025 00:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jrJzVEYU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309272066F7
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722193; cv=none; b=JLReJxYB3ITjz0rh4HvhbKKwGICEjDL1VJNbVszvmfIfqhpDJwqlEerSVBxVUfxKrY4X+oUibK5UIGtoeI67lNvNnpH54+jQPVjQsYjsPKvjU8sFCJigMsCGGy/Y6NwZfveVo1b7VT0j9ZyQKO1QPSU7odaOcOGIH4B9csqFs5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722193; c=relaxed/simple;
	bh=7T6726z1zdlV1hWkP8IfMOUiajK+mSFph4zflnKYWCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNNOtt6Pb5NIGl1V4HhNSb7UE8JomOX5wnZZ0R+5wZ16PTwYag0XwGUF+olw/oAUjdqkN5gh+kGZNXneZjt5eoQh738tB04AG56vjyuEj5ntTXv6S2zTuT4cTiUDIyT7gRBceb6ayGf5TIJRfTxgoM76afO+Lu+/mSu497QpDq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jrJzVEYU; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3436d6ca17bso5856450a91.3
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722191; x=1765326991; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7N4XE+ZdXB4ivipPSz0W5fhv6rsGP2vaJ2oXWPonyhE=;
        b=jrJzVEYU0hZOg/EAUKJRGPmPukDm44EOsg1L87YflaDUmehh9OMRHnK0zu3Vajyfvv
         6sFoIJkAaXnpvraPNvYaDx33CoGhx8dd52QnRx27WbTsJKZ7JLi4lt8XnYoFk5F5LfHY
         cGgguGiA3RJTdh10WdItiA7uH2bsd4KqCaaIku6B0IWi+8Fq71yMZXaUnl0Nx0P4WtVP
         ryuDP7oh08ROUrO7o7T11tZx0xtPl7DVufdoARdzPiFh5HFvxfydS+sV0/0wep4yK/gu
         ndvedq2tRufWPhTu5C/KAj80JxuvORIzMC/CtUJZP0FCh/e127G4hxEiqtmAvDah8TWt
         jziA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722191; x=1765326991;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7N4XE+ZdXB4ivipPSz0W5fhv6rsGP2vaJ2oXWPonyhE=;
        b=QLOTF1tP9XijxP7cw0FLMnTkxVxzPXF4H238tbjALmWsBSzfL0bYt/oV1jWhv4ff8+
         GWh19+Bau/r9OYFJxOvwZqzVuyu9XdZCq3N2GgM3VenrDXprvnpp5ZFq1e04LW+PBJmK
         pbl5MlLmOPwvk52GGU8RKGLu2IE6jgYjWs5WgDZuLDxWTU9jh246898ohX+KsuAE691l
         q9auokXE/w982hAXXCUPlvUiHZJLJTVj3I54NyXVhyETVPUhtrmcbjhBV8i/hYcMRgLb
         txgcBfhGQ5c7fjf2NpiBOAw8ck1YF989Or0bHIpnsCWBeiZcmTJlrrA3agetOYMTIP9f
         UAQg==
X-Forwarded-Encrypted: i=1; AJvYcCXkCQ0x6rNI8tx/qj7AUUrjfBvIZTPCiCGoXHnan7JaAtc+d4SW6MSwl4GNP7A9rLcG8eTMaWDl9A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/8sJmp4GhydjlDUN2XhhcDWc/jLDxy2efF5cMEBQrzinb7PK4
	otjVTdGQIJOHbTSxY/+2xUxL5R63+vgOo32efMXbbOtFi7zWsZNCHOZc
X-Gm-Gg: ASbGnctzPW3TQNN9ZC3tu6dm2o9vTx1820vh0auNYX7bvbxIdQoKVQ7ysGmHjqi99z5
	MQFt3b2i8P3qR6YpwrpqDfNjKRQINLs3+pDdHEEFGYR6oTBYUNLsGvA/pCyAgNtz/TuNxdWKE7V
	xxH6yXTl/3IbkHntVprgBD5cSHiVKx+aVZClTzWDAUQ0YdLf3c7l1vTWbTYbhw3L2uWlzbfH9iY
	VCYqB1u9fBlW/KRAuhytr/ytcUEvCX11mgdQK963a21Dtbzo2XWeDD1aub2lD59Nh4fxGSvXUDM
	iWWJ/H/i+XuSrC4YlPCiFUjSD96m/dvAyaM61wli/wDBTj3Nfzne3KM1/G8yPoYUbbz4q2l3H4E
	z8spDRI8Q1IP75GgtOzsK1jc9JsPD2qE0ncXA7vawds8eKdZ8BU0oXyS3ywpQEIaXQtF8QIx7+A
	wPMEP2C6EvqyhH0Oj6GQ==
X-Google-Smtp-Source: AGHT+IFe8N4CJTxVm4Pd+7FlQ7rZzjaveicQcluksZN4R5dW8tltCCoNKntWi22n4zQg1djw2EH3mg==
X-Received: by 2002:a17:90b:4d07:b0:340:c261:f9db with SMTP id 98e67ed59e1d1-349125d0893mr580312a91.10.1764722191463;
        Tue, 02 Dec 2025 16:36:31 -0800 (PST)
Received: from localhost ([2a03:2880:ff:4a::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34912d2109csm136271a91.4.2025.12.02.16.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:36:31 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 02/30] io_uring/kbuf: rename io_unregister_pbuf_ring() to io_unregister_buf_ring()
Date: Tue,  2 Dec 2025 16:34:57 -0800
Message-ID: <20251203003526.2889477-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251203003526.2889477-1-joannelkoong@gmail.com>
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the more generic name io_unregister_buf_ring() as this function will
be used for unregistering both provided buffer rings and kernel-managed
buffer rings.

This is a preparatory change for upcoming kernel-managed buffer ring
support.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 io_uring/kbuf.c     | 2 +-
 io_uring/kbuf.h     | 2 +-
 io_uring/register.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index c656cb433099..8f7ec4ebd990 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -718,7 +718,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	return 0;
 }
 
-int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
+int io_unregister_buf_ring(struct io_ring_ctx *ctx, void __user *arg)
 {
 	struct io_uring_buf_reg reg;
 	struct io_buffer_list *bl;
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index bf15e26520d3..40b44f4fdb15 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -74,7 +74,7 @@ int io_provide_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 int io_manage_buffers_legacy(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
-int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
+int io_unregister_buf_ring(struct io_ring_ctx *ctx, void __user *arg);
 int io_register_pbuf_status(struct io_ring_ctx *ctx, void __user *arg);
 
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
diff --git a/io_uring/register.c b/io_uring/register.c
index 62d39b3ff317..4c6879698844 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -750,7 +750,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		ret = -EINVAL;
 		if (!arg || nr_args != 1)
 			break;
-		ret = io_unregister_pbuf_ring(ctx, arg);
+		ret = io_unregister_buf_ring(ctx, arg);
 		break;
 	case IORING_REGISTER_SYNC_CANCEL:
 		ret = -EINVAL;
-- 
2.47.3


