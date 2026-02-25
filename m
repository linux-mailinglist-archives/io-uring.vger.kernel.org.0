Return-Path: <io-uring+bounces-12417-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IChrC1kbn2kzZAQAu9opvQ
	(envelope-from <io-uring+bounces-12417-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 16:55:05 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 81F4119A0DE
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 16:55:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 943C631593EF
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 15:49:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89ED43D7D87;
	Wed, 25 Feb 2026 15:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RcAsFKgj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D002A3D903B
	for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 15:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772034238; cv=none; b=bZ8hJfxUtvKUicDsGTyKQKmFs3TPpTzjaeA9+jD5l5wRqazgoZWvvZKFjydG4eaaoI8QC6niaXA+SZbpoPantwJ+HNPBTMCatZBkqf/2Nb2d2hvoMhn9aLDPAhN9SAMz55RfoLTwsUBFuvggQ2PgnqaLcU5B7fFbUPxHcFOlKOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772034238; c=relaxed/simple;
	bh=v0Y+1HFaV5Cjm6JNw+uHu5YkFjIIkkHX56K/TPI8X/A=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=kWE5Xz9cLTqcxiRSXFnldNKmrj1y186w/u5pSHOyXs1rYIxlUzwjPgcscicbUGQCeTwozwfjcSpfV/T7G6RkB7pPb1MCJdwwl69YVlTva5waIdWt++ohvhO8DzsTVNnp8nf8BewTjqisLfmu5CT2ghPWwZSKJRQaOkDUvQydHoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RcAsFKgj; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-6759a5576f5so3580605eaf.2
        for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 07:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772034235; x=1772639035; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C9MProOJyXiZN62ms75qj872Q4RTJiN8NNQ4TSdD/Wc=;
        b=RcAsFKgji7eXOIMPKHxxEDYo3aFHvSwcaZ1+98EDmu8v7SIyQ2eTen15PIXEsRmp4U
         SXf1K6QmdciZrsONtSdK4fip6lATXTMYFI0KNe8bUErXRSaWabUSs6hsInz+3KDPs8ye
         Bq5D+glY1dRpHBf9LzntZNPpxaYeWtvq2FpIQx/SqZV+QVPojSXYm8JKggwFMGxCM+GL
         49GVKIWau+EqbmuJ3WfwcCxwwvBslefvXvbU551j8BNSL3cqCSkcolvNrZtspoR710Wf
         CuPI6pLMyzMqs4W/Pzwnio80Vlyx8+HyDmMxWDUa/yyY+V0g9LbN/yBR3udytg8uej6x
         vVKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772034235; x=1772639035;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C9MProOJyXiZN62ms75qj872Q4RTJiN8NNQ4TSdD/Wc=;
        b=ZNMQ8XxJy3ox6I3l89yCMwgPmcKWz4JLlRyqf+dKo71cZSEo2Jiil4xOLkzr3c1riK
         CcPglhdYZgiLZ4RHgTCsJ0PMvve2Y+oSa3B0/PDhqYExU16Ni150Ki2BnwTRr4FuyOKk
         H6EqqhSnL50DdV/clDM/8OPFFZ3OuCE4NH8D+tNl5FR4Vyw+iIZnOoAJgEpDNRD9DoYy
         yzHfbR3UOy3rDWIHGPj5j+bflT8W/d+Q46l/FhdYXtRJ7mTaRG71lYdyw1KZSZG74shh
         ifzVZokt46nhikcSrr9sue/B7EuPH9fmWGyijY229VXik2CeEyOxr+1i7OohDnsZued3
         IbXA==
X-Gm-Message-State: AOJu0Yy9hO0N3lrfgwWRF5jwXrHp7LWuYBmJ2olxKx27bfFKy1w2Z1YF
	7j3kroFut80XsWM0Xoncg3VcODhCr9OJN4gb5ALahmZjSykteRbAB58fN2EDr8HCJ95dZORTK1+
	uSc7ybjc=
X-Gm-Gg: ATEYQzyWafVEsPUOwqm5QBEXBmq/NRmW7PWza0uvl8xDum4kUYI6dFxLmmsMc3R/OXq
	YcglXtCH4SYFOi43jZ1D+b5JJwxkeC3TQ9riihDNJsRYiDyTyZwFFBWxjWYuR9VYZnxWZ0hCuCZ
	uF1l0zdFNgndVc78bfQuGKFoVq7B3g/Mt5SbAVnYar7V08bT8I7HFe//GMraShQM6gby+Nbt3DH
	bn9cabArMfiNzMZH2HmErMalJB8bqzW1LtoqT7U5RAjdU6XjZ0PHQc7CKF5CWs0QnOpijwx47a2
	OHDVz0T2q8jO0h/QygnTLgfff3aYuY2nr/S+3Iw+Euzewxp2C6ULhAzoMQERu96Z3vUPPvi7pSy
	MOecMURKFk+HMpAKB4iFWOPBr8DX7sNFEiDRULK+yZtyIFxcOS5TuzQmduS3iFPRkZdQC0WRzQl
	FDByRWQRKv7pjEGGgQ+e7QpBM1ShLdSlYqa4Pl8bFBWlRTABNqtYcsSI6fPpQ9REUOF9sYri51J
	EvsjDQ1kg==
X-Received: by 2002:a05:6820:1620:b0:679:e7b2:9fcc with SMTP id 006d021491bc7-679e7b2a089mr1506332eaf.12.1772034235339;
        Wed, 25 Feb 2026 07:43:55 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-679e546f4a1sm2596974eaf.5.2026.02.25.07.43.54
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 07:43:54 -0800 (PST)
Message-ID: <a15e0374-bbc6-467d-be33-c188db81e030@kernel.dk>
Date: Wed, 25 Feb 2026 08:43:54 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: Patchwork AI code review
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12417-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:url,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 81F4119A0DE
X-Rspamd-Action: no action

Hi,

This has been running for a few weeks automatically (thanks Jakub!), but
probably very few are aware of this just yet. But if you go to the
io_uring patchwork page:

https://patchwork.kernel.org/project/io-uring/list/

you'll see entries in the S/W/F row. If it's green, all is good, if it's
yellow, then AI flagged some code review concerns. Here's an example of
the output from a recent series posting:

https://netdev-ai.bots.linux.dev/ai-review.html?id=fadb3165-17bd-434f-98d7-c5e6ed066994

If you post a patch or series, do check in and see if there are
comments, I may switch this to email replies at one point so they arrive
as replies to your email and on the list. For now, it's going to be more
of an opt-in kind of thing, where you need to head to the patchwork page
to see results.

-- 
Jens Axboe


