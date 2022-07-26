Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF4E5817CD
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 18:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbiGZQrV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 12:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239199AbiGZQrU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 12:47:20 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F3C255B1
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 09:47:19 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id 125so11645024iou.6
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 09:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=l3tkWv+HCtOtPBX1NCK5OjcSwghIgcQ6DASSm3bVFnk=;
        b=s5t1FMowm/yLkHem1mdrAIUm/1/JlugGQPP3yEQWyU0NVPWsKjLg4CLYOF6YbePg1b
         KKyzaJ8geFcadgvQfRv6Z+LXDdw0bLbNU+RA3PZoY91gTVUQ1FW8YFX5tKsDX5P/J3Xo
         2TKftYoOAGS8njd2Hwj0B6OSoWTQ4zV+3ttfJKpaOA2xYdl4w2ZXaxZfdPBX3O0lqhGk
         1+xxuPlHd0E1Xu5f2P0Gej/514NB/QO6V262co5kTYBlLLDWEZ30xXHUVPx4HJOTYFPF
         zogyWrA6mollNIRcJstOtRyg0hYdY9JLsScuksYyKok1qnqlkarCLw09mxnGNKaovSFh
         3FMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=l3tkWv+HCtOtPBX1NCK5OjcSwghIgcQ6DASSm3bVFnk=;
        b=JSCfiLJOIvOWICQQwvGxGXOOHOK8IS7hbnSBE46FzbmCXuQ49H7D/K2QOLLgx8gq0U
         yOL3ILgRzxQRA3VezLXjqoMv3D5v+R3Nt72RqF9Fh+AU+CRzzlZJX7h+FGpjoKuIQ0YR
         b/Az4NUJN4A5+pDpeU2GZKn2+kH5Mp8EYtp9km8q8V5IKMc5Mu1Qz3msVy7R4kbse/pE
         2aaSQaZ/ndiy21Ps0TP0QI5dKPmKmm2vXQh6zpwEJDI2uql6sgxh8KWSLa55pKVlpeh7
         WMJYNqIidKKCgaJWgD50wF5yYlNDDWBZnX52iLQ3P8XfzCGfsfLQTgZLmsNe1T4frwBW
         uk6Q==
X-Gm-Message-State: AJIora8jELfbcjuO5i6PUBk9DAWBpMjPopASd07XUnCHw4mJSGNKN1X9
        rR6mwd3QkuBjZxI1F/hDP/W2dA==
X-Google-Smtp-Source: AGRyM1vNqTk65rBuuUwru5bRlxOLMARVKu7yDA++ULNlOFL69EPst/QzGRdWTtjElnBgcIksY3Pkkg==
X-Received: by 2002:a05:6602:2e8d:b0:67c:c24c:fec4 with SMTP id m13-20020a0566022e8d00b0067cc24cfec4mr1025103iow.134.1658854038577;
        Tue, 26 Jul 2022 09:47:18 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v9-20020a92ab09000000b002dab4765893sm5715319ilh.66.2022.07.26.09.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 09:47:17 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     ammarfaizi2@gnuweeb.org
Cc:     asml.silence@gmail.com, gwml@gnuweeb.org, dylany@fb.com,
        fernandafmr12@gnuweeb.org, kernel-team@fb.com,
        io-uring@vger.kernel.org
In-Reply-To: <20220726164310.266060-1-ammar.faizi@intel.com>
References: <20220726164310.266060-1-ammar.faizi@intel.com>
Subject: Re: [PATCH liburing] examples/io_uring-udp: Use a proper cast for `(struct sockaddr *)` argument
Message-Id: <165885403738.1519500.7001976896562665856.b4-ty@kernel.dk>
Date:   Tue, 26 Jul 2022 10:47:17 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 26 Jul 2022 23:44:59 +0700, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> 
> Sometimes the compiler accepts `(struct sockaddr_in *)` and
> `(struct sockaddr_in6 *)` to be passed in to `(struct sockaddr *)`
> without a cast. But not all compilers agree with that. Building with
> clang 13.0.1 yields the following errors:
> 
> [...]

Applied, thanks!

[1/1] examples/io_uring-udp: Use a proper cast for `(struct sockaddr *)` argument
      commit: 1842b2a74f4e914cb094019d0f339baeffa3023b

Best regards,
-- 
Jens Axboe


