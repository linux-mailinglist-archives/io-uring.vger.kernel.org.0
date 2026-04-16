Return-Path: <io-uring+bounces-13058-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sJTXHyIF4WkuogAAu9opvQ
	(envelope-from <io-uring+bounces-13058-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 16 Apr 2026 17:49:54 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D703C411394
	for <lists+io-uring@lfdr.de>; Thu, 16 Apr 2026 17:49:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5854230474C5
	for <lists+io-uring@lfdr.de>; Thu, 16 Apr 2026 15:48:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D55623182D;
	Thu, 16 Apr 2026 15:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K7VDbdxP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B881DE2A5
	for <io-uring@vger.kernel.org>; Thu, 16 Apr 2026 15:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776354536; cv=none; b=LEnn+leO2dwScVORk5S5FHW9Zk/+D4c42EoWCQmDBHcV6lmisSZukQ1Abm2aXq3ZgxYeYLMIvyOxJkTz7Cl4glbReOUjqkmoXw7+DEwJoXgC19SMHRTQSD4kon/dEnNckH+9Tfodzehc1YlanLHdFMyTk1cbYa1/tmYD/nIPnFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776354536; c=relaxed/simple;
	bh=ntlB2gooO8+TyNTMEG5S9IQ8W4EapIAf5AUFUUbVLEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UNZTTIfvlzO11IKRgw53ruo/wWMqyhQH6xZqig4ZJ6zr4YE/3eISsRvaAWLPO1SoSHzlTopdOZW/Amqp34MmzE/A50hdtv9mBZ4vQb76e1EChoO+odkEAt1NY4/IEMnTO95h5cIttcEXddD+KodyvpVn9DD5UUmM+QbkVR1imdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K7VDbdxP; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2b25cf1b5f0so54006785ad.3
        for <io-uring@vger.kernel.org>; Thu, 16 Apr 2026 08:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776354534; x=1776959334; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OIHUIp0RxecXJX7Bf3PUl8SC3EM5FeCaTyjb7bZag6c=;
        b=K7VDbdxPc5YQ7YMnbbHY7wFTpZ1I2YHNafVHbtLkFOlQnnjCvUZFyQnccdwyK6Yeus
         /f22r/IVqOXa9ULup+3l/BPESnwX5U/d5unDcYEvY3lVTXjgWT7CmRw/CfAQ1BqxxhBc
         uVy2qfAdqTz0MoM7OCNWSP6lRu5bI9rXsnJQVKEyVyU8Aqxc0QG6FRRCFbvu/FeDem5Z
         VuIkxOO/xtqAGrypDRneYcuk993C72yO2/AoafjT994sMrOe/x6p/3ywdGpsBwPS4h+f
         jBrwWcEk4BKcLW9PtGQDajq4zroNYdDEtmT/9j0/czVEdzYz6qb9lvXj7SQfFDbBT1fi
         Hbpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776354534; x=1776959334;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OIHUIp0RxecXJX7Bf3PUl8SC3EM5FeCaTyjb7bZag6c=;
        b=TUqbucfwQuHXth4P5i0i6AKaraXsBpdTG7HAM1eoI+tHtuj+rdkyqkFvyLzmXY/fbe
         hYUCCYB23AZYDOpA3i6YKKlYHsEFz5H/xPfIbEFXpwK9gwV3PVBWugu5XajpqbQinu2P
         15Nx4UBYKMcuDZxepKGLhDa6XYz0rjdwFIo6UjLzIM2Rj+IZSClw0cWegD12gpjThr+X
         tP0ruJ0NhOsEE4P23xL1ZaPuBiI8cIugI0SPMlFo6jZ0VBUHIreQoaZyV2IwHHulUBkJ
         QwldCgKE/Rg8zyoRZIx5fO+v+cf6sNtbuzCY1IDNAAZFG3TYJ+WaaTaxXwkXanPh5NK+
         uV+Q==
X-Forwarded-Encrypted: i=1; AFNElJ8tJwr9CYRNsmHRDZQ3scu300k2SPBgdHYaiVOeCzmSY8605rhu9Uq8kRZZeC7bhf7da+CtJOFkzA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyMm1QdXW1rxvnwRcjTtOnXQ2rufybVL/Q/YGxR6xAUVRWzC/FB
	L/ZgzsNBPas7ua+7ctiAhE4Isgxh/kJkgtz4NWx28xwWnY2pFdD0xes/
X-Gm-Gg: AeBDievf7NxWOxkjHbldnelX0bJAHke3z9rUjt1RvL3mUmvYmhsJ5GHf1NPB9sKsJSL
	/wLTegEU6B39/Ci/YJT0l2AJiEYVdnJpUEzagxUThOoIOdgsZT/3b5Vf0kN/TK2lmXCEHoymibZ
	+mc8jZmzj4FcdTW4GSWByIN9MpOj4NW1ckpcGM3PyGho3Gji/BWdoZuu7AJgDUFtraf8n2lyMnU
	0pm83w8xoxTLXPqiqvgQ8LDBog8oRDwU5XQv28n2s4+5wwKY9JFCNIvgX1IHlrB/dyNYC1jnDZD
	yjagjybWGnsUi/boYGMalHEpk60n8bRlr2+fIpbbVyKqjZ6k3oxaW/JoijnCeCqYanul0gjDxIc
	6pn9NuZVrU+SGVQlpLpSKLkL6sXmxXeSCkrRekzYRTAoMNiVqxOGuLGLumTarJBXJvXhIYfsQlV
	NnRPmZOhnSaZ3QFfLX6s9JGnmP4/cDO3aVXiVWENEtF0BYdboVCHHmvpVNcQz5JF7cp1qKRsjge
	JL0moHEjYGQZdY=
X-Received: by 2002:a17:902:c7c3:b0:2b0:61c2:8e7a with SMTP id d9443c01a7336-2b2d5a14be8mr202948645ad.25.1776354533841;
        Thu, 16 Apr 2026 08:48:53 -0700 (PDT)
Received: from fedora (173-245-219-252.icn.as140952.net. [173.245.219.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b47810b70csm54090905ad.23.2026.04.16.08.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 08:48:52 -0700 (PDT)
Date: Thu, 16 Apr 2026 23:48:48 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: Bernd Schubert <bernd@niova.io>
Cc: Ming Lei <ming.lei@redhat.com>, fuse-devel@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: fuse/io-uring: Proposal to support pBuf in additon to kBuf
Message-ID: <aeEE4FVGdi5RqKs_@fedora>
References: <18936160-308a-4817-a295-54eef43707a3@niova.io>
 <CAFj5m9LeM4S82QEsRQ0uQiXj1eWCFAW3v2fLTxUj1YM7UO-V9g@mail.gmail.com>
 <fcad39e2-37b5-46a9-a280-2315e0397985@niova.io>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fcad39e2-37b5-46a9-a280-2315e0397985@niova.io>
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13058-lists,io-uring=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D703C411394
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Apr 16, 2026 at 04:46:01PM +0200, Bernd Schubert wrote:
> Hi Ming,
> 
> On 4/16/26 15:49, Ming Lei wrote:
> > Hi Bernd,
> > 
> > On Tue, Apr 14, 2026 at 5:33 AM Bernd Schubert <bernd@niova.io> wrote:
> >>
> >> Hi Joanne, et al,
> >>
> >> this is a bit of duplication of the discussion we had before, but I was
> >> badly distracted with other work and also switching employer - didn't
> >> manage to reply [1].
> >>
> >>
> >> I'm still not too happy about kBuf and its restriction of locked-only
> >> memory. Right now I'm reviewing your patches from the view of what needs
> >> to be done for ublk (for my current employer) and also for fuse to
> >> support different buffer sizes. Let's say fuse only support kBuf and its
> >> restriction of pinned memory, I think we would be forced to add support
> >> for different buffer sizes to the current ring-entry-provides-the-buffer
> >> and the new kBuf interface - from my point of view code dup.
> >> If we would allow pBuf for fuse, we could put the current
> >> 'ring-entry-provides-the-buffer' interface into maintenance mode and
> >> support new features with the new interface only. I know you disagree on
> >> using pBuf [1] with the argument that userspace could free the buffer.
> >> Well, if it does, it does something totally wrong and the same could
> >> happen today over /dev/fuse and also the existing fuse-over-io-uring.
> >> Just the window is smaller, as the pages are extracted from the buffer
> >> during the copy.
> >>
> >> I was looking into what would be needed to support pBuf and I think
> >> io-uring could extract pages from pBuf when the buffer is obtained - it
> >> would limit the window when userspace can do something wrong in a
> >> similar way current fuse and ublk works.
> >>
> >> Suggested changes:
> >>
> >> io_uring:
> >>
> >>   - io_pin_pages() gets a 'bool longterm' parameter.
> >> The new pBuf path would pass false, every other exsting caller true.
> >>
> >>   - io_ring_buf_pin_user() / io_ring_buf_unpin_user()
> >>   - io_ring_buf_get_pages()/io_ring_buf_put_pages() -> fills the
> >> provided bvec
> >>   - New struct io_ring_buf (in cmd.h)
> >>
> >> struct io_ring_buf {
> >>        size_t                  len;
> >>        unsigned int            buf_id;
> >>        unsigned int            nr_bvecs;
> >>
> >>        /* private */
> >>        u64                     addr;
> >>        u8                      is_pinned;
> >> };
> >>
> >>
> >> Fuse changes:
> >>
> >>   - fuse_ring_ent (bufring union side): payload_kvec and ringbuf_buf_id
> >>     replaced by io_ring_buf + pre-allocated bvec array.
> >>   - Buffer selection under queue->lock removed.  The lock only protects
> >>     request dequeue and entry state transitions.  Page access happens
> >>     after the lock is dropped, in the context where the copy runs.
> >>   - setup_fuse_copy_state bufring branch: is_kaddr/kaddr replaced by
> >>     iov_iter_bvec() and would continue to use iov_iter_get_pages2()
> >>
> >> What do you think?
> >>
> >> And my current primary goal is to let ublk to support multiple buffer
> >> sizes - ublk would also need to get support for kBuf/pBuf and I'm
> > 
> > Ublk server is just one liburing application, and it supports all generic
> > io_uring buffer types, so kbuf/pbuf should be fine for your ublk server
> > in theory.
> > 
> > It really depends on how your ublk server is implemented.
> > 
> > Maybe you can share your motivation first before discussing kbuf/pbuf support.
> > If it is for DMA,  there are other candidates too, such as hugepage,
> > recent added
> > UBLK_U_CMD_REG_BUF, ...
> Joanne had actually removed kBuf and switched to pBuf alone and that
> simiplifies things a bit.
> 
> Motivation is to reduce memory usage. Let's say you need 4 IOs of 1MB to
> saturate streaming bandwidth, but still want to get smaller IOs through,
> for these smaller IOs you don't want to assign the 1MB buffer for each
> queue entry / tag.

Thanks for sharing the motivation.

Maybe you can pass UBLK_F_USER_COPY, and each IO buffer can be allocated
dynamically completely from userspace, then pre-allocation can be avoided.

> Zero copy is currently still out of question for us, although I will
> look into your recent work for integration of eBPF and if erasure
> coding, compression and checksums could be done with that (I guess
> checksums is the easy part).

Got it, compression could be the hardest one, however, the recent added bpf
iterator based buffer interface may simplify everything. I'd suggest you to look
at it, and provide some feedback if possible.

Also if your client application uses direct IO, recent added UBLK_F_SHMEM_ZC
could simplify implementation a lot, meantime with zero copy & user-mapped
address.

> 
> Ublk already has UBLK_F_NEED_GET_DATA, but that has two issues
> - needs another round trip (testing on my laptop shows a perf loss of 10
> to 15% per queue)
> - It does not release the application buffer on read. I have an idea how
> to fix that, but here at Niova we would like to go the dynamic memory
> appraoch with pBufs to avoid additional round trip overhead.
> 
> Idea with pBufs: Several pBufs registered per queue at registration
> time. Every pBuf represents a different IO size. Optionally as with
> Joannes patches [1] the buffers can get pinned to avoid mapping to pages
> for every access.

I feel the plain fixed buffer might work too, but I may not get the whole
idea yet, looks I need to dig into pBuf first.

> I'm currently working on a patch series with some luck will sent an RFC
> tomorrow. The harder part compared to fuse is that ublk_drv does not
> have its own queues/lists so far. This is my first work on block layer -
> I'm not sure if internal struct request queuing is allowed at all.
> Testing will show in a bit :)

Great, glad to take a look after your RFC is out.


Thanks,
Ming

