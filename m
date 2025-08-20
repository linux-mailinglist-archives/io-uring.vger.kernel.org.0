Return-Path: <io-uring+bounces-9105-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 47A71B2E166
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 17:44:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F48D3A332D
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 15:39:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 315D32C11EE;
	Wed, 20 Aug 2025 15:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YlLf3CCZ"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E332BE655
	for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 15:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755704367; cv=none; b=Al6a2eg2lI8Oi51ctRaKAs9Kw6tE5af5ZCmZlrF3Iv7pmTxCq4aTyLskoGMjD82RcJvSw+RaK09wynBmP2ZHCfVeZVaJb8tUahwz1EGaMrCJQVTkZzQnBoxQxHaZPhcha30LlSTc/hCKP0FxbU6R2J1EJxRY0QrHkTFuJBxiQns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755704367; c=relaxed/simple;
	bh=R3TnhCDAAbnKT6t2gm5bSFJdc1pjdVoK5PVJ6xqvJM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ImQS7TQq2cPOGItieM/SiK+46Z5oN3ie60LcV6HQ5IqvszxUCyfBZtaHFJ2G0UUYoJqqA6RMi5P1pcqMntQr1RHVlp/HXEuJFyqItjSIIubjZkTiaeq8u9Ib6lEAbdAUMe8HjWxoaCCduCkDZ7CPYA4hEqS1r/7JP38zv5ASm8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YlLf3CCZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755704364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9oAbsVcBTxAoG3afdRCsnhfH8iAs2qh/nX3NvQ2mP4I=;
	b=YlLf3CCZt+M4zGuM7BEQmYZjGqxZBLPw9lwkicfs2bAIumqvwTWbrSUaXbRw6b/KRNXaDc
	bVM/1JJ2qIuRyb6pYtp/DeLBZdwioA6L6/1kz7Hg4hGWCj9UwafQHhfeSoRh2wC1uPY1iZ
	9orhTtfpyRc9C0GP920CeqHucqOf/E8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-376-Nq5rwr9HOC2_ylTZbXzH3w-1; Wed,
 20 Aug 2025 11:39:19 -0400
X-MC-Unique: Nq5rwr9HOC2_ylTZbXzH3w-1
X-Mimecast-MFC-AGG-ID: Nq5rwr9HOC2_ylTZbXzH3w_1755704358
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 66B5D19774FB;
	Wed, 20 Aug 2025 15:39:18 +0000 (UTC)
Received: from fedora (unknown [10.72.116.9])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 92DAD180035C;
	Wed, 20 Aug 2025 15:39:13 +0000 (UTC)
Date: Wed, 20 Aug 2025 23:39:08 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: Re: [PATCH V3] io_uring: uring_cmd: add multishot support
Message-ID: <aKXsHNDK83QCv3rm@fedora>
References: <20250819150040.980875-1-ming.lei@redhat.com>
 <1155b8b0-d5d0-4634-984b-71d246932af7@kernel.dk>
 <aKWssZvQT-Wb-AJA@fedora>
 <8150569b-146e-4d16-86b9-5d53fa6b7e92@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8150569b-146e-4d16-86b9-5d53fa6b7e92@kernel.dk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Wed, Aug 20, 2025 at 07:11:52AM -0600, Jens Axboe wrote:
> On 8/20/25 5:08 AM, Ming Lei wrote:
> > On Tue, Aug 19, 2025 at 10:00:36AM -0600, Jens Axboe wrote:
> >> On 8/19/25 9:00 AM, Ming Lei wrote:
> >>> @@ -251,6 +265,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
> >>>  	}
> >>>  
> >>>  	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
> >>> +	if (ioucmd->flags & IORING_URING_CMD_MULTISHOT) {
> >>> +		if (ret >= 0)
> >>> +			return IOU_ISSUE_SKIP_COMPLETE;
> >>> +		io_kbuf_recycle(req, issue_flags);
> >>> +	}
> >>>  	if (ret == -EAGAIN) {
> >>>  		ioucmd->flags |= IORING_URING_CMD_REISSUE;
> >>>  		return ret;
> >>
> >> Final comment on this part... uring_cmd is unique in the sense that it'd
> >> be the first potentially pollable file type that supports buffer
> >> selection AND can return -EIOCBQUEUED. For non-pollable, the buffer
> >> would get committed upfront. For pollable, we'd either finish and put it
> >> within this same execution context, or we'd drop it entirely when
> >> returning -EAGAIN.
> >>
> >> So what happens if we get -EIOCBQUEUED with a selected buffer from
> >> provided buffer ring, and someome malicious unregisters and frees the
> >> buffer ring before that request completes?
> > 
> > Looks one real trouble for IORING_URING_CMD_MULTISHOT.
> > 
> > For pollable multishot, ->issue() is run in submitter tw context, and done
> > in `sync` style, so ctx->uring_lock protects the buffer list, and
> > unregister can't happen. That should be one reason why polled multishot
> > can't be run in io-wq context.
> > 
> > But now -EIOCBQUEUED is returned from ->issue(), we lose ->uring_lock's
> > protection for req->buf_list, one idea could be adding referenced buffer
> > list for failing unregister in case of any active consumer.
> > 
> > Do you have suggestions for this problem?
> 
> Just commit the buffer upfront, rather than grab it at issue time and
> commit when you get the completion callback? Yes that will pin the
> buffer for the duration of the IO, but that should not be an issue,
> nobody else can use it anyway. Avoiding the pin for pollable files with
> potentially infinite IO times (eg pipe that never gets written to, or
> socket that never gets data) is a key concept for those kinds of
> workloads, but for finite completion times or single use cases like
> yours here, that doesn't really matter.

OK, I will send V4 with documenting "commit the buffer upfront" usage.

> 
> I've got a bit of a side project making the provided buffer selection a
> bit more foolproof in the sense that it makes it explicit that the scope
> of it is the issue context, but across executions. One current problem
> is req->buf_list, which for provided buffer rings really is local scope,
> yet it's in the io_kiocb. I'll be moving that somewhere else and out of
> io_kiocb. Just a side note, because it's currently easy to get this
> wrong even if you know what you are doing, as per your patch.

Thanks for the clarification!


Thanks,
Ming


