Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 531DA5176D3
	for <lists+io-uring@lfdr.de>; Mon,  2 May 2022 20:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242074AbiEBSxQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 May 2022 14:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353640AbiEBSxP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 May 2022 14:53:15 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0306BBE05;
        Mon,  2 May 2022 11:49:46 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id EB1BA32009D3;
        Mon,  2 May 2022 14:49:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 02 May 2022 14:49:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=living180.net;
         h=cc:cc:content-transfer-encoding:content-type:date:date:from
        :from:in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1651517384; x=
        1651603784; bh=TA2UFVaia1h61cNM8zIfNtZYBdMcoajUo47LJiOq4l8=; b=M
        pKdoxVMCy/xlYDX9nOreTIZsbrAGrRpYtYShYJbdUNzoAnfxm9HhU9eJmTViQN8l
        1EXpJFG6aVF8RsolrNyG92LeNXeK8JaxSf41Y3YBheTPO8+wxOa/awTUjllmfU0v
        w7740700pjdTLAzNGA2N1wsHRKpwb9EIfiTT7hCDiuAJOn7YpTZZ4C18QQs/+dEz
        Ox+W65jFkhT/FG8Q/p+bqtP28W13HUFKDz3r42dK59I0pgv/zSXVzm1av9zmuH2W
        oD5joAvPeE/6FSaYlHOJmOh/F+SE7C73SU0SDrJjDfxVl0/JMazMOuOv3/9/5Tu/
        V4dD1fp8eUey195upYP6w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1651517384; x=1651603784; bh=TA2UFVaia1h61
        cNM8zIfNtZYBdMcoajUo47LJiOq4l8=; b=oHGf6c3x40EYjKNZ8oAWzsNvdi1uV
        ziwk9tq3PvX7X2GdMje2Wj6tcTDPQ0XLukxxjkYQy1Gtfk22Mb0N3NB6IpiAJcuR
        qHtK1nNVdNDeXBxoYA5uBW3z9a6UJt3DWG2solwDBt6f8eVmohePqFWP22/gSL7f
        6SJLHstXX4v859JFiSNuxITpJka/XpdH5mlD2p1Cu87QdZqQqoVFbCflxtCsYMnT
        wUP5IS2ZDJYH4GMETW+nXkJ+DaDEHGAwYrCMf9HrUvp9iMl5Fl/qTSJhiuVX0Idg
        p+6oT4/Ljx8Szioc40jkx6XoSRk27JPxrgh604sCLIk97Rr9vdQXoPXsA==
X-ME-Sender: <xms:yCdwYvfT7CjwqMeEDWTdBksMtQTKA4q9N6Tqx6hQeKuCSyztEg8sMg>
    <xme:yCdwYlNG8BSGsm4Wh4I9BauSlIHUwvcsiqYbr-H2eMdZfRX_8MUYaqxY71YX2vZTA
    MpDroFVa2JwAg>
X-ME-Received: <xmr:yCdwYojbYI9YuNiDt21TDeuEuQ2NIYHkDRUMR82-vzYp_iW-4poU2QhW9bau_w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehgdduvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtfeejnecuhfhrohhmpeffrghn
    ihgvlhcujfgrrhguihhnghcuoeguhhgrrhguihhngheslhhivhhinhhgudektddrnhgvth
    eqnecuggftrfgrthhtvghrnhepleekheegfeeffedvhfffvdettedtjeetuedtgfdvudei
    feelfeeigeduhfejhfejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepughhrghrughinhhgsehlihhvihhnghdukedtrdhnvght
X-ME-Proxy: <xmx:yCdwYg8VvaczVTLBDpbqzxV0045As5C5mdsgf8-Rzb2YAh6zzE2V7w>
    <xmx:yCdwYrs1hfTydwQqpzOTAU6U-PhpDoVeBKLdCrMYnuaQfuF4O3TAbg>
    <xmx:yCdwYvF-SP7BpNFceubaXUnvd6KnLXcrAvOwuwSyrnrsXZ8v2go6UQ>
    <xmx:yCdwYrJxrbum8ETZLdLOewJ2R68qcjCqq3xgw1cxqrA6COORAAj7DA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 May 2022 14:49:42 -0400 (EDT)
Message-ID: <ad9c31e5-ee75-4df2-c16d-b1461be1901a@living180.net>
Date:   Mon, 2 May 2022 21:49:40 +0300
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
From:   Daniel Harding <dharding@living180.net>
In-Reply-To: <2436d42c-85ca-d060-6508-350c769804f1@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/2/22 20:40, Pavel Begunkov wrote:
> On 5/2/22 18:00, Jens Axboe wrote:
>> On 5/2/22 7:59 AM, Jens Axboe wrote:
>>> On 5/2/22 7:36 AM, Daniel Harding wrote:
>>>> On 5/2/22 16:26, Jens Axboe wrote:
>>>>> On 5/2/22 7:17 AM, Daniel Harding wrote:
>>>>>> I use lxc-4.0.12 on Gentoo, built with io-uring support
>>>>>> (--enable-liburing), targeting liburing-2.1.  My kernel config is a
>>>>>> very lightly modified version of Fedora's generic kernel config. 
>>>>>> After
>>>>>> moving from the 5.16.x series to the 5.17.x kernel series, I started
>>>>>> noticed frequent hangs in lxc-stop.  It doesn't happen 100% of the
>>>>>> time, but definitely more than 50% of the time. Bisecting narrowed
>>>>>> down the issue to commit aa43477b040251f451db0d844073ac00a8ab66ee:
>>>>>> io_uring: poll rework. Testing indicates the problem is still 
>>>>>> present
>>>>>> in 5.18-rc5. Unfortunately I do not have the expertise with the
>>>>>> codebases of either lxc or io-uring to try to debug the problem
>>>>>> further on my own, but I can easily apply patches to any of the
>>>>>> involved components (lxc, liburing, kernel) and rebuild for 
>>>>>> testing or
>>>>>> validation.  I am also happy to provide any further information that
>>>>>> would be helpful with reproducing or debugging the problem.
>>>>> Do you have a recipe to reproduce the hang? That would make it
>>>>> significantly easier to figure out.
>>>>
>>>> I can reproduce it with just the following:
>>>>
>>>>      sudo lxc-create --n lxc-test --template download --bdev dir 
>>>> --dir /var/lib/lxc/lxc-test/rootfs -- -d ubuntu -r bionic -a amd64
>>>>      sudo lxc-start -n lxc-test
>>>>      sudo lxc-stop -n lxc-test
>>>>
>>>> The lxc-stop command never exits and the container continues running.
>>>> If that isn't sufficient to reproduce, please let me know.
>>>
>>> Thanks, that's useful! I'm at a conference this week and hence have
>>> limited amount of time to debug, hopefully Pavel has time to take a 
>>> look
>>> at this.
>>
>> Didn't manage to reproduce. Can you try, on both the good and bad
>> kernel, to do:
>
> Same here, it doesn't reproduce for me
OK, sorry it wasn't something simple.
> # echo 1 > /sys/kernel/debug/tracing/events/io_uring/enable
>>
>> run lxc-stop
>>
>> # cp /sys/kernel/debug/tracing/trace ~/iou-trace
>>
>> so we can see what's going on? Looking at the source, lxc is just using
>> plain POLL_ADD, so I'm guessing it's not getting a notification when it
>> expects to, or it's POLL_REMOVE not doing its job. If we have a trace
>> from both a working and broken kernel, that might shed some light on it.
It's late in my timezone, but I'll try to work on getting those traces 
tomorrow.

-- 
Regards,

Daniel Harding
