Return-Path: <io-uring+bounces-3133-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3979D9753EA
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 15:30:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D6966B267A7
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 13:30:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D90F91A2622;
	Wed, 11 Sep 2024 13:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vA01a1YP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D851A2561
	for <io-uring@vger.kernel.org>; Wed, 11 Sep 2024 13:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726061302; cv=none; b=KoQMAxzZo28NzoARMMwystv6j0KqbF4Z/nWL7m2wU2+ZtXYHBZdaCeUwh0DfdagCt5ZHNLDfliLT5YR1MmwIuS0vHZvWsDhbW68sczZRk5u52JlwEZ6Q3YxPxjdqj3o+Kd3V9bsdjvYVZVkcI4XNiNNte1paIWFEHOcZK1P8yf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726061302; c=relaxed/simple;
	bh=4Aq3EGL6vjZOV0V8QUAKM9cPAmFz583dltN7Bh4jhE4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=nHtHSaxL2MHRabZfXgDa/tZc15kyOBoHYDgctHsXJDgHI2Xx8iNqrvtYxQOXUTJVoIFKNvU6zeOASa4Y5wegy48mikWIzHWzam0yHrm7k+oRf+IyabYiWeXcFSYvIQiXDMAJCtBkD64Y2nvlTWf1K0z4jMZUo08lPEu+P3AaylI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vA01a1YP; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-82cd872755dso183860039f.1
        for <io-uring@vger.kernel.org>; Wed, 11 Sep 2024 06:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726061300; x=1726666100; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bovJNT5vymtg0/+LN4HIO7mrl/RKcmaAfiJmsEEKKg4=;
        b=vA01a1YPMF9acfWLPe7sYypU0acd1YDJH4mJ4byYxTA9SuZLnZDCU0bEGV/C7OgQsd
         xwfZuxJH/QgQGUYhQixkirCQnyuqPwjJv1AlKBdYmVM9dGY7t0oUj152PQfzqGvkcMZY
         oTitwnUyY53Zw/iZdIB7+WLvqzar1hG2TrWaDSUWmtnTtN8VYGsS0uaSQcJgyBpQ+1u8
         4Dx+bVXs1Wj5aT1JT8n0JhJIWqxXzUfsNy+D91Cqgh3KGes3IEN0qQUUpW2B+sRH950D
         H8RZ7ykgmhnws4t6JdEteY3MsvRJr8WWu+cP80JYBWfmb86rlppQtKowM1miJYFrySTS
         Xu5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726061300; x=1726666100;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bovJNT5vymtg0/+LN4HIO7mrl/RKcmaAfiJmsEEKKg4=;
        b=djKyZejuP9F5hiFgEC4pwXDDGj1CJ1vIub17CrEYsgJe3E8VzUAHpOf79lIyLG1VHu
         iPZT1yWaAyoGrK3SkXx/UgoOm6Tt2UvZP/+S+dv8/zJQq6hHWc/WYrozybN1zQ7TMh02
         XrTy5Afd1lpsqAQ3+GrNcNfzNZmZ0tFp2nNdlOXjFRZ74LoB9g1CPpi8RscoDz2L6p5X
         Lq91mrS70hUqBJ/r078CyBOSviAHzcMD0Yx4Z+Jn1i+CHA2B+FYoOIVnSWcaKWq4aZKN
         CCpBf63bmN7P2dZzEmmI5TKEfa6X9NlxcRvseSwwsU534bUXHLq6S5s9xwr2jOaWKx8c
         nzIw==
X-Forwarded-Encrypted: i=1; AJvYcCWwf7/VFwOvbMgXcLkpY3LXFGg73zPnexBHpVrbjPs2jMLGWCnp0rJ9juRmjTaSD67Ub1Otv46PzQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzEQCB8125CKI5+Um+5jnPy1WXKIfw37x3gioim1RkbVUJsuZtf
	NMN6e9HF0dimazvU1o9LTPyAqmFYWo4u4A115RdfEdBPiXmXUSeJkmhnKzEn5bc=
X-Google-Smtp-Source: AGHT+IEEyHDqkjl8SeQPyVpXiKMNrTIBX51J/e+C4e938rN1IJwaXThSnaa6qkQovcsMbydA0TBZgA==
X-Received: by 2002:a05:6602:6d07:b0:82d:754:5026 with SMTP id ca18e2360f4ac-82d075464e1mr586939539f.4.1726061300302;
        Wed, 11 Sep 2024 06:28:20 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-82aa73536fasm263926739f.17.2024.09.11.06.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2024 06:28:19 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Felix Moessbauer <felix.moessbauer@siemens.com>
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org, 
 io-uring@vger.kernel.org, cgroups@vger.kernel.org, dqminh@cloudflare.com, 
 longman@redhat.com, adriaan.schmidt@siemens.com, 
 florian.bezdeka@siemens.com
In-Reply-To: <20240910171157.166423-1-felix.moessbauer@siemens.com>
References: <20240910171157.166423-1-felix.moessbauer@siemens.com>
Subject: Re: [PATCH v3 0/2] io_uring/io-wq: respect cgroup cpusets
Message-Id: <172606129845.167290.7805052336711734654.b4-ty@kernel.dk>
Date: Wed, 11 Sep 2024 07:28:18 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Tue, 10 Sep 2024 19:11:55 +0200, Felix Moessbauer wrote:
> this series continues the affinity cleanup work started in
> io_uring/sqpoll. It has been successfully tested against the liburing
> testsuite (make runtests), liburing @ caae94903d2e201.
> 
> The test wq-aff.t succeeds if at least cpu 0,1 are in
> the set and fails otherwise. This is expected, as the test wants
> to pin on these cpus. I'll send a patch for liburing to skip that test
> in case this pre-condition is not met.
> 
> [...]

Applied, thanks!

[1/2] io_uring/io-wq: do not allow pinning outside of cpuset
      commit: 0997aa5497c714edbb349ca366d28bd550ba3408
[2/2] io_uring/io-wq: inherit cpuset of cgroup in io worker
      commit: 84eacf177faa605853c58e5b1c0d9544b88c16fd

Best regards,
-- 
Jens Axboe




