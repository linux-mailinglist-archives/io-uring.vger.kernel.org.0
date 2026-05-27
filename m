Return-Path: <io-uring+bounces-13512-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gCr3CDOXFmrVngcAu9opvQ
	(envelope-from <io-uring+bounces-13512-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 09:03:15 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 0840A5E0252
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 09:03:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7C42B3007AD6
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 07:02:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FDAF3B775B;
	Wed, 27 May 2026 07:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="e//4q0U1"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00595305675;
	Wed, 27 May 2026 07:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779865370; cv=none; b=gMK8i6q+JesiHSzFhJQi+2sd3+bsbkq3pbR4Njcv9AEsT6rLp2yQrTG5xwW+R4+zrUCQK4slf0opqelbud1b4qShZ0g4zO+PNObjnVnq45Wb25dWqSAa9KZ8FI4+vy2FFEWSVIS0m5T+P0v5RzBEmjGEd9r+XxwJN7tsXxoYVGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779865370; c=relaxed/simple;
	bh=9Ml/772Vs+EpdIlfs4fmXnahTZpghxCjdin0m9nVEC4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nAQ4LhluwOgBcNRX2eB67hrG96cOzKiapy5IucVzNvmWlJXoOFp/jipUp3w0x7XRFq8UGrgD258WdCILkbJlk55mTWBkX86MVvRNzpR53o2pR5gWcryVFUtWGNO2c7qvlYJwPnPg7S8zpeoq2eykn0b6w4fAxMtzjNfgKf9T2sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=e//4q0U1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=NvR3YFJF8Y8iU4J/6e3/E0bFFW+ErgeNUyJr96l/GBw=; b=e//4q0U1ykdmFjfwjG5D6O4zjy
	bfxRclqUynP5c7s+t2Ui2skJtg/B1qimJCwG3DTT8Vp6ka+DW2jhtnjMYsaOfGhgYU6BJi2GTVB9w
	DQzeLfTY1xBt9ANc4BN3+KI20ekUvh+nJVkAiAg/P9bYHmTgzOHBNPqKsqua8AvKleThe/r+P/nID
	v4BtYCt7OiqLzmaON6udfJDGrHQA3KtsztWHNmqmVlC11unAfXRNP+BpQHqlqDi2Da0kdKX7NxgP/
	xjm37bGqZVbtAHGlQ3XgQ2/euq+aCFIK419NswGCDg/ECo8Zh4F685E5drYjA9VlLDZ+uZJsshRtH
	1eulWmBQ==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wS8Hu-00000003R0P-0SjZ;
	Wed, 27 May 2026 07:02:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	io-uring@vger.kernel.org,
	kasan-dev@googlegroups.com,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org
Subject: improve the kmem_cache_alloc_bulk API
Date: Wed, 27 May 2026 09:02:21 +0200
Message-ID: <20260527070239.2252948-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spamd-Result: default: False [-0.06 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), DKIM not aligned (relaxed),none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-13512-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,lst.de:mid,infradead.org:dkim]
X-Rspamd-Queue-Id: 0840A5E0252
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi all,

kmem_cache_alloc_bulk has a very unintuitive and undocumented return
value convention.  Fix that and add documentation.

Note that the few comments explaining it mention that the gfp flags
must allow "spinning".  That's not really a term used in the memory
allocator, is this supposed to mean "block" or "sleep"?

Diffstat:
 drivers/gpu/drm/msm/msm_iommu.c       |    6 +--
 drivers/gpu/drm/panthor/panthor_mmu.c |   12 ++-----
 include/linux/slab.h                  |    6 ++-
 io_uring/io_uring.c                   |   23 +++++--------
 lib/test_meminit.c                    |   19 +++++------
 mm/kasan/kasan_test_c.c               |    5 +-
 mm/kfence/kfence_test.c               |    9 ++---
 mm/slub.c                             |   58 ++++++++++++++++++----------------
 net/bpf/test_run.c                    |    7 +---
 net/core/skbuff.c                     |   23 +++++++------
 tools/include/linux/slab.h            |    2 -
 tools/testing/shared/linux.c          |   19 ++++-------
 12 files changed, 92 insertions(+), 97 deletions(-)

