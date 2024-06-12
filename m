Return-Path: <io-uring+bounces-2194-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 974119058AC
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 18:24:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A2251C217B6
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 16:24:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BA4617FAD4;
	Wed, 12 Jun 2024 16:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v6CQRjiu"
X-Original-To: io-uring@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA7316C878
	for <io-uring@vger.kernel.org>; Wed, 12 Jun 2024 16:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718209493; cv=none; b=LDsVzThVpp9fyX63Ci8Swk+IHotLIWYRYVNR2SBXkCbvXe0S+KDs2dhvkvL3Xc++645dy/JRE5g3wn6vFpQRo3xeQWdyL8GxUQL+QCdenMq8jfdkUa1HoUi/3DJXqXGpaxVzhtCxlDF8RpBU5Tyk6947k0T0ZZobswOQgoQgeCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718209493; c=relaxed/simple;
	bh=sBiNfD7GrDwAgxw96mt6X1/M1HceKbg1QDPMfxi5/BY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C6GEAYsMxDnB7BSJFUVquo77ezmLbYZHqSif97Exh9iOc2IZNVeStdzFhsMULxyuSqchDbWorULCDHJO3sBtOTG437nyol0/XVcwNvaO6FxX+0CnMm4ExNrnXsfHimFxyshKmc2V9uO4E5J2clwKZ4GEwnBIBv898o7kOlbNoMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v6CQRjiu; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: bernd.schubert@fastmail.fm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718209489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aQPu710OMl/zGUCfEwcpcZgM0JKI4jwl9NMG8oam6aE=;
	b=v6CQRjiuFllc99eBRpG6fXeeRDD7zwail9zUD4250MucsP+Wcf0Qz80iVr8FVghJO9iz4b
	RP5dY5jK7x3IQNc6ebQSOI3nc66nwn0plXYq2XHWcqjjjYtiRqoTFZx0dabMoeWMNbvQIQ
	rw/LzSNAVeK6No+oOeCXByJeZrwbO00=
X-Envelope-To: bschubert@ddn.com
X-Envelope-To: miklos@szeredi.hu
X-Envelope-To: amir73il@gmail.com
X-Envelope-To: linux-fsdevel@vger.kernel.org
X-Envelope-To: akpm@linux-foundation.org
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: mingo@redhat.com
X-Envelope-To: peterz@infradead.org
X-Envelope-To: avagin@google.com
X-Envelope-To: io-uring@vger.kernel.org
Date: Wed, 12 Jun 2024 12:24:40 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrei Vagin <avagin@google.com>, "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
Message-ID: <3bh7pncpg3qpeia5m7kgtolbvxwe2u46uwfixjhb5dcgni5k4m@kqode5qrywls>
References: <CAJfpegurSNV3Tw1oKWL1DgnR-tST-JxSAxvTuK2jirm+L-odeQ@mail.gmail.com>
 <99d13ae4-8250-4308-b86d-14abd1de2867@fastmail.fm>
 <CAJfpegu7VwDEBsUG_ERLsN58msXUC14jcxRT_FqL53xm8FKcdg@mail.gmail.com>
 <62ecc4cf-97c8-43e6-84a1-72feddf07d29@fastmail.fm>
 <im6hqczm7qpr3oxndwupyydnclzne6nmpidln6wee4cer7i6up@hmpv4juppgii>
 <a5ab3ea8-f730-4087-a9ea-b3ac4c8e7919@fastmail.fm>
 <olaitdmh662osparvdobr267qgjitygkl7lt7zdiyyi6ee6jlc@xaashssdxwxm>
 <4e5a84ab-4aa5-4d8b-aa12-625082d92073@ddn.com>
 <hhkehi7qlcjulhyvtd5j25cl3xw764cjk7tbsakf3ueerdhp3j@6d2nka5oalzn>
 <d5f61930-beb5-495b-9227-4531de98dae8@fastmail.fm>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5f61930-beb5-495b-9227-4531de98dae8@fastmail.fm>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 12, 2024 at 06:15:57PM GMT, Bernd Schubert wrote:
> 
> 
> On 6/12/24 17:55, Kent Overstreet wrote:
> > On Wed, Jun 12, 2024 at 03:40:14PM GMT, Bernd Schubert wrote:
> > > On 6/12/24 16:19, Kent Overstreet wrote:
> > > > On Wed, Jun 12, 2024 at 03:53:42PM GMT, Bernd Schubert wrote:
> > > > > I will definitely look at it this week. Although I don't like the idea
> > > > > to have a new kthread. We already have an application thread and have
> > > > > the fuse server thread, why do we need another one?
> > > > 
> > > > Ok, I hadn't found the fuse server thread - that should be fine.
> > > > 
> > > > > > 
> > > > > > The next thing I was going to look at is how you guys are using splice,
> > > > > > we want to get away from that too.
> > > > > 
> > > > > Well, Ming Lei is working on that for ublk_drv and I guess that new approach
> > > > > could be adapted as well onto the current way of io-uring.
> > > > > It _probably_ wouldn't work with IORING_OP_READV/IORING_OP_WRITEV.
> > > > > 
> > > > > https://lore.gnuweeb.org/io-uring/20240511001214.173711-6-ming.lei@redhat.com/T/
> > > > > 
> > > > > > 
> > > > > > Brian was also saying the fuse virtio_fs code may be worth
> > > > > > investigating, maybe that could be adapted?
> > > > > 
> > > > > I need to check, but really, the majority of the new additions
> > > > > is just to set up things, shutdown and to have sanity checks.
> > > > > Request sending/completing to/from the ring is not that much new lines.
> > > > 
> > > > What I'm wondering is how read/write requests are handled. Are the data
> > > > payloads going in the same ringbuffer as the commands? That could work,
> > > > if the ringbuffer is appropriately sized, but alignment is a an issue.
> > > 
> > > That is exactly the big discussion Miklos and I have. Basically in my
> > > series another buffer is vmalloced, mmaped and then assigned to ring entries.
> > > Fuse meta headers and application payload goes into that buffer.
> > > In both kernel/userspace directions. io-uring only allows 80B, so only a
> > > really small request would fit into it.
> > 
> > Well, the generic ringbuffer would lift that restriction.
> 
> Yeah, kind of. Instead allocating the buffer in fuse, it would be now allocated
> in that code. At least all that setup code would be moved out of fuse. I will
> eventually come to your patches today.
> Now we only need to convince Miklos that your ring is better ;)
> 
> > 
> > > Legacy /dev/fuse has an alignment issue as payload follows directly as the fuse
> > > header - intrinsically fixed in the ring patches.
> > 
> > *nod*
> > 
> > That's the big question, put the data inline (with potential alignment
> > hassles) or manage (and map) a separate data structure.
> > 
> > Maybe padding could be inserted to solve alignment?
> 
> Right now I have this struct:
> 
> struct fuse_ring_req {
> 	union {
> 		/* The first 4K are command data */
> 		char ring_header[FUSE_RING_HEADER_BUF_SIZE];
> 
> 		struct {
> 			uint64_t flags;
> 
> 			/* enum fuse_ring_buf_cmd */
> 			uint32_t in_out_arg_len;
> 			uint32_t padding;
> 
> 			/* kernel fills in, reads out */
> 			union {
> 				struct fuse_in_header in;
> 				struct fuse_out_header out;
> 			};
> 		};
> 	};
> 
> 	char in_out_arg[];
> };
> 
> 
> Data go into in_out_arg, i.e. headers are padded by the union.
> I actually wonder if FUSE_RING_HEADER_BUF_SIZE should be page size
> and not a fixed 4K.

I would make the commands variable sized, so that commands with no data
buffers don't need padding, and then when you do have a data command you
only pad out that specific command so that the data buffer starts on a
page boundary.

