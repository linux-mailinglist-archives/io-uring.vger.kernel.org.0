Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73DA1380C72
	for <lists+io-uring@lfdr.de>; Fri, 14 May 2021 17:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbhENPBR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 May 2021 11:01:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233345AbhENPBP (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 14 May 2021 11:01:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3793F61457;
        Fri, 14 May 2021 15:00:02 +0000 (UTC)
Date:   Fri, 14 May 2021 16:59:59 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v4 5/6] namei: add getname_uflags()
Message-ID: <20210514145959.cf2msm4bpkozeufx@wittgenstein>
References: <20210513110612.688851-1-dkadashev@gmail.com>
 <20210513110612.688851-6-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210513110612.688851-6-dkadashev@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 13, 2021 at 06:06:11PM +0700, Dmitry Kadashev wrote:
> There are a couple of places where we already open-code the (flags &
> AT_EMPTY_PATH) check and io_uring will likely add another one in the
> future.  Let's just add a simple helper getname_uflags() that handles
> this directly and use it.
> 
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <christian.brauner@ubuntu.com>
> Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
> Link: https://lore.kernel.org/io-uring/20210415100815.edrn4a7cy26wkowe@wittgenstein/
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
> ---
> 
> Christian, I've kept your Signed-off-by here, even though I took only
> part of the change (leaving getname_flags() switch to boolean out to
> keep the change smaller). Please let me know if that is OK or not and/or
> if you prefer the rest of the change be restored.

I don't mind either way. I think this change is already worth it as it
gets rid of the open coding. (Would be better if it could be inline in
the header but you need access to LOOKUP_EMPTY for that.)

Acked-by: Christian Brauner <christian.brauner@ubuntu.com>

> 
>  fs/exec.c          | 8 ++------
>  fs/namei.c         | 8 ++++++++
>  include/linux/fs.h | 1 +
>  3 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 18594f11c31f..df33ecaf2111 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -2069,10 +2069,8 @@ SYSCALL_DEFINE5(execveat,
>  		const char __user *const __user *, envp,
>  		int, flags)
>  {
> -	int lookup_flags = (flags & AT_EMPTY_PATH) ? LOOKUP_EMPTY : 0;
> -
>  	return do_execveat(fd,
> -			   getname_flags(filename, lookup_flags, NULL),
> +			   getname_uflags(filename, flags),
>  			   argv, envp, flags);
>  }
>  
> @@ -2090,10 +2088,8 @@ COMPAT_SYSCALL_DEFINE5(execveat, int, fd,
>  		       const compat_uptr_t __user *, envp,
>  		       int,  flags)
>  {
> -	int lookup_flags = (flags & AT_EMPTY_PATH) ? LOOKUP_EMPTY : 0;
> -
>  	return compat_do_execveat(fd,
> -				  getname_flags(filename, lookup_flags, NULL),
> +				  getname_uflags(filename, flags),
>  				  argv, envp, flags);
>  }
>  #endif
> diff --git a/fs/namei.c b/fs/namei.c
> index 76572d703e82..010455938826 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -203,6 +203,14 @@ getname_flags(const char __user *filename, int flags, int *empty)
>  	return result;
>  }
>  
> +struct filename *
> +getname_uflags(const char __user *filename, int uflags)
> +{
> +	int flags = (uflags & AT_EMPTY_PATH) ? LOOKUP_EMPTY : 0;
> +
> +	return getname_flags(filename, flags, NULL);
> +}
> +
>  struct filename *
>  getname(const char __user * filename)
>  {
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index bf4e90d3ab18..c46e70682fc0 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2783,6 +2783,7 @@ static inline struct file *file_clone_open(struct file *file)
>  extern int filp_close(struct file *, fl_owner_t id);
>  
>  extern struct filename *getname_flags(const char __user *, int, int *);
> +extern struct filename *getname_uflags(const char __user *, int);
>  extern struct filename *getname(const char __user *);
>  extern struct filename *getname_kernel(const char *);
>  extern void putname(struct filename *name);
> -- 
> 2.30.2
> 
