Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFAF2FBA86
	for <lists+io-uring@lfdr.de>; Tue, 19 Jan 2021 15:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391344AbhASOzg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 09:55:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394422AbhASNhx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 08:37:53 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C870C0613ED
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:40 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id y187so16750335wmd.3
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=sUJZi99MjphBnXUx6N3uI4Z+aZ/NI8itmkbUzyTZPHg=;
        b=uKEijIPFRfGhlgqdKLuTfYEE8hs5XWDM73LNGeyfGNBH4u0OX9RZoEVwmD5n6mXIYw
         v6QDINE8pQmwWJsL+pkvs2Ch7zjpxh4wSO+iZZ7Uegy8F432pINovCDOjwCtcgf100TF
         bzpDNvo3tTVwXTZ8i94KQHe5fyKHEYquTfAWJ1926RjmvXm6UjQoVQLr+/SIFBXyF2vU
         dmsVz7uPHMKU0pL6T26Or25pOvAuyaJrrbISL+IyFeTwV0hZ29KwvJvv/pKXO58mAG14
         L2br/RXS+QJQsCDNYeDIvBoKMKmbae+og9fVk+h8UfKVH0wVccLA+D6BCjxWKWyAJgdl
         1dNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sUJZi99MjphBnXUx6N3uI4Z+aZ/NI8itmkbUzyTZPHg=;
        b=FiKqEHbTBU2HQg835C5WspPNxirj3mV+yXKbDqfUpOusdrcdzNL0apTJUFow9juSC1
         s4AYdRboDH9U+UXYnMwlU7fve+pWnno1u54YyInV0c+5U2+vtigsfdEH93rN6qr8UYgB
         TRBzovi02lGmCRhhf3IIJ32GpXuG9szBZhinfJFuQyQgwacX6bu9TxTU3zV05T7pm32K
         O6NABePihq+dA6cQDsyCw+9vEURNRh0cyGpy7NgI3eL6y+sjdeXwJVlhTGpieC9Ia0EP
         griOqsYEaKCFJntY+vLOiZN0Z7nG8Q/2I7FjuSLzDQj8ParZ6yc/wXIleF4nW4r2eSll
         QPjw==
X-Gm-Message-State: AOAM532RiCZ0hBsjJ1a4L/xxPZm0/1q8VHhtgoM5xI5g4ToahuX0OJho
        kqiEAL2M/qqlsX5/1edxXmA=
X-Google-Smtp-Source: ABdhPJznbrB7feWl8E731yxaCVkSkiCTYrSNvlioXb1uLH7zAcrnoXh+FoH3/7LxfJpUmfZb0rCbpQ==
X-Received: by 2002:a7b:ce17:: with SMTP id m23mr4136979wmc.178.1611063398879;
        Tue, 19 Jan 2021 05:36:38 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.152])
        by smtp.gmail.com with ESMTPSA id f68sm4988443wmf.6.2021.01.19.05.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 05:36:38 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 07/14] io_uring: simplify io_alloc_req()
Date:   Tue, 19 Jan 2021 13:32:40 +0000
Message-Id: <f1c14fb26ef6651872a168b3f74d9eedbc577d01.1611062505.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611062505.git.asml.silence@gmail.com>
References: <cover.1611062505.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Get rid of a label in io_alloc_req(), it's cleaner to do return
directly.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b05d0b94e334..d1ced93c1ea3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1963,7 +1963,7 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx,
 		if (unlikely(ret <= 0)) {
 			state->reqs[0] = kmem_cache_alloc(req_cachep, gfp);
 			if (!state->reqs[0])
-				goto fallback;
+				return io_get_fallback_req(ctx);
 			ret = 1;
 		}
 		state->free_reqs = ret;
@@ -1971,8 +1971,6 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx,
 
 	state->free_reqs--;
 	return state->reqs[state->free_reqs];
-fallback:
-	return io_get_fallback_req(ctx);
 }
 
 static inline void io_put_file(struct io_kiocb *req, struct file *file,
-- 
2.24.0

