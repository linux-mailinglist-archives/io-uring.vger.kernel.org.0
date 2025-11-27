Return-Path: <io-uring+bounces-10824-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D9D98C90238
	for <lists+io-uring@lfdr.de>; Thu, 27 Nov 2025 21:44:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 57CDB350454
	for <lists+io-uring@lfdr.de>; Thu, 27 Nov 2025 20:44:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEEFD314D06;
	Thu, 27 Nov 2025 20:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MtnF1z11"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0A93016FB
	for <io-uring@vger.kernel.org>; Thu, 27 Nov 2025 20:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764276273; cv=none; b=NC6iMV/QZNu8d5O7lJ+x1lBV1S0xfO6D48NOMDvdACL+DSaDqL4cOKa7++2pLKSVulqAER/3HajYjzklp20Z7LNYaxhRqkadICBQqwpKPbiZNHn6VzZkER9AP7lSrsBdw/PG05AVdr3aRRlpckESRJtGYu56gbucSDHcUOG2ZbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764276273; c=relaxed/simple;
	bh=/EjJ09gOItV7saCsoFehzrNjoCEq456We2WFPrNbPig=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rsDPcEz4XLMHBPmwYjOnmkF9t3Y6408GxzEtVxdP/YHwx6nd/bZwy20zE0f5jpi3SZmC9qYa/0TLTJ93AZxL15+c5suSPXbxW24dlnV7OgTOlNNh1HMHOHsBFmqcHEaXq+aEH0YTqiVImuly5OZiQtdHO+AaQXV7Wt67UI33zhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MtnF1z11; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42bb288c1bfso729247f8f.2
        for <io-uring@vger.kernel.org>; Thu, 27 Nov 2025 12:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764276269; x=1764881069; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FpIVeIXOM3u5t7UAKdTuYXobohTRnPpHVwMbUQwuMXY=;
        b=MtnF1z11uyVfucV3hrIGnx3dGye2q5hcej7HJQy1FIckJUt3NlaCd+g8PhmbUsgvnL
         S9yiC9OI4bEdd+cxBywHV+FcXreG8xJjcK1ggzTvb8sON1lc1OLvWVpe5H/hJLFKiFxA
         sKsL1Upn+kPYJ9b54FztslZVcU6oEnFPNL2X8UtYl6cWjhFMSun3CAD+vLcIwkzEbBCs
         HJ5fHbHoY5Y5t4YE53Tfimys/xZPcuGrOCwKvddoBcyuwrAyOsgyfu4sneC6VtuYcsIV
         3NQPXI7DPSE6HhmBRamshZm3uAyU82gFUvwzz/XGbfo7OHKU7QnwhI74uSHYSCe7fxno
         sPQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764276269; x=1764881069;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FpIVeIXOM3u5t7UAKdTuYXobohTRnPpHVwMbUQwuMXY=;
        b=odl5lhEYnb2qFAOvRsVKyPArMpo4W4NwGbYkwUNMNxudqkOjFC2JZSKUVlR19mFwow
         XT645zXBpN3WviK3C2KHUht4zOEsQGocxGtlbaqlXagGhU7TbqBnUmrIzMb6zbqZaaKd
         Jgh8IqcNRT0rLSnqIRBOgkBJ/NvC57xNYsmBhcfpkTpC1Ru2e1zuG2g2SpJUg9/Rmlqg
         km9wEoItyD7ldmYSiR/Uc5OzJxGTyg+BCD4kByVQGPRyqU3IdjpFvXJUo/iRrabu5Abm
         EZ1KrkQFb0xVup9Ax/oG/VHKy8/M71bJw2FoBGVqZ2xC/dJPsnq/7DMDVmjgWphHEO8Z
         zhug==
X-Forwarded-Encrypted: i=1; AJvYcCUYD1RCcog/ZI+j3x9Sl+Q90wIf26cOEtYqFJDGSJGlUDDRCLKrINDZiCbmkHEVUCizj8/LQP6Qvw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxs1GmbvphlEO75rFama95w0M80fRdemMIYykPs9FGgbF5gs3ee
	n7Njfz5HY6baddMo1If9f7UH9UH4sVMApQ5pneHkiWh8Kyo6twURFKNK
X-Gm-Gg: ASbGncuw1VJ0hR665ROO1A9uZzrUpRvEmYmTaqySfJbs0+p5qGID0mz0O1mp715srA+
	pRxI7JDaWHuadmZii0goOx2o8hmwi3c7D0Btye270zmQph+6Kn7YUmI3Gng/BmeU9xYe6bTIOXb
	xLoctDR2uyLm9xBg/nHzMTfR4oGKNstnzfz7/dHsaT9Z2S9HmvpxMbbJkasijLpyN8VnGGDd6bb
	xNF9gXlv851t/yZ48oBKKDz53G6jjIYfAqQudCyLNp/lHLPIkxnveZSQ2tVVtMJGnxdU5CADzev
	uGSMamFvk6hSO7y0LlIzSNyw1NssSfWfAHuZchrdPvfUNYdymwvUa56g1MKmY3FMTLAFJHMoDj0
	zjswpp0UrpY6PtLv4pvDKUhYRBwev1myqrvJqWOdxNysbns9KW8fo88zH7SiRXGVVE0CXNcX7wc
	uRVL9XmE3Mbo//rg==
X-Google-Smtp-Source: AGHT+IEvLAp8f+ARTRxSpj80ry7mwrxLtVe2+RcRZGsNrSm5FpD7CnOSq8CVScpcjLQRd3+QWGXFdQ==
X-Received: by 2002:a05:6000:40c9:b0:42b:47da:c31c with SMTP id ffacd0b85a97d-42e0f344674mr13716391f8f.37.1764276269148;
        Thu, 27 Nov 2025 12:44:29 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1c5d614asm5346105f8f.12.2025.11.27.12.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 12:44:28 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Simon Horman <horms@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	io-uring@vger.kernel.org,
	dtatulea@nvidia.com
Subject: [PATCH net-next v6 0/8][pull request] Add support for providers with large rx buffer
Date: Thu, 27 Nov 2025 20:44:13 +0000
Message-ID: <cover.1764264798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Note: it's net/ only bits and doesn't include changes, which shoulf be
merged separately and are posted separately. The full branch for
convenience is at [1], and the patch is here:

https://lore.kernel.org/io-uring/7486ab32e99be1f614b3ef8d0e9bc77015b173f7.1764265323.git.asml.silence@gmail.com

Many modern NICs support configurable receive buffer lengths, and zcrx and
memory providers can use buffers larger than 4K/PAGE_SIZE on x86 to improve
performance. When paired with hw-gro larger rx buffer sizes can drastically
reduce the number of buffers traversing the stack and save a lot of processing
time. It also allows to give to users larger contiguous chunks of data. The
idea was first floated around by Saeed during netdev conf 2024 and was
asked about by a few folks.

Single stream benchmarks showed up to ~30% CPU util improvement.
E.g. comparison for 4K vs 32K buffers using a 200Gbit NIC:

packets=23987040 (MB=2745098), rps=199559 (MB/s=22837)
CPU    %usr   %nice    %sys %iowait    %irq   %soft   %idle
  0    1.53    0.00   27.78    2.72    1.31   66.45    0.22
packets=24078368 (MB=2755550), rps=200319 (MB/s=22924)
CPU    %usr   %nice    %sys %iowait    %irq   %soft   %idle
  0    0.69    0.00    8.26   31.65    1.83   57.00    0.57

This series adds net infrastructure for memory providers configuring
the size and implements it for bnxt. It's an opt-in feature for drivers,
they should advertise support for the parameter in the qops and must check
if the hardware supports the given size. It's limited to memory providers
as it drastically simplifies implementation. It doesn't affect the fast
path zcrx uAPI, and the sizes is defined in zcrx terms, which allows it
to be flexible and adjusted in the future, see Patch 7 for details.

A liburing example can be found at [2]

full branch:
[1] https://github.com/isilence/linux.git zcrx/large-buffers-v6
Liburing example:
[2] https://github.com/isilence/liburing.git zcrx/rx-buf-len

---

The following changes since commit ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb150d:

  Linux 6.18-rc7 (2025-11-23 14:53:16 -0800)

are available in the Git repository at:

  https://github.com/isilence/linux.git tags/net-queue-rx-buf-len-v6

for you to fetch changes up to ef9cc9f58d60656a8afef1fc84f066aeb7b27378:

  selftests: iou-zcrx: test large chunk sizes (2025-11-27 13:19:32 +0000)


v6: - Update docs and add a selftest

v5: https://lore.kernel.org/netdev/cover.1760440268.git.asml.silence@gmail.com/
    - Remove all unnecessary bits like configuration via netlink, and
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

Pavel Begunkov (7):
  net: page_pool: sanitise allocation order
  net: memzero mp params when closing a queue
  net: let pp memory provider to specify rx buf len
  eth: bnxt: store rx buffer size per queue
  eth: bnxt: allow providers to set rx buf size
  io_uring/zcrx: document area chunking parameter
  selftests: iou-zcrx: test large chunk sizes

 Documentation/networking/iou-zcrx.rst         |  20 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 118 ++++++++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |   6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h |   2 +-
 include/net/netdev_queues.h                   |   9 ++
 include/net/page_pool/types.h                 |   1 +
 net/core/netdev_rx_queue.c                    |  14 ++-
 net/core/page_pool.c                          |   3 +
 .../selftests/drivers/net/hw/iou-zcrx.c       |  72 +++++++++--
 .../selftests/drivers/net/hw/iou-zcrx.py      |  37 ++++++
 11 files changed, 235 insertions(+), 49 deletions(-)

-- 
2.52.0


