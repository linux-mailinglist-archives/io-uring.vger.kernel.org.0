Return-Path: <io-uring+bounces-4879-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5981A9D40C6
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 18:04:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1F5C4B284DA
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 16:53:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EADC153BEE;
	Wed, 20 Nov 2024 16:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uvII7Grk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CDC130A73
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 16:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732121586; cv=none; b=KOS/MNAgQzTzw6pIw0wCA2JE37ZMo09cGg266jF92+/TeB1uMX1U2Pb+8ZjjwotjQyXxZhNue5sgHhGzkFlOI36mNXq/pXafgj7qCkmHshCxVQU7UkqzIQDnz9DqnZKX4iYFLAComJOY35D+RqedGsUIyF9SZ02oZ8O6suBZnII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732121586; c=relaxed/simple;
	bh=ebP22XcP2eX4OYsj2BLJ9Ad1VKGHvy8XJeDHumy0Mzk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=f3ytUsTba0WiwcjCv3zH/nFZ4N1AO0P9o8FZdzEsute/ulyeCOtd978O9UZO942xYiMP2guSnedxi4JU98dyThSdWquDjJvsajo4mj4KLCSxMmj037i3E8zg0Eye+9AI/DSRtU8BFjrCO97pJdNytishADQayC5CfnuS5orfRwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uvII7Grk; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3e6010a3bbfso3048526b6e.2
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 08:53:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732121582; x=1732726382; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Fsm4sQGgxD1ZdQmkv8kfCFgg1gaZuY7Ug/f5xLlAUHQ=;
        b=uvII7GrkILopg7HAhenCQscKqA9Gfatb1rX+RnMsMzs/4aZIXCs2/chWs+EVm9HCEW
         SHEdj3q3cCzORlRPDljyTcquhN7ASWaM9PJub3j3l47y+/gwkvfbu0qRdVxvwNjoaBWo
         3u1MFxwvp0stvQvE5TXjiGQAXzEjVq+ylFkwKiH+XellIgtozqn+XNZBk0sc4irc727s
         dvQZPK7m0j8X/ehm2aYnJ9NBs/+cH6+rFca9INbUhOW5m6ZvOWRm6b5vfa+tMkJnqN4J
         GX72dp00xzh0oCzroxM5jm532qRBdkAbeYHimdQZEd6unnnrELfPob0aiBddvfonxg0X
         oXRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732121582; x=1732726382;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fsm4sQGgxD1ZdQmkv8kfCFgg1gaZuY7Ug/f5xLlAUHQ=;
        b=e1GgK6XC8MdG+Yr2tBH2pcfGqiA+P5OaIBs3An5mDf5nWPkl21ZjiujByZpI/Q0V/7
         /MdwJghHY0W0YOtVfeOQ5GqVhNzKCLLha1VtRvn22271TZyNjyZaXUsLjOZXXsrVAsvS
         c6aj48kb0RpOb7MJMicgeTaiYSiuNzsPw9QK+oJxXHVDjR8Z+iOfNhUwA/zVtWoCet2r
         haDrUWIUt5Nb6zrCUeltb6fV4X+rBOh5SaaQ4M66WqRf3NpQnZzEj+VOAqf0Wbdg/p9U
         EvO/5DI/JKLA2/na0bIQc7xYU8+w19jesFv94b+K3rqmiZAxnnCd9qr5AJQDWhquPyTz
         nJow==
X-Forwarded-Encrypted: i=1; AJvYcCXFQ0nGVcMI4OSqFBOC9sBtsr7S7SuaaVHmyvP86HUX2ctJa1nSJgv0Y9n3CeVk28/O3wgrHpinQA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyiOz9oGUF9NJOdCE0QyKJwfFeiqpgHnxyF6jFuzeWLeggIo0GR
	sBKgEaYeWhssFoyT4Qqc+Y1pQFq0eWnnv07S7bUvXWUZkc8SM9hnGyTUI2A2NFYQXRn+9Xt2Fr0
	E9Es=
X-Google-Smtp-Source: AGHT+IHkavY08KUyna0ZZHrkcUUD/F5RPMkYj+xI8ErCsc39SywNVME1+r+2PALypqd6ZvwrOtwNFg==
X-Received: by 2002:a05:6808:1b9a:b0:3e6:6546:9142 with SMTP id 5614622812f47-3e7eb6b1d72mr3546772b6e.4.1732121582477;
        Wed, 20 Nov 2024 08:53:02 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3e7bcc3876dsm4305135b6e.0.2024.11.20.08.53.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2024 08:53:01 -0800 (PST)
Message-ID: <4fc23dcd-bfa8-40f4-9409-8817f6b7d4fa@kernel.dk>
Date: Wed, 20 Nov 2024 09:53:01 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] btrfs: don't read from userspace twice in
 btrfs_uring_encoded_read()
To: Mark Harmstone <maharmstone@fb.com>, linux-btrfs@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20241120160231.1106844-1-maharmstone@fb.com>
 <20241120160231.1106844-4-maharmstone@fb.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241120160231.1106844-4-maharmstone@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/20/24 9:02 AM, Mark Harmstone wrote:
> If we return -EAGAIN the first time because we need to block,
> btrfs_uring_encoded_read() will get called twice. Take a copy of args
> the first time, to prevent userspace from messing around with it.
> 
> Signed-off-by: Mark Harmstone <maharmstone@fb.com>
> ---
>  fs/btrfs/ioctl.c | 74 ++++++++++++++++++++++++++++++++----------------
>  1 file changed, 49 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 488dcd022dea..97f7812cbf7c 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4873,7 +4873,7 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
>  {
>  	size_t copy_end_kernel = offsetofend(struct btrfs_ioctl_encoded_io_args, flags);
>  	size_t copy_end;
> -	struct btrfs_ioctl_encoded_io_args args = { 0 };
> +	struct btrfs_ioctl_encoded_io_args *args;
>  	int ret;
>  	u64 disk_bytenr, disk_io_size;
>  	struct file *file;
> @@ -4888,6 +4888,9 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
>  	struct extent_state *cached_state = NULL;
>  	u64 start, lockend;
>  	void __user *sqe_addr;
> +	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
> +	struct io_uring_cmd_data *data = req->async_data;
> +	bool need_copy = false;
>  
>  	if (!capable(CAP_SYS_ADMIN)) {
>  		ret = -EPERM;
> @@ -4899,34 +4902,55 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
>  	io_tree = &inode->io_tree;
>  	sqe_addr = u64_to_user_ptr(READ_ONCE(cmd->sqe->addr));
>  
> +	if (!data->op_data) {
> +		data->op_data = kzalloc(sizeof(*args), GFP_NOFS);
> +		if (!data->op_data) {
> +			ret = -ENOMEM;
> +			goto out_acct;
> +		}
> +
> +		need_copy = true;
> +	}

I'd probably get rid of this need_copy variable and just do the copy
here? Might look cleaner with an btrfs_alloc_copy_foo() helper, as you
could just do:

ret = btrfs_alloc_copy_foo(...);
if (unlikely(ret))
	return ret;

and hide all that ugly compat business outside the meat of this
function.

More of a style thing, the change itself looks fine.

-- 
Jens Axboe

