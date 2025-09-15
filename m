Return-Path: <io-uring+bounces-9795-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C8CC4B5851A
	for <lists+io-uring@lfdr.de>; Mon, 15 Sep 2025 21:06:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D6DE1AA811D
	for <lists+io-uring@lfdr.de>; Mon, 15 Sep 2025 19:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 629CE27F163;
	Mon, 15 Sep 2025 19:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NYNN3Ts/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F75327D77A
	for <io-uring@vger.kernel.org>; Mon, 15 Sep 2025 19:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757963174; cv=none; b=gfFcLrSDgElusQY/t3P4DsFsoB6MC1mvi9hAHfMKBSsTynSCkG1hI9/rm4LcReIa7qBOWqRhmOXPo3V1zzwXS/EIOHfQuD0P4Yv8bHyLqxrbHlh0hhV14Mg6+dXmsMQHtcBJsHAYl9BVjywKzhU/ZjgrHUbys0/EVxbDUFe37t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757963174; c=relaxed/simple;
	bh=uG8nC9oDH61dYzrtPeYvBQoL9gSQjgCoib4sR0f3whs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=YFBgKYLiSKWnYFVXAaJhZWGO00pAQRd3mGBPUYYe52oHLM/rx46k2BUG/Ed55Ov98BJDfxVJ6G60gLVQs/wx00EvzTWstHTJzzY/Ed+R04vtSl1ff8EglyWesXMCSS2KLxGwxkyJnTBwwNj91agIO+msnDIJPBlVtRVc26FoRaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NYNN3Ts/; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-424073edddaso6378795ab.1
        for <io-uring@vger.kernel.org>; Mon, 15 Sep 2025 12:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757963171; x=1758567971; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YVh6sd5jyxq/syVYCa2EI7xp2H1Pq0+2Ah4mfKjgzlg=;
        b=NYNN3Ts/Vzg+H1ZsgdHr2dvbyL7CgJpkHNaLVB2rR70gLED2MApyLiZkQ1Ltbw6jHS
         EoqUOdyTST7bRRN75NOm4jxdcMzCAo3ZcQj0kbRLt75YPEB1EBOalaiBOrVtXYUQHMRJ
         DgFIj5uFqQtzHhY0id1xkJTsfkSATYbDFm3la/KdFrZAjJ7HpmtmSJHXbwZAjfgAxE/z
         RvepyobH9dgnxNPjFvUkfR8OijaV7esVqfUHS1HvmJsg+vLh0KuI1f6/+Ypg5T1+lZGc
         NFoJct8gdCUXkNkfjduALHsqIxQMbQrf5IRWlRgz0pw94x3xQWJD31lPZcVMeJooIAsi
         oXEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757963171; x=1758567971;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YVh6sd5jyxq/syVYCa2EI7xp2H1Pq0+2Ah4mfKjgzlg=;
        b=Db1QZpiFr8MScox/VqGEHU9gERCj5TbBwjz6VgycosX/Ar45W6Jc3w+j4rCRxXNyy/
         7Mm0RpxrDJYW1qzRdEXrG3sBy9GXObQRzggkuEbjZSSL2rdGqEdttD9iEaygib+dtZ7R
         oveNJPCjh9xp+hHsC3oRpRlb9z4rJmgP0yEBsHuY3mqJkEfN8WVh2973zVfAxTWxgz96
         sik1xpfvNWzk/res57PTgDLOgVEbwzZzUpDB0fAnK9a8CuXXH2Z74uYAdglZl3pVMFtc
         6kpCrKkE6Guh/nKQ05Bm+84RidEwFrQMXlIeABLSupFRgB/U8gTBwWk/6v4WMqCAeZGo
         Wnkw==
X-Forwarded-Encrypted: i=1; AJvYcCUmZQ2ltZglK6NpQiWSyITKKg3byjC+pAEFByx/NsT4LS11RlQR36nw2RYOBweMbmbNZynCawObDA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxS7E9GZ6bHMtwZLTYYxdFDjvlXduE2HYmds9mST3DHmJTMwZx2
	QkyBmwtfkYwpNQwxHsoyL9Oc4oZr56jrOj7urQB40G3eTjE7siqeZbN8L0f8hLPTEms=
X-Gm-Gg: ASbGnct58eOvYipI9WiYmI+qUebDxEStZoz41su6uxtQpULHs2Cubzlg743zF09wQPT
	j9IsqF4Qd82BUk4IHyPamWTRzIbRkxOJYrOC/MiAPJ9HPZRdbzwmEgK844foZHZ8xl56AUQXFsO
	renpmPraSTAv7S/QQVNU0SnrsWfBhtva0FEbDWkRsI1V2r733DlZpKhLjsMEEaQTB/Vk6aa4Hza
	CUDVr9d7r1HAEeYOerYbX4ITLwHWk6GgQlbXU8cBp+/ZvK4m6CIvFjt4GF+9WkkfAtPKR+vdKpO
	bSuDzKjvJZSqgRR+bRukpxesftTli29JQjEdXJmQnL8WIKaY9uKalI3JQJkZgIdtGmxeyldX9tP
	0laFafrl351RTrg==
X-Google-Smtp-Source: AGHT+IGcYD4IuB/wNW8MI8+e27nl+qICtx3uV3uHHdDP6AqZ/REWrrxVvvAsFfR/EjZbUXKsqyNkjA==
X-Received: by 2002:a05:6e02:4815:b0:424:657:7782 with SMTP id e9e14a558f8ab-42406577ad6mr46791835ab.7.1757963170660;
        Mon, 15 Sep 2025 12:06:10 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-41dfb240f4fsm60222675ab.43.2025.09.15.12.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 12:06:10 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Fengnan Chang <changfengnan@bytedance.com>, 
 Sasha Levin <sashal@kernel.org>, Diangang Li <lidiangang@bytedance.com>, 
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Max Kellermann <max.kellermann@ionos.com>
Cc: stable@vger.kernel.org
In-Reply-To: <20250912000609.1429966-1-max.kellermann@ionos.com>
References: <20250912000609.1429966-1-max.kellermann@ionos.com>
Subject: Re: [PATCH] io_uring/io-wq: fix `max_workers` breakage and
 `nr_workers` underflow
Message-Id: <175796316976.265356.16431775523856266594.b4-ty@kernel.dk>
Date: Mon, 15 Sep 2025 13:06:09 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Fri, 12 Sep 2025 02:06:09 +0200, Max Kellermann wrote:
> Commit 88e6c42e40de ("io_uring/io-wq: add check free worker before
> create new worker") reused the variable `do_create` for something
> else, abusing it for the free worker check.
> 
> This caused the value to effectively always be `true` at the time
> `nr_workers < max_workers` was checked, but it should really be
> `false`.  This means the `max_workers` setting was ignored, and worse:
> if the limit had already been reached, incrementing `nr_workers` was
> skipped even though another worker would be created.
> 
> [...]

Applied, thanks!

[1/1] io_uring/io-wq: fix `max_workers` breakage and `nr_workers` underflow
      (no commit info)

Best regards,
-- 
Jens Axboe




