Return-Path: <io-uring+bounces-3658-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7168199CB8F
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 15:27:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9917B1C217BE
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 13:27:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 023C319C551;
	Mon, 14 Oct 2024 13:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LbsWLrMd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302224A3E
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 13:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728912468; cv=none; b=EjW/DiBumqqu6QaF7rrfdVqWv4Xplizmwy+tA0tkw/MvdSQTmR/rKz/hD/NJNEHmshM+rnu/FzLAyt/yejK0MSDnKmyJLqccOiim9SEHK7nT7hmCm4WEBQ+3yK0xowiFApZQOlPf56mTHHjSlEBzrg9tznOdUEfTGEOZv4SYTEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728912468; c=relaxed/simple;
	bh=PyoDExgkd1sXP3MI2oDzNdYGdxFADG77HrcvMlcjneo=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=WCzLLtw09nfpnZrVbZKYWuu4InC1c0DCmXTV9kFZalMHBsLYUy2Dra06YiEQVq9qH0x4ldhg582ELBHsodd37rSS8+PQFD1jHw7yZdVb7Yd7UElg36pe6S0AiIrEOlq8VPWg2An0nUM/YV7XCfSUxI5+p/zQrVUMuc0VYT9Fog8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LbsWLrMd; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-8377f24fcd5so222989739f.2
        for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 06:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728912463; x=1729517263; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T+TjN11PJbvtBffKZu3Otw5ARAnNVob7hnrELsIW/4w=;
        b=LbsWLrMd5HGTZo8V2vaavLjTFJIVAGVH7vbvKfe3+uD/L9TeFigYdtutMGJcq2z6yj
         C3HsdN7DkH+YZVETQ37s2BlvqoAKtM3e1GHY6Q/1HDeLA/nKQgsxH5laaeV+iR4nuqGO
         hzuqsG4hGMmj+DO0rwq2MvjlA1cFVlYGmX+Rll3GlSSYqFvzIhID9JT5EiToiA2W/vkD
         vZA5wZJh89sTdBQJ4QGtXLZJVSIdxQPWxOOpB7HBhZmOEHMX/f1FPvlFJK6COcc+OjWh
         9le+A4L+I2AuTLCMv7Cl7ABX212vc+alr/o6GY1v1WbJX0QqQWs0WrlifBaT4DJbBBsn
         CBhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728912463; x=1729517263;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T+TjN11PJbvtBffKZu3Otw5ARAnNVob7hnrELsIW/4w=;
        b=lgUPKEYLFxpY4N8yIxGTgaRjFIuQ3CALj6CzTc9FSpl9oCzz8DPa+6QpKBs5EFuMTp
         TpUuSNyMCk6kBS3G+L3WTGl4utt+CQHESgS5qBN418jjwyJk2S/BhpZDe6HGww1t9j70
         mzo0ht/nofmbftFP8rk0YcgqvuBMfM9pJo7eYKdIWx0vPeD6kblmTONE5hxgnCp7d2vH
         XWmCUxfCrr4Gzy9T03SSr6wckwGiq+LSKDUbUiFAmI9yOsl9Aa6/wJxqUa0CyRPBYJ2f
         HI+pix8qJvS9Ft9U6m2gDdv1rGNELFIuUmFovLHBoBKne6XT8yBMcZ0/92UuYwuFJM81
         Pd+A==
X-Gm-Message-State: AOJu0Yy3ftWuI1/oOEcnude3e/oTJBazMzP3BSNRWsU8Uwh4vaB7eXWg
	ASExir/o+nxTvV232Q9vK0tBclhDWSZam7Org1CmaKwJ6AzCYsFK4lgdsMqXbEidp7juOzigx/f
	XupI=
X-Google-Smtp-Source: AGHT+IH/ENQ7mXpi5oFDMqzE33pkFBjd+q6dcdKCyab4OWijFXJGAFiBO2T8VRBI8k47K3faEBl4Ag==
X-Received: by 2002:a05:6602:6206:b0:83a:712a:6ae1 with SMTP id ca18e2360f4ac-83a712a84femr305466339f.9.1728912463234;
        Mon, 14 Oct 2024 06:27:43 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8354ba25686sm481927439f.38.2024.10.14.06.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2024 06:27:42 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1728851862.git.asml.silence@gmail.com>
References: <cover.1728851862.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 0/3] support for discard block commands
Message-Id: <172891246233.358575.5878613323080664373.b4-ty@kernel.dk>
Date: Mon, 14 Oct 2024 07:27:42 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Sun, 13 Oct 2024 21:45:43 +0100, Pavel Begunkov wrote:
> Add helpers for the block layer discard commands, as well as
> some tests and man pages.
> 
> Pavel Begunkov (3):
>   Add io_uring_prep_cmd_discard
>   test: add discard cmd tests
>   man/io_uring_prep_cmd_discard.3: add discard man pages
> 
> [...]

Applied, thanks!

[1/3] Add io_uring_prep_cmd_discard
      commit: 906a4567312346a688ccb05ae94459cb00b889a6
[2/3] test: add discard cmd tests
      commit: 244be25e45c32981008cf50c9923d0ea1bd4e2e5
[3/3] man/io_uring_prep_cmd_discard.3: add discard man pages
      commit: bafd87251db3fa942c310eb8afd137b6c3cd0369

Best regards,
-- 
Jens Axboe




