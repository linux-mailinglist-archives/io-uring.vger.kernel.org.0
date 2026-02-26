Return-Path: <io-uring+bounces-12444-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gH7VNUXDoGmEmQQAu9opvQ
	(envelope-from <io-uring+bounces-12444-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 23:03:49 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AEB21B0271
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 23:03:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id ABFDC303E4B8
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 22:03:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79C753AE6F4;
	Thu, 26 Feb 2026 22:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=p2p.industries header.i=@p2p.industries header.b="G8YU9yg+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3152530F93C
	for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 22:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772143427; cv=none; b=TeRaFEuEJwTIFcZDTuWi9dqhEgAh2jWz5LRUHzAVls3kJVDSGwOpIXEhdgiwhyH14nfQxv9Z8Q98leQ6Ej3eQsz6PsEDp5mGyqJRyDBjqPYqpWqNgcmt4jme/BbdcRIVSGBf2FuoSmyGJ+haGGZOVPrwfyktGBc/TNS1oQx6WWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772143427; c=relaxed/simple;
	bh=CZRe1iUMVr9qEn5m2f/i37y/YNNPSFYQrbyg6aoEQlk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RZC0U19z2jHmpsM4JnBKYSUgsyycohZ3vX/KHSnrxQ87LViqztxkRWwlboS+ol6sdM5/UQElTz2UaYJ9+SGsySlRoLE/EcKb9NrHbETldfMuV4Q6cqncbQqu4FUytzfpAtOIejTwz4wUaZM9qfYib9LO+eTdkJzK9+Qm4ZJCMSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=p2p.industries; spf=pass smtp.mailfrom=p2p.industries; dkim=pass (2048-bit key) header.d=p2p.industries header.i=@p2p.industries header.b=G8YU9yg+; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=p2p.industries
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=p2p.industries
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-48379a42f76so10654055e9.0
        for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 14:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=p2p.industries; s=google; t=1772143423; x=1772748223; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0wS4lSteamMcGZXwonWy8V0zK3HIHohZFVD96e3qpm0=;
        b=G8YU9yg+iENfTlWHXChHtzGtpmiHiNfRjFfo/5xk+vnAx5sLfmY+b9vyPiJpKVHcI9
         gZ9rxlQtk6+pNteREvwz510PpPFvG5IcJxzlfb17/7kDhnrqy/F2rcQ6AktERid1mb10
         HrpQj61dDdR20DUX4r0COsaz/qCD5weahUg345N6Vf1jaCNXVAQfb3/Iek9ZfC1rPpff
         dtr/haLGqxqEYoj1pa0RpSlR6v68KJLanMnnJEfpgzYFAZkSiizA0D3RAqBiF0bCH/2T
         2/IRj7wg4e40PZiV3zNLl2gMScFrIhiFp9E8oGaF+9DhRQSOcVX6fhxIQQBn+3NJRSEx
         0ilw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772143423; x=1772748223;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0wS4lSteamMcGZXwonWy8V0zK3HIHohZFVD96e3qpm0=;
        b=aKkEw0GSlSBOYwnn0H5geQWw4NR/4IhaVfSd3HVU6olYOi0r9l8SnyEfaWW2+QgfAu
         ZbCEht1AsU8xI/cziBTc3YfdG/3NwHHmuOJr8VAle+FGremFa9tx3ZwBJJyirMGFn6pS
         H7akRUPS9+XKEt+xe8fSuuiH8Qg7B7dqZ7awp8wMstHgL7AxQPBq8dH3nZNzxBpWggHQ
         1tJhDG4WJhWkqf38OgfkmLu2Q5w1qTT32VIZooqGkaHYu9504pD3HS1nBdoGPZnXZE/f
         +Tmsqzah5598hVfswT4x1sdZ3Abckr6ZL+96QgksFn1Iq+yGK7zGSmMDohPaNzFD/4qQ
         4jcg==
X-Gm-Message-State: AOJu0YwzqITMX5QB8o53fe7A73teI7aLN9K6Pum7TKQ0CEKbUpMms8PF
	wIbIAkdqCU+jAgstgSflgQCWYeqiWxcKHolXp2vl6n9zM0vMfcDMRmm6mRBMdelXveQ=
X-Gm-Gg: ATEYQzwTPE8ouhPfX/Q2V4ZSDZqvMkugBaGuB6Zss6NUgKkMcDiCYKNV+bLUiPZKArf
	x3b7DsV6VIJieIJGN/mNHSi8+bxT/9FH89A9OpLt3TBb6w7kgxRFka0QARkT6fUdvKOsdR6RNjt
	UAuWLvEPbJZQKsisOKiDXpS2Hgqp6VE2pkTkrlIh+Shh1Ffq4/kOoOvjfpK/8PAhAtzqHY6W4Lo
	lZ2ISdZ6jqYP6MXbsXm8FDScx/xBU7MJCyyog4s/JIaXqHZbHtNMTtT19L+ZPKeU/vrweATAmKH
	v7czTs17UlMeHOx6016A31aASCNB0IuVxWi46TK+L7M3xBpiOsl4ImQSw5za1nhVmuBISoA+xC3
	twUOmQOxjyhtf083DVLS7G8Wkn3sUE9VUU6kXFq7ucv8JvWF9bQG1SP3D2NdNhRBp001HdAYuV6
	vpFv3LMYk8CFs3
X-Received: by 2002:a05:600c:828c:b0:482:dbd7:a1c1 with SMTP id 5b1f17b1804b1-483c9c23c72mr5227085e9.34.1772143423478;
        Thu, 26 Feb 2026 14:03:43 -0800 (PST)
Received: from nixos ([2a02:168:646f:0:cfbc:1fa2:92d:8540])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bd750607sm171813145e9.10.2026.02.26.14.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 14:03:43 -0800 (PST)
From: Hannes Furmans <hannes@p2p.industries>
X-Google-Original-From: Hannes Furmans <hannes@stillwind.ai>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Hannes Furmans <hannes@stillwind.ai>
Subject: [PATCH] io_uring/net: don't fail linked ops when done_io > 0
Date: Thu, 26 Feb 2026 23:03:10 +0100
Message-ID: <20260226220310.758404-1-hannes@stillwind.ai>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[p2p.industries,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[p2p.industries:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12444-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[p2p.industries:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FROM_NEQ_ENVFROM(0.00)[hannes@p2p.industries,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,p2p.industries:dkim]
X-Rspamd-Queue-Id: 9AEB21B0271
X-Rspamd-Action: no action

When io_uring recv/send with MSG_WAITALL accumulates partial data
through done_io and then encounters an error or EOF, req_set_fail()
sets REQ_F_FAIL despite the CQE result being positive (done_io bytes).
io_disarm_next() then sees REQ_F_FAIL and cancels all linked operations
with -ECANCELED, even though the user-visible result indicates success.

This manifests in two code paths:

1) Direct completion: io_recv/io_send fall through to req_set_fail()
   when ret < min_ret, even if done_io > 0. The CQE shows done_io
   (positive) but REQ_F_FAIL severs the link chain.

2) io-wq fallback: after APOLL_MAX_RETRY (128) poll retries, the
   request moves to io-wq. io_recv returns IOU_RETRY from the
   MSG_WAITALL retry path, io-wq fails the request with -EAGAIN, and
   io_req_defer_failed -> io_sendrecv_fail overwrites cqe.res with
   done_io but leaves REQ_F_FAIL set.

Fix this by:
- Not calling req_set_fail() when done_io > 0 in io_recv, io_recvmsg,
  io_send, io_sendmsg, io_send_zc, io_sendmsg_zc
- Clearing REQ_F_FAIL in io_sendrecv_fail() when done_io > 0

This makes MSG_WAITALL partial completions consistent with
non-MSG_WAITALL behavior, where positive results never sever the
IO_LINK chain.

Reproducer: MSG_WAITALL recv via IO_LINK -> write on a UNIX socketpair
where the sender closes after partial data. The recv CQE shows positive
bytes but the linked write gets -ECANCELED.

Fixes: 0031275d119e ("io_uring: call req_set_fail_links() on short send[msg]()/recv[msg]() with MSG_WAITALL")
Cc: stable@vger.kernel.org
Signed-off-by: Hannes Furmans <hannes@stillwind.ai>
---
 io_uring/net.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 8576c6cb2236..ebe51db34af8 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -576,7 +576,8 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
-		req_set_fail(req);
+		if (!sr->done_io)
+			req_set_fail(req);
 	}
 	io_req_msg_cleanup(req, issue_flags);
 	if (ret >= 0)
@@ -688,7 +689,8 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
-		req_set_fail(req);
+		if (!sr->done_io)
+			req_set_fail(req);
 	}
 	if (ret >= 0)
 		ret += sr->done_io;
@@ -1074,7 +1076,8 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
-		req_set_fail(req);
+		if (!sr->done_io)
+			req_set_fail(req);
 	} else if ((flags & MSG_WAITALL) && (kmsg->msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
 		req_set_fail(req);
 	}
@@ -1220,7 +1223,8 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
-		req_set_fail(req);
+		if (!sr->done_io)
+			req_set_fail(req);
 	} else if ((flags & MSG_WAITALL) && (kmsg->msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
 out_free:
 		req_set_fail(req);
@@ -1498,7 +1502,8 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
-		req_set_fail(req);
+		if (!zc->done_io)
+			req_set_fail(req);
 	}
 
 	if (ret >= 0)
@@ -1570,7 +1575,8 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
-		req_set_fail(req);
+		if (!sr->done_io)
+			req_set_fail(req);
 	}
 
 	if (ret >= 0)
@@ -1595,8 +1601,10 @@ void io_sendrecv_fail(struct io_kiocb *req)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
-	if (sr->done_io)
+	if (sr->done_io) {
 		req->cqe.res = sr->done_io;
+		req->flags &= ~REQ_F_FAIL;
+	}
 
 	if ((req->flags & REQ_F_NEED_CLEANUP) &&
 	    (req->opcode == IORING_OP_SEND_ZC || req->opcode == IORING_OP_SENDMSG_ZC))
-- 
2.53.0


