Return-Path: <io-uring+bounces-7542-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D9BDA938D2
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 16:46:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53A1B8E0B25
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 14:45:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E0D76BFC0;
	Fri, 18 Apr 2025 14:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0iFSCUGU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D7D24B28
	for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 14:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744987568; cv=none; b=Vtb4ELmhH2y7flcqMAI4RCHNdk1qepF72c4gyGqJLwtDhLwt3L9JBMoecpweGaynYxxawYkn5YiBQlKM3W90LZ+rUykjoiFK3uXPI0SI6TYs+E2yV7j877vuekpcShBWZru3shDtOHzgWVMtLOCjr5z+BbPInJ9n1kKZDzpu7ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744987568; c=relaxed/simple;
	bh=vbF8qz5chnp+VzABZ3GKSswqVMm3FIidNUy73VdpnPM=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=LvTlevRFiSxuNPPOpqLdQ5h+JgHPv94Aw5rsVrOGvBA0638mTwyCXtaA3jrLolI2rnSewDZ68l7jh87p73x6NQAMjH6QCBnjvYe6ekukUouK/2R+hHGZQVeSEtjZxNyOZYNdsnDFWBQl88MSGcGCU2oQF3mTtBETh4d4HgDRnpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0iFSCUGU; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3d81ea55725so5181585ab.1
        for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 07:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744987564; x=1745592364; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e/RUw3zcFtD+reF3s881W/aqpD52+gQdYdFwSDQCYEc=;
        b=0iFSCUGU2mcHwPNCMIOFsaXLNL96hk0gVsVvMlsGyJYC2xHRUdBG4CfnFuFkfJM8jg
         4xiNwoYCLoTVzgVnDMs+Hkuy0wSzTWxaxluHEOVoIdhoLibShvOqWyXBn+zu5Gv+9q9y
         jYIYWsBVsgrg2izlZD2bhrPt0r74yojSZ43r/H3ctZmWCaPsd/jKZByEAn7y+deV4hgN
         OEFDIEsVF7kw8bftAppzVhehbAncN0W4h5zZtzllw5ITjA+N1FAQD321p3IkL1rAiC0s
         9iBl795aFsfb8bIXQSkGIonczx1xIrzkTqCUCP7UI1gfhEeaqHJMrCH4OgKsln87ax9m
         qBqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744987564; x=1745592364;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=e/RUw3zcFtD+reF3s881W/aqpD52+gQdYdFwSDQCYEc=;
        b=vpvauWmOjt87dCQaIRCV6PV0NWIBRtBzFqe+/wrqoHc0MeNRVhJJVb4D90KAauvIP/
         74JheIuMVwTHQBOakApuGBym1DVE2kahw73syVNsplt5JpR+OaBVKg2E4PHOeipHjGq4
         cP1+/Byr9dThRz2W2Zcxv0KUWGko/AngCLVASOt+f3v6cFMETgQy2OqCofS2zOXwuXeB
         VJzg8ku7n9mqXxTX8D8myg24EYjcWyY8vYAacFWBIbKenX4vPmxusDBYx8ALFunX5hxv
         aoXt7LWjcceT/56WlP6gaL0CCER7BF6YUXH4pisOhHx+CmI5GQQx3oNUMqO75kWXk/Al
         sk5Q==
X-Gm-Message-State: AOJu0YyyWYKVjw/wZvmpo6g2mKlk+gXs4W7hx5UvMuvP+KscJLz1kIrw
	sAULiNAatqhaAc1e/eqi72FKgrebR6fRbGwBJVvQ5VSuQEFvQc1C0YZzlDQZc1N93SnHFv6QO3f
	T
X-Gm-Gg: ASbGncvOPu7QcmhQbjHRELenDCXN1S0TJyYQ4op0jLElrCn5VzOgZzfIAlsYUWObQPd
	N55Tyn+LXhFLTbIUCN9NjLJZKQwCjESLC9P2bKh4Cu1kG7lCvRIY9WMrltWvynhuWdK2ISxOaLY
	i9Q9NXmVHdG42aNJ1RKxrGoXFf3vxhEOuXMeVrb82cj+e4wLzsnSmP8bM49XUupuoO14jcxBk+T
	z8mAjaGCiEftg6FsiA1mzdYF0uihT6Cd1PFqRKCqAqHs8n/AZ+iEQVN2Z+EM6gMtO3D5rEk2Uxh
	LSXEmKVjZpc5w2tDR8sKaxFExpKQK6mAlv/J
X-Google-Smtp-Source: AGHT+IGFr7Asp7UMvO+Tfs/ovRavy0RId6IOz0HWn99SS+jCcEqBso4YnHKSWQefsbVlb0lkt4bKpw==
X-Received: by 2002:a05:6e02:214f:b0:3d3:dcc4:a58e with SMTP id e9e14a558f8ab-3d88ed7c050mr26542135ab.8.1744987563988;
        Fri, 18 Apr 2025 07:46:03 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d821d37514sm4715275ab.16.2025.04.18.07.46.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Apr 2025 07:46:03 -0700 (PDT)
Message-ID: <a88f9dd9-5bcd-4103-8df6-3dd8d29288e9@kernel.dk>
Date: Fri, 18 Apr 2025 08:46:02 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.15-rc3
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Set of fixes for io_uring that should go into the 6.15 kernel release.
This pull request contains:

- Set of patches correctly capping iov_iter->nr_segs for imports of
  registered buffers, both kbuf and normal ones. 3 cleanups to make it
  saner first, then two fixes for each of the buffer types. Fixes a
  performance regression where partial buffer usage doesn't trim the
  tail number of segments, leading the block layer to iterate the IOs to
  check if it needs splitting.

- Two patches tweaking the newly introduced zero-copy rx API, mostly to
  keep the API consistent once we add multiple interface queues per ring
  support in the 6.16 release.

- zc rx unmapping fix for a dead device

Please pull!


The following changes since commit cf960726eb65e8d0bfecbcce6cf95f47b1ffa6cc:

  io_uring/kbuf: reject zero sized provided buffers (2025-04-07 07:51:23 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.15-20250418

for you to fetch changes up to f12ecf5e1c5eca48b8652e893afcdb730384a6aa:

  io_uring/zcrx: fix late dma unmap for a dead dev (2025-04-18 06:12:10 -0600)

----------------------------------------------------------------
io_uring-6.15-20250418

----------------------------------------------------------------
Jens Axboe (1):
      io_uring/rsrc: ensure segments counts are correct on kbuf buffers

Nitesh Shetty (1):
      io_uring/rsrc: send exact nr_segs for fixed buffer

Pavel Begunkov (6):
      io_uring/zcrx: return ifq id to the user
      io_uring/zcrx: add pp to ifq conversion helper
      io_uring/rsrc: don't skip offset calculation
      io_uring/rsrc: separate kbuf offset adjustments
      io_uring/rsrc: refactor io_import_fixed
      io_uring/zcrx: fix late dma unmap for a dead dev

 include/uapi/linux/io_uring.h |  4 +-
 io_uring/rsrc.c               | 92 ++++++++++++++++++++++---------------------
 io_uring/zcrx.c               | 37 ++++++++++++-----
 io_uring/zcrx.h               |  1 +
 4 files changed, 79 insertions(+), 55 deletions(-)

-- 
Jens Axboe


