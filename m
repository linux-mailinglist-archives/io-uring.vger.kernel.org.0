Return-Path: <io-uring+bounces-4304-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 604A09B9356
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 15:34:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F3411C2109E
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 14:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA59C1A4F12;
	Fri,  1 Nov 2024 14:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FcNvmBIj"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5381537C3
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 14:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730471688; cv=none; b=YdZN45D7nLYRZDQja+HBSg6lAkIBdsl36LMuAHCe6SL0OMqMPZDDibwZLEeQ6PzvV8As7plUFgFN0imVliKx8nRAShpet+NvHHrsVJoBrrm/poZDeer3Pw9eiG8LLa1SyXEvP3OiPT7q4C9HNSJVga4p+IAt4R0mmZz1V9BfbF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730471688; c=relaxed/simple;
	bh=znALVoe/nNBIFROgHkilkx79Wfa0UZFGsd771DYl6S4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IFdvteTmd+vqgxS2QMq/ZKvL1b8SL3W5xswk1fejvsOuqrGhYK9ZVrH/cRqXDUJoMcK0UiLl4jTKOU1cVtNydc1l9+y+jLRtmoBnTX/brC/+MwOgDlxLlQLzIB1rn2QdZLiHR7OJQ72rffV+Ri7AABRhF+CpfYIEGcv6NOYsD38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FcNvmBIj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730471685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BMMn8CxSmhMP7Ybc0Ow3SfhL5HiE7PLK1zmVbJpMZzM=;
	b=FcNvmBIjTufhJzKHqudLMvLUwgc4C4zFdSlxadC5iVIHx8XqExG8E/5s0/sg0S+3j14RT2
	2SyakDkPvsitmJg3jOY+nzz6X5zzCBdI3/j5giwMkHpRpULWw7gyX4xMwTUM9YFULO5fmH
	qBlR3OwhUt5EwuR/TCrREnFQBj39ifc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-223-tXC6Q4pbPcC3U0x2zso4Vg-1; Fri,
 01 Nov 2024 10:34:40 -0400
X-MC-Unique: tXC6Q4pbPcC3U0x2zso4Vg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AC15819560AA;
	Fri,  1 Nov 2024 14:34:39 +0000 (UTC)
Received: from fedora (unknown [10.72.116.17])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A12D2300018D;
	Fri,  1 Nov 2024 14:34:35 +0000 (UTC)
Date: Fri, 1 Nov 2024 22:34:30 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH RFC] io_uring: extend io_uring_sqe flags bits
Message-ID: <ZyTm9rBQpy7WFdwK@fedora>
References: <e60a3dd3-3a74-4181-8430-90c106a202f6@kernel.dk>
 <ZyQ5CcwfLhaASvMz@fedora>
 <ZyRAKm0IQV7wWjhC@fedora>
 <3a907323-331f-4442-a2a0-4e2757aaba8b@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a907323-331f-4442-a2a0-4e2757aaba8b@kernel.dk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Fri, Nov 01, 2024 at 07:59:38AM -0600, Jens Axboe wrote:
> On 10/31/24 8:42 PM, Ming Lei wrote:
> > On Fri, Nov 01, 2024 at 10:12:25AM +0800, Ming Lei wrote:
> >> On Thu, Oct 31, 2024 at 03:22:18PM -0600, Jens Axboe wrote:
> >>> In hindsight everything is clearer, but it probably should've been known
> >>> that 8 bits of ->flags would run out sooner than later. Rather than
> >>> gobble up the last bit for a random use case, add a bit that controls
> >>> whether or not ->personality is used as a flags2 argument. If that is
> >>> the case, then there's a new IOSQE2_PERSONALITY flag that tells io_uring
> >>> which personality field to read.
> >>>
> >>> While this isn't the prettiest, it does allow extending with 15 extra
> >>> flags, and retains being able to use personality with any kind of
> >>> command. The exception is uring cmd, where personality2 will overlap
> >>> with the space set aside for SQE128. If they really need that, then that
> >>
> >> The space is the 1st `short` for uring_cmd, instead of SQE128 only.
> >>
> >> Also it is overlapped with ->optval and ->addr3, so just wondering why not
> >> use ->__pad2?
> >>
> >> Another ways is to use __pad2 for sqe2_flags for non-uring_cmd, and for
> >> uring_cmd, use its top 16 as sqe2_flags, this way does work, but it is
> >> just a bit ugly to use.
> > 
> > Also IOSQE2_PERSONALITY doesn't have to be per-SQE, and it can be one
> > feature of IORING_FEAT_IOSQE2_PERSONALITY, that is why I thought it is
> > fine to take the 7th bit as SQE_GROUP now.
> 
> Not sure I follow your thinking there, can you expand?

It could be one io_uring setup flag, such as IORING_SETUP_IOSQE2_PERSONALITY.

If this flag is set, take __pad2 as sqe2_flags, otherwise use current way, so
it doesn't have to take bit7 of sqe_flags for this purpose.

Also in future, if uring_cmd needs personality, it still may reuse top
16bit of uring_cmd_flags for that.



Thanks,
Ming


