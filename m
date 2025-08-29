Return-Path: <io-uring+bounces-9443-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 70475B3B084
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 03:28:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AD17A019AA
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 01:28:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD2DF1F30A9;
	Fri, 29 Aug 2025 01:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tOaDuUFL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA701F09B6
	for <io-uring@vger.kernel.org>; Fri, 29 Aug 2025 01:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756430870; cv=none; b=g8U3gGnD79n9tAJoX2+GviecFbH2CNdGm7JL7ako/Kgs63Eveeft5XgNHtca0+5E3UCAyj1p/ajxIpINhl5TPO3/lYcoK9u6v52dZiD5fgO909ySG25G6ZZsmIBSUyGG1LlDCx6g2DN/Bz8LHQw/V2ySg4ckq0opa0DbkGfqpKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756430870; c=relaxed/simple;
	bh=JQwoAepCKnoRJw1Rg7SX16QEPPC8X7vHCTgi0TLeZxw=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=B5rhkykFxTU3tomXZpOzOZ0bc2BA6fbm/KZ1O7cWA1W8trkSMX3lwdDl6JLpsXbplgcM0P7R8lnoZzUJ31TPKotadKL3+16IB5WaRtnq9s69QEhau4KBkSX3Pp2G1V4fdSeDB4Ejg28cfff3Z0tMldGiMamcpESn1nra9iQNqxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tOaDuUFL; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-248df8d82e2so9539665ad.3
        for <io-uring@vger.kernel.org>; Thu, 28 Aug 2025 18:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1756430868; x=1757035668; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e7RQ3fs2USAU2m95fFP5Q/JucUux61u7xCGtnaoXuCI=;
        b=tOaDuUFLszLci8T4aZEa8OjUTKHniMBCC8dwfcSn7nEeoW4E9xkEXzLarnZvCi8Fn3
         yETMgKYWq8dBZbB3q+W5F0z9DSgLUbaSAtuwPjM0NJKAh8UVN+IMhl3LrymLaMz6oArP
         /i2reLxfbfNa3APByp1E947VGx+aVylVHagUdrjDeydUWG/dsA8Qh+ArIdbNQzR/flbe
         /AKJfDdZet/XElcbBk0VwXUxu4y3iMnsAZT14pZNA/i9IImPltFyuGKMnbiCF3DfvUqW
         7SFuGGc20S83xYvrcdfq7gWw4MVwaZrZ2EgbTIPO9JOS0knW7p52jxfQOrcyFPL5K96e
         RkCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756430868; x=1757035668;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=e7RQ3fs2USAU2m95fFP5Q/JucUux61u7xCGtnaoXuCI=;
        b=oeuqHQGI/0fz4TiOSpH0tNYrgIXNvRZU0CE5RVzFAAaSmMZFucXW3MRFlADqHwTLbp
         dUGHP7hdgCbxmQGnB6n7FWZ/GLTWH6VJDTNaFw11LcQrL0BV10xAFRsGrS8N01a97wRF
         c8sAWRVk7vRiqnzQ1DqzToybzvwwiuc1Co6ukLWMVWmqvQXbmR5p05eNxMFRH8ADW2Fp
         yBYDQOWTBLSaaUQ/cUEoI0vgj1KzPZ9f9AZx4mSsLcJUS1WCl78sXlmwqboFEv4qdlK3
         Ol31gAcfOggbALu1mr2m2jXXNQnejUqayUHelwuMiQO1+h+Po8wZC+pRleMq+fZdooOg
         dOxg==
X-Gm-Message-State: AOJu0YxnCdwSP4IokxH3N7L1v595idvQsgu2xwaJoctl/hKc/q24PKkJ
	DsZmQHgk70qsOF+qnY0zy1OUuA7rdQuM7wKV68kblHzFzCIrtebkTAfbaMw81OShyshGQuqdiTv
	qwaF5
X-Gm-Gg: ASbGncvEkclG2Kewd16mSU8G1Xnjrr/N6c99FEHQQdHkaxnfieKgvKJoSXLdjDHlvJc
	aH4X75Zm71KTJ2gLNasaHBElZqXKcnv4RqxUql0Fhw5G1QkUtyDggZiVdvF63KwF40bMX22ZgET
	gD16dDu7aSyokf31MBBGukrY0H+2FeZVDw92gBAjTZnvQLNLYiaLWSEQMGUmcWIFxPXZXFhEI5S
	3p6f5hjNmCMEbmOB0OgHhGtKbDhykTiUTdNotM2Bh8y/5/wTbee3uHDYkKJoQt1Fk+ufXZrcxyZ
	LqMZuzXBLFXsr+As8So7RJFTfnPM1QO0w7qbqnd470i31nTcz5YkazToAXRFVhsnuzFv5tsq1Kn
	nA+GD0trnblF772evLUu9PAv5a595lSY=
X-Google-Smtp-Source: AGHT+IGE7rebo7D48kxPYvuplU3AS0UR+z+XEFvi+TxAmqLfiUA86w+zodpMREPOqS4gLRzxnpsfPw==
X-Received: by 2002:a17:902:ea0b:b0:249:c66:199e with SMTP id d9443c01a7336-2490c661b1emr12427285ad.26.1756430868501;
        Thu, 28 Aug 2025 18:27:48 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24903704060sm8228165ad.20.2025.08.28.18.27.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 18:27:47 -0700 (PDT)
Message-ID: <6a3bb8be-140e-4ec4-b903-683c43115992@kernel.dk>
Date: Thu, 28 Aug 2025 19:27:47 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.17-rc4
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Two fixes for the ring provided buffers in this pull request:

- Use the proper type for min_t() in getting the min of the leftover
  bytes and the buffer length.

- As good practice, use READ_ONCE() consistently for reading ring
  provided buffer lengths. Additionally, stop looping for incremental
  commits if a zero sized buffer is hit, as no further progress can be
  made at that point.

Please pull!


The following changes since commit e4e6aaea46b7be818eba0510ba68d30df8689ea3:

  io_uring: clear ->async_data as part of normal init (2025-08-21 13:54:01 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.17-20250828

for you to fetch changes up to 98b6fa62c84f2e129161e976a5b9b3cb4ccd117b:

  io_uring/kbuf: always use READ_ONCE() to read ring provided buffer lengths (2025-08-28 05:48:34 -0600)

----------------------------------------------------------------
io_uring-6.17-20250828

----------------------------------------------------------------
Jens Axboe (1):
      io_uring/kbuf: always use READ_ONCE() to read ring provided buffer lengths

Qingyue Zhang (1):
      io_uring/kbuf: fix signedness in this_len calculation

 io_uring/kbuf.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

-- 
Jens Axboe


