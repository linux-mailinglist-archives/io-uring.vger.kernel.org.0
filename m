Return-Path: <io-uring+bounces-13234-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8AUAHo+9+Gnh0AIAu9opvQ
	(envelope-from <io-uring+bounces-13234-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 17:38:55 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BB7B34C0CA0
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 17:38:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8A2A7303E2FE
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2026 15:38:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 662633E025C;
	Mon,  4 May 2026 15:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l9ZJVwIe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8803E1201
	for <io-uring@vger.kernel.org>; Mon,  4 May 2026 15:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777909085; cv=none; b=A2QTBfEWrb11ZXyHVvzMqi5Coyp3LZuGaC7ReH/aCzhDOfo0tfcl3xjil05kLvwZt3udmIFTU5Av9+oK7ZhDdo+kuIFUMCSLM50bsSnsb+VKURXSWBJ3T08Oj7gff8yZ4yT87aCrmv2vPPGdWhfFrzFbLpj3ieowC+eckId4Aiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777909085; c=relaxed/simple;
	bh=DeK8vkDNgVdGtbOfo/XgPm6EantZau9iQInjj3eBNb4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GE34PHlCEE/YUsDcWUd7wzpyTarNimdhNxjkqeryWQMMVIwF4Fmo2CJbnwT5Hj4v2onx5IYzDFSAWfsOsSOrMTywarhhLOlUZzQRrviaXzzOvfpyVtZPwQjXDDIstQiE4HqWJSgnYvDhF/CxAIlaGyAuwwvir/JTiyDipJlxlnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l9ZJVwIe; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-362bb3260f1so3068165a91.2
        for <io-uring@vger.kernel.org>; Mon, 04 May 2026 08:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777909083; x=1778513883; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DRJfHeoNcXWsQi0Hkkxe2yF4lFHCoxvJMvngDFVpA6Y=;
        b=l9ZJVwIemh4H8Gtyw/Bxt9f1JzhdI73Hz/nEJ9jT5EOR2+QvKqe5G64D7/w6H14h3/
         7h8iRbexigrN/Xrn9L84ZXppDkpbXMqmbgQt+HeOPvlnRjdO0YIbF1rwASFWuDemmi4Q
         vTL3BPfV5Qmr5A9CCPv3kujb2/Z71D6K4EVQETGs24Q7576VEbAW97QItRcXc1czt4Li
         2b19dh25UFAvQj2Wkw9s9PRZcuo8GZ3bugpEIv6Gb79c+wLBj7nCwx2RxCAgUTg+TIdD
         RDLmM8cDebHvi/eoos+qZWbf92lxw56SlFVeDsnqAj8b4VRZZKkX1BwcPGwmL8C7UI7n
         0OCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777909083; x=1778513883;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DRJfHeoNcXWsQi0Hkkxe2yF4lFHCoxvJMvngDFVpA6Y=;
        b=FUYJioO9nHVtdFwiQCELEy+XGXSBKMcbsKG1WUm6YiHKVuvico7Plu/aV6YSdDYS76
         WwXydcKq7QKY0aI/CQ8WR2tXNkniy6G0Lb3tZc1MyH0nmpuiw4GPngrfDrKTDpIhotVy
         UN/oTCh0qF+L3EPToZZ+JOK23JmGdKM7UmHXZRJnpPgaVlKY+vs/Zb9MIt9JQlA5Qgny
         LBOdOdliOdFXIDZ5PztYMh7vx2OnLXwxArGYEhzL5PzAp0VmYK2JHKh/qb2ix2sbRGIX
         e5mfe0HeS1yLtywlC2D4KGNz8iKRCSxP/u4l2+ky0CQkw/mIOHoJzQMqaArlG/Dv0tgz
         J1/w==
X-Forwarded-Encrypted: i=1; AFNElJ9TvbqSNdFgghc1O6U+HJg5ZTV4UdMIgXl67EZg9IUgXEs5wsnDawAbTjInmohV4cHwhoYxUPhvjQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywl2FpZcDibJkyl85rLhdu1+rkun86RAOKd3I7qW45aEM7mEBJ+
	P6ezOZGbVp03nerbGrI2qv77upV6qXeo04c4xP6qHfyHcTyP/V2NiCK6
X-Gm-Gg: AeBDieuW0JDUXY5z4e2wRlVZzpr6MuyIGhAsyutMYbkVTB8sxGhiWtoff1RJFcb4QYU
	f9vQuGOVuGMzldetdjoHJ7Hwvbj5tKrrZRMeVMD2wjaFOvayE2Finr79I98kuZyravS++aBTRdI
	Xc5nq7BV9Irsjfb19RHQhoic4ucf8nYXmyyL7KhO61y5S/ZOhJx+WBmBtsC6AZAfdUciffATK9d
	MkscoGMBh6zae95d/Xdm8W6KhMMAwBU7CQ9wJSkFmHaIRgRtssWSTww/XUEI/nT69RLpQN/Ib5K
	K8C4D4+kpSUzCpE3dM+YtXE3EnGJMJBRPWTjtUwq6x9TJOA4KMpOQHXS+xqh94ofjGkNx5qAF8I
	G/sGAGvQP/qGCVM+TR61YV+Rm9uooEBX7aVCqLvTACn6LMwCwTnsgDIFH0x7yYi9JlFYMqpY8GT
	sQiSoKFr30h4cDdlzbII8ZdL4F2yiGGYejuF8vDUkot2VddNSAbtXOyTNCc2M=
X-Received: by 2002:a17:903:40d1:b0:2b0:ccad:de1a with SMTP id d9443c01a7336-2b9f260b4a7mr110180135ad.30.1777909083288;
        Mon, 04 May 2026 08:38:03 -0700 (PDT)
Received: from csl-conti-dell7858.ntu.edu.sg ([155.69.195.57])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9caaaec82sm110364095ad.24.2026.05.04.08.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 08:38:02 -0700 (PDT)
From: Maoyi Xie <maoyixie.tju@gmail.com>
X-Google-Original-From: Maoyi Xie <maoyi.xie@ntu.edu.sg>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] io_uring/wait: honour caller's time namespace for IORING_ENTER_ABS_TIMER
Date: Mon,  4 May 2026 23:37:55 +0800
Message-Id: <20260504153755.1293932-3-maoyi.xie@ntu.edu.sg>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260504153755.1293932-1-maoyi.xie@ntu.edu.sg>
References: <20260504153755.1293932-1-maoyi.xie@ntu.edu.sg>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BB7B34C0CA0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13234-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maoyixietju@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:email,ntu.edu.sg:mid,ntu.edu.sg:email]

io_uring_enter() with IORING_ENTER_ABS_TIMER takes an absolute
timespec from the caller via ext_arg->ts. It arms an ABS mode
hrtimer in __io_cqring_wait_schedule(). The conversion path in
io_uring/wait.c parses ext_arg->ts inline rather than going
through io_parse_user_time(). It therefore does not pick up the
time namespace conversion added by the previous patch.

Apply timens_ktime_to_host() to the parsed time on the
IORING_ENTER_ABS_TIMER branch. This mirrors the IORING_TIMEOUT_ABS
fix in io_parse_user_time(). Use ctx->clockid as the clock id.
ctx->clockid is set either at ring creation or via
IORING_REGISTER_CLOCK.

timens_ktime_to_host() is a no-op for clocks not affected by time
namespaces. It is also a no-op for callers in the initial time
namespace. The fast path is unchanged.

Reproducer: in unshare --user --time, with a -10s monotonic
offset, call io_uring_enter with min_complete=1,
IORING_ENTER_ABS_TIMER, and ts = now + 1s. The call returns
-ETIME after <1ms instead of after the expected ~1s.

Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Maoyi Xie <maoyi.xie@ntu.edu.sg>
---
 io_uring/wait.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/io_uring/wait.c b/io_uring/wait.c
index 91df86ce0..ec01e78a2 100644
--- a/io_uring/wait.c
+++ b/io_uring/wait.c
@@ -5,6 +5,7 @@
 #include <linux/kernel.h>
 #include <linux/sched/signal.h>
 #include <linux/io_uring.h>
+#include <linux/time_namespace.h>
 
 #include <trace/events/io_uring.h>
 
@@ -229,7 +230,10 @@ int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 
 	if (ext_arg->ts_set) {
 		iowq.timeout = timespec64_to_ktime(ext_arg->ts);
-		if (!(flags & IORING_ENTER_ABS_TIMER))
+		if (flags & IORING_ENTER_ABS_TIMER)
+			iowq.timeout = timens_ktime_to_host(ctx->clockid,
+							    iowq.timeout);
+		else
 			iowq.timeout = ktime_add(iowq.timeout, start_time);
 	}
 
-- 
2.34.1


