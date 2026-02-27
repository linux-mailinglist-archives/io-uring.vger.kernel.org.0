Return-Path: <io-uring+bounces-12457-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oDX3N7XGoWkVwQQAu9opvQ
	(envelope-from <io-uring+bounces-12457-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 17:30:45 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 831D31BAD03
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 17:30:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B0D06302CB3C
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 16:30:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E30227472;
	Fri, 27 Feb 2026 16:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="U4pdrUW7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F80C3469EE
	for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 16:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772209832; cv=none; b=a/E4YcwKiwRKUFPatxOrZmfS1MxggCc3FwbTckjNJn2sq5DM6WzNI9qMnAsXMeMErEDCaQrqHxXnxhp2km3pGcTkdQ2ngrSjYzTzdz5L1Pw5L+ruT9fbt/ze3/48mQ4c90X3/Bd4f5cJtrc+5m8ydJhA6urLds/Bqan03HZedFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772209832; c=relaxed/simple;
	bh=l5dJepvYtXJ2X8uqbnc1tg/wYJiV2lZLXh7bd2cri1s=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=cpdWu0O7ydbtpamzFfOaOe4lzqYswcgfqMl8q4PtlR5vM0KVUgyfPlG/ZaaeTQcqYu0yqldBmBuk6DWnCc/CHnOM4w4KNI+FKB+Uo+Nn0Jy6p3UqBZLoV+rtPrHitPflKVOSdSisabO9kaIdbvsyH/byREHFbs8iJXVAdg4x1nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=U4pdrUW7; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8c70ab3b5fcso311810285a.2
        for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 08:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772209827; x=1772814627; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h1B8kqVHGufVeZFTZyRWOpCGuqCECRWo5i926O9ZF1c=;
        b=U4pdrUW73ePrfiAfKqmISsf/veP8+NpsH4JsR0aup+EZIkyse7l6aYTm0CdCuIaFe3
         s+c9RlBZMQ+Zy94YEt8AfakAzAgCjLkeyDLnof64BLDexWrASPrjCuLI9i8c1IMe2fTV
         bxbZHJhi+gVRl0fQ5aPECVvMcHJwqii1979HdesBNzv6x1VcI4ZG0vSkQO8+GLPDYSPs
         MVNve5ttnKR7uy8PFOhiA3drsMdBIilp86U16lo8VlrT2msn8O4hY0KaE9Pa7AkYk5y+
         zlVMwYL4IrDbep58uEuafKLLt3YflYqfE35ljNY4aOWsl/Fhsh2tNnXizvKbRIivyFBH
         HQBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772209827; x=1772814627;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h1B8kqVHGufVeZFTZyRWOpCGuqCECRWo5i926O9ZF1c=;
        b=ApgY8RepqUADJxqfNG3fPbpiFpx1B70tEG0n+IRqkIEhtWjvykiYz6rI1a3psJLDRZ
         X7yCyPY21PAO4DQH/aNN176abmBIg0FkMFmkvn8kqxnxASdRIB9GuD8bGm0kSEDz7nAt
         YM7sIs4m8IhOf7ZZtUO2EOjVk4/YBr9kpq6EtmJrZsKZs5SBQoaGR8WUSiH/SuKetIKt
         icKgJuHz/Es6fflkLepgEJBc08NLsmV5Gx6wfY4UgRfwnxROxXcWHTUdOeWGqrrf6ph6
         eSAUBiljZARjCndWj/I0HWHcncR8Pzm4cnsfAcpJ/UALmWwbNkI9nF3OnyJFzyjZ8mfh
         YuBA==
X-Gm-Message-State: AOJu0YxnzqJbseCnlzYlo+rIa5htTaBdnj6XIzbLemZOJaAX5lqm+sel
	TqySYE2aFLa9Y83sQ4ZLqrHfxjMjVQmmI1PtkH/ceFbgDk+FOYZLs5qJzyyPKiz/y4ciWB4eYfb
	wk1dO
X-Gm-Gg: ATEYQzzUEeza0EcRzScMbmvLeHXGFyAR5CDfdE49W1MyEmRe/32YjEVUFafzdoctt+W
	zdUwJBeYlwSbYglWs074M/oEVNk/iaTykHTrUO4+MIDSjdMIQAwnG28HTiAHc5e1+LFizmeyEqo
	c/0TNtHSdXyNpnVz5+ep4n3vBHAj8YaicxqKwMX9fnNfsFHAKF5sKcuDwA7Hm2qVXffUZ0tRoZR
	8CTe6tGi9TmojTZl/0spn721IL6kuUqjtkrXtnXsIUpck+HJXNQ7RepdxvzXFQvNTVaIB9OL7oX
	3y+RaluJvCM2e/kYvRfMkVugD2itu66/8x/TbaUDNt1RSreVuN5XQxGlylsuvBuhMzMF4IphHEW
	bNkU/XGYBHcy1lGDgbiu8JHcBp//DssRx56tmEI/njxrKF57XQOWwfXkfoNl4++aMd6oWsE0xxT
	PieOfoMxYNguq/dcuarUT353NUASF7alROdyHE3gDpGC+D+fRGiq9uLMnNY/VaSoEfLZrw8TZ6D
	rJ5KzCN
X-Received: by 2002:a05:620a:4712:b0:8cb:44d7:39aa with SMTP id af79cd13be357-8cbc8e2644bmr444183485a.74.1772209826227;
        Fri, 27 Feb 2026 08:30:26 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf6592desm505468685a.2.2026.02.27.08.30.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Feb 2026 08:30:25 -0800 (PST)
Message-ID: <07724648-d977-4f5e-bc20-15b1de4d0656@kernel.dk>
Date: Fri, 27 Feb 2026 09:30:24 -0700
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
Subject: [GIT PULL] io_uring fixes for 7.0-rc2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12457-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 831D31BAD03
X-Rspamd-Action: no action

Hi Linus,

Just two minor patches in here, ensuring the use of READ_ONCE() for sqe
field reading is consistent across the codebase. There were two missing
cases, now they are covered too.

Please pull!


The following changes since commit ea129e55c9e06a51a93c3f5ef3e32a6cfa3f8ec7:

  io_uring: Add size check for sqe->cmd (2026-02-19 07:26:26 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.0-20260227

for you to fetch changes up to 85f6c439a69afe4fa8a688512e586971e97e273a:

  io_uring/timeout: READ_ONCE sqe->addr (2026-02-25 08:36:05 -0700)

----------------------------------------------------------------
io_uring-7.0-20260227

----------------------------------------------------------------
Jens Axboe (1):
      io_uring/cmd_net: use READ_ONCE() for ->addr3 read

Pavel Begunkov (1):
      io_uring/timeout: READ_ONCE sqe->addr

 io_uring/cmd_net.c | 2 +-
 io_uring/timeout.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
Jens Axboe


