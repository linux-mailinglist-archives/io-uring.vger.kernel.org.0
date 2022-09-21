Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCED5BFE8D
	for <lists+io-uring@lfdr.de>; Wed, 21 Sep 2022 15:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiIUNB2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Sep 2022 09:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiIUNB1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Sep 2022 09:01:27 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9954C8E446
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 06:01:23 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id x18so3747966wrm.7
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 06:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=tO3vf7+eRdpUXlRwUTHA40jgggywuUCrzKTMOTBSav8=;
        b=oP0TEG60hSb4GKiFYqy6hZ6MCfQN25OTbwa1cY6fgZDCnCY4VaF5AroDRnIwa+TdW3
         65IOcvNF9ZwhwenCsSIye9fzFqpudmO6Fm1UdKx8qz/tdMsb3vUBXTQLDR9DnLALM7IV
         pxci3snfshy6sZosHZuCrTkRBPorgga0911gtQlBqDvH68IQumOm7p0wZHGRWAsffoFq
         8Vlqvp31tBJ9OgZYj/z+DYTXdpH1ZSx6DVU8V8mZPIa6KtLHT5jhNTlY3De4zDbFPqor
         BCRKNl7UwWSwz34FFYXTkb+2oBtn7KHfYfbTzYrFr0WaRIqEWYUR/BI6LNqUGq31kqTO
         Wzgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=tO3vf7+eRdpUXlRwUTHA40jgggywuUCrzKTMOTBSav8=;
        b=118wEatMtIVHpKwlLGfB/uokeS6pxiO6XYKZTP3beSl4IWFnxWCxrfxgUi+esTvTSz
         qITY3qrzHGISoBhuMhAB2nyNDX8TMBFTjR/oajT2uwB5SrsXPiE3wgAyOygZ3GOqANMp
         lkrZcFAOlRJonD76fQICAEDMpmDc5kCCCuY4Mh/qEBhSg7Rpchs9yWi0Veq4lSs3Yk8T
         h5qNXZkttiCAb8/CK54AbqguU3cafbRb0AHUsM/DIMqNyHGv5fiEbtDwtJCDsFV9E4LF
         pJAYyuOk737IzErmMsCCvuJrwGvD8yhPOi+ZXTqy0A2bC/XByDsr7lYR3vQQzSH2kgid
         zI4Q==
X-Gm-Message-State: ACrzQf3AStaqDUHNcdO8PzI1gpG2khsGclSl5u+6HVZTvLDP+AI8dj9T
        xK/wLzplF2xA0+JOHgVukLA=
X-Google-Smtp-Source: AMsMyM4vVDT/f3x0zGJt+yB+xegt26p+yMxe6cjPf0BB+ayf2cyWqeClzRq3IEiLxSS2TzArBF3SOw==
X-Received: by 2002:a5d:5312:0:b0:228:cc9e:b70f with SMTP id e18-20020a5d5312000000b00228cc9eb70fmr17419759wrv.11.1663765282028;
        Wed, 21 Sep 2022 06:01:22 -0700 (PDT)
Received: from [192.168.8.198] (188.28.205.62.threembb.co.uk. [188.28.205.62])
        by smtp.gmail.com with ESMTPSA id p8-20020a05600c358800b003b47e8a5d22sm3183093wmq.23.2022.09.21.06.01.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 06:01:21 -0700 (PDT)
Message-ID: <8a43f632-d8fb-b8ec-254e-7b9af38f50b0@gmail.com>
Date:   Wed, 21 Sep 2022 13:58:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH for-6.0 0/5] IORING_OP_SEND_ZC improvements
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org,
        axboe@kernel.dk
References: <cover.1663363798.git.metze@samba.org>
 <734a8945-3668-5aa8-df8a-a858213e73ed@gmail.com>
 <a5e2e475-3e81-4375-897d-172c4711e3d1@samba.org>
 <8b456f19-f209-a83e-a346-ff8ea7f190ac@gmail.com>
 <4b84da78-0ff9-5b29-907c-2f8a392baf80@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4b84da78-0ff9-5b29-907c-2f8a392baf80@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/21/22 13:18, Stefan Metzmacher wrote:
> 
> Hi Pavel,
> 
>>>> If network sends anything it should return how many bytes
>>>> it queued for sending, otherwise there would be duplicated
>>>> packets / data on the other endpoint in userspace, and I
>>>> don't think any driver / lower layer would keep memory
>>>> after returning an error.
>>>
>>> As I'm also working on a socket driver for smbdirect,
>>> I already thought about how I could hook into
>>> IORING_OP_SEND[MSG]_ZC, and for sendmsg I'd have
>>> a loop sending individual fragments, which have a reference,
>>> but if I find a connection drop after the first one, I'd
>>> return ECONNRESET or EPIPE in order to get faster recovery
>>> instead of announcing a short write to the caller.
>>
>> I doesn't sound right for me, but neither I know samba to
>> really have an opinion. In any case, I see how it may be
>> more robust if we always try to push a notification cqe.
>> Will you send a patch?
> 
> You mean the IORING_OP_SEND_ZC should always
> issue a NOTIF cqe, one it passed the io_sendzc_prep stage?

Currently we add F_MORE iff cqe->res >= 0, but I want to
decouple them so users don't try to infer one from another.

In theory, it's already a subset of this, but it sounds
like a good idea to always emit notifications (when we can)
to stop users making assumptions about it. And should also
be cleaner.

>>> If we would take my 5/5 we could also have a different
>>> strategy to check decide if MORE/NOTIF is needed.
>>> If notif->cqe.res is still 0 and io_notif_flush drops
>>> the last reference we could go without MORE/NOTIF at all.
>>> In all other cases we'd either set MORE/NOTIF at the end
>>> of io_sendzc of in the fail hook.
>>
>> I had a similar optimisation, i.e. when io_notif_flush() in
>> the submission path is dropping the last ref, but killed it
>> as it was completely useless, I haven't hit this path even
>> once even with UDP, not to mention TCP.
> 
> If I remember correctly I hit it all the time on loopback,
> but I'd have to recheck.

Yeah, I meant real network in particular. I've seen it with
virtual interfaces, but for instance loopback is not interesting
as it doesn't support zerocopy in the first place. You was
probably testing with a modified skb_orphan_frags_rx().

>>>> In any case, I was looking on a bit different problem, but
>>>> it should look much cleaner using the same approach, see
>>>> branch [1], and patch [3] for sendzc in particular.
>>>>
>>>> [1] https://github.com/isilence/linux.git partial-fail
>>>> [2] https://github.com/isilence/linux/tree/io_uring/partial-fail
>>>> [3] https://github.com/isilence/linux/commit/acb4f9bf869e1c2542849e11d992a63d95f2b894
>>>
>>>      const struct io_op_def *def = &io_op_defs[req->opcode];
>>>
>>>      req_set_fail(req);
>>>      io_req_set_res(req, res, io_put_kbuf(req, IO_URING_F_UNLOCKED));
>>>      if (def->fail)
>>>          def->fail(req);
>>>      io_req_complete_post(req);
>>>
>>> Will loose req->cqe.flags, but the fail hook in general looks like a good idea.
>>
>> I just don't like those sporadic changes all across core io_uring
>> code also adding some overhead.
>>
>>> And don't we care about the other failure cases where req->cqe.flags gets overwritten?
>>
>> We don't usually carry them around ->issue handler boundaries,
>> e.g. directly do io_post_aux_cqe(res, IORING_CQE_F_MORE);
>>
>> IORING_CQE_F_BUFFER is a bit more trickier, but there is
>> special handling for this one and it wouldn't fit "set cflags
>> in advance" logic anyway.
>>
>> iow, ->fail callback sounds good enough for now, we'll change
>> it later if needed.
> 
> The fail hook should re-add the MORE flag?

Never set CQE_SKIP for notifications and add MORE flag in the
fail hook, sounds good.


> So I'll try to do the following changes:
> 
> 1. take your ->fail() patches
> 
> 2. once io_sendzc_prep() is over always trigger MORE/NOFIF cqes
>     (But the documentation should still make it clear that
>      userspace have to cope with just a single cqe (without MORE)
>      for both successs and failure, so that we can improve things later)

I've sent a liburing man patch, should be good enough.

> 3. Can I change the cqe.res of the NOTIF cqe to be 0xffffffff ?
>     That would indicate to userspace that we don't give any information
>     if zero copy was actually used or not. This would present someone
>     from relying on cqe.res == 0 and we can improve it by providing
>     more useful values in future.

I don't get the difference, someone just as easily may rely on
0xf..ff. What does it gives us? 0 usually suits better as default.

> Are you ok with that plan for 6.0?

It's late 1-2 are better to be 6.1 + stable. It doesn't break uapi,
so it's fine. It's not even strictly necessary to back port it
(but still a good idea to do it).

-- 
Pavel Begunkov
