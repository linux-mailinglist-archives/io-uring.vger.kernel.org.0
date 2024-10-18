Return-Path: <io-uring+bounces-3821-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BBAC9A444A
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 19:06:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B36011C21158
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 17:06:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 866ED200C87;
	Fri, 18 Oct 2024 17:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sOh04rHJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA8E14F136
	for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 17:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729271168; cv=none; b=Wpt3cFjeSZN5LtT6BP6NxJ9qr6F0LH12X9cl6TMohqbwuTVjHiB2gTbWHfn7YfwnVwpefu2IgjDcOk4BOBMGIjHRLa+rec+RpbB7g8aBjwn8x5mqvLk9QvsTysRYzB1NkDCwgqMuWNrZb3IqSBJmhC7mw0qy8iro1GhD9vmBl6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729271168; c=relaxed/simple;
	bh=WJbZ24j6V5koJNX1drew5DflLKsWPQ4IY4zVqD0rl8A=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=jnkO/Lt0B2vVxrZD7NpbrmLDhvtW8FbjAcIBNGwZmnuNn6VYQQWsth/T+kBxeU1Sssy2wyQKfKXx1rl2CNzRNllMd+rsX8U6ECMFjHlEHZSvt7jGrSD9EHxVPO8BoxuyxBzTB/aqgdvtBPMPI9uKy2wH+HPqUuCjQRa1JMxdDi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sOh04rHJ; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-83aad8586d3so114018839f.1
        for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 10:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729271163; x=1729875963; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3mTlifwcgCgggi4OKcdW+BAN0zmU3K4EAmzWfBTmXig=;
        b=sOh04rHJ28V1TkycCbxN61l8Ryoa0lDSgv4km8nrK4BA5GHjtw0eTp5UVznR3JdlaF
         BAZ1OgWruOPu9l6ZhbhEKGzSo2XSLOwUai25L8hKFqHxlH4jnK17xPaTqjusfWqwydpD
         NV7yy50fVrTbX8AGiKyE9xqiwB1YqKwszft/6mdZT6EcSuOh6w8sLjVHfJX6zvFdTpgS
         iuNUNw3w5tlwB23TlxDTWsbfSBUrKb7mQC8OZehihDZ6O+M+5XVqyeMyjoi0SwAC5HtX
         Y0Z6X9cMxpZTyn03INtrhlhdxw7aLvjhHFETJNuRykflot813U4UXu4cccsCf5SlA6lJ
         HvtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729271163; x=1729875963;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3mTlifwcgCgggi4OKcdW+BAN0zmU3K4EAmzWfBTmXig=;
        b=OEFYnr2PN5coY8ho8eYNDYj8uAWn6WWLOHPq3lEBD0C3dvX21eTZj3TXFzH49sns7/
         vIBMBHtiJ0eXbH5V4XfX3m84qX8OTi/G0iBhnQ6bR81V3D9lzVjdV1alZKA1KZdats2z
         55lW4H4QsT1Ej6cyk/qrvLEUTAXW10WsngIepnQkhljRTRhh9eXF6F5JVGHwAsJz3oSk
         YscLNoF0kEQXiGRc6VtXKVTgsQar2ZNw9jSI4QK4nbD3IW8fWz5VnRjErarWal91A1c4
         RYpcXogRaQlNUvJVx8iKL7g2dljxk1Nw+Q3125chav4dllOVBBWUvcYKzhZ6snvE6f4q
         +Rhw==
X-Gm-Message-State: AOJu0YxMPxOBhWQtCKWbLuf0uObWjVCNkuva8ZDCAEt3fT38Um+DfX6C
	2gdALczGOf7DGlqBe26ucJNLuMqMlnOISZj7TA3dD+jbuPSb33n43ku5hceO0pT9oDHdZpgdeaW
	3
X-Google-Smtp-Source: AGHT+IFYc6ckgikebdPFdvGBcexOrtFxegkRE/fYrOMBpTX6pZMv/o5mf/xUEe2qCpVpF70yioRYHQ==
X-Received: by 2002:a05:6e02:1548:b0:3a0:9cd5:931c with SMTP id e9e14a558f8ab-3a3f409f34amr33193225ab.20.1729271163309;
        Fri, 18 Oct 2024 10:06:03 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a3f403a70fsm4834025ab.80.2024.10.18.10.06.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Oct 2024 10:06:02 -0700 (PDT)
Message-ID: <ac3e8b7b-fa02-4a70-bd1e-80ab3da328af@kernel.dk>
Date: Fri, 18 Oct 2024 11:06:02 -0600
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
Subject: [GIT PULL] io_uring fixes for 6.12-rc4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Just a few odd fixes that should make it into -rc4:

- Fix a regression this merge window where cloning of registered buffers
  didn't take into account the dummy_ubuf.

- Fix a race with reading how many SQRING entries are available, causing
  userspace to need to loop around io_uring_sqring_wait() rather than
  being able to rely on SQEs being available when it returned.

- Ensure that the SQPOLL thread is TASK_RUNNING before running task_work
  off the cancelation exit path.

Please pull!


The following changes since commit f7c9134385331c5ef36252895130aa01a92de907:

  io_uring/rw: allow pollable non-blocking attempts for !FMODE_NOWAIT (2024-10-06 20:58:53 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.12-20241018

for you to fetch changes up to 8f7033aa4089fbaf7a33995f0f2ee6c9d7b9ca1b:

  io_uring/sqpoll: ensure task state is TASK_RUNNING when running task_work (2024-10-17 08:38:04 -0600)

----------------------------------------------------------------
io_uring-6.12-20241018

----------------------------------------------------------------
Jens Axboe (3):
      io_uring/sqpoll: close race on waiting for sqring entries
      io_uring/rsrc: ignore dummy_ubuf for buffer cloning
      io_uring/sqpoll: ensure task state is TASK_RUNNING when running task_work

 io_uring/io_uring.h | 10 +++++++++-
 io_uring/rsrc.c     |  3 ++-
 2 files changed, 11 insertions(+), 2 deletions(-)

-- 
Jens Axboe


