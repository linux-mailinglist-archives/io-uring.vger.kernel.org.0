Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFE259F912
	for <lists+io-uring@lfdr.de>; Wed, 24 Aug 2022 14:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236032AbiHXMKf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Aug 2022 08:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237231AbiHXMK0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Aug 2022 08:10:26 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FE1BE35
        for <io-uring@vger.kernel.org>; Wed, 24 Aug 2022 05:10:25 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id q2so19637945edb.6
        for <io-uring@vger.kernel.org>; Wed, 24 Aug 2022 05:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=dkkPq0XV2TYz8ilMw2LmdxWaWpjg8zabfGHRPH9WEQY=;
        b=XXVyQGoTC0yc5L0h4l8EL51ss8h/GivENIfnKZDzs3sAOwD+Tcc5oDBNRghydDwnzQ
         z2awE8dCTe5xcRKX5aMpTrKaTJw2HRKv73Mnc5zzHZUuzWA1RAWFQtMV2XuG2kQN9hJX
         LeXrzqzIMn6uRq6aIIRrC5POzWXyflA0+4xlXxzTD9cQ1TLLVfCNOOQCmKMxDipJ3vIn
         ltykUdNMz5obpgu0O4FoC0vDs4/LqpX9nA/ZrHMDbz7nJqpaGSnTxagQUuSgq73aFcb0
         4ISgh2QbQfoeDcvmnN9P0PUyoMSm+6pYihSYxWBaCdiwWw951aXBGGXWS/Z7LKv4tQgb
         ei1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=dkkPq0XV2TYz8ilMw2LmdxWaWpjg8zabfGHRPH9WEQY=;
        b=UCF+W1Fs2sm3tWliw7berh0iGw+IhG5uA/aKVh2nk1bWoSEZe6r7Lv5ZZ7SLERdwua
         dQgJ4D9ibpWNj9Ap0tqd5cAT9hDOP25+J1qHwZzaeX7Ed9zP1VSDegOKQ85Ku4Pkdk5p
         tYdE0GtHQ6lexcptBduFGfztvW6fd/2sQLwhmqTp1R0YxkrFUdZQJtPRdtaVEyqe9ELr
         R9kWz7AP6tW2X+7aRc6dxa6K9oJcVV5W7o1UbUHKx5L7IGJyy0YHoLvY40ovWbtGjecd
         FfItMC3Iju/5niStPt0GxjJvmYmroQIGfipqIwiZ9+9SiQEJCu6+Wfyi2lsBFDRQI7j9
         12Rw==
X-Gm-Message-State: ACgBeo3vI8xWVjLsYtnf+wxHVAuXkmYjywhAVRd0Mp3eHJ5uBYcxrDbW
        5Rbzm+E3cmQlA/lVUQpI7e6H/BNO1gHS/Q==
X-Google-Smtp-Source: AA6agR4qfd/gbn/82ux3uqS6lhAppAxVIOV/DaWxLjidSLpSyg93OwRhSWQgGsUTJsKkPVsS0sIZ4A==
X-Received: by 2002:aa7:d990:0:b0:447:8c86:a8ab with SMTP id u16-20020aa7d990000000b004478c86a8abmr1347291eds.157.1661343023153;
        Wed, 24 Aug 2022 05:10:23 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:7067])
        by smtp.gmail.com with ESMTPSA id j2-20020a170906410200b007308bdef04bsm1094626ejk.103.2022.08.24.05.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 05:10:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/6] io_uring/net: fix zc send link failing
Date:   Wed, 24 Aug 2022 13:07:39 +0100
Message-Id: <e47d46fda9db30154ce66a549bb0d3380b780520.1661342812.git.asml.silence@gmail.com>
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

Failed requests should be marked with req_set_fail(), so links and cqe
skipping work correctly, which is missing in io_sendzc(). Note,
io_sendzc() return IOU_OK on failure, so the core code won't do the
cleanup for us.

Fixes: 06a5464be84e4 ("io_uring: wire send zc request type")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index f8cdf1dc3863..d6310c655a0f 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1023,6 +1023,7 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
+		req_set_fail(req);
 	} else if (zc->flags & IORING_RECVSEND_NOTIF_FLUSH) {
 		io_notif_slot_flush_submit(notif_slot, 0);
 	}
-- 
2.37.2

