Return-Path: <io-uring+bounces-13950-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 6+tjFH4LUmoQLgMAu9opvQ
	(envelope-from <io-uring+bounces-13950-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:23:10 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A850774108F
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:23:09 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oUG1QddS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13950-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13950-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C61D0301946A
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 09:22:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 891EC38655A;
	Sat, 11 Jul 2026 09:22:54 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E629C388879
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 09:22:52 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783761774; cv=none; b=G931rVwq9SaddPa74adWMJOMrT0Ob/efdusIu3sREcc5T/JkucueJvj4gmimxoPRQ1E+xkrdIOd24/elZEIACzsaONdNE1dKE7YTHjsxnN5uZqTmLSbjUiSnssbMzdMmB1RCoN6SpZcI63CU3LCyr7AgpJJPP9dOp8Z5nd7slmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783761774; c=relaxed/simple;
	bh=mDM9Ligu7A+i1c5bQaZxxOVFQ0ClldFLx74pGEaA+oY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eaM72bsEheU/nFNgC3a/ril1mvU6MqNfyAMytZdfKx6hp5AIP21nukeFhvbd+/MH/hMg8TQxEfpk26SmsbvYsTGa1BKkB75ucNXYCGfMMcjyjzdjM9s3Rhvv7UIObPiHce3p+/aWm1nj8fI9X9LsfMrNW91KYIZJaNiYvtdrvRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oUG1QddS; arc=none smtp.client-ip=209.85.208.53
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-69c19a37eeaso3339744a12.2
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 02:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783761771; x=1784366571; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ndWdMIRoZiw7wrosi/rRhBvTDxisTiXVuV4qMbAvHHc=;
        b=oUG1QddSZxU2P/GoR7KtrYkA6/vz5MVJNA/7KUzR2GQsRWBwoOmH4SgeAcxy8BEz1n
         B4LYwmPKEGT9oJZEgcb2bijvA6TyXZaSQbI+i6FYR30lrAnTMvhlXABwE/BHnqe8N3ET
         16+wqOwSTPrvH++ucEzqoDbet/uZUp2QMSDyA9rZ1L1mi/UepvG57lhFDaV7s3CEwWin
         b81Hx3qhm/Eb3EyrqNUe8H5DibGUkUVBqy2rLyPuWCUKHKH9twSM2k7HoZ/T3JWzecI2
         kAdDHgqHjaq7ovXHCaJBq2WlWH7k9vm5N5o5RJnhLLYtpDH/KE/s9xsjbY91nN2gsm+V
         tUTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783761771; x=1784366571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ndWdMIRoZiw7wrosi/rRhBvTDxisTiXVuV4qMbAvHHc=;
        b=cF8GdCwtitNzyqwi4g1zsBqYIfwm4ygW5VRuVgBKbGYKjYI2WFA3+Ff9/2R6UNfVwZ
         Y5YFxf+6nzrTWFjhpvIZy9SGNOGU/RZ1gOTxV5iCy6oaEmcaJ21tjuRhavEO4Q0ptO7R
         TAcKbQG0qae39eo51zGe4vgEqmmeED8pAjyIzhj6ODYdLtDETFPgfb3Rr3IR44YgiQZ1
         JpzzASu9mK4sQDEfyQpWPAf9K5AaWDdt+yVa4Wh+D1fs5YSTdfk4Gb4m/ivZVRuYclEB
         rlI2CJtVnWjE3fpnYAjZSMX1Irdl3AJrXPvpD6ozzAI7JaaIpa3hHZQ89y11FYqO+ZxN
         0/PA==
X-Gm-Message-State: AOJu0YyMfCWavznS0MryHu0gguIvEtpoH5NN9k8FTEDzficBWTkdqtP6
	+OXaeYSBNlvwYOFA3Sm+D776ESLMA3vH16PquDP4qUmxq+LyQ0iQFrP0
X-Gm-Gg: AfdE7ckx4lY53g5WXNlUee0LEBJBAKGfaHKQOA5LzGpmCDEhrBl7mcMOvSlsSdNTRWq
	HSBwYe9la9N7dxEcj+RcC7WO+XCACWx1lo9mWM+bH0pcvh48PteCPnW9yfoRIreXYtXLlg6kPyx
	fG8rte/hM5p0z6Y/caOQPxVV8CSDhinH6UTK/xFU8FJ5SxLvv4811Vh8kOVD+b5EBlMYt0dTanO
	fZseHxppvZhf6QnOwq/qXe0cGq9lE2i9wr1mShAM3f5aAKL+iI64dPIvipbMB3SYU/2+FQ1y8lc
	U7KbD3zqGopmD/YNhNy037sxMByh9MC1V72VQlJ2TVMgKHX4b4klL6ibQn/+wRM6UyG6AcvrSnD
	au3MLzc0tJFqIrU/ZMOlyxIohcM1yWsUglpM9IFzglgsF8hbjf7YNRWjsEcxJiZaw0t/mPRbi54
	BFzLudNwZrzaRSeMubv4Lr7gGyb9eRsxN9lg824tCEuY4lBJEW5nBjoR9u68Idw31IODYKg0kC6
	lllEyKAPxXWBAX1f7ovSkCACYio3MdcLO+4sxBSw85mxKo=
X-Received: by 2002:a17:907:6d07:b0:c12:73fd:a6cd with SMTP id a640c23a62f3a-c161f35cd90mr79405366b.52.1783761771294;
        Sat, 11 Jul 2026 02:22:51 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-221-54.dab.02.net. [82.132.221.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15d3859f69sm517493566b.27.2026.07.11.02.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 02:22:50 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netdev@vger.kernel.org
Cc: io-uring@vger.kernel.org,
	asml.silence@gmail.com
Subject: [RFC 4/9] io_uring/zcrx: split frag handling loop
Date: Sat, 11 Jul 2026 10:22:14 +0100
Message-ID: <3a52d7adf84dcf6f3182c4a64e34cd186e3e729a.1783619193.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13950-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:davem@davemloft.net,m:edumazet@google.com,m:kuba@kernel.org,m:pabeni@redhat.com,m:horms@kernel.org,m:netdev@vger.kernel.org,m:io-uring@vger.kernel.org,m:asml.silence@gmail.com,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: A850774108F

A preparation patch splitting the frag array handling loop into two,
where first we skip frags below the requested offset. It makes further
changes more readable.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 816a169b848e..162e67287916 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -1877,23 +1877,29 @@ static int __zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 		const skb_frag_t *frag = &shi->frags[i];
 		unsigned frag_end = start + skb_frag_size(frag);
 
+		if (offset < frag_end)
+			break;
+		start = frag_end;
+	}
+
+	for (; i < shi->nr_frags; i++) {
+		const skb_frag_t *frag = &shi->frags[i];
+		unsigned frag_end = start + skb_frag_size(frag);
+		unsigned copy = min(frag_end - offset, len);
+		unsigned frag_off = offset - start;
+
 		if (WARN_ON(start > offset + len))
 			return -EFAULT;
+		start = frag_end;
 
-		if (offset < frag_end) {
-			unsigned copy = min(frag_end - offset, len);
-			unsigned frag_off = offset - start;
-
-			ret = io_zcrx_recv_frag(req, ifq, frag, frag_off, copy);
-			if (ret < 0)
-				goto out;
+		ret = io_zcrx_recv_frag(req, ifq, frag, frag_off, copy);
+		if (ret < 0)
+			goto out;
 
-			offset += ret;
-			len -= ret;
-			if (len == 0 || ret != copy)
-				goto out;
-		}
-		start = frag_end;
+		offset += ret;
+		len -= ret;
+		if (len == 0 || ret != copy)
+			goto out;
 	}
 
 	skb_walk_frags(skb, frag_iter) {
-- 
2.54.0


