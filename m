Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2650D7C800B
	for <lists+io-uring@lfdr.de>; Fri, 13 Oct 2023 10:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjJMIY0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Oct 2023 04:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjJMIYZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Oct 2023 04:24:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6162EB8;
        Fri, 13 Oct 2023 01:24:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFCAFC433C7;
        Fri, 13 Oct 2023 08:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697185464;
        bh=QqmQxaKl/YOc8772F3o6ch9rZJ0UYhPVI1Fy6DaUYBM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=thtYiLb+x5/ppF+9l7rDIvcn10/GWovnyPX4SvtoxviY0BfdzBI7fcOfvJvhBzEHE
         +0PcTJZF2L+Tn0IErma7NxaN+4qlExTpwAQLICr21qaNRsBhmVnTcv/rRgIpHLy5tC
         0XjIMLiMk4ENAjWJiSZPMg5Xw0XjzmPhU9yKcEYrjVezQsav7eAz5qq50bY97Eg09H
         RPAXc5IVHf3JjSZOYbjDX8rMexx6KcR5MtDk44gOcRoFFKoEGeOhbVAd7PEQ5yhgjh
         GBSfYon3N8hO3D+VBe5ao1tu3V8uP5v26XuK88xbfFkoNtMn1FvGY6CPxftRZbY0kd
         mux2g0sdQGGiA==
Date:   Fri, 13 Oct 2023 10:24:19 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Dan Clash <daclash@linux.microsoft.com>
Cc:     audit@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, paul@paul-moore.com, axboe@kernel.dk,
        linux-fsdevel@vger.kernel.org, dan.clash@microsoft.com
Subject: Re: [PATCH] audit,io_uring: io_uring openat triggers audit reference
 count underflow
Message-ID: <20231013-insofern-gegolten-75ca48b24cf5@brauner>
References: <20231012215518.GA4048@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231012215518.GA4048@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 12, 2023 at 02:55:18PM -0700, Dan Clash wrote:
> An io_uring openat operation can update an audit reference count
> from multiple threads resulting in the call trace below.
> 
> A call to io_uring_submit() with a single openat op with a flag of
> IOSQE_ASYNC results in the following reference count updates.
> 
> These first part of the system call performs two increments that do not race.
> 
> do_syscall_64()
>   __do_sys_io_uring_enter()
>     io_submit_sqes()
>       io_openat_prep()
>         __io_openat_prep()
>           getname()
>             getname_flags()       /* update 1 (increment) */
>               __audit_getname()   /* update 2 (increment) */
> 
> The openat op is queued to an io_uring worker thread which starts the
> opportunity for a race.  The system call exit performs one decrement.
> 
> do_syscall_64()
>   syscall_exit_to_user_mode()
>     syscall_exit_to_user_mode_prepare()
>       __audit_syscall_exit()
>         audit_reset_context()
>            putname()              /* update 3 (decrement) */
> 
> The io_uring worker thread performs one increment and two decrements.
> These updates can race with the system call decrement.
> 
> io_wqe_worker()
>   io_worker_handle_work()
>     io_wq_submit_work()
>       io_issue_sqe()
>         io_openat()
>           io_openat2()
>             do_filp_open()
>               path_openat()
>                 __audit_inode()   /* update 4 (increment) */
>             putname()             /* update 5 (decrement) */
>         __audit_uring_exit()
>           audit_reset_context()
>             putname()             /* update 6 (decrement) */
> 
> The fix is to change the refcnt member of struct audit_names
> from int to atomic_t.
> 
> kernel BUG at fs/namei.c:262!
> Call Trace:
> ...
>  ? putname+0x68/0x70
>  audit_reset_context.part.0.constprop.0+0xe1/0x300
>  __audit_uring_exit+0xda/0x1c0
>  io_issue_sqe+0x1f3/0x450
>  ? lock_timer_base+0x3b/0xd0
>  io_wq_submit_work+0x8d/0x2b0
>  ? __try_to_del_timer_sync+0x67/0xa0
>  io_worker_handle_work+0x17c/0x2b0
>  io_wqe_worker+0x10a/0x350
> 
> Cc: <stable@vger.kernel.org>
> Link: https://lore.kernel.org/lkml/MW2PR2101MB1033FFF044A258F84AEAA584F1C9A@MW2PR2101MB1033.namprd21.prod.outlook.com/
> Fixes: 5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support to io_uring")
> Signed-off-by: Dan Clash <daclash@linux.microsoft.com>
> ---
>  fs/namei.c         | 9 +++++----
>  include/linux/fs.h | 2 +-
>  kernel/auditsc.c   | 8 ++++----
>  3 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 567ee547492b..94565bd7e73f 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -188,7 +188,7 @@ getname_flags(const char __user *filename, int flags, int *empty)
>  		}
>  	}
>  
> -	result->refcnt = 1;
> +	atomic_set(&result->refcnt, 1);
>  	/* The empty path is special. */
>  	if (unlikely(!len)) {
>  		if (empty)
> @@ -249,7 +249,7 @@ getname_kernel(const char * filename)
>  	memcpy((char *)result->name, filename, len);
>  	result->uptr = NULL;
>  	result->aname = NULL;
> -	result->refcnt = 1;
> +	atomic_set(&result->refcnt, 1);
>  	audit_getname(result);
>  
>  	return result;
> @@ -261,9 +261,10 @@ void putname(struct filename *name)
>  	if (IS_ERR(name))
>  		return;
>  
> -	BUG_ON(name->refcnt <= 0);
> +	if (WARN_ON_ONCE(!atomic_read(&name->refcnt)))
> +		return;
>  
> -	if (--name->refcnt > 0)
> +	if (!atomic_dec_and_test(&name->refcnt))
>  		return;

Fine by me. I'd write this as:

count = atomic_dec_if_positive(&name->refcnt);
if (WARN_ON_ONCE(unlikely(count < 0))
	return;
if (count > 0)
	return;
