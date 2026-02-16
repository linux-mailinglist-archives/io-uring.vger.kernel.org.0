Return-Path: <io-uring+bounces-12237-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wLyCAIoDk2nF0wEAu9opvQ
	(envelope-from <io-uring+bounces-12237-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 12:46:18 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DB5B1431AB
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 12:46:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0D72C3004D15
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 11:46:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6F682D9EE8;
	Mon, 16 Feb 2026 11:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CXtQ9wI9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3D52FFFA3
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 11:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771242374; cv=none; b=ZvPegnFAUCK+bIUCaNX65sOeFY6dhWK8I+C3nZajhoJBy5jZ0FQ95V8wIcMWDKsd9mrkdCXeNATk+F0jqYNatPTTs0hk0PkzS9M4YtbplLG9tVhYdVHDiMuup4x0NomfI4Ic4/b1vX6r4G8T0Nu96wtfjrzdOGmYXpars+7Lw9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771242374; c=relaxed/simple;
	bh=zfyXqj+hfqIa2wbuM0T+xe7FeG7VVXmW8h9EInslc7s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GnW6grNNibNQsnhBi35H0xoa8q3IIZJGxFbH6fjDNsLXXKxUCofcoVjBNx6bUDzXZZxGI54FV137SyiHg2G7lLZRo5GTU55Fm5gE5mRnn+VnJWYtUBXWNy1UrfZ3V3kR9W496n3hERaWgtzbZnxyxhNvLSEK8v9cWho+t6E248E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CXtQ9wI9; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4376de3f128so2046459f8f.0
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 03:46:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771242369; x=1771847169; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+3AlY0Y9k7qipwAzKvp+L4L7kmVMTCrtSelq84xH5i0=;
        b=CXtQ9wI9IZELGBgdR8lj2aamZYKvNsoGebefIHtuemMgoe7C94rC4mDZn88ObzUP2d
         9HFjIiiD7yhrvC1uTtEMKm0hYB2K6Qb2Iik1GLE8Txh/jUhOW+ZiQTd8t1f6ZvD9cIqE
         9AJuSfFGy6Dz63RARVK7UKg7VQqA9mIAVkxLxFeY6h5v2QqMJ0OopLndajqjSGXQOcGX
         /Dj3KFEzKUARSNod5wYI6DAenY6tsLM0yYO8LT2v8EMLYBUdtiOD849cdokDpKDheh1r
         8YKbDLmT3LxofpZNBVqK0eQ+xF11aJ6o6HtxOPLChh0dtHomqrsjt7ab5ynVGtmQtG7o
         H39g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771242369; x=1771847169;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+3AlY0Y9k7qipwAzKvp+L4L7kmVMTCrtSelq84xH5i0=;
        b=O9yfcwirUov+YAbRuBwxe0cj18F+YBKXYJWXU+p0pdhWoWw2urKYpx17so+F3HZP9O
         W8F041zwXUL/jcYT+KHd5leZiucz/sWAjyNtKvmvd7MPl5aGqHw5elrcm346xez6K8YP
         VNtwRsBXeDDW+ZCqlEf+XexRFVBd8kY3uM/3nvLsd6bPnk53OHUyKCnvrE4ffxO0aruN
         CU+fva3HIA/RVGALHG6FzCekzdJmlI8twFKZRxDwk/c+LrqkN4r2JGkQO3BP0plT9wwX
         tIp7SDU7ChXpfu0aUzNMWCuO2YiSKJkqt6ZOA2SEsQwN98qO9PLZKiYsRHL7FQ4Yg3LQ
         +lig==
X-Gm-Message-State: AOJu0Yw7mBAjYtkCDi6MxB4Knw6cIH6qIQUVChz3UY+V8gvgCQHUbVf9
	HUgAqVDJPhUiTzDVjNxEDaDQU0p43AX5r8weI6J0BmLrvxGKFlmMPRNJOrt0gQ==
X-Gm-Gg: AZuq6aKybaSkWbw4XQP51EN7oqvxJFlxVkAm059oHNDDIJiUwoeZl0RJb3YyJfMdXLW
	t/fXmsSv5bbwICJsFpesXmW/mK0NANgRXjI3+BTP3/FCnLfnWMLQV/GxhXKaKVjbjQjNkjpu+SQ
	bhZHwoaHVZv0jyvHY12exQ//6XidkSNnGOkyiM22afsNlbG3tjtrUHXvByvRTet5Ha4Qd+SrS/I
	I76pTD9PR0Q1hcwfNR8hhT/jfxezhsFSHDtg6WKVdAWs/bblz773xTlcZiGCURF00AAWfYwmHH+
	dzQVyjJH0BsIX6skKKVn4KRVGT9zsIWBoZgyrCXvRDcYgfnmbhBsGoq7VpMA9+KIDxV/QrbZenX
	KGrOg1Uh26kwZSNshjwTJFSAqNJR5w02EJONL94ef9aqHj5rKqVYmOP87Gxp+BwVD3HH2a2TkZG
	lXBk+tgSPnV6qkhffuZm97d/N8ACxhODIcA1Vd0V/BYp423EnLXAYWeOoZK0CR8/lZ7beHj1w4k
	23M7udF
X-Received: by 2002:a05:6000:2403:b0:435:b0e7:ea1 with SMTP id ffacd0b85a97d-4379db6649cmr14306204f8f.19.1771242369014;
        Mon, 16 Feb 2026 03:46:09 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:c3fa])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796a5b4cdsm28991802f8f.8.2026.02.16.03.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 03:46:08 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	Dylan Yudaken <dyudaken@gmail.com>
Subject: [PATCH 0/3] deduplicate send and senmsg zc issue handlers
Date: Mon, 16 Feb 2026 11:45:52 +0000
Message-ID: <cover.1771240334.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	TAGGED_FROM(0.00)[bounces-12237-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9DB5B1431AB
X-Rspamd-Action: no action

There is a bunch of code duplicated between send_zc and senmsg_zc,
let's consolidate the functions.

Note: it's based on top of Dylan's patch removing buf/len accounting.

Pavel Begunkov (3):
  io_uring/zctx: rename flags var for more clarity
  io_uring/zctx: move vec regbuf import into io_send_zc_import
  io_uring/zctx: unify zerocopy issue variants

 io_uring/net.c   | 125 ++++++++++++++---------------------------------
 io_uring/net.h   |   1 -
 io_uring/opdef.c |   2 +-
 3 files changed, 38 insertions(+), 90 deletions(-)

-- 
2.52.0


