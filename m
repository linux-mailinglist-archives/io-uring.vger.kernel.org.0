Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A916677639C
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 17:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjHIPWF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 11:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjHIPWF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 11:22:05 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F575FE
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 08:22:02 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2b9b50be31aso106093181fa.3
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 08:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691594520; x=1692199320;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ipj18veJPD4zqbsxwaRuS9MIxB5aywHPfKdsWtOA0ak=;
        b=E6imtCNFYQYUEVMCg6cbFXIQad6wuDesofVu1KQ+S+JVBFdCrLzQJp+63xKtUaO7j+
         Gj4R3iDVXhPnpNaE+NOotcwqha9WmkxCGbbiKG5Agrray1PJLCHBv+9VZ9ekBEj3i3fe
         uYp62emmiCe3LM+X+amNebNogGP+4+bA05u/7uJEhyCphoUeC+YBQq2sjDAoByZhOR1u
         kCgiAPeCY35BvEqXxPWin2Y4nWHkjhd1w9z2W+khcwPJ4i3eQ2wG1SkaK697aq76zynR
         dQTQ6k8fPpYvWbdUzXg+3D6LsMjz2Sc7r+u826YtzBMX6qr6k72NTK9x2jBYd314xFPn
         Inow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691594520; x=1692199320;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ipj18veJPD4zqbsxwaRuS9MIxB5aywHPfKdsWtOA0ak=;
        b=Iv8TiBF1zsbTGGoR4M5pCCNcjij4HoBf4FiYL8qiCzWKkpDeFJen8ivvgA1BuoEQjl
         M1if8AMKrrdksCgca66qBfN04i+z7QhhzSPsu3UtXP74IGqd21NNyxqbDqc2Lo3drYfj
         U0+AI6XjPeC54OHLyApzAGgBqU2khs1FaSuFOCg9EcBUlQsMj8fPeroYephc0EV6Uk6A
         feZGP67wy+i0XDNj3sJn1fx3iQ1rF+2+udgNbqeOGxagK0rJYuuRpvTPs9A+OHH+sbr6
         SIboZabHj+TMYABE4friEvqbI//qqXpPHsdopCUNQKVeIAw9tKXJMNAmkR/X47ZSmPGo
         znHw==
X-Gm-Message-State: AOJu0Yyo4dXwXiSJNbhfRdut9p7xGu16MHKKrFhSsDBHdddqIZHn66iN
        kVe2Afscou4OnasozGYlizK51zqUNnA=
X-Google-Smtp-Source: AGHT+IEWCDmjXtwDhkBBNXXrUD3xw2T8YB1Ns2hzE0Hy1OlUGGH3rOiC7Hhlme5+4jC4hbmyyfZoCg==
X-Received: by 2002:a2e:9b4c:0:b0:2b7:4078:13e0 with SMTP id o12-20020a2e9b4c000000b002b7407813e0mr2235820ljj.43.1691594520109;
        Wed, 09 Aug 2023 08:22:00 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:c27f])
        by smtp.gmail.com with ESMTPSA id bw4-20020a170906c1c400b009829d2e892csm8296067ejb.15.2023.08.09.08.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 08:21:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: break iopolling on signal
Date:   Wed,  9 Aug 2023 16:20:21 +0100
Message-ID: <eeba551e82cad12af30c3220125eb6cb244cc94c.1691594339.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't keep spinning iopoll with a signal set. It'll eventually return
back, e.g. by virtue of need_resched(), but it's not a nice user
experience.

Cc: stable@vger.kernel.org
Fixes: def596e9557c9 ("io_uring: support for IO polling")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f32092d90960..1810cf719a02 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1684,6 +1684,9 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 			break;
 		nr_events += ret;
 		ret = 0;
+
+		if (task_sigpending(current))
+			return -EINTR;
 	} while (nr_events < min && !need_resched());
 
 	return ret;
-- 
2.41.0

