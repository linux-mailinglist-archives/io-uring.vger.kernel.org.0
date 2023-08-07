Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF1D772DC9
	for <lists+io-uring@lfdr.de>; Mon,  7 Aug 2023 20:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjHGSXo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Aug 2023 14:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbjHGSXl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Aug 2023 14:23:41 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE30198D
        for <io-uring@vger.kernel.org>; Mon,  7 Aug 2023 11:23:10 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-6873f64a290so1339732b3a.0
        for <io-uring@vger.kernel.org>; Mon, 07 Aug 2023 11:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691432588; x=1692037388;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ScWOr6i/mZ/hSL9XJnUZEAFH7lnK6qsqFipDwCZSrAo=;
        b=g05XxFNT+jxKL5KyU8W8HOcjptr7ey8e/As+wsWSrixnl3qq5bvA4TR4nQNoHR0bqN
         HtLDD4+NfQIdw4BnqqQq+94pNG4IEPcmesY8XtQnnUEQsrrF4IVulde6E56RdWm6rKMo
         dWvFbObkocQI5Uesfu7zs3g4wuMI/vCWzQtsUxigiv74zUd5ulWR63gn9h+S1ozChZS9
         PvfjbXgOx6SNTG/Ed4RAS+aTg8rKKZCt4rcj7aHGCj2DGVb2ThdEkH+8I+3lne8uiaFl
         ZFl0R175fxXl8Jw+87bekGxNkDliwmpSkI2ul1I++E/W+vsu9LRaBwjG7hbFTkQxoINF
         v9rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691432588; x=1692037388;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ScWOr6i/mZ/hSL9XJnUZEAFH7lnK6qsqFipDwCZSrAo=;
        b=ZZ7Pe97ZXw5ZiUMIFScX1KTD4C5IB6ULLKgEEUHA8M7Al6nf1xVubUVx7FmoAMGJho
         9fJqr+4EaGUtnoewGPc2x5ZA5EqICWOteZGEoVRqb+ApfBV7Bpv96ToGWbCh1Cm9t/3n
         4qyaj/2g5At77w36cXVyO28eZFDKUHROzbuqZRzil5GYFeEwfH9+ZTEsQ+hAzfFMZbF4
         Y+FUNRUNx2JvTEa7H6zhtVla4HtIHKcBlo4/kNWoKdTEOds+k6EE9tQeskwJymIYdrmt
         PtqFWQQ1ZhNoc3lTZ9RDePv2kATbqj2eJkTP7xo+VeW3cnKvQ69xw2H/xl3qf0HF5/VJ
         3kng==
X-Gm-Message-State: ABy/qLZ5qvNwMgeNT56WkBf04VN/NXh4iKBrteM6UMt4TJCrrgMVcua1
        tiGMF0vjh/UjmYNrf3yRL26Bgg==
X-Google-Smtp-Source: APBJJlGwsySKIXv1+2gPzF29mUmj8i9i9dwO+hZQQzKaWsEKfMdcXbUrNxJEgG5i9zM+bRr2kyLv4A==
X-Received: by 2002:a17:902:e80e:b0:1b8:35fa:cdcc with SMTP id u14-20020a170902e80e00b001b835facdccmr33721837plg.5.1691432588424;
        Mon, 07 Aug 2023 11:23:08 -0700 (PDT)
Received: from [172.16.7.55] ([12.221.160.50])
        by smtp.gmail.com with ESMTPSA id p18-20020a170902ead200b001b89045ff03sm7214431pld.233.2023.08.07.11.23.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Aug 2023 11:23:07 -0700 (PDT)
Message-ID: <9153c0bf-405b-7c16-d26c-12608a02ee29@kernel.dk>
Date:   Mon, 7 Aug 2023 12:23:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCHSET v4] Add io_uring futex/futexv support
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de
References: <20230728164235.1318118-1-axboe@kernel.dk> <87jzugnjzy.ffs@tglx>
 <e136823c-b5c9-b6b3-a0e2-7e9cfda2b2d8@kernel.dk> <875y5rmyqi.ffs@tglx>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <875y5rmyqi.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/6/23 7:23?PM, Thomas Gleixner wrote:
> Jens!
> 
> On Sun, Aug 06 2023 at 10:44, Jens Axboe wrote:
>> On 7/31/23 10:06?AM, Thomas Gleixner wrote:
>>> Can you please just wait until the futex core bits have been agreed on
>>> and merged? No need to contribute more mess in everyones inbox.
>>
>> Also no need to keep dragging out the review of the other bits. The
>> dependency is only there so we can use FUTEX2 flags for this - which
>> does make sense to me, but we should probably split Peter's series in
>> two as there's no dependency on the functional bits on that patch
>> series. As we're getting ever closer to the merge window, and I have
>> other things sitting on top of the futex series, that's problematic for
>> me.
> 
> Seriously?
> 
> You are still trying to sell me "Features first - corrrectness
> later/never"?

That's not what I'm saying at all. I wrote these patches 3 months ago,
and like I mentioned, I think doing the futex2 flags for that side is a
good suggestion from Peter. As those initial prep patches are all these
require, rather than the full futex2 series, there's no reason not to
review these at the same time too, if people should be so inclined.

> Go and look at the amount of fallout this has caused in the last years.
> io-urine is definitely the leader of the pack in my security@kernel.org
> inbox.

We're now resorting to name calling? Sorry, but I think that's pretty
low and not very professional.

> Vs. the problem at hand. I've failed to catch a major issue with futex
> patches in the past and I'm not seeing any reason to rush any of this to
> repeat the experience just because.

I'm not asking anyone to rush anything.

> You know very well that your whatever depends on this series has to wait
> until the basics are sorted and there is absolutely no reason that your
> so important things have to be rushed into the next merge window.

Again, you're making assumptions.

> It surely makes sense to split these things up into independent series,
> but _you_ could have done that weeks ago instead of just reposting an
> umodified and unreviewed RFC series from Peter and then coming out now
> and complaining about the lack of progress.

It's Peter's series, I'm not going to split his series and step on his
toes. I already separately tested, and will do so with the updated
series as well when I get back, since I saw he posted one.

-- 
Jens Axboe

