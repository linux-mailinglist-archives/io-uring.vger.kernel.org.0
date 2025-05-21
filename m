Return-Path: <io-uring+bounces-8055-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F40C5ABF59D
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 15:09:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A93B03AF12C
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 13:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24E2D272E54;
	Wed, 21 May 2025 13:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RqmXNZJe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCBE274FFE
	for <io-uring@vger.kernel.org>; Wed, 21 May 2025 13:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747832919; cv=none; b=BjAG6eKQpJuLgOtJl1+DPMSjfH9mhwgSFk+RObPXLpvm04wbsg7y0PcpDNxfsv9/IgKwmyKmNPHOI0SaHKhAWEhpBosyjg7ueisGL9ayfrYHOYEhY6B35qqSCMbjP9JB479INNLZ7TR8B+1VzlhNgpz18infW7FY8zoCkkaXnFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747832919; c=relaxed/simple;
	bh=A95YUTb8yjQBhLhcBvSqS4Udv+HPRjnCS895oeAHWso=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o5fxXYP3iYbrTEm1mWW02tz45s/H9Ge0u701tkr73y+8WTwkmELXxylsC1KXui5rKKs3zkRZrJdNoPrgo9ctc9qIMzkFToPrlHBEXl1IXD3I/8m0SSB67BpLNVT9YkMSI/11Y6W66kqmMht3sQxnB2d1ce42PTy+6oFQfhDIj0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RqmXNZJe; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-85dac9728cdso229142539f.0
        for <io-uring@vger.kernel.org>; Wed, 21 May 2025 06:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747832916; x=1748437716; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gt3XFPtSptUI7aaEreVu3gUubLuWy8OGp5Gd9ciB1WA=;
        b=RqmXNZJeVeWiUBIsVq07mgGAg16p/Pw2++raSHeyAGjboz7b96+kv1Gm/ZGm4x3YcM
         CNpYZftztzQ65NUC4LOfN7yr33K6owSgRgXZPIJ7o0+c5LNblD1SM7UbNzoUiIh/Rr6M
         B/qktmukyX9djgX6+EZl6DaBMlWhWKEsdlF9jWLqr+0wiCX9+P0TuokNcuy+J97zUxXe
         pF+Q1eahtqKkuUeilpUNK2Qd+h+ukFMz0Vbr5t3pzt4OispS2capLPBGxHGaFDD2DcB5
         yZ46rSUFplsRpwYM6nstHs3p9brVVK6dXv8fQDZxZ7XLOoDG0peMQ+Q5tHJ5Av2HXJHE
         TK/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747832916; x=1748437716;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gt3XFPtSptUI7aaEreVu3gUubLuWy8OGp5Gd9ciB1WA=;
        b=BDKzJ/ltB2yONiLSya3fOOquihML5MimgEG3tfrXfADp30dPc3SxdmQD2p9Wv/p2DF
         PcexNhAkaas7vPpee/OYeTVuja7NEki1HwkY+fFOwqkdTHr92mlxJe7nCb5oHiQjCqDF
         8n/NguawiQF6zxuxsbkE+WyakFDxeq2KtPLL1NfzZRLL/vnDF9nP3yuhwWovlel5DJ6E
         gX8Iq1j6OYwcv3B9QnjyaqBLT6dZAh3VRkuzWrfTGefmOgjNXHgQ+FAe7/YSD0hEjpK/
         b/a9FX+OAO7FOtGieM7d9L98kYA7yCnBiJU0PVdGz6u0HgIiDewwJzCNrPoEQLSHvSmm
         kSTw==
X-Forwarded-Encrypted: i=1; AJvYcCWczQWMH81yIwisUdlzZdo8hFykQrdSUyfHatqfqdOl8yvf0RpObqFcqBdsYMtapzOAXhYswNJYAA==@vger.kernel.org
X-Gm-Message-State: AOJu0YykiJR1Bj8QTGKC5Y0jJqdcjfrisxMHwHakjCW0txKXw1dzVx5r
	rI/K5bRD/D2+LmPVskyGYKd9FbKE7yfe5lo4x8uQLaj65lz+J13Elszz91uBNWjd25BmHDQXcYf
	d/uzp
X-Gm-Gg: ASbGncubSKdtgdAoaAOBPknapF6BUe1pUYWvsdgnSbXP0QFKHlTyPyaKWWxtY4X/5uI
	FamkH3BV8KZYwTHtHgPz1eI1jsGQ2yxlq5dLDhgd1qRJd2i/1RrKom118ecx1COkAszn29AmWUZ
	00Ro9XY5x6HvI0Uib11h16qEnwz1qZmffdAHxTfatK1p9sUVulxmrYdMZR77P6mPzDFch+V+yJj
	UEIG3N0ovtujlzSwDQz3jhSndzURVeHRJSxvVAypscJBrPk/APXiA2lh9Cr+ovx6xGxr4hGH/xo
	B2zEXOFAo7c/z49kyQs8xSPLo7zc9dLD0nKkV90f1YpbUqdLZt9pMuH2Ig==
X-Google-Smtp-Source: AGHT+IFz6JAxU10bYyrgn5yhg0be8127cbl5Xmaum6Ku0LLYlzQfKKz90aTMMg6L/UJHgzfEfKrmuA==
X-Received: by 2002:a05:6e02:184c:b0:3d9:34c8:54ce with SMTP id e9e14a558f8ab-3db84334f5emr247128245ab.18.1747832904627;
        Wed, 21 May 2025 06:08:24 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3dc83f3d0f3sm3233355ab.22.2025.05.21.06.08.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 06:08:24 -0700 (PDT)
Message-ID: <5b728d70-d698-4997-a5a3-5e90ae93daf8@kernel.dk>
Date: Wed, 21 May 2025 07:08:23 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing] test/io_uring_passthrough: add test for vectored
 fixed-buffers
To: Anuj gupta <anuj1072538@gmail.com>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: Anuj Gupta <anuj20.g@samsung.com>, io-uring@vger.kernel.org,
 joshi.k@samsung.com
References: <CGME20250521083658epcas5p2c2d23dbcfac4242343365bb85301c5ea@epcas5p2.samsung.com>
 <20250521081949.10497-1-anuj20.g@samsung.com>
 <7e846c8a-3506-4581-bbc5-fdf9e084a5bf@gmail.com>
 <CACzX3Av3G1K0aoZXDOHjfT=Su6G9D-_RyKWjdMwsNpba8T7CFA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CACzX3Av3G1K0aoZXDOHjfT=Su6G9D-_RyKWjdMwsNpba8T7CFA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/21/25 4:35 AM, Anuj gupta wrote:
>> LGTM, it's great to have the test, thanks Anuj. FWIW, that's the
>> same way I tested the kernel patch.
>>
>> Somewhat unrelated questions, is there some particular reason why all
>> vectored versions are limited to 1 entry iovec? And why do we even care
>> calling io_uring_prep_read/write*() helpers when non of the rw related
>> fields set are used by passthrough? i.e. iovec passed in the second half
>> of the sqe.
> 
> Thanks, Pavel!
> 
> Regarding the vectored I/O being limited to 1 iovec ? yeah, I kept it
> simple initially because the plumbing was easier that way. It?s the same
> in test/read-write.c, where vectored calls also use just one iovec. But
> I agree, for better coverage, it makes sense to test with multiple
> iovecs. I?ll prepare and post a follow-up patch that adds that.

We really should ensure it exercises at least the three common types
for iovec imports:

1) Single segment
2) Multi segment, but below dynamic alloc range
3) Multi segment, above (or equal) to dynamic alloc range

These days 2+3 are the same thing, so makes it a bit easier, as we
just embed a single vec.

Bonus points if you want to send followup patches for both the
passthrough and read-write case using eg 4 segments or something
like that.

-- 
Jens Axboe

