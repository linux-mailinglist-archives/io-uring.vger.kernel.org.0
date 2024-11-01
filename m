Return-Path: <io-uring+bounces-4308-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B94C9B93E0
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 16:01:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BB691C209D7
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 15:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6888E40BF5;
	Fri,  1 Nov 2024 15:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FLRkXbfd"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93A93EA98
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 15:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730473282; cv=none; b=VZLz0Tjae68epICtvDCzHppwE/3RhI+UBFLtzDE7QSfkoLNZ5nFI2gT8dyD8v6BZyhQfL2Z0weDmrRFz7UJX8SckfFkz/MX+RRLq7uic18Xfc1XuYH7kVtarux+LqQVnYU5ckW9vtCAJAHYv7DgOv4TaZ3JzIRRsJcp3BbXklyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730473282; c=relaxed/simple;
	bh=29P6qYoBRSA5hflh9KV+pDsDVHmmBufTpx2lywLMft8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N4Yau317u7lIsA+Xx+quUjVr9DM9WEsKrv9H9RaMRe/vWOwhtJGuWqdEw2DQWRzNlINA7HRdoqxnVhsxc6GjegEv+oqsRQBEIH4JWHi74+OSxh0JzGvlpKmwhMawu4bqvlGOLgR3dDRPNaoF+by+HEA8xwx8KOAXpqvWe/js+w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FLRkXbfd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730473278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t5DcpsCznkP2D2HWm3ELdL3zbFTUd1ebxYCtDaB0IoY=;
	b=FLRkXbfdIRZdSepX1z0Y3J+V98Znnf44lCgUetjIEO7YihobxeXFaV/OC9E+P5v4g9FH22
	RoWItJ0vgBTylOyNyo0rlWELTKO6Yi/b/RHWPJYFqkTJYfzOdpIXGc96dONrHVBq2/caid
	n2GVAISHvPFCZ9zi4qWAhtGEdZwKmog=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-284-To6-udLGP8ubhFI3WD4LDg-1; Fri,
 01 Nov 2024 11:01:14 -0400
X-MC-Unique: To6-udLGP8ubhFI3WD4LDg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD0521955EEA;
	Fri,  1 Nov 2024 15:01:12 +0000 (UTC)
Received: from fedora (unknown [10.72.116.17])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C9CFB1956086;
	Fri,  1 Nov 2024 15:01:08 +0000 (UTC)
Date: Fri, 1 Nov 2024 23:01:04 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH RFC] io_uring: extend io_uring_sqe flags bits
Message-ID: <ZyTtMJBRJuqsdeBV@fedora>
References: <e60a3dd3-3a74-4181-8430-90c106a202f6@kernel.dk>
 <ZyQ5CcwfLhaASvMz@fedora>
 <ZyRAKm0IQV7wWjhC@fedora>
 <3a907323-331f-4442-a2a0-4e2757aaba8b@kernel.dk>
 <ZyTm9rBQpy7WFdwK@fedora>
 <e648e765-9076-4236-a75d-c7baf68c1040@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e648e765-9076-4236-a75d-c7baf68c1040@kernel.dk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Fri, Nov 01, 2024 at 08:42:42AM -0600, Jens Axboe wrote:
> On 11/1/24 8:34 AM, Ming Lei wrote:
> > On Fri, Nov 01, 2024 at 07:59:38AM -0600, Jens Axboe wrote:
> >> On 10/31/24 8:42 PM, Ming Lei wrote:
> >>> On Fri, Nov 01, 2024 at 10:12:25AM +0800, Ming Lei wrote:
> >>>> On Thu, Oct 31, 2024 at 03:22:18PM -0600, Jens Axboe wrote:
> >>>>> In hindsight everything is clearer, but it probably should've been known
> >>>>> that 8 bits of ->flags would run out sooner than later. Rather than
> >>>>> gobble up the last bit for a random use case, add a bit that controls
> >>>>> whether or not ->personality is used as a flags2 argument. If that is
> >>>>> the case, then there's a new IOSQE2_PERSONALITY flag that tells io_uring
> >>>>> which personality field to read.
> >>>>>
> >>>>> While this isn't the prettiest, it does allow extending with 15 extra
> >>>>> flags, and retains being able to use personality with any kind of
> >>>>> command. The exception is uring cmd, where personality2 will overlap
> >>>>> with the space set aside for SQE128. If they really need that, then that
> >>>>
> >>>> The space is the 1st `short` for uring_cmd, instead of SQE128 only.
> >>>>
> >>>> Also it is overlapped with ->optval and ->addr3, so just wondering why not
> >>>> use ->__pad2?
> >>>>
> >>>> Another ways is to use __pad2 for sqe2_flags for non-uring_cmd, and for
> >>>> uring_cmd, use its top 16 as sqe2_flags, this way does work, but it is
> >>>> just a bit ugly to use.
> >>>
> >>> Also IOSQE2_PERSONALITY doesn't have to be per-SQE, and it can be one
> >>> feature of IORING_FEAT_IOSQE2_PERSONALITY, that is why I thought it is
> >>> fine to take the 7th bit as SQE_GROUP now.
> >>
> >> Not sure I follow your thinking there, can you expand?
> > 
> > It could be one io_uring setup flag, such as
> > IORING_SETUP_IOSQE2_PERSONALITY.
> > 
> > If this flag is set, take __pad2 as sqe2_flags, otherwise use current
> > way, so it doesn't have to take bit7 of sqe_flags for this purpose.
> 
> Would probably have to be a IORING_SETUP_IOSQE2_FLAGS or something in
> general. And while that could work, not a huge fan of that. I think we
> should retain that for when a v2 of the sqe is done, to coordinate which
> version to use.

Fair enough.

Now there are 16bits for new features, which may put v2 off long enough.

> 
> > Also in future, if uring_cmd needs personality, it still may reuse top
> > 16bit of uring_cmd_flags for that.
> 
> Right, that's what I referred to in terms of uring_cmd just having its
> own way to set personality.

Then this approach is safe to go, imo.


Thanks,
Ming


