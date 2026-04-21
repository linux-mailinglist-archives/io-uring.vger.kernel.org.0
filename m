Return-Path: <io-uring+bounces-13082-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oMYZFsWC52k+9gEAu9opvQ
	(envelope-from <io-uring+bounces-13082-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 15:59:33 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EF6A643BAC1
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 15:59:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id BE9373018638
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 13:56:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67D5F2D9EC2;
	Tue, 21 Apr 2026 13:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="lTOS3MAg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E523A3D6CBD
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 13:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776779796; cv=none; b=Ff3O2vgA6gBu0PQbVFZ6nnGolxEIQ6vl9/Fty3SDsEKdzofBvS+f6giJUw08kixdqUM0M/GkRwnNio7vGkvSgBoQGuHbXfFo4oDYW8s+TmVXDwx+ANJMdgX9MdS1t1/71bzwG6zG0jNTkhR76xVx9XGgTYcVqT8j7Q1/nbj2yKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776779796; c=relaxed/simple;
	bh=kILYRTsNlmkQvovOPGVnX6ZxkaitnB2b+67eSfKmvU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCFScBI7BHXftBy9DvriBAIMnSGmhEufgCCbMG8a2T3KJDAn0KhvacHQOEtKJLTR44xV6DiFGIbu2KIrkO2cnvL4DMbF0RJYUsUvzHQ7RQc882JI+OV5ArXI3R7DFnKdWklb+FZdyqoVei7D89eefQphFRkLmILi8S33ys/vXbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=lTOS3MAg; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-6949192b840so595032eaf.3
        for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 06:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776779793; x=1777384593; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MQN/j7lzyFnL/PLIiYNgj0oeXvBdmBo50S1FNus84c8=;
        b=lTOS3MAgwBOcquQMeg7ybQVk3+3C7sMzM34KkBrV+R0tY96+Fk9ruSXUzRnLx2PVm5
         7YvmXNN5ScdNUwULoiUZKoa2l1SmoxB94iPrXWo+XwRGFq3fikONoE6s3BRDcHrMT0IL
         +bx7fiEezc0+U1+EkAHlwCdXFB7s3fWyGScoEqwyOI4B477CBX5VyUhoy4DNTFVb7D+T
         J7N//iXoOrLB6LJ0JSCWpjY7LLesbFBflEptXSAYz622wU5pFBjyyJULXzrXyEjnk6h3
         nFftvx9oYxhsyjhlaBicWRPSukmE8Dlx46SQ+V0wuRVR/uCA2QIZW4X+Gx3uSjL510ib
         ej9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776779793; x=1777384593;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MQN/j7lzyFnL/PLIiYNgj0oeXvBdmBo50S1FNus84c8=;
        b=LGfA46WRYMxaDIUrzHJk5bEjnBSroQ6spsC1sRVVkG1Pi3Lskbh0EIM7qy7n02xdv9
         tKyhel9wB+UdBRTgvGKIEneC2UYKLW81r1E9JEl2z31ETHCuQwKrVYMiPQIQrqlLGl1/
         PSSkrInwkWx47iPECBwjgkDo6E2iASdOenaTQj0k2J9vWtY5LYZoKAEiRCkghbcBQNcx
         8RSwqiH5vUWssJecEVkDapui4JPDJAmNeSw6JkbpSfuJtZIL5lwqymZQfJNFRHCAjfpC
         agkXAjovs40dTzl4LNR+fbo1ugjTg/JJWcMB+YJod19PbdxgZl+M38MAlXRzgFeJaEPQ
         PKXw==
X-Gm-Message-State: AOJu0YzB0k/LPSPDWMLhpKe6uFpi9riKxlMxhlnwApTpN77ZPoLZoiLs
	796BJZzhMIpYE1HPacIyFzXYnzs6nOqXgNn/ZtvJfGlCVhow9YIt2nPx5ynr6bvdctR+GmyoDeN
	tdj56D64=
X-Gm-Gg: AeBDievxg+pUX5OwB1lvQ3QdKeB5LGZkEzamCgf6/9BPZ2SwtYDqRKOQEfTHNj5H+dF
	Bk8RTafosfcE4FEVdJQCnHJLD7Ceu3IiWgIB4SbWCDcO4ih1CVuh4wbuGwF3Sks4HaiCmdrgrtE
	k0SQqZEajep139I4U8DHZ8Se8nM4GjUT/RDnuV74x7evA99QIveKbXDDTiW/tnE6v4bCYDzQpUr
	dF/QYchp0ldCYG9dTmF/yzElDuWxJHWOBt5/wxTWDuMNl18N2Bqg8+rTuoMN5Qp/PrLLg7pu+xF
	sHH19q4XcaHZ6WTa55MccNRUbQ4puHS4QM6xboOlpd1LBBYUcXhgFA06e55oFzHoWG2+TnVes2N
	ls+gMkkTFL4zOqLASMhodSlPteMAmAnrUWdgRroO2O1fn5MGja6Zbc9eGwhGAtvMLgkcbrJfG71
	4lz9zBVBBAJdAKOAahSsAFIOOK3Op8NDlEpn3pJsdGIbka0oza0kXgRGaE+02BRyfStWVg4RZYG
	ua9Gwg=
X-Received: by 2002:a05:6820:6ac8:b0:694:852a:28aa with SMTP id 006d021491bc7-694852a2d49mr4233360eaf.60.1776779793595;
        Tue, 21 Apr 2026 06:56:33 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-42b8fe2c52bsm11756474fac.0.2026.04.21.06.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 06:56:32 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/6] io_uring/rw: add defensive hardening for negative kbuf lengths
Date: Tue, 21 Apr 2026 07:51:41 -0600
Message-ID: <20260421135626.581917-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260421135626.581917-1-axboe@kernel.dk>
References: <20260421135626.581917-1-axboe@kernel.dk>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13082-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel.dk:mid,kernel.dk:email]
X-Rspamd-Queue-Id: EF6A643BAC1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

No real bug here, just being a bit defensive in ensuring that whatever
gets passed into io_put_kbuf() is always >= 0 and not some random error
value.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 20654deff84d..e729e0e7657e 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -580,7 +580,7 @@ void io_req_rw_complete(struct io_tw_req tw_req, io_tw_token_t tw)
 	io_req_io_end(req);
 
 	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING))
-		req->cqe.flags |= io_put_kbuf(req, req->cqe.res, NULL);
+		req->cqe.flags |= io_put_kbuf(req, max(req->cqe.res, 0), NULL);
 
 	io_req_rw_cleanup(req, 0);
 	io_req_task_complete(tw_req, tw);
@@ -1379,7 +1379,7 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		list_del(&req->iopoll_node);
 		wq_list_add_tail(&req->comp_list, &ctx->submit_state.compl_reqs);
 		nr_events++;
-		req->cqe.flags = io_put_kbuf(req, req->cqe.res, NULL);
+		req->cqe.flags = io_put_kbuf(req, max(req->cqe.res, 0), NULL);
 		if (!io_is_uring_cmd(req))
 			io_req_rw_cleanup(req, 0);
 	}
-- 
2.53.0


