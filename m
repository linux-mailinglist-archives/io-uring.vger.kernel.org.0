Return-Path: <io-uring+bounces-12970-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gG1sBU7m02n/ngcAu9opvQ
	(envelope-from <io-uring+bounces-12970-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 06 Apr 2026 18:58:54 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FFCE3A580A
	for <lists+io-uring@lfdr.de>; Mon, 06 Apr 2026 18:58:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9D020300825F
	for <lists+io-uring@lfdr.de>; Mon,  6 Apr 2026 16:58:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8753838B7D7;
	Mon,  6 Apr 2026 16:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LYyOPM9u"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74F73876BD
	for <io-uring@vger.kernel.org>; Mon,  6 Apr 2026 16:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775494731; cv=none; b=oyq8E6MzKZIo6HXzHTm7fCTDWpAHjR04e0FjOdX632jZBFy4Pr0s5Bb2sZESzRxULgehbZJLtsVfpwkJd5NpSsECd0R6y4Z+YdWGy6M4t5dQo5N9L6ijbKeAcu5BlfqGTwrwnzeZHQN6rbP8UHzS3Da/uExjmzKLVZPuf0Gww8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775494731; c=relaxed/simple;
	bh=26psbkjSyDX7x9vT6U/2KCAGMBmxua3SiQxW4R9sbRk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gNmuu+2obG608wyWap7dqES6+jNfSRG1ZO2fbYW1UHUQZLTZW6Z8bCtou1Uz33ZyXW+2ZVCP7KP2Wo5Je+Pg4eNNrPzdgxk4CFHZf4DGcBmNDIXX68yKo60WRGH1DBH6PzuilMqIVUis3Tz+iPkcaaVzhtonBuN0UQnjnlsrlNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LYyOPM9u; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-488aa77a06eso23195165e9.0
        for <io-uring@vger.kernel.org>; Mon, 06 Apr 2026 09:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775494728; x=1776099528; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sGkjJxTK2yrZpo0kjeCsz8SUN93R3CIQmF73mn+CUGQ=;
        b=LYyOPM9uxrWCbSG9KgdXWjc2qvCoGezQc+yAxBM6+FkeK6RoEdWhjeB7ozk7jJSQCb
         Rbt9qmNlzLRykArf/GnbzgnEvWSOcirhHFL6TFyh98C2xl3HsXd2sz2FbxGkby0zDGLp
         4eWOWZNG0cvNWK4tE8SA6Ht8RPfhVaJn7pPh6xv7KLPrAf3AfKgUqIW7CpXL7BYlakqe
         Fd6NW2SXiLj0TGAvBriLzEo9BiX5TTKTujUlupD+YpFREPtiLg7w3j5N5zI9O5yMLlvD
         5VdXbhOQrQEAm52EP+a26g5OuuCt10QyRvZ40kmkCfAv5ussCVAZm9/0lcygJLt6op3j
         WPlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775494728; x=1776099528;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sGkjJxTK2yrZpo0kjeCsz8SUN93R3CIQmF73mn+CUGQ=;
        b=DD9PKsVKFBywZJC61mvnVG4yRYKua/A0CgQGJg4IQetf8y79E5/fruCUpQQRZ5oX75
         /Cd6njAM/yVYhaXv5pfRJSBcQkpUoK28d2i+roOj3vBFxJR9Km0mddzY0zPZ+y+A9qro
         H2BVUvdr+AuWxNucu9tB97TMxIPBvQc+TpfZ6Jw38g+UA3gwveIxZ2betZMKc9y++rsw
         VNnk/wK0Dcwsb+4QcaqMpDuS5uztNnHSIO/TaasXJjc7Mne/QZ0KY4aPat6iloicRcZD
         vtxCV2P5Um4tTs59PYOvfMGsxKb7oqofw9a/WLukiEaaXgICIARo0hKvWPCNugz+2FYf
         npKg==
X-Gm-Message-State: AOJu0Ywnr01tdPdrXpPBlduG/XeW+vfLV3b0v5bEYgMEGvdoVZO0CmiC
	VyYgpZbis1yuUTSibdlPS7XGjLIR9qHxsEk4Q0i1oMvp8HkPa9XFHGpQP9cOeEIsGws=
X-Gm-Gg: AeBDieuwyptDfJ/jrgtOdKnBp53WvZA+CaInXytAVJFClF8UIv9SJFJWZTcEOMv+Lxc
	B+4LifBzlTIiruNpfcrYKqJbTbjy/0EgXILIn4vgpOoz+4/J99E80xpNqUzddK0eG0n+PRFdg2p
	N8coOTcyPaM0cbb7QucqCQs0xwt61W0R1BdLZ3m+2FEU8hgSDBM5/Ajut+Or4qOZ7o9aEFgU8hm
	SxBu1/jNSkopn6m7VF1aXbWfocp9OkC+m9D3eAVsU3PggOK4NozDnHsRqYHORMSQIu9YijgLOgs
	M4fkWX2dn8HBZbTNvHi9h4rOidUKPwHb3csjAAY9S92dFrvHFkiozPWd1raBuZR/LkXoYt3smXf
	KazzR1x0/ZvY5ELtFmfns2nDB2NbqrY7GGmZ8U3qJwEGKLRL1YYEEMmFNCqgv8iRS5KBbcyRnne
	pcA7PySGz9fShwEnzcjX4tM/P6ucS7v8HKYCjURJ+YX0rX0+52CH+nKwhGLhk+y79mplRWXNYsO
	9r8E3umLY2OmbodmPZf+mjUPAdNKmB1Pg29Ox2m
X-Received: by 2002:a5d:5d05:0:b0:43c:fbcd:4b4f with SMTP id ffacd0b85a97d-43d292e800dmr20475728f8f.47.1775494727766;
        Mon, 06 Apr 2026 09:58:47 -0700 (PDT)
Received: from localhost.localdomain (host86-175-208-130.range86-175.btcentralplus.com. [86.175.208.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e4d28a5sm38323919f8f.20.2026.04.06.09.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2026 09:58:47 -0700 (PDT)
From: Bertie Tryner <bertietryner@gmail.com>
X-Google-Original-From: Bertie Tryner <Bertie.Tryner@warwick.ac.uk>
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
	asml.silence@gmail.com,
	Bertie Tryner <Bertie.Tryner@warwick.ac.uk>
Subject: [PATCH v2] io_uring/zcrx: reorder fd allocation in zcrx_export()
Date: Mon,  6 Apr 2026 17:58:46 +0100
Message-Id: <20260406165846.94517-1-Bertie.Tryner@warwick.ac.uk>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12970-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[kernel.dk,gmail.com,warwick.ac.uk];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bertietryner@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 8FFCE3A580A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Currently, zcrx_export() allocates a file descriptor and copies the
control structure to userspace before the backing file is created.

While the operation returns an error on failure, it is cleaner to
follow the standard kernel pattern of performing the copy_to_user()
and fd_install() only after all resource allocations (like the
anon_inode) have succeeded. This aligns the code with other
fd-publishing paths in the VFS.

Signed-off-by: Bertie Tryner <Bertie.Tryner@warwick.ac.uk>
---
 io_uring/zcrx.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 262ac73..700eff9 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -637,19 +637,10 @@ static int zcrx_export(struct io_ring_ctx *ctx, struct io_zcrx_ifq *ifq,
 {
 	struct zcrx_ctrl_export *ce = &ctrl->zc_export;
 	struct file *file;
-	int fd = -1;
+	int fd;
 
 	if (!mem_is_zero(ce, sizeof(*ce)))
 		return -EINVAL;
-	fd = get_unused_fd_flags(O_CLOEXEC);
-	if (fd < 0)
-		return fd;
-
-	ce->zcrx_fd = fd;
-	if (copy_to_user(arg, ctrl, sizeof(*ctrl))) {
-		put_unused_fd(fd);
-		return -EFAULT;
-	}
 
 	refcount_inc(&ifq->refs);
 	refcount_inc(&ifq->user_refs);
@@ -657,11 +648,23 @@ static int zcrx_export(struct io_ring_ctx *ctx, struct io_zcrx_ifq *ifq,
 	file = anon_inode_create_getfile("[zcrx]", &zcrx_box_fops,
 					 ifq, O_CLOEXEC, NULL);
 	if (IS_ERR(file)) {
-		put_unused_fd(fd);
 		zcrx_unregister(ifq);
 		return PTR_ERR(file);
 	}
 
+	fd = get_unused_fd_flags(O_CLOEXEC);
+	if (fd < 0) {
+		fput(file);
+		return fd;
+	}
+
+	ce->zcrx_fd = fd;
+	if (copy_to_user(arg, ctrl, sizeof(*ctrl))) {
+		fput(file);
+		put_unused_fd(fd);
+		return -EFAULT;
+	}
+
 	fd_install(fd, file);
 	return 0;
 }
-- 
2.39.5 (Apple Git-154)


