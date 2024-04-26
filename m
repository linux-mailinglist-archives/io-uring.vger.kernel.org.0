Return-Path: <io-uring+bounces-1648-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A5C78B3A09
	for <lists+io-uring@lfdr.de>; Fri, 26 Apr 2024 16:30:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4291028AF6A
	for <lists+io-uring@lfdr.de>; Fri, 26 Apr 2024 14:30:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAACF148823;
	Fri, 26 Apr 2024 14:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ohljJ22M"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4F25CDD0
	for <io-uring@vger.kernel.org>; Fri, 26 Apr 2024 14:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714141810; cv=none; b=tmpSxIeBDsLLE3cf7qODvPdgLfBqzEqY1NcLHldnN58V7C4fA1xoh0xSJelaiTomhVxkU1K4Yzt9UlP7r/68rKQGQRzMk7p3z4XBe+PwSs1bFpcsesoFxvy0ZFFp2IaQoADpB09yt/XxVyrMQ07zUJLYG9xjfeOYH0Ty20wRci8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714141810; c=relaxed/simple;
	bh=jApyRCdQV/gaUUWArcDmoI0vUG2cGF8vu6Hq2pkwfiA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=fkbBFJ0z0W3FJWpgahe9N0cagG/+5Tq+Fiohzychdkj+dzESUuvocQdCQn5PwooE+mWHUPgih/lv10sXv7yTTtUvLQKGUE4q34aofwS2ye3Q+DbnxCLF12DSSO5URddeW8G+j7s1YGyU4jlZCx+jR94NzXJvfNjjRbvVgf/xj1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ohljJ22M; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-7d9c78cf6c8so17074939f.2
        for <io-uring@vger.kernel.org>; Fri, 26 Apr 2024 07:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1714141808; x=1714746608; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wR9bNeOpoQIpAoI05+VqeCwJW99tBWFS4JicNd5svgU=;
        b=ohljJ22M5sw3b4mfgDxn9/DYBCxwtvbZeHZyrEOG70j/R4Yp3x63+24TQKYdMUUE7O
         VsubIfLnoMQTlzFzf5ipauUbAVRX2k4NYim0BfGi7V0oZJW1ZEL62Cl6LxMkj5SjZced
         jZQz8vfLzfmH3c5TX1bEEXsdvqZRKGlN7xMQN6+JZJ++RmFDD4weOQPq7KjDZLG1y4q0
         bXUmItsD0p7Oenunba4nK4LOgbXzq6uOCr3eBnR3ULOhb4UXlu2Clumz54cqJBo80Ndb
         maMV/tBLSR9wG1Rc7qT38KWXgbIgDqXxz3J0XZ6ZGjpdrgv83bkFW7/YEBp7g3Vv+9e6
         jZBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714141808; x=1714746608;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wR9bNeOpoQIpAoI05+VqeCwJW99tBWFS4JicNd5svgU=;
        b=Fz0Lybi+0xpbYqnvI1R5a+m5t2bHxqP66lYjXCFdJ+a/sa7S+FzKNuNQtSjKH/nO/p
         p5qO4n1BMYgQO4kdKnXo4PlxZQMpRvrFrJkXK80ky17JUyWE2J4m5nzFE86INJu26TZA
         Wusmf574W5v4w/I5KgEhix3sJU//Sj1fv/viozREGCTr4/XPybS0y6on9N00gk+nsUuk
         Hpeh3Otl2qOTamy8kYjq6PRn6uS1elI54RLuJmHhpekGbW5VJG5SIkaglXSaAnYbM1U+
         fnagInWSzy/AVvTfwSaR+lHpzzgIiFzCIX9u9Gh+QXWNTOXnRpaQqBrSirB1N6hSloJp
         sDEQ==
X-Gm-Message-State: AOJu0YzKGzKaV5kl+7EzY68kU+F3h+arh9Gb6SBDswpK2RqYdHjA/x/o
	rxO3XJFKJPbmtXqM0Dwzeje7PQjfSItww1oqMdGR/WgbNF+d3+Hi7EIyS8zbmI95RZSPZ2fl7Lg
	5
X-Google-Smtp-Source: AGHT+IEevvRZAKINpbt406AurxzH0gu8FtFqB8FdBEE4nGluRuUVytWEjA+N9K4/5VnnyzX3YKv1Rg==
X-Received: by 2002:a5e:d612:0:b0:7de:b49a:22ce with SMTP id w18-20020a5ed612000000b007deb49a22cemr522092iom.0.1714141807751;
        Fri, 26 Apr 2024 07:30:07 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z19-20020a056638319300b00486f7a67de8sm1527486jak.127.2024.04.26.07.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 07:30:07 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Arthur Williams <taaparthur@disroot.org>
Cc: io-uring@vger.kernel.org
In-Reply-To: <20240426063150.27949-1-taaparthur@disroot.org>
References: <ZhV83Ryv1oz6NyxU@biznet-home.integral.gnuweeb.org>
 <20240426063150.27949-1-taaparthur@disroot.org>
Subject: Re: [PATCH] Fix portability issues in configure script
Message-Id: <171414180700.215689.14972621787937962088.b4-ty@kernel.dk>
Date: Fri, 26 Apr 2024 08:30:07 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Thu, 25 Apr 2024 23:31:50 -0700, Arthur Williams wrote:
> The configure script failed on my setup because of the invalid printf
> directive "%" and for use of the unportable "echo -e". These have been
> replaced with more portable options.
> 
> 

Applied, thanks!

[1/1] Fix portability issues in configure script
      commit: 380d12d0f5d68be09ccc6151ccca3e15857b16fa

Best regards,
-- 
Jens Axboe




