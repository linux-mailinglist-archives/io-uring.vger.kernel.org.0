Return-Path: <io-uring+bounces-12671-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wBp/BYIetWngwgAAu9opvQ
	(envelope-from <io-uring+bounces-12671-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 09:38:26 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6183328C314
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 09:38:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C6C64305F4C9
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 08:35:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BAC74F881;
	Sat, 14 Mar 2026 08:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Ot3QKLGj"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0D429D29F
	for <io-uring@vger.kernel.org>; Sat, 14 Mar 2026 08:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773477358; cv=none; b=pGKDgajBHJrRCEnxLqm2ejSmLHrBfBS0OQpUsXJ5gr301S4gcQfMDgkYgrLeWqQlqHv/fYFKSE49Pevd28cGcXQ1N2jt9OIylK0RtUP4Sv00OGMz6QmCK1J//y3zxYIGNsysfz3IBNp/Es0UqoiIL958iVmR6+agy1pPuHPQdxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773477358; c=relaxed/simple;
	bh=o4zhdnHI/RsdvuhiFJb/eFdT2q4UfdW+DaOx12olis0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pKi3Y25kgzgb0tGyiSDj3jM2iFvGJ7kNmw23o4qfKBCbh6Rk8bMkbcnVZ/+vRV/HfC5AAI8Pcj5zFbUNZOtqfjhDjH++RunVOzchmZ1GQKBNBdD7LhZFt41EggDLk80S1EPB5OlBdA/MoaTPElfvWtuYiBqIeB5xtPO1GCUtFm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Ot3QKLGj; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=7g
	gQWBCcQwPoIbN/IMeOTEhO9TNJ9KZTWuVOGYE8prw=; b=Ot3QKLGjVnNYM5XTYz
	x7fwzjC9AY/egNV35IiXgIWYSL3V6QQmGfSeDmjzIeCahGOF67I7KBkA/ohl059b
	LFlPlZ89uwZGl3A1PZpfvDwGCCBQwp/BmWTwPgol+6ny7ZMD1Ks6O9UFHG60sCT4
	OQq2FTH2Q3cxiiftswoVsMQBI=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD3P4zcHbVpWkWgAw--.7725S3;
	Sat, 14 Mar 2026 16:35:42 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH 1/2] examples/send-zerocopy: fix -Wstringop-truncation on ifr.ifr_name
Date: Sat, 14 Mar 2026 16:35:37 +0800
Message-Id: <20260314083538.791693-2-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260314083538.791693-1-yangxiuwei@kylinos.cn>
References: <20260314083538.791693-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3P4zcHbVpWkWgAw--.7725S3
X-Coremail-Antispam: 1Uf129KBjvdXoWrKw13Zr17uF4DuFyDZFWDArb_yoWkXwbE9F
	sYvw4rG3WfJFyDtry8Wr4SvFyxGa4UWrySyFWvyF9rAa98Ww4UCF4vgr1j9rW8ZFsFgF9x
	CF1jgr1Utay5ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUjYiiPUUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6h5G1mm1Hd58hwAA3A
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
	TAGGED_FROM(0.00)[bounces-12671-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: 6183328C314
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


