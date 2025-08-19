Return-Path: <io-uring+bounces-9068-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0A23B2C7CC
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 17:01:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 993AF624CDA
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 14:58:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C454F280308;
	Tue, 19 Aug 2025 14:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h8RJS5xR"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90B227FD64
	for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 14:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755615339; cv=none; b=d67TEBDue0Dw8ugxnX2w7jAHKfLlhfA7VeQcj/kHZgYK/jl12ZnghSB/g/LYDxw2ZDH6t5lmDJ3jPHTubRXNtHBaUzx/l/quqZjm3Nu40WueiDhjL1WrbZC9d0cp2W5kchwLDrkdermwOdJv8WMZ4CI88ZQxZ4za+9LeaWhTxAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755615339; c=relaxed/simple;
	bh=Y1uIhUYGKAYcPmEgKUJkPJ8oHCorgeR8mxKzbjbovck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eVvzc41R51BxXseZaUL/dTihlYe4oSUrqsHlmQoj309yj+aBpWv6UTz+zKlSb8AVgzsuxTDsFxE5YC6E30zb1rjs3w0/YDhCXLYrWFP0Z+mrkqyCwDGKZ+81tW3GDlhsQOeBbmUmwSsjoN/JjFu7d0UFpxTQy6o61IuwX4eeIh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h8RJS5xR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755615336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B6Ei5DC0+Hnt9HPoNjCemWYK2kwuLtzHpUwVfE5iOr4=;
	b=h8RJS5xRwl2SMUQKxHJTSsfb7WEQP9DHXBMFPH/bmkfsUIcj70g101W19KBBqGlcvay9bZ
	We9FyZHVup86RHx7mTPi+DZscj7XOHfM5LWF5mRTtXp70JhclTqPoNKg66DxlECF0awFTF
	MlE3pw1sVwPWt9I5uj3MTe+iJEBOHWE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-378-h7poFS3uPmihekUvaHfuew-1; Tue,
 19 Aug 2025 10:55:33 -0400
X-MC-Unique: h7poFS3uPmihekUvaHfuew-1
X-Mimecast-MFC-AGG-ID: h7poFS3uPmihekUvaHfuew_1755615332
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1FAC31800268;
	Tue, 19 Aug 2025 14:55:32 +0000 (UTC)
Received: from fedora (unknown [10.72.116.22])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B803119560B0;
	Tue, 19 Aug 2025 14:55:27 +0000 (UTC)
Date: Tue, 19 Aug 2025 22:55:21 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: Re: [PATCH] io_uring: uring_cmd: add multishot support without poll
Message-ID: <aKSQWUXW2k97SQoQ@fedora>
References: <20250810025024.1659190-1-ming.lei@redhat.com>
 <393638fa-566a-4210-9f7e-79061de43bb4@kernel.dk>
 <aKRd05_pzVwhPfxI@fedora>
 <91bc3fdf-880d-4b71-94b3-ac72ca0f3640@kernel.dk>
 <aKSJ8yg7GRh6UzTr@fedora>
 <628449dc-45e7-4cdf-ad65-7c97e6b2bb6b@kernel.dk>
 <aKSM6uz72puzoqlO@fedora>
 <06bd405d-c5dd-4f20-af90-775278686f5c@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06bd405d-c5dd-4f20-af90-775278686f5c@kernel.dk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Tue, Aug 19, 2025 at 08:43:58AM -0600, Jens Axboe wrote:
> On 8/19/25 8:40 AM, Ming Lei wrote:
> > On Tue, Aug 19, 2025 at 08:31:32AM -0600, Jens Axboe wrote:
> >> On 8/19/25 8:28 AM, Ming Lei wrote:
> >>> On Tue, Aug 19, 2025 at 08:01:18AM -0600, Jens Axboe wrote:
> >>>> On 8/19/25 5:19 AM, Ming Lei wrote:
> >>>>>>> @@ -251,6 +264,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
> >>>>>>>  	}
> >>>>>>>  
> >>>>>>>  	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
> >>>>>>> +	if (ioucmd->flags & IORING_URING_CMD_MULTISHOT) {
> >>>>>>> +		if (ret >= 0)
> >>>>>>> +			return IOU_ISSUE_SKIP_COMPLETE;
> >>>>>>> +		io_kbuf_recycle(req, issue_flags);
> >>>>>>> +	}
> >>>>>>>  	if (ret == -EAGAIN) {
> >>>>>>>  		ioucmd->flags |= IORING_URING_CMD_REISSUE;
> >>>>>>>  		return ret;
> >>>>>>
> >>>>>> Missing recycle for -EAGAIN?
> >>>>>
> >>>>> io_kbuf_recycle() is done above if `ret < 0`
> >>>>
> >>>> Inside the multishot case. I don't see anywhere where it's forbidden to
> >>>> use IOSQE_BUFFER_SELECT without having multishot set? Either that needs
> >>>
> >>> REQ_F_BUFFER_SELECT is supposed to be allowed for IORING_URING_CMD_MULTISHOT
> >>> only, and it is checked in io_uring_cmd_prep().
> >>>
> >>>> to be explicit for now, or the recycling should happen generically.
> >>>> Probably the former I would suspect.
> >>>
> >>> Yes, the former is exactly what the patch is doing.
> >>
> >> Is it? Because looking at v2, you check if IORING_URING_CMD_FIXED is
> >> set, and you fail for that case if REQ_F_BUFFER_SELECT is set. Then you
> >> have a IORING_URING_CMD_MULTISHOT where the opposite is true, which
> >> obviously makes sense.
> >>
> >> But no checks if neither is set?
> > 
> > Indeed, thanks for the catch, and the REQ_F_BUFFER_SELECT check in IORING_URING_CMD_FIXED
> > branch can be moved to the branch of !IORING_URING_CMD_MULTISHOT.
> > 
> >>
> >> You could add that in io_uring_cmd_select_buffer(), eg fail if
> >> IORING_URING_CMD_MULTISHOT isn't set. Which if done, then the prep side
> >> checking could probably just go away.
> > 
> > Looks this way is good too.
> 
> Want to spin a v3 for this?

Yeah, will send V3 out after test is done.

Thanks,
Ming


