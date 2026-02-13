Return-Path: <io-uring+bounces-12190-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cLgiI73SjmnJFAEAu9opvQ
	(envelope-from <io-uring+bounces-12190-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 08:29:01 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 033221338E2
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 08:29:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DB237304B019
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 07:27:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C85D29E0FD;
	Fri, 13 Feb 2026 07:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g3xPH1Qy"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BAE27A465;
	Fri, 13 Feb 2026 07:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770967669; cv=none; b=qpkcNjH9dnvuwtonexf3d45pvVO0vyTFHxN42EHhmu5pHuT1OBD/0hLXmcKuGCuOYBnf6FPOjMLd8KvueFHtIiOr4zPkawDzUtUYXWMsgFatu1VhMSeZIv+6fWjHZwkv1Cr4czbsy1qLg8iJX9QssuWEWpfWbuxLPGukD+/Tn64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770967669; c=relaxed/simple;
	bh=Jse0Flx6WuYiPdcuTCh/Vtxxf8Y5F477X9odXFhkJ3Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hmLgUtYjpOojlEJlXixSqjvm/ifcs1RHXFSdSiV+e3C9rDGDu/eUWJDtUB78mxZSWXP5qUGFsFkqOqZsB1mFrTpwy5WPxjmS0tSyIYGyyzern/wS52JM2R8NN5+1fHzFOR1PuNa35VpXVpQ6GUgEI+Fkul+LhC+pOkEA6ikCmec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=g3xPH1Qy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gSsCX8POADBW94nKops4EneU59ycJUbBknNzjzKpC+s=; b=g3xPH1QyxKzpmR+cFsSiWqBTwz
	b3izH87LtheUJ7oSP8RzutzKnmB8VBBucWetZj/o21pvm9UsiMOJ01uz/KCvfTDpj2kTP3eT0EXWy
	fjKOlvdEgdSM5Zl/mOyw4H84KQNmTQe+eHqb6epQhVRq3XjSeapHYYnHQanMNqvc9Pv3Ddhp6OARG
	OvO35wOLrmDPwyoBg5b3FSQarrkKAoBnInYFNsX8j3jJsyhZRIy9/cpESrvNciXwnBnXKEltGK9Vg
	yBcgIMCayG5pKBcEUWyXdj/8H4zcHVGPy6FkpVdSvqvZZ3YUGy6wGKNELDqVwwKibBgrNq9Sr9zPZ
	a72x9T5A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vqnad-000000036OR-1z4e;
	Fri, 13 Feb 2026 07:27:47 +0000
Date: Thu, 12 Feb 2026 23:27:47 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk,
	io-uring@vger.kernel.org, csander@purestorage.com, krisman@suse.de,
	bernd@bsbernd.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v1 03/11] io_uring/kbuf: add support for kernel-managed
 buffer rings
Message-ID: <aY7ScyJOp4zqKJO7@infradead.org>
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
 <20260210002852.1394504-4-joannelkoong@gmail.com>
 <89c75fc1-2def-4681-a790-78b12b45478a@gmail.com>
 <CAJnrk1ZZyYmwtzcHAnv2x8rt=ZVsz7CXCVV6jtgMMDZytyxp3A@mail.gmail.com>
 <1c657f67-0862-4e13-9c71-7217aeecef61@gmail.com>
 <CAJnrk1YXmxqUnT561-J7seaicxFRJTyJ=F3_MX1rmtAROC6Ybg@mail.gmail.com>
 <aY2mdLkqPM0KfPMC@infradead.org>
 <809cd04b-007b-46c6-9418-161e757e0e80@gmail.com>
 <CAJnrk1Y6YSw6Rkdh==RfL==n4qEYrrTcdbbS32sBn12jaCoeXg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJnrk1Y6YSw6Rkdh==RfL==n4qEYrrTcdbbS32sBn12jaCoeXg@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12190-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[gmail.com,infradead.org,kernel.dk,vger.kernel.org,purestorage.com,suse.de,bsbernd.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[infradead.org:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,infradead.org:mid,infradead.org:dkim]
X-Rspamd-Queue-Id: 033221338E2
X-Rspamd-Action: no action

On Thu, Feb 12, 2026 at 09:29:31AM -0800, Joanne Koong wrote:
> > > I'm arguing exactly against this.  For my use case I need a setup
> > > where the kernel controls the allocation fully and guarantees user
> > > processes can only read the memory but never write to it.  I'd love
> 
> By "control the allocation fully" do you mean for your use case, the
> allocation/setup isn't triggered by userspace but is initiated by the
> kernel (eg user never explicitly registers any kbuf ring, the kernel
> just uses the kbuf ring data structure internally and users can read
> the buffer contents)? If userspace initiates the setup of the kbuf
> ring, going through IORING_REGISTER_MEM_REGION would be semantically
> the same, except the buffer allocation by the kernel now happens
> before the ring is created and then later populated into the ring.
> userspace would still need to make an mmap call to the region and the
> kernel could enforce that as read-only. But if userspace doesn't
> initiate the setup, then going through IORING_REGISTER_MEM_REGION gets
> uglier.

The idea is that the application tells the kernel that it wants to use
a fixed buffer pool for reads.  Right now the application does this
using io_uring_register_buffers().  The problem with that is that
io_uring_register_buffers ends up just doing a pin of the memory,
but the application or, in case of shared memory, someone else could
still modify the memory.  If the underlying file system or storage
device needs verify checksums, or worse rebuild data from parity
(or uncompress), it needs to ensure that the memory it is operating
on can't be modified by someone else.

So I've been thinking of a version of io_uring_register_buffers where
the buffers are not provided by the application, but instead by the
kernel and mapped into the application address space read-only for
a while, and I thought I could implement this on top of your series,
but I have to admit I haven't really looked into the details all
that much.

> 
> To be completely honest, the more I look at this the more this feels
> like overkill / over-engineered to me. I get that now the user can do
> the PMD optimization, but does that actually lead to noticeable
> performance benefits? It seems especially confusing with them going
> through the same pbuf ring interface but having totally different
> expectations.

Yes.  The PMD mapping also is not that relevant.  Both AMD (implicit)
and ARM (explicit) have optimizations for contiguous PTEs that are
almost as valuable.

> What about adding a straightforward kmbuf ring that goes through the
> pbuf interface (eg the design in this patchset) and then in the future
> adding an interface for pbuf rings (both kernel-managed and
> non-kernel-managed) to go through IORING_REGISTERED_MEM_REGIONS if
> users end up needing/wanting to have their rings populated that way?

That feels much simpler to me as well.


