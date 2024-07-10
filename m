Return-Path: <io-uring+bounces-2486-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CF74792CAF4
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 08:24:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80C971F23805
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 06:24:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 885137BAF7;
	Wed, 10 Jul 2024 06:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZdgWQnjA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30901B86FC
	for <io-uring@vger.kernel.org>; Wed, 10 Jul 2024 06:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720592630; cv=none; b=kdTd9w1L0pZBFTh6HB/h9JqcKiQa+cJgjgBKegYw56frBoelACZaFhhz/C90mq/oUs5jRQrCRuk62RPAQbQdxZmNbdb1F1bPUTLxOv93lcAz7cTdjRBifW6V3V51fYf27YWja3wj1f/M+6R2iHyx7FQMmJVFDTtIQTW0vWlaiA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720592630; c=relaxed/simple;
	bh=2ExBjp6eN3FPXcKcpWWDLscGBWA4b76f/uZOXmim2N8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dHlAAj0bP46zNqcaDybk5cH/9W8xdJG663GjzmRUMThglNkxBs7liqG0KLwamQkE12ixPfNGhQQ9GZRY0hfYy+r7JIxUgJQhbeK2T/QlUAW3tXDVrT9moQunIBLil5/YBV+h/d7ERxpNt2zYL0skKeTw9iZ9jrg/LBHv54i8wXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZdgWQnjA; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-52ea0a4e8cfso492403e87.2
        for <io-uring@vger.kernel.org>; Tue, 09 Jul 2024 23:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1720592626; x=1721197426; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aaMgpjLtshlSuccsY94xnC39ysm4NveDbvjcS0K2xos=;
        b=ZdgWQnjAGAjT0kx2E2RPQBu5buxG4yhUfKycpS8BlYuz8DfMm8xpjPtavV9oWmiWJ7
         gFpkAK4pMqPl4NyE0wKlCX3rUaOpjrHkplC0b6M86/XkeLJbQA17x8wSdUpzwBF3Lv5T
         nCG0U2qweXL4tCO140XmlY/Zh/FjNSCzjBKlbjOYYRx7l7GMzUJ8HCTgSsg+YKGioWkf
         qht0+oYOauAof0vO3vvqVs4AumurUnQ4QL9NXNr/BosL3apVhlF4oetdzFaGF0rx4101
         mG2m+EdCUSKAFhGL4n9PmdFjt9zejN60CEZN1piwho1weWLy/RrgUPLG+GhLvgVKKZkn
         LwCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720592626; x=1721197426;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aaMgpjLtshlSuccsY94xnC39ysm4NveDbvjcS0K2xos=;
        b=xR8wlr7lf/foPamjBLQqT2zT1/Inw7bRWXfTBOtFwb7+QOmkz8hIaqKy0RWCzOb4LP
         4N6bWw6XcQ/gICjlo7aumxFFopiEKvxyx4Y9bEFagbXKr2WsF0SnXJ+AMV/K2tUaUMGn
         40LRfTXX1Gt3W7iOH35HvvJsj6vtJ7wJbOvDT315El4gz+gJhvJbkqcQhpVEmOy3mGoa
         bY3fGssjDLh4WWxGWOxJKsupgpzzEVj8PjUJiI4nZsW5Qs3iY1JjJK5JEiJblXNYy7bd
         3bQDjKbsTxUI2/NdBfWAxwQeFLNL6cKLuN2aGiksK7ek0+0D1deWIcMgQ+gOHDcpC8wn
         MpnQ==
X-Gm-Message-State: AOJu0YxARPB9aGKJfG3PD5OXGWpKVn3fkOw6auqa/LJ6LFrylL0cAtf0
	fePqIoNRGSv4OHyP71r1/BGmhaFxwsSXal0HXCsjGyoD8DMs8vY/dteohYShyX4=
X-Google-Smtp-Source: AGHT+IFlGzk+ziq0kKEQlWJT079So9ORXMEJrPoAk/r5OlFGCWYbLUSqSqXOiUN2s3UKCzBcI1MMzg==
X-Received: by 2002:ac2:488f:0:b0:52e:a008:8f4c with SMTP id 2adb3069b0e04-52eb99fa612mr2239467e87.6.1720592625609;
        Tue, 09 Jul 2024 23:23:45 -0700 (PDT)
Received: from [127.0.0.1] (87-52-80-167-dynamic.dk.customer.tdc.net. [87.52.80.167])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-52eb90670b6sm463892e87.197.2024.07.09.23.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jul 2024 23:23:45 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: asml.silence@gmail.com, Thorsten Blum <thorsten.blum@toblux.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20240710010520.384009-2-thorsten.blum@toblux.com>
References: <20240710010520.384009-2-thorsten.blum@toblux.com>
Subject: Re: [PATCH] io_uring/napi: Remove unnecessary s64 cast
Message-Id: <172059262476.380385.7447707428260655880.b4-ty@kernel.dk>
Date: Wed, 10 Jul 2024 00:23:44 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.0


On Wed, 10 Jul 2024 03:05:21 +0200, Thorsten Blum wrote:
> Since the do_div() macro casts the divisor to u32 anyway, remove the
> unnecessary s64 cast and fix the following Coccinelle/coccicheck
> warning reported by do_div.cocci:
> 
>   WARNING: do_div() does a 64-by-32 division, please consider using div64_s64 instead
> 
> 
> [...]

Applied, thanks!

[1/1] io_uring/napi: Remove unnecessary s64 cast
      commit: f7c696a56cc7d70515774a24057b473757ec6089

Best regards,
-- 
Jens Axboe




