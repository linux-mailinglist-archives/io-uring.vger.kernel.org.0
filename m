Return-Path: <io-uring+bounces-2879-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 22CF695ABF5
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 05:35:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4C61286D9F
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 03:35:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BD352374E;
	Thu, 22 Aug 2024 03:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EHkVbe4a"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EA722611;
	Thu, 22 Aug 2024 03:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724297739; cv=none; b=OJV/pTfvS1iE2tDgSFkv7WaFXler0qnuKDzR9he/xPKF4Apk0FJUqwxbVVHXyqZRUnsvwVK89W1dVQc9zfjWWFNxmSG6WsuQu4dGRU++oh8PG9tOA7/VYLfRVAiGLP+bgei3ymNb84Ihb7MAN1Eo/CL0Pz/bR7WJLydwTikwkVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724297739; c=relaxed/simple;
	bh=ZhtwCFkDO20JuZGuyqkwk5MJa8bmDj7Y6Bvn5H3qmJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KbkQxkERmuO6g00pkPdYslBz1W1mmM32pWsCdqzkRajWMs2qFLOHWsSDsK+LhVsuz+jmMnxoP/dOowLHJgZCZhx1HeTEr9i+yMg4Sw6jGVhxHObnzhJWgDrIQhrTmFMfGNeVhlnCN5aaGmPKhirTH7zaKKf6e7MWqIG4sp/7An0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EHkVbe4a; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3717de33d58so132412f8f.1;
        Wed, 21 Aug 2024 20:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724297735; x=1724902535; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+IreBDreZSBwJydKxcFKtWQRaeFNvxt3rNW9GfTop+k=;
        b=EHkVbe4aT2pRiig68tVQczHq32cCCW1FxAm1Sf40M4oTD+LYll39zDxz/xjJpdnot1
         FBvDS1dbsaBBLG2c1I+h6AvCXqZuPJifBm7nllCCAuQ6dWro/DrbyOjp905nwToIGQWb
         KZwNRxWWuBMiuovHVw95dBABgfKKo3DV6RfvKl6L9RmQrcbLcCx+uDtAN4cWf0eB5yNk
         1duhgyrOLwRD5u/jQcbGaxF3JcXG8kiDZptrHQucldJ9k2hnG98VorLmY2YlA8YFXh/9
         BitpjAWLLQJ6miNe0Fa6FtK76r4MvmWAIwpc4PCPFPjWBMgPIv4r5Ly1NJppwZHg5JcZ
         VmaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724297735; x=1724902535;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+IreBDreZSBwJydKxcFKtWQRaeFNvxt3rNW9GfTop+k=;
        b=V3UJlA5SI1phyXH4dA6RvBxPqwUeItvLD5Vx8wTopNpBc3KsvzZGKh5mHBI8wcpp1r
         Dng9m+dZT1i8DGKyn+5Wlk7nD5R0zoT9cB3eu2cLV+06h/whmBIG2nJIhPtRqz5+Ysoa
         2dJ7+u2YXrUAzcaWGlDVrWroRCNBg8T8fezSo+LlhPKbhtDFXjl/wOA427jBnWr6GFPR
         ddrAMsKjbvcwFPuldULGJqzGFjMNWEl51ppRJuZ7OSJhjGEGAmMxlITRrB7qM1E/63a2
         7ysdZD+1qyqL5zVTPd4a4TCQgWbf90Rb5ZNbQPZ8KdO1ed0yAvspkNdY4XbHES6uQdL/
         5XQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvgT4KN2qk0rqjQ5VLQLreWjf2b1QkS7cP+vr41qyiOyonxtgKfYtcfuxHyOQ8ERr/d7Icl3WobFgpgA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxX3ok+AILehdIqDjguK36f4ploGsGLD+fknzy3sKPgyH4NlBYY
	PjwlFqS8w54vtDQTuCgDlOfOcmGsvRHQwYT+wu2nuzaQRJko3h3dhNy9nw==
X-Google-Smtp-Source: AGHT+IFCrZJRE3JoOsYnLyBpiBJ1fJMH0zCOC/q+yqldv3zN7E3+YSE/nUZfdiUy2hzpTtOjgxqKnA==
X-Received: by 2002:a5d:44ca:0:b0:367:434f:ca9a with SMTP id ffacd0b85a97d-372fd4d11a0mr2598796f8f.0.1724297735071;
        Wed, 21 Aug 2024 20:35:35 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42abefc626fsm45491995e9.31.2024.08.21.20.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 20:35:34 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 0/7] implement async block discards/etc. via io_uring
Date: Thu, 22 Aug 2024 04:35:50 +0100
Message-ID: <cover.1724297388.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is an interest in having asynchronous block operations like
discard and write zeroes. The series implements that as io_uring commands,
which is an io_uring request type allowing to implement custom file
specific operations.

First 4 patches are simple preps, patches 5-7 implement support for
discards, write zeroes and secure erases correspondingly.
While the two latter commands use the same code path, discards only
reuses common callbacks and not bio allocation loop because of
differences in how the range is sliced into bios, see granularity
handling in bio_discard_limit().

Note that there are differences with ioctl() versions, these are
asynchronous and looser on synchronisation with page cache allowing
more races, see comments to patch 5.

liburing tests:

https://github.com/isilence/liburing.git discard-cmd-test

Pavel Begunkov (7):
  io_uring/cmd: expose iowq to cmds
  io_uring/cmd: give inline space in request to cmds
  filemap: introduce filemap_invalidate_pages
  block: introduce blk_validate_write()
  block: implement async discard as io_uring cmd
  block: implement async wire write zeroes
  block: implement async secure erase

 block/blk.h                  |   1 +
 block/fops.c                 |   2 +
 block/ioctl.c                | 231 ++++++++++++++++++++++++++++++++---
 include/linux/blkdev.h       |   4 +
 include/linux/io_uring/cmd.h |  15 +++
 include/linux/pagemap.h      |   2 +
 include/uapi/linux/fs.h      |   4 +
 io_uring/io_uring.c          |  11 ++
 io_uring/io_uring.h          |   1 +
 io_uring/uring_cmd.c         |   7 ++
 mm/filemap.c                 |  18 ++-
 11 files changed, 273 insertions(+), 23 deletions(-)


base-commit: 15dadb5430367959a455818fef80350a68c010f4
-- 
2.45.2


