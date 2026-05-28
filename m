Return-Path: <io-uring+bounces-13554-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WHmoEhXRGGqunggAu9opvQ
	(envelope-from <io-uring+bounces-13554-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2026 01:34:45 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 988075FB73F
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2026 01:34:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 74885309DC00
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 23:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FCBF27A477;
	Thu, 28 May 2026 23:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IJNiVaMy"
X-Original-To: io-uring@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3531317176
	for <io-uring@vger.kernel.org>; Thu, 28 May 2026 23:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780011027; cv=none; b=FnVc8xkeh5PSXzLeW//FeJXGfQUNqo8I5UCGKQO4HP7gwyjfGLq1XSYCDBpUCVDg6D2UE2fXMWVrOmyXNVv+ldt9motrVmz4UKsQfFuv1213tsdzTLf4cuG65I45baKpy0F4CDVSJG/Mmn3jSyOjawJHyGqrpAKRckRyXpLR5ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780011027; c=relaxed/simple;
	bh=CPg5W6qmv3QeO/QThKytexmCzra9QCkoXU0qYXhgnRE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=sfO1dUSoV683Le9TDZyXBya4ZtUXfpqxY8z178nCURI9gTjrl3PVCwoRJrB/m83zEQzmGTndqYLc0BjGwDLKPvcGCV+HDy7vvTvHzukV8M+LoDuGDBuhR3gDVq4VqX6FHKPert8mr/dps9t4NE/q4/8U/llmzfbr8ARDUGKMB1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IJNiVaMy; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780011022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D4wIN4SNHRitM0ngarezIhOM5acJEbDG3qSyZyguPCI=;
	b=IJNiVaMyTnO0R8z438tXxUIihVO7hXAF28ZbM8NefFkZnYup68YW7NgHHE+Nyox05yyblt
	wTiE2pvjqGpFvYiIgRb16TDhnQNAD6yZOA4HPZ5UdcsdlWOLOBsMWBNqRYfi3L5WkiZWy/
	E2+R14LJHOe2EQ20LJ6nT+g2NW9i/cU=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v2 0/2] Add bvec_folio and its kernel-doc
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: William Kucharski <william.kucharski@linux.dev>
In-Reply-To: <20260528175905.1102280-1-willy@infradead.org>
Date: Thu, 28 May 2026 17:30:07 -0600
Cc: Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org,
 linux-mm@kvack.org,
 Leon Romanovsky <leon@kernel.org>,
 Christoph Hellwig <hch@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FADCC457-872C-466E-82F8-F88DF03E54F0@linux.dev>
References: <20260528175905.1102280-1-willy@infradead.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
X-Migadu-Flow: FLOW_OUT
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13554-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[linux.dev:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[william.kucharski@linux.dev,io-uring@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,linux.dev:mid,linux.dev:dkim,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,infradead.org:email]
X-Rspamd-Queue-Id: 988075FB73F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

For the series:

Reviewed-by: William Kucharski <william.kucharski@linux.dev>

> On May 28, 2026, at 11:59, Matthew Wilcox (Oracle) =
<willy@infradead.org> wrote:
>=20
> Add the convenience helper bvec_folio() to avoid references to =
bv_page.
> Convert a few of the obvious users.
>=20
> v2:
> - Tweak the kernel-doc (Christoph)
> - Add the bvec kerneldoc to the documentation build
>=20
> Matthew Wilcox (Oracle) (2):
>  block: Add bvec_folio()
>  block: Include bvec.h kernel-doc in the htmldocs
>=20
> Documentation/core-api/kernel-api.rst |  1 +
> block/bio.c                           |  6 +++---
> include/linux/bio.h                   |  2 +-
> include/linux/bvec.h                  | 17 +++++++++++++++++
> io_uring/rsrc.c                       |  2 +-
> mm/page_io.c                          |  4 ++--
> 6 files changed, 25 insertions(+), 7 deletions(-)
>=20
> --=20
> 2.47.3
>=20
>=20


