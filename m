Return-Path: <io-uring+bounces-7688-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C06BEA99FCA
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 06:03:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F4045A532A
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 04:02:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 175671B0411;
	Thu, 24 Apr 2025 04:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i6dMpZRk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EC41AA795
	for <io-uring@vger.kernel.org>; Thu, 24 Apr 2025 04:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745467385; cv=none; b=WoHEysS7By+D8rC6zDlN4VtvK1Sm1k977Qn5fWUmXBHpjMYbxgIMYA2F7lThBX2nZl11xY/lap+Ygg9Y1US7UwMZFUWP6qcnnUcbhc5OJTqFuKqaRFU7mCNeaDLrb6UOYzgfv1HTXAP0mURQ59gmVtWsVVKNbim8aSCByzKJXq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745467385; c=relaxed/simple;
	bh=zt6yYBvh0d8AfeUCUhVJzGOK4AHq2m+OxMp5MyPKv78=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=mPNlGTCCGYW59uGdvs7MKuBiDCOlV1OZqb3pdqcfPeVeUDtRf1TS7sD+Y5MSuxJ7nzZznF5d4aD+SibSm5uLsh0XR/LxEYV4L+UHsotgz87fHgqFhGyPDNgqmI9As4ZvQVxpUW+wgUc8kp8F+CY/D19aaS1O2mFEJtORzK1gELQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i6dMpZRk; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-73c205898aaso400909b3a.2
        for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 21:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745467383; x=1746072183; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=D09PgC93ZS3ZLjn25gSS3hEDnTkEIUuDkcd6alRURFw=;
        b=i6dMpZRkkDo2wKUbCEIwWpz7I099pcApFod+bCfDnDcc5R1swKN1/NRGq0NCj8JQRc
         l/YqGihTrI8k0MUKOFcdOS0R1IgY2y/IUbUrLRymiBkVNPuuUkm11J6l2c0t2UDtFTRn
         WeKyoMaAQx2X2jD4gdJlb71dWoN8KCqa01P3Q9BKA3qtOK7RVIB6Nsx2iu/KcuO8jYBY
         huoK91iSI2TMSXuRgaunxFQET5+PHSKodzAPOwJ7OG+HVHxSu1DBLZ1aog6TxbX2vh1I
         Ha+ORSVCZ6+XZFPqKoC4HP7/s3NUdcfYsTsbQaEF13UeRYxXnZ7Xnr/uX4y6sujhd1Vv
         KgCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745467383; x=1746072183;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D09PgC93ZS3ZLjn25gSS3hEDnTkEIUuDkcd6alRURFw=;
        b=sCRZc4ufkO+AfISnsnigtY9Dmp6tQaQuJx7PyIU+zblqqurqh2lX6PZGorJC0kALZj
         SspMGRXaAS+ZnVPSW63D285fXjxc5eMJjJhiwLopbjk3WpbORlsH8d8bRAHaRKj/01Iz
         xNMGNcLgUcQJYb2J1Ik3v0QpWjinlAFr2O+t+3mrDPrWmTFugEk0w5yLQLRooaW0jlX/
         PEaWHIN5dnOKFyfaiobZSjmr6Pcb5HRFNxJUmenHoMuuV16g1kCP7sNVGVwYAHD6m+c6
         5PAjsoO5o5LCIwr49/P3dqE3PzBPeYE4TXBRwQgM5Vk0Jyg09rRKQVCYHLnGl6qqGmeG
         N5EQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIKxikLJ2aEzLh4EOrpsvjL0xwA4SqxQ9haqIIQN7CMWZgIG++7F5CqDVF7PzZg0E3Tub0nfd6+w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzlC5E/k/I0D51ZqOmxuXyMYC58Ves/Ll1CRP1NEfRnYBiCyQDu
	WC5Ujjm19IFK3b0naYrHiX7uCv4jH7AM3HnzRearVviygvlsnmsbKzU7PQ+I6oZ/yuuKNdvs8af
	b6CoQo5TEtwccXF8zqf6aqA==
X-Google-Smtp-Source: AGHT+IHoYiJAViOyibsmWNa7O71nPYflx8ZwtWAOGvKQYrLpeEes5pAjno8XPyEp9J+g4sJP6zp56GC4j/ih4PdS9g==
X-Received: from pfblc5.prod.google.com ([2002:a05:6a00:4f45:b0:73e:1cf2:cd5c])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:ac86:b0:73c:3060:d53 with SMTP id d2e1a72fcca58-73e24ac977amr1627489b3a.18.1745467382895;
 Wed, 23 Apr 2025 21:03:02 -0700 (PDT)
Date: Thu, 24 Apr 2025 04:02:52 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.805.g082f7c87e0-goog
Message-ID: <20250424040301.2480876-1-almasrymina@google.com>
Subject: [PATCH net-next v11 0/8] Device memory TCP TX
From: Mina Almasry <almasrymina@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, io-uring@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: Mina Almasry <almasrymina@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Donald Hunter <donald.hunter@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Jeroen de Borst <jeroendb@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, sdf@fomichev.me, dw@davidwei.uk, 
	Jamal Hadi Salim <jhs@mojatatu.com>, Victor Nogueira <victor@mojatatu.com>, 
	Pedro Tammela <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"

v11: https://lore.kernel.org/netdev/20250423031117.907681-1-almasrymina@google.com/

Addressed a couple of nits and collected Acked-by from Harshitha
(thanks!)

v10: https://lore.kernel.org/netdev/20250417231540.2780723-1-almasrymina@google.com/

Addressed comments following conversations with Pavel, Stan, and
Harshitha. Thank you guys for the reviews again. Overall minor changes:

Changelog:
- Check for !niov->pp in io_zcrx_recv_frag, just in case we end up with
  a TX niov in that path (Pavel).
- Fix locking case in !netif_device_present (Jakub/Stan).

v9: https://lore.kernel.org/netdev/20250415224756.152002-1-almasrymina@google.com/

Changelog:
- Use priv->bindings list instead of sock_bindings_list. This was missed
  during the rebase as the bindings have been updated to use
  priv->bindings recently (thanks Stan!)

v8: https://lore.kernel.org/netdev/20250308214045.1160445-1-almasrymina@google.com/

Only address minor comments on V7

Changelog:
- Use netdev locking instead of rtnl_locking to match rx path.
- Now that iouring zcrx is in net-next, use NET_IOV_IOURING instead of
  NET_IOV_UNSPECIFIED.
- Post send binding to net_devmem_dmabuf_bindings after it's been fully
  initialized (Stan).

v7: https://lore.kernel.org/netdev/20250227041209.2031104-1-almasrymina@google.com/
===

Changelog:
- Check the dmabuf net_iov binding belongs to the device the TX is going
  out on. (Jakub)
- Provide detailed inspection of callsites of
  __skb_frag_ref/skb_page_unref in patch 2's changelog (Jakub)

v6: https://lore.kernel.org/netdev/20250222191517.743530-1-almasrymina@google.com/
===

v6 has no major changes. Addressed a few issues from Paolo and David,
and collected Acks from Stan. Thank you everyone for the review!

Changes:
- retain behavior to process MSG_FASTOPEN even if the provided cmsg is
  invalid (Paolo).
- Rework the freeing of tx_vec slightly (it now has its own err label).
  (Paolo).
- Squash the commit that makes dmabuf unbinding scheduled work into the
  same one which implements the TX path so we don't run into future
  errors on bisecting (Paolo).
- Fix/add comments to explain how dmabuf binding refcounting works
  (David).

v5: https://lore.kernel.org/netdev/20250220020914.895431-1-almasrymina@google.com/
===

v5 has no major changes; it clears up the relatively minor issues
pointed out to in v4, and rebases the series on top of net-next to
resolve the conflict with a patch that raced to the tree. It also
collects the review tags from v4.

Changes:
- Rebase to net-next
- Fix issues in selftest (Stan).
- Address comments in the devmem and netmem driver docs (Stan and Bagas)
- Fix zerocopy_fill_skb_from_devmem return error code (Stan).

v4: https://lore.kernel.org/netdev/20250203223916.1064540-1-almasrymina@google.com/
===

v4 mainly addresses the critical driver support issue surfaced in v3 by
Paolo and Stan. Drivers aiming to support netmem_tx should make sure not
to pass the netmem dma-addrs to the dma-mapping APIs, as these dma-addrs
may come from dma-bufs.

Additionally other feedback from v3 is addressed.

Major changes:
- Add helpers to handle netmem dma-addrs. Add GVE support for
  netmem_tx.
- Fix binding->tx_vec not being freed on error paths during the
  tx binding.
- Add a minimal devmem_tx test to devmem.py.
- Clean up everything obsolete from the cover letter (Paolo).

v3: https://patchwork.kernel.org/project/netdevbpf/list/?series=929401&state=*
===

Address minor comments from RFCv2 and fix a few build warnings and
ynl-regen issues. No major changes.

RFC v2: https://patchwork.kernel.org/project/netdevbpf/list/?series=920056&state=*
=======

RFC v2 addresses much of the feedback from RFC v1. I plan on sending
something close to this as net-next  reopens, sending it slightly early
to get feedback if any.

Major changes:
--------------

- much improved UAPI as suggested by Stan. We now interpret the iov_base
  of the passed in iov from userspace as the offset into the dmabuf to
  send from. This removes the need to set iov.iov_base = NULL which may
  be confusing to users, and enables us to send multiple iovs in the
  same sendmsg() call. ncdevmem and the docs show a sample use of that.

- Removed the duplicate dmabuf iov_iter in binding->iov_iter. I think
  this is good improvment as it was confusing to keep track of
  2 iterators for the same sendmsg, and mistracking both iterators
  caused a couple of bugs reported in the last iteration that are now
  resolved with this streamlining.

- Improved test coverage in ncdevmem. Now multiple sendmsg() are tested,
  and sending multiple iovs in the same sendmsg() is tested.

- Fixed issue where dmabuf unmapping was happening in invalid context
  (Stan).

====================================================================

The TX path had been dropped from the Device Memory TCP patch series
post RFCv1 [1], to make that series slightly easier to review. This
series rebases the implementation of the TX path on top of the
net_iov/netmem framework agreed upon and merged. The motivation for
the feature is thoroughly described in the docs & cover letter of the
original proposal, so I don't repeat the lengthy descriptions here, but
they are available in [1].

Full outline on usage of the TX path is detailed in the documentation
included with this series.

Test example is available via the kselftest included in the series as well.

The series is relatively small, as the TX path for this feature largely
piggybacks on the existing MSG_ZEROCOPY implementation.

Patch Overview:
---------------

1. Documentation & tests to give high level overview of the feature
   being added.

1. Add netmem refcounting needed for the TX path.

2. Devmem TX netlink API.

3. Devmem TX net stack implementation.

4. Make dma-buf unbinding scheduled work to handle TX cases where it gets
   freed from contexts where we can't sleep.

5. Add devmem TX documentation.

6. Add scaffolding enabling driver support for netmem_tx. Add helpers, driver
feature flag, and docs to enable drivers to declare netmem_tx support.

7. Guard netmem_tx against being enabled against drivers that don't
   support it.

8. Add devmem_tx selftests. Add TX path to ncdevmem and add a test to
   devmem.py.

Testing:
--------

Testing is very similar to devmem TCP RX path. The ncdevmem test used
for the RX path is now augemented with client functionality to test TX
path.

* Test Setup:

Kernel: net-next with this RFC and memory provider API cherry-picked
locally.

Hardware: Google Cloud A3 VMs.

NIC: GVE with header split & RSS & flow steering support.

Performance results are not included with this version, unfortunately.
I'm having issues running the dma-buf exporter driver against the
upstream kernel on my test setup. The issues are specific to that
dma-buf exporter and do not affect this patch series. I plan to follow
up this series with perf fixes if the tests point to issues once they're
up and running.

Special thanks to Stan who took a stab at rebasing the TX implementation
on top of the netmem/net_iov framework merged. Parts of his proposal [2]
that are reused as-is are forked off into their own patches to give full
credit.

[1] https://lore.kernel.org/netdev/20240909054318.1809580-1-almasrymina@google.com/
[2] https://lore.kernel.org/netdev/20240913150913.1280238-2-sdf@fomichev.me/T/#m066dd407fbed108828e2c40ae50e3f4376ef57fd

Cc: sdf@fomichev.me
Cc: asml.silence@gmail.com
Cc: dw@davidwei.uk
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Victor Nogueira <victor@mojatatu.com>
Cc: Pedro Tammela <pctammela@mojatatu.com>
Cc: Samiullah Khawaja <skhawaja@google.com>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>


Mina Almasry (7):
  netmem: add niov->type attribute to distinguish different net_iov
    types
  net: add get_netmem/put_netmem support
  net: devmem: Implement TX path
  net: add devmem TCP TX documentation
  net: enable driver support for netmem TX
  gve: add netmem TX support to GVE DQO-RDA mode
  net: check for driver support in netmem TX

Stanislav Fomichev (1):
  net: devmem: TCP tx netlink api

 Documentation/netlink/specs/netdev.yaml       |  12 ++
 Documentation/networking/devmem.rst           | 150 +++++++++++++++++-
 .../networking/net_cachelines/net_device.rst  |   1 +
 Documentation/networking/netdev-features.rst  |   5 +
 Documentation/networking/netmem.rst           |  23 ++-
 drivers/net/ethernet/google/gve/gve_main.c    |   3 +
 drivers/net/ethernet/google/gve/gve_tx_dqo.c  |   8 +-
 include/linux/netdevice.h                     |   2 +
 include/linux/skbuff.h                        |  17 +-
 include/linux/skbuff_ref.h                    |   4 +-
 include/net/netmem.h                          |  34 +++-
 include/net/sock.h                            |   1 +
 include/uapi/linux/netdev.h                   |   1 +
 io_uring/zcrx.c                               |   3 +-
 net/core/datagram.c                           |  48 +++++-
 net/core/dev.c                                |  34 +++-
 net/core/devmem.c                             | 133 +++++++++++++---
 net/core/devmem.h                             |  83 ++++++++--
 net/core/netdev-genl-gen.c                    |  13 ++
 net/core/netdev-genl-gen.h                    |   1 +
 net/core/netdev-genl.c                        |  80 +++++++++-
 net/core/skbuff.c                             |  48 +++++-
 net/core/sock.c                               |   6 +
 net/ipv4/ip_output.c                          |   3 +-
 net/ipv4/tcp.c                                |  50 ++++--
 net/ipv6/ip6_output.c                         |   3 +-
 net/vmw_vsock/virtio_transport_common.c       |   5 +-
 tools/include/uapi/linux/netdev.h             |   1 +
 28 files changed, 699 insertions(+), 73 deletions(-)


base-commit: abcec3ed92fca92cd81d743bb8a5409da73b7560
-- 
2.49.0.805.g082f7c87e0-goog


