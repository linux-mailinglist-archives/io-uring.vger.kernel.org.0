Return-Path: <io-uring+bounces-9015-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 28CC3B2A880
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 16:06:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A80761BA51A9
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 13:57:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 138932C235C;
	Mon, 18 Aug 2025 13:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LBpkvh3U"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1146C21CC55;
	Mon, 18 Aug 2025 13:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525394; cv=none; b=u65g64sS6UvzsWepd9dzgJbwJ0w1kQPlVk0TD3h/NecywOnNewdjSlTwxjHh7OAk/Nogjt2K+XF1et+i5Iz4Y4A3NEK9g19+TmaGBFlm7YsYRIxOQjXK6e4rXmI7TKYj+wsCFAgRDjK+hR9z0vGTMVm+3CG2wTqbCPvS6wjkhVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525394; c=relaxed/simple;
	bh=WhJVNeSStiv+lvOcXcU3zfjW9jbIie7z1H0GF6hbESg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=otH3cU3aUQWcX51dEnSD4Osn3G9jvwSiG5pSiW1ytYrNU0B01ogcQIsLZQRxCKjLb1sApIBKnnaZRuWLUX0Mtirdh3ufie8xuq96Hm5BX52MoNCDxJrV5gRWd310g+T+0/on3GE6dxet2W1H6sajOMDCfVvsJ99NFbQHdiqtNRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LBpkvh3U; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3b9e41669d6so3288880f8f.2;
        Mon, 18 Aug 2025 06:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755525390; x=1756130190; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HIjGtIzogKi0vJY5xlfW/RJoJSvH8HUexozUhmGaN+Q=;
        b=LBpkvh3U0atrnqg6BW2fG6GwWtU+TnVG0Nd0HTcf+hUJbGsw+Da+CTbfCuKNe3GxTa
         Qr12Cbddg6q67SXYfuXSHJ5A+bDyYUwCFFHvGgER2vQcFjRYOnVyJmHt6wse4Ejd/t3O
         FU9Uuul+ctA9+SCDhz8hUmKVI/GWI772Lxdx6Kwnc3yE8Ap5iS6OabScLlc4KDxOUq1W
         aKjUNVU5Dx1P0qlCzCBaQlQLX4HdBR0jwTpL/N+MgYZSDuCXYuRbNFG2Us2DV8YNI9PE
         2aiKxAPTA0dXKqlDF9/O+fFTimvpIiSQPEJcK7dvqpUsgt8m3E4fmA83osDzZGSujvcR
         SFRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755525390; x=1756130190;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HIjGtIzogKi0vJY5xlfW/RJoJSvH8HUexozUhmGaN+Q=;
        b=MfxKqMi/ZJzH1dycZtjk9O8CP2/PmzgFU2UEengwOPq/nFDw2nu9DYjR6/epMp8rN+
         MJ48GfMkl+Zq4Z3xO9YqoMrERlzJTfjPWwwfaa8uMewdvJ2YA0ns9l7r/TCyB+VY8Ii4
         Hl9AsEmTUaGTh35Z3Ex5iKDgpGgmz16FbHNSxBINF9f30ZOnskQfsFA0VpeKQD3S8X0m
         Nn96Ht6+BPEpHCeiEWZLyOiku4cp7osvBns9AFVW9+Fisc6rPbMoMpJfQzXJaK5enjE6
         2KPXf92T1utWzEwsVJbaO5tdciZQKueSHXjgoimPolq4kzM9rNofrX2xNyIgB+RWWXAD
         TUmA==
X-Forwarded-Encrypted: i=1; AJvYcCWEXbfgE79FSfH0oDNnZ6Z1WIa9NNlzTeX23JnTjYH9qrvbNxTdK8VUzgKhjVGc4zSrMUvq/kNCKA==@vger.kernel.org, AJvYcCWn53sd5Y76Ixf7VxyKnC6Q9ZlQeQ/EaZAnDsKjs9EEypZM6uXWpuz9RvWLu4q16zzI9268S6Aicv1qefaZ@vger.kernel.org, AJvYcCWrgYoCd1NRCaVyYECO2RjnXjFqPlwNf3uxdTfhup1mCo4ECXkf8/r5KUd0XxBcI6+tFUVqfRNe@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9jCU0psrZ5IoDwj1O9efLPe0cFhYohjRS8iWqKbr27wszezr8
	W8H1uZny8mzXrI1bQ//rmHjol/RsMD78vjckp49ohpt1zH3cIk0q0hIl
X-Gm-Gg: ASbGncuNBOjphkbA4Fudvp9YSIa8RAFc2/KrHam174p1Cw9IJe4nJ6JlnZFvSN9dBOc
	4BsprSXDh67wTZweKl4VFW3YK3BG27JMMyLaGGgvpYvOK1PCjoDRK2nTo3s6X292eLbstX3hH3O
	gsKjo0wnNE9J/fjvYvP0UYn+mjaZID2t8JZKxfLuVvIRn3b4pvu6ZRV8CzpLcNkjse51k/0UMSX
	LUXnTipB9XMOPnjBALzltJd4Pao9Gx1hYKkK/dUO2AvSIIEAYtIvBwjUq83lfAlZW8yQPgc772t
	lkt46XHGsuBzxIuXNKFZKTaeSYsOCn+tTC4uViZ9AxP97DyYgTZmrux63M/0xOA4OTAN0EjRkMY
	qa/1+wmx1q7bNGCqt5Kh6UgK1u66NN3pfog==
X-Google-Smtp-Source: AGHT+IFITBu4xmm3trvkM7QeONfVwuLd61rclbo1mHoQfU27oRMWWeC93+mJ/tL09P7hnZHPJhojFA==
X-Received: by 2002:a05:6000:1a8c:b0:3b9:13e4:9693 with SMTP id ffacd0b85a97d-3bc6a74837bmr7035633f8f.52.1755525390079;
        Mon, 18 Aug 2025 06:56:30 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b899338sm91187345e9.7.2025.08.18.06.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 06:56:29 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org
Cc: asml.silence@gmail.com,
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
	ap420073@gmail.com,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [PATCH net-next v3 00/23][pull request] Queue configs and large buffer providers
Date: Mon, 18 Aug 2025 14:57:16 +0100
Message-ID: <cover.1755499375.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pull request with netdev only patches that add support for per queue
configuration and large rx buffers for memory providers. The zcrx
patch using it is separately and can be found at [2].

Large buffers yielded significant benefits during testing, e.g.
a setup with 32KB buffers was using 30% less CPU than with 4K,
see [3] for more details.

Per queue configuration series:
[1] https://lore.kernel.org/all/20250421222827.283737-1-kuba@kernel.org/
Branch with the zcrx patch
[2] https://github.com/isilence/linux.git zcrx/large-buffers-v3
v2 of the series
[3] https://lore.kernel.org/all/cover.1754657711.git.asml.silence@gmail.com/

---

v3: - rebased, excluded zcrx specific patches
    - set agg_size_fac to 1 on warning
v2: - Add MAX_PAGE_ORDER check on pp init (Patch 1)
    - Applied comments rewording (Patch 2)
    - Adjust pp.max_len based on order (Patch 8)
    - Patch up mlx5 queue callbacks after rebase (Patch 12)
    - Minor ->queue_mgmt_ops refactoring (Patch 15)
    - Rebased to account for both fill level and agg_size_fac (Patch 17)
    - Pass providers buf length in struct pp_memory_provider_params and
      apply it in __netdev_queue_confi(). (Patch 22)
    - Use ->supported_ring_params to validate drivers support of set
      qcfg parameters. (Patch 23)

The following changes since commit c17b750b3ad9f45f2b6f7e6f7f4679844244f0b9:

  Linux 6.17-rc2 (2025-08-17 15:22:10 -0700)

are available in the Git repository at:

  https://github.com/isilence/linux.git tags/net-for-6.18-queue-rx-buf-len

for you to fetch changes up to 417cf28f3bf129d1a0d1b231220aa045abac3263:

  net: validate driver supports passed qcfg params (2025-08-18 07:39:50 +0100)

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
      net: allocate per-queue config structs and pass them thru the queue API
      net: pass extack to netdev_rx_queue_restart()
      net: add queue config validation callback
      eth: bnxt: always set the queue mgmt ops
      eth: bnxt: store the rx buf size per queue
      eth: bnxt: adjust the fill level of agg queues with larger buffers
      netdev: add support for setting rx-buf-len per queue
      net: wipe the setting of deactived queues
      eth: bnxt: use queue op config validate
      eth: bnxt: support per queue configuration of rx-buf-len

Pavel Begunkov (3):
      net: page_pool: sanitise allocation order
      net: let pp memory provider to specify rx buf len
      net: validate driver supports passed qcfg params

 Documentation/netlink/specs/ethtool.yaml           |   4 +
 Documentation/netlink/specs/netdev.yaml            |  15 ++
 Documentation/networking/ethtool-netlink.rst       |   7 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 143 ++++++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   5 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   9 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |   6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h      |   2 +-
 drivers/net/ethernet/google/gve/gve_main.c         |   9 +-
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   9 +-
 drivers/net/netdevsim/netdev.c                     |   8 +-
 include/linux/ethtool.h                            |   3 +
 include/net/netdev_queues.h                        |  84 ++++++++--
 include/net/netdev_rx_queue.h                      |   3 +-
 include/net/netlink.h                              |  19 +++
 include/net/page_pool/types.h                      |   1 +
 include/uapi/linux/ethtool_netlink_generated.h     |   1 +
 include/uapi/linux/netdev.h                        |   2 +
 net/core/Makefile                                  |   2 +-
 net/core/dev.c                                     |  12 +-
 net/core/dev.h                                     |  15 ++
 net/core/netdev-genl-gen.c                         |  15 ++
 net/core/netdev-genl-gen.h                         |   1 +
 net/core/netdev-genl.c                             |  92 +++++++++++
 net/core/netdev_config.c                           | 183 +++++++++++++++++++++
 net/core/netdev_rx_queue.c                         |  22 ++-
 net/core/page_pool.c                               |   3 +
 net/ethtool/common.c                               |   4 +-
 net/ethtool/netlink.c                              |  14 +-
 net/ethtool/rings.c                                |  14 +-
 tools/include/uapi/linux/netdev.h                  |   2 +
 32 files changed, 631 insertions(+), 84 deletions(-)
 create mode 100644 net/core/netdev_config.c

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

Pavel Begunkov (3):
  net: page_pool: sanitise allocation order
  net: let pp memory provider to specify rx buf len
  net: validate driver supports passed qcfg params

 Documentation/netlink/specs/ethtool.yaml      |   4 +
 Documentation/netlink/specs/netdev.yaml       |  15 ++
 Documentation/networking/ethtool-netlink.rst  |   7 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 143 +++++++++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   5 +-
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |   9 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |   6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h |   2 +-
 drivers/net/ethernet/google/gve/gve_main.c    |   9 +-
 .../marvell/octeontx2/nic/otx2_ethtool.c      |   6 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   9 +-
 drivers/net/netdevsim/netdev.c                |   8 +-
 include/linux/ethtool.h                       |   3 +
 include/net/netdev_queues.h                   |  84 ++++++--
 include/net/netdev_rx_queue.h                 |   3 +-
 include/net/netlink.h                         |  19 ++
 include/net/page_pool/types.h                 |   1 +
 .../uapi/linux/ethtool_netlink_generated.h    |   1 +
 include/uapi/linux/netdev.h                   |   2 +
 net/core/Makefile                             |   2 +-
 net/core/dev.c                                |  12 +-
 net/core/dev.h                                |  15 ++
 net/core/netdev-genl-gen.c                    |  15 ++
 net/core/netdev-genl-gen.h                    |   1 +
 net/core/netdev-genl.c                        |  92 +++++++++
 net/core/netdev_config.c                      | 183 ++++++++++++++++++
 net/core/netdev_rx_queue.c                    |  22 ++-
 net/core/page_pool.c                          |   3 +
 net/ethtool/common.c                          |   4 +-
 net/ethtool/netlink.c                         |  14 +-
 net/ethtool/rings.c                           |  14 +-
 tools/include/uapi/linux/netdev.h             |   2 +
 32 files changed, 631 insertions(+), 84 deletions(-)
 create mode 100644 net/core/netdev_config.c

-- 
2.49.0


