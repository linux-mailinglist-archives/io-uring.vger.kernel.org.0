Return-Path: <io-uring+bounces-7352-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 36A62A78284
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 20:57:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 882B67A3D96
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 18:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57E98214229;
	Tue,  1 Apr 2025 18:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="K8dGx/1s"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACA61494DB
	for <io-uring@vger.kernel.org>; Tue,  1 Apr 2025 18:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743533814; cv=none; b=j6YCtYFmTwu0qvbWrlsn6tp7nK4KDHr64vs9LSYWsDmWJkaTFfttTDz0R8oFeepaJxbE3qKcKUyYy+hEI7nscbI/fiNzl3QytWOZIYt5tUrtGnK/Uz7xZ/6ZYdIAZaz5jlLIGEAArXAyUo0v6NyCeu/IME3q3Sp1vCMsWI4C8vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743533814; c=relaxed/simple;
	bh=RoaJybxyLFOLBM6HcrsBcW4rhShOwoGnMEM8QSpO9nU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ajBiIzCeKp48qta8LstdbQ1D5ICTzzkiHenv7yq3cEsPaRTzcE9hXR+aRBlhXsjpzxXoTzS1dy+OK4XxcOGMiTKjhPj1yGaitXw1I26xMmXN1oAoK/0gWSrMOX5t2Ov2sdda5uX69ScjVIsh14HBBHB8nuBZihQ53tEwPZZBBCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=K8dGx/1s; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-85b41281b50so137330739f.3
        for <io-uring@vger.kernel.org>; Tue, 01 Apr 2025 11:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743533806; x=1744138606; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wVp+1zQWSWSeViOEZWnId9JxXtPxj3fqRxGTyxbFe3w=;
        b=K8dGx/1sI6U16fIywX9Yu/zdFKW0gn+uGcLJjO4wC1oWE5j0nN7Lg0O3bW6dT1RTLW
         N6PZK407SPsh/fSCcoa9TiKc3ELykP9mlzxTWrspJMQvrF0e9gFpl9oEhO3k/IuKbf/H
         sbZcWYUbkuH9qjUMRu8j5elzqLFegBdIYtCZ/w28ivWa5lXQS20H+gtNApKassSIUG4+
         902Y/IuI/WZAmV7HACInO4pINv7dztaVlo06MahozR97b4joDmsEUXTeBborSG9H8I2w
         RPwNDT/LR3XIMUo8WfwT3eNWcFy8O5RquW5LlP88QwVMydBaR+Z4MHCwIoQkpUsVIvEZ
         PtnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743533806; x=1744138606;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wVp+1zQWSWSeViOEZWnId9JxXtPxj3fqRxGTyxbFe3w=;
        b=E2QLk45ArHjrkHpvWi05LE16Pi/2QyZcdPF50BdsQ7p4QI+IqKF0PtJL1U2lJ0JK5/
         xQdrrC72gnXXwsKjb4H5u5TmELNHHS1njjMOQ4hxrleb4v5mJYiQzowPmrqS4w8ol+z+
         D+k1lS6HFCVhoIzQza/uy5fmxIkqw6/FlDqbaFuM54wx4N/fy5osZsvzot7E3KNO2Loi
         JlSRf0crHXPsrF/pK+wXnusWfgM4VDqqPg5IOuwRDVkrjXTkJw0WcT+NkRjKsBE2R9pq
         knVTVdJuF+47UUMRtfOHZc43bgoWgOimmg5gUB2/bg+VwdrzB3VS184UIVegW656FlhA
         CqIw==
X-Forwarded-Encrypted: i=1; AJvYcCX4lCn3wxGmPhePwORXcm+NslmF3dwpBfHjMdi9RuYydoL4xiz1ijSab5K3X+k7OMCz0Eu0WckBEg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwiZ9LTnFz3h/p5vkBP6oUc5qQpUWOlyiN//AVGwvot1YlhBdte
	RlRUyFgtW5gqiDzYo+jsoNKtOHuBgqZPZcYRB+W8uVQRXcJGj4KT7+le+VTU4fM=
X-Gm-Gg: ASbGnctFuDCETvm2ipsOmwVpU+1yNGvVzvEEsDY1tqlQxLLSNB6HszbgcM6GZWbGn1j
	Yhsy/IV2RI/w9R+lZ1ensFvhx3Rq7pj3WZk7/OlleeHdAMuGdbeGXD5QqM1oBB3tv60PcY6GXaT
	7Wl8Q467VE5DdcBpHNN0FAdusCd17tMdC02g/cWzvj4IiSN1ok5h/HbxCxUT6AkeeGrOOgnxfoF
	rdo0XTlZ6B/phFaJcsap5aE2uhZQ5l7PTLCHRbqnL7Mh2uAJIWIpgod47vU5LrnU1zoMqxTdJqd
	NIXEWZCJMMM4fpb5jk2Ym6BK4NHfsB4aVPKu8EEivw==
X-Google-Smtp-Source: AGHT+IHLp7TFytDqNIE0CLLXGDNQT/XSQG0yKHbLy4q3YeGwqIYKEP9V3KbWMydTTIfRSCviUWn9zg==
X-Received: by 2002:a05:6602:2770:b0:85b:41cc:f709 with SMTP id ca18e2360f4ac-85e9e94fa3dmr1645585739f.14.1743533806176;
        Tue, 01 Apr 2025 11:56:46 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f46489eabbsm2523266173.120.2025.04.01.11.56.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Apr 2025 11:56:45 -0700 (PDT)
Message-ID: <e89aef50-7364-4ab9-9582-aef6aec8cffb@kernel.dk>
Date: Tue, 1 Apr 2025 12:56:44 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/zcrx: return early from io_zcrx_recv_skb if
 readlen is 0
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20250401182813.1115909-1-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250401182813.1115909-1-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/1/25 12:28 PM, David Wei wrote:
> When readlen is set for a recvzc request, tcp_read_sock() will call
> io_zcrx_recv_skb() one final time with len == desc->count == 0. This is
> caused by the !desc->count check happening too late. The offset + 1 !=
> skb->len happens earlier and causes the while loop to continue.
> 
> Fix this in io_zcrx_recv_skb() instead of tcp_read_sock(). Return early
> if len is 0 i.e. the read is done.

Needs a Fixes tag, which looks like it should be:

Fixes: 6699ec9a23f8 ("io_uring/zcrx: add a read limit to recvzc requests")

?

> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>  io_uring/zcrx.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index 9c95b5b6ec4e..d1dd25e7cf4a 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -818,6 +818,8 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
>  	int ret = 0;
>  
>  	len = min_t(size_t, len, desc->count);
> +	if (!len)
> +		goto out;

just return 0 here? Jumping to out would make more sense if there
are things to fixup/account at this point, but it's just going
to find offset == start_off and return 'ret', which is 0 anyway.

-- 
Jens Axboe

