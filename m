Return-Path: <io-uring+bounces-1679-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 716FC8B692F
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 05:43:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20A1C282692
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 03:43:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1A48FC02;
	Tue, 30 Apr 2024 03:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GcmrL+5x"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD50310965
	for <io-uring@vger.kernel.org>; Tue, 30 Apr 2024 03:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714448605; cv=none; b=PhmI97kiT+eekksND2eZOx7Gvt3J2rhd9VeBGz/GLefWI+JRuS8hqDHchjESEwYFjtNHpOnkTO7WchXQZlYJtdCX8pGpGv+Bzq3WGN9uID8+S2rArG7Vyes5rGrcAMwhYM6W0LXNB9vn3gwDxHbSE5rBdIDl0+nfoHCIHh5BwFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714448605; c=relaxed/simple;
	bh=co2uBgimbRjemHAjtJCPTV0pbxxAgEirMTaalg0biFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QWz2XQ3TWws9Lwy89Rye8PBas/YkQQpkT1yGbbqdUys+0L1jCMGAxhNm9hndIXGYfcx7iEC65g5efqgpm6nATW84hVd1V8FojRtdJretJ2ql545wUfxEmXjn5SNgzidMXPS1/15KFnZPYe71eC8hw1hKjY43ZTHg3gIgVeB+4Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GcmrL+5x; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714448602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5L+y63y5kJiR0BnUFSxvPUoESCTVp3fPTI4fs/4VvwU=;
	b=GcmrL+5xReiWr/5M6tplr865cIRrbqNRtIpzriQpsQCH01244FzGjDVquXDectrpsESPJr
	YE8QgYz1Is4pNriBNSydV3oR80rCgIYueKx+i7oMhfSb7Nf0dsoPFNc6QDqO+G96TWYYAc
	9iCHGElSuj4U/HkBXLzVygXskzGBd00=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-198-TIv0tYc1MbifpzsTr3Ej7w-1; Mon,
 29 Apr 2024 23:43:18 -0400
X-MC-Unique: TIv0tYc1MbifpzsTr3Ej7w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 59B6D29AA3B3;
	Tue, 30 Apr 2024 03:43:18 +0000 (UTC)
Received: from fedora (unknown [10.72.116.42])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 30159400EB2;
	Tue, 30 Apr 2024 03:43:13 +0000 (UTC)
Date: Tue, 30 Apr 2024 11:43:10 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>,
	ming.lei@redhat.com
Subject: Re: [PATCH 2/9] io_uring: support user sqe ext flags
Message-ID: <ZjBozhXCCs46OeWK@fedora>
References: <20240408010322.4104395-1-ming.lei@redhat.com>
 <20240408010322.4104395-3-ming.lei@redhat.com>
 <89dac454-6521-4bd8-b8aa-ad329b887396@kernel.dk>
 <Zie+RlbtckZJVE2J@fedora>
 <e0d52e3f-f599-42c8-b9f0-8242961291d0@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0d52e3f-f599-42c8-b9f0-8242961291d0@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

On Mon, Apr 29, 2024 at 04:24:54PM +0100, Pavel Begunkov wrote:
> On 4/23/24 14:57, Ming Lei wrote:
> > On Mon, Apr 22, 2024 at 12:16:12PM -0600, Jens Axboe wrote:
> > > On 4/7/24 7:03 PM, Ming Lei wrote:
> > > > sqe->flags is u8, and now we have used 7 bits, so take the last one for
> > > > extending purpose.
> > > > 
> > > > If bit7(IOSQE_HAS_EXT_FLAGS_BIT) is 1, it means this sqe carries ext flags
> > > > from the last byte(.ext_flags), or bit23~bit16 of sqe->uring_cmd_flags for
> > > > IORING_OP_URING_CMD.
> > > > 
> > > > io_slot_flags() return value is converted to `ULL` because the affected bits
> > > > are beyond 32bit now.
> > > 
> > > If we're extending flags, which is something we arguably need to do at
> > > some point, I think we should have them be generic and not spread out.
> > 
> > Sorry, maybe I don't get your idea, and the ext_flag itself is always
> > initialized in io_init_req(), like normal sqe->flags, same with its
> > usage.
> > 
> > > If uring_cmd needs specific flags and don't have them, then we should
> > > add it just for that.
> > 
> > The only difference is that bit23~bit16 of sqe->uring_cmd_flags is
> > borrowed for uring_cmd's ext flags, because sqe byte0~47 have been taken,
> > and can't be reused for generic flag. If we want to use byte48~63, it has
> > to be overlapped with uring_cmd's payload, and it is one generic sqe
> > flag, which is applied on uring_cmd too.
> 
> Which is exactly the mess nobody would want to see. And I'd also

The trouble is introduced by supporting uring_cmd, and solving it by setting
ext flags for uring_cmd specially by liburing helper is still reasonable or
understandable, IMO.

> argue 8 extra bits is not enough anyway, otherwise the history will
> repeat itself pretty soon

It is started with 8 bits, now doubled when io_uring is basically
mature, even though history might repeat, it will take much longer time

> 
> > That is the only way I thought of, or any other suggestion for extending sqe
> > flags generically?
> 
> idea 1: just use the last bit. When we need another one it'd be time
> to think about a long overdue SQE layout v2, this way we can try
> to make flags u32 and clean up other problems.

It looks over-kill to invent SQE v2 just for solving the trouble in
uring_cmd, and supporting two layouts can be new trouble for io_uring.

Also I doubt the problem can be solved in layout v2:

- 64 byte is small enough to support everything, same for v2

- uring_cmd has only 16 bytes payload, taking any byte from
the payload may cause trouble for drivers

- the only possible change could still be to suppress bytes for OP
specific flags, but it might cause trouble for some OPs, such as
network.

> 
> idea 2: the group assembling flag can move into cmds. Very roughly:
> 
> io_cmd_init() {
> 	ublk_cmd_init();
> }
> 
> ublk_cmd_init() {
> 	io_uring_start_grouping(ctx, cmd);
> }
> 
> io_uring_start_grouping(ctx, cmd) {
> 	ctx->grouping = true;
> 	ctx->group_head = cmd->req;
> }

How can you know one group is starting without any flag? Or you still
suggest the approach taken in fused command?

> 
> submit_sqe() {
> 	if (ctx->grouping) {
> 		link_to_group(req, ctx->group_head);
> 		if (!(req->flags & REQ_F_LINK))
> 			ctx->grouping = false;
> 	}
> }

The group needs to be linked to existed link chain, so reusing REQ_F_LINK may
not doable.


Thanks,
Ming


