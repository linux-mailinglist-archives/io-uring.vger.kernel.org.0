Return-Path: <io-uring+bounces-2554-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B12E93A9C4
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 01:20:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F0E461F22CF6
	for <lists+io-uring@lfdr.de>; Tue, 23 Jul 2024 23:20:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 284D31494C2;
	Tue, 23 Jul 2024 23:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PTsBnwSw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="U+tJUt9X";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PTsBnwSw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="U+tJUt9X"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9477F13BAD5
	for <io-uring@vger.kernel.org>; Tue, 23 Jul 2024 23:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721776833; cv=none; b=LIlc4C1CxIgD/zxI1PYgqeiacGLzA0OA2jS+ZPUQnkA+XvZfF4gBSyWLkJmfohVUtQvDjV6nM0VlPZR7IybZI0m/76T5MCa5UUbIcLvDxI7r12aOqUjGQo702YVuifn/bISP0GUVTl7bdxLC3t87AACLdfIKZoU9M164+Qib2X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721776833; c=relaxed/simple;
	bh=7mfbd1QidoWPAmZvlMfLR96YFXL4TFf8C719etDWQe8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mWHbkxTUbrstuRfr7mxFENEuN7NSmmdH149tkcyHd1Tjz09r/Nmh52xGizi+xuJNdUT4FVG9nOYZ4uEvwI7+5VWa9JLwQyUgxeok+VSuzS002o7rZM1ci2F3mkso02YgiakMtEOpu9HKJlnpVJyrlWHBKD6F7pXH63kcXv3fqdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PTsBnwSw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=U+tJUt9X; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PTsBnwSw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=U+tJUt9X; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A4BB421A82;
	Tue, 23 Jul 2024 23:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1721776829; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=gvIjjC+hrOs+69ERpmQS6TEUJ4FtWnSS9dxYzhRI/40=;
	b=PTsBnwSwbLqI3HhLxHqiNDIW6FwspNrAYJzKug/2X33GmI9oUHXN0zz8eP9Is4Noq2Pg5o
	vehzyx9nzx/EPKz1qd9IyD0X4dSXgcoJwn5h879pzBXbhPR+FDxsbd8k11vHNWYeeNr020
	uSX1y3s//WHrlCmW6fQhoKOQsUkmYm8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1721776829;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=gvIjjC+hrOs+69ERpmQS6TEUJ4FtWnSS9dxYzhRI/40=;
	b=U+tJUt9XMyoZbRpkZ/vQvlQ4x+JFhqeP53CsrV5lCwmA2YyBzjuMMDv5TQ/CvCS+ekG6cS
	7KCnSVXn4VnwMJAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PTsBnwSw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=U+tJUt9X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1721776829; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=gvIjjC+hrOs+69ERpmQS6TEUJ4FtWnSS9dxYzhRI/40=;
	b=PTsBnwSwbLqI3HhLxHqiNDIW6FwspNrAYJzKug/2X33GmI9oUHXN0zz8eP9Is4Noq2Pg5o
	vehzyx9nzx/EPKz1qd9IyD0X4dSXgcoJwn5h879pzBXbhPR+FDxsbd8k11vHNWYeeNr020
	uSX1y3s//WHrlCmW6fQhoKOQsUkmYm8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1721776829;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=gvIjjC+hrOs+69ERpmQS6TEUJ4FtWnSS9dxYzhRI/40=;
	b=U+tJUt9XMyoZbRpkZ/vQvlQ4x+JFhqeP53CsrV5lCwmA2YyBzjuMMDv5TQ/CvCS+ekG6cS
	7KCnSVXn4VnwMJAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6D7961377F;
	Tue, 23 Jul 2024 23:20:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +e+5FL06oGZ9UwAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 23 Jul 2024 23:20:29 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing] configure: Respect relative prefix path
Date: Tue, 23 Jul 2024 19:20:26 -0400
Message-ID: <20240723232026.1444-1-krisman@suse.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: A4BB421A82
X-Spam-Score: -1.31
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-1.31 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]

When the user passes a relative path, we end up splitting the
installation in multiple directories because it is relative to $CWD,
which changes when we recurse into subdirectories.

A common idiom I use is:

  ./configure --prefix=install ; make ; make install

and that currently results in part of the installation inside prefix
and part of it elsewhere:

 $ find . -type d  -name 'install'
  ./src/install
  ./install

Not biggy, but annoying.  Let's use the path where the configure command
was invoked as basedir, like other projects usually do.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 configure | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure b/configure
index f6b590b..21a9356 100755
--- a/configure
+++ b/configure
@@ -10,7 +10,7 @@ for opt do
   case "$opt" in
   --help|-h) show_help=yes
   ;;
-  --prefix=*) prefix="$optarg"
+  --prefix=*) prefix="$(realpath -s $optarg)"
   ;;
   --includedir=*) includedir="$optarg"
   ;;
-- 
2.45.2


