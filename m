Return-Path: <io-uring+bounces-5493-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AC6859F1787
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 21:46:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D72C1168BE6
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 20:46:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B8BB17D354;
	Fri, 13 Dec 2024 20:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="EGtqImV9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825C33207
	for <io-uring@vger.kernel.org>; Fri, 13 Dec 2024 20:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734122778; cv=none; b=UE29ZEhuTVf5U5imbua9cM5glr0P5KI739WBHD8x+9qFqmlb+sSChiulLu+Ph+V+NZg2l+MRHHtLggXpwUDI5IJO+vEI0ULEWaNQv2Ib6+GoH5r8FVRCk/uX6T8Fwqf80C/1L154GRbFcGRLb4GraZAbAfC0Ms5ADz6Enz5qqLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734122778; c=relaxed/simple;
	bh=hGznOAEZJoGi6FhpnDxNPdyur4uw8hWg7RIjfScqGbI=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=g+W/Ff6ivr+AlULnrAwtUO8aoQ1b8CXHdB+W9dLKJFwvs0rZXMCYlz7CYrR/1zd1Po+B5K94mz8wJFVLPFdb3lSMvmPoQR60kGmOWCfA7nPbgpzjSh9S6pcEtcd5AXcUmE4mvBy/g+BnM7Sr95XINJFtY1szt8SVm+xm8AeDuVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=EGtqImV9; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-21631789fcdso22496545ad.1
        for <io-uring@vger.kernel.org>; Fri, 13 Dec 2024 12:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1734122773; x=1734727573; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zjn2GxM7KrMQ/tKgesPmA4YSkuJ5TlJgrkuLSxkD3Ko=;
        b=EGtqImV9dYB2z3x3BXTcQJl/6ruc4mxvz9IuekcE0vXFpd9l69g+F6NRTbrTnHXZ/n
         GH6TosCI2sSykVZFh8OLw4s7Hfh9wDfB0Itx4a5hWJawTiB+rNgMQY7PLtkQjTLEbChp
         1ME/y4+cLFSCNGZ2rrtEwSt0CLnHjZ1elbk0nP5voi5+qVjb4sxY8FJvzpwCwtQwiG9r
         RPUJwV3WkbBTKi8BYQH57rdZJImYvXXqFkGZTpA8kSdpW9LFX4bnFt3ji2d/px2ZrrkE
         5d9LdWVRDWGvD5B0b0WcpPxKVtAbKfb14CkjvYr87/wfMvXy1C21udSrHaSdeZf6+wij
         eoDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734122773; x=1734727573;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Zjn2GxM7KrMQ/tKgesPmA4YSkuJ5TlJgrkuLSxkD3Ko=;
        b=gHQXsvtkybZb05a6Gok8lRTlW/ifFVBcxWNYz1dt3mNQal56FGhk1dj3PLRS+ObEHz
         Y2OnxD0SIOcebwVV2W/JXJi1qA01Y2i8jPuRDFI/ncJhFd9XY+sHAhfg9JRZYsunKEHS
         urMTp1eJPwtk7by5X/fT/FDwGa0SyWoaKepNhre7O/oj+YR4xTeZl0cV604h36gNY8qu
         EZSUvfTr3X+ajJSExSZOd3H9cUtyOTiV9fXbLqiMAmdPKqaz44HDdNsIJE75WC3KObaE
         N4dRKAwR3V4aX29YFKO0sSyeRpdcMeSH5YH3aIJrCcBoq83pv2uUKf8REUuZog2G2YTP
         fDWg==
X-Gm-Message-State: AOJu0Yw8GHtPBkqLk1wJwIYpEi7f3kRY0pf09jrNhoXnIci2vccQhGPv
	ADaIPyaU92ZvMR1PX2PyDBkxV5RdMRsjJrt/w1vIVUSjDvfOLQur/dgXZiiJjSWvLrXKprZMb23
	e
X-Gm-Gg: ASbGnctxG3KrlwWxWcLMoB76rRKX7qStTARlcXCqWcMpTziR4XtakchPKlBBNjCux4j
	LzatfcswGunPuc/804T40ozd8zvpqYK7neinj6GvcFNZzq4Fjz6TidtIR7G8YfnVxY1ck6a3Fmj
	aC3Km4q/f7LLmKFQHN2kZpgcanCSTTslrjSNFht8IQ5F6vr7hAhsYhtE2inDs17A+z7dgCRZD5E
	wEK/Dt7uzs1zY4iRSLksc25dhtjQBVw+Lbn0eZtcZ6ZixdTfMc68A==
X-Google-Smtp-Source: AGHT+IHIvDF64auY/0VUb6yKCjwjEjyaFRJZ0k30bXdF/6AB40Da7Wo+LZDU5QJPRDI3pwsi4he5Tg==
X-Received: by 2002:a17:902:e88e:b0:215:4f99:4ef5 with SMTP id d9443c01a7336-2189422a4fcmr56226905ad.28.1734122773539;
        Fri, 13 Dec 2024 12:46:13 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-218a1dcb8desm1837625ad.91.2024.12.13.12.46.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2024 12:46:12 -0800 (PST)
Message-ID: <a92669cb-c413-463e-b2f1-ddea802dad0c@kernel.dk>
Date: Fri, 13 Dec 2024 13:46:12 -0700
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
Subject: [GIT PULL] io_uring fix for 6.13-rc3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Just a single fix for a regression introduced in the 6.13 merge window.
Please pull!


The following changes since commit a07d2d7930c75e6bf88683b376d09ab1f3fed2aa:

  io_uring: Change res2 parameter type in io_uring_cmd_done (2024-12-03 06:33:13 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.13-20241213

for you to fetch changes up to 99d6af6e8a22b792e1845b186f943cd10bb4b7b0:

  io_uring/rsrc: don't put/free empty buffers (2024-12-12 08:01:52 -0700)

----------------------------------------------------------------
io_uring-6.13-20241213

----------------------------------------------------------------
Jens Axboe (1):
      io_uring/rsrc: don't put/free empty buffers

 io_uring/rsrc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

-- 
Jens Axboe


