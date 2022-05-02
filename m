Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9C35170A6
	for <lists+io-uring@lfdr.de>; Mon,  2 May 2022 15:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243514AbiEBNkI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 May 2022 09:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385362AbiEBNkF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 May 2022 09:40:05 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7851BDEC4;
        Mon,  2 May 2022 06:36:30 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id B20D75C00F3;
        Mon,  2 May 2022 09:36:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 02 May 2022 09:36:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=living180.net;
         h=cc:cc:content-transfer-encoding:content-type:date:date:from
        :from:in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1651498589; x=
        1651584989; bh=DKuJbHbyPUqgLeOliLIbXn1AoO2Mdbl5+P4gRT3Ay2E=; b=D
        mpGN6XA6cMKSi58bz3l8aZ6f0nZszYbA57byZEbN4UOYQ6UwC9zY1CN0M7rLG9Rp
        q0Jk6futlLfwjyvo3EhDLr0YzYoW2y5Mo9l1zzF100c/iGKBXxRKEcsMp8nsrEei
        3EMHXn1AkMu8JH0aySNvRhy48fGYw4/yDwsUE6AucL3JdUaGwUAI4xAB6Sdw56mn
        LzfRX0yF9BjT/eBfDZDj35CKGPb69j00NAweMEIu8VoDtzb6dE2+2hrcQ8sOCE/Q
        R3sFogjT/PIGWHMZMeSM78V/pN1t/scgdt4MoyegXQLZ6xNsp0pzHFNqlB8zxnxy
        OKg5iQjQIXNIztZdFhsYg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1651498589; x=1651584989; bh=DKuJbHbyPUqgL
        eOliLIbXn1AoO2Mdbl5+P4gRT3Ay2E=; b=HCNoHfoxXu5Wonbjc0N2bAf8Zbggb
        kG4mENbrXQA6sPgYaiyfUvA+ky2FYQb8v3o1a7IrfJmr6SAKXaZixnVRuPpFTvR4
        HjiYNIH2YcyILGa4KlQFggRSCRfMEN86oNY9/bgnc2HZ3UMwM7wRox01lQddOoVp
        QOfvxlbIM/zvGepMNdJntQygbEhiDVQ4K/4Tav/0xclLRq0W6rYpTsLCOCEyfdmp
        brVXOfoyxYZc57oONlnwsi6mvFFrkJG9JSQcRzL61fILXC/UlxjH8w+Tj9RdnmzY
        VqBxhey0BPevrDSlxcaVqwE7xXtrioIX2lJ/ifpbnF/+SrjN8L1MS9RgQ==
X-ME-Sender: <xms:Xd5vYsLhYpjzpC-TL0WWuUWl6FB0vf6R9X2HChrPT4ovNz7lcjBJ0g>
    <xme:Xd5vYsKHvFsaocy11JZ8OSVxVKoGy9ZWWlP8OKJvWLMhvqFlwDOEi5F_wu9-a-WD8
    ItHalHdVW0VnQ>
X-ME-Received: <xmr:Xd5vYstxdsteZjhvMhvsU6OgPoxl98lJM0o4URL_hVQ4hcrmHj-zeZgNaE9Mcw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkffggfgfuvfevfhfhjggtgfesthekredttdefjeenucfhrhhomhepffgrnhhi
    vghlucfjrghrughinhhguceoughhrghrughinhhgsehlihhvihhnghdukedtrdhnvghtqe
    enucggtffrrghtthgvrhhnpeelkeehgeeffeefvdfhffdvteettdejteeutdfgvdduieef
    leefieegudfhjefhjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpeguhhgrrhguihhngheslhhivhhinhhgudektddrnhgvth
X-ME-Proxy: <xmx:Xd5vYpZBskH2A79RM7vKtKYDmdZ2Tg3uDoKFI9CUiB3qtX2gCJjPEA>
    <xmx:Xd5vYjZ1Xub_x4b2yVMuz3swAMw6oRFY-8BCQFQIOqlIh1p77nc4pg>
    <xmx:Xd5vYlAINVZfKhjtyTgsgV8CUFQZIggdNSh3ZpAHmpgLzKMmFvpykw>
    <xmx:Xd5vYvEnONa3IdegVxs9PKQ6WxqtlvtT8hmW_bD6_iFdL3i4MkOz2A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 May 2022 09:36:28 -0400 (EDT)
Message-ID: <ccf6cea1-1139-cd73-c4e5-dc9799708bdd@living180.net>
Date:   Mon, 2 May 2022 16:36:25 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [REGRESSION] lxc-stop hang on 5.17.x kernels
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     regressions@lists.linux.dev, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <7925e262-e0d4-6791-e43b-d37e9d693414@living180.net>
 <6ad38ecc-b2a9-f0e9-f7c7-f312a2763f97@kernel.dk>
From:   Daniel Harding <dharding@living180.net>
In-Reply-To: <6ad38ecc-b2a9-f0e9-f7c7-f312a2763f97@kernel.dk>
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

On 5/2/22 16:26, Jens Axboe wrote:
> On 5/2/22 7:17 AM, Daniel Harding wrote:
>> I use lxc-4.0.12 on Gentoo, built with io-uring support
>> (--enable-liburing), targeting liburing-2.1.  My kernel config is a
>> very lightly modified version of Fedora's generic kernel config. After
>> moving from the 5.16.x series to the 5.17.x kernel series, I started
>> noticed frequent hangs in lxc-stop.  It doesn't happen 100% of the
>> time, but definitely more than 50% of the time.  Bisecting narrowed
>> down the issue to commit aa43477b040251f451db0d844073ac00a8ab66ee:
>> io_uring: poll rework. Testing indicates the problem is still present
>> in 5.18-rc5. Unfortunately I do not have the expertise with the
>> codebases of either lxc or io-uring to try to debug the problem
>> further on my own, but I can easily apply patches to any of the
>> involved components (lxc, liburing, kernel) and rebuild for testing or
>> validation.  I am also happy to provide any further information that
>> would be helpful with reproducing or debugging the problem.
> Do you have a recipe to reproduce the hang? That would make it
> significantly easier to figure out.

I can reproduce it with just the following:

     sudo lxc-create --n lxc-test --template download --bdev dir --dir 
/var/lib/lxc/lxc-test/rootfs -- -d ubuntu -r bionic -a amd64
     sudo lxc-start -n lxc-test
     sudo lxc-stop -n lxc-test

The lxc-stop command never exits and the container continues running.  
If that isn't sufficient to reproduce, please let me know.

-- 
Regards,

Daniel Harding
