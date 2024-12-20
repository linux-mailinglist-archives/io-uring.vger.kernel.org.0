Return-Path: <io-uring+bounces-5578-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 729C39F968D
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2024 17:28:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E458818950C5
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2024 16:26:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79065219A77;
	Fri, 20 Dec 2024 16:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xusfunD8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7B6219A9B
	for <io-uring@vger.kernel.org>; Fri, 20 Dec 2024 16:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734711874; cv=none; b=OkPkJ3nOu+rgSTkUFazSaBBAZH43jBOMp90IxGlzVG7FdPYyZiVLyCEWU6JtXMZ+WTzIITjU9FAi2p/yyPhgI7gd8pObKWOQ0tdAPamnBzv5JOos/R2Za9p3heCIFQNiql3KURZMJN97BnqJ/aqJfdIUzIMQ3tabkYjZ1Sm0cio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734711874; c=relaxed/simple;
	bh=RNHzgzFvHM20VnlPOeumF8JB1fAiChBOCUZnFTdPsiY=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=aWp1GIAdUBSU/PaXCW69mH/WBjCYRnsNXiHMqltmlh+YhRmaxg3J/O5y85ITdbBnWI9/9PUAZAQ9Ftqhzej/6V46ciBeVlW3DwFuD9jjZW8KXM2RL6QoFc1pt2Q5NIdIPGmjusZ3Mxb6ua2fCHvzTk6D91cpWbgnCDSCvE2jNgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xusfunD8; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-8442ec2adc7so69535439f.2
        for <io-uring@vger.kernel.org>; Fri, 20 Dec 2024 08:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1734711871; x=1735316671; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dJ9ZHPVWgCW5VesGsdCYMZPaGurWYhPkbrS/5mXomug=;
        b=xusfunD85on8/YogJVNNVbl1p/hKS1QcP/dETVfc9AE+1m/6lapA8f9Ozq7eYI0mol
         e7lHujFhjEbuWCNzlzKU7LXzxIJS56spdi8wzavlMlImqQwNs0odq2LY08UR+cz+GfdU
         pqkCzN1+J9exQK26OdkqNftQR3mXnkcOlZNcURo9NxgZpe7xH0azOW4KAyy4zvpuXggC
         1G6IGbaqZKI7dY9i3RSkYkIHokQAtyJDGVkN30W4ub//EoeC728XAVW1XcRLSSdT34+D
         Iav/wTD68pEihrgYIwHVOC+cvyqKozBxsPg8JOzUbds7gY6GQAl/5FU/4+uXasKoFFiS
         LLZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734711871; x=1735316671;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dJ9ZHPVWgCW5VesGsdCYMZPaGurWYhPkbrS/5mXomug=;
        b=UmwrvdwZXUOrfp+OH3LARmamdNYjRqFOxSd7ZF9pI01AZzVfiU7HRiwHMa3Im3lrmC
         ETxTORw/d3JjJk4jvsYNlvNBFiBrwYkHuEbWjruIn9l7X8xl6alXupZnDba2U+kzBhxY
         HxZyxpp92wvpm76mvz2cgBU/BQjF7+Ms5Gzl0jz2oieGebEuqO9FkMl5uSFSurZiGJR5
         IBX5MFwcKiDEtCIig+Jxat6LdinAZLIey9zEgzZEvvpkJklwfdaUrb+J6IIBp8g/QKmL
         OVTsDKTF11a+xEraaMB2LJO4v4q9HUI+ixsLLihPYSuoOsTJAYg1BDaUPnWwIoMIHq2U
         Z3eA==
X-Gm-Message-State: AOJu0YyD6PNoGXHajPNZ31hISrIk+n+V558xvXM9F67tpMBsw2mndHxD
	dXygtbfQvLTB3qGae0uvAtQgOyC74qKauwd1rDawEsWClJM7L16eaKmYxbCLlnq07N4IYQgOtmR
	6
X-Gm-Gg: ASbGncugfrKyLOVu00UkBI1Urw3d0ZBL/By1qbYrgF4w/7OcW6luhE3Rxdqzi+eVZj/
	M9q8v3KttmVzvvdI5u+CgUIvtR57UZdQOc1mOWRCerwt+GaoaT1sy6RiiaR6Y4a7AApQhYohhWM
	m4IdRvjzZjHPQwONWTaabyhqguB0hJTp9FHHcFqszvOy87oYhfR87DuwBedfXQYyCbdydGqPttz
	ZZTk1qMeL0uTgY46be+I29NOS8M5vEMUdhg7ZVSxrhV/m4ONKf7
X-Google-Smtp-Source: AGHT+IG8RYQ6mZ2eTIYkulmIlSB9LTiho6LdYhwR82hOG4iGxc5r1N/HZ2QNbww5NC1kpgyhFTfj7Q==
X-Received: by 2002:a05:6e02:1a2d:b0:3a0:c820:c5f0 with SMTP id e9e14a558f8ab-3c2d5b27450mr35675255ab.24.1734711870706;
        Fri, 20 Dec 2024 08:24:30 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3c0e3f36333sm9364025ab.63.2024.12.20.08.24.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2024 08:24:28 -0800 (PST)
Message-ID: <785290eb-4182-4ea0-bce1-b3d895de09bf@kernel.dk>
Date: Fri, 20 Dec 2024 09:24:27 -0700
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
Subject: [GIT PULL] io_uring fixes for 6.13-rc4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Fixes for io_uring that should go into the 6.13-rc4 kernel release. This
pull request contains:

- Fix for a file ref leak for registered ring fds

- Turn the ->timeout_lock into a raw spinlock, as it nests under the
  io-wq lock which is a raw spinlock as it's called from the scheduler
  side

- Limit ring resizing to DEFER_TASKRUN for now. We will broaden this in
  the future, but for now, ensure that it's only feasible on rings with
  a single user

- Add sanity check for io-wq enqueuing

Please pull!


The following changes since commit 99d6af6e8a22b792e1845b186f943cd10bb4b7b0:

  io_uring/rsrc: don't put/free empty buffers (2024-12-12 08:01:52 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.13-20241220

for you to fetch changes up to dbd2ca9367eb19bc5e269b8c58b0b1514ada9156:

  io_uring: check if iowq is killed before queuing (2024-12-19 13:31:53 -0700)

----------------------------------------------------------------
io_uring-6.13-20241220

----------------------------------------------------------------
Jann Horn (1):
      io_uring: Fix registered ring file refcount leak

Jens Axboe (2):
      io_uring: make ctx->timeout_lock a raw spinlock
      io_uring/register: limit ring resizing to DEFER_TASKRUN

Pavel Begunkov (1):
      io_uring: check if iowq is killed before queuing

 include/linux/io_uring.h       |  4 +---
 include/linux/io_uring_types.h |  2 +-
 io_uring/io_uring.c            | 17 +++++++++++------
 io_uring/register.c            |  3 +++
 io_uring/timeout.c             | 40 ++++++++++++++++++++--------------------
 5 files changed, 36 insertions(+), 30 deletions(-)

-- 
Jens Axboe


