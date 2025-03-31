Return-Path: <io-uring+bounces-7312-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 53708A76697
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 15:09:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9176A18871D2
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 13:09:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6C44202F6D;
	Mon, 31 Mar 2025 13:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PXOwtUQA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615392AE8D
	for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 13:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743426540; cv=none; b=XTbECO+ZQ9cEQceQd2GIVMdtL40YJ5+qCft56jAHOc3auIQ9+MI7zIPZmRm4iTH1NlbQecMAyrZvvIahFuJWW+KAN0qYpBWy/9/NDgKXVl4UEooD09+L2oQB+644EJsxzbN2nClusW5ochcZfqHwUfeuxvdrvNrh8zgw8jLm5L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743426540; c=relaxed/simple;
	bh=fvqmveKtjESL8qsrRsS/QXASuw0jpL3CmGxFZ6jXVnM=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=B7GPtuTyI5B9LOj2CFDewE0E7xhqZ3kmMsTcL1dpX6geBPzvIHLvRFfThPXmR4zxf2LKhpE/ASu65e52IvAPIqalni1h/5Ky5DrHwlHhgljE+8wbGZHtd0+D3jr0vLMOeQ/2A6Jk60bUGUNkPTr2spEYHcAwTHmuLp+8vfhrXYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PXOwtUQA; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-85dac9729c3so316365339f.2
        for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 06:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743426538; x=1744031338; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KOZurH3TUKcJKm9hGEa9B8TVW0g5I/6/JQepsHR7KBs=;
        b=PXOwtUQAZG4FmZX1oCyBWcNTMnWR/Yx0DVmzIULIUf0OPa8ABsQ8nXyoVW5UQF+BJo
         ZOz0h1SnyO2m5z44GXjW5MRlrmb6MUm+0/YQoPxAraV9lbWjZ16JxKnaTjV/tlBfIRxI
         CH11DQyCvURv0OkcHWESlMLMG8YZLjcgtzeaD9ntwy898VvXPCw98X9d0hwqbWU7auA5
         aF85nWiiKwXD3dQzG98FtzjVJU3HvMMn+nX3+QSCeTBfj1GRn5iC9IP4PclZ1wABRvel
         IA7mdsIQskW/a8UOgdGG6nKTcqfNlRtkH3OhbPQiugqy2C4pIfcHKqh+hOR3BnxHJ8Cz
         TzqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743426538; x=1744031338;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KOZurH3TUKcJKm9hGEa9B8TVW0g5I/6/JQepsHR7KBs=;
        b=aMhJu3F1sBMVBgVqvRf2tf60hsNbL2KFXN7Sf2jAo3NDC4Jd2dxTBSwiQ+DYpAMVQh
         bBNJvfNUKTvCkxh/if5rd17wtEbr/e5O68vBoEr+aTAhEzpUlgF7XifXy8D/NZfnFLSU
         qzyu+L9ZqJGh231P7jF7hS2tpMA3NamV2CnHJ00ryfAlLSZKJTEro2EVryX2+m5JyvI3
         vZEvXHzJb0gQeQ2PAbh4ls3l10yAXF+N5gmoD5F3jtAwpnVWcYwIUcWgVbuxRWljEp93
         a+qFsnLh2QEXMFxByyTcGsW9fWWZMehTR8m4hZjOD2EGu4KRnzJGsmkZ+sZgsLOlFiNW
         aiLQ==
X-Gm-Message-State: AOJu0YwVPmFJ6DIuaZeGaMjyOPhKHyXwOlTpR2NeK54UxRz+How7dpFu
	PPC17aFEYX5cO6W9DRkb6Qk4h1790VJZYQ9XEn3HSUnUvQJSPwhD9jzIePhcq/QmRpFzvQk+yZW
	R
X-Gm-Gg: ASbGncs0O2yyfsfZTvN813wCYIleBytLcY+zWVO47qQNoup2G0avblkZ81OvM0aNtzY
	ZNp10iVRIcnGIzJ7gZvTsFd8WA5N4yXSeVyNgsZL39yYi8Y/8BJb9ib+elzecokGgXzQVg8XArw
	Co1HLAWvmW39l7NWFToRaqe9WhPO/DJyFxJRZ4d4FKiRi4ud92UHnX8m1QTw/ZtIdJgnm+jMKO2
	NUI/3qABUBYSOhfqzNdvSfSJBE6QNMKxDiQBBrKNtbqWVXwNJEdAUJw2+B7QJu+RGSvhNmooTfS
	uhAfW1Ysuw5TPMfwgTatsqT0Jx0fBJiMKC88
X-Google-Smtp-Source: AGHT+IELYW/fhxPxxwZSDqG4r/MPSCm0RfSZxVzOvFC73h9lL+HgcBiycapLE4uOPyco2w+W3+ikLA==
X-Received: by 2002:a05:6602:3814:b0:85b:58b0:7ac9 with SMTP id ca18e2360f4ac-85e9e901762mr823148539f.10.1743426537963;
        Mon, 31 Mar 2025 06:08:57 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f464871886sm1838311173.92.2025.03.31.06.08.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 06:08:57 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ecbe078dd57acefdbc4366d083327086c0879378.1743357121.git.asml.silence@gmail.com>
References: <ecbe078dd57acefdbc4366d083327086c0879378.1743357121.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: hide caches sqes from drivers
Message-Id: <174342653708.1705439.9267345057779130027.b4-ty@kernel.dk>
Date: Mon, 31 Mar 2025 07:08:57 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Mon, 31 Mar 2025 08:55:47 +0100, Pavel Begunkov wrote:
> There is now an io_uring private part of cmd async_data, move saved sqe
> into it. Drivers are accessing it via struct io_uring_cmd::cmd.
> 
> 

Applied, thanks!

[1/1] io_uring: hide caches sqes from drivers
      commit: 296e16961817e8e5f574661febc608ac0c0c0108

Best regards,
-- 
Jens Axboe




