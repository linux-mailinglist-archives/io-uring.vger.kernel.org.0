Return-Path: <io-uring+bounces-5355-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 434039EA11B
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 22:17:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19B31162A96
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 21:17:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 784F7153828;
	Mon,  9 Dec 2024 21:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1p5T7VTg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E590B49652
	for <io-uring@vger.kernel.org>; Mon,  9 Dec 2024 21:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733778971; cv=none; b=gXL4HCOPVc08Xtx47bQkNMwcf3zmyigFq1h4RfUZll+SaG3624o62yqYO6Rz8j9kppDoqeBiPlnDFPLomhFRnpoW7h+FxKByRIaL34UWWhXmzY9PtmpSY/P/pgUHEkLwHbvC2aspk1N3YLZU6uKcdGZATWnJ2J1WT5jE8nT2A2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733778971; c=relaxed/simple;
	bh=e71bzvWSAy/tCVJZHVAa2ZiVacG6qkebfBnhFiZFjjU=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=jr4e83ABX7LcAMXKPyYWwyBVmRZOKD82KY2ni2Kj+v1d2PEZHDjPrWLGF35vVfGtZnsVQs725aNxMnWHV0qFx+Eqk953Gqghg2VK5AjOEag9jAusUr9C6xb7e+VHcjehiq6SZJTOxwDqumfV6I0iKhZcg3u9gzceB8Ngk14Vt5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1p5T7VTg; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3eb5bd4f9daso606193b6e.1
        for <io-uring@vger.kernel.org>; Mon, 09 Dec 2024 13:16:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1733778965; x=1734383765; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pMOF9IP8EoUOdTpFv1dm+2zvfhVGJ04UhfRGaWmPKZo=;
        b=1p5T7VTg6a5H6/w2Hs8QUapi8tflo/Kmj1VGl74IgHfMhEIe/F1Ju4G/YtO14fBI2g
         sBWyCTB8Ve9wMapM+y8EDOw9jfG3xToDlOKu3EhxFV0oTRnp76Pda/fWVk6MOy/2lvs7
         Ns0ttfbY8h8Ha249/fhsRwNI2y/GEh32ZJNZ862EZLxrPunMfFGATHfSTljMBdymQkrx
         y/wPRJd0IPW0ytc+/PTyMAbLAS9zHjyGRqPIzBOTGG3rqL0uybiMSwz6Fn/UkB3PfESY
         z96sjMg0iZ/EFkwuqbZKt8al/Nzp2IcujcZZXXS7EJVrSDJVVl/5mDJbh0+YlmkoPLJq
         Zd4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733778965; x=1734383765;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pMOF9IP8EoUOdTpFv1dm+2zvfhVGJ04UhfRGaWmPKZo=;
        b=QkC3lELpxSMfO36fg0Uw9kXfxNcxQERO1mEjlLrmbARN77LXGl33blu8n+he8Pv+vD
         jEY9B6sGlJppS5Zb8yLDQrcyxR2CGPPNzhPd5C+yYBD9UvZd7XfBus2h6I5L/FNCRddT
         v8Ht12//oLmdZaYoFwh5EbuAnCtXO8GVvV4Yq8XnTPGbfvKpYJPklsVAW/114eM3ypFI
         ThMH2xuNUgktkwRaNJqbUmvGOCKmgMUfKceeyjcEPR/3EERr1NP5xZ3x6JXMVnpEZQWO
         KnVlg6fgfJanXeMmTTFJGHr3CQpJXIJo+l7CjHkbgj55TAinZZ05MTtDipR9J1VRlDyI
         g/hg==
X-Gm-Message-State: AOJu0YwtXu5Fj4diLH7ohJGKMVNinf9vpprQLl7gUxofKf+PqVGpDYoW
	6WSLFD8KQ33MeDo8T8aGxXLjTf5dSx1HB5L/yseG/VWlZw6XXwciOAgDPGsKYpI=
X-Gm-Gg: ASbGncvYb5Nz1tVhXr4xrWoQXDNr8c1o9BlHTCQ6pq4Ypd7w9awcW7dqlX+Sok0VEuv
	SvdSWJfiP8KDYFz0ZBVZawDUZ8jJd31ToIZ6e6nVPJNe1P7OS0Qv7cT3DQIqIv9qi4dxaaTC2TD
	lmV7/MIHBxLKbRPqUT67l8rkynr0JRhDKjJvicFZK6GpuPjXH7ZaQp9diS5o2VEHhgseB1opjZa
	TQGj/sSqC3qEr8lyY9lQRoPvKR1iK10Mhn5+iaW8c3u
X-Google-Smtp-Source: AGHT+IFtwA6zFjPePk2iNE0P9CmlCjVdWPvrx52YXii9jikvd8pJ7B5026tD0JIRbCI1Au6DOPJoZQ==
X-Received: by 2002:a05:6808:202a:b0:3e7:a201:dc31 with SMTP id 5614622812f47-3eb66e13c8bmr1308210b6e.23.1733778964755;
        Mon, 09 Dec 2024 13:16:04 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-71dfa0ec8a9sm520329a34.31.2024.12.09.13.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2024 13:16:04 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1731987026.git.asml.silence@gmail.com>
References: <cover.1731987026.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 0/4] test kernel allocated regions
Message-Id: <173377896392.323933.10570370010328158212.b4-ty@kernel.dk>
Date: Mon, 09 Dec 2024 14:16:03 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-86319


On Wed, 20 Nov 2024 23:39:47 +0000, Pavel Begunkov wrote:
> Patch 1 excersices one additional failure path for user provided regions,
> and the rest test kernel allocated regions.
> 
> Pavel Begunkov (4):
>   tests/reg-wait: test registering RO memory
>   test/reg-wait: basic test + probing of kernel regions
>   test/reg-wait: add allocation abstraction
>   test/reg-wait: test kernel allocated regions
> 
> [...]

Applied, thanks!

[1/4] tests/reg-wait: test registering RO memory
      commit: 67a8f570f9e14aef41c880d60edb675f4517f267
[2/4] test/reg-wait: basic test + probing of kernel regions
      commit: 30ce99006af9403ffdb84ea31223fb0c13f7612e
[3/4] test/reg-wait: add allocation abstraction
      commit: b526f2354b49acc120ff9abd9cd245ef62f07325
[4/4] test/reg-wait: test kernel allocated regions
      commit: 895b45b59e10b543f5c0b9d901d9f39da7687c07

Best regards,
-- 
Jens Axboe




