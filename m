Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B16658AC77
	for <lists+io-uring@lfdr.de>; Fri,  5 Aug 2022 16:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240784AbiHEOnd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Aug 2022 10:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238404AbiHEOnc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Aug 2022 10:43:32 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A42232449
        for <io-uring@vger.kernel.org>; Fri,  5 Aug 2022 07:43:31 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id v185so2028721ioe.11
        for <io-uring@vger.kernel.org>; Fri, 05 Aug 2022 07:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc;
        bh=+uvqBkJBhlijapWyMGBg6HxlgZgyRpWnynygh4oRF3Q=;
        b=tItOL7lRo9+pvWyWeJVD4RRWoScQMTTuKbUUh+ZoOLtl8IxRaR0Y5LT2oVOEVDGSx8
         Uk8ipJHHR9eLnbK9j/2BsqTt/rd8bqsRZyBOp1c6H5Udh9OPr0Z6JpLilzxwaCRwlXxt
         vWB1IPHUI3H4WBe1GFNaj7p0ubu071AQs0F51xBN4UyWRTZYaVxooIRKM0VGA31bbaeb
         gn5NSl6TY3r/mR9gX7eC6RguJCKwu1FVLrzss1Zu3s3g1sEFqA5YMEpQIMBl+RkOmxne
         P+v4VKX39zhDq0MZzvPM6mbGwg2uWtMdUSj7icm8vyW6toQ252T0KxsdXK0GiPfQjCFH
         8ClA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc;
        bh=+uvqBkJBhlijapWyMGBg6HxlgZgyRpWnynygh4oRF3Q=;
        b=Q5ZuZpCmNky5iGXU9ZsyZbtjyCHRnqrSeX3n0hNKIOHIk9Wm1W6Bbv8isG4v43LmQj
         yAETZswz/BdSdrghkyfXJjju46GkVx2ps1EmFXM0h1Yn3mqDKmih8GH3CeaAstvpxbaC
         S7k/rDfC5q2wekxycbYZ58HuxD9BhWuuEdjqHcjpV9skmCc5lZ+UhW3W6m3VsAnHZl+a
         C96uCZETRsgzVvqC6mt7rwbKlU75XyvtPeQLWN+lUySM7WUv62XDr4gtZqNQDqlq7qJp
         /DlZ/1Hnkhq4a8yrDM9Ew6hdAXk7Qs6wezbaE/i6d+aFqTYKrr3Qi3HMFaF3pAU3r5b1
         +frQ==
X-Gm-Message-State: ACgBeo0TMHWvqB5hgmC/FTIwsDi2kpZKE6y4rvUW4wBfW0gCuGw/KrBS
        XRqyR4dm9I9MqFDNJ8Zbvl5oUg==
X-Google-Smtp-Source: AA6agR6SM3/WWpn903sGrwfyEctdyofq4XMYuamobfKc5UkKB2U4nGO7wcH5fUR0Y6W9uIYBgReUJw==
X-Received: by 2002:a05:6638:451a:b0:342:a64b:835c with SMTP id bs26-20020a056638451a00b00342a64b835cmr3033483jab.13.1659710610973;
        Fri, 05 Aug 2022 07:43:30 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g27-20020a02271b000000b00335b403c3b4sm1693752jaa.48.2022.08.05.07.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 07:43:30 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, dylany@fb.com
Cc:     io-uring@vger.kernel.org, Kernel-team@fb.com
In-Reply-To: <20220803155741.3668818-1-dylany@fb.com>
References: <20220803155741.3668818-1-dylany@fb.com>
Subject: Re: [PATCH liburing] io_uring-udp: make more obvious what kernel version is required
Message-Id: <165971060857.382059.2061178619457311809.b4-ty@kernel.dk>
Date:   Fri, 05 Aug 2022 08:43:28 -0600
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

On Wed, 3 Aug 2022 08:57:41 -0700, Dylan Yudaken wrote:
> This example uses some of the latest kernel features, which can be
> confusing. Make this clear in the error messages from these features that
> a latest kernel version is required.
> 
> 

Applied, thanks!

[1/1] io_uring-udp: make more obvious what kernel version is required
      commit: 2757d61fa222739f77b014810894b9ccea79d7f3

Best regards,
-- 
Jens Axboe


