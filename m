Return-Path: <io-uring+bounces-6502-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15722A3A379
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 18:02:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D0BE3B0C04
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 17:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F62426F46D;
	Tue, 18 Feb 2025 17:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bIkddf4N"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EA523FC68
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 17:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739898067; cv=none; b=lRC7TKoLGADlLFvDu588B9V9trd3hDFMz3n6c+99pOa9Hn/Tzcgfk19QQ0O3INI21jcfV1tr/Lvl9uA0iuJkGSU6GmxockAGYb+mvEb503RoTDqP18lDEGIroeo9JnBeFzgUYtLDfpivD3VyUcCvMIYqbpsAeYf0aDsXBGW/Sss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739898067; c=relaxed/simple;
	bh=ip12vp8LKIQkwvxRBzGL2Qva2TjenJoa7/aZB1dSuaU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T0Y0HIDQNB1TcLAxLiQHAX0Ko2jRbRttgs1ZkeasVE1oRSVA0k449Dkjvoz2/eRGXYDbgv4ihIVr0tbkdOOuEF2mj5BxdqoaO4RQnmWTa7d3Pmpd+56XOqDTT4FCv89h6/ZrFzrgHGaOp7c9kXtMGB/+H/FVVKGi77PBpXpFv8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bIkddf4N; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-852050432a8so148031239f.1
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 09:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739898064; x=1740502864; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cBtl4dcGlVqYUfCvOoXlxJyBqOp21mgGHoxj32KV5ps=;
        b=bIkddf4NQRUuP+jTBhG8uClSTd04/Zl3ssTgyHNTG3KTWvxVVt720XZMa0dZi5M0fX
         sOhsIpvn+RQQr4N0wTVaPGRlUDBMZfijmPHl5M3Fc6HEmgP2INXqf6vgl2zQlOAECQ1U
         90QSi812sHZxkU9JUGMWyp7eS90w8Y7oW1EXSvjABeBIszFzwOAcS/5JNeE0Ou6K7uoS
         VEc9k0Vrj8Y9E3rJPzd3IlLC9JJTiEI5nGSduxQLhjLJxGwjgh6iKsWs4WT/s/GN04qT
         m+zYXAGp4JfC4kWGPU4D1LIB1H/R2WysjvXqkuGCxawGaHwcDD8py4CQY6jqoyY6P/t5
         s5Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739898064; x=1740502864;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cBtl4dcGlVqYUfCvOoXlxJyBqOp21mgGHoxj32KV5ps=;
        b=c5LQv/boP7saeNynT3lwuoUqRyDaxxj7NaDnJwUP20KoIvhBlE17ll7EUlVwfFlGvF
         2NqJ0OUsx9/EezmrlKiW1IvfNJFg7xqNhyf6FKuYOgv9H+GZPTDylQLYk7E9o2DHTqS4
         cOAorX1ZT2QbTroI4+Dq7r45PZhDIWQL8Ryzw+G6sTkjW4+7xhb+ZiNroFCQlXL0Lvhw
         l38e/SDmQT5GJS6FFmqSy8l3rFchod1s7eTnQWpbylzIHK+tr99NqkphkGC/AotHKJ8g
         6WfDXbo93zAxtQrTg5tBnF7C/XR1Bq0hevRq7U45pN+5KepWyHUp1wiml3XXMgoQB1XI
         w46A==
X-Forwarded-Encrypted: i=1; AJvYcCVuHzjwpL9NkcgyQ316yrffSeFL5WKOBrOzxIWG16lNq7MaztvJlIs/XvPDDNKV6S7A/1cNnM46vw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwFGZD9qZG6rGrGN6m8JJ0o+z1n+YEUpbMUt++eSU0i4w8sRIiD
	aDukfcGawSoYQxbayF7DNx9eyiz2rhoZPMapr9PXyjhysD2gru2ryi5oc1dZSDc=
X-Gm-Gg: ASbGncuTGD7yL0jbQxDxjrp5VP8tG4Efc0MvPH5/ytJDbB3C35HjNebukEfYHs8d/qL
	6rgcmSKvx4MlWG3yK/MJHFJHTkfosDkZyvGs3yzsbrIdOi3Y1vPgJYOvbbV123PTggsofkd/sF4
	34iqzVYeQC9waQ4p/oKsFUH6z6ArS6MxpsvhOH68ieqaSQkZAFbzs8ldmdlirD7dJhaREX7QExH
	WYsywHK0PA5G+v/mu/ts9tJJIR+VRJAgMjweLH688/04jwErxzmUvYCA041QLH/lMWZbrmh8McK
	bloLOU79pClX
X-Google-Smtp-Source: AGHT+IEw4GP5Q4xX1kcj4T5NJlI2JZqH23qYtDDSSDP9o9eLl7mEbJg8jnnGbbtzLR+SnOk9VolbZQ==
X-Received: by 2002:a05:6602:1642:b0:841:99cb:776f with SMTP id ca18e2360f4ac-855b2f96922mr77507539f.6.1739898063778;
        Tue, 18 Feb 2025 09:01:03 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85566e39393sm240410039f.13.2025.02.18.09.01.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2025 09:01:03 -0800 (PST)
Message-ID: <98e2abcc-c5b4-40e9-942e-30b1a438e5ed@kernel.dk>
Date: Tue, 18 Feb 2025 10:01:02 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v1 0/3] add basic zero copy receive support
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20250215041857.2108684-1-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250215041857.2108684-1-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/14/25 9:18 PM, David Wei wrote:
> Add basic support for io_uring zero copy receive in liburing. Besides
> the mandatory syncing of necessary liburing.h headers, add a thin
> wrapper around the registration op and a unit test.
> 
> Users still need to setup by hand e.g. mmap, setup the registration
> structs, do the registration and then setup the refill queue struct
> io_uring_zcrx_rq.
> 
> In the future, I'll add code to hide the implementation details. But for
> now, this unblocks the kernel selftest.

man pages coming for this too?

-- 
Jens Axboe


