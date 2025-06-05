Return-Path: <io-uring+bounces-8234-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD415ACF848
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 21:48:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B7EC171C0E
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 19:48:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7889A27A92A;
	Thu,  5 Jun 2025 19:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VqXT+lW2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300FE27EC74
	for <io-uring@vger.kernel.org>; Thu,  5 Jun 2025 19:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749152856; cv=none; b=Yxjf1TnkozFIIFib1IcDS5xA25C5ZKuE2+KZNtpuz1rLifVVWTkVl3bDQYC2rgc7os3BFD4qdhVN54c2zrrSxSefG8fyb+/P+36vvjC2J16B9eXN1A5MZpYRYO6/gYEKZb20kxMRxaEHlYNXzt+Y0Ck94hEtJF7pvUbmH3gBcOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749152856; c=relaxed/simple;
	bh=RCKDLPEkdNEJvweUS21C9OxKl+5cERpDXzhnGgCMrrY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q/XAdcftukH9lzqG6tGqSHQamKJJYxHdNL+XncT8N6kXjhtyst1d+wqL0yDfeROyfjJM39PldN99ufJluf1tznDCK61xKOewGYkArE3CjDDKQ94pagZ7vFhSC4DUh8TeHWk7UK88E8cfeyrgBSOOUUBqSgaMw3PphU5Q3VXTfUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VqXT+lW2; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-86d1131551eso39510639f.3
        for <io-uring@vger.kernel.org>; Thu, 05 Jun 2025 12:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749152852; x=1749757652; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=o5ebHgbhVRHP9V7Ojvo4OMGh3VpUrR4CWjq/65kMr8M=;
        b=VqXT+lW2xLkB7FdRM+iZEsRdI59nBnWr7hMA9SMGg+81EgxXJOOn9WyeJj8hRY/HgQ
         mHMmfqfAnrYgLQbI/rX+SCMt3n4a5T1PX1WFVODs9CNj8ERSzFxFQOvIyA2Q8yp8FTTj
         OGVxSiK0l0Ql86kjBUyw43mEUX2WTBtu6q/jVyfsdAaLaEzSoUMrLj+ikiq7gcGtr6h8
         AtNCTgcxgllXWIw92kkclAqgdDkEfTKjsphyRWIewpiNCT31+c8EkGv6KbXcsbV7B38t
         jdFIw8MY9Q6l3FOdIKGDUk15+qg928xQbwwnPnVHcBTrpsQ8w4w006ti+LPt3bqdE5sJ
         MMzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749152852; x=1749757652;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o5ebHgbhVRHP9V7Ojvo4OMGh3VpUrR4CWjq/65kMr8M=;
        b=TLTl/1PhIcLFueVIg/FVErccMII7o4L8mbQonkZxlQUydtC0CmCf4mInd0YWSOib4f
         oxpCOVwPZ8P74Lbn38J0u3M23heS2y41Wu/Bal7x8egLUECc1rB9wnfcm+pgSpapdiUF
         x/15z74QYCr+iZoewrRgn2F2Q9OmXFdbGTPSO9zc8n9k3aqigbdWDddEbO0xbgPx8IRu
         z1p0x6sVOHbVE1PPe6eGpWUOw9zfaXEPE3ONLbIbByh+SQEV52pqt5Q8ltz026Ug+EHr
         n3rxOnjSrmmxViUX+naxKXOr7qT2nfaS6WcNppIlxgecrNSwyisqViVhI9VNmJqc9C+2
         15QQ==
X-Gm-Message-State: AOJu0YyWeEc1QQ1jzNEQZ/RAKrJmpRO0sRcGH1AZPWRJf1MLysbup/xt
	BMGjUsP+1uUiu4n2V+o57flzSiCp4N2rmW8tV3oyVR1guf14bBdIgt3O4FNBa7PS4rZcyeO8so9
	uYgp/
X-Gm-Gg: ASbGnct+EBxPhu9ZYx1VcefeEPHvSdCQ63+58tSQt/ewXr3pbXSsht0782TcsXNv4/w
	nZESDtasSIzaJIHWgRIjZ9zPfDAvrxLbHfttMOXKmsDMzYvVH47GlVTc3GBoeKY2eCkWEUvKGlU
	9yBYaywjlndqzNDqQJWewmpfbGwP//8ZUwwNaXfCas2w/fcOFgPAvfCpCY2hozSs8GOtjBVhN7g
	qEQ9NPKoqMjXgL8yS1vr8xT0qtMBHdBaoG57SHOxhuyqQWHy5juXMaxSJZU0RLCMlc4D/TID1z9
	FDoPLgWGpAubafM1hhfnzoMKeXGKuwf3rpZ3w8iVdSUiwi5Tv42QMabw74c3Lzr8s10L+3KaHyD
	6
X-Google-Smtp-Source: AGHT+IFsWVDgt6RAUPuJOwPclLUGN0ZH1Ns9OuWRibf3ozLpSS57z91Xu4mu64fFrmYcVm4DdqOs4g==
X-Received: by 2002:a05:6602:4142:b0:86c:f0d9:553 with SMTP id ca18e2360f4ac-87336655c73mr114721639f.5.1749152851766;
        Thu, 05 Jun 2025 12:47:31 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-86cf5e79acfsm317783639f.19.2025.06.05.12.47.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 12:47:30 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: csander@purestorage.com
Subject: [PATCHSET RFC v2 0/4] uring_cmd copy avoidance
Date: Thu,  5 Jun 2025 13:40:40 -0600
Message-ID: <20250605194728.145287-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Currently uring_cmd unconditionally copies the SQE at prep time, as it
has no other choice - the SQE data must remain stable after submit.
This can lead to excessive memory bandwidth being used for that copy,
as passthrough will often use 128b SQEs, and efficiency concerns as
those copies will potentially use quite a lot of CPU cycles as well.

As a quick test, running the current -git kernel on a box with 23
NVMe drives doing passthrough IO, memcpy() is the highest cycle user
at 9.05%, which is all off the uring_cmd prep path. The test case is
a 512b random read, which runs at 91-92M IOPS.

With these patches, memcpy() is gone from the profiles, and it runs
at 98-99M IOPS, or about 7-8% faster.

Before:

IOPS=91.12M, BW=44.49GiB/s, IOS/call=32/32
IOPS=91.16M, BW=44.51GiB/s, IOS/call=32/32
IOPS=91.18M, BW=44.52GiB/s, IOS/call=31/32
IOPS=91.92M, BW=44.88GiB/s, IOS/call=32/32
IOPS=91.88M, BW=44.86GiB/s, IOS/call=32/32
IOPS=91.82M, BW=44.83GiB/s, IOS/call=32/31
IOPS=91.52M, BW=44.69GiB/s, IOS/call=32/32

with the top perf report -g --no-children being:

+    9.07%  io_uring  [kernel.kallsyms]  [k] memcpy

and after:

# bash run-peak-pass.sh
[...]
IOPS=99.30M, BW=48.49GiB/s, IOS/call=32/32
IOPS=99.27M, BW=48.47GiB/s, IOS/call=31/32
IOPS=99.60M, BW=48.63GiB/s, IOS/call=32/32
IOPS=99.68M, BW=48.67GiB/s, IOS/call=32/31
IOPS=99.80M, BW=48.73GiB/s, IOS/call=31/32
IOPS=99.84M, BW=48.75GiB/s, IOS/call=32/32

with memcpy not even in profiles. If you do the actual math of 100M
requests per second, and 128b of copying per IOP, then it's almost
12GB/sec of reduced memory bandwidth.

Even for lower IOPS production testing, Caleb reports that memcpy()
overhead is in the realm of 1.1% of CPU time.

v2 of this patchset takes a different approach than v1 did - rather
than have the core mark a request as being potentially issued
out-of-line, this one adds an io_cold_def ->sqe_copy() helper, and
puts the onus on io_uring core to call it appropriately. Outside of
that, it also adds an IO_URING_F_INLINE flag so that the copy helper
_knows_ if it may sanely copy the SQE, or whether there's a bug in
the core and it should just be ended with -EFAULT. Where possible,
the actual SQE is also passed in.

I think this approach is saner, and in fact it can be extended to
reduce over-eager copies in other spots. For now I just did uring_cmd,
and verified that the memcpy's are still gone from my test.

Can also be found here:

https://git.kernel.dk/cgit/linux/log/?h=uring_cmd.2

 include/linux/io_uring_types.h |  2 ++
 io_uring/io_uring.c            | 35 +++++++++++++++------
 io_uring/opdef.c               |  1 +
 io_uring/opdef.h               |  1 +
 io_uring/uring_cmd.c           | 57 ++++++++++++++++++----------------
 io_uring/uring_cmd.h           |  2 ++
 6 files changed, 63 insertions(+), 35 deletions(-)

-- 
Jens Axboe


