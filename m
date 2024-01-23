Return-Path: <io-uring+bounces-457-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 44B9483937D
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 16:46:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC3EC1F246B9
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 15:46:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 818676024E;
	Tue, 23 Jan 2024 15:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jWLl7iS8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4245FEEE
	for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 15:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706024319; cv=none; b=Z87zX6agSbERdWfd0EkA5r9dggGf8R1CqPvI9COwk+VovEvPbf6bqolMjPUxKewYJvINl++wxPEmlLccBAO1bZslXAax/VnYjcCosfxp0LEw5xrLDG5zWUraZGM24YUEHW/uQX0z5HbP2yrViex+4bJ/5Aabw7kLEtXV3yP1xEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706024319; c=relaxed/simple;
	bh=f5CZodpZW39yQTXLwNwYBB6p80UmHudqWrYcppVbzvc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AZThqcISu/82TSpQ4g8XLqp9jFZKGo9FzM12dY52gve004bZ8sa+NKKk7MdrdnwbAVGIktBE6q2pe5JwidyfMaLJirJnljTpIR5GGRHIZ3NW4Go4Tsb6pkH/xYD8dNn5sRC+vTaC32QrMgXalvDru0yr6OUN1OPGyaYzOmu4Eb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jWLl7iS8; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-7bed82030faso57596939f.1
        for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 07:38:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706024316; x=1706629116; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0rPDmRXahONw/h2hfRCZhlKzR0qy1J/U+PJfCfBM4oo=;
        b=jWLl7iS815EIwnyRaT/InQNto3uP3mrI1QSKVm4VwZqJt13xEOqCRcTrM7IVWbG5Bj
         Kjg+UThHlwCFECAmoXxqPejSDleRgbDGHoewAZ/EWwBaidchhInu9+D3wiR8papp9/aH
         TEN+WzL3+XkVj1Gd2lYgbWjOqjq9qCQrI/LuTzARlEHx4omxG14hQ76kEPthPUWRWZCw
         DyYBKc8OPcSza6D5YFbvk+oqiyczZxe8MC7vkvcu5DZzCpf9SdF/syKVz13geYgGMQXd
         +V5QNU4O9xrp9l7k5M7/oqtXHyh2XKrUlZBN9wXqbs8K46ELfL9t+lMnJ4fsxaLqrg1g
         +khw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706024316; x=1706629116;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0rPDmRXahONw/h2hfRCZhlKzR0qy1J/U+PJfCfBM4oo=;
        b=mj8tWx6R+/F3mZgIdaVnMOP/X0pvsAl7s7pnejtiJEFOgINVmgln/GBjIivH3x0BcF
         2b3HSFBkofPg/XgiIlYxk5rnTE0GXAJucF/Udgd2AzOhHYS576VQsqAtf7706vRFReY5
         /Fg4bjvvarv9BTIFdSULK7YQSJbrzo4s1b4LW5SPF+V74ZwIRZztaEpjGM3/VUHI0aEB
         hX0hDM2kb9AusBGYP7i7U4cHxJ6n107l/Wntzo16g0wJ/I9S4qWQx8dEJVOn91gI+Jm3
         fh8cNW9n7e0SLr/ZDYnVI288pkj7KvPLwNgwz0EykHGMnnDScZgYsHCb0EhYvTH0VrVK
         IUyA==
X-Gm-Message-State: AOJu0YzRrqfNO0SRpVJbPCVZBojNFonKGWmXO5WLJMVcaB1kjc9BEjJu
	BsboN++PcDXnGBYW1I8N7W+o0MCkBdh7lYtLR2HPwKA5j1K5pS9reT82MNajaX4=
X-Google-Smtp-Source: AGHT+IHqX0W3qXCIrVKwiAQ5viiABfYiIF5FIBCSDpX5+FstzE7y47TuQzfacPkjmoVUihIT56iaAw==
X-Received: by 2002:a05:6602:4145:b0:7bf:60bc:7f1e with SMTP id bv5-20020a056602414500b007bf60bc7f1emr11047701iob.1.1706024316233;
        Tue, 23 Jan 2024 07:38:36 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l17-20020a02a891000000b0046df3b352casm3578713jam.38.2024.01.23.07.38.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jan 2024 07:38:35 -0800 (PST)
Message-ID: <a44444f9-a220-48a3-b282-a26319e2261c@kernel.dk>
Date: Tue, 23 Jan 2024 08:38:34 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] Add __do_ftruncate that truncates a struct file*
Content-Language: en-US
To: Tony Solomonik <tony.solomonik@gmail.com>
Cc: krisman@suse.de, leitao@debian.org, io-uring@vger.kernel.org,
 asml.silence@gmail.com
References: <CAD62OrGa9pS6-Qgg_UD4r4d+kCSPQihq0VvtVombrbAAOroG=w@mail.gmail.com>
 <20240123113333.79503-1-tony.solomonik@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240123113333.79503-1-tony.solomonik@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/23/24 4:33 AM, Tony Solomonik wrote:
> do_sys_ftruncate receives a file descriptor, fgets the struct file*, and
> finally actually truncates the file.
> 
> __do_ftruncate allows for truncating a file without fgets.
> ---
>  fs/open.c                | 52 ++++++++++++++++++++++++----------------
>  include/linux/syscalls.h |  2 ++
>  2 files changed, 33 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index 02dc608d40d8..b32ac430666c 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -154,47 +154,57 @@ COMPAT_SYSCALL_DEFINE2(truncate, const char __user *, path, compat_off_t, length
>  }
>  #endif
>  
> -long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
> +long __do_ftruncate(struct file *file, loff_t length, int small)
>  {
>  	struct inode *inode;
>  	struct dentry *dentry;
> -	struct fd f;
>  	int error;
>  
> -	error = -EINVAL;
> -	if (length < 0)
> -		goto out;
> -	error = -EBADF;
> -	f = fdget(fd);
> -	if (!f.file)
> -		goto out;
> -
>  	/* explicitly opened as large or we are on 64-bit box */
> -	if (f.file->f_flags & O_LARGEFILE)
> +	if (file->f_flags & O_LARGEFILE)
>  		small = 0;
>  
> -	dentry = f.file->f_path.dentry;
> +	dentry = file->f_path.dentry;
>  	inode = dentry->d_inode;
>  	error = -EINVAL;
> -	if (!S_ISREG(inode->i_mode) || !(f.file->f_mode & FMODE_WRITE))
> -		goto out_putf;
> +	if (!S_ISREG(inode->i_mode) || !(file->f_mode & FMODE_WRITE))
> +		goto out;
>  
>  	error = -EINVAL;
>  	/* Cannot ftruncate over 2^31 bytes without large file support */
>  	if (small && length > MAX_NON_LFS)
> -		goto out_putf;
> +		goto out;
>  
>  	error = -EPERM;
>  	/* Check IS_APPEND on real upper inode */
> -	if (IS_APPEND(file_inode(f.file)))
> -		goto out_putf;
> +	if (IS_APPEND(file_inode(file)))
> +		goto out;
>  	sb_start_write(inode->i_sb);
> -	error = security_file_truncate(f.file);
> +	error = security_file_truncate(file);
>  	if (!error)
> -		error = do_truncate(file_mnt_idmap(f.file), dentry, length,
> -				    ATTR_MTIME | ATTR_CTIME, f.file);
> +		error = do_truncate(file_mnt_idmap(file), dentry, length,
> +				    ATTR_MTIME | ATTR_CTIME, file);
>  	sb_end_write(inode->i_sb);
> -out_putf:
> +
> +out:
> +  return error;
> +}
> +
> +long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
> +{
> +	struct fd f;
> +	int error;
> +
> +	error = -EINVAL;
> +	if (length < 0)
> +		goto out;
> +	error = -EBADF;
> +	f = fdget(fd);
> +	if (!f.file)
> +		goto out;
> +
> +	error = __do_ftruncate(f.file, length, small);
> +
>  	fdput(f);
>  out:

Same comments as Gabriel for the out label, just return error.

> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index fd9d12de7e92..e8c56986e751 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -1229,6 +1229,8 @@ static inline long ksys_lchown(const char __user *filename, uid_t user,
>  			     AT_SYMLINK_NOFOLLOW);
>  }
>  
> +extern long __do_ftruncate(struct file *file, loff_t length, int small);
> +
>  extern long do_sys_ftruncate(unsigned int fd, loff_t length, int small);
>  
>  static inline long ksys_ftruncate(unsigned int fd, loff_t length)

This should go in fs/internal.h, it's not a syscall related thing.

-- 
Jens Axboe


