Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4EC86DD917
	for <lists+io-uring@lfdr.de>; Tue, 11 Apr 2023 13:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjDKLNM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Apr 2023 07:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjDKLNC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Apr 2023 07:13:02 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D034690
        for <io-uring@vger.kernel.org>; Tue, 11 Apr 2023 04:12:50 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id qb20so18904693ejc.6
        for <io-uring@vger.kernel.org>; Tue, 11 Apr 2023 04:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681211568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WXJHUznMJRl0elsxMAshdE0Ny+bVYXLkGUH4jQ9Xv5U=;
        b=Hu/eadbwd8PP23pDn6D1rR8KV4b88J7oMCe1zQuo8GhqAdxrRBSr+7oGP0eRXPFz2T
         Zcv/lB9ERDZvxiyKtqlDdlltN5n2CQSh7f9YhJT+ZJqf2m+h8o4RVANU8xVd8EiN5n8M
         cp/kIckjIuXLzCAwhPvN4Gb0n2hLy0OgFbMHTMvogv9wsphUZP9UVseaamHAqe+dnzBy
         HzIxcSHr0718f8GYshgyfVeysh6RCvC92HDXmOrzzWo6UHq9Dd7jUwixlYsmBdzDXMJ0
         CCj/fOeSKqI3nS2HqGqmwonCIknvjnHXqPV/fkG2Ru609HdaAFeDRLJHZZdBbUsrn5rn
         nvkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681211568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WXJHUznMJRl0elsxMAshdE0Ny+bVYXLkGUH4jQ9Xv5U=;
        b=myw/t6rgB2bG75/GElvuLI3uwYnyQ7obVRNC8Cu9TcXUQJ3SJ7jIAbz9fjIBj4M27F
         LbwMz3EhyaXDxrwohw0ifhmE63NmKQV+w/mXQvBIGso3mfu/nM7/I3qUgbWhGRAPYYOo
         R4FStTcmMMri4uEVQKDZAjzmRqdPpbH8DxL16F5FCIDuiaqFTYULIUSL4HwJDYbmfP9c
         XpysjuaoKJsCAibbk4t2G11aES3n4W3EyHOD2tC5LJszLP9m5Zdw+izJ2ScizMeC7cbA
         eKvC5/Y68yTC9q0AuZr7V0rPqbf1Ub4bIB28AVCNPRoLQur4eyMjzzP9huuCeVRI8WM8
         xCTA==
X-Gm-Message-State: AAQBX9fChVfsFxblMyS7g0deVojad0mUKunTFQk8tLg5oxr8xZUwn378
        b9RvwKUWulANN+O2KOAw9lmPwMnfJrI=
X-Google-Smtp-Source: AKy350Zpj2tayHwdGr48hY0tDhV3uFYECLIsqGt3RDp4qoXHZrBsSDRXmbOa00hVCrSypfI9GCVVrQ==
X-Received: by 2002:a17:906:76c8:b0:93b:5f2:36c with SMTP id q8-20020a17090676c800b0093b05f2036cmr9226298ejn.61.1681211568240;
        Tue, 11 Apr 2023 04:12:48 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:ddc3])
        by smtp.gmail.com with ESMTPSA id ww7-20020a170907084700b00947a40ded80sm6006787ejb.104.2023.04.11.04.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 04:12:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/8] io_uring/kbuf: remove extra ->buf_ring null check
Date:   Tue, 11 Apr 2023 12:06:02 +0100
Message-Id: <9a632bbf749d9d911e605255652ce08d18e7d2c6.1681210788.git.asml.silence@gmail.com>
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

The kernel test robot complains about __io_remove_buffers().

io_uring/kbuf.c:221 __io_remove_buffers() warn: variable dereferenced
before check 'bl->buf_ring' (see line 219)

That check is not needed as ->buf_ring will always be set, so we can
remove it and so silence the warning.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/kbuf.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 79c25459e8de..0905c1761fba 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -218,14 +218,12 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 	if (bl->is_mapped) {
 		i = bl->buf_ring->tail - bl->head;
 		if (bl->is_mmap) {
-			if (bl->buf_ring) {
-				struct page *page;
-
-				page = virt_to_head_page(bl->buf_ring);
-				if (put_page_testzero(page))
-					free_compound_page(page);
-				bl->buf_ring = NULL;
-			}
+			struct page *page;
+
+			page = virt_to_head_page(bl->buf_ring);
+			if (put_page_testzero(page))
+				free_compound_page(page);
+			bl->buf_ring = NULL;
 			bl->is_mmap = 0;
 		} else if (bl->buf_nr_pages) {
 			int j;
-- 
2.40.0

