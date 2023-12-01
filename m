Return-Path: <io-uring+bounces-199-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EE02B801336
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 19:56:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7DE27B20C59
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 18:56:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4904B3D980;
	Fri,  1 Dec 2023 18:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="m4cHoOJQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD23F3
	for <io-uring@vger.kernel.org>; Fri,  1 Dec 2023 10:56:40 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id ca18e2360f4ac-7b359dad0e7so30072439f.0
        for <io-uring@vger.kernel.org>; Fri, 01 Dec 2023 10:56:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701457000; x=1702061800; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IgnuHKh5LC+z0FjdbZ0jiY9f26wDR+NHd95CZDdHMIo=;
        b=m4cHoOJQGFi40XLcYx+UVnMMpUVys5aXugUm6cMW6XJioNA+2LbmGpl8hIhBu7W9J9
         8HZEDVJ3B82FzJ7ab9GNmYKuY9+8HsAEp/VpMh7J6+Obzoar2H3HaV7r9jIi3Uxvn6Va
         /utwt+G3Rgl3BIViKgC3qma9AFl2qEBkqzaEeO6KqSBcWnhbhpZ0wo/wrV2+4ibbqCPg
         aEZjG3K3f3/jmJkivbEpD+wS7bnh9OCO4XtNnYhILMrII/RNhiIux+rh/F0IYV8OBnsu
         ZL/7xvT8Z7P+F/AM0G67ZAEHhW9r0JNPOCV6rmfDQEoQgIB8mMM8D+zJxyquZBPWC/HN
         fk1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701457000; x=1702061800;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IgnuHKh5LC+z0FjdbZ0jiY9f26wDR+NHd95CZDdHMIo=;
        b=GX+wvgimsN6Y8so1QzvitmomGE9wJsGbbMi7fDVoeEDNQU9LlobOMoj897n6tYnidp
         Ifna49lSOtabtyjy0f3WNcmrdv2ADnkOjR3iilZO4diCj5S4utB9xwdFqyL/xWNob8mu
         PuDgLzAt9dBmDqTp3Jqvbbd69QC1uBOI8p0gJxSQ4sJD0c+O4gn4ClKyQRILy/xP+WV6
         2ri19mTn1QFzP3zN9JIrI2W2fdUgETTNAlioQrx3nOSQM/F3p0td5DiS11H8mdnmIJzG
         JsFNWqdicxAhIL5be/KJJtpXEqrVsAIzOtqVdTpSqnVLa2p9Tii3/lky+Smyx0OsQNy0
         FKAw==
X-Gm-Message-State: AOJu0YxN9JGU3n+o1mR7md1uNFrdvukSnEt2NR9dmVIfQVhzOkF63k1Z
	tM7W7KnFPYDiEez9X8eeDViQN7YxXQfYJXs/Zq1ytQ==
X-Google-Smtp-Source: AGHT+IHS84qzaSd1+0MBGwsnRamqF0uEixv9GH7Q5QK4VKEhLdAHyctMOT6UvU0Qi9lx3z9sTYVnow==
X-Received: by 2002:a6b:6915:0:b0:7b0:aea8:2643 with SMTP id e21-20020a6b6915000000b007b0aea82643mr6859610ioc.1.1701456999926;
        Fri, 01 Dec 2023 10:56:39 -0800 (PST)
Received: from [172.19.0.197] ([99.196.131.174])
        by smtp.gmail.com with ESMTPSA id gs26-20020a0566382d9a00b0042b37dda71asm1015204jab.136.2023.12.01.10.56.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Dec 2023 10:56:38 -0800 (PST)
Message-ID: <a9499ad7-e4b4-4af4-8165-336aad7913a3@kernel.dk>
Date: Fri, 1 Dec 2023 11:56:29 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.7-rc4
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Random assortment of fixes, either heading to stable or fixing an issue
introduced in this series.

- Fix an issue with discontig page checking for IORING_SETUP_NO_MMAP

- Fix an issue with not allowing IORING_SETUP_NO_MMAP also disallowing
  mmap'ed buffer rings

- Fix an issue with deferred release of memory mapped pages

- Fix a lockdep issue with IORING_SETUP_NO_MMAP

- Use fget/fput consistently, even from our sync system calls. No real
  issue here, but if we were ever to allow closing io_uring descriptors
  it would be required. Let's play it safe and just use the full ref
  counted versions upfront. Most uses of io_uring are threaded anyway,
  and hence already doing the full version underneath.

Please pull!


The following changes since commit d6fef34ee4d102be448146f24caf96d7b4a05401:

  io_uring: fix off-by one bvec index (2023-11-20 15:21:38 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.7-2023-11-30

for you to fetch changes up to 73363c262d6a7d26063da96610f61baf69a70f7c:

  io_uring: use fget/fput consistently (2023-11-28 11:56:29 -0700)

----------------------------------------------------------------
io_uring-6.7-2023-11-30

----------------------------------------------------------------
Jens Axboe (8):
      io_uring: don't allow discontig pages for IORING_SETUP_NO_MMAP
      io_uring: don't guard IORING_OFF_PBUF_RING with SETUP_NO_MMAP
      io_uring: enable io_mem_alloc/free to be used in other parts
      io_uring/kbuf: defer release of mapped buffer rings
      io_uring/kbuf: recycle freed mapped buffer ring entries
      io_uring/kbuf: prune deferred locked cache when tearing down
      io_uring: free io_buffer_list entries via RCU
      io_uring: use fget/fput consistently

 include/linux/io_uring_types.h |   3 +
 io_uring/cancel.c              |  11 +--
 io_uring/io_uring.c            |  95 ++++++++++++----------
 io_uring/io_uring.h            |   3 +
 io_uring/kbuf.c                | 177 ++++++++++++++++++++++++++++++++++++-----
 io_uring/kbuf.h                |   5 ++
 6 files changed, 224 insertions(+), 70 deletions(-)

-- 
Jens Axboe


