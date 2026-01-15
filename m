Return-Path: <io-uring+bounces-11745-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1022BD27C33
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 19:48:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 62D9430F8212
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 18:21:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8CD42D595B;
	Thu, 15 Jan 2026 18:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mVthOLXk"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47D72D3733;
	Thu, 15 Jan 2026 18:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768501303; cv=none; b=s9TV/Etui5W7avdh1eM6YWqJHAE1focO8QSyRWFEYqhGvxcmP3Zf9hkwUwr+WG+eVCDZBEqcyDZQhRa84A7Yb1aOS9SiDdLPB+VNqQeszVTEmIE2E9l1+NqWsbcWawhFQGHu/XfaHX0lyc+E0mrrYUeXENf5It/yM3iD/E2CfXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768501303; c=relaxed/simple;
	bh=yR3QzVoL1IJHeU1OqKqCoLa2vLvGzDQAKtL+ewzlkTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JsKttKmS+1ZVa1n+SMKSo6BV0wc6rDhbWPtQ7ax4ktGILrQ1Kn3+ttIG8R0gMJgNvFUQnFkh4cPFz1rNVbsDZU/4RegOsPowOkPshQMopnBB4Au4pAYrA6EhWb1JaF34ZFebItrpt7MrzNAThq8gwc2OXaBjrfFSRrR968OMheg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mVthOLXk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFCBC116D0;
	Thu, 15 Jan 2026 18:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768501303;
	bh=yR3QzVoL1IJHeU1OqKqCoLa2vLvGzDQAKtL+ewzlkTg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mVthOLXklUl2f6KXBLJCyV1BuvyOv27suSNDNvnMQjRcSebj6z9D+653aMYUAnnJr
	 4kZoSxg5MwWTQLFUDBpEy3jpWuZWxwn044wzXkDEHIJHNWkj1cCF/Az6yZKjRcxpMh
	 6iPDPTvHI4RQf7EjpG5DfpeQjbArY9FhqzbzPYPz4kiaA+KXsvHSiNPhF+1Pjo+vXn
	 kYIzHTFODod4zrnTmWbGFNVdql1Q5YdQ/0cWSQfexUaePd8bbNhy1mbHvLhSPbycSt
	 8tweF0dbd55VpbOqPeSZU+KKOKEAu0lgS0MpSXnNiky3YZzwQCiKoKLwF/B3lKJaWX
	 lWLVy5RD/KKdg==
Date: Thu, 15 Jan 2026 11:21:41 -0700
From: Keith Busch <kbusch@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH] nvme: optimize passthrough IOPOLL completion for local
 ring context
Message-ID: <aWkwNVgAyBbx732l@kbusch-mbp>
References: <20260115085952.494077-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115085952.494077-1-ming.lei@redhat.com>

On Thu, Jan 15, 2026 at 04:59:52PM +0800, Ming Lei wrote:
> +	if (blk_rq_is_poll(req) && req->poll_ctx == io_uring_cmd_ctx_handle(ioucmd)) {

...

> @@ -677,8 +691,14 @@ int nvme_ns_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd,
>  	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
>  	struct request *req = pdu->req;
>  
> -	if (req && blk_rq_is_poll(req))
> +	if (req && blk_rq_is_poll(req)) {
> +		/*
> +		 * Store the polling context in the request so end_io can
> +		 * detect if it's completing in the local ring's context.
> +		 */
> +		req->poll_ctx = iob ? iob->poll_ctx : NULL;

I don't think this works. The io_uring polling always polls from a
single ctx's iopoll_list, so it's redundant to store the ctx in the iob
since it will always match the ctx of the ioucmd passed in.

Which then leads to the check at the top: if req->poll_ctx was ever set,
then it should always match its ioucmd ctx too, right? If it was set
once before, but the polling didn't find the completion, then another
ctx polling does find it, we won't complete it in the iouring task as
needed.

I think you want to save off ctx that called
'nvme_ns_chr_uring_cmd_iopoll()', but there doesn't seem to be an
immediate way to refer back to that from 'nvme_uring_cmd_end_io'. Maybe
stash it in current->io_uring->last instead, then check if
io_uring_cmd_ctx_handle(ioucmd)) equals that.

