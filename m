Return-Path: <io-uring+bounces-2321-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FF7C912B08
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 18:13:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCF81283AED
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 16:13:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C885615FCEC;
	Fri, 21 Jun 2024 16:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qyvDkaA/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDD415F31D
	for <io-uring@vger.kernel.org>; Fri, 21 Jun 2024 16:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718986378; cv=none; b=scDak3hSb6wAp3eVlsO86Y18vDCsZu4vcL6AVjqS7C+9JsKaoZSXWwi0bvGAEaYqX7e42UwxAJpY12AsUsn8PXK27ICC3A4TcPRCXx8UhnbAOiOgBG9aNss7+MqrYEhPAm1r3wG1UMwcMIkz78HphxzgRaFm326mgw5EwBMZEbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718986378; c=relaxed/simple;
	bh=RRkB13ypj8a9OjlqJV4hXRSVHwpU3Qt+gi6fgksOz7U=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=TLQBfKwfTaUNe0Ku90EXXGLkFOi9J4NbtiN5hSLCNEvYd3E/5f/lhVAAh3O49rnON4A5xaklHNi7LaSXOUC+mpDFHwlTMVStuTl7bm54SV7j0oumA5/MXNrEqkEiH6e/TRJldoFy3DMzlBlhOv6z+Fkyy2NGChJaYBhMqNDscYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qyvDkaA/; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3d2275b045cso92766b6e.1
        for <io-uring@vger.kernel.org>; Fri, 21 Jun 2024 09:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718986376; x=1719591176; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4bFMZnJ2WZimpGp1L7hpJOz9tC/9yHScaYlEApWX0gw=;
        b=qyvDkaA/D/yePki2RdO5wnI/Id8VytPG2D8FCkzWyCdHfVllRRgSVlaTaA5v2mnxoE
         G4FWb2ml+Ck21aF5w71J5YNrjguVkC1BLI5qYZNCBtXTw7TuyVcO79tDVtPKezPIO/bk
         MNWggK5/ds3OnklvjL1Eiz47vQ5nOYnL/aASa5qyDnN+pTSq92kBIAfI38AY1aMYcGmK
         /viE9edMIfpTu4ewKVYFdlXTMDfgFznLci5flsIhIhBZEa9DitTc7T8ELbSZR+r/kTgZ
         rv1dzdDReRjZX7bMXtII8TjzmkvihIZw31I4DLOrCldwGkUGrZtO+S2vIlm5hgMT9GOX
         TdYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718986376; x=1719591176;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4bFMZnJ2WZimpGp1L7hpJOz9tC/9yHScaYlEApWX0gw=;
        b=vxFS66q1ZeXFmGTD6yusZCp0OxnD+0B+p9UoxHi6qAfM6YgfhwIief35X2Xz8arNKb
         sQ9llvl41za3dItqC2hpSaNBrICnBjC+MuXgbsjrq6LRd/ONmGKboNhlV9ITsIxl6bRX
         nRw7D1q7Eg2Ssaf+a4xg2DKTQX72NxOGA2uIZTnKJZ/NhpmyMCU/peOFQ8s+eMadi7gZ
         ZH52EsnY08VO5o6C4XP8VBeNxKbGf0a0+NwBopp4d4x/kZP4thhf5Hn+QEiN2QoBIHsK
         iZA3c/j9fMPHTZuhTfAVeRYRdENy34oX+B703nZAa6eASR2w0BCUZ9g9EpjybsCvtR7H
         6NxA==
X-Gm-Message-State: AOJu0YxjLxcjv3iZ7sXekp4zRRC+WqPszXhowU8kNTBWTVYxkhHsKJ93
	IrJyFAivGNNgo+IPEwBQpkDnaofECWqVVKa7YJl2RlY6mDHCQ4vgROFwGA78JZtjM2pP7m3MLAj
	A
X-Google-Smtp-Source: AGHT+IFVoC6tsgC18o8lIxPBSBMyXbcigQ6TcOHemVA9jFvvOeyrRKUYrNngfWyVHleNYehIpa28tw==
X-Received: by 2002:a05:6808:278f:b0:3d5:1f50:1873 with SMTP id 5614622812f47-3d51f502884mr6624594b6e.1.1718986374526;
        Fri, 21 Jun 2024 09:12:54 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d5354c6c42sm293837b6e.47.2024.06.21.09.12.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jun 2024 09:12:54 -0700 (PDT)
Message-ID: <83d246af-25b2-4ac4-a7f6-57988e6ed145@kernel.dk>
Date: Fri, 21 Jun 2024 10:12:52 -0600
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
Subject: [GIT PULL] io_uring fix for 6.10-rc5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Just a single cleanup for the fixed buffer iov_iter import. More
cosmetic than anything else, but let's get it cleaned up as it's
confusing.

Please pull!


The following changes since commit f4a1254f2a076afb0edd473589bf40f9b4d36b41:

  io_uring: fix cancellation overwriting req->flags (2024-06-13 19:25:28 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.10-20240621

for you to fetch changes up to a23800f08a60787dfbf2b87b2e6ed411cb629859:

  io_uring/rsrc: fix incorrect assignment of iter->nr_segs in io_import_fixed (2024-06-20 06:51:56 -0600)

----------------------------------------------------------------
io_uring-6.10-20240621

----------------------------------------------------------------
Chenliang Li (1):
      io_uring/rsrc: fix incorrect assignment of iter->nr_segs in io_import_fixed

 io_uring/rsrc.c | 1 -
 1 file changed, 1 deletion(-)

-- 
Jens Axboe


