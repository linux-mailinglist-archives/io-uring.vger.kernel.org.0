Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46ED425F588
	for <lists+io-uring@lfdr.de>; Mon,  7 Sep 2020 10:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgIGInh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Sep 2020 04:43:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21551 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727897AbgIGInf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Sep 2020 04:43:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599468214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BZMZGWu3IW0j/iBtI3jPVLFkCsy//+cEnc0vseUjAGI=;
        b=COCkUiG82E4PDk3hDJX9gzgjein0ZMXboFrEFLYsuf9qP+04Re+OERRPv5Hd7ZziFVEsOv
        Ih7Vt4QjADI5nEqlJgX7Vnp9ztmBuJS9DYhZxFSUa6+zQNR9ePMHvmjvdnD6o4BmgzMTsM
        c3MlQO8bPXYijmhNttzA1LOkANzYwqs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-ianyeK1oNaipn7XqedzSdg-1; Mon, 07 Sep 2020 04:43:32 -0400
X-MC-Unique: ianyeK1oNaipn7XqedzSdg-1
Received: by mail-wr1-f71.google.com with SMTP id l9so3316209wrq.20
        for <io-uring@vger.kernel.org>; Mon, 07 Sep 2020 01:43:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BZMZGWu3IW0j/iBtI3jPVLFkCsy//+cEnc0vseUjAGI=;
        b=pA52ptJKBhfZRjAxVTLeIBiLu9CHyT/e7zuWBqz2FPFmcupRGvmDtyQX7JbJmgxZ7I
         AvBf0KpHmJnbSxMHHqwt6lhrlb5CbGAfTJw1s4gze9N6sXFVq/UkRPigWGf0ClKvLwhc
         ctNvy3ETqZNz4kehIvGD88Aq6z3BnFZIRIzCGgGrDYAyYJid6+O4EcxAFLecprMEsnKO
         k6QrIbVXgaNdgbHFNxJ2HhA84s90trVSADtR5yOwr4AuNQy5hnAjLDAzmg33acRXRgHq
         un+VInDa1khIipGZ1KMHoqrr3VT2P0jmge2KJMfsCxQ7V+Sa1jCFMWmnwfSGwNBqpIu6
         q1dA==
X-Gm-Message-State: AOAM533nJ7D3tF5IAr2EBMZtkJj74iR/UdmR1DcPymXLO0EOqj6Lp6oZ
        9zlN2hyfHcXBbiXgY1f0Pt40DkMEofmj12WQxB4IdVREC58ATd9RCr2END4klvVwpKmbz+fGfhf
        h6ba5LD7+qPX97ZNXEH8=
X-Received: by 2002:a1c:98c4:: with SMTP id a187mr19466130wme.178.1599468211189;
        Mon, 07 Sep 2020 01:43:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwS1NweegGfkyO0nAkHOQA5su+mbMupsGAOLm4YwWwCYpbNURAxbkeHTmkjMZWzoM8SjSOQFA==
X-Received: by 2002:a1c:98c4:: with SMTP id a187mr19466103wme.178.1599468210963;
        Mon, 07 Sep 2020 01:43:30 -0700 (PDT)
Received: from steredhat (host-79-53-225-185.retail.telecomitalia.it. [79.53.225.185])
        by smtp.gmail.com with ESMTPSA id j135sm27567976wmj.20.2020.09.07.01.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 01:43:30 -0700 (PDT)
Date:   Mon, 7 Sep 2020 10:43:27 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
        syzbot+107dd59d1efcaf3ffca4@syzkaller.appspotmail.com,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH next] io_uring: fix task hung in io_uring_setup
Message-ID: <20200907084327.b2vyca3tbvkeahhx@steredhat>
References: <20200903132119.14564-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903132119.14564-1-hdanton@sina.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 03, 2020 at 09:21:19PM +0800, Hillf Danton wrote:
> 
> The smart syzbot found the following issue:
> 
> INFO: task syz-executor047:6853 blocked for more than 143 seconds.
>       Not tainted 5.9.0-rc3-next-20200902-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor047 state:D stack:28104 pid: 6853 ppid:  6847 flags:0x00004000
> Call Trace:
>  context_switch kernel/sched/core.c:3777 [inline]
>  __schedule+0xea9/0x2230 kernel/sched/core.c:4526
>  schedule+0xd0/0x2a0 kernel/sched/core.c:4601
>  schedule_timeout+0x1d8/0x250 kernel/time/timer.c:1855
>  do_wait_for_common kernel/sched/completion.c:85 [inline]
>  __wait_for_common kernel/sched/completion.c:106 [inline]
>  wait_for_common kernel/sched/completion.c:117 [inline]
>  wait_for_completion+0x163/0x260 kernel/sched/completion.c:138
>  io_sq_thread_stop fs/io_uring.c:6906 [inline]
>  io_finish_async fs/io_uring.c:6920 [inline]
>  io_sq_offload_create fs/io_uring.c:7595 [inline]
>  io_uring_create fs/io_uring.c:8671 [inline]
>  io_uring_setup+0x1495/0x29a0 fs/io_uring.c:8744
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> because the sqo_thread kthread is created in io_sq_offload_create() without
> being waked up. Then in the error branch of that function we will wait for
> the sqo kthread that never runs. It's fixed by waking it up before waiting.
> 
> Reported-by: syzbot+107dd59d1efcaf3ffca4@syzkaller.appspotmail.com
> Fixes: dfe127799f8e ("io_uring: allow disabling rings during the creation")
> Cc: Stefano Garzarella <sgarzare@redhat.com>
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Hillf Danton <hdanton@sina.com>
> ---
> 
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6903,6 +6903,13 @@ static int io_sqe_files_unregister(struc
>  static void io_sq_thread_stop(struct io_ring_ctx *ctx)
>  {
>  	if (ctx->sqo_thread) {
> +		/*
> +		 * We may arrive here from the error branch in
> +		 * io_sq_offload_create() where the kthread is created without
> +		 * being waked up, thus wake it up now to make sure the wait will
> +		 * complete.
> +		 */
> +		wake_up_process(ctx->sqo_thread);
>  		wait_for_completion(&ctx->sq_thread_comp);
>  		/*
>  		 * The park is a bit of a work-around, without it we get
> --
> 

Thanks for fixing this issue!
Jens already queued this, but just for recording:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>


Thanks,
Stefano

