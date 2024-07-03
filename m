Return-Path: <io-uring+bounces-2424-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32E0C92622F
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 15:50:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E38B9286B78
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 13:50:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1F50178CF5;
	Wed,  3 Jul 2024 13:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="f2VRyKtO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58C017084B
	for <io-uring@vger.kernel.org>; Wed,  3 Jul 2024 13:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720014600; cv=none; b=pdQDTXSjI7Fcl4KBNkCpoRQMdTkxcnrrQlxPEuAnKAAxJpC4vQq1YsSuaPumaCa2TK/tDW8av/q/cUmwSNxecVYWXd8XL3SkUs9+zElma4DSrVyrw0hbja36q/VeqgaE2vdRdWA1gfoHqkizJ6ruhcyrWJk+Hgpvi6jK4XW7iJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720014600; c=relaxed/simple;
	bh=83W1MPFW9svI5Tw/mlA54dNBKL+nuveKQSMdeBwdLS4=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=j1QGCttUCvVu339sWjIm2XTDomLGSTtWUJmagKkHnVtS5s4ahgzT/m6Da9MqRTNrK5qfR1g9cWpdUghCGrUT3RfBDl4ELMHYdyA6Eo0lvEwt+YEUTXVQWTQgg5pP+o8ktg3IuRupAZF8DwS0RPg39MGenuxXIOg8SfqBO5q4p88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=f2VRyKtO; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-6c53be088b1so295817a12.1
        for <io-uring@vger.kernel.org>; Wed, 03 Jul 2024 06:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1720014597; x=1720619397; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WDPdmxgtCDuoTbh1YHOgCC+X68jB8MtTBhWULh1JCuU=;
        b=f2VRyKtOYQ7YjrWlY2bhi48Vx08O48SOV2sgdhiXf1iz1Ayc+7bw1TQsV0laVd2YXb
         2mJjWw34+u73VWsogdi83C79tRRrs7XE4cjcwV6FXG7b1RF0pZylJBk37eppMLqip+es
         wXhgjRFoRoQbUYctnCoyT2Swp4FxT2Cz16+LfEU0rHdbjUO/X070fyRF4SXzvNDC3k7p
         PcBDdLAz9//X7C07OGXHmMxVFgMTrmdXgqcJq24LP45aG8LehddFSEXF88OVnXzxV7Et
         HXu28psahqs/nka6cfie5VegV5Q3eF9ynQGfGqXMdMtAL5ISSvvLyjR1AuDx9/wW2Cdu
         pFBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720014597; x=1720619397;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WDPdmxgtCDuoTbh1YHOgCC+X68jB8MtTBhWULh1JCuU=;
        b=PkSRz3uVMtdF0+h/P8pThYVFYvC9fi5YRNJ7U6etg5ptKF37XQCrGOk+GJGahx2mxs
         JoTTQfLsrq8dRV2TnRsqXBD5Ld0hR3RL6oB4y9zt5kcxEMsRsC7vUTiduf1v51ioDwWb
         efR2QJQSgratrYki+oo2j44PpruSgrIjIn7/8MQm7xtxuNor3PxJW0qa1omkjgNqstSp
         Ap/OvOZeDcz9bEtZg90mTt3gOCNkGMamy+6HQHYQSlY2nxgYKyZKwd6MhwPUy8CK/oax
         olAp87A5grysZFFNj6wNwy5/Rn8XF065XLq5vulTWlYOF2Oc6Ap/7Azx+FqaLnMaP9cp
         uzNQ==
X-Gm-Message-State: AOJu0Yy2Q8kDyUaVdOH5ZHnmDha2v5b2E5NKBwPMZWPJyq+pZsszZzux
	p8xzV44Ocm0I7DmgAiMOUjkIX9vjbOo73Tzr/KZqjuScKjo8rhOuTX/cKsNQWINjA/6j83cY7aQ
	5hZw=
X-Google-Smtp-Source: AGHT+IGloC3Zq900xWxBIPZzVOfuC0zAwa+lNOj5qXtvwONBepyAt7h7BXzfz1maBv4TQI8OtpGjQQ==
X-Received: by 2002:a05:6a20:6a0e:b0:1bc:e9ce:d8bc with SMTP id adf61e73a8af0-1bef62a4583mr14969407637.6.1720014596499;
        Wed, 03 Jul 2024 06:49:56 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fac1535cb2sm103082795ad.128.2024.07.03.06.49.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jul 2024 06:49:55 -0700 (PDT)
Message-ID: <d55b363d-2bd4-48c9-b2e5-92fbae147cb7@kernel.dk>
Date: Wed, 3 Jul 2024 07:49:54 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 6.10-rc7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Sending this out a bit early, as I'm heading on vacation shortly.

A fix for a feature that went into the 6.10 merge window actually ended
up causing a regression in building bundles for receives. Fix that up by
ensuring we don't overwrite msg_inq before we use it in the loop.

Please pull!


The following changes since commit dbcabac138fdfc730ba458ed2199ff1f29a271fc:

  io_uring: signal SQPOLL task_work with TWA_SIGNAL_NO_IPI (2024-06-24 19:46:15 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.10-20240703

for you to fetch changes up to 6e92c646f5a4230d939a0882f879fc50dfa116c5:

  io_uring/net: don't clear msg_inq before io_recv_buf_select() needs it (2024-07-02 09:42:10 -0600)

----------------------------------------------------------------
io_uring-6.10-20240703

----------------------------------------------------------------
Jens Axboe (1):
      io_uring/net: don't clear msg_inq before io_recv_buf_select() needs it

 io_uring/net.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

-- 
Jens Axboe


