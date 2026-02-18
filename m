Return-Path: <io-uring+bounces-12316-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oJPiKtP4lWlMXgIAu9opvQ
	(envelope-from <io-uring+bounces-12316-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 18:37:23 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 318F21585BD
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 18:37:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D4240301C903
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 17:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B95E2345750;
	Wed, 18 Feb 2026 17:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fPfvwdiW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40ECE343D8A
	for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 17:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771436207; cv=none; b=GacGTlAm/JR+jlvE0NkfaIGev8MGdggMQ3tTQlnNZXzk8+Q32Vl0spLa4UcR5udKH24in8uV8F1JKS/ic4ymOwwSRtt1KWo+Z+Lim9TZ7AxDBMSKZBVmQCleQsdKt4qrAbpvR6X/gJLETaejdYtFiGFIsvbLTLmQoL+S9IXKhRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771436207; c=relaxed/simple;
	bh=ryk1XlFpYkbWCCRIEYCdmMdH4Bm5ivPc/TwrajVtluw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KpMHBveTOY/K0iaW5HUb9u8rqTcxg9mcu6LVkiok4tarrTfP7J7Qgf41dW9M7NoYtgUGMSuTvJQ2njVnTmOMnCyVqgTqyVE1iWrBl4dy+dCqiwwLKq5fETpvRITzQTxXkcNVe/+LK04Q1F0zm41exqrd89nJvYHQbWZ8hfBP3vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fPfvwdiW; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-480706554beso948635e9.1
        for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 09:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771436204; x=1772041004; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=opGeJXdqBNHSNGuTpufEOdqG+49HpE5DgTtWk7Ja0tg=;
        b=fPfvwdiWDb4Z/WTrRpEyjGKWx0uF+c3WWRdZpfUgGpmGf/wkqSJQDTsZfLyUtPb8bR
         3j/uHqLognwuuARMvQKskx8S54cNDCrd9ueIKDN9vt8wb9SZdGdXR7oSoAbxaLMTjn8M
         wyTG6ibzHAQZNvaMN9zgUG1+h0oLkSFuF13NONi6yvCohPCC1NUIsTIDL6dpklApzzxh
         99gjgu2i88SLjrIjNZCndX4iVqVBUcR8kMfPRBjin5emSni5dfRSi8JaVBvepj+BeksG
         +Yb0AUnaTtWu4svK6bkYXSMZER1LQU1gy5XI2j01f2/eP09DSQo9/YJ0g0kRstVAw0m4
         XGQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771436204; x=1772041004;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=opGeJXdqBNHSNGuTpufEOdqG+49HpE5DgTtWk7Ja0tg=;
        b=b/i+q6g7AIE+BxQ3yql0EloeWmhe8wClVqCkNlNdA4GpXxOEGV4C7cYI0+86QZimWf
         n4iq+HphZd/mtTzoOvAJseHDh7chIn2vOJS2jaB18NvrEPZJA+n5whOsYRTktuOw1tv2
         aROD72dAwrfyPyqxMDmrH4ibiDuAgBRJVv18iSMqQmquwp+gDaN81zJPtZ2p9uliqOdJ
         IrZMIQQWWQPfr+W1YjpsdEzMUJ5kZs+bSg3CQ+AyDoE1RXG9K68ogKnuEQ1XjHyqTrKn
         HYYIpAQY4b5oFEAANPgtNOD7tdSxjHcIe4NWUAshNTr4QEwI/zLuPuTeYog+tF4liOyv
         6CMw==
X-Gm-Message-State: AOJu0Yz44sLA4D+VZ7t8RZWm8nsp6iFibyVmgc+04PaJoIZFAeu0bXz6
	Z/COk7k2hQcCNvxmwK7+nO17tBJA7ZYcNvBQJoEfsEv1lapiqpwfevWSWOvQTpgN
X-Gm-Gg: AZuq6aI9WScNDgT3PMaY3oS4szziSdh47ZtvTxdMXMeQdKzJjtxfuC2RdQvQNy0TL9p
	PveXBgYJYbyeWRpDw0KZ1EtkUbgck11KnGmUTgT5C6zEtXGRcAhxgGNpW3d73M4UgCQ+KLCPbFk
	oetuku/vNwizVaqVE46SSspoa/PLidKZTjT/WYr1ust4aifr8eSH4vT6/B4ubj+ItBIRf+NztIP
	zvF0qeKP1URTbu2VRdSK2FjkBpQ5/v8pSVAd2FHV8y/L78U7GH4/Ujod1Z9k0Ls+kE8EvBWMx6j
	Wt1cA3dd4CM46HChhwW/g1XLwzS5QV0qnAK5QIe9NQ514Tc4CEiVEkwDC8pgTJmf5uSR5HgfCgN
	hKQnAPNKCrT9BtHsTsKKGEWWhDkUXUyjhbOVxLrn3klBZUiLDWyLPeG+1YRH10cwj5Fa/0gS2vZ
	uChHYmFF4UfyEP6Wl5sSHTstfNkJhNWCQfoaJUpNMmUYmMsm3mqygb5ehzHUlPunuaS7cHCTxmb
	oDzP+dEn1yws6yV59M7Ptl3a5mKg1TmmSkfxoIf
X-Received: by 2002:a05:600c:5308:b0:47e:e946:3a72 with SMTP id 5b1f17b1804b1-48379bf78f1mr246397705e9.27.1771436204063;
        Wed, 18 Feb 2026 09:36:44 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4835d99e194sm464119405e9.8.2026.02.18.09.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 09:36:43 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org,
	Kai Aizen <kai@snailsploit.com>
Subject: [PATCH 1/1] io_uring/zcrx: fix user_ref race between scrub and refill paths
Date: Wed, 18 Feb 2026 17:36:41 +0000
Message-ID: <364c2e7d4f53b26bb3133cfc4271183fcd450be2.1771435883.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org,snailsploit.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12316-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,snailsploit.com:email]
X-Rspamd-Queue-Id: 318F21585BD
X-Rspamd-Action: no action

From: Kai Aizen <kai@snailsploit.com>

The io_zcrx_put_niov_uref() function uses a non-atomic
check-then-decrement pattern (atomic_read followed by separate
atomic_dec) to manipulate user_refs. This is serialized against other
callers by rq_lock, but io_zcrx_scrub() modifies the same counter with
atomic_xchg() WITHOUT holding rq_lock.

On SMP systems, the following race exists:

  CPU0 (refill, holds rq_lock)          CPU1 (scrub, no rq_lock)
  put_niov_uref:
    atomic_read(uref) - 1
    // window opens
                                        atomic_xchg(uref, 0) - 1
                                        return_niov_freelist(niov) [PUSH #1]
    // window closes
    atomic_dec(uref) - wraps to -1
    returns true
    return_niov(niov)
    return_niov_freelist(niov)           [PUSH #2: DOUBLE-FREE]

The same niov is pushed to the freelist twice, causing free_count to
exceed nr_iovs. Subsequent freelist pushes then perform an out-of-bounds
write (a u32 value) past the kvmalloc'd freelist array into the adjacent
slab object.

Fix this by replacing the non-atomic read-then-dec in
io_zcrx_put_niov_uref() with an atomic_try_cmpxchg loop that atomically
tests and decrements user_refs. This makes the operation safe against
concurrent atomic_xchg from scrub without requiring scrub to acquire
rq_lock.

Fixes: 34a3e60821ab ("io_uring/zcrx: implement zerocopy receive pp memory provider")
Cc: stable@vger.kernel.org
Signed-off-by: Kai Aizen <kai@snailsploit.com>
[pavel: removed a warning and a comment]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 3d377523ff7e..0c9bf540b12b 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -341,10 +341,14 @@ static inline atomic_t *io_get_user_counter(struct net_iov *niov)
 static bool io_zcrx_put_niov_uref(struct net_iov *niov)
 {
 	atomic_t *uref = io_get_user_counter(niov);
+	int old;
+
+	old = atomic_read(uref);
+	do {
+		if (unlikely(old == 0))
+			return false;
+	} while (!atomic_try_cmpxchg(uref, &old, old - 1));
 
-	if (unlikely(!atomic_read(uref)))
-		return false;
-	atomic_dec(uref);
 	return true;
 }
 
-- 
2.52.0


