Return-Path: <io-uring+bounces-1929-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D8A778C8EF8
	for <lists+io-uring@lfdr.de>; Sat, 18 May 2024 02:44:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13DE61C2099C
	for <lists+io-uring@lfdr.de>; Sat, 18 May 2024 00:44:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DDDF63B;
	Sat, 18 May 2024 00:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ju15fYZ5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A20637
	for <io-uring@vger.kernel.org>; Sat, 18 May 2024 00:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715993041; cv=none; b=U8Y8jHufUNq/Eu5MCaWsXSyvuFuwDN09uVuJg9Fmyz/af4Orp9SVrn2NzyA6xpaw34NQAHFZ3ScKYM+bHxe0ZT5xMkoOi+VvxEa9YsIjneifwMhLiGM2CYZx9MFbXThIB8hjqA/j1NH9jCVeEaeyIFysNGQEZ8cj6iv8uDc98us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715993041; c=relaxed/simple;
	bh=HEzl/SzTKwTf7Or2AKoCeXgmgIHhiPuMQxOgNpIkBEg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kSKsfcIHWCtuCEJuYOkofOEJ+VUrgIdR4PilMRwAjVZg/NGGsiuwdCazMp5KiTWwkWrTAwlicsayyl7AAcwNRYtnguthmMDtbA7XLCxmwTc0bf8UIGtp32357TdBk1fNP/Thlt9QcF2b32Sbf3+NFWvRxcMqkR+RDuc/79Mh49Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ju15fYZ5; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1ec672364caso2832255ad.0
        for <io-uring@vger.kernel.org>; Fri, 17 May 2024 17:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715993037; x=1716597837; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=63X7KhbC8zJTrca9MdMEbqTlrEgnKSeYAAKo6X6rrL8=;
        b=ju15fYZ5V7rZWpbnQ1JX9PscG/TRJSPMhY8YNBg0FPpYIrHg7ND+tRyhb0TGl4KRvn
         4+BQFtnMarNyBg8NYFz0RU6c8JoZc+LHPJxcg8LVpj1rDdPiId0HeLPo3pGRS+yDgSHv
         BpkcYwrs3fVkn8ttX6+j6mdiibg0mFDoqIcE7aGog42Zv9fYEiQpG5Frm+Oob8fyDNXJ
         oWB4aIcaqUAAxYoTceOtpuAa638onEGg1y+vXXT3bFTzntUpqR1ouaGwgrwqZGrPjivE
         pfgc9bM6Hz3TMDwfX8vTcsOgdJaBLXqWNR9Sm7q+GvduJs4/d1F7cLE1J6XsE/Opvh59
         kDPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715993037; x=1716597837;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=63X7KhbC8zJTrca9MdMEbqTlrEgnKSeYAAKo6X6rrL8=;
        b=ZpzMTNrAO5Co4kUZ7HF60kczhrmHu/ZcgceA7LIDhCgUPGOEMl0sbGHOyYKyiPtXzt
         eYqe65EHk3UV3axN7UOEqZ6769i1HM+CGCfLeFAGPSOp5VTae1cRgAW10do83BFmh8/P
         UNTHjGAJ22TvK34K43ygv1z9zfDK3ZoIDYEb2so4aW/wYRoWjkN3PqJcu4eTlYM8ktkt
         TH1jMEYUZ9Wtvusyqf84oPfviucyiBnUh/sLnnXMy2rbT099BqrHHg55Zhvg20HZ6QRK
         Hsm4IZl8o12HpVz9bsLJULdd8vm/0YDIeKXw7l9vHGu5MiFuyaievDTDujY2LQeJG3OK
         w5iQ==
X-Gm-Message-State: AOJu0YwUITOQ9g1gGl4gAVMaHJowDUQ5bTBxa2M5Ie3MrO8W+1prA2Pg
	heKiGaAP5D8tJnqzzvhrkA1oSh7g9MKVIxgUShjI7ODPV4c7cRR/w5VgGWSRLmI=
X-Google-Smtp-Source: AGHT+IHz5/JJWAntqqik+fOMGriwQkPb0vLE00Lu948Hf2uTDhCLFtbeDyN5vPOg03NQK07O9AKZ8g==
X-Received: by 2002:a17:902:d507:b0:1dd:b883:3398 with SMTP id d9443c01a7336-1ef44059da0mr262819585ad.4.1715993037150;
        Fri, 17 May 2024 17:43:57 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0bf31677sm166548715ad.178.2024.05.17.17.43.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 May 2024 17:43:56 -0700 (PDT)
Message-ID: <fc756a16-f623-4b67-be37-632a486d8d10@kernel.dk>
Date: Fri, 17 May 2024 18:43:55 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Announcement] io_uring Discord chat
To: Jason Bowen <jbowen@infinitecactus.com>,
 Gabriel Krisman Bertazi <krisman@suse.de>,
 Mathieu Masson <mathieu.kernel@proton.me>
Cc: io-uring@vger.kernel.org
References: <2b21e1e5d78c0c34de555e840ce780d3b49f82d1.camel@infinitecactus.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2b21e1e5d78c0c34de555e840ce780d3b49f82d1.camel@infinitecactus.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/17/24 6:25 PM, Jason Bowen wrote:
>> I'm really open to whatever, however I do think it's a good sign if
>> an existing similar community is already using zulip. But as is
>> customary, whoever does the work and sets it up, gets to choose :-)
> 
> Not to be that guy (and I'm just a lurker/observer [for now, at least],
> so feel free to ignore me), but a lot of the other kernel communities
> are using IRC (generally libera.chat or oftc.net).

IRC was fine in the 90s, honestly things have moved on. It's not usable
without some kind of intermediary that makes it work disconnected, and
it's not searchable without having logging separately too. So hard pass
on IRC. I used to use it a lot, but decades ago, and even the use I
still have today is pretty miserable.

> I may be wrong, but I'd suspect some in the community are leery of
> closed platforms like Discord.

And probably rightfully so, but at least we have other suggestions in
the thread now which seem more tenable imho.

> P.S. relevant xkcd: https://xkcd.com/1782/

Right, and not exactly in favor of IRC :-)

-- 
Jens Axboe


