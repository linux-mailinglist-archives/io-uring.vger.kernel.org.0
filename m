Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0C633991B
	for <lists+io-uring@lfdr.de>; Fri, 12 Mar 2021 22:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbhCLVdY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Mar 2021 16:33:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235227AbhCLVdM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Mar 2021 16:33:12 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E80C061574
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 13:33:11 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id bt4so5774899pjb.5
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 13:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Hh2aGM/cKuplaaaiTbmB3XWWXVNVKynpeNFPEkYTow0=;
        b=aQy0KFhyZhilV39CSWUkhAIhm6N4/TVCcZ/FzvhYgFIYUOM0KOER8FJ5ut0yZPY2Ra
         FbfZem+58A+7saEtFc4jpSxfZl8joPMNk68bctgXWVf2XYJhGePV2qmQZVOAst+ZRb7m
         WNbksoTPXsW0eJ2VAWszVuDJ90ISz19XtQgKRmAbHeimeUdRcyunBUroOKItjzEV0Ddi
         GvZGCyXoSo5hPmgn1dPc/xpwZjEIS2e1baebDbfwMvngrd8XVKqOZJ8EoUJqvm1dRlxr
         Ka1/POfuGgqExgD9YY8/vxdFwRmW/Z1pXciFCCvhz9gSWOeehluv/V//e7oZEr/3vsca
         EWyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hh2aGM/cKuplaaaiTbmB3XWWXVNVKynpeNFPEkYTow0=;
        b=uL9V3j3DfiTRlHZ+0/LWwBHoMKXCP0q2ypyvXdNxjD7zW73Up4ANHJTSh9bmxjSPBJ
         2oHqjiMW9bi7PyyDLDYC2/UcYpcY1jntVGX3qnxTrBOvHAcYyr+z2IhaJflNgsX7J1xS
         tIgh1kJi3Bop491juC/GvPP1zEkLVmTiSoxB7mNzsVw5j1SIBlFk/KJ+92aWokcAGob+
         Ar8wn6pZsSXasRGodJfQ+eO2HIjXDvUNeQ1d2kyU6u2e7bXcua0AqZNuB5DD8lbdZ6Hw
         ab8Fkk4k3h9ENgLAjhrHlkP6leDvAZIjK2jIhJ4Qybo2WAAYZ2Bi7Nffw3TFOp72CPnD
         z6Mg==
X-Gm-Message-State: AOAM5312Mmyt25dOq3VVTMQd9Gatvu9lIw3gUBaOfLkkNTpX/RnFhmvk
        28NT1r+fnoT4WPq3oaFisyVSD54xEak52A==
X-Google-Smtp-Source: ABdhPJybeJ7t7MJVA7Dzu3JMMsaPJ4BS3+XjIsAXeU57Cw+mnj021xbKfiVGos81dsRXHyCb4mrEYA==
X-Received: by 2002:a17:902:a606:b029:e6:4c7e:1cba with SMTP id u6-20020a170902a606b02900e64c7e1cbamr475765plq.46.1615584790954;
        Fri, 12 Mar 2021 13:33:10 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id ds3sm3113694pjb.23.2021.03.12.13.33.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 13:33:10 -0800 (PST)
Subject: Re: [GIT PULL] io_uring fixes for 5.12-rc3
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <a5447498-4a4c-20b3-ed1a-68b61df8b26b@kernel.dk>
 <CAHk-=wjpS-kwozJQFNBestco=q5j3bcfXpVXc6uz=9_mmQ7oYg@mail.gmail.com>
 <CAHk-=wj3gu-1djZ-YPGeUNwpsQzbCYGO2j1k_Hf1zO+z5VjSpA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d7350ce7-17dc-75d7-611b-27ebf2cb539b@kernel.dk>
Date:   Fri, 12 Mar 2021 14:33:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wj3gu-1djZ-YPGeUNwpsQzbCYGO2j1k_Hf1zO+z5VjSpA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/12/21 2:24 PM, Linus Torvalds wrote:
> On Fri, Mar 12, 2021 at 1:17 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> I'm _guessing_ it's just that now those threads are user threads, and
>> then the freezing logic expects them to freeze/thaw using a signal
>> machinery or something like that. And that doesn't work when there is
>> no signal handling for those threads.
> 
> IOW, I think it's this logic in freeze_task():
> 
>         if (!(p->flags & PF_KTHREAD))
>                 fake_signal_wake_up(p);
>         else
>                 wake_up_state(p, TASK_INTERRUPTIBLE);
> 
> where that "not a PF_KTHREAD" test will trigger for the io_uring
> threads, and it does that fake_signal_wake_up(), and then
> signal_wake_up() does that
> 
>         set_tsk_thread_flag(t, TIF_SIGPENDING);
> 
> but the io_uring thread has no way to react to it.
> 
> So now the io_uring thread will see "I have pending signals" (even if
> there is no actual pending signal - it's just a way to get normal
> processes to get out of TASK_INTERRUPTIBLE and return to user space
> handling).
> 
> And the pending fake signal will never go away, because there is no
> "return to user space" handling.
> 
> So I think the fix is to simply make freeze_task() not do that fake
> signal thing for IO-uring threads either.

Ah good catch, I missed it. Yes I bet this is exactly what it is, and
it just needs the one liner doing:

         if (!(p->flags & (PF_IO_WORKER | PF_KTHREAD)))
                 fake_signal_wake_up(p);
         else
                 wake_up_state(p, TASK_INTERRUPTIBLE);

instead. I'll try this out and test it, then we can drop the PF_NOFREEZE
business going forward. Thanks!

-- 
Jens Axboe

