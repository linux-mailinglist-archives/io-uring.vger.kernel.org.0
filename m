Return-Path: <io-uring+bounces-12123-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aFv4Eex8imk4LAAAu9opvQ
	(envelope-from <io-uring+bounces-12123-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 01:33:48 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A6109115A7B
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 01:33:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F3932302002C
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 00:31:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDB131A9F8D;
	Tue, 10 Feb 2026 00:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jGPNJljL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22AD16F0FE
	for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 00:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770683515; cv=none; b=pMHXwH5OLlXUjfLIHiyJshZ8Ood+KI9tlyEnLP/yFKMo7M0EoklPUVUvTKZFmUchKRZWz8B5J07gAnjLol6K8TLYA3U3aN6wruekwf+WEiy8NxQg0eBblRa1rg4ZYuYbhfoibwAJ6RvOulJ2Ewanq1ImiNAHb6CvLWrvPRtrS2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770683515; c=relaxed/simple;
	bh=85T418bxMQPlMoZgpwsR449gfWaGrmCBfTpbDTAIlA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QLuUkfsih8iCKT/2aELjuwIKtg67KHOA98iRSfMnmPVuqeZEHA2GiJi2sA8RkPOna2OmHr2g2K3sc2RgBhd6LS5qAoz8+8D/76cFp+AN8xhWETGtxTNAcVwpx+p1v20FBH74upxk1dOdQELDI9jx3BxSn8Tnx/r4P3v1D4yldZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jGPNJljL; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2aadc18f230so12650765ad.3
        for <io-uring@vger.kernel.org>; Mon, 09 Feb 2026 16:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770683514; x=1771288314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j4GMzQ+WyVIO7EowZoyQFL8qWo07xEupOkDSdjri3ek=;
        b=jGPNJljLXc3IFXzRxV+/piT7XXqzTSROpKhtyVIXOCzPwjGW2j2s409zz1+C8S/fVx
         1tLOigkc1nCwgQibub1IDZwqcyUk5GXsxDvMjYK7W/fXyq+elFVBjw93HBlTj1kwoCOJ
         DpDviI8oI7zHHBpmwDoV/6ElnS9d47tJvDgx/V92afZjeFvf/epRpiWNKU0HN+SxvpVl
         zvkDqvvhxDEIWG4wvfqUSlCnFAQUGdxxu5NUIGLQfihQUM+R9YpVstAFskMhMgVvymQs
         D5YL6POYCYqYFQ8c+KW4bWc0ARUs5ijZyluX4U7gMijCMHIxtXO/SDSAgdChk/0RAEuD
         BrWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770683514; x=1771288314;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j4GMzQ+WyVIO7EowZoyQFL8qWo07xEupOkDSdjri3ek=;
        b=mrbsqmCw4tO/dVY5stVZ+/9iNxf3L2KskcQNoS1jcNhyR9UrBu1HTFez7ZzZ6frATX
         NiMCvLBTt/VmmMhXLB5sk2egoyvR9Pojqn/gHAAiqfSL8qrZ4bLZMrS7Knv5ivBMlvox
         pV5eDqMylmjUNvdWnLx5X8QfChiofyHX/vAY5oiX0fFuLGw5ki6buR3MBl4RVdgUYdG4
         5fvwfbmdSCqcv3njskRiaO0bA/NAR233tzF+PXxJcyEca1dIUUrH/4TODNmHFQCSnUw2
         yH9T8DhTChB9Jq8LuaEGqzJUb5TiIrSRIC5Z+z0tWzsT2RFdYprWkSXxVzsUlNa+W5Bw
         VTXg==
X-Forwarded-Encrypted: i=1; AJvYcCVY/iR2QSpb/v73QGqK9KfERybkH2np+zdJvqHeM+NuQybUlcTBCZGXO82g6G0haVL6C0Y1tyocEA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9gkiVR1gV2UPsqI4GKtCWstStfAiX8Gw8k+SmpcoyogTqg/2g
	foO6gJQiJoOTNipIEgfc7L+1Q3vj3kCcUSF/HJk0D2zReEiJTopRz4vR
X-Gm-Gg: AZuq6aJxxvjeEYGrfs9LZvB8UwtGsarWd9/4yKI/YgpNPw6tU7Te4tCOgczNEJct6/7
	rL3LIFFqqW6AbeQ2/zRWDKVjOlQzwBYYpzD8CWVysJpwWTnP6LF0BvyaMNYTsD6gdN6jHdr56fd
	mpXY7jNv2DP0kcvDsDMQfd5hJ/D1NYE3Do9EDYjvQe0Efuk0qscDX22klluhSsIthzlvujtj43T
	oywucpw2qw7fxofTZdkPeMrsdRsIRKXuaWir6CHyUQ5PxV6kqXpgLKxlqc3ddYaSlW5EwSAw9Vi
	cv4Ttseqn8dRULvsUkN2+8Kcl36nPdY2fNujtUbCxpXvk736i24r9wbtRugK3Uh9KoeVIfvTKAm
	fz+dJvfqG92/XouNWHcpe9AeEk1b7c8R8iSYth7kpvXE0yB3XVecf55JnjgSQLFzOtviLGCZVCo
	DulmF4XRAftDeLs0y7+Q==
X-Received: by 2002:a17:903:298e:b0:2a0:b06d:1585 with SMTP id d9443c01a7336-2a951926c64mr120927835ad.34.1770683514022;
        Mon, 09 Feb 2026 16:31:54 -0800 (PST)
Received: from localhost ([2a03:2880:ff:55::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ab0b392cb5sm7660585ad.70.2026.02.09.16.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 16:31:53 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	krisman@suse.de,
	bernd@bsbernd.com,
	hch@infradead.org,
	asml.silence@gmail.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 09/11] io_uring/kbuf: export io_ring_buffer_select()
Date: Mon,  9 Feb 2026 16:28:50 -0800
Message-ID: <20260210002852.1394504-10-joannelkoong@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[purestorage.com,suse.de,bsbernd.com,infradead.org,gmail.com,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12123-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
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
X-Rspamd-Queue-Id: A6109115A7B
X-Rspamd-Action: no action

Export io_ring_buffer_select() so that it may be used by callers who
pass in a pinned bufring without needing to grab the io_uring mutex.

This is a preparatory patch that will be needed by fuse io-uring, which
will need to select a buffer from a kernel-managed bufring while the
uring mutex may already be held by in-progress commits, and may need to
select a buffer in atomic contexts.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/cmd.h | 14 ++++++++++++++
 io_uring/kbuf.c              |  7 ++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 04a937f6f4d3..d4b5943bdeb1 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -95,6 +95,10 @@ int io_uring_kmbuf_recycle(struct io_uring_cmd *cmd, unsigned int buf_group,
 
 bool io_uring_is_kmbuf_ring(struct io_uring_cmd *cmd, unsigned int buf_group,
 			    unsigned int issue_flags);
+
+struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
+				       struct io_buffer_list *bl,
+				       unsigned int issue_flags);
 #else
 static inline int
 io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
@@ -163,6 +167,16 @@ static inline bool io_uring_is_kmbuf_ring(struct io_uring_cmd *cmd,
 {
 	return false;
 }
+static inline struct io_br_sel io_ring_buffer_select(struct io_kiocb *req,
+						     size_t *len,
+						     struct io_buffer_list *bl,
+						     unsigned int issue_flags)
+{
+	struct io_br_sel sel = {
+		.val = -EOPNOTSUPP,
+	};
+	return sel;
+}
 #endif
 
 static inline struct io_uring_cmd *io_uring_cmd_from_tw(struct io_tw_req tw_req)
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 797cc2f0a5e9..9a93f10d3214 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -226,9 +226,9 @@ static bool io_should_commit(struct io_kiocb *req, struct io_buffer_list *bl,
 	return false;
 }
 
-static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
-					      struct io_buffer_list *bl,
-					      unsigned int issue_flags)
+struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
+				       struct io_buffer_list *bl,
+				       unsigned int issue_flags)
 {
 	struct io_uring_buf_ring *br = bl->buf_ring;
 	__u16 tail, head = bl->head;
@@ -261,6 +261,7 @@ static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	}
 	return sel;
 }
+EXPORT_SYMBOL_GPL(io_ring_buffer_select);
 
 struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
 				  unsigned buf_group, unsigned int issue_flags)
-- 
2.47.3


