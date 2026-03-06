Return-Path: <io-uring+bounces-12575-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oMGmEGRAqmlQOAEAu9opvQ
	(envelope-from <io-uring+bounces-12575-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 06 Mar 2026 03:48:04 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A2E7421AB8D
	for <lists+io-uring@lfdr.de>; Fri, 06 Mar 2026 03:48:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 20DE2303A26B
	for <lists+io-uring@lfdr.de>; Fri,  6 Mar 2026 02:47:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08C09318B9D;
	Fri,  6 Mar 2026 02:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="qUPRU+T5"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E072833E363;
	Fri,  6 Mar 2026 02:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772765252; cv=none; b=FCJFY6zkvOmXAcA+1Bk22EqDlE6Bd73ke7iZV4NMZAeNQdC+YkzrJodiUC2PohOsO7mIQ2LaoFploJfiFMfuekan1kqyRk5Ioulb1PCwWbDxIeVyAKyIil/s3unSlma5L484el0HXpoIauqeNB0kAF7k2MUcI4grfJCH8vQXpqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772765252; c=relaxed/simple;
	bh=ss1qzT2zGltopR2HmNiT0A8layIVs3at5mlgB6wi2U4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TKF6uoaIq7bsC/OBDD/a+LWocWeZZdATRSz0q7E34xp9IqOOPJLQwq/j4PdHzW/4cYr9EW5K1QoSEYgADu9ZbpSe82mpfmRA9W0eLv3mc0a5xctZyGkZ/wLxIDmdC1sAFYMdnHlyTPi8XCbV2pH91o99dCO2UhPGwKlgexLCSGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=qUPRU+T5; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=ss
	1qzT2zGltopR2HmNiT0A8layIVs3at5mlgB6wi2U4=; b=qUPRU+T5lBV8hRVgez
	S4iAmjixh3FqBZ1l4bfhzxeJDzLpICg8CpxGonEE3VIp5u53jenTVFBNGa07CCrr
	eExwnkbX+9WHE+o0rZTlEo5x0WY4FOVkohhgZuAVnP5c9n4ONFsRy97qyXZ/XZ4s
	cr4MhMD3rt3OEOkr8+tn1jwnM=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wDXPv0DQKppel3WPQ--.833S2;
	Fri, 06 Mar 2026 10:46:29 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: bvanassche@acm.org
Cc: fujita.tomonori@lab.ntt.co.jp,
	axboe@kernel.dk,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	yangxiuwei@kylinos.cn,
	linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/3] bsg: add io_uring command support for SCSI passthrough
Date: Fri,  6 Mar 2026 10:46:27 +0800
Message-Id: <20260306024627.58267-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <3ce6f611-330c-4705-9842-f85eb9a13556@acm.org>
References: <3ce6f611-330c-4705-9842-f85eb9a13556@acm.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXPv0DQKppel3WPQ--.833S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUo38eUUUUU
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6QUWpmmqQAW72wAA36
X-Rspamd-Queue-Id: A2E7421AB8D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12575-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[kylinos.cn];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[163.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 2026-03-05 15:12, Bart Van Assche wrote:
> Please send a new version of a patch series as a new email thread.
> Otherwise the new version may get overlooked.

Thanks for the reminder. I'll send v7 as a new thread.

Best regards,
Yang Xiuwei


