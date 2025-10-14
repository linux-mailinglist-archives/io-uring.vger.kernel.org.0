Return-Path: <io-uring+bounces-9994-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 131BCBD97F6
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 15:00:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4DF97192798A
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 13:00:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61F6B2116F4;
	Tue, 14 Oct 2025 13:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="epqoEHI6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823551E260C
	for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 13:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760446832; cv=none; b=dg9JBafHU0RL8CQyDSRjbCzM7RmGW86572ogwCfPbiH1crCXAHWaBQsVyQXWesG3SlVRsiJP1pirinDRL8LzwPiDFgXmkvFmvNaKRc1na9wm8F3rKXnREWhU8I0mnGAYOkUazDkpo/7FDK///C3prg+nsvJdER0jjZyKyIXgMJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760446832; c=relaxed/simple;
	bh=yC16Cf9FMJscSBzx0tg70+ZAO1nULgzq46Rq7RWDwRk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZJqqJWHmk6+IR1zavmn96/JfNhuNbc/xmGUaf7ZgVr6lGTg3UlpZ1+kWLrMPyL2bYCU/wv5cDEhN+lRnLaN2M1XwD8uMEyqzpZdiYaa4iWumO2si6+MRGPPmkt/NP0i5jRzmAO98gij8Jhx02wkg5ODtWasMPLB0RpoSiu9Z058=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=epqoEHI6; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3f0308469a4so2906109f8f.0
        for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 06:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760446829; x=1761051629; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=drtmDZAOmuCnQVy+ATNHRyErjp9xi9I5nuXjriiDL/I=;
        b=epqoEHI6UasjISOjXZQ5jSX+wK5NAIYmDIcr8EBc1M4BHt4ZYNokrEpVkU1XrNBayS
         PdsasiSjsXFQ1rv7m9urjGR+eAN9YCah8FJTySyNgyUQr/+3Q8A/qH372S00H2leXvX0
         sllY2k9gE8Y73a+1RpJGW0UtpkY0/uo3Cl/gAxVGxoQYnd+6BzImW/OFeT4JkcatAIwa
         IL97z2hCxTbHiJl/VBCVudgqBzK+F3+q3kMBwsYvDzgiuWtYPXylJ2V3TC4g3JQ48slv
         6Hb/mK3Zk+FkEgTc/J7XO5Qo5IRM8sxCxZVnY0tleD1sVjOM58AkBewfMiM5gCYwJToE
         OJlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760446829; x=1761051629;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=drtmDZAOmuCnQVy+ATNHRyErjp9xi9I5nuXjriiDL/I=;
        b=QRzNw9xf3/irvGXgyIuGhn4RHqcNxVrjIFvXoEbh6ZX/ZdG3kQkmWea0VWlntEdKft
         YzB/OuIyEX7RHqCO8C3Q0PjFy89Q5XbeYjsmlvWTifGq6x6ynBWrAE2VWCD66AQ7kj62
         p4OKFym2WEzdG1CD//mAJs05UWLFXLOVoGhiDpUafogXnGKYwAfliS7HJ1c9jLXDR/Ew
         ul+9q3xouK7Q3arhUDx71ANNCT5bBSBR1UZu44NTiLC6RKIlySLEMiH24rJCC4O3uPKh
         fzYmm7lc0k3hYQujtVbxbt0Ql+F3siDiIzpxmDOJBYBqT51VnPfp1Nd7wTa+tCKDQDH3
         /bXg==
X-Forwarded-Encrypted: i=1; AJvYcCVN7IqjBmuWWLl7QGeV7yVKF1uABM/l+xoiWtCroftE2vr2lW5fBEcFeBDbBaSvfvaICiTe6ksh2A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwBQbOEWDIbkQVd6tAkVBQ/57I3dgPzS0ozbOLaU+24n8cuhr3f
	S2ExJ7+WJs/VwrkPubAbASR1Tm1qHiEdPB/TdN1xS9W3bKqQ11hcA6iS
X-Gm-Gg: ASbGnct39jo6qlWdrgJpWr/IwxVNQHTsUXmR1iNcWH4xtzBWKWGwUoFxs2QvKZJG17O
	Z7XHCUxW8SyowoK+At8wBD02dUBdq8vUmiBsblvMxiIn2WJPQ6TSBxQlqKXVYcFkFOCp+41e++r
	NWSSTJ+aQ7/LK7Dx90Jl4E/PI0ZgPf82UEQApvfjEumxW0HW2zwfrFc7PVFTUkomKe9dgm78URw
	C69Sjx56/BqbnCb7n/uwZnBmNnYJbQIQLOkQTbN43xwdomeLzK9ywR4PGKANo6Cbfyv+kwXoJk9
	h0pivION0NPQpnqlIEqNwAf7jV8632Rf9RDbPB1hzl5sqBP290+G3kNf46g9Pzdid1ru1Vnge+1
	vsFr2p5O/K398e5UcixqRzpHzWPEyJSLZZsg=
X-Google-Smtp-Source: AGHT+IGQ0Gd56K7JwPfQZZ3tAk3u4pF1GdKS8UOWl4Tdgb55qv85ApxtPpM/O9AT16A2P/7TiGsfKw==
X-Received: by 2002:a05:6000:26d0:b0:425:8bf9:557d with SMTP id ffacd0b85a97d-4266e8dd3c2mr17404314f8f.44.1760446823887;
        Tue, 14 Oct 2025 06:00:23 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:7ec0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce582b39sm23296494f8f.15.2025.10.14.06.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 06:00:22 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: netdev@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Simon Horman <horms@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Mina Almasry <almasrymina@google.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	David Wei <dw@davidwei.uk>,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v5 00/24][pull request] Add support for providers with large rx buffer
Date: Tue, 14 Oct 2025 14:01:20 +0100
Message-ID: <cover.1760440268.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Many modern network cards support configurable rx buffer lengths larger
than typically used PAGE_SIZE. When paired with hw-gro larger rx buffer
sizes can drastically reduce the number of buffers traversing the stack
and save a lot of processing time. Another benefit for memory providers
like zcrx is that the userspace will be getting larger contiguous chunks
as well.

This series adds net infrastructure for memory providers configuring
the size and implements it for bnxt. It'll be used by io_uring/zcrx,
which is intentionally separated to simplify merging. You can find
a branch that includes zcrx changes at [1] and an example liburing
program at [3].

It's an opt-in feature for drivers, they should advertise support for
the parameter in the qops and must check if the hardware supports
the given size. It's limited to memory providers as it drastically
simplifies the series comparing with previous revisions and detangles
it from ethtool api discussions.

The idea was first floated around by Saeed during netdev conf 2024.
The series also borrows some patches from [2].

Benchmarks with zcrx [3] show up to ~30% improvement in CPU util.
E.g. comparison for 4K vs 32K buffers using a 200Gbit NIC, napi and
userspace pinned to the same CPU:

packets=23987040 (MB=2745098), rps=199559 (MB/s=22837)
CPU    %usr   %nice    %sys %iowait    %irq   %soft   %idle
  0    1.53    0.00   27.78    2.72    1.31   66.45    0.22
packets=24078368 (MB=2755550), rps=200319 (MB/s=22924)
CPU    %usr   %nice    %sys %iowait    %irq   %soft   %idle
  0    0.69    0.00    8.26   31.65    1.83   57.00    0.57

netdev + zcrx changes:
[1] https://github.com/isilence/linux.git zcrx/large-buffers-v5
Per queue configuration series:
[2] https://lore.kernel.org/all/20250421222827.283737-1-kuba@kernel.org/
Liburing example:
[3] https://github.com/isilence/liburing.git zcrx/rx-buf-len

---
The following changes since commit 3a8660878839faadb4f1a6dd72c3179c1df56787:

  Linux 6.18-rc1 (2025-10-12 13:42:36 -0700)

are available in the Git repository at:

  https://github.com/isilence/linux.git tags/net-for-6.19-queue-rx-buf-len-v5

for you to fetch changes up to f389276330412ec4305fb423944261e78490f06a:

  eth: bnxt: allow providers to set rx buf size (2025-10-14 00:11:59 +0100)


v5: Remove all unnecessary bits like configuration via netlink, and
    multi-stage queue configuration.

v4: https://lore.kernel.org/all/cover.1760364551.git.asml.silence@gmail.com/
    - Update fbnic qops
    - Propagate max buf len for hns3
    - Use configured buf size in __bnxt_alloc_rx_netmem
    - Minor stylistic changes
v3: https://lore.kernel.org/all/cover.1755499375.git.asml.silence@gmail.com/
    - Rebased, excluded zcrx specific patches
    - Set agg_size_fac to 1 on warning
v2: https://lore.kernel.org/all/cover.1754657711.git.asml.silence@gmail.com/
    - Add MAX_PAGE_ORDER check on pp init
    - Applied comments rewording
    - Adjust pp.max_len based on order
    - Patch up mlx5 queue callbacks after rebase
    - Minor ->queue_mgmt_ops refactoring
    - Rebased to account for both fill level and agg_size_fac
    - Pass providers buf length in struct pp_memory_provider_params and
      apply it in __netdev_queue_confi().
    - Use ->supported_ring_params to validate drivers support of set
      qcfg parameters.

Jakub Kicinski (1):
  eth: bnxt: adjust the fill level of agg queues with larger buffers

Pavel Begunkov (5):
  net: page_pool: sanitise allocation order
  net: memzero mp params when closing a queue
  net: let pp memory provider to specify rx buf len
  eth: bnxt: store rx buffer size per queue
  eth: bnxt: allow providers to set rx buf size

 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 118 ++++++++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |   6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h |   2 +-
 include/net/netdev_queues.h                   |   9 ++
 include/net/page_pool/types.h                 |   1 +
 net/core/netdev_rx_queue.c                    |  14 ++-
 net/core/page_pool.c                          |   3 +
 8 files changed, 118 insertions(+), 37 deletions(-)

-- 
2.49.0


