Return-Path: <io-uring+bounces-9096-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5000B2DA90
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 13:08:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 866663AD6E6
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 11:08:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 731C8EEDE;
	Wed, 20 Aug 2025 11:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="chMZbffa"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCBF2E0B45
	for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 11:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755688129; cv=none; b=B17uu3nFjwY3nN/zHsPIa1NyM4euJRfYOlDJG5su0pEcoKOWQOujjal0TGowMDBI6ZH5vohqZ4vPllNAAayFJE49NguWRrA9XkWCCSo7Y/3xkecNbXqV8d05QDiNJqE4B1LAatnpeLjZmAz2ZlfYmjo5mnvpGxJU54rQ+dn2LqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755688129; c=relaxed/simple;
	bh=iczrSRb/LzmTYeWsst5VWMjvh1pJPYOTRFhjjOc5Gk0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MiZYYYaBlf0aaAUdxMrQXxaPDvq4W4Nz5EUvDTsfxX+iJwGCMYL6tCqTvUocNLvoquwqsz4aT605xqb4LqVOEI7KcDIqsc4HdEWr0cwbw58hWClaZQVhF9sCfm8NCMo/m9pe17IMVHEJYyis6Pkg4+Wqf3Lhf6aBFnLbR+INi2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=chMZbffa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755688126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K5UuAcKCpAAO9FQcJaj/6DVRv2+KCSgobmUnlZ2gPCI=;
	b=chMZbffa3Mh+Cidjxtx+h+Jzi4Cou92O14jxuziwpEqwwWWZMsFFQXenR9R32tz2CCm6xW
	qU1BWy1Jffid2C8x8eispP0uUWGjYDOpX/+H2i4FgeX7Xa+i1X33AWkr+OV2BrSCHUFMW6
	Q/aIjwne+VTrCRjS+jHlOlAiigOilJk=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-685-QZgYqNJ2PpiMQprcvoLbNA-1; Wed,
 20 Aug 2025 07:08:43 -0400
X-MC-Unique: QZgYqNJ2PpiMQprcvoLbNA-1
X-Mimecast-MFC-AGG-ID: QZgYqNJ2PpiMQprcvoLbNA_1755688122
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D5E061955D56;
	Wed, 20 Aug 2025 11:08:41 +0000 (UTC)
Received: from fedora (unknown [10.72.116.45])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AB5823000198;
	Wed, 20 Aug 2025 11:08:37 +0000 (UTC)
Date: Wed, 20 Aug 2025 19:08:33 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: Re: [PATCH V3] io_uring: uring_cmd: add multishot support
Message-ID: <aKWssZvQT-Wb-AJA@fedora>
References: <20250819150040.980875-1-ming.lei@redhat.com>
 <1155b8b0-d5d0-4634-984b-71d246932af7@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1155b8b0-d5d0-4634-984b-71d246932af7@kernel.dk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Aug 19, 2025 at 10:00:36AM -0600, Jens Axboe wrote:
> On 8/19/25 9:00 AM, Ming Lei wrote:
> > @@ -251,6 +265,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
> >  	}
> >  
> >  	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
> > +	if (ioucmd->flags & IORING_URING_CMD_MULTISHOT) {
> > +		if (ret >= 0)
> > +			return IOU_ISSUE_SKIP_COMPLETE;
> > +		io_kbuf_recycle(req, issue_flags);
> > +	}
> >  	if (ret == -EAGAIN) {
> >  		ioucmd->flags |= IORING_URING_CMD_REISSUE;
> >  		return ret;
> 
> Final comment on this part... uring_cmd is unique in the sense that it'd
> be the first potentially pollable file type that supports buffer
> selection AND can return -EIOCBQUEUED. For non-pollable, the buffer
> would get committed upfront. For pollable, we'd either finish and put it
> within this same execution context, or we'd drop it entirely when
> returning -EAGAIN.
> 
> So what happens if we get -EIOCBQUEUED with a selected buffer from
> provided buffer ring, and someome malicious unregisters and frees the
> buffer ring before that request completes?

Looks one real trouble for IORING_URING_CMD_MULTISHOT.

For pollable multishot, ->issue() is run in submitter tw context, and done
in `sync` style, so ctx->uring_lock protects the buffer list, and
unregister can't happen. That should be one reason why polled multishot
can't be run in io-wq context.

But now -EIOCBQUEUED is returned from ->issue(), we lose ->uring_lock's
protection for req->buf_list, one idea could be adding referenced buffer
list for failing unregister in case of any active consumer.

Do you have suggestions for this problem?


Thanks,
Ming


