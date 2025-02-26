Return-Path: <io-uring+bounces-6790-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39F04A462F3
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 15:34:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 85F9B7AB8E8
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 14:31:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33F29221732;
	Wed, 26 Feb 2025 14:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MUqMlJkL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8979021171A
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 14:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740580328; cv=none; b=Z0ANPGx7iGrOuuGR77e6d6u7k+OLDyNVXqSGuOMq8PsBEpR9wTofAqgH6xcdgELaFp1m+x6BeW7ZLfYS1uditEJHiipVkOxReuUNO7DMTNQqJwZJhVmZZCtFgrK1MJc1OrnYoh+Y1dKKHDgfzQp0SbRU3Zmwe0i7beubzAzFkMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740580328; c=relaxed/simple;
	bh=fMVSvdO9Qk7XWWOU/kG7NyzMG+VeN5WdRjOKq8C7m9M=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=jh8j8jHRmEs4TISBhDfU/Dj15B3iDt573CaPxMZbmPkDJ4eLmP9B6HMMgWaNG/UM96Qqv0h2P85+YlULwtUYqIPJpkNZzY8KZprYAv0ulbsDgTT8ZSLt7fvvfT/u15yeCB7Cxjm+Zq/bxZu7QwS+ywye8ueHD10wdd4TYEdj5G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MUqMlJkL; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-855fc51bdfcso31317039f.0
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 06:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740580325; x=1741185125; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=trZK1Q0XJm3EAQhjNCUlku9wqjbsls2X+EuichAbMRQ=;
        b=MUqMlJkLnXRu2zadwbmb28wbke+nzPeyqUKHL4eHpRUy81Szhy2oeYrFFX2Ig/FuKh
         3i0pUJcrUdsCEqZJNGK3OkUFiweEPOVLCeloT/Nvk+Qsmq/7AQ3y3Fr9Vet5orTiFkP4
         CQu2MLeurK2yIGcWNZQlWScGsulXD6gKxXfPDDvuPO69LPx3OhD5N07+feV+Gt9DuH1o
         GTCGKnGUPEItwSzuCc+sp552y2UNpQrWY0icbB6qEU3lgSPBqqlYAoyxr2SxygX873EM
         es6Zvi0iIUXgRJomuSddnLzfbfv+T2a/ZI4W0Hxpe/jHLXVHwaUrpHije/RU1jfAJI1p
         KIdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740580325; x=1741185125;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=trZK1Q0XJm3EAQhjNCUlku9wqjbsls2X+EuichAbMRQ=;
        b=EDLUumD9noLfafZ0cUWCT6DxuVplSNXKazLV6kHXhvshf15CiNnO9jRREEt9NL0VpJ
         dpTc2Wm7645BJQ0W32Hjd5b/K5pO6P+SdOWHrDByL9nwb3sp6AI+VIfSYed1Yoe3WtgL
         FgusieBSuJYhmOnnzpjFvB3d49Ij/YN4+snmgGb18wlqODNqZQ8LiTafhT7Zka6avJrR
         LNGM+R+YbCo5m+76dWMzqaAuhrQSKoNL4NuOQxar/OhXgf60+7zj6NQu1PBFwvfbWLur
         cGh1MC8POwUSKg3bXrQcTeQQm5FWDStBUboa2S6jJEDKoMWMRUFHTGvHaL/ktymsu6kw
         4N8g==
X-Gm-Message-State: AOJu0Ywg5xUJ62lhsqJJni6XxXjYz4RuTUkNckYoUNdi78h/RIwLmQCP
	cNgwgAG9xSsVu5lqbRKeFQHDAc6I4FRsottcISw0UN0kUB3b/w5Uj49ZPeibhn0=
X-Gm-Gg: ASbGncuppgHGA+CsWkeqH0RvkF7T73Nu851cpZK9k+SNZPlrdM1VYAia3kQ2mjTaCfq
	WoUD3tM1qq8eRSln5raD5iYle9hUIOwt+s+nJ1ibk9zyv9p/EuxqDkXB0jH3llPnpXcKbtt8i3P
	cG6kpAd8Sc26tjZXMzao/kNbg7qLFgRr5ELrlxyFJPlz5ndZi0/lzei0nEyQq3volWA66rQxMKT
	afLVmMrsNqELrEITPIx8fu4vjp/C1zHVVNgqWFV/nrf+zmk3ug9q0PBOAio7uuwD/7rtBBoCdIr
	e8+Wdsp+xmsjnGSa
X-Google-Smtp-Source: AGHT+IHabXtiuY9p9FWUehezndCWyS3XMFRLX6LH+PTKhkqUOLGI+DxXj2jxDHmMWTb/jH8LLzzPVw==
X-Received: by 2002:a05:6e02:791:b0:3d1:9bca:cf28 with SMTP id e9e14a558f8ab-3d2c0239750mr196114715ab.8.1740580325652;
        Wed, 26 Feb 2025 06:32:05 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f04744daebsm908534173.27.2025.02.26.06.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 06:32:05 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Keith Busch <kbusch@kernel.org>, Ming Lei <ming.lei@redhat.com>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20250225212456.2902549-1-csander@purestorage.com>
References: <20250225212456.2902549-1-csander@purestorage.com>
Subject: Re: [PATCH] ublk: complete command synchronously on error
Message-Id: <174058032466.2230500.13734000197859662068.b4-ty@kernel.dk>
Date: Wed, 26 Feb 2025 07:32:04 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-94c79


On Tue, 25 Feb 2025 14:24:55 -0700, Caleb Sander Mateos wrote:
> In case of an error, ublk's ->uring_cmd() functions currently return
> -EIOCBQUEUED and immediately call io_uring_cmd_done(). -EIOCBQUEUED and
> io_uring_cmd_done() are intended for asynchronous completions. For
> synchronous completions, the ->uring_cmd() function can just return the
> negative return code directly. This skips io_uring_cmd_del_cancelable(),
> and deferring the completion to task work. So return the error code
> directly from __ublk_ch_uring_cmd() and ublk_ctrl_uring_cmd().
> 
> [...]

Applied, thanks!

[1/1] ublk: complete command synchronously on error
      commit: 6376ef2b6af3bbcb7c50dc657bdfb83aba467aef

Best regards,
-- 
Jens Axboe




