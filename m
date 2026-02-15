Return-Path: <io-uring+bounces-12227-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CBTeN55Tkmk5tAEAu9opvQ
	(envelope-from <io-uring+bounces-12227-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 00:15:42 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CD171400D0
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 00:15:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 336093006B15
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 23:15:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C112C218AC4;
	Sun, 15 Feb 2026 23:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EhfxX2W3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA3E17736
	for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 23:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771197338; cv=none; b=bipcnbGe6sE1NqzJu/jpM6F+CJYlu5C60dj73lfaTdX3WFdSNmMaaglC3fxeuAF5oKjJWkCN+GQTABQ/N33dxqOEyxtxvY9xV1q5KYKdqX/ntegu2P53vtG6tZ0e5J93SmhTS+mIplwH5SwGg/D76iX+ltiaV1d6MDnxXh3pE0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771197338; c=relaxed/simple;
	bh=VHaE1qH/vNfAbmIj9H85V0LRn/CxNxtosu6+KrNlyU4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h3jYA8KOlOxhtkLBab2gVF3FRJwSAnz55/Wq8+31zP/RkTHiQWtECB/lzY8kPFIAL+0ONupSnJxTQ/6v3StCnECSMtisJ/Y3qgYNz06QHFdMm15nAP9xnsuADu51rl/MmAeX+OHeA16WyUxZxbrLcJBAE0+V+DkMIUIpbuNEUDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EhfxX2W3; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4806e0f6b69so19850135e9.3
        for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 15:15:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771197336; x=1771802136; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7kPDK0pti3fCly5apvA5k9zBjT+FAQ4Sk6VhfjFwHqI=;
        b=EhfxX2W3NtcV3DQXICjfRq2imtNM54TViBEAedquRguX/5rpSLiwW00Fhr+2nWv2ev
         kLj6P7Vx3ota4iFBcM+yYowaRIH2wg5gc5IxWTZSNCtqUYkuPq+UhtHa/AZpJIseWYtr
         ByqKs0dU1HjN9U8I/B/efB9EdNgpkuyotIkkW6hZ2jJ29KHPOew9iAOj0u1w141wJfND
         5uKjp285roEanR6qw+Q79iio26qM6v2PWa1pB3rTM/fvoED2VsFoqh0CGZW0tWra3gVh
         0qIQor0ufWksbBFtPjVjtRhJfyyIZJDABQhWmxSc4RWx5JJlOwh/OpxqcuvOAasLEHLL
         QvMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771197336; x=1771802136;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7kPDK0pti3fCly5apvA5k9zBjT+FAQ4Sk6VhfjFwHqI=;
        b=VFmljIn5dBM+h6BjRfZAAIHfbRto1wIGmmqlcTNPfmNms0NRDZ3K1X+QkZ7VlFbi0B
         9Pk5cCOAA8WZ06mPBhmnVI3Bl0cJrYVdeVUM22A25j6wlbLYR1aDTmo6bZH3G3TALGYs
         GdULuB3qA9raM8I+5wd4zt/3/eNyp6pQHaX/6TMRItMp97mN+mU8lrL86gWgJEacF9fa
         Mc7J2lJhtVl1LZmEtYJrJkcYeGbu2O+AY7KHmhqIYPDMxXa9TbOhnOsY0BPatW3m2NmF
         NWIPiEXZo/UYtEUwp1GMBty1+EeDJyKTOKDmLD8vPh7j8cwbHszQWwXpu8+DrXTnehIO
         1HKQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8t1R+HP3dFinCSLUqQeJ0YXFVb+NhpA9alsqVLMVczmi3GKZiwNmcRnAhwonMt6rUNGDwYYIpHA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyJoUXTWT9OxTN3CJHbJTRRbvqfcXo4hlv6DYOmmJnOscg4r+Hm
	zJiRyt1l+WWwZOnFg/yYkhYdrk9uUlQKMrYGWhQBiUfX8pjnaoADFZkw
X-Gm-Gg: AZuq6aI8VU7vfnvpHiE1g+oYlVjnWw+hyX0UJAMs0UvdwTxQlwbsk1qYiZbwTVS0S+Y
	O/JNB2fjwoHxzPoledgiEI2FPWUi+WRQaDd+/VH800InxCMxWZJdrP4sRv9Vz5k98j5rbHu66Dn
	AX6V1Zrqdf8xUDrCHMp5lzpkHQGWJZpop5UyebfDgn74UuTSf2UKqH5QvXnzgJnNNxYNGbJe7GC
	f+JRNkcRv8E0LIBGrloi/iuPPVbjwPWnQBMxLJdfpeYsYNY7Kz1iwPCLgnrNhaJA7fehUfqw2V/
	Oniq0eARWQna1fmCAbn1XresWDQnXxKkBai5ho4FHPNuTtVIU8GYlA4EU9JMHLCNvBxYHRw85+l
	v/C07vRA3fX0W2wea0he815HKTDp5LYYC9aO5A7V9i8uWMl4AElxl9QV11rJlZeucaWZweGxs5R
	PbocazQ0b0/JuYK8RysDMmHOpWBd7lbIfpUIvJeEw4Dw==
X-Received: by 2002:a05:600c:1991:b0:480:1e8f:d15f with SMTP id 5b1f17b1804b1-48371043dbfmr149828225e9.2.1771197335658;
        Sun, 15 Feb 2026 15:15:35 -0800 (PST)
Received: from puck (234.243.199.146.dyn.plus.net. [146.199.243.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796a5d156sm24789446f8f.5.2026.02.15.15.15.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Feb 2026 15:15:35 -0800 (PST)
From: Dylan Yudaken <dyudaken@gmail.com>
To: axboe@kernel.dk,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com
Cc: Dylan Yudaken <dyudaken@gmail.com>
Subject: [PATCH] io_uring: remove unneeded io_send_zc accounting
Date: Sun, 15 Feb 2026 23:15:23 +0000
Message-ID: <20260215231523.308665-1-dyudaken@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12227-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[kernel.dk,vger.kernel.org,gmail.com];
	FREEMAIL_CC(0.00)[gmail.com];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dyudaken@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5CD171400D0
X-Rspamd-Action: no action

zc->len and zc->buf are not actually used once you get to the retry
stage. The buffer remains in kmsg->msg.msg_iter, which is setup in
io_send_setup.
Note: it still seems needed in io_send due to io_send_select_buffer
needing it (for the len parameter).

Signed-off-by: Dylan Yudaken <dyudaken@gmail.com>
---
Hi,

I'm reasonably sure this is correct - but I think Pavel might want to
double check that I did not miss anything. The tests seem to pass with no
changes.

Thanks,
Dylan


 io_uring/net.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index a6f3cbb7dfea..8576c6cb2236 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1493,8 +1493,6 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 			return -EAGAIN;
 
 		if (ret > 0 && io_net_retry(sock, kmsg->msg.msg_flags)) {
-			zc->len -= ret;
-			zc->buf += ret;
 			zc->done_io += ret;
 			return -EAGAIN;
 		}

base-commit: 26a4cfaff82a2dcb810f6bfd5f4842f9b6046c8a
-- 
2.50.1


