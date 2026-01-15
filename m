Return-Path: <io-uring+bounces-11727-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A85ACD220EF
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 02:44:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CC32E3019E20
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 01:44:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7CA521CC5A;
	Thu, 15 Jan 2026 01:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K9K1sEir"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D51B2745C
	for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 01:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768441485; cv=none; b=EedmzyHTnfLH9eMVEg5Mdn4JNrjC+4cnqJ1tk6Y0dRpjygtPuxvp7eIb9VhOpOidFPTRGhxk9roCostKGlaKCp7SGNNc/mq9t57wMtpnfG2skTt8PeOtRISFgZn9b0JAjqlqABKizXZRM6/S7W0oDXEZPn52551uZW7NpzlpVlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768441485; c=relaxed/simple;
	bh=qG1i5S5GlRTcqkcAmTsEvilYfnXL4TMweWxPAXSDuCc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FCywFgtUxwhE1//8ZRahXqfO9n9aHFXuXIRNIHTMUT/PhRt+WQDjFEn1uD77dhg2wzlWFERZ55lSUafhFXRZCYd1OdpIBAO4W5G1yir+CBB9TLf3XLN/S9otE6wpJjDNbvdwP1BUuLXurePEtp5nqFZu8FbE/631aX65ohdM/uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K9K1sEir; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768441483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CofeJKXrVpQP3buCN08MSu8YNj1eGt2aIwSC4F04Z/0=;
	b=K9K1sEirqre1XywyVld8UJwXKUcV5g1o7nyKQHWECFMylsE6ZAUoOK1JBp5B0pMwZRvEpN
	c0Mwh2uQGEuQKxjKYHkZVbCgiL723RblSuZSHCWyoSeigbJRNP6HKQBV6k5Fg2X1kB8seL
	LlvY8T+bLaENeIsTVXNd+jQW+b/5vwU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-115-oKuSQpKJPimkyo5ezIXSSQ-1; Wed,
 14 Jan 2026 20:44:41 -0500
X-MC-Unique: oKuSQpKJPimkyo5ezIXSSQ-1
X-Mimecast-MFC-AGG-ID: oKuSQpKJPimkyo5ezIXSSQ_1768441480
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 707711956054;
	Thu, 15 Jan 2026 01:44:40 +0000 (UTC)
Received: from fedora (unknown [10.72.116.198])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 22EBC30002DC;
	Thu, 15 Jan 2026 01:44:37 +0000 (UTC)
Date: Thu, 15 Jan 2026 09:44:33 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring/uring_cmd: explicitly disallow cancelations for
 IOPOLL
Message-ID: <aWhGgQ2XjTrZGjQi@fedora>
References: <636afbe3-d547-49da-aeaf-7da56e28608c@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <636afbe3-d547-49da-aeaf-7da56e28608c@kernel.dk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Wed, Jan 14, 2026 at 08:52:31AM -0700, Jens Axboe wrote:
> This currently isn't supported, and due to a recent commit, it also
> cannot easily be supported by io_uring due to hash_node and IOPOLL
> completion data overlapping.
> 
> This can be revisited if we ever do support cancelations of requests
> that have gone to the block stack.
> 
> Suggested-by: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 197474911f04..ee7b49f47cb5 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -104,6 +104,15 @@ void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
>  	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
>  	struct io_ring_ctx *ctx = req->ctx;
>  
> +	/*
> +	 * Doing cancelations on IOPOLL requests are not supported. Both
> +	 * because they can't get canceled in the block stack, but also
> +	 * because iopoll completion data overlaps with the hash_node used
> +	 * for tracking.
> +	 */
> +	if (ctx->flags & IORING_SETUP_IOPOLL)
> +		return;

Maybe better to add warn_on_once(), but not a big deal, anyway:

Reviewed-by: Ming Lei <ming.lei@redhat.com>


Thanks,
Ming


