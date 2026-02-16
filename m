Return-Path: <io-uring+bounces-12267-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oElPDf1Rk2nA3QEAu9opvQ
	(envelope-from <io-uring+bounces-12267-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 18:21:01 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E256146A9B
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 18:21:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2A3C33013794
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 17:20:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6A8F28851F;
	Mon, 16 Feb 2026 17:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IqFjFzJQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A83838D
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 17:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771262458; cv=none; b=Bx9D/f6VhycJ6ZeI+Tt78PiBjuDHBYm+pzdZLrtEGrEfbONuUkm5IRzQECbOEJnxfSk/8Fi6RP3ScA296IM44E5K+GiS+2mZpljvlU8tpVx+6ym5suvoqw3v0PRM0WExPcFN6YcuJSaVBg4VNlMyj0WB7uAWVUR8oxlg2EdB2vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771262458; c=relaxed/simple;
	bh=d4xCA5o3bpu0Ihp8UMw0GKKfY7C7PvTn9X4IDpbWwdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CJhe/Ftbh0hV8Eb1fFxycOamr4CbuNk8HAp5oYntkvKOgGv6LzRw24BXNeAsF++a05cZXak9y+2p2YvxZZa63b4mNrDej0PVcC8PWW3M7/t/pF0+YSdlLZ/oaFWC1B5U7M0x07mWQbR6vgQdDYoOG+lp5tMbe9Y3xRhB23xf50g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IqFjFzJQ; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4837584120eso21732455e9.1
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 09:20:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771262455; x=1771867255; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=D9sKiAeFp/cPKhL5UJUSwwiatyz+rLqRHgt+WzfD2Vc=;
        b=IqFjFzJQx5EYWAXxkKeFkiJ9N8yXH4KxFBzUUc12QqR/R/vm5tNdWK+aIUYQc0Pxhv
         9+OdxxlsHpNZE4EMipSY/OCX35ntvXtzwxIH9DAuGhSv1Hi0oTfIc3OZNH6lPbbh1ANa
         8X27kJ4JfwltY8htBGJwUcuP+DEDfLSAicZKhaXRHsdfrBAvhHpIvd0ThdyJCctb8Uln
         3DeLiNPE9tSJwu6/1c+Sj0Bk18o+CcefmnIClCmNbNIJfIyIbrf31c2pJz17u7T2XJ4n
         R454erZlCtWHidMO/Vqa9oSiFmbo8ZBm0CiZm14hY7L2S3uXLHV9h/AdsntBRzFJXy70
         P7Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771262455; x=1771867255;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D9sKiAeFp/cPKhL5UJUSwwiatyz+rLqRHgt+WzfD2Vc=;
        b=MRVIDSMsdsNTMI9D6kgzUvaGE9WPp3O65sd9ZPo5x+6PMxwTp16P1sOKGlkcO6o4Iq
         W1TVcLjW4XFu+QZyBy0Z9Jg9vfZu7uBmPM7bCcm40isYwAM9tsiUA/D609MjkaqGh081
         BWaNAphhcDSsMBZqSug1dgZ5WlR0/5aOIPPuP8d8HddR1yBow8orUzqWEtR/eGGe2FXJ
         an7U5g5/t1pkJAa3HWCP4CZVQP43nOfRvmFNxdrisxiJwHQk3+13u5GGhvdv77S7X6Yl
         fSlLu12yRBB1wAq5Ac387DLtBtBAn6mzovBOENyNAYe23g865gCIWf3DYyzfx3sno0UD
         Hi1A==
X-Gm-Message-State: AOJu0YwJvMH5z5xsOL73NbDcDsurrT4jLr09Gwc21z04bEmENJOqlLPA
	7pWF53lWcM8ngQfP7K/XpxP2fj665UKR0eOboaAl3Pnu8N0aXpdSSl8ibJw1bVs1
X-Gm-Gg: AZuq6aJRn9eJBKHzOtb5S6ZlIheSW6BRbJt6BvwBvrxp2lp6zpcKLr+R1u9xkjX/Xbn
	fqwlLXN5LgGCh0RaK06MLgXfz1Aft6K/8V3VSeORP2tfFoEkkuF+c/xY9XzvsHEj2/LYs/DK9l5
	GzVXl7Syt7uoo2xdIXkl4j1WMCszOr0sOpgp8uNF2khqIjmgWqLey2Uvr2asYqAAgYTy8m3GkGI
	c313i1PRjyeYFMbKPSYYmABtrpn1NdSu8+XVeYdmflBjAJWXILB9ILVCprHXutUshsTBROHBBMz
	MTwOqAPuiUHFHjjsEhFh2N1gx74PdfvLLXc8tM3rWiz1ed78/V//HCKPmZ95/3GA8J4C/juI0fx
	dgSJjDcjL/+vwNl+eOY7PG8PHX2Ignidr9EltD1dFFEHkM/Mpd6sf5Ge1c5bxdPjI09EoXkhcJY
	UgA58Ru5GEeqBvjE+5ksfPY/GtnH58NcGGtlQl3OzH5Mq7TN+Ha/DTFlK8QKg2+tKF92VlKREbh
	OwBZ6Br
X-Received: by 2002:a05:600c:8189:b0:482:f12f:f35e with SMTP id 5b1f17b1804b1-48379b98ff9mr143532365e9.12.1771262455125;
        Mon, 16 Feb 2026 09:20:55 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:c3fa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48371a298b5sm87606975e9.12.2026.02.16.09.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 09:20:54 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH v2 1/1] io_uring/net: separate notification user_data
Date: Mon, 16 Feb 2026 17:20:44 +0000
Message-ID: <5f4edc94666e8b5e895ec0d212d1e0ceb8ca0165.1771261811.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12267-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_THREE(0.00)[3];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7E256146A9B
X-Rspamd-Action: no action

People previously asked for the notification CQE to have a different
user_data value from the main request completion. It's useful to
separate buffer and request handling logic and avoid separately
refcounting the request.

Introduce a new flag IORING_SEND_ZC_NOTIF_USER_DATA. If set, the
notification user_data will contain the value from sqe->addr3 instead of
inheriting it from the original request.

Note, it doesn't change the rules for when the user can expect a
notification CQE, and it should still check the IORING_CQE_F_MORE flag.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  6 ++++++
 io_uring/net.c                | 13 +++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 6750c383a2ab..e3648147b98e 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -425,6 +425,11 @@ enum io_uring_op {
  *
  * IORING_SEND_VECTORIZED	If set, SEND[_ZC] will take a pointer to a io_vec
  *				to allow vectorized send operations.
+ *
+ * IORING_SEND_ZC_NOTIF_USER_DATA
+ *				If set, the notification CQE user_data will be
+ *				set to the value specified in the addr3 field
+ *				of the SQE.
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
 #define IORING_RECV_MULTISHOT		(1U << 1)
@@ -432,6 +437,7 @@ enum io_uring_op {
 #define IORING_SEND_ZC_REPORT_USAGE	(1U << 3)
 #define IORING_RECVSEND_BUNDLE		(1U << 4)
 #define IORING_SEND_VECTORIZED		(1U << 5)
+#define IORING_SEND_ZC_NOTIF_USER_DATA	(1U << 6)
 
 /*
  * cqe.res for IORING_CQE_F_NOTIF if
diff --git a/io_uring/net.c b/io_uring/net.c
index 8576c6cb2236..79c424717f9b 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1317,7 +1317,9 @@ void io_send_zc_cleanup(struct io_kiocb *req)
 	}
 }
 
-#define IO_ZC_FLAGS_COMMON (IORING_RECVSEND_POLL_FIRST | IORING_RECVSEND_FIXED_BUF)
+#define IO_ZC_FLAGS_COMMON (IORING_RECVSEND_POLL_FIRST |\
+			    IORING_RECVSEND_FIXED_BUF |\
+			    IORING_SEND_ZC_NOTIF_USER_DATA)
 #define IO_ZC_FLAGS_VALID  (IO_ZC_FLAGS_COMMON | IORING_SEND_ZC_REPORT_USAGE | \
 				IORING_SEND_VECTORIZED)
 
@@ -1331,7 +1333,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	zc->done_io = 0;
 
-	if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
+	if (unlikely(READ_ONCE(sqe->__pad2[0])))
 		return -EINVAL;
 	/* we don't support IOSQE_CQE_SKIP_SUCCESS just yet */
 	if (req->flags & REQ_F_CQE_SKIP)
@@ -1358,6 +1360,13 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		}
 	}
 
+	if (zc->flags & IORING_SEND_ZC_NOTIF_USER_DATA) {
+		notif->cqe.user_data = READ_ONCE(sqe->addr3);
+	} else {
+		if (READ_ONCE(sqe->addr3))
+			return -EINVAL;
+	}
+
 	zc->len = READ_ONCE(sqe->len);
 	zc->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL | MSG_ZEROCOPY;
 	req->buf_index = READ_ONCE(sqe->buf_index);
-- 
2.52.0


