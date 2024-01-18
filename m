Return-Path: <io-uring+bounces-426-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B593832156
	for <lists+io-uring@lfdr.de>; Thu, 18 Jan 2024 23:05:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE717282FEA
	for <lists+io-uring@lfdr.de>; Thu, 18 Jan 2024 22:05:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72C152EB06;
	Thu, 18 Jan 2024 22:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ghKfgaK/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330132E848
	for <io-uring@vger.kernel.org>; Thu, 18 Jan 2024 22:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705615532; cv=none; b=Mnek6u75VbvI4y/IuZiEtJXXbJB9lG+rgT/apVMbKHKAiAseBSJVBy/ygaQZSFi5EBJOhX61/QHM0ihHzkJWljkSa+rS+HTFQM2OfdQLcLkNUqecWgk7D/XTkO1g3Uc6EmlwR/aB2hP3m3/vrsOViH+6XS3WZN/6l+wyE5mo4FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705615532; c=relaxed/simple;
	bh=FBPSuDT89mT1tydLXpCsrAV/1W9uZRXuCjZKqPpsbQ0=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=LZ94BzC3agT4a06A1Hi2NGCJi1dSz01xAyN80jXW1HpSG0ab2Q5YNr7APv5stY+8SCW/p7JeMRhXxpH2VUQNK20ukTs1i6awLN8lFP7lU5px0h/VoolfU8oBzCwCZG8p+WDBnk/jomgGdHZ3+DFqD9IcWoTORjg9oi7JtKVonpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ghKfgaK/; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-5cdf90e5cdeso34928a12.1
        for <io-uring@vger.kernel.org>; Thu, 18 Jan 2024 14:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1705615528; x=1706220328; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4LEHwChTbFgz9jP7ydRAgw1ZDZkZ74Lsf9abd/R5vUI=;
        b=ghKfgaK/OXP6f0PvgvtzEOOIv2ROzvmDbhCXJzo8s2K2+HeJle4h5Oxb6QxClEDH5j
         hdLb7lXUxYujfr5mh88BvLlCM/tK/zymcVheiNS1qKf8kU9j+g58phWQC6jGfiZOSmn0
         fByxqX43b2QF/76OxCkpo9nrT7EBzAhowWWeqkYtqm0DkaesKb8Fw3H4gwo1yKBj47vu
         j6Ih1RS7ACqNSpkXXDxBtwpVlPtHj9XIpzqkr6xs1+mcFCFBfGZP123S4ZxIIVad2Fzt
         XJ5IgFlXePXI/HODL/rUg2e+7cuejIQVIGvHguHHWATP/f5+wyuM2awZlFvqLyOFc3NI
         xlcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705615528; x=1706220328;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4LEHwChTbFgz9jP7ydRAgw1ZDZkZ74Lsf9abd/R5vUI=;
        b=fNCJXsKevwq88yko2s+GZsgaO5CYi/2cfjshrg6fTUwqZzE+qayC6spVm1JOSrLLbQ
         PRxI0ofhay68F3VIr95pX5K8hA9JFYgVr5suUlv/+pal6TngJOQHWTNDlPzGJH6vE1wH
         2EoOWg5rc7/HEkWJRoya5y/xhpN86wfd9Aj2aFkCMpLGjqZS3HRbL/6AkdqqZ05nZdGZ
         QdzDPd9U9r/YlJACK5NvycNIssfUsxXzwOikj4LyjlpzeUk3VyGoOPR3VCGIUqp4EeAJ
         LeWdwUscgEuHahVOFZ8hoQppgjDVGhBMZbSSHOuudT32Vm1cic7tjiIjasQJh74MpYQA
         Q2dA==
X-Gm-Message-State: AOJu0YztOx4sbhdf/ENhqR1M7LMiwTJXi7HFP0I5xcjvKxzY1/fzTsC+
	fzMXzoEaxrtagti1Bqi9qn33gB32r7TiZm13grhNyEjh2wKwCXiXzL2P9egOcgyiGxfaBkxMxmn
	H
X-Google-Smtp-Source: AGHT+IHdeOWmo63cWQ3+XFOzb7WEqu8ImFT7dQ6AmNj92kBSBCi99miqHQtrCxbF0JGqs6S9PlGVtg==
X-Received: by 2002:a17:90a:df8f:b0:28e:1e79:c5c2 with SMTP id p15-20020a17090adf8f00b0028e1e79c5c2mr494204pjv.1.1705615528438;
        Thu, 18 Jan 2024 14:05:28 -0800 (PST)
Received: from ?IPV6:2600:380:4a42:5ed:5773:6488:5dc:8499? ([2600:380:4a42:5ed:5773:6488:5dc:8499])
        by smtp.gmail.com with ESMTPSA id co19-20020a17090afe9300b0028db1713cbbsm2390274pjb.1.2024.01.18.14.05.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jan 2024 14:05:27 -0800 (PST)
Message-ID: <e0d9841c-0ff8-4cd4-a0d6-dab694598b8f@kernel.dk>
Date: Thu, 18 Jan 2024 15:05:26 -0700
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
Subject: [GIT PULL] Followup io_uring fixes for 6.8-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Nothing major in here, just a few fixes and cleanups that arrived after
the initial merge window pull request got finalized, as well as a fix
for a patch that got merged earlier.

Please pull!

https://www.wikihow.com/Live-off-the-Grid

The following changes since commit 6ff1407e24e6fdfa4a16ba9ba551e3d253a26391:

  io_uring: ensure local task_work is run on wait timeout (2024-01-04 12:21:08 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/for-6.8/io_uring-2024-01-18

for you to fetch changes up to b4bc35cf8704db86203c0739711dab1804265bf3:

  io_uring: combine cq_wait_nr checks (2024-01-17 09:45:24 -0700)

----------------------------------------------------------------
for-6.8/io_uring-2024-01-18

----------------------------------------------------------------
Jens Axboe (3):
      io_uring/rw: cleanup io_rw_done()
      io_uring/rsrc: improve code generation for fixed file assignment
      io_uring/register: guard compat syscall with CONFIG_COMPAT

Pavel Begunkov (4):
      io_uring: adjust defer tw counting
      io_uring: clean up local tw add-wait sync
      io_uring: clean *local_work_add var naming
      io_uring: combine cq_wait_nr checks

 io_uring/io_uring.c | 63 ++++++++++++++++++++++++++++++++++++++---------------
 io_uring/register.c |  8 ++++---
 io_uring/rsrc.h     | 14 +++++++-----
 io_uring/rw.c       | 48 ++++++++++++++++++++++------------------
 4 files changed, 86 insertions(+), 47 deletions(-)

-- 
Jens Axboe


