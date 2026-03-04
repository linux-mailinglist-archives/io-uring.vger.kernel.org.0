Return-Path: <io-uring+bounces-12551-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QLwoMH4LqGn2nQAAu9opvQ
	(envelope-from <io-uring+bounces-12551-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 04 Mar 2026 11:37:50 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 248991FE756
	for <lists+io-uring@lfdr.de>; Wed, 04 Mar 2026 11:37:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DD1B53028B0C
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2026 10:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95A453A2570;
	Wed,  4 Mar 2026 10:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XV4R1Sz3"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F183A2548
	for <io-uring@vger.kernel.org>; Wed,  4 Mar 2026 10:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772620385; cv=none; b=sic5ubd01AHBDBQ8zURhUj2SgIUle5qo9xIguebXXPWhIXwCVESgIMn7vAKhnWvGo6t3PJOXo91d/P+rLuBmggBuBjWFC1yBAdVCTvFvutm0kVFJhKOOItGfVNXgDGdiPaUALTb8Hn2TeHCm+MpB0yx9C28BBqywIelGH8Z/JU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772620385; c=relaxed/simple;
	bh=3Q81G1UaENIs0YDiv1zAYxSveV6EXuSxHm4u7nx1bzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lWy3RrhNahy7nE695GliHX/XNzstUsScmQCYNsAUmc6qQQafl3EYPschwyZaG/z59X+w7ztGZW72asEYz/LuHj4zmOvh2iOoGt2LhxREOTFuvT7Hs2CeUDDhz98Hhg43fW0Dq80niMbPlEro47EQwuNFi2DOn4CAbFYg6lZus9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XV4R1Sz3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772620383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6c9L5RtHp8CSPnp5zZyBQRyYeXPW3aEtn53qvsfLHHk=;
	b=XV4R1Sz3ntqaCQLOZnTJXY3rBJct84gw8PPAZPnejZJPgUlnjXsBXmksRqAB3soXr7bZ+/
	h068L3cRMrl8r6flgNunpEb78PNj088CdS0BHlmK0Z0mm2mcZWhOl5gra2YoB3EERQASk3
	gBfvEHo35Avc2rsgJ1vzYvdyJc1itdo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-74-TfJoT7MpPLuVRyYeA_WI_Q-1; Wed,
 04 Mar 2026 05:32:59 -0500
X-MC-Unique: TfJoT7MpPLuVRyYeA_WI_Q-1
X-Mimecast-MFC-AGG-ID: TfJoT7MpPLuVRyYeA_WI_Q_1772620378
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 65F251956096;
	Wed,  4 Mar 2026 10:32:57 +0000 (UTC)
Received: from fedora (unknown [10.72.116.5])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D582E195608E;
	Wed,  4 Mar 2026 10:32:50 +0000 (UTC)
Date: Wed, 4 Mar 2026 18:32:45 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v5 3/5] io_uring: count CQEs in io_iopoll_check()
Message-ID: <aagKTanM5Az9UDsJ@fedora>
References: <20260302172914.2488599-1-csander@purestorage.com>
 <20260302172914.2488599-4-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302172914.2488599-4-csander@purestorage.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Queue-Id: 248991FE756
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
	TAGGED_FROM(0.00)[bounces-12551-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ming.lei@redhat.com,io-uring@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,purestorage.com:email]
X-Rspamd-Action: no action

On Mon, Mar 02, 2026 at 10:29:12AM -0700, Caleb Sander Mateos wrote:
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
>  io_uring/io_uring.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 46f39831d27c..b4625695bb3a 100644
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
> @@ -1227,34 +1226,30 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int min_events)
>  		 * the poll to the issued list. Otherwise we can spin here
>  		 * forever, while the workqueue is stuck trying to acquire the
>  		 * very same mutex.
>  		 */
>  		if (list_empty(&ctx->iopoll_list) || io_task_work_pending(ctx)) {
> -			u32 tail = ctx->cached_cq_tail;
> -
>  			(void) io_run_local_work_locked(ctx, min_events);
>  
>  			if (task_work_pending(current) || list_empty(&ctx->iopoll_list)) {
>  				mutex_unlock(&ctx->uring_lock);
>  				io_run_task_work();
>  				mutex_lock(&ctx->uring_lock);
>  			}
>  			/* some requests don't go through iopoll_list */
> -			if (tail != ctx->cached_cq_tail || list_empty(&ctx->iopoll_list))
> +			if (list_empty(&ctx->iopoll_list))
>  				break;
>  		}
>  		ret = io_do_iopoll(ctx, !min_events);
>  		if (unlikely(ret < 0))
>  			return ret;
>  
>  		if (task_sigpending(current))
>  			return -EINTR;
>  		if (need_resched())
>  			break;
> -
> -		nr_events += ret;
> -	} while (nr_events < min_events);
> +	} while (io_cqring_events(ctx) < min_events);

Before entering the loop, if io_cqring_events() finds any queued CQE,
io_iopoll_check() returns immediately without polling.

If the queued CQE is originated from non-iopoll uring_cmd, iopoll request
will not be polled, may this be one issue?


Thanks,
Ming


