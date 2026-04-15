Return-Path: <io-uring+bounces-13049-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4JBwN3fw32kCagAAu9opvQ
	(envelope-from <io-uring+bounces-13049-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 22:09:27 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 41B3340790A
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 22:09:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F216630ABD12
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 20:09:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F60F3859DA;
	Wed, 15 Apr 2026 20:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="hIVEgW+c"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C1E23370F
	for <io-uring@vger.kernel.org>; Wed, 15 Apr 2026 20:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776283765; cv=none; b=ERgx/YjBvbzyOmEf2nT32I0i6rU4OSJsjXo1Tr+X70PIhWZdoZAtak4MbArtg49hBzJ4QRv34K6xCD7gcnNUDx/h4k+5NrrHNfk/qkk4tRUD7xKs/qbvz7sxaJzeS5XZR2gV66S90U9X+hHbKMlm0nqnfd4hT6ZB9viokTewhrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776283765; c=relaxed/simple;
	bh=GOtpMk//QENNCRaBqNHSIeybw7o/Y/31eHo1iUkYjzA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LI8bJuftPO95yw9nYyca66bao3wJ8dhS5FKkjZ93/MY5GwdLU8xZrrUQjGbTAL8I+43AFAyTDlwygmw5eDQgf9JVx5ztArX1e8O7Sk9Xv7ZVHmOztPjEjjezoEzzlU8/8pogv018dzNLpd3WPQzA1+3JWqXc10GwBRckXyYwSj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=hIVEgW+c; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7d55b97f358so4354355a34.3
        for <io-uring@vger.kernel.org>; Wed, 15 Apr 2026 13:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776283763; x=1776888563; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WgDTUnukorJscI5siZH6fwJtm9Dw1JEgSPV4+/spIMk=;
        b=hIVEgW+cA2f5L6PzJ2RVFBB21jkD6uuM4HiJ8cVXg/ebW1dVphF08TTRjOl4bzV5U/
         O4bON0VcrxrO7SSlNQfOkta2MXTRU14EiQxb9cQoa7+pnNvlgeBX1y10ePkdrQcNc1iP
         BfAKxfkf3Vucz4aTzVV/5LiTqi9gKCQilCRdXba53JRmCt2t0IdvmYbKFYL+gcX55/Rk
         oij6/vrmEzS388ekVdDcoOXkQmJjF/wLGCdDWFZ7gt4BUK+6VxwFJPoKpHDhvlgL03TF
         77c9RbOmCi+eRr6C+mFRS9237wsogryuODTHwOy17snjqDWNqj4UrQXMEXTzG7hWAsmf
         1iOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776283763; x=1776888563;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WgDTUnukorJscI5siZH6fwJtm9Dw1JEgSPV4+/spIMk=;
        b=aro0Up0ykSSn2j8RH+oCOS7OJQU/fjBcJoc2dfQvGRev8vKrLGnMUle2Nl/Y/UlTtg
         +o4jf8bIGqzjZODWwUlEejYVb8CyswAoCHyE7DJRVeWhU4UaYfPpcl2aSviQzfXVuc7G
         a8iWbu2eDxhp9rrCIO4JuNQT/j9NxhrNG7bnKHafXGYqw4R4bbigp7HJsMuUWiuWrAUX
         395BhDjaZYH0ZL9Iq4zt76Zf+0+8ZU5xpHnzsUAS3ihzJrvueeMy8vU5HcADayB22/RC
         sUQ564gtVZDI9SazPk/dLosktPzmAdYPBpImJFA/ccpmgaSn+FAGWxrp+mQrqIfIoJnj
         EhTQ==
X-Forwarded-Encrypted: i=1; AFNElJ93yg56Qsd891Z+2TrYAMLNdWjAmYYF9g1rwoDmzVkbcx0GCDiZ3OLf7jNsC6Ljys3ClfoaETRyLg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+Sk+eA6GYkxaB/MYEMhrsPBQWBH5jOkcLJvcULH3alGv/6yib
	cthRiXs49nfxWylFXknuivG9PK0dBAeKk/Qbd8v5jg6KEtFPT9VL4celG3geswkXYz8=
X-Gm-Gg: AeBDietQCJ+S7J7KXLg9z9yPyjxtCvBigPTkAajaS8ta3Oty5887i+bzQ7KtHh7aj8l
	kUfAvo1j4Ap5rd8S2NxQX0u9+uLRHvgjwCShUjwJdQoBSqfofbID2lqqsujXNqmta5WPa5yw1Ob
	Rsu7NfHzIMx/GIvSssB2DkR5lS1m6LGJ81ycdkqrPBxc9wyO76YIPhDkeLBkRkwy16e649RqOO7
	T+JewLBqxYiVwNJJ9y4BqQHUkOgOhz5BLoY14hRKo9vcj/H6/p+CTkvwdrpkV1hVB61PQG5RHKu
	G8A7WCgHVFv700av/zsnvX4hX7oi9c1FSqv/2LQQA7SPfXKXXPP+WiprvrYz3SAYtnWfLTqCXSN
	lKsDOTU0bEGGvQza1egFLwTzI0IgjIsio9+DM3ZwySd6xdYtgGDHSrm1i12H7nIS/IUkOvb6Fxb
	xPafWnoVg2O1K2wI8hWjAHqNjemnCGu5RhUmHdcToIeGT6osZxogpdUkP/q7okCI9VqEU3c0pKM
	B5g49Ahbwbbli9aZ8uHdXafVo70Y/St92uix5CCHg==
X-Received: by 2002:a05:6830:358e:b0:7d7:fbe5:e9be with SMTP id 46e09a7af769-7dc27e0f792mr15028864a34.20.1776283758967;
        Wed, 15 Apr 2026 13:09:18 -0700 (PDT)
Received: from [10.0.0.169] ([72.170.223.83])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dc76b2dd72sm1901678a34.18.2026.04.15.13.09.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2026 13:09:18 -0700 (PDT)
Message-ID: <6dc4f9dd-975b-436f-889b-7c584bc18e62@kernel.dk>
Date: Wed, 15 Apr 2026 14:09:06 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/poll: fix signed comparison in
 io_poll_get_ownership()
To: Ren Wei <n05ec@lzu.edu.cn>, io-uring@vger.kernel.org
Cc: asml.silence@gmail.com, yifanwucs@gmail.com, tomapufckgml@gmail.com,
 yuantan098@gmail.com, bird@lzu.edu.cn, zcliangcn@gmail.com, ylong030@ucr.edu
References: <cover.1775965597.git.ylong030@ucr.edu>
 <3a3508b08bcd7f1bc3beff848ae6e1d73d355043.1775965597.git.ylong030@ucr.edu>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3a3508b08bcd7f1bc3beff848ae6e1d73d355043.1775965597.git.ylong030@ucr.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,lzu.edu.cn,ucr.edu];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13049-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim,ucr.edu:email]
X-Rspamd-Queue-Id: 41B3340790A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/12/26 2:38 AM, Ren Wei wrote:
> From: Longxuan Yu <ylong030@ucr.edu>
> 
> io_poll_get_ownership() uses a signed comparison to check whether
> poll_refs has reached the threshold for the slowpath:
> 
>     if (unlikely(atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))
> 
> atomic_read() returns int (signed). When IO_POLL_CANCEL_FLAG
> (BIT(31)) is set in poll_refs, the value becomes negative in
> signed arithmetic, so the >= 128 comparison always evaluates to
> false and the slowpath is never taken.
> 
> Fix this by casting the atomic_read() result to unsigned int
> before the comparison, so that the cancel flag is treated as a
> large positive value and correctly triggers the slowpath.
> 
> Fixes: aa43477b0402 ("io_uring: poll rework")

Is this correct? Seems it should be:

Fixes: a26a35e9019f ("io_uring: make poll refs more robust")

-- 
Jens Axboe


