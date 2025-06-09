Return-Path: <io-uring+bounces-8283-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F3156AD2514
	for <lists+io-uring@lfdr.de>; Mon,  9 Jun 2025 19:39:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 98128188612F
	for <lists+io-uring@lfdr.de>; Mon,  9 Jun 2025 17:39:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AC0021B8E7;
	Mon,  9 Jun 2025 17:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ig/RTEIX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A7E21A931
	for <io-uring@vger.kernel.org>; Mon,  9 Jun 2025 17:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749490753; cv=none; b=BnJvrc2YcYUZG5iDAV48f/OkZCnBSdcfvUtnkVHXbztDcGrhQFwp9AsBwHvUnudycAoiBsEJ1IimsqyvVvJQAY7xScTL5cA57II3fzUUH0hX8eE7mR23TKDWn6cA+bE1PCZQbFtKHNnxXkQhF7mV5PkWZhlcyt+QcNQCNFQYy18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749490753; c=relaxed/simple;
	bh=gBmWq30AT4j7Ok+BF5D+qo09MakEmJovtVbzF+bhdn0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OHgAjgYSU+huQYytcmOAoPRT8B/NZMXWVIlkqh4OlZPFVtuF0caCP46CbC2gSwXLtFVq3N74m8y8BvKE7I3/jKSHdEi97aogq8Md1804MK91j+HG4fpQV7U1pI70h7ZuS2WtjTFk15gJZjULp8d946nw/X1/AeTNUvLq1RL0CqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ig/RTEIX; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-86d074fc24bso145339639f.1
        for <io-uring@vger.kernel.org>; Mon, 09 Jun 2025 10:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749490748; x=1750095548; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JZ47ieDoP3jNVWu6vTww3ngTGFSGJEXo0z8PGp5L+X8=;
        b=ig/RTEIXxLd54hkxuu0F0OYiNvQw68BUw+hR6aqHgYWV8OvWGneYP3Eis6ZdxUpDdh
         gTYLTxwiefV73J87+cuNG/wkWzbUr+/u/iRkcF8/mo9HzXtGME1i5Azo3MJNFWgz8Afj
         8ljzIQ+kYUrfm6SS4oc1DCNmS5EkCVFlBWwZjFXOeNOZO/nkeDxILvvzSHmOvMC5TP1q
         cnIIYWvVCtRlbrGqTbWwFMuL1g0IWFRpA5Kmsp4b/6Df9D24NL/Vj5egGlgw4cfnbovL
         govqD3FK3k/vOP05gh/WY8ymf48LOo5ZFNFJY/kWIacj1yu93ENOdNUb+BPJMgKIxT3e
         QzxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749490748; x=1750095548;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JZ47ieDoP3jNVWu6vTww3ngTGFSGJEXo0z8PGp5L+X8=;
        b=ZCkjvFruwPt7F/xyt5xMekrCuZ4c1qTPrupduWDwO6VRsCtdy6AbYzacWrmWK30vYv
         xNSD9MZwDKOMQqfclXF+Qh0W0MOWYe3gOuLwe/21/rSqvEIWQxgRhwyEbu1UJ16ZTr0K
         Kfc6hXKlu6wPimePyZ/XeiPRu+JINjJFAbmRo2WolOJuMKTxsIBCdeT34pPRb6mfV46u
         RVYCj2+cwPczc8mf23GpO3QKDjZKT1nIGUZB4YigQeXrStUDh4qZtPc33xYQJUvjr6dj
         dlxyA2ZCJzklraSbpQAPA87iht2HH1ALTyNYz8q1QVImWx204QZG3/vPpDSaLvfZh21U
         Melw==
X-Gm-Message-State: AOJu0Yy7iHf6cmdq1IoegVCanSjku1Lfee3NzbVHH7ArvDOZrf9iwJOt
	+3CWikwxkmuyl/BCMyYMIMQdgse2utxxT1i0QNIzRSv+DTivQk8xbzm1XyNFVuecYlTAsaSwTYx
	729I+
X-Gm-Gg: ASbGncvA6zy3e/FQqJ1Na4M6NQXQwoKPs9AjxMBWywVB9krVTjm/DlUGnYaOcxgA5yM
	XlnkU55RDhV4umvknVqecDNC3IqFyxQP5EyRtLIOD1HAdUHfV/VAAg7EwLhxACM+i0Yo80WOjMQ
	S/DNlJWTuw5blW0jNEM8b4xyJTUr/veGH21UHm2xSBRCnZh5SparQBBRsaI0JYbDdFmCluRYwLZ
	5JlRDM1pLra7fQC/E6Y8NpMgTmJDuOQAzvB8cD/GZkjwza60f6bq1KNlxdYC23TPFkgMcNpUy/Q
	inl+aTzkMpnuWkuESIiR9wXJP+2PzsOxYYfu02sGjBxxuR5XekVZdp2YlZvCSbe/hGU=
X-Google-Smtp-Source: AGHT+IGzHcemSggPGHz0qMpDnNWTTj9e2CzeI0ockUbwYMUvHMDVfAUDYkhCyKS8FZJgOWltykVqsg==
X-Received: by 2002:a05:6602:378b:b0:86c:efdb:6ed2 with SMTP id ca18e2360f4ac-873366c84d7mr1532909039f.11.1749490747999;
        Mon, 09 Jun 2025 10:39:07 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-87338a1eb84sm166607639f.44.2025.06.09.10.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jun 2025 10:39:07 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: csander@purestorage.com
Subject: [PATCHSET v4 0/4] uring_cmd copy avoidance
Date: Mon,  9 Jun 2025 11:36:32 -0600
Message-ID: <20250609173904.62854-1-axboe@kernel.dk>
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

I think this approach is saner, and in fact it can be extended to
reduce over-eager copies in other spots. For now I just did uring_cmd,
and verified that the memcpy's are still gone from my test.

Can also be found here:

https://git.kernel.dk/cgit/linux/log/?h=uring_cmd.2

 include/linux/io_uring_types.h |  5 ++++
 io_uring/io_uring.c            | 39 ++++++++++++++++++++++++------
 io_uring/opdef.c               |  1 +
 io_uring/opdef.h               |  1 +
 io_uring/uring_cmd.c           | 43 +++++++++++++++-------------------
 io_uring/uring_cmd.h           |  1 +
 6 files changed, 59 insertions(+), 31 deletions(-)

Since v3:
- Add REQ_F_SQE_COPY flag, so that ->sqe_copy() can only be called once
  and so that the IO_URING_F_INLINE WARN_ON_ONCE()/-EFAULT check
  actually works.
- Call io_req_sqe_copy() for any link member
- Update patch 4 commit message
- Rebase on 6.16-rc1

-- 
Jens Axboe


