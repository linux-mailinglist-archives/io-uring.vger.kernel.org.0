Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 020036EE4F5
	for <lists+io-uring@lfdr.de>; Tue, 25 Apr 2023 17:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234533AbjDYPrk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Apr 2023 11:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233799AbjDYPrj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Apr 2023 11:47:39 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58635586
        for <io-uring@vger.kernel.org>; Tue, 25 Apr 2023 08:47:36 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-94a39f6e8caso1118432066b.0
        for <io-uring@vger.kernel.org>; Tue, 25 Apr 2023 08:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682437655; x=1685029655;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AwrCCFyxt2wo2CUF32QtXZVYBCDXk3aDoTs93YdpXkg=;
        b=d9ybziZnXJaOsLTbOrWvEoxmzcXukmtApXroNGQF9Q3sk/0TwCsjNNOhlKydTCeR2P
         5KVyfIU3Nyo0HdaE7MmpwbvvfLDRnco1SMBZNIK5FSzghnSOG/toxHNHPsqb7SOgrw3X
         RX+Ic8lfpMsT3I5EVgIt6iI5OyfYxJHyrkx0VWWjjNem7ncNRtALXZLWly4IJjDUdik4
         JOSZsVMZpZzO+Y4i5wsnf2pMtdlTrbyAE0bdevOdPNXOfGWb0VVs06gR72EEwEB4Nv7E
         F4BPiaV/HpQr9ayLwAkr31y9Wnq1l9VAwhQ3stIqy8LBNCpVRwIsEZ2L9YVCU2cJdZNo
         oABg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682437655; x=1685029655;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AwrCCFyxt2wo2CUF32QtXZVYBCDXk3aDoTs93YdpXkg=;
        b=UIjgi4dbeGy4vdax7Uo0+V7mv9XqxFo4LhRMcq1uR83KLpckNdiXBKVI3zChQKKie5
         TNTWaE30X8J31u5xFONIh2qJTm9jwPPcRnr51NZRzGy7ho5qhYcvYxX9z849TGTweKKH
         s+wcnrr+6WKcKy754/BLdikHJ4uePSr/KZMMXIcdAklZ7ChnqC6FMwB+Ltvie6iMTnR9
         oVuDsOv/N6w4xq91qTrt1tMI4l1A6pPFia+KDpzpWMjLYdz17zshIo4yeM1+j8AdIM6N
         N/g99D+ci1LNJtFLb5FEgRHxqfSzSo6idGupK8cTkonoRFEF9YW1H1A+jHrkJkOegqeU
         wirQ==
X-Gm-Message-State: AAQBX9cJJTAafctiPemwFVurxfRcBX2YiPNNVCXKj1bvOaJz+2H8XX6G
        +1zEEj88GFdsgW5JLnsvvVk=
X-Google-Smtp-Source: AKy350YsXb5oHROxV0q6JIGzryssbeUv7K4/LPJlsmqV6048F/6uSO6MJYC8DTMCaD0NQ1Ewrsu3og==
X-Received: by 2002:a17:906:90c8:b0:92b:e1ff:be30 with SMTP id v8-20020a17090690c800b0092be1ffbe30mr11121656ejw.4.1682437654794;
        Tue, 25 Apr 2023 08:47:34 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:7aec])
        by smtp.gmail.com with ESMTPSA id m5-20020a170906848500b0094ef96a6564sm6865943ejx.75.2023.04.25.08.47.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Apr 2023 08:47:34 -0700 (PDT)
Message-ID: <ee5ffd39-a810-e734-1eba-fcdee9fb5cad@gmail.com>
Date:   Tue, 25 Apr 2023 16:46:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 4/4] io_uring: mark opcodes that always need io-wq punt
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org
References: <ZEYwAkk7aXKfQKKr@ovpn-8-16.pek2.redhat.com>
 <b5e48439-0427-98a8-3288-99426ae36b45@kernel.dk>
 <ZEclhYPobt94OndL@ovpn-8-24.pek2.redhat.com>
 <478df0f7-c167-76f3-3fd8-9d5771a44048@kernel.dk>
 <ZEc3WttIofAqFy+b@ovpn-8-24.pek2.redhat.com>
 <a1c8d37f-ca21-3648-9a37-741e7519650b@kernel.dk>
 <ZEc/5Xyqvu2WkWyk@ovpn-8-24.pek2.redhat.com>
 <0e5910a9-d776-cdea-1852-edd995f93dc8@kernel.dk>
 <ZEfmzALXP9vqWkOV@ovpn-8-24.pek2.redhat.com>
 <a3225f4c-d0aa-e20e-6df3-84a996fe66dd@kernel.dk>
 <ZEfso1qH41MWKZV6@ovpn-8-24.pek2.redhat.com>
 <dd711c1b-8743-75ea-2368-a3f53316a030@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <dd711c1b-8743-75ea-2368-a3f53316a030@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/25/23 16:25, Jens Axboe wrote:
> On 4/25/23 9:07?AM, Ming Lei wrote:
>> On Tue, Apr 25, 2023 at 08:50:33AM -0600, Jens Axboe wrote:
>>> On 4/25/23 8:42?AM, Ming Lei wrote:
>>>> On Tue, Apr 25, 2023 at 07:31:10AM -0600, Jens Axboe wrote:
>>>>> On 4/24/23 8:50?PM, Ming Lei wrote:
>>>>>> On Mon, Apr 24, 2023 at 08:18:02PM -0600, Jens Axboe wrote:
>>>>>>> On 4/24/23 8:13?PM, Ming Lei wrote:
>>>>>>>> On Mon, Apr 24, 2023 at 08:08:09PM -0600, Jens Axboe wrote:
>>>>>>>>> On 4/24/23 6:57?PM, Ming Lei wrote:
>>>>>>>>>> On Mon, Apr 24, 2023 at 09:24:33AM -0600, Jens Axboe wrote:
>>>>>>>>>>> On 4/24/23 1:30?AM, Ming Lei wrote:
>>>>>>>>>>>> On Thu, Apr 20, 2023 at 12:31:35PM -0600, Jens Axboe wrote:
>>>>>>>>>>>>> Add an opdef bit for them, and set it for the opcodes where we always
>>>>>>>>>>>>> need io-wq punt. With that done, exclude them from the file_can_poll()
>>>>>>>>>>>>> check in terms of whether or not we need to punt them if any of the
>>>>>>>>>>>>> NO_OFFLOAD flags are set.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>>>>>>>> ---
>>>>>>>>>>>>>   io_uring/io_uring.c |  2 +-
>>>>>>>>>>>>>   io_uring/opdef.c    | 22 ++++++++++++++++++++--
>>>>>>>>>>>>>   io_uring/opdef.h    |  2 ++
>>>>>>>>>>>>>   3 files changed, 23 insertions(+), 3 deletions(-)
>>>>>>>>>>>>>
>>>>>>>>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>>>>>>>>>> index fee3e461e149..420cfd35ebc6 100644
>>>>>>>>>>>>> --- a/io_uring/io_uring.c
>>>>>>>>>>>>> +++ b/io_uring/io_uring.c
>>>>>>>>>>>>> @@ -1948,7 +1948,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>>>>>>>>>>>>>   		return -EBADF;
>>>>>>>>>>>>>   
>>>>>>>>>>>>>   	if (issue_flags & IO_URING_F_NO_OFFLOAD &&
>>>>>>>>>>>>> -	    (!req->file || !file_can_poll(req->file)))
>>>>>>>>>>>>> +	    (!req->file || !file_can_poll(req->file) || def->always_iowq))
>>>>>>>>>>>>>   		issue_flags &= ~IO_URING_F_NONBLOCK;
>>>>>>>>>>>>
>>>>>>>>>>>> I guess the check should be !def->always_iowq?
>>>>>>>>>>>
>>>>>>>>>>> How so? Nobody that takes pollable files should/is setting
>>>>>>>>>>> ->always_iowq. If we can poll the file, we should not force inline
>>>>>>>>>>> submission. Basically the ones setting ->always_iowq always do -EAGAIN
>>>>>>>>>>> returns if nonblock == true.
>>>>>>>>>>
>>>>>>>>>> I meant IO_URING_F_NONBLOCK is cleared here for  ->always_iowq, and
>>>>>>>>>> these OPs won't return -EAGAIN, then run in the current task context
>>>>>>>>>> directly.
>>>>>>>>>
>>>>>>>>> Right, of IO_URING_F_NO_OFFLOAD is set, which is entirely the point of
>>>>>>>>> it :-)
>>>>>>>>
>>>>>>>> But ->always_iowq isn't actually _always_ since fallocate/fsync/... are
>>>>>>>> not punted to iowq in case of IO_URING_F_NO_OFFLOAD, looks the naming of
>>>>>>>> ->always_iowq is a bit confusing?
>>>>>>>
>>>>>>> Yeah naming isn't that great, I can see how that's bit confusing. I'll
>>>>>>> be happy to take suggestions on what would make it clearer.
>>>>>>
>>>>>> Except for the naming, I am also wondering why these ->always_iowq OPs
>>>>>> aren't punted to iowq in case of IO_URING_F_NO_OFFLOAD, given it
>>>>>> shouldn't improve performance by doing so because these OPs are supposed
>>>>>> to be slow and always slept, not like others(buffered writes, ...),
>>>>>> can you provide one hint about not offloading these OPs? Or is it just that
>>>>>> NO_OFFLOAD needs to not offload every OPs?
>>>>>
>>>>> The whole point of NO_OFFLOAD is that items that would normally be
>>>>> passed to io-wq are just run inline. This provides a way to reap the
>>>>> benefits of batched submissions and syscall reductions. Some opcodes
>>>>> will just never be async, and io-wq offloads are not very fast. Some of
>>>>
>>>> Yeah, seems io-wq is much slower than inline issue, maybe it needs
>>>> to be looked into, and it is easy to run into io-wq for IOSQE_IO_LINK.
>>>
>>> Indeed, depending on what is being linked, you may see io-wq activity
>>> which is not ideal.
>>
>> That is why I prefer to fused command for ublk zero copy, because the
>> registering buffer approach suggested by Pavel and Ziyang has to link
>> register buffer OP with the actual IO OP, and it is observed that
>> IOPS drops to 1/2 in 4k random io test with registered buffer approach.
> 
> It'd be worth looking into if we can avoid io-wq for link execution, as
> that'd be a nice win overall too. IIRC, there's no reason why it can't
> be done like initial issue rather than just a lazy punt to io-wq.

I might've missed a part of the discussion, but links are _usually_
executed by task_work, e.g.

io_submit_flush_completions() -> io_queue_next() -> io_req_task_queue()

There is one optimisation where if we're already in io-wq, it'll try
to serve the next linked request by the same io-wq worker with no
overhead on requeueing, but otherwise it'll only get there if
the request can't be executed nowait / async as per usual rules.

The tw execution part might be further optimised, it can be executed
almost in place instead of queueing a tw. It saved quite a lot of CPU
when I tried it with BPF requests.

-- 
Pavel Begunkov
