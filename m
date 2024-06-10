Return-Path: <io-uring+bounces-2144-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0848890193A
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 03:23:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB3C52817E2
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 01:23:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31973A38;
	Mon, 10 Jun 2024 01:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ejcrVlEW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDE780C;
	Mon, 10 Jun 2024 01:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717982634; cv=none; b=quNaJtOaXTf2vm/88+n9fgChqk1l7AthQhYgNCjaRGLwadIbuiNNND0bZqCVgX4NcuCXmVCWbqut8yaMaJXEwlY2wmKSD50HZv3o6PKpMbBToLYfXpebSHVzMckIq7w60z0yxk6CRxzZPWq5s+LmeGwR9tXVHKftAHeK+uJbgLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717982634; c=relaxed/simple;
	bh=zYy6uVQstwH74Q+Df7UsoGQSUmybj1iqE/Bhf0ddZEI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qvz9q7CFbfoJZRhisv+yGglQjWNr6aIJxY90MfkZfkwYbRTQeC/JfXk2xSVXESAAOWNWc9ylEkuFRn7zFQJcbuGx3O29hLSbcSlV6TM4ZdMfZF5AD8CTa6VrEYgbdzuBqH1MReRRWUScDH9inuPdIiS/fS8lq4WZu8v8fYKl11A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ejcrVlEW; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-42172ed3597so13088645e9.0;
        Sun, 09 Jun 2024 18:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717982631; x=1718587431; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yuxUvYhO65eTt6eO5Lba8apkXWYQbQeNsTXdcu/SAPI=;
        b=ejcrVlEW/JqnSEyxqmG8OTPGhbshhUdHepscqEGFfrwQmqIJJor8X0QMQPgZ7/7FnB
         FOQdNZAY0Y83V/hEAEKxsKiqmR6YuDSuSxxPscdpuwSehAw1M9FVCh32F//S+/FiXZUS
         CNdSrUK1u+W2bf9zJ0RL27xNW5GnYqUD2Br3z49m6ODxi8J49c6FzCM/lMysFjfV2URw
         TrDELoJlf+f7oVog1DLyo0Q/OPps7LemF13gzpu3z+N0OznZPnYkta7Sn6hUNqv35CFI
         v4vU+htrKNtwfGmKxrEo4vz17/bog5/H9OrGNW57OYcS1fz1YYwwmbjsAyP/fHPZEq3z
         JTeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717982631; x=1718587431;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yuxUvYhO65eTt6eO5Lba8apkXWYQbQeNsTXdcu/SAPI=;
        b=C19JfjIQh914T65sqO5KuMBRPnQnZRsn2+cwSI+kEeGvB37Aktk8NeJ7MOSAjcNCzS
         jlgki4HOGCJY3wqwcn0Rejbg/kh+XvpuZsJYDLjXx5nRNo5ZmCTS/RVcVQUXS7RV0+Xd
         RYV3V1WIowq2+JLNfB5YXVO1rPbmy9ZB+o8773nkw0GLR2sx+qxIlhHDuSXo/z2x6Tqr
         3WSCfpKtZyeQorc5jIUp1doIzmdArs62MIPoMoI/EdHEae0uk2cGaPLLVz+tlwCEAqni
         r7MIQUeu7r0oJtWuSU/wkCKmtm6LJN4r3RVzp2MoPOp4ebtCsyhP3Nq8foZaHhP5x168
         G/cg==
X-Forwarded-Encrypted: i=1; AJvYcCVIL8/spl2uvZ92LYboXImDL1QPaIMXYnfZmRcQPHNTccw62SsZcq/vWu6o8pFKrQbEjWJnZ4FbOR08iaTz2QywANda5N4U0Hs=
X-Gm-Message-State: AOJu0YwOyN7e+5LrJE1rsRl9QR/+xp4rTvT4+8ng/mr+P5AaTy0wp7pP
	IfTBIm68gWCIjw3m2ng/DK2XG0tfCWvTY1MRogn3uBqNjqTs5Up6
X-Google-Smtp-Source: AGHT+IEue2kER8YKOg0dnUNbSQUT0L0BAFZNmT8cchgdyXAC/W0S25wajiFSgYbXuSeEW3Gvc/8KVg==
X-Received: by 2002:a05:600c:1c99:b0:421:81eb:7d5c with SMTP id 5b1f17b1804b1-42181eb7f7bmr21853365e9.18.1717982630625;
        Sun, 09 Jun 2024 18:23:50 -0700 (PDT)
Received: from [192.168.42.136] ([148.252.129.53])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4215c2c6bedsm124953495e9.30.2024.06.09.18.23.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Jun 2024 18:23:50 -0700 (PDT)
Message-ID: <f7b3164a-b9a5-4c61-84c9-ff5b18e2e92a@gmail.com>
Date: Mon, 10 Jun 2024 02:23:50 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 4/9] io_uring: move marking REQ_F_CQE_SKIP out of
 io_free_req()
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>
References: <20240511001214.173711-1-ming.lei@redhat.com>
 <20240511001214.173711-5-ming.lei@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240511001214.173711-5-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/11/24 01:12, Ming Lei wrote:
> Prepare for supporting sqe group, which requires to post group leader's
> CQE after all members' CQEs are posted. For group leader request, we can't
> do that in io_req_complete_post, and REQ_F_CQE_SKIP can't be set in
> io_free_req().

Can you elaborate what exactly we can't do and why?

> So move marking REQ_F_CQE_SKIP out of io_free_req().

That makes io_free_req() a very confusing function, it tells
that it just frees the request but in reality can post a
CQE. If you really need it, just add a new function.

  
> No functional change.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   io_uring/io_uring.c | 5 +++--
>   io_uring/timeout.c  | 3 +++
>   2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index e4be930e0f1e..c184c9a312df 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1027,8 +1027,6 @@ __cold void io_free_req(struct io_kiocb *req)
>   {
>   	/* refs were already put, restore them for io_req_task_complete() */
>   	req->flags &= ~REQ_F_REFCOUNT;
> -	/* we only want to free it, don't post CQEs */
> -	req->flags |= REQ_F_CQE_SKIP;
>   	req->io_task_work.func = io_req_task_complete;
>   	io_req_task_work_add(req);
>   }
> @@ -1797,6 +1795,9 @@ struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
>   	if (req_ref_put_and_test(req)) {
>   		if (req->flags & IO_REQ_LINK_FLAGS)
>   			nxt = io_req_find_next(req);
> +
> +		/* we have posted CQEs in io_req_complete_post() */
> +		req->flags |= REQ_F_CQE_SKIP;
>   		io_free_req(req);
>   	}
>   	return nxt ? &nxt->work : NULL;
> diff --git a/io_uring/timeout.c b/io_uring/timeout.c
> index 1c9bf07499b1..202f540aa314 100644
> --- a/io_uring/timeout.c
> +++ b/io_uring/timeout.c
> @@ -47,6 +47,9 @@ static inline void io_put_req(struct io_kiocb *req)
>   {
>   	if (req_ref_put_and_test(req)) {
>   		io_queue_next(req);
> +
> +		/* we only want to free it, don't post CQEs */
> +		req->flags |= REQ_F_CQE_SKIP;
>   		io_free_req(req);
>   	}
>   }

-- 
Pavel Begunkov

