Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5D6454B74E
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 19:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236988AbiFNRDK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 13:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351730AbiFNRCx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 13:02:53 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C32140A6
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 10:02:49 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id s37so6419773pfg.11
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 10:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=QFBqJijkDJ+DCDKjH8faYodmfK1y3eLRLQXmDBveQzA=;
        b=opHVIr4WCB6P3tFYDtdt218FbnRTi6G+pRjXAVdSHPdpJaFBrmk/3UhRJLOQa/+f/o
         Fxcqyjnm+Fm54rLKY/MV5BfAJpFmxCkk3QVQfCjDFv6MMpnff4sXMd4Pckbj062sx3QI
         llx5qElskkER2rgqszLS3VVNXd66UxpyJuBk5GnnAjWZcXqEBjS7RERiAr3qy4xYl4Gg
         2ozomsWzZoxLvzc2dMZEehN1HacmVbH/GgL3dLFhPZphv77UTmgvCcTW3ZN0/9qmQEHd
         Kg09eNEFJWyJ9yIbbxlreSC2ET5FcEV2zVvQSsxxfoH73Rk0XQ5IFbYcnQQxknqy7CNd
         Byig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=QFBqJijkDJ+DCDKjH8faYodmfK1y3eLRLQXmDBveQzA=;
        b=UcgMLgvR2U4jMKZdxE3IGfnXc0gtgZ+y0qrV+ZD3dkSMGXLCoI3Y8JoM8B3zsi3sdW
         d/6zfp3NCnqgGVc5L0oVNd3viMrbKQY5BmnuG4kGD1XX9IfKGMmLSWItc/I97xdDSnSq
         JNxifGljbXYM0ciTa/HwhCxWK+nScykIPPsLKDMBfv71Gg12pWfvX52aTnewcQG//ZNH
         ax51ifYjMcQJEyoqcJ8QhPlr4eWCamqXTB9+6AQkYf+Xfg8q1dvv86y97vlbqAJ9/dtU
         95a0RRp7hk6c4rerbkXT4nj67l/JL35/MzqBJ0+hP0/FGPUs/y/gT2oWozqwtaUmLdTL
         rqwA==
X-Gm-Message-State: AOAM530cd3FC1rc/ifkI4jWHLeT0fcbCBZ09nLiNYhdLrHWkh75H3oq9
        1oxVgHzKjg5dzTjEAm6cDemfeVbhsgY0XQ==
X-Google-Smtp-Source: ABdhPJyZPCM3lXyT1gWoDS/IOxEyR/xUBhKF060VyEoP/N3720FctGagQkg40K+YB570pu3r0S/QYg==
X-Received: by 2002:a63:e45:0:b0:401:9f3e:9a6c with SMTP id 5-20020a630e45000000b004019f3e9a6cmr5146109pgo.395.1655226168451;
        Tue, 14 Jun 2022 10:02:48 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d5-20020a17090ab30500b001e2f383110bsm9786335pjr.11.2022.06.14.10.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 10:02:47 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <cover.1655224415.git.asml.silence@gmail.com>
References: <cover.1655224415.git.asml.silence@gmail.com>
Subject: Re: [PATCH 5.19 0/3] 5.19 reverts
Message-Id: <165522616748.252848.18050487497900493924.b4-ty@kernel.dk>
Date:   Tue, 14 Jun 2022 11:02:47 -0600
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

On Tue, 14 Jun 2022 17:51:15 +0100, Pavel Begunkov wrote:
> We've got a couple of nops debugging features, which don't belong to
> upstream, and IORING_CLOSE_FD_AND_FILE_SLOT nobody knows how to use
> reliably and with a couple of unsolved problems.
> 
> All came in 5.19, let's revert them.
> 
> Pavel Begunkov (3):
>   Revert "io_uring: support CQE32 for nop operation"
>   Revert "io_uring: add buffer selection support to IORING_OP_NOP"
>   io_uring: remove IORING_CLOSE_FD_AND_FILE_SLOT
> 
> [...]

Applied, thanks!

[1/3] Revert "io_uring: support CQE32 for nop operation"
      commit: 8899ce4b2f7364a90e3b9cf332dfd9993c61f46c
[2/3] Revert "io_uring: add buffer selection support to IORING_OP_NOP"
      commit: aa165d6d2bb55f8b1bb5047fd634311681316fa2
[3/3] io_uring: remove IORING_CLOSE_FD_AND_FILE_SLOT
      commit: d884b6498d2f022098502e106d5a45ab635f2e9a

Best regards,
-- 
Jens Axboe


