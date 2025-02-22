Return-Path: <io-uring+bounces-6629-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B7DA8A40473
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2025 01:55:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02DB819C596F
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2025 00:56:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F47761FFE;
	Sat, 22 Feb 2025 00:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GzcjHB2W"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93FC24EB50
	for <io-uring@vger.kernel.org>; Sat, 22 Feb 2025 00:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740185751; cv=none; b=sLVNd6cMT+Usv5f6ycNextbHctfCJenenCeyTQKtSZOALQYNGlOytyW1DOisMy/4Ljoai/PoXK4lF2E2dmSwXGO40xLiGEHCQ5vuVer6DaZLG+JXyjQZKeCAX/roEFUMoE0cAudIz8jl4NXqsv6zSa6kBEcaeQIs/5CV8RL/QNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740185751; c=relaxed/simple;
	bh=LO2x/lysr/+Fds1t6pcE+AWWHLI23N+YFUJVgWO1MrI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A4W7KaQiKPcM4SiegTpTnWrvPa5A6x917/9ZxcP06wjDB04swnVgO3jOJi/ltqg0yATokTZCvAYY2Iq/2Fi8cXtgHXI6tUTrK5CFbsM1V6Nxsh2OKQEaq6V87ib0pg9vVt+psb9Wi4Zr85LK+v3tS2+vFubQxup/k7kZYoOGhDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GzcjHB2W; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-38f403edb4eso1510045f8f.3
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2025 16:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740185748; x=1740790548; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gWa/MoWZtJ4xS8/lpReEkMdDgYIr0CpjRTYGP783zl0=;
        b=GzcjHB2WDazU+Z284qrd62/zlwwHmgVtWf2tuV0vc8nD2ojqy303IN+65s+TFJUW4x
         xrkKXEITmAbuY3F3qlhOCf53JI51wAztTmH8Glm4cf7kZRGvFMt6KvZDqKKmQRIWVucs
         UiqZXdPwMGpB3B6Zwo0W2UgGDg8ODe+pR3MjixxplrMGP+aQe7GUIMu7OiT79qJtPzWj
         yQATd3g76wzVUtJleOb/zT1AxVAzQ4/ggF/ElxmIVmiu3Kk689EOsStuJ96x2zNKQDVd
         lJ3RdmR1RUpn+OcxdfFLlEi+Y/NZHX+0CfNqKXwpqFjz5SpYn84aFvPFJnhMQ4Kb/62/
         LVdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740185748; x=1740790548;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gWa/MoWZtJ4xS8/lpReEkMdDgYIr0CpjRTYGP783zl0=;
        b=BM+EBYs5mGRB2epVzap9w/NLDYcaLnNXKOANtBoI9XzMRxqbmvlCiC8kaYdQ3IPrYw
         AilWV4vnc8ZbCnD0AWnD+LLBgb4X61WC3Yld8tqaBEZHgj4MBV10SjYbQTYKUDA+eah2
         m0lG7Wkdo4ILOWWcS63onuEUnSxyrO+vyTQLuDvbaEJyhU7CZJV0XW6b2Az+wrvuTxLN
         9sKc0RwYQUhDiP71jCVK6BKmh8Z3p1VfTqUV7t9ZWxDszZzmE114497tYzaOE3VzCbRO
         t9sjiIjeNuJsI5nLAi58q0Lkl4FFEZcUGPby63JXZRGX7BkI7MiK6xHmTLkqmoYCWeSL
         ebCA==
X-Forwarded-Encrypted: i=1; AJvYcCXfQm6P+3jYM/hYIIVqT77H/HEpWtrwzRrN3Rc10jpboOGhhyEMIuYTFtLjkaFV5tuWsRFcaIUHmg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxZVJWDfn8BMa4V5lEQ3bLlIs4F9UIOBfW8jP1nHrDX6rR2k/Jr
	rxz9CCtdI3q5fo5ulT5wc5YhiFRp88Y14KKCLQsNqMX4Hh5AnZVP
X-Gm-Gg: ASbGncs8aw69RE+Eg3UidWfIC9Pvt9/sgFOSowbUgsTS/NiN9iM3FKtFrl/DOnh587G
	CDJ1BPsfLHqB9FppiHev5iXE57q+4S5IggT4PJG0wi6YJ8+zRpoUQDqq4lzBl++u6hYcEiwVPfJ
	cVLQuW0z8fhamg7D6AC3/3gEYlNELpriwYiqoi52jgmmmW4fIdug+EQcOWys66kZ8/2fORzVZaD
	yM6R+gG1LTD3+Lr52Z9tGn7uoKxE34UApFEoN/deCimb4Ai0/dUwaFIhgOfZHhkF9Ys7HY8Gy0q
	/y4lpwwL2uYkxNDfOGs92fcx+XlkvhcdUoo5
X-Google-Smtp-Source: AGHT+IFPkA16Ytjx0mLgICM2pi7KiE3Q9Lcuezilfn9mbYmEHWhJ8Rp4ShuBGQJOsmgMdU8+j8nYxw==
X-Received: by 2002:a5d:5f43:0:b0:38f:3224:65ff with SMTP id ffacd0b85a97d-38f6e7563e8mr4566471f8f.5.1740185747658;
        Fri, 21 Feb 2025 16:55:47 -0800 (PST)
Received: from [192.168.8.100] ([148.252.141.194])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258dcc50sm25210832f8f.34.2025.02.21.16.55.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 16:55:46 -0800 (PST)
Message-ID: <92bc1fca-ea5e-42eb-bdb3-c53854193ce7@gmail.com>
Date: Sat, 22 Feb 2025 00:56:51 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] io_uring/zcrx: add single shot recvzc
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20250221205146.1210952-1-dw@davidwei.uk>
 <20250221205146.1210952-2-dw@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250221205146.1210952-2-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/21/25 20:51, David Wei wrote:
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index f2d326e18e67..74bca4e471bc 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
...
>   static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>   				struct sock *sk, int flags,
> -				unsigned issue_flags)
> +				unsigned issue_flags, unsigned int *outlen)
>   {
> +	unsigned int len = *outlen;
> +	bool limit = len != UINT_MAX;
>   	struct io_zcrx_args args = {
>   		.req = req,
>   		.ifq = ifq,
>   		.sock = sk->sk_socket,
>   	};
>   	read_descriptor_t rd_desc = {
> -		.count = 1,
> +		.count = len,
>   		.arg.data = &args,
>   	};
>   	int ret;
>   
>   	lock_sock(sk);
>   	ret = tcp_read_sock(sk, &rd_desc, io_zcrx_recv_skb);
> +	if (limit && ret)
> +		*outlen = len - ret;

ret can be negative, the check will pass and the calculations
will turn it into something weird.

-- 
Pavel Begunkov


