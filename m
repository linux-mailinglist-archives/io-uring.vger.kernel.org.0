Return-Path: <io-uring+bounces-13332-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sORUAv/YBWpOcQIAu9opvQ
	(envelope-from <io-uring+bounces-13332-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 16:15:27 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 051FF542EA8
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 16:15:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 765763059123
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 14:09:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5212B3F9F20;
	Thu, 14 May 2026 14:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="LF63ddbf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3734C3FE65D
	for <io-uring@vger.kernel.org>; Thu, 14 May 2026 14:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778767715; cv=none; b=jVGDzqxkrLBWIgQl9TOUZWHeuGcE0ZcmYRCiS0WNFIyrum/yZg9Rc7FaVcO1JpcRX63t00wPtqV/MGlVjGaADOLtsgn+fIC81qZ/MpE+Fh9/uNxeZP+kLpf5Wvv15TAZ3hk4PRze6UnincBsF8obdWxIQZIh4r827Izbpvgl/h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778767715; c=relaxed/simple;
	bh=MfxGf4k9bzg3mLwup0IaKiUGOVMqKY8RKOnZjm/Zlgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtBTYAh3xLjVGSlm1kqE/s49m2neij+BffLpUiE0bLEpJa8mtkUYaC1KZNtsOoNKhQ5BI5hKVC4fsVkqJvgvgbmgbcziuVHV/O6FX4ht62yepSwbi/Vbg3KOC05Cjw1K0EU7gKXcEI+5l3sOCjrSNwle30ggWXBw2qoQwFKEnU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=LF63ddbf; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-479d68a9063so3028016b6e.0
        for <io-uring@vger.kernel.org>; Thu, 14 May 2026 07:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778767708; x=1779372508; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f9SCnljrhoN+CFUXYWb37sIdHn7+8JTxl2AQOURl0Sw=;
        b=LF63ddbfmB4R5UkEKckGSSZTawauXrBMOMLHr2I/wqi2QhhxzH0ZG8wNS8ikT0s0bE
         eqEJyLhBB7LH1lBlEtfEf4eMPVvWISPgGW1xNg2nHgUjFXzmP01lGFz9Np1w8+gnIZH8
         m61+zs8vYwKhZiZa+7q+vKN3nw2mTbjKdo20ZfbH8Hb2CooTOUJqPW3Q4PeeTEmwUZ9h
         8e18RLz3p21LYj0RCHMUSufbx6SnhVpbg53byv61piFbkc1bf2LczHyqyZCKWqwqhfTF
         R7MSeSxr0JVBRDxQpXkKVipWMjXns6bHE9RpZlGoW8573NK9mrjJ0WQeuTot9sMZUHWS
         qjHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778767708; x=1779372508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f9SCnljrhoN+CFUXYWb37sIdHn7+8JTxl2AQOURl0Sw=;
        b=r5irWG2WsPSmEpwkqTNrUKhHDdzgL7pRg+McvKCd97mPTEhdsdpF+4x5JVGzMzOIQd
         R3dO9p1ru59JSkE4PDx3SuZ63PZlGgkNYuYh6JZ1cAQcM6ur2WbNcO/5rHeoLbGqiMD9
         3UjWK34jqZLkGJDTUTpsYvAChxsx3NzjJpulNDaLOs1PXq69/kB5yTDGwTzWqMxfG5qr
         UQINKqeM3WE096RiJQqp5H4KCHiIMZxCR5oeH6uBvQVV/Ga+KsMxEFlrR+F5SxzVtU6v
         JqjKHTjSEMxKhFjo2TjV2FzyHXUIhQwXFxMYfnRPxYk9jR9qRn82F/q0fiUvrJovBuLq
         zpIw==
X-Gm-Message-State: AOJu0YxAGFga0a+pUMld8RJDg/5SlqT+lH3U2SAe23NwVf65iujWDYrQ
	1ovNm91kgwi+90kk/0a8ue2E6XvQ8WD53HSZJTjzI6g2p0RnUpeqiEqErZmDfdzxMiQdb5xIHhF
	gz5fv
X-Gm-Gg: Acq92OFxmVRPNMIlQWgffLB7lXeTDqkQ9tzvbn+/jxxQfjlFoloxaMny34Tc79oTbhQ
	AM27MxMqoJLI47fzmR/+YmXv8fXZPMMirUv/Rcl/EJ+LRlfU5DTSjjdjFbcK3/IZIpK73HSwNjf
	/BzctHhnbpNygkEBgo2ZdMPn2w+4g9tndSq/ZAnwVt8mK9gFOQZHGRYC6CxKCigv64avTnE38We
	jUL5o4nQoG3efFAynfC34WTOUoN8uMVUiZ+gvFg1UqQlFLCw/6/tYOOhyt62knSxbCz3CxbtK8z
	d/BzwA58MbpLM7NobW9e5e4y76oTxZ4Rso2YpbKCaXFX8ogfbF2Xt7C4VDIpkaCFuZleuCADm+P
	thktoGDGcCP7XAjdOj4bMRIiPUboWZcw8XqhIOX2FWv4hXVMX/q656yZdt92LSTG1K0OMd5zFB8
	alQN9L9sYRnLVk92GntDlTOYrRDKYOlKCQltS5Mf56CHxcl1Ez0mavEB2XJhfqGSr5I8u3w2T6o
	r8qgg==
X-Received: by 2002:a05:6808:14d0:b0:479:f928:44d9 with SMTP id 5614622812f47-482b25bdae6mr5017604b6e.0.1778767708007;
        Thu, 14 May 2026 07:08:28 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-482d379f062sm1394956b6e.6.2026.05.14.07.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 07:08:27 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/6] eventpoll: rename struct epoll_filefd to epoll_key
Date: Thu, 14 May 2026 08:07:20 -0600
Message-ID: <20260514140817.623026-5-axboe@kernel.dk>
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
X-Rspamd-Queue-Id: 051FF542EA8
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13332-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:email,kernel.dk:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Action: no action

This more accurately describes what purpose this structure serves, as
a lookup key.

Suggested-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/eventpoll.c            | 13 ++++++-------
 include/linux/eventpoll.h |  4 ++--
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 1c7001866340..7535b10f8c6a 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -141,7 +141,7 @@ struct epitem {
 	struct epitem *next;
 
 	/* The file descriptor information this item refers to */
-	struct epoll_filefd ffd;
+	struct epoll_key ffd;
 
 	/* List containing poll wait queues */
 	struct eppoll_entry *pwqlist;
@@ -335,8 +335,7 @@ int is_file_epoll(struct file *f)
 }
 
 /* Compare RB tree keys */
-static inline int ep_cmp_ffd(struct epoll_filefd *p1,
-			     struct epoll_filefd *p2)
+static inline int ep_cmp_ffd(struct epoll_key *p1, struct epoll_key *p2)
 {
 	return (p1->file > p2->file ? +1:
 	        (p1->file < p2->file ? -1 : p1->fd - p2->fd));
@@ -1160,7 +1159,7 @@ static int ep_alloc(struct eventpoll **pep)
  * are protected by the "mtx" mutex, and ep_find() must be called with
  * "mtx" held.
  */
-static struct epitem *ep_find(struct eventpoll *ep, struct epoll_filefd *tf)
+static struct epitem *ep_find(struct eventpoll *ep, struct epoll_key *tf)
 {
 	int kcmp;
 	struct rb_node *rbp;
@@ -1549,7 +1548,7 @@ static int attach_epitem(struct file *file, struct epitem *epi)
  * Must be called with "mtx" held.
  */
 static int ep_insert(struct eventpoll *ep, const struct epoll_event *event,
-		     struct epoll_filefd *tf, int full_check)
+		     struct epoll_key *tf, int full_check)
 {
 	int error, pwake = 0;
 	__poll_t revents;
@@ -2220,7 +2219,7 @@ static inline int epoll_mutex_lock(struct mutex *mutex, int depth,
 	return -EAGAIN;
 }
 
-int do_epoll_ctl_file(struct file *f, int op, struct epoll_filefd *tf,
+int do_epoll_ctl_file(struct file *f, int op, struct epoll_key *tf,
 		      struct epoll_event *epds, bool nonblock)
 {
 	int error;
@@ -2357,7 +2356,7 @@ int do_epoll_ctl_file(struct file *f, int op, struct epoll_filefd *tf,
 int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
 		 bool nonblock)
 {
-	struct epoll_filefd efd;
+	struct epoll_key efd;
 
 	CLASS(fd, f)(epfd);
 	if (fd_empty(f))
diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
index 4a6fe989810b..c214c374fefc 100644
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -61,12 +61,12 @@ static inline void eventpoll_release(struct file *file)
 	eventpoll_release_file(file);
 }
 
-struct epoll_filefd {
+struct epoll_key {
 	struct file *file;
 	int fd;
 } __packed;
 
-int do_epoll_ctl_file(struct file *f, int op, struct epoll_filefd *tf,
+int do_epoll_ctl_file(struct file *f, int op, struct epoll_key *tf,
 		      struct epoll_event *epds, bool nonblock);
 int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
 		 bool nonblock);
-- 
2.53.0


