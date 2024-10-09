Return-Path: <io-uring+bounces-3536-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EE469977FE
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 23:58:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF5261C228BC
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 21:58:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DC181E1C0B;
	Wed,  9 Oct 2024 21:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XUzBGrw/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F60416BE3A;
	Wed,  9 Oct 2024 21:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728511111; cv=none; b=armJUC7B19d4ZAQxaqWwM2pYZ07KYHo/gNVt4b7mJkusv0xKEwKkRoJ/qwkTq9hqqrUKnJ5fTDOflVpYsy7cD04MSf0S1bNwJg0YHUNinMXfCHNkFEschzs2aExoqeKwEesykEbSUw74BflUO/1CfREaL/KafSrD7IDH8EX029w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728511111; c=relaxed/simple;
	bh=8t0p5BbQjdrO1KJl2ZEt0vLVWjCdi20ZwqiuiHbB5+4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ghEEaHI6d2pAaacsjwGhkUmy3yjjj3R/KRGlIw+t27RlD1u5wlVydqwbXzPB6zT+RrYiiQR+3kOYewB9ZML1EU6Z0pDdwRHiutyqVhv7Evxr3b8s6aLJGmNiSP6AdMS+SZtIisyvk/QPCOR5hArRKZyf8+cSlou1O7tEQZDijwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XUzBGrw/; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-42cbb08a1a5so1906655e9.3;
        Wed, 09 Oct 2024 14:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728511109; x=1729115909; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ufNfIzu88zbEmyqoL6y97aa469XTW8bUJoeqLncozL4=;
        b=XUzBGrw/ij2TffDpaSqqIjXvQ499ug6Vl5/IW63v6xrh+GsdnMUP4ZMmeKW4BQXm4z
         7umqZ3w2PsWnu7d1yjGwqzSNnpCEgb4JyfA9o3CBPleGTOwyvqMSXkPmiUnPjd8uBYUb
         /Dx4BW8Z9NiKffxWM5StD0tlrqex5anaMkUM9yvKkeI6V+IrFZ/XsPB54KkKXVdSfIVJ
         okLY9ggUKvAi9/xaYTBjEj0wGe9Hg1oki9kw5bvNok6/sJHjpRixM8NElZhMApTf5QEk
         9DrHMKeEc+kd+3Ny2SYEjQLdGeMUZOGXaqXL+95USWj+Vj9FATjUJHZTnHQKbCVDVKKI
         FIoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728511109; x=1729115909;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ufNfIzu88zbEmyqoL6y97aa469XTW8bUJoeqLncozL4=;
        b=xIO2a8fFx1JEMEAzNatd2oZ2yDfStpzuAWMxvfSdSNWEnnwy/DXd7sc9cmWgr1rxkJ
         hKWlKd8re9kptdWb9zpgWr+zhg+3TZodfnvqdlcDUe4i3w+zDl1zU45o3+w7RuF3titf
         dtIQmmoLycKF/V+N6PH2TptRzFoUhSzEQKHom9kpyzl2BCS8nYE7HeTEf3zlWaWG0XWW
         /WI5Mj4gedXyjQV7H4uouurTlZt3dCIQENjtWON+DuUZpCiui6ygabR2HARkpn7Onhqi
         zdyCeOa7q8xydrIlSdOzAZEcB73xwiKfBUPzgjTODwBHW0uqzMg0NaUB2vyOOuXbrcon
         oOiQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSqneEELs4vGWs2zD4PK2p5HX9yU77mPvDoG7SmciixytgpNPaH+djZAawSPfahzvW6c5lelQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhtgNzTkjLW6SOtsHhnanevGACyZJOzUxlOps1oIDFzk5dDBVp
	zoY5HbsBagWDnNdpivUMD6IxC5NTSm5cB07zCwmqCuVhjfFqtq87YHL5Dw==
X-Google-Smtp-Source: AGHT+IGz6XRUYrZ44rnJOQ+N1dsczw0UqeGkbMlvp8vj148BwNBABgf0281JWcqJ2ajNgMTuB8hfdQ==
X-Received: by 2002:a5d:6dac:0:b0:37c:c5fc:89f4 with SMTP id ffacd0b85a97d-37d3aacd9cemr2793293f8f.51.1728511108464;
        Wed, 09 Oct 2024 14:58:28 -0700 (PDT)
Received: from [192.168.42.9] ([148.252.140.94])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-430ccf6095esm30868865e9.30.2024.10.09.14.58.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 14:58:27 -0700 (PDT)
Message-ID: <9f1897b3-0cea-4822-8e33-a4cab278b2ac@gmail.com>
Date: Wed, 9 Oct 2024 22:59:02 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 06/15] net: page_pool: add ->scrub mem provider
 callback
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-7-dw@davidwei.uk>
 <CAHS8izPFp_Q1OngcwZDQeo=YD+nnA9vyVqhuaT--+uREEkfujQ@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izPFp_Q1OngcwZDQeo=YD+nnA9vyVqhuaT--+uREEkfujQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/9/24 22:00, Mina Almasry wrote:
> On Mon, Oct 7, 2024 at 3:16 PM David Wei <dw@davidwei.uk> wrote:
>>
>> From: Pavel Begunkov <asml.silence@gmail.com>
>>
>> page pool is now waiting for all ppiovs to return before destroying
>> itself, and for that to happen the memory provider might need to push
>> some buffers, flush caches and so on.
>>
>> todo: we'll try to get by without it before the final release
>>
> 
> Is the intention to drop this todo and stick with this patch, or to
> move ahead with this patch?

Heh, I overlooked this todo. The plan is to actually leave it
as is, it's by far the simplest way and doesn't really gets
into anyone's way as it's a slow path.

> To be honest, I think I read in a follow up patch that you want to
> unref all the memory on page_pool_destory, which is not how the
> page_pool is used today. Tdoay page_pool_destroy does not reclaim
> memory. Changing that may be OK.

It doesn't because it can't (not breaking anything), which is a
problem as the page pool might never get destroyed. io_uring
doesn't change that, a buffer can't be reclaimed while anything
in the kernel stack holds it. It's only when it's given to the
user we can force it back out of there.

And it has to happen one way or another, we can't trust the
user to put buffers back, it's just devmem does that by temporarily
attaching the lifetime of such buffers to a socket.

> But I'm not sure this is generic change that should be put in the
> page_pool providers. I don't envision other providers implementing
> this. I think they'll be more interested in using the page_pool the
> way it's used today.

If the pp/net maintainers abhor it, I could try to replace it
with some "inventive" solution, which most likely would need
referencing all io_uring zcrx requests, but otherwise I'd
prefer to leave it as is.

> I would suggest that instead of making this a page_pool provider
> thing, to instead have your iouring code listen to a notification that
> a new generic notificatino that page_pool is being destroyed or an
> rx-queue is being destroyed or something like that, and doing the
> scrubbing based on that, maybe?

You can say it listens to the page pool being destroyed, exactly
what it's interesting in. Trying to catch the destruction of an
rx-queue is the same thing but with jumping more hops and indirectly
deriving that the page pool is killed.

-- 
Pavel Begunkov

