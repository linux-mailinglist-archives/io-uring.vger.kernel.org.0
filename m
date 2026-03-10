Return-Path: <io-uring+bounces-12610-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id hAYnKwqqr2nibQIAu9opvQ
	(envelope-from <io-uring+bounces-12610-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 06:20:10 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 04EEB2456CA
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 06:20:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B184D3052628
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 05:20:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F5912749D5;
	Tue, 10 Mar 2026 05:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lhyeDoll"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C406E126F3B
	for <io-uring@vger.kernel.org>; Tue, 10 Mar 2026 05:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773120007; cv=none; b=j6foIx/NBPVqd+eXcxlTywcbkck5caS0KRmGakwEpkGOsV8grAy72VAga0XoAIc50+1cyP6Ya5Wpe3mB1jteiQ/0vBcBpAoj6rYexibY4vRFGipH45sa6piCTHV7fJ9h1+7UVzYiShRJkUG/FqIiD3k1wkr/fwpj1YBVjYTetp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773120007; c=relaxed/simple;
	bh=eptNaZ64wqLEU7TrZTv6Z/w6fv8lss7bocwFzNA4Y2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQ+jksPVRiQlDNKrGbM2pgG7i41Pwvu44G9lai31MRe9JRXbKuB7r4/OLXejU7gIZ+jQayM5UluT9qadSEIsAVV1vbHqBLpY3jbGh9XJAl5HdTWV9ZowX3+KigIfLoDkXGfyLFEF2k3PuXERNHGOY6RguNKE9Bx6lZ04c+IUC3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lhyeDoll; arc=none smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2be3bdfda8eso5820865eec.1
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 22:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773120006; x=1773724806; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b/4kWTUKQrjnwbYMGXgVUk814Gnx5umitEul4UmuF0s=;
        b=lhyeDollYMxKdSDU6Hit1/EQV+essCoPkomiWON23PPoxrA0C3a/VxsaaXgp0gRAVO
         yP8MxL2Nlg4gv6HbXjiis4qdWQl4MOVvylnofZjoU/bAoaNXEvBPyruJsko921WW1CYd
         ZmKK9ruxGahWBNENeGIK5jIwxoDblJSFIPv16txwKGGAcw/7YPcMPVBcpMtPqAaJThX2
         /X/srmJ3yawhPyOf81pbUJKnP0KO9Lg9mVuYShZlNdyff09TUuH/idyf58j/Aqfo6JBs
         8YfV7Xlh2bqw8q07bbir66JcMw6fxXZlZeDbdUp5y/n0p25Szd40/nZxY7SWfXLW+10Z
         G5Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773120006; x=1773724806;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b/4kWTUKQrjnwbYMGXgVUk814Gnx5umitEul4UmuF0s=;
        b=DGty2vxk5VaffXT+UZlsYHrRMJBYcVe/Zj3jY8iMdXGaUBObdpVqk5iHuV9dX16j8L
         5wu8Q9Zk5vj1kEDabRPpYTkH5jlxApSMGJ1b26Va50GP8Pi2JhWGFZG4/qsUX3Y/2goM
         5hctCURsnMRFvUgILcA/jwBKiKxx20MhuaYTT/iRthYDLhrUtqc3xFMJ/vJZDl/Ztgzv
         hC9xRK2/5lw4FrCdQ+SfDeK14UaG+kAEY/XxC+mF4cSvun1vylqqAdHwzquoaUBQIx/8
         8qR+ZXcvPlJCu8gHb+k0PgYQngTUuG4rcECc1Iv36zHYEAbIL1++kYu4FibDpqPu8WoN
         22uw==
X-Gm-Message-State: AOJu0Yza+9o7CVUS0cMXdisnhsL5XRQXiE5IAKd0NXYsHYFPFRm3JKTr
	mOAKCz44YM15id9JMAHkUQ2LcRhzL5Kw1ym2+vJBlgj2srXt0DOGHHBuoRINHkqi
X-Gm-Gg: ATEYQzwPwedJw2i8E4iF3wUp8TARDDdb671xKux2es7vKoH/YThXmM0jnA7AYgmmUt+
	2KQQ/1ZRk8SBNMQVMoY9+L/0VDIy0eKyjzcqVlprXU8/GGHAIKM7XjKK+742fDLaHmvOQod5zGm
	L96zvbMqHO+3L1hMl/DJY8rs6TmsGXut5BCWvdEUPH/9+hc3QI3jyfkiF/6as7dMpdlLn6vz3oM
	oPrlWIwtf/s/TTG9z0uEUGR5VqRrn8hYSr/i/WB0HflIKRLyN+WdzGvbfi77ZM02pPoo7mA9Snn
	p1IKLBLQjey35Rjyl2L8a2k5JXM/VjgP9ERtB/3CtWK1d0BLLhtTOCXPz3eWA6urIm3VnZC/puO
	cD6o/5juZnePjiWhKG9yONJ47FavXHrF/c/6YYI7czJ0CXRHrz2NQbm9W26bBA8P7AcwHK0CC+r
	8t1CtXfzG3n1YaGn4aV0ZLgLUQ9PbV89wGz/LZEoWJZsC9pu9Ly/fGH1NgVPk9uwuz4F9DWM7vJ
	ByzQxVe9FMQ
X-Received: by 2002:a05:693c:2b04:b0:2bd:fbc6:4134 with SMTP id 5a478bee46e88-2be4e027480mr5306098eec.23.1773120005580;
        Mon, 09 Mar 2026 22:20:05 -0700 (PDT)
Received: from localhost.localdomain ([109.104.115.136])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2be4f94833bsm11663237eec.18.2026.03.09.22.20.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Mar 2026 22:20:05 -0700 (PDT)
From: Tom Ryan <ryan36005@gmail.com>
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
	gregkh@linuxfoundation.org,
	kbusch@kernel.org,
	csander@purestorage.com,
	Tom Ryan <ryan36005@gmail.com>
Subject: [PATCH v2] io_uring: fix physical SQE bounds check for SQE_MIXED 128-byte ops
Date: Mon,  9 Mar 2026 22:20:02 -0700
Message-ID: <20260310052003.72871-1-ryan36005@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <aa9Bjbplx3b_Uvmj@kbusch-mbp>
References: <aa9Bjbplx3b_Uvmj@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 04EEB2456CA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.dk,linuxfoundation.org,kernel.org,purestorage.com,gmail.com];
	TAGGED_FROM(0.00)[bounces-12610-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ryan36005@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

When IORING_SETUP_SQE_MIXED is used without IORING_SETUP_NO_SQARRAY,
the boundary check for 128-byte SQE operations in io_init_req()
validated the logical SQ head position rather than the physical SQE
index.

The existing check:

  !(ctx->cached_sq_head & (ctx->sq_entries - 1))

ensures the logical position isn't at the end of the ring, which is
correct for NO_SQARRAY rings where physical == logical. However, when
sq_array is present, an unprivileged user can remap any logical
position to an arbitrary physical index via sq_array. Setting
sq_array[N] = sq_entries - 1 places a 128-byte operation at the last
physical SQE slot, causing the 128-byte memcpy in
io_uring_cmd_sqe_copy() to read 64 bytes past the end of the SQE
array.

Replace the cached_sq_head alignment check with a direct validation
of the physical SQE index, which correctly handles both sq_array and
NO_SQARRAY cases.

Fixes: 1cba30bf9fdd ("io_uring: add support for IORING_SETUP_SQE_MIXED")
Signed-off-by: Tom Ryan <ryan36005@gmail.com>
---
v1 -> v2:
 - Replace the cached_sq_head alignment check rather than adding a
   separate check, per Caleb Sander Mateos' observation that the new
   physical index validation subsumes the old logical check for both
   sq_array and NO_SQARRAY cases
 - Fold into existing conditional per Keith Busch
 - liburing test sent separately

 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index aa9570316..d9a307384 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1745,7 +1745,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		 * well as 2 contiguous entries.
 		 */
 		if (!(ctx->flags & IORING_SETUP_SQE_MIXED) || *left < 2 ||
-		    !(ctx->cached_sq_head & (ctx->sq_entries - 1)))
+		    (unsigned)(sqe - ctx->sq_sqes) >= ctx->sq_entries - 1)
 			return io_init_fail_req(req, -EINVAL);
 		/*
 		 * A 128b operation on a mixed SQ uses two entries, so we have
-- 
2.50.1 (Apple Git-155)


