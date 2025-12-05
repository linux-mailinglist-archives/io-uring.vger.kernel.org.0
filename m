Return-Path: <io-uring+bounces-10979-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E8AECA872D
	for <lists+io-uring@lfdr.de>; Fri, 05 Dec 2025 17:58:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 21A40301C3EB
	for <lists+io-uring@lfdr.de>; Fri,  5 Dec 2025 16:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C349326927;
	Fri,  5 Dec 2025 16:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oM0ODan0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7DA2DEA70
	for <io-uring@vger.kernel.org>; Fri,  5 Dec 2025 16:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764953580; cv=none; b=AMnQvYyRSQY+oER5ty5uD+gbbEip585ucg/PXKCvQpovlVo72r3/ZdYBo7TF8JaHt9nTvglGWMoWOW5C516/UyTkYCmrNi7JsocLLkIPWoAiSWiS8GAzGEPUs9nWAVx5dbMBTF2vJNlkQYwDR51ue48jIuVNV89WIyiVm2WTZnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764953580; c=relaxed/simple;
	bh=+g6uqAnbC89NpMwdDhzAjO8+Gri4EzCzfdoe7GIPweg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=rhu0WCFPS6EnXsP7aNZi+gO8Gzb7OPAjJo/SLoAGLwH7JEiGzDFNeHdC2Xa77EqwyKYirVK5kgDrEKE7Tss+EKn/P5QgqBGGuHgItxQq/8+S/B4WLqZvN3GEPI11cEEk6gmb70XR0H2CJFxvXIDIprs3MIbChqsL5hIx4Isg5To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oM0ODan0; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-3ec31d2b7f8so911133fac.3
        for <io-uring@vger.kernel.org>; Fri, 05 Dec 2025 08:52:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764953572; x=1765558372; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w8SKMX4ybu6h8zNWUZiAOTt8fMQRkTvyjaDYjeKxvBA=;
        b=oM0ODan0DI8NIAWlHClSnAM2R2TJn+/0hXp+/mwVtOoeoj95s9j+XxOOt2UjxEXuaI
         HvpL4ywfkZ9dKDDArA17vLMyXsI//D7+hnAavrShvOgmvsGUsAj9UMEFdoVAvFhvfBHZ
         9Hhvn5Qh3hQGGNj6XlelJXOyGwbcHWXGOlYu3BhCRGfLbX2SGg41ifT0nO2TweDo9sRi
         xgB2YMufS1XXYgbh+rFAAQpeGHFj8ptiY5POudwPMgG/qc+UO8y33bsEIMjiWq4DyKtX
         CCmL1DRQYkS/McUWqEoM872HQIeMTMurOy7WGRqBbCG287EVYp2pUfpAcbX0bME7uv5L
         cCnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764953572; x=1765558372;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=w8SKMX4ybu6h8zNWUZiAOTt8fMQRkTvyjaDYjeKxvBA=;
        b=P/LdXiQfkVSlWnn3ZTy2z87forEKZmMb6xQkQLz4Up6LmX6DMMSFATdFyvBib8tyEQ
         FE4zwpOMfVzOfY6tSDO1STY30cfud2aDzncBRs2sHrrY/r105m1KOO0+iU/UUJRmnZfO
         JEf1bmm1awRr8mBT92Vtn9AWE/6pQMOeYp1+BcyoWHbs4mNs9RZTFHHCnATnVXU5WJd6
         IOgWsNfIhNSkNukkHhS6RGh89myNXag00jBhhetur5zzRzZbnxgxlEoytffAI2MPzUX2
         Dqvulaa2YVrcN9ooKrQTkUM0dgJDzSUgQPZ3XO2s45O3G4SwSQJVbDnoFHvoStEZ75Cv
         kUnw==
X-Forwarded-Encrypted: i=1; AJvYcCVerFbDVGTUgvNXamFLvJCFilI0SNOtTsJRUcEL2jG3WWWarPwvrO1UXLvOlmhuZ86xb6REV7ghrg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxlgP2DguiTOBU72k00B5yROpH2bdF+0KEcFzfIsgXndQQ1cteF
	8ueWgJS39gCG7PLbTIsoJD/tty2H7XhwiRooNdFt28vCHJkKYexaBhC0pnHw/sUbk+k=
X-Gm-Gg: ASbGncs9wmTjdU0HXg1mvHb+xkiRY0lEsKemRiaINF5XjvBNAoMUZO9LBdlecm3AtF9
	+NrkvV6/hoxS9Byr5aWO+symaMrOP1aDFtfqS3oztaJWIfLHUg2afpqjuHqEQi8da0GXTKh+1b7
	zzGvi7r6ozigjNEDqAul601MCj/bET1oQlw90wS6/7/JBxEvk0y1G1DCWWYCqgGlKWMtvQaW83j
	/NKbYBfe2fJePmb7YQYpIVD7GPAfU0jF97ZeknbECVGZct3VThLPlGVrNhaTBDtVzBDDqaLru/A
	ZFyDovJGr6OW53OtOm6OqG44IOkJL3LiMVO7GAiQui3CtwWs1M8yZ4UhwHq937XfMHgb7RkUIK9
	2NXRfwfFvB25x7Y+/tJQa/IyrCLAXIu8VPENI8Q3TpGMq3IcNboyqPi9d/+zAPb5f83r+QHUBuy
	vVtQ==
X-Google-Smtp-Source: AGHT+IEevaXi1fBwIlO1FuNasBCIdcVM8uEAdbLWI97tIfwz0yxjFCAJXCYW9nxOjHXEQj4a/NiXeg==
X-Received: by 2002:a05:6808:15a6:b0:450:125d:d9e with SMTP id 5614622812f47-4536e435c75mr5974098b6e.21.1764953572537;
        Fri, 05 Dec 2025 08:52:52 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6597ef0ca05sm2398649eaf.11.2025.12.05.08.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 08:52:51 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: csander@purestorage.com, io-uring@vger.kernel.org
In-Reply-To: <20251204235450.1219662-1-joannelkoong@gmail.com>
References: <20251204235450.1219662-1-joannelkoong@gmail.com>
Subject: Re: [PATCH v1] io_uring/kbuf: use WRITE_ONCE() for
 userspace-shared buffer ring fields
Message-Id: <176495357153.1162213.11911701547224537851.b4-ty@kernel.dk>
Date: Fri, 05 Dec 2025 09:52:51 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Thu, 04 Dec 2025 15:54:50 -0800, Joanne Koong wrote:
> buf->addr and buf->len reside in memory shared with userspace. They
> should be written with WRITE_ONCE() to guarantee atomic stores and
> prevent tearing or other unsafe compiler optimizations.
> 
> 

Applied, thanks!

[1/1] io_uring/kbuf: use WRITE_ONCE() for userspace-shared buffer ring fields
      commit: a4c694bfc2455e82b7caf6045ca893d123e0ed11

Best regards,
-- 
Jens Axboe




