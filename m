Return-Path: <io-uring+bounces-8099-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F13DDAC22B0
	for <lists+io-uring@lfdr.de>; Fri, 23 May 2025 14:33:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B383175989
	for <lists+io-uring@lfdr.de>; Fri, 23 May 2025 12:32:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FDE079DA;
	Fri, 23 May 2025 12:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HbmbiQSw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AED15E90
	for <io-uring@vger.kernel.org>; Fri, 23 May 2025 12:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748003574; cv=none; b=ffEdWXazG03NS1QtLIIpj+lq3V66IeCrDfwNI05HQhYrc/MmUYPbZooT2FZ4180qrwfsYbpAgNsr5qA2zHZO8GmrQMt1oMIYM9jwvhQdS76EtKJRzB87vQl4wSAg4Ud1OJy2Ih/GMIliw/annT3qDAJTp/vl1J4nFg3ZsG1WBUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748003574; c=relaxed/simple;
	bh=ATaOqLiqVW6+/u7cEwt6sry6RhUIoJW26++5WSKo/fg=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=hxGG/FqOoVi88qpmY5E8kSu7b/279kcw8T5mYZKRRlvfHvMCbpQ4Vg3CgQwuFG/NyghWALcsNjr8/JbX/cidKC9UQKl4H51Zow5ZVQLGlYVCGMuWlrAYyoe+RGysVosYnnCrkb+EPU3doVo1l7DR+GLhL3ATPzCFttoyCzSfYzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HbmbiQSw; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-867347b8de9so28762739f.0
        for <io-uring@vger.kernel.org>; Fri, 23 May 2025 05:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748003569; x=1748608369; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NftKF7vU3RHYyahYbztDao6TkM4LIOiIYxqa1p9kovo=;
        b=HbmbiQSwhyhK+HyRmn59cSgeHsPc6osYK/h8P6KOCmUJ6JWsbXrays2HCFvOiu9ZXk
         jCqWZ7KR3jOG78BLSS5+SpJgIVsn0PMUDVpbzN0tWfIvuqSLeYplQ8uu75yEV78drQHi
         3+l/4YH2NQFPmWFdQ01I7c7HuAu8zYMRc7VQTdSjQ/66cu7jQIcxeg6ytyWBfZX49cch
         Jao7eGUXv28PR5z1M0VC/tuthE0NhnEA7IyfkLbnnp7yug39AgkVLcq/GwrRgxwEQXxP
         1InK6D94rRN45DGRpzioIl01414AxXuL2RNmOS4ORNb//ppZW0stsRGxI6QOCGv08yIy
         ARew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748003569; x=1748608369;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NftKF7vU3RHYyahYbztDao6TkM4LIOiIYxqa1p9kovo=;
        b=VtmRwO1DKjEAR3SaWL6ibdgHSy9uCRF6aWEqw0HbqciGwE6cnvjCFoiwIPdS6XmH1p
         ftPeykMZcxD1xp0qwCNOeLihk5WNMw3yzeU5PhceylAQDTUJRb7BwcdZpROR52H4W9ug
         m6cpF04OqUpOBdYXqBzBgok/infWv2pl8rLeInkI4CPJXxO5Zm8T8dZFMWsoLy4Y8Vzt
         LnL4+6DPXuztnVobkxdROjFM0BsqU2lt1vn/5jZpLSq8RaMopEdNQWn1+65mjS1ARybD
         UzKc4nXcRL4LnYv8A7QT5fX9dLnKiiZEGTgwcParBujeqnzXjLIRESSJ8fiB/f0XEubG
         JxxA==
X-Gm-Message-State: AOJu0YyCtzvABqdzm+5/wpHiFfpuMDF7is4lyoplsk3JvVV5X3nePQHL
	p0Q2Nqf4OUPnlgxIohSMM0xqpDYnWaSKHEDuOoRCJ4PCLNoneHEjsNfa/WNfz1+dGUvzkL+obGB
	hotEB
X-Gm-Gg: ASbGncskA6fIc6kxu/xEruRJ7ZsHvjpDdf8gUzzukLA91ra60vuISr/1/BujCFdQHyO
	Kod9NNiZOhleRyuqc7e4f0TZbcKIwwvRI1ET/ZXElKmKiwkWA29NP02DTU7T+eI/osRfdxi86H5
	5pmzHkZY2RWZL6fT4Nu2U7Ddl20GkWcTXss7RJH4E/wXJGZLF6wnXEZ6hl8+0mOUYEJprTB7Ce/
	8nd7mfxjoXSJK1FtY2EDicKbB3aeQe64/w1obAYgqHbEBxreKtbm0LnaV5Es9qIG0D2aqY7DEOG
	NO+rWgfll9IN1Kfys8KJ9reOk+PXwj9Gcc10NjnOH5M=
X-Google-Smtp-Source: AGHT+IHqDVX0dH7/1L/m1pXLGdYgbGsBoOzQ0h4ecagY5ZFqhrRmiTqpWTRRRZkWfUK+wkCULP7b9g==
X-Received: by 2002:a05:6602:6d17:b0:85b:3ae9:da01 with SMTP id ca18e2360f4ac-86cadd5ffbcmr320167239f.4.1748003569333;
        Fri, 23 May 2025 05:32:49 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc4af638sm3451360173.105.2025.05.23.05.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 05:32:48 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a1c2c88e53c3fe96978f23d50c6bc66c2c79c337.1747991070.git.asml.silence@gmail.com>
References: <a1c2c88e53c3fe96978f23d50c6bc66c2c79c337.1747991070.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/cmd: warn on reg buf imports by
 ineligible cmds
Message-Id: <174800356862.1255350.9517115478564537743.b4-ty@kernel.dk>
Date: Fri, 23 May 2025 06:32:48 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Fri, 23 May 2025 10:04:46 +0100, Pavel Begunkov wrote:
> For IORING_URING_CMD_FIXED-less commands io_uring doesn't pull buf_index
> from the sqe, so imports might succeed if the index coincide, e.g. when
> it's 0, but otherwise it's error prone. Warn if someone tries to import
> without the flag.
> 
> 

Applied, thanks!

[1/1] io_uring/cmd: warn on reg buf imports by ineligible cmds
      commit: 6faaf6e0faf1cc9a1359cfe6ecb4d9711b4a9f29

Best regards,
-- 
Jens Axboe




