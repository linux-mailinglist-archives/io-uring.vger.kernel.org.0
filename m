Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B79DE4EB465
	for <lists+io-uring@lfdr.de>; Tue, 29 Mar 2022 22:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236313AbiC2UEw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Mar 2022 16:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241136AbiC2UEv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Mar 2022 16:04:51 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5DA1E95DC
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 13:03:07 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id z10so131729iln.0
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 13:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0QGztPVjzX44ttEFwvwFdDeevgc4RC7UwAPyPzN4Wew=;
        b=bP/0KJ8x/fRJ+fFQfqRyP39DajyTjUJ9qry0c6jZ8nvEto5g8ACQRzhpAIgoLiqZ9l
         HBXV/UwKTInlBkytIijlj3465xQsUu63U/ASgOrZe5U+97buM7bQVInnVxzxkvBWQKWJ
         dAnL2V7yLF4ZyzLumunf+/B5wKAJErFrKn1oi6V9oHpGUS3QG9GrbFsUWNlVVU3wqdnC
         Nefd7wmGUEt+GZE9Kgx8/JV+OZ9zXF+Qeqkn9/+EJP+mTaEWEe2T95KvrgN9SsVY7pt4
         3sQ9AE6NqitgDZ1VsR53B6pY2KMuqtOP8GhMcZ9OHy5zJ7KCQ9EzICtCjotrTK53qNn6
         JKaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0QGztPVjzX44ttEFwvwFdDeevgc4RC7UwAPyPzN4Wew=;
        b=pFHWXc8cJLJCzYaQj5mbRnt6dvHDAQt0Xe0pVI6Q3XKxiWdsmd9ZUkS1CB0SWo0Ygd
         ZbNe6pTi7tg8LRTgDhHh/ldefieiDqtmmPcF1S1kLMp8j/BFE8g6svrLHNVBuEhuGiOr
         IHzvuCQa1GZiauHVX8VjdooMeCZFSKvlh2A0ApG+RUcMN24oRpuM/G2NoRvU8rMzRHS9
         pXPx/nbk0Vn3m9Dfz8GHdtCSnxYIeGUbJUNLytMt3km/twcuKhqe/+BCnA6Jlg4gUTog
         3PxnC2bYpSlvtEOTjZ4LlWKPc28NUObgy3SUxgtHILILW4BDfhP6SX+wrl+ammjYB//2
         ODMA==
X-Gm-Message-State: AOAM531H2fjs/AHRuvoYlCkL7FnojPiIx6zr6se09KGYHk98yN+45r2+
        P8Nd1nbnaeupL60lKNJoBmiNBWzbx+jwZCKJ
X-Google-Smtp-Source: ABdhPJxeEyULZ4VMPbcWE4OFfySqIb3Tw6phnRHXmEYpunRX8DB394tsu8DptoyC/+Gf32+FX9Nk4Q==
X-Received: by 2002:a92:c268:0:b0:2c7:c913:a44b with SMTP id h8-20020a92c268000000b002c7c913a44bmr8994952ild.281.1648584186875;
        Tue, 29 Mar 2022 13:03:06 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v18-20020a6b5b12000000b00645bd8bd288sm10296975ioh.47.2022.03.29.13.03.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Mar 2022 13:03:06 -0700 (PDT)
Message-ID: <0c5745ab-5d3d-52c1-6a1d-e5e33d4078b5@kernel.dk>
Date:   Tue, 29 Mar 2022 14:03:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: io_uring_prep_openat_direct() and link/drain
Content-Language: en-US
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     io-uring@vger.kernel.org
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
 <8145e724-d960-dd85-531e-16e564a02f05@kernel.dk>
 <c8872b69-f042-dc35-fa3d-6862f09a5385@kernel.dk>
 <CAJfpegs1o3HNkpxPa85LmNCoVVk-T2rt3vJXBvRf_M93P+6ouA@mail.gmail.com>
 <115fc7d1-9b9c-712b-e75d-39b2041df437@kernel.dk>
 <CAJfpegs=GcTuXcor-pbhaAxDKeS5XRy5rwTGXUcZM0BYYUK2LA@mail.gmail.com>
 <89322bd1-5e6f-bcc6-7974-ffd22363a165@kernel.dk>
 <CAJfpegtr+Bo0O=i9uShDJO_=--KAsFmvdzodwH6qF7f+ABeQ5g@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAJfpegtr+Bo0O=i9uShDJO_=--KAsFmvdzodwH6qF7f+ABeQ5g@mail.gmail.com>
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

On 3/29/22 1:30 PM, Miklos Szeredi wrote:
> On Tue, 29 Mar 2022 at 20:40, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 3/29/22 12:31 PM, Miklos Szeredi wrote:
>>> On Tue, 29 Mar 2022 at 20:26, Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 3/29/22 12:21 PM, Miklos Szeredi wrote:
>>>>> On Tue, 29 Mar 2022 at 19:04, Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>
>>>>>> On 3/29/22 10:08 AM, Jens Axboe wrote:
>>>>>>> On 3/29/22 7:20 AM, Miklos Szeredi wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> I'm trying to read multiple files with io_uring and getting stuck,
>>>>>>>> because the link and drain flags don't seem to do what they are
>>>>>>>> documented to do.
>>>>>>>>
>>>>>>>> Kernel is v5.17 and liburing is compiled from the git tree at
>>>>>>>> 7a3a27b6a384 ("add tests for nonblocking accept sockets").
>>>>>>>>
>>>>>>>> Without those flags the attached example works some of the time, but
>>>>>>>> that's probably accidental since ordering is not ensured.
>>>>>>>>
>>>>>>>> Adding the drain or link flags make it even worse (fail in casese that
>>>>>>>> the unordered one didn't).
>>>>>>>>
>>>>>>>> What am I missing?
>>>>>>>
>>>>>>> I don't think you're missing anything, it looks like a bug. What you
>>>>>>> want here is:
>>>>>>>
>>>>>>> prep_open_direct(sqe);
>>>>>>> sqe->flags |= IOSQE_IO_LINK;
>>>>>>> ...
>>>>>>> prep_read(sqe);
>>>>>
>>>>> So with the below merge this works.   But if instead I do
>>>>>
>>>>> prep_open_direct(sqe);
>>>>>  ...
>>>>> prep_read(sqe);
>>>>> sqe->flags |= IOSQE_IO_DRAIN;
> 
> And this doesn't work either:
> 
> prep_open_direct(sqe);
> sqe->flags |= IOSQE_IO_LINK;
> ...
> prep_read(sqe);
> sqe->flags |= IOSQE_IO_LINK;
> ...
> prep_open_direct(sqe);
> sqe->flags |= IOSQE_IO_LINK;
> ...
> prep_read(sqe);
> 
> Yeah, the link is not needed for the read (unless the fixed file slot
> is to be reused), but link/drain should work as general ordering
> instructions, not just in special cases.

Not disagreeing with that, it had nothing to do with any assumptions
like that, it was just a bug in the change I made in terms of when
things got punted async.

Can you try and repull the branch? I rebased the top two, so reset to
v5.17 first and then pull it.

BTW, I would not recommend using DRAIN, it's very expensive compared to
just a link. Particularly, using just a single link between the
open+read makes sense, and should be efficient. Don't link between all
of them, that's creating a more expensive dependency that doesn't make
any sense for your use case either. Should they both work? Of course,
and I think they will in the current branch. Merely stating that they
make no sense other than as an exercise-the-logic test case.

-- 
Jens Axboe

