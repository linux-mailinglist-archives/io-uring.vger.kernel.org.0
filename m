Return-Path: <io-uring+bounces-3836-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B2999A5103
	for <lists+io-uring@lfdr.de>; Sat, 19 Oct 2024 23:54:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F9431C21365
	for <lists+io-uring@lfdr.de>; Sat, 19 Oct 2024 21:54:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 655BC1922DB;
	Sat, 19 Oct 2024 21:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RFBmzKL+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB69155398
	for <io-uring@vger.kernel.org>; Sat, 19 Oct 2024 21:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729374891; cv=none; b=QBcJppKauYvTaG6hFMCbzOgxKUMYjxse1dG68TiArqJ14fGRO2YhMFGcIBRNJOZ7iHasBSA8sdiTlk527sShOT45wF6T6QZadJPqSiWmpnFRdcg8s+kVkwenQ7jw3VnhdioEoxbonDAI/LUBMXf0+x6txS8GFrBSA3PAoHvzOjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729374891; c=relaxed/simple;
	bh=VIeuKoRDfVhZktAkhzoJIUXGa7mt/wO2f+w9E2sSyow=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=FFOnbB9SU5VOOiPbpD4QZbnqMs16pP9/UpA7PVk87p8cXAqxyzBQVRZUQ4JQ1yBKUCBj/LDU+2HA+wSqCDKW5P5GcPujgKz2y4nQjaJYei7Mv7bkWZNNE59wKZ/o6GywuM1lBw1rwwYDql1MctDkpBrqE44Y2BinRgfo/wW3f+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RFBmzKL+; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-20caea61132so26341915ad.2
        for <io-uring@vger.kernel.org>; Sat, 19 Oct 2024 14:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729374887; x=1729979687; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iXK3dXYAQ3I6TNo9U+N78/SBctM91SVh2qa3xxOEaUc=;
        b=RFBmzKL+QN29ZYkXkzR9NSajMMJ9B4fdumSgm4NImVQLQWvquJjH5s9pGCaa6HjRbP
         lLbu31zbbSHsmlvgvwv/fVA9zLuRvZl3M1gYnzkqIr70WWjs7KBtSTr8EEiJ0ul50aO3
         s4r5m6g50sr57f68uYgURHsft2aH9opMZ9gW+U69k12jNlvSZn5XdRzsbQ/P/wLnr5BP
         0oMl0AtfY5UYKgr5Ws+dWsV5kOYc5/bVLJZksqSHP2OK77YHeR/sjNZLhRYzlqgr9Pgp
         UnusywMO7CPUuBjiClEBM7PiUSEHUoXzshecAxznytCFM+gvk8e/+0Y5/bLEqZjCw1L8
         JMzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729374887; x=1729979687;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iXK3dXYAQ3I6TNo9U+N78/SBctM91SVh2qa3xxOEaUc=;
        b=Jj3weP/HtX0+zLeqYN49xOIsKcOPTuJnLF/zFBvRLkpvZSOvxibr3G0Hsiw5N+MIF5
         b30ALjg1Y5Vg+xWroCLsaIs5t9PLp50Becq34cFQT0MHfIoCS9o2Rr1mvdqJLvi8GkwB
         jJIuRSi+FJbTFVs0UaMdJMxT6sBC4/m1qCHbVZYvdRTIssjj7N1v68mQKatar/1lALnU
         EQzAvhXUGqy5W+UdOotvSNUvb82OQgA160tHBuRSt7/reuGc69hHByf8PgSKbUa9NC27
         mJWmUxhsQmSg4bIEHBRNYQLKSNSNasHNA3cBkQJbLXdgRk7hYi6TYmfmlJN6UQlEEPcZ
         xyOA==
X-Gm-Message-State: AOJu0Yzf3060cJc6WIpGK6Ss+4XkZgbaqPZBuJY8iaJWOGZ1A5gqsbHM
	tC3oOv2Uc8xNNKenkd8/f109DitOgW62G/Qm42Zxo/fdDAyI6UGS5LU7Vk9/1z8Z/4yDHictWth
	m
X-Google-Smtp-Source: AGHT+IHXjFfisI0OEWZqNWwz4Hyv/7uc1FJUUH1+0mwldbZJ5P4XLkRp46XdrafUiN+tomFvfiJ2ig==
X-Received: by 2002:a17:902:d2d2:b0:20c:85db:fb6e with SMTP id d9443c01a7336-20e5a712e4cmr80676115ad.8.1729374887241;
        Sat, 19 Oct 2024 14:54:47 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7ef0adb4sm1785915ad.87.2024.10.19.14.54.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Oct 2024 14:54:46 -0700 (PDT)
Message-ID: <46257b01-db4d-4454-a1db-9e528bb8097e@kernel.dk>
Date: Sat, 19 Oct 2024 15:54:45 -0600
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
Subject: [GIT PULL] Follow up io_uring fix for 6.12-rc4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Got a report this morning for a regression that was introduced in -rc2.
Since it's pretty silly, the fix is obvious and would be a shame to have
this miss -rc4 since people are hitting it. A test case has been added
for this issue.

Fix for a regression introduced in 6.12-rc2, where a condition check was
negated and hence -EAGAIN would bubble back up up to userspace rather
than trigger a retry condition.

Please pull!

The following changes since commit 8f7033aa4089fbaf7a33995f0f2ee6c9d7b9ca1b:

  io_uring/sqpoll: ensure task state is TASK_RUNNING when running task_work (2024-10-17 08:38:04 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.12-20241019

for you to fetch changes up to ae6a888a4357131c01d85f4c91fb32552dd0bf70:

  io_uring/rw: fix wrong NOWAIT check in io_rw_init_file() (2024-10-19 09:25:45 -0600)

----------------------------------------------------------------
io_uring-6.12-20241019

----------------------------------------------------------------
Jens Axboe (1):
      io_uring/rw: fix wrong NOWAIT check in io_rw_init_file()

 io_uring/rw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Jens Axboe


