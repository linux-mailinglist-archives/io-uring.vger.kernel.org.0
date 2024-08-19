Return-Path: <io-uring+bounces-2835-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 502389578A5
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 01:30:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC85A1F237FB
	for <lists+io-uring@lfdr.de>; Mon, 19 Aug 2024 23:30:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D7171DD392;
	Mon, 19 Aug 2024 23:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="AUQHvbba"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C7B5C613
	for <io-uring@vger.kernel.org>; Mon, 19 Aug 2024 23:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724110251; cv=none; b=kz/6tPbo0oMNYbL+G/g7T4H75x7GNQHzHKnx2QtkMVLYXSZI7uIrNpI4TgGrG9Pv+u22F4aXCUEi2I02VCvj9ZhhNvCY9oAk+trrsOSC/RBIDvWx9p7wD01DwVL2Kq7OL5eWdSityYQ/g9+H2V2Zl2hpv7uNVozNyffPR5l+LtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724110251; c=relaxed/simple;
	bh=+gaZV38Hi0kLP5iWmon/MP8OJRdLiy861J0U+Z0oUYo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=prxsLTcZiJU63yE5flmCEOgvi/mDr46iabLkfRjXNPqi/nTJHjhlucNMMW0UajzrS/1hVVc8rVPx9M0MUw0ZEroc3CdjHyyPuOh8h0c8Fg4NqNjcQhfSbGc1cNUVbzdibO8dUPTtqueEqa4qEGqZ9vB5C+RrbxTYVhoAm5RHjBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=AUQHvbba; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3db1d48083dso543222b6e.3
        for <io-uring@vger.kernel.org>; Mon, 19 Aug 2024 16:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724110246; x=1724715046; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PikPHOLBDlHgTPtiUjpWpgLBCwse+zvmLb0pPzoEkTA=;
        b=AUQHvbbaoGpd+W7LLxxvRtupRDRl//Qa/eyyuHqHlRsffxooBcOeqtuIyMGy/32TBL
         cpUcTHeeYeoQloobaxoqDWWZCejW8G0kBIMIagYwqXrLJ5p3b1KOp+aRojh7DHbKAH/B
         m8hHCTzwMyWR9StZox3B5Uxu/yRKdKGMrVD7Z6AkClcapOjgAz2nSMse3KVbeepS2isW
         ReQ3U9MgpELdIg71CTKz7VYYnGxY+RDI94tH2VnmPjtRlrFU9mUXjBYhTPZNrsZ6A5dD
         hKCsgeyFBRdWvpUu6UOu5DZ1C28fkp8+UfX/vaLNgqWWlvGuk0Qa46clXelGZuQknoFK
         zAeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724110246; x=1724715046;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PikPHOLBDlHgTPtiUjpWpgLBCwse+zvmLb0pPzoEkTA=;
        b=YE2N4trIKEnGjJYc2Ei/2EfmRMOaM+Mlr9+KjdbGFdvl6yDYCxtZtZ/zYg7iEdDMNz
         eAaTcXnjY/DtqNelKZbQMyXZsSDDndPl8P7wLk7svDcitZSkvhNB+UdsG37r/sxza+UJ
         3k9YX7iadA0wb3BcI3kQQr6uX3uYRK1d9CeQOcMbwqYxec9FILpnyU6+IhF6gvfbEWXB
         NvbuE2EcWLnZ8PbEIKxPl/VpcAQM9GgFLFTe/FI3flPBpL+biM/cEDtRSslluJmT33V7
         qgjIkNM0EWw2B7daMr1Wvv8PeUiMCJsMhk+VV63fTKvca25Te7Oei1hWqxuyIoL7xeTQ
         IKkw==
X-Gm-Message-State: AOJu0YzywYP7yF72wVKwFQQkQ/NsUF8J0QrN6fyJSf0VxfydG8QdAE+r
	3+BOdhMtBBl/iwWV5ImqIDoaz5HcnaCkmJhwPFApl+cjaDRqPIKsA/D6u8QHFJ6YmT2kNw+c+UX
	Q
X-Google-Smtp-Source: AGHT+IFqfbXa1kA+CQyTZxRTAepb7TC7M8+jtEAFayxw+9DHmRZY84rm5rjvJ7oOFjk40grqESLA9w==
X-Received: by 2002:a05:6870:d60d:b0:260:f1c4:2fdb with SMTP id 586e51a60fabf-2701c57b639mr6978804fac.8.1724110246135;
        Mon, 19 Aug 2024 16:30:46 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c6b61dc929sm8219838a12.40.2024.08.19.16.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2024 16:30:45 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: dw@davidwei.uk
Subject: [PATCHSET v4 0/5] Add support for batched min timeout
Date: Mon, 19 Aug 2024 17:28:48 -0600
Message-ID: <20240819233042.230956-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

After somewhat of a lengthy delay from v2, here's v3 of this patchset.
We've now validated this actually makes sense and helps for production
workloads where there's a big gap between the peak and slow hours in
terms of load. Having a min time enables the same settings to be used
for peak hours (guaranteeing minimum response time), while avoiding
excessive context switches during lulls.

For a full description, see the v2 posting:

https://lore.kernel.org/io-uring/20240215161002.3044270-1-axboe@kernel.dk/

As before, there's a liburing branch with added test cases, it can be
found here:

https://git.kernel.dk/cgit/liburing/log/?h=min-wait

The patches are on top of for-6.12/io_uring, and with David Wei's
new iowait feat and enter flag added to avoid conflicts with that.

Changes since v3:
- Rebase on current 6.12 tree, without the NOWAIT toggle patch. Mostly
  mechanical, and FEAT flag reordering.

 include/uapi/linux/io_uring.h |   3 +-
 io_uring/io_uring.c           | 186 +++++++++++++++++++++++++---------
 io_uring/io_uring.h           |   4 +
 3 files changed, 146 insertions(+), 47 deletions(-)

-- 
Jens Axboe


