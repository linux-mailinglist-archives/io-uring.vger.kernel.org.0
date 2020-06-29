Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D68E20DD93
	for <lists+io-uring@lfdr.de>; Mon, 29 Jun 2020 23:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731631AbgF2TOC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Jun 2020 15:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730821AbgF2TOA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Jun 2020 15:14:00 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E03FC008601
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 03:14:52 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id w3so3083227wmi.4
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 03:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=N+4UOWBZzrgwQGhMntSqcuSTT1fw5zdmbfmsAaddoMM=;
        b=untGSkEVjoHF2vPy/QKR/5Ufi1Tb6E/IN9MWFa5wyHplk31pxkyiUpD20wsS9A9Ul4
         VS4V4B/T7zdo1JG424i8rfU46TEIsXZFq+MTmB16NEByOAJP93DpacCUaGXhRC73VcHA
         7wJK9rRN/3SSt1YCytevxoSBQVG6UemMbU4R9c5mujB9pKJ7Rh70PLjEtMeyMmVbaSVm
         0I+qI+jpLzaQjyiBqtwjVty5ATTsSNUsCQZCcdbQ313pgnF9xrICoqWwlRzgkDNLK5F9
         atkyVOCRGgMKwoq5WeP+0r/TaMEoMD+Hgij2F+Bj7mqZmrZOJFu242uAEZVP3thv94xJ
         PQdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N+4UOWBZzrgwQGhMntSqcuSTT1fw5zdmbfmsAaddoMM=;
        b=pT6ezgQ/SIHqjexdoGeg1pv3puYBdr4VO/XHhsU+J69d7jShwjuDyv/YHKEf/QeaWs
         zqzirAYzyYetZNcKQyrsrJB7VNvt3cpZWJ8ezs6CoyJhwEX0HoS7GaYKRqO43f+Uw347
         7PZv7Jigzl5VjFdCHIfWL/WpqZWzr5jdNoClk/0LDe6JsNrxp0itwmZUmf6E5Z7nP4Dn
         REeamt5QrwvbM8LxhhgzLKrpQdeXPwvp1OQihNbJF6rYq2kNZEr4JrlisrEpKODuLBQ1
         OzJeQsT14Dik0wprVvv26tG2+FYyMP/wryR4Dtd9RVvtd0O4aJgP7bxhv6LWTkRONZJH
         QaHg==
X-Gm-Message-State: AOAM531eg28tl22r/4G9vbEMVlX3YXZ3vMLq14UipgHV7Z6xcr+E84VL
        +W5ixqEYUdrFhMpXsTNRj0gOEwqL
X-Google-Smtp-Source: ABdhPJwWJVWxNZva2emC3nn1zbAW4baqoaeSlQxdRFPWNdy/WkNrousN7P/pNUEDeXko4rhHk1z88A==
X-Received: by 2002:a1c:63c2:: with SMTP id x185mr16281284wmb.68.1593425691193;
        Mon, 29 Jun 2020 03:14:51 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id a12sm37807233wrv.41.2020.06.29.03.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 03:14:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5/5] io_uring: fix use after free
Date:   Mon, 29 Jun 2020 13:13:03 +0300
Message-Id: <1221be71ac8977607748d381f90439af4781c1e5.1593424923.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593424923.git.asml.silence@gmail.com>
References: <cover.1593424923.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After __io_free_req() put a ctx ref, it should assumed that the ctx may
already be gone. However, it can be accessed to put back fallback req.
Free req first and then put a req.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 40996f25822e..013f31e35e78 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1526,12 +1526,15 @@ static void io_dismantle_req(struct io_kiocb *req)
 
 static void __io_free_req(struct io_kiocb *req)
 {
+	struct io_ring_ctx *ctx;
+
 	io_dismantle_req(req);
-	percpu_ref_put(&req->ctx->refs);
+	ctx = req->ctx;
 	if (likely(!io_is_fallback_req(req)))
 		kmem_cache_free(req_cachep, req);
 	else
-		clear_bit_unlock(0, (unsigned long *) &req->ctx->fallback_req);
+		clear_bit_unlock(0, (unsigned long *) &ctx->fallback_req);
+	percpu_ref_put(&ctx->refs);
 }
 
 static bool io_link_cancel_timeout(struct io_kiocb *req)
-- 
2.24.0

