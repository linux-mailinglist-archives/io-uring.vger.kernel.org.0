Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A91C69F95C
	for <lists+io-uring@lfdr.de>; Wed, 22 Feb 2023 17:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbjBVQyF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Feb 2023 11:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbjBVQyD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Feb 2023 11:54:03 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D2E2CFC6
        for <io-uring@vger.kernel.org>; Wed, 22 Feb 2023 08:54:03 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id o8so998973ilt.13
        for <io-uring@vger.kernel.org>; Wed, 22 Feb 2023 08:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LXrPZngBu2LRoHJg2VBXqi3eY7rAHYTlpGkroOxcjtI=;
        b=QsnAxERn4sznAWmgZFnUXqoqygZI+73mLMXrLp2xh262m48+vM2ZMhMyRoZZ7Y1Ibt
         ++R6/GH0vW3DlS3JfKE/fTKhx5OkS9KqnEgPOsz7cqH97yoaP94HV4l6XTXcvqhACqut
         I/XaJbeF1R5rTECW5G/cNT1D8oD4PhJ4a1/AD/XoJRFX9UjUpm/pAve9A6u/4HgD7AXa
         cjiL14p1MpZSm2m2x84SdvvImk53NugSK7QzewKLpK/+9h39kBC5/eXVBJLlS5t7F6qx
         tqg/MqTBOUksaM0+HGtXYeNTI4CtP8aH5KZXQ48Hb9C+h7LtmyBULAGR8+2taiXUNRz9
         jUhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LXrPZngBu2LRoHJg2VBXqi3eY7rAHYTlpGkroOxcjtI=;
        b=yJPhxKCmZfgy8dvrb1lbNr6idMPDpYoSJacGn5xzrjo6qc3+SxT8u8VriHR0YcXSjc
         KdYNtbZrLrAzHPtj4TRHtwEdP9HqDSB5RM9JBZXUE1uwGQRstWJ3SJA7bzkM71NNrS50
         c2+SohqG+7dymIOsEvZ3FjsZwGJB4vjnEklL7Nd9CeAZfCFZerlDj1fwjVqe1kD9jBdM
         EgdYHSYPLdAN4IICJB860sIDh+oSX2ttuLXWqs6jSwGkK1ZfkTKGaz1mErZhnP8OvISx
         TyDoDr8jm9wWGiOYu8O1vriLJzb0BmH2TkbljtJnBMDnlMf6aA2ct3bXDYYe4vUy81Ly
         Sm0g==
X-Gm-Message-State: AO0yUKXj0flB+k9n47qGVLy30qa9kDmlYnjJ3pq/8N510yfrlHS79MI6
        cZ0AEe6IgAPxQWxihLpoKKmkrw==
X-Google-Smtp-Source: AK7set/DSZ0CsqgC0I18ul0EKNeuaxkBxFpirZ7a1RPAan5UQCbKul+W/nY+/6m16L/j9/LBP10xgw==
X-Received: by 2002:a05:6e02:2165:b0:314:1579:be2c with SMTP id s5-20020a056e02216500b003141579be2cmr5246299ilv.0.1677084842321;
        Wed, 22 Feb 2023 08:54:02 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x17-20020a029711000000b003a7dc5a032csm997371jai.145.2023.02.22.08.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 08:54:01 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Wojciech Lukowicz <wlukowicz01@gmail.com>
Cc:     io-uring@vger.kernel.org
In-Reply-To: <20230218184618.70966-1-wlukowicz01@gmail.com>
References: <20230218184618.70966-1-wlukowicz01@gmail.com>
Subject: Re: [PATCH liburing] test/buf-ring: add test for buf ring
 occupying exactly one page
Message-Id: <167708484141.23363.9245039027086286261.b4-ty@kernel.dk>
Date:   Wed, 22 Feb 2023 09:54:01 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-ada30
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Sat, 18 Feb 2023 18:46:18 +0000, Wojciech Lukowicz wrote:
> This shows an issue with how the kernel calculates buffer ring sizes
> during their registration.
> 
> Allocate two pages, register a buf ring fully occupying the first one,
> while protecting the second one to make sure it's not used. The
> registration should succeed.
> 
> [...]

Applied, thanks!

[1/1] test/buf-ring: add test for buf ring occupying exactly one page
      (no commit info)

Best regards,
-- 
Jens Axboe



