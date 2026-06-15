Return-Path: <io-uring+bounces-13727-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id qroJLlAQMGrvMgUAu9opvQ
	(envelope-from <io-uring+bounces-13727-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 16:46:40 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C18768750D
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 16:46:40 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jVLdFio2;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13727-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13727-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8775E30459FB
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 14:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90A943542F4;
	Mon, 15 Jun 2026 14:46:26 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B7A3F5BF6
	for <io-uring@vger.kernel.org>; Mon, 15 Jun 2026 14:46:25 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781534786; cv=none; b=dlGlGgrKQ0jKsS7P3VxgTDQg3LfW5OPaZEHVzWj9GRvJ3oOiW6+B80ucyZDHiJAj1Jd+s52M/R05QPqszI9x2ZnsfuwQoHf1n3P+DrEO4QuOKXWaTMeUGhjJ+fYS3FbOhUiv5RiWJfHALnP9xfG3p0C1np/a4ExrQwKDKCSGRr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781534786; c=relaxed/simple;
	bh=oPr0a+93+hwQDjkv/hkcRUKfcoFOXOadlFa3egEcfDI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oYygW69BZ3aWZ1S8gbBqMFRrXef9wfijSJHAlv/28ozNM7kfBEzzWcKf+AJGNXRQeYsRCtlP/Jga99KxI+P4sdHOnhb7lytDIZGLubMOzoZjONxzzWqbabGe4zWgfBwxfTcIo8K3iybzTOb82inj67LCjUDP8i79/nYAa5Osq3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jVLdFio2; arc=none smtp.client-ip=209.85.128.45
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-490b3637b90so26305665e9.3
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2026 07:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781534784; x=1782139584; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Z3G1FozDQG3/xwnIKMWehzO7UPIHmTljvzEEwpG+XIc=;
        b=jVLdFio2Fh19BQsP8SHftXePr7irg6cw4IZwccl8KO+yCccgMfgeuABrGKcnJjjDg6
         OqnG16DKHAoeafuDWXojS5EJSI5eI815+CVUpWtiNcuvY2Y6sXA2wB5Jua/DKlX5izcl
         w53pMm6PufsbDuKm/dz61oZ5ivfzKu9GcMSJzrlPOwHq+8JY5fniYShUCVh2e59jC8Xi
         XKeEKqdGQiYUfLYjVrA1y52G0zXVZycF88VRrIjXKHn4FmAfXipsfNVbq4lpo90h+XDK
         OwnkFoXDJhb9j18+Oc48KNUy/bSWSBZzIQHmnFRcXaEin847tr7fiOwrP+psBESmycH9
         JNxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781534784; x=1782139584;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z3G1FozDQG3/xwnIKMWehzO7UPIHmTljvzEEwpG+XIc=;
        b=h1N4AkkPT+r4VzS2X4iwf+wIMpxGqJybmVUbKZoZ74iBXg5tdtKkIX9oXG8ti1zFlF
         g1vhCc6ZegQEprbhg4P4dbhIDSRZVjeAkDD5CFS+R1MhtQKLkfie7GacnTYEOfskSyzm
         MwQSGkcvboqWVSHJHAYr317uL9FGPEs6uw3z8qXi2d/kqXwSJdNClmLj52n2WP81/sac
         473yROKY+kkq6HWNfd0wK2LxcPCNjhoohre1KPXlCuLP53NaOEyvrX8PZ94Dwc3O2ut/
         JQyYdMqL2P2A1SUdPqT30I8bOORMToA/YHbtCuXOI0EItHi8D0wTV5EvUuBbXhgoWbTj
         nrVg==
X-Gm-Message-State: AOJu0YxqTCqubxGTuJ6kxgERSiA5h7JN2VeYnWbFpDw+OmA5LgbDrXeJ
	G0eVbn/NCaK/FtpPY1891qgmHnhgzcbbBl0QJkKdtsje/Zd5y3iLUepBaJ3CJ/A4
X-Gm-Gg: Acq92OHu8n2Hnyj6RzWNGNrKasm456LVBbnBsJbwHF/K/g1hG8dNXd2xqKA0sVSCYw9
	GN5J+ExtNKbj88F8audPGRVIa9s7V1LEEXEBkYy5eK1t/kVFwXNa1q3hinSoBvkmiJZYLBUpxvA
	90EIAZjiBZuODVeuARyx1eRZjNQ4JN+lNEydPk6KSkWaODE1RI5oxo8Cjb5DMnzQxSkiPF/5Axg
	KwE9anyvavg+1b3Yz7Fs/Bgy4kYO7hqC/IoOQU0d7JwPVBSgents+PjC7QqDYBt2zGt88f2OJlK
	yyLKprNWb+MFxUB2b8vHKwbxWvRw8YUZGmDpmBuQT5+KIsfYeZrwuGA9rlRZiVD404b2qEg4ZeD
	DKfxcTvzsXKKgy2UvuRDq0RfIidEwu5k1dzXgMx0WKRHE+0GOzBW3BkqORCHsWYv6Vc+BhG7QBF
	iwxmvq8kSbliNf9/f4QwR9oFE6V5FqsBGTIDqV4VelhS1lMb+NOu00It5vW9wUwVc0pnxAFe5/c
	GA9dgrUcpGMqXHgpCRf
X-Received: by 2002:a05:600c:1392:b0:490:a646:9d75 with SMTP id 5b1f17b1804b1-49220091dbemr129797765e9.9.1781534783107;
        Mon, 15 Jun 2026 07:46:23 -0700 (PDT)
Received: from valmpani.fritz.box (cgn-195-14-216-63.nc.de. [195.14.216.63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-492202edec6sm285706305e9.3.2026.06.15.07.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 07:46:22 -0700 (PDT)
From: Vasileios Almpanis <vasilisalmpanis@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring/nop: fix file reference leak with IOSQE_FIXED_FILE
Date: Mon, 15 Jun 2026 16:45:57 +0200
Message-ID: <20260615144619.482749-1-vasilisalmpanis@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13727-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER(0.00)[vasilisalmpanis@gmail.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[vasilisalmpanis@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp,syzkaller.appspot.com:url]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 0C18768750D

NOP file-acquisition support choses between a fixed (registered) file and
a normal fget()'d file based on its own IORING_NOP_FIXED_FILE flag in
sqe->nop_flags. However, a request's REQ_F_FIXED_FILE is set
independently from the generic IOSQE_FIXED_FILE sqe flag during request
init, before the issue handler runs.

If a NOP is submitted with IOSQE_FIXED_FILE set (so REQ_F_FIXED_FILE is
set) but without IORING_NOP_FIXED_FILE, io_nop() takes the normal path
and grabs a real reference via io_file_get_normal(). On completion,
io_put_file() only drops the reference when REQ_F_FIXED_FILE is clear,
so the fget()'d file is never released and leaks:

  BUG: memory leak
  unreferenced object 0xffff88800f42c240 (size 176):
    kmem_cache_alloc_noprof+0x358/0x440
    alloc_empty_file+0x57/0x180
    path_openat+0x44/0x1e50
    do_file_open+0x121/0x200
    do_sys_openat2+0xa7/0x150
    __x64_sys_openat+0x82/0xf0

Decide between fixed and normal file acquisition from REQ_F_FIXED_FILE,
the same way io_assign_file() does for every other opcode, and fold
IORING_NOP_FIXED_FILE into REQ_F_FIXED_FILE at prep time.

Cc: stable@vger.kernel.org
Fixes: a85f31052bce ("io_uring/nop: add support for testing registered files and buffers")
Reported-by: syzbot+2cd473471e77bda12b0e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?id=879092631b98f73a28ea405adacfa5bb34a14a25
Signed-off-by: Vasileios Almpanis <vasilisalmpanis@gmail.com>
---
 io_uring/nop.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/io_uring/nop.c b/io_uring/nop.c
index 91ae0b2e7e55..60ab19604b36 100644
--- a/io_uring/nop.c
+++ b/io_uring/nop.c
@@ -40,6 +40,8 @@ int io_nop_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		nop->fd = READ_ONCE(sqe->fd);
 	else
 		nop->fd = -1;
+	if (nop->flags & IORING_NOP_FIXED_FILE)
+		req->flags |= REQ_F_FIXED_FILE;
 	if (nop->flags & IORING_NOP_FIXED_BUFFER)
 		req->buf_index = READ_ONCE(sqe->buf_index);
 	if (nop->flags & IORING_NOP_CQE32) {
@@ -59,12 +61,10 @@ int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 	int ret = nop->result;
 
 	if (nop->flags & IORING_NOP_FILE) {
-		if (nop->flags & IORING_NOP_FIXED_FILE) {
+		if (req->flags & REQ_F_FIXED_FILE)
 			req->file = io_file_get_fixed(req, nop->fd, issue_flags);
-			req->flags |= REQ_F_FIXED_FILE;
-		} else {
+		else
 			req->file = io_file_get_normal(req, nop->fd);
-		}
 		if (!req->file) {
 			ret = -EBADF;
 			goto done;
-- 
2.47.3


