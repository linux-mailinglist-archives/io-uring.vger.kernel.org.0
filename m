Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDB44EB34D
	for <lists+io-uring@lfdr.de>; Tue, 29 Mar 2022 20:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240532AbiC2S15 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Mar 2022 14:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240527AbiC2S14 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Mar 2022 14:27:56 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39BD98F47
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 11:26:12 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id 125so22038568iov.10
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 11:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=g9A4NftQS0NAGt2vvdqLHDcZntu7PyBD2u+4jbKKQF8=;
        b=mrnO+06SPRaF2OPpTrjywUjz/3doLeVSq2kEP63ld0cMghdBJ0rc2rJBHR/TmyxHhV
         c8Pvj+saKCb+t1OJcWQbfPs3y9sPqBQuR0eH3Xaar09mlZ9hXUIQSs2vl+8XDGVCCcJ+
         Otlz9cFAvynB3tMMRJ8Zy+HpF4ZEV3PXnZOkB2AZNQtyijbD/HK+ZDgShxCuge69vXQE
         igWN4GY7QL6+p2svEMzZh4sElRzmC9+NAAmF3FLfa/ExuwWnZBiIDaiYmfu5bulS/0HB
         ODHbJOsTqoRzmj893WEIfTdXS9olGXlarL8gf9zQl+SCPE2PENDxKXi2zz0luPO8YY5j
         A4kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=g9A4NftQS0NAGt2vvdqLHDcZntu7PyBD2u+4jbKKQF8=;
        b=GNYXrztMj1/3cy3Dxt1ySFykSmXNsRGENiDBKDM+XEfLHSHx81nL2rMzTe7BL44I42
         HwmwA+4HQDja1ZO+BL6JtTE07eTAZ6OMOx/eAUhCX4Fg+B4FsAZWVJyDbND8iJbIpaVL
         3wipAU9NGCQgxA7X505GLv9wm2LCjy6MVpjNvHZo7ODHHHQa+vOBKEGcfhycUWWQaL01
         5UIsZ7b95zqaa/gU/Gy4t+a0rG2n1TO86CxsYnKAA3wDoGVkTLg+WbZG7cqrtBN7qTnC
         7RMHKrDQidnB6Ww6WzVUG0X/nxNgFtWnDKWKygdtnMaJ+NECN3X8Y+Aj9i1hxcsqusyo
         V2pA==
X-Gm-Message-State: AOAM5334Ar2tLnJuw3Eh94zCwi/7wy0roJl1r0V9tJJ89ARU8c+f/bq9
        LH1ewFLDn1DhxFrXWDo0gRk7xOnbcGKW3P23
X-Google-Smtp-Source: ABdhPJzbvWY7+BfZ8qh5J1LYMOZo4CkfjjLw13vj2RJ87BOPH6uddB5kk6Vd4gK0J3s4bwNhNjmn6g==
X-Received: by 2002:a02:944e:0:b0:31a:2e9:bfa6 with SMTP id a72-20020a02944e000000b0031a02e9bfa6mr17238060jai.277.1648578371687;
        Tue, 29 Mar 2022 11:26:11 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b14-20020a92c84e000000b002c9bdfacabasm3095418ilq.53.2022.03.29.11.26.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Mar 2022 11:26:11 -0700 (PDT)
Message-ID: <115fc7d1-9b9c-712b-e75d-39b2041df437@kernel.dk>
Date:   Tue, 29 Mar 2022 12:26:10 -0600
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
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAJfpegs1o3HNkpxPa85LmNCoVVk-T2rt3vJXBvRf_M93P+6ouA@mail.gmail.com>
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

On 3/29/22 12:21 PM, Miklos Szeredi wrote:
> On Tue, 29 Mar 2022 at 19:04, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 3/29/22 10:08 AM, Jens Axboe wrote:
>>> On 3/29/22 7:20 AM, Miklos Szeredi wrote:
>>>> Hi,
>>>>
>>>> I'm trying to read multiple files with io_uring and getting stuck,
>>>> because the link and drain flags don't seem to do what they are
>>>> documented to do.
>>>>
>>>> Kernel is v5.17 and liburing is compiled from the git tree at
>>>> 7a3a27b6a384 ("add tests for nonblocking accept sockets").
>>>>
>>>> Without those flags the attached example works some of the time, but
>>>> that's probably accidental since ordering is not ensured.
>>>>
>>>> Adding the drain or link flags make it even worse (fail in casese that
>>>> the unordered one didn't).
>>>>
>>>> What am I missing?
>>>
>>> I don't think you're missing anything, it looks like a bug. What you
>>> want here is:
>>>
>>> prep_open_direct(sqe);
>>> sqe->flags |= IOSQE_IO_LINK;
>>> ...
>>> prep_read(sqe);
> 
> So with the below merge this works.   But if instead I do
> 
> prep_open_direct(sqe);
>  ...
> prep_read(sqe);
> sqe->flags |= IOSQE_IO_DRAIN;
> 
> than it doesn't.  Shouldn't drain have a stronger ordering guarantee than link?

I didn't test that, but I bet it's running into the same kind of issue
wrt prep. Are you getting -EBADF? The drain will indeed ensure that
_execution_ doesn't start until the previous requests have completed,
but it's still prepared before.

For your use case, IO_LINK is what you want and that must work.

I'll check the drain case just in case, it may in fact work if you just
edit the code base you're running now and remove these two lines from
io_init_req():

if (unlikely(!req->file)) {
-        if (!ctx->submit_state.link.head)
-                return -EBADF;
        req->result = fd;
        req->flags |= REQ_F_DEFERRED_FILE;
}

to not make it dependent on link.head. Probably not a bad idea in
general, as the rest of the handlers have been audited for req->file
usage in prep.

-- 
Jens Axboe

