Return-Path: <io-uring+bounces-7273-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2B4DA74E02
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 16:47:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A3003B56EC
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 15:47:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0456B1D5CD6;
	Fri, 28 Mar 2025 15:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Zf/p3gjG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f101.google.com (mail-io1-f101.google.com [209.85.166.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EFC5FEE6
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 15:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743176833; cv=none; b=DHw1kUmMs5hyOJIPAZWW2FS3pVnI6clIXV7hTdnceJvLBGdRo3Yv5uClxRzS7stxdJqSTlgXtfAtOIRtdciR4EV3xvIPonGNdHdbu+F1ystmdFywB55nkUvHACkyDKy5bvlrnfvWD2rbQAbbpmMfImPhwA2zSWswdADrG86AZJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743176833; c=relaxed/simple;
	bh=JhjmRIdsBL82blE2ISLTaByd0bJwbwic5q5i5qFM4LY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ih3wvgNg1z9HIulN+12S5Yw4Ns0SKRng0T9r9lfvXIawPBoFQw1KYTW98Ji6Z8im2PuZa9kWpdR6ccIjrpEl8R0/Iunrzzit16J6ZkRpSTDOYGX3yS3EU99fHWpP3L/+fNfEZ6m253pdJcvrEURD9w394gIOQNN9ySB6vXu85SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Zf/p3gjG; arc=none smtp.client-ip=209.85.166.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-io1-f101.google.com with SMTP id ca18e2360f4ac-85dc6dd9c5fso6510139f.3
        for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 08:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1743176829; x=1743781629; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7gtA1OYyJE89rNT+H5TYqZMzvImVx4usYAUfSZyWv3w=;
        b=Zf/p3gjG/bYLzEWAWR+35BgsCwxZnhGb+XCnGH00vGL6DhglADyzmisdxPhBJMZlLc
         eZbPP5FNo1qo/68ca4ByZprQ4kOfJRfgUrdFASgSH/Uhj+YZwcy/CH/7wGqZ4c6I9cgA
         2jk0caBMtYlx1+zzMkvPo7C+tDbeeuEtW5u45ySfKzhSwyezvsJjeDVIVU0oe3yC89gN
         k68hakV00Qew856GR/iYhN/lmcO6hn4RcFm3++vBQ6J3wKZcAFmTg4FZSxTmXTTSZfZc
         Xg4QaOmtAo0r9ESpfQkJZsAsPhel5dk5jyajXcDynRPSukO4Pit9PRsvrRxnNX9zsQ8A
         g0MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743176829; x=1743781629;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7gtA1OYyJE89rNT+H5TYqZMzvImVx4usYAUfSZyWv3w=;
        b=Su19ZnnpZz37hYAcgBvGTHORhg0mDC/DDlNIwqMeHr2oNvOBKKW4eVEaJNymA+RwjV
         UmBLk/YYwRFBnV+cZBcTwRDhlhIlQurZGQhM5SUgnZPvDQEDzEzzODRmkEhlL+jiQpNQ
         DbCujGsR31+ZydqJWsdRm0KIq+jjq1JgJ3jkaU2UZVLXXaBnZiyhBIXRBC97kBWTalr/
         nhpWbrtm8TlJrn3tdZuwHHJ38ZNvRt8AFo0t9ovyUejjcDCtTd1lVv4qGIklVMLs+jyV
         5SjmSMixMOfUyU9IKkE09ujQ048MXDeXioWzjyjinpX852ukf0W+uWDf8eAh8SxZeyz6
         mW8g==
X-Forwarded-Encrypted: i=1; AJvYcCV4QLzJp8ZXSBv0UhCPstKeXUzM/hfkaB6rl/b7b3+wqVzTDtP/s63CVvdvk0rQTMtDIwY+UPn6ow==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8J/41ttcCcFSVgxTVEsbFQ2hRlnXPF4JeFyTEvfv1o8P/TSyb
	+944EDfVNuaDu+x4V4Oez/znvjR3Vm8kNrPjB/y21rKWW3zbuZg298P5U5a6mDj9nqG2VuLCqpg
	5x9dEwBz/gEMfyc5zWTIj46PJbLDfZVDi
X-Gm-Gg: ASbGncv5I83PLV7/kgIY2bnOAppvfOP271zQSwYgL1Llc0p9J0EsUT/3T+OWk3RmDHx
	lt5UGHZ2AEk7EtY9PK8XGSZ2bpeKKdZWzfq+MiRt2DtG1Nl0XIDFT6ifChNP5cPpg++A0NNjxcS
	cg/09N6d0R5ckehtxVSHOPGbcou875GSQxFXdO6tdmImym5IgvpPGHDD/FtLPQ49Vbrn02AscAj
	w6lHs4xrfM0YYL/MVnRO2ecc4B7JHll05JJd3tkWhfJvtsB5RXzXmb2/in1aHXpz5gLms1KWn/h
	bozzJSv2cax9DUwtPWJ/xvm8OPrPM+MRXgAH50J+lkDYhHBT
X-Google-Smtp-Source: AGHT+IE12R3vBd9KmQtvrZk87CCQk21F2844/VQ6rL9De9RQ1rDN0EpXVNVc3dxmtWCMWiJIkiRKQtXilAro
X-Received: by 2002:a05:6602:15d2:b0:85a:e406:5836 with SMTP id ca18e2360f4ac-85e83e70bd4mr224753739f.5.1743176829103;
        Fri, 28 Mar 2025 08:47:09 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id 8926c6da1cb9f-4f46486e230sm268228173.45.2025.03.28.08.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 08:47:09 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 793B034018F;
	Fri, 28 Mar 2025 09:47:08 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 73065E40A9F; Fri, 28 Mar 2025 09:47:08 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Chaitanya Kulkarni <kch@nvidia.com>,
	linux-nvme@lists.infradead.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v4 0/3] nvme_map_user_request() cleanup
Date: Fri, 28 Mar 2025 09:46:44 -0600
Message-ID: <20250328154647.2590171-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The first commit removes a WARN_ON_ONCE() checking userspace values.
The last 2 move code out of nvme_map_user_request() that belongs better
in its callers, and move the fixed buffer import before going async.
As discussed in [1], this allows an NVMe passthru operation submitted at
the same time as a ublk zero-copy buffer unregister operation to succeed
even if the initial issue goes async. This can improve performance of
userspace applications submitting the operations together like this with
a slow fallback path on failure. This is an alternate approach to [2],
which moved the fixed buffer import to the io_uring layer.

There will likely be conflicts with the parameter cleanup series Keith
posted last month in [3].

The series is based on for-6.15/io_uring, with commit 00817f0f1c45
("nvme-ioctl: fix leaked requests on mapping error") cherry-picked.

[1]: https://lore.kernel.org/io-uring/20250321184819.3847386-1-csander@purestorage.com/T/#u
[2]: https://lore.kernel.org/io-uring/20250321184819.3847386-4-csander@purestorage.com/
[3]: https://lore.kernel.org/all/20250224182128.2042061-1-kbusch@meta.com/T/#u

v4:
- Preserve the order of blk_mq_free_request() and nvme_passthru_end()
- Add Reviewed-by tags

v3: Move the fixed buffer import before allocating a blk-mq request

v2: Fix iov_iter value passed to nvme_map_user_request()

Caleb Sander Mateos (3):
  nvme/ioctl: don't warn on vectorized uring_cmd with fixed buffer
  nvme/ioctl: move blk_mq_free_request() out of nvme_map_user_request()
  nvme/ioctl: move fixed buffer lookup to nvme_uring_cmd_io()

 drivers/nvme/host/ioctl.c | 68 +++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 31 deletions(-)

-- 
2.45.2


