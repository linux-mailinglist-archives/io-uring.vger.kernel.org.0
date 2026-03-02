Return-Path: <io-uring+bounces-12519-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OFr1McbIpWnEFgAAu9opvQ
	(envelope-from <io-uring+bounces-12519-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 18:28:38 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F2621DDCBE
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 18:28:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 263FD301053D
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2026 17:28:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F15D283FE5;
	Mon,  2 Mar 2026 17:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FJtcbwY7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2D1410D3B
	for <io-uring@vger.kernel.org>; Mon,  2 Mar 2026 17:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772472481; cv=none; b=nUL0y8t/8vWb935b6llGhapPk8ABVJk16zj+BK7kZRlxCsuMmbdxoFa8kGRhKsDoRwxYSO03LTomeqMEc/fsQPaTdwzQ+NEx7qWc2DuF9n45zWKlHpMPQRug50NDDLlU7OgUpI1YEm72fNGDzUtqc60+ZbNYCr/TmoL7t/NdzI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772472481; c=relaxed/simple;
	bh=T0x134goV8WQ2DtQCgAvc8s6JF2xNTUe3NSOgLXKr10=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rfamzHjvRSDCrINaL3M65Y+hOxhwxyz2Gu3ecXsEsiccpm1Hqgc//RUbn35UD3HaBiNxLjNi0DNfsKcLY6Ksmw0/UTypBFuOGXbaaMqcrKHsjg5G1AI4evjt3t/duuA8YR9Df3DrDCfn3KTAuPSCZBpNyiIXhD2piM2m5t2sLnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FJtcbwY7; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-899fbf92bdbso16010926d6.0
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2026 09:28:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772472479; x=1773077279; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3MhoPaUqG9JgKSvFCYNz3zMTwzdLO4nZWUPMhCrKY1E=;
        b=FJtcbwY7fAVy9zCcO5sMCUZhOSIhnfTWHiYHaBsWd3+zbLAFXGUXCHpo+UWzcYeuI7
         AbD2nYto+onlPwjsYGM8dumpp25l545TakUNuKY+Upmw7hDCnZLqxmDzMmCLVQ0GMqjw
         8DMBK80pR8pQvitBLb8SRFVeI96uMEKIlQbDeZCOeZ7tkarUu0UoBJ1aTsNZMJaiqduq
         Df8tBFjek58tIV6XNr6TsHUTckk2MI8xUD00fHEetR4XnOXEvnP7KnCJu/WSeqnJykyP
         AZfFpDx9rehHezOWlr5Tms5JPc+3uQDgCJ69AMMp1yIqu0QpQNacWlhfT1Ww6jL0BuTG
         rtIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772472479; x=1773077279;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3MhoPaUqG9JgKSvFCYNz3zMTwzdLO4nZWUPMhCrKY1E=;
        b=LpoeqnkNxJ4C9Cz8E6eKqxFQn+esPEAHwA2hzvpFw3xC8JHPnxH2mZHc79pUDk5LdE
         tCQhzqcKn6eKwENfJbIpH1B3AXqSFMmPcKWj8Mwu9gditRkMiTxkODiC3BLUUSfomY0C
         nZ6w7l6FnUa+snKLLBRfWxGouE26ersa7ymH6K4QF3krbDNjwQrPeyWCxPzwR0Kdf7kx
         GBJvy0qr8cKNcPvF02LqJaaNUjr+AnJ+htZexuw0ygQKbT8G0fwuD3uzqZLY/XDfqRm+
         7IaCHbMgIqHK3D1/mwKyJQDaxKeXrXacu74Dl+igcFsOyv8xhi/f9ks91QKPOuddBgYd
         baAw==
X-Gm-Message-State: AOJu0YxAVhtTYUYxaEKC0FYE1fKRcuxlQmJOYSRsTwY4xJA0OfLm2rzk
	Nqd738wKx4GygzQr3bKiXVaFHIJgM9osdI/gC+xCr3gRCfyYMPopxWwyec85pESvBvMk5Qy7+CV
	r37ipWgg=
X-Gm-Gg: ATEYQzzkNIj7VoR81VjTeMCRCRBQVCJFLNh6rIBGgychhZdQzyTOd8fhaDIL0DWK0Ky
	aj4AW3rydHsPZxuV5GmSP9UgHRa+iDS7kjtJJCpyW4q7vCI60t9RH4Fxo1XEi3EbRnYKV9JhJDu
	M/qu2I+/g6+cUo0sh0Uqvv3D7wfjf34r8hSoGgIY4AWLGR25ld/LECvLhBby/hW+/S+Dm46fJDD
	hFHHXeXaddQq5w1Mm/DAdPygOLwGDa4+qda9VuZEL4Em5Uyood17cqVGx3GRcUIaYPavVJx709R
	1ibSZwWUzEwXoaWgbteYQmk+H6he6CSWy4WgMSxRsOys3olZ9mL3YLUQn9/DTgQgs6V4Vwl8Ur+
	o9bohq7sW6PHsPywypnpYsBKLRUsk4LcFZJAVqcvomjFNIy8PzoCPqiCRSAvGxFBg+DClMu1RPM
	hjCZJzaPltD/izgaZaWFXocvsmYTSUvqBKHGxx36H438IlVITRmgw0qm87kbXAJW7aq/akBgkgP
	Upo+A2o
X-Received: by 2002:a05:6214:2a4a:b0:899:c5ba:d5ce with SMTP id 6a1803df08f44-899d1e3293amr194502336d6.22.1772472479148;
        Mon, 02 Mar 2026 09:27:59 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf717301sm1185035785a.36.2026.03.02.09.27.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 09:27:58 -0800 (PST)
Message-ID: <68bec573-eceb-4d87-bf93-6c76ec578c7a@kernel.dk>
Date: Mon, 2 Mar 2026 10:27:57 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: FAILED: Patch "io_uring/zcrx: fix post open error handling"
 failed to apply to 6.18-stable tree
To: Pavel Begunkov <asml.silence@gmail.com>, Sasha Levin <sashal@kernel.org>,
 stable@vger.kernel.org
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org
References: <20260301011746.1671806-1-sashal@kernel.org>
 <002c2bb8-3304-40e0-b8c6-8eee7dcb7710@kernel.dk>
 <53896290-9a0a-4822-854f-945595a19fe0@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <53896290-9a0a-4822-854f-945595a19fe0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2F2621DDCBE
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12519-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,kernel.org,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.997];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 3/2/26 3:02 AM, Pavel Begunkov wrote:
> On 3/1/26 13:22, Jens Axboe wrote:
>> On 2/28/26 6:17 PM, Sasha Levin wrote:
>>> The patch below does not apply to the 6.18-stable tree.
>>> If someone wants it applied there, or to any other stable or longterm
>>> tree, then please email the backport, including the original git commit
>>> id to <stable@vger.kernel.org>.
>>
>> Looks like this has dependencies on parts of this:
>>
>> https://lore.kernel.org/io-uring/cover.1763029704.git.asml.silence@gmail.com/
>>
>> series. But seems easier to just do a variant for the 6.18 base,
>> I'll leave that to Pavel.
> 
> I was thinking to remove post open error handling. xarray is preallocated
> and shouldn't fail. And copy_to_user can be moved earlier. Should be safer
> than taking all deps.

Agree, that looks good to me.

-- 
Jens Axboe


