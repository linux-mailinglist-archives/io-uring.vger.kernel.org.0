Return-Path: <io-uring+bounces-4322-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AF2D9B9720
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 19:10:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8615BB214DE
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 18:10:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AE72146A6B;
	Fri,  1 Nov 2024 18:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sN/4CUkl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD6513B7A3
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 18:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730484618; cv=none; b=kbme7gko+Jxxpeo7T8zHiekqcR93LC0FmeG6jA3fMjpN19mm/2hOpeS9BrK6BO24UWXKZ8CbICBEjJ+wEdQfvhvilsWRtSqeeu+zrliNsqLbgSsGchyZBpjiBi2IMpGccrMB2FtRLWq+HpIjr4Y9EuO76WGsH4hJqmrLujz0Kz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730484618; c=relaxed/simple;
	bh=MQ3MiRfGvbg5YWfogrz/cd0GUG+SqIZHB6B7ZBFMlUs=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=cJ0/LWACrFE9THiIz4KcLsXv669t/JhLeSrNSYmseWlR1QGD/n28Bb6BGeGN78c3OXF8ARI3CLo4Ym7IBGhcCEMppYKVy0MS7mfqEmQQG5H0dtDcvePOjH8NwNapvvhgxD4M9zuI2EWHKVX0Ah/npkJDgutvMx06f81ZkeE3kCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sN/4CUkl; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-207115e3056so22217995ad.2
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 11:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730484616; x=1731089416; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x/v8GC3p1BgR/bTBZp3ObLwYzKRMTH8FKuOnH87JAf4=;
        b=sN/4CUklSM8sQwLl53VtdaLfFtHgKnTCO7e/GKHF+afzDssi7UeaX6AbmuS+Mo+MNn
         VzTkPcKN5jIcTgqHfRc3S9GWepxJL6fNlCJrPF0DNghQDBwt9k1HMB4I3C49n2V/eA2+
         MkUIPXUIjWktMe1j3fsqkmO+wbzDdeF5fURBU+NWFNi5zVCeuXhNZpdjzBRLdi5Vj+RO
         jMvubxid71+czZU48/qeDQoGrkAfrSDLc/a2mTGDlVPf2clnYm5mckb6bUs+rP2vO8/M
         ZYvzt9WxLURKdZe4Chb5vNjH+uOmA7T2GSRDwbBIZJvLj0RxScsMT6Ry3L+hu1zj49Sb
         Guig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730484616; x=1731089416;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=x/v8GC3p1BgR/bTBZp3ObLwYzKRMTH8FKuOnH87JAf4=;
        b=Wy6rAPixVtF/1sw5bfG7Cd2+al9gn8uQvJznzQNbqg44fwaTChJlv4cEQB3xMEmjG/
         qBLI4/psnwMRTkWQP7SK6CYNfdzAmksX/BbPrNzbuEUatDzvNziA5/PB6XxKzblJe3YP
         K3zLExw0E0fXGzPqz+HlC1uNTwcHCzc5TOTU91AyHPkWYzOGBbaDEwydMIoUIlJynEzK
         G3d20N/GHpKHinOL2cngzQJHcpRtzxc5Cf5U4JFhD8JykfH1e0xbZH+Dn4T/eDt39vGm
         7ued2Z4ZMfZARATz2hmjq78pjWYsAz+bCgZQOrIqjFVl6+oPZ6AfZ8FXUHudq9OICtb5
         YmWA==
X-Gm-Message-State: AOJu0YwlZEMf95LuHR4Ho3i+z/nlgJs1dPq1yPRxk50ZmsEXLqqGbLD6
	p4+g4PAQjXByR/3bc4ZuAY5k1D7A2Fw/7L+xCTTj7EDh0lRo3DDKkI+loHkIuYObPbnZpSiprxx
	LD/E=
X-Google-Smtp-Source: AGHT+IG1vphsb6DzwAjSExI3a5hV/uMk31N++OlnuqF9ZHLQEr1k2wjqsccPVW1tls4VFfuyTD3bZQ==
X-Received: by 2002:a17:902:ecc3:b0:20c:f292:3a21 with SMTP id d9443c01a7336-210c6892a36mr332484015ad.15.1730484615725;
        Fri, 01 Nov 2024 11:10:15 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e93db18128sm2960192a91.36.2024.11.01.11.10.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2024 11:10:15 -0700 (PDT)
Message-ID: <8a3c26ea-bebb-401c-9fa3-e900aacfa77d@kernel.dk>
Date: Fri, 1 Nov 2024 12:10:14 -0600
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
Subject: [GIT PULL] io_uring fix for 6.12-rc6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Just a single fix for a report that came in this week.

- Fix not honoring IOCB_NOWAIT for starting buffered writes in terms of
  calling sb_start_write(), leading to a deadlock if someone is
  attempting to freeze the file system with writes in progress, as each
  side will end up waiting for the other to make progress.

Please pull!

The following changes since commit ae6a888a4357131c01d85f4c91fb32552dd0bf70:

  io_uring/rw: fix wrong NOWAIT check in io_rw_init_file() (2024-10-19 09:25:45 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.12-20241101

for you to fetch changes up to 1d60d74e852647255bd8e76f5a22dc42531e4389:

  io_uring/rw: fix missing NOWAIT check for O_DIRECT start write (2024-10-31 08:21:02 -0600)

----------------------------------------------------------------
io_uring-6.12-20241101

----------------------------------------------------------------
Jens Axboe (1):
      io_uring/rw: fix missing NOWAIT check for O_DIRECT start write

 io_uring/rw.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

-- 
Jens Axboe


