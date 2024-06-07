Return-Path: <io-uring+bounces-2138-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FB4B9009AA
	for <lists+io-uring@lfdr.de>; Fri,  7 Jun 2024 17:55:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D0916B218A4
	for <lists+io-uring@lfdr.de>; Fri,  7 Jun 2024 15:55:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 323B11991D5;
	Fri,  7 Jun 2024 15:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="urNQiQS2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D5B19939C
	for <io-uring@vger.kernel.org>; Fri,  7 Jun 2024 15:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717775723; cv=none; b=YDEE7dCuf1OVkzAT40QCD5Hv3Z8qEp+LJolW3yDtme4VKPvU/cEGBw4IPs84JILUcsQAmxw1p3LIV8Kv0OpBmD4c8rBjY1E++YohFvHdvindMfCslyLOcQwtLAfs25i3YxGCS7fS3/jJWYESmwDungvG22kX8avN+gl195BPPrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717775723; c=relaxed/simple;
	bh=rVTYCCD+6wuPUQA58naD6ESPH5JNnGt1I/qyYsZNFiI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=Lu0SzwLvqGhmfU8Leny7g8jxkvq54aOr8FSvJzM/IzYq/n0enECwrQB+vH9dxbGSXCDP2GqNuWJJLNum5UIY87A1rwLRUu0Xr59pdY5W1Vv6QnQp7jgr5YknLEx+Pou5R6/vG5svuI5FZnB7Hlo/EMzXs4Z+a6IWgIHqTLk9PiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=urNQiQS2; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-6f95aac8cdaso33803a34.0
        for <io-uring@vger.kernel.org>; Fri, 07 Jun 2024 08:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717775719; x=1718380519; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HZjzr8ACe3RFaiG8HuTKpdP2YO7pOOk9cvbRvl4sxzM=;
        b=urNQiQS2LRxBmzRS5uxX0HyGBP0ivgmo3+IkT6qwAAztrkca5TrEflJAHEygNOKCFE
         tIX5y8MUWp4pmy/NnxTAzOlMDdpvE7zn9bz+ijjRIUiOB7rjxP3lT8dBC4S5x/j1c9yl
         +bcEdomIZEHqPrHcgGOT9/q4NigvnOG95D1AyPQJIIMGIeV5Hb5sZqNYAGdwnC0pBubj
         tigcYZaAB8zPYzhldqsZ+OxBq9dkBlLmDNIZ0v/f/3PHM1qbVQzAXHprFqzgkDWPfXXY
         /UDu4LhnIUeBQP7d/Q5Cy5KNGGfLSII9y0eph2M9FK7dKgmI4LrQ97Oxj+wEQnMlUzgF
         MHGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717775719; x=1718380519;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HZjzr8ACe3RFaiG8HuTKpdP2YO7pOOk9cvbRvl4sxzM=;
        b=PMTseb4VjEfw5uIFtXcEgYZ/YcJ+PQfJQXrwkY5JYjK+GhpSXdbGCLYeTD8bKjk1Ly
         aGbFJCXNcjaL7w1oVMDVQMTbKyWhyA1f0QFMiKY0CL9DWIHBaDzdE7AFb7OdVkW+9p/R
         VbXZpLnTrm3flYM52NZjb6p7dfYe/3N3lAD8PW6a7lqsS+u7hAZRMM3uZyshuxh4L+oH
         JQno9g0K0jRIRJmP2fyl14Zb914urHhpg8fExRseURzcFH6OE45ubZ0rM8XKpvfmjMlu
         54ypeaGKeTDnXBZgHRfHhC+tcs+8ZK9p8B5qUNY/J2jP0OdRktziOmDJqEGntCt0JmmD
         1/AA==
X-Gm-Message-State: AOJu0YyIywmaamPD3J2yMZt5z3O13J0AfDM8P0x3mA6gFHfrU7GCy45v
	V3cZ9ZhESJOLZEekaCbPg2/E/cuCcmDs8RjPqnirDMQCU9s50BSeyNcqc6W9VlC9xzXZ0qtddCJ
	S
X-Google-Smtp-Source: AGHT+IEVx7uw7d7MZQNpRqLavAQ3Q6sE7G/jgdyAfoQlqqD8Xa3Va1MhbrEiczaI0gQO5tWB2VJsGQ==
X-Received: by 2002:a05:6830:3d87:b0:6f0:e6a2:f619 with SMTP id 46e09a7af769-6f9570d44c5mr2926300a34.0.1717775718972;
        Fri, 07 Jun 2024 08:55:18 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-6f94dc70ba5sm728056a34.15.2024.06.07.08.55.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jun 2024 08:55:18 -0700 (PDT)
Message-ID: <ab15af52-d76f-4c68-bc22-12b41860106a@kernel.dk>
Date: Fri, 7 Jun 2024 09:55:17 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.10-rc3
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

A few fixes that should go into the 6.10 kernel release:

- Fix a locking order issue with setting max async thread workers
  (Hagar)

- Fix for a NULL pointer dereference for failed async flagged requests
  using ring provided buffers. This doesn't affect the current kernel,
  but it does affect older kernels, and is being queued up for 6.10 just
  to make the stable process easier (me)

- Fix for NAPI timeout calculations for how long to busy poll, and
  subsequently how much to sleep post that if a wait timeout is passed
  in (me)

- Fix for a regression in this release cycle, where we could end up
  using a partially unitialized match value for io-wq (Su)

Please pull!


The following changes since commit 18414a4a2eabb0281d12d374c92874327e0e3fe3:

  io_uring/net: assign kmsg inq/flags before buffer selection (2024-05-30 14:04:37 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.10-20240607

for you to fetch changes up to 73254a297c2dd094abec7c9efee32455ae875bdf:

  io_uring: fix possible deadlock in io_register_iowq_max_workers() (2024-06-04 07:39:17 -0600)

----------------------------------------------------------------
io_uring-6.10-20240607

----------------------------------------------------------------
Hagar Hemdan (1):
      io_uring: fix possible deadlock in io_register_iowq_max_workers()

Jens Axboe (2):
      io_uring: check for non-NULL file pointer in io_file_can_poll()
      io_uring/napi: fix timeout calculation

Su Hui (1):
      io_uring/io-wq: avoid garbage value of 'match' in io_wq_enqueue()

 io_uring/io-wq.c    | 10 +++++-----
 io_uring/io_uring.h |  2 +-
 io_uring/napi.c     | 24 +++++++++++++-----------
 io_uring/register.c |  4 ++++
 4 files changed, 23 insertions(+), 17 deletions(-)

-- 
Jens Axboe


