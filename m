Return-Path: <io-uring+bounces-12058-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aLhbM7vdhGkV6AMAu9opvQ
	(envelope-from <io-uring+bounces-12058-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 05 Feb 2026 19:13:15 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3878AF6643
	for <lists+io-uring@lfdr.de>; Thu, 05 Feb 2026 19:13:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DBBEF300DD4F
	for <lists+io-uring@lfdr.de>; Thu,  5 Feb 2026 18:13:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1E3830594E;
	Thu,  5 Feb 2026 18:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="m//2D3mv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3183016E2
	for <io-uring@vger.kernel.org>; Thu,  5 Feb 2026 18:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770315189; cv=none; b=ePuttxLa5wrhyDiaQUCQ/dXKzzBYkxXx5NCmuH7W4LE68kQEh5lOKEyEgRQZkIp951zb6/py0UGaD5uQeB2/osGcS+Xut2U+gfDSk9nGIJudNh2Y1D7xTaafbB6HPl/W9uyJtOOmL9ticdVFMle+3JUJDBk8zUjJ6N18JVHu1x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770315189; c=relaxed/simple;
	bh=0oJFOkRcV5lYzbo6009rO5nkha/VqrQxkC2sQjvLZKg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=t58Kn6zDDUs7dqwF0fs8A00P/Wozod4hBMi6TEwQoJmMoOCQ6ZFr7c162R5sJQOuPFke7hqB3xOD3oOaZ0/57WIw70nFShNVqB1WPzX61ZuAvu3HSPKcX+yhpo6cr4eYsHQ9f5cafqI7V0dl1uEHoNqvjexVyo0s9Ctrr6XY62w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=m//2D3mv; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-40a62601731so754797fac.0
        for <io-uring@vger.kernel.org>; Thu, 05 Feb 2026 10:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770315187; x=1770919987; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PXHzqascsh6fzgoA4IXHTTmgg2xk9q72ZAVQ22cNdpY=;
        b=m//2D3mvdzMFpbXLSYwNr9hGZnjf/f9HRdpADZ+DpzvfoedP4Vh66pzv7Tn0IXJOVd
         97ItdZ+fY6wAnX7HB0mV1+v7yZ4wuq2mZv69FRnu9waq8No5TV8ZWUEOkv5lz7BPtlQZ
         22fUgefkW+gyl6AE7pK/GgUDkd3LNpzU0ddatZTXZ/nb9KbM6fmTAOm9IP9GHhrJeR33
         GQcQM1kLH9W71vKthqZMKnQuhM/RQ+wPLIJ59e0OizfY9ev8zRy464Ydo4wNug2A8G5H
         jEcop8TwaQH0kH0rvxYlR79I0+t+bB9Uggjdi4nKvxxTYtYuKrHZGHpgIPQDY+tbsiDi
         WPcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770315187; x=1770919987;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PXHzqascsh6fzgoA4IXHTTmgg2xk9q72ZAVQ22cNdpY=;
        b=qXGfVK0Kogk2akwAqWPg7xec1yV1YESKNmsMkApiPHPMcchm0CmtWxijFSyHNQPvCN
         fhnGICPzvLLwyyB0F7jvTS3t38MORNft268GxxvRNielKby+WoeEcKHmIDXGl2nq6EXw
         ZkW6HoIfVkDID07nfBifOfR0AFHmc0PIBKguDGIPY9TM4cbIBIMd08HXhr2+1oefpsSa
         vy2/WNjPwPU+uuHGcKzu+Wv3ebhAjsEiBtzTnDOXY55kc/3u3kpRAUojIBD3ynfMWe68
         4qHB9A3wh08bZ5e2PBmUqzLcHPo53WkDZ9pDvTvCpsqOHj90/rMaOsiBpnryNZpvLHAV
         N7kQ==
X-Forwarded-Encrypted: i=1; AJvYcCUL/DDoAye4yS+6c8E7S6VoDJt5SH8vIpZnYPhRIZwpWlsoGmCSI6nK3juhq+8Tz5qDp+WROYq2Fw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5/HK0L6Sm+aaMNv47+1SEUMlCLqxFxTjdKjIaubaxZccVjpfw
	cJQ5sdCKGAXOAzQunCiGJxKohq+nMekqz2x5B3bSwbhpUTnGCgV5yJtyBgh6lVHHqfUE4R7dCcZ
	JebJtJlM=
X-Gm-Gg: AZuq6aKsVBxsX0f3Xau/w4Z+B7Knd4xANvqVo3DczI+qrYRlVD0eV3wMBSzMs2NKHhW
	YKfH3dy9bl7tgc0cDLqNsMJG28EuaI6bjSUS+xSurajItyrWgZtFux50b5icwjItbMy/OKstNu6
	BDHP12ZJuLVvxjhF0zYe9VFev3JLoboIbwhT+gT/BYpsObzCxKKJ9wxQgxHw1GGS40RbmGIP6Y9
	/oqMJikLupTxOWdLgf5J2Er4UpobPB5Cc9mhqE3LIMMWlwHu/NHhPnBXQ816Pt2iJwGY4nVZmnh
	v5dZA4arjYcX4K0L2gg7e3VLI7eEcXB4rW95tXTJLweMeu+Gf6EYWkghn94+JujkB/szh4bGSfv
	CtVCF5uMXvVJaHNDvmRdKFX64tHKgx6a8z3YN1Qtoh2QqWC4LWrAanoJ9Xkk6anou3eW6QxQMAt
	0eQcv95OAzRy3Zh92uSPJhL8WJRFIldhCoEO9/ZnvVpGAz/EJ0dqFmudyXVdkCA1BQn4s+wNKRr
	EjFoC+E
X-Received: by 2002:a05:6871:20c7:b0:409:8bfb:c7c4 with SMTP id 586e51a60fabf-40a9777e095mr33528fac.31.1770315187670;
        Thu, 05 Feb 2026 10:13:07 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40a54426935sm4210290fac.12.2026.02.05.10.13.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Feb 2026 10:13:07 -0800 (PST)
Message-ID: <2dfc0458-444c-4812-ad44-b321d4174bc0@kernel.dk>
Date: Thu, 5 Feb 2026 11:13:06 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/kbuf: fix memory leak if io_buffer_add_list
 fails
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <9f658484-0a25-49a1-ae27-d2ffa0f3132f@kernel.dk>
 <1af36abc-4956-4461-9a06-50fd120c04d0@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1af36abc-4956-4461-9a06-50fd120c04d0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-12058-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+]
X-Rspamd-Queue-Id: 3878AF6643
X-Rspamd-Action: no action

On 2/5/26 11:11 AM, Pavel Begunkov wrote:
> On 2/5/26 15:43, Jens Axboe wrote:
>> io_register_pbuf_ring() ignores the return value of io_buffer_add_list(),
>> which can fail if xa_store() returns an error (e.g., -ENOMEM). When this
>> happens, the function returns 0 (success) to the caller, but the
>> io_buffer_list structure is neither added to the xarray nor freed.
>>
>> In practice this requires failure injection to hit, hence not a real
>> issue. But it should get fixed up none the less.
>>
>> Fixes: ef62de3c4ad5 ("io_uring/kbuf: use region api for pbuf rings")
> 
> Looks like that patch just moved the call, and the tag should be
> more like:
> 
> c7fb19428d67d ("io_uring: add support for ring mapped supplied buffers")

Yep agree, I'll update the tag.

-- 
Jens Axboe


