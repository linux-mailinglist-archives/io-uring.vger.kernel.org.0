Return-Path: <io-uring+bounces-8811-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0DDAB13970
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 13:03:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C24F3BD1A5
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 11:02:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90B9C194A65;
	Mon, 28 Jul 2025 11:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WRftoPM8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE69A93D;
	Mon, 28 Jul 2025 11:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753700593; cv=none; b=HqFMmRey3ox/qgFjJPLWI44IiNXguufiESPkJsrRGAR+VLWMw+LokotRoS5/Bo/KHoqxh/83GRuGKTwjF4XosPBc2Z2Q0VQGtVl3cP6qynlRClNNDsM4utPY9iQ4T5zC01UeRBB7QmGHLwgdqpwHVMhtwn9Mxw3kL+I6x5nX4QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753700593; c=relaxed/simple;
	bh=Whmv3tqtRmgJiIYGELeIAXSeuGj1Kz1NncnO4kIgxzE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dx/bmmFuzhbkNwOZ+QDQc0JVL5P0+l1SewTKoXuRS0198J/M9zRPj8vpecCiauBsH9863EdVLTlBNNkCJ5TBwYFVXo8fByhgTuPsrCVujAQMwnuw1KcwU3kKFtJhf+u1vFwlVZQVInNNNvN5PKdjUq41evTZHLIKqFj7CUd3oD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WRftoPM8; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45629703011so29801445e9.0;
        Mon, 28 Jul 2025 04:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753700590; x=1754305390; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1jowSLaKN/Ws9H5lAIY2Dr86ADPi/3uIFM3SGpEqovg=;
        b=WRftoPM87RIAqGC9Vbo4VXHhfyhp+Qu8tcTdqRCDUAcq91v5+UzgRlhR6A+IcV/PBo
         HXVhZyimp7HI6AUBwXaXtmXBeirUM4DCJPY7MpjOH+Zz1J0OxReLf3eB3Jmgv8sSbEoI
         NdBP3iju/JuS7hjCVVWOPbGNE4+OM4Ic2E2mhDW4n++I/JCbbqVBSt/oYCBYmrZvy0xd
         65BGEO8mkg59iEV+rUXlWYPQtpZ4DPV3IvGq/7GEmPZs3hk1f5jxpIbKR89CaddVZRjD
         cTMxefZSrfJV6CGqKQGo0ZQykQv5UVCZeWlmYk1D0CgXhXFD/XTDlWRQUK3Bt4GF5LYt
         IH+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753700590; x=1754305390;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1jowSLaKN/Ws9H5lAIY2Dr86ADPi/3uIFM3SGpEqovg=;
        b=CFulc+fBkzqPLfXebLzRlFiAKhnDXAWw7IAvQjwVto9UBoNu3TwwoBpXuBojYmjgrm
         7MhKXNbQUe+uiOHpK2rEHkWqFtPH7EPonZUW4O+Gd/f+TcbuVsbHDnQRrJoolVtgjGtP
         s5vYxUK7P/eSMzp2nbmdIsRcPxRFque8ZKZgv1nXGxLkMd8353sW5i1Fp4K6vTp///H6
         +ddAzblG+XeiB9rdZ6df8CixGC2/aeHZIKLLoLKx8JNv9n0GSlvZTI09z/p9XZ6PGFsp
         tm+nwWG7KXalwe2JFIPnDO58ZyvDfui+R76pBmGqC1XGrBL0tnGxeyjn/wNudluFqq6B
         xpiw==
X-Forwarded-Encrypted: i=1; AJvYcCVjJuQCvAiqhfT8+M/UhrfnX/yhjVfFeMiVOtIBEV1uZ97Y9qe224Lmxy40v5g7w+s5gIsbMgWo@vger.kernel.org, AJvYcCXGcslCAQpLuOfdph47Whk1/iAJmCJoNdlZknUNLHvP1rCgBx0U9MsGevG4lNZUqTs1Zty0qRAkaA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzg4tjaIeIgv6itDfpc4MKRCiOM4FKDwcUxZ8GQjYHJe5j3Mwis
	YERuo0uZ08D7EZNWfaA43IKcyyx47OjIvNoF5qqKnIAUNzFHCoMuO2EOXitYnw==
X-Gm-Gg: ASbGncvK35Z6Iw0Onv8BJPamC+y+6tQ3tYcCH8eaSFVcoGoQrkuOsl9mOELH3zYSzZG
	pd5Bd4py30rFE4kd2kTXMpg5LPlRpVUi3EwczIju1+7FxNhig6GJ6Px2Hvcyrjwk+XkixMlPUHM
	AmNYmFYTh1CKUPfoWMw8ExzpgztALn+i2YoFykQAPGZuqZt3oSsRpurdTB2n8HBo34QFled5mmT
	siO+4+bNxxwlzddK9ZJxDYRDYx1QJ0TaeagXBRbu13adHTEiSUt9V4s1WA5lo8CmVFH5OQvxGMZ
	U0FMdmdrJq5IZN6Vf+QeTt1zXTZUuG9nzQeYVWlVHkGccyELTcSwUrtxUVWwIAKOKVKXy/e8qfv
	Pbew=
X-Google-Smtp-Source: AGHT+IFK8A6k9Kuo6xoPlzvlrtA0my4NBoo1/XDe13FIsLcIqwMyfcT2Ow9Ng+etE3ZWGv/GTb0uPg==
X-Received: by 2002:a05:600c:3592:b0:456:fc1:c286 with SMTP id 5b1f17b1804b1-45884b0d501mr23768375e9.1.1753700589515;
        Mon, 28 Jul 2025 04:03:09 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:75])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4fdasm157410235e9.28.2025.07.28.04.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 04:03:08 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org
Cc: asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	andrew+netdev@lunn.ch,
	horms@kernel.org,
	davem@davemloft.net,
	sdf@fomichev.me,
	almasrymina@google.com,
	dw@davidwei.uk,
	michael.chan@broadcom.com,
	dtatulea@nvidia.com,
	ap420073@gmail.com
Subject: [RFC v1 00/22] Large rx buffer support for zcrx
Date: Mon, 28 Jul 2025 12:04:04 +0100
Message-ID: <cover.1753694913.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series implements large rx buffer support for io_uring/zcrx on
top of Jakub's queue configuration changes, but it can also be used
by other memory providers. Large rx buffers can be drastically
beneficial with high-end hw-gro enabled cards that can coalesce traffic
into larger pages, reducing the number of frags traversing the network
stack and resuling in larger contiguous chunks of data for the
userspace. Benchamrks showed up to ~30% improvement in CPU util.

For example, for 200Gbit broadcom NIC, 4K vs 32K buffers, and napi and
userspace pinned to the same CPU:

packets=23987040 (MB=2745098), rps=199559 (MB/s=22837)
CPU    %usr   %nice    %sys %iowait    %irq   %soft   %idle
  0    1.53    0.00   27.78    2.72    1.31   66.45    0.22
packets=24078368 (MB=2755550), rps=200319 (MB/s=22924)
CPU    %usr   %nice    %sys %iowait    %irq   %soft   %idle
  0    0.69    0.00    8.26   31.65    1.83   57.00    0.57

And for napi and userspace on different CPUs:

packets=10725082 (MB=1227388), rps=198285 (MB/s=22692)
CPU    %usr   %nice    %sys %iowait    %irq   %soft   %idle
  0    0.10    0.00    0.50    0.00    0.50   74.50    24.40
  1    4.51    0.00   44.33   47.22    2.08    1.85    0.00
packets=14026235 (MB=1605175), rps=198388 (MB/s=22703)
CPU    %usr   %nice    %sys %iowait    %irq   %soft   %idle
  0    0.10    0.00    0.70    0.00    1.00   43.78   54.42
  1    1.09    0.00   31.95   62.91    1.42    2.63    0.00

Patch 19 allows to pass queue config from a memory provider. The
zcrx changes are contained in a single patch as I already queued
most of work making it size agnostic into my zcrx branch. The
uAPI is simple and imperative, it'll use the exact value (if)
specified by the user. In the future we might extend it to
"choose the best size in a given range".

The rest (first 20) patches are from Jakub's series implementing
per queue configuration. Quoting Jakub:

"... The direct motivation for the series is that zero-copy Rx queues would
like to use larger Rx buffers. Most modern high-speed NICs support HW-GRO,
and can coalesce payloads into pages much larger than than the MTU.
Enabling larger buffers globally is a bit precarious as it exposes us
to potentially very inefficient memory use. Also allocating large
buffers may not be easy or cheap under load. Zero-copy queues service
only select traffic and have pre-allocated memory so the concerns don't
apply as much.

The per-queue config has to address 3 problems:
- user API
- driver API
- memory provider API

For user API the main question is whether we expose the config via
ethtool or netdev nl. I picked the latter - via queue GET/SET, rather
than extending the ethtool RINGS_GET API. I worry slightly that queue
GET/SET will turn in a monster like SETLINK. OTOH the only per-queue
settings we have in ethtool which are not going via RINGS_SET is
IRQ coalescing.

My goal for the driver API was to avoid complexity in the drivers.
The queue management API has gained two ops, responsible for preparing
configuration for a given queue, and validating whether the config
is supported. The validating is used both for NIC-wide and per-queue
changes. Queue alloc/start ops have a new "config" argument which
contains the current config for a given queue (we use queue restart
to apply per-queue settings). Outside of queue reset paths drivers
can call netdev_queue_config() which returns the config for an arbitrary
queue. Long story short I anticipate it to be used during ndo_open.

In the core I extended struct netdev_config with per queue settings.
All in all this isn't too far from what was there in my "queue API
prototype" a few years ago ..."


Kernel branch with all dependencies: 
git: https://github.com/isilence/linux.git zcrx/large-buffers
url: https://github.com/isilence/linux/tree/zcrx/large-buffers

Jakub Kicinski (20):
  docs: ethtool: document that rx_buf_len must control payload lengths
  net: ethtool: report max value for rx-buf-len
  net: use zero value to restore rx_buf_len to default
  net: clarify the meaning of netdev_config members
  net: add rx_buf_len to netdev config
  eth: bnxt: read the page size from the adapter struct
  eth: bnxt: set page pool page order based on rx_page_size
  eth: bnxt: support setting size of agg buffers via ethtool
  net: move netdev_config manipulation to dedicated helpers
  net: reduce indent of struct netdev_queue_mgmt_ops members
  net: allocate per-queue config structs and pass them thru the queue
    API
  net: pass extack to netdev_rx_queue_restart()
  net: add queue config validation callback
  eth: bnxt: always set the queue mgmt ops
  eth: bnxt: store the rx buf size per queue
  eth: bnxt: adjust the fill level of agg queues with larger buffers
  netdev: add support for setting rx-buf-len per queue
  net: wipe the setting of deactived queues
  eth: bnxt: use queue op config validate
  eth: bnxt: support per queue configuration of rx-buf-len

Pavel Begunkov (2):
  net: parametrise mp open with a queue config
  io_uring/zcrx: implement large rx buffer support

 Documentation/netlink/specs/ethtool.yaml      |   4 +
 Documentation/netlink/specs/netdev.yaml       |  15 ++
 Documentation/networking/ethtool-netlink.rst  |   7 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 135 ++++++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   5 +-
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |   9 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |   6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h |   2 +-
 drivers/net/ethernet/google/gve/gve_main.c    |   9 +-
 .../marvell/octeontx2/nic/otx2_ethtool.c      |   6 +-
 drivers/net/netdevsim/netdev.c                |   8 +-
 include/linux/ethtool.h                       |   3 +
 include/net/netdev_queues.h                   |  83 ++++++++--
 include/net/netdev_rx_queue.h                 |   3 +-
 include/net/netlink.h                         |  19 +++
 include/net/page_pool/memory_provider.h       |   4 +-
 .../uapi/linux/ethtool_netlink_generated.h    |   1 +
 include/uapi/linux/io_uring.h                 |   2 +-
 include/uapi/linux/netdev.h                   |   2 +
 io_uring/zcrx.c                               |  39 ++++-
 net/core/Makefile                             |   2 +-
 net/core/dev.c                                |  12 +-
 net/core/dev.h                                |  12 ++
 net/core/netdev-genl-gen.c                    |  15 ++
 net/core/netdev-genl-gen.h                    |   1 +
 net/core/netdev-genl.c                        |  92 +++++++++++
 net/core/netdev_config.c                      | 150 ++++++++++++++++++
 net/core/netdev_rx_queue.c                    |  54 +++++--
 net/ethtool/common.c                          |   4 +-
 net/ethtool/netlink.c                         |  14 +-
 net/ethtool/rings.c                           |  14 +-
 tools/include/uapi/linux/netdev.h             |   2 +
 32 files changed, 642 insertions(+), 92 deletions(-)
 create mode 100644 net/core/netdev_config.c

-- 
2.49.0


