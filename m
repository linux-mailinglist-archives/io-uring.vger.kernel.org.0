Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C13A2553ED2
	for <lists+io-uring@lfdr.de>; Wed, 22 Jun 2022 01:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353965AbiFUXBQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jun 2022 19:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiFUXBP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jun 2022 19:01:15 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C942E6B8
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 16:01:13 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id w17so20891800wrg.7
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 16:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nn2a2KKHnEW+tenzPHxmOsTwnVub8z9r9JtzehG3s78=;
        b=LmEWgMlgzvM5CoW3RtNLGBNeDDtQdWQdoKE2VE4MWv5AJtAJj3k/NQ1OM38l5a2u+f
         b8PYQDPssWrZjV86OtGG59nOeQ5H1hRE2JevwpUX4auIIGgMDrGc1No289YeHtnTboO+
         ycIrlMwNKAxBMQasNFB8xO7+FBq+bPjW+opyTILAmaNcVbU0e9ohTbKZGljzHRBul5fJ
         yWTw9Rpr6etv6Zac0dQJ2EVQpb3K4cll3/XzuFh5Pplg+dg8f1DJ1dmeFGHQGKP5bLZP
         arsVgMy+Ku2JL8iXYJfqkDTJQMIbGN1zzOzjsnQUnXug6jEFpQmmV6psR1oHhByInw6u
         DlbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nn2a2KKHnEW+tenzPHxmOsTwnVub8z9r9JtzehG3s78=;
        b=kuhF7Q0YnY5jYkqZTPOcnuLSbO/WPdZ6sJaJvxUdIeozKatLHNtqZ/NPDK0YoHF69T
         AaHJ1+QuWw4jdCPb0/3f042d9mPyKoAobGmxQYXuM+ceOPKhvnudqjF0q/eMLwaUp19V
         dl+HIjYLdbrmHD7n/cVggxmdnX430tcjuZazjK3ohPUcRtd5beTmeL3BfbswWMTSHFf4
         5RukEW31EXo3evZ5TiOyiQbZ/ZBZq9ebmzyYkbdwawJrUqK1gdhiDnhbS7ta0QX0um9X
         n9a/OydHbjsqCxjh7EosCs84+N2m7ZikzU2t/756TMnNu0Z0sZbV1z6I9LAXk+JsgEV0
         99+g==
X-Gm-Message-State: AJIora9XsjWa5FFzM9piQzGBvq3l/x+Q5vtrhgtw+C9RARJVIrMHPQyU
        wQimpMEeIA1wy2Moz7HFNK2w7+J/Xmq+askQ
X-Google-Smtp-Source: AGRyM1sYEHLf9fkLYZFWZCYQXyfSlQW6y8gudqQ06j9IBtoE5sLScSE1cVZfr6IMkYnajclOuwz3Mw==
X-Received: by 2002:a5d:5234:0:b0:21b:829c:3058 with SMTP id i20-20020a5d5234000000b0021b829c3058mr286200wra.13.1655852471632;
        Tue, 21 Jun 2022 16:01:11 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id q2-20020a05600000c200b0021b8ea5c7bdsm7630462wrx.42.2022.06.21.16.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 16:01:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5.19 3/3] io_uring: fix double poll leak on repolling
Date:   Wed, 22 Jun 2022 00:00:37 +0100
Message-Id: <fee2452494222ecc7f1f88c8fb659baef971414a.1655852245.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655852245.git.asml.silence@gmail.com>
References: <cover.1655852245.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have re-polling for partial IO, so a request can be polled twice. If
it used two poll entries the first time then on the second
io_arm_poll_handler() it will find the old apoll entry and NULL
kmalloc()'ed second entry, i.e. apoll->double_poll, so leaking it.

Fixes: 10c873334feba ("io_uring: allow re-poll if we made progress")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cb719a53b8bd..5c95755619e2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7208,6 +7208,7 @@ static int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 		mask |= EPOLLEXCLUSIVE;
 	if (req->flags & REQ_F_POLLED) {
 		apoll = req->apoll;
+		kfree(apoll->double_poll);
 	} else if (!(issue_flags & IO_URING_F_UNLOCKED) &&
 		   !list_empty(&ctx->apoll_cache)) {
 		apoll = list_first_entry(&ctx->apoll_cache, struct async_poll,
-- 
2.36.1

