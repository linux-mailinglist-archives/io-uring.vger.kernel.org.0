Return-Path: <io-uring+bounces-10994-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 85A70CB199E
	for <lists+io-uring@lfdr.de>; Wed, 10 Dec 2025 02:32:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 999B130B6E94
	for <lists+io-uring@lfdr.de>; Wed, 10 Dec 2025 01:31:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 162092222CC;
	Wed, 10 Dec 2025 01:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vcWO697F"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB4A137750
	for <io-uring@vger.kernel.org>; Wed, 10 Dec 2025 01:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765330318; cv=none; b=jfCfFRKEfJhW0Le7dVmbTs01M+7hRWhTIcsaLkkGTsquWs4/vphpBNX1AwFr0Zce+iGz0XAXCzu1wJBu0+JMkZRRE770VhS4uY1zpe8gnfI+FBtk8wZcz4w4tAQvNb42qfAYO4I30IlvmzwhmfTHCPLYF5cT2nYkMBk+V/LDvUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765330318; c=relaxed/simple;
	bh=Qzl2+G26+egzW7NDywgHIPdgsSaruQbcND52dODf3n8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MGfbD397VjTIthJ5WJuNeIDHcRQG0HA7c6nFwmhMgGNAgxFRpOr8mUcUvRMlrNCc3niR/BSzLLKwCMSLLeWDxCaAC+VRmnU2YXM0o/RxeXOkmkgApUos91Z4Kfzd86zlkPD7k0G86eNFu3i27MbQHSNqBbxDCnloD5lKDfzFDYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vcWO697F; arc=none smtp.client-ip=209.85.214.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-29555415c5fso72153275ad.1
        for <io-uring@vger.kernel.org>; Tue, 09 Dec 2025 17:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1765330314; x=1765935114; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bADCVXBmULrDifzRYGxN5q5EnP7XKBVKqffCRORME+8=;
        b=vcWO697FfeR9XP3IZLye2h5kDXCOy8u4uaEwWUapyEix6y7jfTcVCAiwDu0gQU/tCx
         n6eKFfZWTp7jEz5ZDIDKdDXUb/tABDWOpV8+KdbA65q9EDo0gxovTwFO44A85J3sYWt6
         mngtreF1nRG3mQ/WGiWI3cXpv8Kjmks4AJNPMjUNDuvGz4Pz7n6ClW3sdv8G3XsJjEbr
         9GPXJH1nkd6qtRraL2jRm9hU59fkLMk2Rd+YYOE4+MCjC6xklg3bPg1YFyD1qNkQbUEm
         zDW/lwDX5wQZEIThCubD8U6HW4JPb3nCLTJulvvgbvwYuYciseZI+UkCgeVg0KXOhsbk
         rplw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765330314; x=1765935114;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bADCVXBmULrDifzRYGxN5q5EnP7XKBVKqffCRORME+8=;
        b=g+u0575vv6stjBC0oVfVKLUF7uf76qEoNImN+VSy2VpsJY3aKd5k/gGxxlwtMJEPqn
         ZCi0Merj6Y6UEX7eJCDbK2TL5kuZ5bL77O5df/moN82INSuDlpRcgcnBqsK41rvvASCG
         o+hDeEYRpQGWFGp58/uyWwGp2RjhKL3EXU6ALLwVSk6MgjQS3SVErif0JR8WGpuoBvPG
         lx12rBcecb57xKfooYg0YuWdEyTNdSA6/mnVnSRQgSMWzJ1KCFeVGvb2kkKxbVkTioqu
         p2iAZgzch/jXqbprriKwNMkVm+Cq1AtgYxuqQdMVRcbedfphcDWDyQHDFs/euYSTN4bA
         QhDA==
X-Forwarded-Encrypted: i=1; AJvYcCVY878bgiaLi1cY5EhFXttn6u2suW+oLKVJ50Tp7TD3DTGRqDir8hOTkq5lN6FIqyBHIooBm9+MwQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyOl3dhmEZfY6S6NbuZ3Xc6Zgits9rQ8WIJDeP+dY/9kRc991Tz
	QgohdX5X5jlC5L2e6Wgbp1G7nR06sLZMUaaUsEuOyEgWnYJhckHDt6KQ1tfFaLgECNw=
X-Gm-Gg: AY/fxX55lQk3ehvi1haJrKZ8UH0uOUWLacgmh4RvwaHkuqBthYKPY41yhNJ26yw+edC
	D/mhBUrtsHxJi4K2xJpy6X3C0Dtcwul2YYxYWoB5/rnu8wNH++nQcy7oqjFrX/KQKo+vd7ZyN5V
	v7l7y2m/1k4ozq4ZsKk6WzoVb56yiwWUnzPz6yuC8tNjGmWwxEYKXzasAPfgN4brx4CqThBQmq1
	e4LtoBl+hdnd3HWehjmNShkjBqyCpJks2Y+MB2GzPH20rPvhfSF2mkB+jTxEG8+UZ/STkKEa3qD
	5etl3MWJ/NvndjpHCJsvWnr2BGhYFQc5lJZ403XD2LS4G9ajXu5U1TX4yYmmsGdjNpj0e8UTfa8
	1ty89Bl0ZqgpCgjLHdCB5ITmIEo3vJZgusc5qaWTbpCj0ExhyUE246G3Z5OKNe3cgDvBNnf+yHV
	6MtxK9cNB32r5iAykcpthzc8yKyiMtxOuinGzlTT0E
X-Google-Smtp-Source: AGHT+IF6FoYEiOVVDWUPpLU3jDJvqNCzpKzqnbeVvQnDEvwsoJDLeiTjGFb0z18Vy2LTN2AqGWN2Hw==
X-Received: by 2002:a17:902:da82:b0:298:595d:3d3a with SMTP id d9443c01a7336-29ec27d74f8mr6124455ad.50.1765330313644;
        Tue, 09 Dec 2025 17:31:53 -0800 (PST)
Received: from [172.21.1.37] (fs76eed293.tkyc007.ap.nuro.jp. [118.238.210.147])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29dae99ea20sm163067015ad.49.2025.12.09.17.31.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Dec 2025 17:31:53 -0800 (PST)
Message-ID: <3c535b4d-6eaa-4c33-83fd-8cce3f62c020@kernel.dk>
Date: Tue, 9 Dec 2025 18:31:49 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 00/18] io_uring, struct filename and audit
To: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz,
 mjguzik@gmail.com, paul@paul-moore.com, audit@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20251129170142.150639-1-viro@zeniv.linux.org.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251129170142.150639-1-viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/29/25 10:01 AM, Al Viro wrote:
> Changes compared to v1:
> 	* putname_to_delayed(): new primitive, hopefully solving the
> io_openat2() breakage spotted by Jens
> 	* Linus' suggestion re saner allocation for struct filename
> implemented and carved up [##11--15]
> 
> It's obviously doing to slip to the next cycle at this point - I'm not
> proposing to merge it in the coming window.
> 
> Please, review.  Branch in
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #work.filename-refcnt
> individual patches in followups.

Sorry slow to look at this - from the io_uring POV, this looks good to
me.

-- 
Jens Axboe


