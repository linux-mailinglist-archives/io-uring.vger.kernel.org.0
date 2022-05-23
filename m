Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5301B53193B
	for <lists+io-uring@lfdr.de>; Mon, 23 May 2022 22:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232852AbiEWUTv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 May 2022 16:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232810AbiEWUTn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 May 2022 16:19:43 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE63BCEA3
        for <io-uring@vger.kernel.org>; Mon, 23 May 2022 13:19:40 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id m1so14079693plx.3
        for <io-uring@vger.kernel.org>; Mon, 23 May 2022 13:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=X6KzDWV2s9CddCeS2n3xLkn5ljOP7g4ucSnb8sgeU+g=;
        b=Junva1dQ9VVrtil0/VpAz8ZRAtOPljAlGJVh05PqgLdrJhGyiHPb7kbuqAuAAxGIE7
         gznLGGFfa94LmzfgcSigDTio2gqW3/nwqKVWoyDOaLD9k5uuwxT4+F0toncGxj1+ccfJ
         3Me7uu2SBTRg2wvnFbtpnAUWBlpWG6VOt3SGMYz9uiRs/NFLGSww8HPDSX1KAtvqKPlx
         Q+TWhEIh53KZp75I4AI0GD0i47vRV82w6zcC1yk1hie6QObR5Azm9pvoLfsQTVSB/OpS
         tYWuCJYLFbhCC8Gth4ilRFHlY5bXVVT5ZxroqDiYWubXmqwATuCgwu/N4/AHm2ICgJY2
         5VUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=X6KzDWV2s9CddCeS2n3xLkn5ljOP7g4ucSnb8sgeU+g=;
        b=E3M4yBjtku2236thpASQtdyS6HClVcTrixz5ISejPDElpVC2fPQCL/3tN3/NmGiF1K
         Fzjn/OTqejUxSU5aqzOHJfyTJm09uHKyYj4/Ssb+DcfAlzga7SNHfsCBy0cyVAgmmZco
         bqkg3F8lhonwZm5PAcsssPRZaQBFT4Qkj9hHC7Txnmk5v10vUnhojVeCN1tD2H51bY8T
         ZmIGPlrF6AvBGt9MiOQF3bPV26EheKkjdv9WgNW1KdTu8mqBw/L5c3p+g9KMW4PaTUHH
         GVe2lbAEWMbJxZRy3M+3+5D42qiAaMnCFg5vPd5IkmYB/242T9YQgKupORNKjZY6lkEO
         u07w==
X-Gm-Message-State: AOAM532e7qRCTjdlT+BPvZzZeHoPIA2EFLgdrnftKJc++p8aSd58CnY8
        J1tqrelEttJ34PU4n6oC45eaUw==
X-Google-Smtp-Source: ABdhPJwE2FyhUuyJfb2fxL0s3tzgZw/zFzPrpAe0yTUW02/5PzAcT2O1SW5Msdq10Wsdt/kQI9SVVQ==
X-Received: by 2002:a17:902:e94e:b0:158:91e6:501 with SMTP id b14-20020a170902e94e00b0015891e60501mr24261902pll.29.1653337180154;
        Mon, 23 May 2022 13:19:40 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ck18-20020a17090afe1200b001cb6527ca39sm129991pjb.0.2022.05.23.13.19.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 13:19:39 -0700 (PDT)
Message-ID: <caa5e85c-2bfe-b9e3-1e32-c11f78e6ad29@kernel.dk>
Date:   Mon, 23 May 2022 14:19:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [GIT PULL] io_uring passthrough support
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
References: <6f712c75-c849-ae89-d763-b2a18da52844@kernel.dk>
 <CAHk-=whfi3FE3O7KrziqPbyGvAmNFas3xxLz2O+ttzBkCOQmfw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=whfi3FE3O7KrziqPbyGvAmNFas3xxLz2O+ttzBkCOQmfw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/23/22 2:15 PM, Linus Torvalds wrote:
> On Sun, May 22, 2022 at 2:26 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> This will cause a merge conflict as well, with the provided buffer
>> change from the core branch, and adding CQE32 support for NOP in this
>> branch.
> 
> Ugh, that really hits home how ugly this CQE32 support was.
> 
> Dammit, it shouldn't have been done this way. That io_nop() code is
> disgusting, and how it wants that separate "with extra info" case is
> just nasty.
> 
> I've pulled this, but with some swearing. That whole "extra1" and
> "extra2" is ugly as hell, and just the naming shows that it has no
> sane semantics, much less documentation.
> 
> And the way it's randomly hidden in 'struct io_nop' *and* then a union
> with that hash_node is just disgusting beyond words. Why do you need
> both fields when you just copy one to the other at cmd start and then
> back at cmd end?
> 
> I must be missing something, but that it is incredibly ugly is clear.

I think you are! The NOP case is just a sample way of exercising the
CQE32 support, with extra1+2 being what is passed back in the bigger
CQE. The NOP command exists purely to test things, and the CQE32 support
there is a bit forced because NOP just always completes with '0' in the
normal res field.

We can obviously dump this as it isn't integral to anything, and
honestly now that the NVMe is wired up, there's no great need to have a
separate test for it. But it doesn't really hurt and there are already
regression tests for it.

-- 
Jens Axboe

