Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837E365DDE4
	for <lists+io-uring@lfdr.de>; Wed,  4 Jan 2023 21:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235514AbjADUxp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Jan 2023 15:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235489AbjADUxo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Jan 2023 15:53:44 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE6C3AA80
        for <io-uring@vger.kernel.org>; Wed,  4 Jan 2023 12:53:43 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id q190so18635830iod.10
        for <io-uring@vger.kernel.org>; Wed, 04 Jan 2023 12:53:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4bt9EaLCTYfjAm0yaVoPQbigPx+o3/Zv6b2C05q9TvM=;
        b=MieaCqjAUPW91r7KRQP0KjOCEQ6oVxjM/dAqxT7iii5s3oWSRg3MfYTN8lRo7Ihn0x
         qshproRw7QZGmLF4NuOsFWlsz1+04zvm39GRRKsorwPLDjFFpG26V/VwFBwcW5emcXuH
         z0s3UF7fMqWPqy5cRkF+U3Jl+XwIVetVwctEV40dx1Pa1m+cC70s22iz0DC08DRncTS3
         D3J1EwEKQtjkzC08F4Yf3T2j9c/Skk4ycvgCPif8ltrVoX4pjXVcXT611i74HrSUoIvV
         EEcDPbBBjGK3P51POz7V64We8TgOoRqIUWaCaRQqzx9PjxiJ4LqMhMvJUI2wMg1R5KhZ
         QhCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4bt9EaLCTYfjAm0yaVoPQbigPx+o3/Zv6b2C05q9TvM=;
        b=JYio3fdaCp6qwQI4vSMkyFmQNNLm/5OWiR1HMaPxoTbRvyna8glAYVWxbKJa4Si2Bz
         OtA5d7XXLohpr4dUhcinuI6sSd3vNrIVyAWdnJ/es8gQem51E0JejARd68GbMhNOu4gD
         HsNYNiXtm1Rj52zKvDzotoj72lz0wpoA7ZouFnr0P1fd1bLPWdEy/3EO3BMFybWbDEko
         kT+rgTfAGnbpaAqQHQhIeE6Xf+0XxyfhDUpVwl6U7MCNKaEoZV1AUgZFGaOvptp2UoWR
         fjQHu2EfJX8QwL6mN838i2FQKdkpwIat97dqzx9X2oZ9eH3BJFmzms6J10bPkix4uGDH
         OhuQ==
X-Gm-Message-State: AFqh2kq6YeDdxnVfsGo385Jx6gSNoPmAtkEd6WHeBKV1JlA2gNOyeApd
        reVwd5LlS42wUE83Vh29FvKddOKh4N5DVh2e
X-Google-Smtp-Source: AMrXdXvyrWIjZYMFZzrJPg8J/RGIP4Y0W0be4ns0J0UEbJITrOo7NkPpEKz8RrgcArngCL4grPwVqA==
X-Received: by 2002:a5d:91d5:0:b0:6cc:8b29:9a73 with SMTP id k21-20020a5d91d5000000b006cc8b299a73mr7738789ior.1.1672865622561;
        Wed, 04 Jan 2023 12:53:42 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y31-20020a029522000000b0039e28b92b51sm2132808jah.121.2023.01.04.12.53.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 12:53:42 -0800 (PST)
Message-ID: <128f7392-9fe3-f157-73c9-9c86332457ac@kernel.dk>
Date:   Wed, 4 Jan 2023 13:53:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC v2 09/13] io_uring: separate wq for ring polling
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1672713341.git.asml.silence@gmail.com>
 <0fbee0baf170cbfb8488773e61890fc78ed48d1e.1672713341.git.asml.silence@gmail.com>
 <1968c5b9-dd2b-4ed1-14a0-8f78b302bf2d@kernel.dk>
 <894c3092-9561-1a32-fb4c-8bf33e3667a1@gmail.com>
 <75dcfbaf-5822-0b20-5580-1f6ac3ba7f20@kernel.dk>
 <9638d8ff-6995-c7f4-1bbc-dccae70eb936@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <9638d8ff-6995-c7f4-1bbc-dccae70eb936@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/4/23 1:45?PM, Pavel Begunkov wrote:
> On 1/4/23 20:34, Jens Axboe wrote:
>> On 1/4/23 1:28?PM, Pavel Begunkov wrote:
>>> On 1/4/23 18:08, Jens Axboe wrote:
>>>> On 1/2/23 8:04?PM, Pavel Begunkov wrote:
>>>>> Don't use ->cq_wait for ring polling but add a separate wait queue for
>>>>> it. We need it for following patches.
>>>>>
>>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>>> ---
>>>>>    include/linux/io_uring_types.h | 1 +
>>>>>    io_uring/io_uring.c            | 3 ++-
>>>>>    io_uring/io_uring.h            | 9 +++++++++
>>>>>    3 files changed, 12 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>>>>> index dcd8a563ab52..cbcd3aaddd9d 100644
>>>>> --- a/include/linux/io_uring_types.h
>>>>> +++ b/include/linux/io_uring_types.h
>>>>> @@ -286,6 +286,7 @@ struct io_ring_ctx {
>>>>>            unsigned        cq_entries;
>>>>>            struct io_ev_fd    __rcu    *io_ev_fd;
>>>>>            struct wait_queue_head    cq_wait;
>>>>> +        struct wait_queue_head    poll_wq;
>>>>>            unsigned        cq_extra;
>>>>>        } ____cacheline_aligned_in_smp;
>>>>>    
>>>>
>>>> Should we move poll_wq somewhere else, more out of the way?
>>>
>>> If we care about polling perf and cache collisions with
>>> cq_wait, yeah we can. In any case it's a good idea to at
>>> least move it after cq_extra.
>>>
>>>> Would need to gate the check a flag or something.
>>>
>>> Not sure I follow
>>
>> I guess I could've been a bit more verbose... If we consider poll on the
>> io_uring rather uncommon, then moving the poll_wq outside of the hotter
>> cq_wait cacheline(s) would make sense. Each wait_queue_head is more than
>> a cacheline.
> 
> Looks it's 24B, and wait_queue_entry is uncomfortable 40B.

(also see followup email). Yes, it's only 24 bytes indeed.

>> Then we could have a flag in a spot that's hot anyway
>> whether to check it or not, eg in that same section as cq_wait.
>> Looking at the layout right now, we're at 116 bytes for that section, or
>> two cachelines with 12 bytes to spare. If we add poll_wq, then we'll be
>> at 196 bytes, which is 4 bytes over the next cacheline. So it'd
>> essentially double the size of that section. If we moved it outside of
>> the aligned sections, then it'd pack better.
> 
> Than it's not about hotness and caches but rather memory
> consumption due to padding, which is still a good argument.

Right, it's nice to not keep io_ring_ctx bigger than it needs to be. And
if moved out-of-line, then it'd pack better and we would not "waste"
another cacheline on adding this wait_queue_head for polling.

-- 
Jens Axboe

