Return-Path: <io-uring+bounces-11299-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 41F55CDAC54
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 23:46:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C1141300EA05
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 22:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E467B1DFF7;
	Tue, 23 Dec 2025 22:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NfuxH8HM"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D9E79CD
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 22:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766529960; cv=none; b=TkoU5MZtrBqjUBDgiAl3OK4ppURP86/z4kwByT/xgTGFG14RcblUpWhSiZZz71AEPIgy0jB0xkc0KK/Sgj/NGxcOODfQ4KANWTJS3hIrzRidUsEeqVZ/x/5X20EFNkxWuR3nl+j6hoVmvP0c+i0egxxefYRKRclMFRTnEIDuJoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766529960; c=relaxed/simple;
	bh=ovBwZaOen47saNuczUmRQ+Zy/e/RvZ+Fuj4PFI1w8ME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WZPdZ5nFM8DAA6j5N08uE5dDSKvQjJxhYNYsg3vUQFVX2KEQix7IBWxEYAvNpwmbNse4lKyEWUfyb4sTqdd2474oZdRlwjmX4gSbY5D5mfl2zKzvd9fSuJqCZ4MI/m+7AtbojzLnEEHNi9e0d/eZieGE43Y/fFpbIclrGKO1Lzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NfuxH8HM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766529957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HJXaYxgmivoOif3yTFufIw9NNravqdvxHENvmUmQR5c=;
	b=NfuxH8HMvx0/Wf4hS1KEBmynkDVxrh6fFvs6oSQ2q47jng2K1Uy/0ga4yT7xoNh55WDrfw
	YD37ePCTKmTwdylTnD4o8G+yMbUEZvkTVTcMG4WhwMxyueb8DqcYDW1FnMrk3sxCDO2kiM
	eyYVyQlpqyz5Da0NTNl+v7xW/2FHGMs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-634-yqWSA8EGMcaVFSRs8HcRlA-1; Tue,
 23 Dec 2025 17:45:54 -0500
X-MC-Unique: yqWSA8EGMcaVFSRs8HcRlA-1
X-Mimecast-MFC-AGG-ID: yqWSA8EGMcaVFSRs8HcRlA_1766529953
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E62D51800343;
	Tue, 23 Dec 2025 22:45:52 +0000 (UTC)
Received: from fedora (unknown [10.72.116.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C84C019560A7;
	Tue, 23 Dec 2025 22:45:48 +0000 (UTC)
Date: Wed, 24 Dec 2025 06:45:44 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: huang-jl <huang-jl@deepseek.com>, axboe@kernel.dk,
	io-uring@vger.kernel.org, nj.shetty@samsung.com
Subject: Re: [PATCH v6.20] io_uring/rsrc: refactor io_import_kbuf() to use
 single loop
Message-ID: <aUsbmGlQI9vC70IW@fedora>
References: <20251217123156.1100620-1-ming.lei@redhat.com>
 <20251217151647.193815-1-huang-jl@deepseek.com>
 <aUNcE48RnCy_rFQj@fedora>
 <aUNmrSVkZEMk7xmF@fedora>
 <CADUfDZr8vQ9AQSONNmQVyS-BwV1T_MxfGcAWWHwQ=Ci15gMYFg@mail.gmail.com>
 <aUn-sSrlD2gwkFTO@fedora>
 <CADUfDZpXNcBuA0Z6+btpw1M+iiyQV2KK0xx6FvHAqoUEMxwO1g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZpXNcBuA0Z6+btpw1M+iiyQV2KK0xx6FvHAqoUEMxwO1g@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Tue, Dec 23, 2025 at 02:56:45PM -0500, Caleb Sander Mateos wrote:
> On Mon, Dec 22, 2025 at 9:30 PM Ming Lei <ming.lei@redhat.com> wrote:
> >
> > On Mon, Dec 22, 2025 at 02:56:02PM -0500, Caleb Sander Mateos wrote:
> > > On Wed, Dec 17, 2025 at 9:28 PM Ming Lei <ming.lei@redhat.com> wrote:
> > > >
> > > > On Thu, Dec 18, 2025 at 09:42:43AM +0800, Ming Lei wrote:
> > > > > On Wed, Dec 17, 2025 at 11:16:47PM +0800, huang-jl wrote:
> > > > > > The code looks correct to me.
> > > > > >
> > > > > > > This simplifies the logic
> > > > > >
> > > > > > I'm not an expert in Linux development, but from my perspective, the
> > > > > > original version seems simpler and more readable. The semantics of
> > > > > > iov_iter_advance() are clear and well-understood.
> > > > > >
> > > > > > That said, I understand the appeal of merging them into a single loop.
> > > > > >
> > > > > > > and avoids the overhead of iov_iter_advance()
> > > > > >
> > > > > > Could you clarify what overhead you mean? If it's the function call
> > > > > > overhead, I think the compiler would inline it anyway. The actual
> > > > > > iteration work seems equivalent between both approaches.
> > > > >
> > > > > iov_iter_advance() is global function, and it can't be inline.
> > > > >
> > > > > Also single loop is more readable, cause ->iov_offset can be ignored easily.
> > > > >
> > > > > In theory, re-calculating nr_segs isn't necessary, it is just for avoiding
> > > > > potential split, however not get idea how it is triggered. Nitesh didn't
> > > > > mention the exact reason:
> > > > >
> > > > > https://lkml.org/lkml/2025/4/16/351
> > > > >
> > > > > I will look at the reason and see if it can be avoided.
> > > >
> > > > The reason is in both bio_iov_bvec_set() and bio_may_need_split().
> > >
> > > nr_segs is not just a performance optimization, it's part of the
> > > struct iov_iter API and used by iov_iter_extract_bvec_pages(), as
> > > huang-jl pointed out. I don't think it's a good idea to assume that
> > > nr_segs isn't going to be used and doesn't need to be calculated
> > > correctly.
> >
> > It doesn't have to be exact if the bytes covered by `count` won't cross
> > `nr_segs`.
> >
> > The `nr_segs` re-calculation is added only for fixing performance regression
> > in the following link:
> >
> > https://lkml.org/lkml/2025/4/16/351
> >
> > because bio_iov_bvec_set() takes iter->nr_segs for setting bio->bi_vcnt.
> 
> But iov_iter_extract_bvec_pages() appears to only use iter->nr_segs
> and not iter->count. I don't understand how it can get away with an
> overestimated iter->nr_segs.

iov_iter_extract_bvec_pages() does pass `max_size` for using iter->counter,
please see the only caller of iov_iter_extract_pages().

iov_iter has to respect both two, otherwise it is a iov_iter bug.


Thanks,
Ming


