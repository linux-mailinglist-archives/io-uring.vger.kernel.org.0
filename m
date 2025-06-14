Return-Path: <io-uring+bounces-8342-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 429C9AD9CB1
	for <lists+io-uring@lfdr.de>; Sat, 14 Jun 2025 14:28:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B41A3BA5B9
	for <lists+io-uring@lfdr.de>; Sat, 14 Jun 2025 12:28:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C08A82741AD;
	Sat, 14 Jun 2025 12:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ohTEBvpd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40C819C556
	for <io-uring@vger.kernel.org>; Sat, 14 Jun 2025 12:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749904134; cv=none; b=uAx2b2fY8i91884BJxEuvK0aiRRrZ66ajE9vB4D8dpxHLnMsu6ofnAUGM1QLt9Vr3+yzUohB37W67yE8ormDAdkQ064V6zr5KdABX8ySVpfF7Fpzz2v/wW0aA86jI0OjOwcCgGpzhyJc2ZZUNpqR2Qv9NNN+EGcwxIfAnbLUSUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749904134; c=relaxed/simple;
	bh=luVPsm0ZJtpzEoJXZ7Gia2mz0TF3bzMoMd6tGdVcUYM=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=jd7q7yfuPssL34uqHh+AL2GRYNRxrjl3/qfGCe+zxuEfM04I2e2AjicByhIPMcGzzvdvXzgpO0Vxj6kwZSmDa2OIEUSJ5Ol2HyxTEuhWvVY3d/1mZuSbTrl23xdVcBNNxS3G4ArRtNxYIBidwpYs8cxAwGfF6JE/C4rjOoREV2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ohTEBvpd; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-861d7a09c88so91980539f.2
        for <io-uring@vger.kernel.org>; Sat, 14 Jun 2025 05:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749904129; x=1750508929; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9PuA9ojXJi4XwS+Gyd0U71OnhNaOhTHyCWxK1xj157o=;
        b=ohTEBvpddUnVxMSlcAPtVm1GOkMQy3nvjvvAvdOosujDECBVeGPHoECZ6ai+obLOD8
         b3tEyFLoaQCFQyyfmqWG0dhn+QtWeot1yAJFnU516eVN45I05w6n/5jv08nRJa/sQgKH
         NqpoBnVVFxaq5JAImxsFfH3y7AHv5XwitRSK9HqwqK9fdyz8JQzv6rCNTZ3bv9y2COQ6
         ln4L3cunZn3VMN64WlWoWX/y/oz2NJOw7ZIDnWqGpHB/3DL+beaqxuO31vJGVSiJCUOn
         Hx9zyoT79fs+5zLKmLFn98ad8J0JY6czmg30KHWk1G2+rszslL9bSxa49s10jvAJa1m7
         pcmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749904129; x=1750508929;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9PuA9ojXJi4XwS+Gyd0U71OnhNaOhTHyCWxK1xj157o=;
        b=cMSfhc/L4jJQYbH9Awgtth/m85BgxMxG3HZXpNsLAjpUFuNGXbACKNTNxUah9KapOg
         FxtbHLZwyKrfLkzJZU9yEro0urJJ+kPMWXDMNNY6COMySyDl+aE7oYXGQ5yhpq2MA7Ev
         5f9wHfqlOOIQGNr/KhvDIpAPFmLKdir+o9jcw2msqthkylo2vR+mFsu+HkSvFsA5Nch5
         VrOIC2rq/3CxX4OubEU5bDWEGRFgqJJk8kAwyOVwPKYbGZqzHd8Jui9Jkos5kOtVuJUK
         c4oMfQQhfa5vzxXNEe9FGitIl89IoWlEhSMzUZmCfRdPV6V5Fh5sO3pRYC8kFgngpRda
         xxHQ==
X-Gm-Message-State: AOJu0YzNhdrSME1tZnlY/itKE/I204J5Vca8Xx+Mi/d6tJf5gtJLFTcg
	8LLS7Ylc09kECSDZdMqaS9aracMHjDzSQ12uptFpW7ENMpUNEpC5PyKwXjSVYnd1y/WaYlArlaZ
	EOCL3
X-Gm-Gg: ASbGncvWZSq3t+Y4b+700D2vF7cQH3Ki/4lHnutVBWDt/6IJIYS7C6gCoLveKn4O8VU
	qi3/Xi901j0lLF+Vv8mXy5gYxxgvB9Fgy5PMGi4rPj0mq+UwVHEY3XYmn3aGGUByR42H8x+E4sj
	PuuCLQqJWFYnj4hklj3LPG4tZL8L4fFbxTImtKiBR17nZWXY3cMCZBT1ERV4MukMchqqXQi7csq
	WFCop6LWIbFB2qjHzzejhjAtn3FgxPvM2j3PTbUtCzPSvFs7RHrDxRkAsyJBM100uJRXBaH10AY
	j6A7x481i/UP94opBmDr8JIuGXpyc4aSJ8MZSbpWJHuRaWBhlvNrb0izjSI=
X-Google-Smtp-Source: AGHT+IHYsTPm0ioFfkUPBqQISVvfBx+K3PvCVOdTM5BvT8guNaKxY+0KF6fPjithRgTdJNCjWFghGw==
X-Received: by 2002:a05:6602:158e:b0:864:9cc7:b847 with SMTP id ca18e2360f4ac-875dedb9319mr329951439f.14.1749904129478;
        Sat, 14 Jun 2025 05:28:49 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50149ca2f5esm777867173.129.2025.06.14.05.28.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Jun 2025 05:28:48 -0700 (PDT)
Message-ID: <2b9b7ac1-31e1-4e1b-972d-81ede60d2c05@kernel.dk>
Date: Sat, 14 Jun 2025 06:28:48 -0600
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
Subject: [GIT PULL] io_uring fixes for 6.16-rc2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

A few fixes for io_uring that should go into this release. This pull
request contains:

- Fix for a race between SQPOLL exit and fdinfo reading. It's slim and I
  was only able to reproduce this with an artificial delay in the
  kernel. Followup sparse fix as well to unify the access to ->thread.

- Fix for multiple buffer peeking, avoiding truncation if possible.

- Run local task_work for IOPOLL reaping when the ring is exiting. This
  currently isn't done due to an assumption that polled IO will never
  need task_work, but a fix on the block side is going to change that.

Please pull!


The following changes since commit 079afb081c4288e94d5e4223d3eb6306d853c68b:

  io_uring/futex: mark wait requests as inflight (2025-06-04 10:50:14 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.16-20250614

for you to fetch changes up to b62e0efd8a8571460d05922862a451855ebdf3c6:

  io_uring: run local task_work from ring exit IOPOLL reaping (2025-06-13 15:26:17 -0600)

----------------------------------------------------------------
io_uring-6.16-20250614

----------------------------------------------------------------
Jens Axboe (2):
      io_uring/kbuf: don't truncate end buffer for multiple buffer peeks
      io_uring: run local task_work from ring exit IOPOLL reaping

Keith Busch (1):
      io_uring: consistently use rcu semantics with sqpoll thread

Penglei Jiang (1):
      io_uring: fix use-after-free of sq->thread in __io_uring_show_fdinfo()

 io_uring/fdinfo.c   | 12 ++++++++++--
 io_uring/io_uring.c |  7 +++++--
 io_uring/kbuf.c     |  5 ++++-
 io_uring/register.c |  7 +++++--
 io_uring/sqpoll.c   | 43 ++++++++++++++++++++++++++++---------------
 io_uring/sqpoll.h   |  8 +++++++-
 6 files changed, 59 insertions(+), 23 deletions(-)

-- 
Jens Axboe


