Return-Path: <io-uring+bounces-6981-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65FC2A56A46
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 15:23:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 825B07A1CC9
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 14:22:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E08418DF65;
	Fri,  7 Mar 2025 14:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="s0UpDvue"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E937121ABCA
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 14:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741357424; cv=none; b=ORbP9pC+dU4olsXXMXrw6VjG4AqCj0fZAHrd6hzaedD4KUqftYPT7Sn22qwXoHqaCl9+wNmebFDnszjuafiUKVm/bVfPHQnmo9ChfX1faoE2/2XihHd6Z9WbhLDRdu4kLdXNeA3xrL85ZRNuRH7tFk+9XNMrhRYyIl/9SECk4UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741357424; c=relaxed/simple;
	bh=dV2QoSCpCizQEnzxEaRdOmXecuIZCUyJmnK0QTy2Bq4=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=p3BUBKtWok9I2yrOwdUeP1q8bEGCxHXPZfjd5QIbwJ6PiEQeek1esYQWU3KwRboxQyoKWxN4UbtWizJB9vyHS7j89Wj6NBHSrYVf68JThy/PMMCTLU/8n4zmc3sTj/7OOdElrZsw8mk4arl13cMdQ876/xszWjzuLeuvIF8QYx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=s0UpDvue; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3cfe17f75dfso14976345ab.2
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 06:23:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741357421; x=1741962221; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q8bSmobAHeyRu4p94skQINdOvSFUVvb9Y3eFU7rGfTs=;
        b=s0UpDvueP1hd6fr4To2c1+pFCCmuooocN9TZBQRvHmEjpHi2g/+/Cq7V5OzMYpvwzi
         sq4ul5QerIAS76Kn5sskMobxfbjaIiNnPgpVeBZ1joE5T2UrH9lnZY72ZmVbjCcQu8Ae
         IsI93j/RNJ90SZ94I7djQ9MgJGjjGBHZjV+8GBvrRBY/vbwfHHhO9Ll6345cpaEdjIsx
         wNj8Yr+euMQgmDMFXpqSAPqq0Ml7zEvoz3PmLeaTD3l1bL0wfoSkaPtxWuHe77yQE8VY
         R1/Kf9/xrKDSFbYusoiTXypVgXEMFTpKLc4JTrX09wdgbYu778o3qGNCWuVVhwf140Xk
         xc9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741357421; x=1741962221;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=q8bSmobAHeyRu4p94skQINdOvSFUVvb9Y3eFU7rGfTs=;
        b=IcllhoAHII0ZJUQdmpa8oQoxG6durfSaahocAelvJd85KKFe+zPOXEWgmAaU8eRKd0
         kfmCZH03s3q6DkqI5+Ty87mH3+Klb8EGy6kyx5qSDtBvOdiYNPyp3YQg4Za97/YcWA5I
         GipnITkXAfuv2iBZ88FgFrY6U00zGl4euNLcZ6Tx3lxZNMKMzu+OUeWd3g/I2NKNIcvV
         qFrmCi6tb+oY0tcGKRHN/gnLuDP/r4qSOVEsZ2CtqcyfDB9o26/t46F/G79GGlnA1dZz
         4bofCL6/eV/4GJjPvh99Tuxb51rW8H/MENhRbtuM4Ypl4RsCi3znaGkACTUrwvNK6TNx
         0+gQ==
X-Gm-Message-State: AOJu0YxsRa7/DiAuWdBYHSnu/Qi6gr8wTtEdd+Bn9avNkOHsFRH0eq8S
	FqHFtbLeiw+Esuw4VqVPOeMdKTjqMPDtrgN17TaMbkRrZPV/bRW17iJ3Cus8Ir9bji7Bs1jiHSF
	z
X-Gm-Gg: ASbGncsuo/jgUx7cBmeNb0wNztABYMeeq1OmoVxJpndqVYjhJ0SLbSCuKZSNfr+wq/0
	WJd8Izz4ckXAtnn1pGPgd27oQ7ikH+69tWD0RcsdjGJCU1lYjtp4tp4IM+ZnP8OgleORjc/5u1g
	tlEGTmkYyxN4q1ALrlgx8TjclXtaps3IbF3W3+MzEC5v2L2e3sKRfoAXco+LBYxuxLkIUIo+sXQ
	eMHnP1KLJir661jbVcDPiiEBiHGc04UhzLWn9XGLTXTvtIdgZ8dKjwf+CBc05ATxZaPUj7iRm+W
	NbaxkuCR/7tz38nty6JV0wH/C9H/tvMHZ2heY1ww
X-Google-Smtp-Source: AGHT+IHonU9XZFAlVBfMcucVJNbeB3uy5TpaMZQwggW3AUW1jP04q5cwF3nyAE1UnOg/BA+5LZ0v/w==
X-Received: by 2002:a05:6e02:1a64:b0:3d0:618c:1b22 with SMTP id e9e14a558f8ab-3d441968a12mr31650415ab.11.1741357420994;
        Fri, 07 Mar 2025 06:23:40 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d43b4f74b3sm8475675ab.27.2025.03.07.06.23.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 06:23:40 -0800 (PST)
Message-ID: <00a11162-3ae8-4873-ab6d-e0b119095e82@kernel.dk>
Date: Fri, 7 Mar 2025 07:23:39 -0700
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
Subject: [GIT PULL] io_uring fix for 6.14-rc6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Single fix for a regression introduced in the 6.14 merge window, causing
stalls/hangs with IOPOLL read or writes.

Please pull!


The following changes since commit 6ebf05189dfc6d0d597c99a6448a4d1064439a18:

  io_uring/net: save msg_control for compat (2025-02-25 09:03:51 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.14-20250306

for you to fetch changes up to bcb0fda3c2da9fe4721d3e73d80e778c038e7d27:

  io_uring/rw: ensure reissue path is correctly handled for IOPOLL (2025-03-05 14:03:34 -0700)

----------------------------------------------------------------
io_uring-6.14-20250306

----------------------------------------------------------------
Jens Axboe (1):
      io_uring/rw: ensure reissue path is correctly handled for IOPOLL

 io_uring/rw.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

-- 
Jens Axboe


