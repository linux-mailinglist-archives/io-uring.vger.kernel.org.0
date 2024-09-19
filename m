Return-Path: <io-uring+bounces-3237-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2600897CD96
	for <lists+io-uring@lfdr.de>; Thu, 19 Sep 2024 20:32:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 62B4CB221D5
	for <lists+io-uring@lfdr.de>; Thu, 19 Sep 2024 18:32:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CFA1AD21;
	Thu, 19 Sep 2024 18:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="euAjBWOG";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="RRmxVH8h"
X-Original-To: io-uring@vger.kernel.org
Received: from fout6-smtp.messagingengine.com (fout6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BA46FB6
	for <io-uring@vger.kernel.org>; Thu, 19 Sep 2024 18:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726770720; cv=none; b=bk/ap9GGKEBOw1N6ou9ChilnLvnauuMvj/vyy1pvPyFMkKwiuZTm9mBUEng/ZOzeADpAz5XfIwFfgZxeFalfz1hcUajN5Nw7eTMAFjJepAGUtLRjndt7UJJ+3dK7o1bPoblmxNiTIUahjZ6vDcmkE0+M6lnG98JvY/NOZowsMbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726770720; c=relaxed/simple;
	bh=Nv7HzrTK10smqIXx076UC7oXXr32jOWW9vGatE0kSAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A2BxzFV8sq8PrlCatbZ3bf6K/ncfwICv5sQk8/Gg54Kbrwe7p8K755kLAZEF91MIgELrlYA/P1hXVtY1iY2ixG9luhq20Nby/lE+wD84r7/wDZEBGWJUS1sdRl8pla+Ze2KRg0oVsNJXVNjNUS3hNoxmKHgIS/6sno/pcE8cbtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=euAjBWOG; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=RRmxVH8h; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Received: from phl-compute-07.internal (phl-compute-07.phl.internal [10.202.2.47])
	by mailfout.phl.internal (Postfix) with ESMTP id 884A01380226;
	Thu, 19 Sep 2024 14:31:57 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Thu, 19 Sep 2024 14:31:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1726770717; x=1726857117; bh=kfz18cfD1O
	MIqqVDw32v2QoRAIUjiR6PywNayR1+GeA=; b=euAjBWOG9iWx0ua1vI8CpZw9bX
	2hn041uCWTQrNLMjoQVyZbBlr8CfesE+MlaQXh5GgM9CKNo/CreTn7OWFszEqsVw
	MUrxjAVKBhEGac7CDb1otc4921XyadTr0g7cHe5TKOZI1/FPFB58pkMLE8C3Z+o4
	NbcFM7HcWlaXAdBjvS4uEBu8hMV1Mnqqc1QwhwvKDuAXOYN3tovFSd88ux0pDCF2
	nc0ta4YVyFfY8wUbnyEfF4I19Alzv/9oGBBz1BJBWnOuwYmHpgeqRYjrTcAUQyXN
	necCaQPWJr7yqfrIv4cGDfL9ZobPghsgPJrdWa2QHcPQdB+HOm+XX56KKXkQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1726770717; x=1726857117; bh=kfz18cfD1OMIqqVDw32v2QoRAIUj
	iR6PywNayR1+GeA=; b=RRmxVH8hu18lnj/4/qgyYp4OSUDtVJF6iKHirz+3UNvF
	uYu2ihP6nm/ZVlZPrlo8tCMY09R4zdlh/WxmC8zSTU8sLPP1nmKY8taQR8+sqPJ6
	Cd8+RttoprtHrCVGqHNPRT8m0zHMqtOGXxItGKPNYQ2TGaIDL7gmFKbyZr083+Sd
	rIEhZ+L11C/NVlTinsfKQmeOy0uMr2nlRpQGUvdvH/Q2hzfOZD5jn8yWXiYZUSgo
	XEyHaCobjh3072z3F30I3MxlVFydys49BrBMaCSy+JqbVHFBmZcU56nLi83gvyvp
	XsV6YrInjqU5ykqUXpwGW0z/puLf8EH+zAbduyhxsw==
X-ME-Sender: <xms:HW7sZvPUwPga400FqbnAmnVoZZ5haRDrbp_uzK4ROoSLpkVpCnY3FA>
    <xme:HW7sZp8ZZ3twjCJhkKi3Ljh9qgy_CHjdKoqqfEK2Ni1Sf1WN5rCB-hUMnwrkqXG3V
    BYiR5gK0m3T8H_lcbE>
X-ME-Received: <xmr:HW7sZuQa36Pm762FzwmKcsx3KNebQSeOv34yc5iDxuJYQVPvdqtjeYH2gBcf1Ft-6wyG48X3IGuZRpx9tE1epG2W0l68>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudeluddguddviecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:HW7sZju3Ov9sSgBocJQ2w9Ha4ledkqz6Wbc-Z1X_fb8-gnIsK2Uvlw>
    <xmx:HW7sZnfKRr2-1APdNL-hg4USpeYXouCWaL6c2x0nofSUOl-9rNIDwg>
    <xmx:HW7sZv26pYnrITXjgM15K_gbuSwv4x0kay3cieqs3ZuQ06MRiUKEkQ>
    <xmx:HW7sZj99abuqtmlxVB6Ts9gbuEsXUUIrUHzJe5hDkBrOFkfV319JnA>
    <xmx:HW7sZj6jubxwWzquiM3MgYgDVaQJUfgGQeeOtpleMbKUfrFE4iOhqGKV>
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Sep 2024 14:31:56 -0400 (EDT)
Date: Thu, 19 Sep 2024 20:31:55 +0200
From: Jan Hendrik Farr <kernel@jfarr.cc>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring: run normal task_work AFTER local work
Message-ID: <ZuxuGwU172K2-Pik@archlinux>
References: <8e3894e3-2609-4233-83df-1633fba7d4dd@kernel.dk>
 <6e445fe1-9a75-4e50-aa70-514937064e64@gmail.com>
 <5ac3973b-fbbd-4a49-babb-6d2e3e8333f7@kernel.dk>
 <ZuxVpEjXoJrkTp-F@archlinux>
 <ed1cc6ec-eb5d-495c-bd99-3a0eb634f9ff@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed1cc6ec-eb5d-495c-bd99-3a0eb634f9ff@kernel.dk>

On 19 12:06:20, Jens Axboe wrote:
> On 9/19/24 10:47 AM, Jan Hendrik Farr wrote:
> >> [...]
> >>
> >> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> >> index 75f0087183e5..56097627eafc 100644
> >> --- a/io_uring/io_uring.c
> >> +++ b/io_uring/io_uring.c
> >> @@ -2472,7 +2472,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
> >>  		return 1;
> >>  	if (unlikely(!llist_empty(&ctx->work_llist)))
> >>  		return 1;
> >> -	if (unlikely(test_thread_flag(TIF_NOTIFY_SIGNAL)))
> >> +	if (unlikely(task_work_pending(current)))
> >>  		return 1;
> >>  	if (unlikely(task_sigpending(current)))
> >>  		return -EINTR;
> >> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> >> index 9d70b2cf7b1e..2fbf0ea9c171 100644
> >> --- a/io_uring/io_uring.h
> >> +++ b/io_uring/io_uring.h
> >> @@ -308,15 +308,17 @@ static inline int io_run_task_work(void)
> >>  	 */
> >>  	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
> >>  		clear_notify_signal();
> >> +
> >> +	if (test_thread_flag(TIF_NOTIFY_RESUME)) {
> >> +		__set_current_state(TASK_RUNNING);
> >> +		resume_user_mode_work(NULL);
> >> +	}
> >> +
> >>  	/*
> >>  	 * PF_IO_WORKER never returns to userspace, so check here if we have
> >>  	 * notify work that needs processing.
> >>  	 */
> >>  	if (current->flags & PF_IO_WORKER) {
> >> -		if (test_thread_flag(TIF_NOTIFY_RESUME)) {
> >> -			__set_current_state(TASK_RUNNING);
> >> -			resume_user_mode_work(NULL);
> >> -		}
> >>  		if (current->io_uring) {
> >>  			unsigned int count = 0;
> >>  
> >>
> > 
> > Can confirm that also this patch fixes the issue on my end (both with the
> > reordering of the task_work and without it).
> 
> Great, thanks for testing! Sent out a v2. No need to test it unless you
> absolutely want to ;-)
> 
> > Also found a different way to trigger the issue that does not misuse
> > IOSQE_IO_LINK. Do three sends with IOSQE_CQE_SKIP_SUCCESS | IOSQE_IO_LINK
> > followed by a close with IOSQE_CQE_SKIP_SUCCESS on a ring with
> > IORING_SETUP_DEFER_TASKRUN.
> > 
> > I confirmed that that test case also first brakes on
> > 846072f16eed3b3fb4e59b677f3ed8afb8509b89 and is fixed by either of the
> > two patches you sent.
> > 
> > Not sure if that's a preferable test case compared to the weirder ealier one.
> > You can find it below as a patch to the existing test case in the liburing
> > repo:
> 
> I think that's an improvement, just because it doesn't rely on a weird
> usage of IOSQE_IO_LINK. And it looks good to me - do you want me to
> commit this directly, or do you want to send a "proper" patch (or github
> PR) to retain the proper attribution to you?
> 

Sent the PR with one minor change (adjusted the user data for the third
send).


