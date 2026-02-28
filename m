Return-Path: <io-uring+bounces-12485-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uO8hCbzzomlD8QQAu9opvQ
	(envelope-from <io-uring+bounces-12485-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 28 Feb 2026 14:55:08 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B3ED1C3603
	for <lists+io-uring@lfdr.de>; Sat, 28 Feb 2026 14:55:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3B98F302A063
	for <lists+io-uring@lfdr.de>; Sat, 28 Feb 2026 13:55:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAEF61C1F02;
	Sat, 28 Feb 2026 13:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jGtCHag8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD731DF73C
	for <io-uring@vger.kernel.org>; Sat, 28 Feb 2026 13:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772286905; cv=none; b=K6ox7+qiLUmZd+9iDHvvI6K5gmh8+7ZPBO4oPaf8Evl+6NgYVckQOc/2VHu391N/13ue3S9Zby7q4U0GsVVzSNexs0YMU+rsrYCX7vqGQs+UdjSmLo300HNI3xQmHDfxGOpcZNIwBdHmA/i067Enou44FPY/AKJ/9hIW9yrVoEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772286905; c=relaxed/simple;
	bh=3ngLFV2XdZQVeJLfaDfBZZsOtfvdfyGUjbFhKXjrGOU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=MsWb4wDVR8UVSzBDEoEfZtTosnZy86OS8UjYUIAbQYtckiw39JGSSlleq6Vqaev7XToGvmfb+wWNfXfo68BZtoTTVA25lrtmFiIpJ8Qr2MEIjepBmduZxEVjWqfo4KXftHjOHIzYofCtY6w90i70kejSCfS30ka0GzwRhDfx7X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jGtCHag8; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-464bba3a9easo1678555b6e.0
        for <io-uring@vger.kernel.org>; Sat, 28 Feb 2026 05:55:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772286902; x=1772891702; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nhIkJr1AyoV/0G7v0QShPUS6diUOOxa1x5FQubP/XPU=;
        b=jGtCHag8kYfAvI9sV0JqAwlpnUFOkxxiYxeQOem3GmGI7nOPRQmIDyl3LXoOJbftof
         eJCfR+qTw/d1wLFNKl5tym/ToPeT6kXN7Ur6ez0oI4iyQbNH5bCOeO7kDoadAyNocn/j
         c5Vt1P5NQD9fzY2wg6n0aHdIWAO1r+AoTEM/rff2Bz+tCuRjsmun8baxclU2UbUiK6aT
         wtOcU+0vuDelJ5yPQkVRF4PtCgx4V2qMwIDxFCylYhU0b/mHfsg26WpNKdsCWgnClvY+
         zeyZE4zmVGfr9QU76nnyk1ZkLftCUphbylKxnFs9GpC4fScpLLwdTozXjfpc0EVmTzsL
         8U+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772286902; x=1772891702;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nhIkJr1AyoV/0G7v0QShPUS6diUOOxa1x5FQubP/XPU=;
        b=a8hST02REnOI/v5NoOPu+JRB6jGLf7t3DLoqfNRsWaiPH8RIqEBZXajFjhUwXJifdF
         KsHXHZpI14AX56CsiOuv4qAqWT7mt2Bt8ZSQbzGabjyzhgZHPJZyH49OL7vWT/tZiGgB
         e7LYRH8EWaSOC68HedHyAT8zWeFWErVFzL+0qijRTX2oFWcsS6Ui4jzfuKPMKaOwixop
         T+Mk08KLH+utRwjtIt7KvtovtY493p5IGR6vnz7VVb1Y++XW6kU5cgNMO+Qjcmt2tXFj
         2dfqRE+U/7eNf8N0BmsYuOxLujNW+fK9roxh0pN6cnO72XBQ6oFQ1NXRWUa9le4KizrC
         fRaw==
X-Forwarded-Encrypted: i=1; AJvYcCWxU9w1vqxownZt3FSQjYd9beY46qn+sUdERNK+IOT7LKxXs6S/2LFqhhPftgUVW+4Ltao0bWJtfg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwJQ6C+iTLmSgt5M2ZaYvyGZjgeu8LEEg7fBW9K5F7vB9uem96E
	J1oI719rhKtFWbfhhisILhyZmA4mkY2httRR72gq1KmQ+K6nRaPL7tronleQr1JUxq4=
X-Gm-Gg: ATEYQzwNkTkq2HsW62CgbYAlkwZx6O0OL9Rz5hWeKJk49cij3z+n7kZZQBmwvWiZaeh
	WHrE042d5LysofEMIYuTvlswMSy1re0A4Dpt7eEO3kMuH49VSSZWyXKF6kdb8JsEBFS7sSo8bVh
	QmFKaUK7vGByjtgdptKRAkticIobK98ara17YbxbD/9Kx5dm7ytoJRx6c2usV1swxN/US4873vC
	4vPtgjIPF27S+IxVouEgpQL0dAJBQL6x8HCS9oXdjj/vgrKr2FXgzX7H7xUGEVhkGN+riUtIyAa
	l5VUxB9M5E0ayB1h6uSfsRmw4XVACwIbVgeO/xBIPopiPowPUEUwmUW3aEKF4EAdEoHkuW42wOi
	5sRt+Ny5TSIYsNAo5wbbnnDa5UGSqx824zR1+u1rPxSEUyhd9olh4cS6Efd/zFR/4jt5T2naHfC
	xwgr5H+WXfUb6crW6zvRZAdL5MC8v+XFkuA/kDjI1e410ZToU/BKbQzSX1rqPXqfZQleQmylq3K
	Ez1khxwFwn3oXzfnqn3
X-Received: by 2002:a05:6808:c40b:b0:43f:2a62:8b79 with SMTP id 5614622812f47-464beb451d1mr3770476b6e.29.1772286902565;
        Sat, 28 Feb 2026 05:55:02 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-464bb3ab302sm4024879b6e.7.2026.02.28.05.55.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Feb 2026 05:55:01 -0800 (PST)
Message-ID: <3f22b095-cb5b-461d-810c-2c602d3abc39@kernel.dk>
Date: Sat, 28 Feb 2026 06:55:00 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] io_uring/timeout: immediate timeout arg
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>,
 Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>
References: <cover.1772015321.git.asml.silence@gmail.com>
 <6151302f1dc01d1c4e3176da50ab4224947b709f.1772015321.git.asml.silence@gmail.com>
 <3ae98749-590e-4f8b-a835-c9a15d7866c2@samba.org>
 <a6cbceb5-2065-42ff-bcca-bdb1c2443b96@gmail.com>
 <1cd9a071-dc93-48d1-81c9-24b65e65e8bf@kernel.dk>
 <dcb21382-36a6-4d5b-8e79-66290e522f2c@gmail.com>
 <2daa9b01-d989-4922-b892-e7f3f06297ac@kernel.dk>
 <cc9ba4b8-88f1-48c9-8aae-fe30a6b5c282@gmail.com>
 <e834eb01-6cde-4249-a797-ed1fd9f8c713@kernel.dk>
 <2ab205f2-fd87-4fcc-9c0a-0bdebbadeb58@gmail.com>
 <3a8e5738-b417-440a-9851-b8ecc2a82b82@kernel.dk>
 <11058b2c-55b2-4a4f-8d80-7533211b16bf@gmail.com>
 <b4c878d6-dcca-421c-a722-84a1fc77a1ee@kernel.dk>
Content-Language: en-US
In-Reply-To: <b4c878d6-dcca-421c-a722-84a1fc77a1ee@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12485-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,samba.org,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: 7B3ED1C3603
X-Rspamd-Action: no action

On 2/28/26 6:44 AM, Jens Axboe wrote:
> In the spirit of not pointlessly arguing this to death, how about a v3
> that includes the ktime_t conversion?

For the nsec vs timespec side, if we just add liburing helpers for the
conversions where appropriate, then I don't think that's a showstopper
for just sticking with the nsecs.

-- 
Jens Axboe

