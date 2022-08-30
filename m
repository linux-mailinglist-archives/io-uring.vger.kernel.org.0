Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52ECD5A60D4
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 12:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiH3Kec (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 06:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiH3Kec (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 06:34:32 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A84AAB401
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 03:34:30 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id z41so6182258ede.0
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 03:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=fNF+6qwNXkiCyeozdTqogTdfUeuMj5ibcku7B7EbFnc=;
        b=GL3UUqWAOXGRYMN8B1wzXggfgMg5F/RF3xA93fukt6WQCH0Zo1H7In/ktPNOGdJsg+
         OVw/aOXsygxtKTaHbj6M3g04dhZbU17JyaYPe6gF/pIpkE0cyhLZ2fuW1dbsMePLyInY
         EmP93dPrbo06YjN9G6IGJwGR1uUGfPYZZ4zDgkyCwm4utfw1m5gfxSYRKrHup7cQF8XG
         XU5A1In2UiUDPHJqk4DWjbs1mpY0xRhayvd98AQfPgbyPhOXl5M3CdChYLfaDAQuySOf
         Krbch8K5Sz/l8KjLW+ofLsvkG1YA0xpU0HKRIT3UGsZtf8h6r3m9721xbxMEGZfsavE9
         ju7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=fNF+6qwNXkiCyeozdTqogTdfUeuMj5ibcku7B7EbFnc=;
        b=UzMaIcW6eC7SvmHHKZQ7qqi+93io7d1hNP2EL9Pq1saLkVvJ6N6am9ECVr0tWI3wDG
         jvYN53CN8D6PopvCmNNReJOu9nRVmHzxYe0arD98Xo/xlTzd5eaomKGc2HWjO5arBr9z
         q/xbIzOnP9HigB4lVVzeSu6jP7N7TlxNEwYuuy+WFUnkJTNM9/FhKUMrOwRySp7C6Ldk
         Mcy8q71baalOuVsVra7Dn28MU0zOB5e1Q+wPrN+dY59YJVmxAS/CQEzsAB5qT9tB8x75
         ff9VMi8Uw3MtR7OS4jsBVb4BBEzBrDxDzHpY2ZN4Z/Pnm3Gzzu9nuBbcXjghL70vAHDq
         FWpg==
X-Gm-Message-State: ACgBeo1kEdEbK8UEgPF74QEMAOUYLg6IsNyWDbRL6BPd5Uu5/IwgeEU/
        en5sFMZOM2thsslWRhXoduuDndu3d42NwA==
X-Google-Smtp-Source: AA6agR6pJ0AH3occZcR1IALrxclWsEDBdI9EevJ9bjAErXtlYPLKgpD1FUPy6qx9+/abkRk5+WSD8A==
X-Received: by 2002:a05:6402:5106:b0:440:3693:e67b with SMTP id m6-20020a056402510600b004403693e67bmr20197870edd.226.1661855668865;
        Tue, 30 Aug 2022 03:34:28 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::202f? ([2620:10d:c092:600::2:4b91])
        by smtp.gmail.com with ESMTPSA id z16-20020aa7c650000000b0044790836307sm7057332edr.85.2022.08.30.03.34.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Aug 2022 03:34:28 -0700 (PDT)
Message-ID: <04513a70-58b1-9e97-a379-77078a55bdd9@gmail.com>
Date:   Tue, 30 Aug 2022 11:29:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH for-next v3 4/7] io_uring: add IORING_SETUP_DEFER_TASKRUN
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     Kernel Team <Kernel-team@fb.com>
References: <20220819121946.676065-1-dylany@fb.com>
 <20220819121946.676065-5-dylany@fb.com>
 <d3ad2512-ab06-1a56-6394-0dc4a62f0028@gmail.com>
 <4b5d0d7f259b799de4cdc869a34827f1b74d43f9.camel@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4b5d0d7f259b799de4cdc869a34827f1b74d43f9.camel@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/30/22 10:54, Dylan Yudaken wrote:
> On Mon, 2022-08-22 at 12:34 +0100, Pavel Begunkov wrote:
[...]
>>> +
>>> +       node = io_llist_cmpxchg(&ctx->work_llist, &fake, NULL);
>>> +       if (node != &fake) {
>>> +               current_final = &fake;
>>> +               node = io_llist_xchg(&ctx->work_llist, &fake);
>>> +               goto again;
>>> +       }
>>> +
>>> +       if (locked) {
>>> +               io_submit_flush_completions(ctx);
>>> +               mutex_unlock(&ctx->uring_lock);
>>> +       }
>>> +       return ret;
>>> +}
>>
>> I was thinking about:
>>
>> int io_run_local_work(struct io_ring_ctx *ctx, bool *locked)
>> {
>>          locked = try_lock();
>> }
>>
>> bool locked = false;
>> io_run_local_work(ctx, *locked);
>> if (locked)
>>          unlock();
>>
>> // or just as below when already holding it
>> bool locked = true;
>> io_run_local_work(ctx, *locked);
>>
>> Which would replace
>>
>> if (DEFER) {
>>          // we're assuming that it'll unlock
>>          io_run_local_work(true);
>> } else {
>>          unlock();
>> }
>>
>> with
>>
>> if (DEFER) {
>>          bool locked = true;
>>          io_run_local_work(&locked);
>> }
>> unlock();
>>
>> But anyway, it can be mulled later.
> 
> I think there is an easier way to clean it up if we allow an extra
> unlock/lock in io_uring_enter (see below). Will do that in v4

fwiw, I'm fine with the current code, the rest can
be cleaned up later if you'd prefer so.

[...]
>>> @@ -3057,10 +3160,20 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned
>>> int, fd, u32, to_submit,
>>>                  }
>>>                  if ((flags & IORING_ENTER_GETEVENTS) && ctx-
>>>> syscall_iopoll)
>>>                          goto iopoll_locked;
>>> +               if ((flags & IORING_ENTER_GETEVENTS) &&
>>> +                       (ctx->flags & IORING_SETUP_DEFER_TASKRUN))
>>> {
>>> +                       int ret2 = io_run_local_work(ctx, true);
>>> +
>>> +                       if (unlikely(ret2 < 0))
>>> +                               goto out;
>>
>> It's an optimisation and we don't have to handle errors here,
>> let's ignore them and make it looking a bit better.
> 
> I'm not convinced about that - as then there is no way the application
> will know it is trying to complete events on the wrong thread. Work
> will just silently pile up instead.

by optimisation I mean exactly this chunk right after submsission.
If it's a wrong thread this will be ignored, then control flow will
fall into cq_wait and then fail there returning an error. So, the
userspace should get an error in the end but the handling would be
consolidated in cq_wait.

> That being said - with the changes below I can just get rid of this
> code I think.
> 
>>
>>> +                       goto getevents_ran_local;
>>> +               }
>>>                  mutex_unlock(&ctx->uring_lock);
>>>          }
>>> +
>>>          if (flags & IORING_ENTER_GETEVENTS) {
>>>                  int ret2;
>>> +
>>>                  if (ctx->syscall_iopoll) {
>>>                          /*
>>>                           * We disallow the app entering
>>> submit/complete with
>>> @@ -3081,6 +3194,12 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned
>>> int, fd, u32, to_submit,
>>>                          const sigset_t __user *sig;
>>>                          struct __kernel_timespec __user *ts;
>>>    
>>> +                       if (ctx->flags &
>>> IORING_SETUP_DEFER_TASKRUN) {
>>
>> I think it should be in io_cqring_wait(), which calls it anyway
>> in the beginning. Instead of
>>
>>          do {
>>                  io_cqring_overflow_flush(ctx);
>>                  if (io_cqring_events(ctx) >= min_events)
>>                          return 0;
>>                  if (!io_run_task_work())
>>                          break;
>>          } while (1);
>>
>> Let's have
>>
>>          do {
>>                  ret = io_run_task_work_ctx();
>>                  // handle ret
>>                  io_cqring_overflow_flush(ctx);
>>                  if (io_cqring_events(ctx) >= min_events)
>>                          return 0;
>>          } while (1);
> 
> I think that is ok.
> The downside is that it adds an extra lock/unlock of the ctx in some
> cases. I assume that will be neglegible?

Not sure there will be any extra locking. IIRC, it was about replacing

// io_uring_enter() -> GETEVENTS path
run_tw();
// io_cqring_wait()
while (cqes_ready() < needed)
	run_tw();

With:

// io_uring_enter()
do {
	run_tw();
} while(cqes_ready() < needed);


>>> +                               ret2 = io_run_local_work(ctx,
>>> false);
>>> +                               if (unlikely(ret2 < 0))
>>> +                                       goto getevents_out;
>>> +                       }
>>> +getevents_ran_local:
>>>                          ret2 = io_get_ext_arg(flags, argp, &argsz,
>>> &ts, &sig);
>>>                          if (likely(!ret2)) {
>>>                                  min_complete = min(min_complete,
>>> @@ -3090,6 +3209,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int,
>>> fd, u32, to_submit,
>>>                          }
>>>                  }
>>>    
>>> +getevents_out:
>>>                  if (!ret) {
>>>                          ret = ret2;
>>>    
>>> @@ -3289,17 +3409,29 @@ static __cold int io_uring_create(unsigned
>>> entries, struct io_uring_params *p,
>>>          if (ctx->flags & IORING_SETUP_SQPOLL) {
>>>                  /* IPI related flags don't make sense with SQPOLL
>>> */
>>>                  if (ctx->flags & (IORING_SETUP_COOP_TASKRUN |
>>> -                                 IORING_SETUP_TASKRUN_FLAG))
>>> +                                 IORING_SETUP_TASKRUN_FLAG |
>>> +                                 IORING_SETUP_DEFER_TASKRUN))
>>
>> Sounds like we should also fail if SQPOLL is set, especially with
>> the task check on the waiting side.
>>
> 
> That is what this code is doing I think? Did I miss something?

Ok, great then

-- 
Pavel Begunkov
