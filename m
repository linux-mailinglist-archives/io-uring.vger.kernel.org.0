Return-Path: <io-uring+bounces-5854-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A371BA10C20
	for <lists+io-uring@lfdr.de>; Tue, 14 Jan 2025 17:21:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48A39164D7A
	for <lists+io-uring@lfdr.de>; Tue, 14 Jan 2025 16:21:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 227B8189B8F;
	Tue, 14 Jan 2025 16:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YRgYytgB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F811CAA7F
	for <io-uring@vger.kernel.org>; Tue, 14 Jan 2025 16:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736871698; cv=none; b=QeWe3nyXYbAc+rE07Z+UDgg8Y7zp8jabCQXmYFGxeWj/vv3b+tGa11EmdG9D7pLbVD/QHasp72OSHffNq3i5Gdj00opVy+RWxWXFwVNHBw3Mtv6dvFqqbV/wT3Pm0Xq997AEGuDK8ki/rcs6YJR7vFfRRQy+FooHOGfCj0aGrV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736871698; c=relaxed/simple;
	bh=HUkOq1DcysSOQKkah/8o4O6cgApow6VcXpSHYdJVe1Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hgc4wij611XEohKsk1P0KmKgcjX/f4jDTUSmG6kf4A7duUfqMrVCMJAc+I0PXvkKD/29Aq3n+9JwrazOMITrHmC0TpTHskYApb6Jk9zbiBpOKCi+vkE0AXNfNKiYD7BAzkniN3Ww8E/Uarq9p3XKdlg0cwGUdRZHWbKpK8h4adg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YRgYytgB; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5d3dce16a3dso3514940a12.1
        for <io-uring@vger.kernel.org>; Tue, 14 Jan 2025 08:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736871694; x=1737476494; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EZVKtQ2Ngf+cig7SnFtTFa4m0VruxR79qB9y9EOYwIM=;
        b=YRgYytgBcv75CYCon0etrLgUkBHP8yNLCpZYVdNeT90wpqyxl+Xe8WUo18CDN2M3gM
         eclWAsunQHp5bvPiUd8Zexi789QBjq4ckckHiNhdbnOiwCUM/lXkWbjk2GijIwikd4Gt
         aFVU59QOsnOWQZiRAxIEBdH2H3jMPpowqYGQZK5t7XnRh/okx7sjA0zyjoUPM61QOKjP
         oKOcHm7NZCsxaeS8dUhddWrfwQQAeXCYlORlMl/A+cO0dqmC1n1sZciQevr9MRzOlIGo
         DoYtJXvGC/gy1mSqBdNm7M6y6OF8YnxpaPubsT1iVD4ndzYwp5DH+bALxslj3IaJK4L3
         6j5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736871694; x=1737476494;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EZVKtQ2Ngf+cig7SnFtTFa4m0VruxR79qB9y9EOYwIM=;
        b=B5xmd1PvJYj/eLFG/bNt2UeDV71VH845NDaBVI6euua3uIImfMn8U6UaBir9losYk1
         fCAfA6MnvfPtq8vf5pQjF4GPMxDRHy5o/cGIC+eUUqPPiZgcFUeO6Or0jCNild81WVbU
         UrhCW7GVu6dSZvd30F/gRfxd8n/NOdWWtN2gh4hBDwX5qT2O3WxzGQRStYSpzyc54zOF
         tF5I2G9ApERz1vSt3YAUMUww3sxZfeTp0AwNI1Lphpf0BVRmmYed0sUOijA47+cqgcGX
         BgQfzgkBsVQ/a6ZQfYdFGhiThgxPvlMmynX5qwaEk2lCpOPalJHEN3pF2yxXjUF5j9tA
         1mVw==
X-Gm-Message-State: AOJu0YyFFybg0s9jpm0iVP9zx2VpVpQHon8ajCzp6H8JVQDmqZg85VO4
	0XjaWqYl+u833cWg3D12t8gXe6AGAfkc032d7wSd4UhQ99DP4n8d
X-Gm-Gg: ASbGncs9ylAKGcYMp3cA1THQrOGc1ZV9yvVRt3gWF+BmsmykCd/3jJA57zv/P6jXPyc
	LvwlmhPCYm09z3yfvKgnAEDQZc7H+62ClFArbDTC3pv/ryq5cwa6ptLzw4xhapZPLj232nV7qXT
	H+jr8g6IP/5RjQ1Jr8jwzb71nvuLx+ggVTbZNt7oQ8y7CMyJfbZQomnNAZdhk46QuDohKXHSCgm
	e67GSPKTxgmRrbK2+ryJHKZks+Gc3DXBA8cbhC5f8pPtNoYo82hB970bBZBq4Qz3g==
X-Google-Smtp-Source: AGHT+IHwE+2/CuOt97Zj9GH+2iNv/Q+k85zoMT6h1zfQWmEdGHzQpx9IIcs8pGTBjQjsGO4mvifuAw==
X-Received: by 2002:a05:6402:3483:b0:5d0:d06b:cdc4 with SMTP id 4fb4d7f45d1cf-5d98a50fa60mr18040484a12.15.1736871694037;
        Tue, 14 Jan 2025 08:21:34 -0800 (PST)
Received: from [192.168.8.100] ([148.252.147.29])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d99008c423sm6443445a12.4.2025.01.14.08.21.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 08:21:33 -0800 (PST)
Message-ID: <0993bb5e-debd-4513-9481-a7d93f8c3c25@gmail.com>
Date: Tue, 14 Jan 2025 16:22:22 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/io-wq: Fix a small time window for reading
 work->flags
To: lizetao <lizetao1@huawei.com>, Jens Axboe <axboe@kernel.dk>
Cc: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <5fd306d40ebb4da0a657da9a9be5cec1@huawei.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <5fd306d40ebb4da0a657da9a9be5cec1@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/14/25 02:06, lizetao wrote:
> There is a small time window that is modified by other tasks after
> reading work->flags. It is changed to read before use, which is more

Can you elaborate on what races with what? I don't immediately
see any race here.

> in line with the semantics of atoms.
> Fixes: 3474d1b93f89 ("io_uring/io-wq: make io_wq_work flags atomic")
> Signed-off-by: Li Zetao <lizetao1@huawei.com>
> ---
>   io_uring/io-wq.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
> index a38f36b68060..75096e77b1fe 100644
> --- a/io_uring/io-wq.c
> +++ b/io_uring/io-wq.c
> @@ -932,7 +932,6 @@ static bool io_wq_work_match_item(struct io_wq_work *work, void *data)
>   void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
>   {
>   	struct io_wq_acct *acct = io_work_get_acct(wq, work);
> -	unsigned int work_flags = atomic_read(&work->flags);
>   	struct io_cb_cancel_data match = {
>   		.fn		= io_wq_work_match_item,
>   		.data		= work,
> @@ -945,7 +944,7 @@ void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
>   	 * been marked as one that should not get executed, cancel it here.
>   	 */
>   	if (test_bit(IO_WQ_BIT_EXIT, &wq->state) ||
> -	    (work_flags & IO_WQ_WORK_CANCEL)) {
> +	    (atomic_read(&work->flags) & IO_WQ_WORK_CANCEL)) {
>   		io_run_cancel(work, wq);
>   		return;
>   	}
> @@ -959,7 +958,7 @@ void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
>   	do_create = !io_wq_activate_free_worker(wq, acct);
>   	rcu_read_unlock();
>   
> -	if (do_create && ((work_flags & IO_WQ_WORK_CONCURRENT) ||
> +	if (do_create && ((atomic_read(&work->flags) & IO_WQ_WORK_CONCURRENT) ||
>   	    !atomic_read(&acct->nr_running))) {
>   		bool did_create;
>   

-- 
Pavel Begunkov


