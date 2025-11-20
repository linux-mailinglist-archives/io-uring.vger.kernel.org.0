Return-Path: <io-uring+bounces-10671-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 82948C71B30
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 02:41:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 621CB28F0A
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 01:41:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01C6E25D209;
	Thu, 20 Nov 2025 01:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BE19eEk7"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA652571AD
	for <io-uring@vger.kernel.org>; Thu, 20 Nov 2025 01:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763602903; cv=none; b=D2JBh6JYuoFUbhKgQcGlnzO2B+Kbl3oSgj7AydLDkI7LPsYZVqzbCAUjHBwTYWK7LeLrUsbLP4xubCxK1gTLticr2sGGT54yM0T/Kk1RwS2gTtoAFXYuYvRusqrbdAGp/zKzNxNTbZfhg5j2PiIo0auMie2nJ24fv4PmY59Qg14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763602903; c=relaxed/simple;
	bh=YkQtjIdTNJSYgaCKJI3D1I0j7sgJJFkSidJzXBG1ibU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cmusyuWq+lqJQ8T0kVie2nh/iql5UGYpGbDwejZeAM+6CVnuBMNccecm9Txm7Fn3G5AW3KAefSml4LouQrpayvM7f9OQnDuo3/EX7n6M8jFFHRt0+E7d/Rtizmij5VEl92WgiX4WEmuV6bcGARfzxCHinIK7N7Lr/1FlSoXbh9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BE19eEk7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763602900;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wuZcH/jpD+V8vNTE4HZRdGth/pGF2BCO/c+oNT+1MhA=;
	b=BE19eEk76jUiKPLNmoWI9UOIhWp34bewICTJdVsJTzoGYqiMtKQJXVVnAmGl4l7vuZYY6a
	FM2LuODkot3DutBQTzR4vNiaL7ajK3uAAYhfb5Aagg0JsNgKwtjCvDcFZ9KekZkXENIs3U
	oINUHG5hQwsbXkaQoBNKHzx+mJZ6hdQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-133-sEfeRA_hMIiCAVyEWvt8OA-1; Wed,
 19 Nov 2025 20:41:36 -0500
X-MC-Unique: sEfeRA_hMIiCAVyEWvt8OA-1
X-Mimecast-MFC-AGG-ID: sEfeRA_hMIiCAVyEWvt8OA_1763602895
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 964731956096;
	Thu, 20 Nov 2025 01:41:34 +0000 (UTC)
Received: from fedora (unknown [10.72.116.74])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D3E5F19560B0;
	Thu, 20 Nov 2025 01:41:29 +0000 (UTC)
Date: Thu, 20 Nov 2025 09:41:24 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk,
	Martin KaFai Lau <martin.lau@linux.dev>, bpf@vger.kernel.org,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH v3 10/10] selftests/io_uring: add bpf io_uring selftests
Message-ID: <aR5xxLu-3Ylrl2os@fedora>
References: <cover.1763031077.git.asml.silence@gmail.com>
 <6143e4393c645c539fc34dc37eeb6d682ad073b9.1763031077.git.asml.silence@gmail.com>
 <aRcp5Gi41i-g64ov@fedora>
 <82fe6ace-2cfe-4351-b7b4-895e9c29cced@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82fe6ace-2cfe-4351-b7b4-895e9c29cced@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Wed, Nov 19, 2025 at 07:00:41PM +0000, Pavel Begunkov wrote:
> On 11/14/25 13:08, Ming Lei wrote:
> > On Thu, Nov 13, 2025 at 11:59:47AM +0000, Pavel Begunkov wrote:
> ...
> > > +	bpf_printk("queue nop request, data %lu\n", (unsigned long)reqs_to_run);
> > > +	sqe = &sqes[sq_hdr->tail & (SQ_ENTRIES - 1)];
> > > +	sqe->user_data = reqs_to_run;
> > > +	sq_hdr->tail++;
> > 
> > Looks this way turns io_uring_enter() into pthread-unsafe, does it need to
> > be documented?
> 
> Assuming you mean parallel io_uring_enter() calls modifying the SQ,
> it's not different from how it currently is. If you're sharing an
> io_uring, threads need to sync the use of SQ/CQ.

Please see the example:

thread_fn(struct io_uring *ring)
{
	while (true) {
		pthread_mutex_lock(sqe_mutex);
		sqe = io_uring_get_sqe(ring);
		io_uring_prep_op(sqe);
		pthread_mutex_unlock(sqe_mutex);

		io_uring_enter(ring);

		pthread_mutex_lock(cqe_mutex);
		io_uring_wait_cqe(ring, &cqe);
		io_uring_cqe_seen(ring, cqe);
		pthread_mutex_unlock(cqe_mutex);
	}
}

`thread_fn` is supposed to work concurrently from >1 pthreads:

1) io_uring_enter() is claimed as pthread safe

2) because of userspace lock protection, there is single code path for
producing sqe for SQ at same time, and single code path for consuming sqe
from io_uring_enter().

With bpf controlled io_uring patches, sqe can be produced from io_uring_enter(),
and cqe can be consumed in io_uring_enter() too, there will be race between
bpf prog(producing sqe, or consuming cqe) and userspace lock-protected
code block.


Thanks,
Ming


