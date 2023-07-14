Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3CD0753F1A
	for <lists+io-uring@lfdr.de>; Fri, 14 Jul 2023 17:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235523AbjGNPjD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Jul 2023 11:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234555AbjGNPjC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Jul 2023 11:39:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1753F30C5;
        Fri, 14 Jul 2023 08:39:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A983B61D24;
        Fri, 14 Jul 2023 15:39:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED51C433C8;
        Fri, 14 Jul 2023 15:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689349140;
        bh=y5YsiA1W3vLAU1+ATspRHVzIiQXGi4WXQQynW8Cg5Zk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L6XVXTFfNFnbtL4Tzp63X/UKOPYwx4xXCHQjlFO9orOjvENgkl7P69Kxxe3X1Uymo
         tuns+EV9tTH9u5EZEilFgQ/iVUAqLrOpMILrilq/V3r4cjhlBui05pkEZf6dzIKfG3
         daOHMHwvRwWGy7f3k9QoL1EdUqFDl/JKnGSc0aoSyvs/Osug/IRzJcX5luG22fz2BB
         KurUNXOJurt7tn+JmPFHTlYvvxTyespJRy4h9kMhc53OIs+QuBQKIHprIWzkIOf+B4
         oOXcx22akHWiz2nO6HUOtsPjpUvlxmaFoXXuyGd+a2SkhOLrTNFlRS9aTEml3kluky
         8dZADbWCJir5w==
Date:   Fri, 14 Jul 2023 17:38:51 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 4/5] exit: add internal include file with helpers
Message-ID: <20230714-lachen-gelassen-716cd90a9a0c@brauner>
References: <20230711204352.214086-1-axboe@kernel.dk>
 <20230711204352.214086-5-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230711204352.214086-5-axboe@kernel.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 11, 2023 at 02:43:51PM -0600, Jens Axboe wrote:
> Move struct wait_opts and waitid_info into kernel/exit.h, and include
> function declarations for the recently added helpers. Make them
> non-static as well.
> 
> This is in preparation for adding a waitid operation through io_uring.
> With the abtracted helpers, this is now possible.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  kernel/exit.c | 32 +++++++-------------------------
>  kernel/exit.h | 30 ++++++++++++++++++++++++++++++
>  2 files changed, 37 insertions(+), 25 deletions(-)
>  create mode 100644 kernel/exit.h
> 
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 8934c91a9fe1..1c9d1cbadcd0 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -74,6 +74,8 @@
>  #include <asm/unistd.h>
>  #include <asm/mmu_context.h>
>  
> +#include "exit.h"
> +
>  /*
>   * The default value should be high enough to not crash a system that randomly
>   * crashes its kernel from time to time, but low enough to at least not permit
> @@ -1037,26 +1039,6 @@ SYSCALL_DEFINE1(exit_group, int, error_code)
>  	return 0;
>  }
>  
> -struct waitid_info {
> -	pid_t pid;
> -	uid_t uid;
> -	int status;
> -	int cause;
> -};
> -
> -struct wait_opts {
> -	enum pid_type		wo_type;
> -	int			wo_flags;
> -	struct pid		*wo_pid;
> -
> -	struct waitid_info	*wo_info;
> -	int			wo_stat;
> -	struct rusage		*wo_rusage;
> -
> -	wait_queue_entry_t		child_wait;
> -	int			notask_error;
> -};
> -
>  static int eligible_pid(struct wait_opts *wo, struct task_struct *p)
>  {
>  	return	wo->wo_type == PIDTYPE_MAX ||
> @@ -1520,7 +1502,7 @@ static int ptrace_do_wait(struct wait_opts *wo, struct task_struct *tsk)
>  	return 0;
>  }
>  
> -static bool pid_child_should_wake(struct wait_opts *wo, struct task_struct *p)
> +bool pid_child_should_wake(struct wait_opts *wo, struct task_struct *p)
>  {
>  	if (!eligible_pid(wo, p))
>  		return false;
> @@ -1590,7 +1572,7 @@ static int do_wait_pid(struct wait_opts *wo)
>  	return 0;
>  }
>  
> -static long __do_wait(struct wait_opts *wo)
> +long __do_wait(struct wait_opts *wo)
>  {
>  	long retval;
>  
> @@ -1662,9 +1644,9 @@ static long do_wait(struct wait_opts *wo)
>  	return retval;
>  }
>  
> -static int kernel_waitid_prepare(struct wait_opts *wo, int which, pid_t upid,
> -				 struct waitid_info *infop, int options,
> -				 struct rusage *ru, unsigned int *f_flags)
> +int kernel_waitid_prepare(struct wait_opts *wo, int which, pid_t upid,
> +			  struct waitid_info *infop, int options,
> +			  struct rusage *ru, unsigned int *f_flags)
>  {
>  	struct pid *pid = NULL;
>  	enum pid_type type;
> diff --git a/kernel/exit.h b/kernel/exit.h
> new file mode 100644
> index 000000000000..f10207ba1341
> --- /dev/null
> +++ b/kernel/exit.h
> @@ -0,0 +1,30 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#ifndef LINUX_WAITID_H
> +#define LINUX_WAITID_H
> +
> +struct waitid_info {
> +	pid_t pid;
> +	uid_t uid;
> +	int status;
> +	int cause;
> +};
> +
> +struct wait_opts {
> +	enum pid_type		wo_type;
> +	int			wo_flags;
> +	struct pid		*wo_pid;
> +
> +	struct waitid_info	*wo_info;
> +	int			wo_stat;
> +	struct rusage		*wo_rusage;
> +
> +	wait_queue_entry_t		child_wait;
> +	int			notask_error;
> +};
> +
> +bool pid_child_should_wake(struct wait_opts *wo, struct task_struct *p);
> +long __do_wait(struct wait_opts *wo);
> +int kernel_waitid_prepare(struct wait_opts *wo, int which, pid_t upid,
> +			  struct waitid_info *infop, int options,
> +			  struct rusage *ru, unsigned int *f_flags);

I know this isn't your mess obviously but could you try and see whether
you can expose a nicer, dedicated struct and helper suited to io_uring's
needs instead of exposing the messy kernel/exit.c format?
