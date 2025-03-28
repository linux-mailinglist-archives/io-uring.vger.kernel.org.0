Return-Path: <io-uring+bounces-7267-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E0880A74CDD
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 15:37:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BCA4171E6A
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 14:32:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75A4D1B3955;
	Fri, 28 Mar 2025 14:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="o0xf4dwA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4D81B0F33
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 14:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743172223; cv=none; b=OE4OrJrg1aicBFVSeGB3pJEZmsNF83Rhx/sDzYEeTvccjIrf63Mjs96JATaGLSBpbYtyS2E7moVufIdnX28DOa1LvpHRvDCTHxGXU/9QeGebm4E4tO2jR9VAKH5ko98N8zA+3qxn4wm1NGmZFpa6TwhWYhb1zdfdcoK2srJ2szs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743172223; c=relaxed/simple;
	bh=kqhjH/RkiOWNIr1pVgBysVpH23vFB7tzaRPlpkeYaxg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nz5K2+AKvxuv2brmV4RZfCvoYRFlW0/yXojlC1bh6krS4Js+P5IFMEvnjGbwoDx8zYW8mmQALMlQwCukKRA5KqHeS2F0VuRjmAvZpjyFfxAd/MNab1gZz9hsFFalXhqIdQTOvXUtmAM6A/bhyIcjUaD+ja/Vr/JyBRR78M46d/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=o0xf4dwA; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-85b58d26336so185047439f.2
        for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 07:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743172217; x=1743777017; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BvoUrJwobiznbx2MdFMDYM8iLPJnm1q5Baa3hRwRcls=;
        b=o0xf4dwAMCpSRixAWNkl9O4vyse2LAhDlU/YKYlko+jBBBlzzF0R9lgCNP/nwaGJ9o
         Wv93spdjRsbaeU26FvPAG4eP0/5YBBtck8yymHg0IysByjpZNG1JO1UYGB3ZHvqOEMuV
         SttKjCdDDI4dfat3mU1+IStDMo1j+4RxsFgGnqqVJ14JNiA0OWHY/+PM1Osi64w/J57d
         jIjbqBH3D21N4fiJIfU1iFi+ihFfEEQLbPDM0MLNBLQ6SSuYHxYczUZFvN3PdkCqaTeZ
         bcc/HXUlQK9U4CB4sgUA1Gl/MnJF3+07puG35J8+PfKTuxkcG0u81DAlprVT69pZRxCs
         iwGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743172217; x=1743777017;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BvoUrJwobiznbx2MdFMDYM8iLPJnm1q5Baa3hRwRcls=;
        b=RAbSmMggFyIiYVN3tcGKJ7CJbpfGVlnwyOh+zLshYNTPfJTaXMTv55wFd9S4Ufz46V
         wb4LapK4Xw9hpuWxzamqJ6mxhoCAH5zAXL/1xJMGCmsihTs0GbG5DN/DmQ6db1jvYrLB
         le+EfVBITemYdCdxg0c8DsC9B901agyuD1a/IzOTeVbBDK6Fs0xFBeX/IJ7H6cX7pJUL
         jIAdWFV0qOenXZ0C1GZcooegMQLbzEF+x4Y8nTggWlGupOoyVKQIHM6XiZRW2i0LIwz+
         p02LkDWI6XUq/0vAZhujKUxhEhXSJei64ZV/tdHecbN/fcnsNlb7yAcp1qF/oHR9gWmZ
         H8gA==
X-Gm-Message-State: AOJu0Ywl9blfAH40UyALUaxfeEPpJ4iuITe50miMPPevFq7UgQMjNFFV
	1P2DgTkLoaLslaqdJLrL0Ztld7thXEzDjntzkSgVZ7XpILUoFu30Uine6/hOgN6QnRAOROpzTYl
	N
X-Gm-Gg: ASbGncvfG8e1ZA4dKu0j+Bf2Us16i2YA0cz26PoI/BYoMj+Pa2Sb7hNLgjw7xiBak/q
	yJaiSUcWxcsiilrHfgIbMPA6M52uIt1/7QO+Eme8+UDN4GUGzz4NmeY0z6GRgeJhX3g56DoqBbY
	jIqJsP63kIGfQF5ZmpqT3SA/PYQAfj5sWjeZkqbNoRWzlunjnKJkPvluM1HyDy1wRTbXi70so8h
	j0Yi/ziD+fGOW9UDmJ8GU9VgWYUXi025IvmjM9qabThAKn4GM3TNenuDY3gO0kZrsAqisH49sXN
	xJs2+HAJu/S6a4J52PlPWOBVzDhCPEp/bjNlw+M/qgdnLY/QQVc=
X-Google-Smtp-Source: AGHT+IHgGXEk+pHWDr03xGlfd1UZx2zHVo+h51CiadjWxn/ZlP9YL8vC++eoDlkKtKCNbnMQnm9bKw==
X-Received: by 2002:a05:6602:400f:b0:85b:3c49:8825 with SMTP id ca18e2360f4ac-85e82081f32mr1116185539f.4.1743172217198;
        Fri, 28 Mar 2025 07:30:17 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f46470fcfdsm466249173.24.2025.03.28.07.30.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Mar 2025 07:30:16 -0700 (PDT)
Message-ID: <272ceaca-3e53-45ae-bbd4-2590f36c7ef8@kernel.dk>
Date: Fri, 28 Mar 2025 08:30:16 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: SOCKET_URING_OP_GETSOCKOPT SOL_SOCKET restriction
To: Stefan Metzmacher <metze@samba.org>
Cc: io-uring <io-uring@vger.kernel.org>
References: <a41d8ee5-e859-4ec6-b01f-c0ea3d753704@samba.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a41d8ee5-e859-4ec6-b01f-c0ea3d753704@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/28/25 8:27 AM, Stefan Metzmacher wrote:
> Hi Jens,
> 
> while playing with the kernel QUIC driver [1],
> I noticed it does a lot of getsockopt() and setsockopt()
> calls to sync the required state into and out of the kernel.
> 
> My long term plan is to let the userspace quic handshake logic
> work with SOCKET_URING_OP_GETSOCKOPT and SOCKET_URING_OP_SETSOCKOPT.
> 
> The used level is SOL_QUIC and that won't work
> as io_uring_cmd_getsockopt() has a restriction to
> SOL_SOCKET, while there's no restriction in
> io_uring_cmd_setsockopt().
> 
> What's the reason to have that restriction?
> And why is it only for the get path and not
> the set path?

There's absolutely no reason for that, looks like a pure oversight?!

-- 
Jens Axboe

