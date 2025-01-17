Return-Path: <io-uring+bounces-5966-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 24298A14E48
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 12:17:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A7213A5C22
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 11:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36D9F1F754C;
	Fri, 17 Jan 2025 11:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LCs/SGqm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7E346BF;
	Fri, 17 Jan 2025 11:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737112654; cv=none; b=Yn/vEjXXKt7UnmxOeoWSblOdla0TZ2VWBkizMaqb+2COw4PliLweKO92b8+sW5vgC2xXedyDp3YpBCsfuHCFSRCV+cPwzBvETnewmV4+4v+ck9ZJZFyTN6uxXXaVkJsxskr7QsbIGSICmRvUQ/nATeXE+G3Oj/XXcYUZpjRiCOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737112654; c=relaxed/simple;
	bh=qlVoELdeJm47htV5g82z1Q6cR45D0c8rrfoTlycrFvg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FB4nnfn8CR91TB5b81Q02ew0HhxOrCZr+98yr6MYuF9fW3PpKayGwv9HTJEBvEd23SAcvpcEijkhtpiCziYEc+NSxjcJrhJ3aS++oSkmID71mgY4pGzlD92jv6BD81i3Q3bApkYMaQqVeWfqBbFOJ4/gm92SC38nsiqDEMFQOGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LCs/SGqm; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5d3f57582a2so6319369a12.1;
        Fri, 17 Jan 2025 03:17:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737112651; x=1737717451; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YV838MOWZd2VxEWX4wg7yYv/YVoGjELOTj2SSPMF/0Y=;
        b=LCs/SGqm/OKzZ7fo+jHs540nMMjP46bH3gLcChRJ0es/CA9ky14NDk6t5vqf5UNbWF
         tMOlibBy52W/MTIeUrjDWg/yl2XvsUfLgBF128GhSmULOx5x1hl9s9+K+6wnTJJQbIPt
         NItB0ie1ExeHfDiRuTzf1nC25Bfzx3/Vw9LfE5R5WEinYru2kWWMRkxCFHR9ImCBt1vx
         y1Ow8skNPNgUd1fVpR5gyggj616CTR9O802LMn8K8Elq7A9IrraKPrg4FnqKgZr+Rv6J
         yc8VkQrteC1wuKkCv8IQKAz4+x1qti8wCM6JilaZh63NPDIhIYFBaWXE5W01+7E5CwfN
         vpfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737112651; x=1737717451;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YV838MOWZd2VxEWX4wg7yYv/YVoGjELOTj2SSPMF/0Y=;
        b=jVyY1E1V3vfXnUjzg0V43l1DuZ4AlQU2Qwj+voF8jPrar2K+RA/J/QFh0a6IcTxCfJ
         3N+XLBZxjSrm3b/8pYqcOvqDLA5RuK7/CNkD4T1wM3c+vZukdbb/2evCXEZyFiQT2un0
         DJfbFyPVi+oZN3K7gvT4FlC9j8R3dkQvWDVO709dsQKIeQWXF4X0WqTW5AmuznS/siFc
         I7YBIsGerFs4ve+sQ4OQYwYDon9p3VB3/TOURHq55RHxUnCRqWx88J75YX8f+1b8wmeL
         XJbXdMgvyAHGR/Xwjy/SjpsxDbqjVlmBiyXt3Ag53QUhbR+FBSQkbkYxt9kbH1hb2AjB
         mIfg==
X-Forwarded-Encrypted: i=1; AJvYcCUh2mGmh3+HQtMKTxLaiklvBDlLR3st3BDCopzeUSFq7kxPSTjpnQIaNi2KvF5R/qMQbqzcS2HVmYy3VFMMZA==@vger.kernel.org, AJvYcCWl9DTrWai6mOJxbZ+YTh04/MyO/XoDOuO7O7ig7f2BYS18Z7EI8xFJxXUQl0EKueH0yqdNUvEwwg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyJMjuDVMqzTwKBCX28mcYJfqogJ0tZc/DU0tkXxH+erSO15QHt
	NUcMrmVBlwDCYiqK2cn5/A5djwJyLzc9wtQ9jENOkubOhPpfnYtS
X-Gm-Gg: ASbGncvLFx9fgKSgCXQABHMWwO5BzUxHlQ+ZfEU6ZQmfGZsPlBHn2Erk4HN9Y6TctGV
	r87IhJBGo2yCqkhvYU6Df6Cxs4H8RaIQGRr8pZ7OZ5PJKvD/PGPPkLwisF009jgkaPTl1BmYV6K
	owevO950dLXngm6plYMOvHF1Zc8qXTajZvTYwlx0y9/7dNI6CUihiMUZ8+SiUiWxl5JX/9Yx0uw
	QdvnOYslQfCIctH+DCeYFXHjJFQ7xZSQZnbcHurgV3zRxqwqCYW/+LtYwnLKiX1F5X+M17gbZYI
	uX7K
X-Google-Smtp-Source: AGHT+IHW5hTlF7ape9zXySS57WwItUZtmObdN7V+tnvhwk+SQpBcZ7gRxjzoIhKa2HLP40jr2FGuYA==
X-Received: by 2002:a05:6402:210d:b0:5d0:7a0b:b45f with SMTP id 4fb4d7f45d1cf-5da0c32c27bmr10251664a12.10.1737112650370;
        Fri, 17 Jan 2025 03:17:30 -0800 (PST)
Received: from [192.168.8.100] ([148.252.147.234])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5db73eb5976sm1343654a12.53.2025.01.17.03.17.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 03:17:29 -0800 (PST)
Message-ID: <a6eea6a0-f4d9-4af1-b4b0-7c5618bc0cbb@gmail.com>
Date: Fri, 17 Jan 2025 11:18:13 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 10/17] fuse: Add io-uring sqe commit and fetch support
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>,
 bernd@bsbernd.com
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
 <20250107-fuse-uring-for-6-10-rfc4-v9-10-9c786f9a7a9d@ddn.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250107-fuse-uring-for-6-10-rfc4-v9-10-9c786f9a7a9d@ddn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/7/25 00:25, Bernd Schubert wrote:
> This adds support for fuse request completion through ring SQEs
> (FUSE_URING_CMD_COMMIT_AND_FETCH handling). After committing
> the ring entry it becomes available for new fuse requests.
> Handling of requests through the ring (SQE/CQE handling)
> is complete now.
> 
> Fuse request data are copied through the mmaped ring buffer,
> there is no support for any zero copy yet.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com> # io_uring

> 
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> ---
>   fs/fuse/dev_uring.c   | 450 ++++++++++++++++++++++++++++++++++++++++++++++++++
>   fs/fuse/dev_uring_i.h |  12 ++
>   fs/fuse/fuse_i.h      |   4 +
>   3 files changed, 466 insertions(+)
> 
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index b44ba4033615e01041313c040035b6da6af0ee17..f44e66a7ea577390da87e9ac7d118a9416898c28 100644
> --- a/fs/fuse/dev_uring.c
> +++ b/fs/fuse/dev_uring.c
> @@ -26,6 +26,19 @@ bool fuse_uring_enabled(void)
...
> +
> +/*
> + * Write data to the ring buffer and send the request to userspace,
> + * userspace will read it
> + * This is comparable with classical read(/dev/fuse)
> + */
> +static int fuse_uring_send_next_to_ring(struct fuse_ring_ent *ring_ent,
> +					unsigned int issue_flags)
> +{
> +	int err = 0;
> +	struct fuse_ring_queue *queue = ring_ent->queue;
> +
> +	err = fuse_uring_prepare_send(ring_ent);
> +	if (err)
> +		goto err;
> +
> +	spin_lock(&queue->lock);
> +	ring_ent->state = FRRS_USERSPACE;
> +	list_move(&ring_ent->list, &queue->ent_in_userspace);
> +	spin_unlock(&queue->lock);
> +
> +	io_uring_cmd_done(ring_ent->cmd, 0, 0, issue_flags);
> +	ring_ent->cmd = NULL;

I haven't checked if it races with some reallocation, but
you might want to consider clearing it under the spin.

spin_lock(&queue->lock);
...
cmd = ring_ent->cmd;
ring_ent->cmd = NULL;
spin_unlock(&queue->lock);

io_uring_cmd_done(cmd);

Can be done on top if even needed.

-- 
Pavel Begunkov


