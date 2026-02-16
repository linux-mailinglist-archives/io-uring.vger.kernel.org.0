Return-Path: <io-uring+bounces-12245-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CCtcEXU2k2mV2gEAu9opvQ
	(envelope-from <io-uring+bounces-12245-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:23:33 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A5A81457BA
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:23:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AE393303BB2B
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 15:10:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E41BE313526;
	Mon, 16 Feb 2026 15:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="R0p3Xya9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A95A30C34A
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 15:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771254639; cv=none; b=VTp+swKnP3jLJBaNBjiAzpp78I7p5vB+cmv8XaV3aDBoqMmb4LMUcBYesCRZyoKYob46SKmsdTgmznoBPbmZVFIgI64xV32UCMxdPZAKpeEJEXKhMKCNJwrEJ/aS6mMsDEFVlXAzJnz7e6VQv0TkqPAKw50bRBZFtmeGialQn/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771254639; c=relaxed/simple;
	bh=0j1JLyvaXx5AIlJoT1fHRPppKSorVAhpv2OWMH5jRtk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z9BMghViB8RErhCMqg7AzQ1w3iDo8AFsLObnbK9kbmnmqK/poFlxZVtm0ntel7Y+nXdP6vdcpdupCenHTMcHk9N0I5iSiT7UzN8be/VwLZr77d9KNoBzwnUfyFOM6FUm5C/gcKPucVFrWF8CGD7pLq8Wi4SOakcD2/A/jv2Qxfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=R0p3Xya9; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7d4c307db9aso1901673a34.3
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 07:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771254636; x=1771859436; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pgtkW+BShXPyy8bp9CeCqGt/EF7dm201v8uERY2WNlM=;
        b=R0p3Xya9Z1ndmAgEDRu2lL9DoaNCUzQaeqttVhN9qz7SBHnkf09tKKGatFLUYkAtH/
         DYM/ZeSBYXTyeAh0MwAD+jFDnQcUPqkHA5C7FtU8ZpDbwgti3d8kny1/fY4H5ZOwANX+
         4frMY0XKuvUdPJg3NM8J98lGpPllKCkhkTGSN8byCMqo4uXRJH3rpIUuegjJ2yURoqq7
         mSNib1QKZUmtXeIN8omxufUTR8x9Td6pKtmZfTOmpnIkFYMWXhdK8lFuIsXMZrbhYso6
         sqzXHcQbyHk+9I/M7U/el6dRDi562kl//PkE4UA2tj2wafJjbkC94OX25xf4b2dJ14xg
         71mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771254636; x=1771859436;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pgtkW+BShXPyy8bp9CeCqGt/EF7dm201v8uERY2WNlM=;
        b=hvLzW1k9pgKSN1X/6RyI8c4JxcmUBTgvqz0AAF4c9ALJPQ0QYG+1H5nFGM3SbRmyro
         SGLSIGpqBQhzFhh8a6ZMIVEzPhQZj4zhHl28RGZCWzedqJBEnQUrnld1lJl6J4gn98vJ
         kYavRv6gi6uIa5ptEaxTTCus13R8klC6odaak0O4tfBuoAlo84vO9gx1t3kvE84XulHd
         R8VlmMb9C2fbrDVoWkMq2LBf/W1sxAP/kLDJQ1xP/n9Gy+adwQxnCOdvNEliqPpubc6w
         KBOe9JjXwCPVGMGvLAZtNjTAjN8hj09mXvGnTotggSHC39SZw+lOS39jyzAzxpvwGtUM
         tJiQ==
X-Forwarded-Encrypted: i=1; AJvYcCXe2mxDhGNxU6rqyrpnQIOYtD5+LPXDKA/xOL72Tu9FY/P5Drj/5QvgFKOxcvhfx5L8Pg02csds0A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxq7L0rb9xq+jK7KUcOMu01lwRO79JecFH6nidngwpl/7jgCY9R
	rKCe9jxOXUO9qarDnL3q8/1prKzssnbHWKbZzmrWSxv8qRq8Nk+IG57+TirHFpHF700=
X-Gm-Gg: AZuq6aLY1uMg+7qUR6hlomTZASJMTVGsUmT8R6zC/CA6XC0P/ZcNVbp9UL3PlNSDEaP
	RaETcu5BpZ2gtGr1CviYyx5kbkbi4A9QdatDF8QGZ5usggdoGOQsfUb4olH/uBqZubNbJdgBa8P
	X9d6nGF1S77aR+iLVnFZKCwHjdDuWi1qmAr/ANIMkeavHt7Ejx6jOeUR5Ck55p/DW09tFdw5m/H
	k+xBlJ3Ght+duZvMefheMn/PrUlj3vhVtgXlpZiH16cWXLrRV4P6vJ3m0QNo7C2axjVkBx94XBy
	5AYvgsSq+0KxxNl5JqoEZrDTZtpqKF2gDujVycgfzPsdLop1CLzYptno5ItVnAo0Eq1meQuMsGX
	NukXaxzutlkHsGT9/szSVTsahWlEZ7SpcucmW/sDglmIr32CT41gnPhHYRVBNatrC8FHMYlh2zg
	JmpnbULwUihlw9ys0uQd5GOlhn3TXaGN4I8bLdkNg9XMA4afx2H9ckjTRtvF3mTQp3VsSO/9DPs
	NJ3t4QT5A==
X-Received: by 2002:a05:6830:258e:b0:7cf:dbb4:320e with SMTP id 46e09a7af769-7d4d0bd1ce1mr5779995a34.18.1771254635786;
        Mon, 16 Feb 2026 07:10:35 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d4b9f04181sm9678888a34.5.2026.02.16.07.10.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 07:10:35 -0800 (PST)
Message-ID: <025de231-a6d2-4fa8-91e5-f4ab81d16e7f@kernel.dk>
Date: Mon, 16 Feb 2026 08:10:34 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/zctx: separate notification user_data
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Dylan Yudaken <dyudaken@gmail.com>
References: <d099d8d0d7526e4eb59f5ffd0e890888a46b21f7.1771242479.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d099d8d0d7526e4eb59f5ffd0e890888a46b21f7.1771242479.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12245-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9A5A81457BA
X-Rspamd-Action: no action

On 2/16/26 4:48 AM, Pavel Begunkov wrote:
> People previously asked for the notification CQE to have a different
> user_data value from the main request completion. It's useful to
> separate buffer and request handling logic and avoid separately
> refcounting the request.
> 
> Let the user pass the notification user_data in sqe->addr3. If zero,
> it'll inherit sqe->user_data as before. It doesn't change the rules for
> when the user can expect a notification CQE, and it should still check
> the IORING_CQE_F_MORE flag.

This should use and sqe->ioprio flag to manage it, otherwise you're
excluding 0. Which may not be important in and of itself, but the
flag approach is expected way to do this.

Also, please use io_uring/net: for this in the subject and just
have the title reflect zerocopy send.

-- 
Jens Axboe


