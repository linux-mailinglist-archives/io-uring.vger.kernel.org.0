Return-Path: <io-uring+bounces-12806-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0LSqDFtuwWnDTAQAu9opvQ
	(envelope-from <io-uring+bounces-12806-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 17:46:19 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 97C7D2F8C6E
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 17:46:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B19D4304F481
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 16:01:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D5EC3B9D92;
	Mon, 23 Mar 2026 16:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="Q8oFKUkK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62FB3B9D97
	for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 16:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774281669; cv=none; b=iwTSqNdnxLKbWVgK3wUXTz1mUHqgr3KeLL4Q+bW19yM/IDy8r8bSLflrqtLS1eWLtkP/w5GLC47KY7xP3Gu++GJj6+sZxM0ziCjeTno2xSVZhXsSib8nsSPqfePIilPCeWYk8EqfZRN1qiRO+3rBx2y80w5kmbutAmlPLF+Sasw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774281669; c=relaxed/simple;
	bh=Hj2JhMI5b6Lafwdjdamwe1jMGPYt17fp5OkHh3BHS7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MdFM339zmDMbHpc2yOtfG3VMXACs4dMPMEB4n336doFNPbTDsOEau0vAvFNvD6/dtSY/lAr5Vn5atzpKqakmiNQE1YqpOJ+E5I2spQEMOtOXBg5nOeDfXuOMIemqGcSyVB+m3c27pYSTa7nfm0AGsDBj6re2oAKt53ebNmDdRQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=Q8oFKUkK; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8cb3bae8d3eso405651285a.1
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 09:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1774281667; x=1774886467; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a4j4tflgND4Uiq9FcYinLLfKMNOFlVvGkpZDXfO0Vpc=;
        b=Q8oFKUkKk31RX4VSpufeeZR/L2ttmdhrNRS/xpusWMuJ3uT77h9XdawdBslPDqAxfS
         QA4JJVHgbpliXhKVMF7XPf1vNWGvVwhLg7FTYKqqCmhLT8bmjFGXuFVuhbDld2OB4Pp8
         UFe/LC2eQIueylGEa3HPqAVjfzBCSfMM8yfY0kPltCYPQG/zsfa71kGewEvtUK6B3nqQ
         pT+sysiqFrsDyA0gA8tea8VFyJ+gIpuiVDN5vxxcJRCxzQVgg7FsiPc154vdyUeBXeGH
         jYvnXi9eNUGijd+xknI9mShD+y8aK3H2hcGpVW89OGqRzcDbZ9TTb+e2hEFnTvBylti1
         srOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774281667; x=1774886467;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a4j4tflgND4Uiq9FcYinLLfKMNOFlVvGkpZDXfO0Vpc=;
        b=dMvil8Y3js6R4mXTopYXxMjtVRwyAvtFc0GqFIf3eeR5fWn2D1byJ/Wgcf2pBWa3Jl
         PinXyYfYlINNkVYuy4V49AZDZpvdwLCt9Cd+FLgozFPEu9D35vL79KdnSQoqprN4iUjn
         TK30z7E8aXTBPfrJU4fSJVP9D5OmMFfQ9p+s4DP86KqkM4SET8A8sNl9o8BQwaoz5aRe
         GY5wDQXvm2h6zTPgu90+4c8CedW54ri5/KUfWfxHXgY49q8SogxsR5kddtzC07R6NDSv
         rn2753Zi5ZKzzcFI0t8ybH2aBArOZIFlwgmgH5fM+j7xuXZk6YPQg47pr6tSNw/a+vOx
         qxMg==
X-Forwarded-Encrypted: i=1; AJvYcCXr8G+XdrG45lQ7L2z/QV9HyzsjU+0DFid98MkeVyg/ORzorETY+0vMkj+56guHp/Er738Jr12ZFQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzDOaGF0MHEyUuDJZKjR9eUobVnDxSK3L47jC9wTP/DH5jNgVGH
	PRsDL9I0sJPhEW6X3y3jPHqn6JmPQMGFrojof/81pKuQXGhx9OoA4BzOJ2DynZEge9k=
X-Gm-Gg: ATEYQzwI7dLp3oQzObxZDUwZwsbFmhfy168rf0CHSsPOgrsMz9uH79FYJDnllOpD0pN
	5xxbn6zQLjdm0Ls49/Ks7K2e6IV3HJEIBAfIoLwVnaN3toFHB/96W/TAcxDhmyRqgTCB/VJYUo1
	lP7OPewJQpXGZLRiM82LY5PMqOHkz/bEnDD9BNYysclYqHiaHMXTSbqaulWJs3lOPB1mlMQVofK
	gJtcU1ixlJMAWUJXz1tbB6Shf4jVgsnK8w2JgftZOnZ5VkYKCQJHquTBa7sJNGfme6szVvocu7+
	clMMh2s4JQyWMFLmpgVWIanGGuS0gD+Yc9FhiSC2GTh/5jJ8dCpdhOVKznaDyvPse+UA6r8LW4X
	hqME28Jb0Wc4iGqkeYswe9ie7eslFshVSo4UzNRgmoC1xJf0WcN2GwhNGpeFkRV0QgL7TRRA83O
	bk9o7j/llayIlaXYKTK8/7SRNC0F96VWt2gBLi2nrpDpeW5TJyYfuDQ3VdEh6pXgi2EK5mL9rAs
	Yoo
X-Received: by 2002:a05:620a:2845:b0:8cd:9033:1724 with SMTP id af79cd13be357-8cfc7b65cb3mr1863344685a.9.1774281666365;
        Mon, 23 Mar 2026 09:01:06 -0700 (PDT)
Received: from vinmini.lan (c-73-143-21-186.hsd1.vt.comcast.net. [73.143.21.186])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc9088df1sm843364185a.25.2026.03.23.09.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 09:01:05 -0700 (PDT)
From: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
To: 
Cc: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v2 03/19] io_uring: Use trace_call__##name() at guarded tracepoint call sites
Date: Mon, 23 Mar 2026 12:00:22 -0400
Message-ID: <20260323160052.17528-4-vineeth@bitbyteword.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323160052.17528-1-vineeth@bitbyteword.org>
References: <20260323160052.17528-1-vineeth@bitbyteword.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[bitbyteword.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12806-lists,io-uring=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	DMARC_NA(0.00)[bitbyteword.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[vineeth@bitbyteword.org,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[bitbyteword.org:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 97C7D2F8C6E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Replace trace_foo() with the new trace_call__foo() at sites already
guarded by trace_foo_enabled(), avoiding a redundant
static_branch_unlikely() re-evaluation inside the tracepoint.
trace_call__foo() calls the tracepoint callbacks directly without
utilizing the static branch again.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
Assisted-by: Claude:claude-sonnet-4-6
---
 io_uring/io_uring.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 0fa844faf2871..e99975ffdda12 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -299,7 +299,7 @@ static __always_inline bool io_fill_cqe_req(struct io_ring_ctx *ctx,
 	}
 
 	if (trace_io_uring_complete_enabled())
-		trace_io_uring_complete(req->ctx, req, cqe);
+		trace_call__io_uring_complete(req->ctx, req, cqe);
 	return true;
 }
 
-- 
2.53.0


