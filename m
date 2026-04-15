Return-Path: <io-uring+bounces-13042-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4NsQOMTZ3mkyJQAAu9opvQ
	(envelope-from <io-uring+bounces-13042-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 02:20:20 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id CF1C73FF444
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 02:20:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7E3E2300A27F
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 00:20:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 932E61A238F;
	Wed, 15 Apr 2026 00:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BVjqMVg9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22FB4A07
	for <io-uring@vger.kernel.org>; Wed, 15 Apr 2026 00:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776212404; cv=pass; b=Ges4sBd2kSWl1G6cXntP7KDyq5k7dlvntVfH0Xs+IXWDXH7hzKfCDN0mT9BBWWQpQ8PRkDwLQiKZMVbBHEEaqu8I5GJ09CYx6mo3WFzHdWEDmW2tuICslakhm1ukqQWZNch7/P1kAJ0I5ue7GhcUYCdwggTjxofd5oK9DkXqJUU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776212404; c=relaxed/simple;
	bh=1caITDgwdheH/M0isdyIXswpQD8x8Z3o1taTNVnODVE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g831vTRtj0lOM1nmBBxVPd6vMNupfwujD5Z/hDHJ7Jh3ZPwNpQc6LsPudfti6lhbN1Ydbr8oNE1J7QhBS/rq2Z9Njb3lFwzark3nQoTYHB2RfRQsjbgZMPGCS+mq8TVuSYu0OwI2ahm7tC3l8rjswpNxNlgstCqt6WJpUkq4xv4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BVjqMVg9; arc=pass smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-488b8efed61so60727775e9.1
        for <io-uring@vger.kernel.org>; Tue, 14 Apr 2026 17:20:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776212401; cv=none;
        d=google.com; s=arc-20240605;
        b=Q0chefMOVwUP/aV1U4t2jRQq1jsMY1GzbxrrUG7Ssrn1bQjN9X8FguBVzPHbPBQDbM
         XsecxAWKBzDTIe0+1CKJYVy1uLxK3MA+eN6n+lgFM1zKVLYUh5u/f34ja3xv052aXMfb
         3ply90CyQxeGc5I/af4Vfs8OEY/jqo7qKo1rHzk5WOKmnikZnxq4p5CgT7J+XpIJtuNb
         FpYzzlaL7Z5GVCFu8glVTc6rYklOxV7ksKH/TTQeFJ+GKmMlsw/ziNDQlUnFPnhMX0w+
         SFojyeqATgXTPA4T2CssRixf/nv0M+Fei7I4L32OZSubQJpGZR6mw2SCueGUPB01vVFD
         2mYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=z5uGFIcAqyz5wNzuMzPehrzfu6ZNsJAgolKPAxtg4WE=;
        fh=ENwnU3Vu5Ny/cv7gSmowKoHYd+feYc0Xez1c8qMR9yU=;
        b=CK19bB+SsJK/qXIrfkqXShLSgTrP2raBdIhDwWYTJKwf2YnmfNdamCXzsQpt9/M77u
         WwfexYu2p0pzOItUnc337zN6HvPfi6jQSPQIp0Nmgr5Mn9qUaArkvJTcV+aaiuQGdH7a
         KTRLb1vSVhychVxR84ru5qnzdycxvb9BzrH2tS5BHeqPIC5Yo7AxmR7EN/4eR3PyOSI+
         zMBz2NK7R/iMQAQl91FszSLzGZ27AttDm2H8ejlztjcdvkb+60GZ8Z6dkkaFhFLbndNx
         RnZTrtTU7Fqdw6p0BFudw57EFdQ91hap5G5M4/tKaLIkN3TNPI/GO3tC96SqcvoZkN/O
         3wqA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776212401; x=1776817201; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z5uGFIcAqyz5wNzuMzPehrzfu6ZNsJAgolKPAxtg4WE=;
        b=BVjqMVg9TeHXgrjkNbGW2rJXr2I9stVFnu1QX4BS6mpZsA+OLFdd7pJ2gbj9slg3oA
         SNFbVAgf1pztaEqIq4dIEChJuIz5ZVU6YQOlLIdvM0VehHUuv+YmaAekET1wqrIaAIco
         ADNVAnHvgP4oPmjJLRkzTYaeJbNPGNKUCHO0qVvML/A7WB8LaqQ2szGOT6TUGnL/Jmu7
         2h+EuNi6WqnhtZe/tkH412b46Mda2BO+IiiLNqRNcHkS4lrJfdBPQ0nMyAkgchKAHkxi
         1xslI/3C1N6kU05KpW6Z7oU3DCbMGRnoGGHTIJ7hpS7T3ZvCMkw8vc1t6+hyNB/nNGeB
         UZEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776212401; x=1776817201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z5uGFIcAqyz5wNzuMzPehrzfu6ZNsJAgolKPAxtg4WE=;
        b=I1HPsOXBDGlhpKi6WzD5rCQIypdaS4gjSgt/JBXqbIazOZo1OS3ZRvjehqLPG+lMQF
         gJg0K6kYZwsJi2UlzvHkGyHIiYt2GpeQvKqQzhEy2YruhWX2YiK7GRCevr+qkMXe9+gh
         RAMc6+kjCiBJSfUnFtOf+T28IO4As5gwNO95JaXepcsRyKVAaI1q3tXVVeHue9BYN8VY
         mnERtdxf8aWxFsH1e//2NJwv2XWwy6BoA6VQ67dUThRh9mYhVeXq3etPYswKmR0+tPO9
         nPYbuM2uKXn0HWFzEkeUBYAY5kvdxCPDo1CIwexH+j3V8SwNvUyC2wpmCS3YBxqIiepI
         9sAA==
X-Forwarded-Encrypted: i=1; AFNElJ8CiAgOjNIiVKmA8y7hDp3ho/h0wKv9mgzeMNhNV1fu9tfRRCjsB+xEhCWiyRo5LDxQclxPFhFccw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyBricNoTCJKrl6iVBC9u4NsNqpO0FLPSFdE+d2Fn3azpILaTT4
	qfk4FQD7r5KBF1yjLYMY14d3LnFVuRa1Ru6pCo4WGLMisjCUNt/6TxpnJHMp4X0zK49fpdoiSrA
	Fn1rygjhGwnfQSzngNwpcJviutEDbxoaME0XF
X-Gm-Gg: AeBDievbXybRYsAwA+2Hkii+N+QjSHpXmVMUzMl0HbYe6Xv/Vb+HZndR0RTaGcvhukg
	ZXOIIRgOQyU1mMMcfa2b6YQy5xd2zeY53tZp+a4pCWcBdR/rOj1D3omJ05SAUv0F51sRgQ/UgIy
	ySutD4xUREa21ZVJh6ZgdS3Er493xIY8BznCoOcqwszMftcQZQDESRxbE2q1EGmp7TzDf+R6VMB
	gxhlUhf3ehGOwUkFSuScALpNLUckpqjYnnHQzepn2p9uhueeDqFu/DEibImNNlu6ntNkEsNLnnT
	NrFiqFFlKk2MTOUL
X-Received: by 2002:a05:600c:c08b:b0:485:3c2e:60d5 with SMTP id
 5b1f17b1804b1-488d6816f66mr187389025e9.2.1776212401077; Tue, 14 Apr 2026
 17:20:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <18936160-308a-4817-a295-54eef43707a3@niova.io>
 <CAJnrk1ZknZJQDdJwE5WBK-yZzocMCN_eiCUzxqfHss5ZKBZQ4Q@mail.gmail.com> <e5553fcf-04bc-49e2-9eb7-17f9007e7fad@niova.io>
In-Reply-To: <e5553fcf-04bc-49e2-9eb7-17f9007e7fad@niova.io>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 14 Apr 2026 17:19:49 -0700
X-Gm-Features: AQROBzB5VnBua0Tj33oLBjLUCqbPDJEOwRxBLNxj9m6OHjtjQHWP_tRVjYcDrHc
Message-ID: <CAJnrk1btU1Mqw9GgbNUXOcTm56odiqW5Qe2uGx_KC9RB0u3GQA@mail.gmail.com>
Subject: Re: fuse/io-uring: Proposal to support pBuf in additon to kBuf
To: Bernd Schubert <bernd@niova.io>
Cc: fuse-devel@lists.linux.dev, io-uring <io-uring@vger.kernel.org>, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Ming Lei <ming.lei@redhat.com>, 
	Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13042-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[lists.linux.dev,vger.kernel.org,kernel.dk,gmail.com,redhat.com,szeredi.hu];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[7];
	FREEMAIL_FROM(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mail.gmail.com:mid,niova.io:email]
X-Rspamd-Queue-Id: CF1C73FF444
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Apr 14, 2026 at 10:34=E2=80=AFAM Bernd Schubert <bernd@niova.io> wr=
ote:
>
>
> On 4/14/26 02:56, Joanne Koong wrote:
> > On Mon, Apr 13, 2026 at 2:33=E2=80=AFPM Bernd Schubert <bernd@niova.io>=
 wrote:
> >>
> >> Hi Joanne, et al,
> >>
> >> this is a bit of duplication of the discussion we had before, but I wa=
s
> >> badly distracted with other work and also switching employer - didn't
> >> manage to reply [1].
> >>
> >>
> >> I'm still not too happy about kBuf and its restriction of locked-only
> >> memory. Right now I'm reviewing your patches from the view of what nee=
ds
> >> to be done for ublk (for my current employer) and also for fuse to
> >> support different buffer sizes. Let's say fuse only support kBuf and i=
ts
> >> restriction of pinned memory, I think we would be forced to add suppor=
t
> >> for different buffer sizes to the current ring-entry-provides-the-buff=
er
> >> and the new kBuf interface - from my point of view code dup.
> >> If we would allow pBuf for fuse, we could put the current
> >> 'ring-entry-provides-the-buffer' interface into maintenance mode and
> >> support new features with the new interface only. I know you disagree =
on
> >> using pBuf [1] with the argument that userspace could free the buffer.
> >> Well, if it does, it does something totally wrong and the same could
> >> happen today over /dev/fuse and also the existing fuse-over-io-uring.
> >> Just the window is smaller, as the pages are extracted from the buffer
> >> during the copy.
> >>
> >> I was looking into what would be needed to support pBuf and I think
> >> io-uring could extract pages from pBuf when the buffer is obtained - i=
t
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
> >>   - fuse_ring_ent (bufring union side): payload_kvec and ringbuf_buf_i=
d
> >>     replaced by io_ring_buf + pre-allocated bvec array.
> >>   - Buffer selection under queue->lock removed.  The lock only protect=
s
> >>     request dequeue and entry state transitions.  Page access happens
> >>     after the lock is dropped, in the context where the copy runs.
> >>   - setup_fuse_copy_state bufring branch: is_kaddr/kaddr replaced by
> >>     iov_iter_bvec() and would continue to use iov_iter_get_pages2()
> >>
> >> What do you think?
> >>
> >> And my current primary goal is to let ublk to support multiple buffer
> >> sizes - ublk would also need to get support for kBuf/pBuf and I'm
> >> current assuming that fuse and ublk rings should just get multiple
> >> kBufs/pBufs and a config options that mapps bufs to io-size. I'm still
> >> looking into details for that.
> >
> > Hi Bernd,
> >
> > Thanks for your email. There were some changes made from v1 -> v2, so
> > please see the v2 "fuse: add io-uring buffer rings and zero-copy"
> > patchset [1], as I think this will hopefully address your concerns
> > about mlock. In short, what changed from v1 -> v2 is that I dropped
> > the approach where kernel-managed buffers is an io-uring native
> > infrastructure. I realized when trying to implement integration
> > between the io-uring networking layer and kmbuf rings that kmbufs
> > didn't tie in as nicely as I'd thought with io-uring native requests,
> > and fuse has too many constraints for the kmbuf ring (locking
> > semantics, request lifecycle, etc.) that it made the io-uring side
> > less clean; this made me realize this logic would be better off not
> > part of io-uring infrastructure and instead self-contained in fuse, as
> > Pavel had suggested.
> >
> > In v2, the fuse headers and payload buffers are passed as user
> > allocations during registration time through the sqe iovs and
> > server-side has control over whether to pin the headers or payload
> > buffers or both (or pin neither), eg bufrings can be used without
> > pinning (no mlock requirement) and pinning is an opt-in optimization.
> > Zero-copy requires pinning both headers and payload buffers, as zero
> > copy requires CAP_SYS_ADMIN privileges anyways. In this design, the
> > buffers are only recyclable by the kernel (unlike pbufs). Unlike pbufs
> > where the api contract is that any buffers not explicitly put into the
> > ring by userspace are under the full control of userspace and not
> > touched by the kernel, this design continues the existing-fuse-uring
> > contract that any buffers passed in through sqe iovs during
> > registration will be copied to/from the kernel as long as the fuse
> > connection is alive. In the future, if the buffers need to be
> > kernel-allocated for dma contiguity or other reasons, that could be
> > added separately if/when it becomes necessary.
> >
> > Does this address your concerns?
>

Hi Bernd,

> yes absolutely it does. I had actually thought that Jens had already
> accepted the kBuf changes. I had seen the discussion with Pavel, but

Yes it had been briefly merged into Jens's io_uring/for-7.1 staging
tree and then it was dropped.

> then seen (at least I think) that Jens had accepted it. And with the
> different versions, I didn't notice that v2 (in my counting that is v5,
> I think), doesn't use kBuf anymore.

No worries, thanks for taking a look at it now.

>
> If I understand it right, the io-uring bvec changes are only needed for
> zero-copy?

Yes, that is correct.

Thanks,
Joanne
>
> Thanks,
> Bernd

