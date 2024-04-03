Return-Path: <io-uring+bounces-1380-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5353B89758A
	for <lists+io-uring@lfdr.de>; Wed,  3 Apr 2024 18:45:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D51C21F28729
	for <lists+io-uring@lfdr.de>; Wed,  3 Apr 2024 16:45:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96F0B152E01;
	Wed,  3 Apr 2024 16:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="SuDFNobn";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Le86eR19"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD56152DF0
	for <io-uring@vger.kernel.org>; Wed,  3 Apr 2024 16:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712162670; cv=none; b=e+1LTUayz3zhsPLdFNZNWYC7YYa2q15bziFv6blcLn5lSbNisDmZusLyx1tDQovqGw3VMZeUkvbPVlwzgxlJYoOWHvBP4AJxTru3YKvI8cY2xN+xTz0kktKetWm6XprfRoGym7Qn8UvoAxAtvbR5W3F/raJIA4u5NsxLHJClifw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712162670; c=relaxed/simple;
	bh=NDBTSRuP6DFLEelhZXoTW/21Av07qrXEtY8DrX4wveM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1jEkTFe4N2LL44V4JocqjQRZKvoSdG++Bk/zu21Q7+S7lTji0VnYr+BCsFnWhh1CclQgivtk8drmBZpRF6Skr9h5ry/RFS6Am08T01hTZ+jeqX1m0lRRzXC8mQ/0voAN1ITv8/OV/U+p2Ni7mucHTPEEiZeM3hqF/R5oNYy4FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=SuDFNobn; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Le86eR19; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 13FB55CEF7;
	Wed,  3 Apr 2024 16:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1712162667; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rei/mER7GyXFPbd2iPRbzSdt6ek8+DP4lDIzOUnN0UE=;
	b=SuDFNobnYUgJ7J5lzdvTLlyxbR220JIqt2l6h1RkX0ExZ6zixJ8ZoXFbnPQKNelobUxQOb
	G5eCS+yYGyi+QLaodSSyBCum+zvaYJOqx7HuuwD1yfLUwMPBFqoydZhv95v+IVvdNVWMhi
	9mxKpOyYjO/XBCkhGTVXeKFjQQeGVHI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1712162667;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rei/mER7GyXFPbd2iPRbzSdt6ek8+DP4lDIzOUnN0UE=;
	b=Le86eR19ogsMvPCoV8e9fRvTF/dz8QVI7kIiGTIS6bb5MGoicn0LtaC/CoMz3n5PY1v8cV
	hjpU8p/Lp9Q1GhAA==
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id BC7E613357;
	Wed,  3 Apr 2024 16:44:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id x2bcJmqHDWbiDQAAn2gu4w
	(envelope-from <krisman@suse.de>); Wed, 03 Apr 2024 16:44:26 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing 1/2] man/io_uring_enter.2:  Move poll update behavior to poll remove
Date: Wed,  3 Apr 2024 12:44:12 -0400
Message-ID: <20240403164413.16398-2-krisman@suse.de>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240403164413.16398-1-krisman@suse.de>
References: <20240403164413.16398-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap2.dmz-prg2.suse.org:rdns,imap2.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Score: -1.80
X-Spam-Level: 
X-Spam-Flag: NO

Since early days of OP_POLL_*, we had kernel commit
c5de00366e3e ("io_uring: move poll update into remove not add"), which
disabled poll update in the POLL_ADD path and moved it to POLL_REMOVE.
This updates the man page to reflect that change.

Closes: https://github.com/axboe/liburing/pull/1095
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 man/io_uring_enter.2 | 48 ++++++++++++++++++--------------------------
 1 file changed, 20 insertions(+), 28 deletions(-)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index 7d04d47..ab73d54 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -302,6 +302,24 @@ the original request. If this flag isn't set on completion, then the poll
 request has been terminated and no further events will be generated. This mode
 is available since 5.13.
 
+This command works like
+an async
+.BR poll(2)
+and the completion event result is the returned mask of events.
+.TP
+.B IORING_OP_POLL_REMOVE
+Remove or update an existing poll request.  If found, the
+.I res
+field of the
+.I "struct io_uring_cqe"
+will contain 0.  If not found,
+.I res
+will contain
+.B -ENOENT,
+or
+.B -EALREADY
+if the poll request was in the process of completing already.
+
 If
 .B IORING_POLL_UPDATE_EVENTS
 is set in the SQE
@@ -311,8 +329,7 @@ events passed in with this request. The lookup is based on the
 .I user_data
 field of the original SQE submitted, and this values is passed in the
 .I addr
-field of the SQE. This mode is available since 5.13.
-
+field of the SQE.
 If
 .B IORING_POLL_UPDATE_USER_DATA
 is set in the SQE
@@ -321,32 +338,7 @@ field, then the request will update the
 .I user_data
 of an existing poll request based on the value passed in the
 .I off
-field. This mode is available since 5.13.
-
-This command works like
-an async
-.BR poll(2)
-and the completion event result is the returned mask of events. For the
-variants that update
-.I user_data
-or
-.I events
-, the completion result will be similar to
-.B IORING_OP_POLL_REMOVE.
-
-.TP
-.B IORING_OP_POLL_REMOVE
-Remove an existing poll request.  If found, the
-.I res
-field of the
-.I "struct io_uring_cqe"
-will contain 0.  If not found,
-.I res
-will contain
-.B -ENOENT,
-or
-.B -EALREADY
-if the poll request was in the process of completing already.
+field. Updating an existing poll is available since 5.13.
 
 .TP
 .B IORING_OP_EPOLL_CTL
-- 
2.44.0


