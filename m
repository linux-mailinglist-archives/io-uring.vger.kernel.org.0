Return-Path: <io-uring+bounces-3112-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C0AF973AAB
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 16:56:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E9001C213D8
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 14:56:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15D6B1990CD;
	Tue, 10 Sep 2024 14:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oiQvIM3r"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4BB19992A
	for <io-uring@vger.kernel.org>; Tue, 10 Sep 2024 14:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725980140; cv=none; b=XKX5KelX8p9g+ctRhtYXKUluhXKbIbHz31mGWA/nYiOqpXNJf1RQqtjZiRyPT+DKs9q8OS3XJOKAC0j420uAO6AwiOhh7h04ydmXBkrILA8Nk0H3qEEUuHRcDL6AZCTBBgk6EJiwr/slEDeR0BGHjRNFQoRNB3BGrTriM7DpiZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725980140; c=relaxed/simple;
	bh=h//wHtXRgtsnucxDoTRJMW20a6wxlz5iZ7J2mRsmAjQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iv/IVvTQvD0JrD/XchO50o4KebJob+pxAtqIN9IyIxykvE1z09/+dV2jIDs/R18ST9CLmJ2d8K4DfV6H9Wq5QXXw3wkr3xeH7YlttygjG8DVHGBVeoMzvZtyhdniieCqL3aIpEG90JJQnq3yeI54huXvLrLyRU5hsbmlFGZ+zN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oiQvIM3r; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-82a626d73efso264281739f.1
        for <io-uring@vger.kernel.org>; Tue, 10 Sep 2024 07:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725980138; x=1726584938; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3Jv69Funzr32cFzMw3DAAVgqxxwV4rEJRwpwk5aDHb8=;
        b=oiQvIM3rfvlGbJ/2JJFPkbukDiasOrWpy2TtLv5AsvGDVsxM0ihZ0O4jY4fHlQvSVu
         l7IgMluN0dhVg1N6j0vhWj2W7KJXYoiMpDlfgN3hBKz6QAy7QP3HVCyghUbxkmm3ojoj
         iU2QYImfmnL2zNjvRjT7nQpG/cYNSTOzlFc0cljD6jaM8sC4UWfQUsmabR4XfOx03owo
         i/QZTaoriv9QAyxBL3Lbg32ouy+pzorv3AD5aIcFCFQJBG4fhV5dvkP/u6rRp5V91/H9
         I0UULUoV7JJ+eaBYIwn5PN/dAihI69w5PphbIY/pVM0bvqrAH/IcdGCWaTOgGuBnMIXO
         8A9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725980138; x=1726584938;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3Jv69Funzr32cFzMw3DAAVgqxxwV4rEJRwpwk5aDHb8=;
        b=VoCoyPXg1jaLC0exQso1vPPPEWuHICNk3OcUAQcmoGl/rS2IfJiLZ8oEStik2QMQtP
         YoHQg6x/8oRP3g41TV5bplbNSetkYECqbzDji61sdvh4E/+bUAch66DrWgFtYFOowuct
         wnqJCZfRvI1FwsKsX+ufcrepurDLOgswpVQh7/DHsMhgpk/enXWOjf2re8eflHDxfJkD
         nGvnEucFsqDtjFl0qhP4o16Ifcu5zJHEyX3sbPE0o9jhnYTVd4njHRPNzAEBPvoyrmqV
         q9ZWTLVp0bNsmhtlFMT1msrq0ImlvYRrkbARGYivHumHRhfYnPNHQ6FVYjht6suoQgAo
         sYpA==
X-Forwarded-Encrypted: i=1; AJvYcCXqRccFzkCuXE2IQI6HqC4aLuKKtzm4Z1f4A/ymig5VsnITQ0AB5ofpVh5yGMQi1F9PN4UbDv9FLQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwYH7j9lmgZ9tjnR16VEkTHiQIETXZyIdG7RWRq0IC/76/XSntG
	BLXYPkKGsLljATPy69TkaXBmLZUYx2gECanZHp89OLKaEiKm4TvgrsavsclXnTU=
X-Google-Smtp-Source: AGHT+IF78iPjvZ2auF59LluRUlSBusRRQ9F/bB7+yzwd4gEwpZtiPuztOVVZuatoClcso9ip5RWRyA==
X-Received: by 2002:a05:6e02:1d82:b0:3a0:45d2:3e81 with SMTP id e9e14a558f8ab-3a04f0670e9mr183027975ab.4.1725980137675;
        Tue, 10 Sep 2024 07:55:37 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a0590161cfsm20423015ab.77.2024.09.10.07.55.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 07:55:37 -0700 (PDT)
Message-ID: <a0480aa7-4be5-49c5-a20a-3bdf936d29d4@kernel.dk>
Date: Tue, 10 Sep 2024 08:55:36 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring/io-wq: do not allow pinning outside of
 cpuset
To: Felix Moessbauer <felix.moessbauer@siemens.com>
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org, cgroups@vger.kernel.org, dqminh@cloudflare.com,
 longman@redhat.com, adriaan.schmidt@siemens.com, florian.bezdeka@siemens.com
References: <20240910143320.123234-1-felix.moessbauer@siemens.com>
 <20240910143320.123234-2-felix.moessbauer@siemens.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240910143320.123234-2-felix.moessbauer@siemens.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/10/24 8:33 AM, Felix Moessbauer wrote:
> The io work queue polling threads are userland threads that just never
> exit to the userland. By that, they are also assigned to a cgroup (the
> group of the creating task).

They are not polling threads, they are just worker threads.

> When changing the affinity of the io_wq thread via syscall, we must only
> allow cpumasks within the ambient limits. These are defined by the cpuset
> controller of the cgroup (if enabled).

ambient limits? Not quite sure that's the correct term to use here.

Outside of commit message oddities, change looks good.

-- 
Jens Axboe

