Return-Path: <io-uring+bounces-12122-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cAvLHd18imkgLAAAu9opvQ
	(envelope-from <io-uring+bounces-12122-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 01:33:33 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1825F115A6C
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 01:33:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8440F30427FF
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 00:31:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 630E6186E58;
	Tue, 10 Feb 2026 00:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jh9gAYWn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454AC16F0FE
	for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 00:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770683513; cv=none; b=hPJKhClLBTZrVgJ9/CFxkqbxvT+lld826KhKF8E8eP72nFYqg3poXW7l3zu7rjjEBDLxjPDIdwT3FnQz4Qn4jK8bMcjL1sp0lUHa4FN4fwnqxMKAhY97iJEjKy3goAtJ9hmXfwnv2XkkCHJ19wOyRFbwuOuecjpix5cmrdXugMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770683513; c=relaxed/simple;
	bh=FDqqgst5N4I1Qao0rBTYji6NztOjthqIoB39rZ9nRjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYRpqAgjRhh1UmzKQs+5ZREuFJmUWV+0YBDVHsNounVN19RSp9YY0J+PB5yr7hZQhvMx7NS02tZ+wLkGwlEldReOD6jfauuRpeR9101tA8iV0sr78tJmEybVnKU13LmdSqvTAlFAWFcyWFTJAE+JeMijMUkOYcbTWZGASBU292M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jh9gAYWn; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8231061d234so213717b3a.1
        for <io-uring@vger.kernel.org>; Mon, 09 Feb 2026 16:31:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770683512; x=1771288312; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D9mcGOimZozNryX99SpCqzkbBzToCKJITt/Fh2vWzFQ=;
        b=jh9gAYWn/zK0EYy3JhXWgXWVr3/78dXwZ9CoZAg8u2AclpFlWIY6FOQRFEFf6YlEsy
         /iC2B/Jqdg5tvfbaf9lr5ZiOwcg9cLKysezCHWLE7NtKeh/tvFjVpxz7QWh5Zsen3OFg
         1Pe18pqL2uTmeqT+7VHVPwcIFFDhbiB/K0mVagPJG0r6owAoKrCeqbzuqTUnww8xhcck
         raTV31acv3nCdOow32mEXJPDGawwttFlawDQ83O+q9Gs7cCuwTPP3wAvFp9BpcNBjyZ2
         DCuA8xfGG5IyreRQGr/NvP1eZLppIm2Ib000Borpgkp2bfyx+B4FE1JY4tqo5mHBMjhf
         iptA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770683512; x=1771288312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D9mcGOimZozNryX99SpCqzkbBzToCKJITt/Fh2vWzFQ=;
        b=UB8j3xKwWRsB55kC0QlzlVasKKtsN1/oi1hlEE9HhkgG3PGW+9NS+x+mqVAdTO2t0v
         9GBkwX/Of5uaOZO8mCU/LdJpnKc3tMC7bcf0Ac9+BqE1O3A+KDtLhIbyNTHfBGtqNvDT
         Hihmzj3AtX17ekFjFK2jtRhkmWwv11N2rW+ugiHbKBaLjw4XWPLaR/RFpuR9Bmli4aSq
         YGRVtrSpn5dxrEYmRGM7zKFwfvZVGTZugx8s4Fe41wcYUETKmV7g0dNQgrjlszU/Iban
         KaPGUhKUCSKyAQ754eLIdw4LnwWeSZyVv0AQNUfCPUmovA7gLNxD7sULO/sVphNVOFzx
         vaBA==
X-Forwarded-Encrypted: i=1; AJvYcCUD4GnWFN3a4cSx3PZVYHw84hpoxpxiCDahPhP5QQ4Sc44hzIMZeodQvfFdQ3SMvy87S+tKmMZijA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyFWTLAGhqRdAJFJyrLpXkwJtffcsDzilIwvWo9v08A+Qec0S8l
	JfdWrMkHTOKjR5XXu11tu68w8BxdiDtSm8jX5AegHXeHU3vYzbjHdIxY
X-Gm-Gg: AZuq6aI2bJLNFXcu9QPrkTwfxh3EHHTwFYTPK8vwocOiaqxNFvMQdhOgSGMChRDVhTC
	52xkjQsuK6MzJd/5Dcu1yiIa18zNDuSqFu0T9rSAI4xs9kx+LwXxx60qDd9vwjSyqAI+vCczoY0
	8c2lNU+gH3M7uXEulcm/1jbfa/CUbYbm11MhNvXCfM0NB7/+IYUGxAvxFRi0l4Td73PeONTdysn
	e+jM+vyLhbCY3WvFRmuav3rWvRs2lqqRG/78lXpIa41V/+rcZpsVD5sugqT3ULEUdvGfeYmQyjK
	2Dx3tygivSPBnzD2MxQ7R7v1JOHPnhM+DO3X4R3/GZmYFcxLgGrucjKstcbnqow+igAdn5sns3H
	41pooSCsTBvharlkOMGQDDgPxYtAufY17zTcSTJ/ZLfu8dJ4lzDf/21BPkjWz5qmW/Zajs/irxp
	AN5lTkVA==
X-Received: by 2002:a05:6a00:4c8b:b0:81f:4ce8:d642 with SMTP id d2e1a72fcca58-82441777e69mr11375093b3a.64.1770683511751;
        Mon, 09 Feb 2026 16:31:51 -0800 (PST)
Received: from localhost ([2a03:2880:ff:5e::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824418ccb2asm11122071b3a.58.2026.02.09.16.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 16:31:51 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	krisman@suse.de,
	bernd@bsbernd.com,
	hch@infradead.org,
	asml.silence@gmail.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 08/11] io_uring/kbuf: add io_uring_is_kmbuf_ring()
Date: Mon,  9 Feb 2026 16:28:49 -0800
Message-ID: <20260210002852.1394504-9-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260210002852.1394504-1-joannelkoong@gmail.com>
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[purestorage.com,suse.de,bsbernd.com,infradead.org,gmail.com,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12122-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_DN_NONE(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1825F115A6C
X-Rspamd-Action: no action

io_uring_is_kmbuf_ring() returns true if there is a kernel-managed
buffer ring at the specified buffer group.

This is a preparatory patch for upcoming fuse kernel-managed buffer
support, which needs to ensure the buffer ring registered by the server
is a kernel-managed buffer ring.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/cmd.h |  9 +++++++++
 io_uring/kbuf.c              | 20 ++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index a488e945f883..04a937f6f4d3 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -92,6 +92,9 @@ int io_uring_buf_ring_unpin(struct io_uring_cmd *cmd, unsigned buf_group,
 int io_uring_kmbuf_recycle(struct io_uring_cmd *cmd, unsigned int buf_group,
 			   u64 addr, unsigned int len, unsigned int bid,
 			   unsigned int issue_flags);
+
+bool io_uring_is_kmbuf_ring(struct io_uring_cmd *cmd, unsigned int buf_group,
+			    unsigned int issue_flags);
 #else
 static inline int
 io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
@@ -154,6 +157,12 @@ static inline int io_uring_kmbuf_recycle(struct io_uring_cmd *cmd,
 {
 	return -EOPNOTSUPP;
 }
+static inline bool io_uring_is_kmbuf_ring(struct io_uring_cmd *cmd,
+					  unsigned int buf_group,
+					  unsigned int issue_flags)
+{
+	return false;
+}
 #endif
 
 static inline struct io_uring_cmd *io_uring_cmd_from_tw(struct io_tw_req tw_req)
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 17b6178be4ce..797cc2f0a5e9 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -963,3 +963,23 @@ int io_register_kmbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 
 	return ret;
 }
+
+bool io_uring_is_kmbuf_ring(struct io_uring_cmd *cmd, unsigned int buf_group,
+			    unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
+	struct io_buffer_list *bl;
+	bool is_kmbuf_ring = false;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	bl = io_buffer_get_list(ctx, buf_group);
+	if (likely(bl) && (bl->flags & IOBL_KERNEL_MANAGED)) {
+		WARN_ON_ONCE(!(bl->flags & IOBL_BUF_RING));
+		is_kmbuf_ring = true;
+	}
+
+	io_ring_submit_unlock(ctx, issue_flags);
+	return is_kmbuf_ring;
+}
+EXPORT_SYMBOL_GPL(io_uring_is_kmbuf_ring);
-- 
2.47.3


