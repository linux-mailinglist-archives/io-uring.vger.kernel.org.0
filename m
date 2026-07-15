Return-Path: <io-uring+bounces-14014-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id UL+6MzorV2onGgEAu9opvQ
	(envelope-from <io-uring+bounces-14014-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2026 08:39:54 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 77D3775B216
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2026 08:39:54 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=iNbUpNS8;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-14014-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-14014-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0F2CC300E035
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2026 06:39:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C71B20ADF8;
	Wed, 15 Jul 2026 06:39:53 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6233128C6
	for <io-uring@vger.kernel.org>; Wed, 15 Jul 2026 06:39:51 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784097593; cv=none; b=XL93hWk08cQEWF/cEuthhW9kY+lM2FLmChNVF1LmrFODiNPgkQxpkp4tffa0DvsPRz6j/+YuwKqlQCh9LTx6frk2gRHVbTJ/pmsvn84QCSgcNSfRLllWgKTbgiaySRACDkVxr2lhdEi8YkN2LPyBaHKQUTivuMgDDB3JBfgBGI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784097593; c=relaxed/simple;
	bh=UaPQ901qZDwrl9dswu+14LQQK7YgTB90O/ovxHTZtlw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uynLTRyFgr7M5YlthkE2fQ1AB7IocTgCAyTAbjGnzBXacVXWMxx4jM9Ck8zeT3lavVMl8Id+2dQKHt4bt68gwgGag/J4vVnnQs/zffxxdsjdxTFjKjNdZmC5rrCpHHRVFRyc919Tryd5jCKvSsR8JLUJySqOcZCRYjgscU6NDlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iNbUpNS8; arc=none smtp.client-ip=198.137.202.133
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=XN8KViqjWvAXhBUse0/7emkr00GEVht/KuFuiITFuPA=; b=iNbUpNS8P+PF7mISjjw/Jk/XpL
	JZUdpjjRKWtORM4SKlmhRGiQK7nCBCeFZNdq5UKKQj8EPEMCx/ohkI/o/eO5CCu7WZNXf3+0AakgP
	NOsPv7DMB2GiroOxij9V3U7oa0lT3JeeKEVZ+/e4xnuiYepxAy3TSBb3Cq60u03DY9bFqWL/O6VDQ
	6uBSXF/MjR66dK2oeEZK1HCHrA61HuM4wCXH7mXkmJebJJoXeqgz7+VYZr6+HPDXB2sG99ud2IInW
	Oknha4t7Uungb7Rp38yXC2CxZbBTeTSxxw06qyagdjQhxCNfTe2ahqqQlDOs8QmmpggTFdCjON8S/
	nFf4zViA==;
Received: from 2a02-8389-2301-9f00-3397-c9eb-6d8a-9179.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:3397:c9eb:6d8a:9179] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjtHa-0000000DvBf-1A3B;
	Wed, 15 Jul 2026 06:39:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	io-uring@vger.kernel.org
Subject: support ZONE_RESET_ALL in liburing
Date: Wed, 15 Jul 2026 08:39:27 +0200
Message-ID: <20260715063947.2933606-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.06 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), DKIM not aligned (relaxed),none];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14014-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:dlemoal@kernel.org,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[hch@lst.de,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,lst.de:from_mime,lst.de:mid,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 77D3775B216

Hi Jens,

this is the liburing support for the just submitted ZONE_RESET_ALL uring
cmd support.  Also a few fixup for the discard support that stood model.

