Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32CC4F0B4B
	for <lists+io-uring@lfdr.de>; Sun,  3 Apr 2022 18:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239665AbiDCQpy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Apr 2022 12:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357590AbiDCQpy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Apr 2022 12:45:54 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089DE55BC
        for <io-uring@vger.kernel.org>; Sun,  3 Apr 2022 09:44:00 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id f3so6865067pfe.2
        for <io-uring@vger.kernel.org>; Sun, 03 Apr 2022 09:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=UvSzyLO8zDeuh863Jx4rLCZqB4RFbYGzsOO7jv+cNZo=;
        b=cbY+h59RrFYJNEVtShgdDsC8uz0TJJ3dQ2Ig3HyEUEAMNF2VZHXR5Qom08FcgzKXup
         g8kGEXYm8bWKRh4n/QjXBL25OYZlwxDb9reWlkYZRzUXrffTZ9p2zm1u7rEqx/YIbpwR
         qDr3vCQfBnClU45YiGS8ZvFN60HYVSCIsKdq8JInh4DNkQE7kGeFph2TUBdzDsWOjLP1
         X6jPcyY4+jO4CrYAqF/z2S0bfP+mA5bMVabyRKb9Ch65qjytDzzYvk8u2Q5AFzWCGgHm
         LYIH46OyVEhDLCQa6L+JXGN51g2c3zTiU0bFoor/6jsa/E6XviPrCydHmk0iRmPXXnBy
         ++hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UvSzyLO8zDeuh863Jx4rLCZqB4RFbYGzsOO7jv+cNZo=;
        b=2mXuQY5CdEefofd/23Iq32lQI1WVqFBY9in3lura/25kE1iYsc3YI95OdPFFTgRbe1
         3lyFa5lpoEJwhylom9sNcoV9sbTNYcK6KkWAbBCKdmo8zhnJny3UJKKMcxSQRKt1Rp5R
         Fc7oGIggh1YU1zd0EHl9WoQ6Atq44mUXv5s9zMPRqtE5hGTen9NMq/teK3itsHqSX6Bt
         MtjHS4H4/kD05UR+zb8coEA/H90gglK6nCOrLBhx1HPMJ65TtpC0TfsPtUM1dRo3/4oQ
         ShW9DfzMcKKELISjpR9/aCNs4cEJ0b6MLCwFdj+Qi1mPXC+fqf8TzGNsZ/6FBLX2sr+y
         G7AA==
X-Gm-Message-State: AOAM530db5Qy4fC5ngPVsP67hyHocmeu4/Ela6zGYjJvLo66vOknTUeg
        jIhAD3TmzLWSPYg0CXtVO0gjxQ==
X-Google-Smtp-Source: ABdhPJz7pt6I7DTTDahwqlNLan1QFoCT26hkg91YC3qGHFKby70AUuORGCdM5cVy2+QRur6KALfIhQ==
X-Received: by 2002:a63:5756:0:b0:36c:67bc:7f3f with SMTP id h22-20020a635756000000b0036c67bc7f3fmr22988833pgm.389.1649004239434;
        Sun, 03 Apr 2022 09:43:59 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k14-20020aa7820e000000b004f7134a70cdsm9051350pfi.61.2022.04.03.09.43.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Apr 2022 09:43:58 -0700 (PDT)
Message-ID: <771eab67-74ba-710e-854a-975a779a9ced@kernel.dk>
Date:   Sun, 3 Apr 2022 10:43:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH liburing 2/2] test/Makefile: Append `.test` to the test
 binary filename
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20220403153849.176502-1-ammarfaizi2@gnuweeb.org>
 <20220403153849.176502-3-ammarfaizi2@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220403153849.176502-3-ammarfaizi2@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/3/22 9:38 AM, Ammar Faizi wrote:
> When adding a new test, we often forget to add the new test binary to
> `.gitignore`. Append `.test` to the test binary filename, this way we
> can use a wildcard matching "test/*.test" in `.gitignore` to ignore all
> test binary files.
> 
> Goals:
>   - Make the .gitignore simpler.
>   - Avoid the burden of adding a new test to .gitignore.

Just a cosmetic issue, but the .test does bother me a bit. Probably just
because we aren't used to it. Maybe let's just call them .t? And we
should probably rename the foo-test.c cases to just foo.c as a prep patch
too.

-- 
Jens Axboe

