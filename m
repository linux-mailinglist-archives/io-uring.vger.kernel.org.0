Return-Path: <io-uring+bounces-6378-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E904BA32F1F
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 20:00:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F1A36188B984
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 19:00:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 151F626139A;
	Wed, 12 Feb 2025 18:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="v6AbuOYE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82103263C86
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 18:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739386759; cv=none; b=QqEyUTM2RD5H/GbhWyVui1ZeGZDlegqWdqc/PQJKcHG1yzeo7GwDsAlhw7VE2A58rc8NMohuG7CW690ZS4OVTM85wWeK7F74snWzMRQ6Thz7hLEUePWPKGJ3ElgaAfP222qM5SGEUvBVAx+0F+GtalU0Kup59GfZ0R6FZIHdhnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739386759; c=relaxed/simple;
	bh=QumA4njWI3uL0s97dnRLtj5mQkb8OjDSLyFeGh8Lsj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSkgGp/wc4+kTxNhYorNYUI1olYxzyyJTlzOnuyu1Mu3BQ5o5GsCPvrSf6UWn6jtnhmIFxMdz9yHZSMXgqNM0qrvioRofoLezi0wdaF9lfnrmHOA9B3S1K8CBXOE0yX0/WJ+Ixqwe/Rlwiit/TVJ0BFkGa25sm5Q8P37jTe+2ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=v6AbuOYE; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-21f55fbb72bso96839685ad.2
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 10:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739386755; x=1739991555; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wlkjdpHbhJX/gR21YXy4ZrMDaO1Q/+f/VrNlDd9Eqgw=;
        b=v6AbuOYEkvxR7iLcQON1nxrDVhIXu02ulCtakjSJTgDoc2PjnCPW0H/0CdFyPb5oh4
         +GhJwJ3v+ewrZhUJExP/gbx8Xj8iKWKPb3cNjAGF+8En1pzBv7FDJxSWygjhXqhznGx1
         khzVMki5DulGmTGHMjJx7KdJgphFPm6wZIfEt5r330GQhAyrZm24YodNGhJqzxv5Cc4X
         42BFdTiZF275D5w8QB20JuI1ls9cOazUrx3D4kR0EOG90+AHQ44zS6Tj+IDfsQxDSutm
         2fd3Nc4HSuHZFahrxOZEIoB2so2ZIMPV5GugR8VmNCc8U0bHDp+3tA5v60qJl8m7OllU
         aN3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739386755; x=1739991555;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wlkjdpHbhJX/gR21YXy4ZrMDaO1Q/+f/VrNlDd9Eqgw=;
        b=AfMNWFAXJjKIhtOJKI5USm0ZE5PJAmJJ9cKlg162TFxBo1tPovwqUY1LzZjNiUwpTz
         9DPsz0qrGp1ZtBaZgH11hQCNlBkRQ22xQiVrpnNdk1vqyWV6vjbe6lJBWIguWy0e3yZe
         T+MTmZg/uhe5yVqvYR1N7DrRmFnxSyTtfnSmArZ2CaBZN51RboQ+X5YxyZ08Veoqdtkb
         H7w/Rz5dCFbT8GvnISIoSe0lgIzyg/7ZE29rtqMyY7eZ9XiHXihNusqdRUuhFuGwv0Xl
         jwqzrw2I39RRJhC7+j9XUWSxH8aepLGTsHYRB8Krx0ZUJ7wFC6Ql+8udyedp+cN9VOx8
         KcrA==
X-Gm-Message-State: AOJu0Yx7kh/su6HJwFtkHigSRzWxgK1idxP/JXjapZRD/gnMwoq6C+tO
	ddwNMe9p551ysPmcnsEiNRMaWiOOzf9CC+D8R9Sw/aU0eR9guYMnZVU/E+14tTKgb1JiiwRh/Ve
	R
X-Gm-Gg: ASbGncsq8IUiWdn4GYv+klyCbVnffcH7CN2Co9QjBlXuatMN1/FJbs6BV+I3NpgM2TS
	A2WoDc3IRhstjxI0DD9JFH+R2WA/wqu3fvo7lFMOZW79Ohf5NVoEGqoSvQXepZU0h2euan8bnNS
	ml1UXU8KPl2WNb6Fr2ytbdMmBA+OUqLY1aZPAkKhdATh9h3XmTW++XnTQR3OZrENGLncQkNZ1XV
	kj1p863KuFXOMIfYMxygUjIQNM8uqIeIA48nysw3CrvVmADyMx8Fzn239CH9S5+W5yprsugSE5x
X-Google-Smtp-Source: AGHT+IFzVa8ocMfhh3NL6cqOH0RlyzwtFqrAJLeoWng7wQzg5qvUzNLNu7fbQviMnBQxjbp/zpgTJg==
X-Received: by 2002:a17:902:d48b:b0:215:9bc2:42ec with SMTP id d9443c01a7336-220d216ce9fmr4657415ad.47.1739386754815;
        Wed, 12 Feb 2025 10:59:14 -0800 (PST)
Received: from localhost ([2a03:2880:ff:43::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21f3689b5ddsm115065095ad.216.2025.02.12.10.59.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 10:59:14 -0800 (PST)
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
Subject: [PATCH net-next v13 09/11] io_uring/zcrx: add copy fallback
Date: Wed, 12 Feb 2025 10:57:59 -0800
Message-ID: <20250212185859.3509616-10-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250212185859.3509616-1-dw@davidwei.uk>
References: <20250212185859.3509616-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

There are scenarios in which the zerocopy path can get a kernel buffer
instead of a net_iov and needs to copy it to the user, whether it is
because of mis-steering or simply getting an skb with the linear part.
In this case, grab a net_iov, copy into it and return it to the user as
normally.

At the moment the user doesn't get any indication whether there was a
copy or not, which is left for follow up work.

Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 120 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 114 insertions(+), 6 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 8f8a71f5d0a4..7359e0810104 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -7,6 +7,7 @@
 #include <linux/io_uring.h>
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
+#include <linux/skbuff_ref.h>
 
 #include <net/page_pool/helpers.h>
 #include <net/page_pool/memory_provider.h>
@@ -132,6 +133,13 @@ static void io_zcrx_get_niov_uref(struct net_iov *niov)
 	atomic_inc(io_get_user_counter(niov));
 }
 
+static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
+{
+	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
+
+	return area->pages[net_iov_idx(niov)];
+}
+
 static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
 				 struct io_uring_zcrx_ifq_reg *reg,
 				 struct io_uring_region_desc *rd)
@@ -448,6 +456,11 @@ static void io_zcrx_return_niov(struct net_iov *niov)
 {
 	netmem_ref netmem = net_iov_to_netmem(niov);
 
+	if (!niov->pp) {
+		/* copy fallback allocated niovs */
+		io_zcrx_return_niov_freelist(niov);
+		return;
+	}
 	page_pool_put_unrefed_netmem(niov->pp, netmem, -1, false);
 }
 
@@ -683,13 +696,93 @@ static bool io_zcrx_queue_cqe(struct io_kiocb *req, struct net_iov *niov,
 	return true;
 }
 
+static struct net_iov *io_zcrx_alloc_fallback(struct io_zcrx_area *area)
+{
+	struct net_iov *niov = NULL;
+
+	spin_lock_bh(&area->freelist_lock);
+	if (area->free_count)
+		niov = __io_zcrx_get_free_niov(area);
+	spin_unlock_bh(&area->freelist_lock);
+
+	if (niov)
+		page_pool_fragment_netmem(net_iov_to_netmem(niov), 1);
+	return niov;
+}
+
+static ssize_t io_zcrx_copy_chunk(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
+				  void *src_base, struct page *src_page,
+				  unsigned int src_offset, size_t len)
+{
+	struct io_zcrx_area *area = ifq->area;
+	size_t copied = 0;
+	int ret = 0;
+
+	while (len) {
+		size_t copy_size = min_t(size_t, PAGE_SIZE, len);
+		const int dst_off = 0;
+		struct net_iov *niov;
+		struct page *dst_page;
+		void *dst_addr;
+
+		niov = io_zcrx_alloc_fallback(area);
+		if (!niov) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		dst_page = io_zcrx_iov_page(niov);
+		dst_addr = kmap_local_page(dst_page);
+		if (src_page)
+			src_base = kmap_local_page(src_page);
+
+		memcpy(dst_addr, src_base + src_offset, copy_size);
+
+		if (src_page)
+			kunmap_local(src_base);
+		kunmap_local(dst_addr);
+
+		if (!io_zcrx_queue_cqe(req, niov, ifq, dst_off, copy_size)) {
+			io_zcrx_return_niov(niov);
+			ret = -ENOSPC;
+			break;
+		}
+
+		io_zcrx_get_niov_uref(niov);
+		src_offset += copy_size;
+		len -= copy_size;
+		copied += copy_size;
+	}
+
+	return copied ? copied : ret;
+}
+
+static int io_zcrx_copy_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
+			     const skb_frag_t *frag, int off, int len)
+{
+	struct page *page = skb_frag_page(frag);
+	u32 p_off, p_len, t, copied = 0;
+	int ret = 0;
+
+	off += skb_frag_off(frag);
+
+	skb_frag_foreach_page(frag, off, len,
+			      page, p_off, p_len, t) {
+		ret = io_zcrx_copy_chunk(req, ifq, NULL, page, p_off, p_len);
+		if (ret < 0)
+			return copied ? copied : ret;
+		copied += ret;
+	}
+	return copied;
+}
+
 static int io_zcrx_recv_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 			     const skb_frag_t *frag, int off, int len)
 {
 	struct net_iov *niov;
 
 	if (unlikely(!skb_frag_is_net_iov(frag)))
-		return -EOPNOTSUPP;
+		return io_zcrx_copy_frag(req, ifq, frag, off, len);
 
 	niov = netmem_to_net_iov(frag->netmem);
 	if (niov->pp->mp_ops != &io_uring_pp_zc_ops ||
@@ -716,18 +809,33 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 	struct io_zcrx_ifq *ifq = args->ifq;
 	struct io_kiocb *req = args->req;
 	struct sk_buff *frag_iter;
-	unsigned start, start_off;
+	unsigned start, start_off = offset;
 	int i, copy, end, off;
 	int ret = 0;
 
 	if (unlikely(args->nr_skbs++ > IO_SKBS_PER_CALL_LIMIT))
 		return -EAGAIN;
 
-	start = skb_headlen(skb);
-	start_off = offset;
+	if (unlikely(offset < skb_headlen(skb))) {
+		ssize_t copied;
+		size_t to_copy;
 
-	if (offset < start)
-		return -EOPNOTSUPP;
+		to_copy = min_t(size_t, skb_headlen(skb) - offset, len);
+		copied = io_zcrx_copy_chunk(req, ifq, skb->data, NULL,
+					    offset, to_copy);
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
2.43.5


