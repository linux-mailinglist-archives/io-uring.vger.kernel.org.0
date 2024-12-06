Return-Path: <io-uring+bounces-5275-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C44C09E7677
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 17:53:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CF21161575
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 16:53:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 344A71F4E32;
	Fri,  6 Dec 2024 16:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OrmGSzWu"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7A8206262;
	Fri,  6 Dec 2024 16:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733503997; cv=none; b=KK9tEsgzQcyancwZ7csELyHBohESXSMuzLYpR02/36hMIf4TIDwcSZp18Y7wtSORoOWMrH6ZBcgUXyB0YRQo9BNuuhq3+dZRSA+mQ81+Kagw4o9N/R2Dw9o3DRjww25oIY5bsrBCnhSOnu65FrnIba4LSXLXbr+sBUapyeJr1kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733503997; c=relaxed/simple;
	bh=E4OmwzABQyPH64Cigqh7KGY0PBH7U5WPajekdK8ToSI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fVG00M1bzmAYDkl0vGSyvgRJrJ/V5q7tWc8H+nxNDVIc8vSUmAVKl9Ah9vKAPx05VX8poU/H57mRxy9zdXmbEY8Cwal05iF1Mc87uqPKncd1JmI0dY9Na1P3zKILYfPNAV7n/iLFGfVBtm0Nk2IiaTmdkInt6GJJkFeIp0QrHf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OrmGSzWu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9A8C4CED1;
	Fri,  6 Dec 2024 16:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733503996;
	bh=E4OmwzABQyPH64Cigqh7KGY0PBH7U5WPajekdK8ToSI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OrmGSzWuLCUiSHe1eGmiA7DgbCZLdxqtps+bnCCJlChdAeuyqNmidVJz6Gew5u3sI
	 rY/UqZPfzKkKhtIfUFzJCQV5RVMrNDnW6WzxcFFhnHwg8JHG97+NZ+TOwpxLlz3HPe
	 bwI6zM6yDHq0103ngcU/ffITezcW009p7F5K9R3KQYedMsNjdTuWBlCiJ59YkFyEIf
	 bOQ3PAZbuFg7sE43mq82XhHKr8+9ycvChGIF1prNCRjDYW6mBZSDXo+65Tq+XHd0xK
	 +eVU/vsg7XxNMPDXNByKGhZj2HnalWHHHz369KspkTMHKXMlQNwUhJZbGM7kcojDJN
	 0/JOVR9T2oQgw==
Date: Fri, 6 Dec 2024 08:53:14 -0800
From: Keith Busch <kbusch@kernel.org>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	sagi@grimberg.me, asml.silence@gmail.com
Subject: Re: [PATCHv11 03/10] io_uring: add write stream attribute
Message-ID: <Z1Mr-rcFOVW2eS8-@kbusch-mbp.dhcp.thefacebook.com>
References: <20241206015308.3342386-1-kbusch@meta.com>
 <CGME20241206015353epcas5p174318c263e73bfe8728d49b5e90a14e8@epcas5p1.samsung.com>
 <20241206015308.3342386-4-kbusch@meta.com>
 <bcfd9c63-797b-4f6b-aa6e-0e639247003b@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcfd9c63-797b-4f6b-aa6e-0e639247003b@samsung.com>

On Fri, Dec 06, 2024 at 06:14:29PM +0530, Kanchan Joshi wrote:
> On 12/6/2024 7:23 AM, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > Adds a new attribute type to specify a write stream per-IO.
> > 
> > Signed-off-by: Keith Busch <kbusch@kernel.org>
> > ---
> >   include/uapi/linux/io_uring.h |  9 ++++++++-
> >   io_uring/rw.c                 | 28 +++++++++++++++++++++++++++-
> >   2 files changed, 35 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> > index 5fa38467d6070..263cd57aae72d 100644
> > --- a/include/uapi/linux/io_uring.h
> > +++ b/include/uapi/linux/io_uring.h
> > @@ -123,7 +123,14 @@ struct io_uring_attr_pi {
> >   	__u64	rsvd;
> >   };
> >   
> > -#define IORING_RW_ATTR_FLAGS_SUPPORTED (IORING_RW_ATTR_FLAG_PI)
> > +#define IORING_RW_ATTR_FLAG_WRITE_STREAM (1U << 1)
> > +struct io_uring_write_stream {
> > +	__u16	write_stream;
> > +	__u8	rsvd[6];
> > +};
> 
> So this needs 8 bytes. Maybe passing just 'u16 write_stream' is better? 
> Or do you expect future additions here (to keep rsvd).

I don't have any plans to use it. It's just padded for alignment. I am
not sure what future attributes might be proposed, but I don't want to
force them be align to a 2-byte boundary.
 
> Optimization is possible (now or in future) if it's 4 bytes or smaller, 
> as that can be placed in SQE along with a new RW attribute flag that 
> says it's placed inline. Like this -

Oh, that's definitely preferred IMO, because it is that much easier to
reach the capability. Previous versions of this proposal had the field
in the next union, so I for some reason this union you're showing here
was unavailable for new fields, but it looks like it's unused for
read/write. So, yeah, let's put it in the sqe if there's no conflict
here.

> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -92,6 +92,10 @@ struct io_uring_sqe {
>                          __u16   addr_len;
>                          __u16   __pad3[1];
>                  };
> +               struct {
> +                       __u16   write_hint;
> +                       __u16   __rsvd[1];
> +               };
>          };
>          union {
>                  struct {

