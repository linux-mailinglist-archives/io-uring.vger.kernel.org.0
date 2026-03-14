Return-Path: <io-uring+bounces-12670-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IEsxLHgetWngwgAAu9opvQ
	(envelope-from <io-uring+bounces-12670-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 09:38:16 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1593028C30D
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 09:38:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C81D4305DEC2
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 08:35:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31DFB3148A6;
	Sat, 14 Mar 2026 08:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="cT2rfrt4"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48FE4F881
	for <io-uring@vger.kernel.org>; Sat, 14 Mar 2026 08:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773477356; cv=none; b=vBJFdsypZ/nS7gth0g+A/iy7x/MURkQyB2WEfdnCPyJwockKHT7dtFw8q9NQM76ZaxYRdQY2ERl2Ab6iz3zMCf9h48u2lG6tLEdE1/SHMcZ1hiei284fjlNMGf6+U4d8PZnwVgrOJtNDkqjrUngzNyda2NszP2CLXmTAXsPoKtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773477356; c=relaxed/simple;
	bh=8Y9YFT/kPCdjXmcyVEJlYHx4Up751OvoUPFiWD1b174=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aSV2HQRiNOx4zKbQzDFRFFOJxXpqcPM6kFqfvqWYqmuO04N73n9kdDIXmcKisc+J8KV/weKOjA/XM/bju3w9W/B9XpZQrBcaMIwglKhn9DDRUoK0NPTbqo5Y2FjWxZtacTz5YqYoMhKhJKMUxsKcfC8Li8JvH8d/GiYiNtDLdrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=cT2rfrt4; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=D+
	FsTyfKxL//YQu6LOZd4CmAtn/D6WP6/7c4dgIA+Vw=; b=cT2rfrt4UWLC4X0RaF
	o7yofO9p9Q1EBfUbPGDFGmVe2A2yo81Yo7BrMILycmGqw9KMMLkrZpaNdsInIJGZ
	fL3+cV4K+x6CLME/EwOs4IjeDHjX+107ixYACecPH7EN/w8PvlQcXbghtshjdgu4
	F8STmM1pPu5rmsQzb6d/FKR18=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD3P4zcHbVpWkWgAw--.7725S2;
	Sat, 14 Mar 2026 16:35:40 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH Liburing 0/2] build and compiler warning fixes
Date: Sat, 14 Mar 2026 16:35:36 +0800
Message-Id: <20260314083538.791693-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3P4zcHbVpWkWgAw--.7725S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxU5KsjDUUUU
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwRxG1mm1Hdw5IwAA3K
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12670-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kylinos.cn];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[163.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kylinos.cn:mid]
X-Rspamd-Queue-Id: 1593028C30D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Fix two issues: (1) cbpf_filter test fails to build when kernel headers
lack openat2.h; (2) send-zerocopy triggers -Wstringop-truncation on
ifr.ifr_name.

Yang Xiuwei (2):
  examples/send-zerocopy: fix -Wstringop-truncation on ifr.ifr_name
  test/cbpf_filter: skip when openat2.h is not available

 examples/send-zerocopy.c |  2 +-
 test/cbpf_filter.c      |  8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

-- 
2.25.1


