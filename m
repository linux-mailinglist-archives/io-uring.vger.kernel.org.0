Return-Path: <io-uring+bounces-6762-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B811DA44EA2
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 22:17:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BE2E189B1FE
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 21:16:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97C951ACEAF;
	Tue, 25 Feb 2025 21:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tusFs4mu"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8871A8F95;
	Tue, 25 Feb 2025 21:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740518172; cv=none; b=OG/9jVE/q7Uo+233B65QcILO4V9pCwrcDnoNDWLJcQZaISK057V64o3Y6tqlfzOp/wMaj0tEnk6jZhb1CxDi8/Mhl8wSQGi7zzxSuL3vI4//OgETIrsu+MvNBgd8hO+XhVFpoXZ02I4NRfBbsKArXF0tZ93WSH59YSQSx9n5GI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740518172; c=relaxed/simple;
	bh=0Wo0zvd4Vfg24Iw6+oVLKeB8By5dvHplz1qC/aGQvNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=as+Sm65wmiag17JX0vRzUv1hidRq1RHeIJBRVnjoNsQkNctoRXr+e/dJhMIPoQAReadth9PmubPc81gIg9so+q4UH8Ct31FdxsbEQaCckRlegLfsB+mzmuSM2jpVKAkZ19CflnU9eM2LY2naSAV91eLu0Co04XreC9IIO8DrA7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tusFs4mu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB33C4CEDD;
	Tue, 25 Feb 2025 21:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740518171;
	bh=0Wo0zvd4Vfg24Iw6+oVLKeB8By5dvHplz1qC/aGQvNQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tusFs4muKhj8o033IxslQv3ZApEXKuHhrV60uovtoAq60h8CoP3CETYdCXSl9qV82
	 WZIFqhlNZ20PNAOj3oNRXmL1PdkKGDe7tOBQ6uAEhIGt4h+5J5N7EKL8e/AV+lQ6cz
	 bbH/E3sLOf5v655UllvID8KaRooHtO40b1HbbrSUVWw9LlHK8EIWZpdXQ3GQ3UbS5f
	 5n7ihQKmVK9qoau2GYn12PFKoctFNh7T7RrZkQ2tr+4fHzGKoHlfmIE+mSNA+lFm8P
	 8iJ3BgxLqacTZADuwfgjOETWGdWKJp8cauDP+zsvlX/MeyHdFmm8ScWH3zg7PiI4Xr
	 0UXAG0MnY/UAw==
Date: Tue, 25 Feb 2025 14:16:09 -0700
From: Keith Busch <kbusch@kernel.org>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com,
	asml.silence@gmail.com, axboe@kernel.dk,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	bernd@bsbernd.com
Subject: Re: [PATCHv5 06/11] io_uring/rw: move fixed buffer import to issue
 path
Message-ID: <Z74zGRndZiQvFRJS@kbusch-mbp>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-7-kbusch@meta.com>
 <CADUfDZqmVX6Vn9euU0v9AvYGdU6BPtR7vEDBgss_8Hiv7WHuZw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZqmVX6Vn9euU0v9AvYGdU6BPtR7vEDBgss_8Hiv7WHuZw@mail.gmail.com>

On Tue, Feb 25, 2025 at 12:57:43PM -0800, Caleb Sander Mateos wrote:
> On Mon, Feb 24, 2025 at 1:31 PM Keith Busch <kbusch@meta.com> wrote:
> > +static int io_init_rw_fixed(struct io_kiocb *req, unsigned int issue_flags, int ddir)
> >  {
> >         struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
> > -       struct io_async_rw *io;
> > +       struct io_async_rw *io = req->async_data;
> >         int ret;
> >
> > -       ret = io_prep_rw(req, sqe, ddir, false);
> > -       if (unlikely(ret))
> > -               return ret;
> > +       if (io->bytes_done)
> > +               return 0;
> >
> > -       io = req->async_data;
> >         ret = io_import_reg_buf(req, &io->iter, rw->addr, rw->len, ddir, 0);
> 
> Shouldn't this be passing issue_flags here?

Definitely should be doing that, and I have that in my next version
already. Was hoping to get that fixed up version out before anyone
noticed, but you got me. 

