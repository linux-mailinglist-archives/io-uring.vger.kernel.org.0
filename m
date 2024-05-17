Return-Path: <io-uring+bounces-1927-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A16548C8EB2
	for <lists+io-uring@lfdr.de>; Sat, 18 May 2024 01:52:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4390A1F2217A
	for <lists+io-uring@lfdr.de>; Fri, 17 May 2024 23:52:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C18AE1DFF3;
	Fri, 17 May 2024 23:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GDKt++x8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F283EED3
	for <io-uring@vger.kernel.org>; Fri, 17 May 2024 23:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715989929; cv=none; b=i0AWQSzBLpieN2Ls3mQTMJRXS2bvN4RMmRwE+qNPDkFFvvHJLkzqWGAwOKZb3hyFp2Y24dHGtGU5PDdpNSdMiFBqFOpokX+CZRNycY+cal32roxQ8isC6pycjdzZWTIBfy20fhItTy6fXvS8djgNZvbzqVX34B8AYZ9ezzJ2Fr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715989929; c=relaxed/simple;
	bh=Atw2FKBEG6HR87haZsxnyYjeDbdtA73OpbtDk48nTZc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hWsOVNxf5kztVXi0vgwFxiA8HW5j6oLJ0bio25ieJX/gvsfQ7mHlXKLFZVC4cGPRtpLkESRqvFTyZqVL9cT0hPetO6Mwn3QP2qLdJKRpfzHnNA4EIFrQ3Llzy4GI6wdz90wKkawhiEQsdxpT3ifPUMhk1m4TBD78mXs5aVwqvNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GDKt++x8; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1ece1f3c626so2163265ad.2
        for <io-uring@vger.kernel.org>; Fri, 17 May 2024 16:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715989926; x=1716594726; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pZgiCk29fcmEyu+NLmXofAa9g4qKzM1fvUQ7UWYwp3A=;
        b=GDKt++x85wU65NcNPsSh2XJRoZdjNCs3vFNTBJfHN0AmfQ45gJTagn1PXrdgLxqn/W
         ySIgCFqRg30r4V7B7k0+sQHnRqBqC2043VPZ4EDqNM2bufW5V5W2iXVdaNYfq+xG0LJ/
         MycuPGaCc1hLPNENZMH/9zrvDTb6f6un91X2TdUuRcvTHpJjMEfD+KT3hxHCXqFg6hKN
         +y4FxFy9HR14v5FTZvTcQINaEPl+iOS4N+in/FX5YPmuVfuUTDBlzrnBtRHnO39EDJ8J
         BHHe6bKjhv9/TQSv4FfgnZCL7Si+5k3D4y50gsFVoDVZ3JAh66gy0TvjrljIfuxJAIR8
         Pjtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715989926; x=1716594726;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pZgiCk29fcmEyu+NLmXofAa9g4qKzM1fvUQ7UWYwp3A=;
        b=kVkQJFbfj8QrVuQYmxgwZ4nCUKTYlAPYyouEZK+CefIoBq9AdXHOwEncWoEFHtW1yz
         kAXRl37IiR4Cd/uXQ2cmin0zyEIzci4yGsoPQu41jL4wQEz8Y8NMEUOIyrKWIDXxl8Ep
         8jI9lLkdbpg+HlhX2C0OERr5sZ6WWrbcyPOcjm2jBFoQ8rW+3sCZzIcmxCZkjG4VoKlV
         Bg+dFyLo6N+zo9Y81m+00L5YIqRefPuX4eEE+CbdHCMFynWbOOnywvek6rnRys9k4ZWR
         TVOKvKCK9zQedLF9QnnQO/HORSZJB89dlP61dKYFc7sTkdk7YxEpmnkci5d4uVvOkA8G
         QFJw==
X-Gm-Message-State: AOJu0Yz6FdrolHRLU81QfBr8nkrh9n1RIvuy42KEq0Yhd5ReOqsZ0ADS
	a9tp1AXPvfkcaYgcurHl8eKswpkXAaIHppoH25eEBKmxzZcD3Fvqe/yy1IGyMBA=
X-Google-Smtp-Source: AGHT+IFZ/lYfvuWEHTQJrTKzqNTzVuwjsreat9MGr6UM3aGwe09wyv+CsFfdbqulsIDvZgiapKd2Og==
X-Received: by 2002:a05:6a00:39a3:b0:6ea:8604:cb1d with SMTP id d2e1a72fcca58-6f4e0148989mr25920814b3a.0.1715989926247;
        Fri, 17 May 2024 16:52:06 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4d2af2b53sm15278771b3a.151.2024.05.17.16.52.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 May 2024 16:52:04 -0700 (PDT)
Message-ID: <7605af9e-d99a-4b23-b52c-7eacdd5f59f7@kernel.dk>
Date: Fri, 17 May 2024 17:52:03 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Announcement] io_uring Discord chat
To: Gabriel Krisman Bertazi <krisman@suse.de>,
 Mathieu Masson <mathieu.kernel@proton.me>
Cc: io-uring@vger.kernel.org
References: <8734qguv98.fsf@mailhost.krisman.be>
 <f7367e15-150f-4fbb-b026-73d9407fd863@kernel.dk> <ZkfZIgwD3OgPSJ8d@cave.home>
 <87ttiwt513.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87ttiwt513.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/17/24 5:03 PM, Gabriel Krisman Bertazi wrote:
> Mathieu Masson <mathieu.kernel@proton.me> writes:
> 
>> On 17 mai 13:09, Jens Axboe wrote:
> 
>> Not to start any form of chat platform war, but the rust-for-linux community has
>> been using Zulip for a while now. At some point they made the full message
>> history live accessible without an account :
>>
>> https://rust-for-linux.zulipchat.com/
>>
>>
>> It is even search-able apparently, which is quite appreciable as an outsider
>> who just wants to follow a bit in a more informal way than the ML.
> 
> I have no objection to Zulip if that is deemed better by the community.
> I have never used Discord until today either, and I chose it because I
> had heard the name before and Jens mentioned he uses it.  It seems a quite
> popular service nowadays, so I'd expect more people to already have an
> account there than on Zulip.
> 
> But I agree that being searchable is essential.  For that, I was looking
> into this:
> 
>   https://www.linen.dev/
> 
> which apparently turns discord channels into a read-only, Google-indexed
> interface.

I'm really open to whatever, however I do think it's a good sign if an
existing similar community is already using zulip. But as is customary,
whoever does the work and sets it up, gets to choose :-)

-- 
Jens Axboe


