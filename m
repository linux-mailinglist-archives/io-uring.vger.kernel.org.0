Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46BA66032C5
	for <lists+io-uring@lfdr.de>; Tue, 18 Oct 2022 20:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiJRSs6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Oct 2022 14:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiJRSs4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Oct 2022 14:48:56 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED24DA2A8E;
        Tue, 18 Oct 2022 11:48:45 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id u21so21847613edi.9;
        Tue, 18 Oct 2022 11:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lFeaHcw3WNcJNFaRay0No0wm3D4s1Mkz5fJGwkqsY20=;
        b=gJClO7ErBlCfzKPWJy/tFBQfQ+rctfzUBl11vrUnH9Tlr8O8uu0mIEqiByfJHvpTv0
         dgJpBSC8TeNV/KvUIkibb7wKldRyBTdC4LwAbxVitkVdrNAum8saXf5SC8Bh8T/ftmGH
         jULwwtjrC6JIKLC0qu7Nu+Zr7l2ZslMOxX8olHV9ag9HRYNKRTwbBfsAJohPVl1d7+7t
         gogXXmQu52TXETJAsIj1dTYakj25eas+y0+Xd7469/26WacHW26Ze9IVD0HhKFvatQ04
         9pmatdw2sd+f3jYjF5ObCtj9PbWa8t6QYXcUy5L+kqwQvAlXsBv4OxD9pqwZW2dStCej
         w+cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lFeaHcw3WNcJNFaRay0No0wm3D4s1Mkz5fJGwkqsY20=;
        b=zTVb9/G9/5g8ryDQkcqET9ETsXGmmCwE5+k0LB7qG4akj1/sWwmR9+VNXyFrvZ/Jcr
         neUyuybGXdgiPe8ws6gXSX95tx7I26vXws2K0sUdOdvIJBDLMrcrwGj+zSj3ChJ1VF70
         ly34B2RQLn5CIytWa2u21+Uc8qGWPBAbhUkf8BXdeYGBzY4aNKvkgPeoUWLaa1CCcpbk
         3WS2XQExB9kpKTeulGGv45zwAwyrbAiBD7Ha1F0mIoaCSXq71LVVSD2USe7LMLj4xVcX
         zz6LJsL5g2K72o/JONX62myoqQSBVpUp9ajBII1OvxbrKgw2HR0yPUzVLP9LAgN3UZQL
         ejkw==
X-Gm-Message-State: ACrzQf3CsQ9rebTp9pKmMSRYEkZY2mbk33yu6tyw7rkVKBZjLf65ciEt
        BYcLt7eizj6L012U+Pfmwg8=
X-Google-Smtp-Source: AMsMyM6JVKjrpUvR48PVYI1Cp/s2Dq8HVr7aM9kYFcHTtSYpQDnkl8cfZLhYvBvOs7fV6B2h3y1kdQ==
X-Received: by 2002:a05:6402:5489:b0:43b:b935:db37 with SMTP id fg9-20020a056402548900b0043bb935db37mr4018153edb.347.1666118923767;
        Tue, 18 Oct 2022 11:48:43 -0700 (PDT)
Received: from 127.0.0.1localhost (94.197.72.2.threembb.co.uk. [94.197.72.2])
        by smtp.gmail.com with ESMTPSA id j18-20020a17090623f200b0078db18d7972sm7855355ejg.117.2022.10.18.11.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 11:48:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC for-next 1/4] bio: safeguard REQ_ALLOC_CACHE bio put
Date:   Tue, 18 Oct 2022 19:47:13 +0100
Message-Id: <558d78313476c4e9c233902efa0092644c3d420a.1666114003.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1666114003.git.asml.silence@gmail.com>
References: <cover.1666114003.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

bio_put() with REQ_ALLOC_CACHE assumes that it's executed not from
an irq context. Let's add a warning if the invariant is not respected,
especially since there is a couple of places removing REQ_POLLED by hand
without also clearing REQ_ALLOC_CACHE.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index 7cb7d2ff139b..5b4594daa259 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -741,7 +741,7 @@ void bio_put(struct bio *bio)
 			return;
 	}
 
-	if (bio->bi_opf & REQ_ALLOC_CACHE) {
+	if ((bio->bi_opf & REQ_ALLOC_CACHE) && !WARN_ON_ONCE(in_interrupt())) {
 		struct bio_alloc_cache *cache;
 
 		bio_uninit(bio);
-- 
2.38.0

