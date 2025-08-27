Return-Path: <io-uring+bounces-9301-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E017FB381AA
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 13:46:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 473AA202326
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 11:46:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 499B92E1C78;
	Wed, 27 Aug 2025 11:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="xKrA0cs9"
X-Original-To: io-uring@vger.kernel.org
Received: from out203-205-221-236.mail.qq.com (out203-205-221-236.mail.qq.com [203.205.221.236])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EF028153A;
	Wed, 27 Aug 2025 11:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.236
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756295044; cv=none; b=dvt03Kl47CS4VICBaFNiN2KlqfxM741rZKuaaWJ2uN0tv3jhxwxfqEzYDzNbs7q3Vx7J7T/snB1EKUxoY8bjaO4hul3nIoLIklheP1edKHqPzl/pkfqHaeaUcgiAqB4gThguT5sspf783PRBQO7deT55W5Iuvh/O7WQ79ZtPrvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756295044; c=relaxed/simple;
	bh=maxOuLp+3eDlVrsCfHLsVqwtISDLilRKcgsGzZm7U4g=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=JRBSDqSyaSsAT71VfjYj+71lfAaJ+C7s8v17A1bXcjrAUTaHrg9HJolMsPNk/oRqLbXBl0NVWcPr0UQ2KYrZZ/pp+vb/YMgzp+to1NIqhg6UddgWpbTVZpmTz12Xy8CzZTcow66w4dGf6bE/liPvwMjHLxSvXY47hrl+FUhFn8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=xKrA0cs9; arc=none smtp.client-ip=203.205.221.236
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1756295036; bh=gYYoL9ur0b6yOBAcZYJs4w63IqPJcdSJT/UvgXbeYXo=;
	h=From:To:Cc:Subject:Date;
	b=xKrA0cs959FcXKBIsmrZ+LJLc8bli+bFINTJWUDXSI8q5wtRlb5sXbW4uxvZs2gT+
	 DNbCWObDK/Dat+gHewVCXYcjEzfvBbINxIbBWNHglsomtMWQWWn7BpImjTUOtbpb8Q
	 VVChQ0vnX54QI+3dwGpgS+2KU1GECVyraYSXGXPQ=
Received: from nebula-bj.localdomain ([223.104.40.195])
	by newxmesmtplogicsvrszc13-0.qq.com (NewEsmtp) with SMTP
	id AF614AE0; Wed, 27 Aug 2025 19:43:54 +0800
X-QQ-mid: xmsmtpt1756295034tpsu050ul
Message-ID: <tencent_4DBB3674C0419BEC2C0C525949DA410CA307@qq.com>
X-QQ-XMAILINFO: M1JY6XCfJolWwkDmIRncCfbgXfxoDJ7U601R46Q2Jc2fHurH/S8eBVm5GNQtf8
	 +SYtqAQo8yudXmV6FCQ+h8AvgbR5P9RzD531k+oYc3lS1fNWu3KoRKB2ugWLzZ5UDWUdbN6XNN0O
	 W4roizeFIxfWG61oxzjd7sSImrP8xK5IGKog6kWBdfQg173j/mor/PBvyvN6deaQUV+hug3rxLrc
	 JdqaKwPa3D4RpxnxqOGqNuqjeu8s/0sEX9M22SRs773zMP9kJmnUpN5aH8FJloVkoTxD1G0pvTgZ
	 vl/9Lgiup5aRo5HKtBN11cVRrzV0sHBA9NqLUSMghuIi321GTJg/2QBOQWJzwCUB+MjNb6hs/xMf
	 RtwTR2wl/LdaKkJpxXUs1ITPvZ/VaZ+TUXk6No1GBli87PA+yyHBSNULrO8c2YFyBzP/yVfAYpem
	 dS6HbSw4ipKoHvHVXgETta++tx68PgecGkPoztrwufJEwqTPi9fNYmj7gS4Z2R/vcRJ0xZNPEFrm
	 ZH2wRlmCyoBqA8AiMJ6457iy5jGdRPxhRsw72J6it1jtyy1MmvrpiwQNdE44sTGozAcH0JEdFvBh
	 RUV7L/BLhEdkYcRW1o1rJzokI/vFuLonB3yIJAiuBpwrpe0qrElUVog0OKFUsf6u1/JgYGBBGhT+
	 RFtJUnYivBCLkMC8lvcFLKleBMy0/OszY7u2GsHuMA0dFIi+4jnSqZaP4vO9J1F/uSHj3O+hAyob
	 Bd94LyjBwzcYWaUurgLm+vVgVhiGMZe4HfSU9zNHHxj2f710g+QFyzZH5mch644NQP2ZrWHO3oou
	 7G2iZ0WASY1KfmHOjODbSA6JMDh2Sicx/bd4A6LebfMD2BJJq2yI5eGZYqmHIgWcFkKMQv1tuy6N
	 iWMgDIz75Vq60SsbdtovunTlpbeMX6CkfGdUEPGLaRQYKvyBwQB6XWTdYULgAmq9/2wm2Nc+T0dC
	 TNbSkSDl2mLC+CjTtUfh8gBZYt/cUD6Vo2gx7M7iS1AXB6Z8zsi+TtuAwq013OohOsrBpwf6yXEV
	 7hWUwwQ5WJxZJEOfhzdUez2r4EnoY6M/nmPrbAVtflboGgfWBzM9E3peofgscEkhcQIvM4kHQ0UB
	 WNKPL75WLcP0PATasv0pdI8I6nh3ozpGz5iWk7G+ZcpwoO4Q682IIGg46AOm+XpREKkDl7JYrhAr
	 Ne1gQ=
X-QQ-XMRINFO: OD9hHCdaPRBwq3WW+NvGbIU=
From: Qingyue Zhang <chunzhennn@qq.com>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qingyue Zhang <chunzhennn@qq.com>,
	Suoxing Zhang <aftern00n@qq.com>
Subject: [PATCH 1/2] io_uring/kbuf: fix signedness in this_len calculation
Date: Wed, 27 Aug 2025 19:43:39 +0800
X-OQ-MSGID: <20250827114339.367080-1-chunzhennn@qq.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When importing and using buffers, buf->len is considered unsigned.
However, buf->len is converted to signed int when committing. This
can lead to unexpected behavior if buffer is large enough to be
interpreted as a negative value. Make min_t calculation unsigned.

Co-developed-by: Suoxing Zhang <aftern00n@qq.com>
Signed-off-by: Suoxing Zhang <aftern00n@qq.com>
Signed-off-by: Qingyue Zhang <chunzhennn@qq.com>
---
 io_uring/kbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index f2d2cc319faa..81a13338dfab 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -39,7 +39,7 @@ static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
 		u32 this_len;
 
 		buf = io_ring_head_to_buf(bl->buf_ring, bl->head, bl->mask);
-		this_len = min_t(int, len, buf->len);
+		this_len = min_t(u32, len, buf->len);
 		buf->len -= this_len;
 		if (buf->len) {
 			buf->addr += this_len;
-- 
2.48.1


