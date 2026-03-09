Return-Path: <io-uring+bounces-12607-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GFc6Guk8r2mDSgIAu9opvQ
	(envelope-from <io-uring+bounces-12607-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 22:34:33 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F06F2241C38
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 22:34:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9AA36311D661
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2026 21:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79196349AF5;
	Mon,  9 Mar 2026 21:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AaEplu1F"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567132BE02A
	for <io-uring@vger.kernel.org>; Mon,  9 Mar 2026 21:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773091800; cv=none; b=b2fGIYTZEOOiO4e/Bv40KW2VKAmwVsgFFG44ZfRG/iFfThDDLkJ/D7IhXt7Y/pcZIjeuo7pfWaU+FSfkBCzjbpZnJtZs6knY8wValJFCYrFAcuN+ywa3raRsIyrt2M1xAnA+rzSxy1fkuPQ2zr5RvksESzQG8wZiBW/FzKCASHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773091800; c=relaxed/simple;
	bh=yOthx7vwFYX9FFCIqixEbMaDpRVC0jfZyVPz6e0+piU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UUv8vh2WczxdEqi4yhlBzZiZiPVN/4+axFM5oYM4dkUI7QJyXVqdd2KPjT+nFLtrxegOqM7h23ZHaKzySnSrLAwAvCpRwO4um5tHCQn8IQl3eaTX9CLUcXgVnzaqU8o1WPtIf9IVPs5tskskkIjqP/flhf9OETKZANyq7BLufms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AaEplu1F; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1869C2BC87;
	Mon,  9 Mar 2026 21:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773091800;
	bh=yOthx7vwFYX9FFCIqixEbMaDpRVC0jfZyVPz6e0+piU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AaEplu1FXrLT+1ULrPoX/xe1RJpQFKObdnmAuwbcxAvfr+zxuqeNP59ENsjEmcuPy
	 rvhO5R/hUOHY2ySXQIz8PII3g/vTEhxvuQ89HjcLxxXa0p8r4CxJJCjOCiTQD6UwRL
	 v340q/VdRMpLSK/E4cVRMymOxw71VGpDdBrGoPvTH5KlxCVXTL3we+BbVcXVm9yQRK
	 6LAJo70BXiXAf4FD/LCglD0+7PdahpFqiWnbtumEmCwl/Qugu6kmaVrhF8JvTucOLN
	 pgn2nvB5BwEOuO7Q+7Q0CUSIqZgf3gvuhChNXzOM/rs+vvUN6z3SM7khoc4AZPvFl4
	 4f7oTzbDfscCw==
Date: Mon, 9 Mar 2026 15:29:57 -0600
From: Keith Busch <kbusch@kernel.org>
To: Tom Ryan <ryan36005@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Greg KH <gregkh@linuxfoundation.org>
Subject: Re: io_uring: OOB read in SQE_MIXED mode via sq_array physical index
 bypass
Message-ID: <aa871Xk0EHzDxOd6@kbusch-mbp>
References: <CAJuauuPNcDAAzjzVjOE_sNcUT5FX6dwcV9o=hLC6ZaQkkZ72Pg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuauuPNcDAAzjzVjOE_sNcUT5FX6dwcV9o=hLC6ZaQkkZ72Pg@mail.gmail.com>
X-Rspamd-Queue-Id: F06F2241C38
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12607-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kbusch@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Mar 09, 2026 at 02:20:38PM -0700, Tom Ryan wrote:
> Patch attached.

You can just submit the patch as text in the mail message.

> @@ -1747,6 +1747,9 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>  		if (!(ctx->flags & IORING_SETUP_SQE_MIXED) || *left < 2 ||
>  		    !(ctx->cached_sq_head & (ctx->sq_entries - 1)))
>  			return io_init_fail_req(req, -EINVAL);
> +		/* Validate physical SQE index has room for 128-byte read */
> +		if ((unsigned)(sqe - ctx->sq_sqes) >= ctx->sq_entries - 1)
> +			return io_init_fail_req(req, -EINVAL);

Isn't this new check redundant with the "left < 2" check preceding it?

