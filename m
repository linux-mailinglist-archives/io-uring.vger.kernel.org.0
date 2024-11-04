Return-Path: <io-uring+bounces-4409-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 73E629BB90D
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 16:34:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 967521C21867
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 15:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C3251BC07E;
	Mon,  4 Nov 2024 15:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XkeoXENC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16141B85C9;
	Mon,  4 Nov 2024 15:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730734463; cv=none; b=dYdsZHv+Sim68K36MoU9DHRWF/ietgly0AdAYRAMOcPNgFL+n+NcEHVjq1M1iRN/c1Agr5+KzXWaIKeTV8THJrT/OrvQNWJdN/9F/lfp+WumtUBX89AMDDFjaPbuZ/eThJAGy6zRIOW8Dcv7LrWP8RH82++0PpqucCrghwnBhyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730734463; c=relaxed/simple;
	bh=KBs/HrNwMD8/oDYt7oSX1TAQI8xFWMmsDeorNSH5xpQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=PW+3fOsmKFxlpX8JXgBtaDyVAea/yH3H12SXgEjpUDz3LOF+XcfiOBRsIaWXfaGMaPNiijS8gmSaj0oQrM8FehzQ821Pb7r2XP4G90QiIAsNzsSrIqF76AKQrZTBozhxW45iPpoKijeflRnKSv5HGbB99ve6jnLuG9hlU3VsDfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XkeoXENC; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5cb74434bc5so5185277a12.0;
        Mon, 04 Nov 2024 07:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730734459; x=1731339259; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x5FkVR8qf3LHcgQyoMYPRUmgOXjYywcsV7jbmR3b7AA=;
        b=XkeoXENCUyxvJFMn+xqBQPaTgOkE6P+tmXZjg3DhIyMLU3UH5GVw1oUGjM6oe/xhzC
         VyPSKln2GGn5WDJpvpEQ6UiVfcCXAhd13/bIULqhG9T99kMKQ6UruNCoW5RtS5foLywY
         WuWNqlKUa1EwJTwacKGpHOJrscPDNG7R7tWsgHGk3dHSbIP4hn6tVMqLF9Wu3y+Ktpyz
         NwWbe7mCEJPFwAoklX+yXE1QujJA+usBUqcearWNSDfnCog63RxRvxOobLvXz3m9oWsB
         GS5tD8Ulk0+0HpaUH26pAkteeMYprJB1AzZ+cBkc+J70k4u6DEJau0qDa/e1Bem6mG09
         Sp+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730734459; x=1731339259;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x5FkVR8qf3LHcgQyoMYPRUmgOXjYywcsV7jbmR3b7AA=;
        b=dxXQ4Awqg53PpZ7ulw6wW89ryj4AQ4RnTWw6l7n/uCDpS1VINQVofKPUbDFMSlEDiY
         GCa8UPQlo1JbIFteA/PQ87U7gXTRG4URUiLHr73MljVB2AfsXDKqYcQoLus3oOdPm22n
         JAnIgGLocyVo0YGXKSgRFi+jW9OYP4w3W6kLxhAWbllUpnIvQuMI2kaFj7wN3ppdDP9t
         BCIRT7yDz5TyIkm0IW84r+BFL+7qziYTYyBABN/Ubo/CdkpGBnrfN1fjRfNZeqI6gTF4
         x+RfMBBFeWQcXYxQ01/XJVIYCTuiddh7xzScrz/5MXK0UBYXiHFZIs9iHV1tY+CXLUdB
         iYUA==
X-Forwarded-Encrypted: i=1; AJvYcCUgBT26Tuv7AHNvM+hpZBXLHIF5/6JSwizwKAGBlQZS3Z85G77ltKOWEZpwsLbI+HvT3yntOgwqzl7ayqZ1@vger.kernel.org, AJvYcCVB7IkXilHKVsUsTXa2+FbzI5XEz2HyEM5rqi7Ru3sQDYf97QIlepVpsjTiaEEL/ngfSM0cTzICW+fN@vger.kernel.org, AJvYcCXaMw+4vqVJDirTonv7Vmeil+v6btojQG7w2sDLOY0sbkU3EnX4TGunBzuaZF7oeKrCNxoEDMuCRA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzzF/VGJ+LHj3t1SQ9Z1dtJsI+KDKY6RfhYVhzZZ/U3BiwJ5qVi
	S07xA6SnN/sHOfSbT/60exml8W+ZneM3YXuk5muftzO6iMg7R9wd
X-Google-Smtp-Source: AGHT+IGZw3ZWntQ5Zrh5953YGJj5aES92AofZAuTaqSZZCJIiAa6TfoR0MSycUX/KD0+I0ErTp9Tzg==
X-Received: by 2002:a17:906:6a1e:b0:a77:c95e:9b1c with SMTP id a640c23a62f3a-a9e654f89b5mr1175452866b.27.1730734458738;
        Mon, 04 Nov 2024 07:34:18 -0800 (PST)
Received: from [192.168.42.239] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9e565e08d0sm562457666b.115.2024.11.04.07.34.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 07:34:18 -0800 (PST)
Message-ID: <16f43422-91aa-4c6d-b36c-3e9cb52b1ff2@gmail.com>
Date: Mon, 4 Nov 2024 15:34:24 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] [usb?] WARNING in io_get_cqe_overflow (2)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
 syzbot <syzbot+e333341d3d985e5173b2@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-usb@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <6728b077.050a0220.35b515.01ba.GAE@google.com>
 <13da163a-d088-4b4d-8ad1-dbf609b03228@gmail.com>
 <b29d2635-d640-4b8e-ad43-1aa25c20d7c8@kernel.dk>
 <965a473d-596a-4cf4-8ec2-a8626c4c73f6@gmail.com>
Content-Language: en-US
In-Reply-To: <965a473d-596a-4cf4-8ec2-a8626c4c73f6@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/4/24 15:27, Pavel Begunkov wrote:
> On 11/4/24 15:08, Jens Axboe wrote:
>> On 11/4/24 6:13 AM, Pavel Begunkov wrote:
>>> On 11/4/24 11:31, syzbot wrote:
>>>> syzbot has bisected this issue to:
>>>>
>>>> commit 3f1a546444738b21a8c312a4b49dc168b65c8706
>>>> Author: Jens Axboe <axboe@kernel.dk>
>>>> Date:   Sat Oct 26 01:27:39 2024 +0000
>>>>
>>>>       io_uring/rsrc: get rid of per-ring io_rsrc_node list
>>>>
>>>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15aaa1f7980000
>>>> start commit:   c88416ba074a Add linux-next specific files for 20241101
>>>> git tree:       linux-next
>>>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=17aaa1f7980000
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=13aaa1f7980000
>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=704b6be2ac2f205f
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=e333341d3d985e5173b2
>>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16ec06a7980000
>>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12c04740580000
>>>>
>>>> Reported-by: syzbot+e333341d3d985e5173b2@syzkaller.appspotmail.com
>>>> Fixes: 3f1a54644473 ("io_uring/rsrc: get rid of per-ring io_rsrc_node list")
>>>>
>>>> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
>>>
>>> Previously all puts were done by requests, which in case of an exiting
>>> ring were fallback'ed to normal tw. Now, the unregister path posts CQEs,
>>> while the original task is still alive. Should be fine in general because
>>> at this point there could be no requests posting in parallel and all
>>> is synchronised, so it's a false positive, but we need to change the assert
>>> or something else.
>>
>> Maybe something ala the below? Also changes these triggers to be
>> _once(), no point spamming them.
>>
>> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
>> index 00409505bf07..7792ed91469b 100644
>> --- a/io_uring/io_uring.h
>> +++ b/io_uring/io_uring.h
>> @@ -137,10 +137,11 @@ static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
>>            * Not from an SQE, as those cannot be submitted, but via
>>            * updating tagged resources.
>>            */
>> -        if (ctx->submitter_task->flags & PF_EXITING)
>> -            lockdep_assert(current_work());
>> +        if (ctx->submitter_task->flags & PF_EXITING ||
>> +            percpu_ref_is_dying(&ctx->refs))
> 
> io_move_task_work_from_local() executes requests with a normal
> task_work of a possible alive task, which which will the check.
> 
> I was thinking to kill the extra step as it doesn't make sense,
> git garbage digging shows the patch below, but I don't remember
> if it has ever been tested.
> 
> 
> commit 65560732da185c85f472e9c94e6b8ff147fc4b96
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Fri Jun 7 13:13:06 2024 +0100
> 
>      io_uring: skip normal tw with DEFER_TASKRUN
>      DEFER_TASKRUN execution first falls back to normal task_work and only
>      then, when the task is dying, to workers. It's cleaner to remove the
>      middle step and use workers as the only fallback. It also detaches
>      DEFER_TASKRUN and normal task_work handling from each other.
>      Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Not sure what spacing got broken here.

Regardless, the rule with sth like that should be simpler,
i.e. a ctx is getting killed => everything is run from fallback/kthread.

> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 9789cf8c68c1..d9e3661ff93d 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1111,9 +1111,8 @@ static inline struct llist_node *io_llist_xchg(struct llist_head *head,
>       return xchg(&head->first, new);
>   }
> 
> -static __cold void io_fallback_tw(struct io_uring_task *tctx, bool sync)
> +static __cold void __io_fallback_tw(struct llist_node *node, bool sync)
>   {
> -    struct llist_node *node = llist_del_all(&tctx->task_list);
>       struct io_ring_ctx *last_ctx = NULL;
>       struct io_kiocb *req;
> 
> @@ -1139,6 +1138,13 @@ static __cold void io_fallback_tw(struct io_uring_task *tctx, bool sync)
>       }
>   }
> 
> +static __cold void io_fallback_tw(struct io_uring_task *tctx, bool sync)
> +{
> +    struct llist_node *node = llist_del_all(&tctx->task_list);
> +
> +    __io_fallback_tw(node, sync);
> +}
> +
>   struct llist_node *tctx_task_work_run(struct io_uring_task *tctx,
>                         unsigned int max_entries,
>                         unsigned int *count)
> @@ -1287,13 +1293,7 @@ static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
>       struct llist_node *node;
> 
>       node = llist_del_all(&ctx->work_llist);
> -    while (node) {
> -        struct io_kiocb *req = container_of(node, struct io_kiocb,
> -                            io_task_work.node);
> -
> -        node = node->next;
> -        io_req_normal_work_add(req);
> -    }
> +    __io_fallback_tw(node, false);
>   }
> 
>   static bool io_run_local_work_continue(struct io_ring_ctx *ctx, int events,
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index e46d13e8a215..bc0a800b5ae7 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -128,7 +128,7 @@ static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
>            * Not from an SQE, as those cannot be submitted, but via
>            * updating tagged resources.
>            */
> -        if (ctx->submitter_task->flags & PF_EXITING)
> +        if (percpu_ref_is_dying(&ctx->refs))
>               lockdep_assert(current_work());
>           else
>               lockdep_assert(current == ctx->submitter_task);
> 

-- 
Pavel Begunkov

