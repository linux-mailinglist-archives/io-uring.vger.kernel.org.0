Return-Path: <io-uring+bounces-5156-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DE9C9DEAEC
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 17:27:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 04436B209C6
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 16:27:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 768EE149E17;
	Fri, 29 Nov 2024 16:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="O9BSLrya"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D88645BEC
	for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 16:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732897661; cv=none; b=YDuuoFvfF3E7h+sUP5P3nniRw+bjUJrrj/UFE2eLvJ5MqjEja7PKIsUk7B2gx/CBeQtgfYKiiXil+RYJW0R4bSXOTINn1MeBehfNkvfeCvMxBUELEnRZs8e9V4jm2WR6nMeDl7DVcylqDLrOPMC98pb8k6D2jkXQwDfenDLLtBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732897661; c=relaxed/simple;
	bh=7oC68dLt+3lFaPQLx5y7vxaOm4NGg/3Vj02oeuv2CqU=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=aXEGMxZnrsAwtKaZPwMBReX9PT8TEAOivTCbIkliHaBWjVfRxvku/9KDSNuk7eiR/CtVHGfp4bMMSScipvwZhvNjpC8LGktvn30h4SyhMo+mg2QZ7HQ8+YVKSva0RDXg2JaRTo+7yEmG4dGWeippuGPz1J+zTB3Bu8TLH1hkbbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=O9BSLrya; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-724f0f6300aso2295616b3a.2
        for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 08:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732897657; x=1733502457; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oASEyJ1zRyFgWyNoO9O/z2XFPPdfl7lpJNGxZoc8WsI=;
        b=O9BSLryaCe1knuojEa1rjlSVteSJ/SOqggX3Uuk+Jf9HIFFwgXTz2kpb6dZwO4GKcr
         lmxRtRCXkxNvmYEQqz165AyH6PG8KYHr1FdVQMyiitM3aPEDQSqx71ugsIE4c8QUyZuC
         t9oaM/hSp61AsgOpPEzp1vj2X1/wDML1KXC9c92JntAKQ4ea0cx6a8GjXCquccwH1o/B
         iZH7HcfbX9x9nXybsUDaFf8BNRQejAc+g0WwiuTlgTgvPE4SYDJOMlXzJbtBHHTlQI7M
         X8BxNyL5HrHGPQxspINUSzqB5D3sYaRzXrsF/n50S59uKFAXT8u+VZj7OJJHOk7xECtZ
         NK3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732897657; x=1733502457;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oASEyJ1zRyFgWyNoO9O/z2XFPPdfl7lpJNGxZoc8WsI=;
        b=ChgDWXnemaouCzKfuj3skOoX3yg420NCL8zvBikuQDFWdxcttZEMxvhP/U+hksCc/q
         WXFe946qwmR+YrROkrS/Lld9PUoCeNi2LI/lhWuQMUxfd8XfkKRvl48gfV7RNcJIGKRl
         pV5mrktRmY0/NcULNS+yUkDLcDAI73eVdUrtfu6HItwGTh7Jv2jX635kGuKMWqBDXqRu
         20xTqato+ZeDwzhOOpIoXRX4E66a3eTPcNDbqWQPTqRcDqpudAr+qGzXje6twEt+/+It
         9FZW14f0c78rp24Loxi7ykXbZChNFjKE5IsclRTpmy/MJnmKUpl6K7tghMUo0ogUhi9i
         iHdw==
X-Gm-Message-State: AOJu0Yxe3WaXRjSGr3c/R8/zRlFa6U0s2oLAX4dlR04PO5uuNeMZyse/
	Kvklz0EdnuL20K6Zg7TCH6SDfNTQOFYa/ewOSYcaktVVXjFC0Tdc4Z62DnhF/PG3Y21eNk5lA8i
	7
X-Gm-Gg: ASbGncsIOe0Y+vsNk9GzbFjgT0BxCR6ItttIreTvOLu+qhzUpap2Mt8yWj1cdMvyCsj
	Ynr6qmvEFUPY9tjimCTylRdnqZ0BeOUECryIYUF9daHLoAeJV3WjoGQpLv4gc+uGFnR27KvvYyc
	22JH6X5VYA97NZX1+O0le9FHxLcPdMsqyO97Su1YlYh6uK5cK27PySVX3V2uxT31cYOHOj5mY1J
	L41W3XZWv8tp94yUI9FtEQ45Q9xJ1oU6c7Jisf0839vvwQ=
X-Google-Smtp-Source: AGHT+IGxkVtbYxLPHHCXFt/4xXigrQPty143j+jfnxUYO3WHgnqjWbSEaDwuWayJ/bzDFs8UkKPE4w==
X-Received: by 2002:a17:90b:33ce:b0:2ea:6f90:ce09 with SMTP id 98e67ed59e1d1-2ee094caf5amr14118114a91.27.1732897657510;
        Fri, 29 Nov 2024 08:27:37 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ee45ec551asm2415207a91.16.2024.11.29.08.27.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Nov 2024 08:27:36 -0800 (PST)
Message-ID: <4fa8aaa8-78e5-4e75-98ce-5d79c2b98dd2@kernel.dk>
Date: Fri, 29 Nov 2024 09:27:36 -0700
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
Subject: [GIT PULL] Final io_uring changes for 6.13-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Various fixes and changes for io_uring that should go into the 6.13
merge window. This pull request contains:

- Remove a leftover struct from when the cqwait registered waiting was
  transitioned to regions.

- Fix for an issue introduced in this merge window, where nop->fd might
  be used uninitialized. Ensure it's always set.

- Add capping of the task_work run in local task_work mode, to prevent
  bursty and long chains from adding too much latency.

- Work around xa_store() leaving ->head non-NULL if it encounters an
  allocation error during storing. Just a debug trigger, and can go away
  once xa_store() behaves in a more expected way for this condition. Not
  a major thing as it basically requires fault injection to trigger it.

- Fix a few mapping corner cases

- Fix KCSAN complaint on reading the table size post unlock. Again not a
  "real" issue, but it's easy to silence by just keeping the reading
  inside the lock that protects it.

Please pull!


The following changes since commit a652958888fb1ada3e4f6b548576c2d2c1b60d66:

  io_uring/region: fix error codes after failed vmap (2024-11-17 09:01:35 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.13-20242901

for you to fetch changes up to 7eb75ce7527129d7f1fee6951566af409a37a1c4:

  io_uring/tctx: work around xa_store() allocation error issue (2024-11-29 07:20:28 -0700)

----------------------------------------------------------------
io_uring-6.13-20242901

----------------------------------------------------------------
Dan Carpenter (1):
      io_uring/region: return negative -E2BIG in io_create_region()

David Wei (2):
      io_uring: add io_local_work_pending()
      io_uring: limit local tw done

Jens Axboe (3):
      io_uring/nop: ensure nop->fd is always initialized
      io_uring: fix task_work cap overshooting
      io_uring/tctx: work around xa_store() allocation error issue

Pavel Begunkov (4):
      io_uring: remove io_uring_cqwait_reg_arg
      io_uring: protect register tracing
      io_uring: check for overflows in io_pin_pages
      io_uring: fix corner case forgetting to vunmap

 include/linux/io_uring_types.h |  1 +
 include/uapi/linux/io_uring.h  | 14 --------
 io_uring/io_uring.c            | 75 ++++++++++++++++++++++++++++--------------
 io_uring/io_uring.h            |  9 +++--
 io_uring/memmap.c              | 13 ++++++--
 io_uring/nop.c                 |  6 +++-
 io_uring/register.c            |  3 +-
 io_uring/tctx.c                | 13 +++++++-
 8 files changed, 87 insertions(+), 47 deletions(-)

-- 
Jens Axboe


