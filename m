Return-Path: <io-uring+bounces-12796-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kAhwJAA2wWm7RQQAu9opvQ
	(envelope-from <io-uring+bounces-12796-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 13:45:52 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 378D82F2262
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 13:45:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5A0363015108
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 12:44:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57DFA3AB29E;
	Mon, 23 Mar 2026 12:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LBubgH7g"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12AC3AB27B
	for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 12:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774269860; cv=none; b=WiJcaqIN1lVBYZ6ucqCka1u1HWbLpFgQwYklCJZ28DmTl1GzLT+XNAujJBA5eyO/OIfeid1c2helTGrVBnA6RQWUBggnR1IQZqZRXK/ovtJKRUVIGstPEwiKYi8mAER0NCtLaO7a4cIQEY0wFLvkv1WPwjT4Anc1blhfp8EBaEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774269860; c=relaxed/simple;
	bh=548r9gMCA/18ni+gpqyQyctulc+/2CPQGCx4cl6n0N0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LAIOkifQEKqyNwywMS5gw9h0jqZMHpFalhlTKhMfIIrhnE1kQp3Rq3zAl7wl0ycJeTe4hv8Jz9+8EJOsh1iNb/GS5eldzgb+hEsxEMUXL9x0XT2FpGOMGwCocgbeIJNkDF8QgHMXAEbUD0YbhgLyvnZVngZ6EdlBrM45vt0CdR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LBubgH7g; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-483487335c2so32523175e9.2
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 05:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774269857; x=1774874657; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tj+QJzuLWIO+IQAqw2AbMXAfv5dEr1RKmvP+yOmL/nY=;
        b=LBubgH7g+LY6B1ZtUNH8MhBvDiGTz7NGkQMCpbPtF5jLvhtfBYNrQ6lskTLNMH2BVl
         CmEe6FpW0guOIMdJpsJS0G0eokrbH2ZTzYPPYW9S41q3wOJV/W0qnvT9Ih40Po0FFTpw
         ep5Ukvk9AvwfWfWVHFVNF3bn0r8WgU5KLuC0Aig2TAOakPWVl60VW4gkivdYW13ghJCa
         4bJ7xYUUNo7CbEt9F1d0SaSEbgARUQOp45AlYLTYD8T3XdhMN+an18pWR0zJhuXIZ0L2
         2IDc8ItuKIZ8NJ+9PDXv9d/oxf8AbodtnD6kVaSaUhAnTmoKDYBARu6gp7FjVqzBamHK
         sG5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774269857; x=1774874657;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Tj+QJzuLWIO+IQAqw2AbMXAfv5dEr1RKmvP+yOmL/nY=;
        b=bjU447zO+BpwaKMk8nFJIuNDrINc7YdI7QuDk2e0qMlkpBBQfzGxGGt6SKug35O6iF
         EjfXm/xc8bQcf9MPRoYMjk8OiVrdeJJBo5aVHbBZDUo1t/OMt9NISbwTg/fa5NK6cEwe
         9a0bYg0mHGOucrAjSfg1Vo5ROsK1FtMt8o5Mmq9fGEz6QwvW81uLQe/Tf/ubzVrhU6Nn
         p7/1vkh32r0nxc9KPTBHIQ7/K33APpLUy3beEEFAOYwzTJeJ2u2qyCDbecVR9ley3fZ0
         CxTHb8Chb4vygMtEzfsgzb92Br3sd+Qwl+5sdyiizxCUThG/tNDF/yo+YA06HfqK6Lz4
         uhRg==
X-Gm-Message-State: AOJu0Yx7Pn6WvIh6MEyv9V4gPbCNBWUnk2PB/jS6hRJ20/kWuGXW4bbQ
	W2qnq1GVCZUgzzs+G56/FQfyFbyb5G0huG8o8vYRifUSJ5YzGiSjKev9Xc+fRQ==
X-Gm-Gg: ATEYQzx68zBYAvzyOGpM2hrx4ZCETkLJQjvJQIpScvgD5bOIEX4tPJC7L4UZaUXZ5hi
	r8Qy0Xr1LnbmFZheue+SXXUD3wN133s9s6EFdLxHF+wvcGrle0gcUctOcoNpwiA9pMISXCZRQTM
	BkKIx/J0jRU0ChD2vLJ+PSIiuX9hZdUKcrrwH1vst7mY6TeLEWR4bhZX/E+oSZAObpAYVyJAdTx
	HiD++1T2WE4K15SruyBt37DsyW9kf0QM8vdz96eneFIAU84eSwQ0XMiY01HELuH0qgtOEO7dfLG
	U7petToMQptP3r2XBL2CvShBIwqBieTBLCyS42Aadg1Kgz0qSmD0FdokDTZgqz/NSl69Pi8pkur
	lGYcXh/m4ZJFyBy1a/2VaZ2kAB0kAlNsovyIYCD1+g/GzFffmPbOkHeGXofK0ayHvnuAmIH9g5/
	kcGjyzXXVaJ0IRa0uwFQYStmFHzKXZxbGqRI0x1xIOs3ZadHo5khkMpjOv+L4/8SdD0ltcNvxBG
	cEih0UuQw==
X-Received: by 2002:a05:600c:a43:b0:485:3f1c:d897 with SMTP id 5b1f17b1804b1-486fedb586dmr169582445e9.9.1774269856705;
        Mon, 23 Mar 2026 05:44:16 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:6969])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b6425eeb4sm25520861f8f.0.2026.03.23.05.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 05:44:16 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring-7.1 12/16] io_uring/zcrx: consolidate dma syncing
Date: Mon, 23 Mar 2026 12:44:01 +0000
Message-ID: <19f2d50baa62ff2e0c6cd56dd7c394cab728c567.1774261953.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774261953.git.asml.silence@gmail.com>
References: <cover.1774261953.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12796-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 378D82F2262
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Split refilling into two steps, first allocate niovs, and then do DMA
sync for them. This way dma synchronisation code can be better
optimised. E.g. we don't need to call dma_dev_need_sync() for each every
niov, and maybe we can coalesce sync for adjacent netmems in the future
as well.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 070b4941d001..bf3dd15678c9 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -300,21 +300,23 @@ static void io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
 	}
 }
 
-static void io_zcrx_sync_for_device(struct page_pool *pool,
-				    struct net_iov *niov)
+static void zcrx_sync_for_device(struct page_pool *pp, struct io_zcrx_ifq *zcrx,
+				 netmem_ref *netmems, unsigned nr)
 {
 #if defined(CONFIG_HAS_DMA) && defined(CONFIG_DMA_NEED_SYNC)
+	struct device *dev = pp->p.dev;
+	unsigned i, niov_size;
 	dma_addr_t dma_addr;
 
-	unsigned niov_size;
-
-	if (!dma_dev_need_sync(pool->p.dev))
+	if (!dma_dev_need_sync(dev))
 		return;
+	niov_size = 1U << zcrx->niov_shift;
 
-	niov_size = 1U << io_pp_to_ifq(pool)->niov_shift;
-	dma_addr = page_pool_get_dma_addr_netmem(net_iov_to_netmem(niov));
-	__dma_sync_single_for_device(pool->p.dev, dma_addr + pool->p.offset,
-				     niov_size, pool->p.dma_dir);
+	for (i = 0; i < nr; i++) {
+		dma_addr = page_pool_get_dma_addr_netmem(netmems[i]);
+		__dma_sync_single_for_device(dev, dma_addr + pp->p.offset,
+					     niov_size, pp->p.dma_dir);
+	}
 #endif
 }
 
@@ -1044,7 +1046,6 @@ static unsigned io_zcrx_ring_refill(struct page_pool *pp,
 			continue;
 		}
 
-		io_zcrx_sync_for_device(pp, niov);
 		netmems[allocated] = netmem;
 		allocated++;
 	} while (--entries);
@@ -1067,7 +1068,6 @@ static unsigned io_zcrx_refill_slow(struct page_pool *pp, struct io_zcrx_ifq *if
 		if (!niov)
 			break;
 		net_mp_niov_set_page_pool(pp, niov);
-		io_zcrx_sync_for_device(pp, niov);
 		netmems[allocated] = net_iov_to_netmem(niov);
 	}
 	return allocated;
@@ -1092,6 +1092,7 @@ static netmem_ref io_pp_zc_alloc_netmems(struct page_pool *pp, gfp_t gfp)
 	if (!allocated)
 		return 0;
 out_return:
+	zcrx_sync_for_device(pp, ifq, netmems, allocated);
 	allocated--;
 	pp->alloc.count += allocated;
 	return netmems[allocated];
-- 
2.53.0


