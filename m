Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 848BB778FF2
	for <lists+io-uring@lfdr.de>; Fri, 11 Aug 2023 14:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbjHKMzP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Aug 2023 08:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233952AbjHKMzO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Aug 2023 08:55:14 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04A126A0
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 05:55:13 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-99bdcade7fbso268288766b.1
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 05:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691758512; x=1692363312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=93K4NPI31nusFtmR4h3522J9OQwMlEfdCozpShx5wv0=;
        b=VVKyMkrRHSYe1wYEvaxFOyn6lpv9HT3enjhuKVnvXkQZzpoGa+kf/pO555m0d6JIRu
         k0lV9w/VpuVZ3FcA0kWbk3WVv/gcaLtnfSKVG5kaaJVdwu4ygpphDRSth51Ct1jtwMLy
         VHHBE7F7jAxZuf6sHmEeRxZ16yv6vKGJELeCoC2jmpizxP3AAVwQjLGzZ5QuOvcgSeSA
         CCMhUWsXfw1DMB10mTB7uYJjYjjM0Elflfqq32JrPzdzuBhv/xUnyoa86fzFEbc9L7GV
         /etLbYXoM2p3ZEhJAAHDAouSszSXlk+RqvGkEoCQOsXtC3Ndg6n9su0ZojRS3cl/YVvI
         +ftQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691758512; x=1692363312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=93K4NPI31nusFtmR4h3522J9OQwMlEfdCozpShx5wv0=;
        b=eb8pHPSI9jhocx1aYmQuadR32wz8zmjuBVOwZUcb6vXmkvm/BWLw5nO+c1OOGUAvNn
         4XUqMnEgkHLy7NB0bFi3e77AFx0nO6HpsOIkTYhdtVzFkxolRvd9L1yG8IxdJtU7scIt
         gNUxBO+HBkE/J+fJkV4k1/diKa8Zjpx9MbayyKOeK5/+DMm8AnK4Ghu2cds8ocXvvo6e
         AoVaUPzvFTEHMHxBs0Max/3ZezS+pvcH1y3/sOK7tpj/cBWY7B+kTlY8qKYKXMWybdG0
         tMvR8mR1VxvhaV/yKPKsWUHsPF+s4H90YvLr7B758dXr24Oc1+XjhkF00JC6y2A4KZVK
         U/+w==
X-Gm-Message-State: AOJu0Yz/rL8u2wc5whqDRgd4qCkDX0KnGlhQkQZg/JZ9QAY0ln0J2q3J
        4USD8qbLXjHjCko3SAZA/ykB/gVa2Po=
X-Google-Smtp-Source: AGHT+IFcA0t4lPMJM6ctIuBsNBsyX4bxgp+Q027iqZEPVqGyVMhQkS99+nyMdU2ypH/MKtJRp1rK/A==
X-Received: by 2002:a17:906:3112:b0:99c:ca27:c447 with SMTP id 18-20020a170906311200b0099cca27c447mr1493421ejx.43.1691758512027;
        Fri, 11 Aug 2023 05:55:12 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:a57e])
        by smtp.gmail.com with ESMTPSA id kk9-20020a170907766900b0099cc36c4681sm2206943ejc.157.2023.08.11.05.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 05:55:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/7] io_uring/net: don't overflow multishot recv
Date:   Fri, 11 Aug 2023 13:53:42 +0100
Message-ID: <0b295634e8f1b71aa764c984608c22d85f88f75c.1691757663.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1691757663.git.asml.silence@gmail.com>
References: <cover.1691757663.git.asml.silence@gmail.com>
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

Don't allow overflowing multishot recv CQEs, it might get out of
hand, hurt performanece, and in the worst case scenario OOM the task.

Cc: stable@vger.kernel.org
Fixes: b3fdea6ecb55c ("io_uring: multishot recv")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 1599493544a5..8c419c01a5db 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -642,7 +642,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 
 	if (!mshot_finished) {
 		if (io_aux_cqe(req, issue_flags & IO_URING_F_COMPLETE_DEFER,
-			       *ret, cflags | IORING_CQE_F_MORE, true)) {
+			       *ret, cflags | IORING_CQE_F_MORE, false)) {
 			io_recv_prep_retry(req);
 			/* Known not-empty or unknown state, retry */
 			if (cflags & IORING_CQE_F_SOCK_NONEMPTY ||
-- 
2.41.0

