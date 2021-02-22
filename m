Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEFA3220B3
	for <lists+io-uring@lfdr.de>; Mon, 22 Feb 2021 21:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbhBVUPU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Feb 2021 15:15:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbhBVUPR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Feb 2021 15:15:17 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544D7C061574
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 12:14:37 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id d5so3121005iln.6
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 12:14:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zMplqoelGfC5iCZcS0ezNIrgh0aEsCHrmPPe6mKmwFE=;
        b=DyGcre5l/jFzbXHLckTqMjv0pl2EvFp0mpuCA4vCvh5gAtwzTZX0ZGLS9FFhqd8Xg6
         pfuh+bNUdzyEP1YobyzviUI3+w2hD/JWAZT0XTLTyHCT9jsCS9DXXTU5bXDoj3YFAhvB
         /wBGXAKmNfvmnyV0tUKYn5i9UYj2WzRLyPavQyHSW4s2nlKSQAq3D76fK8T345tXs6Sh
         2wa6SnrmyZiX+SLarljvZWbej6HKuqEfxYdrjCGNbYWNeTLJH0HcUqOB0TpkifIzqQAX
         g6+bdwSba3J4EZO84UyCMFENKt+rKSEN8jhE8zqGWsocBrk0MmKjr7Ww+wpaAPY97yNc
         G1Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zMplqoelGfC5iCZcS0ezNIrgh0aEsCHrmPPe6mKmwFE=;
        b=PFA2myObxJQaFJ6dNELUj4Sb59G2ewnGdmd2tcVY7SjoxF92jQyViCJEgUivHZRp8Y
         sEMS+3ebUDolztWNPAc1p3dkcvrkXhjBUmDbABePJhGM8kD/DocMPza4oLixUBPzitTO
         KuiU6M+Y2W1CRSU6d2ZyG3DrTrvu6yrrc90A/miuPUDCdxC2l4o1dU6Sbrpk8fpemVZ2
         9SgPRo7UYImNmzWFV0HFiBwMboYodhxXR1wMWLPEeP11iI/l0A/y9ysQTc67HbUOi+rt
         TLSAVfBwQ5nSiet5WnDP11OytooXkduaumoRcAAEBxgYa8BgFViQN/zyhK9OUYFqbiHS
         pR6A==
X-Gm-Message-State: AOAM530qqD69fyCqGy/5cnRQzYUWrcsPQxrdZH7IzswmrKKqRAA+Idtc
        z3EM09C7ZSU1v9NjdL/oPmwvVdiHNEsn88Nm
X-Google-Smtp-Source: ABdhPJy2+JKrVPvokY7yzM7MHZ6bzFGIywsC5BuVMlialrE5yrDqcxwQYVPen1KbG4zmOIxqy6o1Pg==
X-Received: by 2002:a92:740c:: with SMTP id p12mr3332559ilc.9.1614024876553;
        Mon, 22 Feb 2021 12:14:36 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v64sm14284364iod.55.2021.02.22.12.14.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Feb 2021 12:14:36 -0800 (PST)
Subject: Re: [PATCH 2/5] io_uring: add support for IORING_OP_URING_CMD
To:     Stefan Metzmacher <metze@samba.org>,
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6f3bcf67-15e3-f113-486e-b34c6c0df5e3@kernel.dk>
Date:   Mon, 22 Feb 2021 13:14:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bcce9dd6-8222-6dc5-ad4f-5a68ac3ca902@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/22/21 1:04 PM, Stefan Metzmacher wrote:
> Hi Jens,
> 
>>> I've been thinking along the same lines, because having a sparse sqe layout
>>> for the uring cmd is a pain. I do think 'personality' is a bit too specific
>>> to be part of the shared space, that should probably belong in the pdu
>>> instead if the user needs it. One thing they all have in common is that they'd
>>> need a sub-command, so why not make that u16 that?
>>>
>>> There's also the option of simply saying that the uring_cmd sqe is just
>>> a different type, ala:
>>>
>>> struct io_uring_cmd_sqe {
>>> 	__u8	opcode;		/* IO_OP_URING_CMD */
>>> 	__u8	flags;
>>> 	__u16	target_op;
>>> 	__s32	fd;
>>> 	__u64	user_data;
>>> 	strut io_uring_cmd_pdu cmd_pdu;
>>> };
>>>
>>> which is essentially the same as your suggestion in terms of layout
>>> (because that is the one that makes the most sense), we just don't try
>>> and shoe-horn it into the existing sqe. As long as we overlap
>>> opcode/flags, then init is fine. And past init, sqe is already consumed.
>>>
>>> Haven't tried and wire that up yet, and it may just be that the simple
>>> layout change you did is just easier to deal with. The important part
>>> here is the layout, and I certainly think we should do that. There's
>>> effectively 54 bytes of data there, if you include the target op and fd
>>> as part of that space. 48 fully usable for whatever.
>>
>> OK, folded in some of your stuff, and pushed out a new branch. Find it
>> here:
>>
>> https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-fops.v3
>>
>> I did notice while doing so that you put the issue flags in the cmd,
>> I've made them external again. Just seems cleaner to me, otherwise
>> you'd have to modify the command for reissue rather than just
>> pass in the flags directly.
> 
> I think the first two commits need more verbose comments, which clearly
> document the uring_cmd() API.

Oh for sure, I just haven't gotten around to it yet :-)

> Event before uring_cmd(), it's really not clear to me why we have
> 'enum io_uring_cmd_flags', as 'enum'.
> As it seems to be use it as 'flags' (IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER).

They could be unsigned in too, but not really a big deal imho.

> With uring_cmd() it's not clear what the backend is supposed to do
> with these flags.

IO_URING_F_NONBLOCK tells the lower layers that the operation should be
non-blocking, and if that isn't possible, then it must return -EAGAIN.
If that happens, then the operation will be retried from a context where
IO_URING_F_NONBLOCK isn't set.

IO_URING_F_COMPLETE_DEFER is just part of the flags that should be
passed to the completion side, the handler need not do anything else.
It's only used internally, but allows fast processing if the completion
occurs off the IO_URING_F_NONBLOCK path.

It'll get documented... But the above is also why it should get passed
in, rather than stuffed in the command itself.

> I'd assume that uring_cmd() would per definition never block and go
> async itself, by returning -EIOCBQUEUED. And a single &req->uring_cmd
> is only ever passed once to uring_cmd() without any retry.

No, -EIOCBQUEUED would mean "operation is queued, I'll call the
completion callback for it later". For example, you start the IO
operation and you'll get a notification (eg IRQ) later on which allows
you to complete it.

> It's also not clear if IOSQE_ASYNC should have any impact.

Handler doesn't need to care about that, it'll just mean that the
initial queue attempt will not have IO_URING_F_NONBLOCK set.

> I think we also need a way to pass IORING_OP_ASYNC_CANCEL down.

Cancelation indeed needs some thought. There are a few options:

1) Request completes sync, obviously no cancelation needed here as the
   request is never stuck in a state that requires cancelation.

2) Request needs blocking context, and hence an async handler is doing
   it. The regular cancelation already works for that, nothing is needed
   here. Would probably be better handled with a cancel handler.

3) uring_cmd handler returns -EIOCBQUEUED. This is the only case that
   needs active cancelation support. Only case where that would
   currently happen are things like block IO, where we don't support
   cancelation to begin with (insert long rant on inadequate hw
   support).

So tldr here is that 1+2 is already there, and 3 not being fixed leaves
us no different than the existing support for cancelation. IOW, I don't
think this is an initial requirement, support can always be expanded
later.

>> Since we just need that one branch in req init, I do think that your
>> suggestion of just modifying io_uring_sqe is the way to go. So that's
>> what the above branch does.
> 
> Thanks! I think it's much easier to handle the personality logic in
> the core only.
> 
> For fixed files or fixed buffers I think helper functions like this:
> 
> struct file *io_uring_cmd_get_file(struct io_uring_cmd *cmd, int fd, bool fixed);
> 
> And similar functions for io_buffer_select or io_import_fixed.

I did end up retaining that, at least in its current state it's like you
proposed. Only change is some packing on that very union, which should
not be necessary, but due to fun arm reasons it is.

>> I tested the block side, and it works for getting the bs of the
>> device. That's all the testing that has been done so far :-)
> 
> I've added EXPORT_SYMBOL(io_uring_cmd_done); and split your net patch,
> similar to the two block patches. So we can better isolate the core
> from the first consumers.
> 
> See https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/io_uring-fops.v3

Great thanks, I'll take a look and fold back. I'll also expand those
commit messages :-)

-- 
Jens Axboe

