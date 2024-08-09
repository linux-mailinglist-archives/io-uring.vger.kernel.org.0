Return-Path: <io-uring+bounces-2686-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A383B94D2AA
	for <lists+io-uring@lfdr.de>; Fri,  9 Aug 2024 16:54:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E72628156C
	for <lists+io-uring@lfdr.de>; Fri,  9 Aug 2024 14:54:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF643193090;
	Fri,  9 Aug 2024 14:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ft1L96PQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B8C19755A
	for <io-uring@vger.kernel.org>; Fri,  9 Aug 2024 14:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723215197; cv=none; b=TuFRWev6y0J/tNewG9WfS5cpM/b9JNZ7et7j7H4pdbxHk1a2w0g6QPSONuQVYdel8zKint2Pe3h4IG+ntC2qUZKOMnDRAaploZfByA1ArikQOJ6Kv8bYbHFwpc8gNRJA1iLAKlK3YxLeM65gZ9bgSoxkzc8uor+m5gak7AUxoEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723215197; c=relaxed/simple;
	bh=Bh2fMDBqjEztdOwpfHZ23ytOBO3oNUpMDv0ENs/q87A=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=mZvy7JiDslCqTl1e0XTDp6wi3fTeRVLlQDbc9vqP5uTI9KbQMPatMKAuKSLHJj02yPFpsoi3u4YG/ptzJ1aX7NKfxCyVDO4NZa+j4/hwlg65ywDFHhYpSDYwk6wy3m1oQatNbG/Se+sXdG+NDlwq80MLPkqbqj3m3GyjOAC8poI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ft1L96PQ; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-39b37e5f8fdso1011295ab.1
        for <io-uring@vger.kernel.org>; Fri, 09 Aug 2024 07:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723215194; x=1723819994; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bcYrkWmTbfIa4zDbA15mdDV8dBScHHSHm52QwMl52P0=;
        b=ft1L96PQ7Mg3C9HK6ErhOqJlmhpBRad/mfGKvlwr2Kz8mJxr+LkPp+QQjfyoBamkLM
         YbqQGyS19AEkAUVIAQ++3xwAEIgcnLA1DQQc+6v7bea51GYXgC96+scTbuMk0l0m0N2s
         LxP7uXnWzEEdzbjUYja7soSHuCyd8vAj9XLCaNbdH9e6JBFxc/0rCae+4WZWKVfcgiy5
         SiV33P1AtbICuzg9ngjpRMsfC0r7TV85DTXKG5GvWjXK6Co/Rb6D4tTbgsf9vBy9p091
         14PCbjRJexOMuk9AbaASVTxLAlhBSaKKCLsPEi1QvYd9DcmJxpkeWOi30femfnNOW/1U
         iTbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723215194; x=1723819994;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bcYrkWmTbfIa4zDbA15mdDV8dBScHHSHm52QwMl52P0=;
        b=j/OwQq1lK1n5WkPdDlfRqLnkfXsSlJMhc+Dk/PIIECY+DM0sB9rkLf8/nj0zv38ctQ
         GcJWEdvwicdwJXpxvQ9Z/NTF9fsjMm2F4wogmWY76CzB+yc8zf74FO+7KmFO4krizBbS
         KkghV4TMTtlDUXsiATxI4zeSfiTNtmBBmHfhS/sdCUlHYegNjBuKW5KPncFFQWRD2waz
         fzfQzpxWoWPMR7rXE3fX8AU6ZMponY+EvoIDlkPmeWhU6h+hQrKCKCblqK+v2C/ILobI
         e3m+qTqqa0uoI3wCTQZTUbJeS1B9csmXnh+whTKC0Fl+p848wyeUB9VRPmjB14gUstDi
         fMlA==
X-Gm-Message-State: AOJu0YwkH8tuGkWQ73mKi6XIZCHqSU8Jtf6uqLU3IgyOxV6/UWiZikos
	iKTxSzJ8mZMsn5TsesSfSj50E//V27TwapmemXUiV2U2PApUB+wXr8DTS6pXQd83PsZLJ4vbh2E
	Z
X-Google-Smtp-Source: AGHT+IF7mU6YWBZbykFqf9YFmGii0mDNuusdmavPjCEmLZ6NsPxVNWxGtWmLsnNUc3BvioXmGx1ZEg==
X-Received: by 2002:a05:6e02:1387:b0:39a:f126:9d86 with SMTP id e9e14a558f8ab-39b6c22a24fmr14923685ab.0.1723215193827;
        Fri, 09 Aug 2024 07:53:13 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39b4fc00218sm29454965ab.64.2024.08.09.07.53.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Aug 2024 07:53:13 -0700 (PDT)
Message-ID: <92988daa-9b80-4d1d-9433-0f153dc71ae9@kernel.dk>
Date: Fri, 9 Aug 2024 08:53:12 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.11-rc3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Nothing major in here, just two fixes for ensuring that bundle recv/send
requests always get marked for cleanups, and a single fix for ensuring
that sends with provided buffers only pick a single buffer unless the
bundle option has been enabled.

Please pull!


The following changes since commit c3fca4fb83f7c84cd1e1aa9fe3a0e220ce8f30fb:

  io_uring: remove unused local list heads in NAPI functions (2024-07-30 06:20:20 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.11-20240809

for you to fetch changes up to 8fe8ac24adcd76b12edbfdefa078567bfff117d4:

  io_uring/net: don't pick multiple buffers for non-bundle send (2024-08-07 15:20:52 -0600)

----------------------------------------------------------------
io_uring-6.11-20240809

----------------------------------------------------------------
Jens Axboe (3):
      io_uring/net: ensure expanded bundle recv gets marked for cleanup
      io_uring/net: ensure expanded bundle send gets marked for cleanup
      io_uring/net: don't pick multiple buffers for non-bundle send

 io_uring/net.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

-- 
Jens Axboe


