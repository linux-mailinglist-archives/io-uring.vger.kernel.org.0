Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99F7C7D10A0
	for <lists+io-uring@lfdr.de>; Fri, 20 Oct 2023 15:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377074AbjJTNjh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Oct 2023 09:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377376AbjJTNjg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Oct 2023 09:39:36 -0400
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4171C19E
        for <io-uring@vger.kernel.org>; Fri, 20 Oct 2023 06:39:34 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-9be02fcf268so126649666b.3
        for <io-uring@vger.kernel.org>; Fri, 20 Oct 2023 06:39:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697809172; x=1698413972;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ecBcTJo5sXfk5aiuigWKv420DY2jJfGo1LUDJOdUAbA=;
        b=bcIimGogtvu5SHxXIDVskA6gV/bsM5KkLnYgvaSO5FB+8X1we7Hqmu3GacEjm/Fm5t
         yD6CiAyCkPrxVNX1QjuMkhIUU5jzi27ySXHEmMQQIsfOsyU3EjgKD0sZ1yZH4zmS+HTV
         HMuHIF4+74Hs7iHTmEYxzHaY+v0xMcxCBpjYkbUB/PDZF9yq4q38EZ/qOzQlpg6FYtxB
         0BuEXEiC5nwI3WXbN639gGaGWt4737kvWcy6nMEo/P5ZHp8wO64hlBgT/zOlLkj+jbHq
         PleUvBQk+UpdsxfP7ED7FbOWRYsMINatHBdopAjjIgXmzmrOsuRvqxYvgtkbmk/OlMTT
         fm7g==
X-Gm-Message-State: AOJu0YydD6EQVc23XKziEJqLc82F3XMZdcR+xJeDKuSHUGHd3h4MMgpk
        iz+u6Zp1CWr0R4OJL0rwNew=
X-Google-Smtp-Source: AGHT+IGihgOGShk/iOyHNBrAytCBKuluhTEmP7LF8xbrqtspszeVQc7m0M8SAe53i/yXQ+ZfLwbgFA==
X-Received: by 2002:a17:907:25c4:b0:9c1:bee1:b7eb with SMTP id ae4-20020a17090725c400b009c1bee1b7ebmr1466368ejc.37.1697809172424;
        Fri, 20 Oct 2023 06:39:32 -0700 (PDT)
Received: from localhost (fwdproxy-cln-020.fbsv.net. [2a03:2880:31ff:14::face:b00c])
        by smtp.gmail.com with ESMTPSA id jp10-20020a170906f74a00b009adc81bb544sm1544531ejb.106.2023.10.20.06.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Oct 2023 06:39:31 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [PATCH 4/5] man/io_uring_prep_cmd: Fix argument name
Date:   Fri, 20 Oct 2023 06:39:16 -0700
Message-Id: <20231020133917.953642-5-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231020133917.953642-1-leitao@debian.org>
References: <20231020133917.953642-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring_prep_cmd(3) documents that one of the argument is SIOCOUTQ,
while, in fact, it is called `SOCKET_URING_OP_SIOCOUTQ`.

Fix the argument name, by replacing SIOCOUTQ to
SOCKET_URING_OP_SIOCOUTQ.

Fixes: 2459fef09411 ("io_uring_prep_cmd: Create a new helper for command ops")
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 man/io_uring_prep_cmd.3 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/io_uring_prep_cmd.3 b/man/io_uring_prep_cmd.3
index 01b48da..d6ec909 100644
--- a/man/io_uring_prep_cmd.3
+++ b/man/io_uring_prep_cmd.3
@@ -55,7 +55,7 @@ For more information about this command, please check
 
 
 .TP
-.B SIOCOUTQ
+.B SOCKET_URING_OP_SIOCOUTQ
 Returns the amount of unsent data in the socket send queue.
 The socket must not be in LISTEN state, otherwise an error
 .B -EINVAL
-- 
2.34.1

