Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990DB5953AE
	for <lists+io-uring@lfdr.de>; Tue, 16 Aug 2022 09:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbiHPHZR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Aug 2022 03:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbiHPHYh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Aug 2022 03:24:37 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC2C2DFE10
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 20:34:25 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id y141so8278399pfb.7
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 20:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc;
        bh=i/1ev6MP6U01YsnNj0//eY4ryHyybLtyoFtsa+DzUA0=;
        b=bRYDXThCQTj0vQvLqGhogZDw7DkW3kXCTWTYItnQxEtBTy6ZIsJC+PaEA5VvX0L0MD
         bJrJxRuzxrdcED+KNN7W1fy/j6rz/NBTGb+mLlRZd6ZWBuo2cyD5AyLsvN9kE4lwvBUD
         0MEssAWE/4diV98oZJ9Nm+G4/df4QL2IJxA2B9HcVI2RY1WzhlpjBaOtPGn7OdxzN18F
         vMhjUyA1QJdMmZkSpjTZIM/0WWn+kHnWSscJok4o42eMQ5PYepj+WNYDgwPq/zPmkFZb
         6eYTpD+kIOJIT1hzhaMAbgkKyTpeAmfHT8bOAxzCELs0xwgRGg66DLaNpNdnwwI1PERs
         FtGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc;
        bh=i/1ev6MP6U01YsnNj0//eY4ryHyybLtyoFtsa+DzUA0=;
        b=FRYW7DYKEIGP+iELO0JFxckNjeQOAhswrvfD1gCwBdoYttfDgHX6HF23D4WashSD0a
         p4+6Vu5OpzQLb2ubYW2dbxKuEiOlGPpx+evLvHUQuB0Cl+waLMQVeF/sVc5LFs/qKv3x
         S4dvSHoiQKDaPp8WsRBplYLnJSdE91B7nyKapYrYnmn4qFOpWsH7Dj0Dsv6ydldeGS2e
         BWjcDtmUc7BQd1f5yLUR1f0v2bcZPNYK6EssAhKAt1Y3ZNr73w+xrJy7+H4Epvi/sTDc
         myZ0sqM+8IIJVh/acvbKw3DAjtrejhu4dF1RpxitYjQ4kC1pYrnqkQBdQYHTqwS3x67F
         Ag8g==
X-Gm-Message-State: ACgBeo3prPzymcca8BuJWMwYBByEcFrodZ7D/NiSJKYyb2NYp8jfroRX
        /zV4hDKKA0Q9U7+W/+usJRcU33wIAVUHfQ==
X-Google-Smtp-Source: AA6agR5p8VD8ijbDAhWzN5vsbY9M4cwJUTPQVdv8a1KkwlzChZCxcerGEWOSiRZAUO32dUM114aF0w==
X-Received: by 2002:a05:6a00:3408:b0:52f:9dd0:4b21 with SMTP id cn8-20020a056a00340800b0052f9dd04b21mr19492838pfb.39.1660620864248;
        Mon, 15 Aug 2022 20:34:24 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id v8-20020a170902b7c800b0016909be39e5sm7708021plz.177.2022.08.15.20.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 20:34:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, io-uring@vger.kernel.org
In-Reply-To: <cover.1660566179.git.asml.silence@gmail.com>
References: <cover.1660566179.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-5.20 0/3] small io_uring/net fixes and uapi improvements
Message-Id: <166062086153.45056.11482261737517659233.b4-ty@kernel.dk>
Date:   Mon, 15 Aug 2022 21:34:21 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 15 Aug 2022 13:41:59 +0100, Pavel Begunkov wrote:
> Just a random bunch of changes we need in 5.20
> 
> Pavel Begunkov (3):
>   io_uring/net: use right helpers for async recycle
>   io_uring/net: improve zc addr import error handling
>   io_uring/notif: raise limit on notification slots
> 
> [...]

Applied, thanks!

[1/3] io_uring/net: use right helpers for async recycle
      commit: 063604265f967e90901996a1b173fe6df582d350
[2/3] io_uring/net: improve zc addr import error handling
      commit: 86dc8f23bb1b68262ca5db890ec7177b2d074640
[3/3] io_uring/notif: raise limit on notification slots
      commit: 5993000dc6b31b927403cee65fbc5f9f070fa3e4

Best regards,
-- 
Jens Axboe


