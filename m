Return-Path: <io-uring+bounces-12760-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UKc5Gop0vWmt9wIAu9opvQ
	(envelope-from <io-uring+bounces-12760-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 17:23:38 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AC49A2DD3FC
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 17:23:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C7DF33195AA6
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 16:17:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13C123C3C01;
	Fri, 20 Mar 2026 16:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="agsdwFjW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137993CF69C
	for <io-uring@vger.kernel.org>; Fri, 20 Mar 2026 16:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774023387; cv=none; b=WQIhDdemHHJIHHlCyWmvxXYQe1uRHnxIlKT1XpLiPdO3yMgTTIqH1hxuQ4ogRGMi8omOjrIYbQaOjwlwz3WGJiVO6sOKP6PC5D4sxlwHTIudRg0aIVrpXAJDcV3vAfGQtWeKnBce0iqjAHduMzQuM6YnazI5r5PwNyEAskX4NqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774023387; c=relaxed/simple;
	bh=zO5waLLxtQheu3Bx19pX56ydcD5UCmiH7mcc1qt0Nmc=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=p5M6EBrxatDe1amJZIIb3HLFVPoxrhrn8jxBmmhICoueVi6iO0i12FNjc0KAUVyZ5GZ6578gIpDqeVlqc4X7OKLdjvdWRoUiTEhl43w3bXCQFFHfgeBm+XcZJpZsY5sP0ReoJEYj6pMFBa+DEp2Xq0hf45eB9SM0Dlv8zBub0Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=agsdwFjW; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-467ccf23511so1513209b6e.1
        for <io-uring@vger.kernel.org>; Fri, 20 Mar 2026 09:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1774023383; x=1774628183; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6a6+Y55HfzurDM8Oa1pLMyU/mtIFicZ2qFhIVOYiwps=;
        b=agsdwFjWZW39Vo/zbtce36v5Idv/rPNED/TPGEBNAt9rBerjby0HZcQAoqLpw2pHEi
         Gckbir1xiVPa4VjBKkX1QSUfNgKvW0lnjUKudplgonIikSp+d1ObieVkh9nNO+99R5we
         zlUHax52MY31NktCl5muZghbCA2ThO2oB9yo4ImM/yMExWIS523LtLs55SuI8Gx5dmHv
         3uvSCAsr5gdYs7tnI33WPhQkmksTUGcG7aKgD+A1njzcyhTWJ1Uz0nLSQsJ3pFkWiWrl
         2pnnvjnwkNVwnCwHKts4Wl6jbh/IehzaQHooRSHy4qlwEwfLZTuSRIUW5YrMlcrqgtOk
         kwzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774023383; x=1774628183;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6a6+Y55HfzurDM8Oa1pLMyU/mtIFicZ2qFhIVOYiwps=;
        b=DLFFQ7UFQKuOH7msPgk0V5iXFslohrEOY2dfePgRH5X4vlwylUf7t2dM5sF41e6WvF
         I+SIYV/oHhzBA6+LN508+LIMJcp0akE768GKO5PSxpOeDoBqh8M1MwrHjKaoVPQlNThR
         3btxeuroq59jGbrzo644mF4YXGBxFBtE65jk/qf4XRdcgqaKk/XwXGeV/TV/ZQXeIsIp
         iBHq4Sv7n1tXskzUr2+AJnvG3LGHni7wfwmKiVOiE5LYCvQBpFV3+xXpR+I+9i9oMnEJ
         C7fi1K6c0s4ZtQR57gXI1KkvqTbsWKwplhboLq+nLXogyfpQyq/jSidzWNNthCc+5oS1
         D37Q==
X-Gm-Message-State: AOJu0YxuE4wHDvy1LM4uvaYoUN0RnC3ztO7v3y4NfodwheihAc1KBFIO
	O2Wk5p+VJZeghCdR6wBz400cCjC2zB4qMSahNPAIYpQCefec13Isy6rLCd3QBIMlX5NtU60dLOH
	qzjdo9jQ=
X-Gm-Gg: ATEYQzwriZnc6U4Cx/7m9pt2hGbaOtgUdHd0BG8Cq0XSEalIpoi1QzEZvTPOa1Pwbm6
	At+CvyjZd3uvh5BrWZw2/toj+5q44E8M3f6DOBVsHreUdgLzcy3Ttrq6qKQJmYaLDEYmMeFAM/x
	fNfMjFW34DSS6zMG0VNU2QPewuyG0/cIEDbmfgEMkmkPVIyzrmGBMctakJLdeBQQBG6NfX9/nuS
	Z2sZheWscZ/4jVQRR1McNnI1OOSI6FglnwYfTvBCc70HLIGS+0j0zHQkT8kPWKoYced8iEn5gub
	j/QzkMARwhyXarJ0QZiFT5tH6m4S2xZq/m+yYVDrg1OswEggZ2gX8kLNVrsV+SoFdPkPdZ57RNf
	12nOCo1tU4AjKX+++k2qGs1VSJVvimSdUu6oSR/iOwjibzuPRBVu9BoT/QyesZ7+6nIR+V52NNk
	zagS3aZ6qcf1ZGhWGuGVml6HM0CjLxueNRaGzLdo1AmEg8VEQfysjFYCnxbJ4VwOA+AZCFIl/9W
	RsyyeKN
X-Received: by 2002:a05:6808:1250:b0:467:5403:3780 with SMTP id 5614622812f47-467e5a24bd4mr1857040b6e.0.1774023382806;
        Fri, 20 Mar 2026 09:16:22 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-467e7a96c3asm1661689b6e.0.2026.03.20.09.16.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2026 09:16:21 -0700 (PDT)
Message-ID: <40c31f28-a227-4123-91fd-5a4b0c044bef@kernel.dk>
Date: Fri, 20 Mar 2026 10:16:19 -0600
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
Subject: [GIT PULL] io_uring fixes for 7.0-rc5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12760-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: AC49A2DD3FC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Linus,

Three fixes for io_uring that should go into this release, all headed to
stable. This pull request contains:

- A bit of a work-around for AF_UNIX recv multishot, as the in-kernel
  implementation doesn't properly signal EOF. We'll likely rework this
  one going forward, but the fix is sufficient for now.

- Two fixes for incrementally consumed buffers, for non-pollable files
  and for 0 byte reads.

Please pull!


The following changes since commit c2c185be5c85d37215397c8e8781abf0a69bec1f:

  io_uring/kbuf: check if target buffer list is still legacy on recycle (2026-03-12 08:59:25 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.0-20260320

for you to fetch changes up to 418eab7a6f3c002d8e64d6e95ec27118017019af:

  io_uring/kbuf: propagate BUF_MORE through early buffer commit path (2026-03-19 15:09:48 -0600)

----------------------------------------------------------------
io_uring-7.0-20260320

----------------------------------------------------------------
Jens Axboe (3):
      io_uring/poll: fix multishot recv missing EOF on wakeup race
      io_uring/kbuf: fix missing BUF_MORE for incremental buffers at EOF
      io_uring/kbuf: propagate BUF_MORE through early buffer commit path

 include/linux/io_uring_types.h |  3 +++
 io_uring/kbuf.c                | 14 +++++++++++---
 io_uring/poll.c                |  9 +++++++--
 3 files changed, 21 insertions(+), 5 deletions(-)

-- 
Jens Axboe


