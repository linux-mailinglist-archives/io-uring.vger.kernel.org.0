Return-Path: <io-uring+bounces-13334-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aEyeFrvXBWqacAIAu9opvQ
	(envelope-from <io-uring+bounces-13334-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 16:10:03 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E2742542CCB
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 16:10:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DCF11302D92B
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 14:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7DDB3FBED0;
	Thu, 14 May 2026 14:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="bEBAccvL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C7D3FF8A1
	for <io-uring@vger.kernel.org>; Thu, 14 May 2026 14:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778767716; cv=none; b=pgVzPcsx5Eh+7bHgqoPw0lL6k5kzju5CJbol68UfNza3XljnOJHO9TtaEW7x03Jenj9UmX9rnkKi4Tyq+wqTma6kZVcNkPvfkQQoe4Nn7m1POmhLK7GjFOZdEGazxBqEZgdsx9g1GTPX6V1NLP/mym/bc8s+Kn3Qw1CJ/jDzRWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778767716; c=relaxed/simple;
	bh=h/TsxaRciBPPk4deTjUi8jarn4iJ1vrvL4w33rZhFms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIoaE0e4XeIVZB/h5a6W41IXa4FT31BGvOJifUeeDQWbfb0BgrwfLBxPVro9eEeXHZcCHJXD/2WKNxFfvnbM6p3Ll4lB04I6N3VdWm6jY2j3tGdGGLfP4FGxogjPlJMEemnheQONHFt2cQfdDaeAnPUJ4yJUmvVDyS4LXNt1rQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=bEBAccvL; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-479e6bc357eso3199697b6e.2
        for <io-uring@vger.kernel.org>; Thu, 14 May 2026 07:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778767709; x=1779372509; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N0SY4JZ68JhcU3ovh1BQz4gQVwMMdNZDkWHAJkqOOaU=;
        b=bEBAccvLN+UB4FggB//S4FOxqNal+YrCCziW/plG5apK3B27OLjszVqRfQligOwbCT
         ttQJz/CDVWyi0vEm83C5KSYWgUx1zZZJ8FkxVYRAzYa/4M3S4f6vI7fveIVVUqcy6biG
         NvZ9QqSVfE0dKS4mMjiQ5J+sLZq8dv1FfJ98dgLVowEwtl1apaRVCwL+QjX+cr+Fnycq
         HatXpc90cNT/oU7aCC2pqMKTH8MlHMr6/XRgAyiXOcb0CZbD2INHcUXVnalvAXtuLg8M
         SyQfAXPjszIaPB7V8bzXb4VYSDTSkvccYdvUveLNsc5460qk33uwXG2zcQtl4FGxfsTN
         Y53A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778767709; x=1779372509;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N0SY4JZ68JhcU3ovh1BQz4gQVwMMdNZDkWHAJkqOOaU=;
        b=KX50qCbsNRfiJBD8OQbtIpnENBTZzpqMzivcKuZC++QuMUk0oi6tmW5r59o7H3QXAG
         IF5E7abd0rJXguTAeVxfidHLrZl9O3QJDnkxADWP+nx5t1TWCVE+tRtRjSI79yPwi7AN
         KDz9OM5fxzhcnWUTO8FmqzHVC1RsJMeRu7sUDOwXlt2Db9CuXb5A2Us8D5DJqvfZQuc1
         7kxfXZRxx0HQuY/28d6+dKSvj0gNz64A1aLmdvMnN+J47ApHd8YsZm+n01x9KJRDMyrF
         LRY6GIckHa0rZRGrlfqIRU/+MwszGQGYoHruib7jeXI6wiPxpnbSw4lb6QscX80CHw6A
         TYHA==
X-Gm-Message-State: AOJu0YxM846S3HO7LmcdwNBGhS7+s78wtDYcrSq0y+8C6zS1hIexYH32
	aD9+hQKlzxraGRo//2aFfX+82QH2i8qeHMG/kwNUqRkG5GxQyyjtT+CCkocO9u34CSKJP128GKW
	Omuur
X-Gm-Gg: Acq92OFnsRoLho5CqfdJnApa+Jy2FlM0MoZl23dePqqBK1MizdJnTlkXpdwWDxoPKSO
	lob5BfexLSeMT/l+UWvWPcOE8y1WMlGT+YXS7pqUlrSz5nAHPOVS8WYicAL6+bq244gjdwYWJwy
	yUImdogL6LrZh/JbBGSlMFu6xsrmX+FY5txeWy78sm/17A+/SLADQOEA3637x1KCshklqtAEhe5
	O9Heoq5nBJJVn2KmWyeCxnfFKLPzfHpwaET6EOGIdPdDKCobl4NSfqCKs7GJlUue3h5nBIJ1xIV
	81fisSFiJgVQVsDpkGWlnZCfNx73kgpGL9nOgJEVK8qaxsU2omFtJosI4cHgtKIwgMhGye0tUAW
	qqX3aPqBZ4wshfcbZzisVqaKJ+dWOhpOgbuDwiGAS7KFCais0JyDE+tXh6LSFU8O1ZlpJm4cpdq
	R9mWGkUFNC248xDssHai/28b+de0ck4SYMbOMmqCYGdh+3Nv7a+J4DYwsPFciKl3291nc=
X-Received: by 2002:a05:6808:5386:b0:482:af14:8423 with SMTP id 5614622812f47-482b2d9525amr4889512b6e.39.1778767709333;
        Thu, 14 May 2026 07:08:29 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-482d379f062sm1394956b6e.6.2026.05.14.07.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 07:08:28 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/6] io_uring/epoll: switch to using do_epoll_ctl_file() interface
Date: Thu, 14 May 2026 08:07:21 -0600
Message-ID: <20260514140817.623026-6-axboe@kernel.dk>
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
X-Rspamd-Queue-Id: E2742542CCB
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13334-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel.dk:email,kernel.dk:mid]
X-Rspamd-Action: no action

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/epoll.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/io_uring/epoll.c b/io_uring/epoll.c
index 8d4610246ba0..b9db8bde27ec 100644
--- a/io_uring/epoll.c
+++ b/io_uring/epoll.c
@@ -51,10 +51,21 @@ int io_epoll_ctl_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 int io_epoll_ctl(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_epoll *ie = io_kiocb_to_cmd(req, struct io_epoll);
-	int ret;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+	struct epoll_key key;
+	int ret;
+
+	CLASS(fd, f)(ie->epfd);
+	if (fd_empty(f))
+		return -EBADF;
+
+	CLASS(fd, tf)(ie->fd);
+	if (fd_empty(tf))
+		return -EBADF;
 
-	ret = do_epoll_ctl(ie->epfd, ie->op, ie->fd, &ie->event, force_nonblock);
+	key.file = fd_file(tf);
+	key.fd = ie->fd;
+	ret = do_epoll_ctl_file(fd_file(f), ie->op, &key, &ie->event, force_nonblock);
 	if (force_nonblock && ret == -EAGAIN)
 		return -EAGAIN;
 
-- 
2.53.0


