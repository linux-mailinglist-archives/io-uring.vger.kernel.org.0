Return-Path: <io-uring+bounces-5793-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 67943A07FAA
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 19:19:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6CA41168C9F
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 18:19:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D7C419307F;
	Thu,  9 Jan 2025 18:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HDA/57nE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3407A2B9BF
	for <io-uring@vger.kernel.org>; Thu,  9 Jan 2025 18:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736446790; cv=none; b=YDDfxRYys6SLORmEp5Uj4MOk6QlEFZOESf/4lo8oi8pIbWDZh9uyHbt7cu0JS6uwEW9Kpiebzz4gbISS4TSv/zzYI0hwmVDBVi1v1JCe1Ihhy9X1hVxs2h58C/JXqYf3hcLIzfPWBq/r6F625iD3euDEAH+U14WAEpqcbGjh+P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736446790; c=relaxed/simple;
	bh=8A09Ij0KP8rH38gHXW5b55x8fWDODmXzeyqduDqphMk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=KfuXF4GmcIhH2d9xNQzJ+JvYJ/DuBqdaJEg6L4Y5dyyZsiZDMYHuZyE4kjTbnahdtccztWLNUoMGKhPin9Xcv3dWNOXcSeyqIwZmaCo6c1vmXtC6FznYSz8Rx3Xr+IGoPm15ha2594aMwTfMgxwL+F8V0LjKG4R2rT63HvlXN74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HDA/57nE; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3a817ee9936so3459525ab.2
        for <io-uring@vger.kernel.org>; Thu, 09 Jan 2025 10:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736446786; x=1737051586; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=jFNhj0a2J0LJX5Df8CUfh5mmWanaOIyt/PpHMC0rk9A=;
        b=HDA/57nEArHIx4dy4gBviIRMErlFKwd6bo0ekiqaBo/Dl4kjpjRwO2GIeFeDbQUlQF
         48ww5kMm0pC22IrReDhZo/xHaUU5dzYa71eN/sSfZFAbr5t0lgWHX98gaU0wddgrYhPb
         xWHfTwMF4l2uOFGm0lEeWxOxSn82Tb11LTNKNjY3lbVpk9l36n1k0i+bmTsKlHjt3T+x
         fs8xcqrZPm38FYC+pdOd9G8xfxsqLacwqC4xoMTx+uVy1G112p7QUp5KvN4MZmVBy6tU
         gZ2X3jGY5JKs//vd7hC/Nn9QS+XCTgh8/EY8tnwdf67Dix9wn2YQfL4Ro6/MK1qjCfmT
         7r8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736446786; x=1737051586;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jFNhj0a2J0LJX5Df8CUfh5mmWanaOIyt/PpHMC0rk9A=;
        b=Q8UzU77a7oC2OLbUjXR4eEF1YqiLBifx3j0iwIgYMWj5h7vuxjLHJHi3Ejh6yi/uh/
         YIy/ArjGlPlTy9Es1c4s6mIGBSvakCCr7iMNOGHxhKMdN+o3Fi5MuN75JRw/XwekmWnM
         gZJIhLgcINlTjOLmNFGAP8zy9QMBGJbN/NgMrsikFrcwNut2x9K2s28u4gZiP8x6R2uz
         HP2FjpnEiIoITPXmKnWkZiIkftg0MJlE0kIAhWaDJ2qmCWLzK+AnJdu9tSy4pjiXpsk6
         UM3Li29LtAU07q/kL6HqC+l5x2ZrEG9NX7J68yttJR/tYfAWS7jofuRrqd9Qdzg+7uxU
         cOHw==
X-Gm-Message-State: AOJu0Yyy18skBNmjvsqxPnbmxQnWS4cVCXxbTpI7Wwq/u+ZRh4N0Ni5/
	1p4gHKpeaI/jjPsBtygwEkIOvSxUDjayci0QA/RvoR5D83vp1esxxV9MZlTpoHNlKZi4rznLCpS
	5
X-Gm-Gg: ASbGncsxj/xl6Ladrn8G9HJseWA8dZxrQkjiZmDFHGUPkNJhiZAhHIPbHRPmvz/pWso
	8xqpnNH2XeothkySCHOdRzOrwWWPWouLOJ96X6QsuQQP4XidFSDN1UQyGWh4fNiAj8F3rr5zyiw
	zrBUkkPSaiJU2tnVQDAHUe9rufnO9MaswU/DONjn71X+hdbwToGIQ3Zng5h+gCrVX6IEi/rzl8s
	HP9HLN62jZOk9HOAhyC4PXVKIUEBR4oJ1LT+QMES52Y5fMWmK9Rmf+78aHy9g==
X-Google-Smtp-Source: AGHT+IG8fN9n1wKmdx/IEH5OTBpiP/WI2CHZnL7zN1Vyt6y9MM4EoqwWTsj1XAL6Jy4Yi7PlUyLQdg==
X-Received: by 2002:a05:6e02:1687:b0:3a7:85ee:fa78 with SMTP id e9e14a558f8ab-3ce3a9c190dmr55994245ab.18.1736446785701;
        Thu, 09 Jan 2025 10:19:45 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b71763asm440672173.103.2025.01.09.10.19.44
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 10:19:44 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET for-next 0/3] Fix read/write -EAGAIN failure cases
Date: Thu,  9 Jan 2025 11:15:38 -0700
Message-ID: <20250109181940.552635-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

After I had originally ensured that all read/write requests were
fully retryable (with the 6.10 "always allocate async data" changes),
there was an attempt or two at getting rid of these -EAGAIN's bubbling
back to userspace. See:

commit 039a2e800bcd5beb89909d1a488abf3d647642cf
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu Apr 25 09:04:32 2024 -0600

    io_uring/rw: reinstate thread check for retries

and the other two commits it references.

Here's another attempt, which simply moves this kind of checking to
be at completion time. This solves the issue of REQ_F_REISSUE being
missed in case it gets sets outside of submission context, and
generally just cleans up the random REQ_F_REISSUE checking that
otherwise needs to happen for the read/write issue path.

Patch 1 is just a cleanup, patch 2 does the actual change, and patch 3
finally removes the thread group checking in the "Can I resubmit"
checks.

 io_uring/io_uring.c | 15 +++++++-
 io_uring/rw.c       | 89 ++++++++++++++-------------------------------
 2 files changed, 40 insertions(+), 64 deletions(-)

-- 
Jens Axboe


