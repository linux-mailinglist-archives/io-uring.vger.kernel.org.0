Return-Path: <io-uring+bounces-2211-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7C1C908F9C
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 18:06:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DFCCBB21E23
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 16:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE772146A96;
	Fri, 14 Jun 2024 16:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Cz+hpwGU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD242B9A5
	for <io-uring@vger.kernel.org>; Fri, 14 Jun 2024 16:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718381182; cv=none; b=porVTsdIW4bpMIboyBninwlaAuTkf4/7XLgT46Aa0A1qGOywbHXRgnxCG4ZqW4eq60+VjgI2sfwedVrrQPDJf1/+JFhJN/JvXUv4cFHZ0S2Y7ZGvdougFbmOKMspzRvMJFwMsMgefc9qXr6ZASUjGlDjoENLtxfLA8LDRx4d050=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718381182; c=relaxed/simple;
	bh=eJe++GPJbuFK+mYJ7YFUxqfqZvP2JxU8mC0PsqpZZ6w=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=YlcvfFyylMc+2sA7NJGlLBvEaGYDZ+lo4TiDw0Wf5LAHA9PZ/B6g/VULTwGRV2t/GUyAkpN/tn+n2yN5r6NUVxDGOUom6Crs0hjO+Z1BEpg1BKX7cLup/0mLA56gVR9lD9hKZmW59xqrCxivn5ALLInK4G/Wa/wEt0rw02pRhlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Cz+hpwGU; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7041bc85bafso103475b3a.0
        for <io-uring@vger.kernel.org>; Fri, 14 Jun 2024 09:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718381181; x=1718985981; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=szaHrCf2bXBCHMz7h+GZTOvBrquvHTtd7WnBEx5l8GA=;
        b=Cz+hpwGUpBjYrvFrcU2t0OIahzRX7VBx+A8Ux992AlwC7xSnOA7/kTHbw96IEkSA3N
         uqZfXXAZHt6Y/CbO+ixcpqipR+pqFi4Hs70A0BBeQYua8B0+6ksAwmXOh8RQuwMvh0p8
         iq/WeECWplLh31K7U7nF2uNLL0YOjVdDZtXS6//YdYeFEtyy3MhIK/tC8CsZJUKxwAq/
         bbfVed/oUnw57y19EK/H082tf6e7bc+tOaAAG7dbmSqvoQOttAyKx3YT6TQ8v2zg8t3t
         cwp4icncQE09NkurvPcrx/vMp6dg7OACzEaDGj4jpnjdRv9owV5rAUS2XP5ET+P5vimG
         41NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718381181; x=1718985981;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=szaHrCf2bXBCHMz7h+GZTOvBrquvHTtd7WnBEx5l8GA=;
        b=pmbSiszL+XTOa8M9KlIAbpJ9Tt0ECXNS3PCm7o1DiIvb32FRPZhUwgRWTA6H2G9rt5
         q0zIp2+/+znoaUMpkKiGaWIDvrMDbHJaXpUG/GS3XveqV9VRa30ge6NoZv3FrMM+kz0Q
         P6HvxDVZfyF/T+QPg+UNA4iMRj163GqUTh9Okyb6nnv5jly2YHLkG0g+KFq03kDzBMDv
         ZZJcrn2/vn+qVM1Q4oMX06OWSdbgq9LERFBNcvzTB9Fots+EhrJ5IPyWcxcosyjAuNWt
         H+bjIxRIWEpfj6t8y8mNkjrSVna/8YNYucamacgpX9PbeaGJw7XJyEA+Lj63Tzr3hDuq
         0Juw==
X-Gm-Message-State: AOJu0Yx35ED7dGQ3GzJytXJPj5f1ZWa6m/rC/t0Qg7WTm5wOYA5tFDYv
	bjizCzZSYVLjOtJeUCzfgxZie2QDwr5zqzuq7pqiuZ9UaOrxN6IVjjAbnrrozbs=
X-Google-Smtp-Source: AGHT+IHgc8Og1fY+OsO9b0JsSQg3LcUVSPKKy14T9FQoOeXeJPwhfS/0/3Xg6gnXrbxW+Tf9nbjWEw==
X-Received: by 2002:a05:6a21:6d9e:b0:1af:cd45:59a9 with SMTP id adf61e73a8af0-1bae7e1cf3emr3915796637.2.1718381180510;
        Fri, 14 Jun 2024 09:06:20 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705cc91dc67sm3230939b3a.2.2024.06.14.09.06.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 09:06:19 -0700 (PDT)
Message-ID: <ae3d160d-6886-47a3-9179-de6becf0af38@kernel.dk>
Date: Fri, 14 Jun 2024 10:06:19 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.10-rc4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Two fixes from Pavel headed to stable:

- Ensure that the task state is correct before attempting to grab a
  mutex

- Split cancel sequence flag into a separate variable, as it can get set
  by someone not owning the request (but holding the ctx lock)

Please pull!


The following changes since commit 73254a297c2dd094abec7c9efee32455ae875bdf:

  io_uring: fix possible deadlock in io_register_iowq_max_workers() (2024-06-04 07:39:17 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.10-20240614

for you to fetch changes up to f4a1254f2a076afb0edd473589bf40f9b4d36b41:

  io_uring: fix cancellation overwriting req->flags (2024-06-13 19:25:28 -0600)

----------------------------------------------------------------
io_uring-6.10-20240614

----------------------------------------------------------------
Pavel Begunkov (2):
      io_uring/rsrc: don't lock while !TASK_RUNNING
      io_uring: fix cancellation overwriting req->flags

 include/linux/io_uring_types.h | 3 ++-
 io_uring/cancel.h              | 4 ++--
 io_uring/io_uring.c            | 1 +
 io_uring/rsrc.c                | 1 +
 4 files changed, 6 insertions(+), 3 deletions(-)

-- 
Jens Axboe


