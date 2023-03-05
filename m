Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7206AAE40
	for <lists+io-uring@lfdr.de>; Sun,  5 Mar 2023 06:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjCEFOQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Mar 2023 00:14:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjCEFOQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Mar 2023 00:14:16 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E0CBDE3
        for <io-uring@vger.kernel.org>; Sat,  4 Mar 2023 21:14:14 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id e13so5759944wro.10
        for <io-uring@vger.kernel.org>; Sat, 04 Mar 2023 21:14:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hWK7oSHT2dCfPFgalceRFJKymGsHciclQuv3EZEs3IA=;
        b=TNtHLjrso9ndMROmMgU/PNKhhlX+HJ8+di7LFPeHHrc0TJUL8Xa5FMwfrOpWlvJ7eB
         mGezAPnPxqJiFeyr0o7UVBhGND+R7rw9DibaGomCL8nycwQ1OCW56LLzbkK8JJiTeajE
         3v4rHSVimIIJGuTQfCzCtNJgfKWe8EfJpUSNfOsrdxVR3951UFhsKmWkGFDjIZ9p4UMC
         +woUispjUwILl4HzIfFrY88gk/nUpKaLY8/NzSuXqBXU9JVx6UX0FBCpCtyiJw4By1Cz
         S5nXGgIBE9QrK1JTOiXwy9KdSYh5dbLTfDdTTHSh6K6fJhPB+ahPmHmJjOqHmEe2pspz
         oPyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hWK7oSHT2dCfPFgalceRFJKymGsHciclQuv3EZEs3IA=;
        b=sQtpz0EGBdmBSoCx/4J11IJrXjr11x4NtK0IsQTUCQG3qY8/4Xku8xOPN67+2u6GAZ
         J0S4zUOD0VNfMAjfmCIku5VluFk4YDONjNi3g/W6XkFrRCL9QO6ZJIW07ihq3yDJlv8O
         i0/IGbRXIj/IXrSjhc48OGcU5mGo0LNLo12WUTBtzYnPljsDvg6dDwCmMGwRKpGvu/gH
         4k2ErURs3/2t+Bzq2rKsYlNRBAZAEv46FvGLtZbEfRYsc/DYc2RJMRPnWqV3jmLFi47B
         znASAZph6OCi5d8RmnTpKL5xAZkumpqi853AZ0rnDr6pMjo7Tl0wgLqDbwBK1EvZm1Ft
         4waw==
X-Gm-Message-State: AO0yUKUGJqOowfCHau/wP4ZmlVXVZ2UEf7U4A5o/+YAWG1TSSzw04a9+
        X0kCZk5/VVksOGgWmRpeo3Tm3ZDtelg=
X-Google-Smtp-Source: AK7set/bSyJKhs2jjjUlcn9WOs1dtBxYxaxlgrLWuxrL+IKy9taEn1qZM/oBvzboVBAvqlN9oKmjZQ==
X-Received: by 2002:adf:e50c:0:b0:2c7:a39:6e2e with SMTP id j12-20020adfe50c000000b002c70a396e2emr4304965wrm.15.1677993252767;
        Sat, 04 Mar 2023 21:14:12 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.92.184.threembb.co.uk. [94.196.92.184])
        by smtp.gmail.com with ESMTPSA id j4-20020adfff84000000b002cda9aa1dc1sm6524348wrr.111.2023.03.04.21.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Mar 2023 21:14:12 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 0/5] sendzc test improvements
Date:   Sun,  5 Mar 2023 05:13:03 +0000
Message-Id: <cover.1677993039.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
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

Add affinity, multithreading and the server, and also fix TPC
performance issues

v2: rebase
    add defer support (patch 1/5)
    fix rx tcp problems (patch 5/5) 

Pavel Begunkov (5):
  examples/send-zc: add defer taskrun support
  examples/send-zc: add affinity / CPU pinning
  examples/send-zc: add multithreading
  examples/send-zc: add the receive part
  examples/send-zc: kill sock bufs configuration

 examples/Makefile        |   3 +
 examples/send-zerocopy.c | 290 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 260 insertions(+), 33 deletions(-)

-- 
2.39.1

