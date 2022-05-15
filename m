Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 930CE527926
	for <lists+io-uring@lfdr.de>; Sun, 15 May 2022 20:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238125AbiEOSep (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 May 2022 14:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238123AbiEOSeo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 May 2022 14:34:44 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3294CDED2;
        Sun, 15 May 2022 11:34:43 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id EBFF93200972;
        Sun, 15 May 2022 14:34:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 15 May 2022 14:34:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=living180.net;
         h=cc:cc:content-transfer-encoding:content-type:date:date:from
        :from:in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1652639679; x=
        1652726079; bh=1tqwKGxvROapik2SZuXrpiyKuwJSO346wMqf0Svvi3s=; b=V
        7RDZwhnjNHoUl+SnGUB32icJcjYPZerNpiRLx0H0J4qKV5OKbJqag1s4EIRoZxHV
        CfMVNMNwUBnm97fepkMdA0HrJpjZO7b+963bC3IHDeXsfqPd9xIcGPz1YjqOYGJ/
        iV1i41LwsH17UiEnaF/NJC+WZdwkWNt7vvJrFPYY5A80iaGvkBohVwza6QKqwCWc
        1ZUvQabiLMvx7Vmbnyqg/HdlX62VL6WllbBQBhYPy+57Jx0iimnV8vzpBWorflFK
        G2OUbsJA5ZM2qCdAVjcDGIj6eaYFZlBwnYzj9+gTTIQuGAyACO25YeGiM1QpCp3l
        B3C8MkyhnjPiWVTowhLeA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1652639679; x=1652726079; bh=1tqwKGxvROapi
        k2SZuXrpiyKuwJSO346wMqf0Svvi3s=; b=n3ic4cjP6oMiDgJdmmVbSY8k/m0kA
        4YNNyMu1sJW0h05D3IRB1pFtBTP1rQ6apKZipklWVkjAQGopz1iU9ilUFIWvs6fr
        YW3VmxDqMbllzJn8VpyiiskW3eBwLCE2Fkni3p5UK4fmYbFzWWM0V+iTgOB+Pd9S
        K2aJrCN0KxAn3ZwWTBX5opXDqW8oJ3FzUp7+FqLgdhzNB5mPYyoj/CBKBoNVZVh/
        z1z8MxoC6ASta1b8kZxv2RZu2yXUdYEwmWj77WDkmSQ91YgHT/fNXHfvEPXAhGBz
        mtAVMmAmK/c4E/FNSHuh7foEiYbdRQMiT9wAcYfdGwBuO5quyfEG2c1IA==
X-ME-Sender: <xms:v0eBYsIfaVvZk9-p92ok4U9D1VcTpvJHm5Ybel9K7ctUD9u1N8_GjQ>
    <xme:v0eBYsLtGCnU-yaix8LDlhCm8E6b7R0S9N-6020bHsB8B6qRVR_6bfvgb-jkpoM0R
    5Oshu6TQfNoVQ>
X-ME-Received: <xmr:v0eBYsvfcUc1qHAzUpnImPm9M5rbYQr06CJbltm65e_DmSRn04RktysGwzsuXA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrheefgdduvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtfeejnecuhfhrohhmpeffrghn
    ihgvlhcujfgrrhguihhnghcuoeguhhgrrhguihhngheslhhivhhinhhgudektddrnhgvth
    eqnecuggftrfgrthhtvghrnhepfeffjeejffegffeuveekkeffiefghefhtefgvdehveei
    geeuffegfeeileeihfevnecuffhomhgrihhnpehgihhthhhusgdrtghomhenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpeguhhgrrhguihhnghes
    lhhivhhinhhgudektddrnhgvth
X-ME-Proxy: <xmx:v0eBYpYXlFjste4YbVDcId4VSJU9xrVLvYB5K2qWAUyOKXm3LcrbMw>
    <xmx:v0eBYjaTytIVPidYr_e97rcrPH7LbcIkfsZ2VC2deOx_78mikvGKhQ>
    <xmx:v0eBYlDOMcsiBwEDgQkdH5B4bCYaK1HvhtV7j-ZQFJQITIwOSvaONQ>
    <xmx:v0eBYiU1C2drFgFPbULENOUedaFvnOnM2N61BfwvhKIRNW2D5IDrHw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 15 May 2022 14:34:37 -0400 (EDT)
Message-ID: <c2f956e2-b235-9937-d554-424ae44c68e4@living180.net>
Date:   Sun, 15 May 2022 21:34:35 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [REGRESSION] lxc-stop hang on 5.17.x kernels
Content-Language: en-US
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     regressions@lists.linux.dev, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <7925e262-e0d4-6791-e43b-d37e9d693414@living180.net>
 <6ad38ecc-b2a9-f0e9-f7c7-f312a2763f97@kernel.dk>
 <ccf6cea1-1139-cd73-c4e5-dc9799708bdd@living180.net>
 <bb283ff5-6820-d096-2fca-ae7679698a50@kernel.dk>
 <371c01dd-258c-e428-7428-ff390b664752@kernel.dk>
 <2436d42c-85ca-d060-6508-350c769804f1@gmail.com>
 <ad9c31e5-ee75-4df2-c16d-b1461be1901a@living180.net>
 <fb0dbd71-9733-0208-48f2-c5d22ed17510@gmail.com>
 <a204ba93-7261-5c6e-1baf-e5427e26b124@living180.net>
 <bd932b5a-9508-e58f-05f8-001503e4bd2b@gmail.com>
 <12a57dd9-4423-a13d-559b-2b1dd2fb0ef3@living180.net>
 <897dc597-fc0a-34ec-84b8-7e1c4901e0fc@leemhuis.info>
From:   Daniel Harding <dharding@living180.net>
In-Reply-To: <897dc597-fc0a-34ec-84b8-7e1c4901e0fc@leemhuis.info>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/15/22 11:20, Thorsten Leemhuis wrote:
> On 04.05.22 08:54, Daniel Harding wrote:
>> On 5/3/22 17:14, Pavel Begunkov wrote:
>>> On 5/3/22 08:37, Daniel Harding wrote:
>>>> [Resend with a smaller trace]
>>>> On 5/3/22 02:14, Pavel Begunkov wrote:
>>>>> On 5/2/22 19:49, Daniel Harding wrote:
>>>>>> On 5/2/22 20:40, Pavel Begunkov wrote:
>>>>>>> On 5/2/22 18:00, Jens Axboe wrote:
>>>>>>>> On 5/2/22 7:59 AM, Jens Axboe wrote:
>>>>>>>>> On 5/2/22 7:36 AM, Daniel Harding wrote:
>>>>>>>>>> On 5/2/22 16:26, Jens Axboe wrote:
>>>>>>>>>>> On 5/2/22 7:17 AM, Daniel Harding wrote:
>>>>>>>>>>>> I use lxc-4.0.12 on Gentoo, built with io-uring support
>>>>>>>>>>>> (--enable-liburing), targeting liburing-2.1.  My kernel
>>>>>>>>>>>> config is a
>>>>>>>>>>>> very lightly modified version of Fedora's generic kernel
>>>>>>>>>>>> config. After
>>>>>>>>>>>> moving from the 5.16.x series to the 5.17.x kernel series, I
>>>>>>>>>>>> started
>>>>>>>>>>>> noticed frequent hangs in lxc-stop.  It doesn't happen 100%
>>>>>>>>>>>> of the
>>>>>>>>>>>> time, but definitely more than 50% of the time. Bisecting
>>>>>>>>>>>> narrowed
>>>>>>>>>>>> down the issue to commit
>>>>>>>>>>>> aa43477b040251f451db0d844073ac00a8ab66ee:
>>>>>>>>>>>> io_uring: poll rework. Testing indicates the problem is still
>>>>>>>>>>>> present
>>>>>>>>>>>> in 5.18-rc5. Unfortunately I do not have the expertise with the
>>>>>>>>>>>> codebases of either lxc or io-uring to try to debug the problem
>>>>>>>>>>>> further on my own, but I can easily apply patches to any of the
>>>>>>>>>>>> involved components (lxc, liburing, kernel) and rebuild for
>>>>>>>>>>>> testing or
>>>>>>>>>>>> validation.  I am also happy to provide any further
>>>>>>>>>>>> information that
>>>>>>>>>>>> would be helpful with reproducing or debugging the problem.
>>>>>>>>>>> Do you have a recipe to reproduce the hang? That would make it
>>>>>>>>>>> significantly easier to figure out.
>>>>>>>>>> I can reproduce it with just the following:
>>>>>>>>>>
>>>>>>>>>>       sudo lxc-create --n lxc-test --template download --bdev
>>>>>>>>>> dir --dir /var/lib/lxc/lxc-test/rootfs -- -d ubuntu -r bionic
>>>>>>>>>> -a amd64
>>>>>>>>>>       sudo lxc-start -n lxc-test
>>>>>>>>>>       sudo lxc-stop -n lxc-test
>>>>>>>>>>
>>>>>>>>>> The lxc-stop command never exits and the container continues
>>>>>>>>>> running.
>>>>>>>>>> If that isn't sufficient to reproduce, please let me know.
>>>>>>>>> Thanks, that's useful! I'm at a conference this week and hence have
>>>>>>>>> limited amount of time to debug, hopefully Pavel has time to
>>>>>>>>> take a look
>>>>>>>>> at this.
>>>>>>>> Didn't manage to reproduce. Can you try, on both the good and bad
>>>>>>>> kernel, to do:
>>>>>>> Same here, it doesn't reproduce for me
>>>>>> OK, sorry it wasn't something simple.
>>>>>>> # echo 1 > /sys/kernel/debug/tracing/events/io_uring/enable
>>>>>>>> run lxc-stop
>>>>>>>>
>>>>>>>> # cp /sys/kernel/debug/tracing/trace ~/iou-trace
>>>>>>>>
>>>>>>>> so we can see what's going on? Looking at the source, lxc is just
>>>>>>>> using
>>>>>>>> plain POLL_ADD, so I'm guessing it's not getting a notification
>>>>>>>> when it
>>>>>>>> expects to, or it's POLL_REMOVE not doing its job. If we have a
>>>>>>>> trace
>>>>>>>> from both a working and broken kernel, that might shed some light
>>>>>>>> on it.
>>>>>> It's late in my timezone, but I'll try to work on getting those
>>>>>> traces tomorrow.
>>>>> I think I got it, I've attached a trace.
>>>>>
>>>>> What's interesting is that it issues a multi shot poll but I don't
>>>>> see any kind of cancellation, neither cancel requests nor task/ring
>>>>> exit. Perhaps have to go look at lxc to see how it's supposed
>>>>> to work
>>>> Yes, that looks exactly like my bad trace.  I've attached good trace
>>>> (captured with linux-5.16.19) and a bad trace (captured with
>>>> linux-5.17.5).  These are the differences I noticed with just a
>>>> visual scan:
>>>>
>>>> * Both traces have three io_uring_submit_sqe calls at the very
>>>> beginning, but in the good trace, there are further
>>>> io_uring_submit_sqe calls throughout the trace, while in the bad
>>>> trace, there are none.
>>>> * The good trace uses a mask of c3 for io_uring_task_add much more
>>>> often than the bad trace:  the bad trace uses a mask of c3 only for
>>>> the very last call to io_uring_task_add, but a mask of 41 for the
>>>> other calls.
>>>> * In the good trace, many of the io_uring_complete calls have a
>>>> result of 195, while in the bad trace, they all have a result of 1.
>>>>
>>>> I don't know whether any of those things are significant or not, but
>>>> that's what jumped out at me.
>>>>
>>>> I have also attached a copy of the script I used to generate the
>>>> traces.  If there is anything further I can to do help debug, please
>>>> let me know.
>>> Good observations! thanks for traces.
>>>
>>> It sounds like multi-shot poll requests were getting downgraded
>>> to one-shot, which is a valid behaviour and was so because we
>>> didn't fully support some cases. If that's the reason, than
>>> the userspace/lxc is misusing the ABI. At least, that's the
>>> working hypothesis for now, need to check lxc.
>> So, I looked at the lxc source code, and it appears to at least try to
>> handle the case of multi-shot being downgraded to one-shot.  I don't
>> know enough to know if the code is actually correct however:
>>
>> https://github.com/lxc/lxc/blob/7e37cc96bb94175a8e351025d26cc35dc2d10543/src/lxc/mainloop.c#L165-L189
>> https://github.com/lxc/lxc/blob/7e37cc96bb94175a8e351025d26cc35dc2d10543/src/lxc/mainloop.c#L254
>> https://github.com/lxc/lxc/blob/7e37cc96bb94175a8e351025d26cc35dc2d10543/src/lxc/mainloop.c#L288-L290
> Hi, this is your Linux kernel regression tracker. Nothing happened here
> for round about ten days now afaics; or did the discussion continue
> somewhere else.
>
>  From what I gathered from this discussion is seems the root cause might
> be in LXC, but it was exposed by kernel change. That makes it sill a
> kernel regression that should be fixed; or is there a strong reason why
> we should let this one slip?

No, there hasn't been any discussion since the email you replied to.  
I've done a bit more testing on my end, but without anything 
conclusive.  The one thing I can say is that my testing shows that LXC 
does correctly handle multi-shot poll requests which were being 
downgraded to one-shot in 5.16.x kernels, which I think invalidates 
Pavel's theory.  In 5.17.x kernels, those same poll requests are no 
longer being downgraded to one-shot requests, and thus under 5.17.x LXC 
is no longer re-arming those poll requests (but also shouldn't need to, 
according to what is being returned by the kernel).  I don't know if 
this change in kernel behavior is related to the hang, or if it is just 
a side effect of other io-uring changes that made it into 5.17.  Nothing 
in the LXC's usage of io-uring seems obviously incorrect to me, but I am 
far from an expert.  I also did some work toward creating a simpler 
reproducer, without success (I was able to get a simple program using 
io-uring running, but never could get it to hang).  ISTM that this is 
still a kernel regression, unless someone can point out a definite fault 
in the way LXC is using io-uring.

-- 
Regards,

Daniel Harding
