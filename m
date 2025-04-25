Return-Path: <io-uring+bounces-7726-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D15AA9CE81
	for <lists+io-uring@lfdr.de>; Fri, 25 Apr 2025 18:46:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24BE817DBA4
	for <lists+io-uring@lfdr.de>; Fri, 25 Apr 2025 16:46:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC8331C84C0;
	Fri, 25 Apr 2025 16:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rqAvU4zM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122F41B4156
	for <io-uring@vger.kernel.org>; Fri, 25 Apr 2025 16:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745599553; cv=none; b=pEr0nSpGKp/S5T+mgE9/avYrtidpVZlKNbXjDjNLI8dLmVvhRZ6r79CR6Iwy5Vq2RUXtoQZNZJj6g8KNDSbyaZ/L/0odh6AAHxkcYm2QSxfGiZgg7sQCxP7YLHETktnypi0c5i6kk2bFLks3IegsMqUPlB/q9k9SkJ2pNKkYouQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745599553; c=relaxed/simple;
	bh=mAMCCEsafKXYZcJ6bRI9wygLPljkf3RJAreRSHREd9A=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=SsaLuu1OKgRDmccTUt9YLY2kYGLV/5iwxW/fqyobDFLcrjlI3q8qXlQFy+suO6RUmpRAtyqUvlE0NjhgKwADv/5+xqvLB5yDHijfLhq/f7MiWwGwiEYO4OKntx0j0aqiBPKMO/pg3ukdITFuiJ/rLRZ8GJWQqOGr0zW/ILh1j7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rqAvU4zM; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-85de3e8d0adso45745239f.1
        for <io-uring@vger.kernel.org>; Fri, 25 Apr 2025 09:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745599549; x=1746204349; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SrOSRJ5dmNb9AG7YZs8lyf14tHmWRyWCVBt5ciLvhdI=;
        b=rqAvU4zMcw0oFWLvDcJCN55PLA1thPDrX42i2abGmkBF+Yjz2pDnei0fnJSfPkFRoP
         uqdaLOSab4y5/UM2qFHSme8Zzy9fnZLW6SaK/czCZvo8PRlOrmEz19MbHskcz+vzz9OA
         hQq0FihH7EvfYzr5YTw61dEcODmrJM1PAJWRiA8wono1Rn5i50RwTVwt2r/9vN/mG6RE
         4f2ntA9sKpjoIc18SM4M2vYAt68C7o1xkP729I4Mv2h0gRP1y5wfyGeM9ENsDERI3IPR
         ytHu/tBdkQ0PEtZbLWzKISob2zTvTQoK11uL6FN4SIgtXb0KlUm+aQWH4f8BkSQkfDqY
         udsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745599549; x=1746204349;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SrOSRJ5dmNb9AG7YZs8lyf14tHmWRyWCVBt5ciLvhdI=;
        b=jccGdGANg0XStjtf28YDRVx9lJIeXTwIjqrAAdufj24q2YrjqIF8k20/QGtYwFm0It
         xnMNkVq+yNpMrMDxIeAIL3RSo+fa124ixHK5CRMV2E+VTb8D3lNzbFCUsJfTn02Fra84
         dAw3iS4oNTwwlhceU7RJOgH1s5itA3ibEcObGn/CJwDpcxgL59F/mhdq4ftg4vSsS39b
         0vHW7dVfOatEXuoswjj0dPzWhMrX7wpQnWmaapegq4iujxcaXWRm1Po2SLDqq1hdtv9v
         p1X09qr2hdTreEtStjL3y+h+ud5pYlZdE56QNMmtfQSB9NfqxqH0PQf7DL9OJHwYP3Yu
         WRbQ==
X-Gm-Message-State: AOJu0YyJhNoooikC1WXhQB67ix7PunzICtmXxhQZmgwnAaFEMrVQQQNz
	Uo0wIEs+pa/JZwhMWqv1exVqbpWX6Bk+UbBQ6LA8dDXieGxEbdV86jx50ACozxO3FpXAmx7sH4b
	D
X-Gm-Gg: ASbGnctVxF6i1+1ZcyxTFVO6CicAl/MDSru1/AfpPNIAcan3hpGy97B1MH0Rj8SI284
	W+AzHSHlVqCuwfk8IvKB7/3/wgqdk4YR1P/5Wj0tH13sm4LqYxw/CJ74qJ3W0DELdbf/aw3mWOw
	Sj1O2muETEmZGfyIMn0U0eUM77TTGju+AnjkIS3lmFuskXpg9lyp3II3LFeEB6AH4NZfNfG7ulD
	fBkmmE96A+xQ3Z6+HxT4srMg+9Eb071dCeAhFDlY8LdDC9cXW7YlhpLUep15XIS85JTGPFrJBZY
	mZHx8FY=
X-Google-Smtp-Source: AGHT+IH2yViPvYvSpFDl9xrJQ3V0UjGs1bfQcbSB6n2svEZyO4mIvRZoetCcjgsiyyVcUIAIP2A60Q==
X-Received: by 2002:a05:6602:60c8:b0:85b:3885:159e with SMTP id ca18e2360f4ac-86467a628a9mr14598239f.3.1745599548660;
        Fri, 25 Apr 2025 09:45:48 -0700 (PDT)
Received: from [172.19.0.90] ([99.196.129.216])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-864518de4e9sm63148539f.16.2025.04.25.09.45.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Apr 2025 09:45:47 -0700 (PDT)
Message-ID: <e393e036-2d3a-4636-834a-094f8364ec94@kernel.dk>
Date: Fri, 25 Apr 2025 10:45:39 -0600
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
Subject: [GIT PULL] io_uring fixes for 6.15-rc4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Just two small fixes for the 6.15 kernel release:

- Fix an older bug for handling of fallback task_work, when the task is
  exiting. Found by code inspection while reworking cancelation.

- Fix duplicate flushing in one of the CQE posting helpers.

Please pull!


The following changes since commit f12ecf5e1c5eca48b8652e893afcdb730384a6aa:

  io_uring/zcrx: fix late dma unmap for a dead dev (2025-04-18 06:12:10 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.15-20250424

for you to fetch changes up to edd43f4d6f50ec3de55a0c9e9df6348d1da51965:

  io_uring: fix 'sync' handling of io_fallback_tw() (2025-04-24 10:32:43 -0600)

----------------------------------------------------------------
io_uring-6.15-20250424

----------------------------------------------------------------
Jens Axboe (1):
      io_uring: fix 'sync' handling of io_fallback_tw()

Pavel Begunkov (1):
      io_uring: don't duplicate flushing in io_req_post_cqe

 io_uring/io_uring.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

-- 
Jens Axboe


