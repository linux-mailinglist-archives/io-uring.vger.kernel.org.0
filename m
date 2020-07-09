Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A626A21A3F3
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 17:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgGIPoX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jul 2020 11:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgGIPoX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jul 2020 11:44:23 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968F0C08C5CE
        for <io-uring@vger.kernel.org>; Thu,  9 Jul 2020 08:44:23 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id t27so2399689ill.9
        for <io-uring@vger.kernel.org>; Thu, 09 Jul 2020 08:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=a1qVjyhj1hfitbMNfMrEqb//pKZ+imnKzj6wAyYQZ7A=;
        b=cqwaGR4hsolcV0d1i/uSl/ioypAHZMkDrw7fYtcoefiiuwA9mRuhIRGTowQ7wiyCES
         QdQ7vyqoEzSekVSSSjwYyUrTzA+MthjxHK5+aGWXqpNK9706XCNV0uVFzJVwegeZmaXK
         /splmYSmo/DEQGSg7htO0R7W7z2M2/k7URRBCTnCzNWJ8QniRpFOpYVjd75VlIcl1N/R
         bM2jIG1pMLT0++F6ZOj/fa4MKqunhE4z7RBKjt8TL3C5YnmN3Kdye6UvAhaduourq827
         Jvi7jisO4i0doiwiihZ2JrGR/St1a5qOLG3+r+ZihuzYG4r3FYosr5d4Oo4BerFhDyLu
         /anA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=a1qVjyhj1hfitbMNfMrEqb//pKZ+imnKzj6wAyYQZ7A=;
        b=ASEBhVtFeHaWSQyH3fjAFvORFwTDZbPHLFkX9tmkU00AhxPYK68qIOT2InOudf0AHW
         YOgwK8Wq6f74/jKbMzX2z3q1jA6h9StqFNMWG7BLvT99jq/ubFQfmVymnB2+gRUX38pk
         tWIaP8uxCrWQFkmQ8Sj/4oAUH/8x/H6/+pelVJtp7ZpClOPSFWpswX0TAp4vHE4+vvPO
         i5IRK8xHnr+Ud1sfU/9n0FN5zIFJkBtyqwRZNrL5UkOfp64/uR9On49HXqzAtpkYLYF7
         fyCEzEJ5U4iJyS4YcbpbchO+B01KV6BhPdfPoiC736OdVbPbFHADPtys2gTQReBVsZ1C
         BcsA==
X-Gm-Message-State: AOAM530OeTAS3xnm3BOFozayGLl1yP0w0ON7/8ZCjwdG1HgdjvkMiRLh
        KXQwxXKwBrEASGfv51Dz+sRUoldqi6tHug==
X-Google-Smtp-Source: ABdhPJxYwYDyokki8tGx/yPV3O/mpjbkkaOlnG9HSw8KWRq/Tcruc46vKrucGhkip/DxMiOelhmdtw==
X-Received: by 2002:a92:4983:: with SMTP id k3mr17012851ilg.275.1594309462774;
        Thu, 09 Jul 2020 08:44:22 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s12sm2178029ilk.58.2020.07.09.08.44.21
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 08:44:22 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: get rid of __req_need_defer()
Message-ID: <9e1a9b81-c0f4-aa69-ec3f-e7c11aaf027d@kernel.dk>
Date:   Thu, 9 Jul 2020 09:44:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We just have one caller of this, req_need_defer(), just inline the
code in there instead.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 51ff88330f9a..7f2a2cb5c056 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1069,18 +1069,14 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	return NULL;
 }
 
-static inline bool __req_need_defer(struct io_kiocb *req)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	return req->sequence != ctx->cached_cq_tail
-				+ atomic_read(&ctx->cached_cq_overflow);
-}
-
 static inline bool req_need_defer(struct io_kiocb *req)
 {
-	if (unlikely(req->flags & REQ_F_IO_DRAIN))
-		return __req_need_defer(req);
+	if (unlikely(req->flags & REQ_F_IO_DRAIN)) {
+		struct io_ring_ctx *ctx = req->ctx;
+
+		return req->sequence != ctx->cached_cq_tail
+					+ atomic_read(&ctx->cached_cq_overflow);
+	}
 
 	return false;
 }

-- 
Jens Axboe

