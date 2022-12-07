Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8846452B4
	for <lists+io-uring@lfdr.de>; Wed,  7 Dec 2022 04:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiLGDyh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Dec 2022 22:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiLGDyh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Dec 2022 22:54:37 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5492027168
        for <io-uring@vger.kernel.org>; Tue,  6 Dec 2022 19:54:36 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id m18so9506460eji.5
        for <io-uring@vger.kernel.org>; Tue, 06 Dec 2022 19:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kiMloYQ40taJVrPwywcsMg/nXflbrlvaJuqVqOat9EI=;
        b=hbLa/ocNZzlaIXaaKgCX0GOjRZqOdkCDps5ulV60oK7d1/r8OUhq6hfSHloMoadbpW
         1H3hJvMrA51NSzvat+EE/tXL3gcL7rGlHv6HxCMiEp6Y5TLCrfrREWnVODXDllW9ybHd
         BVvjNFD4TAWIQfNBJ0kGI67mVOt70zH5YaAt4EP8gPdC+6BK8z2gcmmWfRGw8UZBjjkd
         BmdkERgvrn1jy2wpb55AqoD2tROa8HpLzrOo4wMXbRPi43Hn0d2WUKWXaAXkqkTPxEZ2
         okvNViuiRsr6W5Q8qxOZJLImxLgAGHuWfplu+ze+VT3SdZlx1taHPcih4q/YNE0/kAhe
         Yrhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kiMloYQ40taJVrPwywcsMg/nXflbrlvaJuqVqOat9EI=;
        b=4MKGoATXe2vxV5KfPW0eeFTgTRxBiiwu5BxURwW9NJeratvmSQHXMm8HHFH5/wXnL7
         UP5A0+Nz+zBWvig//buyDNgZwEXA1CusrGLHtVUkeloFOUxn2iRX0ealnOf1YGwvIS5l
         rQKiQli2gOliAvHg/D5Bo5DOsPMBkXD8i+FfQ3WvZaG9g7NSRT/R2EH1NFIE5XGOB034
         nvPleeHY5GgtRAdhFBIElLgKzEzVQp1MIf9Y4fF8nDRPk+ITeYPCxyAOu2JNewKs7NJt
         J0+un5Rva3qrMRp6kwIt+lUrqTqUIdFSAeLrOJbqN2QgxtIs5EcEFZsNelLyGyzeW5UE
         ZaTg==
X-Gm-Message-State: ANoB5plZ1WdzAF1bUhbH7hg7U/7kJNG/H3vPhdbiPt2i7PXrnVFOw3u1
        SJVmvGQ8gJLIyhvYxPe1mghLg03sNg4=
X-Google-Smtp-Source: AA0mqf5stzzcUmr8ud40EUV3Sx+e/nBNUQS4kIENyQwKS4k/qFtx5Bib+19qELHXxwGfaljT2JfDMg==
X-Received: by 2002:a17:906:328e:b0:78d:7f22:2c53 with SMTP id 14-20020a170906328e00b0078d7f222c53mr59486400ejw.420.1670385274713;
        Tue, 06 Dec 2022 19:54:34 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.241.58.threembb.co.uk. [94.196.241.58])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906210900b0073de0506745sm7938939ejt.197.2022.12.06.19.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 19:54:34 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 02/12] io_uring: improve io_double_lock_ctx fail handling
Date:   Wed,  7 Dec 2022 03:53:27 +0000
Message-Id: <4697f05afcc37df5c8f89e2fe6d9c7c19f0241f9.1670384893.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670384893.git.asml.silence@gmail.com>
References: <cover.1670384893.git.asml.silence@gmail.com>
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

msg_ring will fail the request if it can't lock rings, instead punt it
to io-wq as was originally intended.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/msg_ring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 615c85e164ab..c7d6586164ca 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -164,6 +164,8 @@ int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 done:
+	if (ret == -EAGAIN)
+		return -EAGAIN;
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
-- 
2.38.1

