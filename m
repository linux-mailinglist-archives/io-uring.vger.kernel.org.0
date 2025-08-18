Return-Path: <io-uring+bounces-9039-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CB43B2A900
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 16:14:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B05B66E33FB
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 14:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33954321F51;
	Mon, 18 Aug 2025 13:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HI9FsVDI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8061D321F43;
	Mon, 18 Aug 2025 13:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525518; cv=none; b=KoiHaehZ01XX+lOHQFPyJaMGqfunITrs+xeEaEUwXzGyj8A7c01znI81+PXTHMAVUXLKwFZy7ni+VbOh6O0+c0YVJDTNAJ0hbopzeTs3W/V9anb9vWQYrzNM4GJO4QPiQAlS756UreCXllO3GgbsqPF0+fJUs86UgoaiT9we6hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525518; c=relaxed/simple;
	bh=udImFYEyvcy0P5Lzw36Tuio32ZiyjGbkEpFXoChFLk0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hYP3e5hWroFTYnen0WSA2nZcWingLkLbaEyQKHoKH3qkvV4Zkek+Amv1dQjqviZLU10rmYZdkMvwweVo4trpp9OS8BHDY0CZ/92AxO9WyXd4OenI4jK7p0RA1bpK2j/PXm/cpgl9FHhPRzeDGy+L5DqrpDHGG6Qnc7Lm0RbKqpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HI9FsVDI; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45a1b0bd237so33184155e9.2;
        Mon, 18 Aug 2025 06:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755525515; x=1756130315; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4J2qOoplxm5/COGTn/SHR0+UbFimv4xPGKDMv/3jRlg=;
        b=HI9FsVDIdABVPxgdQ9izfZn6O8uF9O5/MgoJyGpMIFE69h4uIJI5kNS8C1SW28PgKQ
         4UqzUsp3Zu6JiJ8O/AKyuO3+fPhD4DkV94szlcJut5I4Wnl9tMyv/q9mw7hupZ/FDFwy
         080gGBMEsKPWDbclkCltlD/kppkYG0myInL4nYL4fZxPCkHBMqOrVhNdR9Chd3iO7/fu
         wcQKv9dH+/0xT7RPlSe3Qp0ERS/vK1sMBjO6mRScK9fAwCycP5ZmPfFfWKl0D80PdCps
         bKsCLLIHUTTLe5AFe1itCQ1at2OSG7Lqyoo16RclBp+TMjARhxjvbdIpyDhnD6S6kXK9
         ZGpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755525515; x=1756130315;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4J2qOoplxm5/COGTn/SHR0+UbFimv4xPGKDMv/3jRlg=;
        b=ncWxNTRn0Yq4R7r0+za8/OT22IKpyoWH5zrZAedMSecQwUv+FhQmftVN14wLCqx8A0
         JmMurDHOReio7sjY5mF03fgin/YMMKKFdR6VZatOhIhJS20nVl0WT1VcjspqfwCAy+M1
         zqqxlUPG715YxSbVzPtyCTFlMhrEQtvBPkQBSCNMVVB/k0WEfXJKSRfR9P9dnwBto+Sh
         BSXiQAW0QMAeGPbxk17XhuKoetz3B7/YAixNB+WGy7fNeu4wFCbwRCsLmXe9ZFlHhWWN
         R5miNfDEYfKwPGoKJFn78f+87Vg0r2j+nlRI5c1C0smgn32GPHD5SIQq5HDM1sC3k+Ln
         9lXA==
X-Forwarded-Encrypted: i=1; AJvYcCU0ba5zX5ZFCabBrcZQlxDGzHyFDkBPJEqMAS/9CeAJeSz0tjEZxiJTPHKmFzK+0k0gb+xYMtUVWg==@vger.kernel.org, AJvYcCW1qwTlMZnDMKFemOrq2o0RrVDh4eUndYGWtehzj5MB1jrDTWIzMoM4cYk07oG4QjtTkJHhY6CI@vger.kernel.org, AJvYcCXccQoXEs7t3/WjZSWEwyMb7ih207OooioFLxVFlm3U6K629OxnECNGzvlEMqqVb8AczPX5COrztJmad9QN@vger.kernel.org
X-Gm-Message-State: AOJu0YwN9yDMAGx6UzCsj+6TmUFXHVSs9jxdzTqFwumHc4uVDxi1bde8
	5VpOorDYjTIdGk0i7Z2LKnfFmyjrymqP4QnLJLjvc036w/cvi2mpC/ek
X-Gm-Gg: ASbGncvBgsodfe7g4Kh9uN8QjYJGzo/h6WqBt9ezxPvI5bXP1vwqzkhkZhxTbmt1Hr2
	ft7bRWRqy8RdhqbcPjoLu8zEXjjXJjfx0qyVGtTaZotBZDOJ/+RcI18nUNKeMJeqMv6cFCShA6U
	d1KAkXJ8pMLDs+FgW4co8W7FBYD3GYP6eNF4eJEWpKRlxKmN0Z18JA4uCnIOjn5UGNSnOvx0Q7v
	sbHOgW3QItQQ0gw/Mcnsi3+Ts62FLoCVJHB/IR3POtXo57wGH6+TP7YTG9ARKBSsE8pdcwJ3TD+
	RSGmvV+Wj3oECfOm2gPXt/9mS79GeC0wuS0YsJJGjBFlCOIaUyFWRrjV08gd0LRBDkTaJif4QlA
	lF9RRDXg8OSztt3bDAxuXTgLiD1rcdg==
X-Google-Smtp-Source: AGHT+IF2nSSJ1vpyZ8Q4Drk6IzqIjIiKmjZ/df6jowsqi46vTHnishqb15aL/CEwNQNCubGU2CO5Ow==
X-Received: by 2002:a5d:5f89:0:b0:3b7:78c8:9392 with SMTP id ffacd0b85a97d-3bb67007abbmr9891260f8f.19.1755525514523;
        Mon, 18 Aug 2025 06:58:34 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b42a983f7sm1150745e9.24.2025.08.18.06.58.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 06:58:33 -0700 (PDT)
Message-ID: <9b55ae03-01b3-4a49-8eb7-b1f24e9e1ce0@gmail.com>
Date: Mon, 18 Aug 2025 14:59:46 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 00/23][pull request] Queue configs and large
 buffer providers
To: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>, Willem de Bruijn
 <willemb@google.com>, Paolo Abeni <pabeni@redhat.com>,
 andrew+netdev@lunn.ch, horms@kernel.org, davem@davemloft.net,
 sdf@fomichev.me, almasrymina@google.com, dw@davidwei.uk,
 michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <cover.1755499375.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1755499375.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/18/25 14:57, Pavel Begunkov wrote:
> Pull request with netdev only patches that add support for per queue
> configuration and large rx buffers for memory providers. The zcrx
> patch using it is separately and can be found at [2].

I'm sending it out as a v6.17-rc2 based pull request since I'll also
need it in another tree for zcrx. The patch number is over the limit,
however most of them are just taken from Jakub's series, and it'll
likely be esier this way for cross tree work. Please let me know if
that's acceptable or whether I need to somehow split or trim it
down.

-- 
Pavel Begunkov


