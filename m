Return-Path: <io-uring+bounces-5625-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EE1439FDC45
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2024 21:58:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA7FE18826DA
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2024 20:58:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDEA6198853;
	Sat, 28 Dec 2024 20:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mjtZvtiv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1589118B46C
	for <io-uring@vger.kernel.org>; Sat, 28 Dec 2024 20:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735419524; cv=none; b=dHoyeCKu5E+EXZJIbbd2l+qW+TbygKPJDtDlZFSNlnnTuKiBKgNyASA9w/4LV6sK/KW/A2h25nSTDaaUbP6njsEF408eJDFTgs+HJbk4zOy7nQm6pT4Bc2za9/U5ZJiPs9n9IINz9oPakw3Ntrmk97KRE8Ya0okW0HGpxOO1LsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735419524; c=relaxed/simple;
	bh=9J5hk8QZVDm8vbleoUZdhiWobb2Aa1ExtskLRc6AwBg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uI2PZRvJ4UVI7dY9J2xHl/MfYfXUTC1hqQoRWM90DgCcFxu00p5IhatEEE5LFBImTZcFGD4BvGqeoCP65CiJLsqVZr/pmbiJNSbrRembw+t36hcFtVo+N9uX+w+cyDj+83/GlkCbbZdb5mUY/KAKALKiPuaqkBr5PQixwyxD4gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mjtZvtiv; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2ef87d24c2dso8607230a91.1
        for <io-uring@vger.kernel.org>; Sat, 28 Dec 2024 12:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1735419522; x=1736024322; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tvWzgeNcIeTX9LH0dhtA7vdO40SCLRWP2dvCG3jJO54=;
        b=mjtZvtivauOtM6avoPdDUaKlhpmWNVBr7bNSDkAgjVQLnBkdoiukx7457DeoRd2hoa
         YUXuWdePZh48YsZEEHQF9ZNGopRoY1GRx6arCvmqaPem5oTIYUD8cLxtoklSHd4oxOpt
         pK5T4vvu1DbH66WLSFQE7fYpIIYBrW9y1XUULL40DWLoomThI9mnNaZceIsVC5N8F9u1
         d1BdflV9Hol12QaxyyMrGZAXO0q96Tu+qkSw2Ulpl0VojrU2JhiD38ViXBbAp4o3pr3c
         KPu+M8V/1wZs7wrd2ysp72UpU/1LHCSaFYtDwO4KyGzSmUBuG89kJhFfAhQ8jhAQYOcl
         j2lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735419522; x=1736024322;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tvWzgeNcIeTX9LH0dhtA7vdO40SCLRWP2dvCG3jJO54=;
        b=AixneRKOgdUo959p7zLKQ68gwi6tkUg7mZoyhoZIuJals8Qwu/MnNTibgQSX+qThK9
         aTlUYotjGR1vvXfPf+3H1bF5bi08jutJb0FhsM5i4nV3gRf5iqkktHVuHjUvlbdRd4Jm
         JnIXl3F8xattEySojzGW0YkHBVErmXPus57/NzcswQgax8hG5b1MNU3Ti2FyCxKjdQth
         C6I7TQ7ZGbDb3rPojYVyToWG8Z12eXzoXKt7ES5M5qQKXF6ajKy7QIiYu3/y/zbQHWJe
         5K2c2oxFUMWAbW/PaHvCjwdvZkojUUzOtXs4T5/1iGbEPnmE69OvGegTkTAJzmOYRo+b
         aK7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUMmHDrSTOn0rjlcuSKwNSPtF7u0RE6vK2/C0ISO4G0PjrIsJDCUDOfJXVM06IOXmoLfL6v6x4m5g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyQXtNs8BVHAoUi0wGTAwhJz1pP9BR5Dg4xertCD47Ny0cvtfDH
	aXPXQYujHhxIrIazMLMYO5JkWcc3LFP0URy4W16BDrHv1apTCxbtdRdsEpr+nn8=
X-Gm-Gg: ASbGncsvgj2UhhdqEK6jdFs3lCaEap6JO/7YQi1VveanIXENWVWRB0ZlAozx7OXpK6N
	Lf+fnczLc2Q0aU5LUjI8MV2Hxn87tOwq49f5IFYmM2FxIc7d9z1Bzv+08wAQWXbshDZu0HH2m0s
	MUqPwk3gJUbRO+lm1np5uAiLn8A3DhOwFCUNcQ8/27/4fd4MVpTvDGpf1WhEvxXt4Itsorq4KnS
	WYNW9JwY0dc9/QUngVi5Q2me6wnBSiraQfeePIh5nqnO0rlzged+w==
X-Google-Smtp-Source: AGHT+IFWFMfKYzy7zXm24wQhFZ3sT7tgPFA92qXW2nHZ8UJHZc7AuYpQdciCaZ3KUUaG2SgKJWmoVQ==
X-Received: by 2002:a05:6a00:3286:b0:725:b201:2353 with SMTP id d2e1a72fcca58-72abdec8856mr47800140b3a.13.1735419522329;
        Sat, 28 Dec 2024 12:58:42 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad8315adsm16517149b3a.51.2024.12.28.12.58.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Dec 2024 12:58:41 -0800 (PST)
Message-ID: <f7be2820-fa37-4276-b02d-3dd00eb464a0@kernel.dk>
Date: Sat, 28 Dec 2024 13:58:40 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] [usb?] WARNING in io_get_cqe_overflow (2)
To: syzbot <syzbot+e333341d3d985e5173b2@syzkaller.appspotmail.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <67706650.050a0220.226966.00b3.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <67706650.050a0220.226966.00b3.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/28/24 1:57 PM, syzbot wrote:
>> Should be fixed in upstream for quite a while:
>>
>> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> 
> This crash does not have a reproducer. I cannot test it.

#syz invalid

-- 
Jens Axboe


