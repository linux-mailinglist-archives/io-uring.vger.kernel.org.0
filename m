Return-Path: <io-uring+bounces-6835-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B711A48020
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 14:57:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF9EE17B5D2
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 13:49:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97A14233D87;
	Thu, 27 Feb 2025 13:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pe5ptzh6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C6F23371B;
	Thu, 27 Feb 2025 13:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740664113; cv=none; b=aTcCFWSaoqAKBJR2cT/q05ZxSdt8xnkP23CR9YS2doJTnPF0q9T0dEbAAEtiloh8laF45dB9ehwZueB6A32PDjm00OQ1x2zCrmVlvZIieyE6UjG28KoXIKpSQxhAt91+Yz76QMVuIHu1qwg9o9jGT2znDApo48US+otxJ3cXG0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740664113; c=relaxed/simple;
	bh=slAOqw7zVI++LpNh8v72VWXj4oE//9x/CEl1pfW2jzo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DCH9tQ6Mb1+0MEu4yNRcRAA4gU5izhSchavefbxaM+qSZW7EmNoKvi788d5XfoYKbA+WgAkl94e28jCIIPspOJo6b86M8qup5WLgrEIPw105GfBYFCCjEeT5FM2Sr9RmH4ZoDklBeRfI5ozB28o1Yoc6FRynMEbq64Ltb+DRgNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pe5ptzh6; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5dec996069aso1493319a12.2;
        Thu, 27 Feb 2025 05:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740664110; x=1741268910; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EApx63Q1qzZyL10SeStYtTlNysvrIBtUNsuVUpFQBUg=;
        b=Pe5ptzh6xmc/JTn2dzTDFDhb/lPVT+uiUuORHq83+dZHxshhMw9leBHrpAGidu7ONA
         wSWnM1IYQpPRl4KagfbJdaRe1ZeIlDd3u54I9A3eeiow50MQrdIGzezt9EEYoykhsEQn
         AHuJAdTA4/aAOyBG2628VaCSbKdpgcC5SDrAJ03ytK3tMnTvXqaie7d8A399E9obzAWU
         69YglZ/AiBBZWYPL5sgNHqx9Vnl17eHf4T7pHQyKtVdLpol9bSL3ZIoXLPwknUmd6pk0
         ueKlePuvGSZ2TQI8wF0pqugZwUnBpxGzCAYhXDjQ6paDmIBKMJVDRCxEPaRjRlIp3cpl
         zTNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740664110; x=1741268910;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EApx63Q1qzZyL10SeStYtTlNysvrIBtUNsuVUpFQBUg=;
        b=pztZUmP45KbiuMzCL35YTSGWOFVcPXDz2U4cQgqcl5aIT9hsE90f1U6lgAokr3p8OW
         yyfoQ5UJM7pgrkex+mWWsNEj/Xa5+7hU6CIikx0FvVCVXDPzd0C+B2qLYkHGaO4i5k59
         D+vKk9AfR/8R/9j+KrQ/TriB1wToPM04AbGCkMx1W/yyhar0RG3mzrFBpmMH0DXy7zkp
         wdjHBMDs2oYqrcmOEFa5AfYz/q/8Qwp+yAz+hH/GNYSKEPj4oTvJ8oBBo1ESXmJFmpll
         Sv6zxMIBXeTfQE6aP29v60x4dM5rk5kRlgNVSBB8afymbnhA8lmM7Dzl4wfDkLlAocA/
         ABJA==
X-Forwarded-Encrypted: i=1; AJvYcCU1X1llXneIuEarGBaeX8BtoTV6w6kXrRnBsnKAkP1IBLG8TkU4quapy9j0+87GkLUAmakO8ORsxQ==@vger.kernel.org, AJvYcCWsTyEklMbG67wROeqLnwEZmZRU/fkov0wPhX4u2fC8tI2OGRHOU/oxAg/Bl07eLOzVYWXbqOtwVbOmWkaD@vger.kernel.org
X-Gm-Message-State: AOJu0Yzwwm2P4EXb5TR8q1v9FMAwItXiEbLdgmrmd3RXOnpAh+fXon5l
	+vxudk4LSbWPQhTA6LBqzC1vmNIZ1Gh8+XroMnCyQeAKSsb8fPfO
X-Gm-Gg: ASbGncvV9qPpCMxPtftKTHUNP1r8Lkb1EttdaiqKwXnNfPZqH42DJVun5JZt5oHz3uj
	rp/knH3RIeI15FIu26Bwo+qucmPY8ytONwdgNGkmjd7Wit5J6KtvzFDs/iL8065WNOXzQXrIKvo
	XZS6eT6FYqsZJgdTl7k5t181Aj4v/1F+CZymHh0UbfklkQfELVihWWIEnhp9BixjrpKCC9Lo6Uc
	XqDeOLGgGzPtM+rrEZCLvrqQ45AJNNsUfGQ9DOvNDdYzmawLjaxO0G4kU50C3tfFCb/s8vhLxoc
	VzSfg134BjFfq3n0VuDf2MPmQBx75St62Kr0r4OBiTjj1UT9DmO2CFpNUXg=
X-Google-Smtp-Source: AGHT+IH3pFb3xUoGobJjFElugknrrTtEoeRHI7mgyioAHss2k1r2qXSU8ambiAnFRRCVG7ANyROG2g==
X-Received: by 2002:a05:6402:2b95:b0:5dc:7725:a0e0 with SMTP id 4fb4d7f45d1cf-5e4a0d830eemr9784545a12.15.1740664109570;
        Thu, 27 Feb 2025 05:48:29 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:4215])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e4c43a6f2bsm1110746a12.75.2025.02.27.05.48.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Feb 2025 05:48:27 -0800 (PST)
Message-ID: <275033e5-d3fe-400a-9e53-de1286adb107@gmail.com>
Date: Thu, 27 Feb 2025 13:49:25 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/net: fix build warning for !CONFIG_COMPAT
To: Arnd Bergmann <arnd@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Arnd Bergmann <arnd@arndb.de>, Gabriel Krisman Bertazi <krisman@suse.de>,
 David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250227132018.1111094-1-arnd@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250227132018.1111094-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/25 13:20, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> A code rework resulted in an uninitialized return code when COMPAT
> mode is disabled:

As mentioned in the lkp report, it should be a false positive.

> 
> io_uring/net.c:722:6: error: variable 'ret' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
>    722 |         if (io_is_compat(req->ctx)) {
>        |             ^~~~~~~~~~~~~~~~~~~~~~
> io_uring/net.c:736:15: note: uninitialized use occurs here
>    736 |         if (unlikely(ret))
>        |                      ^~~
> 
> Since io_is_compat() turns into a compile-time 'false', the #ifdef
> here is completely unnecessary, and removing it avoids the warning.

I don't think __get_compat_msghdr() and other helpers are
compiled for !COMPAT. I'd just silence it like:

if (io_is_compat(req->ctx)) {
	ret = -EFAULT;
#ifdef CONFIG_COMPAT
	...
#endif CONFIG_COMPAT
}
	
Let's see if Jens wants to fix it up in the tree.

-- 
Pavel Begunkov


