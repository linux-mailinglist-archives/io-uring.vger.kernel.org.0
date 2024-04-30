Return-Path: <io-uring+bounces-1686-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFAEE8B7675
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 14:57:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3A151C20C68
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 12:57:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B166717165D;
	Tue, 30 Apr 2024 12:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cBZ6ZVos"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F222A171E4D
	for <io-uring@vger.kernel.org>; Tue, 30 Apr 2024 12:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481818; cv=none; b=cW+bGplDdhiJwy9RKZXcgUnxLWtPUZpZ/b5NKIUyHsoAIir7iImXwMaxWMqL2j4lLzz9/WbU+nrfC+XLIO4qqaI3aNYgIMnQdZysDRuHajDvoApeawbLbWrtoOu/PkLU9TINf17au47qxZ/LKogj4htcvc7ZZFAJmQRVmfAis6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481818; c=relaxed/simple;
	bh=Wv20oWplSg0tGu8RRHKogQ8m5TUoaW/Q6lGphOdcK1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ShFpcOjXbaNOVnFnA4cIr/vA8Gb/jcR3ShFeiO44e8mZ+vz7sdPyfYjyGEZu/M8mO4D/zmvgjiow6lsm7Gi2tV8cYzTyP7ZpyYed4jxLuHnyeQQULOkOis2/CcZwvBx7P+ZTENd+HAHPyDprIVRYRE0jkDtC5r7H6DU1ceJiL08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cBZ6ZVos; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714481816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uyY6DBPT5jy7KF2IEGx8U7pldZaUUgnYl/UdxFULhCk=;
	b=cBZ6ZVosI1qnD+EHegXMUoLtXQ9/B/EFELkOPvw4f4YK0qew6SLjw3Ll+PZWbaibxTjMcA
	aW2p99odGWSuSSxRJTBlVOigofrnBYep9U70L0p4492Kx/hnSXQETQNAX8Q6exfUCstmFb
	ZTN2vwOJxplafN1o7u9dtqNMin4YeDo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-199-gi1Wm3sIOBGbpJDLh-0kaQ-1; Tue, 30 Apr 2024 08:56:51 -0400
X-MC-Unique: gi1Wm3sIOBGbpJDLh-0kaQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D1B6889F61;
	Tue, 30 Apr 2024 12:56:23 +0000 (UTC)
Received: from fedora (unknown [10.72.116.42])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 46B944067A1E;
	Tue, 30 Apr 2024 12:56:18 +0000 (UTC)
Date: Tue, 30 Apr 2024 20:56:15 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>,
	ming.lei@redhat.com
Subject: Re: [PATCH 2/9] io_uring: support user sqe ext flags
Message-ID: <ZjDqb80OTfb6WzBp@fedora>
References: <20240408010322.4104395-1-ming.lei@redhat.com>
 <20240408010322.4104395-3-ming.lei@redhat.com>
 <89dac454-6521-4bd8-b8aa-ad329b887396@kernel.dk>
 <Zie+RlbtckZJVE2J@fedora>
 <e0d52e3f-f599-42c8-b9f0-8242961291d0@gmail.com>
 <ZjBozhXCCs46OeWK@fedora>
 <81bc860f-0801-478b-adba-ea2a90cfe69e@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81bc860f-0801-478b-adba-ea2a90cfe69e@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

On Tue, Apr 30, 2024 at 01:00:30PM +0100, Pavel Begunkov wrote:
> On 4/30/24 04:43, Ming Lei wrote:
> > On Mon, Apr 29, 2024 at 04:24:54PM +0100, Pavel Begunkov wrote:
> > > On 4/23/24 14:57, Ming Lei wrote:
> > > > On Mon, Apr 22, 2024 at 12:16:12PM -0600, Jens Axboe wrote:
> > > > > On 4/7/24 7:03 PM, Ming Lei wrote:
> > > > > > sqe->flags is u8, and now we have used 7 bits, so take the last one for
> > > > > > extending purpose.
> > > > > > 
> > > > > > If bit7(IOSQE_HAS_EXT_FLAGS_BIT) is 1, it means this sqe carries ext flags
> > > > > > from the last byte(.ext_flags), or bit23~bit16 of sqe->uring_cmd_flags for
> > > > > > IORING_OP_URING_CMD.
> > > > > > 
> > > > > > io_slot_flags() return value is converted to `ULL` because the affected bits
> > > > > > are beyond 32bit now.
> > > > > 
> > > > > If we're extending flags, which is something we arguably need to do at
> > > > > some point, I think we should have them be generic and not spread out.
> > > > 
> > > > Sorry, maybe I don't get your idea, and the ext_flag itself is always
> > > > initialized in io_init_req(), like normal sqe->flags, same with its
> > > > usage.
> > > > 
> > > > > If uring_cmd needs specific flags and don't have them, then we should
> > > > > add it just for that.
> > > > 
> > > > The only difference is that bit23~bit16 of sqe->uring_cmd_flags is
> > > > borrowed for uring_cmd's ext flags, because sqe byte0~47 have been taken,
> > > > and can't be reused for generic flag. If we want to use byte48~63, it has
> > > > to be overlapped with uring_cmd's payload, and it is one generic sqe
> > > > flag, which is applied on uring_cmd too.
> > > 
> > > Which is exactly the mess nobody would want to see. And I'd also
> > 
> > The trouble is introduced by supporting uring_cmd, and solving it by setting
> > ext flags for uring_cmd specially by liburing helper is still reasonable or
> > understandable, IMO.
> > 
> > > argue 8 extra bits is not enough anyway, otherwise the history will
> > > repeat itself pretty soon
> > 
> > It is started with 8 bits, now doubled when io_uring is basically
> > mature, even though history might repeat, it will take much longer time
> 
> You're mistaken, only 7 bits are taken not because there haven't been
> ideas and need to use them, but because we're out of space and we've
> been saving it for something that might be absolutely necessary.
> 
> POLL_FIRST IMHO should've been a generic feature, but it worked around
> being a send/recv specific flag, same goes for the use of registered
> buffers, not to mention ideas for which we haven't had enough flag space.

OK, but I am wondering why not extend flags a bit so that io_uring can
become extendable, just like this patch.

> 
> > > > That is the only way I thought of, or any other suggestion for extending sqe
> > > > flags generically?
> > > 
> > > idea 1: just use the last bit. When we need another one it'd be time
> > > to think about a long overdue SQE layout v2, this way we can try
> > > to make flags u32 and clean up other problems.
> > 
> > It looks over-kill to invent SQE v2 just for solving the trouble in
> > uring_cmd, and supporting two layouts can be new trouble for io_uring.
> 
> Sounds too uring_cmd centric, it's not specifically for uring_cmd, it's
> just one of reasons. As for overkill, that's why I'm not telling you
> to change the layour, but suggesting to take the last bit for the
> group flag and leave future problems for the future.

You mentioned 8bit flag is designed from beginning just for saving
space, so SQE V2 may not help us at all.

If the last bit can be reserved for extend flag, it is still possible
to extend sqe flags a bit, such as this patch. Otherwise, we just lose
chance to extend sqe flags in future.

Jens, can you share your idea/option wrt. extending sqe flags?

> 
> 
> > Also I doubt the problem can be solved in layout v2:
> > 
> > - 64 byte is small enough to support everything, same for v2
> > 
> > - uring_cmd has only 16 bytes payload, taking any byte from
> > the payload may cause trouble for drivers
> > 
> > - the only possible change could still be to suppress bytes for OP
> > specific flags, but it might cause trouble for some OPs, such as
> > network.
> 
> Look up sqe's __pad1, for example

Suppose it is just for uring_cmd, '__pad1' is shared with cmd_op, which is aligned
with ioctl cmd and is supposed to be 32bit.

Same with 'off' which is used in rw at least, if sqe group is to be
generic flag.

> 
> 
> > > idea 2: the group assembling flag can move into cmds. Very roughly:
> > > 
> > > io_cmd_init() {
> > > 	ublk_cmd_init();
> > > }
> > > 
> > > ublk_cmd_init() {
> > > 	io_uring_start_grouping(ctx, cmd);
> > > }
> > > 
> > > io_uring_start_grouping(ctx, cmd) {
> > > 	ctx->grouping = true;
> > > 	ctx->group_head = cmd->req;
> > > }
> > 
> > How can you know one group is starting without any flag? Or you still
> > suggest the approach taken in fused command?
> 
> That would be ublk's business, e.g. ublk or cmds specific flag

Then it becomes dedicated fused command actually, and last year's main
concern is that the approach isn't generic.

> 
> 
> > > submit_sqe() {
> > > 	if (ctx->grouping) {
> > > 		link_to_group(req, ctx->group_head);
> > > 		if (!(req->flags & REQ_F_LINK))
> > > 			ctx->grouping = false;
> > > 	}
> > > }
> > 
> > The group needs to be linked to existed link chain, so reusing REQ_F_LINK may
> > not doable.
> 
> Would it break zero copy feature if you cant?

The whole sqe group needs to be linked to existed link chain, so we
can't reuse REQ_F_LINK here.

Thanks,
Ming


