Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C07322B60
	for <lists+io-uring@lfdr.de>; Tue, 23 Feb 2021 14:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbhBWNZg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Feb 2021 08:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbhBWNZe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Feb 2021 08:25:34 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC853C06174A
        for <io-uring@vger.kernel.org>; Tue, 23 Feb 2021 05:24:53 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id a132so2426359wmc.0
        for <io-uring@vger.kernel.org>; Tue, 23 Feb 2021 05:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mXnghtvqIw1I5SqmLxQCs8EZ/47R56bPfymygdaPc6s=;
        b=dh5ct46dnxA2ZR1NLo9Gvl3v827GVLN9Sh+joCCj08QkswCqkFdjqi3URkv0bJnXXZ
         VzmobvM1RyPvUuyyVlcGKdw2/mywOGzLDi9L5dupIO8coXfvFWIIBw25DLynxzYFseJ2
         QP17DT61oBFQgy3kF2+NhZAUz6e0sOXI5G5V1WOAvB+7/nQcljCh9dMjKPHW+gaLnFnx
         rfst5TiETme3JUIpncuYFxeBV4sayjKyMaRGFVJtL586EHwEtXna2yLvghRZSWGBbt7d
         bhcEgwWYooK2hRFgjzaHVQp435Ii2n4xL3aNkqPmqx5qaMCk9cL6SmGerx766GY3UIpp
         lJ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=mXnghtvqIw1I5SqmLxQCs8EZ/47R56bPfymygdaPc6s=;
        b=C3Iney1UpPLUzir7CmQAGrhCfmWPBlxBj/vy5fFbRIVuapB7cwzNptzkLWdsmezXJG
         3cgjMz/ubdO/wTblLF6ywRIQGTD4n398ZhDR9ah1fPjmDeZNX+Dc1531n4HibOZGLKla
         NUxqWC9YQRCWENWAHGLuh/Z54G8XDbCq7PRCBZrh8TyI5BAjxZ/eSoLE/OxtxHvvg6Qi
         p9msmW/TOH4ZTOlIp3/hMhkftrgvE82qX2U5w5khVmMIFgAZhXPru59hWXY0QHMO0jEM
         T5fF37u2EgCACmbCINGalKnDDxOTS5zYs2tp59pomdSI+xVEYBwfSlpt8PuYrGtZRadw
         wSQQ==
X-Gm-Message-State: AOAM530Q+9hi/NlOLDL81K5DW9NFgqnaB182vcfvXSus/V4Uu/JOSnfO
        JJMfOtlHOySCWgIu/0XRcY03hJ59eXQ=
X-Google-Smtp-Source: ABdhPJzUbxbEquoXJVOVqGZR9JcUmdxIXtJ2qtNM9kuUit/QbVNdFRICafTF8kHBIHlwtE+/V6oD2A==
X-Received: by 2002:a05:600c:2184:: with SMTP id e4mr24563389wme.107.1614086692395;
        Tue, 23 Feb 2021 05:24:52 -0800 (PST)
Received: from [192.168.8.157] ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id m6sm9278628wrv.73.2021.02.23.05.24.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 05:24:51 -0800 (PST)
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     io-uring@vger.kernel.org
References: <20210127212541.88944-1-axboe@kernel.dk>
 <20210127212541.88944-3-axboe@kernel.dk> <20210128003831.GE7695@magnolia>
 <67627096-6d30-af3a-9545-1446909a38c4@kernel.dk>
 <f8576940-5441-1355-c09e-db60ad0ac889@kernel.dk>
 <81d6c90e-b853-27c0-c4b7-23605bd4abae@samba.org>
 <187cbfad-0dfe-9a16-11f0-bfe18a6c7520@kernel.dk>
 <58fe1e10-ed71-53f9-c47c-5e64066d3290@kernel.dk>
 <bcce9dd6-8222-6dc5-ad4f-5a68ac3ca902@samba.org>
 <6f3bcf67-15e3-f113-486e-b34c6c0df5e3@kernel.dk>
 <c22271fd-85e1-2bc6-0946-ee24885d28ce@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 2/5] io_uring: add support for IORING_OP_URING_CMD
Message-ID: <35c25d58-457b-c23c-f298-3d623024d03a@gmail.com>
Date:   Tue, 23 Feb 2021 13:21:01 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <c22271fd-85e1-2bc6-0946-ee24885d28ce@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 23/02/2021 08:14, Stefan Metzmacher wrote:
> Am 22.02.21 um 21:14 schrieb Jens Axboe:
>> On 2/22/21 1:04 PM, Stefan Metzmacher wrote:
>> For example, you start the IO operation and you'll get a notification (eg IRQ) later on which allows
>> you to complete it.
> 
> Yes, it's up to the implementation of uring_cmd() to do the processing and waiting
> in the background, based on timers, hardware events or whatever and finally call
> io_uring_cmd_done().
> 
> But with this:
> 
>         ret = file->f_op->uring_cmd(&req->uring_cmd, issue_flags);
>         /* queued async, consumer will call io_uring_cmd_done() when complete */
>         if (ret == -EIOCBQUEUED)
>                 return 0;
>         io_uring_cmd_done(&req->uring_cmd, ret);
>         return 0;
> 
> I don't see where -EAGAIN would trigger a retry in a io-wq worker context.
> Isn't -EAGAIN exposed to the cqe. Similar to ret == -EAGAIN && req->flags & REQ_F_NOWAIT.

if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
	return -EAGAIN;

Yes, something alike. Apparently it was just forgotten

>>> It's also not clear if IOSQE_ASYNC should have any impact.
>>
>> Handler doesn't need to care about that, it'll just mean that the
>> initial queue attempt will not have IO_URING_F_NONBLOCK set.
> 
> Ok, because it's done from the io-wq worker, correct?

Currently, IO_URING_F_NONBLOCK isn't set only when executed from
io-wq, may change for any reason though. Actually, ASYNC req may
get executed with IO_URING_F_NONBLOCK, but handlers should be
sane.

>> So tldr here is that 1+2 is already there, and 3 not being fixed leaves
>> us no different than the existing support for cancelation. IOW, I don't
>> think this is an initial requirement, support can always be expanded
>> later.
> 
> Given that you list 2) here again, I get the impression that the logic should be:
> 
>         ret = file->f_op->uring_cmd(&req->uring_cmd, issue_flags);
>         /* reschedule in io-wq worker again */
>         if (ret == -EAGAIN)
>                 return ret;

Yes, kind of

>         /* queued async, consumer will call io_uring_cmd_done() when complete */
>         if (ret == -EIOCBQUEUED)
>                 return 0;
>         io_uring_cmd_done(&req->uring_cmd, ret);
>         return 0;
> 
> With that the above would make sense and seems to make the whole design more flexible
> for the uring_cmd implementers.
> 
> However my primary use case would be using the -EIOCBQUEUED logic.
> And I think it would be good to have IORING_OP_ASYNC_CANCEL logic in place for that,
> as it would simplify the userspace logic to single io_uring_opcode_supported(IO_OP_URING_CMD).
> 
> I also noticed that some sendmsg/recvmsg implementations support -EIOCBQUEUED, e.g. _aead_recvmsg(),
> I guess it would be nice to support that for IORING_OP_SENDMSG and IORING_OP_RECVMSG as well.
> It uses struct kiocb and iocb->ki_complete().

It's just crypto stuff, IMHO unless something more useful like TCP/UDP
sockets start supporting it, it isn't worth it.

> 
> Would it make sense to also use struct kiocb and iocb->ki_complete() instead of
> a custom io_uring_cmd_done()?
> 
> Maybe it would be possible to also have a common way to cancel an struct kiocb request...
> 
>>>> Since we just need that one branch in req init, I do think that your
>>>> suggestion of just modifying io_uring_sqe is the way to go. So that's
>>>> what the above branch does.
>>>
>>> Thanks! I think it's much easier to handle the personality logic in
>>> the core only.
>>>
>>> For fixed files or fixed buffers I think helper functions like this:
>>>
>>> struct file *io_uring_cmd_get_file(struct io_uring_cmd *cmd, int fd, bool fixed);
>>>
>>> And similar functions for io_buffer_select or io_import_fixed.
>>
>> I did end up retaining that, at least in its current state it's like you
>> proposed. Only change is some packing on that very union, which should
>> not be necessary, but due to fun arm reasons it is.
> 
> I noticed that thanks!
> 
> Do you also think a io_uring_cmd_get_file() would be useful?
> My uring_cmd() implementation would need a 2nd struct file in order to
> do something similar to a splice operation. And it might be good to
> allow also fixed files to be used.
> 
> Referencing fixed buffer may also be useful, I'm not 100% sure I'll need them,
> but it would be good to be flexible and prototype various solutions.

Right, there should be a set of API for different purposes, including
getting resources. Also should be better integrated into prep/cleaning
up/etc. bits.

Even more, I think the approach should be modernised into two-step:
1. register your fd (or classes of fds) for further uring_cmd() in
io_uring ctx, 2. use that pre-registered fds/state for actually
issuing a command.

That would open the way for pre-allocating memory in advance,
pre-backing some stuff like iommu mappings, iovec/bvecs in specific
cases, pinning pages, and so on.

And also will get rid of virtual calls chaining, e.g.
	->uring_cmd() { blk_mq->uring_blk_mq() { ... }

We will just get the final callback in the state.

Hopefully, I'll get to it to describe in details or even hack
it up.

-- 
Pavel Begunkov
