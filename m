Return-Path: <io-uring+bounces-9065-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EAB41B2C74A
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 16:41:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5755E1BC3D5C
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 14:41:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 902C9227EB9;
	Tue, 19 Aug 2025 14:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RN1q/m60"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3981DA60F
	for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 14:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755614461; cv=none; b=IT6iq/4YGzelY1ia86R7nMzqRnescaPGvTMXScBVaJjmU01iTi42kjgRtDnxxSZ70tdC2BaUIx93wXuGHqr904rQfPsVODkC6KIzmvr5e1E6oVPEzqULVpz4tZLkilKPato34H4QmXxX9QBir2erwbAPXFr0az/s7XKRoUIb3p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755614461; c=relaxed/simple;
	bh=l7tjBHdi1XsJbvQZl8puL6RefkXpqKQ3WQKLaCwjBxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f1ONgWh3D9KvJxUYj596xyT4Rw7QmbpsPHOiDPMJj9sek+hPrIjKq+pMHIlc5emO4obI7fX2RBrJd/8cY2oW2v3KD/BbsxNZAfCAKuvGldTz7Zw3ZkZlfNgD4u7KaIQEmD4iplRvoxTnMHgP2Q58yUmnwTAzLkHm6tN2upi0AjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RN1q/m60; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755614458;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xR+oimg/qFJB5/ZfbYebaqlFWfytM/n8bDSdNwvfkCA=;
	b=RN1q/m60YGA/9oD5c5oyzEzf0LI2Vabp0+H4AUGTsNT1Vnk4DioliPEDqYU2lgwup30gzt
	/0K2A6B7Z0GRV7Ik1vU+zBvT1JXU3+jlLcpqYrJLU0Pvpnkn93Osc9L2hWwDypHXwk2a1P
	3OSSKwlPfudnbtPV1OYHZDc9R2VEKx0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-119-jsrKF03lP3WCkKUFuwjvQQ-1; Tue,
 19 Aug 2025 10:40:55 -0400
X-MC-Unique: jsrKF03lP3WCkKUFuwjvQQ-1
X-Mimecast-MFC-AGG-ID: jsrKF03lP3WCkKUFuwjvQQ_1755614454
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 368BA180044F;
	Tue, 19 Aug 2025 14:40:54 +0000 (UTC)
Received: from fedora (unknown [10.72.116.22])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA6FF180047F;
	Tue, 19 Aug 2025 14:40:49 +0000 (UTC)
Date: Tue, 19 Aug 2025 22:40:42 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: Re: [PATCH] io_uring: uring_cmd: add multishot support without poll
Message-ID: <aKSM6uz72puzoqlO@fedora>
References: <20250810025024.1659190-1-ming.lei@redhat.com>
 <393638fa-566a-4210-9f7e-79061de43bb4@kernel.dk>
 <aKRd05_pzVwhPfxI@fedora>
 <91bc3fdf-880d-4b71-94b3-ac72ca0f3640@kernel.dk>
 <aKSJ8yg7GRh6UzTr@fedora>
 <628449dc-45e7-4cdf-ad65-7c97e6b2bb6b@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <628449dc-45e7-4cdf-ad65-7c97e6b2bb6b@kernel.dk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Tue, Aug 19, 2025 at 08:31:32AM -0600, Jens Axboe wrote:
> On 8/19/25 8:28 AM, Ming Lei wrote:
> > On Tue, Aug 19, 2025 at 08:01:18AM -0600, Jens Axboe wrote:
> >> On 8/19/25 5:19 AM, Ming Lei wrote:
> >>>>> @@ -251,6 +264,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
> >>>>>  	}
> >>>>>  
> >>>>>  	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
> >>>>> +	if (ioucmd->flags & IORING_URING_CMD_MULTISHOT) {
> >>>>> +		if (ret >= 0)
> >>>>> +			return IOU_ISSUE_SKIP_COMPLETE;
> >>>>> +		io_kbuf_recycle(req, issue_flags);
> >>>>> +	}
> >>>>>  	if (ret == -EAGAIN) {
> >>>>>  		ioucmd->flags |= IORING_URING_CMD_REISSUE;
> >>>>>  		return ret;
> >>>>
> >>>> Missing recycle for -EAGAIN?
> >>>
> >>> io_kbuf_recycle() is done above if `ret < 0`
> >>
> >> Inside the multishot case. I don't see anywhere where it's forbidden to
> >> use IOSQE_BUFFER_SELECT without having multishot set? Either that needs
> > 
> > REQ_F_BUFFER_SELECT is supposed to be allowed for IORING_URING_CMD_MULTISHOT
> > only, and it is checked in io_uring_cmd_prep().
> > 
> >> to be explicit for now, or the recycling should happen generically.
> >> Probably the former I would suspect.
> > 
> > Yes, the former is exactly what the patch is doing.
> 
> Is it? Because looking at v2, you check if IORING_URING_CMD_FIXED is
> set, and you fail for that case if REQ_F_BUFFER_SELECT is set. Then you
> have a IORING_URING_CMD_MULTISHOT where the opposite is true, which
> obviously makes sense.
> 
> But no checks if neither is set?

Indeed, thanks for the catch, and the REQ_F_BUFFER_SELECT check in IORING_URING_CMD_FIXED
branch can be moved to the branch of !IORING_URING_CMD_MULTISHOT.

> 
> You could add that in io_uring_cmd_select_buffer(), eg fail if
> IORING_URING_CMD_MULTISHOT isn't set. Which if done, then the prep side
> checking could probably just go away.

Looks this way is good too.

Thanks,
Ming


