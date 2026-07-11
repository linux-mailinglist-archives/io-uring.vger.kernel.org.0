Return-Path: <io-uring+bounces-13949-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 6bVSK/0LUmofLgMAu9opvQ
	(envelope-from <io-uring+bounces-13949-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:25:17 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 00DFA7410C4
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:25:16 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W2dtQqRj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13949-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13949-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1BEE4304502A
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 09:22:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0D6F388E4B;
	Sat, 11 Jul 2026 09:22:52 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4703388E51
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 09:22:49 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783761772; cv=none; b=gStCVeGtobCxNJTCuuE8/a6ANZ7mUkw5inXF6iBNhDyLK7k83GF+GH3E/WWAAeup7mr+LXcquX0BftIO4qOLfd5l/6ciHvTZMo9ypF04mXki9Jr+y097tPCgCBRd+j1LrmddsbMbn6hgqCZrRXMSDgsySS7pPC21qH+iwtf7+Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783761772; c=relaxed/simple;
	bh=1ZDKUtGQ/a8BS68raZRoNcVAxiVUqlOQWmMvMBshBKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TvUnxq8T917M6nCAehE4sX6AldGx1qyCPgGrij1dSziZP327qQzpFyR3uaH62AuHFpHRjqTo+g7/BnJr4m5BsU0QtiMXpFV1xc2/2Mzf1WOnrzds7/wx7EL/SOcvnGNSD9nWaIwSRTPvSFd8Njrzde9nv78tPemyJ2DV1quqo/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W2dtQqRj; arc=none smtp.client-ip=209.85.218.48
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c15c257a488so245603566b.3
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 02:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783761768; x=1784366568; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T98o7Pl7lA+wpHQm5Sj3XRNCCZO6SwAqa5AzQEn9zdo=;
        b=W2dtQqRjx3L/A/DKWmnWU6w0kVY0VaBD5LxLlcWpuWbVBHWLeW82RDzbWgv1jb+wse
         vjHvG9avFZcOTS41oezsFO4Iaa8icQ1tsurGuN8jU4C4Z9aov0GHVGHL6XadoeQuJrW0
         xfhfoAqkrL4CK6V3wEIOz+78wx+wYJCPLkEQBLM5WoSv0hp/1bPViS3Cq+3eVUhdNUnP
         kayOU3sonxU8jR32xSqL1jmzyQjT1B8ITGPawg4WwBo9zYNOewxpF/tMdH5LGkFpSXBP
         b5DnL0x5SJjXrsLeocyAwOMwDYoPywM1PqzD/2xDeS2SVT2tEJl7pg2QLkfkFfo6ygne
         7G3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783761768; x=1784366568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=T98o7Pl7lA+wpHQm5Sj3XRNCCZO6SwAqa5AzQEn9zdo=;
        b=UKNRJmnafLuoyCXD4sbkR+FLX6HC33Noub6G3zvMhzxAEK4rmpSJQkKWambPV1Ej2M
         uBEoF/AscBgcvl8yDcL7xQEHLT8VPImLxoLPDDcWSnrIrvq+e3S3WjpBaOVGp9JJy526
         89skQZqu+yh02Lc+O/S9RiJPFBfe81ErBQm8YvtAk0w4bvhFtwOdMhGZSE9u1i3sixsH
         LwJjmvkLTiTb5WbT9ZwTJK4cUi13W2tmqpG5B5YSGkngfXEupl2viFb9MASN0oQwUlZ6
         d/2ZHrmVJeh4EEc2BnGZIPRXbjRSm7st4yR4AapsbVeHxrBjl0ksVrV4x/2oaZKmdbkm
         0XKA==
X-Gm-Message-State: AOJu0YxSvYRdCVnp1pPrZGj4GHSnduMDc8DmGUEs8NV7tMPMF6fcVoph
	9RMIX8PVySTUMER5O4I6vZpFtGFm8hM1gJY/WGdfa53r4sotL6TQPcJszPfTxg==
X-Gm-Gg: AfdE7ckJoYv+sIlfXiRWaoNxMG52dbWy24s46h081N4DceGLUASpxc38cGSQlZZClDR
	5BTyK6QF1P1Oql47lHMiMFt6QVzKHiCYFPwvWBUw/bQjU6h2PqopSyVqigFf8OfqLhw6aT6y/f9
	RTf/0N4xkZy/XEhVozVR1T3QynKgrtOzAHOqlfL8/pzL1hn0uo5czvthoC0at86ZFpmX38dNkcD
	1OpGMRfrfk7pqNqkIdB72Dr2sclBXtAxNKIB4ocgxmnOH8+zHl7SdihQPdBL2TQ81YrYjKhTW6q
	/0VplALG6c7GEeEVmDr7B7nEbA1riEslqhVwEzQvObMmxBpJF07vfY4W0aofhSAFBlK8kx0hz3h
	hDauirI1AB8ngtToGPoleE4yrThCbHalKYRjeqga5XNAZHgNltmKO8N9VIHlpRPmFgwStTP0LeC
	u6mAyKbqTc6ofPhQUpgHDE+Jw6mQ+Hh2pr8j7rZOnu1zYJFy9mWvP97BzxJiAGshBAkL/3eGHMX
	PHVVs+AYyOZzEtPOl8xaztaDRhLg9Hz3ceu1nYIm4HV/fY=
X-Received: by 2002:a17:906:c10d:b0:c15:e9aa:f711 with SMTP id a640c23a62f3a-c161e8b2300mr76157666b.14.1783761768105;
        Sat, 11 Jul 2026 02:22:48 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-221-54.dab.02.net. [82.132.221.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15d3859f69sm517493566b.27.2026.07.11.02.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 02:22:47 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netdev@vger.kernel.org
Cc: io-uring@vger.kernel.org,
	asml.silence@gmail.com
Subject: [RFC 3/9] io_uring/zcrx: don't save/restore count for frag skbs
Date: Sat, 11 Jul 2026 10:22:13 +0100
Message-ID: <1279bf7c6c379945e57dce4d7366c1764a3fb938.1783619193.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1783619193.git.asml.silence@gmail.com>
References: <cover.1783619193.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13949-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:davem@davemloft.net,m:edumazet@google.com,m:kuba@kernel.org,m:pabeni@redhat.com,m:horms@kernel.org,m:netdev@vger.kernel.org,m:io-uring@vger.kernel.org,m:asml.silence@gmail.com,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 00DFA7410C4

We save and restore desc->count before recursing for frag skb
processing. Extract the handling into a separate function instead and
pass a flag.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 0aa6455971d6..816a169b848e 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -1827,9 +1827,8 @@ static int io_zcrx_recv_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 	return len;
 }
 
-static int
-io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
-		 unsigned int offset, size_t len)
+static int __zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
+			   unsigned int offset, size_t len)
 {
 	struct io_zcrx_args *args = desc->arg.data;
 	struct io_zcrx_ifq *ifq = args->ifq;
@@ -1907,11 +1906,8 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 		if (offset < frag_end) {
 			unsigned copy = min(frag_end - offset, len);
 			unsigned frag_off = offset - start;
-			size_t count;
 
-			count = desc->count;
-			ret = io_zcrx_recv_skb(desc, frag_iter, frag_off, copy);
-			desc->count = count;
+			ret = __zcrx_recv_skb(desc, frag_iter, frag_off, copy);
 			if (ret < 0)
 				goto out;
 
@@ -1926,10 +1922,20 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 out:
 	if (offset == start_off)
 		return ret;
-	desc->count -= (offset - start_off);
 	return offset - start_off;
 }
 
+static
+int io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
+			unsigned int offset, size_t len)
+{
+	int ret;
+
+	ret = __zcrx_recv_skb(desc, skb, offset, len);
+	desc->count -= max(0, ret);
+	return ret;
+}
+
 static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 				struct sock *sk, int flags,
 				unsigned issue_flags, unsigned int *outlen)
-- 
2.54.0


