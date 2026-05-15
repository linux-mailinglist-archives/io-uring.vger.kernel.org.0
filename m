Return-Path: <io-uring+bounces-13350-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kIoUDRMrB2oLsgIAu9opvQ
	(envelope-from <io-uring+bounces-13350-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 16:17:55 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 64A5055137B
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 16:17:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 91AF930381B6
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 13:59:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39C923D1AAA;
	Fri, 15 May 2026 13:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="teHeFy7W"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D1130B533
	for <io-uring@vger.kernel.org>; Fri, 15 May 2026 13:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778853552; cv=none; b=GzGDWR7kKAxfkAtFWOF8zbt7LrFI4z9mhEgBo1x5g3VD2nOa6CpYpa1bZ0hfOFJ+x7BsBZ9clNkSv1nRNqzDGPx3a5/x2IDBhDFWA988fuhkWdI48Q2nowIwxICANlJYZ40q+21LNVahS/c+Vwr4NWg1yHE61zGCSxMod+//Jsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778853552; c=relaxed/simple;
	bh=tVZj1+966VqX+wAXgGFS+7w3EvvAUDuCPHW8H14LHLo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZP3+wcWyEWoiLrQQIkH0TF1ZMHDs6andP5yjR5JDPOmQNhTN6I1iW5MmfIHcSyPgI3os6jNIvUqOucyD5Ok4Uy/JYk+lGeX3zWCvnIc4gwNLtx3nNddzKz+N7Rs+LPR004ZEVAPhp8JfMqcfPzJINlco5KJhi0DRPHbhHEIJro8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=teHeFy7W; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8b3d6b215cfso136940606d6.3
        for <io-uring@vger.kernel.org>; Fri, 15 May 2026 06:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1778853549; x=1779458349; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uHdVr+Knu51ewWGCsREiTmFjxqZ/k2tepG9i/Vxx7HE=;
        b=teHeFy7W8y/lbW24oml6pKJ5BHeKsCsWZ3PDqzpckir9H8b23T2p/DN67HXL3q7pg8
         4aJZ6xFKhnWN9kndBfFry8uKmZRZw8WETF9JpckSyE7N/f44xg5blg/dP5isuJO3R25n
         KviXn7Y7Vf7Cktn1LI272gsNpg0iCV6e6DSR7wZR22f1jjxGu15vEFBnqA90AFK1hGsS
         fTfTbYSdEsJ1piFcdBNXZB0YTfQb3EW4fc/WIl43ihxwlkQqrRtYVwu3yUbvbeSeQ04/
         lShZvjviQEwwyMtLBgx9iTpNioAaJtOcWt1URmC1bdhlvJGaLS0dajoMhhKb5N80TyeK
         gLeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778853549; x=1779458349;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uHdVr+Knu51ewWGCsREiTmFjxqZ/k2tepG9i/Vxx7HE=;
        b=AQUiTaUGmK6uBrNER7tn2sZu0aTYW7PaAPMQw1l3Pmun8HsN9xe44pQq4zvA6BEhJd
         Rxj784L+7/bwcRotGDkZDHTpG8X9QR5mtwpSROgGKQA7gSKb46/VRodjuDbHn4n7cI9f
         TRcrz9vXGniSOlWLhZ66StWpWfSplZdsaK/68WpI51iyfTx1Y2Nfj12jKZcfoCfHTIcm
         lecLKNvPqfDc1D3bHznJKEmCwOgw1WjkwMkjVcC7Ya4vOClp26eZbAth/x+WUFSvbeOB
         I1B38AgRskTkDkFcYP+3zKn1mF6IR8EnLQZFesLaCQNi025M6xKDe7sB5t9W1gXPzhXC
         aLKw==
X-Gm-Message-State: AOJu0Yxibm0f3hqx70/c0+ZsOhuNpgNJCkPuLW71JkMfk3USO7gBtbym
	Oli01UBDl/fuI/UdG3m1VWkdQqUsAbicjmcUVGOKxLwgCpwV4l8dFfxKvXCL+OkauTs=
X-Gm-Gg: Acq92OEE4YEeFET9hIqDC/Nnh5RMQm35wtAlen0AImOnVeGrsogNWTEVQ0xjFD++5fN
	/+hJrwPgAekELCLSZ1dzcl+QLOBf22KoynEJfazqgXwK0td51+mpa8i129XFc1+3K7LIuhe1Kv+
	iMcGb+C2A/ZCcDoHmIbB61esTJXGj6Nzxho0wKZj3Nm39aKk69R+SEGLHssBCnRP7EZLfu8SNm4
	ZZYsHWPsiZmdH86q7jFCrwE98joAJSUsUAFfHaDqy9svn3DZ0x+ETCXYUMyKbIZ1ILZGktKvId0
	sfFonhUf5hgxj1TTc4gS5eEv9WYidCk6h2+ejnkqnosxSnraup+njtjBMjyDr228dwKQFRX+PYI
	sSU70ntzfdCysKyifXW3oFyP15d+4zvd3DZZzmLa4Utc2JsZovQFy9hIW0elg3/bQ2mZKR+sr+U
	98/qWtYt4SBEMkH8qjfg6p3NoK1CQz
X-Received: by 2002:a05:6214:3f86:b0:8ca:164c:a851 with SMTP id 6a1803df08f44-8ca164cab11mr39494576d6.41.1778853549278;
        Fri, 15 May 2026 06:59:09 -0700 (PDT)
Received: from vinp2.lan ([2607:fb92:1900:6734:902:ab48:6190:9c1e])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8c90874da6dsm52910696d6.9.2026.05.15.06.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 06:59:08 -0700 (PDT)
From: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-trace-kernel@vger.kernel.org,
	Vineeth Pillai <vineeth@bitbyteword.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v3 01/11] io_uring: Use trace_call__##name() at guarded tracepoint call sites
Date: Fri, 15 May 2026 09:59:03 -0400
Message-ID: <20260515135903.2238731-1-vineeth@bitbyteword.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 64A5055137B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[bitbyteword.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_NA(0.00)[bitbyteword.org];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13350-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[vineeth@bitbyteword.org,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[bitbyteword.org:+];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[bitbyteword.org:email,bitbyteword.org:mid,bitbyteword.org:dkim,goodmis.org:email,infradead.org:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Action: no action

From: Vineeth Pillai <vineeth@bitbyteword.org>

Replace trace_foo() with the new trace_call__foo() at sites already
guarded by trace_foo_enabled(), avoiding a redundant
static_branch_unlikely() re-evaluation inside the tracepoint.
trace_call__foo() calls the tracepoint callbacks directly without
utilizing the static branch again.

Original v2 series:
https://lore.kernel.org/linux-trace-kernel/20260323160052.17528-1-vineeth@bitbyteword.org/

Parts of the original v2 series have already been merged in mainline.
This patch is being reposted as a follow-up cleanup for the remaining
unmerged pieces.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
Assisted-by: Claude:claude-sonnet-4-6
---
 io_uring/io_uring.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index e612a66ee80e..1b657b714373 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -312,7 +312,7 @@ static __always_inline bool io_fill_cqe_req(struct io_ring_ctx *ctx,
 	}
 
 	if (trace_io_uring_complete_enabled())
-		trace_io_uring_complete(req->ctx, req, cqe);
+		trace_call__io_uring_complete(req->ctx, req, cqe);
 	return true;
 }
 
-- 
2.54.0


