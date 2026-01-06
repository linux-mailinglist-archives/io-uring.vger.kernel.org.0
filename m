Return-Path: <io-uring+bounces-11380-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B9F2FCF6108
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 01:13:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5284B3038028
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 00:13:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50C4E3A1E77;
	Tue,  6 Jan 2026 00:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="O2WFgBe6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C343A1E6D
	for <io-uring@vger.kernel.org>; Tue,  6 Jan 2026 00:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767658418; cv=none; b=dqEgeuOl5beG6I5PVdJ/gK3qhTVaAT5pVBgzMMUv2owu7C05bgVLE5BzxloP7ehz8mWgedM2mY5sgk+ahP57dGIsMpOxag9orGkle1H5jORi9pR8vLkDJzTp57uXT4fKcJNvagjM+gLElm3uCbyBep16FIUZzQleTScSVyCZlmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767658418; c=relaxed/simple;
	bh=bzGD/PoVdWrENqoxJmIBW8NlnWorYuBKmngO14ELvtw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=WxXs8DzqGPmzHZKCuwdHKSvkCzmJqGc1mUcJrL+o7JMYsI4yO7yZ8NDFbL8fZ1ofpdpCmdI7gafh9ooy8GUAaYcUhM90vxckqkFrgEa91Q/pI9uu98hPmqoAoM/nb1nZlnaCinNhg/7A5Rcu0jo3N8F0UdV/ySQCiDkFkaaaUgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=O2WFgBe6; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-6575e760f06so166708eaf.0
        for <io-uring@vger.kernel.org>; Mon, 05 Jan 2026 16:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767658412; x=1768263212; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R++r5HMNe0fxa2Laucsjc3XFZ4+clmUvVrFDz4u5L9Y=;
        b=O2WFgBe6lVFKWK0qZ465UI/lnNuZj3AMwPH7/rCDF2Y8ubNHQL8LGNKF8EJBMI80o2
         3rQJ06qnFxEPWOFOSonAiMOIuY4CX4ZZaaZa9dduEplZ0CIAdod1HRJFIV8r0dMN/UEo
         0LcN/hA+NX0xClfybbAp1wjkCZc2K04axKsKl3cCU4f0xQAjyAua0oX628+SAtfgtJdV
         T1fuKyCcotJ+rJcBFqf2T1b7Vr4CErZjdtOMqwY5ydOndJkUxLo5c2ShF22EfFxa/pI6
         JIslUfBtJDIKN8oZ3V0VL7vuyM31ycqqSrEyhMegxXhDviORgh5bGiPw1KnUoYNiQVGm
         j/Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767658412; x=1768263212;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=R++r5HMNe0fxa2Laucsjc3XFZ4+clmUvVrFDz4u5L9Y=;
        b=BaYXRV7QMzOyKjKei492ptgoCbRLpmS/bpclfTa/qzI+wnGMufMN0l6ApJXfc2Lt1p
         zJr+B92KuW0YmJzh0gLydpdgxaITdAJdAXVX+ifihSg99FwwYHP241oWwlfrb5JbAQLO
         /fSoXmhYgFUJsgDDKmFFHVuVHEeElODMdRr49ROOSi9++uh5oeoAaRYXAEvrZBLmu7qz
         a28LE15aDdlzd4ZhRGx7YLA3nXnXY5eF/MBaifMCpaqfGXg54D8+k+AMt4YNLAJ6tF49
         55Bvwk4bM1VC90D5lo4LI8UztYu3ucAcdRZ0rWoF4uYsbx5vn2XBQJJDAtFg0CIL1GiW
         GkTA==
X-Gm-Message-State: AOJu0YzVWe9tDEW5qrvhJob1F+vUNPHbOLoPvf0aq/r/KVov+DQoHsL5
	KagUszQcdqEgFPC9X2s9rfLoP8K2RVxJG4SUn/LAQeE7Ww7jOAwT1pSD2uHqHQ4rMAqEjzKqIHP
	Aodft
X-Gm-Gg: AY/fxX7HZmrqkPO78P8JJfYhDBl23y6vxpZHKu9LqK5jwpbb9Fxo48tvYbJsyHfqQcN
	7OqCa86J7WW1+P6A6d+vlprvvkA+114fIz+2miDbFplygCkh8q1jL23t/pp+GYof4nfh93281Rq
	PCVZM5l33cX2LqHNXPk7INGNxPFFcTrqYraisEo+jIPGXYBkudVeRuG80bKxwINCxYkaAmqVd4i
	dtklT7AIuWwqCE8+17SfLPrP5vYyl1JKb4ZHdNVv9XJmsbw4R+Zio8/4yISwJBp8/TBDGVlWqKy
	DhcqUXgru0DFxnFmKT3QEo8BG6J8JBEQkKv2PpMS/ircU9qTcNcTp886GRjtVETlmmG7p1TeNB1
	+Bbvd1JE1DtFDvpB5I6OZ8zoMILlnZyMw7WibrLwilWYNjHEYaoXhTZPuQITpF1B8TyIASBziQW
	czykw=
X-Google-Smtp-Source: AGHT+IG3xq46WWird/pZM/kGFqv/7epMD4Ko9VLQy4TtiZYYQcMbc8/QATyYpCJ9ZKHq4ry30YR7Ww==
X-Received: by 2002:a05:6820:606:b0:659:9a49:8e7e with SMTP id 006d021491bc7-65f47a70bebmr655616eaf.78.1767658412317;
        Mon, 05 Jan 2026 16:13:32 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-65f48bec1c4sm286225eaf.8.2026.01.05.16.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 16:13:31 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
In-Reply-To: <20260105230932.3805619-1-krisman@suse.de>
References: <20260105230932.3805619-1-krisman@suse.de>
Subject: Re: [PATCH] io_uring: Trim out unused includes
Message-Id: <176765841139.656591.6427851835467985463.b4-ty@kernel.dk>
Date: Mon, 05 Jan 2026 17:13:31 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Mon, 05 Jan 2026 18:09:32 -0500, Gabriel Krisman Bertazi wrote:
> Clean up some left overs of refactoring io_uring into multiple files.
> Compile tested with a few configurations.
> 
> 

Applied, thanks!

[1/1] io_uring: Trim out unused includes
      commit: 48ed70131e4f3057f819c848d92fe84ba696e2a9

Best regards,
-- 
Jens Axboe




