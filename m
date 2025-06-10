Return-Path: <io-uring+bounces-8303-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E34C4AD43A2
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 22:20:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BADE0189D82F
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 20:21:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEEDB26560B;
	Tue, 10 Jun 2025 20:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ok+VBh8X"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8954B264F99
	for <io-uring@vger.kernel.org>; Tue, 10 Jun 2025 20:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749586851; cv=none; b=ZMQmjdKVxRU04z2HqOqmJlR6oJRJ/pD81qLI4D37uOrv/OkA7uD1PnNuJGgoGykesUCN3EJXBRgCuB2BKEcx6vdqdkhU574inHW+qXbTljdQiL81j4Fg9CXUv7Oe1yP5ib1VnlGO3d0hcgxlH/uRsVpgIdGQs8L1BCyOuBHMGUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749586851; c=relaxed/simple;
	bh=OKAhe7RVk7e3Jy7xcLnQfensj8kvM3IfDsgJ+mNymfY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hwbsHqIhHuetQXsOAMUf1Yjh3PWglnwiec//lXS1abcqa0Se7Iyt3s9NmNcb1V9J1vH7d7zS7rDe0F6F85yHa4R0I1X6W1yZ7ePwB/b1vbqqa7ZYKL+nT4nsy1WMghfwAtb3C2eHTOntG5T9GUC9O4i3uSaQMrcrCaKXI+/xARU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ok+VBh8X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A1FC4CEF0;
	Tue, 10 Jun 2025 20:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749586851;
	bh=OKAhe7RVk7e3Jy7xcLnQfensj8kvM3IfDsgJ+mNymfY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ok+VBh8XX6722qDjqDb7mSdk11NfVBrz94UzXaBoPlv5YToRz92F0NwU9UHCHpZkq
	 5po/8Udg85TSUEApHFzR6hU9jGmD3PGxzw1pSAJcrI2nZhQK+BNZeYhvibyPM3Lofs
	 EciVe/wwciL2Zcy9viR4PLRdztrtf54BVNZdadMJ3K+CA89+TP6nvfhksqbwLpP4EV
	 7LZ0jW5QC+zBUHpAY1vtnKqcg96XIrYuXOnOVXQTezBNNdm0ILDetaPo4rYVQGf3GS
	 Cs0kcq6KKk52DujZdV0SBBb6xZ6RWfLFjJGpGsiNlt0ZFRzYqNjRtfG/FQYekmzuYy
	 nKY/3tXoLL4Vg==
Date: Tue, 10 Jun 2025 14:20:49 -0600
From: Keith Busch <kbusch@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
	superman.xpt@gmail.com
Subject: Re: [PATCH] io_uring: consistently use rcu semantics with sqpoll
 thread
Message-ID: <aEiToYXiUneeNFq_@kbusch-mbp>
References: <20250610193028.2032495-1-kbusch@meta.com>
 <c2f09260-46c8-4108-b190-232c025947df@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2f09260-46c8-4108-b190-232c025947df@kernel.dk>

On Tue, Jun 10, 2025 at 02:04:41PM -0600, Jens Axboe wrote:
> On 6/10/25 1:30 PM, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > It is already dereferenced with rcu read protection, so it needs to be
> > annotated as such, and consistently use rcu helpers for access and
> > assignment.
> 
> There are some bits in io_uring.c that access it, which probably need
> some attention too I think. One of them a bit trickier.

Oh, sure is. I just ran 'make C=1' on the originally affected files, but
should have ran it on all of io_uring/.

I think the below should clear up the new warnings. I think it's safe to
hold the rcu read lock for the tricky one as io_wq_cancel_cb() doesn't
appear to make any blocking calls.

---
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cf759c172083c..c6502197eb6b2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2906,10 +2906,12 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 			struct task_struct *tsk;
 
 			io_sq_thread_park(sqd);
-			tsk = sqd->thread;
+			rcu_read_lock();
+			tsk = rcu_dereference(sqd->thread);
 			if (tsk && tsk->io_uring && tsk->io_uring->io_wq)
 				io_wq_cancel_cb(tsk->io_uring->io_wq,
 						io_cancel_ctx_cb, ctx, true);
+			rcu_read_unlock();
 			io_sq_thread_unpark(sqd);
 		}
 
@@ -3142,7 +3144,7 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 	s64 inflight;
 	DEFINE_WAIT(wait);
 
-	WARN_ON_ONCE(sqd && sqd->thread != current);
+	WARN_ON_ONCE(sqd && rcu_access_pointer(sqd->thread) != current);
 
 	if (!current->io_uring)
 		return;
--

