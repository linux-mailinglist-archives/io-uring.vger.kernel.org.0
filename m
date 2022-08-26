Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB445A2C1B
	for <lists+io-uring@lfdr.de>; Fri, 26 Aug 2022 18:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344271AbiHZQQ4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Aug 2022 12:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343642AbiHZQQw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Aug 2022 12:16:52 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB5DD91F6
        for <io-uring@vger.kernel.org>; Fri, 26 Aug 2022 09:16:49 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id gb36so4040345ejc.10
        for <io-uring@vger.kernel.org>; Fri, 26 Aug 2022 09:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=JNnUu8ABSVU1n2oKVBq8Yv/DQ1rdwKMHWnqS6x2DKh8=;
        b=k5tVc+/MGTWFZbFZ1RALigng8pbxMu12eaQ16cd6YPyv2hsorXKwkZCxI3PrkbPPdn
         6DK0Now5od4EPJDbPTRjjmWqD1ba52TS4iBNGAwSQRoQJi3/W6BsV3g3SP1CvxtjwgtR
         gkzCl1S4hdgl1/PmWp7z9vGUl49pAvJVy55WSzX9hmQrlB83IOecxSWRCGCsX1Ercq+P
         dF+rh+KwZ8L/RmbERue2zLu34IqZUltiXht6tCisXXj7vOmsZRm8L8jlY7WXvFKyVPcj
         OTK5ss9gkg8XfHDEOarNYaDSAJ4dQA5ttXAw/S8nY20mxCX08Ld927oObR+LqPrq24K7
         q6OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=JNnUu8ABSVU1n2oKVBq8Yv/DQ1rdwKMHWnqS6x2DKh8=;
        b=Gw2JtHJyWfcChCoKgUa2ZL8rogdfIZf7AqOdLObluIdeFcKZUc02XGfx5rIXf5OQfp
         UhGfXv+9r7lfn+68hOfDzJDcpT3HDJOO5H757SfakIZhXUkMnvFv9cbpZZTyKVEXp4tO
         dbftFUh+n3cPECyIwyKNzdIbahaqW0V5w4HYCLpNXofhaDPTZVYjufOmF3lFuB8vvZnn
         UPQL+x3HK8V5oYqdKl+H2OGhCWk1rg6yreqaGebqe5bwxj8bmL5+v8Ypqyte4mFZpTzF
         pHHu5jFCJLw1YkXjpw97P/jISQCQNSrL+2N5oQzZNQkwjcAeGwR2wrKKu+LUlKKf5wAB
         X2RQ==
X-Gm-Message-State: ACgBeo0hPhqZhXiqpnMiy4qJaiHVU6yhejlnjnI65D+nwUrmOA7xyI3W
        hasJUlLH5Zp2IX2767f0x89NvEu7PX0=
X-Google-Smtp-Source: AA6agR7JqVDlE18Ibjbri137eoEvZYUXSK70t3g7UXEDfxhQ88GbEc2s90mxMVE81qT3tXenIz0nUQ==
X-Received: by 2002:a17:907:2856:b0:73d:dd82:4ef0 with SMTP id el22-20020a170907285600b0073ddd824ef0mr3674505ejc.571.1661530608168;
        Fri, 26 Aug 2022 09:16:48 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id c10-20020aa7c98a000000b00447dc591874sm1516419edt.37.2022.08.26.09.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 09:16:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RESEND for-5.20] io_uring/net: fix overexcessive retries
Date:   Fri, 26 Aug 2022 17:15:47 +0100
Message-Id: <0bc0d5179c665b4ef5c328377c84c7a1f298467e.1661530037.git.asml.silence@gmail.com>
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

Length parameter of io_sg_from_iter() can be smaller than the iterator's
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
index 0af8a02df580..7a5468cc905e 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -956,7 +956,7 @@ static int io_sg_from_iter(struct sock *sk, struct sk_buff *skb,
 	shinfo->nr_frags = frag;
 	from->bvec += bi.bi_idx;
 	from->nr_segs -= bi.bi_idx;
-	from->count = bi.bi_size;
+	from->count -= copied;
 	from->iov_offset = bi.bi_bvec_done;
 
 	skb->data_len += copied;
-- 
2.37.2

