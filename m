Return-Path: <io-uring+bounces-4391-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 079399BAA1F
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 02:21:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8362281395
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 01:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 606CB14E2FD;
	Mon,  4 Nov 2024 01:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dM/7cYko"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2392EB10
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 01:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730683315; cv=none; b=q6KDJt+ErXLOjRVTXTAFy91aNNJ9Ej5pP1b/xwmmYDKp/zykhQuUeJ0GUadA1E8y1scQvFQW2jWJbAmKwyrl9A93dM2pS3jJj7sCUuq/2LE6jdCcBNjU8fEvNxZFRszkcFicAoGkLIPMUMW1c6KR431I0rzh2K8+bgYzhkIUgUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730683315; c=relaxed/simple;
	bh=Uy99q9eepkEl4NTSA53tC4l4a2Omao+FMYRINELvplE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O5Jg3g9vSPbKGZA647budCv84Tgv7Rv36rFQibTLpg87AsW4I8ABxEiB0deLYQA6soPCgN6kmnkuG2E3cRVdpHy4zUhbqDxv53E2IY5OR8r8fOcIa5HoVSVRTkQDhuKzYuXh5jt+A4MLXpvbCQL7Qwyxm2sUs5DEcQPfyNikpas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dM/7cYko; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730683312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dCTtV2ju/9XvHh9YhtOf3FTrchBZpHdTIhodln+S6Yw=;
	b=dM/7cYkoZenQ2vwYhnAxryRibDMEgGXVPvvqElbDOTIH7ie27iu19rFBZ1BG2o0AejMaCM
	OKqaVsfQkj0698BEgrKHptWhTzkRwiOLDyEggSuJphG0uoHrcCDVGIGFDw5p49Axchiy36
	iGjLpbE1FlFTs3Y+wKssWohAV7Cx7jk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-688-HLcllT7BNaOGLCbHqXG8lg-1; Sun,
 03 Nov 2024 20:21:47 -0500
X-MC-Unique: HLcllT7BNaOGLCbHqXG8lg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5665319560B8;
	Mon,  4 Nov 2024 01:21:46 +0000 (UTC)
Received: from fedora (unknown [10.72.116.38])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DBCC819560A2;
	Mon,  4 Nov 2024 01:21:38 +0000 (UTC)
Date: Mon, 4 Nov 2024 09:21:31 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>
Subject: Re: [PATCH V8 5/7] io_uring: support leased group buffer with
 REQ_F_GROUP_KBUF
Message-ID: <ZyghmwcI1U4WizyX@fedora>
References: <20241025122247.3709133-6-ming.lei@redhat.com>
 <4576f723-5694-40b5-a656-abd1c8d05d62@gmail.com>
 <ZyGBlWUt02xJRQii@fedora>
 <bbf2612e-e029-460f-91cf-e1b00de3e656@gmail.com>
 <ZyGURQ-LgIY9DOmh@fedora>
 <40107636-651f-47ea-8086-58953351c462@gmail.com>
 <ZyQpH8ttWAhS9C5G@fedora>
 <4802ef4c-84ca-4588-aa34-6f1ffa31ac49@gmail.com>
 <ZygSWB08t1PPyPyv@fedora>
 <0cd7e62b-3e5d-46f2-926b-5e3c3f65c7dd@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0cd7e62b-3e5d-46f2-926b-5e3c3f65c7dd@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Mon, Nov 04, 2024 at 01:08:04AM +0000, Pavel Begunkov wrote:
> On 11/4/24 00:16, Ming Lei wrote:
> > On Sun, Nov 03, 2024 at 10:31:25PM +0000, Pavel Begunkov wrote:
> > > On 11/1/24 01:04, Ming Lei wrote:
> > > > On Thu, Oct 31, 2024 at 01:16:07PM +0000, Pavel Begunkov wrote:
> > > > > On 10/30/24 02:04, Ming Lei wrote:
> > > > > > On Wed, Oct 30, 2024 at 01:25:33AM +0000, Pavel Begunkov wrote:
> > > > > > > On 10/30/24 00:45, Ming Lei wrote:
> > > > > > > > On Tue, Oct 29, 2024 at 04:47:59PM +0000, Pavel Begunkov wrote:
> > > > > > > > > On 10/25/24 13:22, Ming Lei wrote:
> > > > > > > > > ...
> > > > > > > > > > diff --git a/io_uring/rw.c b/io_uring/rw.c
> > > > > > > > > > index 4bc0d762627d..5a2025d48804 100644
> > > > > > > > > > --- a/io_uring/rw.c
> > > > > > > > > > +++ b/io_uring/rw.c
> > > > > > > > > > @@ -245,7 +245,8 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
> > > > > > > > > >       	if (io_rw_alloc_async(req))
> > > > > > > > > >       		return -ENOMEM;
> > > > > > > > > > -	if (!do_import || io_do_buffer_select(req))
> > > > > > > > > > +	if (!do_import || io_do_buffer_select(req) ||
> > > > > > > > > > +	    io_use_leased_grp_kbuf(req))
> > > > > > > > > >       		return 0;
> > > > > > > > > >       	rw = req->async_data;
> > > > > > > > > > @@ -489,6 +490,11 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
> > > > > > > > > >       		}
> > > > > > > > > >       		req_set_fail(req);
> > > > > > > > > >       		req->cqe.res = res;
> > > > > > > > > > +		if (io_use_leased_grp_kbuf(req)) {
> > > > > > > > > 
> > > > > > > > > That's what I'm talking about, we're pushing more and
> > > > > > > > > into the generic paths (or patching every single hot opcode
> > > > > > > > > there is). You said it's fine for ublk the way it was, i.e.
> > > > > > > > > without tracking, so let's then pretend it's a ublk specific
> > > > > > > > > feature, kill that addition and settle at that if that's the
> > > > > > > > > way to go.
> > > > > > > > 
> > > > > > > > As I mentioned before, it isn't ublk specific, zeroing is required
> > > > > > > > because the buffer is kernel buffer, that is all. Any other approach
> > > > > > > > needs this kind of handling too. The coming fuse zc need it.
> > > > > > > > 
> > > > > > > > And it can't be done in driver side, because driver has no idea how
> > > > > > > > to consume the kernel buffer.
> > > > > > > > 
> > > > > > > > Also it is only required in case of short read/recv, and it isn't
> > > > > > > > hot path, not mention it is just one check on request flag.
> > > > > > > 
> > > > > > > I agree, it's not hot, it's a failure path, and the recv side
> > > > > > > is of medium hotness, but the main concern is that the feature
> > > > > > > is too actively leaking into other requests.
> > > > > > The point is that if you'd like to support kernel buffer. If yes, this
> > > > > > kind of change can't be avoided.
> > > > > 
> > > > > There is no guarantee with the patchset that there will be any IO done
> > > > > with that buffer, e.g. place a nop into the group, and even then you
> > > > 
> > > > Yes, here it depends on user. In case of ublk, the application has to be
> > > > trusted, and the situation is same with other user-emulated storage, such
> > > > as qemu.
> > > > 
> > > > > have offsets and length, so it's not clear what the zeroying is supposed
> > > > > to achieve.
> > > > 
> > > > The buffer may bee one page cache page, if it isn't initialized
> > > > completely, kernel data may be leaked to userspace via mmap.
> > > > 
> > > > > Either the buffer comes fully "initialised", i.e. free of
> > > > > kernel private data, or we need to track what parts of the buffer were
> > > > > used.
> > > > 
> > > > That is why the only workable way is to zero the remainder in
> > > > consumer of OP, imo.
> > > 
> > > If it can leak kernel data in some way, I'm afraid zeroing of the
> > > remainder alone won't be enough to prevent it, e.g. the recv/read
> > > len doesn't have to match the buffer size.
> > 
> > The leased kernel buffer size is fixed, and the recv/read len is known
> > in case of short read/recv, the remainder part is known too, so can you
> > explain why zeroing remainder alone isn't enough?
> 
> "The buffer may bee one page cache page, if it isn't initialized
> completely, kernel data may be leaked to userspace via mmap."
> 
> I don't know the exact path you meant in this sentence, but let's
> take an example:
> 
> 1. The leaser, e.g. ublk cmd, allocates an uninitialised page and
> leases it to io_uring.
> 
> 2. User space (e.g. ublk user space impl) does some IO to fill
> the buffer, but it's buggy or malicious and fills only half of
> the buffer:
> 
> recv(leased_buffer, offset=0, len = 2K);
> 
> So, one half is filled with data, the other half is still not
> initialsed.

io_req_zero_remained() is added in this patch and called after the
half is done for both io_read() and net recv().

> 
> 3. The lease ends, and we copy full 4K back to user space with the
> unitialised chunk.
> 
> You can correct me on ublk specifics, I assume 3. is not a copy and
> the user in 3 is the one using a ublk block device, but the point I'm
> making is that if something similar is possible, then just zeroing is not
> enough, the user can skip the step filling the buffer. If it can't leak

Can you explain how user skips the step given read IO is member of one group?

> any private data, then the buffer should've already been initialised by
> the time it was lease. Initialised is in the sense that it contains no

For block IO the practice is to zero the remainder after short read, please
see example of loop, lo_complete_rq() & lo_read_simple().

Thanks,
Ming


