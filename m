Return-Path: <io-uring+bounces-13705-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id HKIGAp1VLGpNPgQAu9opvQ
	(envelope-from <io-uring+bounces-13705-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 20:53:17 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id D4C7867BDE0
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 20:53:16 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J9eJzoz8;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13705-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-13705-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3A7CF3016C75
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 18:53:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9B40314A79;
	Fri, 12 Jun 2026 18:53:15 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC504189B84
	for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 18:53:14 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781290395; cv=none; b=M/jrcsIQQ3BLwA/WftpYJ9+Hap++ylVdbZcWdwPtVrnUyU+5O5kuE0EaztYRk2JbZs1XpiwdgIUKI4kISgLUOTc5F1GQf6c74pD37ZQ1pcp72hJpqsuY0oZOfoYa0B7FiNHmU2lEEU8v82BRbLz31ui37ochroE3N+oJTzy+Vrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781290395; c=relaxed/simple;
	bh=0/J9iT1SbQo1r3a+H3EBXXHWgO2DUvQweFq9yS5+ilQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MqbmOXANDCvmrwFEP+0TvzmQy+nbumQnh8ejkd/611KfBxsVLRJ0rFD9rW7qK25d4/a6aZ3U0R3lb2pwwn30Rzc3kSAnCCQbqnhiP/ctbNoJ6PsHP5fHAZ1firuJUGLhK6iX2I3r5izTZ8f18jX+oLJRjBYcPo/PcRuchZK2j4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J9eJzoz8; arc=none smtp.client-ip=209.85.215.174
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c858b5de728so837379a12.0
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 11:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781290394; x=1781895194; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8ZvkHD3wdV4DD8gZCg48BD1eg+E6XuDbGqJnkWpybxs=;
        b=J9eJzoz8JPFVFNcvFgHwe8f/+MWp3LbivMPOBKa4KFR6kfgwIXy6HRIwdUnQBKq21E
         OMErgbdga+rMCpVCZFh4H+8ilalOejlpIdANFInn9oKVSte693Gjl9Lvjet1c2tRvm/K
         aGCSDH9STMZOeqJTGt0CJIGBn/RpkNZJVpYi2xBRftwDvvObgu50PEDMpAV0Mj+U0dpg
         NWtZe9GmjvEp6ii/IQr1OgYBKO496rb7PFLRfG87P39yZxeCPah26C/k9eelxLQd6YG+
         Og1pMp/ZRIadqt8X8eOmOky5+crmajaEYJ6DLh25acQysDhQ6P2DMOR93Y/jDB6QChdX
         aRkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781290394; x=1781895194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8ZvkHD3wdV4DD8gZCg48BD1eg+E6XuDbGqJnkWpybxs=;
        b=DhlydAhCGeKYaWvr4G/tXuAPSnlQDB9LIAi6Hfn5/iTFXl/AKVeksXf1lJ8cTiuEXv
         Pn7Vg50rVfsUdREt3Trmr6khIBHFnuCcOSRHIls59SratALh6aendd1rT+BB76QRUbhD
         G0XspCuC4fsymgtXJNenUhpEE8Sl6YgTBttRvg4dDkr0aALfpnrkqAgpUtq5RcRMHWWq
         sOFwO1RzP5+lC/ZsQK3z+Zpal4nKoKEcmBOGeJMMrSeTRu2wqZCAqbelXrHDrCw880up
         EGyQldINOfWjcejIHXOx2E6aVw59Li6l45J52yfQ8/to/DxymsgY6vzadpQRUQC36D5V
         xVaw==
X-Forwarded-Encrypted: i=1; AFNElJ9nBzFXC4jJkiNoZBGxl0w6sh2yGdxeP8bNN1xrB0qWLvKqneorc4e5F72UtnF5Q6rZ0h5yefW8kw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxfcl11iA59nHVojz3bRCIua8VsUttxJIOF+DfzgGPJNA5xkdiE
	Le+oVa133Tpw3bPSgQ4E4Jqjc+oA734my1uyJONuCpAZXkzQ//0rG0nPGhqIyw==
X-Gm-Gg: Acq92OEnUeMYxq5DNMX+cwEPqFMRHWRfoMknkYEZdoUN+eLfPQBoRDZGOdQq6QVpymT
	Dt3yJazsh2PCLaZUeMu0kxYA/TiZN1n6h7pVLQ0HqzMDVDsSFm7BhBA/c2ZZZ9YyekLw3Tj8VoC
	EZdRmm5WCCWpLvaxMi2XdCYYJGlW1dIZ9fasgpVISei2VpItoDZj26KKzo8UViJOqLCgxMkXO/4
	QYwEM7qHUmB0iE3M+8WrkEw3vSuMmmrpiGazfEM4Vk5WhYU87iI0JVs5r6qQB5cSjp22IXI6c4K
	ijPCcKOqjM4/2wW967qMhW+fRFyqeAP4v6epVONXoSh82oN1O9vFWUltqM0YFIF9w3A69O6/xs1
	6b+TWTMy3IqmUmC5t/pWxMTswKazK56ZXvOcA1kcd+RBtBk5I/tmmw4R1QklLk9xu5y6gIO/mP6
	3oeKIU2ynOsZgZsipmN/ymUBw3BUNU9AcZoTadk0G35gtYmfK9BVVvYK5IZKYo3qoZKTW0Ryehc
	A==
X-Received: by 2002:a05:6a20:748a:b0:3b4:7aae:1ee8 with SMTP id adf61e73a8af0-3b79624cb18mr944439637.14.1781290393884;
        Fri, 12 Jun 2026 11:53:13 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:2::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c86651a0090sm2674961a12.26.2026.06.12.11.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 11:53:13 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: miklos@szeredi.hu,
	csander@purestorage.com,
	io-uring@vger.kernel.org
Subject: [PATCH v7 4/4] io_uring/rsrc: rename and export IO_IMU_DEST / IO_IMU_SOURCE
Date: Fri, 12 Jun 2026 11:48:40 -0700
Message-ID: <20260612184840.4058966-5-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260612184840.4058966-1-joannelkoong@gmail.com>
References: <20260612184840.4058966-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13705-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:miklos@szeredi.hu,m:csander@purestorage.com,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[5];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: D4C7867BDE0

Rename IO_IMU_DEST and IO_IMU_SOURCE to IO_BUF_DEST and IO_BUF_SOURCE
and export it so subsystems may use it.

This is needed by the io_buffer_register_bvec() path for callers who may
need the buffer to be both readable and writable.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring_types.h | 5 +++++
 io_uring/io_uring.c            | 2 +-
 io_uring/rsrc.c                | 2 +-
 io_uring/rsrc.h                | 5 -----
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 6415a3353ee0..6b2957182c7f 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -44,6 +44,11 @@ enum io_uring_cmd_flags {
 	IO_URING_F_COMPAT		= (1 << 12),
 };
 
+enum {
+	IO_BUF_DEST	= 1 << ITER_DEST,
+	IO_BUF_SOURCE	= 1 << ITER_SOURCE,
+};
+
 struct iou_loop_params;
 
 struct io_wq_work_node {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 33b4340d32a7..042f25f2c613 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3250,7 +3250,7 @@ static int __init io_uring_init(void)
 	io_uring_optable_init();
 
 	/* imu->dir is u8 */
-	BUILD_BUG_ON((IO_IMU_DEST | IO_IMU_SOURCE) > U8_MAX);
+	BUILD_BUG_ON((IO_BUF_DEST | IO_BUF_SOURCE) > U8_MAX);
 
 	/*
 	 * Allow user copy in the per-command field, which starts after the
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 819c5087d8d3..f3f01e0c8102 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -912,7 +912,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	imu->release = io_release_ubuf;
 	imu->priv = imu;
 	imu->flags = 0;
-	imu->dir = IO_IMU_DEST | IO_IMU_SOURCE;
+	imu->dir = IO_BUF_DEST | IO_BUF_SOURCE;
 	if (coalesced)
 		imu->folio_shift = data.folio_shift;
 	refcount_set(&imu->refs, 1);
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 98ae8ef51009..e503b02aa61a 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -23,11 +23,6 @@ struct io_rsrc_node {
 	};
 };
 
-enum {
-	IO_IMU_DEST	= 1 << ITER_DEST,
-	IO_IMU_SOURCE	= 1 << ITER_SOURCE,
-};
-
 enum {
 	IO_REGBUF_F_KBUF		= 1,
 };
-- 
2.52.0


