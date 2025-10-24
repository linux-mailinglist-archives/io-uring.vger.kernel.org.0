Return-Path: <io-uring+bounces-10188-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 63C0AC06988
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 15:59:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 84C1619A761C
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 13:59:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81AC9320A08;
	Fri, 24 Oct 2025 13:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ihsKJEul"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21B7320386
	for <io-uring@vger.kernel.org>; Fri, 24 Oct 2025 13:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761314296; cv=none; b=TTLFflZPLvPSBnuR7f3EW98k8slwVNEQcqnFeCHVBeyL7N/mqXtfOl9F9v600uifUEOlkweDrUxuToqKgn+N/ajy3tr/VC3ksjjoV0BjF9w1ZIlrpYwYrjyZcWuZZhVl40lUGpW+VxD5md7fOj0L3cJtwVFF9Zz6G3njbJCxh9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761314296; c=relaxed/simple;
	bh=hhWGgPZVrScqKojkhjwFx9OV3O+dBo/OrV6wmNEwm+U=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=erLKUk2Eg9TjPGy8jninhwLpmzAQ4m1YXRYFrtj5BKgizHO/i+9UhuCfEAJ6RgE9VzoU/mqz77p/v9YCX4EgOISibXN/XMck2mArY5tjHbzn7tJ12Zc5Ud40g4g4ZZrHs95H7wHKMcVkg7XlHxiTb5NhPDMWYcjOf5lDJaCMCFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ihsKJEul; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-93ba2eb817aso198051739f.2
        for <io-uring@vger.kernel.org>; Fri, 24 Oct 2025 06:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761314291; x=1761919091; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zuLxgtMkO9oR4c6knTEi3Gl+89vfzh19jpxK7UiAaBo=;
        b=ihsKJEulAgPy7ag5b0+HFc0cQjSr9zWHlwp5V2/su2wtzE22/hz/zbMgQ0NvBc8pQ5
         B/hzCzHqZhpJynIJzdYVz+D9qd4/RaO7+RJcAm+rOay45NB/+9oXpBaQXbHoQ32LO6JO
         NcxVpZf2b3MqWaiYtiIiwZ5bQYQTwi/N+I8Qo61JSCRCr0l6xmTb0VRfDk9F0Lz7Gfse
         O49ikXvjnch62oTn6L4xCRfZeu6TVJT0KZGT+2YlbTO3UiAZFejVKSSc1rcdMCdZkUDs
         OrLv554PQSEWv2+IYp3nkHPKyNStTLAz2gWCy7Dvm77aSVH24gg5QuWmo26bhGmrdHNG
         K6Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761314291; x=1761919091;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zuLxgtMkO9oR4c6knTEi3Gl+89vfzh19jpxK7UiAaBo=;
        b=fZjhmbO6lgjZ1AyCLB5kiDTU+fv4f19k8x7NDLUzVv8dDIrV4B6P+auOjIzA0An1N7
         Vq2clloktqHXjCwG6PEhVs0gqRkntKH8j1Wl7P1k/xgka4qSJbLIFW0Ru3+GhWnJVq0d
         rxpktfcmTIlsN4iGbUzi8nA1OzIgSMCKMyHWNgIHx1DrY7B66Y2YGfzk83hCezTQHOBf
         gnYCpLsWcE35YFLJZjuj9yKw7B39UoyWf8lCaJrM6oCwzCLwScgj+o8jd9R7VqU7tdob
         wcVWf4CqO1dCCLHUEvbVrx6vajwJbCw5H9m9waRu+ZgxfQFmZhJZiB6nd9UBb/IiLitl
         3ezA==
X-Gm-Message-State: AOJu0YxmL9uxnxs0uuKoCu9bfqjDrejwwrYqxgKLdsc6AUoTBQix7Ooh
	RjAw1J364YhnjG7H7Wu36z5KCjPUg9T5ydKROmj2ybA5jk2rDd0/R4Cbe+jdh+54/ARLnR6gi7N
	/+P12Sd4=
X-Gm-Gg: ASbGnctc4uoLkOpCiXkxemFHBUy/mQpcaTkS16pewx3c3rYRQfp+3qfU3DCdDLJOS02
	+8bgiKII9DfX1oRvrXzzOKJUc3tCeykaM6vg8Vt1oW4DJwW5nvoeVPBMa4NFxFPx7PKPymp2i2H
	TjUwXlSedEwa5nyZpGvRk1C7zNb1B3XElQE7YhU0ErkxNxm8nDuxeg97WUA+4tDThRmRd/tOE6l
	PZUlITdX3es7dE9k41S6YK7ETjOlxxK6ujTM0/ynEGmYVrU4JfcuTUKXyDh6YxfwEjlzqo3c2ik
	aOtliub97s1kZVGrcmCs/eCF29fofX1wV7QxaVJvcsbERUUUqCjWqlEzXfYwxblwALeusRi+Yw8
	EDfOyRw/Bd0s/QhPvTLquGjWxky2AdmaO2RLX2qsfEM1sujQlhQkpfKlEbTz/Yz9UDVcPCjNFbw
	Yxg+qFJ+F7
X-Google-Smtp-Source: AGHT+IHaDix7j36TPUAiatWKGjNXJvWOifi7XBcS0I/c7c1YIcTMQz13yCaKYUKR+bCrGjZF6+5QAg==
X-Received: by 2002:a05:6e02:1707:b0:430:ab98:7b1f with SMTP id e9e14a558f8ab-431dc1e2718mr86617855ab.18.1761314291274;
        Fri, 24 Oct 2025 06:58:11 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5abb5828249sm2158814173.23.2025.10.24.06.58.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Oct 2025 06:58:10 -0700 (PDT)
Message-ID: <32011c0c-7c43-466b-99a8-7fc3a6b661ac@kernel.dk>
Date: Fri, 24 Oct 2025 07:58:09 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.18-rc3
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

A few fixes for io_uring that should go into the 6.18-rc3 kernel
release. This pull request contains:

- Add MAINTAINERS entry for zcrx, mostly so that netdev gets
  automatically CC'ed by default on any changes there too.

- Fix for the SQPOLL busy vs work time accounting. It was using
  getrusage(), which was both broken from a thread point of view (we
  only care about the SQPOLL thread itself), and vastly overkill as only
  the systime was used. On top of that, also be abit smarter in when
  it's queried. It used excessive CPU before this change. Marked for
  stable as well.

- Fix provided ring buffer auto commit for uring_cmd.

- Fix a few style issues and sparse annotation for a lock.

Please pull!


The following changes since commit 18d6b1743eafeb3fb1e0ea5a2b7fd0a773d525a8:

  io_uring/rw: check for NULL io_br_sel when putting a buffer (2025-10-15 13:38:53 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.18-20251023

for you to fetch changes up to 6f1cbf6d6fd13fc169dde14e865897924cdc4bbd:

  io_uring: fix buffer auto-commit for multishot uring_cmd (2025-10-23 19:41:31 -0600)

----------------------------------------------------------------
io_uring-6.18-20251023

----------------------------------------------------------------
Alok Tiwari (2):
      io_uring: fix incorrect unlikely() usage in io_waitid_prep()
      io_uring: correct __must_hold annotation in io_install_fixed_file

David Wei (1):
      io_uring zcrx: add MAINTAINERS entry

Jens Axboe (2):
      io_uring/sqpoll: switch away from getrusage() for CPU accounting
      io_uring/sqpoll: be smarter on when to update the stime usage

Ming Lei (1):
      io_uring: fix buffer auto-commit for multishot uring_cmd

Ranganath V N (1):
      io_uring: Fix code indentation error

 MAINTAINERS          |  9 ++++++++
 io_uring/fdinfo.c    |  8 +++----
 io_uring/filetable.c |  2 +-
 io_uring/io_uring.c  |  2 +-
 io_uring/kbuf.c      | 33 +++++++++++++++++---------
 io_uring/net.c       |  2 +-
 io_uring/sqpoll.c    | 65 ++++++++++++++++++++++++++++++++++++----------------
 io_uring/sqpoll.h    |  1 +
 io_uring/waitid.c    |  2 +-
 9 files changed, 85 insertions(+), 39 deletions(-)
-- 
Jens Axboe


