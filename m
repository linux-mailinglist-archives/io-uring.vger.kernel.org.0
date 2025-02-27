Return-Path: <io-uring+bounces-6830-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E115A47448
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 05:19:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 44853188E6EA
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 04:17:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 181BA1EB5C4;
	Thu, 27 Feb 2025 04:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="blE1zRDu"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F0F1E835E
	for <io-uring@vger.kernel.org>; Thu, 27 Feb 2025 04:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740629829; cv=none; b=HT5+yzFEhL+zPYhz8BrH0heeY/j4T/2dIUwPssObdUzF+BxlpbTXilL4vTBiwRyfGqMVtLcsh4/zF1NTsWB+BKKNDuFYrF90T3ul9hv+JLKHI0i3g7B5nvIPCSgUeEHLxx4WL6a+LU1bln1GiJ68bXmUUf40S1g1951ZEtqDgGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740629829; c=relaxed/simple;
	bh=7cM7mtUsjrPOXcshDsyOh6y6/hI8jJnNzQG8/FcCHyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ocxd8nto2eanhhw5luNq0YTQDD1QfMCugk3RNPPFi1fLT4BM7Ss1GoHkQjk2CmHwdWBPqn8vhfeXrHKnaRv2FdPpz54hhIVcwRs99gIuNUF0Eav3ucwS6jYg7XtwzvmBBR23U1Qw+/6LmBE6MBmHoMLNaxK/P/mqoTAdrcjuMZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=blE1zRDu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740629826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=91O3clJbCKHoCFSga1DoZxclHTlojh88FCXnpKVW7Xo=;
	b=blE1zRDupHWekJHZA3eHTF0PVEOngXHeMdWo0uoxdulEvkFUKm04ssk3962Mb75KmZ/6GH
	ZiGE/Z2DzsdnPhDF7u1VBTX6QOBCrt7RgoyffgMtIs1V9mpmpqWbkxJ7eBuTRGfkWXoCj5
	LrDXvKuxTEPorbCuMvxvDUK+z7jbx8M=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-10-GtGNkgGaPwuEufHumHUhpg-1; Wed,
 26 Feb 2025 23:17:04 -0500
X-MC-Unique: GtGNkgGaPwuEufHumHUhpg-1
X-Mimecast-MFC-AGG-ID: GtGNkgGaPwuEufHumHUhpg_1740629821
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3A9D519373DC;
	Thu, 27 Feb 2025 04:17:01 +0000 (UTC)
Received: from fedora (unknown [10.72.120.23])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5767F19560AE;
	Thu, 27 Feb 2025 04:16:54 +0000 (UTC)
Date: Thu, 27 Feb 2025 12:16:49 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@kernel.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Keith Busch <kbusch@meta.com>,
	axboe@kernel.dk, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, bernd@bsbernd.com,
	csander@purestorage.com
Subject: Re: [PATCHv5 09/11] ublk: zc register/unregister bvec
Message-ID: <Z7_nMaZahEGPGIh8@fedora>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-10-kbusch@meta.com>
 <90747c18-01ae-4995-9505-0bd29b7f17ab@gmail.com>
 <Z73vfy0wlCxwf4hp@kbusch-mbp>
 <a5ceb705-a561-4f84-a4de-5f2e4b3e2de8@gmail.com>
 <Z731OQNVyrjXtuc9@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z731OQNVyrjXtuc9@kbusch-mbp>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Tue, Feb 25, 2025 at 09:52:09AM -0700, Keith Busch wrote:
> On Tue, Feb 25, 2025 at 04:42:59PM +0000, Pavel Begunkov wrote:
> > On 2/25/25 16:27, Keith Busch wrote:
> > > On Tue, Feb 25, 2025 at 04:19:37PM +0000, Pavel Begunkov wrote:
> > > > On 2/24/25 21:31, Keith Busch wrote:
> > > > > From: Keith Busch <kbusch@kernel.org>
> > > > > 
> > > > > Provide new operations for the user to request mapping an active request
> > > > > to an io uring instance's buf_table. The user has to provide the index
> > > > > it wants to install the buffer.
> > > > 
> > > > Do we ever fail requests here? I don't see any result propagation.
> > > > E.g. what if the ublk server fail, either being killed or just an
> > > > io_uring request using the buffer failed? Looking at
> > > > __ublk_complete_rq(), shouldn't someone set struct ublk_io::res?
> > > 
> > > If the ublk server is killed, the ublk driver timeout handler will abort
> > > all incomplete requests.
> > > 
> > > If a backend request using this buffer fails, for example -EFAULT, then
> > > the ublk server notifies the ublk driver frontend with that status in a
> > > COMMIT_AND_FETCH command, and the ublk driver completes that frontend
> > > request with an appropriate error status.
> > 
> > I see. IIUC, the API assumes that in normal circumstances you
> > first unregister the buffer, and then issue another command like
> > COMMIT_AND_FETCH to finally complete the ublk request. Is that it?
> 
> Yes, that's the expected good sequence. It's okay if user space does it

That is exactly what the ublk ktests patch loop/zc is doing.

> the other around, too: commit first, then unregister. The registration
> holds a reference on the ublk request, preventing it from completing.

It depends on UBLK_IO_COMMIT_AND_FETCH_REQ is only done once, and luckily
it works in this way from beginning, otherwise the request still may be freed
before unregister command is done.

> The backend urin gthat registered the bvec can also be a different uring
> instance than the frontend that notifies the of the commit-and-fetch. In
> such a setup, the commit and unregister sequence could happen
> concurrently, and that's also okay.

Yes, ublk io commands are always run in the queue context, but
unregister from io-wq still brings some extra latency for io.




Thanks,
Ming


