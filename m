Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3780A6EE443
	for <lists+io-uring@lfdr.de>; Tue, 25 Apr 2023 16:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbjDYOui (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Apr 2023 10:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233940AbjDYOuh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Apr 2023 10:50:37 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5C0189
        for <io-uring@vger.kernel.org>; Tue, 25 Apr 2023 07:50:35 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id ca18e2360f4ac-760dff4b701so33711639f.0
        for <io-uring@vger.kernel.org>; Tue, 25 Apr 2023 07:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682434235; x=1685026235;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OOt/lJqAWh+LNCvSjviMcz2ct20+7E3hcdx8jC8Z88s=;
        b=B+ToV3JoBEGJlW/lqoyZjK3oTkGU4xj5p5JMmUQSTbozlvgH+AYz3fioqiYXufSUH5
         p/bOTanIct9Dq6AsX7v7fXDvb8i8eCmPZXB6sfyj1FmtIFbWVPNMLbgMq0atEh4sKN3n
         +gvHy2CzVXe9EfuWimmOAzfh8F8scpLeNJD5eNKXPaUCZeWLh8ubrMs09a0800VWhLJA
         8zKFnndFCnuwGYm8vTKwrbkwmp6A2b2PUECCN2we8323eTkc/RQKsi9C+luF1D8CxTvp
         EpB953NndYbbdPRIO6B/VMVq5LmuSE7rVrPEyZKt8bhQz0bsPnxefTF8vYKJGyupLDWN
         o3RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682434235; x=1685026235;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OOt/lJqAWh+LNCvSjviMcz2ct20+7E3hcdx8jC8Z88s=;
        b=hnXvijbOHYh5TsI1+wZCoUA+dX7ho/aWkXf1e0EL6ssbDTd3F960v7v3CfNcR61KWI
         rSOvVGdxaYFCJXLUk+wWjAGYwCoJuJqEfrD3T3KYpLDmUSgUAgmKYTdFVN33d/RZv3PK
         K+jB70yCL+yl2UGn98nVuDfyPLZXq0Rc+w6IOjNVkTSr6BFFkIYqb3EZ83hueZ7FN+bq
         wafIpuG2EWq6SF0b81ld9sRrWB56ynpolUXkt9ilqD0865JI1aw0T1K14hLBE/xSYRGi
         l7u1Aa8A5TbFO7pzzVxxl9SvEYQjRg4u/oxlgLnXSH1Dc99Wmrrbes/G4oT7Eo0ywGcW
         FeyQ==
X-Gm-Message-State: AAQBX9dvGGGycQR/6hhVToLr1KeDjFKqS5StEjdhWbQYy8EzJOR0dfs9
        Et07awveiIx+2rbbnICwQzoYiHCfxfJSae5bHi8=
X-Google-Smtp-Source: AKy350YIpWXOVK+fINjUO9CHoNFENGPsJdjpOKPrMfIkF4qB8JftzIzyk/dHHpQMI3WbaQXyHYk9bA==
X-Received: by 2002:a05:6602:2d91:b0:763:86b1:6111 with SMTP id k17-20020a0566022d9100b0076386b16111mr12263208iow.2.1682434235057;
        Tue, 25 Apr 2023 07:50:35 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id q6-20020a0566380d0600b0040474ab909fsm3978714jaj.36.2023.04.25.07.50.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Apr 2023 07:50:34 -0700 (PDT)
Message-ID: <a3225f4c-d0aa-e20e-6df3-84a996fe66dd@kernel.dk>
Date:   Tue, 25 Apr 2023 08:50:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 4/4] io_uring: mark opcodes that always need io-wq punt
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org
References: <20230420183135.119618-1-axboe@kernel.dk>
 <20230420183135.119618-5-axboe@kernel.dk>
 <ZEYwAkk7aXKfQKKr@ovpn-8-16.pek2.redhat.com>
 <b5e48439-0427-98a8-3288-99426ae36b45@kernel.dk>
 <ZEclhYPobt94OndL@ovpn-8-24.pek2.redhat.com>
 <478df0f7-c167-76f3-3fd8-9d5771a44048@kernel.dk>
 <ZEc3WttIofAqFy+b@ovpn-8-24.pek2.redhat.com>
 <a1c8d37f-ca21-3648-9a37-741e7519650b@kernel.dk>
 <ZEc/5Xyqvu2WkWyk@ovpn-8-24.pek2.redhat.com>
 <0e5910a9-d776-cdea-1852-edd995f93dc8@kernel.dk>
 <ZEfmzALXP9vqWkOV@ovpn-8-24.pek2.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZEfmzALXP9vqWkOV@ovpn-8-24.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/25/23 8:42?AM, Ming Lei wrote:
> On Tue, Apr 25, 2023 at 07:31:10AM -0600, Jens Axboe wrote:
>> On 4/24/23 8:50?PM, Ming Lei wrote:
>>> On Mon, Apr 24, 2023 at 08:18:02PM -0600, Jens Axboe wrote:
>>>> On 4/24/23 8:13?PM, Ming Lei wrote:
>>>>> On Mon, Apr 24, 2023 at 08:08:09PM -0600, Jens Axboe wrote:
>>>>>> On 4/24/23 6:57?PM, Ming Lei wrote:
>>>>>>> On Mon, Apr 24, 2023 at 09:24:33AM -0600, Jens Axboe wrote:
>>>>>>>> On 4/24/23 1:30?AM, Ming Lei wrote:
>>>>>>>>> On Thu, Apr 20, 2023 at 12:31:35PM -0600, Jens Axboe wrote:
>>>>>>>>>> Add an opdef bit for them, and set it for the opcodes where we always
>>>>>>>>>> need io-wq punt. With that done, exclude them from the file_can_poll()
>>>>>>>>>> check in terms of whether or not we need to punt them if any of the
>>>>>>>>>> NO_OFFLOAD flags are set.
>>>>>>>>>>
>>>>>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>>>>> ---
>>>>>>>>>>  io_uring/io_uring.c |  2 +-
>>>>>>>>>>  io_uring/opdef.c    | 22 ++++++++++++++++++++--
>>>>>>>>>>  io_uring/opdef.h    |  2 ++
>>>>>>>>>>  3 files changed, 23 insertions(+), 3 deletions(-)
>>>>>>>>>>
>>>>>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>>>>>>> index fee3e461e149..420cfd35ebc6 100644
>>>>>>>>>> --- a/io_uring/io_uring.c
>>>>>>>>>> +++ b/io_uring/io_uring.c
>>>>>>>>>> @@ -1948,7 +1948,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>>>>>>>>>>  		return -EBADF;
>>>>>>>>>>  
>>>>>>>>>>  	if (issue_flags & IO_URING_F_NO_OFFLOAD &&
>>>>>>>>>> -	    (!req->file || !file_can_poll(req->file)))
>>>>>>>>>> +	    (!req->file || !file_can_poll(req->file) || def->always_iowq))
>>>>>>>>>>  		issue_flags &= ~IO_URING_F_NONBLOCK;
>>>>>>>>>
>>>>>>>>> I guess the check should be !def->always_iowq?
>>>>>>>>
>>>>>>>> How so? Nobody that takes pollable files should/is setting
>>>>>>>> ->always_iowq. If we can poll the file, we should not force inline
>>>>>>>> submission. Basically the ones setting ->always_iowq always do -EAGAIN
>>>>>>>> returns if nonblock == true.
>>>>>>>
>>>>>>> I meant IO_URING_F_NONBLOCK is cleared here for  ->always_iowq, and
>>>>>>> these OPs won't return -EAGAIN, then run in the current task context
>>>>>>> directly.
>>>>>>
>>>>>> Right, of IO_URING_F_NO_OFFLOAD is set, which is entirely the point of
>>>>>> it :-)
>>>>>
>>>>> But ->always_iowq isn't actually _always_ since fallocate/fsync/... are
>>>>> not punted to iowq in case of IO_URING_F_NO_OFFLOAD, looks the naming of
>>>>> ->always_iowq is a bit confusing?
>>>>
>>>> Yeah naming isn't that great, I can see how that's bit confusing. I'll
>>>> be happy to take suggestions on what would make it clearer.
>>>
>>> Except for the naming, I am also wondering why these ->always_iowq OPs
>>> aren't punted to iowq in case of IO_URING_F_NO_OFFLOAD, given it
>>> shouldn't improve performance by doing so because these OPs are supposed
>>> to be slow and always slept, not like others(buffered writes, ...),
>>> can you provide one hint about not offloading these OPs? Or is it just that
>>> NO_OFFLOAD needs to not offload every OPs?
>>
>> The whole point of NO_OFFLOAD is that items that would normally be
>> passed to io-wq are just run inline. This provides a way to reap the
>> benefits of batched submissions and syscall reductions. Some opcodes
>> will just never be async, and io-wq offloads are not very fast. Some of
> 
> Yeah, seems io-wq is much slower than inline issue, maybe it needs
> to be looked into, and it is easy to run into io-wq for IOSQE_IO_LINK.

Indeed, depending on what is being linked, you may see io-wq activity
which is not ideal.

>> them can eventually be migrated to async support, if the underlying
>> mechanics support it.
>>
>> You'll note that none of the ->always_iowq opcodes are pollable. If
> 
> True, then looks the ->always_iowq flag doesn't make a difference here
> because your patch clears IO_URING_F_NONBLOCK for !file_can_poll(req->file).

Yep, we may be able to just get rid of it. The important bit is really
getting rid of the forced setting of REQ_F_FORCE_ASYNC which the
previous reverts take care of. So we can probably just drop this one,
let me give it a spin.

> Also almost all these ->always_iowq OPs are slow and blocked, if they are
> issued inline, the submission pipeline will be blocked.

That is true, but that's very much the tradeoff you make by using
NO_OFFLOAD. I would expect any users of this to have two rings, one for
just batched submissions, and one for "normal" usage. Or maybe they only
do the batched submissions and one is fine.

>> NO_OFFLOAD is setup, it's pointless NOT to issue them with NONBLOCK
>> cleared, as you'd just get -EAGAIN and then need to call them again with
>> NONBLOCK cleared from the same context.
> 
> My point is that these OPs are slow and slept, so inline issue won't
> improve performance actually for them, and punting to io-wq couldn't
> be worse too. On the other side, inline issue may hurt perf because
> submission pipeline is blocked when issuing these OPs.

That is definitely not true, it really depends on which ops it is. For a
lot of them, they don't generally block, but we have to be prepared for
them blocking. This is why they are offloaded. If they don't block and
execute fast, then the io-wq offload is easily a 2-3x slowdown, while
the batched submission can make it more efficient than simply doing the
normal syscalls as you avoid quite a few syscalls.

But you should not mix and match issue of these slower ops with "normal"
issues, you should separate them.

-- 
Jens Axboe

