Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A522C5A2BEF
	for <lists+io-uring@lfdr.de>; Fri, 26 Aug 2022 18:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbiHZQFa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Aug 2022 12:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344005AbiHZQF2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Aug 2022 12:05:28 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFBC6D9D8
        for <io-uring@vger.kernel.org>; Fri, 26 Aug 2022 09:05:24 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id fy31so3588419ejc.6
        for <io-uring@vger.kernel.org>; Fri, 26 Aug 2022 09:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=sPrbgBALcZC4eiQZheA5oE729kyR7I7z9balqV63ge4=;
        b=QjgJH3UGaHHz5FImipyKdqwsGBGtBS6qzy3oqDeNZYsrUU1VIHi9zQkMT46AMlPigw
         RKPwsIwqaXSu+WMvcZX8ZxY9CDlo1g//mKJDD3Bk6afC2QZpRe1tmz3ut8sV+Eu98PfV
         xofC9IXawOrY8rhiyL6QU0MmFePkaHKfH5GAxmdkovIjjuh+wGENbQHrgCVHtnjiIdX9
         JZlXhaF5WXgOZJ6Hxqm2fQvnThyPZ+VsrYEtEmaeQ91sXCnx7EsrGlIjbSkvATNUCbeI
         jvFy5GbGrzVZCbTwXGy0b/0Uc2ETbu/gNwJ+yI+zIaJdKXCR2g/HE9giFbI6rLMEB+E+
         pBLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=sPrbgBALcZC4eiQZheA5oE729kyR7I7z9balqV63ge4=;
        b=G9DyfnrntMzCJbfO676mRZWkpyQkTFvCJ2tvBjN3qLwyLPD3TrXDjkfN3+COu+GEPM
         giACkRqC+yO/Lok9/oTX3qc+AsXzzI0PM7/xEqaKllUpc9Ihx6GJhEnHieHS1TT5NA3V
         r1z8J2bh2fjFXfR/tOj1NYzMLE0aSo0ZzoCOSa7HFn0jtmUSh5HoPZwwIOhLCtYucwSm
         +avTB9gFXFQQQLnQf64L+Z5x96NGUrCCXLj/DYIwWyOxJAZmYapz6o3/dTWfmsjxdFYo
         qW4i0xdNGogA6tWMfPu6qKuPFO47xsbSUHQgp8blv4H7xp33TXBXhKA18GMP6YOL48DP
         RsEQ==
X-Gm-Message-State: ACgBeo13IHglfXBEu1dl/R9eYzVEOM2mI6YFOop7RWZ7kX5WskN7hsUp
        zsf9lewU2e8lIStuST5rVph05bjVVtQ=
X-Google-Smtp-Source: AA6agR6SVGL+UhncJZ5BVqJnGSW68wAlIe7V1c6aKZhly/o/lTubyrXC2hLMVzJABPD+j0rht+yx8Q==
X-Received: by 2002:a17:907:72d5:b0:73d:d6ce:5d3a with SMTP id du21-20020a17090772d500b0073dd6ce5d3amr4758200ejc.489.1661529922372;
        Fri, 26 Aug 2022 09:05:22 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id s6-20020a056402036600b00448139a26d0sm68518edw.0.2022.08.26.09.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 09:05:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-5.20] io_uring/net: fix overexcessive retries
Date:   Fri, 26 Aug 2022 17:04:12 +0100
Message-Id: <7ae9790cdf2f30cd381efda5b159ef95c88cf8eb.1661529830.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
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

Lenght parameter of io_sg_from_iter() can be smaller than the iterator's
size, as it's with TCP, so when we set from->count at the end of the
function we truncate the iterator forcing TCP to return preliminary with
a short send. It affects zerocopy sends with large payload sizes and
leads to retries and possible request failures.

Fixes: 3ff1a0d395c00 ("io_uring: enable managed frags with register buffers")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 0af8a02df580..629a02a148d4 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -956,7 +956,7 @@ static int io_sg_from_iter(struct sock *sk, struct sk_buff *skb,
 	shinfo->nr_frags = frag;
 	from->bvec += bi.bi_idx;
 	from->nr_segs -= bi.bi_idx;
-	from->count = bi.bi_size;
+	from->count -= bi.bi_size;
 	from->iov_offset = bi.bi_bvec_done;
 
 	skb->data_len += copied;
-- 
2.37.2

