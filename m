Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6521D1E81
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2020 21:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389946AbgEMTER (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 May 2020 15:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390277AbgEMTEQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 May 2020 15:04:16 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C778CC061A0C
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 12:04:16 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id f23so164833pgj.4
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 12:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=bs7S/ft1jErTfx16PZZ7k/OOgMRB8Xmv24TkNNOJIVI=;
        b=XjDiLlzEnqiiEkM72JYdeORyoKHGsDW66jK5fXmf47KsAhtg8K2TGdwTnyEERO+fOR
         NpkgKScA6EEGd1BQdlxfwoywo8DJfJhK+NFaJAfURke3AUwHL4LDXM1/A5rszmuCvZlw
         RQmAZw95OTiicyG2BAgG4y+nfHoZbgsOPBPaGg0wJohr4dKJqO6UgxLHuvcm11g0GTDd
         vey6lgGDzyrbjgqYGYopR71EMrIOuLYx9+nU+PWRnlXIU4/XES29CinwMRsWYOlKZlcO
         34ZHtYNZJlUohlzYMq3Mx8k97F/pvsi3cUO+rQfwn8UGAEB/Wx4Kriqk0x3ZEbnB4wPS
         iB3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=bs7S/ft1jErTfx16PZZ7k/OOgMRB8Xmv24TkNNOJIVI=;
        b=AQfRKa6orgNb3z+ORPadfdHS6TR/CsSbF6gImPvXHNmV2TSSSPa63VRbl3TewenKWJ
         npNEde1+XmS3e+HhTJS/I9ei0v0Bs9n/U5HE6dJmKu0QHvtkhzjBdpo0rvfqjLZkPquK
         5dyCgT1S5QkOjow33SsyOf0STV8UIGr3o/0fZEu+HpwvVudv0wnEBGVXlI0RjIAjAL5t
         Thyiy3rpuRb27O6nqi6Dmd7prIA1F4b5nf9XTqa7PIcoQwissRH1Rnf+HfpkG8ltrLSh
         KlBBLuKPhGLCNxUlawOxPPWls77vNhL7ociKXF2n8X7Hk/ZhABRaGFUha1hGsBNM0y3t
         IWEg==
X-Gm-Message-State: AOAM532VyraunlxvaUT7tCXyQMVnogcgb2dud/BBOqxfFjk/DEqpRXHm
        UbTEl5TS0YcVwvE8DRYltYWDwISLbbk=
X-Google-Smtp-Source: ABdhPJyW5Ivy84vF2vS3rYCutUWQBj5KoN3i5zOQ/9nQAmIHRsLJjzBB3UfjUfGtpa/8ySa3NR7J8Q==
X-Received: by 2002:a63:7d3:: with SMTP id 202mr662889pgh.279.1589396656243;
        Wed, 13 May 2020 12:04:16 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:4833:bff6:8281:ef26? ([2605:e000:100e:8c61:4833:bff6:8281:ef26])
        by smtp.gmail.com with ESMTPSA id 131sm372425pgf.49.2020.05.13.12.04.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 12:04:15 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: polled fixed file must go through free iteration
Message-ID: <015659db-626c-5a78-6746-081a45175f45@kernel.dk>
Date:   Wed, 13 May 2020 13:04:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When we changed the file registration handling, it became important to
iterate the bulk request freeing list for fixed files as well, or we
miss dropping the fixed file reference. If not, we're leaking references,
and we'll get a kworker stuck waiting for file references to disappear.

This also means we can remove the special casing of fixed vs non-fixed
files, we need to iterate for both and we can just rely on
__io_req_aux_free() doing io_put_file() instead of doing it manually.

Fixes: 055895537302 ("io_uring: refactor file register/unregister/update handling")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4c2fe06ae20b..70ae7e840c85 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1394,10 +1394,6 @@ static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
 		for (i = 0; i < rb->to_free; i++) {
 			struct io_kiocb *req = rb->reqs[i];
 
-			if (req->flags & REQ_F_FIXED_FILE) {
-				req->file = NULL;
-				percpu_ref_put(req->fixed_file_refs);
-			}
 			if (req->flags & REQ_F_INFLIGHT)
 				inflight++;
 			__io_req_aux_free(req);
@@ -1670,7 +1666,7 @@ static inline bool io_req_multi_free(struct req_batch *rb, struct io_kiocb *req)
 	if ((req->flags & REQ_F_LINK_HEAD) || io_is_fallback_req(req))
 		return false;
 
-	if (!(req->flags & REQ_F_FIXED_FILE) || req->io)
+	if (req->file || req->io)
 		rb->need_iter++;
 
 	rb->reqs[rb->to_free++] = req;
-- 
2.26.2

-- 
Jens Axboe

