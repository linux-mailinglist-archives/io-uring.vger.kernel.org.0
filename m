Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 689492888C0
	for <lists+io-uring@lfdr.de>; Fri,  9 Oct 2020 14:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731589AbgJIMbi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Oct 2020 08:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbgJIMbi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Oct 2020 08:31:38 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B40C0613D2;
        Fri,  9 Oct 2020 05:31:38 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id n6so9802743wrm.13;
        Fri, 09 Oct 2020 05:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fNugXzVlM6VjzUFq5cTxpvQO/3ywBznFcqsiji/Jrt0=;
        b=U63Wq9v3tkGg2eoexnbcybCIvzxcznkOe1+E7MvHdv4UG/LCUTKGrth8t1urGxL7Tw
         mr7fRHLQoNXCj8fmgIiPpNuO4f5yJKrwwyoBw3gfuTWWL5QaUopaoC6wN7GNMLo0gKZG
         HXxAf4kPk8s0o79fMxTfYvggVsdtuorL0oTjAC9wXSYGgRTI7SsCzw+MMNNRzNtlZPx9
         aeYqcsoUiQythroPZSqxVN7XPPmy4l9BB95UDdN9UHkrE6aKPp+ULmk+WXrxuBLAVww2
         PEItQHF4EjXJDzRZzcmmAgC4/dq75JoFfgvSBft/Dge78aJng9ej3vbtZQJ0nn69VlGT
         IXTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=fNugXzVlM6VjzUFq5cTxpvQO/3ywBznFcqsiji/Jrt0=;
        b=B7moP/PpF2p/KwqHJuTXbd/xyBP7wbgft3kOvaPnHggaP6idhIfjYhb5NYtqMlrR0k
         t5Ljfogsqek9hp18LD69WlRjZ0NycizLh8kKBh7mwulUn+pAKCIjFAHvzv7wwRHnwrni
         sycISv5in0O7viVrkRqS+541wRHyvGMvAYexOgapptGe92yAV02jCFrdFPjomsLnSWaE
         8sBhAti/K4tq3fzAqXr6Amqso/csHoWA2qSuS4szkWlcccrUzXdaoCauW9YA8mQeXcKB
         laodXGQjzOMk2bFyXDjBxLQEILJMwbueqAC1Og5UwEbIYzVlj887kBCiWLFLOcvzQ5zN
         f2CA==
X-Gm-Message-State: AOAM531t97tyxl+hWVKH8Kzp8IqM0JK9XptxarTneW2EMUcq6lO2itJG
        /jbwU6GRY6pq8nTGFwuXG5A=
X-Google-Smtp-Source: ABdhPJwW04Q8mzPsF4MID7j2hxkizDaruX9Ab59fBbKS3RR+NvhK21ze3+T+1a4VXoUw/VOVhqNlNw==
X-Received: by 2002:a5d:420d:: with SMTP id n13mr14589648wrq.196.1602246696653;
        Fri, 09 Oct 2020 05:31:36 -0700 (PDT)
Received: from [192.168.1.82] (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id k190sm11621745wme.33.2020.10.09.05.31.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2020 05:31:36 -0700 (PDT)
To:     Matthew Wilcox <willy@infradead.org>
Cc:     syzbot <syzbot+77efce558b2b9e6b6405@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <0000000000001a684d05b1385e71@google.com>
 <3a98a77a-a507-954a-f2ec-e38af18c168f@gmail.com>
 <20201009121211.GQ20115@casper.infradead.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: KASAN: use-after-free Read in __io_uring_files_cancel
Message-ID: <6da35bc9-d072-c18b-2268-15d37fa786df@gmail.com>
Date:   Fri, 9 Oct 2020 15:28:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20201009121211.GQ20115@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 09/10/2020 15:12, Matthew Wilcox wrote:
> On Fri, Oct 09, 2020 at 02:10:49PM +0300, Pavel Begunkov wrote:
>>>  kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
>>>  xas_next_entry include/linux/xarray.h:1630 [inline]
>>>  __io_uring_files_cancel+0x417/0x440 fs/io_uring.c:8681
>>>  io_uring_files_cancel include/linux/io_uring.h:35 [inline]
>>>  exit_files+0xe4/0x170 fs/file.c:456
>>>  do_exit+0xae9/0x2930 kernel/exit.c:801
>>>  do_group_exit+0x125/0x310 kernel/exit.c:903
>>>  get_signal+0x428/0x1f00 kernel/signal.c:2757
>>>  arch_do_signal+0x82/0x2470 arch/x86/kernel/signal.c:811
>>>  exit_to_user_mode_loop kernel/entry/common.c:161 [inline]
>>>  exit_to_user_mode_prepare+0x194/0x1f0 kernel/entry/common.c:192
>>>  syscall_exit_to_user_mode+0x7a/0x2c0 kernel/entry/common.c:267
>>>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> It seems this fails on "node->shift" in xas_next_entry(), that would
>> mean that the node itself was freed while we're iterating on it.
>>
>> __io_uring_files_cancel() iterates with xas_next_entry() and creates
>> XA_STATE once by hand, but it also removes entries in the loop with
>> io_uring_del_task_file() -> xas_store(&xas, NULL); without updating
>> the iterating XA_STATE. Could it be the problem? See a diff below
> 
> No, the problem is that the lock is dropped after calling
> xas_next_entry(), and at any point after calling xas_next_entry(),
> the node that it's pointing to can be freed.

Only the task itself clears/removes entries, others can only insert.
So, could it be freed even though there are no parallel erases?

> 
> I don't think there's any benefit to using the advanced API here.
> Since io_uring_cancel_task_requests() can sleep, we have to drop the lock
> for each iteration around the loop, and so we have to walk from the top of the tree each time.  So we may as well make this easy to read:

Thanks for looking into it, looks definitely better.

> 
> @@ -8665,28 +8665,19 @@ static void io_uring_attempt_task_drop(struct file *file, bool exiting)
>  void __io_uring_files_cancel(struct files_struct *files)
>  {
>         struct io_uring_task *tctx = current->io_uring;
> -       XA_STATE(xas, &tctx->xa, 0);
> +       struct file *file;
> +       unsigned long index;
>  
>         /* make sure overflow events are dropped */
>         tctx->in_idle = true;
>  
> -       do {
> -               struct io_ring_ctx *ctx;
> -               struct file *file;
> -
> -               xas_lock(&xas);
> -               file = xas_next_entry(&xas, ULONG_MAX);
> -               xas_unlock(&xas);
> -
> -               if (!file)
> -                       break;
> -
> -               ctx = file->private_data;
> +       xa_for_each(&tctx->xa, index, file) {
> +               struct io_ring_ctx *ctx = file->private_data;
>  
>                 io_uring_cancel_task_requests(ctx, files);
>                 if (files)
>                         io_uring_del_task_file(file);
> -       } while (1);
> +       }
>  }
>  
>  static inline bool io_uring_task_idle(struct io_uring_task *tctx)
> 
> I'll send a proper patch in a few minutes -- I'd like to neaten up a
> few of the other XArray uses.
> 

-- 
Pavel Begunkov
