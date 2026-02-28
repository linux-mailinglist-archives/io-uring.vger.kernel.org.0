Return-Path: <io-uring+bounces-12483-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sO/uKnm5omnZ5AQAu9opvQ
	(envelope-from <io-uring+bounces-12483-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 28 Feb 2026 10:46:33 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 326F61C1CD8
	for <lists+io-uring@lfdr.de>; Sat, 28 Feb 2026 10:46:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A0AB5304C7FF
	for <lists+io-uring@lfdr.de>; Sat, 28 Feb 2026 09:46:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E855740FD97;
	Sat, 28 Feb 2026 09:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y7yL19iN"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA8F40B6D2
	for <io-uring@vger.kernel.org>; Sat, 28 Feb 2026 09:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772271977; cv=none; b=A5K/wT1q+yeAl52dXRJclnMbWxcYGIxbGzgTfGwPtyPAV8eXBk7VrDgFpw74rJGMguhVdMHCdAdMjog/6ul9rpjr7dDo83H/sYxArhzJPGNvea9SIVSoC2DNFxCRqLzLn0u4y+12SFqWEvfQPIkaQjrbhgV8JALiyaRTvSVNRTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772271977; c=relaxed/simple;
	bh=WnWzNq9DiOWuHhN5cpoJ0i/sZD0QJ7Jw+sxbse9Yn3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S8yFEYWhd/vNMoh3FJ3/eWpNMusNbXYq65MsY2YQOHqWpE/2JVcQ2BxIqnEFEF5yr56Zovy1+pkozFy4QlddUxSy2KjF1T64Yhtra1zn4pYe5LXcmufpE5n95p5WkWUCdSaPgbPoFoXNPljYL0B28zsBdeETD1rqeKFSv5aQzTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y7yL19iN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772271974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TKa9ExoJrCcyxe887LgwD6P4LJ/v9g4RnssVwA0or+A=;
	b=Y7yL19iNSUDCtUAs5DGlBYV1IZA2Rjr+AIG+IwuTdf9dgiOoDb+7/tnS37uetJQZCtunGz
	TIZ0TmDSMDou58XbELQ2isqmDoeeGITO7oS+HxOPrdC5ISjUJVDJGfo+Dr40dkOWnpt30o
	YG35MrPi3Beus2VD+xBMAiHjtSLg4OU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-376-Hl12rc4MPT6J_CtYXnIOyQ-1; Sat,
 28 Feb 2026 04:46:10 -0500
X-MC-Unique: Hl12rc4MPT6J_CtYXnIOyQ-1
X-Mimecast-MFC-AGG-ID: Hl12rc4MPT6J_CtYXnIOyQ_1772271969
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0AE861956080;
	Sat, 28 Feb 2026 09:46:08 +0000 (UTC)
Received: from fedora (unknown [10.72.116.144])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 15AE119560B5;
	Sat, 28 Feb 2026 09:46:00 +0000 (UTC)
Date: Sat, 28 Feb 2026 17:45:56 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v4 3/5] io_uring: count CQEs in io_iopoll_check()
Message-ID: <aaK5VIfPR9fOil39@fedora>
References: <20260227223504.1162421-1-csander@purestorage.com>
 <20260227223504.1162421-4-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227223504.1162421-4-csander@purestorage.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12483-lists,io-uring=lfdr.de];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ming.lei@redhat.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 326F61C1CD8
X-Rspamd-Action: no action

On Fri, Feb 27, 2026 at 03:35:01PM -0700, Caleb Sander Mateos wrote:
> A subsequent commit will allow uring_cmds that don't use iopoll on
> IORING_SETUP_IOPOLL io_urings. As a result, CQEs can be posted without
> setting the iopoll_completed flag for a request in iopoll_list or going
> through task work. For example, a UBLK_U_IO_FETCH_IO_CMDS command could
> call io_uring_mshot_cmd_post_cqe() to directly post a CQE. The
> io_iopoll_check() loop currently only counts completions posted in
> io_do_iopoll() when determining whether the min_events threshold has
> been met. It also exits early if there are any existing CQEs before
> polling, or if any CQEs are posted while running task work. CQEs posted
> via io_uring_mshot_cmd_post_cqe() or other mechanisms won't be counted
> against min_events.
> 
> Explicitly check the available CQEs in each io_iopoll_check() loop
> iteration to account for CQEs posted in any fashion.
> 
> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> ---
>  io_uring/io_uring.c | 18 +++---------------
>  1 file changed, 3 insertions(+), 15 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 46f39831d27c..5f694052f501 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1184,11 +1184,10 @@ __cold void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
>  		io_move_task_work_from_local(ctx);
>  }
>  
>  static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int min_events)
>  {
> -	unsigned int nr_events = 0;
>  	unsigned long check_cq;
>  
>  	min_events = min(min_events, ctx->cq_entries);
>  
>  	lockdep_assert_held(&ctx->uring_lock);
> @@ -1205,19 +1204,12 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int min_events)
>  		 * dropped CQE.
>  		 */
>  		if (check_cq & BIT(IO_CHECK_CQ_DROPPED_BIT))
>  			return -EBADR;
>  	}
> -	/*
> -	 * Don't enter poll loop if we already have events pending.
> -	 * If we do, we can potentially be spinning for commands that
> -	 * already triggered a CQE (eg in error).
> -	 */
> -	if (io_cqring_events(ctx))
> -		return 0;
>  
> -	do {
> +	while (io_cqring_events(ctx) < min_events) {

It may not handle zero `min_events` correctly, please see AI review result:

https://netdev-ai.bots.linux.dev/ai-review.html?id=6977b6d6-04e4-4990-a96f-b7580fc5acc4

Thanks,
Ming


