Return-Path: <io-uring+bounces-13331-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4KuyDAXZBWoncQIAu9opvQ
	(envelope-from <io-uring+bounces-13331-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 16:15:33 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 94E3A542EB6
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 16:15:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B7C7A30C74E8
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 14:08:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B972A3FFAD4;
	Thu, 14 May 2026 14:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="lrHlo7Lc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF673FFAB0
	for <io-uring@vger.kernel.org>; Thu, 14 May 2026 14:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778767713; cv=none; b=YG21VfMBGv87Q6t2uoK+dX73Ubb0A5enEgS6Zb8XEs9LXTDSAv+UVAjyTg8PjyYftGnr3W1DQP7Zjjb0oFy66F+fxmkXI9gsVE1gDf2Y8RvPr3mzy3O/C3mAerjIHwFnRW/kh/a83UDzpQhIp14ZoA8YoMgi7BtW7IMe1DlFmFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778767713; c=relaxed/simple;
	bh=klxxVnyGRED1q317T7p7fYo0Zj/3oMSRfd75h/qMGIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPhyhPnxITU5HoDy3j7i0kZlDioLs7dKfz94e9sDGkblEmQcpzEFBKWhx2S+CkTiQILtw3+zZ18QmGN8odHPkKGgsCRk+nPqUTH4TIpIGPoqz624y64B7iqVPEhq5iqqUqO2ivJOgfLNYqDtZXYfAE4fRybQLVdMmN2JeZjpBmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=lrHlo7Lc; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-479d68a9063so3027995b6e.0
        for <io-uring@vger.kernel.org>; Thu, 14 May 2026 07:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778767705; x=1779372505; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/zFTck5W930pgUh3AWU46ER/xD6QLi7A/3R3iLUIHZI=;
        b=lrHlo7LcT8I9P/48q0SJatj1nEyw3NBKJSL7b1LOSysoQ05uY2O3co0d9igjeU4LYH
         PefDlWuzCM8eL+1VJEwPL47Faom0bDS6KQYoaOc1Lo6CSMUrf7ksX1jCQVFHdFHKAswh
         yJDSR8ntQFWctGvgrh+yfdqsKCi5rsm9PKW24HwRsXaZY7rti8luCMd8W9UennESnsY0
         4uS1wgUT0x3M/NWOyb+duQkwb5ptZYvqxgg+N1xOVxp1au/APQ7dCEezGCpu9+/K9vsM
         x682VGefEsJ5AWIia/7TW7Hq8HelayNl3IuiCGVp5CKf7VUtNXqEUF/lh3SIFy/X+cBD
         zdrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778767705; x=1779372505;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/zFTck5W930pgUh3AWU46ER/xD6QLi7A/3R3iLUIHZI=;
        b=i03oSuy94Sf2P9nsLelNfjTc6Yt5rxzSixYavZXtlhxFgS91/svtlaNEpen0SFzAav
         5Z8js0oFuefGZqFn/qqx9h/+2ypQoDn3Eje/ZjHzj397YQHwB758hQTcO2S49qqGFlMt
         j/gUuWqv2y2J2OZ1qZWKJK4/hn+yRqPXjnTo3XajmtOzUr91V6IKrqmlWh4S9xwhNFqG
         fPSHGMWWZ4Cdc2P73SXAFSExnWXDwY0GHkqUl6KhlpclNOCSDCpGN3ZpftnPimn6baDS
         0Zr0AjNJAaU4gbO2R/88WxyLl0RbbpouX0FJIw8exc98fKn34Gd4R6YvNs8OyMvwElbt
         9Vbg==
X-Gm-Message-State: AOJu0YxS4681QdatHAQzDXBI4489iOTk4X6J/I4b1IaNcd8P/JzGEMy6
	VMxBBcr6qdr34HLIFD3lvatTYgZnaK5938hWKugtQFTy4kWw7EuLYPKeXjxNPDVQp05T4LP1kCk
	ajDQS
X-Gm-Gg: Acq92OGyCus8ET6Dj79Knp4/2r7S6a0U/C5rHywCsNc9OzQvgcfrjcUwC+Rb9nvQzuB
	+wZ8SsxqPce6j/yheyX40MyCWRU7Up8ydZzd4qUddakXcuw8YLxkWJEWug2N0uqM/D/ozC/l1jZ
	Zkk6gZp5LNbtMMEvThei8FGJ+pYoLS34F5WU6zubCPs/D5RWtEeNVF5IIbWJgio4NftiErKzuVW
	QWLbN1PdTKzff2R0Bkz0OSCPCBFAoM+ZDFb+D1vTcJ+5HCnPVtiYN8BZIb5kJ0uc6UdrVBAM8xY
	jOAvLe2Pk2dWRDWz5QN/yLfgc1yHOg4jEMH7LSU5bcJNzt/UbHKULHyIqZlCe7ICoh0feiTpt46
	f6l8rZOt3uPh62HFfaGxCPBk2CJ23w5BZ5akipMGxJphnZr30nfTEfAAM96HWgAfBJLPoQdLthJ
	PjDbeFSLfJZz/RkRPbBLd5K1rpui2mTewf5uSB4vz7scpJhqYyR6ZRFMXvtWmoQ/Y4sIU=
X-Received: by 2002:a05:6808:1783:b0:479:ed26:fbca with SMTP id 5614622812f47-482b2db4b30mr4552026b6e.37.1778767705357;
        Thu, 14 May 2026 07:08:25 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-482d379f062sm1394956b6e.6.2026.05.14.07.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 07:08:24 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/6] eventpoll: export is_file_epoll()
Date: Thu, 14 May 2026 08:07:18 -0600
Message-ID: <20260514140817.623026-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260514140817.623026-1-axboe@kernel.dk>
References: <20260514140817.623026-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 94E3A542EB6
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13331-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:email,kernel.dk:mid,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Action: no action

Make is_file_epoll() available outside of epoll. This is in preparation
from using it from io_uring.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/eventpoll.c            | 2 +-
 include/linux/eventpoll.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index f464f2f39e0e..9ea6a2bd3d87 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -334,7 +334,7 @@ static void __init epoll_sysctls_init(void)
 
 static const struct file_operations eventpoll_fops;
 
-static inline int is_file_epoll(struct file *f)
+int is_file_epoll(struct file *f)
 {
 	return f->f_op == &eventpoll_fops;
 }
diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
index 728fb5dee5ed..7bf30e9f90d7 100644
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -63,6 +63,7 @@ static inline void eventpoll_release(struct file *file)
 
 int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
 		 bool nonblock);
+int is_file_epoll(struct file *f);
 
 /* Tells if the epoll_ctl(2) operation needs an event copy from userspace */
 static inline int ep_op_has_event(int op)
-- 
2.53.0


