Return-Path: <io-uring+bounces-9888-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 705EFBB04C3
	for <lists+io-uring@lfdr.de>; Wed, 01 Oct 2025 14:16:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA1E54A447D
	for <lists+io-uring@lfdr.de>; Wed,  1 Oct 2025 12:16:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E29AA239E60;
	Wed,  1 Oct 2025 12:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="UZScML0T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B83427E048
	for <io-uring@vger.kernel.org>; Wed,  1 Oct 2025 12:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759320952; cv=none; b=gsscWfXjlyTRYJ9OHKNycR5WPtwIOI/sZ0xH+VlV98whwvvKvQV7/MrW+Fd8GNU+hPrhxWa1J1RYsKYjatuC4vuMk4LZX2JSZyQLi8lcGNe2r15WV5A2JKYqE9ypoZrX08toZK4bqjuhzMwq8kj8slx/XFmXx2P7uQf1ibVY6Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759320952; c=relaxed/simple;
	bh=D4eS0UAXAhRPjmktKVXH1VzAfhMCPB15653jG3rSlEo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=HHDT+EXuym12wqKW3eLGLx/bmvcNT0u40JJJiIqApP8EyhJY0TnxbUQ3p8KQiy8bJJ8nIUyl//6x12+q8DWPnknL3ZAyCtGQ2q2niwqt5+/DLWZpNScNmkUdXsHnUuk2j9msf2RlWcrLEdRSa9Ee4z3vpINThVJhrQTMDJBCq1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=UZScML0T; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-42d888f6b3bso2053965ab.1
        for <io-uring@vger.kernel.org>; Wed, 01 Oct 2025 05:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1759320949; x=1759925749; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hzUgE3TaPel3Uu2CLo+G9h59zbRvmZ3+EiFyRKPP8X0=;
        b=UZScML0TgbME7agL604lXbm0HGVhop7tiNNM02sjGzu9tt+TzyNJJOZa3Zb/m7e7O/
         dS0ddam00NLdERpB1b9yFHraZdOaRiAL2Lzl0Ag8rMRwPq2OTvkQWqONNnhmMjVUQenn
         1pUnR3tQ+Ih1WvAXpN9y/ArrLedro6rtJIkilW05UecEJBcEemnjXCh8T6E1vSsp8P2k
         KrpD2mcMF4IlFWeU7vATy+Ws+9t/29OIhwSxbwQbl2Tfq3EBzb62J6pxmmEXjlvgtV4e
         vkSU30grWwKbBW3bWpC0dY1cHHQ1Obsr2RkqIYnMUqCdHVUaOjCwkikXVl11gU4h2B/U
         7htg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759320949; x=1759925749;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hzUgE3TaPel3Uu2CLo+G9h59zbRvmZ3+EiFyRKPP8X0=;
        b=GHCFN/ulH5EPnZwmJ6ZD1yG4rfz78o9bOtfe3uSxtN2lv8EXxpXm5CKwtjQrZ5yJ5G
         9ZIPSbBq6CFIblRpTQ2X782BeH30X7nynanV35CwBF5jgMQotMLv+/j+fCtRNpveez/Q
         vFFrkrSnNwBdZi9paz0e/LcNu7YzTLQy6PJKOls8Vs5TaJYh/mLC1OlCTfCq3S077ZsX
         /Wtt/b05K6Yz3xJYy8/403oNBJZ8NpRo/ZsVLEzh7s+Jc43l/G0bYeXlpBDRXhGv7Pqj
         O11phn5IJrctdvXEtSx3qnQmIln/+nO+0N4XxpYvPJrXwxygFyu5cEDYrJ/0dNDorWtF
         l0NQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDFFy5Oq13YEhr+1LImA9F3n1qQOpYvcehqmB90ihVdYMWKu+7FtWnUXI9JXGK+qaDIfd9IhwD/w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwQqtBAZ3SWtIPMUDM5Tj4iTMJf16BVtCnNu5xFF5iJ9qYzuoXP
	sI4awwxEjRa0ezhvGqyPmvPDPL58xlhk4EVNaQzIFNwNk19Ad+sokowIpYqajgp6I/o=
X-Gm-Gg: ASbGnctSoKXAljn9+UMkRwWI1GTlkFVzBRRUYpsG8XHaE7c8hxOpfBIq8mLB5ARfZqM
	yE22fNP55RF7WVIG7o8Ii2eNLH3xdoTycKhMp1ZxOpCy38J3g1nU6+93/XEt1lTKyo/j5zQbW7+
	j/NwdANl6+VzxoLJaE1oJK9dCGqL4W1eFQ5uP13euzx5cJXRRBtiWbef7ty3qXRfQwB1Ho874FW
	U/TKtGDmJ9ZFO+l0s8AIBeUosVUAsmm+5NhVGcirp/Z+mMScWxwONDxR6BQCsqmW4VJPxlwq3dy
	JSAGgYf1oFjStMd7Vjm97XUUOVJfOJbelbpjMjHldGAHeBmDSgeJpegAuf1pYCHdXtVsTe3ZRtj
	t8eR4iNlBB++c6ON5AL75A9h8OI5okZz5VA2jDf4=
X-Google-Smtp-Source: AGHT+IFL5K6xEjxqKVxGyRG36i8d6MEqFnWhOoZW1S4U1T4IXlDjzCCFfh+I4DePyQIdd0W8grWLkA==
X-Received: by 2002:a05:6e02:1d8e:b0:426:790e:5cfc with SMTP id e9e14a558f8ab-42d815c6315mr52300295ab.13.1759320948876;
        Wed, 01 Oct 2025 05:15:48 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-574656e63fdsm2900937173.48.2025.10.01.05.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 05:15:48 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
 io-uring Mailing List <io-uring@vger.kernel.org>, 
 Romain Pereira <rpereira@anl.gov>, Pavel Begunkov <asml.silence@gmail.com>, 
 Christian Mazakas <christian.mazakas@gmail.com>
In-Reply-To: <20251001103803.1423513-1-ammarfaizi2@gnuweeb.org>
References: <20251001103803.1423513-1-ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing] github: Test build against the installed
 liburing
Message-Id: <175932094792.1251250.7096571794041153549.b4-ty@kernel.dk>
Date: Wed, 01 Oct 2025 06:15:47 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-e5369


On Wed, 01 Oct 2025 17:38:03 +0700, Ammar Faizi wrote:
> When adding a new header file, the author might forget to add it to the
> installation path in the Makefile.
> 
> For example, commit 7e565c0116ba ("tests: test the query interface"),
> introduced an include to the query.h file via liburing.h, but the
> query.h file was not added to the installation entry, which resulted
> in the following error:
> 
> [...]

Applied, thanks!

[1/1] github: Test build against the installed liburing
      commit: f22f2fb4341afbe755870b0e7dd1b680dbb5bb8f

Best regards,
-- 
Jens Axboe




