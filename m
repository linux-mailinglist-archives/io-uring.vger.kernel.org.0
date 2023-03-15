Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9FC46BBE09
	for <lists+io-uring@lfdr.de>; Wed, 15 Mar 2023 21:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbjCOUix (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Mar 2023 16:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjCOUiw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Mar 2023 16:38:52 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8545298FC
        for <io-uring@vger.kernel.org>; Wed, 15 Mar 2023 13:38:49 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id q6so8382848iot.2
        for <io-uring@vger.kernel.org>; Wed, 15 Mar 2023 13:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678912729;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n/+RN8x2HxBwu9AA/zJWbELiiKbvAOys+kKOW63YhQI=;
        b=sUyPajnN0B29WhboHYxEweASIzvlB+yPnH++dGMc/mSA2Y4PAz6huWnR6Rm4Nceemb
         DGQWZZp2DF/Y9sGNwEm9kc8HM1E581JNbQ+ZHDPUsHiPoYPlspZNMlONYjA6U3FavSm4
         cFG1pIqCHww/uffmVuCnT5quKGFMjHCFt3LeqJpNmiwzduNP/VCwjN543wZn8L1lM8KD
         J4pwx31jG/4Q6YiM0dNFkwWo0LPbMH0UjEsZBGvqUM3yv/kNgwXINmUkCSM7G4Hppr2a
         Rtjz3wtP2d4HtnAb/3+h2hWJfuz7hI5E0YcCKtdwwxbYkCFnKpcrXy01Go7rXkMcRuR+
         dllQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678912729;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n/+RN8x2HxBwu9AA/zJWbELiiKbvAOys+kKOW63YhQI=;
        b=X/nyEfefFYBsFvQ1K7QjMUbHLjFAL6vaY1vD1gvaHjvnrRQoWRHE04Wfni1pbt4oVL
         4ZVzVmcLJkhp3cN2rTLy4zpD6e8VvzyqSbW74+gPmG7P8rkuDj/DqZ16Vzcnf5fQ2uQI
         a6xqTPLTqZAUuGIMHvxQts/TWypncUfoetTdY0Mp2gL7mS83SUwDI3yLQ0CynIsakiRA
         4t8+2eFeTfbhun7v5w3dBXiDgcavD2UCvFVR8NkYvFGAoqARj1ii17WcTiUB8VGKd60n
         gWN4NpD71d1TVou52eIaLiGtfMvWqpVjDbVlg6Tn4SJGimif8tmxmhxt+DF6tZuaqPx3
         8vOg==
X-Gm-Message-State: AO0yUKUwbk8GJ4XgWLKOIE1uIIS1fzCoMNXNimtejz34JWx/aICsrm1a
        LXina5jBlnFvc325EcWjAc1vbgun4nG2p3lWoootJg==
X-Google-Smtp-Source: AK7set9sTdP00K+I3TfMDLn34KgA5hNLmB2voTQ8Sev5AY3JBaCKKueOkMMkm9Fvnyv4/3wjLZ6DXg==
X-Received: by 2002:a05:6602:2c07:b0:74e:5fba:d5df with SMTP id w7-20020a0566022c0700b0074e5fbad5dfmr493361iov.0.1678912729141;
        Wed, 15 Mar 2023 13:38:49 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a14-20020a056638004e00b003b39dcca1dfsm1936478jap.170.2023.03.15.13.38.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 13:38:48 -0700 (PDT)
Message-ID: <88b273f6-a747-7d2e-7981-3d224fdac7be@kernel.dk>
Date:   Wed, 15 Mar 2023 14:38:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCHSET 0/5] User mapped provided buffer rings
Content-Language: en-US
To:     Helge Deller <deller@gmx.de>, io-uring@vger.kernel.org,
        linux-parisc <linux-parisc@vger.kernel.org>
References: <20230314171641.10542-1-axboe@kernel.dk>
 <0eeed691-9ea1-9516-c403-5ba22554f8e7@gmx.de>
 <3dcf3e0c-d393-cb95-86ab-00b4d8cf3c75@gmx.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3dcf3e0c-d393-cb95-86ab-00b4d8cf3c75@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/15/23 2:07?PM, Helge Deller wrote:
> On 3/15/23 21:03, Helge Deller wrote:
>> Hi Jens,
>>
>> Thanks for doing those fixes!
>>
>> On 3/14/23 18:16, Jens Axboe wrote:
>>> One issue that became apparent when running io_uring code on parisc is
>>> that for data shared between the application and the kernel, we must
>>> ensure that it's placed correctly to avoid aliasing issues that render
>>> it useless.
>>>
>>> The first patch in this series is from Helge, and ensures that the
>>> SQ/CQ rings are mapped appropriately. This makes io_uring actually work
>>> there.
>>>
>>> Patches 2..4 are prep patches for patch 5, which adds a variant of
>>> ring mapped provided buffers that have the kernel allocate the memory
>>> for them and the application mmap() it. This brings these mapped
>>> buffers in line with how the SQ/CQ rings are managed too.
>>>
>>> I'm not fully sure if this ONLY impacts archs that set SHM_COLOUR,
>>> of which there is only parisc, or if SHMLBA setting archs (of which
>>> there are others) are impact to any degree as well...
>>
>> It would be interesting to find out. I'd assume that other arches,
>> e.g. sparc, might have similiar issues.
>> Have you tested your patches on other arches as well?
> 
> By the way, I've now tested this series on current git head on an
> older parisc box (with PA8700 / PCX-W2 CPU).
> 
> Results of liburing testsuite:
> Tests timed out (1): <send-zerocopy.t> - (may not be a failure)
> Tests failed (5): <buf-ring.t> <file-verify.t> <poll-race-mshot.t> <ringbuf-read.t> <send_recvmsg.t>

send-zerocopy.t takes about ~20 seconds for me on modern hardware, so
that one likely just needs a longer timeout to work. Running it here on
my PA8900:

axboe@c8000 ~/g/liburing (master)> time test/send-zerocopy.t 

________________________________________________________
Executed in  115.08 secs    fish           external
   usr time   63.70 secs    1.08 millis   63.70 secs
   sys time   57.25 secs    4.26 millis   57.24 secs

which on that box is almost twice as long as the normal timeout for
the test script.

For file-verify.t, that one should work with the current tree. The issue
there is the use of registered buffers, and I added a parisc hack for
that. Maybe it's too specific to the PA8900 (the 128 byte stride). If
your tree does have:

commit 4c4fd1843bf284c0063c3a0f8822cb2d352b20c0 (origin/master, origin/HEAD, master)
Author: Jens Axboe <axboe@kernel.dk>
Date:   Wed Mar 15 11:34:54 2023 -0600

    test/file-verify: add dcache sync for parisc

then please experiment with that. 64 might be the correct value here and
I just got lucky with my testing...
be interesting to see 

For the remainder, they are all related to the buffer ring, which is
what is enabled by this series. But the tests don't use that yet, so
they will fail just like they do without the patch. In the
ring-buf-alloc branch of liburing there's the start of adding helpers to
setup the buffer rings, and then we can switch them to the mmap()
approach without much trouble. It's just not done yet, I will add a
patch in there to do that.

-- 
Jens Axboe

