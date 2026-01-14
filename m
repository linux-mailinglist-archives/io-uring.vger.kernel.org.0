Return-Path: <io-uring+bounces-11700-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 50A41D1E33A
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 11:47:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 29E6030670B5
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 10:43:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7049A39526D;
	Wed, 14 Jan 2026 10:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R/qJeu6H"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EC3393DC9
	for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 10:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768387322; cv=none; b=CmEGswL0Lh+3eI46/t07ujoWhPZu+5qCzGRdGhUZes0vCnhEa5BJ6fKAZmD+gg8jF5NHfgy3+cxJK+E/ZbobrgvgTha57Fs+G7j6NwJRM3hQcksy2wS36xYYpuX/d13MzOZ9gcq8c/LeqvBjGuV/WuLoiEuFOCZlZCo7VegHBus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768387322; c=relaxed/simple;
	bh=i4yytTNmVkmFiF7VhC12SD5qcVKeMJU0ABCzZO/63xY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HyNJOxlAnnF8PfLOXVxYZovWj7YBJfn+XcbIA75rzfIYkagFhZDnpKdTQryG5nJmgGI0oHvj29TVI4ld5Pr6/aGVYtgZ9pj3zGqFRZAglxZ7wSyfz5iUTxZSdZv24iH4On9k9pv41oiRg2vocSrd+3hzfVNFfvBi+d2D2b0U6bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R/qJeu6H; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-477563e28a3so4519445e9.1
        for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 02:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768387318; x=1768992118; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Lk7QsQj8+PnAUAXKejIhRlWfGoAntY1XiyL3gVs6yI=;
        b=R/qJeu6HoJthZFgQ5jwvjuATd3NFsmZb0XPMd/3F+SxJRrh2rPEO9ILbrihFG86CxY
         kxJlueg7RZwNhdTfsnCtnEE9JqKk2U6nbDWV9wqX3DJZHmEq2eISv4piq6rXKkCduOW7
         nNCFB7Zn5HO9slncITH8kfyBBWlbvmhBLSxTLSE6JduzvNTqSkagb7PIC+hzNJdLHLai
         XU0zf5tjMPqOHLUjVsf8EWQThT4XU/eKfioSn8paOW38Ux+tHVkKPBUvUXHkuiC0nHDD
         /YBEI954s7ocE6RUUoOxS3s7Uh8aL4DKkSytJJ79+gA2uPCWRiFQFe45iXBeTeK5W4qE
         E04Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768387318; x=1768992118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/Lk7QsQj8+PnAUAXKejIhRlWfGoAntY1XiyL3gVs6yI=;
        b=t+NvELPduU6pFdjuV8RujgWAv/sNmEH5HkgCQIsXEmEhMN6VqpXFupW3Kf/atmEQ65
         iH0f32uhhSq15tkRNSKVJgep3N0VeNkzZ2UG0hAqLAH8zCBMqRJ/jwy9aUP/rKoIRqCs
         mYGsLvUsqrjOb3hf6Mjy7lq+01Imu0BbYgtuT+GoQNIupVh/oWhyS7loMQWzwpNcx1o/
         Dz0LUqzW9OHAL1IxECQ4cWzprCSxFcpTKcYFLZZaTzAKFLI1AtBPQJs7v3YhQ5fAzIZL
         XVCBUK5MqmEvzhPQRuNaHf6bUFnFTya0wR/CHtu3X/ZbQ2+XYX/6JmSMZAj8GQ1nQ3nt
         icwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsESFqL6u8mb3P/1GZ9aYJVsCvxJ4yPf9B+faAuIi1OGCAnEH+/rmamURrMaLItLr3lgANMyF5gw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzDKWMPA3kSMLocCCLTbJBJynoqZy9DJg1AAFivHO6lIUpBdZMP
	RqlfLzaP8vk92TcdrkS3A2VztEIerT8tQXqiyr9mXhtbIdxSyZWNACa2
X-Gm-Gg: AY/fxX5T6oE9hrcPpsKw3DBd6CDmc63J9zBrIuK92oKOhlCl7/rDZdC8lAI14rgPRnf
	PrfQfQ6qEnqjebHhP0R8z5b4Hp4v4/Q+wOBIMtB+Pr1/hKOqsYMr/RnCtTMlICsuZ1Kb8pfjLT5
	PCNLpnjFF6YV3LYkG5vlDvDKxFrhIMZkt6kStJmeHudETWKf++El+ozqNqaWa6sZkcKbAXhYcZ4
	gFP2ggXwkds3edUprMwn8yXmbTxzBHareh4POtPy7yxVHT6rCWJKdisEqq5L4WH9yGsZoG48zze
	D7FlLCi9U2BbHQN4JR4ugYw57X0E7oLP0MkGuMLWD07meOYajQrK+AHJy2IykN0JR0yMnTeCD+D
	ZV4MEHVrVihTinB+s8+Yl3TxAEIM5NWruJPLvXIlgbPdzhE+RyBbrkh1b5/zNpKYsILY8QSrddt
	EudW6ieQ6EGIei7LCM8R+zop+5TDWkyxMjGInZ5esD6tJjULlq0Ef+
X-Received: by 2002:a05:600c:1c02:b0:46e:2815:8568 with SMTP id 5b1f17b1804b1-47ee37a440bmr25926025e9.10.1768387317582;
        Wed, 14 Jan 2026 02:41:57 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47ee5910fc2sm20776235e9.13.2026.01.14.02.41.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 02:41:57 -0800 (PST)
Date: Wed, 14 Jan 2026 10:41:55 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, Linus Torvalds
 <torvalds@linux-foundation.org>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Mateusz Guzik <mjguzik@gmail.com>, Paul Moore
 <paul@paul-moore.com>, Jens Axboe <axboe@kernel.dk>, audit@vger.kernel.org,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 68/68] sysfs(2): fs_index() argument is _not_ a
 pathname
Message-ID: <20260114104155.708180fc@pumpkin>
In-Reply-To: <20260114043310.3885463-69-viro@zeniv.linux.org.uk>
References: <20260114043310.3885463-1-viro@zeniv.linux.org.uk>
	<20260114043310.3885463-69-viro@zeniv.linux.org.uk>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jan 2026 04:33:10 +0000
Al Viro <viro@zeniv.linux.org.uk> wrote:

> ... it's a filesystem type name.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  fs/filesystems.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/filesystems.c b/fs/filesystems.c
> index 95e5256821a5..0c7d2b7ac26c 100644
> --- a/fs/filesystems.c
> +++ b/fs/filesystems.c
> @@ -132,24 +132,21 @@ EXPORT_SYMBOL(unregister_filesystem);
>  static int fs_index(const char __user * __name)
>  {
>  	struct file_system_type * tmp;
> -	struct filename *name;
> +	char *name __free(kfree) = strndup_user(__name, PATH_MAX);
>  	int err, index;
>  
> -	name = getname(__name);
> -	err = PTR_ERR(name);
>  	if (IS_ERR(name))
> -		return err;
> +		return PTR_ERR(name);

Doesn't that end up calling kfree(name) and the check in kfree() doesn't
seem to exclude error values.

Changing:
#define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) <= \
				(unsigned long)ZERO_SIZE_PTR)
to:
#define ZERO_OR_NULL_PTR(x) (4096 + (unsigned long)(x) <= \
				4096 + (unsigned long)ZERO_SIZE_PTR)
would fix it at minimal cost.

	David


>  
>  	err = -EINVAL;
>  	read_lock(&file_systems_lock);
>  	for (tmp=file_systems, index=0 ; tmp ; tmp=tmp->next, index++) {
> -		if (strcmp(tmp->name, name->name) == 0) {
> +		if (strcmp(tmp->name, name) == 0) {
>  			err = index;
>  			break;
>  		}
>  	}
>  	read_unlock(&file_systems_lock);
> -	putname(name);
>  	return err;
>  }
>  


