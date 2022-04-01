Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5304EE5A6
	for <lists+io-uring@lfdr.de>; Fri,  1 Apr 2022 03:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243726AbiDABYZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 31 Mar 2022 21:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243725AbiDABYY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 31 Mar 2022 21:24:24 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA45F21D7DF
        for <io-uring@vger.kernel.org>; Thu, 31 Mar 2022 18:22:36 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id o3-20020a17090a3d4300b001c6bc749227so1110660pjf.1
        for <io-uring@vger.kernel.org>; Thu, 31 Mar 2022 18:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JqzlBlmuscHVnNnPYh/b4FXO/hWZSCec4wgmjvC92Jo=;
        b=RVEsEQROdKrOtmuldgRa/PvAwe+jXLwDuENO6CLXw/FiINEJ2W3a0yi0925jx/MLia
         4RQiMO0g09YbbYmNnKMEqiiIA3fgP4bxLn2aCN8W/+gZANXPCAO64tzDgahR17mX/FPC
         8deLSNbM1nINSB9O+Zt3W8QmiEMN+WPmndJe7BYCuL2wMiOOzuN8AuV5gZJZKcr+vaCM
         Sf0UuNxnbI891NPM5xo1i4N4sVk8KAECSNaO9rKpQI4uvt2MJrzFA3ghdNh3ARmXwiiR
         24V0782Tbleh3JOkq6yUsnpH9gZoCjRZsyQGK5hWY77UAxGHyhEPMTaAaeBAwMke3ST/
         8xuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JqzlBlmuscHVnNnPYh/b4FXO/hWZSCec4wgmjvC92Jo=;
        b=1wHfBFW6OIzTQG/uChiCBNRNTkhT0s6WEc8/dPP96HC9Ypn4f5rZCBt0KWEnc8aZ+T
         I4JKt/PtjO7XYvc1hgum5B6eCD9g9TinFOCClhxZM/HB6eo7VNP/qjcsESkIv3e6XsMv
         MHVP850tl81upxs7fxCI9LsJMDzAp/cAf0mYblHmlRenl41vMnLgsXAnmFtiIezujmhi
         SLCEwD06+mXk0Ct4M/9rDD/P8PWtSYVFpnNL5ZB0i7lwiFtn5aSEpIHyaOAfw1gS/l86
         TrqJWNlYkH2W4RvtPLtIxJyuIuO1G1sLhHdOpAZTW5S1AcN6J4WDSKSfI5q3we+jliH/
         c23g==
X-Gm-Message-State: AOAM531ZZl5afLEBvp81Ov87wfT3JVR1iz+c+WzwRPkKykEs6QitGdeh
        mLpvNw/t0Gnd5DLbjqSgrMUMww==
X-Google-Smtp-Source: ABdhPJwoohPEsfOaUYXtn0uGcWPKVWgHksrPhLg73D4Ij9RANYSEV1jYZJzcq4SC73s2yoUDnieM0Q==
X-Received: by 2002:a17:902:6845:b0:153:9af1:3134 with SMTP id f5-20020a170902684500b001539af13134mr44235505pln.169.1648776156095;
        Thu, 31 Mar 2022 18:22:36 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d23-20020a17090a02d700b001bf6ef9daafsm530640pjd.38.2022.03.31.18.22.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Mar 2022 18:22:35 -0700 (PDT)
Message-ID: <910afdf8-ec01-90b2-b7ec-a7644e53259e@kernel.dk>
Date:   Thu, 31 Mar 2022 19:22:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 17/17] nvme: enable non-inline passthru commands
Content-Language: en-US
To:     Kanchan Joshi <joshiiitr@gmail.com>, Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        Keith Busch <kbusch@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, Pankaj Raghav <pankydev8@gmail.com>,
        =?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier@javigon.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
References: <20220308152105.309618-1-joshi.k@samsung.com>
 <CGME20220308152729epcas5p17e82d59c68076eb46b5ef658619d65e3@epcas5p1.samsung.com>
 <20220308152105.309618-18-joshi.k@samsung.com>
 <20220310083652.GF26614@lst.de>
 <CA+1E3rLaQstG8LWUyJrbK5Qz+AnNpOnAyoK-7H5foFm67BJeFA@mail.gmail.com>
 <20220310141945.GA890@lst.de>
 <CA+1E3rL3Q2noHW-cD20SZyo9EqbzjF54F6TgZoUMMuZGkhkqnw@mail.gmail.com>
 <20220311062710.GA17232@lst.de>
 <CA+1E3rLGwHFbdbSTJBfWrw6RLErwcT2zPxGmmWbcLUj2y=16Qg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CA+1E3rLGwHFbdbSTJBfWrw6RLErwcT2zPxGmmWbcLUj2y=16Qg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/22/22 11:10 AM, Kanchan Joshi wrote:
>> We need to decouple the
>> uring cmd properly.  And properly in this case means not to add a
>> result pointer, but to drop the result from the _input_ structure
>> entirely, and instead optionally support a larger CQ entry that contains
>> it, just like the first patch does for the SQ.
> 
> Creating a large CQE was my thought too. Gave that another stab.
> Dealing with two types of CQE felt nasty to fit in liburing's api-set
> (which is cqe-heavy).
> 
> Jens: Do you already have thoughts (go/no-go) for this route?

Yes, I think we should just add support for 32-byte CQEs as well. Only
pondering I've done here is if it makes sense to manage them separately,
or if you should just get both big sqe and cqe support in one setting.
For passthrough, you'd want both. But eg for zoned writes, you can make
do with a normal sized sqes and only do larger cqes.

I did actually benchmark big sqes in peak testing, and found them to
perform about the same, no noticeable difference. Which does make sense,
as normal IO with big sqe would only touch the normal sized sqe and
leave the other one unwritten and unread. Since they are cacheline
sized, there's no extra load there.

For big cqes, that's a bit different and I'd expect a bit of a
performance hit for that. We can currently fit 4 of them into a
cacheline, with the change it'd be 2. The same number of ops/sec would
hence touch twice as many cachelines for completions.

But I still think it's way better than having to copy back part of the
completion info out-of-band vs just doing it inline, and it's more
efficient too for that case for sure.

> From all that we discussed, maybe the path forward could be this:
> - inline-cmd/big-sqe is useful if paired with big-cqe. Drop big-sqe
> for now if we cannot go the big-cqe route.

We should go big cqe for sure, it'll help clean up a bunch of things
too.

-- 
Jens Axboe

