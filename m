Return-Path: <io-uring+bounces-9062-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F833B2C6FD
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 16:28:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 216463AFA9C
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 14:28:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 171B22EB873;
	Tue, 19 Aug 2025 14:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jhytx1rz"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C912EB86C
	for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 14:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755613725; cv=none; b=nnwnWS+R+06EMEoBwo7jAx1z1kbgzGBSpPc0BUIfwBZKNDBuP2KmvR6KY4HJjyob314aBfeUfR6El9+AwsnxV9wXHllUcwhfn3kqJbNYRIfZNBT23ehgfQH1r9KzJXQcaJ2xdAcS0mAuT9pLaJ/UsxLw7AsyTLw6kx4EfbnqYAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755613725; c=relaxed/simple;
	bh=7HaHeOPpQfYKHBJkJG6d7eRAC/xDsFbuRGPc/JlrwWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dVxSz6XoQ/+1cZT4lpM+vKIRl+f0Bx8J430kjGV/JaFugNDC3Y3io42hFoj5NlUSFRHuehJ+WtQKBZdu/EzoO9w8fuuBG+usxtPvthpxSiyvqQkyUoVyLL3Iq6g8BP6vh9d5rcAMktIHyjF+AEROB5+it2fLo/sObiUiOJrK1qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jhytx1rz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755613721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/6zBek0g8HUEZIo8dL4wThzGyN50nBvBl8G37xKvO2g=;
	b=Jhytx1rzvjBKuuIc0aJ08NfnVJVONAS6Ietvxfzke5hx23ifAGjNRgj58YWvFPNBhWVHst
	wkJAWpej0Ja/+E0loHOxj1vaad4Lawq9/oVd6TvZ63PR3X0M5erg1ZdtMZcus4b7u91Cmu
	uhfq5G14s+3xkXoD29wTuIBouQTWzjw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-h-3XkjemNeuzdaFK6bPZPg-1; Tue,
 19 Aug 2025 10:28:39 -0400
X-MC-Unique: h-3XkjemNeuzdaFK6bPZPg-1
X-Mimecast-MFC-AGG-ID: h-3XkjemNeuzdaFK6bPZPg_1755613717
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 585771800342;
	Tue, 19 Aug 2025 14:28:37 +0000 (UTC)
Received: from fedora (unknown [10.72.116.22])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3299919A4CA6;
	Tue, 19 Aug 2025 14:28:30 +0000 (UTC)
Date: Tue, 19 Aug 2025 22:28:03 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: Re: [PATCH] io_uring: uring_cmd: add multishot support without poll
Message-ID: <aKSJ8yg7GRh6UzTr@fedora>
References: <20250810025024.1659190-1-ming.lei@redhat.com>
 <393638fa-566a-4210-9f7e-79061de43bb4@kernel.dk>
 <aKRd05_pzVwhPfxI@fedora>
 <91bc3fdf-880d-4b71-94b3-ac72ca0f3640@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91bc3fdf-880d-4b71-94b3-ac72ca0f3640@kernel.dk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, Aug 19, 2025 at 08:01:18AM -0600, Jens Axboe wrote:
> On 8/19/25 5:19 AM, Ming Lei wrote:
> >>> @@ -251,6 +264,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
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
> >> Missing recycle for -EAGAIN?
> > 
> > io_kbuf_recycle() is done above if `ret < 0`
> 
> Inside the multishot case. I don't see anywhere where it's forbidden to
> use IOSQE_BUFFER_SELECT without having multishot set? Either that needs

REQ_F_BUFFER_SELECT is supposed to be allowed for IORING_URING_CMD_MULTISHOT
only, and it is checked in io_uring_cmd_prep().

> to be explicit for now, or the recycling should happen generically.
> Probably the former I would suspect.

Yes, the former is exactly what the patch is doing.


Thanks,
Ming


