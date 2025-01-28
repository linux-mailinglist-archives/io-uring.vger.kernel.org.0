Return-Path: <io-uring+bounces-6159-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D4B69A20BB9
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 15:07:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42D97163128
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 14:07:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9847A1A0B08;
	Tue, 28 Jan 2025 14:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uERtR2xS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E47199FC9
	for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 14:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738073231; cv=none; b=fCVE//iLOhyu1yZ3are3YTnLKUO5MeG5Zf6il9nQKGSu3YIyEY3BZMHlFEAROorwDgq2te+a0zJgdlVWP9EcDeMieV+7SrQXvDPDARo9gt6vxJNrLdzgljWlDp1brPGtvIWs4fC1/bvkmGcRo3vnds3D8h+TFMmRPMGLwu/jxSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738073231; c=relaxed/simple;
	bh=gq2NWccl/XiAv9vrtcGToa+Sw6KkF7qE0pi4mz/eWUA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dXmlG5cUWKu6mKJ5LjerBuHPUCGKJEL65plZ5xUvcSIcFWUsDw1vTdhsNK+7MCcwjtU5jGss02wUAXulJX4+oQZxzjuaYVkTLTUtUjD2JD9jC4+HgTE0ej8ndLv/M8vQXjihMxB4D1Isxgq/N2Z2F2/4gbEbdA/l2Eb4JUJp90U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uERtR2xS; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3a7dd54af4bso12765365ab.2
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 06:07:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738073226; x=1738678026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b4dCPe6Bj7dBOwFNPRfSXyFqFuAX7t38ECheNdkI/Qc=;
        b=uERtR2xS6jmnUAqJrCJP1hyZb2ftA81zdtHH46AKROeK4GmbaraTk0ww9OAp6DfrCf
         x8QpWL7bcJ7Dm0O5K/EKBOdegI9s2Dvc8w4hHjb2Kr7EfPUuDAXE7bBMaLNic75NWrW4
         LnUa6EdkSPfYybYlzZtKLEfAWEpwXTrrmkU7wmYUowZG9mH6BdikcnNw6twS5thsciHI
         hMI7ioZfvwiLMe308POSmsq90CFEDqtqK/leVWiNku79LX4p0ByrMgmH2DgWX5PLONNC
         63giHE0SRrpumHQL4h8qxBwJ2zxJGRfbJ6sVDGK5vKXiUXJDI2cR8XywzwprzF1sLiPw
         M99g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738073226; x=1738678026;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b4dCPe6Bj7dBOwFNPRfSXyFqFuAX7t38ECheNdkI/Qc=;
        b=VOqs/9h85gB9CjQiXe9LzGwFcJsudjYjpa5pV40cLViyTvmkJVSJpgec15IxiqW85y
         RH/mQCUXom1sAfoUywPAz0w8F+1QB0vAPaR6RlyAI9talwQbPw3amhQsb/sKDZrYDjCI
         vZg1TRu0sCki6YuoZoqAwrl/x9GX19+yHYtWN1CAGuIfRs8K/jCmcquhcaNRKOaGXk9e
         jeZLLE9HH0gKDUzDb3h4GrWbjnpkhY59gj6B9le58dczYfkFAzI4V01ZRCtXtPBHc6qu
         CIG88rbi64PAPAlUWouQD4CuwrdNsOtdEsxCZS868HhuAfkAJyFTdaxQp4eHTSSsA0mR
         cHVQ==
X-Gm-Message-State: AOJu0YwmgoYb06+WmhTBqfs7yP785KemtCkGnYIA4cCd0Vx7xxiMKblj
	RONvv5DWcgBIjqdHFAPhjhspVN/+nMY+XDum8z1fO+xf+DmCF78nPEsQPHMLTQYuVsV7I6wmSYh
	z
X-Gm-Gg: ASbGnct2vSemxcf+1ayBEl/T53/HAxZqLZxxRkoyGpIYf+eX0WeI0dvXkRTZuwtCA/7
	7zZAd2MXm7XwtVnKbUtC66KpirCqQwimrjKf9J+M/hLAQGLSbHpTY9kX+PO4LWGjrNWPlq56qXk
	cCw03PzjjV91udKnuXtAEJjCFkwecUvKuS9OBuqcD3VhBtxLwbU4xBBx1rk4mojH1vM5Jb1Y7ck
	S9gGJ0zCXzJiXl2AeghUhzlTWTS+iJ8jnXf/7ltfKxLmZhvbmKTJpeekZQARMXBBxjk5sHFDsIM
	9tEATw==
X-Google-Smtp-Source: AGHT+IGE54K6eo8yCsuqUpicJqTzWYuG3QmdfpLl9fAKDchKm8dxlwtlDeqdDu/BT3FotpYnB9y64w==
X-Received: by 2002:a05:6e02:148a:b0:3cf:cf25:ec83 with SMTP id e9e14a558f8ab-3cfcf25ecdemr118615375ab.11.1738073225933;
        Tue, 28 Jan 2025 06:07:05 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec1da2de7esm3139366173.32.2025.01.28.06.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 06:07:05 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Muhammad Ramdhan <ramdhan@starlabs.sg>, 
 Bing-Jhong Billy Jheng <billy@starlabs.sg>, 
 Jacob Soo <jacob.soo@starlabs.sg>
In-Reply-To: <1bfc9990fe435f1fc6152ca9efeba5eb3e68339c.1738025570.git.asml.silence@gmail.com>
References: <1bfc9990fe435f1fc6152ca9efeba5eb3e68339c.1738025570.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: fix multishots with selected buffers
Message-Id: <173807322480.85622.1680325412012201454.b4-ty@kernel.dk>
Date: Tue, 28 Jan 2025 07:07:04 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Tue, 28 Jan 2025 00:55:24 +0000, Pavel Begunkov wrote:
> We do io_kbuf_recycle() when arming a poll but every iteration of a
> multishot can grab more buffers, which is why we need to flush the kbuf
> ring state before continuing with waiting.
> 
> 

Applied, thanks!

[1/1] io_uring: fix multishots with selected buffers
      commit: d63b0e8a628e62ca85a0f7915230186bb92f8bb4

Best regards,
-- 
Jens Axboe




