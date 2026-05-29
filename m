Return-Path: <io-uring+bounces-13563-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mGCOChTIGWoIzAgAu9opvQ
	(envelope-from <io-uring+bounces-13563-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2026 19:08:36 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 0857A60624F
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2026 19:08:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6CABB300B9C3
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2026 17:02:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02BDD370D62;
	Fri, 29 May 2026 17:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="vErsWSzx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623A836E48D
	for <io-uring@vger.kernel.org>; Fri, 29 May 2026 17:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780074138; cv=none; b=V++UIDUnRgsj9R60aQCD55iS75Df5ES+e09SqBDBwwoocBf0/Yh/dwoc3+ncedJwoI7eqDx9Ju7kLfQJ86Wmd65pDdf0iFsdN8yJYJNgeFZwyXEw9QhYntDk6Alvdn20hEupRNzV0veSCqioJOwiD53A/fqdKOrt9Woh377qNhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780074138; c=relaxed/simple;
	bh=ENRJWZnXpjCoKyjt43nO/eSIkE7ZeW0EUEysBoPtJxs=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=YyGOoIoDXeGmHrnxossvX+Jw9IW6vhjGwNg/TMHGHRJZFa2KsYaKHqUu/T5rza7Weqfc9GBFY5Q0LnuGVTwVCQp7fhp0dxEh6OxByA8iENHsm9NLJSEqPeexPDhO5c6IWJkvomktwNsPbOAMBYG6FxFwcv3++doasIg8oywjTwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=vErsWSzx; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-490686877a1so42290585e9.0
        for <io-uring@vger.kernel.org>; Fri, 29 May 2026 10:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1780074135; x=1780678935; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fz6Fk/GRnyy47DPd+/A2va/b1LBHsIs/lBQBJR+raAs=;
        b=vErsWSzxCQ+M/DU0nLZBWSFw6R8Id0EJqLEB26k3B8UliiseOlPKP8NJMVd9Qhw7xQ
         Hjo5fIdKSop6dtZ0+bnm8AO5z9GospqVLOzDXByuhD9ter9Vi3Q/EoqTdwFGPziilX4J
         7Z+WC7JYiMWghnaSS+hI5uGY3hd6i0KO1ZomKwp9yvO9mqXDaKHqpW7z421G1SwL1ucb
         z0yw/9p/hzs3lNQkYNDGM88hDVG0wIbdX3ZFs4wAgP064F+xsvUyLxvgYFttnWvjrt0f
         Y9Sw68ECBRa0vpFQsBdegXZkmrAKeqfu5qaZI8ycghofSWsSiGa11EBkzJyPPKVVU0N2
         qqIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780074135; x=1780678935;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fz6Fk/GRnyy47DPd+/A2va/b1LBHsIs/lBQBJR+raAs=;
        b=LA6/gL1MVEfAhaRHgzBrvV/Z3vVYQOgb4OyGRPykN6POEbGOel7y5l1qrNq33ip+nq
         LrjfN/xWHI6lqY7RNrvzvDmtocfnr4Vzyjf9a/YJN+ClYQOIwlii1LuR0gZegWgyOaYm
         HQiF5jK15BRicks+jAZ4o03/T/G95n+shgOKObs3XMo/R3Ff0iiIKegR3ucHx1SoHeX2
         h0Sjw5hoaw+N7y1YKlGry8JCVVhJxRlFpPbDOY+o4dFaaVeekyHKG2oDfjXFfdpK6b98
         DS01W8Hht3eYUbjNAh/HVSKZcC4p/eshCht2/x+Oo9VXjfgpMMBUY5hAtEhIyljaKkgB
         65pw==
X-Gm-Message-State: AOJu0YwUmXHMsPmB83Pi7hwrpeEVZR85/eFKTAfEj5amr1PHgLhsQIqF
	x2axSrSBA75Qhb61208KNM65sHKUgpcMi3nDH9HbQI1LZDleoHEzBu7Y4WPa62bS5ZxnVd6kxK/
	Phae3
X-Gm-Gg: Acq92OG9E5JEXaMYZH5OEyB997imToOHDmLix2WO7MooO4g5Ptl/p2R2+mc/zIaWk3q
	mbXewCX/HwuyhYf6C9DWUvrDy40Qy9hipok6Jl6wD8Me801vFTIAqc8SHkWrmLmYots9IQU7Ai+
	Lt/PTdtyPKfCv3DOZkZj6+oNN82xznELK7kHiPdU7wl4BFhy7dotS0RS2GaKIGxU4Th1jIMPIm/
	cJlh0O2hcOm9YUqHQgaZrBE2zfA2h2HmajhXS9PCnatLT2DMT+fbJ0oBMpHUOb9u4DbKvShqruQ
	gcfiB1SkdibPMVKsn0xJReWVOiuxD+eOO3ewspWOCJjlYEEBCBTx6Eu28p74SA2f8n0rrL6p31o
	zgsFvfVQv5OIL1sj+F8sTkdx2VUjwHQBX/tPHDH2MgacAA3oc+FgUPdjiNw50z76i0inXP1mQxl
	HIrgylvh4JPhWaeA5J3RUIS/CyYwlTKMYDej/SLE+tIL2uc5T3t26TxPjZXD6Y3bEn/4Y2eBPeg
	7faaNW22Es7gSEAajxadsnE1GnBzpyIFnJ1bcMALae1ZPweOYk=
X-Received: by 2002:a05:600c:1387:b0:490:3cf0:8d81 with SMTP id 5b1f17b1804b1-490a2a4e8ebmr3348135e9.13.1780074134631;
        Fri, 29 May 2026 10:02:14 -0700 (PDT)
Received: from [172.19.131.179] ([216.250.207.179])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909c1049f8sm17663765e9.18.2026.05.29.10.02.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2026 10:02:13 -0700 (PDT)
Message-ID: <21ba7f4f-91f5-4157-b4ed-385359b487d5@kernel.dk>
Date: Fri, 29 May 2026 11:02:02 -0600
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
Subject: [GIT PULL] io_uring fix for 7.1-rc6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13563-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,kernel.dk:mid]
X-Rspamd-Queue-Id: 0857A60624F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Linus,

Just a single fix for a regression introduced in this cycle, where we
should ensure the node is visible before the entry is added to the tctx
list. Please pull!


The following changes since commit e97ff8b62d4690c69297f0f6de874f0564cc01a4:

  io_uring/nop: pass all errors to userspace (2026-05-21 11:10:56 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.1-20260529

for you to fetch changes up to a88c02915d9c6160cfc7ab1b26ed64b2993e2b94:

  io_uring/tctx: set ->io_uring before publishing the tctx node (2026-05-24 12:01:15 -0600)

----------------------------------------------------------------
io_uring-7.1-20260529

----------------------------------------------------------------
Lim HyeonJun (1):
      io_uring/tctx: set ->io_uring before publishing the tctx node

 io_uring/tctx.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

-- 
Jens Axboe


