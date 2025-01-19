Return-Path: <io-uring+bounces-6001-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A1C75A16016
	for <lists+io-uring@lfdr.de>; Sun, 19 Jan 2025 04:26:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2725D18865CC
	for <lists+io-uring@lfdr.de>; Sun, 19 Jan 2025 03:27:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EBCD27735;
	Sun, 19 Jan 2025 03:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="UKWJK6A3"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E26257D;
	Sun, 19 Jan 2025 03:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737257215; cv=none; b=D4Y1pKRrqb/5PLh2EdOORFLiMJTO0LKyt7SyDSE3fvJS0W+gvqIc2uxCuhPBp5ED5clUJ8tFP2goqaYfJb30YDZZy0fE3sVYvqcjcJaxXYI6XejWNwxJGtNMafoNMDD6O4wibwAwm0E67OeK1a//VIZ8RCm2egyXZx0Mc8oHekQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737257215; c=relaxed/simple;
	bh=K9keBNlDZRQtdk7HhZ6KdwEDEhE29bqpqYPpH2lCwec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OhS+B+BrRTGKg9JXq+BiH75TuM1gKt0Ce09VP8rqHG8EHZOvyA/PPlSX2cXET+EsMG77n/F9dvtNUuO1uIQaMqlp6t3mZ/nNijkTWNTILW/LdxIfbyuzfKLCXOROGc40/j1KKzxu7KVY1lFgI4Hfup+n2ejlhL7qwxy8+TdCSX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=UKWJK6A3; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dOYkumjLGpeR0yN7ontlw2BBDSnb3xdbwZlJ9c3uc9I=; b=UKWJK6A3i5zuF36/0rf7xh9FjZ
	82Sde6SpAGwNkM1vEslW72Zq9FGeU/N/R/QtFNHcEOfmw90uJS/0bdS5VFIP3gX40rcbbGBN6Dslz
	VSRmhLNdYrt8CbYRGSf2diaYjSo3kvWGTIbkl1ONRd8jprngOVTXMDWz9wcwUgNxpPNwdDGDFH6dr
	BG1jPWggX14ZE34WSQSI7gNVdIyzPhDGZ5UiOyVVlzuOjvN10spfkmurreIa1NRc2rgpsQfkjoJFV
	oopVckwfdZE8mTLWwaWNnlbX0I/B/ZEQH0GbNlb6+YUsVpz1FURXIkUDDYLfIpVCXBaFs6PVTjtap
	G+yM2qvA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tZLxZ-00000004dbg-26hk;
	Sun, 19 Jan 2025 03:26:49 +0000
Date: Sun, 19 Jan 2025 03:26:49 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH] fix io_uring_show_fdinfo() misuse of ->d_iname
Message-ID: <20250119032649.GW1977892@ZenIV>
References: <20250118025717.GU1977892@ZenIV>
 <cf13b64b-29fb-47b9-ae2d-1dcedd8cc415@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf13b64b-29fb-47b9-ae2d-1dcedd8cc415@kernel.dk>
Sender: Al Viro <viro@ftp.linux.org.uk>

	Output of io_uring_show_fdinfo() has several problems:
* racy use of ->d_iname
* junk if the name is long - in that case it's not stored in ->d_iname
at all
* lack of quoting (names can contain newlines, etc. - or be equal to "<none>",
for that matter).
* lines for empty slots are pointless noise - we already have the total
amount, so having just the non-empty ones would carry the same information.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
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

