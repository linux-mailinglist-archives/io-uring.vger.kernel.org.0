Return-Path: <io-uring+bounces-10239-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BDE0C11937
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 22:48:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 864431890EC5
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 21:49:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE3BA2DC77A;
	Mon, 27 Oct 2025 21:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Tj2u4Tpi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9840A2DAFD7
	for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 21:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761601733; cv=none; b=rSrrc5cY7Dj22QMS25bufa8Tzv7iBcii75aPhvXGDJcBU24rukqs+++I0r/hYhWP5eH/GvAkjIpdy100JfTkeaOq4cKQTh2yAJmq91mHV6Ny3g+wYWGJKjK0u45Kj6oV2Vx/GUpx56t9O4bmjSUtMt35+oGxKhkL7u3Agst+QeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761601733; c=relaxed/simple;
	bh=HESvwmfoiGXdnTQyiQ/4wlcD6w8702121djuiembiTw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z0lnDj0JeYY1B06DGgGkBzAfCCF/UbNOgp08ilqCo1dJFj7eRuGcdaQTj8hhOc08dCRoGicWZ1Rk4lJDy0dZoLyCUrQrUH9mi5LC46OuHU5mE6tocjbXNX7GFwrkyYEX7/tkZ9cKeEyZxrFroPou7iQXoacJ/+/VqU/w51LF1YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Tj2u4Tpi; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-945a5a42f1eso87604839f.0
        for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 14:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761601730; x=1762206530; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t/0vwNg+qgGMIcwUt5jgRslT1jJKk2XffVBkdX0DK+4=;
        b=Tj2u4Tpi7YtX67PdmWmkJELh6TcHS+jBzjBU/vFgZtzosDgrOuW8oqhKUtVt7PqPqo
         pp8R51swZjK9cNpXXl88YElaYTtzGAyp30yV1e/qM8nZn4cqYGwcUHzCCeUF6GdxcJnD
         vmDrdREQDS8rIBPPmNoQUuFJvx0BEDSaBV8PssXwkIqOA4HpeOEEHIcZ4WQNS/CehR0u
         IbIPXEuSTQVyNmmHS/Prsqn6h0Luy03372h9710zJ840Iz15Ecl1ubhKfUnZMjJMpDvV
         4Kh6IiCJnS0RzGWdGq1osv6hKt1YkzFrWwLpp4urERf2P4saYrtaBLu4Kj5gg05A4ZtL
         i7Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761601730; x=1762206530;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t/0vwNg+qgGMIcwUt5jgRslT1jJKk2XffVBkdX0DK+4=;
        b=jzuj/jDHEmNGiI3VtJt0s/RO6VvVCslIt1JiR11xTuN9GiaUZlq5aA9GmpDuQQ0eyB
         bM0jx6v0ZFb5bWieDSa9w1Vxg4sUiCH46olseDrjyxi12AfjlQjFuRMPSlvVfukjUnEK
         6zcMk312Ku6jEzq8KXvPNdRmzt4mdUsPb2NKkJuiB8vR7uMT1PJG3u7YgoBu0GafZOqG
         3aS2/Z4PgomkXgOSeG0h3nsAXX5vHQP5qPX5yl/prl5zx6XphZe7L1Q/sql3UY/keays
         FC706zYyHbZVrqGFTLgGUXqs79kpZwz9l0f7OKNFMdUkjt7QNfPPnKGKmmvHI4gZjzeh
         RMdw==
X-Forwarded-Encrypted: i=1; AJvYcCU/zfBrIdr62fJhADv8jMZosh/g9QnRGRYh3KAbuAtYG/yiKKXJwLtT0iXgGsqeIsN/eGDREEE27w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxbSgj4siDAIrfnJjmzPESZqyI08g8WQ3b0F8as7TpfT203EDku
	+K1IiNRuDLpdB6N0jATqTmEXDJlhQwL+PLHLRp/Ssrj0P/fbsaZxDVqobTQ5kjiS7Xc=
X-Gm-Gg: ASbGncskmty7gvJIWWVFqQKebScNtOGzg36/b8KGNXuUQiJ6sZUb3BJQtnquQnsxvRK
	xPiXM2pvcFJBChmTcyd0VOFOqzvIqcFTpkLpd72hBHXfMtioyNO54m1XVmlO6Vp7VyANAPZ3lqM
	rP8yHIhw2MKhKYtY9aOlWZ6bzkrr5oXVbSmYTfLtQBF6xpXxQFBF5h9KBzFZzXG1uYnBRiWlepF
	GpUm2hkV0m3UX/gl/abH9E/UTUATtXeAx1NGC2+YW5sN1ldrjVNX2H1JRgv6+zLtmuui0ZLEb1W
	sDS5Hk182FVFh4aYJBMaD5bvYu6b95mYFbr1PCodAETNb8k17b0HIKn6lQYeneVybwbGGnMpRZm
	O/+zX2JQJ5etnYyOtL3IMeDsiBQQrph3S0L8QxriiV6LpRf87K9Gz5fE56z2q2Q6NWzFsUvDRBM
	EQE2w42dB/
X-Google-Smtp-Source: AGHT+IHzO3FpGLd7oMr9wjLHWyDiT//0dXgSKkkQx/4gl+VhyjAOsEpPRYjjWCpnczR7BrGo6EngCg==
X-Received: by 2002:a05:6e02:2406:b0:431:f808:622a with SMTP id e9e14a558f8ab-4320f6a89ffmr27613425ab.6.1761601729644;
        Mon, 27 Oct 2025 14:48:49 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5aea73dbe02sm3498228173.2.2025.10.27.14.48.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 14:48:48 -0700 (PDT)
Message-ID: <23860806-f58d-4f11-977a-8ec518adc59a@kernel.dk>
Date: Mon, 27 Oct 2025 15:48:47 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] io_uring: Introduce getsockname io_uring cmd
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: netdev@vger.kernel.org, io-uring@vger.kernel.org,
 Jakub Kicinski <kuba@kernel.org>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>
References: <20251024154901.797262-1-krisman@suse.de>
 <20251024154901.797262-4-krisman@suse.de>
 <f61afa55-f610-478b-9079-d37ad9c2f232@kernel.dk>
 <87ldkwyrcf.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87ldkwyrcf.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/27/25 3:20 PM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 10/24/25 9:49 AM, Gabriel Krisman Bertazi wrote:
>>> Introduce a socket-specific io_uring_cmd to support
>>> getsockname/getpeername via io_uring.  I made this an io_uring_cmd
>>> instead of a new operation to avoid polluting the command namespace with
>>> what is exclusively a socket operation.  In addition, since we don't
>>> need to conform to existing interfaces, this merges the
>>> getsockname/getpeername in a single operation, since the implementation
>>> is pretty much the same.
>>>
>>> This has been frequently requested, for instance at [1] and more
>>> recently in the project Discord channel. The main use-case is to support
>>> fixed socket file descriptors.
>>
>> Just two nits below, otherwise looks good!
>>
>>> diff --git a/io_uring/cmd_net.c b/io_uring/cmd_net.c
>>> index 27a09aa4c9d0..092844358729 100644
>>> --- a/io_uring/cmd_net.c
>>> +++ b/io_uring/cmd_net.c
>>> @@ -132,6 +132,28 @@ static int io_uring_cmd_timestamp(struct socket *sock,
>>>  	return -EAGAIN;
>>>  }
>>>  
>>> +static int io_uring_cmd_getsockname(struct socket *sock,
>>> +				    struct io_uring_cmd *cmd,
>>> +				    unsigned int issue_flags)
>>> +{
>>> +	const struct io_uring_sqe *sqe = cmd->sqe;
>>> +
>>
>> Random newline.
> 
> Done, but this fix will totally ruin the diffstat.  :(

What do you mean, it'll look even better as you're now killing a
redundant line you added :)

>>> +	struct sockaddr_storage address;
>>> +	struct sockaddr __user *uaddr;
>>> +	int __user *ulen;
>>> +	unsigned int peer;
>>> +
>>> +	uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
>>> +	ulen = u64_to_user_ptr(sqe->addr3);
>>> +	peer = READ_ONCE(sqe->optlen);
>>> +
>>> +	if (sqe->ioprio || sqe->__pad1 || sqe->len || sqe->rw_flags)
>>> +		return -EINVAL;
>>
>> Most/all prep handlers tend to check these first, then proceed with
>> setting up if not set. Would probably make sense to mirror that here
>> too.
> 
> Ack. will wait a few days for feedback on the network side before the
> v2.

Sounds good, thanks.

-- 
Jens Axboe


