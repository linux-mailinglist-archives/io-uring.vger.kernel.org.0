Return-Path: <io-uring+bounces-3234-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B9A997CCA5
	for <lists+io-uring@lfdr.de>; Thu, 19 Sep 2024 18:47:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F36B1C21993
	for <lists+io-uring@lfdr.de>; Thu, 19 Sep 2024 16:47:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D7BB1A08A8;
	Thu, 19 Sep 2024 16:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="Jen/zCIi";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Ir2rjLQp"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh2-smtp.messagingengine.com (fhigh2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E86619B3CB
	for <io-uring@vger.kernel.org>; Thu, 19 Sep 2024 16:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726764458; cv=none; b=shzP7LzumESIKVZFOMWoWTGwraxTLT/T6TATwPm5alLXYSwpy61940Elv83G3PUAPD28M2iXLfMaIuHNI5vMKDoNeYgPGyxpT1fidxweuWta/Oi1dALuFwSfQBJYzsTs70U6+Q2+ZuPGpmEHHGj7lRIItkOaXb1ImpD13iRLYxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726764458; c=relaxed/simple;
	bh=fJYDXJfwKP/Ov8ShAz5HD/FsqoaJDWjvL7WPUJ6D3rg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nBmVbhHBdZXTOLlwvrXidlZdRG2VKs51DMw/KwzGCf9WBhx3/v33Nd4m1BwyWOPHmLN9d1Eo8ZLAUm+aHaOZFQylI0amlgqYPo1B9vm8D5B8sH9V8W2opupu+LPy9rwZuI4Hmxu5MyuLe2kMUXxu8djJhX1dm0CjX641BwUP7Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=Jen/zCIi; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Ir2rjLQp; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 58E6A11401A6;
	Thu, 19 Sep 2024 12:47:35 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Thu, 19 Sep 2024 12:47:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1726764455; x=1726850855; bh=xU0YftXEWI
	JCH0Hh4JmTxM9vm3EqbxokTQHUuDjAz/A=; b=Jen/zCIi99nDlMg52H3oAMneEH
	ibGjEfvc06NJe8X0VOZmbbnxnarJU0vJqWpt54/4U3SwB2URAW6VPjeSgVusecYA
	1uqnLo/vEKnVP4Ypw8TQLat7RePEFuAQbBUbY3TvR8fKwdtS3HfwucqboN7v13fH
	Z80Bszejb/ClaRtB3XKyX3uzkNxwt0XSMOZmnz0OYLAdoyfvg7Pa+msuoprfGQ4R
	9/McJWVc//EDcgBNqksrpp23jTP2vXJb4Rso8uBPCuzmzsSUcNDtA684wIAYLAeI
	jzMfaYTJ9+4AsfvYI+eIYk+srbDMVBRIEh4OK5ZsuABGVWEHBYIYIY+ZRL5Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1726764455; x=1726850855; bh=xU0YftXEWIJCH0Hh4JmTxM9vm3Eq
	bxokTQHUuDjAz/A=; b=Ir2rjLQp3pTU4b2rhNDPu8HLYCPhYiv1tX92OW3RgIk8
	YTLSZZt+hBgeqn2BTaZT9vPJmmUXUzF2JOKnBxG56Q+J10/mwEEynw1r86iWqirS
	2Gq0lBNYKC9B0994ot5994sdjQpT2I70Cy6fid7U1tgYyfsvte80qsT5wY+7uGsO
	D3gDvp5PuSHK2jXF4yGenedylhJXQhPRFAcoSeALqoSdzInnBLPj1fWwgjoMyTfN
	PtwRh9yYbC64ZTk3iNIovb8TZAB2mOojRvfZaRCMvaXe8x9PGcfgI1iosepgOYUq
	+hYVXRdx4YLGCDW3zMa/WsGnhhZsgB8KcRoQokgWCA==
X-ME-Sender: <xms:p1XsZkr_amyJSrumuuj09M7CMPzdmxOhc7RhMkUPdzfJEJ8_oaLxoQ>
    <xme:p1XsZqpKGReiE4xlp8Iy2oRaJfnfPi4UFo1sR6g9S3PWTctgDRiy5UVyDdiYXc8eb
    vVFwOxxLKqMMURQU-g>
X-ME-Received: <xmr:p1XsZpPe8cZt5ou7b3XD0FSacw4vjzX1JhCPpm6UgLyLUylelDbYUsoqpdHPAqz7KkhuP6nORC5TaVW7SeQLXk6PvyC0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudeluddguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenfghrlhcuvffnffculdeftddmnecujfgurhepfffhvfevuffk
    fhggtggujgesthdtredttddtvdenucfhrhhomheplfgrnhcujfgvnhgurhhikhcuhfgrrh
    hruceokhgvrhhnvghlsehjfhgrrhhrrdgttgeqnecuggftrfgrthhtvghrnhepudekgeff
    tdefiefhheetvedvieeuteetlefgfedvhfelueefgeeiudeiudfhkeeinecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhgvrhhnvghlsehjfhgr
    rhhrrdgttgdpnhgspghrtghpthhtohepfedpmhhouggvpehsmhhtphhouhhtpdhrtghpth
    htoheprgigsghovgeskhgvrhhnvghlrdgukhdprhgtphhtthhopegrshhmlhdrshhilhgv
    nhgtvgesghhmrghilhdrtghomhdprhgtphhtthhopehiohdquhhrihhnghesvhhgvghrrd
    hkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:p1XsZr5CW_F_rjPdLBu7AZtPmBrPTamrTzG_1sUirnchF_F86G1LGQ>
    <xmx:p1XsZj7jPUnz1RIsrR5bEPOnkqQZBweYWJ0IG9P9Tq_-jwqVj6nm1w>
    <xmx:p1XsZrgRkoshaCn6W2o6MkC9QiNBKcTFvxQFA95aP67X6Rc8CiW2BQ>
    <xmx:p1XsZt5sWgEBBMGhxbXNKURX8mC6AKbxBufkJiYNZSLzwhhxoYKqbg>
    <xmx:p1XsZln2FXT-TrqN89HSzWmGC4yMw_XwKA5ej390U2USjkP-TxDN69_I>
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Sep 2024 12:47:34 -0400 (EDT)
Date: Thu, 19 Sep 2024 18:47:32 +0200
From: Jan Hendrik Farr <kernel@jfarr.cc>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring: run normal task_work AFTER local work
Message-ID: <ZuxVpEjXoJrkTp-F@archlinux>
References: <8e3894e3-2609-4233-83df-1633fba7d4dd@kernel.dk>
 <6e445fe1-9a75-4e50-aa70-514937064e64@gmail.com>
 <5ac3973b-fbbd-4a49-babb-6d2e3e8333f7@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ac3973b-fbbd-4a49-babb-6d2e3e8333f7@kernel.dk>

> [...]
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 75f0087183e5..56097627eafc 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2472,7 +2472,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>  		return 1;
>  	if (unlikely(!llist_empty(&ctx->work_llist)))
>  		return 1;
> -	if (unlikely(test_thread_flag(TIF_NOTIFY_SIGNAL)))
> +	if (unlikely(task_work_pending(current)))
>  		return 1;
>  	if (unlikely(task_sigpending(current)))
>  		return -EINTR;
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index 9d70b2cf7b1e..2fbf0ea9c171 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -308,15 +308,17 @@ static inline int io_run_task_work(void)
>  	 */
>  	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
>  		clear_notify_signal();
> +
> +	if (test_thread_flag(TIF_NOTIFY_RESUME)) {
> +		__set_current_state(TASK_RUNNING);
> +		resume_user_mode_work(NULL);
> +	}
> +
>  	/*
>  	 * PF_IO_WORKER never returns to userspace, so check here if we have
>  	 * notify work that needs processing.
>  	 */
>  	if (current->flags & PF_IO_WORKER) {
> -		if (test_thread_flag(TIF_NOTIFY_RESUME)) {
> -			__set_current_state(TASK_RUNNING);
> -			resume_user_mode_work(NULL);
> -		}
>  		if (current->io_uring) {
>  			unsigned int count = 0;
>  
> 

Can confirm that also this patch fixes the issue on my end (both with the
reordering of the task_work and without it).

Also found a different way to trigger the issue that does not misuse
IOSQE_IO_LINK. Do three sends with IOSQE_CQE_SKIP_SUCCESS | IOSQE_IO_LINK
followed by a close with IOSQE_CQE_SKIP_SUCCESS on a ring with
IORING_SETUP_DEFER_TASKRUN.

I confirmed that that test case also first brakes on
846072f16eed3b3fb4e59b677f3ed8afb8509b89 and is fixed by either of the
two patches you sent.

Not sure if that's a preferable test case compared to the weirder ealier one.
You can find it below as a patch to the existing test case in the liburing
repo:


diff --git a/test/linked-defer-close.c b/test/linked-defer-close.c
index 4be96b3..f9ef6eb 100644
--- a/test/linked-defer-close.c
+++ b/test/linked-defer-close.c
@@ -88,6 +88,7 @@ int main(int argc, char *argv[])
 	struct sockaddr_in saddr;
 	char *msg1 = "message number 1\n";
 	char *msg2 = "message number 2\n";
+	char *msg3 = "message number 3\n";
 	int val, send_fd, ret, sockfd;
 	struct sigaction act[2] = { };
 	struct thread_data td;
@@ -182,17 +183,22 @@ int main(int argc, char *argv[])
 			sqe = io_uring_get_sqe(&ring);
 			io_uring_prep_send(sqe, send_fd, msg1, strlen(msg1), 0);
 			sqe->user_data = IS_SEND;
-			sqe->flags = IOSQE_CQE_SKIP_SUCCESS;
+			sqe->flags = IOSQE_CQE_SKIP_SUCCESS | IOSQE_IO_LINK;
 
 			sqe = io_uring_get_sqe(&ring);
 			io_uring_prep_send(sqe, send_fd, msg2, strlen(msg2), 0);
 			sqe->user_data = IS_SEND2;
 			sqe->flags = IOSQE_CQE_SKIP_SUCCESS | IOSQE_IO_LINK;
 
+			sqe = io_uring_get_sqe(&ring);
+			io_uring_prep_send(sqe, send_fd, msg3, strlen(msg3), 0);
+			sqe->user_data = IS_SEND2;
+			sqe->flags = IOSQE_CQE_SKIP_SUCCESS | IOSQE_IO_LINK;
+
 			sqe = io_uring_get_sqe(&ring);
 			io_uring_prep_close(sqe, send_fd);
 			sqe->user_data = IS_CLOSE;
-			sqe->flags = IOSQE_CQE_SKIP_SUCCESS | IOSQE_IO_LINK;
+			sqe->flags = IOSQE_CQE_SKIP_SUCCESS;
 			break;
 		case IS_SEND:
 		case IS_SEND2:

