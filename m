Return-Path: <io-uring+bounces-13747-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 6ws7EMxEMWr+fgUAu9opvQ
	(envelope-from <io-uring+bounces-13747-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 14:42:52 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9791E68F75C
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 14:42:51 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ON5CSeS6;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13747-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13747-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 292D231A1339
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 12:36:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8B7E35F193;
	Tue, 16 Jun 2026 12:36:44 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7683624D4
	for <io-uring@vger.kernel.org>; Tue, 16 Jun 2026 12:36:43 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781613404; cv=none; b=TZmPFwIn0mUkQbZykDIuqDB+Mk4sS9FZKepl0Ap2eLfzfDUCy2zPchfE9o/zThR05NrEpsEczSjME0vQYh0HK4MvfyABtFCy3Btj5ALeGVhEF+uOpT4K2Q2KieXeywefNlc/xRDfycvFLStDZIo/2hy9Oq5lGtgQ1bGiqhIKBgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781613404; c=relaxed/simple;
	bh=AQu0bGG4P5sk44ih0WOlfIlUFx15WXJenCKRn7z3Fzs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Bnx/SfdTeYCF+ghpxoOLS4fQdBrlifA5ly+ap+h/b4xq1yrsEKEdfmSqj5XPe2PKZH+90HYXsYDeyQhBRY5FW15xjAZ2qknftgml/zWlXsdpX+vydHIZAt5pGBdYckWpEiLN4Guenhj9bWNj9XaNEnaY+Ix7kPxtDN4kYNqZlgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ON5CSeS6; arc=none smtp.client-ip=170.10.133.124
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781613402;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=CWlLwoh5y3iVjDYKyZhWzTfzwRycOW+LCm3ThLAWCnE=;
	b=ON5CSeS6pzVVZvUzbG1W6/FTaDLqLHxZ23wyAiqzEYiPBobhn/uko3v0uW8fpkKmWTGikS
	UNBPg5yYKCyMLwJ5ylwkt0rrCdQK+K2iTEJwE0p1yUwfq1DEDrbjWCRZQgBJaX6Fg2FzCm
	tXQ9ZjEIb1MtFf3w1qXiw7ekCWF1r1w=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-84-ESBi7erwNUiVoQ2ga2-Kpw-1; Tue,
 16 Jun 2026 08:36:39 -0400
X-MC-Unique: ESBi7erwNUiVoQ2ga2-Kpw-1
X-Mimecast-MFC-AGG-ID: ESBi7erwNUiVoQ2ga2-Kpw_1781613398
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 669551805C01;
	Tue, 16 Jun 2026 12:36:38 +0000 (UTC)
Received: from wsxc.redhat.com (unknown [10.96.134.57])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CA9B81955BC1;
	Tue, 16 Jun 2026 12:36:35 +0000 (UTC)
From: Ricardo Robaina <rrobaina@redhat.com>
To: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk,
	paul@paul-moore.com,
	sgrubb@redhat.com,
	Ricardo Robaina <rrobaina@redhat.com>
Subject: [PATCH] io_uring, audit: don't log IORING_OP_RECV_ZC
Date: Tue, 16 Jun 2026 09:36:32 -0300
Message-ID: <20260616123632.3209545-1-rrobaina@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13747-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:axboe@kernel.dk,m:paul@paul-moore.com,m:sgrubb@redhat.com,m:rrobaina@redhat.com,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER(0.00)[rrobaina@redhat.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[redhat.com:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rrobaina@redhat.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 9791E68F75C

IORING_OP_RECV_ZC is a read operation. Audit only tracks file/socket
creation, not subsequent reads. Set audit_skip to align with
audit-userspace uringop_table.h.

Fixes: 11ed914bbf94 ("io_uring/zcrx: add io_recvzc request")
Suggested-by: Steve Grubb <sgrubb@redhat.com>
Signed-off-by: Ricardo Robaina <rrobaina@redhat.com>
---
 io_uring/opdef.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index c3ef52b70811..fef134a21113 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -519,6 +519,7 @@ const struct io_issue_def io_issue_defs[] = {
 #endif
 	},
 	[IORING_OP_RECV_ZC] = {
+		.audit_skip		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
-- 
2.53.0


