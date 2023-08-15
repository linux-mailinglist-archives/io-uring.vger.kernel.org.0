Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2659077C572
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 03:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233819AbjHOBvx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Aug 2023 21:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234124AbjHOBvu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Aug 2023 21:51:50 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3B4BE
        for <io-uring@vger.kernel.org>; Mon, 14 Aug 2023 18:51:48 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-6874a386ec7so984164b3a.1
        for <io-uring@vger.kernel.org>; Mon, 14 Aug 2023 18:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1692064308; x=1692669108;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gjJh1H6n4HDecJO/e4d6N0EBFkimFhhLQvDqvGPNpQQ=;
        b=LLXTK5hD/cetcRfc0dOsWHwgmrWHc72x9/RLAd16QZjkeX4oOo8TS+pw7iSWaDkQJu
         KOMKooP69Y/2WiI38vhm6o1bM1mGB6HXo/O9uSSCw46Dfy9kjMUcW4Cr0gMWbtwP/L73
         O/Ju3kaDs2E/dd1a5SvTdqZBVH4HNqP2TnEVNCBgvEQdyEj0EuHP2RuNF6ETsSKWo311
         9qNzLiUKXcCraYt5qd3/tmdqc9iuv2FdWizO2WZuz7184oIQZT/9Ws/d6aQv9WPbj0xS
         LABSRhkRlevzyXRiiZCVpdzrTqgEdtr49PvNgHk0HRgR0ONjNr93V5qisFDcfz33w0Rz
         CDJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692064308; x=1692669108;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gjJh1H6n4HDecJO/e4d6N0EBFkimFhhLQvDqvGPNpQQ=;
        b=awOW+JqSJoGGTuJoS+jIgHcqtjbB/KDx3MtlwRaJ0Bw6BcF/wdlk7kvEr7Tg3+ViDn
         GLVVOlfihfb2Rv1OeARnQ1Sk1uvm/gxXKlIkxvYUjFJlu2rBKcQURVKFzk5pLFhi8+O3
         Pbbjs0TIwaT/YJH4potklgpDBS+AD1YZPrcRf4TQfS/46IeR9DQ372Ae7CKRAX9QDetM
         Ek0fnUPc+ckOfOaHpIZrAALQl0ASTK0ze3FmUuLNJdLGBw+nQeHTGm7zSJTOnG4lmBAi
         iPy6f8KnmzLhEDSnzRt4mM5/ClWcz/SNBmk08lub+a2pAUvduYMyQmCBNylmIKXXBgLZ
         3wLg==
X-Gm-Message-State: AOJu0YxCE02n0iFWn43YE7OJao+Y1WlMfLF9jGL7FUp3FO/BIxIKi80F
        WZotHnYm+xsMXtuMrcOYo8pQRA==
X-Google-Smtp-Source: AGHT+IG4ucQC4hM9rpUVd+0XSHyHpYDeNAJaZPYaZazhXrh/yZcCvSw9jKvL2m+bXRt4Z4gD+FwQvA==
X-Received: by 2002:a17:902:e54f:b0:1b3:d8ac:8db3 with SMTP id n15-20020a170902e54f00b001b3d8ac8db3mr13288794plf.6.1692064308278;
        Mon, 14 Aug 2023 18:51:48 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m11-20020a170902768b00b001bb750189desm10102601pll.255.2023.08.14.18.51.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 18:51:47 -0700 (PDT)
Message-ID: <5a7738df-9a4c-47d1-beea-b2b50d5cef19@kernel.dk>
Date:   Mon, 14 Aug 2023 19:51:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET v4] Add io_uring futex/futexv support
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de
References: <20230728164235.1318118-1-axboe@kernel.dk> <87jzugnjzy.ffs@tglx>
 <e136823c-b5c9-b6b3-a0e2-7e9cfda2b2d8@kernel.dk> <875y5rmyqi.ffs@tglx>
 <9153c0bf-405b-7c16-d26c-12608a02ee29@kernel.dk> <87y1idgo3j.ffs@tglx>
 <bda49491-4d7f-485f-b929-87a4bec6efaa@kernel.dk> <87v8dhgmhc.ffs@tglx>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87v8dhgmhc.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/14/23 6:47 PM, Thomas Gleixner wrote:
> On Mon, Aug 14 2023 at 18:18, Jens Axboe wrote:
>> On 8/14/23 6:12 PM, Thomas Gleixner wrote:
> 
>>>> We're now resorting to name calling? Sorry, but I think that's pretty
>>>> low and not very professional.
>>>
>>> I'm not resorting to that. If you got offended by the meme which
>>> happened to elapse into my reply, then I can definitely understand
>>> that. That was not my intention at all. But you might think about why
>>> that meme exists in the first place.
>>
>> It's been there since day 1 because a) the spelling is close, and b)
>> some people are just childish. Same reason kids in the 3rd grade come up
>> with nicknames for each others. And that's fine, but most people grow
>> out of that, and it certainly has no place in what is supposedly a
>> professional setting.
> 
> Sure. Repeat that as often you want. I already made clear in my reply
> that this was unintentional, no?

Wasn't clear to me, and your repeated undertones don't help either.

> Though the fact that this "rush the feature" ends up in my security
> inbox more than justified has absolutely nothing to do with my
> potentially childish and non-professionl attitude, right?

I've already made it clear that nothing is being rushed, yet you keep
harping on that. It was in my reply, again, though you gracefully
ignored that, again.

Have we had security issues? For sure, and more than I would've liked.
By far most of that is for old kernels, not the current code base. We've
made good progress getting that migrated back, and it's always top of
the mind when developing new features. If you think I don't take this
seriously, then you are ignorant, and suggesting otherwise is slander.
And since it's apparently a big problem in your inbox, you will have
undoubtedly also seen that we've always been handling these well and
expediently.

-- 
Jens Axboe

