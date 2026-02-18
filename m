Return-Path: <io-uring+bounces-12308-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iNZ9BXgqlWm2MQIAu9opvQ
	(envelope-from <io-uring+bounces-12308-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 03:56:56 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8097B152C38
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 03:56:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DD44E303E74B
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 02:56:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A6532DB794;
	Wed, 18 Feb 2026 02:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ABWbL8mf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4982D46A9
	for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 02:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771383410; cv=none; b=ILk5XJxC0HpJC9fAnIDt1+hjIhSgIFHPS4kB7HX+XKlgzy98EgZlPf90g0zwNm6UrQduutpbsrP2yg5Gk6yIXx0C87Dlx5p5Fjf56IO6n+GXDzmdaCaDBieOhlB6f14KV3k6iDZFT+d78+Yp/cqIUW0fIChqI4u1KNZc7TIGWL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771383410; c=relaxed/simple;
	bh=u77Fv23vVgUh2i0EV1Xo+zAYC2HuNe2GXcQKR0jPD7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPlXOFR8DtUDB4bSoCyH7hpkLCICBKc1mN/s7c6ZOzSTPXIyyPibYj+y9lWMJUZrRu84+W+I9v8IlmJfnYcivCTgwfRuYuXCtE9KMp6tnNjweQqzGY3XbCoqTtfRZW32plqqUQplKhSUaHbMg23sVuN2NmVvq/yYErFT03sjFGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ABWbL8mf; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-824c9da9928so2238407b3a.3
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 18:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771383408; x=1771988208; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V7wjxq/eNP+NdtPDJj2E/dekKXzCsqNWnav9v+Kzgms=;
        b=ABWbL8mfscZT401LikERetzowfkRiDOOkjK2txiR3UqC6M1vXJ/VsZGCD8fSdfc+kt
         yCIcu/RCSj1C6dEx79muLv/yB+ix22FqPP4wtaqOySdxO2gtwybIe+7/PBfuHn910NEZ
         Kbqi6i5mUeiQU86w4bBQQj2Di6G2wwdt3xoVZykcuu+UCM2LA/mMFIhR7XoEPjmEXEx0
         AEvJ4CCVDGQHPtgT3kUYmvC9/0fEIhgESkvILe946BKBGxuX9cS45lMQaa8Lfn7P5mid
         4lKeNUB16aHDSsogB17ySCHlbKey5wxmTcMlfDYrxDJbgSUzF5dI9f1EOSL0cokO/y1t
         iX+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771383408; x=1771988208;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V7wjxq/eNP+NdtPDJj2E/dekKXzCsqNWnav9v+Kzgms=;
        b=Hy1pjCGo41wllFEKT1xgK9u8gMOQPiiECN+J8l0HJFKecF5nRQV4kqaFc2TRakhGPk
         IZoTWoHHvHIzYwu7oLY+/NWse7eEeTaUYyYOz/A6kdqRZxrOczeM4MwAfh2ONCMkPjR1
         aX29HJ1bPVyEnll82LXMGuJ07Eeq97yVDL0rqmM08xaYIWcP0FGDY/REvJpr8tr5ROyT
         AA9KKjiA2FpAyFJgXiNmR/uZ+WLnM0QGP65574qXjaD10uRQ5GW+2BZAo5WmNb+LyWPe
         aNdF52fPq7wf2cMg17ie1iArDcXKkYIBddoFVeM+KFXqNoPxVjMTZsLvxnzrZgzcbUv3
         6g+A==
X-Forwarded-Encrypted: i=1; AJvYcCXEbOrwqdT9l8YS51UwSsqnjCP10jnJqqdQWWYuRXoW0rO7z14Vir7XClR5IKZOTaYPq/dLZ+YowQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxBqKTBH/qdM9Jku50Kgtkh7Dfslxcmu2WvCxuhG3LbtR15UOYZ
	AXo5U7tnGlQzjGggFFaQTn421SB0f4eZA24Sq3Vx+HWPq/kwQJSVgGRZ
X-Gm-Gg: AZuq6aJhwAx4pBPmblN75U2kNIOyBbpSAUvdnyH/bAA7dXaG4RXz0iKOJEFAwyFgxQC
	bkhePx4GD+yWeYaoCqVbMbBi8741lduykXP6Pc5MdG19Rw8i8ZnH3mRMYke6nGVXtSTZGkeKpz9
	DrHEyLTUGe+fIZuHxSdkHwjXgq41y92P+ztDnW99aiGlivtgSh9KoGjKn8H6dvDJx/befQ2gPUf
	LWMSRBYJinV+iFn6Jb9R343ji3NXRl0L/ExYnSuQQFH+SxhsKHGQL0wpqZL5dywZgqHRycHcJO8
	YsEls49/+kU4tx2M8+QSPB1hg6OH06ejA4qjLI82jBXBzdKZ84khb2Kl91TrROOebr093eRYwFL
	szPVoq/NeMmplyZxEX1ZsRDfkfjy0rdR2dLsjUWKLHshJXWAMqWX6GHNeBABUD9GX2FicbC3VGP
	MFQuaSbjqoz8oxXadpx4rrBrllh6VR
X-Received: by 2002:a05:6a00:1742:b0:81f:9986:9205 with SMTP id d2e1a72fcca58-825275e6a2fmr621094b3a.57.1771383408408;
        Tue, 17 Feb 2026 18:56:48 -0800 (PST)
Received: from localhost ([2a03:2880:ff:22::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824c6bb55adsm14705927b3a.62.2026.02.17.18.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 18:56:48 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	bernd@bsbernd.com,
	hch@infradead.org,
	asml.silence@gmail.com
Subject: [PATCH v2 8/9] io_uring/kbuf: export io_ring_buffer_select()
Date: Tue, 17 Feb 2026 18:52:06 -0800
Message-ID: <20260218025207.1425553-9-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260218025207.1425553-1-joannelkoong@gmail.com>
References: <20260218025207.1425553-1-joannelkoong@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[purestorage.com,bsbernd.com,infradead.org,gmail.com];
	FREEMAIL_FROM(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12308-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_NONE(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8097B152C38
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
index dce6a0ce8538..ac8925fa81f6 100644
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
index bd10c830cd30..fcc64e4a6a29 100644
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


