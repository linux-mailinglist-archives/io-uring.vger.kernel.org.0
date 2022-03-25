Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5E84E73E1
	for <lists+io-uring@lfdr.de>; Fri, 25 Mar 2022 14:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359209AbiCYNDY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Mar 2022 09:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359206AbiCYNDX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Mar 2022 09:03:23 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A306EC4B
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 06:01:49 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id r13so15215433ejd.5
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 06:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I4SgMl30HyjiI0/lHmPkoLFiL8gTUJUGmq7qmhrAQKA=;
        b=LHfq9j7+WFLaALawdqM5Pktd4M9KzaUk2Bz28nHemb3u636gV30mdNWzAsVmxPViO3
         rR0/tRdmnARrCW21GGX3bzKfDkeRPWF++0Cag7vdwKUp8hvnBa/82jmLEtSyaZk71aEA
         ill/A17lznf6smPKwBrvshcv3B7UGtYCd2jk1bd5svXtOorLCU9iXn+M7rR3rjgMo3f2
         R0AzXdH00OS8NgAZDPJHd3y8GWI9J3QLmEYnJ3HyfaUYdlBLklroJ5e4WUtfR06VN8pA
         VO6Tg6nq2il3TV4fOr+9mrVpDZObR5at2UJnrWvH9PunhKiLjZlhxUDJqJnbGUCv22D6
         UZpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I4SgMl30HyjiI0/lHmPkoLFiL8gTUJUGmq7qmhrAQKA=;
        b=3Np045+4hXMHekvVzHutezYcyvod8yDG7GntpLMOJxojeOnn8uc0Us9SB8Om/lSMWg
         Ac286gSDbIYK4WBaqaIp9qAhjRAWVGmkJFSWyRwx96Ahe+TP7EFaFVOwf9bPTcSjwYrP
         YIBvL1qum5qdfDm4dTUz967uwFk5tK++1sj+h/QzCxeg+ofA9aH3pZxUq2dB9hK0gwJl
         mLkgMcJPmPn4m8jpGH1yVqabcjyopPuo+lea3cExqqlO4Ipypq3SuQy3mMuDe/TNYiK6
         23j1QjVycBTsXnHV4u/FWPwHR58FkjTo7KfG0d/38N2wvUxlVm9OpQ2uACnuYoZa2koK
         6Fig==
X-Gm-Message-State: AOAM5334NQRhV4N1gpGw6ZbLm5yRJHWGA2hT0VXlOEVFiQ66A91ql+hu
        xMH8quIdDoW8q73BL8B3MahySmKO56fZPA==
X-Google-Smtp-Source: ABdhPJx+GkUJk2jHo5BSyfLIuFh2W3VvHGwojNb1SDS2b+/uHENJtz377PmwCQJSaHQCChDmClQJAA==
X-Received: by 2002:a17:907:7214:b0:6dd:e8fe:3e9 with SMTP id dr20-20020a170907721400b006dde8fe03e9mr11565805ejc.51.1648213307133;
        Fri, 25 Mar 2022 06:01:47 -0700 (PDT)
Received: from 127.0.0.1localhost ([78.179.227.119])
        by smtp.gmail.com with ESMTPSA id ky5-20020a170907778500b006d1b2dd8d4csm2326222ejc.99.2022.03.25.06.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 06:01:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5.18 0/2] selected buffers recycling fixes
Date:   Fri, 25 Mar 2022 13:00:41 +0000
Message-Id: <cover.1648212967.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
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

Fix two locking problems with new buffer recycling.

Jens, could you help to test it properly and with lockdep enabled?

Pavel Begunkov (2):
  io_uring: fix invalid flags for io_put_kbuf()
  io_uring: fix put_kbuf without proper locking

 fs/io_uring.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

-- 
2.35.1

