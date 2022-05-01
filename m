Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2225167ED
	for <lists+io-uring@lfdr.de>; Sun,  1 May 2022 22:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354896AbiEAVAg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 May 2022 17:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354856AbiEAVAe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 May 2022 17:00:34 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4289E26111
        for <io-uring@vger.kernel.org>; Sun,  1 May 2022 13:57:08 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 77so816212pgb.13
        for <io-uring@vger.kernel.org>; Sun, 01 May 2022 13:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eaJGzAFZXHCiQicKKVtnivj4K5L/i7O1QjTPs/xkhfQ=;
        b=YXn5f53YzSRaGExtCczpndNo7GDbji5W3IrbjYP0wqVvp/Ommozl31K+vE859bKdST
         rzYDU32RHwOdtIJ4BVXw097GiXtwfPyyhaqxoHgr+ECq5uUQlH4tfpOyxTdSNA7XzNls
         V0Auq0HEHSBm+qi9lDOVWOunqP/kZ57XPROjvMaMduLupiXHDj4XmmEssukKixJZfbeC
         mBJ6BMUyt5vdKb7jiyjrPR1i3OkDAbTA8g4uJUPFapWp9DyWJQx+GpRBpv1hM8b4hcVN
         CGTu4gO5EhFQ6QwNxoKB5H8fNeqk2rt+FDkVDwCm4E7vgrOfsxleVu6F2bpJFaQR8Hj8
         8d0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eaJGzAFZXHCiQicKKVtnivj4K5L/i7O1QjTPs/xkhfQ=;
        b=le9gcyYE73/fxVgAt5vXnUUZe208H145GYQCm/hGYhhvGZj5PsDpYaTQwancw4O8Jv
         iPrLXCkGrsqgf4UOnUhHFAnXAr0lVPswiW53+kae7L3/Xp6/hIyFZc3+aPKmZXX/JIIP
         bF73DiodndvGo27FPNUTMzFm9kPepH9UwR31Q4tsz8bjkUMQYPJtG9p+Q6BBwpRq1uZ/
         S3lVZcrmH4/ebUag9NKOBA5M/a3upfrNcMIWpWqjMXRi2KjD6Y/Yxmkd6WUAlE9k41Ap
         nljSWtk4kQl/5iTS4+yLuHbB5IlPIK7ItjJbce95M1gsqnxuyLqK4Fr8DeYFMjE27XSe
         v/dw==
X-Gm-Message-State: AOAM5307JGzWUizbKLm5GdS4TbrxzP5WPZM/+Bq4ry5OZGdbkbTcY7Rv
        nUU56tYv8BgZvQmNwBI9egzmtfrL93+Z1w==
X-Google-Smtp-Source: ABdhPJxws/ii4KHI+WRkrgTJo1+1knMhdB7KrzjGfZjW/mQcL9EDi1nbUGZ/AdNn1SQ7HENAiad8CQ==
X-Received: by 2002:a65:4006:0:b0:3aa:1cb6:e2f8 with SMTP id f6-20020a654006000000b003aa1cb6e2f8mr7247213pgp.274.1651438627518;
        Sun, 01 May 2022 13:57:07 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id l8-20020a17090270c800b0015e8d4eb1e9sm1894013plt.51.2022.05.01.13.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 13:57:07 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 11/16] io_uring: move provided buffer state closer to submit state
Date:   Sun,  1 May 2022 14:56:48 -0600
Message-Id: <20220501205653.15775-12-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220501205653.15775-1-axboe@kernel.dk>
References: <20220501205653.15775-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The timeout and other items that follow are less hot, so let's move the
provided buffer state above that.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 84b867cff785..23de92f5934f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -410,12 +410,14 @@ struct io_ring_ctx {
 		struct io_mapped_ubuf	**user_bufs;
 
 		struct io_submit_state	submit_state;
-		struct list_head	timeout_list;
-		struct list_head	ltimeout_list;
-		struct list_head	cq_overflow_list;
+
 		struct io_buffer_list	*io_bl;
 		struct xarray		io_bl_xa;
 		struct list_head	io_buffers_cache;
+
+		struct list_head	timeout_list;
+		struct list_head	ltimeout_list;
+		struct list_head	cq_overflow_list;
 		struct list_head	apoll_cache;
 		struct xarray		personalities;
 		u32			pers_next;
-- 
2.35.1

