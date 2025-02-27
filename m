Return-Path: <io-uring+bounces-6831-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 76BAFA4744A
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 05:21:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 21DFA1889B67
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 04:19:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94EFD188006;
	Thu, 27 Feb 2025 04:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VtHWOfst"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB7314D2B7
	for <io-uring@vger.kernel.org>; Thu, 27 Feb 2025 04:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740629970; cv=none; b=IDXVKuRehzB3WWKvbsqKKnl9O+b0ynwRk4N1rvUEZAfOKhzUeBYM7zJPSlqQNCUyuAjrkUjn8gEu6vOqkUImuLZJrAqInSc47n5rOox8WAg1qdbD6zkKXi3VIoIYSFJC5QoDgkT3Jhi5Uyjp8oxgJKIPg8QDRIIyxD1RGEl2nZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740629970; c=relaxed/simple;
	bh=pb3q9GToljyuzZWYBPijvZiIsxmtbzZJgYQlsblBAsY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=svjT2abZvkigMjKOLT9Fpv2HaBHAhLPFbVFl3BdW3q2mWXVE8IgG69w/LsCccEKez6zBArfSiQzP7DiII1uyiBiCbBS2TyXrqb11oM4TnoRltwL1x1Vp7ftKRw9hYEb7WYsQktNZhjAtSFwLD5Ns63WpP27FhqLW3G4sm2ZioK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VtHWOfst; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740629967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y3miCUsYvStT9AwYJZu+gnG0siH+gsnQ0kgCx7EBnoM=;
	b=VtHWOfstb6F4odk8NpDly4mdbuJDjWE1cFFzhWxwCmaMBmMOrLUrDGb6/Y7aph3ZSWoMhM
	6W+rnIlsNk3Fj4WY6jBgTZM0dsZjiuuWsn6Vb0mQboTEDvMbAyp/spT4v9v1Z4GYdT7k0M
	938+dRD7m3n9izPCMSOF4XbYpY7bfVQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-218-OCAPH6KzPJaXkcsMuykVRg-1; Wed,
 26 Feb 2025 23:19:26 -0500
X-MC-Unique: OCAPH6KzPJaXkcsMuykVRg-1
X-Mimecast-MFC-AGG-ID: OCAPH6KzPJaXkcsMuykVRg_1740629961
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 679781800874;
	Thu, 27 Feb 2025 04:19:21 +0000 (UTC)
Received: from fedora (unknown [10.72.120.23])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1490D180035E;
	Thu, 27 Feb 2025 04:19:14 +0000 (UTC)
Date: Thu, 27 Feb 2025 12:19:08 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, asml.silence@gmail.com, axboe@kernel.dk,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	bernd@bsbernd.com, csander@purestorage.com
Subject: Re: [PATCHv5 09/11] ublk: zc register/unregister bvec
Message-ID: <Z7_nvBrmOw2csDua@fedora>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-10-kbusch@meta.com>
 <Z77Nq_5ZGxUjxkau@fedora>
 <Z79LB3T5Aa6RoaDo@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z79LB3T5Aa6RoaDo@kbusch-mbp>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Wed, Feb 26, 2025 at 10:10:31AM -0700, Keith Busch wrote:
> On Wed, Feb 26, 2025 at 04:15:39PM +0800, Ming Lei wrote:
> > On Mon, Feb 24, 2025 at 01:31:14PM -0800, Keith Busch wrote:
> > > From: Keith Busch <kbusch@kernel.org>
> > > 
> > > Provide new operations for the user to request mapping an active request
> > > to an io uring instance's buf_table. The user has to provide the index
> > > it wants to install the buffer.
> > > 
> > > A reference count is taken on the request to ensure it can't be
> > > completed while it is active in a ring's buf_table.
> > > 
> > > Signed-off-by: Keith Busch <kbusch@kernel.org>
> > > ---
> > 
> > Looks IO_LINK doesn't work, and UNREG_BUF cqe can be received from userspace.
> 
> You can link the register, but should do the unregister with COMMIT
> command on the frontend when the backend is complete. This doesn't need
> the triple SQE requirement.
> 
> I was going to share with the next version, but since you bring it up
> now, here's the reference patch for ublksrv using links:

Forget to reply in this thread, IO_LINK works well in ktests V2 after
fixing one out-of-sqe issue, which is mentioned in the V2 cover-letter.



Thanks,
Ming


