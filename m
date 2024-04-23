Return-Path: <io-uring+bounces-1615-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B6738AE790
	for <lists+io-uring@lfdr.de>; Tue, 23 Apr 2024 15:10:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3AC871F25A82
	for <lists+io-uring@lfdr.de>; Tue, 23 Apr 2024 13:10:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E794C134751;
	Tue, 23 Apr 2024 13:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bntP7q+T"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FBC134CF7
	for <io-uring@vger.kernel.org>; Tue, 23 Apr 2024 13:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713877746; cv=none; b=R8Drlj4kum5/kOhEPkW1UIYBwTF1EdFQqqPoVEN8ym8YU7sPkBPA9Ah+7I+m8ykJ0NXqyD1x9p8dXuIicRcWT54ZJLE5plHreJvKLSz38KmCcXJZwG64GK/o+zuMYKlUQtLdkey1v5zQWHS6YYNVT01KQ6BG+vPc8pAJAvBUNWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713877746; c=relaxed/simple;
	bh=v1gU3iDXvFB9615CSisd1aIJpJuGfXzjwHbkoGfSKXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D4rP9i0hKP0eOLDPrwKU0d0qAg+QBr0ne3hYxIakZWadbqS0iUJhniQasjD2zE9cexM+P5VxQMDj0YADuSuWSdJHX9A5G0w5FSUK9WqhQ8F/gCXe6wGp9SVSjoV+OmHpv1hnIRVvze9p8+/xKdB0rmE+oThyXRMTXrUD79j5Qu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bntP7q+T; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713877744;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WlhMbRZb1wmn9lo2JOEuioW89eNr9mYV8YZyWbIWLjA=;
	b=bntP7q+TIEyzv4kXywl+fptuWcsMGzSaQ3YM52dU1zuMlWj60gDq0iheMKFCjb/E/WoU60
	noKDPn3HD0vBVd6dy3lLAGa2sYM4k09qjgJ/Brn8Exojsa0OWrV/Vwb3HlLJBBEpcxGjf8
	ZINAH9Gh1h6ri79tTdAs5OKpBeuImGw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-613-Zpe06I1xNEGgjVdDDuKRzw-1; Tue,
 23 Apr 2024 09:08:58 -0400
X-MC-Unique: Zpe06I1xNEGgjVdDDuKRzw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E6AE51C0AF4F;
	Tue, 23 Apr 2024 13:08:57 +0000 (UTC)
Received: from redhat.com (unknown [10.39.194.8])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E80BF425375;
	Tue, 23 Apr 2024 13:08:56 +0000 (UTC)
Date: Tue, 23 Apr 2024 15:08:55 +0200
From: Kevin Wolf <kwolf@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 5/9] io_uring: support SQE group
Message-ID: <Ziey53aADgxDrXZw@redhat.com>
References: <20240408010322.4104395-1-ming.lei@redhat.com>
 <20240408010322.4104395-6-ming.lei@redhat.com>
 <e36cc8de-3726-4479-8fbd-f54fd21465a2@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e36cc8de-3726-4479-8fbd-f54fd21465a2@kernel.dk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

Am 22.04.2024 um 20:27 hat Jens Axboe geschrieben:
> On 4/7/24 7:03 PM, Ming Lei wrote:
> > SQE group is defined as one chain of SQEs starting with the first sqe that
> > has IOSQE_EXT_SQE_GROUP set, and ending with the first subsequent sqe that
> > doesn't have it set, and it is similar with chain of linked sqes.
> > 
> > The 1st SQE is group leader, and the other SQEs are group member. The group
> > leader is always freed after all members are completed. Group members
> > aren't submitted until the group leader is completed, and there isn't any
> > dependency among group members, and IOSQE_IO_LINK can't be set for group
> > members, same with IOSQE_IO_DRAIN.
> > 
> > Typically the group leader provides or makes resource, and the other members
> > consume the resource, such as scenario of multiple backup, the 1st SQE is to
> > read data from source file into fixed buffer, the other SQEs write data from
> > the same buffer into other destination files. SQE group provides very
> > efficient way to complete this task: 1) fs write SQEs and fs read SQE can be
> > submitted in single syscall, no need to submit fs read SQE first, and wait
> > until read SQE is completed, 2) no need to link all write SQEs together, then
> > write SQEs can be submitted to files concurrently. Meantime application is
> > simplified a lot in this way.
> > 
> > Another use case is to for supporting generic device zero copy:
> > 
> > - the lead SQE is for providing device buffer, which is owned by device or
> >   kernel, can't be cross userspace, otherwise easy to cause leak for devil
> >   application or panic
> > 
> > - member SQEs reads or writes concurrently against the buffer provided by lead
> >   SQE
> 
> In concept, this looks very similar to "sqe bundles" that I played with
> in the past:
> 
> https://git.kernel.dk/cgit/linux/log/?h=io_uring-bundle
> 
> Didn't look too closely yet at the implementation, but in spirit it's
> about the same in that the first entry is processed first, and there's
> no ordering implied between the test of the members of the bundle /
> group.

When I first read this patch, I wondered if it wouldn't make sense to
allow linking a group with subsequent requests, e.g. first having a few
requests that run in parallel and once all of them have completed
continue with the next linked one sequentially.

For SQE bundles, you reused the LINK flag, which doesn't easily allow
this. Ming's patch uses a new flag for groups, so the interface would be
more obvious, you simply set the LINK flag on the last member of the
group (or on the leader, doesn't really matter). Of course, this doesn't
mean it has to be implemented now, but there is a clear way forward if
it's wanted.

The part that looks a bit arbitrary in Ming's patch is that the group
leader is always completed before the rest starts. It makes perfect
sense in the context that this series is really after (enabling zero
copy for ublk), but it doesn't really allow the case you mention in the
SQE bundle commit message, running everything in parallel and getting a
single CQE for the whole group.

I suppose you could hack around the sequential nature of the first
request by using an extra NOP as the group leader - which isn't any
worse than having an IORING_OP_BUNDLE really, just looks a bit odd - but
the group completion would still be missing. (Of course, removing the
sequential first operation would mean that ublk wouldn't have the buffer
ready any more when the other requests try to use it, so that would
defeat the purpose of the series...)

I wonder if we can still combine both approaches and create some
generally useful infrastructure and not something where it's visible
that it was designed mostly for ublk's special case and other use cases
just happened to be enabled as a side effect.

Kevin


