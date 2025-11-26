Return-Path: <io-uring+bounces-10820-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A4C5DC8C314
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 23:19:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8AE4C4E03F1
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 22:19:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48BE23451A9;
	Wed, 26 Nov 2025 22:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ceh0248k"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261563446C7
	for <io-uring@vger.kernel.org>; Wed, 26 Nov 2025 22:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764195545; cv=none; b=Rb/MBxIm7F+TbMvYEvDhdAaRa1aPyW6GB3aGO1PbXYCNYz10YfzUj3xnHeDJPeOEkMUvPVaNian3LFxm3Fl9LwTqTNAx6CFgpWybfOiscUSSD0IXvSVinEmZ1ASnRyPxEdcLiMoZz+e6mCRMGyaZfIMHXN4N0OV3tD5KPQZAYD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764195545; c=relaxed/simple;
	bh=sIWbRcx7sC05bYi/YIY2zR/NKUvh0KWELOSEGo3Hfzw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nFmDi/3IFdJTfsH0nIzsTiNA5UMf+6ggAp35I4mbTIVuRgdd4et0/kYEZbS3MKRn7lviIjrN1u6UFqqzl5akh9eTT465udQDw9bJ2HRfVdi5zQFP6CcjwTrWw0Sac4sj8X9L+hLfAfHyzw2kMj84OGbPFbOcrlBjav9GL7UKkJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ceh0248k; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-9491ba846b2so10964739f.2
        for <io-uring@vger.kernel.org>; Wed, 26 Nov 2025 14:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764195542; x=1764800342; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1wowXlow3FMc8/tNrN2yLigPPDUDtx0JGtrYUEW5hUk=;
        b=Ceh0248kyaTc90MipJKQFJgX3pPuS4aCyr7FKFyuiJzy3OQ/nOTtsx4lt5ihaAC9Jf
         wAT2Q6NI1gM6Oe9YzpFy1mCOAbkJ0fQKQerimlqRWQRutwNWAvyCJI6vn+tfrP23Uy+k
         qIutfsaaHsQ8qoU/9dqZE/Y9eSb16YwGVPjVgqEyzZWUHY9ElHelTOxsrCwiO9qlYOpB
         Wp2O43aKUDOL0CaR0d5pgOfUYklhoKpoivCoYqr6bCusqZCPvTaAxRDdumWMNf2YJaHK
         rKIhcr45r7JnISjXQxWENBcHmMnuTI0TxuapbThn+Hc9e4VP7M4F4mFpdqbHIipsHI5O
         sSOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764195542; x=1764800342;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1wowXlow3FMc8/tNrN2yLigPPDUDtx0JGtrYUEW5hUk=;
        b=v1r2xeGdkcKPx4HZjIkIl1LcxizMafejFPSEm1OIBO0UZWKET27mVVyNzQ2iWVq1XS
         M1jNSVL6puFbUsvdEs9S14E6RcmDmzQ3CWnyyV8ZwGK2+uBEW646puQeDqrgMI4xebLf
         aZbFBmI8YEIO8fr8r9onS85w/nLMEcjcjhZbDm2mgFTfZQ90n1YL5tSQUlfH7QYkEDkq
         7VNI1XYJmzjmhnFQvystztej3tE1FghC6liPvYKv+hYZ6ute6rihAdKfGg+dvTWuA/Hb
         wh00AhQbFhoA19h03VgqJPNI94qXC8jLzs8qBuId6jgwejui+NFOwQZwxwLgnADOc+Pe
         KZ+g==
X-Forwarded-Encrypted: i=1; AJvYcCV9EDNzwV18yUpR63yRRGpUh0maYPqbomUl9ry1ZpKe6RzlaCMfhyd69bsNPS/fvhzb0wmx5y4W4A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxFc+KPaGft48UOjZTVGsO4BMJl3cIN+CxCO9UXeV1qf7w9XIhL
	z3tsY3t66oy3Cvxu4ZL+k9NRPfhjZ+Mi0oA8pQbifZjs+doNkQodxBcZ5x5Mq0O2I38=
X-Gm-Gg: ASbGncu6e5YWMyfrx5b1jgEcmVogHaqEvZXa8n+L04JjQycr92bDwJEN1G4qw5o0+/g
	jDteMHjOlxZ8NoYzX2V8nv9L8L7mpCaC3MPSyPjlZnSGWTNtCT/MUq+O66yeyyg59e7/tY8xbvz
	rDrYm+1q4tu89QXPJQP+viTek3dnApq6qu70AknjSst4knf3Vl/rNXsPG/CO2WGcxcOKu01gbm4
	pKcWsBAozL+Zn51dNVBdOA83zr6xAyGk5CjgZ5Zt9bFsIctm/0DJ6mnqlBQp80a0tYO0UPLL8R+
	djQM4gIxOLYmQZ1Ogsl0gV7H25alv0K0poFk454FleuuCWmhsOZie3QyqxemJoesJMmkcPsLZ3r
	P5baBEJVjr78XZrC3jRpxXqgnBgvx1kHLYhW2TgOM4FY8wgMAlSiedT5SkvPaRGJ65s1m37DLbT
	nlIK9y8wIqcW7DgaOr
X-Google-Smtp-Source: AGHT+IGxkxc8fCZt/xF4NNM9fIWKpLzM300DpmX1FeSS/Z4JaygfyFk1znrns1dtxauVsXPqqT3cZQ==
X-Received: by 2002:a05:6602:26c9:b0:948:81a5:7ac9 with SMTP id ca18e2360f4ac-94948b3d514mr1644646239f.18.1764195542254;
        Wed, 26 Nov 2025 14:19:02 -0800 (PST)
Received: from [192.168.1.99] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-94938651ce7sm811919039f.10.2025.11.26.14.19.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Nov 2025 14:19:01 -0800 (PST)
Message-ID: <46280bc6-0db9-4526-aa7d-3e1143c33303@kernel.dk>
Date: Wed, 26 Nov 2025 15:19:00 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/net: wire up support for
 sk->sk_prot->uring_cmd() with SOCKET_URING_OP_PASSTHROUGH_FLAG
To: Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Kuniyuki Iwashima <kuniyu@google.com>, Willem de Bruijn
 <willemb@google.com>, netdev@vger.kernel.org, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251126111931.1788970-1-metze@samba.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251126111931.1788970-1-metze@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/26/25 4:19 AM, Stefan Metzmacher wrote:
> This will allow network protocols to implement async operations
> instead of using ioctl() syscalls.
> 
> By using the high bit there's more than enough room for generic
> calls to be added, but also more than enough for protocols to
> implement their own specific opcodes.
> 
> The IPPROTO_SMBDIRECT socket layer [1] I'm currently working on,
> will use this in future in order to let Samba use efficient RDMA offload.

Patch looks fine to me, but I think it needs to be submitted with an
actual user of it too. If not, then it's just unused infrastructure...

> [1]
> https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/master-ipproto-smbdirect

This looks interesting, however!

-- 
Jens Axboe


