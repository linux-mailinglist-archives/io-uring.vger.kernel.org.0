Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04126589D49
	for <lists+io-uring@lfdr.de>; Thu,  4 Aug 2022 16:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbiHDOPA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Aug 2022 10:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232295AbiHDOO7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Aug 2022 10:14:59 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB922AE11
        for <io-uring@vger.kernel.org>; Thu,  4 Aug 2022 07:14:58 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id kb8so22550088ejc.4
        for <io-uring@vger.kernel.org>; Thu, 04 Aug 2022 07:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=1/q2hbvqGlzpBqL0bCYNyVx+DlfMyFhDL4VzORu+sGE=;
        b=ekiSmbZqGxT11JPk9lNsgqvtxSuJg/iIysXXWkImpx4KbOjJUH9wpCLWiJGNOYkDVM
         D1AJcw3i4U8/2fWKU3yvfPuDc+jdu18VjObFNv09rtYHlP9A+5MAGIUBiL21du85t9mo
         vNAsdeT6K7A3v+Lh+iDXPTF9Dwc6nerRM5QgxqPgJuKZBxejuKMZuWEFVNedhJQ1AAHi
         tibUxWXG7DKlwLgOtoZUu2LNNWNPlCAK+kXjDnXCtTGgAGmpti8LB+9RMgIivxMk1D2y
         RjfxxslBzodLnhkU2PwBpEQ6Zut7mnqkIcjZY9/tYs8WbtVJNe7tSFRbiPE0lnSPg1D8
         mblw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=1/q2hbvqGlzpBqL0bCYNyVx+DlfMyFhDL4VzORu+sGE=;
        b=Zix/liFK2K2oAU7cf6M+pkrgsiQxyvC6/XFemehud2wE5TkoCQ0VrtKvnVijg/0cg0
         k1OoUhvyKARUALMnl3rrXexCyhYVAWMjpBS1HNastxrwtKggoteHoSL3duxKsbA8XSRA
         eeMH6h3NvlFp3gKNZYrhJuutfVaNv84Vlj6C0OnRgHE93yoLPP4OCQ/LzCtxlpNPc6r8
         wbC1ytiCyj8cOhmQGZFaUCcftWUBs0dVrjWG0N1o7zQVr4MpOkAhUVeKiXG2QMQyg3eJ
         YNmrTIeCK9Lz2MKQ77zAxwmbIE2ua+cn3kPjAN58SoysymqXN1B4yG45KUmaZVqZTtmN
         PuRw==
X-Gm-Message-State: ACgBeo3OkCnTGEFis1ysQ7X/11kAYHszhq6cGhI7CN0bGu54ESYTSxIM
        8KjtMxGdj56sazg0Va2nAHB+S4pyJi4=
X-Google-Smtp-Source: AA6agR5SddrTg38eLANJkYPK7L+A7QZlvtsHBS9DrJ2Z6fCMlqrjsrzGz7ep2ucyVpceZ29RfcMO4Q==
X-Received: by 2002:a17:907:1c8f:b0:6e8:f898:63bb with SMTP id nb15-20020a1709071c8f00b006e8f89863bbmr1603089ejc.721.1659622496778;
        Thu, 04 Aug 2022 07:14:56 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id p4-20020a17090653c400b00730c4d1b1cesm370290ejo.178.2022.08.04.07.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 07:14:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: mem-account pbuf buckets
Date:   Thu,  4 Aug 2022 15:13:46 +0100
Message-Id: <d34c452e45793e978d26e2606211ec9070d329ea.1659622312.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
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

Potentially, someone may create as many pbuf bucket as there are indexes
in an xarray without any other restrictions bounding our memory usage,
put memory needed for the buckets under memory accounting.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/kbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index e538fa7cb727..a73f40a4cfe6 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -436,7 +436,7 @@ int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 
 	bl = io_buffer_get_list(ctx, p->bgid);
 	if (unlikely(!bl)) {
-		bl = kzalloc(sizeof(*bl), GFP_KERNEL);
+		bl = kzalloc(sizeof(*bl), GFP_KERNEL_ACCOUNT);
 		if (!bl) {
 			ret = -ENOMEM;
 			goto err;
-- 
2.37.0

