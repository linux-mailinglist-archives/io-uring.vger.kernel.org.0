Return-Path: <io-uring+bounces-11014-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B6A3CB74F6
	for <lists+io-uring@lfdr.de>; Thu, 11 Dec 2025 23:38:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 56EBC300B80B
	for <lists+io-uring@lfdr.de>; Thu, 11 Dec 2025 22:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE664178372;
	Thu, 11 Dec 2025 22:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zOWc2rdg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE09772602
	for <io-uring@vger.kernel.org>; Thu, 11 Dec 2025 22:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765492729; cv=none; b=Mv2HDiPGeUBMgAIxw9islgfUL410thnp+vu86/+Hh4pLEAoQubAA1uNFFMNS+gSPskyJk70SPV0vTwESv0yvZV0RehonLeKTg+yuNEW4FWNhk1ohuXm3aFacPDSVXDJLLafGCqfYjdnGpoJUPnbrLWkNg9/4tMjOhdPyHx3rtZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765492729; c=relaxed/simple;
	bh=Xq5ZU76OSk5k3UlysGy6F4g8uQ89kImu19NSv7MEv7g=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=osk6mYyZrPRkt+zgPAOPi/i9hgJ8TB7gtT9eAEfP2agnmDWjc9UJd8bT6sU9nNtk5GelC6L8yBX9thjcWYwjxb0yN8VCBVJ4+M67CVe7XIe033M01o8lwf++DBfnShMpHdwic0KTqDhCJ7cnJ10FoYyMFXKnbGp47IysX6Ag+iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zOWc2rdg; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3436d6bdce8so622237a91.3
        for <io-uring@vger.kernel.org>; Thu, 11 Dec 2025 14:38:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1765492725; x=1766097525; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ofgvI3Y0XLUnAg9mpnbIFKBZnCwEoN7SjncpWFNbEY=;
        b=zOWc2rdg7e3dHPolIEfG6tEeijcN1L4ElYyeeStkFjWe2aoP68bFeLiOZO1MlfhN5o
         bXD67lwYmQFK57DVUH5lWZfA1EnAKcud1/msOZR7aoNYctlvKuj73pe6tT5/3REvV/rr
         s1hVtNsyrZqLTeHzd5PEAdRCwG31NtWRRkTQkOhi44QGZbr4RmOLNAOcfExwg9rpo4Tr
         +KmlWTiOk51QPcwNz+YmFSTU9Exfdz1a2Ri1M3GmC5eF7PhbynSp6TTpEfvx2+HpJNTg
         BPqyx0kWdjXhzRHEe9KYBvdarmv0gUy5/qsOBB0ZzRbb2qhrH40nlWSPo5mgc57gvwLd
         eaKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765492725; x=1766097525;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7ofgvI3Y0XLUnAg9mpnbIFKBZnCwEoN7SjncpWFNbEY=;
        b=tPSbxQ9VJjSpXv3/P2E5UJdCfKhqdACMJOaWTxjYNdDoVuKGqWur4A5mUcho9a4Ks6
         itC61vRPp06cGwqsFq6yCCq+gDQVUMcJp/QkhaNBPV5ysx8WT9gjltZHf2poiodcwAu1
         Ywk1oQxSUsQZ58Lc9f7aXHaCNUxFCtQi/8akDPWxcpeMdBSfJnRfhJjIblhOJCAQwpbO
         SVj8xx0GyviqnlyLT0b9zrzUjPdyIHUDSrHlgmguUuHrKKxHfqAlhI48UXE3Y8sHE10F
         NERtm1lJ0qPRUUCjF4tu0iiJMq13DgGjKRnQFdJFdDYJpJhvvOsnSrNVe3RZK4fPB424
         sB4w==
X-Gm-Message-State: AOJu0Yx9rrZEWvTwitXYcdXahhHlhwhWt5oXeRkgd+DSMAvIg+1CnFtW
	/KeeRsTbBHDYIOHEbG3OBgiAz+SiauHP7BdHgrrUCCTbpI21qfgRc+gzEeyGs74snmXWXFz/XDT
	4XzrqvudaLg==
X-Gm-Gg: AY/fxX6OJEL/axAznP7KHl6MVmyzh0LS9dCtoJKQwLBUHSUrEE6uUQby2RuPVVTKa/K
	u86AN6kaJ0NKdLr8Y4qNlt/vRkQUKgR6e0Ruf0g+iKYyshOmiH1GLRD9Z0oYfYqLu3L48qx5bzb
	yGAPZyIp8MaZBSS62ulw70pw2FUt8Mc8qL5sohcnXfrMs+o3eLPqCGKe+wfU+hJ9Tof/ltgZSMl
	PABI6sz2zgM7IrwN3oes29u67dPYNrPiqaoMMY7du3jB4zNIZBvQibhi+42PrBNmzZNNHFeuA3q
	REUeUpylmn4it5nAYsS5bvMFXEIjEXeVscmU3z3+LnBO6pixWMZpS/qLjq3IAsxbPwcEJppddEM
	Z6JekrGHKmynlgjahE7/yrvc/oS024SM6xFMwU6ktyjQrPj09skiCDv8j56eJD5sDpmviyfSjX9
	Y3TCpOa0MtCD4a8mEBKFxJL4/Rh7yqedyxdbsXvCLoLkFOz1+Uybpr1z30/qqH
X-Google-Smtp-Source: AGHT+IFKJaTtC9zCfdLPrA3hvo79F+NULRYtfo+FtftQtUeBbic4NhbpYkunPMPqUPr0gprg742Y4w==
X-Received: by 2002:a05:701b:2902:b0:119:e569:f60a with SMTP id a92af1059eb24-11f349a19f2mr88383c88.3.1765492724488;
        Thu, 11 Dec 2025 14:38:44 -0800 (PST)
Received: from [172.20.4.188] (221x255x142x61.ap221.ftth.ucom.ne.jp. [221.255.142.61])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11f2e2b4867sm11509336c88.6.2025.12.11.14.38.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Dec 2025 14:38:43 -0800 (PST)
Message-ID: <b78bae2c-2b09-421c-a8e1-8ad3fff21045@kernel.dk>
Date: Thu, 11 Dec 2025 15:38:38 -0700
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
Subject: [GIT PULL] io_uring fix for 6.19-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Single fix for io_uring headed to stable, fixing an issue introduced
with the min_wait support earlier this year, where SQPOLL didn't get
correctly woken if an event arrived once the event waiting has finished
the min_wait portion.

As we already have regression tests for this added and people reporting
new failures there, let's get this one flushed out so it can bubble back
down to stable as well.

Please pull!


The following changes since commit 55d57b3bcc7efcab812a8179e2dc17d781302997:

  io_uring/poll: unify poll waitqueue entry and list removal (2025-12-05 10:23:28 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.19-20251211

for you to fetch changes up to e15cb2200b934e507273510ba6bc747d5cde24a3:

  io_uring: fix min_wait wakeups for SQPOLL (2025-12-09 16:54:12 -0700)

----------------------------------------------------------------
io_uring-6.19-20251211

----------------------------------------------------------------
Jens Axboe (1):
      io_uring: fix min_wait wakeups for SQPOLL

 io_uring/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

-- 
Jens Axboe


