Return-Path: <io-uring+bounces-7228-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F2B4DA6FE1D
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 13:51:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D345219A0AC2
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 12:45:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE2DD2627F5;
	Tue, 25 Mar 2025 12:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T2cStf5v"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F252620C6
	for <io-uring@vger.kernel.org>; Tue, 25 Mar 2025 12:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905446; cv=none; b=pDRIbDqLp/KVVgwsZSnJTVAMSX06JhBPV3MNMxz6CBZTy+TeoKLLcqjY1UMI/17iMzPIxtgvFvYMmDKIdIeE/VAM6rWUgFEe0+Ye0nM8myHaW9kCvZj12vy38JPGK/NMnkR/5kCJbLAgy9e6NN2fu/XjNiizIIbTLQMNW1u7tYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905446; c=relaxed/simple;
	bh=wn1WBoIMzL15p320nXFa8dKndRoz/qSGoUe1u5eIMCQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NgM9Yf+ekPlX/ktmTamzKlioR2tyLKX/5o5kV3AzqHSPJES/fgs9eDSvRiXTl/DAISyfhbniS+1Do77h5gvaikJiFA/6rrFHek0YS/aVi5ME8I9I/JjYJIuukyfrUdS6NnVycGMPNoHqTnU8BjDjAR7kdxuNELA8Xn0VcHVDNnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T2cStf5v; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742905443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8FZoxiXkYnN/E/dxEvlD3+meuAIyG+ElT4G9u+2PW1g=;
	b=T2cStf5v6jLrUZg0Zv/+LJlDGP0ASsfO94Yn7ChoQK8hw/pfxxiU4p2atp8NSYYIZuhaKv
	z2RCKrc75Vov+NYPJE6EsEoKhMCO5apyaOJUmKbVwNvyKz9u0FZpbHi9dxA9nWeC/bw16t
	C8pm0H6esXdDK0GoAWS3Oim0cCI9nA8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-456-1sbbKYNFPeeJZ9r7Jdz1Wg-1; Tue,
 25 Mar 2025 08:24:00 -0400
X-MC-Unique: 1sbbKYNFPeeJZ9r7Jdz1Wg-1
X-Mimecast-MFC-AGG-ID: 1sbbKYNFPeeJZ9r7Jdz1Wg_1742905438
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B1EBC180049D;
	Tue, 25 Mar 2025 12:23:57 +0000 (UTC)
Received: from fedora (unknown [10.72.120.3])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 397CA180A803;
	Tue, 25 Mar 2025 12:23:48 +0000 (UTC)
Date: Tue, 25 Mar 2025 20:23:43 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Jooyung Han <jooyung@google.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Heinz Mauelshagen <heinzm@redhat.com>, zkabelac@redhat.com,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH] the dm-loop target
Message-ID: <Z-KgT3Xine0kcVo-@fedora>
References: <Z9ATyhq6PzOh7onx@fedora>
 <Z9DymjGRW3mTPJTt@dread.disaster.area>
 <Z9FFTiuMC8WD6qMH@fedora>
 <7b8b8a24-f36b-d213-cca1-d8857b6aca02@redhat.com>
 <Z9j2RJBark15LQQ1@dread.disaster.area>
 <Z9knXQixQhs90j5F@infradead.org>
 <Z9k-JE8FmWKe0fm0@fedora>
 <Z9u-489C_PVu8Se1@infradead.org>
 <Z9vGxrPzJ6oswWrS@fedora>
 <Z-KCPvmBO3AeuiDf@dread.disaster.area>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-KCPvmBO3AeuiDf@dread.disaster.area>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Tue, Mar 25, 2025 at 09:15:26PM +1100, Dave Chinner wrote:
> On Thu, Mar 20, 2025 at 03:41:58PM +0800, Ming Lei wrote:
> > On Thu, Mar 20, 2025 at 12:08:19AM -0700, Christoph Hellwig wrote:
> > > On Tue, Mar 18, 2025 at 05:34:28PM +0800, Ming Lei wrote:
> > > > On Tue, Mar 18, 2025 at 12:57:17AM -0700, Christoph Hellwig wrote:
> > > > > On Tue, Mar 18, 2025 at 03:27:48PM +1100, Dave Chinner wrote:
> > > > > > Yes, NOWAIT may then add an incremental performance improvement on
> > > > > > top for optimal layout cases, but I'm still not yet convinced that
> > > > > > it is a generally applicable loop device optimisation that everyone
> > > > > > wants to always enable due to the potential for 100% NOWAIT
> > > > > > submission failure on any given loop device.....
> > > > 
> > > > NOWAIT failure can be avoided actually:
> > > > 
> > > > https://lore.kernel.org/linux-block/20250314021148.3081954-6-ming.lei@redhat.com/
> > > 
> > > That's a very complex set of heuristics which doesn't match up
> > > with other uses of it.
> > 
> > I'd suggest you to point them out in the patch review.
> 
> Until you pointed them out here, I didn't know these patches
> existed.
> 
> Please cc linux-fsdevel on any loop device changes you are
> proposing, Ming. It is as much a filesystem driver as it is a block
> device, and it changes need review from both sides of the fence.

Please see the patchset:

https://lore.kernel.org/linux-block/20250322012617.354222-1-ming.lei@redhat.com/

> 
> > > > > Yes, I think this is a really good first step:
> > > > > 
> > > > > 1) switch loop to use a per-command work_item unconditionally, which also
> > > > >    has the nice effect that it cleans up the horrible mess of the
> > > > >    per-blkcg workers.  (note that this is what the nvmet file backend has
> > > > 
> > > > It could be worse to take per-command work, because IO handling crosses
> > > > all system wq worker contexts.
> > > 
> > > So do other workloads with pretty good success.
> > > 
> > > > 
> > > > >    always done with good result)
> > > > 
> > > > per-command work does burn lots of CPU unnecessarily, it isn't good for
> > > > use case of container
> > > 
> > > That does not match my observations in say nvmet.  But if you have
> > > numbers please share them.
> > 
> > Please see the result I posted:
> > 
> > https://lore.kernel.org/linux-block/Z9FFTiuMC8WD6qMH@fedora/
> 
> You are arguing in circles about how we need to optimise for static
> file layouts.
> 
> Please listen to the filesystem people when they tell you that
> static file layouts are a -secondary- optimisation target for loop
> devices.
> 
> The primary optimisation target is the modification that makes all
> types of IO perform better in production, not just the one use case
> that overwrite-specific IO benchmarks exercise.
> 
> If you want me to test your changes, I have a very loop device heavy
> workload here - it currently creates about 300 *sparse* loop devices
> totalling about 1.2TB of capacity, then does all sorts of IO to them
> through both the loop devices themselves and filesystems created on
> top of the loop devices. It typically generates 4-5GB/s of IO
> through the loop devices to the backing filesystem and it's physical
> storage.

The patchset does cover the sparse backfile, and I also provide one test
case in which one completely sparse file is used, and make sure that
there isn't regression in this case.

This patchset is supposed to address Mikulas's case of stable FS mapping,
meantime without introducing regression on other cases, such as
the sparse backing file.

> 
> Speeding up or slowing down IO submission through the loop devices
> has direct impact on the speed of the workload. Using buffered IO
> through the loop device right now is about 25% faster than using
> aio+dio for the loop because there is some amount of re-read and
> re-write in the filesystem IO patterns. That said, AIO+DIO should be
> much faster than it is, hence my interest in making all the AIO+DIO
> IO submission independent of potential blocking operations.
> 
> Hence if you have patch sets that improve loop device performance,
> then you need to make sure filesystem people like myself see those
> patch series so they can be tested and reviewed in a timely manner.
> That means you need to cc loop device patches to linux-fsdevel....

OK, will Cc you and linux-fsdevel in future loop patch submission.


Thanks,
Ming


