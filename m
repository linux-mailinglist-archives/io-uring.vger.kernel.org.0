Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEC11B4908
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2020 17:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgDVPoo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Apr 2020 11:44:44 -0400
Received: from albireo.enyo.de ([37.24.231.21]:43428 "EHLO albireo.enyo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726124AbgDVPoo (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 22 Apr 2020 11:44:44 -0400
Received: from [172.17.203.2] (helo=deneb.enyo.de)
        by albireo.enyo.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1jRHYE-00031Q-Ug; Wed, 22 Apr 2020 15:44:38 +0000
Received: from fw by deneb.enyo.de with local (Exim 4.92)
        (envelope-from <fw@deneb.enyo.de>)
        id 1jRHYE-0006oS-Ox; Wed, 22 Apr 2020 17:44:38 +0200
From:   Florian Weimer <fw@deneb.enyo.de>
To:     Mark Wielaard <mark@klomp.org>
Cc:     Josh Triplett <josh@joshtriplett.org>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mtk.manpages@gmail.com, Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
        Aleksa Sarai <cyphar@cyphar.com>, linux-man@vger.kernel.org
Subject: Re: [PATCH v5 3/3] fs: pipe2: Support O_SPECIFIC_FD
References: <cover.1587531463.git.josh@joshtriplett.org>
        <2bb2e92c688b97247f644fe8220054d6c6b66b65.1587531463.git.josh@joshtriplett.org>
Date:   Wed, 22 Apr 2020 17:44:38 +0200
In-Reply-To: <2bb2e92c688b97247f644fe8220054d6c6b66b65.1587531463.git.josh@joshtriplett.org>
        (Josh Triplett's message of "Tue, 21 Apr 2020 22:20:20 -0700")
Message-ID: <877dy7ikyh.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

* Josh Triplett:

> This allows the caller of pipe2 to specify one or both file descriptors
> rather than having them automatically use the lowest available file
> descriptor. The caller can specify either file descriptor as -1 to
> allow that file descriptor to use the lowest available.
>
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  fs/pipe.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/fs/pipe.c b/fs/pipe.c
> index 16fb72e9abf7..4681a0d1d587 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -936,19 +936,19 @@ static int __do_pipe_flags(int *fd, struct file **files, int flags)
>  	int error;
>  	int fdw, fdr;
>  
> -	if (flags & ~(O_CLOEXEC | O_NONBLOCK | O_DIRECT))
> +	if (flags & ~(O_CLOEXEC | O_NONBLOCK | O_DIRECT | O_SPECIFIC_FD))
>  		return -EINVAL;
>  
>  	error = create_pipe_files(files, flags);
>  	if (error)
>  		return error;
>  
> -	error = get_unused_fd_flags(flags);
> +	error = get_specific_unused_fd_flags(fd[0], flags);
>  	if (error < 0)
>  		goto err_read_pipe;
>  	fdr = error;
>  
> -	error = get_unused_fd_flags(flags);
> +	error = get_specific_unused_fd_flags(fd[1], flags);
>  	if (error < 0)
>  		goto err_fdr;
>  	fdw = error;
> @@ -969,7 +969,11 @@ static int __do_pipe_flags(int *fd, struct file **files, int flags)
>  int do_pipe_flags(int *fd, int flags)
>  {
>  	struct file *files[2];
> -	int error = __do_pipe_flags(fd, files, flags);
> +	int error;
> +
> +	if (flags & O_SPECIFIC_FD)
> +		return -EINVAL;
> +	error = __do_pipe_flags(fd, files, flags);
>  	if (!error) {
>  		fd_install(fd[0], files[0]);
>  		fd_install(fd[1], files[1]);
> @@ -987,6 +991,10 @@ static int do_pipe2(int __user *fildes, int flags)
>  	int fd[2];
>  	int error;
>  
> +	if (flags & O_SPECIFIC_FD)
> +		if (copy_from_user(fd, fildes, sizeof(fd)))
> +			return -EFAULT;
> +
>  	error = __do_pipe_flags(fd, files, flags);
>  	if (!error) {
>  		if (unlikely(copy_to_user(fildes, fd, sizeof(fd)))) {

Mark, I think this will need (or at least benefit from) some valgrind
changes.
