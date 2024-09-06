Return-Path: <io-uring+bounces-3074-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54A4196FE2C
	for <lists+io-uring@lfdr.de>; Sat,  7 Sep 2024 00:57:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 123FC287885
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 22:57:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0860B15B0EC;
	Fri,  6 Sep 2024 22:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YgONsrOM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C485C613;
	Fri,  6 Sep 2024 22:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725663418; cv=none; b=EPAsc705d8E63T/GR38uiII+6dej5FRgTvylBnL4Q+P+wqq841FkOHZ5kTM0iVogSOKJNcciZTJo0JSl3Y8T8/Um/HouCDoZuws3U+7nptFto7Qm2HqMgGFk/ZUfPNYbuHWffJBYffvIVq5ZE7pQ5aXWeb2YPPVqro2Jg1AjNlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725663418; c=relaxed/simple;
	bh=maoi4n2RXuMluWy6MNivIbHc3lpL4aBnaNCTlonGGCo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qqqljzVonktg867lcsLYyNSwF1EQJF2Y9yV0hOlM8nIOQFvucmUJ+YNtjTkbrBepe/gdMbu8xJAuN57TYbP9Y13llwTu8QixZIBWaLclkCQZE7NLL39fYzc4PLeQnFeqFhpGj3vTJkR/SwQ6AYCuT37koZQeuTbsYDs/35m0CGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YgONsrOM; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a8a789c4fc5so348860966b.0;
        Fri, 06 Sep 2024 15:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725663415; x=1726268215; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nGTHGb53DvEPF010k3Zs0+1r6sTv45lepnS24XVNVEo=;
        b=YgONsrOMGS7vFTg/wtDDvUW3aGDkDQGLjHWZqYb2emWrj1f6pDrdUz2SdoqFouzlmR
         taLC3UupbF/lZKro1LHrcrN1HRkDTmP9SnJE5PYGAD8uhy5QcfP0e4HShiXthoJetgWI
         CiJWwg5SFntxVBBfNybdG9QyZrhkvC2dwIb/6N/YnlLq3j7eWSiUgK/YI36+yukn88Gp
         KTDFU3DFNa0zcRIWYg57duDml8twY5qpIgMaaE1aglDeWlXNsLzzEd79FLVTH1RZkNdI
         xAFf9Y41jPSJs7Lp3aRE4MvU/NCCJNFuKBXR3An+IyO3WWgIZtgNNkYmpL3SOVGtLCvI
         jenQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725663415; x=1726268215;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nGTHGb53DvEPF010k3Zs0+1r6sTv45lepnS24XVNVEo=;
        b=SmZzOqBifEDQTdAF5TZaoW2OoaCEl4DXK9sRbg/4GX/HFpY9de1ZH6REviHHUNfwsD
         aBoJckFRLJkGUP4l6oor5F0Eez4Uph3UWFm6PfEM+ceL9QoaPEUit4/ggRC+kDZAQPq0
         FPhrqVtZJdZvn1QrAx4P+0LdMziboKG4jjmJ/+J5ncS4raC0DMosyrnA0wQJib25KrmH
         yFkrklbsG0gS+M5sU/EKPSYSbLIgHCjNj3vZzMC+fvPD0xRD8xNI8f8ojViIjhiecAC4
         Ub51A61MY7XuPKjJam4fdf8twNrvKw/7BmBHKLV0stWOpC6FE8fuC5ZDLeYS4ePeFM/T
         /ysQ==
X-Forwarded-Encrypted: i=1; AJvYcCXaSqblhkMUngLvNmzo/byro5/bRT8tRwNu5ar9+db0XQhaxlRMJxARHsLSO3TWcJ5Bsx8rBEI9n4J3UQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwAC0KwQb54SJAB4gTtKOo9OaNm/qAmsRk7m9LXAE9jvY42wKPu
	3MtRk6uJpQwwvEhBoi5mdojRMt2nLY+tsfOe5bF6Npow5pIm1vvJTSGKMV34
X-Google-Smtp-Source: AGHT+IHuJBTmNgLXekzqo/kN3wYBE9A78U+mlsI5nzmIR5b6yYLak0xoaHmWgdXR81I+7iIxWWK4gw==
X-Received: by 2002:a17:907:3da4:b0:a80:c0ed:2145 with SMTP id a640c23a62f3a-a8a85f2ee3dmr431894766b.2.1725663414129;
        Fri, 06 Sep 2024 15:56:54 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.146.236])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25d54978sm2679566b.199.2024.09.06.15.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 15:56:53 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v4 0/8] implement async block discards and other ops via io_uring
Date: Fri,  6 Sep 2024 23:57:17 +0100
Message-ID: <cover.1725621577.git.asml.silence@gmail.com>
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

First 4 are preparation patches. Patch 5 introduces the main chunk of
cmd infrastructure and discard commands. Patches 6-8 implement
write zeroes variants.

Branch with tests and docs:
https://github.com/isilence/liburing.git discard-cmd

The man page specifically (need to shuffle it to some cmd section):
https://github.com/isilence/liburing/commit/a6fa2bc2400bf7fcb80496e322b5db4c8b3191f0

v4: fix failing to pass nowait (unused opf) in patch 7

v3: use GFP_NOWAIT for non-blocking allocation
    fail oversized nowait discards in advance
    drop secure erase and add zero page writes
    renamed function name + other cosmetic changes
    use IOC / ioctl encoding for cmd opcodes

v2: move out of CONFIG_COMPAT
    add write zeroes & secure erase
    drop a note about interaction with page cache

Pavel Begunkov (8):
  io_uring/cmd: expose iowq to cmds
  io_uring/cmd: give inline space in request to cmds
  filemap: introduce filemap_invalidate_pages
  block: introduce blk_validate_byte_range()
  block: implement async discard as io_uring cmd
  block: implement async write zeroes command
  block: add nowait flag for __blkdev_issue_zero_pages
  block: implement async write zero pages command

 block/blk-lib.c              |  27 ++++-
 block/blk.h                  |   1 +
 block/fops.c                 |   2 +
 block/ioctl.c                | 228 ++++++++++++++++++++++++++++++++---
 include/linux/bio.h          |   6 +
 include/linux/blkdev.h       |   1 +
 include/linux/io_uring/cmd.h |  15 +++
 include/linux/pagemap.h      |   2 +
 include/uapi/linux/fs.h      |   4 +
 io_uring/io_uring.c          |  11 ++
 io_uring/io_uring.h          |   1 +
 io_uring/uring_cmd.c         |   7 ++
 mm/filemap.c                 |  17 ++-
 13 files changed, 293 insertions(+), 29 deletions(-)

-- 
2.45.2


