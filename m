Return-Path: <io-uring+bounces-7260-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27929A73103
	for <lists+io-uring@lfdr.de>; Thu, 27 Mar 2025 12:53:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5379A3B9B1B
	for <lists+io-uring@lfdr.de>; Thu, 27 Mar 2025 11:48:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8050A2135D7;
	Thu, 27 Mar 2025 11:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gtd2ZKLa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF97513C682
	for <io-uring@vger.kernel.org>; Thu, 27 Mar 2025 11:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743076080; cv=none; b=C2sC9GxVcw6Mxs62d9jp3uRMmMQS4BEpUocthavZ5dmSgMuFlyHwlfIJKssGYqjQP4ZQm70RjpTtOTBc9TlIhXBoZKXGsGHmSjxwlEPugrXK8vZrefGkoiEG3qQ5XsP5RxySuGaV01kYhxVy8mUxoFE1mY5aPjlfQYkdQXrASoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743076080; c=relaxed/simple;
	bh=BoZEho9fDL/Gm3ssaM96SrYmA7W8roBBdfVECmZ46Tw=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=bc82AI3sxVkkM+zxqH6hWfzBKWe7XuceYa3MuGfmDbQGxFDZ51WE6IPpLcRVjruBTAspota8yNFxKhdjBbJvbTiusEVa1/T3FSl1cN83t/GD9SIn6wsCsb+LOcWervUFuVz8e4BwNUoH66tAAcdHmc37kTlZjgvjix6IeI5Ia24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gtd2ZKLa; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7c560c55bc1so97775085a.1
        for <io-uring@vger.kernel.org>; Thu, 27 Mar 2025 04:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743076077; x=1743680877; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VBFSr9jjlSrAZe5ddV8UvSH6s11GruYk+AQrtjmhz7Y=;
        b=gtd2ZKLakXAfmtB4x0oIi2p+alW/htvolYbnbGBalX0or9rB7SvmctRCLRLZ/O9enI
         zVjf9sba3aHZHjdEEmKTD4HQvONU/CmokS2QNmXaBdB9FdlScbNVyX3fzULlpCw+Mn2Q
         /5q5pX6/wzRgKizQ98KsFFqmlUXrguo3vWBr0fgwmBCpKb29RAW5EWdjyQpoJIxJ3T7e
         WNR0t4ZYyI7fO9+KYGNMYC7TZUt7E69SQSEqv6wPIKIpmnwlcp54ISLnb9b0WbMPZfzj
         o//68SteFLm4cj2ZtUQXUTPOiH9AmNyun2fZ2USu82+n1+BIODp+W8OESVx08MQvXkFE
         vbPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743076077; x=1743680877;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VBFSr9jjlSrAZe5ddV8UvSH6s11GruYk+AQrtjmhz7Y=;
        b=fhkoBHZc9vUrgRMzcCzoezs4hY2H5e8sUFwC1FDqbacVvvljG1zqFOKjozKG2qjdDG
         FaaOU4t1bFC5MNtcm/qTtU0FwzuGYbeCl9eJy8p+ArJucuMozlgy/FTvN8sieqUYLdvS
         JTkShVZdTEAC4j1DkTJONVPjB0etUBhV8BDZT9KQDmuuMnE9VpArH20IdVvClF+xoSby
         b4O3MQvAHqtp95A/4bIsUGSGoqPnE1rQBjK3oRmiGWIJG2GvbR+UvJD81kbXWJXAq1f8
         jRNhLK0JobVPSPHJZRY9q1YrLIVZC1fV5iDoNsJLXTBQGEKTnbtbAGnpOvDbIS4ARXSS
         qcqQ==
X-Gm-Message-State: AOJu0Yz9nl1UixaQyOsQ6OoA83wq9XmvbMPI5ubAvVMYrY9OmkDnrEWw
	FzcQN/rnRsljadiyGBwk+f0mETpXmoZTIcjBXEj0fv5YBWxo0rL31N/Yvaid1d5gm80TcKTszdv
	sgMo=
X-Gm-Gg: ASbGnctqnhJxNHuHDKmSjzntc0UMmzSfNoHSHQxXV9ekO8K7qDljn5kXhgSztAiv5EA
	XSY5KS7xcOeknQyHMc0hlSKuwrwQ9rRm6skAioFj6lDpBnje0+r51nnfC/c69m1A9ILIwl8qRDk
	fUUzDkSUVwGOvgWY7qh/LrV1FQGdfyU4P7uO42wASMeS3ULYl64kH+uYZQVYsuYIVTpcEDPWrf5
	Z9nFSJAuRsQwitnHMUw1itTdOAS83+XuYfLgcrqQLzlDkBzLnjy4MKwEzWAunEW/yD/FlFUONRY
	Lo5Pr0Mgw1jyQv6Rr0+JWSUUlSJ5QMhab3ghJqw=
X-Google-Smtp-Source: AGHT+IEof9fQbWVlyP+b0Ou7+jNngeRxdWHatTO8Eh9yzKoZm+TxhT3kVY2XswDWarx9apE34wgc/g==
X-Received: by 2002:ad4:5c42:0:b0:6e8:fcc9:a29c with SMTP id 6a1803df08f44-6ed238be16fmr52034666d6.19.1743076077507;
        Thu, 27 Mar 2025 04:47:57 -0700 (PDT)
Received: from [172.20.6.96] ([99.209.85.25])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6eb3ef34792sm78909876d6.68.2025.03.27.04.47.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Mar 2025 04:47:56 -0700 (PDT)
Message-ID: <3ad3c346-1415-45bd-bcb2-2f9b46164f30@kernel.dk>
Date: Thu, 27 Mar 2025 05:47:56 -0600
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
Subject: [GIT PULL] io_uring epoll reaping support
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

This sits on top of the recently sent out zero-copy rx pull request.

This adds support for reading epoll events via io_uring. While this may
seem counter-intuitive (and/or productive), the reasoning here is that
quite a few existing epoll event loops can easily do a partial
conversion to a completion based model, but are still stuck with one (or
few) event types that remain readiness based. For that case, they then
need to add the io_uring fd to the epoll context, and continue to rely
on epoll_wait(2) for waiting on events. This misses out on the finer
grained waiting that io_uring can do, to reduce context switches and
wait for multiple events in one batch reliably.

With adding support for reaping epoll events via io_uring, the whole
legacy readiness based event types can still be reaped via epoll, with
the overall waiting in the loop be driven by io_uring.

Relies on a prep patch that went in via the VFS tree already. Please
pull!


The following changes since commit 0511f4e6a16988e485a5e60727c89e2ca9f83f44:

  Merge patch series "epoll changes for io_uring wait support" (2025-02-20 10:18:47 +0100)

are available in the Git repository at:

  git://git.kernel.dk/linux.git for-6.15/io_uring-rx-zc-20250325

for you to fetch changes up to 19f7e942732766aec8a51d217ab5fb4a7fe3bb0d:

  io_uring/epoll: add support for IORING_OP_EPOLL_WAIT (2025-02-20 07:59:56 -0700)

----------------------------------------------------------------
Jens Axboe (5):
      Merge branch 'for-6.15/io_uring' into for-6.15/io_uring-epoll-wait
      Merge branch 'for-6.15/io_uring-rx-zc' into for-6.15/io_uring-epoll-wait
      Merge branch 'vfs-6.15.eventpoll' of https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs into for-6.15/io_uring-epoll-wait
      io_uring/epoll: remove CONFIG_EPOLL guards
      io_uring/epoll: add support for IORING_OP_EPOLL_WAIT

 include/uapi/linux/io_uring.h |  1 +
 io_uring/Makefile             |  9 +++++----
 io_uring/epoll.c              | 35 +++++++++++++++++++++++++++++++++--
 io_uring/epoll.h              |  2 ++
 io_uring/opdef.c              | 14 ++++++++++++++
 5 files changed, 55 insertions(+), 6 deletions(-)

-- 
Jens Axboe


