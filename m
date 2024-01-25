Return-Path: <io-uring+bounces-485-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4323683CA5C
	for <lists+io-uring@lfdr.de>; Thu, 25 Jan 2024 18:56:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F04102904FD
	for <lists+io-uring@lfdr.de>; Thu, 25 Jan 2024 17:56:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52748130E4D;
	Thu, 25 Jan 2024 17:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gPA8lYpw"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BAAA12FF9F;
	Thu, 25 Jan 2024 17:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706205370; cv=none; b=oSnp9KqqnUHF49oGhOJh727IQO24GfZkm2nzjOdy8EHT7HGdVEznENZ6+FB/1oVc+NVyAyFA3S9YI/2ybPeKsVGiPTPVuui3535Rb5Cc3421SkBIM+OIk5vz0R4Xv7a060QTV0Mn5LNf5xL7uIh5u+Z4U3JFIERhh0QZ66aGe6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706205370; c=relaxed/simple;
	bh=5zG9U0DzdAhitAtjOM1hSe+LdL3+tjiF/DdGkyoqWsM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c3OPY2KjoowZ1hx0gC+tWlL5DI8sirxiQ76lZo/B8c7HIM/AVs/mWrYbknNAuLF0GmWSck1QdklCl4ubBaAxeujTqr7KoSb7WgKJmJ/oBfRSPrBoO74B9fRAVvCjTWPeaQcRaoQD1ZgS5hwEo2vO+gs+KoFa6hF/FSYGUaEp9xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gPA8lYpw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81AA6C433F1;
	Thu, 25 Jan 2024 17:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706205368;
	bh=5zG9U0DzdAhitAtjOM1hSe+LdL3+tjiF/DdGkyoqWsM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gPA8lYpwIkc009qBw4FkHI2ylWYDep6bGAb9cbe/+5htz8Hh6hoJW8egMF3hAuktm
	 m2q59n0eX9cOvE/PzgrtGtz/0Ur6u4Y7k//Z+1hhJH/pk0VkTqZL7xZ9/yp8fjg5KD
	 w3pdZ8O1bhGyqLShWn1kxYLRBGAhpKVIbECQ4KjEYlclFioesEm6GVzWLR/9CEarmh
	 XUGaVVre6W1iXOoc7s9tc+upZoYMi/jHKkYtJFSupwaKwtpRcd9c/UD1Dj8316UlvC
	 TaOygb5CBrnYk/BCyuukfjuQUEUG4lsFNo3z/iqDNNSs5nZDDTtz+uOcTGWZPuz3rz
	 bAZNuqACbZRHg==
Date: Thu, 25 Jan 2024 18:56:04 +0100
From: Christian Brauner <brauner@kernel.org>
To: Tony Solomonik <tony.solomonik@gmail.com>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com, axboe@kernel.dk, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5 1/2] Add ftruncate_file that truncates a struct file
Message-ID: <20240125-mickrig-gemustert-927a2eaee125@brauner>
References: <20240124083301.8661-1-tony.solomonik@gmail.com>
 <20240124083301.8661-2-tony.solomonik@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240124083301.8661-2-tony.solomonik@gmail.com>

On Wed, Jan 24, 2024 at 10:33:00AM +0200, Tony Solomonik wrote:
> do_sys_ftruncate receives a file descriptor, fgets the struct file, and
> finally actually truncates the file.
> 
> ftruncate_file allows for passing in a file directly, with the caller
> already holding a reference to it.
> 
> Signed-off-by: Tony Solomonik <tony.solomonik@gmail.com>
> ---
>  fs/internal.h |  1 +
>  fs/open.c     | 53 +++++++++++++++++++++++++++------------------------
>  2 files changed, 29 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/internal.h b/fs/internal.h
> index 58e43341aebf..78a641ebd16e 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -182,6 +182,7 @@ extern struct open_how build_open_how(int flags, umode_t mode);
>  extern int build_open_flags(const struct open_how *how, struct open_flags *op);
>  extern struct file *__close_fd_get_file(unsigned int fd);
>  
> +long ftruncate_file(struct file *file, loff_t length, int small);
>  long do_sys_ftruncate(unsigned int fd, loff_t length, int small);
>  int chmod_common(const struct path *path, umode_t mode);
>  int do_fchownat(int dfd, const char __user *filename, uid_t user, gid_t group,
> diff --git a/fs/open.c b/fs/open.c
> index 02dc608d40d8..649d38eecfe4 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -154,49 +154,52 @@ COMPAT_SYSCALL_DEFINE2(truncate, const char __user *, path, compat_off_t, length
>  }
>  #endif
>  
> -long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
> +long ftruncate_file(struct file *file, loff_t length, int small)

All internal functions that io_uring currently calls are called do_*():

* do_rmdir()
* do_unlinkat()
* do_mkdirat()
* do_symlinkat()
* do_statx()

So I'd follow that pattern and just call that thing do_ftruncate().
Otherwise looks good to me,

Acked-by: Christian Brauner <brauner@kernel.org>

