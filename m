Return-Path: <io-uring+bounces-13541-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8K2ELRcPGGqwbQgAu9opvQ
	(envelope-from <io-uring+bounces-13541-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 11:47:03 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 430B35EFDC1
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 11:47:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1272A30D94A0
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 09:34:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F85739EF2A;
	Thu, 28 May 2026 09:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oyDjwN+b"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E6D28D8DB;
	Thu, 28 May 2026 09:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779960888; cv=none; b=J0MzCYeyrm9kx9RbAMWNnf/jDcQMXWCGKzMwGFdttWD/dn+68ypq6pUOQ7rzE4T2yjwN20AyciaRUDvv6uZM/du5cADmyAZVtmqi2IzWT0rfJvod18Uzmacw9VWCP4q2xsnBAFWHcYloOCleqM82SLb/3O3oLzsQZKWdIhTcnnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779960888; c=relaxed/simple;
	bh=dahFSdbxB15aXJInp7gon4Sk7QRJA5Ckpfi5kANXQHU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cpgYyDppuL++6F7e0A/YbgIeXWhKcfcEMHtY9Lafb5JIAMYfs70D6W3nbCI4KJ9ayXeBrbld8S1PgPxcHBaghpMYTimVuCGE+gYXmmkgRTbJ/B4RefJUowbB7JIURoKTYOgrxNxcaxoTQrvRNh1mFZ8uZ7efwbl22EcoqPgIRmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oyDjwN+b; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=pANoFNUJ5rscT7uP3oM15kc+SWL0V877H/uU38vShj8=; b=oyDjwN+bRgj0+TJOVnay73cV9D
	EdCnPBP+0/iqe+9u31JmicYPVunHjl+Rju0ohWrtjx6+rD7pZ5Ucia9QYCO4Hj8PYmBHq0e9eo79s
	0XAdIBoH7hgdIq/vnPP/a5EsKpJFIGrwQ5ssGRAUeCSN4Fj7GICvux7IzZQpQi2QyR6OCaJh6LspY
	TWU+f3+5NE0DuoH2oK6AbH89l4bXiyZWK2cKyPWuREQvEyPk7kXIsQA6Nnkvf0+HVudWa6KpfD48F
	PNxPUFVNUUisTA2Ox6ywtXDv+N9L20lhFWLSJLAIAdtgG1/JH2PFeeO9nIMdGAsi6wwssmCNomaSx
	0UdY/vtg==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSX8U-00000005WDo-3pQ8;
	Thu, 28 May 2026 09:34:43 +0000
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
Subject: improve the kmem_cache_alloc_bulk API v2
Date: Thu, 28 May 2026 11:34:31 +0200
Message-ID: <20260528093437.2519248-1-hch@lst.de>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), DKIM not aligned (relaxed),none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-13541-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,lst.de:mid,infradead.org:dkim]
X-Rspamd-Queue-Id: 430B35EFDC1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi all,

kmem_cache_alloc_bulk has a very unintuitive and undocumented return
value convention.  Fix that and add documentation.

Changes since v1:
 - fix compile in drm and test_meminit
 - document that 0-sized allocations fail

Diffstat:
 drivers/gpu/drm/msm/msm_iommu.c       |    6 +--
 drivers/gpu/drm/panthor/panthor_mmu.c |   13 +++----
 include/linux/slab.h                  |    6 ++-
 io_uring/io_uring.c                   |   23 +++++--------
 lib/test_meminit.c                    |   23 ++++++-------
 mm/kasan/kasan_test_c.c               |    5 +-
 mm/kfence/kfence_test.c               |    9 ++---
 mm/slub.c                             |   59 +++++++++++++++++++---------------
 net/bpf/test_run.c                    |    7 +---
 net/core/skbuff.c                     |   24 +++++++------
 tools/include/linux/slab.h            |    2 -
 tools/testing/shared/linux.c          |   19 ++++------
 12 files changed, 97 insertions(+), 99 deletions(-)

