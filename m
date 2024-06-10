Return-Path: <io-uring+bounces-2146-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E85E901952
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 04:00:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D86952812E6
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 02:00:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47CB0320F;
	Mon, 10 Jun 2024 02:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MMdNRxaE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B382187F;
	Mon, 10 Jun 2024 02:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717984827; cv=none; b=npYOZPCbaMjc8W9WJhdbbfl4AsOB/5aRbFpYnlqjKQwdODH/GyP41FUk/nN061HBMhlKbE9WTNb6Ns6EOCQdGA1T8k23a61478Ro10ooOMAN1mriuD97qktmaifpvjYkt/6WHiNlDtMFKNMRyoV14ZJR1URbNENMr9iA0j80nzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717984827; c=relaxed/simple;
	bh=NsWtJ6IIDOcTEJh4yp/Cpfy1H13ngsirFiYt5W2cRRU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tHaUIkxEz9bozcYH4JQpmEHEmF+9CS22clGGJMyZwBtSU/nT8pVSAG6YGxHx1CzKgtWVnS4/we5Mm6/Q5QnnvikpkRiUDWXK6kXQvJPklryBsCu6eKOKzN7RAXGf1d8Vwy++2ALgPM+Oyl0woI8VMy/qAo4Vh0c6lF1lLAXECyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MMdNRxaE; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4217c7eb6b4so8769255e9.2;
        Sun, 09 Jun 2024 19:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717984824; x=1718589624; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zQXctGUz5rYtsVj7odcF6AauhH220AQqsqUsPqBWcSU=;
        b=MMdNRxaErGdxPpbLowyNwA/4hTUBKVrpeS7/C/DLYLsCTHrHEXE8KhgpKdEW9UUYJ7
         4mvM47p6Uc0ixuJur9fPzOdSdmr0OFopX/Yik1ygAQ/CSSPLouxsn383B14wc5X4tVTg
         WtXHz9yYUqZ675hMR6IcE2s/SUgqfm6rYHRB/e5WVY9UkyVvjxp2shD755zi0gVcMuzq
         l8sCxOLnhoI1DcdoIaN2PaJyhUQ6qPkfdHJ1dzwNUHrW2o8mThzmvM1B0nvVI0IMU5u3
         UqsTCRJgQMx6X2v8FckmJD32jdFVajwqtS54C7OlOOG0+4pTKfNIPZDtSxwMAq4r2q6e
         AM4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717984824; x=1718589624;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zQXctGUz5rYtsVj7odcF6AauhH220AQqsqUsPqBWcSU=;
        b=N2fmRappaIbl/JxlEi6gNALt+iLoDBcxvAsxAb/K6Xj9/2IQsPVIXBM//OfKV6vXBV
         tc1mfBvOpS606NeN6j95Lf81f46jDxgaEjvMxz7zAza1WNCKRISG0qKQ+T9O2uWC8ti1
         /3F+o99nRErO7+rHSiFeC7n89kyDrmRzmQay6SYGu918k0l6gKdXovOEfeoMqU2VJmj/
         /iiXsqpeRz2HhxkVvs0thV51y9aq0lJ2ExVZG0SiEW3aT276RQtI1FhgOdGzq6/yyNm0
         5Vs/EqMX3JrE9zcG/qK+ffdAxf4jCIK+0Nw/7fKEoOASk7TJgHlieBKdArtcmSNED5Wq
         fX8Q==
X-Forwarded-Encrypted: i=1; AJvYcCV5xnbIcLMf2jrhqcXjpYDcVdBq9P4DXhVeay0JYrrgpDeY2Xdq4qK8e9Y9zZRG7hYgUqg6fiiaFkuCn6mTXNvly6nwd/xu43A=
X-Gm-Message-State: AOJu0Yw7H9l5ccW/iBjYY3UFXMwjdWJW52X8pRoe32kBtRBqY3AKdM5/
	IuDfof4XyFaxIl1GAEEtDx6zpdBZGRLyAp+3f6IVOfbj1hAgJuwN
X-Google-Smtp-Source: AGHT+IHHieMiBHqQcVPEH5jPr+hSwW4+efgTrdybKidvmknJdGradZAf2QO55jk08jes5QtXNPReRA==
X-Received: by 2002:a05:600c:524e:b0:421:4754:c49a with SMTP id 5b1f17b1804b1-42164a20cd0mr82017855e9.31.1717984823518;
        Sun, 09 Jun 2024 19:00:23 -0700 (PDT)
Received: from [192.168.42.136] ([148.252.129.53])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4215c19e572sm126048235e9.10.2024.06.09.19.00.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Jun 2024 19:00:23 -0700 (PDT)
Message-ID: <ae3941f8-36a4-42fc-aaf8-027fe2de2d4d@gmail.com>
Date: Mon, 10 Jun 2024 03:00:23 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 7/9] io_uring: support providing sqe group buffer
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>
References: <20240511001214.173711-1-ming.lei@redhat.com>
 <20240511001214.173711-8-ming.lei@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240511001214.173711-8-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/11/24 01:12, Ming Lei wrote:
> SQE group with REQ_F_SQE_GROUP_DEP introduces one new mechanism to share
> resource among one group of requests, and all member requests can consume
> the resource provided by group lead efficiently in parallel.
> 
> This patch uses the added sqe group feature REQ_F_SQE_GROUP_DEP to share
> kernel buffer in sqe group:
> 
> - the group lead provides kernel buffer to member requests
> 
> - member requests use the provided buffer to do FS or network IO, or more
> operations in future
> 
> - this kernel buffer is returned back after member requests use it up
> 
> This way looks a bit similar with kernel's pipe/splice, but there are some
> important differences:
> 
> - splice is for transferring data between two FDs via pipe, and fd_out can
> only read data from pipe; this feature can borrow buffer from group lead to
> members, so member request can write data to this buffer if the provided
> buffer is allowed to write to.
> 
> - splice implements data transfer by moving pages between subsystem and
> pipe, that means page ownership is transferred, and this way is one of the
> most complicated thing of splice; this patch supports scenarios in which
> the buffer can't be transferred, and buffer is only borrowed to member
> requests, and is returned back after member requests consume the provided
> buffer, so buffer lifetime is simplified a lot. Especially the buffer is
> guaranteed to be returned back.
> 
> - splice can't run in async way basically
> 
> It can help to implement generic zero copy between device and related
> operations, such as ublk, fuse, vdpa, even network receive or whatever.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   include/linux/io_uring_types.h | 33 +++++++++++++++++++
>   io_uring/io_uring.c            | 10 +++++-
>   io_uring/io_uring.h            |  5 +++
>   io_uring/kbuf.c                | 60 ++++++++++++++++++++++++++++++++++
>   io_uring/kbuf.h                | 13 ++++++++
>   io_uring/net.c                 | 31 +++++++++++++++++-
>   io_uring/opdef.c               |  5 +++
>   io_uring/opdef.h               |  2 ++
>   io_uring/rw.c                  | 20 +++++++++++-
>   9 files changed, 176 insertions(+), 3 deletions(-)
> 
...
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 070dea9a4eda..83fd5879082e 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -79,6 +79,13 @@ struct io_sr_msg {
...
>   retry_bundle:
>   	if (io_do_buffer_select(req)) {
>   		struct buf_sel_arg arg = {
> @@ -1132,6 +1148,11 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>   		if (unlikely(ret))
>   			goto out_free;
>   		sr->buf = NULL;
> +	} else if (req->flags & REQ_F_GROUP_KBUF) {
> +		ret = io_import_group_kbuf(req, user_ptr_to_u64(sr->buf),
> +				sr->len, ITER_DEST, &kmsg->msg.msg_iter);
> +		if (unlikely(ret))
> +			goto out_free;
>   	}
>   
>   	kmsg->msg.msg_inq = -1;
> @@ -1334,6 +1355,14 @@ static int io_send_zc_import(struct io_kiocb *req, struct io_async_msghdr *kmsg)
>   		if (unlikely(ret))
>   			return ret;
>   		kmsg->msg.sg_from_iter = io_sg_from_iter;
> +	} else if (req->flags & REQ_F_GROUP_KBUF) {
> +		struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
> +
> +		ret = io_import_group_kbuf(req, user_ptr_to_u64(sr->buf),
> +				sr->len, ITER_SOURCE, &kmsg->msg.msg_iter);
> +		if (unlikely(ret))
> +			return ret;
> +		kmsg->msg.sg_from_iter = io_sg_from_iter;

Not looking here too deeply I'm pretty sure it's buggy.
The buffer can only be reused once the notification
CQE completes, and there is nothing in regards to it.

>   	} else {
>   		ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len, &kmsg->msg.msg_iter);
>   		if (unlikely(ret))


-- 
Pavel Begunkov

