Return-Path: <io-uring+bounces-3138-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AD6297587F
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 18:34:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7CF48B23CD2
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 16:34:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AE291AC8A0;
	Wed, 11 Sep 2024 16:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xbfs0hNG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB551A3AB0;
	Wed, 11 Sep 2024 16:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726072465; cv=none; b=nyCXQgfOg+odOoZX0A/HJwuBgOvGvrB2OTC0v0O6Z3kjK6sP7NnO7ksBvZMajrdPFPn8Vhlj8amwpwbQNjX/WLiofQ2qm8KL7bFlvotHfTBwNHLk0c2w1LV/J3igVPOoCtXSyJg2nBzOyJn7Fuv4OQ92ScZdVU0xNOvqoIW57H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726072465; c=relaxed/simple;
	bh=THxi2fdst1mrp9grDb0k3ERw8bEb5E1Jtp6pCASNW3U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ullD0Sja3mRmBDesQAyjsBDVOwbj/ZTNs/upfnHLfS9XDtAa4PQJFyAATR/+aFIFshHJK/jisjVvURHq+HGPsl1D+BD9dZ2n3pm6AULL+ct6KFqddtu+IN9gndr6KE9MDzrpd6QGfDzj8a8HkQsx3K3muxRJcv9xlejAS5NrwxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xbfs0hNG; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a8d29b7edc2so4061166b.1;
        Wed, 11 Sep 2024 09:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726072462; x=1726677262; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JMtXVHkqQbVZYjnenJKozcU9t1oo3mrhS0t1pBayqX0=;
        b=Xbfs0hNGQYdiRn3EA/bD0E5QUqUFTdzmZZ6wn2YDauXPdh+Wirxp6qlfACTKI3u+a/
         roQOR71l+5bUn900ZVF3iGUHq51I8GPNJpgjK8FcajtvKx42UBwdl1nHkXciVFUaiScO
         uPqodcV0CatmAf3MepQv2dFgxRdLHkjSPHfDFEUw7gflL9X3A06jkNX55QcVRsES157K
         RrQzYpzt/3qbf+Dclq32mr6jmwBwYMFIQiaIltMuNJklvSKKtFw+qqgzsajRfHWOXlUN
         5PYe5ZmutHXUAGt4c85FQywUl7jH3ylFTsMMz/VsBOsBrorb4N06YzMgK7wfLuw3Q1zJ
         V1Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726072462; x=1726677262;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JMtXVHkqQbVZYjnenJKozcU9t1oo3mrhS0t1pBayqX0=;
        b=HS0/Wq/notfV3s9CAJvgDSYEBisblLYKdOSOymFLNmmp/T0ZCoT0e26EUEi3mQqkFO
         q8aKD1QNaeF/H1Smy1Pt/vP+mApU+y50teYIZAzZLj9HeqtMUqO6eNFew3R98GKTIdAM
         ic9YjrkE3ElYbr1ujpscwR0Oa4NZJo/eN/BluUX4sPvHta5HmmPE2QwFeCCFFfF6tOde
         gIUwjOfSiZe7O/bnVCiyuHBbHnzhEEsh8slztJmZUPjsA1a7AjzyaO6WAO5k+sjsfMwH
         jMAl2e+xVbkQ4+1epsQIFYEhMZJUUp5eEPquKCd5PA2O9C23qdgRquF4PLTluVkX5vBn
         i57g==
X-Forwarded-Encrypted: i=1; AJvYcCXKGxFHlrYnyyTtzswDM+zto2Vvv6OeVHPc3wFapDfk9U2NbYnz4097NORRRnbrJxfyZplRnomg1k+Khg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwHXsqz1aY+4Z+tCKdYyEOhh2IUkG7Sq4MwwY3H0pTC+rs7gI1v
	DQVCQEMWDIx5FvDXnPaM5ndN+EnHJtShzHxWxUYuoVLnM9hbQuUlWYj/xak7
X-Google-Smtp-Source: AGHT+IGjuO6kXZBiH/YIXMFCm9Da9OqH+kOJ25he8cNe8qOZqvyK5g024tTbFGMJIxveiGd9EzI8/w==
X-Received: by 2002:a17:906:d555:b0:a8d:5e1a:8d80 with SMTP id a640c23a62f3a-a902961ab79mr6013366b.40.1726072461451;
        Wed, 11 Sep 2024 09:34:21 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25c72ed3sm631820866b.135.2024.09.11.09.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2024 09:34:20 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v5 0/8] implement async block discards and other ops via io_uring
Date: Wed, 11 Sep 2024 17:34:36 +0100
Message-ID: <cover.1726072086.git.asml.silence@gmail.com>
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

v5: add uapi/linux/blkdev.h
    number block cmd opcodes starting from IOC seq 0
    don't export bio_discard_limit(), return to v2 and put bio if nowait
      can't proceed
    minor comment and stylistics changes

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
  block: implement async io_uring discard cmd
  block: implement write zeroes io_uring cmd
  block: add nowait flag for __blkdev_issue_zero_pages
  block: implement write zero pages cmd

 block/blk-lib.c              |  22 +++-
 block/blk.h                  |   1 +
 block/fops.c                 |   2 +
 block/ioctl.c                | 242 ++++++++++++++++++++++++++++++++---
 include/linux/bio.h          |   4 +
 include/linux/blkdev.h       |   1 +
 include/linux/io_uring/cmd.h |  15 +++
 include/linux/pagemap.h      |   2 +
 include/uapi/linux/blkdev.h  |  16 +++
 io_uring/io_uring.c          |  11 ++
 io_uring/io_uring.h          |   1 +
 io_uring/uring_cmd.c         |   7 +
 mm/filemap.c                 |  17 ++-
 13 files changed, 314 insertions(+), 27 deletions(-)
 create mode 100644 include/uapi/linux/blkdev.h

-- 
2.45.2


