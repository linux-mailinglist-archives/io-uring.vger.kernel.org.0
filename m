Return-Path: <io-uring+bounces-13760-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id QbDGGwIVMmofugUAu9opvQ
	(envelope-from <io-uring+bounces-13760-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 05:31:14 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BC28B6964D4
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 05:31:13 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=163.com header.s=s110527 header.b=LWxz3VZs;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13760-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13760-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D481F30C0017
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 03:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 891FE2E7376;
	Wed, 17 Jun 2026 03:31:04 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6568C13B293
	for <io-uring@vger.kernel.org>; Wed, 17 Jun 2026 03:31:00 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781667064; cv=none; b=nRBkhoC1BhYNaWT/YVCOKt5+fek7vtji5cS2sOhiuqLvF/PBBeBY+gdKJvAa6V5MriSNUTe7HopDBTCbMZXXPDFPv1xHyevHRCJweDMOMAMX1egZl/TIaaBifq3IU4UVXFpQl1oXDa/VxYTvaW3JrtwUVTWoj/aXUsTJs7NPx7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781667064; c=relaxed/simple;
	bh=7l/djdSfYUw/NZdPa4/DnUi8PO5QsVYTaWEF+Kw3I+A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dKbyLUV1LIzNR9RbaU0QBL3hgXCWdVZMbYLJUNRJyE4hnKWRjDVocP3FYxZlv5mursfWej8jpT4fpv6r4CJopzs5x/KPoqs9MM9aIm+o6of1m7DWaK+2y6rmJtz2qUfsgE57IamjFzX5Aw1CpFrIOqCBRN6ngUYXl6hhRaxTids=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=LWxz3VZs; arc=none smtp.client-ip=220.197.31.5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=k8
	dVqQTMxsLI0qS9QLUcxPb5hATFc96dpIcfialqDIo=; b=LWxz3VZswf6dJ4OH7J
	P3h43QQA1Pw1/GiT6QI8x7x+vKHIuGf7OaHaJwGn67SuevKGhrcGEauSfkSQvyrL
	WMLo0/gBL09hZ4FEdB5burs58ihb6zD1kkIc04EeZ0VCRYcaQUQ3X8xy0A2aJgur
	IOzX//8/pqADpfKr1ismeJ1eo=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgCnggLfFDJqiIRVCw--.54307S2;
	Wed, 17 Jun 2026 11:30:41 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: axboe@kernel.dk
Cc: krisman@suse.de,
	io-uring@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: Re: [PATCH] io_uring/net: fix netmsg_cache iovec leak on BIND and CONNECT
Date: Wed, 17 Jun 2026 11:30:35 +0800
Message-Id: <20260617033035.1373691-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260617025348.1301777-1-yangxiuwei@kylinos.cn>
References: <20260617025348.1301777-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgCnggLfFDJqiIRVCw--.54307S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUjHUqUUUUU
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6gFk9GoyFOHGtAAA3k
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13760-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:krisman@suse.de,m:io-uring@vger.kernel.org,m:yangxiuwei@kylinos.cn,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[kylinos.cn];
	FORGED_SENDER(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[163.com:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp,kylinos.cn:mid,kylinos.cn:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: BC28B6964D4

Hi Jens,

Please drop this patch.

After rebasing on the latest io_uring tree, I noticed that this issue
has already been fixed upstream by:

  3979840cd858 ("io_uring/net: Avoid msghdr on op_connect/op_bind async data")

BIND and CONNECT no longer allocate async data from netmsg_cache via
io_msg_alloc_async(). They now use struct sockaddr_storage directly, so
the iovec leak path described in my patch no longer exists. My fix is
also incorrect on the current code base.

Sorry for the noise.

Thanks,
Yang Xiuwei


