Return-Path: <io-uring+bounces-6312-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DDF2A2CB6F
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 19:38:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A72C3A872A
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 18:37:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8A3E1DF979;
	Fri,  7 Feb 2025 18:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Pvisv8OA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5672D1DF974
	for <io-uring@vger.kernel.org>; Fri,  7 Feb 2025 18:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738952673; cv=none; b=TtxfCbBNtfShGovrCK0duvdqnz7TjL9G9mmlR7URJuq3F3Lyu9cyez9GR5rURZ/YrKrAg9i+qiAA74y8TtCOpl1kz9ExwXBr4UDk2YXDi9RvQO4VJXhDrERcz/c77LADw0xCVfQYHidOJ4niWxdXLPTHAIzSwaay0r167yaJfJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738952673; c=relaxed/simple;
	bh=vkoWl7flEapiLD3wBz2If9EaC6GzGOx9HVjiMBTcOSc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X2071qccS+WwBEvMlKZ9s+ziqLVQB0rtDHaYa2BNdceSGc6TZkztlob6XXgFyO6abPpvwqqFXSvFzC/ekoUJr9Qyyl/kipRFWlQsgnm0PQziCfXP6uAKyP5ox8SIbUFlY0u3dQPJpJk/5ITOL1OUK6KbLwqUHYQi7tv9NhQxNQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Pvisv8OA; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3d144f1f68bso2173035ab.3
        for <io-uring@vger.kernel.org>; Fri, 07 Feb 2025 10:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738952669; x=1739557469; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oUl+lJe5zdU1aBjOYjlfHnJlRG+OVSuJE0z1SWx2zRA=;
        b=Pvisv8OAMk5iWxfGn9ubujejq9wa7JHcGW+FSmA/0wR3CZmjMCNt2rXMTkkUtrl+Fr
         EavgiHGo/5S4MPq5P0M5MqNyHMehvYBIdjmGvviOMuC9xE9rcxZbcJnpF2VIoauX6rWM
         nG+OpbpOOBHTiqCmMD8LZZ2XK+0AUpB50qkMkXLDlXmZzoAGUZkvs2/xEZdU0mcMMPUT
         ZpfrybFMIum0j/x/QV+5x1KsLgY5HytdN4qpDq7dp4AEmBUS9n0npor3KSNjy+sKCrvr
         4oChI0BkVxR3GSMAM25AGwUVlAzP5bfDUDaNNfcCDM7dBdYpodbT9FYHl+nfXQklUlJp
         azsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738952669; x=1739557469;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oUl+lJe5zdU1aBjOYjlfHnJlRG+OVSuJE0z1SWx2zRA=;
        b=LhKRXb08TxvA9RE1tet1KTrpWtSrOMkzL1pVAG+V3XjG4fYlnLSA4uXgpdvVzE7WnX
         I0S3WH8JNFpY9kRIPnLjEeTWuyxGZGekE8t7ICCr+6lK3fiyVAgKgTgmP9FBY9o+vQ9T
         QEu22e6zoKFZuPhTK0W0dIlHsG8mBLHsux58/SiDBEUTPJYu8DamNGAmRnJ1fJ/LkGlH
         gZdcYksxaIWHywiBCRBh6wTiWsMBaaZPjl0uyBjKnW6cLg3sCSYO4tgfE1R5e71c18z/
         hoI98tZ7UfMyFF3L0/LNTGX48PYPp3rauDUi7eoRA6oqZGs6AsdCBUf7/f7KqvsIg+dM
         Lvfg==
X-Gm-Message-State: AOJu0YzKscrR1cbaOBMGo+S1vEKk6hq8tavd+7giCGK0QOLO6vAf36R3
	LXqOyt2DIjiM8wxnqSByzISUW0e8Pd4VSMOy6nCBvuAm9W4j+TphsbBho1EoLK0=
X-Gm-Gg: ASbGncuH0vt7xuj6c53m55ujQTkA7onmbAZA03caFzwVIvGLqOQYj2eCUlNvekqxH6o
	UyI3U00ijw7xL6qNxVHu/+BgZRFr8zNZRadXWDDaRheIclLRwt1bYnniDUYVNI2sOUI5EzRipzb
	8dqjkCzYWZMobmxwFy0e6zGjH/5zAlcT8TmoZkeoDF7+Q6Hyz8vrOrQQAfDC/PRVtKP5C2v1F0I
	oFo4Lf1KPOmePqjmreflHMSaqT1G9UPgXJdkDnbObPiiwbMMhpQY+2eMjEn0gfqRknwSupM7ctc
	OeO+1o8O5xE=
X-Google-Smtp-Source: AGHT+IEL7PQxe1C8LKvk5c+cipurZ4zDxAqYMgysw/qsDV/3fgKcf4K/mq04qbl+67HpTwO4Q/g0sg==
X-Received: by 2002:a05:6e02:1a41:b0:3cf:bac5:d90c with SMTP id e9e14a558f8ab-3d13defdaebmr32697615ab.18.1738952669090;
        Fri, 07 Feb 2025 10:24:29 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4eccfacfde2sm872327173.98.2025.02.07.10.24.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2025 10:24:28 -0800 (PST)
Message-ID: <7a2864fa-3312-413a-b513-58671ce3963f@kernel.dk>
Date: Fri, 7 Feb 2025 11:24:27 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io-wq: backoff when retrying worker creation
To: Uday Shankar <ushankar@purestorage.com>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
References: <20250206-wq_retry-v1-1-6d79bde1e69f@purestorage.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250206-wq_retry-v1-1-6d79bde1e69f@purestorage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/6/25 3:38 PM, Uday Shankar wrote:
>  io_uring/io-wq.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
> index f7d328feb7225d809601707e423c86a85ebb1c3c..173c77b70060bbbb2cd6009614c079095fab3e3c 100644
> --- a/io_uring/io-wq.c
> +++ b/io_uring/io-wq.c
> @@ -63,7 +63,7 @@ struct io_worker {
>  
>  	union {
>  		struct rcu_head rcu;
> -		struct work_struct work;
> +		struct delayed_work work;
>  	};
>  };
>  
> @@ -784,6 +784,18 @@ static inline bool io_should_retry_thread(struct io_worker *worker, long err)
>  	}
>  }
>  
> +static void queue_create_worker_retry(struct io_worker *worker)
> +{
> +	/*
> +	 * We only bother retrying because there's a chance that the
> +	 * failure to create a worker is due to some temporary condition
> +	 * in the forking task (e.g. outstanding signal); give the task
> +	 * some time to clear that condition.
> +	 */
> +	schedule_delayed_work(
> +		&worker->work, msecs_to_jiffies(worker->init_retries * 5));
> +}

This should be broken ala:

	schedule_delayed_work(&worker->work,
				msecs_to_jiffies(worker->init_retries * 5));

as that's more readable. But that's just a minor nit. I do think the
increased backoff makes sense, and while I agree that this isn't the
prettiest solution (or guaranteed foolproof), it'll most likely fix the
issue.


>  static void io_workqueue_create(struct work_struct *work)
>  {
> -	struct io_worker *worker = container_of(work, struct io_worker, work);
> +	struct io_worker *worker = container_of(
> +		work, struct io_worker, work.work);

Same here on line break.

I can make these edits while applying, or just send a v2. Thanks!

-- 
Jens Axboe

