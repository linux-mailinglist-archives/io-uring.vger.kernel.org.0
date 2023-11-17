Return-Path: <io-uring+bounces-96-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6057F7EF721
	for <lists+io-uring@lfdr.de>; Fri, 17 Nov 2023 18:41:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DA561B20B33
	for <lists+io-uring@lfdr.de>; Fri, 17 Nov 2023 17:41:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3924199BC;
	Fri, 17 Nov 2023 17:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DOI6Ix8b"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C7BB3
	for <io-uring@vger.kernel.org>; Fri, 17 Nov 2023 09:41:25 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-5c43fa8ea06so5598347b3.0
        for <io-uring@vger.kernel.org>; Fri, 17 Nov 2023 09:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1700242884; x=1700847684; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=atxC4y6LnqH8JKMlK0fxB4FNMBm/aW8usFle3Un9b4A=;
        b=DOI6Ix8boT5fGYi/haLpVOdaRGHskq00yRToLXrBtW3Q549wlXPBkB6T5oTf6VX1zI
         zwW5sfPqjitZxwbrjLtsSdixp0KwekL1VmAGtWepKVaBxvVqRHjlZXjtU3H1fFbJOo+V
         23TgL6OVXZpJRkV+c4ZkkBuxMZtStkn+mLTtJJ8nbmN70Jzkf41yX4K6C9xBXKAL/D1f
         gwuMWGcMiS10xdls7PNtcBtJGj5mO1wB3mlWUMC1B/Kmu/dQ+BsRhbvvx84tU84BfLp6
         SJyk4l8QQgmFUMIqCxVaXKAndb3SOMThrcKtwpHyYMnKLFXpOyLCR8k/SqAnwKr3cVBV
         aXhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700242884; x=1700847684;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=atxC4y6LnqH8JKMlK0fxB4FNMBm/aW8usFle3Un9b4A=;
        b=TUG+nF0HURkvzUmB1AxY98wbIFQV/sAIUqOmqpLZD9zsK8aXQNomQuW6OPkdVHy6sm
         05Bw4dTtdF65SCEL30oW0wBs0PSLJj6EdC9U/myf6WB1YgS84n4mdUduh3wmU7jm5IlF
         L+TZEAElY+qjyFCTQB5MNov9fOJ5U6x9kHlhUkGYBQAIEQ3z4amNmfnHsOBrLSzUEb32
         FdjEpOWbGHNkDEi2WFDp8mDlvuP+huLYnDJGhiUhtSSnJcEusfy+QbEk16hR10MAvv6o
         JEnjsLOZZUZMDlccoZ7NDlk/JtO76v4c0d8uXOq9NnvqAItaE3qUdHUx9mXSnkk+0nB6
         Q4Lg==
X-Gm-Message-State: AOJu0YzEigEmYU4mTb1HfZsvR5foTJ5HGmjOpBwWopnzbt6eCeYulGxc
	CMs1ut+B7/1PTjBju9+/8c/bkzHgS+aVMGOhd+HRIw==
X-Google-Smtp-Source: AGHT+IHh3w9R1W8jzw7bTWI6vptHgNecjUaMJlJwO46xj+XQPXmQmZexLrIPHVjdVca94iFMfybKCQ==
X-Received: by 2002:a81:e50c:0:b0:5af:778e:d53b with SMTP id s12-20020a81e50c000000b005af778ed53bmr316100ywl.0.1700242884613;
        Fri, 17 Nov 2023 09:41:24 -0800 (PST)
Received: from [172.16.1.212] ([65.207.165.42])
        by smtp.gmail.com with ESMTPSA id a124-20020a818a82000000b00598d67585d7sm596106ywg.117.2023.11.17.09.41.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Nov 2023 09:41:24 -0800 (PST)
Message-ID: <f5892835-cf39-42ad-8280-e9f63498ea96@kernel.dk>
Date: Fri, 17 Nov 2023 10:41:23 -0700
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
Subject: [GIT PULL] io_uring fix for 6.7-rc2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Just a single fixup for a change we made in this release, which caused a
regression in sometimes missing fdinfo output if the SQPOLL thread had
the lock held when fdinfo output was retrieved. This brings us back on
par with what we had before, where just the main uring_lock will prevent
that output. We'd love to get rid of that too, but that is beyond the
scope of this release and will have to wait for 6.8.

Please pull!


The following changes since commit b85ea95d086471afb4ad062012a4d73cd328fa86:

  Linux 6.7-rc1 (2023-11-12 16:19:07 -0800)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.7-2023-11-17

for you to fetch changes up to a0d45c3f596be53c1bd8822a1984532d14fdcea9:

  io_uring/fdinfo: remove need for sqpoll lock for thread/pid retrieval (2023-11-15 06:35:46 -0700)

----------------------------------------------------------------
io_uring-6.7-2023-11-17

----------------------------------------------------------------
Jens Axboe (1):
      io_uring/fdinfo: remove need for sqpoll lock for thread/pid retrieval

 io_uring/fdinfo.c |  9 ++-------
 io_uring/sqpoll.c | 12 ++++++++++--
 2 files changed, 12 insertions(+), 9 deletions(-)

-- 
Jens Axboe


