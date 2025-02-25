Return-Path: <io-uring+bounces-6747-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4538EA44372
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 15:49:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04ED816DD49
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 14:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EFAC26E153;
	Tue, 25 Feb 2025 14:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RoyufuGt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC45B26D5D6
	for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 14:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740494626; cv=none; b=SyXDiiy5aSP9HURbctfetixoLzUxwDHqRMIxKzsYGSfK0QaIAjEJeNsxu8HPgxIo6cVErLQmUhG3KpadIjxS7Cf8AoFncEz/dLu875zoHdGD9mWMd5cdlyn2QroSZjcql4BXOrfcNzhU019XgDEWaguxW3bH73hGDFJZRPbWR5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740494626; c=relaxed/simple;
	bh=fQyV7cop8AcDxeUkPHuHVP10xyn/srj9/X0jFyaPZQg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=bimwkttbRmR2f171w9zz+vD+b3mJ0900VYhsIuvyJUXkfJfSkLQyZU2YhQEg0BbxbmzaN0Jm9bY/RDZ5gc4EQQzGOZ5al8/PyEXPa0OK1aDQZ11ijyCKrXa34W/q+OK/qpAVHuFjWqQfHjeMPC8GpXaKm97XqaWvVDqiTyfiU/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RoyufuGt; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3d1a428471fso43222435ab.2
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 06:43:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740494620; x=1741099420; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xnaE7pkMEQORJs53mpRJIZTHTOxmxD6C4NRWr/ocGgI=;
        b=RoyufuGtu5FqzM/H0VtZqjhZg3I0jTT4wHNusijzoujrc9t+aWu2xxSzjFdhSyTIzd
         ugHvxfySTieIbzc1R3cbHkicvWy3iZfOiQGVDV5osjPlWfGqDDJek9V2O6Bz0XDhkjjO
         +kdUs7cvPk02pDep0cC+onza5VHBrl59rLDmSByNP4OvOwHXXPUmIZagyrMNvX/Lr2U9
         La8msIwr1/Ndah8gHrqLTzocuPsaUAGADt11/x16fQId57Js1XexSx2xWoKZQE5ETbvO
         3csZP5Yd7AQKC7NRpl4+P2l6iVBaRHLvKW0dYGOKe6/6QhUu1Tk4zWXWvBZFdjl5fFrH
         mSKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740494620; x=1741099420;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xnaE7pkMEQORJs53mpRJIZTHTOxmxD6C4NRWr/ocGgI=;
        b=mNpcV7tgu/mlDvoMCn+Unugl0cC1v1SWmKLBHgt1Ho8q8IKhyF/LXCtDkV5RByAPvz
         mZYRjNeiGbEkrT9zC1BRQhLaT1DFHv890+BwpwT2NhBZpcsQ9Y41x6/1JjdDPjydHW/n
         aclvwZZDyQ1jgoV/QRDV7WS9adNair0irJKtL5u7ehn50A+FTrqK1M2KT5lz3Fi6QJlr
         PFHh64IHf6x/X6IWB62O6BJiZW/gEnX15NK3/mWyneBRHioM/eqgl/1YAm+hPMjq3gy4
         NGYTiuLbx6j1WEr1aVCwEbMCJ8ibfOs+Dc1h1nzQQzVbq5TgESV3EPH/KHmdWpWn3lY+
         AKtA==
X-Gm-Message-State: AOJu0YwKsyOMekryQXgrgcE9L40KkYeY6osRYHRj9/V9w+uA7jq6O3rx
	a5a4xmqyR9RGf/gUXOLkaCT5Wqgrs0aAcn9a1Rm42fUh4tZJ+8qQVDYCEQwmdnw=
X-Gm-Gg: ASbGncvK+g8jC40Ws1xJIQjSvSUQn9MHXnxD9RgY+XEcjmuE32v7EraaACbuHY941sE
	bXAnqjoQ5x+svJ8Bf/V/9rXdtf6bhbsKmnVtWKrTCuIzfKT0iNycNYW0Yq6I6KonAsWcd04EaeC
	Wt0BUvjs6zOdgvH0rIeFTpJHyH0b7SIkrNYE06DYpiAgyj8nhzFrnel7CeE2qcMoBfPybKRc/hJ
	CW84cy7c+ifWZUzPRK97xcbbG0sApzaWJpMollLyjpP78wXq5ZsjlLv8d0L9Z5q5ObQ4USb13wl
	CaFCnX3+qcrodmPU
X-Google-Smtp-Source: AGHT+IGOBsv8VmWXt5EfVW9FiDpTloHN4N1lr56Yw1MvzcmPHl7q0iTLzSHL/8W3beaVU8Te8rP+aw==
X-Received: by 2002:a05:6e02:b22:b0:3d2:b6a8:9b21 with SMTP id e9e14a558f8ab-3d2fc0c552emr32599985ab.4.1740494620488;
        Tue, 25 Feb 2025 06:43:40 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d361653616sm3584065ab.25.2025.02.25.06.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 06:43:39 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>
In-Reply-To: <cover.1740425922.git.asml.silence@gmail.com>
References: <cover.1740425922.git.asml.silence@gmail.com>
Subject: Re: [PATCH v2 0/4] clean up rw buffer import
Message-Id: <174049461937.2111022.2491756232035105242.b4-ty@kernel.dk>
Date: Tue, 25 Feb 2025 07:43:39 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-94c79


On Mon, 24 Feb 2025 19:45:02 +0000, Pavel Begunkov wrote:
> Do some minor brushing for read/write prep. It might need more work,
> but should be a cleaner base for changes around how we import buffers.
> 
> v2: void * -> struct iovec * in io_import_vec()
>     flip the if branches in __io_import_rw_buffer()
> 
> Pavel Begunkov (4):
>   io_uring/rw: allocate async data in io_prep_rw()
>   io_uring/rw: rename io_import_iovec()
>   io_uring/rw: extract helper for iovec import
>   io_uring/rw: open code io_prep_rw_setup()
> 
> [...]

Applied, thanks!

[1/4] io_uring/rw: allocate async data in io_prep_rw()
      commit: c72282dd865ee66bc1b8fbc843deefe53beb426c
[2/4] io_uring/rw: rename io_import_iovec()
      commit: 74c942499917e5d011ae414a026dda00a995a09b
[3/4] io_uring/rw: extract helper for iovec import
      commit: 99fab04778da20d2b7e224cb6932eb2ad532f5d8
[4/4] io_uring/rw: open code io_prep_rw_setup()
      commit: 61ed48b5fc63d1c6d9c3eb59ed2b46a2cbfc6039

Best regards,
-- 
Jens Axboe




