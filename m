Return-Path: <io-uring+bounces-12038-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ENXnKPo2gmmVQgMAu9opvQ
	(envelope-from <io-uring+bounces-12038-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 03 Feb 2026 18:57:14 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B8D6DD324
	for <lists+io-uring@lfdr.de>; Tue, 03 Feb 2026 18:57:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3E328300A503
	for <lists+io-uring@lfdr.de>; Tue,  3 Feb 2026 17:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47C1C31B123;
	Tue,  3 Feb 2026 17:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SwY71fbE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B238331B100
	for <io-uring@vger.kernel.org>; Tue,  3 Feb 2026 17:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770141406; cv=none; b=gQ5zlfPknVxilxuktMOYxekuJFSqq/fWlYmcgVhzCvC4+cgMOpimwCs3vf10IK/cEB2I2pCzaZIpWrN38x0oPkP3G5V3BphGjB+Czh1G75j4QrFagzrZMAv4kvTqhR4mysWrQxvNBulJFxosdLwdFL2cpjTZL94rxegEqAoCaH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770141406; c=relaxed/simple;
	bh=e0nBTTMuiaExe/GwHMNe0Ecnx69vHQ+x3OD8LmlDUMs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n9vk691NrE4sy0nLp0L2ZoAeiZopemtGT0770CU0/ogF1OqU19/hiLvrEiOzQSE21XE9yj+qcMxwqGym4gSEtoJzSUz4yPkZutK5whABZVRIZEqroh5GObwFzbu699WZ2+Nr9XFvOIdPsaUE10M1rOnVPquexSeweItMAfK8Fp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SwY71fbE; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-45c70afbeebso3914867b6e.0
        for <io-uring@vger.kernel.org>; Tue, 03 Feb 2026 09:56:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770141402; x=1770746202; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HmvPoVhvFj2es8gtBbt+lcfOeEJSDYjB7LnU957mXV4=;
        b=SwY71fbER6Cuorcs9+sLw865e+tgv6GsvaJy1uLVw58SJR0nUAYnbrWktrm0V+pU/Y
         EG5tx3beHcIxkfitYsIWThH2Qxl9/SO2crkp//vHcufc9ywUGhOxEBXnpc5yJYQsO/Kk
         4R5pqUUq+SWe7fQcYQRnUAHlDvC393yq/AW0/hqLSOwf9j42cRsfe/Ct2K12flJgAYkT
         xUiiLn9ja8bNzhobJ/lCZR0Ij36Bv5ekC5ls0pwG6KQKFwm7cx8P5Y6iPE6S2E8hJIeW
         +p+FaJ5/vTF1v0qKG4O27mbUmJAGU2G2dZYt2NZ8mdSjSjC57Kam2Z0wahQ7xn/1e5nr
         uMFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770141402; x=1770746202;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HmvPoVhvFj2es8gtBbt+lcfOeEJSDYjB7LnU957mXV4=;
        b=RssFRgZPYLMFjukMiobwpAHN9VhvfsnT4sCYTQJ5c+efkbn4lyT0SoY7/RU7enWh1e
         Li3RJJPyS2FI4vXj3zAZi1xOFT3Z9ci132Gyu6i2BXny/Jo1g7XKpQTmICumQDBRP1hm
         luUNFzanDREogXFpkgIRfvNGiZWEAamiMRF/8TiaowyvuRUNNoD8aMkIJYoe++H2cSCm
         AXo+yiBxIhcI0oUBPCwpa6PPmZYFOYHzwWZ1euJVrfBKmT5xz2T7YThLeouFI1D9CGNf
         NNun4R4QHj8ccwhvOQUed802Sa1AMUyO51Y/2ryiuTUds2yLfR5HiHwE1knaTbJRtAmt
         vnNw==
X-Gm-Message-State: AOJu0Yy5Zz2VcCFTrn4MMViLcjlzzoL1IF4Z/XZuFvXadigBVIRs4NeH
	67zYV6geEFKxqWAyiJxkL6AnvfzrkpjIJW909sV+VnoTVpyZdY++jCv17grDxWFBpY8=
X-Gm-Gg: AZuq6aJl0cterKRX3F8FWCLoOiJTJF4BOiKC0sNIu92p1SUoyepi9O/kEwR56c6DDAW
	NH0p35ePfMSS10qA7weT3wvT2lp5DWmJmo0tkQluWmaCUECNNT1CpsbhetLF1u6aUrUu56KfzTS
	CJMzuwENnAhvI9oh9X+XCsxvNFDQ+Mqe2oCtJRORRi8rHBDxn5rr8Stw4OJZwzi++UOlkBw8M+H
	697WAKd5qav9rz0+xZAfClJDNbbSVXw4RT5DMErC2pnr6ollQXAGVqGKDwDNvOTCx4a10jt/8fv
	VMzFihym1Q3iZBspJK6wamt0lvjzE/CK2EkPVLfhoz7uy77dQ69lbveZVsVMxPPrsA8RCCpGR7q
	JeDzAMHOJ7hvJwRmnhzeCUiioJUJG26a/nNCz2opF4o8h+Dxgvm3NPsi+dvG4VuLi53bMEhkVBk
	Bu2S0hhdmXnmHveI9Wo23kydYmgWVsxGbSdh4AIEn7nh7YTG2/Wtx9hbnkBG6wPa4zkvrK
X-Received: by 2002:a05:6808:3006:b0:450:bb92:7fb6 with SMTP id 5614622812f47-462d59c4186mr105837b6e.39.1770141402458;
        Tue, 03 Feb 2026 09:56:42 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-462d66595a1sm5338b6e.8.2026.02.03.09.56.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Feb 2026 09:56:41 -0800 (PST)
Message-ID: <686395a6-c20d-4390-a3fd-110d6cfa3b8e@kernel.dk>
Date: Tue, 3 Feb 2026 10:56:41 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/fdinfo: be a bit nicer when looping a lot of
 SQEs/CQEs
To: Keith Busch <kbusch@kernel.org>
Cc: io-uring <io-uring@vger.kernel.org>, =?UTF-8?B?5piv5Y+C5beu?=
 <shicenci@gmail.com>
References: <f8f9a810-3e66-4010-b6c8-47cd9d1c9292@kernel.dk>
 <aYI2T75jvb-xeHmr@kbusch-mbp>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aYI2T75jvb-xeHmr@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12038-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TO_DN_ALL(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 1B8D6DD324
X-Rspamd-Action: no action

On 2/3/26 10:54 AM, Keith Busch wrote:
> On Tue, Feb 03, 2026 at 10:06:18AM -0700, Jens Axboe wrote:
>> Add cond_resched() in those dump loops, just in case a lot of entries
>> are being dumped. And detect invalid CQ ring head/tail entries, to avoid
> 
> Hey, another cond_resched that lazy preemption would make unnecessary!

Yeah exactly...

> Looks good anyway.
> 
> Reviewed-by: Keith Busch <kbusch@kernel.org>

Thanks!

-- 
Jens Axboe


