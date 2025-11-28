Return-Path: <io-uring+bounces-10834-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 73347C93077
	for <lists+io-uring@lfdr.de>; Fri, 28 Nov 2025 20:33:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 660404E4B8F
	for <lists+io-uring@lfdr.de>; Fri, 28 Nov 2025 19:33:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E8702D0C7F;
	Fri, 28 Nov 2025 19:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="f8NQsXix"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E6C244671
	for <io-uring@vger.kernel.org>; Fri, 28 Nov 2025 19:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764358378; cv=none; b=AZLpBcdBbJHrSusxZXlIgkffVT+Wtem9b0zc2mm3JJ4rkO1sC1obsSPMa6DXgsLc8vLtASEGFIrnkdALUPeJV+RmhbaBMMOWuLAs7ibolpsWZeiySvvbr19/22CbvPZNhyr2FjsnAKbAyqv1pzSmvWzNXwPQJtRLwBL8q3Jfzyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764358378; c=relaxed/simple;
	bh=W1J29jk5veQziBct3BPHWk9r/7nwqNt3kXGLbX4xH4I=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=RidVGSmH7bIEsKYhl6OR2iPKcNs+Og8HLruux+tI7gegYCm1UIER/dWHWgtLQRirJXRIJsG8oHvcokgbRvbrZW58EB/fv8TRcPFnZFTtIPBqY6scWsnGVXad4dwk8L+n2jMmE6geTofMvklWjpZzeytd0og9q4V2tWJQIFlI18o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=f8NQsXix; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-4330d78f935so9232045ab.2
        for <io-uring@vger.kernel.org>; Fri, 28 Nov 2025 11:32:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764358374; x=1764963174; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gJYu1phbUvH9/hniH+gCB5UZ3DmhkmuK2udl87zkcY0=;
        b=f8NQsXixIoFnjvf6IsI8RVxtIlLRnGKrPROY4HvEZ9LEF67JIN66qJ6vdTtNVaRcq+
         9nrJRYBbcipOFx+W6P5LXZk4uMeUKPRVQkdnBLtw1EHftuV95Y9glCG+EWj5mOSmLDD0
         sdOuHH+2TYhdVs7Z0Q/0Sz86coXrzf+hBJvlszRg+iW1+/oWnfvFhx3Wd3juQ4fkbOF9
         K8+P/DeZgvOERvUP0X1l+10B4pIdOouLkZDXwgALJX9HX3n8OcAVTOqfTTmlIW9IWovG
         Ox5l+Zo03sBnAl/o9EPZYC90WFG5Dh5+PSAiykLBl/lIBec6y7Zp0mbDxisjYDZQelvc
         +9Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764358374; x=1764963174;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gJYu1phbUvH9/hniH+gCB5UZ3DmhkmuK2udl87zkcY0=;
        b=kRHYuUZYfkmbNl/U0c9FROE7xcrFjXxB/00PBafwIEQYX7Pcbp35COQ0EdnEncJ3Td
         i1Z2Sv0yJIv1ckCWXtQ7cEcLbMFWAX48VW+EAFC94U1phJlogq3fY//ZbMmJJsxfixM/
         YothPBYN4SsjE5lqVyQC+pfYZkYgpXDliiNqeNL+PbM/z2nwvn901/qd3NEwkW2PqIdA
         ksp0lMkcKxMhm6I+cu/IajP5QMkQdYkaa3nHicTQA9MjZt/IM5so6XBvgDaFlkbdU5fU
         VZoybIIzlX7IknOmcAEDVWoeAPHhgCSgNazMBBmZ6XYWAkRxvo/IefAInjGVvYHkBMaA
         nBYw==
X-Gm-Message-State: AOJu0YweJ04h6F7GW47xJgy86Hg/3/7GuYQfpE/IqR3fnXMdlYea7LtI
	jutrg72enzGgeEnQjpwlOzjL966znXhIAmYRbqnBfeUmCe7T7vBp60BUxFEEX449Yu8=
X-Gm-Gg: ASbGncuwckxTnUH1CtFIqdwo8qiJsrKwGBql5MHVhOMreKY4MGO6SaS/rdj9KC1D9Td
	j1hNs5OCSvF8gyV12QSpFEFeunfYvRFIunEpr6A5CephOgSCUqZwF//6Hokvs5lRJZYTcsEBnBa
	4K7St/yPguttoOaPY5JrbFLU6qkEabdHWExRJIQdosckrhmMhpSDvIph1ho20GA/dNo8J3fPsue
	jnFj0JP+63AC8r+okgejgpyBX94FtRYfLDejQW/rK2yVZSS8mPCyJWudCdqfxmDBR5wlHDcCaA0
	Iux3/1I8sJwQj/gX0ZQef+O6S0ewvSiTaz+xX9yjkAGOP+ghVQYezZhIa544tDwO1p+IIKjAZNB
	phh+upggIo0R8mB1lWfJdYrm+hqAC2wGlwk6DCyXqJO+hsksbJpsbTUdS4dG9/gdK5BKnyWdx6V
	yYBaxZhSJx
X-Google-Smtp-Source: AGHT+IFLJBLFQ9Zw8/k5VOT70j4JgO8XgSezTaJGS0zOpgi9ZQff2/ivJgncdwiJIniobDzoibWvUg==
X-Received: by 2002:a05:6e02:194a:b0:425:7534:ab09 with SMTP id e9e14a558f8ab-435b8bf922amr263391585ab.7.1764358374582;
        Fri, 28 Nov 2025 11:32:54 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-436b33b7072sm26965405ab.17.2025.11.28.11.32.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Nov 2025 11:32:54 -0800 (PST)
Message-ID: <c7983db3-002d-41a0-bc04-523eceb70748@kernel.dk>
Date: Fri, 28 Nov 2025 12:32:52 -0700
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
Subject: [GIT PULL] io_uring fixes for 6.18-final
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Two fixes that should go into the 6.18 kernel release:

- Ensure that vectored registered buffer imports ties the lifetime of
  those to the zero-copy send notification, not the parent request.

- Fix a bug introduced in this merge window, with the introduction of
  mixed sized CQE support.

Please pull!


The following changes since commit 46447367a52965e9d35f112f5b26fc8ff8ec443d:

  io_uring/cmd_net: fix wrong argument types for skb_queue_splice() (2025-11-20 11:40:15 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.18-20251128

for you to fetch changes up to f6dc5a36195d3f5be769f60d6987150192dfb099:

  io_uring: fix mixed cqe overflow handling (2025-11-25 07:03:45 -0700)

----------------------------------------------------------------
io_uring-6.18-20251128

----------------------------------------------------------------
Jens Axboe (1):
      io_uring/net: ensure vectored buffer node import is tied to notification

Pavel Begunkov (1):
      io_uring: fix mixed cqe overflow handling

 io_uring/io_uring.c | 2 ++
 io_uring/net.c      | 6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

-- 
Jens Axboe


