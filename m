Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B93D6CD7DB
	for <lists+io-uring@lfdr.de>; Wed, 29 Mar 2023 12:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjC2Ko1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Mar 2023 06:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjC2Ko0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Mar 2023 06:44:26 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C510A1FDA;
        Wed, 29 Mar 2023 03:44:24 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id b20so61385070edd.1;
        Wed, 29 Mar 2023 03:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680086663;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uYdRSUd+n++FaO/4RlA8ykxHRkEtbyhjS8QfPtLh9yw=;
        b=kZtgk5Np3tArpEQNhAakEddngqh1o/X/PKQXRwbrDrzVRyJAw8V4HChbSNjrI4SC6W
         mNpojHznDTYqiL0ve8xC0idcKWAFG5FngJb5igh396mXCS/MuyGYqayih6vcdrGpy5fl
         obhOt4guIAgM1W1JZ8o0tHus3Trrnz3fefPNtEI83YIdS0Yw4lYaFZBfA5rhBai8nXUk
         7A1wEfqbO35IidPQ9rmdTkz0q1rXb3ldGGfFaAFz7Z2z3TG+LqjXwbJFltcL6gscFBLq
         tvJDOalUrd/D+SGrE/jur8kx/kdJjCstvax8grhbygeeQL/by4koeE7JRk4fbHzuPnqE
         RT0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680086663;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uYdRSUd+n++FaO/4RlA8ykxHRkEtbyhjS8QfPtLh9yw=;
        b=Ot3j9mES/I5oYHA/vJwlp8ePJa/ZnSzVzWyiUd1EmtKD0yipv4a+/xBbRzdCf60GCU
         gf40wuhvVlwKuHy1f6KVhmK0V+v1byd3gBZCJ5mt2mu4heAFBz/MXb7M36720RtXbx2y
         4bw6757jDsbMctVQijZr0OSlcmPmgKql/dVZyqZFyF9JWda+eIc0NsC0IeN70qXmT87p
         WYpNSdjiGhwhlArCav0GrY0/gmGaqXCkuRO2sXCx9IrEAJaUxXlK+ZvZEEUTbmkOpltO
         nPv5DE0YSp/ZD1vNBmZaDvuOFZlq1EwToTqFdnvphOL2GOdhP8x3FhxKxLTkPzg5NdVg
         vVnw==
X-Gm-Message-State: AAQBX9cjT6R4+u2773lFIlo0a0Pcb7tsHnUsphP2G2RkSAxYzSbsE2qI
        jdEwIzLCaUkn1IliQ2GH22I=
X-Google-Smtp-Source: AKy350aUkQDG8M1RisM4OFczmgLLZ/g+Hl7xGo/SK2SuMdG9dTsk8sjFgxCsR0xuU0zhYik/yyzdkA==
X-Received: by 2002:a17:907:2099:b0:8b0:ad0b:7ab8 with SMTP id pv25-20020a170907209900b008b0ad0b7ab8mr19361318ejb.14.1680086663097;
        Wed, 29 Mar 2023 03:44:23 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:5e48])
        by smtp.gmail.com with ESMTPSA id f3-20020a17090624c300b0092a59ee224csm16264021ejb.185.2023.03.29.03.44.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 03:44:22 -0700 (PDT)
Message-ID: <ac0c51aa-7240-94b9-476a-9401911ee481@gmail.com>
Date:   Wed, 29 Mar 2023 11:43:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH V3 00/16] io_uring/ublk: add IORING_OP_FUSED_CMD
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>
References: <20230314125727.1731233-1-ming.lei@redhat.com>
 <ZBQhSzIhvZL+83nM@ovpn-8-18.pek2.redhat.com>
 <3971d43f-601f-635f-5a30-df7e647f6659@kernel.dk>
 <ZBW+PCaeNmCR/k0M@ovpn-8-18.pek2.redhat.com>
 <4f8161e7-5229-45c4-1bb2-b86d87e22a16@gmail.com>
 <ZBZJXb6vQ7z4CYk/@ovpn-8-18.pek2.redhat.com>
 <8b227cf3-6ad1-59ad-e13b-a46381958a4c@gmail.com>
 <ZCLlIAnBWOm59rIM@ovpn-8-20.pek2.redhat.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZCLlIAnBWOm59rIM@ovpn-8-20.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/28/23 14:01, Ming Lei wrote:
> On Tue, Mar 28, 2023 at 11:55:38AM +0100, Pavel Begunkov wrote:
>> On 3/18/23 23:42, Ming Lei wrote:
>>> On Sat, Mar 18, 2023 at 04:51:14PM +0000, Pavel Begunkov wrote:
>>>> On 3/18/23 13:35, Ming Lei wrote:
>>>>> On Sat, Mar 18, 2023 at 06:59:41AM -0600, Jens Axboe wrote:
>>>>>> On 3/17/23 2:14?AM, Ming Lei wrote:
>>>>>>> On Tue, Mar 14, 2023 at 08:57:11PM +0800, Ming Lei wrote:
>> [...]
>>>>> IMO, splice(->splice_read()) can help much less in this use case, and
>>>>> I can't see improvement David Howells has done in this area:
>>>>
>>>> Let me correct a misunderstanding I've seen a couple of times
>>>> from people. Apart from the general idea of providing buffers, it's
>>>> not that bound to splice. Yes, I reused splicing guts for that
>>>> half-made POC, but we can add a new callback that would do it a
>>>> bit nicer, i.e. better consolidating returned buffers. Would
>>>
>>> ->release() is for releasing pipe-buffer(page), instead of the whole buffer(reference).
>>>> probably be even better to have both of them falling back to
>>>> splice so it can cover more cases. The core of it is mediating
>>>> buffers through io_uring's registered buffer table, which
>>>> decouples all the components from each other.
>>>
>>> For using pipe buffer's ->release() to release the whole buffer's
>>> reference, you have to allocate one pipe for each fixed buffer, and add
>>> pipe buffer to it, and keep each pipe buffer into the pipe
>>> until it is consumed, since ->release() needs to be called when
>>> unregistering buffer(all IOs are completed)
>>
>> What I'm saying is that I'm more concerned about the uapi,
>> whether internally it's ->splice_read(). I think ->splice_read()
>> has its merit in a hybrid approach, but simplicity let's say for
>> we don't use it and there is a new f_op callback or it's
>> it's returned with by cmd requests.
> 
> OK, then forget splice if you add new callback, isn't that what this
> patchset(just reuse ->uring_cmd()) is doing?

It certainly similar in many aspects! And it's also similar to
splicing with pipes, just instead of pipes there is io_uring and,
of course, semantics changes. The idea is to decouple requests from
each other with a different uapi.

>>> It(allocating/free pipe node, and populating it with each page) is
>>> really inefficient for handling one single IO.
>>
>> It doesn't need pipe node allocation. We'd need to allocate
>> space for pages, but again, there is a good io_uring infra
>> for it without any single additional lock taken in most cases.
> 
> Then it is same with this patchset.
> 
>>
>>
>>> So re-using splice for this purpose is still bad not mention splice
>>> can't support writeable spliced page.
>>>
>>> Wiring device io buffer with context registered buffer table looks like
>>> another approach, however:
>>>
>>> 1) two uring command OPs for registering/unregistering this buffer in io fast
>>> path has to be added since only userspace can know when buffer(reference)
>>> isn't needed
>>
>> Yes, that's a good point. Registration replaces fuse master cmd, so it's
>> one extra request for unregister, which might be fine.
> 
> Unfortunately I don't think this way is good, the problem is that buffer
> only has physical pages, and doesn't have userspace mapping, so why bother
> to export it to userspace?
> 
> As I replied to Ziyang, the current fused command can be extended to
> this way easily, but I don't know why we need to use the buffer registration,
> given userspace can't read/write the buffer, and fused command can cover
> it just fine.

I probably mentioned it before, but that's where we need a new memcpy
io_uring request type, to partially copy it, e.g. headers. I think people
mentioned memcpy before in general, and it will also be used for DMA driven
copies if Keith returns back to experiments.

Apart from it and things like broadcasting, sending different chunks to
different places and so, there is a typical problem what to do when the
second operation fails but the data has already been received, mostly
relevant to sockets / streams.

>>> 2) userspace becomes more complicated, 3+ OPs are required for handling one
>>> single device IO
>>>
>>> 3) buffer reference crosses multiple OPs, for cleanup the registered buffer,
>>> we have to store the device file & "buffer key" in each buffer(such as io_uring_bvec_buf)
>>> for unregistering buffer
>>
>> It should not necessarily be a file.
> 
> At least in ublk's case, from io_uring viewpoint, the buffer is owned by
> ublk device, so we need the device node or file for releasing the
> buffer.

For example, io_uring has a lightweight way to pin the context
(pcpu refcount). I haven't looked into ublk code, it's hard for
me to argue about it.

>>> 4) here the case is totally different with io_mapped_ubuf which isn't
>>> related to any specific file, and just belong to io_uring context; however,
>>> the device io buffer belongs to device(file) actually, so in theory it is wrong
>>> to put it into context's registered buffer table, and supposed to put into
>>
>> Not at all, it doesn't belong to io_uring but rather to the user space,
>> without a file, right, but io_uring still only borrowing it.
> 
> How can one such buffer be owned by userspace? What if the userspace is
> killed? If you think userspace can grab the buffer reference, that still
> needs userspace to release the buffer, but that is unreliable, and
> io_uring has to cover the buffer cleanup in case of userspace exit abnormally.

Conceptually userspace owns buffers and io_uring is share / borrowing it.
Probably, I misunderstood and you was talking about refcounting or something
else. Can you elaborate? As for references, io_uring pins normal buffers
and so holds additional refs.

> Because buffer lifetime is crossing multiple OPs if you implement buffer
> register/unregister OPs. And there isn't such issue for fused command
> which has same lifetime with the buffer.
> 
>>
>> As for keeping files, I predict that it'll be there anyway in some time,
>> some p2pdma experiments, dma preregistration, all required having a file
>> attached to the buffer.
>>
>>> per-file buffer table which isn't supported by io_uring, or it becomes hard to
>>> implement multiple-device io buffer in single context since 'file + buffer key'
>>> has to be used to retrieve this buffer, probably xarray has to be
>>> relied, but
>>
>> I was proposing to give slot selection to the userspace, perhaps with
>> optional auto index allocation as it's done with registered files.
> 
> As I mentioned above, it doesn't make sense to export buffer to
> userspace which can't touch any data of the buffer at all.

replied above.

>>> 	- here the index is (file, buffer key) if the table is per-context, current
>>> 	xarray only supports index with type of 'unsigned long', so looks not doable
>>> 	- or per-file xarray has to be used, then the implementation becomes more complicated
>>> 	- write to xarray has to be done two times in fast io path, so another factor which
>>> 	hurts performance.
>>>
>>>>
[...]

-- 
Pavel Begunkov
