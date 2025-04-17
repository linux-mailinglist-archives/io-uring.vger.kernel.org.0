Return-Path: <io-uring+bounces-7527-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 897EFA92DE2
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 01:15:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7336D3ACC0E
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 23:15:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A15192222A9;
	Thu, 17 Apr 2025 23:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G6pe0r1K"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC5422171B
	for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 23:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744931746; cv=none; b=KLiXAghIzY2jv36bKn0lCUg2DZjhGMKSyvInKVpl7NVohmS7/Iu2ycidMccqkKXicGwrsKj8lxjIwIeVFSIpd74HHHPMep2XsbEqP32x06FhAqLXnN6g8FKvVz4V8180oA/5lJblAv+m4wfzsQW9wZBCHUhKSniFUNL/wWPLK0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744931746; c=relaxed/simple;
	bh=BHBb1CGqfVkBq5p1joAjwZM6RdIF3ify/rYCXHSdX5Q=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=jRRMRxCbluf5z0PSW/flvMD0+3XU30FdXSCkeN4qcneQxeFrgRAUirNxbIElz0KEEm0sqDNdT4SHFWnBW+L1x/4ROSAaU6rCjr3a6rnuOiKRMaPFLLBRHsj9LH54jVq5Mt3lI6BwzKXTjbMAIRwtrJs3S/CkRxjp5rBrwnDhm5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G6pe0r1K; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b00aa1f50d1so751366a12.3
        for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 16:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744931743; x=1745536543; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=959uz33BV//g+a794CDjMebjZF60Bgf+wfJg9Elzli0=;
        b=G6pe0r1Kw0b56XGEGkM82jOLDgYkMHhx2DP2tMD8WydCz86NCiLUTVBp+QRDGUHUy/
         Xyx3HYlcw7o7voTbXHKm7B/BbOq28mdHe9qU/pZueOjEJO0WLcNfJtI6RBZr7IJKlbVs
         nESWUX3FMQb1nfoztdTyIoa4ZkNgyPCBMyxJMKrNMxJY9bI1YMf5wS/0oCDizhpfZkEv
         4SsGtMCYIF6jdEZkjzKTDvcvgoofSYYp2sQBpQ8d4zOkFCG23l6c4nsk7bc0DKvRNEjV
         8LY9lAb8EpNgEDJvijysgF8aVf8ImyHwnvhtUHlVwoXYUI82GQuWOr2pZTaBmmmSjzlU
         4SFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744931743; x=1745536543;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=959uz33BV//g+a794CDjMebjZF60Bgf+wfJg9Elzli0=;
        b=sQ2a9xipPIzcdXMe4/WfisqXO3suzmeAVtA7Rl3K+c5jf7XD66CDP/ImMnJVd49ojq
         K98qlAvH21LTGrnWo+jEJpGop7m99XPmvvpvZXFMM9K7P3vauKG3AHMYtLfPF/lTqXS9
         UOLckoEGKTzseZ+mI9oizQWeEUOZYx5B2HWDiIwkTgwAuEuQVgbkyCc1Q3UbC6ubP0gz
         ldwhzZ72dsmuWxpJfuggUI5TAoQCwvFhqIcBAVWpbHb0bEOFvof2ZE9IYptj1Vts5zaU
         BJkfCEOm0xdihgcClOHji4qU6qiWgChc0c13a44J5Z+k7aSwdptprK2MkaxK7UvOKud7
         5LRA==
X-Forwarded-Encrypted: i=1; AJvYcCUk1f/BbvA/9MwLatkuFuaACbh13upuqHBlq+iCs8kyt2JnhMnPmdlpeD3f6UUy79Qk2yI+jUs2yw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwAkXQ5toz29sFBuULRsZ0mlbDqFe2sKu5DwtmnldApe4sPgtob
	zfY10aOjprWGNbrcksL2KLWTLJr9If1whLPNRj0T7LQrvviYT3qh42hfEPKsagn5bNe+AOubvCY
	GQdpzXJCwvVVrPAyCN0CelQ==
X-Google-Smtp-Source: AGHT+IFywzm8aNSuk5tkiTEUKcvGh1SYZ627hVg8fZBmCQjKu2wWWhuI42PIrHslPjHURPGcIAGhg6LGZrXtcp1wgQ==
X-Received: from pjbeu15.prod.google.com ([2002:a17:90a:f94f:b0:2f7:d453:e587])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:280b:b0:2fe:b470:dde4 with SMTP id 98e67ed59e1d1-3087bb48e31mr1260040a91.12.1744931742908;
 Thu, 17 Apr 2025 16:15:42 -0700 (PDT)
Date: Thu, 17 Apr 2025 23:15:31 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.805.g082f7c87e0-goog
Message-ID: <20250417231540.2780723-1-almasrymina@google.com>
Subject: [PATCH net-next v9 0/9] Device memory TCP TX
From: Mina Almasry <almasrymina@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, io-uring@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: Mina Almasry <almasrymina@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Donald Hunter <donald.hunter@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Jeroen de Borst <jeroendb@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, sdf@fomichev.me, dw@davidwei.uk, 
	Jamal Hadi Salim <jhs@mojatatu.com>, Victor Nogueira <victor@mojatatu.com>, 
	Pedro Tammela <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"

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


Mina Almasry (8):
  netmem: add niov->type attribute to distinguish different net_iov
    types
  net: add get_netmem/put_netmem support
  net: devmem: Implement TX path
  net: add devmem TCP TX documentation
  net: enable driver support for netmem TX
  gve: add netmem TX support to GVE DQO-RDA mode
  net: check for driver support in netmem TX
  selftests: ncdevmem: Implement devmem TCP TX

Stanislav Fomichev (1):
  net: devmem: TCP tx netlink api

 Documentation/netlink/specs/netdev.yaml       |  12 +
 Documentation/networking/devmem.rst           | 150 ++++++++-
 .../networking/net_cachelines/net_device.rst  |   1 +
 Documentation/networking/netdev-features.rst  |   5 +
 Documentation/networking/netmem.rst           |  23 +-
 drivers/net/ethernet/google/gve/gve_main.c    |   4 +
 drivers/net/ethernet/google/gve/gve_tx_dqo.c  |   8 +-
 include/linux/netdevice.h                     |   2 +
 include/linux/skbuff.h                        |  17 +-
 include/linux/skbuff_ref.h                    |   4 +-
 include/net/netmem.h                          |  34 +-
 include/net/sock.h                            |   1 +
 include/uapi/linux/netdev.h                   |   1 +
 io_uring/zcrx.c                               |   1 +
 net/core/datagram.c                           |  48 ++-
 net/core/dev.c                                |  34 +-
 net/core/devmem.c                             | 139 ++++++--
 net/core/devmem.h                             |  83 ++++-
 net/core/netdev-genl-gen.c                    |  13 +
 net/core/netdev-genl-gen.h                    |   1 +
 net/core/netdev-genl.c                        |  75 ++++-
 net/core/skbuff.c                             |  48 ++-
 net/core/sock.c                               |   6 +
 net/ipv4/ip_output.c                          |   3 +-
 net/ipv4/tcp.c                                |  50 ++-
 net/ipv6/ip6_output.c                         |   3 +-
 net/vmw_vsock/virtio_transport_common.c       |   5 +-
 tools/include/uapi/linux/netdev.h             |   1 +
 .../selftests/drivers/net/hw/devmem.py        |  26 +-
 .../selftests/drivers/net/hw/ncdevmem.c       | 300 +++++++++++++++++-
 30 files changed, 1009 insertions(+), 89 deletions(-)


base-commit: 240ce924d2718b8f6f622f2a9a9c219b9da736e8
-- 
2.49.0.805.g082f7c87e0-goog


