Return-Path: <io-uring+bounces-6444-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 96946A36491
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 18:28:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A6C1168A77
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 17:28:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D662267F7D;
	Fri, 14 Feb 2025 17:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dunqjn8I"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D762267AEB
	for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 17:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739554118; cv=none; b=qtS6zMHP6A3yosK1RqbmwDg/8aGEfEN3aAdPJkcLmtiuvjexDfrScxensy9HFpeNSphM95LH5Ovsk9li2nkX76k0Mn48JoVrLFa6/W9ZltmI2wiIyWi0+yh4Ak2gcEl757nGovqjyxw4wePVuv9LCJZjZlnOi9ciPsrxTVPUJJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739554118; c=relaxed/simple;
	bh=vykFqLjApyYpeKW5LzIkX9zpGGzzjmBXQDJYzCIagHo=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=RAT2hQDSJoNQXLOta3Prp495CLHoif9BZr+woEord7j7o8y9rb46vq3bhKSWi/w2wweH+RB4bq2Z5/2K8wA9RUtO2lIbwyM5jGpuVaEaURVtePJhjntTjI0ydkfWJ0uGxJODE5AeTHXC1qQAbE4WYmHHXLTIdBlV5yHuo3maMME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dunqjn8I; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3d14f752bcaso14756205ab.3
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 09:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739554114; x=1740158914; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OJY2HBo/4Ti3v7DB/pjT741wHSrehYUS8NFrMFWA7Mo=;
        b=dunqjn8I02cEKBw36feu06ccLnSRyt3YdQ4kdYRQUma3SmKXTFaofSxkm4E7VBmBxd
         L6agpcdTgy2YyiHEQasuxL35zdWHDI068lP3yS0kcn/9IUd4HV1qouz9Lb9siHFys2vs
         IwP0ieZTrN+dsD7jL25eG4+hXtCF60Tv3CCTmwooVpR9wYWql2ZGoee7XPMky16445YX
         e/RfjckMcB+ISBZQaybOvuAqa3R29x3b1ggZCQxhpPNdB4551KHAm7tw48VkGt02M96l
         Az8le52Jdn+yLkirwwHqZRN89IAA5HfytZXwyqdGgOkLHYGeVPaJ2dMVRxCeVBNnaCbq
         RL5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739554114; x=1740158914;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OJY2HBo/4Ti3v7DB/pjT741wHSrehYUS8NFrMFWA7Mo=;
        b=Ec4S6Pi7p1in5vlmgHM5dlqynRtyps6a5RLscjIQr8lwqwN8Mklt1f9JboNk3VlgCM
         eSyL5n7Vc32VMrdvm/5j4oy66WsdlyvLHSk7xvnvFBk3dCpHfT5M7mgow4svsDfrNpV7
         kiaNsEpvn+XTdsWL9oOFf0spAyNETHOMn3MIiFGfqW2oc+vRQgpoWXrLxc34/FBOq9W3
         HnaWEjY0QbkEzd7ZWSC3EN6M98fMCoqATILDkttS3BRX/M4Ccv7PMtApLX5bgCVz+GIi
         7etfX02SaRY/HAJGI1IiQo5XvAAM8KNoTHXybffoDfVFduEae9kkRDd2g/vzmDcVesw3
         JC3Q==
X-Gm-Message-State: AOJu0Yw3g8VqFqu5+ZpZGf4RFiKTIuO4LUzOH2S8yY2P4xYTJbobot4R
	3izarRqqAbZfFFnmJTyghvFMqxNGUAwPZ5w/HokvBZ6h/n4dklRiFNKHSWFxGkniyqG/M+mfDQY
	N
X-Gm-Gg: ASbGncswgtybYcu5BUyfEo0u6F8XA7Dj8hDtMaIwlRWmnUYaNQddFDDizDVABFoaHET
	qMtRP+cQenlaQAXlONos6bORhCiGqz3n2EDn/+Np9irgR5Cc7xiz+Ctinb2zShppFpjO0rngdWC
	M3IgINIyuRmD6GGZUCa0rebdzYX2nyzXmQKUiibN3PT9hvt9D3hHWZ7XG3+46scSznlkNrWjMzx
	jSfAvKt/9WcDm57qM938CW6KwKOxNFsSa4oR6uinvUP3dCeir78l5ETjdxOWjkj9910+7v2zDQn
	lgaZF2p+rPk4
X-Google-Smtp-Source: AGHT+IGj8GaFHbpoFkyfE8+hYEWTuecErBuc/jm4EgwBIFhilzrgY8X1/Y3mKgCXlqFxzbwZzDPJiw==
X-Received: by 2002:a92:c269:0:b0:3cf:fe21:af8 with SMTP id e9e14a558f8ab-3d28078d48emr2028815ab.4.1739554113999;
        Fri, 14 Feb 2025 09:28:33 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ed282dd1b7sm901057173.120.2025.02.14.09.28.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2025 09:28:33 -0800 (PST)
Message-ID: <e18f2a29-be98-4d08-8d83-5370e01d6d7e@kernel.dk>
Date: Fri, 14 Feb 2025 10:28:32 -0700
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
Subject: [GIT PULL] io_uring fixes for 6.14-rc3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Set of fixes for io_uring that should go into the 6.14-rc3 kernel
release. This pull request contains:

- Set of fixes for a potential data corruption issue with
  IORING_OP_URING_CMD, where not all the SQE data is stable. Will be
  revisited in the future, for now it ends up with just always copying
  it beyond prep to provide the same guarantees as all other opcodes.

- Make the waitid opcode setup async data like any other opcodes. No
  real fix here, just a consistency thing.

- Fix for waitid io_tw_state abuse.

- When a buffer group is type is changed, do so by allocating a new
  buffer group entry and discard the old one, rather than migrating.

Please pull!


The following changes since commit 8c8492ca64e79c6e0f433e8c9d2bcbd039ef83d0:

  io_uring/net: don't retry connect operation on EPOLLERR (2025-01-30 09:41:25 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.14-20250214

for you to fetch changes up to d6211ebbdaa541af197b50b8dd8f22642ce0b87f:

  io_uring/uring_cmd: unconditionally copy SQEs at prep time (2025-02-13 10:24:39 -0700)

----------------------------------------------------------------
io_uring-6.14-20250214

----------------------------------------------------------------
Caleb Sander Mateos (2):
      io_uring/uring_cmd: don't assume io_uring_cmd_data layout
      io_uring/uring_cmd: switch sqe to async_data on EAGAIN

Jens Axboe (3):
      io_uring/uring_cmd: remove dead req_has_async_data() check
      io_uring/waitid: setup async data in the prep handler
      io_uring/uring_cmd: unconditionally copy SQEs at prep time

Pavel Begunkov (2):
      io_uring/waitid: don't abuse io_tw_state
      io_uring/kbuf: reallocate buf lists on upgrade

 io_uring/kbuf.c      | 16 ++++++++++++----
 io_uring/uring_cmd.c | 28 +++++++++-------------------
 io_uring/waitid.c    | 18 +++++++++---------
 3 files changed, 30 insertions(+), 32 deletions(-)

-- 
Jens Axboe


