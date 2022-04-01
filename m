Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 164304EE5AD
	for <lists+io-uring@lfdr.de>; Fri,  1 Apr 2022 03:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243725AbiDAB1D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 31 Mar 2022 21:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243203AbiDAB1C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 31 Mar 2022 21:27:02 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0EB419B2
        for <io-uring@vger.kernel.org>; Thu, 31 Mar 2022 18:25:14 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id m18so1168181plx.3
        for <io-uring@vger.kernel.org>; Thu, 31 Mar 2022 18:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=R1dhsfiSnHarafc+SmeCxyhyUIwSltgVfiy2Auaw7XY=;
        b=fQMNa0zR50WmR1S4nBEbfURpZV/PZqj5G/FooiuFfLFx/oSbL6TAO1RmchiopvRUYc
         lRutC+dyKymrdUYXiFz6oX5FW2enISjhKnXTxnce9fBUgsU2EzJ2JAxcy94OjJZyD7sn
         OnK9u+Vn1G6BrK1XubK95JXY7dYXcCOVZn8tDWtT9bGxFbjiE7ajdEO8gV9DYlXdhxnI
         8amhNJFaBdkbukTk88vIooQWmT1w9MMPtDeNAyTG05/fQvSMr3mErWuw4Msdxd6KU2ZO
         3TXMrtiJukjn6feeJpgztxBaTZtHEokjO3ECTzfJLk03IuiGfrbVqMmOuFvfxae+Wy06
         foBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=R1dhsfiSnHarafc+SmeCxyhyUIwSltgVfiy2Auaw7XY=;
        b=Z/9kW4rEDjfSxtiBzAFaDc39xhT/+rlNDy/VnNBBUuKY+nkWWySSqvdpKImMDiFL5/
         4RIq21MuMGOXolC5CrO3RXN80L5k4Gpkm/6oIhKzoIMPwmQxAMNBDYvJ4rCvtvPkaTUv
         dmcN6WB5Y9UPPQ3yWONtBcnJ5l51Klqc9VhtZxyb3Q1h1kHHF16bvmDoUaOCglp2A18b
         R80P3wZV2OyOerRe2fSIEbKaIo1qDsPx1USw5tzZ0YwWdg2XXqUfynPjF3ytfG93xnp3
         60Ed3Qt7vGDTZea9wqJP5oI7A6E8Qhw/qGdLxadSwiWkCtQDIvLaztmqwE+dr3krz/Q3
         4mtA==
X-Gm-Message-State: AOAM533lQl+tZ0jhGV1wtEroKN/SrS31DVXj/jNAtu3IhF9aqeVPA41p
        E4iMPFCeDh19DsQymni3LlwHUg==
X-Google-Smtp-Source: ABdhPJy8855lS5pun2goImSU2Yk45LqwFkuwCtNplt7chwm3MS44jEbh+GGvioT7BUI4sTCb+BnA2Q==
X-Received: by 2002:a17:902:f551:b0:153:b179:291a with SMTP id h17-20020a170902f55100b00153b179291amr43675464plf.13.1648776313690;
        Thu, 31 Mar 2022 18:25:13 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d16-20020a056a00245000b004f771b48736sm700240pfj.194.2022.03.31.18.25.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Mar 2022 18:25:13 -0700 (PDT)
Message-ID: <a44e38d6-54b4-0d17-c274-b7d46f60a0cf@kernel.dk>
Date:   Thu, 31 Mar 2022 19:25:11 -0600
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
References: <CGME20220308152729epcas5p17e82d59c68076eb46b5ef658619d65e3@epcas5p1.samsung.com>
 <20220308152105.309618-18-joshi.k@samsung.com>
 <20220310083652.GF26614@lst.de>
 <CA+1E3rLaQstG8LWUyJrbK5Qz+AnNpOnAyoK-7H5foFm67BJeFA@mail.gmail.com>
 <20220310141945.GA890@lst.de>
 <CA+1E3rL3Q2noHW-cD20SZyo9EqbzjF54F6TgZoUMMuZGkhkqnw@mail.gmail.com>
 <20220311062710.GA17232@lst.de>
 <CA+1E3rLGwHFbdbSTJBfWrw6RLErwcT2zPxGmmWbcLUj2y=16Qg@mail.gmail.com>
 <20220324063218.GC12660@lst.de> <20220325133921.GA13818@test-zns>
 <20220330130219.GB1938@lst.de>
 <CA+1E3r+Z9UyiNjmb-DzOpNrcbCO_nNFYUD5L5xJJCisx_D=wPQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CA+1E3r+Z9UyiNjmb-DzOpNrcbCO_nNFYUD5L5xJJCisx_D=wPQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/30/22 7:14 AM, Kanchan Joshi wrote:
> On Wed, Mar 30, 2022 at 6:32 PM Christoph Hellwig <hch@lst.de> wrote:
>>
>> On Fri, Mar 25, 2022 at 07:09:21PM +0530, Kanchan Joshi wrote:
>>> Ok. If you are open to take new opcode/struct route, that is all we
>>> require to pair with big-sqe and have this sorted. How about this -
>>
>> I would much, much, much prefer to support a bigger CQE.  Having
>> a pointer in there just creates a fair amount of overhead and
>> really does not fit into the model nvme and io_uring use.
> 
> Sure, will post the code with bigger-cqe first.

I can add the support, should be pretty trivial. And do the liburing
side as well, so we have a sane base.

Then I'd suggest to collapse a few of the patches in the series,
the ones that simply modify or fix gaps in previous ones. Order
the series so we build the support and then add nvme support
nicely on top of that.

I'll send out a message on a rebase big sqe/cqe branch, will do
that once 5.18-rc1 is released so we can get it updated to a
current tree as well.

-- 
Jens Axboe

