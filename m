Return-Path: <io-uring+bounces-10401-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 25975C3ADC3
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 13:19:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id ADAFB3426E9
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 12:19:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D503329373;
	Thu,  6 Nov 2025 12:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TaIxjHv2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C992D9ED9
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 12:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762431581; cv=none; b=KsCfFvfXihaVHObTPBUv6xPZP0A5vQDl/MVXrTffQFosndBilaysOMUEBXmng4eQPG0ZJM1dRtase5k9jMw22NKgeZ1w/KPeLZxDcGfsRpkwKDkDhWwmm4VK6ygSUD+Mr4ynR+SP+mbHkP+a+IvLV54qfsSUK2cwqX7dbMPzszQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762431581; c=relaxed/simple;
	bh=AdxdgEJ/c3YnrMVU+JQwGArbVzZQR7fBlKdBaBlw0xU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=BFZ72yyonDiavFKxJEU8txesHFTgVj4NUCY9AcMT6L+rxlVwq1swUNRFKmvz16Pv4Pbdxiy27/uIxz+wkUAix1AQtH1lrFFrmaFUOQnuLs1GOE5JCm8Hf5de6yTn8EkdJE9LlCVeHh0J6AgWS49drdWinHjL7DHa7+UfgaoP4UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TaIxjHv2; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47758595eecso4709475e9.0
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 04:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762431577; x=1763036377; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+UF4XjDbwyokRpg/QB69b+dDKTBg+af+82xcWz8pJFE=;
        b=TaIxjHv2zS2XPQoAxzGP/Pa7pjHLqY1kO0ybeiDlUPHGKQfcAX+N59CZaC8RhwucPO
         WTYOGcTg9OtNNH7Uo/4PEHr9UBQ6L1HEUwxzMimZfxQBmfLzVh3X45Od5bmnKaU6H+tb
         q5zP7KblkQr72Ljx2zjRyomgeR1f395LUj4Y6Lo4ukunKG0pjJZdbZ5K69r2dMI8yNCT
         +tywt6HHQhfwfosN7N7k3QR577gmn5gUCzfI9Zyg4rLN4irMCe0iTLnkZjtrTBRTu0n1
         Utp936Y+Wqhf5JKyik+qDFgR5Yx1ApsP/Tp2u1LeI45g238xtnXa6j1SRglp0RyP0wDs
         REhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762431577; x=1763036377;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+UF4XjDbwyokRpg/QB69b+dDKTBg+af+82xcWz8pJFE=;
        b=iDj8uFLg6wCUV/HMklp2hhBLv4r04PyruWO50QmRJxNEzVCySB79prZ45qNTBZjVI5
         XpUYRlpYyoSYL39eYRLzcrwo9R4WGk0BY6L7lAwmVkV6mpC8DIgh+vZWu6aiDP7AbeZM
         QvtRcC6Os3DfMr96MQOycUvjjGUqUYnQOdUGa8Wo1Aglhprk8dTXE/inGc4fwmsGOBz3
         hO4Ya+Jlv6J+S8jhjd1PSeP5xIAR1rgVZncSbpIIQ5DEpIYRL7kNnBPalVKcfeTmV4gL
         osJDdUsCPa63up8jOITyG9odIIVpfbjgCApkLQq3b14Bk0wCjoR4RePQ0bxCIrg4b77K
         UHzw==
X-Forwarded-Encrypted: i=1; AJvYcCUPxsPCp19pyq/84t6lVbDF2ROMKeapsiZt84drfEtmJgHTwOeYMO25qafL6G7Ylb62OtYgJpBubw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyQ3m0JnR8VelUIXY8V6sPjzJ6xbjL+gXYGlBtNO8JJqUkPBu/k
	k7f7DGNGHlSEj3CSbE3PBnoEcpcguV/weMX5Xd+dJhGqP8DLqXZPhW3D/0hrUw==
X-Gm-Gg: ASbGnctvRaPRkjULigEQcdxu49hc3BmTRkzSo+BZ0C871l2QhTeVl/Z0RURHZ61YylW
	8O5bKaq5vUfHK0HolRxPbApJbc44UMPODleC/vz18tiNRinFmeKLeFYY1r7H2CPlUuQ9cVEENj+
	CwxmLpZpCNTxtN15PW4I9TA3pxVChL3WZv2iSotbA1LH2U0d638Rdo3BK+0RRw/NtVdVDTBNY+1
	gUufJ66UJ0+L5lIplbDKtgSS4kTmidn56UA7igNtu3YUbPKHY8zFNypdOQ79CCsRy6pw2GG8bpQ
	Ck98E6abYzdGkChhmDTE0LQO2GdvNdE8vMTkFA8yNZbU9ueY+vjCOp8EuGI5JD7JoexN/KeA9wl
	XV+B880xl7IKD9BABvst9Un0nAmwzaT41zfeXI3+0O+vzCmdPP6b0e20Qg+qo/PpYINqk66LbWu
	ua6yykLj6ITxxzaZO7103IaI73M8lBWRyleJHK6eCsdpe1QVy+sN0=
X-Google-Smtp-Source: AGHT+IE/6cFEVxKImiTauS9+n+mYaqYQAQZsON20YMDfg6FCNYIM44J2QyAssrse9U8sC/C6F3inmg==
X-Received: by 2002:a05:600c:821b:b0:477:bb0:751b with SMTP id 5b1f17b1804b1-4775cdf259amr58177985e9.27.1762431577464;
        Thu, 06 Nov 2025 04:19:37 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477625c2f4fsm47710035e9.11.2025.11.06.04.19.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Nov 2025 04:19:36 -0800 (PST)
Message-ID: <c5390f95-22f6-4b21-b1b1-bad44d5fc1e5@gmail.com>
Date: Thu, 6 Nov 2025 12:19:35 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET 0/2] Add support for IORING_CQE_F_SOCK_FULL
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20251105193639.235441-1-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251105193639.235441-1-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/5/25 19:30, Jens Axboe wrote:
> Hi,
> 
> It can be useful for userspace to know if a send request had to go
> through poll to complete, as that generally means that the socket was
> out of space. On the send side, this is pretty trivial to support - we
> just need to check if the request needed to go through poll to complete.
> 
> This reuses the IORING_CQE_F_SOCK_NONEMPTY flag value, which is only
> valid for recv operations. As IORING_CQE_F_SOCK_FULL only applies on
> sends, there's no need for separate values for this flag.
> 
> Based on an earlier patchset, which utilized REQ_F_POLL_ARMED instead
> and handled patch 1 a bit differently.

FWIW, same comments as last time. REQ_F_POLL_TRIGGERED is set not
in the right place. And, with how tcp manages wait queues, you won't
be able to use it well for any throttling, as the user will get the
flagged CQE long time after, when the queue is already half empty.

-- 
Pavel Begunkov


