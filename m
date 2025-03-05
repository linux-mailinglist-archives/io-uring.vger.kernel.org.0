Return-Path: <io-uring+bounces-6968-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A54DAA5029C
	for <lists+io-uring@lfdr.de>; Wed,  5 Mar 2025 15:49:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC2AA1626E3
	for <lists+io-uring@lfdr.de>; Wed,  5 Mar 2025 14:45:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9754824E4A8;
	Wed,  5 Mar 2025 14:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="blp8zjFj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D58248885
	for <io-uring@vger.kernel.org>; Wed,  5 Mar 2025 14:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741185930; cv=none; b=FdF21yQEUyabGFXNaxyJRMFO3qil2AuiEIiOTxqlqUvTTor4QNCvp9mYZ4Hb/xRhOECRAVgFD3d+zzAw0t9jaB/6VHgRm/4xf9jl029K1CVA1f5Js3wzuACAi5zxqRAQkWcaUinhYVg3LFlo+81nS8f2W1kNwWe/SUKLeE7NuNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741185930; c=relaxed/simple;
	bh=gyWV7YvGW+ooACaK5nWmdJ0YTuhR9JJJPh/VOE/DVDs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=sgJMhRrlwBDz53qKCubsuYGOPBqYu/F09MfdfXlDGnbTRyPsrX0ru4kwzBmP+krMMG58QC2n1wDwpWji3lSkexZrH75hC8ktPBdnSDezMpQF3wOINpR5U3SvohXWUWyMUylUw5xapq0VOQD9KEtBYigjjC3Ok+Rf9TwdMQvvpsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=blp8zjFj; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3d04932a36cso68073215ab.1
        for <io-uring@vger.kernel.org>; Wed, 05 Mar 2025 06:45:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741185927; x=1741790727; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z8hx3WPr3Ij6YvWamKNFqC9J9nfj7Y917rEHjG4+YRU=;
        b=blp8zjFjNcAsZTxQg/2ppO56M/QxGyb7M9sGo1v0i0bFh9ticeaZrogKjcIAbjz6ba
         giVAmpqHCae17+m33HEbEQfyMu3XDBmLLChj52BxzwwPYRr/csR9cy/GAWVl33cJDKAQ
         lUnfesGk6Jend1cGrblk3Zvrk0kttZFCo9IJqEVaFv35+zqwxFSG6Dgc0HL5mMKkFCqM
         WYbukYblVI4QVUIjn1s6yBjfyuH8KgD24SovRg721sXl9uVIMHxdw8fspC1OHY7YDTIr
         ekQdexUa38jz70DDyzJKwNNcETnfMJhPz1hGkZTQp2VKE8yNx1pcCTrYoKuNQ9uOO9br
         ROMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741185927; x=1741790727;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z8hx3WPr3Ij6YvWamKNFqC9J9nfj7Y917rEHjG4+YRU=;
        b=mGtUIJ4gMY1MHEVfGN1Q6IMOY3rlUbWq3Gz5I/J9qr7uSPK11Za4zSDUibma+xLDYQ
         lU2fl0fHdDXusrtgQbUKj7Dv5WTNRksSx8Lsv7Bzk5PCnnc9t4i+59NSq43KlbFcXvRI
         rNInPCYdVaZrHjdJmQH4zNxsLirQvJG5ByYtCvH7cnjK3L1seaREXKQ3J1jyzO+TScwh
         cazIEC9R/W2Tvfe8trvcoBo7pDqCur/Px/QkzihKJAWIzkUPtC6u1ChMo2rxx6ExbuMJ
         PkMKIVHx4TgiYKaUvRDaJ5FA5noYEdxuiX39qDKMq9UHxLX0IsPXeMSeMoUpw76ktGmw
         d14A==
X-Gm-Message-State: AOJu0YxXmgTt5u8RsDjUjcOHTBKZVQxvm3abuiAvQxi+69AKUH2S88az
	3Gp+aFe/ZUY+EwaK8fgfWwElNNofsiao+r/3keQCJZ/dfM6R7Ael2Ngl1rQmUN0Y9wadHb6Mbcb
	c
X-Gm-Gg: ASbGnct+QFA8S7N8Eok+6SqZ6uKhp9pFCoqIbEHoP+e6S0orabo8ysEkraUom2iaYKL
	zMauQpxQwdggtKgRgr4iKf7EAAbh2MATrbrSoZa58Hop1VKA6GCmKN7zbQEjWbrDt2xhrRMH+s4
	4LPpcdXy8bH9sCsXVoAO7DNZQKIIUV8T8GnFAAhJeddzxYUcWgkg7q6OdrDV+yORrxgjZ24yfYk
	4DyigbuNTuqBDttxIlKhkU27gJ1nKx2oha0PtTy521hIVQfgpI4nCwcLt8AUnrq5OJdEm5QHXsl
	V0e/4FPwlq/5AokmShDf1okl59URrrzQ99Q=
X-Google-Smtp-Source: AGHT+IEWXGGY/waAyVY7J+OzEL0duzUGaUsJRJKqUSxfQmBXQI5guIsFf1ubFIkjLSp2+56bEpx3lQ==
X-Received: by 2002:a05:6e02:b27:b0:3d4:2409:ce6 with SMTP id e9e14a558f8ab-3d42b881a52mr44547825ab.5.1741185927104;
        Wed, 05 Mar 2025 06:45:27 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f061c07b73sm3585381173.23.2025.03.05.06.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 06:45:25 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250304194814.2346705-1-csander@purestorage.com>
References: <20250304194814.2346705-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring: introduce io_cache_free() helper
Message-Id: <174118592580.8596.405686502009114886.b4-ty@kernel.dk>
Date: Wed, 05 Mar 2025 07:45:25 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-94c79


On Tue, 04 Mar 2025 12:48:12 -0700, Caleb Sander Mateos wrote:
> Add a helper function io_cache_free() that returns an allocation to a
> io_alloc_cache, falling back on kfree() if the io_alloc_cache is full.
> This is the inverse of io_cache_alloc(), which takes an allocation from
> an io_alloc_cache and falls back on kmalloc() if the cache is empty.
> 
> Convert 4 callers to use the helper.
> 
> [...]

Applied, thanks!

[1/1] io_uring: introduce io_cache_free() helper
      commit: 0d83b8a9f180436a84fbdeb575696b0c3ae0ac0c

Best regards,
-- 
Jens Axboe




