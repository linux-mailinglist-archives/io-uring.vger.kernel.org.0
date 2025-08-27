Return-Path: <io-uring+bounces-9302-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F247B381B6
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 13:51:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 465E61BA32F4
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 11:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 032D52EF654;
	Wed, 27 Aug 2025 11:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="x2aQd+Fe"
X-Original-To: io-uring@vger.kernel.org
Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DF279F2;
	Wed, 27 Aug 2025 11:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756295481; cv=none; b=XIUPPRUmJKTGo13gXttlkqU8UmkK+STXDLN5TtWEUzucpbDrBnsnb4bbZvhdlrzaby+t0bmq0axOoQcE1j3ZUccN/L8SSNPb93IEX88I8lW5eJt8IqScyBANyvB6sbFCKp1a/yApKpw9ELkIot0uRSRqRuGmDKJ3sLLE58WIvQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756295481; c=relaxed/simple;
	bh=ccyX1PDsjLelMFjOfiaiMPG+qkk4GLlT/rYXDlrW0KU=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=qwJizFcc3mj3FUSmVFVIcjyOKleqrbtMBB6t6F9q5W1SPGHjSZACsRoYmNVWyh+4z+WqGUBuIlu/Qozf0oLvc2Dt3xqMU551w0pHvkE0eLsxiI31S8wYLSy08yY5sOd+mNOC606/OISgp6IJV2QpIx4Ld6QM+GEyNHWunFe9vao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=x2aQd+Fe; arc=none smtp.client-ip=43.163.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1756295476; bh=SeX1GYV2aQwc6O4xvX38s0OKdpYFk5AKG8oI2cIJdqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x2aQd+FeU5/F1nLPe8y9aMZfM9m8Mhi61fhu497J8UY/lDLZ6OWR40MsfzPwTEVy+
	 s/k9+lOXFrlsFAL5VF71T/TBXE+IF5QwczvlyMRV2N+Zop7MlziCqDU+Z2KBV3n6Ya
	 +5mfqdzJxMvTpelOMUZrsTTOZMgCm7Kc+a3+r3WA=
Received: from nebula-bj.localdomain ([223.104.40.195])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id B488E43B; Wed, 27 Aug 2025 19:45:08 +0800
X-QQ-mid: xmsmtpt1756295108trorwj4bz
Message-ID: <tencent_000C02641F6250C856D0C26228DE29A3D30A@qq.com>
X-QQ-XMAILINFO: N6IfSeM/PG+tJkJouisOQ7aTCUC1nM2EvWU8+pRyPsIQSZuXbpl8r1uFQVEIRX
	 ikML9JKhepNZqOqi2h5IkbV9n+YmAGkl+N0k69HsZmJUwL7a55NkUgEMTuOV+/frZI8JHPPNmUx2
	 3OWJKADbDB7Dyuy7+bLWktH1ihhe1RO/CO5v9e5vHcDmHC5HCMPsVPqJc3bdjR1x0lUkpkv8/gx4
	 gQj3YQ7D49P++5lWDyGwbWfD62O7nKLWTdgzb3dIr+NR2WNDa9KWCPCDwdBkUp592suTV4bJxbp9
	 /GEMgfjXWRm5afA886kJgsrxTrYepKkwNPfO/6QF6YS7LJ5VmbTXOtTqq0uMgl0tDnU+SJVstlnC
	 VOdN3FLi9kCUPJhfIcR/SZQqGBJZfJZmvk/0TtfvaSUXcl0XKJRtNsacBhgUHD3OrP1yUE3J5gbo
	 kX9DFIhBfWBFRaQGQ27iRuKFV+VwUtDPeCzP10datidfTFOEYA3gVYd5KClxSi+OcM1tZfyWLsr5
	 bYr/zcRlgUnwTeOrTMYLxeHFXT5+69tGvthogPlPKQvhmRopaM2SwQpjv6yncIrQxiyYCrBu0Ug0
	 tYodv+A380VsaxY+kGPOmbf21ZKC2A0vspuIsCNTKQ7DZQAKzlfMezhHlalqunIslD5Vij+37rrw
	 yhfkU4AEh9jDGHhNavPbawpa+A4Oy9bZJdH5awUtQ6m70+QPqMn1MHrDlix9uWMPqusJ2cFbnKNw
	 BIzC0VXGcXtwKrMQwjO0Fm8aq8N/rcGbpHIGHiBmwGhV29oc/SgreuS7iv5F0lOAOTqF7js+DKeB
	 MDkmGdzaDsxWIXGrCvUzrXhVBQC08u6MA70y33JHrV1+nDp25Tysu+I9n6H+7vKe6mZDWNJoTC0B
	 vZUtvpXJOQBtdJCda4fKUHGaFz0DPyW6WU0onluR18lnk8H3D7FMWEV9og+ylzO6eK1AvnB945eq
	 xTV6ECDPQqLHnwOm1UhWjdvthggSaCXDOWWXAI6aaIjvjS3Q4AQ38kNwYV4TOo8KlT9oswsWd6tF
	 U3XTFxoZrlaej5zaGkOdFwBZTT5E9OunsFWlxarUhp8EZTNTZ7B8Fe4/6+CBnCU558eAmkpRQGGV
	 /xiBHyrwSfw5VeybOjUkYW9N4Xpf+mEq5KiWXe667wYty5LITZlHHwPz7L+FJajJjIHfeuBc5Ggs
	 hQem0=
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
From: Qingyue Zhang <chunzhennn@qq.com>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qingyue Zhang <chunzhennn@qq.com>,
	Suoxing Zhang <aftern00n@qq.com>
Subject: [PATCH 2/2] io_uring/kbuf: fix infinite loop in io_kbuf_inc_commit()
Date: Wed, 27 Aug 2025 19:44:53 +0800
X-OQ-MSGID: <20250827114453.368894-1-chunzhennn@qq.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250827114339.367080-1-chunzhennn@qq.com>
References: <20250827114339.367080-1-chunzhennn@qq.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In io_kbuf_inc_commit(), buf points to a user-mapped memory region,
which means buf->len might be changed between importing and committing.
Add a check to avoid infinite loop when sum of buf->len is less than
len.

Co-developed-by: Suoxing Zhang <aftern00n@qq.com>
Signed-off-by: Suoxing Zhang <aftern00n@qq.com>
Signed-off-by: Qingyue Zhang <chunzhennn@qq.com>
---
 io_uring/kbuf.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 81a13338dfab..80ffe6755598 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -34,11 +34,12 @@ struct io_provide_buf {
 
 static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
 {
+	struct io_uring_buf *buf, *buf_start;
+
+	buf_start = buf = io_ring_head_to_buf(bl->buf_ring, bl->head, bl->mask);
 	while (len) {
-		struct io_uring_buf *buf;
 		u32 this_len;
 
-		buf = io_ring_head_to_buf(bl->buf_ring, bl->head, bl->mask);
 		this_len = min_t(u32, len, buf->len);
 		buf->len -= this_len;
 		if (buf->len) {
@@ -47,6 +48,10 @@ static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
 		}
 		bl->head++;
 		len -= this_len;
+
+		buf = io_ring_head_to_buf(bl->buf_ring, bl->head, bl->mask);
+		if (unlikely(buf == buf_start))
+			break;
 	}
 	return true;
 }
-- 
2.48.1


