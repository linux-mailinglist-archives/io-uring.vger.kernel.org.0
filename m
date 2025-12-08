Return-Path: <io-uring+bounces-10988-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 599BDCAE2AF
	for <lists+io-uring@lfdr.de>; Mon, 08 Dec 2025 21:31:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CD781300A216
	for <lists+io-uring@lfdr.de>; Mon,  8 Dec 2025 20:31:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2E151E6DC5;
	Mon,  8 Dec 2025 20:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mF+jBexX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CAAF9C0
	for <io-uring@vger.kernel.org>; Mon,  8 Dec 2025 20:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765225881; cv=none; b=aYYGheAxU8lpjL/WpIwbCINwuvHqxQizwUGrKwN8/ezVjXaslfX8iHehSQzKHEkCguzYJgP3ZP+nd9r1NMC/M+KBn5FucGhDw7zPHT3EzPouq1fiF2dWnoa4/XPk91PPMbvZJmFJYP7MXo54W7QH6wPsaZY6IXevDmlaPXHSKSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765225881; c=relaxed/simple;
	bh=isRw9A9yBjkTerJM4nYjbbjPV8Uqm2TwTQ69+To6t90=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=dnlp6fJT2heBI37yaHZC6wW6FxxjLBpSVM82SgTDegeC6bMJR7n2PgHuC5wokxeLceSIH1qybU86fNjcQAlF3KBaSa75j71RnXznyCeX0I7XQm6abgsxm1q3Ih2ejMC1hlim+ZVUHmvSd06VFpuZYSGzmijquCnF5kBOHYzwLxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mF+jBexX; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3436d6ca17bso4857057a91.3
        for <io-uring@vger.kernel.org>; Mon, 08 Dec 2025 12:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1765225878; x=1765830678; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IYNOpCX0rZUepVhqdmLlwhtrU+SR0iv7Kr55ozRJ1xM=;
        b=mF+jBexXvMWqFJOH8R796A21anhMVmbRW98+xwPPoyCYaRVXw3qP6gxRyrFy5S19Va
         7a7We/JtwF76YoTPNHTbVICISFso/za2MNfsyF1qnhdrjT/jMhHhsdEbIY/pOPePcnjv
         fTRs0LiyLVOuX3AACJkfHBYUEYSHvK+/Myu5qiewPYe3ESFbkAJZ15pGkmBSF15svT0c
         +3Tph9Ul5lMupNNAtLjdHZZar46RQH5/Pf/4SR50uG6uMGtDPHimCgBK/KuNCa4/VEkB
         1CH/uAagN3oPZBsmV3Go8Fz6X/LgLvkMo5ywhV0PJPlPKUssKk7wNGpa7SFfps2LCWYi
         3mjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765225878; x=1765830678;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IYNOpCX0rZUepVhqdmLlwhtrU+SR0iv7Kr55ozRJ1xM=;
        b=Ivzijefz0I1M2SpGaIzQDE3T8M/BWcuTfiYq7PhOi5vgptR3hJ5zwgDe9yExO63y/w
         e7e22/tgCDcZdtMAE56HGtNapCBlqp38gWY3lTZY0TSw6ne4+0cYRN2TVfN954gJYdLO
         F/+IaWqbVhePzb8TvdKTiCdkhoxT64i5oMhU5jixUvYOI0vCun2W0VMGUhSLHVNmipoY
         a6B5rqdBDcMLPYgbP3RJG/WAD/25nUV0TBnbtjVjF94pyOhAveMsE6WqMerH6s/3491V
         dmhfkavXcj/vGPIi08vVzF/RYpoPWzPkx8mvszZ2ubkhdN7dI8WY/Gv8YPzxXe+T3Ldj
         +7gQ==
X-Gm-Message-State: AOJu0Yw2MDMo8Ix033/CB4ImNBx2LgG+Jp9AsvHpYv/733fB6qhp9FCm
	06Nfc7jYoqxGq5ULBAKiuRUVIY3J7lSQAKB5nmZkX50hCD8B0mfqgfA+/2HIrUYC+5k=
X-Gm-Gg: ASbGnctGh22mcFq4en/ncGve4D5bJrACD+Xz4C3wkAljVp9kC/gnA5yhqyFa7QtyppC
	69tWHcplDr/aLpix4P18XYVgQ4IFeZ7YDavsaSFZ0KHZyTmqLTiXz8fMxNFJssvOsf50W96Ihbc
	ytgFbIxo9wa8gsqWt8j0MRTIXXYc54F1xudDdS7JfAbpYGXr3mOybwh4V7gA8ww5dLZr/Z29cQL
	MZo6qodP98VInD47XEb70CHaF/Tip0m7AhKjIeYWKnMFdaGLC3GZMN4+fa4hSNV+ZDQV0R0GSRS
	rd12dZSk7rm21RvMOZ+oRi5ygTjGp0/oQARqvAw3lPadBjCWLE1vsnjqbI4JKa4ecFXxXIxMjEb
	fceOBVTeDKdnbW7WAiS8YwKOrQvGWR17usNC2A8FCH0L128BNGkMYSBXjWPvwssaEYpUKE5OMHp
	maoRyNGFZ8tLcY16YKBMl/1Ph4uK0ubDRHlHgD3JQTfHHleQ==
X-Google-Smtp-Source: AGHT+IG9JZid3I73tSGnJkibDU6m7oIc4VKRQrzrpY1MtDlbI2e2YhkmPmhy4BSrtmTWNou7TwZfSA==
X-Received: by 2002:a17:90b:564c:b0:340:776d:f4ca with SMTP id 98e67ed59e1d1-349a25e45fbmr6646426a91.26.1765225878320;
        Mon, 08 Dec 2025 12:31:18 -0800 (PST)
Received: from [172.19.130.138] ([164.86.9.138])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34a4a8aa876sm7086a91.9.2025.12.08.12.31.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Dec 2025 12:31:17 -0800 (PST)
Message-ID: <fdab55a9-8a66-40e4-b824-b473b63c974b@kernel.dk>
Date: Mon, 8 Dec 2025 13:31:06 -0700
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
Subject: [GIT PULL] Followup io_uring fixes for 6.19-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Followup set of fixes for io_uring for this merge window. These are
either later fixes, or cleanups that don't make sense to defer. This
pull request contains:

- Fix for a recent regression in io-wq worker creation.

- Tracing cleanup

- Use READ_ONCE/WRITE_ONCE consistently for ring mapped kbufs. Mostly
  for documentation purposes, indicating that they are shared with
  userspace.

- Fix for POLL_ADD losing a completion, if the request is updated and
  now is triggerable - eg, if POLLIN is set with the updated, and the
  polled file is readable.

- In conjunction with the above fix, also unify how poll wait queue
  entries are deleted with the head update. We had 3 different spots
  doing both the list deletion and head write, with one of them nicely
  documented. Abstract that into a helper and use it consistently.

- Small series from Joanne fixing an issue with buffer cloning, and
  cleaning up the arg validation.

Please pull!


The following changes since commit 559e608c46553c107dbba19dae0854af7b219400:

  Merge tag 'ntfs3_for_6.19' of https://github.com/Paragon-Software-Group/linux-ntfs3 (2025-12-03 20:45:43 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.19-20251208

for you to fetch changes up to 55d57b3bcc7efcab812a8179e2dc17d781302997:

  io_uring/poll: unify poll waitqueue entry and list removal (2025-12-05 10:23:28 -0700)

----------------------------------------------------------------
io_uring-6.19-20251208

----------------------------------------------------------------
Caleb Sander Mateos (3):
      io_uring/io-wq: always retry worker create on ERESTART*
      io_uring/trace: rename io_uring_queue_async_work event "rw" field
      io_uring/kbuf: use READ_ONCE() for userspace-mapped memory

Jens Axboe (2):
      io_uring/poll: correctly handle io_poll_add() return value on update
      io_uring/poll: unify poll waitqueue entry and list removal

Joanne Koong (4):
      io_uring/rsrc: clean up buffer cloning arg validation
      io_uring/rsrc: rename misleading src_node variable in io_clone_buffers()
      io_uring/rsrc: fix lost entries after cloned range
      io_uring/kbuf: use WRITE_ONCE() for userspace-shared buffer ring fields

 include/trace/events/io_uring.h | 12 +++++-----
 io_uring/io-wq.c                |  5 ++--
 io_uring/kbuf.c                 | 16 ++++++-------
 io_uring/poll.c                 | 52 +++++++++++++++++++++++------------------
 io_uring/rsrc.c                 | 47 +++++++++++++++++--------------------
 5 files changed, 67 insertions(+), 65 deletions(-)

-- 
Jens Axboe


