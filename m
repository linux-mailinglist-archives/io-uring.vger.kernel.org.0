Return-Path: <io-uring+bounces-3259-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A07C597E063
	for <lists+io-uring@lfdr.de>; Sun, 22 Sep 2024 09:04:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 06A2BB20F3E
	for <lists+io-uring@lfdr.de>; Sun, 22 Sep 2024 07:04:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 457D238DD8;
	Sun, 22 Sep 2024 07:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Z7Lmg8Pj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B63339BC
	for <io-uring@vger.kernel.org>; Sun, 22 Sep 2024 07:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726988680; cv=none; b=RfpyL88+eiBpLjuT2lJc2Gu5UnMfJxbYVHgOqQUT71Z2pkcpi2xDZuomDTOf4kwaG/ssf8kqtq4Q2C50w+8uFXvzVNQdJ4px0l17BCP4s3RHj2inyqbzLjJNaHz9+yklrxhe3PJD8f7xI8uVFB9u5Rz0lGkaEoaRqEKolyxkjEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726988680; c=relaxed/simple;
	bh=HIOpYZs+ijP7PDaizO+LMxtQS5Q1ns9odbyjz1IoS4s=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=rqe0jh5cSwBUJkTDRnHPK6u/PoCPpyTtcf6YPs0eTFmzE44rSY1bJuMzxyMg+Y8ksZrIVUlCn4ZO8wIXO/8eqpCcsrVAOvZyQqnNWeuswpkxmV4xuXu9I0kl6XB0huQ98FV7Y8T8YBIQiZED+q1djlLZYf6t9ZFFFkBoLXANKIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Z7Lmg8Pj; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5c44e1cde53so4277101a12.0
        for <io-uring@vger.kernel.org>; Sun, 22 Sep 2024 00:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726988673; x=1727593473; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ydqWaHP1HyODpMcNozdUOVJrOuc4oV2JsZOgxDBvJQ=;
        b=Z7Lmg8PjTblQceojzPoG3Qchecfv1IiJ0YiWRGnhNT822AqQY3T30JdnSPTkSUfumR
         pO5KqKqiqmVvuQokyNVtqD699DxDo60NtaJjEhkGEQi6MM3gKPc7jh9jSMHSymXQaDwy
         DQCPBXPP8R8eH1xrBr5/XqsaNi9N5n/oc+aK4RzQF2H0kCzqNUNBNkmE/AkEevKOR8Wq
         FVK07E7IxBWB/j06oCKe4DJ3vcR4frBdD9GG1i0FDdEfSoGXN1IKiO1NhGKqTlUOPSB1
         KV+Voe00U7Hq7tjBLnruHdP+0Q5XJjaWk67nGpqZfTKOjGQQ73Yxr8EbiDzadwUdp0uD
         g8jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726988673; x=1727593473;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7ydqWaHP1HyODpMcNozdUOVJrOuc4oV2JsZOgxDBvJQ=;
        b=u5bcIbqHF2CGroV5mIgKIn8TdGCHlw4lc4o5CYXMe7GjMSwv/foVInH5ujlVc7xycd
         rcVCHozNcrTEz41ZSiiin6OsxuujMG8CWWq0RHg+r811yk/LjZj66QN2NCAvU6csWzDp
         yxrsk48myj4RGT1expt23VnBeIR6jTVPKMzlkpMotIREnlXWso3O218otgljMu+5lV9g
         sSjHMf8F4QxK+kPHQtu8qckiQ12w0ZRRs37UDjUxGFeyc2ELvwgVEtqALZhTxpmHVCmd
         zPDMhbp7fxkqq3kdZoQh1ouES+nFCmO1j+gLeVcWvmKpTAoXLHcYiJ6hkLVDZUg/n2Dr
         unDg==
X-Gm-Message-State: AOJu0YwjTEt0l0S5fLb8i2kgQRisvh1eGl3cuK2cfBMV1QFkt/FiUVX7
	zjmKtQo3cO3ke2Q0J6dFUmzxw+7qaQDpCxvUkuzuLy+zi1Uxz/1MjtP4XANtqSxeM8nxheN3eCk
	zDGpdTg==
X-Google-Smtp-Source: AGHT+IGlvbVHqycwrnOyk4CdDfp0+S6xPdieeoZVMtyHgSRBjFmeXGWJjk2pC3wX49ZuwJnZmiRSFQ==
X-Received: by 2002:a17:907:3f9f:b0:a8a:9195:922d with SMTP id a640c23a62f3a-a90d4e2fe6dmr822490066b.0.1726988672621;
        Sun, 22 Sep 2024 00:04:32 -0700 (PDT)
Received: from [10.17.14.1] (cpe.ge-7-3-6-100.bynqe11.dk.customer.tdc.net. [83.91.95.82])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9061328e61sm1054522866b.196.2024.09.22.00.04.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Sep 2024 00:04:31 -0700 (PDT)
Message-ID: <4aaa45b3-ddef-4278-88da-fb9f4bbd96ec@kernel.dk>
Date: Sun, 22 Sep 2024 01:04:30 -0600
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
Subject: [GIT PULL] Followup io_uring fixes for 6.12-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Mostly just a set of fixes in here, or little changes that didn't get
included in the initial pull request. This pull request contains:

- Move the SQPOLL napi polling outside the submission lock (Olivier)

- Rename of the "copy buffers" API that got added in the 6.12 merge
  window. There's really no copying going on, it's just referencing the
  buffers. After a bit of consideration, decided that it was better to
  simply rename this to avoid potential confusion (me)

- Shrink struct io_mapped_ubuf from 48 to 32 bytes, by changing it to
  start + len tracking rather than having start / end in there, and by
  removing the caching of folio_mask when we can just calculate it from
  folio_shift when we need it (me)

- Fixes for the SQPOLL affinity checking (me, Felix)

- Fix for how cqring waiting checks for the presence of task_work. Just
  check it directly rather than check for a specific notification
  mechanism (me)

- Tweak to how request linking is represented in tracing (me)

- Fix a syzbot report that deliberately sets up a huge list of overflow
  entries, and then hits rcu stalls when flushing this list. Just check
  for the need to preempt, and drop/reacquire locks in the loop. There's
  no state maintained over the loop itself, and each entry is yanked from
  head-of-list (me)

Please pull!


The following changes since commit 7cc2a6eadcd7a5aa36ac63e6659f5c6138c7f4d2:

  io_uring: add IORING_REGISTER_COPY_BUFFERS method (2024-09-12 10:14:15 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/for-6.12/io_uring-20240922

for you to fetch changes up to eac2ca2d682f94f46b1973bdf5e77d85d77b8e53:

  io_uring: check if we need to reschedule during overflow flush (2024-09-20 02:51:20 -0600)

----------------------------------------------------------------
for-6.12/io_uring-20240922

----------------------------------------------------------------
Dan Carpenter (1):
      io_uring: clean up a type in io_uring_register_get_file()

Felix Moessbauer (1):
      io_uring/sqpoll: do not put cpumask on stack

Jens Axboe (7):
      io_uring: rename "copy buffers" to "clone buffers"
      io_uring/rsrc: get rid of io_mapped_ubuf->folio_mask
      io_uring/rsrc: change ubuf->ubuf_end to length tracking
      io_uring/sqpoll: retain test for whether the CPU is valid
      io_uring: check for presence of task_work rather than TIF_NOTIFY_SIGNAL
      io_uring: improve request linking trace
      io_uring: check if we need to reschedule during overflow flush

Olivier Langlois (1):
      io_uring/sqpoll: do the napi busy poll outside the submission block

 include/uapi/linux/io_uring.h |  6 +++---
 io_uring/fdinfo.c             |  3 +--
 io_uring/io_uring.c           | 21 ++++++++++++++++++---
 io_uring/register.c           |  6 +++---
 io_uring/register.h           |  2 +-
 io_uring/rsrc.c               | 23 ++++++++++-------------
 io_uring/rsrc.h               |  7 +++----
 io_uring/sqpoll.c             | 22 ++++++++++++++++------
 8 files changed, 55 insertions(+), 35 deletions(-)

-- 
Jens Axboe


