Return-Path: <io-uring+bounces-4169-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22A009B5676
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 00:07:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7CBF6B2199E
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 23:07:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A912220BB4E;
	Tue, 29 Oct 2024 23:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="EBBIlC3y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632FE20C498
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 23:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730243179; cv=none; b=Iu0zGCBjU6nGs2Cu4de3CI5qB7svWQELH8DeVhJ6c8wbg1Ssulp0I44n+zyutUgsryXGO2kbhrm/0mvof7ktKgEH9YsK/Cjm9ELw4S7WykF28+nE7VxLTQy1xNKH2FLaES5y2yx3bAiK2Ukm/+5lYqQxbrY809WB0swc6anntqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730243179; c=relaxed/simple;
	bh=7FnSeT5rG0hNe8XnQzL2pjhkkXdqIXvOONCY1JXWVNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhT4qKTU4MQwgieWzv4ZMK56o5MJTEo5umnHknS+sWEmsNcEXJ7RdOkRNJiHCLrd7p2yQuEuPaarZNKW+BanWF5PZm0lq9yASCaT/o/H/ihKd8QeLIBZWQNEl+fUT6Z3rpcmaO/maQqUdzz6PR9833P8+jGZGrYSNHsCDOeZXR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=EBBIlC3y; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-20e6981ca77so64586835ad.2
        for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 16:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1730243177; x=1730847977; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m9i7k9AwDi6yEmab9fhAfUnB2mFTPp04Wex6JOJ/x70=;
        b=EBBIlC3yMeRjJPvxar6oQ6AQHOEV5EK0ObLHpJ+fWqSyGJqsfSJWXBfGylvkwD7MEC
         +P6UqCh+cae9c2lDvae/Lt3NWA+TPp1p15bqO7jXvOldKdzAqpfyGRd2qtfaFiZrhYyV
         AMSIijFNmU0LJ2dhaNWLFUoe+UylhRSw62+gBnVYQxhizsGLddub1zTBYpkdTSLhs1wD
         XP3TM4CoI6rSFR91q0gyrmwUBQZzTJMhChP3tRvLkm1rL/3wzuX6T2qoezmYpnLe2EaP
         N2TJEqryFWDPrVrI++ZWDOnT4Cvmxopg2CtJilwVOyoyq+aXbWrknNKeR7TO91ObNU3T
         gyVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730243177; x=1730847977;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m9i7k9AwDi6yEmab9fhAfUnB2mFTPp04Wex6JOJ/x70=;
        b=eibTW5xzaUVu3nRWRjk4GKUWlvPNCYlILkZda9ztvYQV7/HpXxa7JLhHjSLtkNpDjo
         4YNb+m5VYp5pEPt3g+3PS12yQt8i/xKwNKlZ9yu0K1VN+9Vci+CUu+goX+jrM9In4lnZ
         b+8GgaWtg7pbAbIQKQkhHEquGKwL1r3dNpjFdvguH8a7Rzk24Th+lMtkCzLLA7zRwDhx
         BcDZ+oBhfhSaSgdM8Xet4bn8hawzI6upjD5HSM3EvjVu5QRcvwJRLv5I4ynEqcofqDGR
         LPLlz1p518g9weRpAEESxYuT5HIqQxCJP6pJ97uLS205BZA6xBmAbeAlN4XJ3B8BztBf
         FP6w==
X-Gm-Message-State: AOJu0YzNRcx4OsclHM03FdFgXd+AVExtbGNVcubgd7lbRAjlbBO8uH2Z
	qSqbeBQ0samFoy+stXCAib/Ze9XcmEJZJMjbgCGzxLoINl81eMLN8HatmDW4zNV/Pw10Y16c7aE
	Dwxg=
X-Google-Smtp-Source: AGHT+IFAOX9QM/TdIaQD3TLWLnfkXn7/Vh1YJpjasadBIZml3foik3gkOjD/8BexVd3heXufw1YkSw==
X-Received: by 2002:a17:902:d4d2:b0:20c:ea04:a186 with SMTP id d9443c01a7336-210c6c93ea4mr172580585ad.48.1730243176815;
        Tue, 29 Oct 2024 16:06:16 -0700 (PDT)
Received: from localhost (fwdproxy-prn-030.fbsv.net. [2a03:2880:ff:1e::face:b00c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-210bc04b201sm70459835ad.272.2024.10.29.16.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 16:06:16 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH v7 14/15] io_uring/zcrx: add copy fallback
Date: Tue, 29 Oct 2024 16:05:17 -0700
Message-ID: <20241029230521.2385749-15-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241029230521.2385749-1-dw@davidwei.uk>
References: <20241029230521.2385749-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

There are scenarios in which the zerocopy path might get a normal
in-kernel buffer, it could be a mis-steered packet or simply the linear
part of an skb. Another use case is to allow the driver to allocate
kernel pages when it's out of zc buffers, which makes it more resilient
to spikes in load and allow the user to choose the balance between the
amount of memory provided and performance.

At the moment we fail such requests. Instead, grab a buffer from the
page pool, copy data there, and return back to user in the usual way.
Because the refill ring is private to the napi our page pool is running
from, it's done by stopping the napi via napi_execute() helper. It grabs
only one buffer, which is inefficient, and improving it is left for
follow up patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 133 +++++++++++++++++++++++++++++++++++++++++++++---
 io_uring/zcrx.h |   1 +
 2 files changed, 127 insertions(+), 7 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 3f4625730dbd..1f4db70e3370 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -5,6 +5,8 @@
 #include <linux/nospec.h>
 #include <linux/netdevice.h>
 #include <linux/io_uring.h>
+#include <linux/skbuff_ref.h>
+#include <net/busy_poll.h>
 #include <net/page_pool/helpers.h>
 #include <net/page_pool/memory_provider.h>
 #include <trace/events/page_pool.h>
@@ -28,6 +30,11 @@ struct io_zcrx_args {
 	struct socket		*sock;
 };
 
+struct io_zc_refill_data {
+	struct io_zcrx_ifq *ifq;
+	struct net_iov *niov;
+};
+
 static const struct memory_provider_ops io_uring_pp_zc_ops;
 
 static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_iov *niov)
@@ -37,6 +44,13 @@ static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_iov *nio
 	return container_of(owner, struct io_zcrx_area, nia);
 }
 
+static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
+{
+	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
+
+	return area->pages[net_iov_idx(niov)];
+}
+
 static int io_open_zc_rxq(struct io_zcrx_ifq *ifq, unsigned ifq_idx)
 {
 	struct netdev_rx_queue *rxq;
@@ -59,6 +73,13 @@ static int io_open_zc_rxq(struct io_zcrx_ifq *ifq, unsigned ifq_idx)
 	ret = netdev_rx_queue_restart(ifq->dev, ifq->if_rxq);
 	if (ret)
 		goto fail;
+
+	if (WARN_ON_ONCE(!ifq->pp)) {
+		ret = -EFAULT;
+		goto fail;
+	}
+	/* grab napi_id while still under rtnl */
+	ifq->napi_id = ifq->pp->p.napi->napi_id;
 	return 0;
 fail:
 	rxq->mp_params.mp_ops = NULL;
@@ -526,6 +547,7 @@ static void io_pp_zc_destroy(struct page_pool *pp)
 	page_pool_mp_release_area(pp, &ifq->area->nia);
 
 	ifq->pp = NULL;
+	ifq->napi_id = 0;
 
 	if (WARN_ON_ONCE(area->free_count != area->nia.num_niovs))
 		return;
@@ -540,6 +562,34 @@ static const struct memory_provider_ops io_uring_pp_zc_ops = {
 	.scrub			= io_pp_zc_scrub,
 };
 
+static void io_napi_refill(void *data)
+{
+	struct io_zc_refill_data *rd = data;
+	struct io_zcrx_ifq *ifq = rd->ifq;
+	netmem_ref netmem;
+
+	if (WARN_ON_ONCE(!ifq->pp))
+		return;
+
+	netmem = page_pool_alloc_netmem(ifq->pp, GFP_ATOMIC | __GFP_NOWARN);
+	if (!netmem)
+		return;
+	if (WARN_ON_ONCE(!netmem_is_net_iov(netmem)))
+		return;
+
+	rd->niov = netmem_to_net_iov(netmem);
+}
+
+static struct net_iov *io_zc_get_buf_task_safe(struct io_zcrx_ifq *ifq)
+{
+	struct io_zc_refill_data rd = {
+		.ifq = ifq,
+	};
+
+	napi_execute(ifq->napi_id, io_napi_refill, &rd);
+	return rd.niov;
+}
+
 static bool io_zcrx_queue_cqe(struct io_kiocb *req, struct net_iov *niov,
 			      struct io_zcrx_ifq *ifq, int off, int len)
 {
@@ -563,6 +613,45 @@ static bool io_zcrx_queue_cqe(struct io_kiocb *req, struct net_iov *niov,
 	return true;
 }
 
+static ssize_t io_zcrx_copy_chunk(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
+				  void *data, unsigned int offset, size_t len)
+{
+	size_t copy_size, copied = 0;
+	int ret = 0, off = 0;
+	struct page *page;
+	u8 *vaddr;
+
+	do {
+		struct net_iov *niov;
+
+		niov = io_zc_get_buf_task_safe(ifq);
+		if (!niov) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		page = io_zcrx_iov_page(niov);
+		vaddr = kmap_local_page(page);
+		copy_size = min_t(size_t, PAGE_SIZE, len);
+		memcpy(vaddr, data + offset, copy_size);
+		kunmap_local(vaddr);
+
+		if (!io_zcrx_queue_cqe(req, niov, ifq, off, copy_size)) {
+			napi_pp_put_page(net_iov_to_netmem(niov));
+			return -ENOSPC;
+		}
+
+		io_zcrx_get_buf_uref(niov);
+		napi_pp_put_page(net_iov_to_netmem(niov));
+
+		offset += copy_size;
+		len -= copy_size;
+		copied += copy_size;
+	} while (offset < len);
+
+	return copied ? copied : ret;
+}
+
 static int io_zcrx_recv_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 			     const skb_frag_t *frag, int off, int len)
 {
@@ -570,8 +659,24 @@ static int io_zcrx_recv_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 
 	off += skb_frag_off(frag);
 
-	if (unlikely(!skb_frag_is_net_iov(frag)))
-		return -EOPNOTSUPP;
+	if (unlikely(!skb_frag_is_net_iov(frag))) {
+		struct page *page = skb_frag_page(frag);
+		u32 p_off, p_len, t, copied = 0;
+		u8 *vaddr;
+		int ret = 0;
+
+		skb_frag_foreach_page(frag, off, len,
+				      page, p_off, p_len, t) {
+			vaddr = kmap_local_page(page);
+			ret = io_zcrx_copy_chunk(req, ifq, vaddr, p_off, p_len);
+			kunmap_local(vaddr);
+
+			if (ret < 0)
+				return copied ? copied : ret;
+			copied += ret;
+		}
+		return copied;
+	}
 
 	niov = netmem_to_net_iov(frag->netmem);
 	if (niov->pp->mp_ops != &io_uring_pp_zc_ops ||
@@ -592,15 +697,29 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 	struct io_zcrx_ifq *ifq = args->ifq;
 	struct io_kiocb *req = args->req;
 	struct sk_buff *frag_iter;
-	unsigned start, start_off;
+	unsigned start, start_off = offset;
 	int i, copy, end, off;
 	int ret = 0;
 
-	start = skb_headlen(skb);
-	start_off = offset;
+	if (unlikely(offset < skb_headlen(skb))) {
+		ssize_t copied;
+		size_t to_copy;
 
-	if (offset < start)
-		return -EOPNOTSUPP;
+		to_copy = min_t(size_t, skb_headlen(skb) - offset, len);
+		copied = io_zcrx_copy_chunk(req, ifq, skb->data, offset, to_copy);
+		if (copied < 0) {
+			ret = copied;
+			goto out;
+		}
+		offset += copied;
+		len -= copied;
+		if (!len)
+			goto out;
+		if (offset != skb_headlen(skb))
+			goto out;
+	}
+
+	start = skb_headlen(skb);
 
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		const skb_frag_t *frag;
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index d3f6b6cdd647..5d7920972e95 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -39,6 +39,7 @@ struct io_zcrx_ifq {
 
 	u32				if_rxq;
 	netdevice_tracker		netdev_tracker;
+	unsigned			napi_id;
 };
 
 #if defined(CONFIG_IO_URING_ZCRX)
-- 
2.43.5


