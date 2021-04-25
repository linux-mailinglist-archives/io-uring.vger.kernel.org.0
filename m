Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9062436A786
	for <lists+io-uring@lfdr.de>; Sun, 25 Apr 2021 15:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhDYNdT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Apr 2021 09:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbhDYNdT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Apr 2021 09:33:19 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3618BC061756
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 06:32:39 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id e5so24402898wrg.7
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 06:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=khza0+emDH/8SGke3kG+FG/pDGPnQ2DdXv9AOpxij7M=;
        b=QBpRG7IkEfrJsfmYECPwy/+2W56d5LKfIBBeBtmir48lWEQo9Wxg1OkwYU9vLMw/DA
         2KDtewG4/eL2rpd0TvXrBG4gM1zuu5JJl6e2hWKhW0BWqdQkNWvr5VjaMb4P8bfqHZYY
         /CE4g9H9aJzsfMzxkRow6PVI4hiUnLRjO3KYteR/D/k1/ko8E9dWTJN9FVcnx3xxMgxK
         u1CUcw99pw8mclfXGATKIDsj/Vc1ntfnD2m1NePR3TuFJzFRL2Z/A9i/B4iFE94flgdr
         ZpVn8PuJl9bSdqu3XHmrZHAVhJDxFflsxbgCCZCeBHDZKDfG85qS4hPum6VNPeMPGIv6
         Insw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=khza0+emDH/8SGke3kG+FG/pDGPnQ2DdXv9AOpxij7M=;
        b=TPPeZy9k6YYOVqTt7NeF/HF6YKz3nlG9G6dog//YaNOKzmcimKiTjjKJeBVAdV4Lx+
         ipu9UNhJvqybpvoE44FMnef1RkFCI3vCJ7W8a79S+99P5iv1Q8QrWhGWXRxndww9NrKg
         P86fXNLjUon8Hm/J061RCmCGKPgUhgZNIUVCgLfJT9MGjIKyDCqmubFeWKcjimQlT+eG
         t+0LAR6wmz+i1fFqklHumrQ6p+h8LrUdGh6zDLELEuLYqgvS4EcgEqMFyVyzsUCkdI7x
         9QkEn2kvIuwHGzBpXtUje25DPA/PfPcc0Z+jb8jBDW30W4xx25plaA3+ssYB0HXupeU2
         r/qg==
X-Gm-Message-State: AOAM530jejboCG362Z+ghLhrVQuhpWX5DT25DG5Gn+VzPRbrEoIizPjq
        NCu+a4+++4jTbVVK1FFcafbfi9afnhw=
X-Google-Smtp-Source: ABdhPJwyOOZJp4V7fT4xBICUoRM5GmARW6W1ReidUvQMLmj6wa3uVqWFXp5pyJvORzuIHwOEQNQ88A==
X-Received: by 2002:adf:dd50:: with SMTP id u16mr17379114wrm.380.1619357557977;
        Sun, 25 Apr 2021 06:32:37 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.108])
        by smtp.gmail.com with ESMTPSA id a2sm16551552wrt.82.2021.04.25.06.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 06:32:37 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 02/12] io_uring: return back rsrc data free helper
Date:   Sun, 25 Apr 2021 14:32:16 +0100
Message-Id: <562d1d53b5ff184f15b8949a63d76ef19c4ba9ec.1619356238.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619356238.git.asml.silence@gmail.com>
References: <cover.1619356238.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add io_rsrc_data_free() helper for destroying rsrc_data, easier for
search and the function will get more stuff to destroy shortly.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 70e331349213..a1f89340e844 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7109,6 +7109,11 @@ static int io_rsrc_ref_quiesce(struct io_rsrc_data *data, struct io_ring_ctx *ct
 	return ret;
 }
 
+static void io_rsrc_data_free(struct io_rsrc_data *data)
+{
+	kfree(data);
+}
+
 static struct io_rsrc_data *io_rsrc_data_alloc(struct io_ring_ctx *ctx,
 					       rsrc_put_fn *do_put)
 {
@@ -7147,7 +7152,7 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	}
 #endif
 	io_free_file_tables(&ctx->file_table, ctx->nr_user_files);
-	kfree(ctx->file_data);
+	io_rsrc_data_free(ctx->file_data);
 	ctx->file_data = NULL;
 	ctx->nr_user_files = 0;
 }
@@ -7624,7 +7629,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	io_free_file_tables(&ctx->file_table, nr_args);
 	ctx->nr_user_files = 0;
 out_free:
-	kfree(ctx->file_data);
+	io_rsrc_data_free(ctx->file_data);
 	ctx->file_data = NULL;
 	return ret;
 }
-- 
2.31.1

