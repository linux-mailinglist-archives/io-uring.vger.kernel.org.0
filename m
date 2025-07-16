Return-Path: <io-uring+bounces-8700-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DE89BB078BA
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 16:56:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD170188906B
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 14:54:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB4482F2706;
	Wed, 16 Jul 2025 14:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uTVHnCXJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201EE2F433C
	for <io-uring@vger.kernel.org>; Wed, 16 Jul 2025 14:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752677469; cv=none; b=CblOQy6BQa+8mtf4gR9gMXGMLP55SqEJ0IJtIxsArWHxSFFZT5dFRqTp6q78M5ka5HQ5E5jiD8sbhXVv3PBbV1cZ7MdMoKC971VFXjdrKqJoetmQubAoCDo8yUcx4fYznsfgbcKITfFtICyT3aIN5p7GsZKo/rOeC4EfElSmO+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752677469; c=relaxed/simple;
	bh=fwbD9UqZsH241N3eR2h9klJuicSlxQUaLnMjsuw1OwY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=e+HTT1lOpedty3CpLn8o07ltDM39mZGALsrmn5yso29sj3kg7h5W9KhnugMWUjByd7Ln9s6BupEqgrVoVQ3LMIe8jC9J9wxTkQoogw6GkgBDmMN2q/BP/NuFNe73bBcVIocV9gRhIWOavrgpNMpjrjE5cteP684j43zzGdIr8wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uTVHnCXJ; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3da73df6b6bso25368125ab.3
        for <io-uring@vger.kernel.org>; Wed, 16 Jul 2025 07:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752677466; x=1753282266; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VwbU0q/ifd6FalZH5HEq7gHegG0B7AyE43XqSR/SlAs=;
        b=uTVHnCXJ5apqSXyWebs2aoGJqb82KYo9Wm80Rmlql7+xSlqwt3D+jkB4vZmzHkubEv
         TUbEKRpHtCiiQSwl04UjvaXosbXD5fJx7D5njMS7znsIEATmXvivhFlumKWoT8l1IbVe
         KbotzRNKhnM62IASqGTLLJ7UmwTjp6YN/ceaLyKVe8FkOQBgyEhQukKtabEruIK882eM
         UJ2HAONUvSSFzseAaReuAghB7+139VupBpMJgeMYMEZ7rqmAwWUuU/GO8I46Z8te+QV/
         yo0wQGDwH4bjDXNMR/X5ec0snRicAOWYeY5ALpWo+pp8+ikbWJh37kTXYDspxjnfsDBT
         wOzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752677466; x=1753282266;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VwbU0q/ifd6FalZH5HEq7gHegG0B7AyE43XqSR/SlAs=;
        b=kSIlkbVf2hGEJTQASZxTGo4ara9MKTAhoN+RWXY5KCcj9gnO2R/Zj54802HZFsOwTB
         IzAga67nMHp9kZg6syKJDEjW6XwI/fWGOC87/DoKVbHYbDkexzPGeKKkkzu8alApNVG3
         s+o0pskbaNUxqHyVK3o7sKkkArDbwlMHsT5AQJ13nCIPzE7SWtFGw/OD7wbqyqJDkY+S
         kud0o3x87Kf7kpjoM/o4bdb/3WziEpvKXpoeNc8oFM+PSbhBuHhdq9brWsdZqwPsM4Ez
         3k/69hHSIDVnv8IH2eVTRanUBLYrWvkqFZbAEgcq/Qod9GC0fvrkP2IDal+1NQ8fAB2o
         FkSQ==
X-Forwarded-Encrypted: i=1; AJvYcCXWUflXMhYJ1T6IM/eOf4IXyly+Wpsf5Wk8fWsP0DRGXSyboDFGV7oqoNtucalorQJl9xgQu24jiA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzkU0XMkC+1DkRki63ktjWXH7N8WUQ911zFbgetg3PVzgeqlBT1
	RJuXfZChZ7GpMGleCz5j1XJfUFHhRmkCz5gXW036O/qCc7M9P4b55XmiaKO9Ib7zAmI=
X-Gm-Gg: ASbGncsvSRJnyGYjQr+NiLE86Zde2t6pbQnOkCymZHG4b3N7C19cha8SiIIL6HCVTKE
	SsKAyVwnjW/xH9WvE/66gQoE4rIAlHsH95kpTBPKg6yGUrJh7ZfwG4lo+0rL9Q6M/61jgw2mYe5
	KE9tb3x1nU1inihe5Sh/TUDthzFWitOFhiOu1uTQP8BXcbQRiadWsgyuah/Ahm7l3UdibCKSVTb
	Z8aO5SLyU2d//QtM51jPSngxcl6RV6AA6P5bi/P+kJR+HHlcXdM8gR4MccQqM73uPXTR4l8qPRN
	aPSxPs7AJwijwBTni3zEpYyMIeTjipGetC3nCvmdFVIlxfqkE5e4JE9vQbbZNH8u5KOUjQ/JUHP
	UY1PCll63cVvw6g==
X-Google-Smtp-Source: AGHT+IHP4Rj05mgTi/TM+2sWnURzVs9GTrIAvMAgF7z97LxxXL0q66/VCKY85ikZmNl1jEito3jg6A==
X-Received: by 2002:a05:6e02:1a09:b0:3e2:83d2:8b08 with SMTP id e9e14a558f8ab-3e283d28bb5mr23221745ab.6.1752677466082;
        Wed, 16 Jul 2025 07:51:06 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-505569d0e4dsm3011781173.109.2025.07.16.07.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 07:51:05 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>, 
 GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>, 
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
 io-uring Mailing List <io-uring@vger.kernel.org>
In-Reply-To: <20250716144610.3938579-1-alviro.iskandar@gnuweeb.org>
References: <20250716144610.3938579-1-alviro.iskandar@gnuweeb.org>
Subject: Re: [PATCH liburing v3] Bring back `CONFIG_HAVE_MEMFD_CREATE` to
 fix Android build error
Message-Id: <175267746483.305834.15435352691107984360.b4-ty@kernel.dk>
Date: Wed, 16 Jul 2025 08:51:04 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Wed, 16 Jul 2025 21:46:10 +0700, Alviro Iskandar Setiawan wrote:
> Commit 732bf609b670 ("test/io_uring_register: kill old memfd test")
> removed the `CONFIG_HAVE_MEMFD_CREATE`, which was previously used to
> conditionally provide `memfd_create()` for an old test in
> `test/io_uring_register.c`.
> 
> Reintroduce `CONFIG_HAVE_MEMFD_CREATE` to resolve Android build error
> caused by commit:
> 
> [...]

Applied, thanks!

[1/1] Bring back `CONFIG_HAVE_MEMFD_CREATE` to fix Android build error
      commit: bc8776af071656b47114d777b56f0e598431cf5d

Best regards,
-- 
Jens Axboe




