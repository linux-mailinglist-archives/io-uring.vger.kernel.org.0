Return-Path: <io-uring+bounces-8646-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4513BB01E79
	for <lists+io-uring@lfdr.de>; Fri, 11 Jul 2025 15:59:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4D20CB62265
	for <lists+io-uring@lfdr.de>; Fri, 11 Jul 2025 13:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 977641A2632;
	Fri, 11 Jul 2025 13:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2IAfFl9T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA132AD21
	for <io-uring@vger.kernel.org>; Fri, 11 Jul 2025 13:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752241668; cv=none; b=faZFN/j9u5PNu8LNcDpZArPcfcGM3Ob8bqXpEikeLUzB8sXKd337BoBS7Z+Y6eT/yNxYcVWiHBvYgWjqYVt64dCYx+Xa2OGoT16MmJTOpXns86LIk0QvuFRXezVlIq6QXkWiG237+DZ7sCa3i6P39Ru3gqs1A1bw+ZkZbfU55Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752241668; c=relaxed/simple;
	bh=CdHUNRkv2opzAeNNXV6KJxQKnaKy6KLx58wfAd2DNvA=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=I9FLn4vMgfdNYT6qKbvFELeVeyEfFwd/WISJkTfjAYfzbJa5fKa6wAmPU2DtsQMYctt39FgBjuwDoAM01M/ocHzUXGWr28HcDeQM3T02duRcbXc22I0vu4hEN6OF8PawlfTO8+VfvN1dqDaPgSbeHcwUssfdc2wYUNJa2FIy6xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2IAfFl9T; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-8794259ffe8so59219539f.1
        for <io-uring@vger.kernel.org>; Fri, 11 Jul 2025 06:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752241666; x=1752846466; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M0x8wTSsSQ3yEf7OM92qeScdUyMwLLJ/NW32IkUQu+c=;
        b=2IAfFl9Thb1SEW0xEorTDeOeITQv9sHr09WoNhwlNOOjon91yP3nC2tg69WcRQ3OsK
         V2LaCOmwkJI/iZKEJrnZtpmEQE747MlsSBmxQkUf6EQoU3FW3ZW7aXZB40CuTbjTfoLR
         SoFbNWWaxiTQVvatUDP9xoK0WQS21njC6qSIQB1NrD6KCuGvBP5hvKGx3aDmqvE6GUU6
         k84FaEuGsYIkANtlwspMqrqdDgGPlIq/dAVDy1uX7GWcfIihNK0zbbgaEjuYfFWIdjw8
         Ft3Ia955NzWFsIAZ+PZFnzUTesRe4ALytP5XrpD0nPoG/m/tygeqGV4tktGAiquaU5ug
         hvwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752241666; x=1752846466;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=M0x8wTSsSQ3yEf7OM92qeScdUyMwLLJ/NW32IkUQu+c=;
        b=BOLgKk+VIEkQXQYydGdFNLgiJJPeZsM3qiFgePdqbtTjmJ9VrjQrF7KRvJi92KyP++
         1tu9wObynvaAmoLDBmpDQ4wgffUmR39OBH/HAqM5lIpIXyex1r1ovoRCiPRm/2fgWM5V
         PuJ/XOXXrALhW0k14Y2wPs4ehW9aYprk9L2/iXNhH+TO38L5Gum6u2zBSWatVIvZPIon
         jFa2FraWA0xcyYBePSsiOfuCr1D9LodngA9nWekDFBgjcNBTCp/hHb0a/5DTUj/HpGN7
         M38Sfzfy1R0iBijuEnhLPYuJX5fjw4LUsJa4eDVrJP02QiZY/OiYAanaSpmmsUVGg4vS
         zX+g==
X-Gm-Message-State: AOJu0YzLXesJktGevCMj+Comyw/MXATREuJzJIICE2Ey9mRuqj3JioG6
	fMqfcAQ9gniv19VbaLo9oAeI7G0+7o7uWIAucD3qciBzOz6MwZ8w5n5hOw/LXJsrjBz/XrnB/9A
	e0okC
X-Gm-Gg: ASbGncsnnp4SO2G/rekEsxPwKQosBOt+GigftcRCo9hVTQm7hIM/+TQo9Kx3Qj9ujtm
	mLU8vzoVTcT5QKdRPRqo/SdIb/8Ok2VErRcXIemdmueN/FPtocO1baw3amLp4lbUdgaV1EuhGvW
	rpQP/RfNXwcB8mCdGzxAELUle+Xlgn6g41n7aHgo8ZBfZg3RMTN1xD0/wcSL7xjiPrjo52ezAYk
	vqiYCviwx9mGCqqaU9KAUYBj55vSjDuRNHBCI6hXM+aBeS1NDeq3e45vAEXI4h4NuNpSaSvFkuM
	kflTMs/3DfbuAU/qV0A041tMEvwwzE71DaKXk8jsGI8wJmv2VURNibH7eYUsTjq7VUcdvRsynyx
	XuhbCy5sk4zMhsRzSqds=
X-Google-Smtp-Source: AGHT+IGM3vZ0ViNjwH1KasJkvx5oyXq8JWlm3fG3pWmVwzQFtboyK4irJwxU1q4vJI+o6EuZzeIpLw==
X-Received: by 2002:a05:6602:400e:b0:876:737:85da with SMTP id ca18e2360f4ac-87966e04798mr808935439f.0.1752241665347;
        Fri, 11 Jul 2025 06:47:45 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50556b0f297sm847146173.122.2025.07.11.06.47.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jul 2025 06:47:44 -0700 (PDT)
Message-ID: <bc75d13a-cea1-4a0d-a849-84b1379a1bc3@kernel.dk>
Date: Fri, 11 Jul 2025 07:47:44 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.16-rc6
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Set of fixes for io_uring that should go into the 6.16 kernel release.
This pull request contains:

- Remove a pointless warning in the zcrx code

- Fix for MSG_RING commands, where the allocated io_kiocb needs to be
  freed under RCU as well.

- Revert the work-around we had in place for the anon inodes pretending
  to be regular files. Since that got reworked upstream, the work-around
  is no longer needed.

Please pull!


The following changes since commit 6f11adcc6f36ffd8f33dbdf5f5ce073368975bc3:

  io_uring: gate REQ_F_ISREG on !S_ANON_INODE as well (2025-06-29 16:52:34 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.16-20250710

for you to fetch changes up to 9dff55ebaef7e94e5dedb6be28a1cafff65cc467:

  Revert "io_uring: gate REQ_F_ISREG on !S_ANON_INODE as well" (2025-07-08 11:09:01 -0600)

----------------------------------------------------------------
io_uring-6.16-20250710

----------------------------------------------------------------
Jens Axboe (2):
      io_uring/msg_ring: ensure io_kiocb freeing is deferred for RCU
      Revert "io_uring: gate REQ_F_ISREG on !S_ANON_INODE as well"

Pavel Begunkov (1):
      io_uring/zcrx: fix pp destruction warnings

 include/linux/io_uring_types.h | 2 ++
 io_uring/io_uring.c            | 3 +--
 io_uring/msg_ring.c            | 4 ++--
 io_uring/zcrx.c                | 3 ---
 4 files changed, 5 insertions(+), 7 deletions(-)

-- 
Jens Axboe


