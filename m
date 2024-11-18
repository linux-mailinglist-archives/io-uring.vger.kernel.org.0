Return-Path: <io-uring+bounces-4776-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 64D189D1519
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 17:11:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1CE621F22C9F
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 16:11:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B75D1BD4E1;
	Mon, 18 Nov 2024 16:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HjCNVIq8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA217199EBB
	for <io-uring@vger.kernel.org>; Mon, 18 Nov 2024 16:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731946291; cv=none; b=tkvrU39xVvvc/D9FNTOsKnVIR4N4nEewFx6UmWkEFG+OiAs7wd0STacWRUlqTnrZm8uL4NKH4tmBzeMXBpnaEgu+2CWcR7tALKW56ri/AyUoQY2lATXsyF+ZEeOh5QPrYv7/NwTS5XVAYwfIGYmYoJsalvUD8jt8qChcgY0O0GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731946291; c=relaxed/simple;
	bh=/lZWK152fcgoe44Gto2RmZI04kUUs0oh56Ig4zh1AkQ=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=uJtfz79zbiuYgAFQ7dG9xwr8zPlsbJiUkQIgI7RB/TH/2PK3+68dWjrf1yP0PMjoLkzFjw7OCOBiHTE7IchT6zPBHiw86wqI0JARReZF4ceFunVS8uSSXSe+tLrprnwSaHGwE04C25KBG9MW0Fd+qEqcbPesVC77EQ1fbwVw6Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HjCNVIq8; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-296252514c2so2825887fac.3
        for <io-uring@vger.kernel.org>; Mon, 18 Nov 2024 08:11:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731946288; x=1732551088; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fg53EyEXJW5+0jXepu7VALIadcyOsdJX30eT3TNMvPo=;
        b=HjCNVIq8GEJjWB+jtlR3kU1aKkb+aJlISMu2G2lna0Vjvx812Jt2Fsn8fvMZSB8Rh7
         iPncb5NbJrUPib9NHpPLPHlkmn2MpB6IO1Xx1nrNoPmQ3JRMcp++SrASwGn070OPBVKC
         pD1Jx4v6Gfo4dXydx+FnkUNt/R8YkSiix2p9u5zaY0QpLAZlcHjb7tTuI5+5J6hCJf2a
         8hn6S5GUcyytZtb8/hD5lAft1FlmhCy0YSAxxHnExm1XMjk1N6Y/t7eKVjITSb/m7sOX
         6mupaa1ZLhxetBdusuoWIeTSFB+S0TBKoIQMbhcvKw5zjFUbozG+LMXguFlI7NLFviTi
         jSPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731946288; x=1732551088;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fg53EyEXJW5+0jXepu7VALIadcyOsdJX30eT3TNMvPo=;
        b=CPh/1zY+NhNXSlqDekWgAKbpHRpJ6AJkP0Z1qWhMujqBA/cvttJJPQPdD6hntR7NoH
         PpoThFr2BJLUPea9cYVsxWgE9hgJ7rEbgET+gBwZQfj5NNMckjo0hd3Wl+U2bX/d8FXE
         s+gXDgIYcG0xuFyNP3DbmvCzt7LTCTlEpuRbeV/Q2e6Kq40A68X4y6YGfU0CJOSROkjw
         KVMfzLyW7ZQFNC4U8UOGvi4xP5qDeXe9R+PYNCS8ABgDOfYTTMki967BfUyxzODEo2UG
         nB7gRG0l4xpQGMwqYwGvXsFATMyKoefTCyT9wt8MDS07KSAIINmh8+L/ppyL5YI4yM/c
         NMxA==
X-Gm-Message-State: AOJu0YyhOYtcxRNU9BEo+mzWbOs3LEpqrtMqT548DZTMQNRyqa/dftnp
	Nm1DpRyE91OlWld+wi0yOnjQwo7GY1QglSiP7X8AN84ZAX5Rz1C5KV5rpo6+Ld250dZWHEanVvw
	zv9E=
X-Google-Smtp-Source: AGHT+IGLzvMDCsU8r3WsJjGjsZIs+KyphbM/TvUgUZjK9/ZH5DCgtTga+t0eBKMf26L1ZfYzUCcu4g==
X-Received: by 2002:a05:6870:8290:b0:288:679e:ca8a with SMTP id 586e51a60fabf-2962dd77a32mr10353697fac.18.1731946286506;
        Mon, 18 Nov 2024 08:11:26 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-296519331c1sm2676223fac.23.2024.11.18.08.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2024 08:11:24 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <143b6a53591badac23632d3e6fa3e5db4b342ee2.1731942445.git.asml.silence@gmail.com>
References: <143b6a53591badac23632d3e6fa3e5db4b342ee2.1731942445.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: remove io_uring_cqwait_reg_arg
Message-Id: <173194628425.10763.6496638613974421744.b4-ty@kernel.dk>
Date: Mon, 18 Nov 2024 09:11:24 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-86319


On Mon, 18 Nov 2024 15:14:34 +0000, Pavel Begunkov wrote:
> A separate wait argument registration API was removed, also delete
> leftover uapi definitions.
> 
> 

Applied, thanks!

[1/1] io_uring: remove io_uring_cqwait_reg_arg
      commit: c750629caeca01979da3403f4bebecda88713233

Best regards,
-- 
Jens Axboe




