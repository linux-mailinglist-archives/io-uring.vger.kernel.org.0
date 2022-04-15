Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D30E25030CA
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 01:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235014AbiDOVLn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 17:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344108AbiDOVLm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 17:11:42 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062C28BE12
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:13 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id k23so17136927ejd.3
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9qPI8Z6J5wThUH1MAIGvFkko5TEJKODd9DQFGoMGYZM=;
        b=iqm8jBCmt0aGynl9/ZAfRsvpeAWKihpH9e9/WjanuRRoss9XJfCnuVcofo0zzBUVNC
         vjW3wddNa3BpSLaUEin8hRkAT04+9OWz6QaIAMGuK4ioOWwXkwSeQJREgACaYOtS/EZh
         9jbLmJ74UjpTDI8p/sisLQFoqe5HtL4meU3Ij5Snm3HWiS8uvq+hZrQ1SOOG3GsMaXtq
         xsXOvDqE6rx/donh+XiUNWXCdgSAfdrjmYbBHMztwmzr2UDoYJM6trtS3OgXXq550ZAF
         vzVRDyiEpni/4+aP+jVU1mnZ60bI3jCrD1k55atfV8Ryq02f2V+Nr7IMXZnXlcPe9BzS
         Y9cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9qPI8Z6J5wThUH1MAIGvFkko5TEJKODd9DQFGoMGYZM=;
        b=cUr5Ppvn5PdvR9oxFXyjF/yyfE55o8YSPLsT8BD8EGOVnw/AAeSVcdBwjvmIMcpRAG
         i3whP7TWO4OwvcV3SmeRn1mJ4+VC3sapbm253pHjcaNKjFr108HGPBLxcjNSv4KJqIXd
         cdBvU3SDA9Gl8+X8XY4E4gMn+6aHBVztbPxllO7UwyTV8TKDyC+o2L/nMTF1OGzPjt/D
         P/Sl5QiHB8j+nliszphRwbO0k28Iukwd5n1/1PiSp3iNm9hsWyuQ1t5QFrVVCrLjKoG5
         LENmkyo41kyWPun3fNRdI9R915qVQi+0oLhg/FqgdL570AjSRtWDOWFoxmTmf9Jf4MAB
         TC4A==
X-Gm-Message-State: AOAM532gD36+SqzS/+Go6ot0sn36raSztFGwEx2iAmNaHxs1yIyqMEy7
        jBmYqBbb4lbEwzmqlCjP3KVCHR/U7RU=
X-Google-Smtp-Source: ABdhPJwSOMs4krjNdl87IAsvA3tnHjfyCERawjsmJRpzAnfbxd1o9s7qUMwEVXfIEE5qRrXKpLmnUA==
X-Received: by 2002:a17:906:9b8f:b0:6e0:6bcb:fc59 with SMTP id dd15-20020a1709069b8f00b006e06bcbfc59mr682582ejc.624.1650056951454;
        Fri, 15 Apr 2022 14:09:11 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.133.118])
        by smtp.gmail.com with ESMTPSA id j10-20020aa7de8a000000b004215209b077sm2602938edv.37.2022.04.15.14.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 14:09:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 01/14] io_uring: clean poll tw PF_EXITING handling
Date:   Fri, 15 Apr 2022 22:08:20 +0100
Message-Id: <f0cc981af82a5b193658f8f44397eeb3bf838b7b.1650056133.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <cover.1650056133.git.asml.silence@gmail.com>
References: <cover.1650056133.git.asml.silence@gmail.com>
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

When we meet PF_EXITING in io_poll_check_events(), don't overcomplicate
the code with io_poll_mark_cancelled() but just return -ECANCELED and
the callers will deal with the rest.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 99e6c14d2a47..4bc3b20b7f85 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5899,7 +5899,7 @@ static int io_poll_check_events(struct io_kiocb *req, bool locked)
 
 	/* req->task == current here, checking PF_EXITING is safe */
 	if (unlikely(req->task->flags & PF_EXITING))
-		io_poll_mark_cancelled(req);
+		return -ECANCELED;
 
 	do {
 		v = atomic_read(&req->poll_refs);
-- 
2.35.2

