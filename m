Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBF45BFCE9
	for <lists+io-uring@lfdr.de>; Wed, 21 Sep 2022 13:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiIULYg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Sep 2022 07:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiIULYf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Sep 2022 07:24:35 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2404F10A8
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:24:34 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id n15so2418207wrq.5
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=1A/AF2O0KnZf8BC1p2lMQccLfFnZcq73/1o1rWc+TI0=;
        b=qKrdiONCoCqclcrGFpNgMT1hdgp75LDcuftI0IhAY3k6mjOV5k0ivvDNzaVyzDuVes
         JWsBgzQyVf0BU1n/98qqK99jN1U8Ev1dLcc2NO9aPOplCCCn0WKASm/NxQK4fwjw6zxJ
         yo7CCHhfNn09F2tPJ7wuv/1ITGrPCHfaOA+1/JUP+jiWJCPIuYI5r6mRp/xw1dSzH2ix
         /H4klwlm6v2DypQTu12zACXukLJ84TO4qH6MiKb6bepQNg6CeWUgMoo2ISbAyjbpCcHR
         VkhiiphTyXjcRCb9cZlA+h5jP6fFC0hWiaHXWhLnZmBdFA/OYzzH0O3WqAhYNrPPhLvm
         TwOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=1A/AF2O0KnZf8BC1p2lMQccLfFnZcq73/1o1rWc+TI0=;
        b=NKYn3b+xC9mm963Gbz1gOBdleBkYv0HYEiiUDkhlDJWb7BrWk/0kjviDLY+snh88Vf
         Bbwt/DA4q2a76XgcRYgo3uj3zIKbAKNTsi7YE87BEek8TjA0DwKnZ3PnvTrO2IGtf5G7
         tfG3BPMp5S4DAR/THtkWmd/7zrPww+ESogIga1ZUfTIsFjUJ4NKWYS8zLGRFDKxvOUxH
         p3CsXPSxSeNuy/yzm1BEBJ6gSVU7WrzyE/snfO/+VTeEDLeUjTJeHjqWrcGhVQaPhuxb
         LuBeCWEmsuGw44YtrpR8I6T2EQYA/WFptCnV6qIu0EjZnhFf35bO39KP1HF/CUagh0h9
         +uhA==
X-Gm-Message-State: ACrzQf3LKH9jRfdL7XDlgU48S1HVpczaMfhindcY4MKTRgsTptD6ZKBa
        vKt+N977Onnbkm8Uf0UK36KgelJugzs=
X-Google-Smtp-Source: AMsMyM7h2jU0wAY1u8vj0dhhit70/6zsJMt5JxN+IrdeQDXxN3lZZc/lbXE6repONg9z5z+QiuoC4g==
X-Received: by 2002:a5d:47c5:0:b0:22a:6c7a:10f3 with SMTP id o5-20020a5d47c5000000b0022a6c7a10f3mr16278734wrc.523.1663759472401;
        Wed, 21 Sep 2022 04:24:32 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.205.62.threembb.co.uk. [188.28.205.62])
        by smtp.gmail.com with ESMTPSA id bw25-20020a0560001f9900b0022ac1be009esm2467539wrb.16.2022.09.21.04.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 04:24:32 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/4] examples: fix sendzc notif handling
Date:   Wed, 21 Sep 2022 12:21:55 +0100
Message-Id: <e9a14d6e6b3dc7db4eb4f816abee59b947ce416e.1663759148.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1663759148.git.asml.silence@gmail.com>
References: <cover.1663759148.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/send-zerocopy.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/examples/send-zerocopy.c b/examples/send-zerocopy.c
index 4ed0f67..7f5f2b1 100644
--- a/examples/send-zerocopy.c
+++ b/examples/send-zerocopy.c
@@ -190,8 +190,6 @@ static void do_tx(int domain, int type, int protocol)
 				sqe->flags |= IOSQE_FIXED_FILE;
 			}
 		}
-		if (cfg_zc)
-			compl_cqes += cfg_nr_reqs;
 
 		ret = io_uring_submit(&ring);
 		if (ret != cfg_nr_reqs)
@@ -205,19 +203,20 @@ static void do_tx(int domain, int type, int protocol)
 					error(1, -EINVAL, "F_MORE notif");
 				compl_cqes--;
 				i--;
-			} else if (cqe->res >= 0) {
-				if (!(cqe->flags & IORING_CQE_F_MORE) && cfg_zc)
-					error(1, -EINVAL, "no F_MORE");
+				io_uring_cqe_seen(&ring, cqe);
+				continue;
+			}
+			if (cqe->flags & IORING_CQE_F_MORE)
+				compl_cqes++;
+
+			if (cqe->res >= 0) {
 				packets++;
 				bytes += cqe->res;
-			} else if (cqe->res == -EAGAIN) {
-				if (cfg_zc)
-					compl_cqes--;
 			} else if (cqe->res == -ECONNREFUSED || cqe->res == -EPIPE ||
 				   cqe->res == -ECONNRESET) {
 				fprintf(stderr, "Connection failure");
 				goto out_fail;
-			} else {
+			} else if (cqe->res != -EAGAIN) {
 				error(1, cqe->res, "send failed");
 			}
 			io_uring_cqe_seen(&ring, cqe);
-- 
2.37.2

