Return-Path: <io-uring+bounces-12640-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uF8JEbeFsWmjCwAAu9opvQ
	(envelope-from <io-uring+bounces-12640-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 16:09:43 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id F1ADF26610E
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 16:09:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6EA2A307F00A
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 15:06:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33C173CF036;
	Wed, 11 Mar 2026 15:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gxlwhJtf"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08503CEBAF;
	Wed, 11 Mar 2026 15:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773241599; cv=none; b=CA8ukcxNKsXuy2fWeQeTJDO6haByKSzARfB8YOvpy+eWdlX0LYfCvmqZW0RiWT1D6KXx5ullfD3XAM1LBikrVG+uxEBx7/vMd2HyksphchDivyilxSzQhnPfCrgnYeZ+ZaKzeHUjeLJDgWhyYCfMdf8hMtJg/Usdb6Uhl+FSbEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773241599; c=relaxed/simple;
	bh=zBo7dnZBqpPdvvQOM0M1QJsAw8E1ZGy2JgdpANolUdM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lq2mQaksxN38WVi4wfzNL5fhO4GS5ljPdW1uUBLddOlEuDbeSTQHFzEhQ9KH2Rz8mo3+NA7PJby/ECkq3ICCo6iLdT+JQxSuUXgy8ScjIE6+NmwGW4VQhZq+GZIVuRGqZOPzJJXfYF5LlhmG7Shc0FcxxIdUVoTFRulJzxSBuE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gxlwhJtf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF21C19424;
	Wed, 11 Mar 2026 15:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773241598;
	bh=zBo7dnZBqpPdvvQOM0M1QJsAw8E1ZGy2JgdpANolUdM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gxlwhJtffN4HWCqfjvu1OelaAxP7oGwgVBp8k3PNppJvfiXJ+kQa/xDm52HZrFCph
	 3icH1rgxdi+fTEFZhelwOmCvhHv5n9Opt2MHrrZ8uCNFlkhx2K7Msrw9PzUQTRxj7b
	 /HNwyE0A8ScMtE/0sXxb9pa96FTA++2Bg7u/8gV12SUsyiEzNBZPt+ef+D/5oKmZIR
	 wBtF0IXEtPdFaQVIXyrH+b0yd9zpz2uEhjiT1p7nzNFVFCJFFgYLiaJpebYZbWVMj9
	 7Lh0r04G0EysCpGg9A8MB+TXd17awvRnb74zb8iqUYg1kA4t6H0Sf+PwjNUi5yXgvL
	 YSydxfyXY7BZw==
Date: Wed, 11 Mar 2026 09:06:36 -0600
From: Keith Busch <kbusch@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com, naup96721@gmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] io_uring: ensure ctx->rings is stable for task work
 flags manipulation
Message-ID: <abGE_CLo4vW_-Tkh@kbusch-mbp>
References: <20260311131336.197028-1-axboe@kernel.dk>
 <20260311131336.197028-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311131336.197028-2-axboe@kernel.dk>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12640-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kbusch@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: F1ADF26610E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Mar 11, 2026 at 07:11:55AM -0600, Jens Axboe wrote:
> +/*
> + * Sets IORING_SQ_TASKRUN in the sq_flags shared with userspace, using the
> + * RCU protected rings pointer to be safe against concurrent ring resizing.
> + * Must be called inside an RCU read-side critical section.

You can make the rcu requirement explicit in the code with:

	ASSERT(rcu_read_lock_held());

And debug kernels will catch misuse, too.

> + */
> +static void io_ctx_mark_taskrun(struct io_ring_ctx *ctx)
> +{
> +	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG) {
> +		struct io_rings *rings = rcu_dereference(ctx->rings_rcu);
> +
> +		atomic_or(IORING_SQ_TASKRUN, &rings->sq_flags);
> +	}
> +}

