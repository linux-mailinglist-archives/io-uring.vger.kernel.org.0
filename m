Return-Path: <io-uring+bounces-12341-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CD50CbVHl2kUwgIAu9opvQ
	(envelope-from <io-uring+bounces-12341-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 18:26:13 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FDCE1612B5
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 18:26:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D4002306C452
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 17:23:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD29F34F254;
	Thu, 19 Feb 2026 17:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="JAB4HSGa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f227.google.com (mail-pl1-f227.google.com [209.85.214.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F2B34CFBA
	for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 17:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771521788; cv=none; b=X73687WNJq5g9ULztZ86TO1eA4xDR8w5WK2K/U0PBbzhfY4stHBhhS7OFUNUyO7OSy0x74gT5OtgwRwH+SuGApXATr4FNSoqQhoI3yFNNuWzsxF2G5lergoXcGuP9eckXuysV5UpaShogITopHO+8GXCYtWiGfff/cAjfmI/KOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771521788; c=relaxed/simple;
	bh=tV41JT4N82HtLiVT4LDve0d5RQZWyngFmDTN+LM2KSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwG1LA6EdaPQOs5Kf6jaXOx8CWfImi1x6FQeJXeN3xZxfjQMKEzkPgYKd9rrocp4NO8QxYpibo4rWFGuCt+/etlZa+ym8PGPr6HggnO5DcWBrXliIUPMQvhpDmbMAOvIiKDwmD4IklL9vTttMsJSeWVWuXY71VfYJNT7iJW9O78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=JAB4HSGa; arc=none smtp.client-ip=209.85.214.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f227.google.com with SMTP id d9443c01a7336-2a8720818aeso523055ad.1
        for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 09:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1771521786; x=1772126586; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cD5qcELz1szuWzdXkgd0fgG80WegTttIPZeozvdhos4=;
        b=JAB4HSGaBijit6dpJZg285XUG7gn1q7WgnAOzFzjKDjnF5luVR1E4AirCW95LaNj1H
         VhCUPbJEUIlIJxgqGPozbUSd5LCjEsZzsWOrjIdGAHhmdC3DH9RrwDKeYmt81K8nuzkI
         BClqIOUnmUItP7xaeXvUm2pxjGgh+VwAjOHxDxt0XCWdRyMrcS5eH6ZKxgGdA1NWwj81
         X/j6g5SCMyKulSUi5bAKHeBma/U4bsHc7NnAXsJYHJDY1QMglCM/Q8DrhWx6X5+5q+Bq
         eQOuFXnH6/hmvnoVQN6JbPKC4VbH0rUOZ8YSzW9+zlhgKAZePw2z336031oWMTMSCb4f
         d6Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771521786; x=1772126586;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cD5qcELz1szuWzdXkgd0fgG80WegTttIPZeozvdhos4=;
        b=GzNxqVE1TkkAZwvjLzAUWTXQD/sg1ooX5b2DxYViB/nLX9uMNn1mjylw1BloNSL1LP
         EdBrL6keOZGKDhLljJzDK3BGtaFcpp10ynZZrAtwYZZpIsP5+BJXvAHouksJpRAmyZlt
         fXfTHQgpjM8ndo39ZDwq1g+qgnR3SgorBpPio1gP57p6bXJkia8Yjopo9MxVNX1JuKl3
         mT11r6vc8cnLHdVfNl6CWyz/Ab8WRXWp3TlYRnWzVUkI0VBe0DcMMfgft4TncpdO6PiW
         iEaphbYxGQm1rFHhxhLE/f8gBUIZxtcKEO5sWtJ8x9OL8moVs2sY7DFbVGGZJzsDpikb
         S8RQ==
X-Gm-Message-State: AOJu0YzbmtbhEhrgiryUkYW5fJlKs5lhlDvzZ8ZFXIL0Gasi9e3wT7H8
	7dy/vQqd5QdUU96o/K0tcSqONqWW4xFya6uLgV0Po0j7MYu/n8IFbuJccLW4PADMj3dlNIeYk7X
	PYP6M0rOtUChclX9r0WOX5NDXP4FoJ0G83+ZfYsJvX2ZhMdQilX9S
X-Gm-Gg: AZuq6aK6fEZztrY3FKTAD423fjiPAthKt4/rIv1v5q9oZ1OymLBlP1hazVI5+ao4xnz
	etSMxVrIO4Pqe/byLxsygx5rkhzXU4U1JEU8dsWGPXC47imtS84u446fqFQCXnjAg2N+oF7Knuh
	5tGR8MpYOLtv7+X+lF2hZ56l6gUMxcGIhZRv+FZOcaFJ38ANiIPPxwGUzW81FUhcGBFBQV8p/se
	1GwjPRn341Lrjo/z8pYT1WEbfabDYDXzA7BEQ+NJT8caO/3Ixo9qRX8NkPOtDZ0PRCUuFGyvkmh
	FUA7gprA33pGwqm4a89slTGft3R2wwuAVCXUKUVEDs8bJ6jUjehPl0Fe1V4aTxafi7R9D98bfJv
	QOG5t8abdoJsfbB6yLSkfFDVkE721rFYTOBVH1rg=
X-Received: by 2002:a17:903:1b63:b0:2a7:8bf3:5674 with SMTP id d9443c01a7336-2ab4cb003e4mr163336915ad.0.1771521785949;
        Thu, 19 Feb 2026 09:23:05 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2ad1a78f7c0sm21662705ad.28.2026.02.19.09.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 09:23:05 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 2F5A4342181;
	Thu, 19 Feb 2026 10:23:05 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 27164E41AE3; Thu, 19 Feb 2026 10:23:05 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>
Cc: io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anuj gupta <anuj1072538@gmail.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v3 3/4] io_uring/uring_cmd: allow non-iopoll cmds with IORING_SETUP_IOPOLL
Date: Thu, 19 Feb 2026 10:22:26 -0700
Message-ID: <20260219172228.429479-4-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260219172228.429479-1-csander@purestorage.com>
References: <20260219172228.429479-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,reject];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12341-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.infradead.org,gmail.com,samsung.com,purestorage.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[purestorage.com:mid,purestorage.com:dkim,purestorage.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[purestorage.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 6FDCE1612B5
X-Rspamd-Action: no action

Currently, creating an io_uring with IORING_SETUP_IOPOLL requires all
requests issued to it to support iopoll. This prevents, for example,
using ublk zero-copy together with IORING_SETUP_IOPOLL, as ublk
zero-copy buffer registrations are performed using a uring_cmd. There's
no technical reason why these non-iopoll uring_cmds can't be supported.
They will either complete synchronously or via an external mechanism
that calls io_uring_cmd_done(), so they don't need to be polled.

Allow uring_cmd requests to be issued to IORING_SETUP_IOPOLL io_urings
even if their files don't implement ->uring_cmd_iopoll(). For these
uring_cmd requests, skip initializing struct io_kiocb's iopoll fields,
don't set REQ_F_IOPOLL, and don't set IO_URING_F_IOPOLL in issue_flags.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/uring_cmd.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index b651c63f6e20..7b25dcd9d05f 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -255,13 +255,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 		issue_flags |= IO_URING_F_SQE128;
 	if (ctx->flags & (IORING_SETUP_CQE32 | IORING_SETUP_CQE_MIXED))
 		issue_flags |= IO_URING_F_CQE32;
 	if (io_is_compat(ctx))
 		issue_flags |= IO_URING_F_COMPAT;
-	if (ctx->flags & IORING_SETUP_IOPOLL) {
-		if (!file->f_op->uring_cmd_iopoll)
-			return -EOPNOTSUPP;
+	if (ctx->flags & IORING_SETUP_IOPOLL && file->f_op->uring_cmd_iopoll) {
 		req->flags |= REQ_F_IOPOLL;
 		issue_flags |= IO_URING_F_IOPOLL;
 		req->iopoll_completed = 0;
 		if (ctx->flags & IORING_SETUP_HYBRID_IOPOLL) {
 			/* make sure every req only blocks once */
-- 
2.45.2


