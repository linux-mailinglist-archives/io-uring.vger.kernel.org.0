Return-Path: <io-uring+bounces-1013-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DB9B387DA31
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 13:47:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74DA41F218A5
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 12:47:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4613E17722;
	Sat, 16 Mar 2024 12:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="wBihuBHb"
X-Original-To: io-uring@vger.kernel.org
Received: from out203-205-251-66.mail.qq.com (out203-205-251-66.mail.qq.com [203.205.251.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A50DDC3;
	Sat, 16 Mar 2024 12:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.251.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710593266; cv=none; b=aQNEVnJpBUs/J0cZrH50g7WetZGInecOtgEBath63l2Of7jVbuNmh82gerqgvlYoQ3Rgk6UHYto4NAW1iqFMS9/PwrngALTvzlFv3LApj1VUsai4FlTevzFxPwQ0vz7+ZTT0b2u44j59OpbHmE9aSeB6+qB+PuRMpAzGnxMnIXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710593266; c=relaxed/simple;
	bh=tQaFUnIdO5CKC9alDHRa2C/PIBbjIjrg2ogPsbneuBE=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=jChVbeWQOec3eF4NBFNJi/qSPqa6mUtd1TIY7xqAVW7Za/HxcvZIzpBGIXepwriHAd/6IpANAYefxX1R+EIBpSY7T19yjGUlVVEq3y5rDGM4q5V+nqYtHJuy8ebuZjMEsT7sQUHXBe2iS//SEF0U7azM9B7OkWy8fUX2DKFISZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=wBihuBHb; arc=none smtp.client-ip=203.205.251.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1710592952; bh=Rqkwy9I2RaGd2cVOFtNOTpk39pneScI8duXDDLL7M0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wBihuBHbrVnF5yV51XV4IIv5dlHyf2LKsApoaIEdCcrSCET1kF9ciMvYePOdBkiCT
	 NLfekhelLBEyQ43Ky8YsEWgSlOd5tPi+uIlNV+0gvDNzZApI8qHHjIx0meLrnJX9EL
	 F7dRVZA9hLKRcsuSKP9ruhgUVLyemioxrS/bN4H0=
Received: from pek-lxu-l1.wrs.com ([111.198.228.140])
	by newxmesmtplogicsvrszb6-0.qq.com (NewEsmtp) with SMTP
	id A9E26826; Sat, 16 Mar 2024 20:42:30 +0800
X-QQ-mid: xmsmtpt1710592950t1wiwff13
Message-ID: <tencent_6C22CC2079326CC82FB96CD89458E9F6EF0A@qq.com>
X-QQ-XMAILINFO: OQhZ3T0tjf0aNQ6/zQrKjDc/YllEgtBlreFWaRhZfg/aSkV5nGAPvsPRdf4KZZ
	 ZgkTYJWollvQbPmCeThbRmkjpFB8Qqg0KrM5fumSrwrg9ydWM1EbLqHx90qnKmWPgdqbSaRQ+hhj
	 n9qjZxGHQMs7oLiePEQ9Fh3gIXzjxXx93UDVausznAVtcMe9UI80fMJ4AP7N1L+mKhMTxMhDHyjl
	 On4RoqoV0O1I7I3yPZ0RhSH0aIazm6bRZqSIl9TisKhz56ChGHkH1kwkXmunfQ6lqu8JIG8J3Lqm
	 quK1PfLj/dIpLKypc3LUg5OXgmeJKMYwt7JoUQN+24qPkSsugmipznU0rwxLJO8SIdfAIWtiBwYS
	 92akOSRzPFHcnH5nSWyExPwDk6kZJAE5Fi9IKELIeJ0aVE+8CRuHsR39GzlACZzomy8g3bGHRSi4
	 SXvDOX4csu7533SViGSEPs3VYk20u2ufC2Tt8wq/2nNlA2kBLe3LOaEJnRvOwOcbm3F9mBj1egz7
	 +vqvG1RvrhePCRVF/B0tR3adr3pHxJMAnnIa+MoB7sFyBiJuvM7BZPjErTBOlralwRpTpd3gvcsV
	 3Ovq0lBhv9W9Piri0aANnucgdOJHhxyrktmWXglDM4XbPZo0LgpA+bbaAe7pPZRdaImqqWn8UZ1+
	 ZDJhMIQMhZSIrFvbdg0lImEhxVGETwgCiERRVwbiiR4hSwtQfLM4rL7/wo90dmylQWuSdgJYhMZq
	 M7ALVuWunbSLykBwvPJ+tEwM59VIQSU+yQOuvsKPc5ej2FPJINSJwpJdJMsEI6+pF6WQTHXeMQaz
	 Hk1i7umGsk1kf9+j+Q0zWYruJXSjYf5NEhC7O1BrOwDrk/teT8A7qr+d/o+irNvBYmmqmqL+wxR7
	 Wz9ej3P7DzluVNVvxpt30Z9sOurEI/iTOCGE0SFNjaEKZRw76jA4Fc5IkxxTxiHSJa0iodYfE+KM
	 Vfkvusp4Q7rh+0JJf8Ow==
X-QQ-XMRINFO: OD9hHCdaPRBwq3WW+NvGbIU=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+f8e9a371388aa62ecab4@syzkaller.appspotmail.com
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] io_uring: fix uninit-value in io_sendrecv_fail
Date: Sat, 16 Mar 2024 20:42:30 +0800
X-OQ-MSGID: <20240316124229.1745430-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <00000000000024b0820613ba8647@google.com>
References: <00000000000024b0820613ba8647@google.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[Syzbot reported]
BUG: KMSAN: uninit-value in io_sendrecv_fail+0x91/0x1e0 io_uring/net.c:1334
 io_sendrecv_fail+0x91/0x1e0 io_uring/net.c:1334
 io_req_defer_failed+0x3bd/0x610 io_uring/io_uring.c:1050
 io_queue_sqe_fallback+0x1e3/0x280 io_uring/io_uring.c:2126
 io_submit_fail_init+0x4e1/0x790 io_uring/io_uring.c:2304
 io_submit_sqes+0x19cd/0x2fb0 io_uring/io_uring.c:2480
 __do_sys_io_uring_enter io_uring/io_uring.c:3656 [inline]
 __se_sys_io_uring_enter+0x409/0x43e0 io_uring/io_uring.c:3591
 __x64_sys_io_uring_enter+0x11b/0x1a0 io_uring/io_uring.c:3591
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

Uninit was created at:
 __alloc_pages+0x9a6/0xe00 mm/page_alloc.c:4592
 __alloc_pages_node include/linux/gfp.h:238 [inline]
 alloc_pages_node include/linux/gfp.h:261 [inline]
 alloc_slab_page mm/slub.c:2190 [inline]
 allocate_slab mm/slub.c:2354 [inline]
 new_slab+0x2d7/0x1400 mm/slub.c:2407
 ___slab_alloc+0x16b5/0x3970 mm/slub.c:3540
 __kmem_cache_alloc_bulk mm/slub.c:4574 [inline]
 kmem_cache_alloc_bulk+0x52a/0x1440 mm/slub.c:4648
 __io_alloc_req_refill+0x248/0x780 io_uring/io_uring.c:1101
 io_alloc_req io_uring/io_uring.h:405 [inline]
 io_submit_sqes+0xaa1/0x2fb0 io_uring/io_uring.c:2469
 __do_sys_io_uring_enter io_uring/io_uring.c:3656 [inline]
 __se_sys_io_uring_enter+0x409/0x43e0 io_uring/io_uring.c:3591
 __x64_sys_io_uring_enter+0x11b/0x1a0 io_uring/io_uring.c:3591
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

[Fix] 
When initializing the req object, increase its member cmd initialization.

Reported-and-tested-by: syzbot+f8e9a371388aa62ecab4@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 io_uring/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cd9a137ad6ce..3db59fd6f676 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1066,6 +1066,7 @@ static void io_preinit_req(struct io_kiocb *req, struct io_ring_ctx *ctx)
 	/* not necessary, but safer to zero */
 	memset(&req->cqe, 0, sizeof(req->cqe));
 	memset(&req->big_cqe, 0, sizeof(req->big_cqe));
+	memset(&req->cmd, 0, sizeof(req->cmd));
 }
 
 static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,
-- 
2.43.0


