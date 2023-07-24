Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2353A75F9CB
	for <lists+io-uring@lfdr.de>; Mon, 24 Jul 2023 16:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbjGXOYI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Jul 2023 10:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbjGXOYH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Jul 2023 10:24:07 -0400
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570F010D3;
        Mon, 24 Jul 2023 07:23:57 -0700 (PDT)
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5222c5d71b8so1553196a12.2;
        Mon, 24 Jul 2023 07:23:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690208636; x=1690813436;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=InNH0JvJZ59G15aPVaduy0ZgdUUB/VBaXGV72FTdLX8=;
        b=PYUlNukPVxUwY1QQYwf/qlDPShjGJ+4xeD7y6lWy0BUSgUhPS0PhCLGOe0LqI0kLeC
         owuJ2sG/PXQm3HOmWtIZEgzjy/mgukxjY7WYc2+0XSb+ygRzKZnxstdQIZkzhSknBmjD
         u+B6fFRvyZWf04u36cvx9zp46mHZT6gihvnCaVkd6Rir+8AOp0+I3nUS3AagGw544grG
         qyeQZtKrS3Tt9fjrl42HJB4+EAfXP9GaNrMgvhSzZfcuwPxPo/IrGxtS55wWlQ0zBJzo
         apw+OP0dWOqNm6A2zakXpLDIwK5p8SLPFCS3y9SL3EAyv9bz4tmOIgyy+KXUE30wkGk3
         hheA==
X-Gm-Message-State: ABy/qLaf+FiOaf63W0JvyEAP+sBqaJRejKjfH1PwNWlk0tLTrikO+fH6
        MJg6GtxHpWIJ1A/sSOGv0hE=
X-Google-Smtp-Source: APBJJlEff2FaAz2S0e77QKwTEYOPwndwXpEpzYjsHXHr3fMOor5smynpFKEb247h6fN47lwf5jjxiA==
X-Received: by 2002:aa7:c2ca:0:b0:51e:677:603f with SMTP id m10-20020aa7c2ca000000b0051e0677603fmr8335834edp.38.1690208635735;
        Mon, 24 Jul 2023 07:23:55 -0700 (PDT)
Received: from localhost (fwdproxy-cln-120.fbsv.net. [2a03:2880:31ff:78::face:b00c])
        by smtp.gmail.com with ESMTPSA id a23-20020aa7cf17000000b005221f0b75b7sm3118092edy.27.2023.07.24.07.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 07:23:55 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, linux-kernel@vger.kernel.org, leit@meta.com
Subject: [PATCH 4/4] io_uring/cmd: Extend support beyond SOL_SOCKET
Date:   Mon, 24 Jul 2023 07:22:37 -0700
Message-Id: <20230724142237.358769-5-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230724142237.358769-1-leitao@debian.org>
References: <20230724142237.358769-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add generic support for SOCKET_URING_OP_SETSOCKOPT, expanding the
current case, that just execute if level is SOL_SOCKET.

This implementation basically calls sock->ops->setsockopt() with a
kernel allocated optval;

Since the callback for ops->setsockopt() is already using sockptr_t,
then the callbacks are leveraged to be called directly, similarly to
__sys_setsockopt().

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 io_uring/uring_cmd.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index d63a3b0f93a3..ff438826e63f 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -229,11 +229,14 @@ static inline int io_uring_cmd_setsockopt(struct socket *sock,
 	if (err)
 		goto fail;
 
-	err = -EOPNOTSUPP;
-	if (level == SOL_SOCKET && !sock_use_custom_sol_socket(sock)) {
+	if (level == SOL_SOCKET && !sock_use_custom_sol_socket(sock))
 		err = sock_setsockopt(sock, level, optname,
 				      KERNEL_SOCKPTR(koptval), optlen);
-	}
+	else if (unlikely(!sock->ops->setsockopt))
+		err = -EOPNOTSUPP;
+	else
+		err = sock->ops->setsockopt(sock, level, optname,
+					    KERNEL_SOCKPTR(koptval), optlen);
 
 fail:
 	kfree(koptval);
-- 
2.34.1

