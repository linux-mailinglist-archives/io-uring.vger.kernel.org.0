Return-Path: <io-uring+bounces-13210-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0Mg7F5kM92ktbgIAu9opvQ
	(envelope-from <io-uring+bounces-13210-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 03 May 2026 10:51:37 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C68664B4F72
	for <lists+io-uring@lfdr.de>; Sun, 03 May 2026 10:51:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7E3783010D9D
	for <lists+io-uring@lfdr.de>; Sun,  3 May 2026 08:51:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 540932F6904;
	Sun,  3 May 2026 08:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="SYS5Fqv6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09793AD510
	for <io-uring@vger.kernel.org>; Sun,  3 May 2026 08:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777798278; cv=none; b=KqHeSGgWYfUpmFvCoZ6tAJAmd9USgQx0rn8bQ6ieif0yM2vuT6SmU9gl0KyF5UrWj6Z4mJEd1PUAGAkn7DNa+AlyW3vxR9V1CbkL7Mso568yysr1cIifKBgCIAufZ2vRaYPLggj2KZTXXnh7F0sgXUdJDRAavjnfuu42ACxH7UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777798278; c=relaxed/simple;
	bh=klxxVnyGRED1q317T7p7fYo0Zj/3oMSRfd75h/qMGIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s61MwCZO1LWgNBaBP2Q6aAPyy74H7si91UIFl1wOhIwOhs0FuEhhH0tJWRUhEd0IDjyxkUgoOuPNN2TGZUuxdwoNTP+kSp4UPjj7m8R12wCLAIwoFDnYA117MgGHL3bT8AVQVwao/v4BC+qeKvLdCCTtUErm50kaaoFFk3bej4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=SYS5Fqv6; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b9358bc9c50so469776266b.1
        for <io-uring@vger.kernel.org>; Sun, 03 May 2026 01:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777798275; x=1778403075; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/zFTck5W930pgUh3AWU46ER/xD6QLi7A/3R3iLUIHZI=;
        b=SYS5Fqv67YpkTX6XMemVIQiwuMRq/A/t6z7DM9HWqE8SyD0h4z7O+BZ3Otw1HLjUcv
         WybZMYa6cEc2l33zL3pu8mhAbfgoqrJVCxbMINYUWP47+/uG1lk2GzrJDKmmgil8KRxK
         wzJ1HSoRosbzUaCsuV7PFwmgLPZpV+XGy3Ohc8tD2ioLOywZS09KyIcIxLZeqMr7t6TY
         jC/hnVlMO9ddDNjXy81Jc6eKjKiF/8uatXwnU9suR8giII63v6FOWQmKAGzkG3u+EZFR
         qkiZV+NQrLHQvU/BT7M1eWvEu8DPuJ7oOxvHSjMMfKU6+4iCMEEwtzfH+PPzs0RLj8Ha
         86+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777798275; x=1778403075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/zFTck5W930pgUh3AWU46ER/xD6QLi7A/3R3iLUIHZI=;
        b=ZGTNRlrMlBsCk6YnKlvihrljJ+qUgQdHj5yaESRUbflqv5/422z2AjT2RbINA3vlEP
         G9BTnOugSXW7wwHN6mKoea8Z1Le+ul8akhX8gMEEH7w3vZiHf3DoUPH+7o3TSCXUOQIW
         YhgTwwWDGCOJ+KMfQexSN0vBExSsn09NmkTEK1R03qyD17evN45/8Nz9dxUCQrYXGqL1
         8H92F9Wv+N2ld3OUbOTOKpd6LUZmpQPJoslJ21Q82AlNb9gNMKLo1DffPn2f0KWaEGWl
         Jom1ou868VOseXfYa1C7HAZNzvMLbxZCb56aVUnWjvZ6+QgG6lJJDj+6uREajbd7al83
         9CRg==
X-Gm-Message-State: AOJu0YzDVX9JQlGNSahv/k08/Ik4uN0FG5S3qqSSZIWeZhdAwMhVPH32
	TxsqKxNnmI/flAaMkSd4gH65ZABPZ5ZGIQpuflYKQoO3I4wqZdLTGaz8OPTVu8R10m/h0ZOeape
	gNtgnNlSVwQ==
X-Gm-Gg: AeBDies5TY4P+VymMvIKNeb1Iy/mW9H1rCC7uQKCDdIsKKv7tA5syXOLYhyR7935PsY
	zFrYSB0u2z1R3jB92QfqnjkDGe5PPSYVr9Sm7BkOnyD9ACap1FlsfqjjOJLMvLS0l0uF09bC7Th
	Zk0mB2TUu7srLeklqTfxSKOn2UxcSNZhFDyCUg8riKqlj0ZMMUbxCOoYKk7JXqzyDObioet+bzn
	ZlzCkHiKZkxMTdSizXGc7wcbyEUi1GeBJt2qeCQ7BQo+0noHEvowe7JUCQrhhqTL3kJGs6OZMLj
	tZKgAZwSFQ3qQTODpduQBW7ZisAXpyQG4CLR+8m6uGUgyQgb9LIwtmbio0wFiOToCWn72BsDeXy
	rD3FUHESifGb1MoQBSg8wQvDX6ZAPKVrLZPiP0bu5pJLMFTIYIaiD86g3JqDiCJ662onYwU08Sp
	WtVo0bh81W/fdLVt9DwMHZk6L9TtTCqI2tWUq7FOuJMzNLspafW8ROrE7SLo6AtW3We7mP5/Ngq
	tKQDxLFpg==
X-Received: by 2002:a17:907:d02:b0:b9d:c374:6e33 with SMTP id a640c23a62f3a-bbffaf3d8e5mr284088566b.26.1777798274826;
        Sun, 03 May 2026 01:51:14 -0700 (PDT)
Received: from m2max ([77.241.229.232])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-67b85e292c2sm2368936a12.1.2026.05.03.01.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2026 01:51:12 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] eventpoll: export is_file_epoll()
Date: Sun,  3 May 2026 02:49:13 -0600
Message-ID: <20260503085101.112698-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260503085101.112698-1-axboe@kernel.dk>
References: <20260503085101.112698-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C68664B4F72
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13210-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel.dk:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]

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


