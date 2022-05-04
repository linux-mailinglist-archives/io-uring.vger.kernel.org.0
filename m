Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2E05197B0
	for <lists+io-uring@lfdr.de>; Wed,  4 May 2022 08:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiEDG7W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 May 2022 02:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345211AbiEDG62 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 May 2022 02:58:28 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A636D21E3B;
        Tue,  3 May 2022 23:54:17 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 3872A5C006E;
        Wed,  4 May 2022 02:54:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 04 May 2022 02:54:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=living180.net;
         h=cc:cc:content-transfer-encoding:content-type:date:date:from
        :from:in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1651647255; x=
        1651733655; bh=JEqrpWsOY9RdcvSTc4MYhkThrGU1N4YgK93BL3bHbPE=; b=c
        F3yMJkgUEYFeUdLTCk2bGdHLlYlCFHTImxZqwXzz/CR7BSDiUn4GqfRDHWYF7ltc
        0J/U5vbn5PD/98NcyUS40xyVNHKBKTIfG3VD/H4k7oYK/hErljYKXM/sYvIKgQn8
        i6tgpwSXj3gapirV7N6P/0KeBVWOEGrcvTYgF38zxFI4bH43noo/NwOqsP/E7ao+
        nGpmjt0diqA7xSUdMUdp/WDhzFeoDvMqBBofHBAzUmUAs/aRlwNTDTTTA0ohF5fq
        IWjDwjQuFb27pQlnjstMYwqDYqhcBcvBQiTHuzVDqyR8ovvHFarK3poyc9KF+qJy
        lLy4uRKQ7+pylKiKuevMg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1651647255; x=1651733655; bh=JEqrpWsOY9Rdc
        vSTc4MYhkThrGU1N4YgK93BL3bHbPE=; b=I5pMtQos66KTI2Y+4x47HT0oI5vZQ
        tV9BjfCHSaXc8Oe4yNuGl7oRZvH1h6+oIdr2gPJAOu+/emYL1tI26osOuLOEq1n9
        3t4gqBOCGCYFrOegynwmB1ZXkQ7n4sAh+T8L9DA7Gc6BLP3BBFo+DQ3C72J/QqYl
        g/EpC3bUmZwQUbM0XBqtXSCDd9cHNxXa3KHgm0f6da2Bz69iQcHsb70Qdzk3NcPA
        P7gOT0235z2recYFQPz/Maiu4z7q4W+v0M02zsPD9Ay7sLYGWsspXUkBVXVzaYys
        3GVpr2bMi+9PDJxtRlKRnZZ4nY/sepKqBNtEthcdi1Upl0HxyQ9tXERxA==
X-ME-Sender: <xms:FiNyYsaLyPRtpcxi3FsPm2_bPpzzwNIMEbyvM3az03bkhM5vduQNIQ>
    <xme:FiNyYnaDdT12vUeBVL2iII9f_hCX0446v4GzLtVVVgThBybQAvVd5tjhYwS_mNuYY
    xm1ifbGU1_zdw>
X-ME-Received: <xmr:FiNyYm9VTTv2ZA9gs_hQC_Y-Sm0NkdlRx0dUK2MQhLgYPjy7RqUiYAxvtMMkDQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdekgdduudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtfeejnecuhfhrohhmpeffrghn
    ihgvlhcujfgrrhguihhnghcuoeguhhgrrhguihhngheslhhivhhinhhgudektddrnhgvth
    eqnecuggftrfgrthhtvghrnhepfeffjeejffegffeuveekkeffiefghefhtefgvdehveei
    geeuffegfeeileeihfevnecuffhomhgrihhnpehgihhthhhusgdrtghomhenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpeguhhgrrhguihhnghes
    lhhivhhinhhgudektddrnhgvth
X-ME-Proxy: <xmx:FiNyYmqG5gM7t1jGGAdFQ_ND0AZnBxv56IVUgA0vJQvuiJRqmG6caA>
    <xmx:FiNyYno75tc9TP7Octey_F7oXyXIQ8fR1eehoAMRZSXKpLuNLtSuoA>
    <xmx:FiNyYkSL1edVLok9MB0oTcDBppQs-e-aDAjpnGORSwf0DMDwc8nFUA>
    <xmx:FyNyYmWVgsbt0pkLT7ninLay_LPpKrKGz_d332sZzcSmI2wrJAcEcQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 May 2022 02:54:13 -0400 (EDT)
Message-ID: <12a57dd9-4423-a13d-559b-2b1dd2fb0ef3@living180.net>
Date:   Wed, 4 May 2022 09:54:10 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [REGRESSION] lxc-stop hang on 5.17.x kernels
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
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
From:   Daniel Harding <dharding@living180.net>
In-Reply-To: <bd932b5a-9508-e58f-05f8-001503e4bd2b@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/3/22 17:14, Pavel Begunkov wrote:
> On 5/3/22 08:37, Daniel Harding wrote:
>> [Resend with a smaller trace]
>>
>> On 5/3/22 02:14, Pavel Begunkov wrote:
>>> On 5/2/22 19:49, Daniel Harding wrote:
>>>> On 5/2/22 20:40, Pavel Begunkov wrote:
>>>>> On 5/2/22 18:00, Jens Axboe wrote:
>>>>>> On 5/2/22 7:59 AM, Jens Axboe wrote:
>>>>>>> On 5/2/22 7:36 AM, Daniel Harding wrote:
>>>>>>>> On 5/2/22 16:26, Jens Axboe wrote:
>>>>>>>>> On 5/2/22 7:17 AM, Daniel Harding wrote:
>>>>>>>>>> I use lxc-4.0.12 on Gentoo, built with io-uring support
>>>>>>>>>> (--enable-liburing), targeting liburing-2.1.  My kernel 
>>>>>>>>>> config is a
>>>>>>>>>> very lightly modified version of Fedora's generic kernel 
>>>>>>>>>> config. After
>>>>>>>>>> moving from the 5.16.x series to the 5.17.x kernel series, I 
>>>>>>>>>> started
>>>>>>>>>> noticed frequent hangs in lxc-stop.  It doesn't happen 100% 
>>>>>>>>>> of the
>>>>>>>>>> time, but definitely more than 50% of the time. Bisecting 
>>>>>>>>>> narrowed
>>>>>>>>>> down the issue to commit 
>>>>>>>>>> aa43477b040251f451db0d844073ac00a8ab66ee:
>>>>>>>>>> io_uring: poll rework. Testing indicates the problem is still 
>>>>>>>>>> present
>>>>>>>>>> in 5.18-rc5. Unfortunately I do not have the expertise with the
>>>>>>>>>> codebases of either lxc or io-uring to try to debug the problem
>>>>>>>>>> further on my own, but I can easily apply patches to any of the
>>>>>>>>>> involved components (lxc, liburing, kernel) and rebuild for 
>>>>>>>>>> testing or
>>>>>>>>>> validation.  I am also happy to provide any further 
>>>>>>>>>> information that
>>>>>>>>>> would be helpful with reproducing or debugging the problem.
>>>>>>>>> Do you have a recipe to reproduce the hang? That would make it
>>>>>>>>> significantly easier to figure out.
>>>>>>>>
>>>>>>>> I can reproduce it with just the following:
>>>>>>>>
>>>>>>>>      sudo lxc-create --n lxc-test --template download --bdev 
>>>>>>>> dir --dir /var/lib/lxc/lxc-test/rootfs -- -d ubuntu -r bionic 
>>>>>>>> -a amd64
>>>>>>>>      sudo lxc-start -n lxc-test
>>>>>>>>      sudo lxc-stop -n lxc-test
>>>>>>>>
>>>>>>>> The lxc-stop command never exits and the container continues 
>>>>>>>> running.
>>>>>>>> If that isn't sufficient to reproduce, please let me know.
>>>>>>>
>>>>>>> Thanks, that's useful! I'm at a conference this week and hence have
>>>>>>> limited amount of time to debug, hopefully Pavel has time to 
>>>>>>> take a look
>>>>>>> at this.
>>>>>>
>>>>>> Didn't manage to reproduce. Can you try, on both the good and bad
>>>>>> kernel, to do:
>>>>>
>>>>> Same here, it doesn't reproduce for me
>>>> OK, sorry it wasn't something simple.
>>>>> # echo 1 > /sys/kernel/debug/tracing/events/io_uring/enable
>>>>>>
>>>>>> run lxc-stop
>>>>>>
>>>>>> # cp /sys/kernel/debug/tracing/trace ~/iou-trace
>>>>>>
>>>>>> so we can see what's going on? Looking at the source, lxc is just 
>>>>>> using
>>>>>> plain POLL_ADD, so I'm guessing it's not getting a notification 
>>>>>> when it
>>>>>> expects to, or it's POLL_REMOVE not doing its job. If we have a 
>>>>>> trace
>>>>>> from both a working and broken kernel, that might shed some light 
>>>>>> on it.
>>>> It's late in my timezone, but I'll try to work on getting those 
>>>> traces tomorrow.
>>>
>>> I think I got it, I've attached a trace.
>>>
>>> What's interesting is that it issues a multi shot poll but I don't
>>> see any kind of cancellation, neither cancel requests nor task/ring
>>> exit. Perhaps have to go look at lxc to see how it's supposed
>>> to work
>>
>> Yes, that looks exactly like my bad trace.  I've attached good trace 
>> (captured with linux-5.16.19) and a bad trace (captured with 
>> linux-5.17.5).  These are the differences I noticed with just a 
>> visual scan:
>>
>> * Both traces have three io_uring_submit_sqe calls at the very 
>> beginning, but in the good trace, there are further 
>> io_uring_submit_sqe calls throughout the trace, while in the bad 
>> trace, there are none.
>> * The good trace uses a mask of c3 for io_uring_task_add much more 
>> often than the bad trace:  the bad trace uses a mask of c3 only for 
>> the very last call to io_uring_task_add, but a mask of 41 for the 
>> other calls.
>> * In the good trace, many of the io_uring_complete calls have a 
>> result of 195, while in the bad trace, they all have a result of 1.
>>
>> I don't know whether any of those things are significant or not, but 
>> that's what jumped out at me.
>>
>> I have also attached a copy of the script I used to generate the 
>> traces.  If there is anything further I can to do help debug, please 
>> let me know.
>
> Good observations! thanks for traces.
>
> It sounds like multi-shot poll requests were getting downgraded
> to one-shot, which is a valid behaviour and was so because we
> didn't fully support some cases. If that's the reason, than
> the userspace/lxc is misusing the ABI. At least, that's the
> working hypothesis for now, need to check lxc.

So, I looked at the lxc source code, and it appears to at least try to 
handle the case of multi-shot being downgraded to one-shot.  I don't 
know enough to know if the code is actually correct however:

https://github.com/lxc/lxc/blob/7e37cc96bb94175a8e351025d26cc35dc2d10543/src/lxc/mainloop.c#L165-L189

https://github.com/lxc/lxc/blob/7e37cc96bb94175a8e351025d26cc35dc2d10543/src/lxc/mainloop.c#L254

https://github.com/lxc/lxc/blob/7e37cc96bb94175a8e351025d26cc35dc2d10543/src/lxc/mainloop.c#L288-L290

-- 
Regards,

Daniel Harding
