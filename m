Return-Path: <io-uring+bounces-12572-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UMXOKukgqmn2LgEAu9opvQ
	(envelope-from <io-uring+bounces-12572-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 06 Mar 2026 01:33:45 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 64BE5219D96
	for <lists+io-uring@lfdr.de>; Fri, 06 Mar 2026 01:33:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 71A9F303969F
	for <lists+io-uring@lfdr.de>; Fri,  6 Mar 2026 00:33:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FCB02D77EA;
	Fri,  6 Mar 2026 00:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mWH6MH3n"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32DE2D77E5
	for <io-uring@vger.kernel.org>; Fri,  6 Mar 2026 00:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772757203; cv=none; b=LnqJvbqK/C/CAxvwybix/KghmDsGb8stm2V/A33PHWGKvvscIcqmzCiLlGLAyLI/EbC03xfRIKFbq1J2qoBZple7iT1OsXHfycea1/wICSglW+3AXh9XC8B1z4pD4bVn2r2W3eAQcXAW+QkQ20KuUs4KlninRiOyANK0W56HAsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772757203; c=relaxed/simple;
	bh=Heyu2Q5T5X4A9SKANnsUv6UKZixsvFR59P1h1KCTty8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiNjWUdkgTODgesjjIEAvEaAQW2DOtorkYwm/FrS1mzB0pQ0sD9aef627OFymXXfItzJ/D+Sg8zif5Tntf2eKauly2nRjW8nScrXzha0OjE8sK1iih/pgh0GKDxU2P9D5XGsYpVVDw3JkEXPv/svfnUew4d3GUzmDJF/m/Usv4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mWH6MH3n; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-82989744ee0so1213950b3a.2
        for <io-uring@vger.kernel.org>; Thu, 05 Mar 2026 16:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772757199; x=1773361999; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y26k+fkCoNaSBSZdLvS8sV0ZMa7T8y/2My/KGsSy7Zo=;
        b=mWH6MH3nzjPy7W8MZ7l4PSa3fbjSnRiPHXLKoP+x7pYyj6b+nmVAipZyUddJL9RoLN
         x4SpdVf7pMvw6YXxziv6IULSltE0XphjKexvkWaFoudZwUtSUcWMGMhqn679PxPGGW0N
         6pSC5SS9D/bOqJH+c4ABzahi+MrbSLfih5gU6Du8c4b0OX2iQl6wkK1KNp+W/9fou/bw
         +hNp8X57xn7AW9BRGNqhOgZRSG11i3lfHLocbLu4Cakcg/lAlppHOncPtIuAFdJN4ms3
         EhSfqK89MYjFD/SKwslq6/j2LoYhLHveR3Fvyq0lKy2jisgyZP1ZiMtol8YVQS62lAvy
         +bQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772757199; x=1773361999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y26k+fkCoNaSBSZdLvS8sV0ZMa7T8y/2My/KGsSy7Zo=;
        b=RFShDzoHJbEJ746Bss6ZUZrN4M8brPEybEXQnTpFkGYmeSEPBL724ibuR1x9oDYt3z
         HcHcdF70Y9XhaDotQuUfN2A+47TumnWP/i0l4WWpm9QG4dSNlisMkDQL4EUEbKGhP1U9
         jYs7r6hP0ZPU174B4zZj6vdYsFRrR2d7833/io7qhRkEPpM/G2t0oECSKmsUcBT6GgMu
         JAiq83xT3k00MXrDu3wPOPgDU6idN0Dn64SmUj5Uj0zsRU9f4CuEIq25oMG+fxUc2bFK
         cWZhN+7DDxt2L8DHgqKoO0+t7leCZKFYQsf/PSD1l8DgIFErQ1CP1SEi7h+3K91uUsma
         qnzw==
X-Forwarded-Encrypted: i=1; AJvYcCUJ3P20fQolrDG/SjyqUz3JdUsJAk2At8cVszqR4IHScdmfnFROYTpYxm0992TDGXrI1bjWqZlvRQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxGSaeizEP5bIQXUbkZK6nLOwq5RfmUk7Grm1i9xTRkqUWKEoPY
	fGe27lE75zrj6s/tqHfAOd4SEwLy/nWiZ8/GuDSoLXxaOdThMEANwVqU
X-Gm-Gg: ATEYQzyk54gRds2rRdsYjJfQC1Ry1yvy78AiddUFJFAtIhAQjjiZQHRFMU13xIbIZgW
	N84RJM6BT74CzN9oyxc8po8EvzLq5XxjGzdpzdCzIhxjozWZtEf8yadzBBmLI6QUvIPDCkurJZa
	J7llUNRZ0VJ8cync76x3J8t5EKvrBj69/tzqPNAYn1ChJRiC8vmyQA99H2NNB5nTrKY91kLPT/U
	zbEakbDalXNPMuevsK5Jkh3Uwz2/vjmd5A4tJ8RVELfbdzhsqlYOWE4HDpBIdMJcSUYcpJS9WhL
	lBOQQUMxHnPtXVL73KPB6JIJCd7VRpTD6CDL4eNXzmiUeLGZqLqPbozwAZPUCVSLoyu1oOh5tJ9
	b4rdCoQG/F21NTKycnwuhcq4qUSMiRPNKQH4Iyibm4+EvQFUBUz9p61N53A9k63G8DsyXyxzPRE
	Ya24delUVtZ1umTMElQQ==
X-Received: by 2002:a05:6a00:c95:b0:823:edd:20b9 with SMTP id d2e1a72fcca58-829a2fa9676mr175202b3a.61.1772757198859;
        Thu, 05 Mar 2026 16:33:18 -0800 (PST)
Received: from localhost ([2a03:2880:ff:5f::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8296c9f83f3sm6015571b3a.0.2026.03.05.16.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 16:33:18 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: hch@infradead.org,
	asml.silence@gmail.com,
	bernd@bsbernd.com,
	csander@purestorage.com,
	krisman@suse.de,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [PATCH v3 7/8] io_uring/kbuf: export io_ring_buffer_select()
Date: Thu,  5 Mar 2026 16:32:23 -0800
Message-ID: <20260306003224.3620942-8-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260306003224.3620942-1-joannelkoong@gmail.com>
References: <20260306003224.3620942-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 64BE5219D96
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12572-lists,io-uring=lfdr.de];
	TO_DN_NONE(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[infradead.org,gmail.com,bsbernd.com,purestorage.com,suse.de,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
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
index b258671099ec..89e1a80d9f5f 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -102,6 +102,10 @@ int io_uring_kmbuf_recycle(struct io_uring_cmd *cmd, unsigned int buf_group,
 
 bool io_uring_is_kmbuf_ring(struct io_uring_cmd *cmd, unsigned int buf_group,
 			    unsigned int issue_flags);
+
+struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
+				       struct io_buffer_list *bl,
+				       unsigned int issue_flags);
 #else
 static inline int
 io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
@@ -170,6 +174,16 @@ static inline bool io_uring_is_kmbuf_ring(struct io_uring_cmd *cmd,
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
index ef9be071ae4e..6b5f033ad8bb 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -230,9 +230,9 @@ static bool io_should_commit(struct io_kiocb *req, struct io_buffer_list *bl,
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
@@ -266,6 +266,7 @@ static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	}
 	return sel;
 }
+EXPORT_SYMBOL_GPL(io_ring_buffer_select);
 
 struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
 				  unsigned buf_group, unsigned int issue_flags)
-- 
2.47.3


