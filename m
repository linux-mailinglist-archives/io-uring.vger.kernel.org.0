Return-Path: <io-uring+bounces-8498-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 041B6AEB9CE
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 16:26:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 393524A38AB
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 14:26:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C60692E4258;
	Fri, 27 Jun 2025 14:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="X/Nifwzn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F672E3B08
	for <io-uring@vger.kernel.org>; Fri, 27 Jun 2025 14:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751034330; cv=none; b=qz/SpXwePJ6YKU/oeWimiwcMrDaEhyKvIYYo08q3QFT4SES63NHteJMHnJZ1A3a4EgQoNcmO4co/8hth3otIbxctTMZVerpg3NxbBailD9HXF7wtySxe2nZlviYHvpXOSOyUzzFTlyJhNXDwDWaLSrAeoRH6sU7kIepNDe2ZSII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751034330; c=relaxed/simple;
	bh=M+/ZB6XYsV4jXn2d2Z4PyR3g6DTKoKnsSomY7nC4NgQ=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=I5YTJeVIZr84/fzUxlKQVinmknCBr9n2MRSk8g26gD5i/q8ceyP/hTZ2foNOSLIxV4MWdqH3NshuFSkcLhfJckeBc3zcrjdQb6ZGQOsER/cOyi/2YdYGPljsjnzeuA9BXu+/E/q/z9WM44+m9qPEPaczvBj6idBCrdOrVuTCHr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=X/Nifwzn; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b2c4e46a89fso1883038a12.2
        for <io-uring@vger.kernel.org>; Fri, 27 Jun 2025 07:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751034326; x=1751639126; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oZ1iTZM7LOYhl/7fS4TVU9PkPZiypOWFGEQjtz+0LSc=;
        b=X/NifwznLRap+I2ph+d9kg45RoZd34uGmglyeJdtEUvokUJ00S8pwCl3d2aT6dnZN0
         cCD3nD2cZ0McOg40naiJ+BMuLs/eIknY2S+PLcxPECsTUvORPYcH2Up4oNctJtQ0oqs0
         19pfRzgt0nO8jEBD4V+CqTtSGd4MJKSNth2UUFiBUPl4DbOdBBWqcRs/1QVeAZQiJ081
         rtL6MTLJeyf0CSFM7SY8qrgCzTymeS/LVNOVlo/8OM5Snk4W346tNVYD4+I7leKefQDk
         9FiqcTFNmFuUUqQRVYDZaXImaJUnyLeYG/HY6sVk8/rkFlCYjVqh14vd51vw0ycjRSEV
         5QFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751034326; x=1751639126;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oZ1iTZM7LOYhl/7fS4TVU9PkPZiypOWFGEQjtz+0LSc=;
        b=IX7T5oVVxJpn+5CBnrRST9geLQS5uZXKs0/BW1nb5CTuoInZZSl8Nclh0eb8GqGAhb
         0ode6U6pNJs1rDLjflDhxaWSMgeTRqOJhjehPek4xr+6AVaqbauTEGx8xBIYNyJimngG
         x9TMPVcJYvc6AJy4GhzpT+pmtzovwwMLhKehcX+RTgdWmNEWasP0M3ydKXPPtzoGt1IM
         K/GmU+LXB6NDwq1TBtDoWeX+wWeqgQI4tdDIpmw5bDMmby7ni235r9r7i3X5vC3/JFyC
         yz8ETgxhaz8ECu9sKjFkDg93dS17+mxREO68CIpFTeZMbscsDjF8BPKNtBz0v8n170uD
         uCYg==
X-Gm-Message-State: AOJu0Ywjb+VqtLm1ZP6W7rfYYm66sC1YXrg9qqoFW0vTHlj59NeYHGtL
	mcpuKKzOGyHtWWdQrszsGOLouqAA35LaQZjIGbFr9kgps35A5a4IFZMx05W/JtUpA3GjfoaX1zI
	EkuE0
X-Gm-Gg: ASbGncvbKpVjpJSY4NvN0pXI4UZ8THdoM/rQJuSkaDncfsJ9xCDrKQ3pdJl86hS0rEu
	Bx39V+pHJynm+OX0YSwmCZRX+PB8n9CwJwGekNXULKVslJnV9G0eQq2WC4Rqzs0EkWppA94golu
	VQ20efW0OOgg7IWtklvjgU9QI9otrqq+ugWSTFqnsQ2hR87c/WNVmaRR2Fxw8Ld/EAEorMygIL7
	gnE8/oRKNJvb89vb4oYid+rBuRH5p5CCuOzF1ASN+Et75dsV/M4pC7jDKLiCFwaJJDXabDp65ey
	BYCRtNWAaGH1/n9SI4d5nWmlN0dJEwg+zEkmi3/TftiRS8cQN+q6iWLSEjAzlN0ByAFP
X-Google-Smtp-Source: AGHT+IH1hyDvFL8B1oaOIqVtirZQUPJaTOWlCmMMmBCCb/CDEKV7ahl59wQi5+shKT0csFEb7V4g0A==
X-Received: by 2002:a05:6a21:3284:b0:1f5:8cc8:9cbe with SMTP id adf61e73a8af0-220a12a66a3mr4874383637.5.1751034326071;
        Fri, 27 Jun 2025 07:25:26 -0700 (PDT)
Received: from [172.20.0.228] ([12.48.65.201])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b34e3200fedsm1757229a12.73.2025.06.27.07.25.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jun 2025 07:25:25 -0700 (PDT)
Message-ID: <681fa987-b28b-4669-82f2-d8d89966561e@kernel.dk>
Date: Fri, 27 Jun 2025 08:25:24 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.16-rc4
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Set of fixes for io_uring that should go into the 6.16 kernel release.
This pull request contains:

- Two tweaks for a recent fix: fixing a memory leak if multiple iovecs
  were initially mapped but only the first was used and hence turned
  into a UBUF rathan than an IOVEC iterator, and catching a case where a
  retry would be done even if the previous segment wasn't full.

- Small series fixing an issue making the vm unhappy if debugging is
  turned on, hitting a VM_BUG_ON_PAGE().

- Fix a resource leak in io_import_dmabuf() in the error handling case,
  which is a regression in this merge window.

- Mark fallocate as needing to be write serialized, as is already done
  for truncate and buffered writes.

Please pull!


The following changes since commit 51a4598ad5d9eb6be4ec9ba65bbfdf0ac302eb2e:

  io_uring/net: always use current transfer count for buffer put (2025-06-20 08:33:45 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.16-20250626

for you to fetch changes up to 178b8ff66ff827c41b4fa105e9aabb99a0b5c537:

  io_uring/kbuf: flag partial buffer mappings (2025-06-26 12:17:48 -0600)

----------------------------------------------------------------
io_uring-6.16-20250626

----------------------------------------------------------------
Fengnan Chang (1):
      io_uring: make fallocate be hashed work

Jens Axboe (2):
      io_uring/net: mark iov as dynamically allocated even for single segments
      io_uring/kbuf: flag partial buffer mappings

Pavel Begunkov (3):
      io_uring/rsrc: fix folio unpinning
      io_uring/rsrc: don't rely on user vaddr alignment
      io_uring: don't assume uaddr alignment in io_vec_fill_bvec

Penglei Jiang (1):
      io_uring: fix resource leak in io_import_dmabuf()

 io_uring/kbuf.c  |  1 +
 io_uring/kbuf.h  |  3 ++-
 io_uring/net.c   | 34 +++++++++++++++++++++-------------
 io_uring/opdef.c |  1 +
 io_uring/rsrc.c  | 30 ++++++++++++++++++++++--------
 io_uring/rsrc.h  |  1 +
 io_uring/zcrx.c  |  6 ++++--
 7 files changed, 52 insertions(+), 24 deletions(-)

-- 
Jens Axboe


