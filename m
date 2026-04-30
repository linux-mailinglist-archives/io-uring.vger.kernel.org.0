Return-Path: <io-uring+bounces-13189-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oL1UAqh182nJ4AEAu9opvQ
	(envelope-from <io-uring+bounces-13189-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 30 Apr 2026 17:30:48 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8160F4A4CCA
	for <lists+io-uring@lfdr.de>; Thu, 30 Apr 2026 17:30:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B19CD30214E6
	for <lists+io-uring@lfdr.de>; Thu, 30 Apr 2026 15:20:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 525EC2C08D4;
	Thu, 30 Apr 2026 15:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K0HH66l9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7552C3252
	for <io-uring@vger.kernel.org>; Thu, 30 Apr 2026 15:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777562450; cv=pass; b=Fw3BT6RlpQ4uInUhsQCuqlTyWJwY38i3D07RciFSFD1fBZQEX7doc0x/qo+YTskiPMz6FL1xS1dqhFDIXLIhLEh/3jWLOg7ola1dVu5Xl/oB1iOmfuyxQR0ezNf/rbEQsm4Ryk1iddjno+gKIiC9vHRWiMVfHekN2BBbFR/Qxrg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777562450; c=relaxed/simple;
	bh=4M/yBReMw7nFSotYuj+DWWY6sz8pxUDoM5L9QaUG1rA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ijEL4txxa0MRA22e1jJ5ZpwRL2CX/x8xBjvpDVQ3+fx2MN+Gb7Gh72UMAtlO6rg0bY1If2xVID3l2N/IEX/QqMc0e3YP+JOlCXIFkjNszngCE+mZZ4fOX+BaIFB6iGZ1Jg90DybOSsQLtmFkYP5gMZndfgiU27liajCDkzPy8Nc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K0HH66l9; arc=pass smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43fe62837baso651659f8f.3
        for <io-uring@vger.kernel.org>; Thu, 30 Apr 2026 08:20:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777562447; cv=none;
        d=google.com; s=arc-20240605;
        b=i1u/A2M2LCGeY02UHWT4TO7QvixEldYJnXiDZcjyHXhnvmqIAN3SPk/pKMSyRcrzIf
         SYqD6jQMd8LXPxRh199NugsQcGsH1fXrnUW14FuMbyknxcpslXaSTSg/BeEtiVAsobAR
         4lLq8QWKGK4VPSyG1ABuvuyD6W9TXoIagSzybSomkEuP2bFsN9lANd9uNuLaQ53zFJ1f
         YpK5rDfYc7zy8YMKL7v6iMTybNs5pFJN3l4QV/upDCW0oASQruRmpBvyHId9geOBjPVk
         aimBH4Mdos23oWU097x2is8DNei54ZwnqPoXooWexnYSdt0lrTVFc8ox1a6hyprh1tTS
         g4aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Tf4ZYrJ8jWXqA5SZ3EYmerOKJPYj1HSyCqmogWlEE/s=;
        fh=wttI9gcjteLK0ad87RtGJgNVBbqPkMz/zCbHSEuwihw=;
        b=B7sWsYlNempBFUkvhVXZz9Xab6DEqPYRepP3OKCwYtHfA1RhpLXjSTI/VI1dtE4xmX
         XLpSjWcTHX0rMcheUfHac50e6l44v7G8gCHKS2hQAZHD8mwE4xNVf5Z99b/0N4SwTCfq
         BaCD+5A6NUcnv53tWoKr9jjbZHls+RD8q3WsMdy5x06dSVcgaHiRc4EKa5Yswc5kcoQy
         uN2MxYJTTUSzQ53jXDhFvG0MA7pOWgocpnvqqjvwouYIAX0TpLW64OtEXHHNjsUflaaD
         TM60pt4BXZrV9cwgBeUkb3XjJ70UzC92DT31fuO/kzXq9FhMxVX/t848fXCsvHPA9/cp
         k32A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777562447; x=1778167247; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tf4ZYrJ8jWXqA5SZ3EYmerOKJPYj1HSyCqmogWlEE/s=;
        b=K0HH66l9rZ4R7NDSIRRwk9W84+B18z8tEyJAmeIv6PJiCnRE8ZCbBQlOlTNESelEkp
         RoA3UVweINP+klR+4vn6TNZfYQAiNfIU3iv1PfnmKwpmqPfkvOKpUIC6f7lyPRZZ4y/c
         C8S4bOrqlfRBKNjMI4rEIeZcQ+GgIEJxNWnT/7w3WSRsRB/hBW0OPWnLVAwTV7lFxGma
         6tG/yAASe3lPK3LUHkWOECY+6No/wAJcWrx+eGoREFrEMgKYg3l9mAI2G9SUt7RSyv7l
         uNyo1+K3y+AHXfX6iw6hMA6M7HTL5r7xeQ+/G4uBz3GUOM419nn+uwiDEmoI4FnKNXaN
         SWUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777562447; x=1778167247;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Tf4ZYrJ8jWXqA5SZ3EYmerOKJPYj1HSyCqmogWlEE/s=;
        b=fGpFKl3xGnuHrY8umDSQ6peU1s5UaCpfXBC16K5EVZF3tFdF0Q9r2NyRy6d/TBrGi9
         olkHJqwzr4U1/DAn+d6rnv4X+cTHRxH29pZgWJLpQ9S165pN6hkKS+8LwnVtOhLDdeBX
         cbAu40jNSXdLgbaDPpFMCY/SAOZNOAz76HYSQIIVFPWlGpnHgTbTwZ5rCQ0Gjo6VjcgE
         2fkOSEGqXu/qu7yuOj9+/1FCBMVPqt04/pCX/TbPykozvHSwa0dZ5aIylRckf9f/B4wf
         qKAnUVVxqZ0akWtUtbRcpx+Jw26d42JhxYAKZQWLOHI3Iyo8NnemKIp/Ob9BmsPYRBkn
         mN8A==
X-Forwarded-Encrypted: i=1; AFNElJ+lW5g6IKG4aBBi1bKIDuyU7O5N2ZSLMtcoybe6rAnCwk9PhSgAe1W7QMsK/VSfDn9/lprkH1nYWw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9SMjWYHnd8hgNXzrjoKZEehYnrWclzdKIrQfMw/pVt725bH4T
	xDbGBS+01hw/GNXm/UTi9wjEzTdJA2BSv9uizbNxAqR0ghKzeHDe27KDotT80C/qsc2CkvvNmwD
	uk2apYuUL3pe5uD18mfVPf6LBJOP1J/8=
X-Gm-Gg: AeBDieukIaOR0DwmwUXJBYDp1vMjZ7XER/U0GoRK5RJdM74cWfUF2Rasgk7SAe0a4Lv
	3Mh8kIJX31RnlIW6DPmYbOEYjSzK+WZSIawFuHlxlcKrdBJyGge0akmQMxMddYNi3CYCZ0T6nzp
	T4K/HLVoagnk+zbjZB0HJd55Wh78RVyrYv7EOfalEKYQCpGpPrzhF61HmvLxbWXCSfH/qw1cazg
	5UUDI8PZnPgLLsjRrgBuxLL2pd1adjQsqzUhwGyOgETXo3l89pUJC52XnGvpIEBbLMSmRAzrNdX
	7QcZ4zoM+GiAyiTLZRlG4C/Dc1FfZ2I=
X-Received: by 2002:a05:6000:2891:b0:43d:67f4:91aa with SMTP id
 ffacd0b85a97d-449403a9c35mr5637707f8f.40.1777562446695; Thu, 30 Apr 2026
 08:20:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <18936160-308a-4817-a295-54eef43707a3@niova.io>
 <CAFj5m9LeM4S82QEsRQ0uQiXj1eWCFAW3v2fLTxUj1YM7UO-V9g@mail.gmail.com>
 <fcad39e2-37b5-46a9-a280-2315e0397985@niova.io> <CAJnrk1Yw3=z7W_my4pLG6avBeDZkUp3j1LZk-RVpGv2vAsw-ZA@mail.gmail.com>
 <b2037b8f-466c-47d4-b74b-fe5b8f38fbc4@bsbernd.com>
In-Reply-To: <b2037b8f-466c-47d4-b74b-fe5b8f38fbc4@bsbernd.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 30 Apr 2026 16:20:33 +0100
X-Gm-Features: AVHnY4JIP708ebKcg3t9ciiWnAWYAwhXYA5fjWoeJDq1Qnz01zSf-LLjUcKEMQw
Message-ID: <CAJnrk1aOTdDCOY-3F_urPbasRMFy+0DDLADWU2zss=D+8xaonQ@mail.gmail.com>
Subject: Re: fuse/io-uring: Proposal to support pBuf in additon to kBuf
To: Bernd Schubert <bernd@bsbernd.com>
Cc: Ming Lei <ming.lei@redhat.com>, fuse-devel@lists.linux.dev, 
	io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	"Lei, Ming" <tom.leiming@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8160F4A4CCA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13189-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,lists.linux.dev,vger.kernel.org,kernel.dk,gmail.com,szeredi.hu];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_FROM(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,niova.io:email]

On Wed, Apr 29, 2026 at 11:09=E2=80=AFAM Bernd Schubert <bernd@bsbernd.com>=
 wrote:
>
> Hi Joanne,
>
> sorry my terribly late reply, takes about 30 min to reply for these
> complex discussions and finding that time is currently a bit hard.

No worries, thanks for taking the time to reply.

>
> On 4/17/26 23:02, Joanne Koong wrote:
> > On Thu, Apr 16, 2026 at 7:46=E2=80=AFAM Bernd Schubert <bernd@niova.io>=
 wrote:
> >>
> >> Hi Ming,
> >>
> >> On 4/16/26 15:49, Ming Lei wrote:
> >>> Hi Bernd,
> >>>
> >>> On Tue, Apr 14, 2026 at 5:33=E2=80=AFAM Bernd Schubert <bernd@niova.i=
o> wrote:
> >>>>
> >>>> And my current primary goal is to let ublk to support multiple buffe=
r
> >>>> sizes - ublk would also need to get support for kBuf/pBuf and I'm
> >>>
> >>> Ublk server is just one liburing application, and it supports all gen=
eric
> >>> io_uring buffer types, so kbuf/pbuf should be fine for your ublk serv=
er
> >>> in theory.
> >>>
> >>> It really depends on how your ublk server is implemented.
> >>>
> >>> Maybe you can share your motivation first before discussing kbuf/pbuf=
 support.
> >>> If it is for DMA,  there are other candidates too, such as hugepage,
> >>> recent added
> >>> UBLK_U_CMD_REG_BUF, ...
> >> Joanne had actually removed kBuf and switched to pBuf alone and that
> >> simiplifies things a bit.
> >
> > Hi Bernd,
> >
> >>
> >> Motivation is to reduce memory usage. Let's say you need 4 IOs of 1MB =
to
> >> saturate streaming bandwidth, but still want to get smaller IOs throug=
h,
> >> for these smaller IOs you don't want to assign the 1MB buffer for each
> >> queue entry / tag.
> >
> > Have you considered having separate rings take separate payload sizes
> > instead of having each ring support multiple different payload sizes?
> > I think this gives a few non-trivial benefits over per-ring
> > multi-buffer-size support:
> >
> > * less head-of-line blocking - with a single ring, the large io
> > requests can block smaller metadata requests until the io completes,
> > since fuse processes cqes sequentially from a single ring. Separate
>
> I think blocking is a pure libfuse implementation issue. All
> example/passthrough* file sytems take the buffers and write it out in
> blocking mode. However, they could use non-blocking IO like io-uring
> themselves and act on completion. Processing what fuse-client/kernel
> provides would then be rather fast. Same applies to network IO, which is
> implementation wise probably already async, except that we do not have
> an example yet. I'm currently creating a small benchtool for my main
> work to test different io-uring options (mostly network related) - I can
> use that as template later on a libfuse example.
>
> I.e. my argument here is that we should not make the kernel more
> complex, just because libfuse is not ready yet.

This is exactly my argument :) I think we should try to keep the
kernel side logic as simple and as efficient as possible.

With regards to head-of-line blocking, processing IO server-side in an
async nonblocking way make work in some cases but there are plenty in
which this is not feasible. Using non-blocking IO like going through
io-uring requires the backend to expose the raw file descriptor but
many real fuse servers don't talk to backends that expose this, eg
custom rpc/networking libraries, database client libraries, in-memory
filesystems, etc.

While I agree that the passthrough examples could be improved, I don't
think we can assume most fuse servers can adopt an asynchronous
io-uring-like model for issuing backend I/O.

>
> As soon as the sync FUSE_INIT series is merged into libfuse (and
> obviosuly also need to take care of Darrick series) I will start to work
> on a reactor/coroutine libfuse interface - the daemon is then the ring
> owner - daemon can set up the ring as it wants, use or for backend IO, et=
c.
>
> > rings would allow smaller requests to proceed independently of io
> > * makes kernel-side request dispatching more efficient + simpler  - if
> > for example there's 10 different rings and each of them supports 4
> > categories of buffer sizes, imo it gets non-trivially complicated to
> > find an available ring that supports the payload size that needs to be
> > sent, if there's lots of parallel requests going on. In the worst
> > case, we would have to check each of the 10 rings' various categories
> > of buffer sizes to see if there's a slot that's big enough.
>
> I don't get that - let's say we have several pBuf rings - it could
> always check the next (rouned up) size? One could have an option to
> search for available slots in larger pBufs, but I'm not sure if that
> would be wanted. Let's say we would have two pBuf rings, 4K and 1M. The
> 4k pBufs then could be use 1MB memory - place for 128 small requests -
> why should small requests then switch to the next larger buffer pool, if
> their own pool is exhausted? In my opinion large pools should be
> reserved for large requests.

I think this would be suboptimal. I don't think small requests should
stall when larger buffers are sitting idly.

I think this also adds more nontrivial kernel-side complexity, eg the
kernel now needs to have per-pool wait queue management on top of the
existing per-queue entry management, whereas with having separate
queues each with its own payload size, we can just use the existing
"queue has no available entries" logic and not have to deal with doing
extra bookkeeping / pool management.

>
> > * simpler kernel-side buffer management - keeping track of the payload
> > buffers in the ring becomes a lot simpler, since there's just one
> > buffer size the ring supports
>
> Personally I don't think it makes a difference. Instead of having
> multiple pBuf rings you now have to deal with multiple IO size io-uring
> rings. Maybe I mis-understand your itend, though.
>
> > * more dynamic / deterministic scalability - I think you mentioned on
> > another thread you were interested in dynamically adding ents to
> > rings. Having separate rings for separate payload sizes would make
> > independently scaling queues based on workload characteristics a lot
> > easier. for example if there were 10 rings that each support 4
> > different buffer sizes, one question I would have is which ring would
> > the extra entry be added to? It kind of seems like at request dispatch
> > time, it would have to do that non-trivial ent searching logic across
> > all rings mentioned earlier to find that extra ent?
>
> And entry would always go into its own fuse-io-uring queue. Without pBuf

That is the point I was trying to make - with the entry going into its
own fuse-io-uring queue, it's not efficient for dynamically scaling up
capacity because the server doesn't know which queue should have the
added ent. For example if there are 10 queues that each support 4
different buffer sizes and the server wants to add an extra ent for a
16k buffer size, which queue should they add it to? If small requests
wait on a queue when its full pool is saturated and don't search
across pools, then this becomes even more suboptimal. Whereas with a
queue that's dedicated to a 16k buffer size, that entry would be
available to any matching request, rather than only to requests that
happen to land on the specific queue the server added it to

imo the multi-buf-size-per-queue design suboptimally
distributes/fragments buffers. With separate payload-size queues, all
4k buffers are in one pool - any small request can use any of them.
With multi-buf-per-queue, the 4k buffers are fragmented across queues,
so a small request can only use the 4k buffers in its specific queue
even if other queues have idle 4k buffers.

> I would have added these entries to a size sorted ent_avail_queue[]
> array, with pBuf the entry doesn't have a payload itself anymore, but
> only the pBuf rings have.
>
> Here I had suggested to convert the arg size to an order and then to do
> an O(1) lookup for the right buf ring
>
> https://lore.kernel.org/r/ff596299-38c1-4c5a-8f1d-14931dd84ef0@bsbernd.co=
m
>
>     struct fuse_bufring {
> ...
>         /* lookup: order (req size) pool */
>         struct fuse_bufring_pool *order_map[FUSE_URING_NR_ORDERS];
> }
>
> struct fuse_bufring_pool *pool =3D order_map[get_order(fuse_len_args())];
>
> Without pBuf it would be the same, except that ring entries would have
> their payload size and would be sorted by payload order size into their
> ent_avail_queue[].

I think doing this without bufring makes it even more complicated
kernel-side with having to keep the array in sorted order

>
> >
> > These are just my 2 cents, but it kind of seems t o me that having
> > separate rings take separate payload sizes could be more scalable for
> > your use case?
>
> I don't think so - more rings just create more syscall overhead from my
> point of view. And more rings are harder to handle with coroutines.

I disagree with this, as there will already be multiple queues per
server. I don't think this would lead to more queues. (using "queues"
here instead of "rings" as it gets confusing with there being 1
overall "ring" per server, but multiple "ringqueues" inside the 1
ring)

I think it's clear we disagree on this and an in-person conversation
might be more useful for getting this hashed out :) Maybe a good topic
for next week at lsf and Miklos can weigh in with what he prefers?

Thanks,
Joanne

>
> Thanks,
> Bernd

