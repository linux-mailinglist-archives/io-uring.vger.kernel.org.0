Return-Path: <io-uring+bounces-12770-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eALoM/GjvWkM/wIAu9opvQ
	(envelope-from <io-uring+bounces-12770-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 20:45:53 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id DC9662E0540
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 20:45:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A7ED53039EED
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 19:36:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEF2F3ECBE7;
	Fri, 20 Mar 2026 19:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QkwhXXiD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A16A3E8C71
	for <io-uring@vger.kernel.org>; Fri, 20 Mar 2026 19:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774035275; cv=none; b=m49bkkTnHB+BnSasohg1sxmLQ7Ap9Tnofi6lbZbfvqGmrcuVQWmjvUsY6yBEIEBpB57TomukcXV8/5q18L0xRTbpWHVToAuUPDxjgP1JnOPvt/KAy8fOYuLs9bsbMQdxQhsr5zaTJtnN30AKeyyiGpQ3Ww/uPQ0hNm25ZYohssM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774035275; c=relaxed/simple;
	bh=FwBUNOvZQNrsC0bLTeOJsE6bKAUoEdxGbW7JNzOFIR0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p9Ojergnc1hwDsVaehbHQ3LX2H/A7OvmnBvnscd6NsQWMIOnDaWJrvwDXMrtgljIx37vbO2v2hDAGLwRGclMTl9VjMC1T3LO1xCwHoR4xHP64lLs6ZLemARTAOjPB1XxyQMxEeTEbLizfjzU7fAyC/gWvEG4/f9V9U1UcboKOPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QkwhXXiD; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-417400afaeeso2469170fac.1
        for <io-uring@vger.kernel.org>; Fri, 20 Mar 2026 12:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1774035271; x=1774640071; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PBCKl5XV2fZEJHRFI8QwapsaCQ6SSZzaVn8iplu1N8g=;
        b=QkwhXXiDQEwePu/D2drsahfEzp+uwtNbwCnaeC9I0G1Vbf9ccizqn/3DVtRUjn52J7
         GoJj6yG4TtEdX4lfgUvfh3jEH6LynXON/4NiuQxv00hMvKBgUfejh+FGta7p0k311Dul
         3tPgrTuXrx0RMb+naMTXvlQdv1i+8I5rZ2A27b/HQny5otGBJ2SbyDju1UNi7bWlTILZ
         zAaQR6GFsMhUVklj+4ssxJKUg0+khDfUNFAnQ0kLYMk5Ht/sB8RyYsCw4rVGSaA7cQQs
         aIlIsRlcj++qUqB13ofe4MmcU/6O8KQYc1H+nqBSqFh/mJ0oyIPsbBiP/13MNjslVHlL
         Jj0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774035271; x=1774640071;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PBCKl5XV2fZEJHRFI8QwapsaCQ6SSZzaVn8iplu1N8g=;
        b=aqi0OI2fVdIR3eVtkfgl+hvAojeVgx47Ew0jS0AYJhRdZy54pkree3Q/Mez2FLhXTq
         7zIT3IdMyhl6RDDiufKvbXGLwfFXpxv3y0weGa51la/HC7R1w+PiHfaoEGmwzpBBpu5c
         XaWujpuyj9VzljPNv/q6xf+X8ciyDdW96xtJ9Z+BtMBLE2+5Ap1NZWA65yxjBbS/nVuX
         yxmmXS2rxonAOGGd5u93gqwQVEB7WBdz/5N9FUadgWhwlex3SwYG25dpdLJ/wFTCF91K
         81+xJ6zOPp5/nZTzd6tD1jnGzoVxQLmJ8j3c7b7BHg63xC4xEuKmIwoqRyt886cOimQq
         XmPg==
X-Forwarded-Encrypted: i=1; AJvYcCWQvYBcFlmcG03niB3Vluu+8gjoTCwOeUC+iv2p6PelKo6+GrJ6qbujIaPQE4Cuy2W4SBcfCKeQfA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5Pjeg55H6ovVCG9T+TxcXU89FDpWN6hnB564ECOgtdUko+Yx3
	rMzGb3FcI48Jhibz4GFzp6uE6S6R7krtUsD3m3vNV4PKUQn2Aj9P5Qh1vuRdSfiVsZQ=
X-Gm-Gg: ATEYQzxfdnKOlnbp4slxwoKD3UPAusmkGli3MDIMyUhGNN1Um5fZeVWPbkG1GrX6TBh
	O33/Uh5NX3tEKNy42lWaiUTKGifQQnn67cX4sK6rpwd3AMXIBenr40r0NBJHuBEbVNXBgskTKv7
	UAAiU1HQiVM4ZEwYUkmJjr/qHFDX8y1PjUqu428AsVxVSjOWF3KgPaOsnCh351Am9gVsGKm+Dmw
	PrBcqT9Wjx+WkVPhsRefZddMKh/5TUdoTwJeuVsvhVPGXF/3J8LtumNC85cY13NpPjlYCow9b6c
	THUwqgrZzMeFemzyvZ1jJ7jmYKiTUyLdBKMG2AMbqRLTt+5SnfB97osA2B+t7LLYvyIzw0Mbh7+
	0XLL17jgtI7mt0nMM1zghwdc9jYx/0ag1u9Hlf0wSbcGTEsmw3vULghMjAFqc3ZdImEFA+i/19W
	d7Xj9cKJeSnRkmORT479POzXU8uAzm3Bbo2/D20J6sijh9sFaiT6cyb1giBmxIuvB9YI5uuD0ef
	9zvTyd5
X-Received: by 2002:a05:6820:609:b0:67c:1cdf:f046 with SMTP id 006d021491bc7-67c2353c5b9mr2459578eaf.7.1774035271200;
        Fri, 20 Mar 2026 12:34:31 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67c253fceddsm1763289eaf.15.2026.03.20.12.34.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2026 12:34:30 -0700 (PDT)
Message-ID: <ff60b19b-ecd8-44cd-b7d3-f7755fe49934@kernel.dk>
Date: Fri, 20 Mar 2026 13:34:29 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] io_uring: Add IORING_OP_DUP
To: Daniele Di Proietto <daniele.di.proietto@gmail.com>,
 io-uring@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>, Pavel Begunkov <asml.silence@gmail.com>,
 linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
References: <20260320182341.780295-1-daniele.di.proietto@gmail.com>
 <20260320182341.780295-3-daniele.di.proietto@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260320182341.780295-3-daniele.di.proietto@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12770-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,vger.kernel.org,zeniv.linux.org.uk,suse.cz];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: DC9662E0540
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/20/26 12:23 PM, Daniele Di Proietto wrote:
> diff --git a/fs/file.c b/fs/file.c
> index 384c83ce768d..64d712ef89b5 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -285,9 +285,8 @@ static int expand_fdtable(struct files_struct *files, unsigned int nr)
>   * Return <0 error code on error; 0 on success.
>   * The files->file_lock should be held on entry, and will be held on exit.
>   */
> -static int expand_files(struct files_struct *files, unsigned int nr)
> -	__releases(files->file_lock)
> -	__acquires(files->file_lock)
> +int expand_files(struct files_struct *files, unsigned int nr)
> +	__releases(files->file_lock) __acquires(files->file_lock)
>  {
>  	struct fdtable *fdt;
>  	int error;
> @@ -1291,13 +1290,33 @@ bool get_close_on_exec(unsigned int fd)
>  	return res;
>  }
>  
> -static int do_dup2(struct files_struct *files,
> -	struct file *file, unsigned fd, unsigned flags)
> -__releases(&files->file_lock)
> +/**
> + * do_replace_fd_locked() - Installs a file on a specific fd number.
> + * @files: struct files_struct to install the file on.
> + * @file: struct file to be installed.
> + * @fd: number in the files table to replace
> + * @flags: the O_* flags to apply to the new fd entry
> + *
> + * Installs a @file on the specific @fd number on the @files table.
> + *
> + * The caller must makes sure that @fd fits inside the @files table, likely via
> + * expand_files().
> + *
> + * Requires holding @files->file_lock.
> + *
> + * This helper handles its own reference counting of the incoming
> + * struct file.
> + *
> + * Returns a preexisting file in @fd, if any, NULL, if none or an error.
> + */
> +struct file *do_replace_fd_locked(struct files_struct *files, struct file *file,
> +				  unsigned int fd, unsigned int flags)
>  {
>  	struct file *tofree;
>  	struct fdtable *fdt;
>  
> +	lockdep_assert_held(&files->file_lock);
> +
>  	/*
>  	 * dup2() is expected to close the file installed in the target fd slot
>  	 * (if any). However, userspace hand-picking a fd may be racing against
> @@ -1328,26 +1347,19 @@ __releases(&files->file_lock)
>  	fd = array_index_nospec(fd, fdt->max_fds);
>  	tofree = rcu_dereference_raw(fdt->fd[fd]);
>  	if (!tofree && fd_is_open(fd, fdt))
> -		goto Ebusy;
> +		return ERR_PTR(-EBUSY);
>  	get_file(file);
>  	rcu_assign_pointer(fdt->fd[fd], file);
>  	__set_open_fd(fd, fdt, flags & O_CLOEXEC);
> -	spin_unlock(&files->file_lock);
> -
> -	if (tofree)
> -		filp_close(tofree, files);
> -
> -	return fd;
>  
> -Ebusy:
> -	spin_unlock(&files->file_lock);
> -	return -EBUSY;
> +	return tofree;
>  }
>  
>  int replace_fd(unsigned fd, struct file *file, unsigned flags)
>  {
> -	int err;
>  	struct files_struct *files = current->files;
> +	struct file *tofree;
> +	int err;
>  
>  	if (!file)
>  		return close_fd(fd);
> @@ -1359,9 +1371,14 @@ int replace_fd(unsigned fd, struct file *file, unsigned flags)
>  	err = expand_files(files, fd);
>  	if (unlikely(err < 0))
>  		goto out_unlock;
> -	err = do_dup2(files, file, fd, flags);
> -	if (err < 0)
> -		return err;
> +	tofree = do_replace_fd_locked(files, file, fd, flags);
> +	spin_unlock(&files->file_lock);
> +
> +	if (IS_ERR(tofree))
> +		return PTR_ERR(tofree);
> +
> +	if (tofree)
> +		filp_close(tofree, files);
>  	return 0;
>  
>  out_unlock:
> @@ -1422,11 +1439,29 @@ int receive_fd_replace(int new_fd, struct file *file, unsigned int o_flags)
>  	return new_fd;
>  }
>  
> -static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
> +static struct file *do_dup3(struct files_struct *files, unsigned int oldfd,
> +			    unsigned int newfd, int flags)
> +	__releases(files->file_lock) __acquires(files->file_lock)
>  {
> -	int err = -EBADF;
>  	struct file *file;
> +	int err = 0;
> +
> +	err = expand_files(files, newfd);
> +	file = files_lookup_fd_locked(files, oldfd);
> +	if (unlikely(!file))
> +		return ERR_PTR(-EBADF);
> +	if (err < 0) {
> +		if (err == -EMFILE)
> +			err = -EBADF;
> +		return ERR_PTR(err);
> +	}
> +	return do_replace_fd_locked(files, file, newfd, flags);
> +}
> +
> +static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
> +{
>  	struct files_struct *files = current->files;
> +	struct file *to_free;
>  
>  	if ((flags & ~O_CLOEXEC) != 0)
>  		return -EINVAL;
> @@ -1438,22 +1473,15 @@ static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
>  		return -EBADF;
>  
>  	spin_lock(&files->file_lock);
> -	err = expand_files(files, newfd);
> -	file = files_lookup_fd_locked(files, oldfd);
> -	if (unlikely(!file))
> -		goto Ebadf;
> -	if (unlikely(err < 0)) {
> -		if (err == -EMFILE)
> -			goto Ebadf;
> -		goto out_unlock;
> -	}
> -	return do_dup2(files, file, newfd, flags);
> -
> -Ebadf:
> -	err = -EBADF;
> -out_unlock:
> +	to_free = do_dup3(files, oldfd, newfd, flags);
>  	spin_unlock(&files->file_lock);
> -	return err;
> +
> +	if (IS_ERR(to_free))
> +		return PTR_ERR(to_free);
> +	if (to_free)
> +		filp_close(to_free, files);
> +
> +	return newfd;
>  }
>  
>  SYSCALL_DEFINE3(dup3, unsigned int, oldfd, unsigned int, newfd, int, flags)
> diff --git a/fs/internal.h b/fs/internal.h
> index cbc384a1aa09..c3d1eaf65328 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -197,6 +197,11 @@ extern struct file *do_file_open_root(const struct path *,
>  extern struct open_how build_open_how(int flags, umode_t mode);
>  extern int build_open_flags(const struct open_how *how, struct open_flags *op);
>  struct file *file_close_fd_locked(struct files_struct *files, unsigned fd);
> +struct file *do_replace_fd_locked(struct files_struct *files, struct file *file,
> +				  unsigned int fd, unsigned int flags)
> +	__must_hold(files->file_lock);
> +int expand_files(struct files_struct *files, unsigned int nr)
> +	__releases(files->file_lock) __acquires(files->file_lock);
>  
>  int do_ftruncate(struct file *file, loff_t length, int small);
>  int do_sys_ftruncate(unsigned int fd, loff_t length, int small);

All of the above should be a separate prep patch, not part of the
io_uring patch adding IORING_OP_DUP.

> diff --git a/io_uring/openclose.c b/io_uring/openclose.c
> index c71242915dad..2658adbfd17a 100644
> --- a/io_uring/openclose.c
> +++ b/io_uring/openclose.c
> @@ -446,3 +454,175 @@ int io_pipe(struct io_kiocb *req, unsigned int issue_flags)
>  		fput(files[1]);
>  	return ret;
>  }
> +
> +void io_dup_cleanup(struct io_kiocb *req)
> +{
> +	struct io_dup *id = io_kiocb_to_cmd(req, struct io_dup);
> +
> +	if (id->rsrc_node)
> +		io_put_rsrc_node(req->ctx, id->rsrc_node);
> +}

Probably doesn't hurt to be defensive and clear ->rsrc_node when put.

> +int io_dup_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	struct io_dup *id;
> +
> +	if (sqe->off || sqe->addr || sqe->len || sqe->buf_index || sqe->addr3)
> +		return -EINVAL;
> +
> +	id = io_kiocb_to_cmd(req, struct io_dup);
> +	id->flags = READ_ONCE(sqe->dup_flags);
> +	if (id->flags & ~(IORING_DUP_NO_CLOEXEC | IORING_DUP_OLD_FIXED |
> +			  IORING_DUP_NEW_FIXED))
> +		return -EINVAL;

Would be cleaner with an IORING_DUP_FLAGS mask above io_dup_prep().

> +static struct file *io_dup_get_old_file_fixed(struct io_kiocb *req,
> +					      unsigned int issue_flags,
> +					      unsigned int file_slot)
> +{
> +	struct io_dup *id = io_kiocb_to_cmd(req, struct io_dup);
> +	struct file *file = NULL;
> +
> +	if (!id->rsrc_node)
> +		id->rsrc_node =
> +			io_file_get_fixed_node(req, file_slot, issue_flags);

Just use the full line length, io_uring isn't a stickler on 80 chars and
it'd read better as:

	if (!id->rsrc_node)
		id->rsrc_node = io_file_get_fixed_node(req, file_slot, issue_flags);

Need to check further, but I'm assuming the difference here is for retry
where the node could already be assigned?


> +static int io_dup_to_fd(struct io_kiocb *req, unsigned int issue_flags,
> +			bool old_fixed, int old_fd, int new_fd, int o_flags)
> +{
> +	struct file *old_file, *to_replace, *to_close = NULL;
> +	bool non_block = issue_flags & IO_URING_F_NONBLOCK;
> +	struct files_struct *files = current->files;
> +	int ret;
> +
> +	if (new_fd >= rlimit(RLIMIT_NOFILE))
> +		return -EBADF;
> +
> +	if (old_fixed)
> +		old_file = io_dup_get_old_file_fixed(req, issue_flags, old_fd);
> +
> +	spin_lock(&files->file_lock);

If you use:

	guard(spinlock)(&files->file_lock);

and move:

> +
> +	/* Do we need to expand? If so, be safe and punt to async */
> +	if (new_fd >= files_fdtable(files)->max_fds && non_block)
> +		goto out_again;
> +	ret = expand_files(files, new_fd);
> +	if (ret < 0)
> +		goto out_unlock;
> +
> +	if (!old_fixed)
> +		old_file = files_lookup_fd_locked(files, old_fd);
> +
> +	ret = -EBADF;
> +	if (!old_file)
> +		goto out_unlock;
> +
> +	to_replace = files_lookup_fd_locked(files, new_fd);
> +	if (to_replace) {
> +		if (io_is_uring_fops(to_replace))
> +			goto out_unlock;
> +
> +		/* if the file has a flush method, be safe and punt to async */
> +		if (to_replace->f_op->flush && non_block)
> +			goto out_again;
> +	}
> +	to_close = do_replace_fd_locked(files, old_file, new_fd, o_flags);
> +	ret = new_fd;

into a helper, all of this somewhat messy goto error_handling stuff can
go away.

-- 
Jens Axboe

