Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4526DD916
	for <lists+io-uring@lfdr.de>; Tue, 11 Apr 2023 13:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjDKLNL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Apr 2023 07:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjDKLNB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Apr 2023 07:13:01 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 588E644B8
        for <io-uring@vger.kernel.org>; Tue, 11 Apr 2023 04:12:49 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id jg21so19002222ejc.2
        for <io-uring@vger.kernel.org>; Tue, 11 Apr 2023 04:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681211567;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gejjt1nqo8/4I5cAJJVj1DToUQqE66kHLtUoIqIHgAE=;
        b=UTJn4il5mJD6WuNXor0U/3PDhjoTWwYzPeKMf7oIH1p47kFxCbIRUVKsXsDRSAYOub
         pQwjfng8SkzKwq6dbkkj2fR9zJDnj+PH/GoUvZE+cW/T/swdX2RXpWAKfKv5QwfVQ909
         KSXmiWpC3JNJcud4IBcUjKLiXaTXZKAJ8wLrDj+B1pwbYxTgI275CoguxIfvLzO/diIu
         3oAPotixw891I6NTIScR1GzUu0jQ9tRs92jH7KKRogGQjQWghtpGjbxhsnK2K8LqkAE8
         VFq9GEkmqj5cZuf4/ET9aGbhRssT+uFEoSw/vzeBZlEfeRdUZ7Od05RWY0YkJBqKD6g8
         derg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681211567;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gejjt1nqo8/4I5cAJJVj1DToUQqE66kHLtUoIqIHgAE=;
        b=fHGxtKvVx4mm/rqpHsOh1xhqSFou98PoG+LOdRvweC5CfkatrCI6OuRawQ+A1WC5jF
         ND6EAy6pj0vpABj8DA1Ct1R2Et3CgOC7itBnoT9LiGCyo/L5dnnS8CREr0LkQyQtAptE
         k9RDVFVemxOM1Ql1/dgrp5cZMKxb2ScDuB8Op74EiqGnWtcmUqEmXq+TV90ZfKPQpOS0
         OP6oEYREq3cgPJOLBm6w5Hz0wBuaQ36otRHE7nLVEZuNUNvJaLe8qhfv0yovFIpNqXh2
         w0kj2xmxMaSff5DAb1ih2/bhSPbes/TOW/Lv1PHQEK7KpUqKi3LXdHeA2AForZKXWOC8
         lIFQ==
X-Gm-Message-State: AAQBX9e6hUKikUkAd+LvctfrN239ZNjt/b8qBH+9pDA4PoLZUAanw+Ai
        WvRYSyXz2XwrjnkgJRXFetYdn6kSzBo=
X-Google-Smtp-Source: AKy350Zoa42IZ7/ivlb3mbHKAZaB4VacMsw0Rh9aY2LbS7sL+xPQHMEiaCpodbVWhH4PPuGV5/ypRg==
X-Received: by 2002:a17:907:376:b0:94b:958c:8827 with SMTP id rs22-20020a170907037600b0094b958c8827mr4456657ejb.56.1681211567438;
        Tue, 11 Apr 2023 04:12:47 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:ddc3])
        by smtp.gmail.com with ESMTPSA id ww7-20020a170907084700b00947a40ded80sm6006787ejb.104.2023.04.11.04.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 04:12:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/8] io_uring: shut io_prep_async_work warning
Date:   Tue, 11 Apr 2023 12:06:01 +0100
Message-Id: <a6cfbe92c74b789c0b4f046f7f98d19b1ca2e5b7.1681210788.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681210788.git.asml.silence@gmail.com>
References: <cover.1681210788.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring/io_uring.c:432 io_prep_async_work() error: we previously
assumed 'req->file' could be null (see line 425).

Even though it's a false positive as there will not be REQ_F_ISREG set
without a file, let's add a simple check to make the kernel test robot
happy. We don't care about performance here, but assumingly it'll be
optimised out by the compiler.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9bbf58297a0e..b171c26d331d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -425,7 +425,7 @@ static void io_prep_async_work(struct io_kiocb *req)
 	if (req->file && !io_req_ffs_set(req))
 		req->flags |= io_file_get_flags(req->file) << REQ_F_SUPPORT_NOWAIT_BIT;
 
-	if (req->flags & REQ_F_ISREG) {
+	if (req->file && (req->flags & REQ_F_ISREG)) {
 		bool should_hash = def->hash_reg_file;
 
 		/* don't serialize this request if the fs doesn't need it */
-- 
2.40.0

