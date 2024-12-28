Return-Path: <io-uring+bounces-5618-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BF3E89FDBC3
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2024 18:38:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 74800161CD9
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2024 17:38:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A2C019258B;
	Sat, 28 Dec 2024 17:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="croDsBhj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C916418C939
	for <io-uring@vger.kernel.org>; Sat, 28 Dec 2024 17:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735407531; cv=none; b=aL3/cQ9rk/EZC9C/Yt6iOVG8ex7m6L3Ptwdyw7nqv8wYjgTkZmBcOcmbMBm2uin0zYfZhU5K5AwsJZqyjlqLRpdy6pNr5S1lbhxjw9X///SMuEydhGkRi70+wssiNDSfbhdV6FdlFTV4Qsa/9Sd0HVOMRnlydXAxGJqSJ06Q3wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735407531; c=relaxed/simple;
	bh=MQVVnah8C2VchUSSDvMldv6RC2pnoVPAlbohLBojO3k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rJAmcVFxYcZCQv/2weC6PtfC3xxrfCu/xvUtlZJL6lCoBgRmU++AK5zB1o4VrQvvbg+nGgIMqlBAqaPNo8Ra40SKzxrEdV15C5SeDpT4Z+zFJgEKjThuQ/uDWwHBo+Nfb6OUtbmLgodf3lSLJEwbQ+M4BfQEwS8ggeLkudO/cX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=croDsBhj; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-385ef8b64b3so6176647f8f.0
        for <io-uring@vger.kernel.org>; Sat, 28 Dec 2024 09:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735407528; x=1736012328; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kB5Pio977Bv12Mu5fZLZgjP86kjKUJKxxpZucTwSiIA=;
        b=croDsBhjmgIQaGdObEWG2jl/mgcs7ASN06cH36mj4quuZaUvKqE3ZfnZkoPtpO5W+g
         S51yNMr9svgSeX8CbnuoZnWGZ5F2QCw7i3JYU+Yx8ZxwPuV7FcmmSaobtJ+1aY0WfWbU
         Nsqrw0CAM/mrwd66MhdCrIMo8pHEUoQKozJF0FgPfxORwYj+KFvYNBfRFFo3jAWNflcH
         g6WWV6+pYOeAdeZ7j23RLhqRDjGRnoPeCKi5zJte0sEdXyhcfnbAFW6G9nI6OIZUdc8A
         Dfm+TCto1LFDuCqv5s1m2WMu+OI2tzwljVfidaGd5JHrSZQNlxNwvRql3iBaMLYWSDQ2
         IZDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735407528; x=1736012328;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kB5Pio977Bv12Mu5fZLZgjP86kjKUJKxxpZucTwSiIA=;
        b=TxtLeHJEdCHGpnSsrOfFH3vjoQ18Ba07gZ2sR5QjHC6MqifYbXgB54DpWspQ1lrDDt
         gcvpnORSjWsSZmscU5StAdW8EpvrxTp72D5CV5Hmub3aa27lKBvMouJ78b4ilSpqSTq9
         oSWYyLXzxQHssx4nXFMSpj4WGVoGwY9Zi9LkBz/Td7FfoJwLn0JyVFEf6bi7u54BAnwA
         +h79+IUXqr0YzcaWl7DjCdNIAXrh00gGi8bmtjL6opFGLP447oKilQqxhaAtqVboil/P
         Ut0xQWA+XL52gDx1RR8GrQZI/Hxg4vFQTnU/sL7cnGJ7yDV+gFFHYVKdVkd3bGmqGi36
         LPrg==
X-Gm-Message-State: AOJu0YyydAgmQPLcqCQA7qqimK3pv0LDN7cdROCA0ldmw+F6iaDImPpZ
	xQvn0wQv+01anhdLrPm2iSKB0sd2QWfk/VZ92zvLJrc9lP5/0JOAjMBaFQ==
X-Gm-Gg: ASbGncvl2LgfLfIgcLbkozdPnNvgBWnnyAxmTGHH798aXw5sWsWi8wfoe/ag+AVLhz0
	1Z90UC7pHGejoRYdLXGpr78nqOfOj7LS2LuMrUUDYFuE3FQLvvc3R31W9YQqLncH4A3u7p1OAwM
	q4Y6E1p8iEC7ZhgTLQF/FFUzbv+3w0k31N/J5jIPPKQcdBtKp73kg7MKlA2fzdb+NVB7HzMLhvN
	v/YJcrn6gomk8MHnAWJ6zJBk56dJaMTlx0JKjm81wu5qOvsWTMMzcpCzbfji1P2vDd0
X-Google-Smtp-Source: AGHT+IHpcWNlIeF1v2tdYdYkz4M9c+VpEeEQa3wS8Vh4gGVtPpB8MFfAdzRCeTmtKs4ClHbT/7BB/g==
X-Received: by 2002:a5d:47c3:0:b0:385:e35e:9da8 with SMTP id ffacd0b85a97d-38a221f69e0mr25951600f8f.18.1735407527612;
        Sat, 28 Dec 2024 09:38:47 -0800 (PST)
Received: from [192.168.42.236] ([148.252.146.249])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4366127c488sm301324485e9.27.2024.12.28.09.38.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Dec 2024 09:38:47 -0800 (PST)
Message-ID: <211a5047-12d9-4835-8274-919b12d0e06f@gmail.com>
Date: Sat, 28 Dec 2024 17:39:35 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/rw: fix downgraded mshot read
To: io-uring@vger.kernel.org
Cc: chase xd <sl1589472800@gmail.com>
References: <594cc3cae8b479df473ac7711ede07e85bc6e266.1735407348.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <594cc3cae8b479df473ac7711ede07e85bc6e266.1735407348.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/28/24 17:36, Pavel Begunkov wrote:
> The iowq path can downgrade a multishot request to the oneshot mode,
> however io_read_mshot() doesn't handle that and would still post
> multiple CQEs. That's not allowed, because io_req_post_cqe() requires
> stricter context requirements.
> 
> The described can only happen with pollable files that don't support
> FMODE_NOWAIT, which is an odd combination, so if even allowed it should
> be fairly rare.
> 
> Cc: stable@vger.kernel.org
> Reported-by: chase xd <sl1589472800@gmail.com>
> Fixes: bee1d5becdf5b ("io_uring: disable io-wq execution of multishot NOWAIT requests")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/rw.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index b1db4595788b..c212d57df6e5 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -1066,6 +1066,8 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
>   		io_kbuf_recycle(req, issue_flags);
>   		if (ret < 0)
>   			req_set_fail(req);
> +	} else if (req->flags & REQ_F_APOLL_MULTISHOT) {
> +		cflags = io_put_kbuf(req, ret, issue_flags);

Oops, this one is broken, misses inversion.

-- 
Pavel Begunkov


