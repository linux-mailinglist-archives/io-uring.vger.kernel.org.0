Return-Path: <io-uring+bounces-5994-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 98289A15B20
	for <lists+io-uring@lfdr.de>; Sat, 18 Jan 2025 03:57:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFBE81682BA
	for <lists+io-uring@lfdr.de>; Sat, 18 Jan 2025 02:57:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9849514A82;
	Sat, 18 Jan 2025 02:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="vfXGyCRJ"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8DD134D4;
	Sat, 18 Jan 2025 02:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737169043; cv=none; b=hDs8SOH9WQoWtV87VRwixYQ0lnx5TGaZIuiKQ8sB5PGtXTUeOG85K6bhm77E/MKzQNicsTe43OinfC345T0VkhSMvw8nJcfE0GMQAm7c8E4Fp3GHRJEEy2gnChsmpz/hjUjyjj2WhLJubDKtHSiqngrkzsBIxrgrvyROpoVBpR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737169043; c=relaxed/simple;
	bh=GMFi9nHeTvIBKZmh3hlbZoJ8Jt6lOKi/Hgbs+9JlJTE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=NqXC+d6Kjg3/5KQ8fPeARFEl25mFdVsOH1/lYKXW4bNeckDaRTYjrB0aAtRpQqK8JHxZ4oK8V3WwUHGAPZJKf4dv6tdrKF6hUdkAtOIMKUJix2HK1QAEOXY4OsWpy37Vra3whcyQtttM+u6jJmGyf1LMYMkOdLxRjJjlwGoFyyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=vfXGyCRJ; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=svBW7OAiM6brfzanr9gW/aY6gZVjAXk3jmFgEBllS9c=; b=vfXGyCRJccsfWC4MHVylvKfcHI
	1ue1bZPQqvIjdWD+xbQQ/ukWvGBoiSwlALCk3waM+Um0mj/Cit7mWVJZ+XDia+gKDaSubFT4SXTvN
	lTkREomuaCbPWUwoDRzUZjYGQlDtVTTyomjThZroy0QJrncEHANLt2jD4Uau6lu2+bfSv+dxb3uJS
	d72eW9sndRHb2ZtnMQ+cNOTklDrFyoB+qD4MIzNJVVCCXLfwL24ZIEodXDBlJK3HdCsy95Y3Hq37d
	7AU7/7w8g7QP8/RGtTRfx4oZbYSZuMuZXZq0oWSojCg+jwiXlztGHAJ98YPLc2IbYpzzB+6HkC1R/
	3QRtZKvw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tYz1R-00000003lsp-3ZWq;
	Sat, 18 Jan 2025 02:57:18 +0000
Date: Sat, 18 Jan 2025 02:57:17 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC][PATCH] fix io_uring_show_fdinfo() misuse of ->d_iname
Message-ID: <20250118025717.GU1977892@ZenIV>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Al Viro <viro@ftp.linux.org.uk>

	The output of io_uring_show_fdinfo() is crazy - for
each slot of io_uring file_table it produces either
INDEX: <none>
or
INDEX: NAME
where INDEX runs through all numbers from 0 to ctx->file_table.data.nr-1
and NAME is usually the last component of pathname of file in slot
#INDEX.  Usually == if it's no longer than 39 bytes.  If it's longer,
you get junk.  Oh, and if it contains newlines, you get several lines and
no way to tell that it has happened, them's the breaks.  If it's happens
to be /home/luser/<none>, well, what you see is indistinguishable from what
you'd get if it hadn't been there...

According to Jens, it's *not* cast in stone, so we should be able to
change that to something saner.  I see two options:

1) replace NAME with actual pathname of the damn file, quoted to reasonable
extent.

2) same, and skip the INDEX: <none> lines.  It's not as if they contained
any useful information - the size of table is printed right before that,
so you'd get

...
UserFiles:	16
    0: foo
   11: bar
UserBufs:	....

instead of

...
UserFiles:	16
    0: foo
    1: <none>
    2: <none>
    3: <none>
    4: <none>
    5: <none>
    6: <none>
    7: <none>
    8: <none>
    9: <none>
   10: <none>
   11:	bar
   12: <none>
   13: <none>
   14: <none>
   15: <none>
UserBufs:	....

IMO the former is more useful for any debugging purposes.

The patch is trivial either way - (1) is
------------------------
diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index b214e5a407b5..1017249ae610 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -211,10 +211,12 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 
 		if (ctx->file_table.data.nodes[i])
 			f = io_slot_file(ctx->file_table.data.nodes[i]);
+		seq_printf(m, "%5u: ", i);
 		if (f)
-			seq_printf(m, "%5u: %s\n", i, file_dentry(f)->d_iname);
+			seq_file_path(m, f, " \t\n\\<");
 		else
-			seq_printf(m, "%5u: <none>\n", i);
+			seq_puts(m, "<none>");
+		seq_puts(m, "\n");
 	}
 	seq_printf(m, "UserBufs:\t%u\n", ctx->buf_table.nr);
 	for (i = 0; has_lock && i < ctx->buf_table.nr; i++) {
------------------------
and (2) -
------------------------
diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index b214e5a407b5..f60d0a9d505e 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -211,10 +211,11 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 
 		if (ctx->file_table.data.nodes[i])
 			f = io_slot_file(ctx->file_table.data.nodes[i]);
-		if (f)
-			seq_printf(m, "%5u: %s\n", i, file_dentry(f)->d_iname);
-		else
-			seq_printf(m, "%5u: <none>\n", i);
+		if (f) {
+			seq_printf(m, "%5u: ", i);
+			seq_file_path(m, f, " \t\n\\");
+			seq_puts(m, "\n");
+		}
 	}
 	seq_printf(m, "UserBufs:\t%u\n", ctx->buf_table.nr);
 	for (i = 0; has_lock && i < ctx->buf_table.nr; i++) {
------------------------

Preferences?  The difference in seq_printf() argument is due to the need
to quote < in filenames if we need to distinguish them from <none>;
whitespace and \ needs to be quoted in either case.

