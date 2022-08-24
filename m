Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8981B59FDA0
	for <lists+io-uring@lfdr.de>; Wed, 24 Aug 2022 16:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbiHXO5s (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Aug 2022 10:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238759AbiHXO5s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Aug 2022 10:57:48 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E32F86C0A
        for <io-uring@vger.kernel.org>; Wed, 24 Aug 2022 07:57:47 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id y187so13578425iof.0
        for <io-uring@vger.kernel.org>; Wed, 24 Aug 2022 07:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc;
        bh=3ymjEgBuXLhh0HS/wZ43X1F1MazH/YRoJVB+yBCUsWM=;
        b=YSwXv+uDMdsS5Hs2Y3HfZ3YPh17xbkHy9QqutST88Blg39aInTHxiO3ZgYQr77kO2/
         piL96Bm0pkLINJA24UVWvByqyoRrYI6qGT6fQS21V2Sk2nPs6VTWjkEStPME1eFzyFJk
         j9bGHXtsfS7cpppszrK46IQQww0wH9If+4mlr6c7lCgmuaEj/eeMpSoLx38xTciw6V0H
         tyI/u7Qhu8U67ORG8pcqdxzE0NQHpUM1bXU3WYhGSyfhhqhSL35JqrXg+tXgHqxds2Hl
         8Ro8q2ouPM0gtEpPjq4XYNlCh/U9RxSZ0dgJYDycv5wVy3PDuWvDILmpR+c7+maUXnZ6
         MtBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc;
        bh=3ymjEgBuXLhh0HS/wZ43X1F1MazH/YRoJVB+yBCUsWM=;
        b=y3A7oeerRvUXf+e29POYAg9c+BfEC49LJeQBXcCfFYZXdxGbpBJPESt+oI1gZ7UTYA
         XhxdLcrdDkB0+zr670nOyJEisEcPtKMK4novTXpgUzsskkR8wSZ2SYATqR2DgagtK0WY
         rUsTJW/FX4pFRdRKfwqtZ2qvUBm0RXWwu0Gdq20srwzMD9XQQqlN7mejd5OFQgVCVBZ/
         t0q8aQ7VkT83Jram9SgLsgyGakLc+MrpSpRDm5dg7kmDR6i4b9/CJwtQnJHzFSMIz1uR
         cKueConMDRiAebKY2jEEFV2fohdoOd08AaFcnu3xTCqL4bNirSP8YqyRvgk/m03Nh6q6
         WWzA==
X-Gm-Message-State: ACgBeo1lFPcGC/PcAxCa17emoPcnTP4xMbKmRpcgbGKI3U7XRwm2BoGJ
        zoWyk9W+XIyjZqlQ9OKxDR8Dy9lH/8dsQA==
X-Google-Smtp-Source: AA6agR5vig3ugub1YQYlFxdZEAe7ACViNIiK/qYIxPwNYahg5wOLuaJDX/fNbmrXLqcA/rKkKvp5XA==
X-Received: by 2002:a6b:ba44:0:b0:688:876b:61c6 with SMTP id k65-20020a6bba44000000b00688876b61c6mr12864825iof.51.1661353066633;
        Wed, 24 Aug 2022 07:57:46 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c13-20020a02330d000000b00346b4b25252sm7438219jae.13.2022.08.24.07.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 07:57:46 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1661342812.git.asml.silence@gmail.com>
References: <cover.1661342812.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/6] bunch of zerocopy send changes
Message-Id: <166135306587.10586.8502656702937373818.b4-ty@kernel.dk>
Date:   Wed, 24 Aug 2022 08:57:45 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-65ba7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 24 Aug 2022 13:07:37 +0100, Pavel Begunkov wrote:
> 4/6 adds some ordering guarantees for send vs notif CQEs.
> 5 and 6 save address (if any) when it goes async, so we're more
> consistent and don't read it twice.
> 
> Pavel Begunkov (6):
>   io_uring/net: fix must_hold annotation
>   io_uring/net: fix zc send link failing
>   io_uring/net: fix indention
>   io_uring/notif: order notif vs send CQEs
>   io_uring: conditional ->async_data allocation
>   io_uring/net: save address for sendzc async execution
> 
> [...]

Applied, thanks!

[1/6] io_uring/net: fix must_hold annotation
      commit: 2cacedc873ab5f5945d8f1b71804b0bcea0383ff
[2/6] io_uring/net: fix zc send link failing
      commit: 5a848b7c9e5e4d94390fbc391ccb81d40f3ccfb5
[3/6] io_uring/net: fix indention
      commit: 986e263def32eec89153babf469859d837507d34
[4/6] io_uring/notif: order notif vs send CQEs
      commit: 53bdc88aac9a21aae937452724fa4738cd843795
[5/6] io_uring: conditional ->async_data allocation
      commit: 5916943943d19a854238d50d1fe2047467cbeb3c
[6/6] io_uring/net: save address for sendzc async execution
      commit: 0596fa5ef9aff29219021fa6f0117b604ff83d09

Best regards,
-- 
Jens Axboe


