Return-Path: <io-uring+bounces-1619-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 937C68AFDF9
	for <lists+io-uring@lfdr.de>; Wed, 24 Apr 2024 03:41:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A0A32B21B9F
	for <lists+io-uring@lfdr.de>; Wed, 24 Apr 2024 01:41:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E482BE4D;
	Wed, 24 Apr 2024 01:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F+VHJ7XT"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E4DC8E9
	for <io-uring@vger.kernel.org>; Wed, 24 Apr 2024 01:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713922796; cv=none; b=S2AMmmywM1FWMLwIa39rOT/IJPm+uEVMQzywMq5Qj5ZULeoSYHw+lgpUgjPARPtbq5rYaPLHgERmqxQH/ZWULrOFQlSTzrs/adZvwl8BdhmaVD5YFHHQuMQRq7FzjlHy0LxExLuaIq5qkQ2reknZegH3ojx8LYvk1b1HmCcfjFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713922796; c=relaxed/simple;
	bh=nBWq0/nl7p+r4jZzeXlnnXvRGayO9S0mCF9/Glj+3J4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YF0opaeuhCfIJvgKN3/BIFzOS4rQ6ltspSl65NtJZs5KcG5BT7UTEqFIQOjWyK6YMLyVWDuQnByY9TJthc3fhYaYQpcNezms6rgEx4CKQ7ffXo2EXYOLljtus26Mw0Av6CE8Jft3U4V7k7znaBhlSFy3RhW3IpxycQvijIKf7pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F+VHJ7XT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713922793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Aw7xummt3AxEBlh1tPOSPjycxwKKfpMU9IKieHaf6X8=;
	b=F+VHJ7XTR3YJ48e1TlS/oPk3Q6OKXs9BPj2Evv7WFVET2Vk9BTU0l9bxhqakLcBC8L4zpz
	ZmcyLsabha+K5jdmmR0e2znjbu9fA+gvYH3KDgAsGqQCWZSIXzekwbPlQOI1mw6sIsku6m
	mEE0vuCrqVRTZlO9tpLwjIozMUrX9qY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-547-vfanGcmbM7il8z_tJpwDsg-1; Tue, 23 Apr 2024 21:39:50 -0400
X-MC-Unique: vfanGcmbM7il8z_tJpwDsg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6EDE61005D7C;
	Wed, 24 Apr 2024 01:39:50 +0000 (UTC)
Received: from fedora (unknown [10.72.116.33])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B1414400EAC;
	Wed, 24 Apr 2024 01:39:46 +0000 (UTC)
Date: Wed, 24 Apr 2024 09:39:42 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Kevin Wolf <kwolf@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>, ming.lei@redhat.com
Subject: Re: [PATCH 5/9] io_uring: support SQE group
Message-ID: <Zihi3nDAJg1s7Cws@fedora>
References: <20240408010322.4104395-1-ming.lei@redhat.com>
 <20240408010322.4104395-6-ming.lei@redhat.com>
 <e36cc8de-3726-4479-8fbd-f54fd21465a2@kernel.dk>
 <Ziey53aADgxDrXZw@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ziey53aADgxDrXZw@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

On Tue, Apr 23, 2024 at 03:08:55PM +0200, Kevin Wolf wrote:
> Am 22.04.2024 um 20:27 hat Jens Axboe geschrieben:
> > On 4/7/24 7:03 PM, Ming Lei wrote:
> > > SQE group is defined as one chain of SQEs starting with the first sqe that
> > > has IOSQE_EXT_SQE_GROUP set, and ending with the first subsequent sqe that
> > > doesn't have it set, and it is similar with chain of linked sqes.
> > > 
> > > The 1st SQE is group leader, and the other SQEs are group member. The group
> > > leader is always freed after all members are completed. Group members
> > > aren't submitted until the group leader is completed, and there isn't any
> > > dependency among group members, and IOSQE_IO_LINK can't be set for group
> > > members, same with IOSQE_IO_DRAIN.
> > > 
> > > Typically the group leader provides or makes resource, and the other members
> > > consume the resource, such as scenario of multiple backup, the 1st SQE is to
> > > read data from source file into fixed buffer, the other SQEs write data from
> > > the same buffer into other destination files. SQE group provides very
> > > efficient way to complete this task: 1) fs write SQEs and fs read SQE can be
> > > submitted in single syscall, no need to submit fs read SQE first, and wait
> > > until read SQE is completed, 2) no need to link all write SQEs together, then
> > > write SQEs can be submitted to files concurrently. Meantime application is
> > > simplified a lot in this way.
> > > 
> > > Another use case is to for supporting generic device zero copy:
> > > 
> > > - the lead SQE is for providing device buffer, which is owned by device or
> > >   kernel, can't be cross userspace, otherwise easy to cause leak for devil
> > >   application or panic
> > > 
> > > - member SQEs reads or writes concurrently against the buffer provided by lead
> > >   SQE
> > 
> > In concept, this looks very similar to "sqe bundles" that I played with
> > in the past:
> > 
> > https://git.kernel.dk/cgit/linux/log/?h=io_uring-bundle
> > 
> > Didn't look too closely yet at the implementation, but in spirit it's
> > about the same in that the first entry is processed first, and there's
> > no ordering implied between the test of the members of the bundle /
> > group.
> 
> When I first read this patch, I wondered if it wouldn't make sense to
> allow linking a group with subsequent requests, e.g. first having a few
> requests that run in parallel and once all of them have completed
> continue with the next linked one sequentially.
> 
> For SQE bundles, you reused the LINK flag, which doesn't easily allow
> this. Ming's patch uses a new flag for groups, so the interface would be
> more obvious, you simply set the LINK flag on the last member of the
> group (or on the leader, doesn't really matter). Of course, this doesn't
> mean it has to be implemented now, but there is a clear way forward if
> it's wanted.

Reusing LINK for bundle breaks existed link chains(BUNDLE linked to existed
link chain), so I think it may not work.

The link rule is explicit for sqe group:

- only group leader can set link flag, which is applied on the whole
group: the next sqe in the link chain won't be started until the
previous linked sqe group is completed

- link flag can't be set for group members

Also sqe group doesn't limit async for both group leader and member.

sqe group vs link & async is covered in the last liburing test code.

> 
> The part that looks a bit arbitrary in Ming's patch is that the group
> leader is always completed before the rest starts. It makes perfect
> sense in the context that this series is really after (enabling zero
> copy for ublk), but it doesn't really allow the case you mention in the
> SQE bundle commit message, running everything in parallel and getting a
> single CQE for the whole group.

I think it should be easy to cover bundle in this way, such as add one new
op IORING_OP_BUNDLE as Jens did, and implement the single CQE for whole group/bundle.

> 
> I suppose you could hack around the sequential nature of the first
> request by using an extra NOP as the group leader - which isn't any
> worse than having an IORING_OP_BUNDLE really, just looks a bit odd - but
> the group completion would still be missing. (Of course, removing the
> sequential first operation would mean that ublk wouldn't have the buffer
> ready any more when the other requests try to use it, so that would
> defeat the purpose of the series...)
> 
> I wonder if we can still combine both approaches and create some
> generally useful infrastructure and not something where it's visible
> that it was designed mostly for ublk's special case and other use cases
> just happened to be enabled as a side effect.

sqe group is actually one generic interface, please see the multiple copy(
copy one file to multiple destinations in single syscall for one range) example
in the last patch, and it can support generic device zero copy: any device internal
buffer can be linked with io_uring operations in this way, which can't
be done by traditional splice/pipe.

I guess it can be used in network Rx zero copy too, but may depend on actual
network Rx use case.



Thanks,
Ming


