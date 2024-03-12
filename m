Return-Path: <io-uring+bounces-917-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 46D3B879DD4
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 22:47:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 73E2F1C21951
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 21:47:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 070F2145FE2;
	Tue, 12 Mar 2024 21:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="vgL2p05t"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EB614535E
	for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 21:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710279890; cv=none; b=DDai6Rf+qVeGQLwSZhai+IXQLg7FF2aie7TMoGs7AAj4VsBbVGg2fmJCMq/hl7okmOytoDJI05sc81E6lQXqIJEjpsFGlt3Q0nztyVz5L5FNJdPvYqg9PJxx8W+Cm0mkC0PAg3AjfVlOY+7sk4a/9mkEK0H3RGWI+8Px6ZHsTy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710279890; c=relaxed/simple;
	bh=z2w+r09/BcYGkyADiO4nrIRRIVTOhcEE99lfEgsktAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HF+iT7shccrt7/GFOuOVAE4oBgyp+hc+dLnm3rrbQROZvArPfWtM9TnyPz70kfpT9Rqgd2gElPZCVm+DnCPqRvxXF65msnE8BFzyONovee8I5R87unjXhdWOlyL9SM57hUxhU6StaCjrUhvS9CoKh0O6sR4jnnZq7Spkb4t0ymc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=vgL2p05t; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6e6afb754fcso682252b3a.3
        for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 14:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1710279888; x=1710884688; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qIC4Ae0sae8eShK2Gi00SxXSModbCHeO8tBGSVnxdXA=;
        b=vgL2p05tgSlpBkFqYqHwqlzETlIEEUSl5R3ZvHwcFmVyFkfr2fTDhX/ifvRNvZ/I1K
         O3Rx5Xyq0AZkdGcBwEXU/R/lCA+GYrjv+Oq06Cy+t6f2jp8B56XJLAp0eJ+9G5kYbie1
         l84xr7tfb42ny9/J5ICnGz5iG8DpDnb3EMnfX6bere4ha5Ad+emKUHez1JZE1ZLbEkSx
         AO1k/Be7l2OBSaJINCuaTdE7T/5MYtqrKVNh520IuAmcUkmGlgLubUmQpbpAxAGtVNXp
         WCN4FJrn6K8bFPidDyL/KnRHQ1uysHUcjosPBP0X53JQd47NzHjNTLo5ZvDefmLaTd+o
         Zekw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710279888; x=1710884688;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qIC4Ae0sae8eShK2Gi00SxXSModbCHeO8tBGSVnxdXA=;
        b=cprg1Bz4GgxbqXu4ej21v3GDlCE/ru/1uwQKr2tFGC967XRUHfj295fUpqt2agHx+e
         I+j/clFfzhhmHh/a5sfffsq+goSDEg20+gpuLwkES3IaqKyKAcoLQaDWCq9Y3vPDDKx4
         MxKp82TUF9yfwsT7aWt5eQukyEyrX209E7atzq+BlCEXL43X9V5LMasncdZqdzCmuwZX
         AoIj+plBiMQHSFwr2uJ3WC/CdioILJE7vnCZ2S1aespRRWYn0UE939rCWwThhA+Pr6UL
         8O4KksbJpCAN35/6dpUFeOlYH/9+9z5srJJCcpfeWcy2v2+LToQkf67KZ4TAHpibGlst
         Io6Q==
X-Gm-Message-State: AOJu0Yz5QMV+jZGfAcrX7uJYyw6lcs7wyoFuKYO7+Hh65//R6qq6gTS6
	T0YCv1lq1cQDKPdT2q3uNkOavtlfJNw3gLvRfNKXafA5X0/88L5FyRPxmM1ZMpM2d2XVqShUGdl
	x
X-Google-Smtp-Source: AGHT+IGmk/rm4/qpneP5Z5KvYp/gR8eyBX/7oPoJnJNaHVb+8SwNc608T+M0WqH8X/aPFxjSmYTQjg==
X-Received: by 2002:a05:6a00:4f96:b0:6e5:5597:822d with SMTP id ld22-20020a056a004f9600b006e55597822dmr842673pfb.33.1710279888574;
        Tue, 12 Mar 2024 14:44:48 -0700 (PDT)
Received: from localhost (fwdproxy-prn-025.fbsv.net. [2a03:2880:ff:19::face:b00c])
        by smtp.gmail.com with ESMTPSA id r10-20020aa7988a000000b006e681769ee0sm5808845pfl.145.2024.03.12.14.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 14:44:48 -0700 (PDT)
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
	Mina Almasry <almasrymina@google.com>
Subject: [RFC PATCH v4 15/16] io_uring/zcrx: add copy fallback
Date: Tue, 12 Mar 2024 14:44:29 -0700
Message-ID: <20240312214430.2923019-16-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240312214430.2923019-1-dw@davidwei.uk>
References: <20240312214430.2923019-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, if user fails to keep up with the network and doesn't refill
the buffer ring fast enough the NIC/driver will start dropping packets.
That might be too punishing. Add a fallback path, which would allow
drivers to allocate normal pages when there is starvation, then
zc_rx_recv_skb() we'll detect them and copy into the user specified
buffers, when they become available.

That should help with adoption and also help the user striking the right
balance allocating just the right amount of zerocopy buffers but also
being resilient to sudden surges in traffic.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zc_rx.c | 111 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 105 insertions(+), 6 deletions(-)

diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index bb9251111735..d5f49590e682 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -8,6 +8,7 @@
 #include <linux/nospec.h>
 
 #include <net/page_pool/helpers.h>
+#include <net/busy_poll.h>
 #include <net/tcp.h>
 #include <net/af_unix.h>
 
@@ -26,6 +27,11 @@ struct io_zc_rx_args {
 	struct socket		*sock;
 };
 
+struct io_zc_refill_data {
+	struct io_zc_rx_ifq *ifq;
+	struct io_zc_rx_buf *buf;
+};
+
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 
 static int __io_queue_mgmt(struct net_device *dev, struct io_zc_rx_ifq *ifq,
@@ -648,6 +654,34 @@ const struct memory_provider_ops io_uring_pp_zc_ops = {
 };
 EXPORT_SYMBOL(io_uring_pp_zc_ops);
 
+static void io_napi_refill(void *data)
+{
+	struct io_zc_refill_data *rd = data;
+	struct io_zc_rx_ifq *ifq = rd->ifq;
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
+	rd->buf = io_niov_to_buf(netmem_to_net_iov(netmem));
+}
+
+static struct io_zc_rx_buf *io_zc_get_buf_task_safe(struct io_zc_rx_ifq *ifq)
+{
+	struct io_zc_refill_data rd = {
+		.ifq = ifq,
+	};
+
+	napi_execute(ifq->pp->p.napi, io_napi_refill, &rd);
+	return rd.buf;
+}
+
 static bool zc_rx_queue_cqe(struct io_kiocb *req, struct io_zc_rx_buf *buf,
 			   struct io_zc_rx_ifq *ifq, int off, int len)
 {
@@ -669,6 +703,42 @@ static bool zc_rx_queue_cqe(struct io_kiocb *req, struct io_zc_rx_buf *buf,
 	return true;
 }
 
+static ssize_t zc_rx_copy_chunk(struct io_kiocb *req, struct io_zc_rx_ifq *ifq,
+				void *data, unsigned int offset, size_t len)
+{
+	size_t copy_size, copied = 0;
+	struct io_zc_rx_buf *buf;
+	int ret = 0, off = 0;
+	u8 *vaddr;
+
+	do {
+		buf = io_zc_get_buf_task_safe(ifq);
+		if (!buf) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		vaddr = kmap_local_page(buf->page);
+		copy_size = min_t(size_t, PAGE_SIZE, len);
+		memcpy(vaddr, data + offset, copy_size);
+		kunmap_local(vaddr);
+
+		if (!zc_rx_queue_cqe(req, buf, ifq, off, copy_size)) {
+			napi_pp_put_page(net_iov_to_netmem(&buf->niov), false);
+			return -ENOSPC;
+		}
+
+		io_zc_rx_get_buf_uref(buf);
+		napi_pp_put_page(net_iov_to_netmem(&buf->niov), false);
+
+		offset += copy_size;
+		len -= copy_size;
+		copied += copy_size;
+	} while (offset < len);
+
+	return copied ? copied : ret;
+}
+
 static int zc_rx_recv_frag(struct io_kiocb *req, struct io_zc_rx_ifq *ifq,
 			   const skb_frag_t *frag, int off, int len)
 {
@@ -688,7 +758,22 @@ static int zc_rx_recv_frag(struct io_kiocb *req, struct io_zc_rx_ifq *ifq,
 			return -ENOSPC;
 		io_zc_rx_get_buf_uref(buf);
 	} else {
-		return -EOPNOTSUPP;
+		struct page *page = skb_frag_page(frag);
+		u32 p_off, p_len, t, copied = 0;
+		u8 *vaddr;
+		int ret = 0;
+
+		skb_frag_foreach_page(frag, off, len,
+				      page, p_off, p_len, t) {
+			vaddr = kmap_local_page(page);
+			ret = zc_rx_copy_chunk(req, ifq, vaddr, p_off, p_len);
+			kunmap_local(vaddr);
+
+			if (ret < 0)
+				return copied ? copied : ret;
+			copied += ret;
+		}
+		len = copied;
 	}
 
 	return len;
@@ -702,15 +787,29 @@ zc_rx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 	struct io_zc_rx_ifq *ifq = args->ifq;
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
+		copied = zc_rx_copy_chunk(req, ifq, skb->data, offset, to_copy);
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
-- 
2.43.0


