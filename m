Return-Path: <io-uring+bounces-2539-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13072939041
	for <lists+io-uring@lfdr.de>; Mon, 22 Jul 2024 15:59:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4497A1C20D4B
	for <lists+io-uring@lfdr.de>; Mon, 22 Jul 2024 13:59:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8AA716D9C8;
	Mon, 22 Jul 2024 13:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sCcf8o1f"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D90A16D9C1
	for <io-uring@vger.kernel.org>; Mon, 22 Jul 2024 13:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721656793; cv=none; b=Upu3h8PdiciZkWagHit6C+mvDdcBPsr3bRmIpmCPvAA8sHqMKCX0kJBFuxWwgxQ9azpodXE0SEYuEB8uw7Y5GKApNXil24/iEgp5U+4SefMq8Z0OoJJBLwnst+3XybbyqPxuCh/LHZxrONne1X87UuYkZumSg6bG++0NJ+wATq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721656793; c=relaxed/simple;
	bh=pVM2BhILsrOqIiPDRrMSMwIds9UFmBPya8YmYf0Wevo=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=JoJFjbBF/77D5PsrKYtJbhVzbvwOaoOaG7l24JoU2JLD8qr929m6TiZ6YNUWkm7G/4UTmtqsX6nomYhzszkx1T4fywlj4oqegmKJoMiRQkAEcwWDd24jeqozhObEEefgGQCBa00trLC0g4W/O5kDcP22bGRuwE4+OZdyqlLhiL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sCcf8o1f; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1fc47aef524so2553755ad.3
        for <io-uring@vger.kernel.org>; Mon, 22 Jul 2024 06:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1721656790; x=1722261590; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5TKSVRTNXnAaGme59NWwS1rMpmk6qZnE5IDEN7WT3P8=;
        b=sCcf8o1fBsLAiOhPkIYGSbuGPGLazJ80VOd+sJNRFX+Hd5o3M8VB/NUCXOsbK2crjB
         HNSrCCfvSWf9lGy0YQIz0LsR9Hpn8zHXzx8ZvY3YYceSEr21YtpQMvYFbNbFdhbzuLVi
         AsOhvdPvJ0b2aq9ObUzwcg0Zgzl9FSZKMIE3fXFxZaY6+7KHAnS/opvyJYlLI29l5nmS
         +KIcKMrhk8L4jirUwZqVOrSV87g713YMtO/e4KBtB9+z63K7+zWITqcUxHVHMPHg36TR
         nLnLlvGaBta7/1K5eNPB1Be0gU+7ZG6/IxJCgyVDXLi0APlXXYmfsgRQqnka6aTdY2oA
         BN3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721656790; x=1722261590;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5TKSVRTNXnAaGme59NWwS1rMpmk6qZnE5IDEN7WT3P8=;
        b=vhUIaKjGR5T3fxW9b1/pHF7VszgcO+6FeW09uA6bsKnYgo3z4EoDQCSc0zqn8fcvGj
         1Sar01KHlo5kSkYp4+N9JncZFUn/QE7WQEL6UuBzJKa9NANTl7wclnc2lcJgwYY6eTRt
         /1hNa5ohAdhsNs6Ki7WhqeuMpVo2B+l5eSxGh08m836wIELrusQxGpDzuv3dhWznxgvj
         0gFMYqhBtZie8jJ+SF43FQ6zfrDRavrHgvRLWWMceT8PqtypLGF+s0UECuNZ6LiOBKwN
         u4l8TqOvzHF4K+UEasf08ED3WeG5ChJ1Lg09XC8UxaFxp5Z++JR+fOQ9OJ1Z9RJLVP5f
         Pmuw==
X-Gm-Message-State: AOJu0YxrKGdVatpf/WVzMfIM83QuCFkGfHB2q6y3xif82BYMABt0DZrO
	R2OY8t/1GZSo22JCRsBLyzh1OE1+6Qr1ZW3IHD595nAaIDUYgplgoa3PPis98qoszNNEHDrxFRI
	qjpY=
X-Google-Smtp-Source: AGHT+IHa/lcQdoTtSxdnQpKMsElZHUzE3pet6Vt9OJ/V599qOqJc+SqZMgTLGp/v2niM6yOjYhrIbQ==
X-Received: by 2002:a17:902:ec81:b0:1fc:4377:afa4 with SMTP id d9443c01a7336-1fd7467f3damr59240415ad.8.1721656790443;
        Mon, 22 Jul 2024 06:59:50 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f28ce51sm55128385ad.87.2024.07.22.06.59.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jul 2024 06:59:50 -0700 (PDT)
Message-ID: <3b4379ca-3504-4afd-aa51-a00f1d6022e7@kernel.dk>
Date: Mon, 22 Jul 2024 07:59:49 -0600
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
Subject: [GIT PULL] io_uring fixes for 6.11-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Two minor fixes in here, both heading to stable. In detail:

- Fix error where forced async uring_cmd getsockopt returns the wrong
  value on execution, leading to it never being completed (Pavel)

- Fix io_alloc_pbuf_ring() using a NULL check rather than IS_ERR (Pavel)

Please pull!


The following changes since commit f557af081de6b45a25e27d633b4d8d2dbc2f428e:

  Merge tag 'riscv-for-linus-6.11-mw1' of git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux (2024-07-20 09:11:27 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.11-20240722

for you to fetch changes up to bcc87d978b834c298bbdd9c52454c5d0a946e97e:

  io_uring: fix error pbuf checking (2024-07-20 11:04:57 -0600)

----------------------------------------------------------------
io_uring-6.11-20240722

----------------------------------------------------------------
Pavel Begunkov (2):
      io_uring: fix lost getsockopt completions
      io_uring: fix error pbuf checking

 io_uring/kbuf.c      | 4 +++-
 io_uring/uring_cmd.c | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

-- 
Jens Axboe


