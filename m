Return-Path: <io-uring+bounces-80-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 105B97E7E29
	for <lists+io-uring@lfdr.de>; Fri, 10 Nov 2023 18:33:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C3CC7B20C54
	for <lists+io-uring@lfdr.de>; Fri, 10 Nov 2023 17:33:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D796520338;
	Fri, 10 Nov 2023 17:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gRrZ5n8G"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638B9219EB
	for <io-uring@vger.kernel.org>; Fri, 10 Nov 2023 17:32:54 +0000 (UTC)
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771ED446F6
	for <io-uring@vger.kernel.org>; Fri, 10 Nov 2023 09:32:53 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id ca18e2360f4ac-7a950f1451fso1110039f.1
        for <io-uring@vger.kernel.org>; Fri, 10 Nov 2023 09:32:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1699637573; x=1700242373; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5bDmiLaGVm60HLMeKwi9hDr5D1dGHNrTG0OEtlRHSHo=;
        b=gRrZ5n8GKJsiQkloaYP6hcSuoEn7ChD3lKECwaXW8F9C3aINVU88Mfo1+m3BYMRbW+
         S3s4yy61xzlMuhinlzbgpq2p0QKO4BO27Oa+wc9nSYai1jJ66CxnHJ48vEANxKnfHGc7
         R83Mfc3JLUSJ9Ra1P93jOVdszaSxDMyN/MCYPtAPdB+n6QIddDuq1CzSozrFjln1/nJJ
         1nkxlRUxmu4QRlYVWUSYJwa/0pBhj7EI1b3VAf4KMZCFsEQFdRbi8NtqmbCDIbo5N/hb
         81q2yn/IjLG/5mE5htF2r8S6AHQMTri6+YdBwVH3HBwmIZCV8ZIs61tTWu76sb8XF9uQ
         VhHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699637573; x=1700242373;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5bDmiLaGVm60HLMeKwi9hDr5D1dGHNrTG0OEtlRHSHo=;
        b=NNFoJ1c+9o7jS0SHrKziXXh90GTgNsJLQSRNxpb4AMX+UQiripSUy295gXnMSYjEoN
         0mTaAVS3nyFOwx5yLlMMj2nS56O1xjPblNQTHfsy5FLhJAtb7uCwh940xfK/qpF9t2Ms
         OTwCURVyi8K4nEIKsp6Xxnw6C8tY1/ZsTtMey6cRA4/1S2+2o53G8FQ/c4PWKBkPKKWb
         JcUdtxGqkYkMgO23ZeCBBbwIiBN7S7WpEN4Hs2DYMnnEZOAPs0bURoLM3HG6Y3AjJo06
         yy08TzNZ9CHEgCHvtPrT0lpvJPjGeE+f2YFcgqxUKuI0UF0ttn9DnLbKs9HVq8jET2hD
         STlg==
X-Gm-Message-State: AOJu0YygtM2M0+LOoBzQcVZhsoZvo/SWvzgE3qZK5pKbyNBt4BhdFZ6O
	obbArBktKKPa3EWpDrF5EfDlK0ZanhpdeuyI4uH4cQ==
X-Google-Smtp-Source: AGHT+IGLkDfyANKJVpTJju8IcVIHcbcym0m2N/svx0rnnaQtqFNuF15xzd3WaTltWRX85+fFxUZ4FA==
X-Received: by 2002:a05:6602:b8c:b0:792:7c78:55be with SMTP id fm12-20020a0566020b8c00b007927c7855bemr10994177iob.0.1699637572865;
        Fri, 10 Nov 2023 09:32:52 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id k19-20020a6b6f13000000b007a67b8e9e34sm4721814ioc.32.2023.11.10.09.32.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Nov 2023 09:32:52 -0800 (PST)
Message-ID: <d0e69261-4d09-422c-a5f9-8a1015da0466@kernel.dk>
Date: Fri, 10 Nov 2023 10:32:51 -0700
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
Subject: [GIT PULL] io_uring fixes for 6.7-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Mostly just a few fixes and cleanups caused by the read multishot
support. Outside of that, a stable fix for how a connect retry is done.

Please pull!


The following changes since commit 8f6f76a6a29f36d2f3e4510d0bde5046672f6924:

  Merge tag 'mm-nonmm-stable-2023-11-02-14-08' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm (2023-11-02 20:53:31 -1000)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.7-2023-11-10

for you to fetch changes up to e53759298a7d7e98c3e5c2440d395d19cea7d6bf:

  io_uring: do not clamp read length for multishot read (2023-11-06 13:41:58 -0700)

----------------------------------------------------------------
io_uring-6.7-2023-11-10

----------------------------------------------------------------
Dylan Yudaken (3):
      io_uring: indicate if io_kbuf_recycle did recycle anything
      io_uring: do not allow multishot read to set addr or len
      io_uring: do not clamp read length for multishot read

Jens Axboe (4):
      io_uring/rw: don't attempt to allocate async data if opcode doesn't need it
      io_uring/net: ensure socket is marked connected on connect retry
      io_uring/rw: add separate prep handler for readv/writev
      io_uring/rw: add separate prep handler for fixed read/write

 io_uring/kbuf.c  |  6 ++---
 io_uring/kbuf.h  | 13 ++++++----
 io_uring/net.c   | 24 +++++++++----------
 io_uring/opdef.c |  8 +++----
 io_uring/rw.c    | 72 ++++++++++++++++++++++++++++++++++++++++----------------
 io_uring/rw.h    |  2 ++
 6 files changed, 80 insertions(+), 45 deletions(-)

-- 
Jens Axboe


