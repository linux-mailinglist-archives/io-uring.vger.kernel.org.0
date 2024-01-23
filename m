Return-Path: <io-uring+bounces-454-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 702B78391C3
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 15:53:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1EBEB2809B2
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 14:53:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11D631C14;
	Tue, 23 Jan 2024 14:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yfH847dm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="XzIOzs78";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yfH847dm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="XzIOzs78"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B4A5FB80
	for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 14:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706021611; cv=none; b=VufFCD3ywiECsyXUUWDebHb61ZAzyXe+Bg/wdpw4TQr62V9U1XTk0un91MDufKZvXeZg0VKA/N+EJ3Us0110jAZyGnK08NKL7sQUuGUq39GPG06E6hpsa2Dz6I+VXwoLoUiMEVkxzjZymd7Uw/S5vFy4025jOJDQ57DTwGsZ69g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706021611; c=relaxed/simple;
	bh=vPD92HP7g75Dv73EzRrlGICL9R2GKiuUBqr8WHFA1a4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=tsY4e4EHG4Ea2/s4hSWSa9GBRisCcCxkgEUg8M20gzFry40z6bThj8GGyVt/PKt67Ea+gxTc2Mq4dzBa6Q8B5s0y/quBxR+CuxF883s69gZmoEKPEmJM/ExjluJBv+z7TnvyhkvDyJljL9vdM+xZqilAclP/vy2Ao8l08sCZaE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yfH847dm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=XzIOzs78; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yfH847dm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=XzIOzs78; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4409E22D73;
	Tue, 23 Jan 2024 14:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1706021607; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ngmXuw6UxtBMlddWO4rPVNrLF72WO09VI/iDlYhWZtg=;
	b=yfH847dmMYnAWWnCYdXKrtW4Bfqr4MANAQsIBkZR5F9TtbZOS6MyEvCrEG1fUP6iRMoqJ2
	L+aOAs2wZv8/5Ulu5Gh1iKqIk0X1NvbejwETTDLDBeLDHqiAvb9na4Fy8lwH8Zj73Mx+YC
	UIXwwW9DEbTVkj0th9SoMbzkFMev1zc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1706021607;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ngmXuw6UxtBMlddWO4rPVNrLF72WO09VI/iDlYhWZtg=;
	b=XzIOzs78HwwzlXeATIqNmtqjkCqFFg9KsSHURX6lliuPahnHN0820YfqvLrghXr8NADwJo
	meACWApWwe8ZXfDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1706021607; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ngmXuw6UxtBMlddWO4rPVNrLF72WO09VI/iDlYhWZtg=;
	b=yfH847dmMYnAWWnCYdXKrtW4Bfqr4MANAQsIBkZR5F9TtbZOS6MyEvCrEG1fUP6iRMoqJ2
	L+aOAs2wZv8/5Ulu5Gh1iKqIk0X1NvbejwETTDLDBeLDHqiAvb9na4Fy8lwH8Zj73Mx+YC
	UIXwwW9DEbTVkj0th9SoMbzkFMev1zc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1706021607;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ngmXuw6UxtBMlddWO4rPVNrLF72WO09VI/iDlYhWZtg=;
	b=XzIOzs78HwwzlXeATIqNmtqjkCqFFg9KsSHURX6lliuPahnHN0820YfqvLrghXr8NADwJo
	meACWApWwe8ZXfDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C03A813786;
	Tue, 23 Jan 2024 14:53:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id r2PdIObSr2XTagAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 23 Jan 2024 14:53:26 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Tony Solomonik <tony.solomonik@gmail.com>
Cc: axboe@kernel.dk,  leitao@debian.org,  io-uring@vger.kernel.org,
  asml.silence@gmail.com
Subject: Re: [PATCH v2 1/2] Add __do_ftruncate that truncates a struct file*
In-Reply-To: <20240123113333.79503-1-tony.solomonik@gmail.com> (Tony
	Solomonik's message of "Tue, 23 Jan 2024 13:33:32 +0200")
Organization: SUSE
References: <CAD62OrGa9pS6-Qgg_UD4r4d+kCSPQihq0VvtVombrbAAOroG=w@mail.gmail.com>
	<20240123113333.79503-1-tony.solomonik@gmail.com>
Date: Tue, 23 Jan 2024 11:53:24 -0300
Message-ID: <8734uot82j.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 TAGGED_RCPT(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCPT_COUNT_FIVE(0.00)[5];
	 HAS_ORG_HEADER(0.00)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-0.999];
	 FREEMAIL_TO(0.00)[gmail.com];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 FREEMAIL_CC(0.00)[kernel.dk,debian.org,vger.kernel.org,gmail.com];
	 RCVD_TLS_ALL(0.00)[];
	 SUSPICIOUS_RECIPS(1.50)[]
X-Spam-Flag: NO

Tony Solomonik <tony.solomonik@gmail.com> writes:

> do_sys_ftruncate receives a file descriptor, fgets the struct file*, and
> finally actually truncates the file.

This need to be Cc'ed to the VFS maintainers and appropriated lists.
Also, you need a signed-off-by line and cover letter.

Take a look at:

https://www.kernel.org/doc/html/v6.7/process/submitting-patches.html

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

Just return directly here. No point in jumping to 'out' just to return
immediately.

>  
>  	error = -EINVAL;
>  	/* Cannot ftruncate over 2^31 bytes without large file support */
>  	if (small && length > MAX_NON_LFS)
> -		goto out_putf;
> +		goto out;

likewise for the others..

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
>  	return error;

Same here.

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

-- 
Gabriel Krisman Bertazi

