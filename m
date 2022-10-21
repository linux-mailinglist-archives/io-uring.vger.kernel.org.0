Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4F6607809
	for <lists+io-uring@lfdr.de>; Fri, 21 Oct 2022 15:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbiJUNOr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Oct 2022 09:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbiJUNNe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Oct 2022 09:13:34 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8077526DB19
        for <io-uring@vger.kernel.org>; Fri, 21 Oct 2022 06:13:16 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id v1so4731605wrt.11
        for <io-uring@vger.kernel.org>; Fri, 21 Oct 2022 06:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eZYQSbfkaJtk5nzX2qim59oopTpElc7omAbRQbEtBO4=;
        b=mDvJW82+EfqRjFo19WeBi9jQIqud0rXE1ph3AgIhGqBRO5VIrDMAl/bDA2YLHd04yf
         nEwxdLAR8g5txQtagQDJPxakJeS2lTjrMaessvvdpbSQbReTdfVbZo78uVLeL3T9DO+D
         AmmwnHJtk4MmmR4zb0nykC69gLGXBIjIU+zC94OMlzgkQXMIg5YCqdYzWB+WqNy+jRDi
         tN50RogzKh9F4kJGSsyy+pQzu8ElEFrIs1JyD0zDSmLOm8k9Wvr9z27ewowrUTLLtF1U
         XXcDGkjMrCpMCHpnZd34R8ZWTAcvaMZOy+4ezBLkLCWh2PS0QRfYDliWLhN1C5HpuqlV
         Of0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eZYQSbfkaJtk5nzX2qim59oopTpElc7omAbRQbEtBO4=;
        b=ZeFUOfE72qpTZbBMRKe2boZ9ASuO7Ehwt2y+WzKbEmlXiUXK8uizqV4VK4RhvQzrsn
         lvt5nV5PvT13Oh91joaegFY9Vkm6+X1GhICHHq4m51OGOSiD0ajogGeFDiFU3CgDKZOq
         hbrC1qv7ybk/G8XppltT5VAqca7+IguKYWvxEtkKneOJUDPDJny08KG+tGEB+Pj8Kzdx
         +lsrSamchJ4F7rLqbqiXO1t9w6+2Mwy1WbhvdttIHhA9/FtakWzY/TI7Qs2DtrBcFO4v
         eWpMVzutaAKggbMPfGcxcY+j7BD/Fu3UA+3CIt2oKs2iuvThsC2o1f85rJBaSnsTb2Nj
         blEA==
X-Gm-Message-State: ACrzQf3vVbC/xG2uSJkDikGQGaQXlg991cyIAQ65H7X+jLMXWcuKQttr
        IzA3iOWbJRM6V3IYx3zUD8vQ1Xaah1k=
X-Google-Smtp-Source: AMsMyM67xn70WCG45GsfRqBYCBQ8k3qIekMWSlyIqYHif3tpnRAmCCv9yZb68CR036/4kPsGDze5iw==
X-Received: by 2002:a5d:64e8:0:b0:231:a71:1eec with SMTP id g8-20020a5d64e8000000b002310a711eecmr12341618wri.59.1666357989429;
        Fri, 21 Oct 2022 06:13:09 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:f27e])
        by smtp.gmail.com with ESMTPSA id n4-20020adf8b04000000b00231893bfdc7sm20739442wra.2.2022.10.21.06.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 06:13:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 3/3] io_uring_enter.2: document IORING_RECVSEND_FIXED_BUF
Date:   Fri, 21 Oct 2022 14:11:00 +0100
Message-Id: <2075ca0ba4b2e8bf11cc16131e09ab5136953155.1666357688.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1666357688.git.asml.silence@gmail.com>
References: <cover.1666357688.git.asml.silence@gmail.com>
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
 man/io_uring_enter.2 | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index d98ae59..2a8705f 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -1231,6 +1231,12 @@ This initial send attempt can be wasteful for the case where the socket
 is expected to be full, setting this flag will bypass the initial send
 attempt and go straight to arming poll. If poll does indicate that data can
 be sent, the operation will proceed.
+
+.B IORING_RECVSEND_FIXED_BUF
+instructs to use a pre-mapped buffer. If set, the
+.I buf_index
+field should contain an index into an array of fixed buffers. See
+io_uring_register(2) for details on how to setup a context for fixed buffer I/O.
 .EE
 .in
 .PP
-- 
2.38.0

