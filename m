Return-Path: <io-uring+bounces-13063-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GCTgH4tF4mlh4AAAu9opvQ
	(envelope-from <io-uring+bounces-13063-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 17 Apr 2026 16:36:59 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id AADA941C209
	for <lists+io-uring@lfdr.de>; Fri, 17 Apr 2026 16:36:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id AD47D3033544
	for <lists+io-uring@lfdr.de>; Fri, 17 Apr 2026 14:35:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E2423B4EB4;
	Fri, 17 Apr 2026 14:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LfUyGAzq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62043B6350
	for <io-uring@vger.kernel.org>; Fri, 17 Apr 2026 14:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776436551; cv=none; b=TXr4R0/AJIpSErut0Rs//nrXEmRiy+ZuHcOTx/8NQFGxqKstu82qZfLyarFF85akGpm7Pz3OeFNHSJtNmRg9tmrgoVD2Da2oINavo2rMBaHBjb8M1i69KBBuAX60U7a3xpFMHsNWcjFrnvK6fzUTeDvr8NXoNRxrZLS7J/lSLMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776436551; c=relaxed/simple;
	bh=zLSRvxuJezn5knvIQBgSjbQdMRyyImGUoozeC/CsSOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q/VMfz1dtq7RY+LNe6M6yx+SCLY9tj/Mir/ffxETYbkcLCwF+B+XZOUnH0jgSqDYABzdIlIqEtyu0Uz9QOgSvT9IL1S9hTYZjveIurPTJB5QSXEUK/o+rrd79nXVXHcNSF9Mu1ecMk5ava6L+AKLl184Tb4DPe826pamcwJpWag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LfUyGAzq; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-488af9fdaa7so5492205e9.1
        for <io-uring@vger.kernel.org>; Fri, 17 Apr 2026 07:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776436548; x=1777041348; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jA3YbhSUsNdLppcNpGxb5cEbWpDvT0O/nJo4+itqimo=;
        b=LfUyGAzqGnKoWXVDvYRnxybIYkll9o3pV7FEom2QCI6DiU5x1WvID24c6TuWi7FAP1
         mItklCYj4VYwMUZdmbbwGj89J4RFS/qYlNybCMe2Z5EZRzlPvBMJRw/Gongx6q+9UuJH
         ei1LuM48ui6lC+NHHHaFd/caI5zJQUNtzn7CAIaEJB05/IXfkxQXMLIXSiYzLKjLHjMk
         Ulv8nSMsdn2outCObJa3BWHVLZSE0qGq8A8B1aeT/Hl0ZfSgTK266SSWN7kQZgEWnsJe
         q0uTv1MAj5DzzeB+PbAbvQYzUQxzdUgL7XoE7aqn9hXnUX+KqnZKmsRbCd6InQ1EA3Y1
         jO+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776436548; x=1777041348;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jA3YbhSUsNdLppcNpGxb5cEbWpDvT0O/nJo4+itqimo=;
        b=HYh1MtnbNxZG9REt2mGKYBTgZhFQqtmX7cfXgnvk6bTF7043o9MmDYhFHhmjCPCgNI
         XTNhYnsXY9i9/9cb0L/m8XnmBcj/9cP3xszGi7vxUQIr4/MoD77Rn2EwSJqLEL3fWQXi
         3GJeqKC4w14DZmyMJ9ZZIpwkB8oAAXVZ8PHH4yJNLD4jeV8JodnEy9rUWYGUhAMFiOp8
         OvoE5Pni6oOpOnA8iLCoh8NcUgT+W/J2yxmAUW0oKKEXVOxPrN3A4kL8i40NTGNwQzVC
         IzOzFfJoEdUKZcXzK8YHTHmmjOrEEHK3PMtkRjWDHkYU456JuzU50QcEVe6HCrrPnvbm
         Gwnw==
X-Forwarded-Encrypted: i=1; AFNElJ+oNH/ro3capmEFAoXRozz3XRJ4XxtM5uiyXgEXL09XHpwuJoI8TwneW/uWbrNfCfGhSh6MEboEGg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwWUAYjI+xW9TGP32SfmFa5Z3HSogEdfDjppM1vtzNqWhqTDe2C
	ge2VgXUcH9Ocxk3aA/61IgzA4L23JtGQwFnNNdyAwhWK1Q681juoQLVr
X-Gm-Gg: AeBDietZpRUqxzTRL29RP5kS70bb9W3iWUZ307PqPeZdahIfDnuPL1Yy6VqjIkv45cE
	Bt2z7tAHkKEcQYbjd/Z8P8xBKrQAy9i/7ssX77yNCkNXfRTQppAXnHjagZk6VcBTFO/92po4FX8
	syVGgK6A496oO6MD0OCK+d+1z/p51jCjF2690S62zcjxNKLNcMQneNwU4hGn32t3EAG1WU9Tg7h
	VW8DSe3Hg/mhgVFP/Tcsyzrp/cCgw3ThL4WPoeTEsc2Ivd+2KIO/HWa66vCXnDNeJmGLAnJ900c
	aABNuRkM40wAqA+popGG/WiAqVzyTwNtsq9YOuhk2/zSuIXOWt8r/3s8ihJU7HZIVs+bz6/b74+
	Gerc//tb6OedWgvolYUQvOsmApfKLAxOgup0FAn7JBXN39dbxPxVpyRXE9KLawLMgvz5griRVb+
	eW+j9kRpRF6Z4mv5wqQF1Dl5+k6S3e2roBY7yfaBZBB6U+Bz/fhy5c7Lcs01nNl3DESjRBa2YFy
	amwTZtJuG6A4F85nEw2W49vvepPAg==
X-Received: by 2002:a05:600c:8183:b0:486:fd5c:2b35 with SMTP id 5b1f17b1804b1-488fb750809mr45782885e9.13.1776436547740;
        Fri, 17 Apr 2026 07:35:47 -0700 (PDT)
Received: from fedora (185-147-214-8.mad.as62651.net. [185.147.214.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc16f93dsm69109315e9.3.2026.04.17.07.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 07:35:47 -0700 (PDT)
Date: Fri, 17 Apr 2026 22:35:38 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: Bernd Schubert <bernd@niova.io>
Cc: Ming Lei <ming.lei@redhat.com>, fuse-devel@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: fuse/io-uring: Proposal to support pBuf in additon to kBuf
Message-ID: <aeJFOmvCF3ArL9iq@fedora>
References: <18936160-308a-4817-a295-54eef43707a3@niova.io>
 <CAFj5m9LeM4S82QEsRQ0uQiXj1eWCFAW3v2fLTxUj1YM7UO-V9g@mail.gmail.com>
 <fcad39e2-37b5-46a9-a280-2315e0397985@niova.io>
 <aeEE4FVGdi5RqKs_@fedora>
 <55db9a65-4408-42d2-8958-3bf3aa79d554@niova.io>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <55db9a65-4408-42d2-8958-3bf3aa79d554@niova.io>
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13063-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[redhat.com,lists.linux.dev,gmail.com,vger.kernel.org,kernel.dk,szeredi.hu];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tomleiming@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,niova.io:email]
X-Rspamd-Queue-Id: AADA941C209
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Apr 16, 2026 at 09:13:41PM +0200, Bernd Schubert wrote:
> 
> 
> On 4/16/26 17:48, Ming Lei wrote:
> > On Thu, Apr 16, 2026 at 04:46:01PM +0200, Bernd Schubert wrote:
> >> Hi Ming,
> >>
> >> On 4/16/26 15:49, Ming Lei wrote:
> >>> Hi Bernd,
> >>>
> >>> On Tue, Apr 14, 2026 at 5:33 AM Bernd Schubert <bernd@niova.io> wrote:
> >>>>
> >>>> Hi Joanne, et al,
> >>>>
> >>>> this is a bit of duplication of the discussion we had before, but I was
> >>>> badly distracted with other work and also switching employer - didn't
> >>>> manage to reply [1].
> >>>>
> >>>>
> >>>> I'm still not too happy about kBuf and its restriction of locked-only
> >>>> memory. Right now I'm reviewing your patches from the view of what needs
> >>>> to be done for ublk (for my current employer) and also for fuse to
> >>>> support different buffer sizes. Let's say fuse only support kBuf and its
> >>>> restriction of pinned memory, I think we would be forced to add support
> >>>> for different buffer sizes to the current ring-entry-provides-the-buffer
> >>>> and the new kBuf interface - from my point of view code dup.
> >>>> If we would allow pBuf for fuse, we could put the current
> >>>> 'ring-entry-provides-the-buffer' interface into maintenance mode and
> >>>> support new features with the new interface only. I know you disagree on
> >>>> using pBuf [1] with the argument that userspace could free the buffer.
> >>>> Well, if it does, it does something totally wrong and the same could
> >>>> happen today over /dev/fuse and also the existing fuse-over-io-uring.
> >>>> Just the window is smaller, as the pages are extracted from the buffer
> >>>> during the copy.
> >>>>
> >>>> I was looking into what would be needed to support pBuf and I think
> >>>> io-uring could extract pages from pBuf when the buffer is obtained - it
> >>>> would limit the window when userspace can do something wrong in a
> >>>> similar way current fuse and ublk works.
> >>>>
> >>>> Suggested changes:
> >>>>
> >>>> io_uring:
> >>>>
> >>>>   - io_pin_pages() gets a 'bool longterm' parameter.
> >>>> The new pBuf path would pass false, every other exsting caller true.
> >>>>
> >>>>   - io_ring_buf_pin_user() / io_ring_buf_unpin_user()
> >>>>   - io_ring_buf_get_pages()/io_ring_buf_put_pages() -> fills the
> >>>> provided bvec
> >>>>   - New struct io_ring_buf (in cmd.h)
> >>>>
> >>>> struct io_ring_buf {
> >>>>        size_t                  len;
> >>>>        unsigned int            buf_id;
> >>>>        unsigned int            nr_bvecs;
> >>>>
> >>>>        /* private */
> >>>>        u64                     addr;
> >>>>        u8                      is_pinned;
> >>>> };
> >>>>
> >>>>
> >>>> Fuse changes:
> >>>>
> >>>>   - fuse_ring_ent (bufring union side): payload_kvec and ringbuf_buf_id
> >>>>     replaced by io_ring_buf + pre-allocated bvec array.
> >>>>   - Buffer selection under queue->lock removed.  The lock only protects
> >>>>     request dequeue and entry state transitions.  Page access happens
> >>>>     after the lock is dropped, in the context where the copy runs.
> >>>>   - setup_fuse_copy_state bufring branch: is_kaddr/kaddr replaced by
> >>>>     iov_iter_bvec() and would continue to use iov_iter_get_pages2()
> >>>>
> >>>> What do you think?
> >>>>
> >>>> And my current primary goal is to let ublk to support multiple buffer
> >>>> sizes - ublk would also need to get support for kBuf/pBuf and I'm
> >>>
> >>> Ublk server is just one liburing application, and it supports all generic
> >>> io_uring buffer types, so kbuf/pbuf should be fine for your ublk server
> >>> in theory.
> >>>
> >>> It really depends on how your ublk server is implemented.
> >>>
> >>> Maybe you can share your motivation first before discussing kbuf/pbuf support.
> >>> If it is for DMA,  there are other candidates too, such as hugepage,
> >>> recent added
> >>> UBLK_U_CMD_REG_BUF, ...
> >> Joanne had actually removed kBuf and switched to pBuf alone and that
> >> simiplifies things a bit.
> >>
> >> Motivation is to reduce memory usage. Let's say you need 4 IOs of 1MB to
> >> saturate streaming bandwidth, but still want to get smaller IOs through,
> >> for these smaller IOs you don't want to assign the 1MB buffer for each
> >> queue entry / tag.
> > 
> > Thanks for sharing the motivation.
> > 
> > Maybe you can pass UBLK_F_USER_COPY, and each IO buffer can be allocated
> > dynamically completely from userspace, then pre-allocation can be avoided.
> 
> I had looked into, but that is still another syscall / roundtrip, will
> have the same performance issue as UBLK_F_NEED_GET_DATA and probably
> worse because compared to ring IO that is a syscall per IO.

Yeah, it seems true in your use case in which compression is followed,
so pread/pwrite for read/write io buffer can't be linked to io_uring SQE pipeline.

However, I am not sure how you use pbuf for this use case, one big thing is
that the buffer has to be provided to ublk FETCH_AND_COMMAND command
beforehand for handling the coming ublk IO request, which size can't be
known at that time. I will study the pBuf patchset later, but it depends
how ublk driver uses it too, IMO.

Meantime another (more flexible)way is to use bpf struct_ops for allocating &
freeing IO buffer, following the basic idea:

- define struct_ops(alloc_io_buf, free_io_buf) for allocating & freeing io buffer
which is used for copying data between request pages and this buffer

- ->alloc_io_buf() can be called from ublk_map_io() and ->free_io_buf()
can be called from ublk_unmap_io()

- the allocated buffer can be accessed directly from both userspace ublk server
and bpf prog, bpf arena is one perfect match for this use case, page
pinning is avoided meantime.

- the two callbacks are not called for the following features:
UBLK_F_SUPPORT_ZERO_COPY,UBLK_F_USER_COPY, UBLK_F_AUTO_BUF_REG or
UBLK_IO_F_SHMEM_ZC is set for this IO

- motivation is for avoiding big pre-allocate, so ublk server can
use dynamic per-queue heap for allocating io buffer in space-effective way.

- with this feature, userspace needn't to pre-allocate io buffer with max
  buffer size, and typical implementation is to provide one bpf area heap
  for bpf prog to alloc & free buffer. And it still can fallback to usercopy
  code path in case of allocation failure from bpf prog.

You may compare the two approaches for your use case.

> 
> > 
> >> Zero copy is currently still out of question for us, although I will
> >> look into your recent work for integration of eBPF and if erasure
> >> coding, compression and checksums could be done with that (I guess
> >> checksums is the easy part).
> > 
> > Got it, compression could be the hardest one, however, the recent added bpf
> > iterator based buffer interface may simplify everything. I'd suggest you to look
> > at it, and provide some feedback if possible.
> > 
> > Also if your client application uses direct IO, recent added UBLK_F_SHMEM_ZC
> > could simplify implementation a lot, meantime with zero copy & user-mapped
> > address.
> 
> Oh I see, that was just merged. Nice, thank you! I don't our users will
> be DIO only, but nice to have that ZC option!

It can be thought as speedup or optimization for DIO use case.

Thanks,
Ming

