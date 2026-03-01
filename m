Return-Path: <io-uring+bounces-12497-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gBV5KL87pGlnawUAu9opvQ
	(envelope-from <io-uring+bounces-12497-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 01 Mar 2026 14:14:39 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DC45C1CFD1B
	for <lists+io-uring@lfdr.de>; Sun, 01 Mar 2026 14:14:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D04C9300F51B
	for <lists+io-uring@lfdr.de>; Sun,  1 Mar 2026 13:14:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22941322B6F;
	Sun,  1 Mar 2026 13:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cS02p6f1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6D531DD97
	for <io-uring@vger.kernel.org>; Sun,  1 Mar 2026 13:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772370852; cv=none; b=mGJH+ksc5ZAMbseeOFUAi17tMzj6GHxhRGlw/pMxGdSN4PaFhNiPPl5U0esv9SymA01R130/ZpE1A2jU/sZbXoAfEwXybE5vzXCYjxhLtWvyZfBFxV469g8AEmFsQqxUmw+jbWguWFMbqVU9Y24OVZXCHgygVwlNEUWwzVu/HHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772370852; c=relaxed/simple;
	bh=oYK/7bNbjgndx7LFMDmcovzWIRhAdGMyJR8FdeIR5zg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F8YqCi5iWHacAOqV1Pyn5mspe/rC18c+jZxP2jQda6m8tqqtnSO6LhiGGIa3HVVgXh2LO+wf2gPDOobHpH6CJinVND3hVv7FBxXKfKfK7G5ZQ4HQEPiGRyDvuxtL2TFgI/Gjcz335A1rXllHiyCmUOaTlq87bhL3siZk6ErWbxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cS02p6f1; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-4648447e29bso1445521b6e.0
        for <io-uring@vger.kernel.org>; Sun, 01 Mar 2026 05:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772370850; x=1772975650; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hz+96hR5uMS8gx9rZ/1JEYUugqVK4LUQ/kv2vuzjV2s=;
        b=cS02p6f1zra1QlVOaPDTiHTJfS1t7CM/D5k1NqUIC9aGdQ2jt6u/M/KH4EPunHaXDc
         7rjBlf6N2wJt5KreLFv6w6yzxHhF06CnDAm++o+H26Ru+2wuWBbX1xl9azNudg31aASr
         95TZfrMvJBxlWoyfY1lW1c1ekNrSNONmml1v2bveHfdXcueE96Pj18Fsk4W2pkDlizkr
         DSFnLZ/okOMrM7K5g54FT4D8uvIhn/Dh/2R7PW12guCqJkWfYNhtRWeOxVGOnBFTaAos
         yyykbP17c4JPthiwhRHpRZ0xOw0BUbJ4GjBa0hsSEXYs/zPKAH4pZRtKopkRvyybk3ec
         WK6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772370850; x=1772975650;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hz+96hR5uMS8gx9rZ/1JEYUugqVK4LUQ/kv2vuzjV2s=;
        b=s2F6tHNnelk71jBnUtOpf26/xma6tfOHKExq1dUJl5SSaBINQTFdDYwq7nSgVZ3dJB
         oz2Sj8khzByiQptbCuTBF9o0MvuE/5XWi/z0JjDeIYFKpIlJisJFTxfi3yzlyBxZuAUJ
         kG3lllaN9qLjjVNWZ7w4a7+y+Odo7/eyoEHICuZqgp7skEAM3upwJ17C8rxNJIBHA2vo
         tN2um0hiXB35lVH/YEo0+Hau7H6wP+sQDVfoOMlarR2IUTV+ZanYIcTh/Dgu3+hYPKTu
         QgwryJ41EOrD29rF+zyBKQGRT/F9YXvbDmSVeeZYtVxJdWroN1D3kxQt/hQGfwF2g4PV
         m9Vw==
X-Gm-Message-State: AOJu0YwIJSZTe8+nblgqP9DXtCGNPRYJhoIBF9iSejzR3JHtpLwd0jMN
	GwGG4CH+mhpckQxVpCYBQxN6ZSn4vLLeknMZprEKhkfD5D1wRR4pDIJKVRMXh5GRw1KWd6wNAjd
	RRl8YWSE=
X-Gm-Gg: ATEYQzzJX0xoyjJSKNgCFmcAt+Otab5/CRRhw6vcL2e0ioqJHpf7Mct92V6R/CMeCCF
	zz7Dxrye6U6Exst5AdgHokJHn1Gc8Vbiby+wajweaQtnNxii6IsoKthxbB9rajexbnSWMc6ssQf
	7BLjqEf5ylIQBkbELhE/f7BmJGkdDy4uqrGjLbyhxHDYFNKyKBjNZEeMfFwr9PJbsjqogZpPgq+
	9XpkOi85GdrJtRzGRAY8oyFj+KTQvnWgDZY2Lgk5yg7flDOTW5XSIPOaFrE51UZDAqLfWHljkF2
	pz49/Ik8I6WG6Tl9RgIcpmEzBCFZ+iLCQDpHkUm9wssSdcB6zmfjAoibc1Hd403kwlIh7yQWj19
	FPAmU+krp59NdzzgdDADUZkuXlOQmhBwE7SkmFOwbzCU4nuWwCXXrOWhC7MQ38pLTOeoeNryRHm
	Weus+tARprseI3mo12L97xNA9TaOoUZI5Zks/O1BbPwowfeIzL0+8/nJ/9fGQ03HyJ7Adymv+fR
	AfzOnVN2g==
X-Received: by 2002:a05:6808:1b2c:b0:45c:925b:5848 with SMTP id 5614622812f47-464bef47bb9mr5580674b6e.45.1772370849693;
        Sun, 01 Mar 2026 05:14:09 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4160cf2572bsm8886542fac.2.2026.03.01.05.14.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2026 05:14:08 -0800 (PST)
Message-ID: <cb521900-5eac-4408-901f-ef102f04c0ff@kernel.dk>
Date: Sun, 1 Mar 2026 06:14:07 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: FAILED: Patch "io_uring/filetable: clamp alloc_hint to the
 configured alloc range" failed to apply to 6.6-stable tree
To: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: io-uring@vger.kernel.org
References: <20260301013828.1698919-1-sashal@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260301013828.1698919-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-12497-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DC45C1CFD1B
X-Rspamd-Action: no action

On 2/28/26 6:38 PM, Sasha Levin wrote:
> The patch below does not apply to the 6.6-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

This too picks cleanly into the current 6.6-stable branch...

-- 
Jens Axboe


