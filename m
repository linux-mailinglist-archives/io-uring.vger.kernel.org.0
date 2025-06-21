Return-Path: <io-uring+bounces-8445-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 25AB0AE2906
	for <lists+io-uring@lfdr.de>; Sat, 21 Jun 2025 14:58:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 816363BB1CA
	for <lists+io-uring@lfdr.de>; Sat, 21 Jun 2025 12:57:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0EB01DF974;
	Sat, 21 Jun 2025 12:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Dt7CB9W8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB01C2AE8D
	for <io-uring@vger.kernel.org>; Sat, 21 Jun 2025 12:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750510687; cv=none; b=Q3Z3zUTfFijLxF6SLxryWyzaVbMslvrNCB20vBtZehp6uabhutfv3VjNv4FX3LhGUl3dh4Y0nPDPDjvbx0I5kJc9g2NE+PPpSEg+uU+tMm464/zNwclVzHHR6YZCOKFw+vFI6M3kh3cxp8aCXMOAeHxxcRYTMWYcsHcxaTtvPx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750510687; c=relaxed/simple;
	bh=XRCBWZAHuwwevzYIEHsi7ge5J6g+3671Dp6cpxUfKds=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=ERrBAdUrhJ8gxSe1L5e6Ny2bfQDXLTlOweZPCcjfugO7VX2Hb+Ww71E/6BAvfWSTb4I56rrBcPLaej3e2x6yX7gySLtugw5kl906Oy1UX+L/WETbFNjdv0FGFmqIGPEvoY4i+UysIx0iWNuGkMo7bg/nNahkRITcYfOrxJ1dTNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Dt7CB9W8; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-747abb3cd0bso1936275b3a.1
        for <io-uring@vger.kernel.org>; Sat, 21 Jun 2025 05:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750510681; x=1751115481; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hUnSbegBKElTj0VFeD8hcA254YHm2Sk7ZfsoZHNws9U=;
        b=Dt7CB9W8kYjHUu8uTF2sqvthGBUTlR4LAV1kSvDBsMadWsrx0+wnUCmakB1QdNyVl6
         79rDzJ2+Jtes0mVJ8EUtBRyQineJXbV/bfxoueCoX/Ti0W0g5Y2HzjBzolUNAdtIEiPt
         2a/CnW8JtBiHpFO+GIT7qhsz46nxjr+sGwVpHPh4d3X+g9Y9vN9edkdTXhh2xKeai5/0
         fUiFpUq3/dauqumwU+O3KHW+rGgJqftYFx6UUOmBeQJKly8DnJxz1mP3VZqDi8mSPm+c
         GNuSWPsHvpZJT40t2p6w03c212QTC0ugsRqKfkcax2c+EVOx83a3yrhms31IUvsQbx6/
         6viw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750510681; x=1751115481;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hUnSbegBKElTj0VFeD8hcA254YHm2Sk7ZfsoZHNws9U=;
        b=He9kWaJmzd5dNLuQA7MWrQAfZ245n10R/HOeFf05//WbC0fum87ChWLIL2EnSRjaeC
         UKCOR3f0vmpR17J5J/55Pvt3NKjWdc+0FVAf0eROKNTNbQRFzcEj1Ocwvau6DKz9b657
         4VIpxTGxkZmFKk++0rkQ0TfDSQsnjZ9/CRQHNn0CK5H0veAyokKhnpFXFca1GeRqx41s
         /h0LqEzRLg17QgrVrkQrSFgr7XDec4WT3SpPYn3c2oI6Ey6RlY67AjA9YgmegnL0SBRw
         Ab4oaZNc3/wTG8vb4lzkl+jMT5t+Y10Kr/qi2Fr0MQFdrMBD82jA2hcGntwL2qiKFv9t
         Of/A==
X-Gm-Message-State: AOJu0YzsdGiaG/dEJFuzkxcOuxhWNSL+ZMf1lt/8aGUhAI244OG5IgA4
	OiENxyggRWC5IgLgpuPkHa4DfkH1zhVWx2p4hX08PCq39bLlzHQ7wtdPxIODtcPTyx6vLWcShTv
	xV3HK
X-Gm-Gg: ASbGncvdsTX1+syRbQQG4MM5cgdzaSa8ep86O7rAPYREynriwS7WF0O5uLRnYm+aUxC
	n0uneycN4BGRLvUNluhf6w+qvbYCz0CKcj/cIhjD2t55MMdATge6UWEfwk7iGYwEpZGi4yhnxuz
	eqmUaRtxFyeZsk7l/zRrWnk1ROr3wwR/wZMTNPDPxE1mbFq+hbbVC6FG1IIQ0MGx8STjBn6RGvE
	nMPo6gKIRqp1fIGR37iYKhSY0kqe4fLlqelQo8eTespaEr5tjLk168SLvhjoS8+V4OneNZDZ/hA
	toz25qEwqnexLdJgaILtQ1C4SYCKoSSrBeQyBQb6IJIwOgzWQc5PHMiYReNbHxNWVgUloRevVut
	7j1aGHKtWthWtOqdV4qEgyGRX1/DAuCiifnq3hgI=
X-Google-Smtp-Source: AGHT+IFKU3KLT5xHfq0/ifNDum0tzaZne3YcUjcgg29dyQRHGx2lzIiv2P+EvTx1ZnI82Bjp2Np2sA==
X-Received: by 2002:a17:902:e88c:b0:231:e413:986c with SMTP id d9443c01a7336-237daff48f5mr90718835ad.11.1750510681385;
        Sat, 21 Jun 2025 05:58:01 -0700 (PDT)
Received: from [192.168.11.150] (157-131-30-234.fiber.static.sonic.net. [157.131.30.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3159df93ad9sm3859992a91.21.2025.06.21.05.58.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Jun 2025 05:58:00 -0700 (PDT)
Message-ID: <d84da304-de2c-4587-a78b-20efdff71787@kernel.dk>
Date: Sat, 21 Jun 2025 06:57:59 -0600
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
Subject: [GIT PULL] io_uring fix for 6.16-rc3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Followup pull request with a single fix, to hopefully wrap up the saga
of receive bundles. Pushing it out now, so this one can land in -stable
with the other couple of fixes for this.

Please pull!


The following changes since commit e1c75831f682eef0f68b35723437146ed86070b1:

  io_uring: fix potential page leak in io_sqe_buffer_register() (2025-06-18 05:09:46 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.16-20250621

for you to fetch changes up to 51a4598ad5d9eb6be4ec9ba65bbfdf0ac302eb2e:

  io_uring/net: always use current transfer count for buffer put (2025-06-20 08:33:45 -0600)

----------------------------------------------------------------
io_uring-6.16-20250621

----------------------------------------------------------------
Jens Axboe (1):
      io_uring/net: always use current transfer count for buffer put

 io_uring/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Jens Axboe


