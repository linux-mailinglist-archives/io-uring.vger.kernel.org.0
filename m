Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2466CBCEB
	for <lists+io-uring@lfdr.de>; Tue, 28 Mar 2023 12:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbjC1K4O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Mar 2023 06:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjC1K4N (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Mar 2023 06:56:13 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E606594;
        Tue, 28 Mar 2023 03:56:12 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id b20so47929609edd.1;
        Tue, 28 Mar 2023 03:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680000971;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C5ZR2fZZj03SSHee5c4LOk+e4g2ondqIK0utb+HqTBA=;
        b=JFmYWBjP1qSAvYNYbXw4jDz6bb6FPR0vnV4n8HxUN+F2Jv2JtbMyHvEUaSHWeJ3p+z
         SaEXRagoB9znNC8pLdyPTDxmsftN52wv55aOyVr5iBq6mvQk3jAPfhQZumBHCz5izhu4
         7MvEF9KbpMY547rvgGg3yBRybQqqKkdWC+F3NYSpxnTjkZ378lyGSriXwaDekEmG3olN
         iILms4onH+/63Gj8CcQyjvinb7i466QlYOV15MnxTLMRNAD6xHD4fJhTrO/bUvtfzPo9
         +zRgcJ3Wk8adDjWNsxEgrS4bpTsolswRT6pZTRTYJW1KwAXu8FYC94pJ+uwoajfAOcMB
         QIeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680000971;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C5ZR2fZZj03SSHee5c4LOk+e4g2ondqIK0utb+HqTBA=;
        b=f4pgxdoflfjFFFS6oE6kupJaLy0dTWCD2qJVI+Xi1jUlumkWZ2MdWmSkY0F2n65czS
         mF3Th6hIu8ccCPCspUS0rmMkEYV9w05RTMzmrEhwzZ7zGrAw8g35SC0rj984wcgEfOkb
         B7BG09wAaAiY4e7L8LUJzmJk0tl61j67HxgoF/X8lp7ycsU9hs0PJ8ElglpUpdmAlOEr
         nAEzK9QyUkAx1Vo5UOgKe88u2jqWFahoAEHnSSOa0lKRyYILdXOsyWWhVWEg/7WAVe6H
         NmC7WfuRkHIlaVbYHbziV6ptFBOyNHDoHioHNLMdhmLLt/316M8RgEe2627P20kMd9tQ
         tyKQ==
X-Gm-Message-State: AAQBX9clGxPrb6lpkMEBE09SFFms3W5YtQiLKy4mGh0aXFuIyh4xcBho
        ap+C/eZ0EE9++IoH6DmhlhI=
X-Google-Smtp-Source: AKy350bQjzV+n03rp5hj4FzVbr62oO61jl2xmxegTYBEk/BnbawbCmL5Kt2KEYAATllHWVpts4JN2w==
X-Received: by 2002:aa7:dac6:0:b0:4fd:2363:16fa with SMTP id x6-20020aa7dac6000000b004fd236316famr13269332eds.41.1680000970617;
        Tue, 28 Mar 2023 03:56:10 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:d7])
        by smtp.gmail.com with ESMTPSA id a27-20020a509b5b000000b00501dd53dbfbsm10335185edj.75.2023.03.28.03.56.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Mar 2023 03:56:10 -0700 (PDT)
Message-ID: <8b227cf3-6ad1-59ad-e13b-a46381958a4c@gmail.com>
Date:   Tue, 28 Mar 2023 11:55:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH V3 00/16] io_uring/ublk: add IORING_OP_FUSED_CMD
Content-Language: en-US
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
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZBZJXb6vQ7z4CYk/@ovpn-8-18.pek2.redhat.com>
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

On 3/18/23 23:42, Ming Lei wrote:
> On Sat, Mar 18, 2023 at 04:51:14PM +0000, Pavel Begunkov wrote:
>> On 3/18/23 13:35, Ming Lei wrote:
>>> On Sat, Mar 18, 2023 at 06:59:41AM -0600, Jens Axboe wrote:
>>>> On 3/17/23 2:14?AM, Ming Lei wrote:
>>>>> On Tue, Mar 14, 2023 at 08:57:11PM +0800, Ming Lei wrote:
[...]
>>> IMO, splice(->splice_read()) can help much less in this use case, and
>>> I can't see improvement David Howells has done in this area:
>>
>> Let me correct a misunderstanding I've seen a couple of times
>> from people. Apart from the general idea of providing buffers, it's
>> not that bound to splice. Yes, I reused splicing guts for that
>> half-made POC, but we can add a new callback that would do it a
>> bit nicer, i.e. better consolidating returned buffers. Would
> 
> ->release() is for releasing pipe-buffer(page), instead of the whole buffer(reference).
>> probably be even better to have both of them falling back to
>> splice so it can cover more cases. The core of it is mediating
>> buffers through io_uring's registered buffer table, which
>> decouples all the components from each other.
> 
> For using pipe buffer's ->release() to release the whole buffer's
> reference, you have to allocate one pipe for each fixed buffer, and add
> pipe buffer to it, and keep each pipe buffer into the pipe
> until it is consumed, since ->release() needs to be called when
> unregistering buffer(all IOs are completed)

What I'm saying is that I'm more concerned about the uapi,
whether internally it's ->splice_read(). I think ->splice_read()
has its merit in a hybrid approach, but simplicity let's say for
we don't use it and there is a new f_op callback or it's
it's returned with by cmd requests.

> It(allocating/free pipe node, and populating it with each page) is
> really inefficient for handling one single IO.

It doesn't need pipe node allocation. We'd need to allocate
space for pages, but again, there is a good io_uring infra
for it without any single additional lock taken in most cases.


> So re-using splice for this purpose is still bad not mention splice
> can't support writeable spliced page.
> 
> Wiring device io buffer with context registered buffer table looks like
> another approach, however:
> 
> 1) two uring command OPs for registering/unregistering this buffer in io fast
> path has to be added since only userspace can know when buffer(reference)
> isn't needed

Yes, that's a good point. Registration replaces fuse master cmd, so it's
one extra request for unregister, which might be fine.

> 2) userspace becomes more complicated, 3+ OPs are required for handling one
> single device IO
> 
> 3) buffer reference crosses multiple OPs, for cleanup the registered buffer,
> we have to store the device file & "buffer key" in each buffer(such as io_uring_bvec_buf)
> for unregistering buffer

It should not necessarily be a file.

> 4) here the case is totally different with io_mapped_ubuf which isn't
> related to any specific file, and just belong to io_uring context; however,
> the device io buffer belongs to device(file) actually, so in theory it is wrong
> to put it into context's registered buffer table, and supposed to put into

Not at all, it doesn't belong to io_uring but rather to the user space,
without a file, right, but io_uring still only borrowing it.

As for keeping files, I predict that it'll be there anyway in some time,
some p2pdma experiments, dma preregistration, all required having a file
attached to the buffer.

> per-file buffer table which isn't supported by io_uring, or it becomes hard to
> implement multiple-device io buffer in single context since 'file + buffer key'
> has to be used to retrieve this buffer, probably xarray has to be
> relied, but

I was proposing to give slot selection to the userspace, perhaps with
optional auto index allocation as it's done with registered files.

> 	- here the index is (file, buffer key) if the table is per-context, current
> 	xarray only supports index with type of 'unsigned long', so looks not doable
> 	- or per-file xarray has to be used, then the implementation becomes more complicated
> 	- write to xarray has to be done two times in fast io path, so another factor which
> 	hurts performance.
> 
>>
>>> 1) we need to pass reference of the whole buffer from driver to io_uring,
>>> which is missed in splice, which just deals with page reference; for
>>> passing whole buffer reference, we have to apply per buffer pipe to
>>> solve the problem, and this way is expensive since the pipe can't
>>> be freed until all buffers are consumed.
>>>
>>> 2) reference can't outlive the whole buffer, and splice still misses
>>> mechanism to provide such guarantee; splice can just make sure that
>>> page won't be gone if page reference is grabbed, but here we care
>>> more the whole buffer & its (shared)references lifetime
>>>
>>> 3) current ->splice_read() misses capability to provide writeable
>>> reference to spliced page[2]; either we have to pass new flags
>>> to ->splice_read() or passing back new pipe buf flags, unfortunately
>>> Linus thought it isn't good to extend pipe/splice for such purpose,
>>> and now I agree with Linus now.
>>
>> It might be a non-workable option if we're thinking about splice(2)
>> and pipes, but pipes and ->splice_read() are just internal details,
>> an execution mechanism, and it's hidden from the userspace.
> 
> both pipe and ->splice_read() are really exposed to userspace, and are
> used in other non-io_uring situations, so any change can not break
> existed splice/pipe usage, maybe I misunderstand your point?

Oh, I meant reusing some of splice bits but not changing splice(2).
E.g. a kernel internal flag which is not allowed to be passed into
splice(2).


>> I guess someone might make a point that we don't want any changes
>> to the splice code even if it doesn't affect splice(2) userspace
>> users, but that's rather a part of development process.
>>> I believe that Pavel has realized this point[3] too, and here the only
>>> of value of using pipe is to reuse ->splice_read(), however, the above
>>> points show that ->splice_read() isn't good at this purpose.
>>
>> But agree that, ->splice_read() doesn't support the revers
>> direction, i.e. a file (e.g. ublk) provides buffers for
>> someone to write into it, that would need to be extended
>> in some way.
> 
> Linus has objected[1] explicitly to extend it in this way:
> 
> 	There's no point trying to deal with "if unexpectedly doing crazy
> 	things". If a sink writes the data, the sinkm is so unbelievably buggy
> 	that it's not even funny.

As far as I can see, Linus doesn't like there that the semantics
is not clear. "sink writes data" and writing to pages provided
by ->splice_read() don't sound right indeed.

I might be wrong but it appears that the semantics was ublk
lending an "empty" buffer to another file, which will fill it
in and return back the data by calling some sort of ->release
callback, then ublk consumes the data.


> [1] https://lore.kernel.org/linux-block/CAHk-=wgJsi7t7YYpuo6ewXGnHz2nmj67iWR6KPGoz5TBu34mWQ@mail.gmail.com/
> 
> That is also the reason why fuse can only support write zero copy via splice
> for 10+ years.
> 
>>
>>> [1] https://lore.kernel.org/linux-block/ZAk5%2FHfwc+NBwlbI@ovpn-8-17.pek2.redhat.com/
>>
>> Oops, missed this one
>>
>>> [2] https://lore.kernel.org/linux-block/CAJfpeguQ3xn2-6svkkVXJ88tiVfcDd-eKi1evzzfvu305fMoyw@mail.gmail.com/
>>
>> Miklos said that it's better to signal the owner of buffer about
>> completion, IIUC the way I was proposing, i.e. calling ->release
>> when io_uring removes the buffer and all io_uring requests using
>> it complete, should do exactly that.
> 
> ->release() just for acking the page consumption, what the ublk needs is
> to drop the whole buffer(represented by bvec) reference when the buffer isn't
> used by normal OPs, actually similar with fuse's case, because buffer
> reference can't outlive the buffer itself(repesented by bvec).
> 
> Yeah, probably releasing whole buffer reference can be done by ->release() in
> very complicated way, but the whole pipe & pipe buffer has to be kept in
> the whole IO lifetime for calling each pipe buffer's ->release(), so you have to
> allocate one pipe when registering this buffer, and release it when un-registering
> it. Much less efficient.

As per noted above, We don't necessarily have to stick with splice_read()
and pipe callbacks.

> 
> In short, splice can't help us for meeting ublk/fuse requirement.
-- 
Pavel Begunkov
