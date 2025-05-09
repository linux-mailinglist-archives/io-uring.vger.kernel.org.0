Return-Path: <io-uring+bounces-7937-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 20265AB1888
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 17:32:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CDF001BC47D7
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 15:32:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D032A22CBE9;
	Fri,  9 May 2025 15:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Mq4/YjiC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486881F03D5
	for <io-uring@vger.kernel.org>; Fri,  9 May 2025 15:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746804729; cv=none; b=WYOaDwwOXiZyKPDQ9Wf2KQyxhtomO1JUnYjhdjI2ZgCxgJd5AIC28w8VMTWko/pnaLTPvQdJTZD2fuLp1G19/lRnN+y7f2WG1TTOeEMSeTE52UcekCs+S2x2bgD/U3DabvZTP3zMIeuyY50MfEsxwLrpqHipaReXwgprAIrmZ00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746804729; c=relaxed/simple;
	bh=Kfz5ZRglYz6ds2VsHIHoJw04mZs37/oKD4OYX36Hp48=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Vmjv9jNxoMPoQUpYwIbOn+vC2RyhG52USOlLcrzHoKB9xBoCma5dju3giyQQ4KQWOe4s+Dc7rsUQA9Hzjf8lq5TrQIEuml6PIzeYqrmhN6Y5YLjc+i7hYTF2tZ3Z9JDn78G0YqeAqdDBeoWoxD5mTBUWyKEVC1L3QEEL/mw1kv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Mq4/YjiC; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-86135ad7b4cso95691739f.1
        for <io-uring@vger.kernel.org>; Fri, 09 May 2025 08:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746804724; x=1747409524; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tiMJrHnKON1Nwem5qFohdAsQFnucjVQtdQK9a7Tld0Y=;
        b=Mq4/YjiCJtqnStdW2MCgi8pLLDripCaoQMcDIWJpk88H+MX6u2a/P6hTE9di0/qJJd
         czp4LKSHmp4pZY9F9JUgnDWMuv5uwTI3LjKuYUjPsR3s4D2O+mmw6lbW7HpFY1TY/k0u
         tlE4xRBI1yqJCBXmduA/W+wAq4EFUvaW3aPSaaA26IuDn/V7+pnx2WvITp2LkOZaqssX
         khCea0ZkNcLq8CkEi4ofpUpySSbS9/pQlZvRmWBwxRFighMjW2ikK6ARblVGXSa7E9qh
         sOGoJGMryj3SASYEaOCuQeHNLCa+yvhsFwedmeqJzEKoCBCWOhMDbf34F1LRN/4zasWq
         eFFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746804724; x=1747409524;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tiMJrHnKON1Nwem5qFohdAsQFnucjVQtdQK9a7Tld0Y=;
        b=UlbOT2vEpV0PktRAHtYjeTaC2tV82LKHzosTDKpHDTgSwo9tCaUa0hXiH/wx+Y3ILW
         55Cko1ssZfGqsuKqWHoqKbMKMIvWyt9mzX2Rr6T3pDerD3M0PGl+rkyrqwDlXBxU+1Uh
         hU+fufieUGyZtFFOBpbpHAC+f6FVL0qvOxs25Y9MF2b/m59cqUbu/wPPSM4d58xHfBha
         1zXdvifNeURai1nfq0UYg4/ZpHCekyQroLW008s58bnxNTlunWSREWCVxEI35Z23Ea4i
         ucPWjRnB73RuLAxzTSQLAlD7FXAdwL1RqSlCNgRiE9N0/p5KQm9ip/tPy/yx0IC6CGNc
         Nd9g==
X-Gm-Message-State: AOJu0YxrvNgihMlslEYgN9f1AFZ6OoJF28KbEKOVHAJWzhI07sbt4zma
	p4NWFXBHzLR/HH2OvB9i9nCdPOoycGVh8agRJWnUxTpwQeSRPoL2G525z7/NoCqAAy92d5MI/Kd
	F
X-Gm-Gg: ASbGncu4rgXGTpXnvHj992noU5hJStAzvwHARdHpAOWqngIPah/FYBhMtB9vFH8URGT
	A20/3diuUPIvXzVNwuedUUuE7WhKjIN3xgpoGIItlltUAus9DpXLI2Hbw7vlMNsqvQdqhxptUqa
	Y3Xdetun5LtEkMyvUdyVw5AGHGo/tBlV9Rx4/nrh4QxxjLiyuPFvHjb9ew2d43fN/x/L61Be59o
	O6XX0zzvqICW0NGad8tMItiqxDlM+qrpWFmGI0eiGS9nbnqZL72LEyu1vMv4d9MUsTVbknbc/D3
	cLX2+29ZnCCxqxpOPc/wk6A7+e4lfkFvBcq7
X-Google-Smtp-Source: AGHT+IHHGQCaBSaRL1+2cdsXax8lLO9jk+65v3lEaDVtjzBaI4Mjj1B6XSaybYUZB3A2DcnkbvtHxg==
X-Received: by 2002:a05:6602:15cc:b0:85b:3f8e:f186 with SMTP id ca18e2360f4ac-8676357736cmr577951439f.6.1746804724178;
        Fri, 09 May 2025 08:32:04 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fa226590f1sm446960173.123.2025.05.09.08.32.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 May 2025 08:32:03 -0700 (PDT)
Message-ID: <570b6c7d-e273-4ceb-80fb-ac00090b8f94@kernel.dk>
Date: Fri, 9 May 2025 09:32:02 -0600
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
Subject: [GIT PULL] io_uring fixes for 6.15-rc6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

A few io_uring fixes that should go into the 6.15 kernel release. This
pull request contains:

- Fix for linked timeouts arming and firing wrt prep and issue of the
  request being managed by the linked timeou.

- Fix for a CQE ordering issue between requests with multishot and using
  the same buffer group. This is a dumbed down version for this release
  and for stable, it'll get improved for 6.16.

- Tweak the SQPOLL submit batch size. A previous commit made SQPOLL
  manage its own task_work and chose a tiny batch size, bump it from 8
  to 32 to fix a performance regression due to that.

Please pull!


The following changes since commit f024d3a8ded0d8d2129ae123d7a5305c29ca44ce:

  io_uring/fdinfo: annotate racy sq/cq head/tail reads (2025-04-30 07:17:17 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.15-20250509

for you to fetch changes up to 92835cebab120f8a5f023a26a792a2ac3f816c4f:

  io_uring/sqpoll: Increase task_work submission batch size (2025-05-09 07:56:53 -0600)

----------------------------------------------------------------
io_uring-6.15-20250509

----------------------------------------------------------------
Gabriel Krisman Bertazi (1):
      io_uring/sqpoll: Increase task_work submission batch size

Jens Axboe (2):
      io_uring: always arm linked timeouts prior to issue
      io_uring: ensure deferred completions are flushed for multishot

 io_uring/io_uring.c | 58 +++++++++++++++++++++--------------------------------
 io_uring/sqpoll.c   |  2 +-
 2 files changed, 24 insertions(+), 36 deletions(-)

-- 
Jens Axboe


