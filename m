Return-Path: <io-uring+bounces-10634-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 72D4DC5D1C4
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 13:29:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 393EE3AA915
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 12:29:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD0B435CBAF;
	Fri, 14 Nov 2025 12:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CHKgKzu4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E474136358
	for <io-uring@vger.kernel.org>; Fri, 14 Nov 2025 12:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763123396; cv=none; b=if+45KwHuvE0JyQ3VKdRqsIYWA6upxxERRK+XC32kiqdUFytxSmUau5W+0FZ0cjA1hCQ2yS5+6I1rO8fH8aB2yBLzlSzHfln7mpSNi4ZlOsmJBUshEPfSfOP3H1Gelzlkl541hfoOEJk5p2aUlRFQBnXt5i6iZHiW6Uq1gs7y3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763123396; c=relaxed/simple;
	bh=oiv13xuy4GXq99OY9H8L8kaUxs7oGwabDj+Y1M0iHeU=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Cve0SteRzBgF1WjzgJdxf1g6aNLGBijFiPfiTMEAXfCi1TDEQBuyyYWaevFbClnNr+BkU3cCXHFg59fldBcp89rG2gKhyXMafGXfACDDg19Y0N/0Wjc0SWLCXh7QmWs4lTHXFGQlaUAhfRIlP4m68dYKvvI07+yTO+Syj/3hD9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CHKgKzu4; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-4337076ae3fso8610065ab.1
        for <io-uring@vger.kernel.org>; Fri, 14 Nov 2025 04:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1763123393; x=1763728193; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9dX/51kxKpzKw3zIwxWDQfRcPXyUBxp0+ewsMrmnY9g=;
        b=CHKgKzu471tDyt/Apx6QkGhJBvZE/ljWZuQYwedkET+DAhhtuGwbv1p4XaQ5QSTdFB
         QGhs6Z4hI17dkH3x49amldTqumsw+qLk+kS4e1jeSDGZNCsed8XiC6bp9UrtIrbAWThI
         grbZTCBhgaLqZpdlMlOXExfB/ylUJW1ROVwgEv1JWpIZHvxbILCP3l3mIrO4ES9h55YR
         NcXRXAdZuPJbhrwSBq5Uk/0BRgJx64pK5mOOlEsXTgTxwLeRwmB4gltb0PpTnPTP0mlo
         W0G2XitQFzDaUv6s9dWS0eub3qLZyNkGU0L8u9ysmbigKSfr+8VAX6nePV5glkx2hy+A
         QzKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763123393; x=1763728193;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9dX/51kxKpzKw3zIwxWDQfRcPXyUBxp0+ewsMrmnY9g=;
        b=ILrfBuNry/ijnf5BHuo/cF8lDz6LFJTSMCm/3Qf/9BGEwbcwjdEf6PVy21Nvvrnb87
         X+06wBGdEIi3WhWsSIv7a6azW3e+4bGsgGOejxQppBncX7m0b7tG90v0/TPNqc1RA1S9
         ztQGa7/sEqQU1pOSqxIqYpkaHuvqT9hQaFK6m+v0h+ePSedZMVhZtj81sPFMdt+puOI3
         NjPOfK1XCa/RvBWGElRuiML5LRnGNNLxV70tchZ/g2dguXwQcNUkoYOAPNdD6O44TCL1
         jtJrZB0HnpFavPvbcZirHQTuaIego2KIrfA5WzE/2MqxMBiGrgm03PJYxlPBkyiAScVA
         NtZQ==
X-Gm-Message-State: AOJu0Yw7bxVLKpRXFL67UJW8LoTx4m3F+DaveioJq5QFv0Q1/GGmJ49y
	1zxviD8uGqsghiCmsPLCik8R7W+vDsPnxqvJL2fI5n3aCggrprCZYD1A6VNT8A65y8jQyG0DKnK
	vCUcG
X-Gm-Gg: ASbGncsUHddbsPvxvJ9PpZYmT/95DywyNzrEk9ED3BhXarg5fpW+atlrW3IxxqRwU4n
	4UOV8wxcZAHUcXfu3dSdBPm/Wab2snU/YNF7du8/T5OYLTx3/X7l9YRbFo1R75hkivxcYKx2KAk
	XpD1v0wCNIkvGNYjTNTHaESelRDHUcoYC+bK/MoRkXQnq00hJiQuus4xIE+rU+aFOLYPsp5M1In
	boBbXr4RGsp/Ctpo74K/LvpEmoirSUM6enkc8ZwEgGjppdlT/z9q1bN1XeAwRBotMerUpkYdf4j
	ys9/0XFJoDwsOqUrD4HVb2gsKKodSyVOioJfCG/WIaL9sWDrPtQLMTT00Wm5tfUYVbytta/u7oU
	hZD3i/mJ5kleLu3/ueYeOp8oQpZD5MMEWR/tpc2uq8Wdh++0fan+DnROT0LbVXt9h3Q5HzUKQqA
	==
X-Google-Smtp-Source: AGHT+IGwUZS0ioVlGgO86RZQ7fm2RLBRCuesQmfRtoEootQWnJBsSG9fQyNhxrjKMhuhX541EWVXHA==
X-Received: by 2002:a92:cda5:0:b0:434:767d:8a3f with SMTP id e9e14a558f8ab-4348c942b89mr43036115ab.21.1763123393587;
        Fri, 14 Nov 2025 04:29:53 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-434839a4ac7sm23408125ab.25.2025.11.14.04.29.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Nov 2025 04:29:53 -0800 (PST)
Message-ID: <962882e4-207a-49a3-beb3-81067ead6681@kernel.dk>
Date: Fri, 14 Nov 2025 05:29:51 -0700
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
Subject: [GIT PULL] io_uring fixes for 6.18-rc6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Three small fixes for io_uring that should go into the 6.18 kernel
release. This pull request contains:

- Use the actual segments in a request when for bvec based buffers.

- Fix an odd case where the iovec might get leaked for a read/write
  request, if it was newly allocated, overflowed the alloc cache, and
  hit an early error.

- Minor tweak to the query API added in this release, returning the
  number of available entries.

Please pull!


The following changes since commit 146eb58629f45f8297e83d69e64d4eea4b28d972:

  io_uring: fix regbuf vector size truncation (2025-11-07 17:17:13 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.18-20251113

for you to fetch changes up to 2d0e88f3fd1dcb37072d499c36162baf5b009d41:

  io_uring/rsrc: don't use blk_rq_nr_phys_segments() as number of bvecs (2025-11-12 08:25:33 -0700)

----------------------------------------------------------------
io_uring-6.18-20251113

----------------------------------------------------------------
Caleb Sander Mateos (1):
      io_uring/rsrc: don't use blk_rq_nr_phys_segments() as number of bvecs

Jens Axboe (1):
      io_uring/rw: ensure allocated iovec gets cleared for early failure

Pavel Begunkov (1):
      io_uring/query: return number of available queries

 include/uapi/linux/io_uring/query.h |  3 +++
 io_uring/query.c                    |  2 ++
 io_uring/rsrc.c                     | 16 +++++++++-------
 io_uring/rw.c                       |  3 +++
 4 files changed, 17 insertions(+), 7 deletions(-)

-- 
Jens Axboe


