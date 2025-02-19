Return-Path: <io-uring+bounces-6561-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 194B8A3C331
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 16:10:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0ECC179456
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 15:09:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFD6D1F3B8F;
	Wed, 19 Feb 2025 15:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RmpY+t28"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B38E1F3D5D
	for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 15:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739977746; cv=none; b=jPGtswehf6Xv9G/Q2A5NaTItwD3tDLUDUYzL3dvVraCCb1mJTOybSlEA9Kzi3J5kHrE4PxZzU3WfIITwkjsQxOFjlt93zReyBRQaCOqa79a0S5cKnBYBE6YIaQ1RpkO3xuHSlYQrAbACE3RjT2X/VSXP9gtLHFpy2QgD0lu91vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739977746; c=relaxed/simple;
	bh=KpRZkJVpMER4ABmtHIWnu1sCwcyaQlJVM2PbewJQAHs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=IahKt2y5ouqz8lxJ6iD1uzmTk6Opd9WSAVpnr+K+MwdupyTevC2cEbSoPQVCJSUt/21eniKQv+KP/fjlDsc9+3JMUN/VI20s81nYbHoMPu3JLYnuezUhqoyJhy5huqnUMDZBltNwJLVeyMy70Kbnv7zX0voMchfXcy1p3nE7zfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RmpY+t28; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-855bd88ee2cso11481539f.0
        for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 07:09:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739977744; x=1740582544; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iJiPIBuxHziy6xD4QyZZewHTaEeyt9GRiu24U+QynKk=;
        b=RmpY+t28nCfbxkb7kWUvaAklOet4zESwRSWUFagB5BAbSY2a1VJbKueesXnjX8JxcV
         w8dkyXpFJJhuGZdVR5ePHaL5LQi4ZKEYv2d1h3uP6aOgUbFN0/gkKemuM7GAn3v8MWLn
         yq8EV835AOV4Xcl2MgBL6jMtNE+I1e04RrQuPRHFQhOSQ6Vh4V9ULgE3QLgZyKKcmlte
         kInf8GiBJOABv4YM+APTA3zx6p1HfozPRugnEFBiAxG6LdAe3z01m/MTrOz81CtkyPR7
         o9SkWrdE22EHffg4L9l6WLg3RPRrTCrGDxtRw63sZD8IHiyOjFrH8OHat7NcNvjDEa46
         gvew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739977744; x=1740582544;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iJiPIBuxHziy6xD4QyZZewHTaEeyt9GRiu24U+QynKk=;
        b=LOejY7gPnEaPn1py6Os9hZXhmScwpuzc3PW9eVUM9ZLWudUQK4SH/5t/CBpKsj+SJE
         hRi9ciPoK+E19NfUY1G0INatnamvksxcLKiwKSjjGFxBLAQRow50cBagQnvOk3/KA7Oe
         Fgyx27iFaySU1B1PvVTwysKF5ynmr1hPMgnYDOLxJUAHqnfsbg/lkYl4GhANbHjFmGDi
         yHf+1PqPBsEr5oLZ/w3OxS6nWMPmCzv2XeLgLnNsaAlvFZO76JPqc/IDyTq9V69CgQFD
         pRyt2D5dzZplz7IZE15bHojHsTY/xsH6B0C5IAq/eE/Mi8FxJCG8tobemxCTU3EqIwum
         pFCA==
X-Gm-Message-State: AOJu0YxcBiZJJjLQUYBkDLcFT8v/+RS19gMI5nkrcNzDriTFjHiZBiP8
	L2yssjfKHEtOiM9tMsWfL/ia0GKdbT4RirBTVHbAVQhAVtPzF0zEyF2Bo4i8WeU=
X-Gm-Gg: ASbGncsF+bB4Bxtqy5xc40reYBA9qGLOWTzFjnOorTHxa/swhBqOzdrLq83wFX7JxS8
	Sf0dyqtcj/m+hT2KnpJefwS+pf07IZSwm4H/8ULI12y6je+AqSLjia8WplZsNmDXfoYsIy4q8Rr
	6E26wgtS+NY1ZpSBISOK25F1y1DwJxu3wFDGlSNM+PPwe7kO8m010H7PT380FEAluacjGAA9LzT
	Frlr9VWRSZa+DzU/dRhLe0S+qQOf4DlVkS/xFyywilewBBLkBN+cYwf+EUxmOd4RPKeiGc12lH7
	igf1yQ==
X-Google-Smtp-Source: AGHT+IHYl6ZT9AhuTNpGUwh6j3kXJF8NvBTk0kQ3u8/3rbup/1cf5eYdnKcGywhE9gpaBSQ5fnD6KA==
X-Received: by 2002:a05:6602:13d4:b0:855:683d:d451 with SMTP id ca18e2360f4ac-85579fbd60amr1738963439f.0.1739977744316;
        Wed, 19 Feb 2025 07:09:04 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ee9c1a303bsm1491950173.26.2025.02.19.07.09.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2025 07:09:03 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>, 
 Jakub Kicinski <kuba@kernel.org>, 
 Geert Uytterhoeven <geert+renesas@glider.be>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <5ae387c1465f54768b51a5a1ca87be7934c4b2ad.1739976387.git.geert+renesas@glider.be>
References: <5ae387c1465f54768b51a5a1ca87be7934c4b2ad.1739976387.git.geert+renesas@glider.be>
Subject: Re: [PATCH] io_uring: Rename KConfig to Kconfig
Message-Id: <173997774341.1536543.15426787418429919089.b4-ty@kernel.dk>
Date: Wed, 19 Feb 2025 08:09:03 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Wed, 19 Feb 2025 15:47:58 +0100, Geert Uytterhoeven wrote:
> Kconfig files are traditionally named "Kconfig".
> 
> 

Applied, thanks!

[1/1] io_uring: Rename KConfig to Kconfig
      commit: 5b760fc6e9c5f984629c217e559005dc3725e9cf

Best regards,
-- 
Jens Axboe




