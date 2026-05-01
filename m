Return-Path: <io-uring+bounces-13197-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WIvCIs4u9WknJQIAu9opvQ
	(envelope-from <io-uring+bounces-13197-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 02 May 2026 00:53:02 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 35D464B01A5
	for <lists+io-uring@lfdr.de>; Sat, 02 May 2026 00:53:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6CCD9301C171
	for <lists+io-uring@lfdr.de>; Fri,  1 May 2026 22:52:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 492CF37CD5F;
	Fri,  1 May 2026 22:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NEahbwYm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F25E378839
	for <io-uring@vger.kernel.org>; Fri,  1 May 2026 22:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777675977; cv=none; b=cneKe2a+exp+hBEcoERKb3t2xX3BBrGzvp5jnNb7/LHml13S5cVfdUOMPl96BNlAql+imuF4CB3wqzd7AverePvDhnscXG5alSLGmk5SvF/CAY8rZKiInaYPa9uPsXEsVQDhpm35zbFGZG4hJciI7L17ssflaidQcW3q/Vk59dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777675977; c=relaxed/simple;
	bh=KbPF2RtAp5GA4ixDDuFKfIoCxIwrgo/0CFOYS2TseVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OuNa5zG+wXzWTbgPHs/t9yyX5TczREk+vv0ai83/mUT8xdSLL9WJilzL8UphX55/J3ptheARrVm689MJTFMhWyqyPz94h4RLbDyVaxFrIv7BiWPN34sWvIMVmV7w3dkQhuywF8CZlxS8PgAHGJ/ou2gGevca7b/Lk/2CQz+PZ5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NEahbwYm; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-488ba840146so18943725e9.1
        for <io-uring@vger.kernel.org>; Fri, 01 May 2026 15:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777675974; x=1778280774; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u1w8ThLqZd25cwWjWBnDyIz33tp+IZal5hIPijMDDLM=;
        b=NEahbwYmHJxrj7a3G42T0LonHxglkL3Ifu6aShWdcOd+5uHT05oajQk154FGs9GHA6
         cH0Rkivwaz+wnenuuCCYti3rpBeEYy6MphelDSR3UNt7GQZaIofmxZzCaSXmOIPkS5bU
         18H2mPWsen1GZGGfUAsFGzUwL+xn/bSctd3PQWfanw0nVZF95XwTQNICG94YTj5o+QoB
         UR1BQRwn9coAbIgneYQ2xUs0qaIpn1OaGabj3Qt8LMfLIoayrtRSoPhRJqWW1veiimrO
         /ejTMFKpD0B/tA22+uF3kpmjp+7oDH4zuNI3dXMsxtjr95s/PCnbzoqg++uYslwSIdMP
         eJbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777675974; x=1778280774;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u1w8ThLqZd25cwWjWBnDyIz33tp+IZal5hIPijMDDLM=;
        b=UrXe+vA0sUgqOkyE0tqTwKEg4gtIMqJ+uO3VPTLgDgQNPVC1/6u6ABAH34vmzVj9/q
         FoyDtNHG2ZScjfbse886FvUEM5CcoUBC9O9LzVRL8R8gCECtS/NmIBaGBb3njqnPx26l
         9R6IR4K7dP72CnvjpafN5zG4oPM8gL3sUwTDXu9SgZocWhx2lTq2Y56ErkpPnrp351D8
         phGNrEH5R5fKbgYu/irvsNQlmETji8rfVKY/KOvBrIffYSNWjdUNm/EnCr8bpAd/CsJh
         DojT+eWOlgg0lde6st96+Iy1G+HKk3Fjw13gfFg4443uGeFsvVeC9oUPh/qQ2tuRHY74
         uweQ==
X-Forwarded-Encrypted: i=1; AFNElJ8Qy6r/W6zqmxsmrX74wj6bSfFYnEuWK8Wb2rcHKR9+l+fZlvbNymyaPCAguwKZ5euaf8pLZe8xEA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxjHRVWjnDRJmdU4isLAgPg1BEz2MVVoikzYVoIkTe8lEHWUvRN
	MQ5Ml5aOMmx9w5T3NVXVZBszbTbEhSSH/K9vDOtzBjDUEkn7g/I3uMeq
X-Gm-Gg: AeBDievXAj7Zbwk/bOToDVx7mJsgENbOTzsV78Q45SACVpQ5Qq/HlyaAI8YGutFhZvV
	oVLyo80QW7vs6ido31qdD8rheM64rG+zLn/SlLdGVcULJygUHx76PAFGvBrUMgxw6zzQnMOJyFe
	etQDSIPluVIV1xaib1+y6wCdJFXvsAk3Tk802DePR7ZggSLqrZzdMrY00vGAyRyGIPGh7/drjtQ
	k4ja9tIeygzvaGhWOeZ46RwMsAA5TeyGQidVzTQOEqeWeHLoSr+S2r8aZTgiZ0r49LrQSiQLFya
	g2Ge6ClKqkWeFtFo9iPEVBMtXAzEx9exz/+z2W51CDqAYIfbmliZs5k3V/LnbxFJwYywcNRXsE2
	S7W/oieyLKdHHGZ0/C1TNJfYWQsjdxBso1cXjvOy3AgBZ1aRZWRN3HUI0aaM7s/ac68kQ7PYUKF
	I86jjBPRvzKNBf+sc+qVaer0GuiqajZ/1PYSKWrVFqSI3Y355oiuhd9cZ3AQs2Qb7qqYcfXGs72
	Rpv+eo0pvsbiMU6dnFvxc3MeA==
X-Received: by 2002:a05:600c:621a:b0:488:bfc3:efc with SMTP id 5b1f17b1804b1-48a980fb94dmr14665835e9.0.1777675974024;
        Fri, 01 May 2026 15:52:54 -0700 (PDT)
Received: from localhost.localdomain ([77.124.36.154])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8fe93266sm23857045e9.3.2026.05.01.15.52.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 01 May 2026 15:52:53 -0700 (PDT)
From: Kai Aizen <kai.aizen.dev@gmail.com>
To: stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	axboe@kernel.dk,
	io-uring@vger.kernel.org
Subject: [PATCH 6.6.y] io_uring/poll: fix multishot recv missing EOF on wakeup race
Date: Sat,  2 May 2026 01:51:55 +0300
Message-ID: <20260501225250.90152-2-kai.aizen.dev@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260501225250.90152-1-kai.aizen.dev@gmail.com>
References: <20260501225250.90152-1-kai.aizen.dev@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 35D464B01A5
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-13197-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kaiaizendev@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:email]

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit a68ed2df72131447d131531a08fe4dfcf4fa4653 ]

When a socket send and shutdown() happen back-to-back, both fire
wake-ups before the receiver's task_work has a chance to run. The first
wake gets poll ownership (poll_refs=1), and the second bumps it to 2.
When io_poll_check_events() runs, it calls io_poll_issue() which does a
recv that reads the data and returns IOU_RETRY. The loop then drains all
accumulated refs (atomic_sub_return(2) -> 0) and exits, even though only
the first event was consumed. Since the shutdown is a persistent state
change, no further wakeups will happen, and the multishot recv can hang
forever.

Check specifically for HUP in the poll loop, and ensure that another
loop is done to check for status if more than a single poll activation
is pending. This ensures we don't lose the shutdown event.

Backport notes for linux-6.6.y:
  - In 6.6.y the do-while masks v in the while-condition itself
    (`atomic_sub_return(v & IO_POLL_REF_MASK, ...) & IO_POLL_REF_MASK`),
    so v can carry IO_POLL_RETRY_FLAG / IO_POLL_CANCEL_FLAG bits when
    we reach the multishot branch.  The HUP check therefore compares
    `(v & IO_POLL_REF_MASK) != 1` rather than the upstream
    `v != 1`, to avoid reacting to flag bits.
  - io_poll_issue takes `ts` (struct io_tw_state *) here.

CVE: CVE-2026-23473
Cc: stable@vger.kernel.org # 6.6.y
Fixes: dbc2564cfe0f ("io_uring: let fast poll support multishot")
Reported-by: Francis Brosseau <francis@malagauche.com>
Link: https://github.com/axboe/liburing/issues/1549
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[backport for linux-6.6.y, verified 2026-05-01]
---
 io_uring/poll.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -321,7 +321,13 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			}
 		} else {
-			int ret = io_poll_issue(req, ts);
+			int ret;
+
+			/* multiple refs and HUP, ensure we loop once more */
+			if ((req->cqe.res & (POLLHUP | POLLRDHUP)) &&
+			    (v & IO_POLL_REF_MASK) != 1)
+				v--;
+			ret = io_poll_issue(req, ts);
 			if (ret == IOU_STOP_MULTISHOT)
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			else if (ret == IOU_REQUEUE)
--
2.43.0


