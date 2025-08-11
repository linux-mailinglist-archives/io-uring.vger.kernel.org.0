Return-Path: <io-uring+bounces-8937-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DF9DB215F6
	for <lists+io-uring@lfdr.de>; Mon, 11 Aug 2025 21:52:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A575B1A23B45
	for <lists+io-uring@lfdr.de>; Mon, 11 Aug 2025 19:53:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A96A229BDA7;
	Mon, 11 Aug 2025 19:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nK/tQIUx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D88A25A655
	for <io-uring@vger.kernel.org>; Mon, 11 Aug 2025 19:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754941971; cv=none; b=UZhHoYfvRVKSjTd8A+xFTxl7BuIVqpLvEiX1k/F2/dxQKGFjjgjOogM+BTSaL5/BGok9tG4vQvAgxsRahNZavXFvtBMF/ou4gAtyEWj89mSWulPiorCuzH0E7Ds/jZaNMyYDQ3pg2AX7gkjTZJrZ8JdgyIPnp5qXUDHOJwWyBOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754941971; c=relaxed/simple;
	bh=3J4hf39N9WkZYQ3OuHg7B9EnwWtZ4jUWaILAPmt/Mmk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ECcqKeww1MOsxjhWdreKNF3AividnkLxc5EcQI8PGN76NXxsYnq3UBmAkMK8yPl+Ldj4nKh2pjiiU3/OHgdNS42Qeb0NfEFjHgbmaFySR57V7U7vP5QB6Q7Px7/HbHe1lagYIyMDPeb77CaAL+ICEgKE3M4ppfr2wS8GNZc7CM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nK/tQIUx; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3e40212e6ceso20235415ab.0
        for <io-uring@vger.kernel.org>; Mon, 11 Aug 2025 12:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1754941968; x=1755546768; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1m66q0fM0VeMd58sXC/PkiRndt2PM+bpxiTzs05zqa8=;
        b=nK/tQIUxXdHRLoQz8HmXUgXe+u6Kmt41a8f1eJQFC8GmMw/vWlUydL0vVSp1+9EwEO
         MIa4X15TDCH0TShxpaJHFmMe6SYUlZ5mijxGtryemZiPlIHWQOOHUhTmvNpouPdqhUe+
         vyuRQUUXnMn94e/zk0z6ik2A5lYLFcUw3SZDe61EBwwDyHg4u8lOUsfo7f/i2L0blIYm
         btr+XQxjbBPpZSjLYohH6LW1YwPex5t1rCKfplomqro+fNkzJKQH+fe3pgCb+EwuGIJj
         XrOZp57jrmUAAA+KuKXIdyNRYfWdZsS/lW5dIx1nhZy1KF2i3QW84ASG0PiMSTQhURQJ
         igJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754941968; x=1755546768;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1m66q0fM0VeMd58sXC/PkiRndt2PM+bpxiTzs05zqa8=;
        b=mPobZjkBuZ87s2eoZ6EwwYq/MtD8AAr61o7TBWlOw/jUD33Ha6gwiJh1zL6vPh1S0A
         iccNmg06SDVbB10e6BlGwOLUX/2jP6iLJhfxxtXFpAhWuO1zkrfT6gbv3qwVlAngswq9
         J/qCqsgVsFJm7z2y7HzucTxvB1+r05VZj6BOk3RBY032AnpYalcDZUx01QSZp/EqUvjo
         HJHITFXDHnfncbQUsQQ8Ga003CFOfyQl3dq/xK/WYCPG65FuCWXJwqXRtqubbQy8ImrQ
         5HAZJfkvwulYLjVdnGimGvomV0ynlJc+aWH3iCY95vDZvU5s12ZPy6XuGAiIOFWMxohA
         Y9Yw==
X-Forwarded-Encrypted: i=1; AJvYcCWNGvRaw6mxn+yHX1NwjEeZaINY0l2SgESv2BuaNIn6SQU2hIJXUhR0PZbwTJ8URwipFqf9e4l2JQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwgH6hmljYOdj52aG9ko9hvw7yFpcIyj94iAHFz6Py2S0hxDDvt
	QzvQNfHixyp80yRa84jPsaKwQREW28JxbM3O52QqERbKeCJR93anKswU5Lo2q9FLemU=
X-Gm-Gg: ASbGnctyIKPml9UlIof+VAPBp2D6bSe0Qx3VlEyuAnuN3j7tAgdieDuLAETZeVJB3lD
	PiuMbX66JFluErnaFfm+Ius1MUkwKCbK2D5REjd8hWyLSOJmJpofygrM5rj6D0gRKr/cdIK5QaG
	EhqvZHQU4FEE+5gXOXqusUmYCSuIrdZQQgKMEmfMAImAXLNOHbZEtrD8azPV7redNur6wywz9pM
	OkYbHGX4efX6HV//XFSrkI63npdF48TBZPL8jaqZ/0qR4al1lDs+ervp1mWKrm24UDWsHo+BdYC
	mQF4ngM+a1E4gdvH3BAMRjbSvg3rxkz7pbxE4oBDtazPmT2R9IrmW+wAU5mj7n4v90M5J0dTov1
	b3zNGXsjsOXt5ubag72M=
X-Google-Smtp-Source: AGHT+IHs0PmXKqLJy0GDWXaGD+BPqU2PH316ln49ZM8SzRwDdhor0dknz4aDGdM4QOlVwpmF3gNAmA==
X-Received: by 2002:a05:6e02:2143:b0:3e3:d44d:4d12 with SMTP id e9e14a558f8ab-3e55ae32ef3mr12016415ab.0.1754941968095;
        Mon, 11 Aug 2025 12:52:48 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50ae997b3acsm2586440173.13.2025.08.11.12.52.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 12:52:47 -0700 (PDT)
Message-ID: <62f9321b-9ab5-4982-85f5-bc386d863a2b@kernel.dk>
Date: Mon, 11 Aug 2025 13:52:46 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] WARNING in vmap_small_pages_range_noflush
To: syzbot <syzbot+7f04e5b3fea8b6c33d39@syzkaller.appspotmail.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <689a4635.050a0220.7f033.0101.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <689a4635.050a0220.7f033.0101.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/11/25 1:36 PM, syzbot wrote:
>> #syz dup "[syzbot] [io-uring?] WARNING in __vmap_pages_range_noflush"
> 
> can't find the dup bug

Huh, did I mess that up? It's literally right here:

https://lore.kernel.org/io-uring/6895f766.050a0220.7f033.0064.GAE@google.com/T/#t

with that very subject line.

#syz dup [syzbot] [io-uring?] WARNING in __vmap_pages_range_noflush

-- 
Jens Axboe

