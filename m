Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71233557D87
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 16:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbiFWOIT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 10:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbiFWOIP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 10:08:15 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852FC3EBB2
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 07:08:12 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id k18so8320026ilr.11
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 07:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KtGcO+WB7Oy31zJ1NLEXMcO/8OKl158blOykwTSsaFI=;
        b=4ce+zg40R4jacXjIuEcZL3uMH4IDI2M9HOnYW7wv98wkkvUhGuCydAJc6Se4pSM247
         YymnVYnY14fJFGztOTW7f/d+DLVv4W++E/ZKYHCvd19ymdEMrStnJ2he+MYemMnr8sEC
         7O3MOIZX+4jwvGlPVurEM0kKiPKKjle0LDKRzNO5wosRvusTZ44fKt78CGb8STI72Bwk
         W6dJgxK4O2iBPIjpl6h3I5cteN4U5UVF7iY9+qRtMtIwdTqWV0zrszbhI6E5Fo8nLakf
         0g4tkV6Lk9NGh7XJHSncWACHPAbQJjnxna5SRvSDlBZEer/QzGDkDGQlkcm3E6ks7rre
         ecDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KtGcO+WB7Oy31zJ1NLEXMcO/8OKl158blOykwTSsaFI=;
        b=3jjoe2cRNVpFBBcXwkqMfhYuhdpzrw50mcaIqkz106/+bshI04NST3PWZ0ZFHV1Iiz
         VCfHdrdLWGPad6xBWTOgH7aA/ul6sOLbNKavaSfF3f+tHtn4aAKMo17mIEfxlyRuol6M
         GghNiHddHKdvGfFEkUhk3hskcOd2CTo7poJLQGxUdgHaiufg/V2jahjCFik0aLDEf6Oa
         5b7LHfsa5eOJ5hjWlfiWuLtbzRpXk6T+PmyzU1KdYl1sJJt8OB33WSMdUMoGljgi6fL7
         LRU7mnmFmb33/ZbmXiXybO2N46Ao6Fo8QS5v1wlwjpqlpUSjCYu7b0b8TPt+zvbYqH8v
         b95Q==
X-Gm-Message-State: AJIora/aYe0Bv8Xj3Y1tjmM24c8wnyfpuy9/smKirF6otgKeeNoYvL6M
        u8e2o1BQsKdZjg3heVPw7JiovQ==
X-Google-Smtp-Source: AGRyM1tRs77eZWKpqkJDyVpzGUbJApjrcKSQvsHy/XjJJqs71WQ46bBpWhN5tge/jwRdgJeElZXnWA==
X-Received: by 2002:a05:6e02:1a89:b0:2d9:2feb:da69 with SMTP id k9-20020a056e021a8900b002d92febda69mr5397398ilv.189.1655993291618;
        Thu, 23 Jun 2022 07:08:11 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s15-20020a02c7cf000000b0032b5e78bfcbsm9877639jao.135.2022.06.23.07.08.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 07:08:11 -0700 (PDT)
Message-ID: <698e189e-834c-60b0-6cb8-fdad78cd0a49@kernel.dk>
Date:   Thu, 23 Jun 2022 08:08:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RFC] a new way to achieve asynchronous IO
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring <io-uring@vger.kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, dvernet@fb.com
References: <3d1452da-ecec-fdc7-626c-bcd79df23c92@linux.dev>
 <b297ac50-c336-dabe-b6ee-c067b7f418c7@kernel.dk>
 <1237fa26-3190-7c92-c516-9cf2a750fab4@linux.dev>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1237fa26-3190-7c92-c516-9cf2a750fab4@linux.dev>
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

On 6/23/22 7:31 AM, Hao Xu wrote:
> On 6/20/22 21:41, Jens Axboe wrote:
>> On 6/20/22 6:01 AM, Hao Xu wrote:
>>> Hi,
>>> I've some thought on the way of doing async IO. The current model is:
>>> (given we are using SQPOLL mode)
>>>
>>> the sqthread does:
>>> (a) Issue a request with nowait/nonblock flag.
>>> (b) If it would block, reutrn -EAGAIN
>>> (c) The io_uring layer captures this -EAGAIN and wake up/create
>>> a io-worker to execute the request synchronously.
>>> (d) Try to issue other requests in the above steps again.
>>>
>>> This implementation has two downsides:
>>> (1) we have to find all the block point in the IO stack manually and
>>> change them into "nowait/nonblock friendly".
>>> (2) when we raise another io-worker to do the request, we submit the
>>> request from the very beginning. This isn't a little bit inefficient.
>>>
>>>
>>> While I think we can actually do it in a reverse way:
>>> (given we are using SQPOLL mode)
>>>
>>> the sqthread1 does:
>>> (a) Issue a request in the synchronous way
>>> (b) If it is blocked/scheduled soon, raise another sqthread2
>>> (c) sqthread2 tries to issue other requests in the same way.
>>>
>>> This solves problem (1), and may solve (2).
>>> For (1), we just do the sqthread waken-up at the beginning of schedule()
>>> just like what the io-worker and system-worker do. No need to find all
>>> the block point.
>>> For (2), we continue the blocked request from where it is blocked when
>>> resource is satisfied.
>>>
>>> What we need to take care is making sure there is only one task
>>> submitting the requests.
>>>
>>> To achieve this, we can maintain a pool of sqthread just like the iowq.
>>>
>>> I've done a very simple/ugly POC to demonstrate this:
>>>
>>> https://github.com/HowHsu/linux/commit/183be142493b5a816b58bd95ae4f0926227b587b
>>>
>>> I also wrote a simple test to test it, which submits two sqes, one
>>> read(pipe), one nop request. The first one will be block since no data
>>> in the pipe. Then a new sqthread was created/waken up to submit the
>>> second one and then some data is written to the pipe(by a unrelated
>>> user thread), soon the first sqthread is waken up and continues the
>>> request.
>>>
>>> If the idea sounds no fatal issue I'll change the POC to real patches.
>>> Any comments are welcome!
>>
>> One thing I've always wanted to try out is kind of similar to this, but
>> a superset of it. Basically io-wq isn't an explicit offload mechanism,
>> it just happens automatically if the issue blocks. This applies to both
>> SQPOLL and non-SQPOLL.
>>
>> This takes a page out of the old syslet/threadlet that Ingo Molnar did
>> way back in the day [1], but it never really went anywhere. But the
>> pass-on-block primitive would apply very nice to io_uring.
> 
> I've read a part of the syslet/threadlet patchset, seems it has
> something that I need, my first idea about the new iowq offload is
> just like syslet----if blocked, trigger a new worker, deliver the
> context to it, and then update the current context so that we return
> to the place of sqe submission. But I just didn't know how to do it.

Exactly, what you mentioned was very close to what I had considered in
the past, and what the syslet/threadlet attempted to do. Except it flips
it upside down a bit, which I do think is probably the saner way to do
it rather than have the original block and fork a new one.

> By the way, may I ask why the syslet/threadlet is not merged to the
> mainline. The mail thread is very long, haven't gotten a chance to
> read all of it.

Not quite sure, it's been a long time. IMHO it's a good idea looking for
the right interface, which we now have. So the time may be ripe to do
something like this, finally.
> 
> For the approach I posted, I found it is actually SQPOLL-nonrelated.
> The original conext just wake up a worker in the pool to do the
> submission, and if one blocks, another one wakes up to do the
> submission. It is definitely easier to implement than something like
> syslet(context delivery) since the new worker naturally goes to the
> place of submission thus no context delivery needed. but a downside is
> every time we call io_uring_enter to submit a batch of sqes, there is a
> wakeup at the beginning.
> 
> I'll try if I can implement a context delivery version.

Sounds good, thanks.

-- 
Jens Axboe

