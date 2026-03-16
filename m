Return-Path: <io-uring+bounces-12687-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OKfrNL5et2nZQQEAu9opvQ
	(envelope-from <io-uring+bounces-12687-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 02:37:02 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 377A92936CC
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 02:37:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0CBDF300E385
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 01:37:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77B3F23C516;
	Mon, 16 Mar 2026 01:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="BIqFKLPK"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D811231A41
	for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 01:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773625019; cv=none; b=dMwJGRVHLri3vaUsEc11gePnQwyVWMBZbtOpdUHrGw6v0V/yq+KOlRwQ9pBRElPk/hr4cz7Yh0ZnC3vsoyelWj1CGQo09xGSpVhh3imaeIzTQW1l6lMpcGW5cvuP5veo1lmnQS/TBnjd2izaWZgn9ZBemkVggTPRT4qxdcUbEm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773625019; c=relaxed/simple;
	bh=o4zhdnHI/RsdvuhiFJb/eFdT2q4UfdW+DaOx12olis0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ppdPcWum4uSSJ5qHtvJAd/lqUwSljiuw9fR7pKXAxpwFpnzt9PO7eNtcyZ+8Pfws9JP6pHe7wvLruIMQs6AExrRBv0r2+866jpmPG9hqj6Pv1Q3TeoR2ZbjttSopy1k3h8oyl6/vNndFeLdqDt397gEZTnxcyFbU4LdORFgQyiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=BIqFKLPK; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=7g
	gQWBCcQwPoIbN/IMeOTEhO9TNJ9KZTWuVOGYE8prw=; b=BIqFKLPKZx0RjyahJD
	4/mmQa5CQZQb6guCk/dav0FuZo6pxLVZSZN0IVdag7OOXYQP+H4dXaCHQICNcJkK
	p70iuSMcWrpi/NIsYkrmFqzn5dvU/gzC9cBmzynufpSYx7qysY7qnPcIG8obYRr5
	5vigNmDnD95QPa3YYOs3GleLM=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wB3LduWXrdpW5DGBA--.28271S3;
	Mon, 16 Mar 2026 09:36:27 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v2 1/2] examples/send-zerocopy: fix -Wstringop-truncation on ifr.ifr_name
Date: Mon, 16 Mar 2026 09:36:20 +0800
Message-Id: <20260316013621.115939-2-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260316013621.115939-1-yangxiuwei@kylinos.cn>
References: <20260316013621.115939-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wB3LduWXrdpW5DGBA--.28271S3
X-Coremail-Antispam: 1Uf129KBjvdXoWrKw13Zr17uF4DuFyDZFWDArb_yoWkXwbE9F
	sYvw4rG3WfJFyDtry8Wr4SvFyxGa4UWrySyFWvyF9rAa98Ww4UCF4vgr1j9rW8ZFsFgF9x
	CF1jgr1Utay5ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUjOzV5UUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6RsGlmm3Xpt5IQAA3h
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
	TAGGED_FROM(0.00)[bounces-12687-lists,io-uring=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[kylinos.cn:email,kylinos.cn:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 377A92936CC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

strncpy(ifr.ifr_name, cfg_ifname, sizeof(ifr.ifr_name)) triggers
-Wstringop-truncation because the bound equals the destination size,
so the compiler assumes the result may not be null-terminated. Use
sizeof(ifr.ifr_name) - 1 as the bound so at most 15 bytes are copied.

Fixes: 3e4f05342662 ("examples/send-zerocopy: use strncpy() to copy interface name")
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 examples/send-zerocopy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/examples/send-zerocopy.c b/examples/send-zerocopy.c
index f0248d20..b2821af6 100644
--- a/examples/send-zerocopy.c
+++ b/examples/send-zerocopy.c
@@ -353,7 +353,7 @@ static void do_tx(struct thread_data *td, int domain, int type, int protocol)
 		struct ifreq ifr;
 
 		memset(&ifr, 0, sizeof(ifr));
-		strncpy(ifr.ifr_name, cfg_ifname, sizeof(ifr.ifr_name));
+		strncpy(ifr.ifr_name, cfg_ifname, sizeof(ifr.ifr_name) - 1);
 
 		if (setsockopt(fd, SOL_SOCKET, SO_BINDTODEVICE, &ifr, sizeof(ifr)) < 0)
 			t_error(1, errno, "Binding to device failed\n");
-- 
2.25.1


