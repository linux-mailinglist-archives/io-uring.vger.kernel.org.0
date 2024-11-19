Return-Path: <io-uring+bounces-4801-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 986C89D1D4A
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 02:28:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5272B1F23ACE
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 01:28:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B993B2AD20;
	Tue, 19 Nov 2024 01:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TyKQq3nJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD9B200CB
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 01:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731979710; cv=none; b=t4U2WG9+V41H3jxEj1NgKq4abghjA90DF9oVjhqmOdX92TN4csafLl7yjqZBUPWTtH1VtNrYWvrrX0J0114N5znOc8v4HeeT91BOL0v5zNxtF+zXTG3aw5GmGn0noJs0GOFh/Xqw68MUl4PQaLox1/ADsBmbwQJi+dQ0VYKlJ+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731979710; c=relaxed/simple;
	bh=sau5uyc2b+0Sktxnz7sB8+mIfcNRXliBmG90ibDvDv4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mSaQn7Xz5m5f1W8q759NdaUFL82Vh4zAzqSHidBaJWhzoyKNU7LeD/P6I/4x9+ZpwWyAPlj/HVFcuvGLqSF/xjqzT6cuSgOTyJMKpx2y+xGt79W+A5oTlzSH72HEWjZQ6EQ+TtY77uRz7vUqmfreI4BjI7H4CmEAYiMrxdTaf80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TyKQq3nJ; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-aa4cb5fcc06so32477966b.0
        for <io-uring@vger.kernel.org>; Mon, 18 Nov 2024 17:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731979706; x=1732584506; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hLSU/jRUhuHXlhVBDdtqkUFQT5le+HcAWBdoUp3qv8c=;
        b=TyKQq3nJnzkdCOntqu4YFxZCD3h42B9m/u1h+W2fr6Mt1L0JwjlICAZhqopku1NuRA
         HnFV8BddPtOxoFgDxBzR1y5Dscun1619Xue/C9bud8YcgoScVtnfn24JBzm4Vtoha5cC
         Va4y6JoYbBe8zQiZyrA6txz8MjHaVJnZcpVEglJH86axLWL87IaUOkFlWxvbaYn5iT7/
         cRP09Kh69nhVDpYnrr9S0eDesv9WySUIPep0P7f5HQoLblImejdHXK/SnfrIsmqCx5MZ
         IEj1VbI9iaZnTs1MhDgdvBU/LrzoVMFM8FOgaMApB2ooxpQw1besxQjrNJy/Y561hLdh
         RyDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731979706; x=1732584506;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hLSU/jRUhuHXlhVBDdtqkUFQT5le+HcAWBdoUp3qv8c=;
        b=tc74nrvpE7y5VJ5iNL3oe5/fhRXjQax4il3yrHtj0t8+8634/f1SY9T6i0tuCF7tm8
         Bo3Y0W98fKidR8XmzJURhc+8dz2k05dWbgtlj/RMlVzxcWx/bqUuMQfP7noU7Ev1G+3L
         slL4wrHcAB6wOtbr+4hcvmMD1ewuz94yWuNAx4AApOAey0QLR+jczjxrr9BGomwXNZfj
         d0u6hKlEcZFa5DqhsTngdVXDDsU5gHP1RzsHHb6d/9UDVv3CJhjyhCnK0ZumTP5BDdzr
         SpV7OeLfi5eVzoFnSiv/aSLP9x+AOCBZTLb7p9Pyqp6ijRreasx6thwiLx6ShgAXPULJ
         6K+w==
X-Gm-Message-State: AOJu0YzgBW+XT6cIqBcFaf3D0AW4xNgrQiKGEw9Mpd9sxdc82H6EXoVw
	R1R4BnLUK3fwWL74slKz6y9xFDJt9p/G6JzDtV7on/RPRu/1mDgEdA+bhA==
X-Google-Smtp-Source: AGHT+IE9B+GPwIs0Sb8aYsXpcA+UTq8zAGH6N+1KdkhWCKcwqd+duEJxEcQobRT+Pq6LQ4V6Kax7wQ==
X-Received: by 2002:a17:907:26c4:b0:a9a:161:8da4 with SMTP id a640c23a62f3a-aa483556b92mr1309388666b.55.1731979705847;
        Mon, 18 Nov 2024 17:28:25 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.141.248])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20e043bbcsm591539066b.152.2024.11.18.17.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2024 17:28:25 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	jannh@google.com
Subject: [PATCH 1/1] io_uring: prevent reg-wait speculations
Date: Tue, 19 Nov 2024 01:29:03 +0000
Message-ID: <fd36cd900023955c763bd424c0895ae5828f68a0.1731979403.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With *ENTER_EXT_ARG_REG instead of passing a user pointer with arguments
for the waiting loop the user can specify an offset into a pre-mapped
region of memory, in which case the
[offset, offset + sizeof(io_uring_reg_wait)) will be intepreted as the
argument.

As we address a kernel array using a user given index, it'd be a subject
to speculation type of exploits.

Fixes: d617b3147d54c ("io_uring: restore back registered wait arguments")
Fixes: aa00f67adc2c0 ("io_uring: add support for fixed wait regions")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index da8fd460977b..3a3e4fca1545 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3207,6 +3207,7 @@ static struct io_uring_reg_wait *io_get_ext_arg_reg(struct io_ring_ctx *ctx,
 		     end > ctx->cq_wait_size))
 		return ERR_PTR(-EFAULT);
 
+	barrier_nospec();
 	return ctx->cq_wait_arg + offset;
 }
 
-- 
2.46.0


