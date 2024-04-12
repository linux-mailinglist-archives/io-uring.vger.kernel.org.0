Return-Path: <io-uring+bounces-1530-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C2D518A3403
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 18:46:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 799C21F22E9E
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 16:46:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ECF7149013;
	Fri, 12 Apr 2024 16:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GQCt6an8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7FF82C60
	for <io-uring@vger.kernel.org>; Fri, 12 Apr 2024 16:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712940389; cv=none; b=HFb8nQzegSmMS92ljlVWbZX6+03NQfo5mAxkfRaUzIRK+pDikHlNP/kDO8suujMeqb60zrJ/42lj07/qaJTnLw28QN0U7sTAOI7Bg50fZVpQXfJN7rSlkzkCx9PAiNmyCWDHrBZ6RDwMLrd+Yx6gWZk7aBHf9r+UTKNfufnWAwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712940389; c=relaxed/simple;
	bh=ycGX4KNUbg3ja6uRPiXeMKU0mViEe714Hvd8BaOvlOk=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=FgFnMcAb1ElmHMPgFUZwRNnEzTw+zBueNXZJZVTNxRDrt9joTY6/gbDH+fPuk5C8rO851iho+LNJ3lN4fcW3tIh6ZCJuTqlpH0SnET3Ycy3oh0+q8g3kJFyp43GKYS9Mgh4m3zT6/sPfIXiIy+4z353ZTnbhSVT9F70Q3wqO4XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GQCt6an8; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-36a11328dfeso117855ab.1
        for <io-uring@vger.kernel.org>; Fri, 12 Apr 2024 09:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712940385; x=1713545185; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qccNymqalU1lMWwk++ofjflegyMjpwXhd6m9R+JA1Xk=;
        b=GQCt6an8fyAAQmIFwJzbM1w6QEBevsDXj+H+ynHG66BWhqY/r1+BgwLF7n++o4EEBU
         xmsMkRw/0JAE6ylSEshrftqWfuRNBjGsOwNPrqVQldA2axL0Kcg0OhfWYJHnSJAyRgYl
         8rbx7Hc2GY6jPpdnxvDQsydLul3vWj2PkQDL2a4h0yn7rzlH0q54n4pzril1RVvNS//i
         dbEYvmdk1FN9xk1dYKoJER189TYQBvdaMjp6QHLxUdmx/fUGF9yUDDJX921R7wUOU955
         +lgJqfhmwn32CCH34mP6ITNUgEZb2+RRWbRInAcifsAy8s1SH3DDTkNkM5LMZWo7ELBR
         at6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712940385; x=1713545185;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qccNymqalU1lMWwk++ofjflegyMjpwXhd6m9R+JA1Xk=;
        b=WV3adrA8HOEeEwRX/7ZkNekp0lxtyvKX3HhEKNkjLRCwU1i2CfX/XXFuges837l6QK
         dAAUwOVebAZvff9iEgaRrmRLP/VRUUQX3t1iqF6IgVErc2pZtl6GiSNCGfDAPlpIUp8t
         KgJuHGcOqibsj6QLx3L9YNksxXLAJ1FfTNjwW3Y7qCTIJWj9UrNxUisNnCq85Rfae17v
         hGYAp6R71Lmjlzp4Bqb79iqOjtcMlCfZZLHyW/cUTOxWHXhKg+LnlDrhhYV4peJiMvNh
         T188knm01kMSmh6bec4gbJMbL5NuzpFi5KNWRwtDipaVDrxRFHtjwK/9I02ZoXhl3Df3
         k4ww==
X-Gm-Message-State: AOJu0Yzq/YipPLhHeqzvV58GWbwVTNXjXGjFg3lePRBVidnZRDXIMzUp
	U2EdRQVdYGtv8P0tqoLrQQ8DearnUVNaV8ZCHmBhDHVwRjjrQSkMyeBrACB83M4=
X-Google-Smtp-Source: AGHT+IHSQTKlH2B5uw9frGHQ+p3VpExh2+ocOD/0XG/OmsJ8vGYmBzOUS5K55KazukbL6AL4gfA+iQ==
X-Received: by 2002:a6b:c34e:0:b0:7d6:7b7c:8257 with SMTP id t75-20020a6bc34e000000b007d67b7c8257mr3352279iof.0.1712940385224;
        Fri, 12 Apr 2024 09:46:25 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id w2-20020a056638138200b00480f0130f19sm1173166jad.45.2024.04.12.09.46.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Apr 2024 09:46:24 -0700 (PDT)
Message-ID: <d9cb3787-7373-4963-b3dd-1ce21ecd415e@kernel.dk>
Date: Fri, 12 Apr 2024 10:46:23 -0600
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
Subject: [GIT PULL] io_uring fixes for 6.9-rc4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

A few little fixes that should go into the 6.9 kernel release:

- Fix for sigmask restoring while waiting for events (Alexey)

- Typo fix in comment (Haiyue)

- Fix for a msg_control retstore on SEND_ZC retries (Pavel)

Please pull!


The following changes since commit 561e4f9451d65fc2f7eef564e0064373e3019793:

  io_uring/kbuf: hold io_buffer_list reference over mmap (2024-04-02 19:03:27 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.9-20240412

for you to fetch changes up to ff81dade48608363136d52bb2493a6df76458b28:

  io-uring: correct typo in comment for IOU_F_TWQ_LAZY_WAKE (2024-04-09 15:00:35 -0600)

----------------------------------------------------------------
io_uring-6.9-20240412

----------------------------------------------------------------
Alexey Izbyshev (1):
      io_uring: Fix io_cqring_wait() not restoring sigmask on get_timespec64() failure

Haiyue Wang (1):
      io-uring: correct typo in comment for IOU_F_TWQ_LAZY_WAKE

Pavel Begunkov (1):
      io_uring/net: restore msg_control on sendzc retry

 include/linux/io_uring_types.h |  2 +-
 io_uring/io_uring.c            | 26 +++++++++++++-------------
 io_uring/net.c                 |  1 +
 3 files changed, 15 insertions(+), 14 deletions(-)

-- 
Jens Axboe


