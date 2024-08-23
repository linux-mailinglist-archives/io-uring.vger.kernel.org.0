Return-Path: <io-uring+bounces-2923-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4239095D11A
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 17:12:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2A90289E13
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 15:12:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A67518951C;
	Fri, 23 Aug 2024 15:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wEQn3yMN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABCC188A22
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 15:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724425906; cv=none; b=s7emULw2aZJFu+JGcsyfyAD7uC6l2MK0imVGf7deDYPWYYYMqQAnY6rJg9eIrqI7QczoqU1Pc8IDhdnG8cMWIFdfTt5BMdKKfQoYRJp7h8802FsR87qvXXg3ENyF0UbTmoStscs1V8mhQLmYwGEp2fPLjiRYpzx0dfQEIFR+SJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724425906; c=relaxed/simple;
	bh=h+6nKVpBc+Bk2L/dR3ONjR5umF7ts3gpGWtlJc4t9cM=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Ou8O69Sz2+nkn4BsDr3YFVmIRSnzrpciTlTpSkIJTd4IJt/KQuuxQHMXbClSMFHNdZ4rpIzUZ9p3D0vJ6zY9fco1qbY4Qfx+4rDNOSKZ8jasWYpoLBTVITFf9obJdD3a87mXCsipSF3EUQbyB6EdYjHDeuc6atzbyQ8IZUFqdEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wEQn3yMN; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-81f94ce22f2so81236239f.1
        for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 08:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724425902; x=1725030702; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i7SF0+vN7JUXO63qIMjxRtNZPwMttnmHz7k/vsNZCRg=;
        b=wEQn3yMNwx7dMfCuKZKH60pwSPvSpJdM/eZJtQDV88pc3rJxwac43JZQTKyvecItZc
         ezzTxix8gZdb/wijW72HR4rP39FU4JdQfpaDBBk0oKtvCCgO9b1B3LUXlmYRgnO7dL+I
         612+ByNEK1x5MKg1aWCOha0EQairfqnN19sTiTIT714Na1FRcyTxjG+EQA0ZQq2S4HKR
         +B2XV/ysZoNAeVaqQS6H0h6ml04EXlFQXAmj3b4gg6o4HxxM0k9Y04Oc1nk/vGcJoTPE
         qzg0tMTGxCLe4bEIq8NNjiUJue0wgZlZYHQh2hvab90I8t0WL2UzsK/n9qqPkowSaNEp
         f9Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724425902; x=1725030702;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=i7SF0+vN7JUXO63qIMjxRtNZPwMttnmHz7k/vsNZCRg=;
        b=sX9Eo/2l75yl3R0bzHDpChjn1b+yu5m1rjCwZVWDOEg5XLevj1k/+y2PZuXbOwW83Q
         3ussYUiarB1K+YwuBCLOBZFBOzt94msGyCdp6jQ9tV3JnJ4yxc4NtCFRS4DWFcrj+AHJ
         mDm9Uok2bhg2TaZMNx3BXyoyniXUVVJbVkkorBHqbmSlvrJaV2j8ShtbXql8hR3HC2eP
         ltafplcjdgffLSv7cQYj63CncWJ7b8xm7UhM53DyIXVyud0C+f44/Z6sW5XKaOpDgwXK
         MAkE3M8zaOU9vjHWzr55ORZmYRUN0xDpAjd7bJGV4zZaONNmFhWsdANVxeHGzipLQTeP
         7Iaw==
X-Gm-Message-State: AOJu0YzITEGNJBU3cP9eq9fnSiIstdxehfJ/VEqTsIkJ5FEu7s6saNKU
	7JSdBsQ4rbLU0fR9e1MYIPwdUNSgUsVGjfMFuDK3lehQ0ng5Nv3UPFRaaLy2vF78iKMZeXMzAbO
	t
X-Google-Smtp-Source: AGHT+IE1qsS3Ia8MiHXj16RHAEbnHLarow39bhOA6qimmMGtdKatvIvseyiqL7TjR9vLnc6qr4w1Zg==
X-Received: by 2002:a05:6602:2ccd:b0:825:1f11:5996 with SMTP id ca18e2360f4ac-82787360727mr255521239f.13.1724425901774;
        Fri, 23 Aug 2024 08:11:41 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ce70f5caccsm970873173.67.2024.08.23.08.11.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Aug 2024 08:11:41 -0700 (PDT)
Message-ID: <e1c82466-845e-4a68-888e-43f6916ed5e2@kernel.dk>
Date: Fri, 23 Aug 2024 09:11:40 -0600
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
Subject: [GIT PULL] io_uring fix for 6.11-rc5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Just a single fix for provided buffer validation. Please pull!


The following changes since commit 1fc2ac428ef7d2ab9e8e19efe7ec3e58aea51bf3:

  io_uring: fix user_data field name in comment (2024-08-16 12:31:26 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.11-20240823

for you to fetch changes up to e0ee967630c8ee67bb47a5b38d235cd5a8789c48:

  io_uring/kbuf: sanitize peek buffer setup (2024-08-21 07:16:38 -0600)

----------------------------------------------------------------
io_uring-6.11-20240823

----------------------------------------------------------------
Jens Axboe (1):
      io_uring/kbuf: sanitize peek buffer setup

 io_uring/kbuf.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

-- 
Jens Axboe


