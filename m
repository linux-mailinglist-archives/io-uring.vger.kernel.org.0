Return-Path: <io-uring+bounces-466-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2460839BD6
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 23:08:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F05C28FB01
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 22:08:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A33F148CC5;
	Tue, 23 Jan 2024 22:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ygmZj01n"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BEB4E1BC
	for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 22:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706047680; cv=none; b=lYQ9boHfW3xUiAenUswR2H01UXJZkYIjlD8UawoQjqG2VIRUTi6sn/LAkSHSHz3uMsrHLN0uGoClbeXMuGW9xsaS89s4K68KZhzyIv+hWq5z+ATaLhMZADJGv4gnuWxLHBuqN6XKMzI97N2Ewu48nlpIQ1gh7JNh6ePN0XgZtRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706047680; c=relaxed/simple;
	bh=HFR4GK6PdrW3Nf0esLFuiIChziBQRVzxihNFEvR/qSA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oXkYtBSh80yR14kd/pYUj43e04ibsmb+TB9iTqSVC/BWNCYllqJ/CYhKdyPD6Os3Fe4TLQklU2VRYS46L2sXv4tX5o0f0+O7R/UpYocik7k8x/9MvOldafU+LnyWvFX4JqedmrrORF0NU5DKHjyyWyOvLj9galidDlIzKnErrzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ygmZj01n; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6d9bd8adb9aso910142b3a.0
        for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 14:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706047676; x=1706652476; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rsdz5EiagkqmXiAvpv6vmZ/y9nzPFM08ELqeuarmbVw=;
        b=ygmZj01nz/dXd77D164kll1yEpFNVt1DChXlBtjwymBEtJ57ekFP8YQ2dW8pxHUhIL
         HhIsWHy0nVbrJY0uEmrn6fMWUAX7ODv1ZiKS/jaJ511Zi749qiWZreXMKLDSdFKM2kHv
         rLH6/NHPY+0zPBMhjlVUFoqsUQWNoiQW8dPhOFtRNuPq2aX2PqR2govU9Jzzc7XRcAZk
         Jq7YSoOIxtYshGuyXcnh+hqFthy9xu4qYohTZH/qpLXNc2yDiCeWyOOCKvnITS5jgSpc
         juBoLD3pp8Tx8HmZyZVJ8BpIWTosDADbyFV8KISNU9VebVVgDywKDaaYNOhFK4QaABC1
         mNtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706047676; x=1706652476;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rsdz5EiagkqmXiAvpv6vmZ/y9nzPFM08ELqeuarmbVw=;
        b=fTweFRY3M8BTNmuIatJQXSVMMohpWQHR6fgSC7gvJrz4CfcegH1slVfET0fp624RBq
         YM3/lfE5zsG30u7U+GbDtCkiUtg2sExwCV+9A993IbZZRmAKAQtMMJc4bOum1Vo5gXeK
         kcgGC/ZaJAutUpIlwicFwEOvQUzIqFI298bqgI6N13nBab2hvjwjvbbQonbFf0ErmtV9
         Dhl906iv+HHjfasl7ki+K9r4/wKTqmXvF/Emj6OXeb75nasCupuoPUw8dCZliq86/ZJP
         WrGM4yru2tj1Eur+SJdl8gjcCY/PfsPCGcrl2bZRbDHvtXGkSkuyHwIWLHIJxb5PNW7J
         AWjw==
X-Gm-Message-State: AOJu0Yz+9efoyyJvDCV+TSInyn8kWtbF8OJMlq4njVJnSibNOkotG1wl
	IIqLO6WGIt++d0NOmp8v0L8lQ77KkUHK++CY4FPymnf2qI/ExktOHv/TeVn9oiI=
X-Google-Smtp-Source: AGHT+IGiA4db8xXv9VAoGJVRVoum1VD5ymUzhfxU/VyKtRxpEgN0CDDUeO/jTa+XI/OjIwdlYGCdKA==
X-Received: by 2002:a05:6a20:d398:b0:19b:1d4a:b94c with SMTP id iq24-20020a056a20d39800b0019b1d4ab94cmr15280399pzb.2.1706047676037;
        Tue, 23 Jan 2024 14:07:56 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id se6-20020a17090b518600b0028aecd6b29fsm12453429pjb.3.2024.01.23.14.07.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jan 2024 14:07:55 -0800 (PST)
Message-ID: <955c752a-7631-4f3e-a19b-e3bc8a5139f3@kernel.dk>
Date: Tue, 23 Jan 2024 15:07:54 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] Add ftruncate_file that truncates a struct file*
Content-Language: en-US
To: Tony Solomonik <tony.solomonik@gmail.com>
Cc: krisman@suse.de, leitao@debian.org, io-uring@vger.kernel.org,
 asml.silence@gmail.com
References: <20240123113333.79503-2-tony.solomonik@gmail.com>
 <20240123211952.32342-1-tony.solomonik@gmail.com>
 <20240123211952.32342-2-tony.solomonik@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240123211952.32342-2-tony.solomonik@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/23/24 2:19 PM, Tony Solomonik wrote:
> do_sys_ftruncate receives a file descriptor, fgets the struct file*, and
> finally actually truncates the file.

Just do struct file and get rid of '*', kernel style would otherwise
dictate it should be struct file * but there's no point in mentioning
this is a pointer. It's the only case that makes sense.

> ftruncate_file allows for truncating a file without fgets.

I'd rephrase that last sentence, as it reads as you could do this
without holding a file reference. That is obviously not true. You
could make it:

ftruncate_file allows for passing in a file directly, with the
caller already holding a reference to it.

> 
> Signed-off-by: Tony Solomonik <tony.solomonik@gmail.com>
> ---
>  fs/internal.h |  1 +
>  fs/open.c     | 51 ++++++++++++++++++++++++++++++---------------------
>  2 files changed, 31 insertions(+), 21 deletions(-)
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
> index 02dc608d40d8..0c505402e93d 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -154,47 +154,56 @@ COMPAT_SYSCALL_DEFINE2(truncate, const char __user *, path, compat_off_t, length
>  }
>  #endif
>  
> -long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
> +long ftruncate_file(struct file *file, loff_t length, int small)
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
> +		return error;
>  
>  	error = -EINVAL;
>  	/* Cannot ftruncate over 2^31 bytes without large file support */
>  	if (small && length > MAX_NON_LFS)
> -		goto out_putf;
> +		return error;
>  
>  	error = -EPERM;
>  	/* Check IS_APPEND on real upper inode */
> -	if (IS_APPEND(file_inode(f.file)))
> -		goto out_putf;
> +	if (IS_APPEND(file_inode(file)))
> +		return error;
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
> +  return error;

White space issue here with 'error'. And see below comments for error
assignment in general.

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
> +	error = ftruncate_file(f.file, length, small);
> +
>  	fdput(f);
>  out:
>  	return error;

No reason for the goto's here anymore, just do:

long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
{
	struct fd f;
	int error;

	if (length < 0)
		return -EINVAL;
	error = -EBADF;
	f = fdget(fd);
	if (f.file)
		error = ftruncate_file(f.file, length, small);
	fdput(f);
	return error;
}

Same for the above helper, save error for when you actually need it
rather than do:

	error = -EFOO;
	if (some_error)
		return error;

That only really makes sense when you assign error through eg calling a
function, not when you know what error you are returning. Makes it
easier to read the code as well.

-- 
Jens Axboe


