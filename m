Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040733E4EB5
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 23:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbhHIVtB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 17:49:01 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:45308 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233294AbhHIVtB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 17:49:01 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:54436 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1mDD8R-0005EU-6B; Mon, 09 Aug 2021 17:48:39 -0400
Message-ID: <fdd54421f4d4e825152192e327c838d035352945.camel@trillion01.com>
Subject: Re: [PATCH 1/2] io_uring: clear TIF_NOTIFY_SIGNAL when running task
 work
From:   Olivier Langlois <olivier@trillion01.com>
To:     Nadav Amit <nadav.amit@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@vmware.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Date:   Mon, 09 Aug 2021 17:48:38 -0400
In-Reply-To: <20210808001342.964634-2-namit@vmware.com>
References: <20210808001342.964634-1-namit@vmware.com>
         <20210808001342.964634-2-namit@vmware.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, 2021-08-07 at 17:13 -0700, Nadav Amit wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> When using SQPOLL, the submission queue polling thread calls
> task_work_run() to run queued work. However, when work is added with
> TWA_SIGNAL - as done by io_uring itself - the TIF_NOTIFY_SIGNAL remains
> set afterwards and is never cleared.
> 
> Consequently, when the submission queue polling thread checks whether
> signal_pending(), it may always find a pending signal, if
> task_work_add() was ever called before.
> 
> The impact of this bug might be different on different kernel versions.
> It appears that on 5.14 it would only cause unnecessary calculation and
> prevent the polling thread from sleeping. On 5.13, where the bug was
> found, it stops the polling thread from finding newly submitted work.
> 
> Instead of task_work_run(), use tracehook_notify_signal() that clears
> TIF_NOTIFY_SIGNAL. Test for TIF_NOTIFY_SIGNAL in addition to
> current->task_works to avoid a race in which task_works is cleared but
> the TIF_NOTIFY_SIGNAL is set.
> 
> Fixes: 685fe7feedb96 ("io-wq: eliminate the need for a manager thread")
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  fs/io_uring.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 5a0fd6bcd318..f39244d35f90 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -78,6 +78,7 @@
>  #include <linux/task_work.h>
>  #include <linux/pagemap.h>
>  #include <linux/io_uring.h>
> +#include <linux/tracehook.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/io_uring.h>
> @@ -2203,9 +2204,9 @@ static inline unsigned int io_put_rw_kbuf(struct
> io_kiocb *req)
>  
>  static inline bool io_run_task_work(void)
>  {
> -       if (current->task_works) {
> +       if (test_thread_flag(TIF_NOTIFY_SIGNAL) || current->task_works)
> {
>                 __set_current_state(TASK_RUNNING);
> -               task_work_run();
> +               tracehook_notify_signal();
>                 return true;
>         }
>  

thx a lot for this patch!

This explains what I am seeing here:
https://lore.kernel.org/io-uring/4d93d0600e4a9590a48d320c5a7dd4c54d66f095.camel@trillion01.com/

I was under the impression that task_work_run() was clearing
TIF_NOTIFY_SIGNAL.

your patch made me realize that it does not...


