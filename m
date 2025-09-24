Return-Path: <io-uring+bounces-9876-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0229EB9C03C
	for <lists+io-uring@lfdr.de>; Wed, 24 Sep 2025 22:32:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55F583A6BB2
	for <lists+io-uring@lfdr.de>; Wed, 24 Sep 2025 20:31:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE25132BF40;
	Wed, 24 Sep 2025 20:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="da+25kkK"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90C732B4B9
	for <io-uring@vger.kernel.org>; Wed, 24 Sep 2025 20:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758745811; cv=none; b=ecCoQGyh7mVLrINppDPj5rJjn+ErJr6dYOjXr/M2sb90iB1GWwnrB7/GTkY4tTGK2a4bN84rWKPSMNQ8qUCzb/a3ZNV+Jalw/qeDvBod4dl0/+lPvC1eCTvW4QVeGnZlee/DRJjkB7msxu6D3LRefo/cwAVA98ZY1nR1Gjq+L8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758745811; c=relaxed/simple;
	bh=lSFGZe9faPikoBqW1U9jcc3670hCHv8wESiUkeYQUcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PL5gEn7atRd36tlIfukelkXaYpID0p9IgrDNeyBkKoTgEPIO01ujmGnysp5D+RkyoQrq06jVaS8qV1ncevo6q4SN2Ksls85TGlgL4kMtIlvu8mxjpBgLthnRVxKJ3IbvNaISKgMuBKJmsOLMVJjm+pp9/VBW5bscoNtXxJwVHEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=da+25kkK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA30C4CEE7;
	Wed, 24 Sep 2025 20:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758745811;
	bh=lSFGZe9faPikoBqW1U9jcc3670hCHv8wESiUkeYQUcQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=da+25kkK+L+JGAv0FhDuL/RWz0K1CXj7gMd2Ih+r0/eSLPCVkOG+1XlcBIBYwg187
	 09puYwuN7S0AejL7G5Ve3xY5MDenQKfUhhW+xv1mCalTxkHP03uN0MBA4K/Tap5Gfj
	 YD8Wubw5t3VHNgRD+sMYYXwvBlVZ9lS8YmzK+Lzep1+jzO4xxsh4C8dZxSFMFlP7Qj
	 1+sIOrlaDcA8+8GV2xlXI0BJNHw4VE5WQBPPsAEfiu83Q3lOO8MMls4nRGdO/PMk6/
	 QgF2RYj1Vkoug0ZhNaY2V1Ot6R5HM23ubyZAxkWhzUoIq4XCIMh5DrSDDk4BNirgA+
	 L/Ohg4m1fiy4A==
Date: Wed, 24 Sep 2025 14:30:09 -0600
From: Keith Busch <kbusch@kernel.org>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
	axboe@kernel.dk, ming.lei@redhat.com
Subject: Re: [PATCHv3 1/3] Add support IORING_SETUP_SQE_MIXED
Message-ID: <aNRU0fStL1YuEBSf@kbusch-mbp>
References: <20250924151210.619099-1-kbusch@meta.com>
 <20250924151210.619099-2-kbusch@meta.com>
 <CADUfDZrmFphH5AwNkLs=OtPg9qfnpciJB--28PVQ4q=5Fh21TQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADUfDZrmFphH5AwNkLs=OtPg9qfnpciJB--28PVQ4q=5Fh21TQ@mail.gmail.com>

On Wed, Sep 24, 2025 at 01:20:44PM -0700, Caleb Sander Mateos wrote:
> > index 052d6b56..66f1b990 100644
> > --- a/src/include/liburing.h
> > +++ b/src/include/liburing.h
> > @@ -575,6 +575,7 @@ IOURINGINLINE void io_uring_initialize_sqe(struct io_uring_sqe *sqe)
> >         sqe->buf_index = 0;
> >         sqe->personality = 0;
> >         sqe->file_index = 0;
> > +       sqe->addr2 = 0;
> 
> Why is this necessary for mixed SQE size support? It looks like this
> field is already initialized in io_uring_prep_rw() via the unioned off
> field. Though, to be honest, I can't say I understand why the
> initialization of the SQE fields is split between
> io_uring_initialize_sqe() and io_uring_prep_rw().

The nvme passthrough uring_cmd doesn't call io_uring_prep_rw(), so we'd
just get a stale value in that field if we don't clear it. But you're
right that many cases would end up setting the field twice when we don't
need that.
 
> > +       IOSQE_SQE_128B_BIT,
> 
> I thought we decided against using an SQE flag bit for this? Looks
> like this needs to be re-synced with the kernel uapi header.

We did, and this is a left over artifact that is not supposed to be
here. :( Nothing is depending on the bit in this series.

