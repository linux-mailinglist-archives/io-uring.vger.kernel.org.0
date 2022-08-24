Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6AF459F911
	for <lists+io-uring@lfdr.de>; Wed, 24 Aug 2022 14:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237185AbiHXMKc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Aug 2022 08:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237280AbiHXMK3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Aug 2022 08:10:29 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B207A3E779
        for <io-uring@vger.kernel.org>; Wed, 24 Aug 2022 05:10:27 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id sd33so11771279ejc.8
        for <io-uring@vger.kernel.org>; Wed, 24 Aug 2022 05:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=vT2SMsi+70IiyW0tafUfZBivZ5hq8kKCBP0oxP+zUEc=;
        b=Y8ySVizk0AyS4lAF6YnNM991COxMujbDwBh4Pbzd7AcHhphSZoR2P/8iNJyXFe0p0I
         H8j3HR5+4MpmAZBWduM78BanFTbKEKLZglcd225aJNvoRjUnKJUZIJCKhu9KeaSlgWWm
         flnVM6mfO/TC0mIxjHSbCgK1nkbruyaGJcvPFU88bEBcAlcCX7hksQt8Qs/QrNjFBBZC
         5ICjlcXGu90X/v4RU9rAyQ0YAdNRjg4RT24FXrMlNNDCbX5A4BG6zhH+sgcRk4PivRWg
         ixtuFKBBoZmB1FYkmuBvL2a6q62IvcO7KfUNf5lQEHTCsJZvyN/iRPJnF8kUjD1qyBDl
         lLaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=vT2SMsi+70IiyW0tafUfZBivZ5hq8kKCBP0oxP+zUEc=;
        b=vQ7BoKw2BHOwMuCABSQkuTKsGvHpRZ+eZpdnyz8EV6/YjFnmRhahWZBeaSVO3QB0/y
         jqD3h1AtbFDEWJf2qZNz4H3dv6bdaol1fNZFEw0+jZH3hIMqFSJ6Js71RPCigd1Nbint
         iYjYKr4/smzcESqbPalYXdq125C+99fjqvWnMnnnULusBmFxCQNUSvcdBnSiUM+9SigJ
         OCCVrp1y21nHdp1TwbW/8ujUrw6woztqUprSa67rIn/nPIY0IaFaMvPIPX0F6EpQeOIV
         m35RrWNFj1U553Kro1ohWmToN1UchqZqNQMti5C5JEBUbaOVhoN+8FL2qI5dInxeJxOu
         YpCA==
X-Gm-Message-State: ACgBeo3hr7qUijqtKS8C3a98uERVr057lU4+7ebFQquqreeMI2zLSrIi
        4PMs+p4EFSxz0KrGEApi74w7B/xJZkhVJA==
X-Google-Smtp-Source: AA6agR7uHl1AvUn8D92HXpiIlF8Jw5CEf/3eLFqxXVRtM7esHGp/z3q9DydbWmzNSQ6EHtAxBi9fXQ==
X-Received: by 2002:a17:907:60c7:b0:731:14e2:af10 with SMTP id hv7-20020a17090760c700b0073114e2af10mr2733827ejc.92.1661343026014;
        Wed, 24 Aug 2022 05:10:26 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:7067])
        by smtp.gmail.com with ESMTPSA id j2-20020a170906410200b007308bdef04bsm1094626ejk.103.2022.08.24.05.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 05:10:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5/6] io_uring: conditional ->async_data allocation
Date:   Wed, 24 Aug 2022 13:07:42 +0100
Message-Id: <9dc62be9e88dd0ed63c48365340e8922d2498293.1661342812.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1661342812.git.asml.silence@gmail.com>
References: <cover.1661342812.git.asml.silence@gmail.com>
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

There are opcodes that need ->async_data only in some cases and
allocation it unconditionally may hurt performance. Add an option to
opdef to make move the allocation part from the core io_uring to opcode
specific code.
Note, we can't just set opdef->async_size to zero because there are
other helpers that rely on it, e.g. io_alloc_async_data().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 7 ++++---
 io_uring/opdef.h    | 2 ++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ebfdb2212ec2..77616279000b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1450,9 +1450,10 @@ int io_req_prep_async(struct io_kiocb *req)
 		return 0;
 	if (WARN_ON_ONCE(req_has_async_data(req)))
 		return -EFAULT;
-	if (io_alloc_async_data(req))
-		return -EAGAIN;
-
+	if (!io_op_defs[req->opcode].manual_alloc) {
+		if (io_alloc_async_data(req))
+			return -EAGAIN;
+	}
 	return def->prep_async(req);
 }
 
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index ece8ed4f96c4..763c6e54e2ee 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -25,6 +25,8 @@ struct io_op_def {
 	unsigned		ioprio : 1;
 	/* supports iopoll */
 	unsigned		iopoll : 1;
+	/* opcode specific path will handle ->async_data allocation if needed */
+	unsigned		manual_alloc : 1;
 	/* size of async data needed, if any */
 	unsigned short		async_size;
 
-- 
2.37.2

