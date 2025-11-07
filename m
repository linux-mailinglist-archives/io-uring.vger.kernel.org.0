Return-Path: <io-uring+bounces-10440-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A973C3FBDA
	for <lists+io-uring@lfdr.de>; Fri, 07 Nov 2025 12:33:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBE663A9D35
	for <lists+io-uring@lfdr.de>; Fri,  7 Nov 2025 11:33:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FFF31DE3C0;
	Fri,  7 Nov 2025 11:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cxw2tIpK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD4D20ADF8
	for <io-uring@vger.kernel.org>; Fri,  7 Nov 2025 11:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762515183; cv=none; b=EPVQfesBlW0DTEaF3dirZoOVLzjE6CcQ0hF3niZINVh0V7TP35OC20V6/APHjQSyvhAmj0HwogdwLFKhxLfF4PI5BbGGRbkJPrggsRGm1K/Iut2DEetK7n+FEJatTmLNWC0QJ8dlmrX25KwZ9rD0N1uILhcnaS4zeVTXzxt8RD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762515183; c=relaxed/simple;
	bh=/sj6BwG4+3pYFY8tBMAJfghtuqoXIbRD9UC7e1YLMp0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=UBgcxMUFEvQ47OkgTdgHKdJDZ2zjDgsjFEYt4ngLxyHSViykt2YKwaE1OrasshZvUWHVI4fTekpeuqwcRyrIL0ja2cKQPOxtxt2oUkQtRHMSaOdyD7bIOs0B3gjiLBvOtFZh4BEO0qWQFpoVIvqWRhyZY9xgqr2SJ9xL2O/xeTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cxw2tIpK; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8738c6fdbe8so6268066d6.1
        for <io-uring@vger.kernel.org>; Fri, 07 Nov 2025 03:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762515178; x=1763119978; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vkwSlwTN6QRxMeU1rmIo0A5CSCQzNMOYfRplohZM0nU=;
        b=cxw2tIpKeNwjM7R4yaPAIeEmRDX5JDcllZiAwTsdpCrfYakisttXUp/MBtGo9uClsh
         xVDujq4saYYXdbTBtsmRSAWfIFcQRCQFlTIvi3QmNlIVkD3iAHGq0eH0kQ/vmSo/ad/S
         vVpXhXOv+NEG4M8cTGAMROI1yc/Qv9R49PFzXagNwm7X7J/nyDGPxmsgIVVLpw9Hhwm2
         ubbfICyGWPpubhnehDQWr0CJWP2vDIyO4T1lxU7UooO9drxNd4S6OtVoD1WiJCua5Keh
         GsjV5LiX6PgpKSsg4xztbTMlfekILtpZiaUrIcH68whClPcD0l9Y/hMIoUbndi2sX69i
         BlAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762515178; x=1763119978;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vkwSlwTN6QRxMeU1rmIo0A5CSCQzNMOYfRplohZM0nU=;
        b=TE59RDGtqNE3Y/agR3AnkRtze7aH7n2rGncr8USf9pnso/6dlxJKS3FQqgNfuGmwdA
         gIiU/TjHfsM4RgfgdrC90fPUon01p29OwyQVHUM2lNX7qkFkBxFR0MDtvjQooKSigQ54
         PcsE+/PhMYcwyUJxi3jcfr5+UJjj2uO5A3+q2jGb/pvQMl3KBHGyNrYLHi1LDbiRGZnG
         zwsxgLBJvoq7K2smRJOaIbLtrNHYOMB3V6ISlQBtEC1nqrvc1qgzGcDOXoo2T4/rt3wq
         T70fiPYCpLr+zW2xGudynJtOz8c/yqc6ixqYTZyVQMTLQug7TSb6gzFKGSvHPEiPxUpS
         cvcA==
X-Gm-Message-State: AOJu0YwrEu/9kk9LhyPFqmECd2H35yyVUexRjtJ+6XiANz0S7RPxz7qC
	hnY6xLOgCX5SL+e8L/qSrpq2lzfDE8kf6eP+oLWksKVroQZtDC/Y6LXEGrcyL8gm4t3O/DSkylw
	Kcr2b
X-Gm-Gg: ASbGncu2qL8GLRgq3IFZsd7vEpdurYvgx+uKWdnD0Cmd8Dcxscwszu/6cSERhvTsrHQ
	dmqxWAPT+tY1QPd8Uv9qBJTUNKdZu0YeEGYuikFktx1OBQYdnqF8O8s4NT8YAM2DRUEieJQ+w0+
	E5jI0kou9v+NLNX8qbOFXIotJoEV8dKUkAa0HACw+eY1mNB3NIBq13jzuZtuJ9B1gHA6JpsZgdn
	xUT3p3SFaivyU8J5hllFv3zM6l5Yz5az1tW8waTZf2sYH2Ts2roeA6qbMCd3QuDHg37X+RYcuJ+
	7LQesgf6N/I/EPp3LOz3BCDKKZskr00kQumHf9m38vssFVXkipNNyZDOUfoG4JxVPWoq7a3ivsd
	Ay2n1wcY6giKig/gioyt1zppsdT65cHrl0ewpALWCSRZIn6ylW1FwJ87M+pjWCfFnkin8YCZcix
	nNfoOtIz/t3A1OYivu08aHkGUDHd3gInePbmTUuHWCoqA=
X-Google-Smtp-Source: AGHT+IHJyulbjVP40n2jeL2KqrQjt0ALepKGwRwkV7M+RUmuz9JGVp7IHImY67eIEUcJ79YQC56UyA==
X-Received: by 2002:a05:6214:212f:b0:880:3eb3:3b0a with SMTP id 6a1803df08f44-8822f4d3dacmr12133496d6.4.1762515178021;
        Fri, 07 Nov 2025 03:32:58 -0800 (PST)
Received: from ?IPV6:2600:380:1865:be24:546c:e307:b658:1b6b? ([2600:380:1865:be24:546c:e307:b658:1b6b])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88082a4041bsm37922796d6.59.2025.11.07.03.32.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Nov 2025 03:32:56 -0800 (PST)
Message-ID: <005ffa7d-e86c-4432-9806-8449b9de0b37@kernel.dk>
Date: Fri, 7 Nov 2025 04:32:55 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.18-rc5
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Two changes for io_uring that should go into the 6.18 release. This pull
request contains:

- Remove the sync refill API that was added in this release, in
  anticipation of doing it in a better way for the next release.

- Fix type extension for calculating size off nr_pages, like we do in
  other spots.

Please pull!


The following changes since commit 6f1cbf6d6fd13fc169dde14e865897924cdc4bbd:

  io_uring: fix buffer auto-commit for multishot uring_cmd (2025-10-23 19:41:31 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.18-20251106

for you to fetch changes up to 1fd5367391bf0eeb09e624c4ab45121b54eaab96:

  io_uring: fix types for region size calulation (2025-11-05 11:45:07 -0700)

----------------------------------------------------------------
io_uring-6.18-20251106

----------------------------------------------------------------
Pavel Begunkov (2):
      io_uring/zcrx: remove sync refill uapi
      io_uring: fix types for region size calulation

 include/uapi/linux/io_uring.h | 12 --------
 io_uring/memmap.c             |  2 +-
 io_uring/register.c           |  3 --
 io_uring/zcrx.c               | 68 -------------------------------------------
 io_uring/zcrx.h               |  7 -----
 5 files changed, 1 insertion(+), 91 deletions(-)

-- 
Jens Axboe


