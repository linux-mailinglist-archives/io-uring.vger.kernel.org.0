Return-Path: <io-uring+bounces-147-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BB8A67F67D4
	for <lists+io-uring@lfdr.de>; Thu, 23 Nov 2023 20:50:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 49BB4B20B08
	for <lists+io-uring@lfdr.de>; Thu, 23 Nov 2023 19:50:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43F424C3DA;
	Thu, 23 Nov 2023 19:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XMrvSN5d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93034D40
	for <io-uring@vger.kernel.org>; Thu, 23 Nov 2023 11:50:12 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-6cba45eeaf6so287300b3a.1
        for <io-uring@vger.kernel.org>; Thu, 23 Nov 2023 11:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1700769012; x=1701373812; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hMga94sP0H5811wKlrEF4Z2pVUD5+ReJtaBu+uL/CHg=;
        b=XMrvSN5dMllMn+/1/6hmUF5YyHzaMDn/SEEUgwYl952T9GORFxEqeYeQR6rd6lRQBk
         VDangA55jMDNPEHLbb4WyBRXfYaSWtF7DIfsxMOyW7/QJ3cH641slmdO9Q+7n99nYWHu
         9ed/p0rxsSRQ4YzjrbBeXSKhf4DfuDNjPUB5yRWDxGT7E5M//yYgXugjji2lO+6u4Rjv
         0Qf70+z4kK7S1B2HXxPyWY/4XSnk8k0ZwnV7+wezYQMW3im2LPtKNBGXeMWiBAAPT1LR
         g5hI30OR+wIEjRb3lXxqIo2fzZ3tb1n8TY/AUgfDwhwnZzqrhqjm8thwlF+++4J0r+iC
         noXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700769012; x=1701373812;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hMga94sP0H5811wKlrEF4Z2pVUD5+ReJtaBu+uL/CHg=;
        b=fn1XauHrnu5MnwYkQVOMshL4PhLAwfCB3NdtRI9WUiy0QrXHiviXBeKbWP3wTgusZP
         ElNhZ224lIThtL75NAuCnrZ6oEtePQ/eLOBiFHqWvqG3JAUpQZjMD2ZKX9dJQb/oNkZq
         RQDnbKaEKNoK9SRnEeeh54WosFQleQfBD9bPOZeWYlEXAq5MoTxjn0R0mh9CIftDX6ch
         utrMBsjnA/jt3mH18xRZyxStj5xhac4G1h3Z8lIi/n504Z3ade3T1iwXeqPtlR/lnuf8
         c4kQkKsZfESg9Ed8GSDUQ8FuHdCDiVTzlqUFbZ7AgRaonvweHVDtkdwjZz9xop+d9Eo/
         vmfg==
X-Gm-Message-State: AOJu0Yy1ZOiV27Cb4wW8oPXhyRow/1KYXEXnzlZwyMpeMdnh1VAPrnxV
	p/4nISIbMmQpg6ycmDZmAB8s16N43jJIbBZgfkVRvQ==
X-Google-Smtp-Source: AGHT+IGSzM5gA4rNudXWapFjvxRT2UVdpEwEaLha0/q9xK06LtQYQ3es+i23C+gxWQuYYmE+dH6j/Q==
X-Received: by 2002:a05:6a00:2d19:b0:6cb:b6e3:e007 with SMTP id fa25-20020a056a002d1900b006cbb6e3e007mr548711pfb.2.1700769011975;
        Thu, 23 Nov 2023 11:50:11 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id b12-20020aa7810c000000b00690c52267easm1573107pfi.40.2023.11.23.11.50.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Nov 2023 11:50:11 -0800 (PST)
Message-ID: <14e0cca0-03b5-48d8-8976-28170e105d8d@kernel.dk>
Date: Thu, 23 Nov 2023 12:50:10 -0700
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
Subject: [GIT PULL] io_uring fixes for 6.7-rc3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

A fix for ensuring that LINKAT always propagates flags correctly, and a
fix for an off-by-one in segment skipping for registered buffers. Both
heading to stable as well.

Please pull!


The following changes since commit a0d45c3f596be53c1bd8822a1984532d14fdcea9:

  io_uring/fdinfo: remove need for sqpoll lock for thread/pid retrieval (2023-11-15 06:35:46 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.7-2023-11-23

for you to fetch changes up to d6fef34ee4d102be448146f24caf96d7b4a05401:

  io_uring: fix off-by one bvec index (2023-11-20 15:21:38 -0700)

----------------------------------------------------------------
io_uring-6.7-2023-11-23

----------------------------------------------------------------
Charles Mirabile (1):
      io_uring/fs: consider link->flags when getting path for LINKAT

Keith Busch (1):
      io_uring: fix off-by one bvec index

 io_uring/fs.c   | 2 +-
 io_uring/rsrc.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
Jens Axboe


