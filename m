Return-Path: <io-uring+bounces-12231-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wF7FL61ckmmUtQEAu9opvQ
	(envelope-from <io-uring+bounces-12231-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 00:54:21 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E51CC140549
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 00:54:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1EB723014BE8
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 23:52:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B64AE1DF75D;
	Sun, 15 Feb 2026 23:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fztVvHPa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B4422CBD9
	for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 23:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771199523; cv=none; b=qTFFj9is713zJquCIgPpt/yKN7SyPpj68Ck6j8wYXdom7aZp5gCwETkPns3twbJxC4lS3zhWpAEqQbdg1c68T9suL+j4/qr5LrENGKFXmI6zXXQzx7W6qbhBqWBZJN0H7STaqGobuGS/k8rlstNfUK8hKU808qaKUqAOakG+gDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771199523; c=relaxed/simple;
	bh=gEs0inbNxM3zdMAW6Ia7LGn3N9KhQo0oDkt3I3o5ocE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TrQsc9h2aIanXPcsE6CnEM1JRWlHSM033Pbs1EU+aoWhBKPQUN85Cvt0a80Od2amEoJYyHhOpZ1tWtulLjA616lbeB8Pyy/ec9jbTMZVBBdzH6187BKgGIWSW5PcVvsJrgiOVNQwP0UOT4fdsnkdbS/bgk6mjiXRDOX+wz6T0V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fztVvHPa; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7d18a9d2b1aso2617341a34.2
        for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 15:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771199520; x=1771804320; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LubjkIXiEyaJeE0uiU/11/5FhTVR3tdXFdOah1niz2I=;
        b=fztVvHPar/wk05C24aoqnt0cSKAjYkTelmowIpbzrI2PDeB4m7GmqU00q/tMQnEWyM
         fSsXEL4dFS3Ldq7Bg4JtOjBnnzAJI1lZ7jVPauy5IwRgLNWkkhA+Xo9S/9Xg+nxH2DVY
         /EiHf03pWhvtGnfmL/hF4jYns8ZdQjj770IHnDBHQC896XwGTcdG9+v1sE+StVwSMJ29
         0jh9wvNAjQY3SXjne6HgzSBG3oU6w4AcA9IwVt9CXalewRNtwwvAUGwaO+mWuuA2k994
         2kSWVAKDZYyj8JKM9kUh9WLCo8MYSy1DnfDF0tna5FnG8p1CGv3H82b5IPh4mhj1oJpU
         HeBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771199520; x=1771804320;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LubjkIXiEyaJeE0uiU/11/5FhTVR3tdXFdOah1niz2I=;
        b=NkxJUX6Me7tfffDaSyVxE6bLkpl2jq0NEhZyfEjreb2ZDs98UzH+OpbVg5cFMcsteM
         7nafTy+E/eDWQngREWJKAL2DmtXZq9TUOEYaS6hdrOmBf0likRlTafxOy1laMk7ibt5e
         NyMCYBuiRtZfA/Hsd2eZgPUnV+osJlvGfPNMK2GTYMnsrSTa/XC8i2btMGi5/sTccmcS
         7l5NutjUrfIs9RJujOeQe9gSvG86sp22n+gH9e3mUDE11eXDPJWYBfG+6qoqKxp1RfVl
         fl+1A0sckP2oAft8zslrqgEX7fYXuAxBMsu2Y5Tm7jJujv/LHCPjkrhLh3vSX0Szzhik
         IHQw==
X-Forwarded-Encrypted: i=1; AJvYcCVuoj/oBp1/uF/tDo8nX82IE7d80y2zobxSrCPCvGmRp3qw06Fv/aI5BCFKjwooi7a5Is7KmEmahQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyC5Xxe62t/C3k+G5deWgqBucpfySzUnUbM2vlAsf2ImDNdEY0g
	9O9b03zbPTq86S8IxSLCTNUqVrsIg7++2SuT/UP/xcpB/IqOZp0Z/6N4hDiBMvF9Ns+fDw8s5Yg
	1sQJwXkk=
X-Gm-Gg: AZuq6aLTztiZypiaOL72oT9dKaL7iR94GlSBXxNPKJNKSLKIqys958+rFrc7RA3t81H
	ZusZf9wSjWqYbtxcsbdBeQaHQJZlC+FGVxkGOxzZbPJhaEwI3xBs3yJhmHx+QY/7o0ZS/yLoChD
	cuMAN3WV54yDOiLJgyIQIVrf5eocH1fzJ/q2D64C0l1XAanLicxeLK/CRAkbhziR5glFxB0Ob2r
	CC1Is2lj32pMqguhyYvBuszC8rnj8/0VpTXcai4IAESQ1DysxkRHXs0jbw4h3arSdu1WGDM9ZjC
	1JcRDHFlub/A/imZHhUyEM3iBnIigQwaknmdOrKxnDsfaqDvTp1X4vQJCAVeyHD2vkL3avVuWVA
	ag5M5KntgxYtGV8N23eyMMhY1N6/PT5avr28fZwbE+8MgFIUbjkb5weAz02KAtPyI9+bBUxPqp6
	5J1pRMk/WZ8bOYVF5//5IsHXsrAulorC2uuRSP78bslhKiL7UgvO7zsPv/coPiP7vSN9W9d95KY
	17CChCuBA==
X-Received: by 2002:a05:6820:f00a:b0:65b:257b:a898 with SMTP id 006d021491bc7-67767294c72mr5514476eaf.29.1771199520126;
        Sun, 15 Feb 2026 15:52:00 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40eaf1e854fsm11890488fac.20.2026.02.15.15.51.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Feb 2026 15:51:59 -0800 (PST)
Message-ID: <49f25745-fa99-44c4-b74b-c44a961e387b@kernel.dk>
Date: Sun, 15 Feb 2026 16:51:59 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: remove unneeded io_send_zc accounting
To: Dylan Yudaken <dyudaken@gmail.com>, io-uring@vger.kernel.org,
 asml.silence@gmail.com
References: <20260215231523.308665-1-dyudaken@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260215231523.308665-1-dyudaken@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12231-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: E51CC140549
X-Rspamd-Action: no action

On 2/15/26 4:15 PM, Dylan Yudaken wrote:
> zc->len and zc->buf are not actually used once you get to the retry
> stage. The buffer remains in kmsg->msg.msg_iter, which is setup in
> io_send_setup.
> Note: it still seems needed in io_send due to io_send_select_buffer
> needing it (for the len parameter).
> 
> Signed-off-by: Dylan Yudaken <dyudaken@gmail.com>
> ---
> Hi,
> 
> I'm reasonably sure this is correct - but I think Pavel might want to
> double check that I did not miss anything. The tests seem to pass with no
> changes.

FWIW looks good to me, and we should probably move towards just
tracking state in iov_iter for the other paths too and get rid of
this. Wild handwaving, haven't actually looked at it, but it'd be
a nice cleanup.

-- 
Jens Axboe


