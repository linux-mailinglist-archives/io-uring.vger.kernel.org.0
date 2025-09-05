Return-Path: <io-uring+bounces-9606-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 793F2B46393
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 21:25:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40DEF5A7333
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 19:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF4D6279912;
	Fri,  5 Sep 2025 19:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X2XXkTkT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D38278779
	for <io-uring@vger.kernel.org>; Fri,  5 Sep 2025 19:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757100265; cv=none; b=Tfn3pIw0nIbn02sqgsTx5fBI9aZ49P0mTN+OB0j97gn2JkqtcbOv1AfC3m7N5OL/FSfkr03rQqivvm6a6DF8qKBPSHWog2LFqSbMfNpFmf98XIvoKWpYhKnrxM9ENDP8kBmdX6FaF+k3JhY3bV63AYrB+YlVXdYB+zxGaF5UNYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757100265; c=relaxed/simple;
	bh=YQgaFRVScBR8CdN31XeTpzd8Co0aGjdN2SIVDDdkZYI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ufHxU19SEe2uvScaHAoRVbLP6X0J5Bt3v7KZx0GdpF7ZiVHDg/cGkDNw/gPtdXuVJDqfgFmWRHDPPy1r45DqikJLBwxp066I8qVk1mgkw9a1+DAmxLwUzZ4g0ruIpD2FqXylW9st+DVJzfR5+8jA52dy0ZL5EwFk362z8NJmrIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X2XXkTkT; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b0475ce7f41so473646466b.1
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 12:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1757100262; x=1757705062; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LraTCc7ZDr/qseb9fCpwX5ASeZ9pStoMGqMFLaHyNCg=;
        b=X2XXkTkTz2D4DLIFr5YoIIANQfkk3HUvbEhe79OsHkP17feDzSLfAI4jOeboytxb2X
         Y6kLC3WJEifzKh+gcJzWq5wwCVf4g9dtd20xTCtv4O1lJjC2PlYNk950hfHIY9Qm+iKz
         5QHQGUeE8+Akg4BhJTuAE3C+/tD7p/lDt7cKY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757100262; x=1757705062;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LraTCc7ZDr/qseb9fCpwX5ASeZ9pStoMGqMFLaHyNCg=;
        b=CwWsTrf0UMZZPE9ycls2DMydd+sJuMviggtkkI/gzPjELCSsuCIEOrfmaAUA/AkX/h
         l6XHNuVQuSu3l/HyeUEE9OL+4n5uh63Jf8tEvKdUGeqJO3YU9mEqpwgfxqMiSa3RiDpo
         hRj6wzfMHQ3IsIeDeJu+CNMStZ2erKkrNlcBLKlFSQ5Spp2coO9X3RGzlujetbk3n28n
         +GyJGStDuM2UJAslUOnN1nypWL1jRle+VuMA+BDlJB1bwriC55x0oN94a4GxOmocY0BL
         YEK1F8RJGD80rKfBN+GVugMXaXPGyTqLCeR0wVXjYHzxWdz5XxX5E6ZUV9xBAxVgQiRM
         B+VQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTa9q7ANCE9Ji7sejOfjoZVtj8OrVaKR4aQyHaJasg2yL6Bdf15c97OfiJf+6VHLXvIRuHBoHDYA==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywav2Hdz7Fu5MGsaBmS5INmSMzseMyooVSGXi1iYqtJ2EI5Y/ZC
	vHEoH1c63Ou7ZmfhySfSl2oclHULbVwaGJjNz+uLT+1in953jk2bApaSL5t7eAwXCFDLN6Syg5e
	Cn8xJh58=
X-Gm-Gg: ASbGnctRrm4dwyiI7XkeRA7PqRBaTEKqNAuKrYzu7RGNvXFsR6Dbo7dSPLbGaH7fYeu
	xkFpOsE0Z8tI4zgsNfJYAxoZagw5xKgcSECHHOx/n/YyqJqcFfTzbPsLDu32MjGGZBj/HEgbB2R
	wjb2iWwo2fCBdMkAGDx/XDhEkc8UZlxxujcNpSl00vkWl0W6dH5+ObDyGVWnLHuIk71jDQc6VFN
	Q3/iuBXWJBAsJvblG3N1OBWiONFMWfg2wmUcyRrF3nvErUaH8dsX4Ib/HoBYLyEWYDjfJcyFABu
	ECM/mUqODXVKxetIQHJj80M6JJhdpQst2rZHlksK7XfAz6kelUTjf1sEkxflvAohhXlVsuIVQdD
	s8jUOYFNkJRw0ZRUoB/Eebmmgcp448FQ3R0a0bS4x/HpuPhk3hXs32jIFMaM71ys9ME9wpuoZwY
	Y/AxmPnXf9rAhuTsPJ/g==
X-Google-Smtp-Source: AGHT+IGybl0JZ3MZP5VffIshdUipe0lGgY87QGKqM7XZEd0QwzX4s8W9/87AhWt58Zk4weGQOL2E0A==
X-Received: by 2002:a17:906:6a0b:b0:b04:ae7c:703e with SMTP id a640c23a62f3a-b04ae7c786cmr37236266b.24.1757100261614;
        Fri, 05 Sep 2025 12:24:21 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b0431832a98sm1248514766b.80.2025.09.05.12.24.21
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 12:24:21 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-61ce4c32a36so4765460a12.3
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 12:24:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVGx3TJSaA1V3yLwpxZ+69jXdbRpchjBN0aNH6ux4a6dGMrgG6peGx5CpPIEayhLJRvgUNbop8UJg==@vger.kernel.org
X-Received: by 2002:a17:907:1c1a:b0:b04:6338:c936 with SMTP id
 a640c23a62f3a-b0463391027mr1285634566b.17.1757099773481; Fri, 05 Sep 2025
 12:16:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com> <f0f31943-cfed-463d-8e03-9855ba027830@kernel.dk>
In-Reply-To: <f0f31943-cfed-463d-8e03-9855ba027830@kernel.dk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Sep 2025 12:15:57 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi-jomx2=9jRbUz0F_AQ9vKs2uN42mPsEurYNQsUCJn-w@mail.gmail.com>
X-Gm-Features: Ac12FXy70hC-VxcARa1uOiuMe7T-lcPrYf6omHFP8_0CpXkjJOQa0QTa_RFLw8A
Message-ID: <CAHk-=wi-jomx2=9jRbUz0F_AQ9vKs2uN42mPsEurYNQsUCJn-w@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fix for 6.17-rc5
To: Jens Axboe <axboe@kernel.dk>
Cc: Caleb Sander Mateos <csander@purestorage.com>, io-uring <io-uring@vger.kernel.org>, 
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 5 Sept 2025 at 12:04, Jens Axboe <axboe@kernel.dk> wrote:
>
> IMHO it's better to have a Link and it _potentially_ being useful than
> not to have it and then need to search around for it.

No. Really.

The issue is "potentially - but very likely not - useful" vs "I HIT
THIS TEN+ TIMES EVERY SINGLE F%^& RELEASE".

There is just no comparison.  I have literally *never* found the
original submission email to be useful, and I'm tired of the
"potentially useful" argument that has nothing to back it up with.

It's literally magical thinking of "in some alternate universe, pigs
can fly, and that link might be useful"

          Linus

