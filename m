Return-Path: <io-uring+bounces-2607-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BA7D94157C
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 17:33:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB931284EB0
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 15:33:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D6CC18A92F;
	Tue, 30 Jul 2024 15:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PYW8Bdx3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9BD197A83
	for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 15:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722353586; cv=none; b=XEKSlHby3LTfUL+KuU/1LBTLfu8b+l7f77GTUpGljRpA7yq+LmGefP/Ji+vWgxRyckhmo1A8fh+t5Nuzf6+Dkk7w9LcE2U4BkexMilblrDPogOXU+wLQr55FOns7h6uJkTv3LMLMeB2NXjGbQ2FOYP6blV42Z8uFdE3KpcOzdi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722353586; c=relaxed/simple;
	bh=yN5X2yBlLNdTXhxa4sa4ShMWDCIta2PrPLC+GqmrjMI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=IpLoWpDARtQ1ey+djNgh4RWYCpkgRHKw9xiJOqoQ/Ai7pfBYaEtVImTZ02ecsW/JzBHS9SHXqCegYUC4WXnXBFf4uY35/irrABA97HMi76BZXi5PIS8C0TS/c/uXXanm3SJOUSjfJW5hBJ3PHmseTfLOgiY2TBaWLGiRIIYgPfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PYW8Bdx3; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a7abe5aa9d5so560756966b.1
        for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 08:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722353583; x=1722958383; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z979zz1/+X55gb4aDOEGQhVQ7QTef62QznEAdI0yuvI=;
        b=PYW8Bdx3cFZ7OrqVRlTsWKdT/XF2q78NP/gsHhxJYfP9BIm0jDJ0YEA/jAGVuZhHVo
         9nlUXWXm3Zf63ir0AiVJONZFfB1QJIx514CMIN7DWRUzYY6vGiDT1wKZJsSZI2FSvtCU
         1z1ZDbq0KMMX4WClL/e4REQTTEv/x23goekocJWAALv+XOugv81+MYGQEn4dRzq8NkFo
         68BVZ5GKYQSC+uQbFcj+Nsp1mi1kr5Z+fxHc2Fzxk+05arNQtcBVgoMQXyqbUM/nSk1N
         +muLruUa4mhOfr0Vd9azyabDunUEzliTN0zX1naw3+Lf4EZmNDE7rAWJfJoqx7BtHrks
         2psw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722353583; x=1722958383;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z979zz1/+X55gb4aDOEGQhVQ7QTef62QznEAdI0yuvI=;
        b=u6mDFd0Rk7nETHmKKr3+iNoONVGJ5hz/yU1+tLtrOZNeTeKbpQnmBB315iKvYw/3BX
         T5l6NCPbH2Gxmd80NjnCr8ptotWu6Bu76C3bz0q6ggkztE57DiXJ1MikDzxqo0MbCLT+
         IyVBfk3SzQ2stnWR6VYU+alslJfF/yx1vq0wiO6Hx/TcbB7I9efPBeN/ykrLg6oMONly
         rtVPT/2Zg2WopFee967lM8Ww2VsHeGEDSKwTH/946OKpTxWPNiJKkET+gBJ7smQ64FWt
         8WxDnIpsGK55UsUhexpoHqsxDY8IA8wCo+w2bDFqCiVUqflH44uWjTuzbyfesM9r2eCK
         BasA==
X-Forwarded-Encrypted: i=1; AJvYcCXpCSQhLuhJGEdYnjIXRw08KrNe7JhsLBDU0YWCHC1lCWjSyf+jAAm37CSgNa7LnBK9Z3KtyAc+jR8FM4t8Gexe3dv13nZqoac=
X-Gm-Message-State: AOJu0YzJOuyHF6KRl1TPb7DK2cIgeHkjcZTFIhiBbvsZrv1PPEfHJdaJ
	0sV1jUx+kfA7RzRNfi4czH7iqZWN8SzDmOaD860J5Cwvl9/3dy8bDuCM9w==
X-Google-Smtp-Source: AGHT+IG1FkfYJKHXhKgTk5qJFViAlyDi1zhje9IvxfMbeNptAUpmqaLTLm9t9PUF14AqZuF9oOSWCA==
X-Received: by 2002:a17:906:6a24:b0:a7a:8e0f:aaed with SMTP id a640c23a62f3a-a7d4012628fmr898952166b.50.1722353582849;
        Tue, 30 Jul 2024 08:33:02 -0700 (PDT)
Received: from [192.168.42.72] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7acad418f1sm651867066b.135.2024.07.30.08.33.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jul 2024 08:33:02 -0700 (PDT)
Message-ID: <08e5c092-a7c4-47ca-8e4b-44acb741d1f9@gmail.com>
Date: Tue, 30 Jul 2024 16:33:36 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: add napi busy settings to the fdinfo output
To: Olivier Langlois <olivier@trillion01.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
References: <bb184f8b62703ddd3e6e19eae7ab6c67b97e1e10.1722293317.git.olivier@trillion01.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <bb184f8b62703ddd3e6e19eae7ab6c67b97e1e10.1722293317.git.olivier@trillion01.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/29/24 23:38, Olivier Langlois wrote:
> this info may be useful when attempting to debug a problem
> involving a ring using the feature.

While on the topic of busy polling, there is a function
io_napi_adjust_timeout(), it ensures that we don't busy poll for longer
than the passed wait timeout.

Do you use it? I have some doubts in regards to its usefulness, and
would prefer to try get rid of it if there are no users since it's a
hustle.


> CqOverflowList:
> NAPI:	enabled
> napi_busy_poll_to:	1
> napi_prefer_busy_poll:	true
> 
> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
>   io_uring/fdinfo.c | 13 ++++++++++++-
>   1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
> index b1e0e0d85349..3ba42e136a40 100644
> --- a/io_uring/fdinfo.c
> +++ b/io_uring/fdinfo.c
> @@ -221,7 +221,18 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
>   			   cqe->user_data, cqe->res, cqe->flags);
>   
>   	}
> -
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	if (ctx->napi_enabled) {
> +		seq_puts(m, "NAPI:\tenabled\n");
> +		seq_printf(m, "napi_busy_poll_dt:\t%llu\n", ctx->napi_busy_poll_dt);
> +		if (ctx->napi_prefer_busy_poll)
> +			seq_puts(m, "napi_prefer_busy_poll:\ttrue\n");
> +		else
> +			seq_puts(m, "napi_prefer_busy_poll:\tfalse\n");
> +	} else {
> +		seq_puts(m, "NAPI:\tdisabled\n");
> +	}
> +#endif
>   	spin_unlock(&ctx->completion_lock);
>   }
>   #endif

-- 
Pavel Begunkov

