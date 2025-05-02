Return-Path: <io-uring+bounces-7810-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 887ECAA6CE3
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 10:49:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 576D41BA10C6
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 08:49:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CF5B22A819;
	Fri,  2 May 2025 08:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A98IylqC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66A31FCFE2;
	Fri,  2 May 2025 08:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746175755; cv=none; b=sPbKfgc0/RtzbSAJKWy4X95QCDKu1U9ABsI/JBIouS/u9uhwocJB+q3eNbXPXEuSy0gEoZGeBI5ZF5WNWdPYPFRwkl5GSieYbZvg/q/ByzEaVBE1MseDyhNnEPRhoGzTJ8AvClQl3QnTsfxMH81YRJOm9GUreGG2aqQm5k95GPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746175755; c=relaxed/simple;
	bh=Sc0kKtLVhzxsFBLnXRrtQDKelHx1RU6Bl7SXit2X3Rs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uQ9tE8e1JVP2yF7eW8/+rvcDQl13oU+u219jmqumdPqP+YLbZtvTmqtCDY/tWaESnipTzZywmivopfmzkezDVAZW8grOEN7b5r5YgDhoHeTSQQrXAkQQT0UAVCjwifMjvNi7xrPyGY20ZKRBk/jSs6nN6QdNUHkGQWA1yyh9R/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A98IylqC; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-acb615228a4so536378966b.0;
        Fri, 02 May 2025 01:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746175752; x=1746780552; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uB7k2sMKFXWKwkMljfzsMqgRuKAdD5+ATWJpVBXl8Qs=;
        b=A98IylqCV/IP4dZrk7zJLRdZKMfq71dz5ODFCa/Z2W1KTY0KrSq3brl4eynU2jlJzg
         oN7aA5mAyK/GiZChOHaR9Ot9osfsfCpNAtLKjCY2V7onO4gyRy5ydr7qRftNyIkqAEyt
         Wzn3pobJplWK5t7TN1lLBN/+tqreS6Ca5gECLdu2+AVA8Nr42a4TiVx2Uo2GiMx/IfAx
         LvDJcKSXoYriadix1iTewgiJqimVzfc3KZmH7nGaKchF5LalxUGDJ428hN2S9h2ob4f4
         TYM/mY9TNCyz6dfSusGqyxpH/HUxs4Edh+HqbnTCe8snOWvg3Lq1Jvz7T7q0uXTr81C5
         dE3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746175752; x=1746780552;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uB7k2sMKFXWKwkMljfzsMqgRuKAdD5+ATWJpVBXl8Qs=;
        b=SLC6lf4eL0bdhObXiZyvRjoW//hMhQKmfLQ0fmSCwH2lQjrdJJdCG2IwigYr9wETgt
         b01nk0obX+WShUKYRAsKQKSw64DiEC3ZxxNUpshwOvD+sgXYSUi2wF9p/NgwQ7vf4rXL
         bQP1ABci2wsSAUx9IMJj8wRHOrwqPOf2J8BBBfIp5zFgOm7t4KyL9twyuvEOgJ2pTgeI
         ZSdxf7YEJcs8Fzn00Lx40bsd4u5n9pxY67AFfaIWlNIUyaljZy5j/B84lzzoQuQDOfSW
         gqX15O5IbK9MYJpsLDyNViGMUNAnJ0M61b20B6FcGvNAelmZUt7eHt2v+apeoNwGjJKf
         a6Tg==
X-Forwarded-Encrypted: i=1; AJvYcCW2Lvh3RQjTk8WPuyM4/R2pf9XULlRMuZ8eEYIoO1J2yXmsMF/HOZ+7iWqCE+YhCowqbQZ1CYt2cg==@vger.kernel.org, AJvYcCWXdK2ZwUdgWjCko1g56rcFSaSRc7Ja2h0mKXNzqzjTKLQQxc4eVPf8w363pSZMiH358dc9cHdA2W+7m9vU@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/iJDumaHOKLAodcrpWZqhzI8Hc5gPzSbzBeko9JBkOOhS2B6U
	ADTUl6E5afkAtDE2/M0kOe9fcSlpLr6QRAMyr8fSRDo1V3b3MOCQ
X-Gm-Gg: ASbGncvQ/xYaN0Pz2V1gYn3q7q0/e7X+z593lep2i3lHTiLkJlJGzAMF3076EMaPGDy
	iX11uRhcbF2B8jzm1a+zLDo2E3gmzd6K1q/zcKIhx1JePwz0KeLpsqi/x2zC3DbeQjKd+GtFH1r
	MYWn8KTnRxMqoSNz5b8AWXddD4XsiRStyOawdnA79hx3HYvLnyRZ+yFLCw3EQO9P9vXfJ4HJSHt
	B/bUSpbkl/PUz3Iy47/LaTD+419uCXzOJDms0jvnNFXu45vpTCoTN8xblMTdUxkMROcPtA6ZFuY
	7pHV66ZudGENSrd6beXvEtr8Gy5DhNnFGPd1gM4MrRPZzNdEMVxPCQ==
X-Google-Smtp-Source: AGHT+IEFeB52irtgk+4uPAFrjyWyOmGPusvb+AQOm3hwAQ3CgBJ+5rseSOcIlViJkbRqxH/lPpmJ+g==
X-Received: by 2002:a17:907:6e87:b0:ace:4ed9:a8c3 with SMTP id a640c23a62f3a-ad17ad876e4mr192517266b.7.1746175751592;
        Fri, 02 May 2025 01:49:11 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::1fc? ([2620:10d:c092:600::1:80f0])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad1891478fasm17169966b.26.2025.05.02.01.49.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 May 2025 01:49:10 -0700 (PDT)
Message-ID: <23dbf9ff-8542-43d0-8bc1-2584e5f88808@gmail.com>
Date: Fri, 2 May 2025 09:50:17 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/31] io_uring/timeout: Switch to use hrtimer_setup()
To: Nam Cao <namcao@linutronix.de>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Miguel Ojeda <ojeda@kernel.org>, Kees Cook <kees@kernel.org>,
 linux-kernel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
References: <cover.1729864823.git.namcao@linutronix.de>
 <8bc0762e419b6fd1d0a0da31a187d19826d71187.1729864823.git.namcao@linutronix.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8bc0762e419b6fd1d0a0da31a187d19826d71187.1729864823.git.namcao@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/24 07:31, Nam Cao wrote:
> There is a newly introduced hrtimer_setup() which will replace
> hrtimer_init(). This new function is similar to the old one, except that it
> also sanity-checks and initializes the timer's callback function.
> 
> Switch to use the new function.
> 
> This new function is also used to initialize the callback function in
> .prep() (the callback function depends on whether it is IORING_OP_TIMEOUT
> or IORING_OP_LINK_TIMEOUT). Thus, callback function setup in io_timeout()
> and io_queue_linked_timeout() are now redundant, therefore remove them.

Next time do the basic courtesy of CC'ing io_uring mailing list if
you're sending io_uring patches, so that people don't have to guess
months later why there is an unknown patch in the tree and where the
hell did it came from.

-- 
Pavel Begunkov


