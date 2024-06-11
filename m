Return-Path: <io-uring+bounces-2166-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 04E629047B3
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 01:35:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 80E3AB22E7F
	for <lists+io-uring@lfdr.de>; Tue, 11 Jun 2024 23:35:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D03084594C;
	Tue, 11 Jun 2024 23:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EQSI5O/N"
X-Original-To: io-uring@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A160154455
	for <io-uring@vger.kernel.org>; Tue, 11 Jun 2024 23:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718148910; cv=none; b=q93bs4A89laf3012MZRuTDmoORY0lxQ01zJHzyGz9rcCp03QtZ7Ws5VYgQAMkW0dEuDaPqMnQa6BA0OIxb8oZqTJ2qyTbYHOQ2QlwYOBFfKxpesLmCL8aUPEmNL/7nTbUMTfbmsToe0eAP0sAhnRUPprqx1X9WlahBvhd2pq4Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718148910; c=relaxed/simple;
	bh=kx0jnwFfHx0pXiMaG0jVnF0VB8qCjcRFWQY61UFu/t4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IVgkrVLr6gaWT9phB9j2bdSSK9T2LkYG0YG2jo+8T+C/Qe0GXadFQsqMM9CX2V6kTP6n63oq5t8jxRsP7Dcn7ihVFZpkJqvp1DTUM0N1onstsjCR7SlgkhgWSGMjE8rismPv/CEiNngaYw0+kkB2/3EPVnKQ0u5X5DNwfOl3cLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EQSI5O/N; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: bernd.schubert@fastmail.fm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718148907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9Cjknq0RVOyh4UWOHg2cniGcfnX4Dm7y/+Yo/T54704=;
	b=EQSI5O/NkSpUX1Bw8cam3LaOgO8YAC9bkApzrxADLXhslIYL3X4ETjkYwT0xlmd2zQ+7Ql
	tqBUTPZB8Umn1DLKOH2Bedairl7sKZytfi5gV3GyBfjrZB7NhffhzUn2AZAgTdAgLjuCIv
	2dJR4iY89A2bxV1nhueC/U11CIVsDnw=
X-Envelope-To: miklos@szeredi.hu
X-Envelope-To: bschubert@ddn.com
X-Envelope-To: amir73il@gmail.com
X-Envelope-To: linux-fsdevel@vger.kernel.org
X-Envelope-To: akpm@linux-foundation.org
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: mingo@redhat.com
X-Envelope-To: peterz@infradead.org
X-Envelope-To: avagin@google.com
X-Envelope-To: io-uring@vger.kernel.org
Date: Tue, 11 Jun 2024 19:35:01 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Bernd Schubert <bschubert@ddn.com>, 
	Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrei Vagin <avagin@google.com>, io-uring@vger.kernel.org
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
Message-ID: <im6hqczm7qpr3oxndwupyydnclzne6nmpidln6wee4cer7i6up@hmpv4juppgii>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <CAJfpegurSNV3Tw1oKWL1DgnR-tST-JxSAxvTuK2jirm+L-odeQ@mail.gmail.com>
 <99d13ae4-8250-4308-b86d-14abd1de2867@fastmail.fm>
 <CAJfpegu7VwDEBsUG_ERLsN58msXUC14jcxRT_FqL53xm8FKcdg@mail.gmail.com>
 <62ecc4cf-97c8-43e6-84a1-72feddf07d29@fastmail.fm>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62ecc4cf-97c8-43e6-84a1-72feddf07d29@fastmail.fm>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 11, 2024 at 07:37:30PM GMT, Bernd Schubert wrote:
> 
> 
> On 6/11/24 17:35, Miklos Szeredi wrote:
> > On Tue, 11 Jun 2024 at 12:26, Bernd Schubert <bernd.schubert@fastmail.fm> wrote:
> > 
> >> Secondly, with IORING_OP_URING_CMD we already have only a single command
> >> to submit requests and fetch the next one - half of the system calls.
> >>
> >> Wouldn't IORING_OP_READV/IORING_OP_WRITEV be just this approach?
> >> https://github.com/uroni/fuseuring?
> >> I.e. it hook into the existing fuse and just changes from read()/write()
> >> of /dev/fuse to io-uring of /dev/fuse. With the disadvantage of zero
> >> control which ring/queue and which ring-entry handles the request.
> > 
> > Unlike system calls, io_uring ops should have very little overhead.
> > That's one of the main selling points of io_uring (as described in the
> > io_uring(7) man page).
> > 
> > So I don't think it matters to performance whether there's a combined
> > WRITEV + READV (or COMMIT + FETCH) op or separate ops.
> 
> This has to be performance proven and is no means what I'm seeing. How
> should io-uring improve performance if you have the same number of
> system calls?
> 
> As I see it (@Jens or @Pavel or anyone else please correct me if I'm
> wrong), advantage of io-uring comes when there is no syscall overhead at
> all - either you have a ring with multiple entries and then one side
> operates on multiple entries or you have polling and no syscall overhead
> either. We cannot afford cpu intensive polling - out of question,
> besides that I had even tried SQPOLL and it made things worse (that is
> actually where my idea about application polling comes from).
> As I see it, for sync blocking calls (like meta operations) with one
> entry in the queue, you would get no advantage with
> IORING_OP_READV/IORING_OP_WRITEV -  io-uring has  do two system calls -
> one to submit from kernel to userspace and another from userspace to
> kernel. Why should io-uring be faster there?
> 
> And from my testing this is exactly what I had seen - io-uring for meta
> requests (i.e. without a large request queue and *without* core
> affinity) makes meta operations even slower that /dev/fuse.
> 
> For anything that imposes a large ring queue and where either side
> (kernel or userspace) needs to process multiple ring entries - system
> call overhead gets reduced by the queue size. Just for DIO or meta
> operations that is hard to reach.
> 
> Also, if you are using IORING_OP_READV/IORING_OP_WRITEV, nothing would
> change in fuse kernel? I.e. IOs would go via fuse_dev_read()?
> I.e. we would not have encoded in the request which queue it belongs to?

Want to try out my new ringbuffer syscall?

I haven't yet dug far into the fuse protocol or /dev/fuse code yet, only
skimmed. But using it to replace the read/write syscall overhead should
be straightforward; you'll want to spin up a kthread for responding to
requests.

The next thing I was going to look at is how you guys are using splice,
we want to get away from that too.

Brian was also saying the fuse virtio_fs code may be worth
investigating, maybe that could be adapted?

