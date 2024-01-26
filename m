Return-Path: <io-uring+bounces-487-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 957E183E13C
	for <lists+io-uring@lfdr.de>; Fri, 26 Jan 2024 19:25:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 467AE283323
	for <lists+io-uring@lfdr.de>; Fri, 26 Jan 2024 18:25:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AB511EF1E;
	Fri, 26 Jan 2024 18:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qbPRJHD0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6B517572
	for <io-uring@vger.kernel.org>; Fri, 26 Jan 2024 18:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706293519; cv=none; b=uV+Rg++EzOvyrBnPFvp/4w6LnNkk5DyygBPmQKNKjF29WefcehU/V8ebTTPD2m/EVtU1ybwK1V3nFWnefFRUNvgqaF+XTTLFj+4xjLMfdwV3OJpiW4mk2y8mGe/rvhDjnDpvjpD4Woyc/oqZcU/6wh4A3cgR8EuE90T0xVbsJmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706293519; c=relaxed/simple;
	bh=thjg5yZHcbiF9F1RfPhU+m3BiRcd/B/UsG5tzK0vrI8=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=SfYUEzA4cpkMpeDAIJHi9ZmL2PJ89y44yVg5kgjywSC0m0YO8I1bl3qF4rATG+OQijK/uqtPg22/4GV5kIwNupbj0Vc73g7kJcoHFXpHdbaNHB77Sm4vxQ0VyKgFxYODTQnULa6gINvsDyw/WLDv+A8HTdp4XTJ3sh+RWbbM1ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qbPRJHD0; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-7bb06f56fe9so13053839f.0
        for <io-uring@vger.kernel.org>; Fri, 26 Jan 2024 10:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706293514; x=1706898314; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1dn3zAcx/HT/64XnprLT7A6i+WrAK5SqetVD7YZDfXk=;
        b=qbPRJHD0TcHqKCOrds8j7FlPtn/vopHrFqskIPiFMaJaIUcdCESHLcLVEH7tCBmHLb
         esJwdILHqL/RR4U+f13f0J3iIP90HDPP3lzbIyDWwcGp06+vE4qQ254qGO4fTRLfANM5
         vwgvZVoCwfJCMVdY2SY7LW9jJ5vmCeMzuStNzfXnVezmQ4KR4lb6YMTRAo3XXXEaKwdu
         79npfwmKXtzzMlb9c4WhnuM9vwc3TpWAncRLIK03VjFE/rI3DTkzUFufPnxH1GqHcFoR
         3y4EARcdRsBaDmq7alwz1YqhUSufDhJyC9mW7zUnp7+f3AX+SikUod+H8GBDWTLrdeT5
         akyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706293514; x=1706898314;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1dn3zAcx/HT/64XnprLT7A6i+WrAK5SqetVD7YZDfXk=;
        b=b8PLI7i3k28GkEgAE4kFrzJCMz0ZgV2NLivRmBDZJ/fjU7TCCrmzDLpbwdIHytMI/R
         5365bUu0iSVCqYOYt6pdyl7uB1bICptOooMD+42cvRkJCINulvYaj3wnrvMMWA0r5tb9
         LI1+gGDRZjx7NnTZOazJ6wLNvC297jfohRfGFIbryrNVi7RMWP9YA46UljnAMSJKsjbw
         WjI8+ilJkQnIBw9jHmx/XvXBsionSLUjPbIJx6wSD0NAknkkoCue9OAXujgKidI732i4
         VpXSjZTag3zNWOg2NpIGAWnkQLvyHOrzHKoZb4lNa91VtBf7FzJkwSd7xBpTgV73dXoi
         hypg==
X-Gm-Message-State: AOJu0YxlYP33D7XfBCopcWd685aWW4ZC1x7lTblOGMX3eDrCWGZLu0NY
	D5+UzbjEE+zY0lVT40WhZkSWBI18J2OY1cJ7wd64sxuj68Eqkv+XWHQzPPBbflAjl5hHJT5x4c/
	vZFM=
X-Google-Smtp-Source: AGHT+IEQvjOcLIgbdjCy9ZOYBRQk3YtXMGyd6e0sIrXkT/ekfHTbfRbEqpD8fhuNRD4p0kIj4MltZA==
X-Received: by 2002:a5d:8885:0:b0:7bf:356b:7a96 with SMTP id d5-20020a5d8885000000b007bf356b7a96mr400786ioo.2.1706293514239;
        Fri, 26 Jan 2024 10:25:14 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id do5-20020a0566384c8500b0046e3e617619sm393386jab.129.2024.01.26.10.25.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jan 2024 10:25:13 -0800 (PST)
Message-ID: <6f96ec57-ae11-4ce3-af26-1bd7eccdc248@kernel.dk>
Date: Fri, 26 Jan 2024 11:25:13 -0700
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
Subject: [GIT PULL] io_uring fix for 6.8-rc2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Just a single tweak to the newly added IORING_OP_FIXED_FD_INSTALL from
Paul, ensuring it goes via the audit path and playing it safe by
excluding it from using registered creds.

Please pull!


The following changes since commit 6613476e225e090cc9aad49be7fa504e290dd33d:

  Linux 6.8-rc1 (2024-01-21 14:11:32 -0800)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.8-2024-01-26

for you to fetch changes up to 16bae3e1377846734ec6b87eee459c0f3551692c:

  io_uring: enable audit and restrict cred override for IORING_OP_FIXED_FD_INSTALL (2024-01-23 15:25:14 -0700)

----------------------------------------------------------------
io_uring-6.8-2024-01-26

----------------------------------------------------------------
Paul Moore (1):
      io_uring: enable audit and restrict cred override for IORING_OP_FIXED_FD_INSTALL

 io_uring/opdef.c     | 1 -
 io_uring/openclose.c | 4 ++++
 2 files changed, 4 insertions(+), 1 deletion(-)

-- 
Jens Axboe


