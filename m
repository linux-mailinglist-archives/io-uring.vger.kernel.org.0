Return-Path: <io-uring+bounces-13035-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +A//NLaQ3WkLfwkAu9opvQ
	(envelope-from <io-uring+bounces-13035-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2026 02:56:22 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DF3A13F4AB7
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2026 02:56:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id F1614300B445
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2026 00:56:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA567242925;
	Tue, 14 Apr 2026 00:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SAftWlN2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A0D23EAA6
	for <io-uring@vger.kernel.org>; Tue, 14 Apr 2026 00:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776128176; cv=pass; b=TpeJMfP38SC20UbHaUEZhCcWUu2xK+RgyXAfZQfsPWqlKcWChK1hov3BPH8DLF1FJc2uEzn1u++bOuPXhmrlFMB9cffPc0me9WPQ6LcQ7Y4iH8cSuIveLxa9O4DtviL/QpWxiZ7g35ZnKcUYTkdB/FO7FkmJfhts30JZTVZH7Qw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776128176; c=relaxed/simple;
	bh=Vp4pnW+APqoJ6vsm4GKCCFVCW8H7QvOZo2BoRfNkO9U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G12vue6snKF9v9ZN8bvcQhT3/2YDfjb5hTnuC35G/2BB9zBs20kdBUFDfl0ke9W5DGf0NY0tedOiOwi6XD2k6Krii7jNQvGexk2paWvBqJ+3ZACg67wuvDqZxCQph4OAnX3Y47M2yndKuTHkFF9wuzaXgykydHZBnq5yPWRlMEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SAftWlN2; arc=pass smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4852b81c73aso47345405e9.3
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2026 17:56:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776128173; cv=none;
        d=google.com; s=arc-20240605;
        b=TktOoiUr9TT8rMkkT3KCLjFU2mCEeuD69FcBIVGjm1iCpNOcChxnENA/msoDSgpmVr
         Au5QnSYIeYm3H3GFHwyibieTY2pkKc3v5Vkvik6O/H9gEGhWMJSvdfDSMbHBd1lHbAYx
         hPiYuoIW6Xh/fu7Ggh9Hd2LRUIdqw1P+GhsYSAenyi5S4yS/83G7RSSvpAJRfhNtNPmr
         bdP+e7a46sViO9ZZR8BUpXfqGwOLs4ZtwEathw0yVvXooTI8cTaYZI+U/tgfARdtwmH8
         C6DTxUQ2ESxhtA4+qlfKF/E5ngCar9q/fqOQCReIsC/D8a4qQzvPuvJ515kxDe8noHm5
         YDUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ALvfb/xM9NzyOiSdrffQV62MeEy+q68iWYXwc1mIBkE=;
        fh=kC+9vQnaH+PJ/T+0KLIFEPJMr+bb/vl8MDamNjtdNMg=;
        b=ksC5FwaxXd3rH0TkbDsOEVsCaekehZrKMmL09UED5n04l5VRhSQll6fB9fqoAiJD1d
         13o++DjfcMgqc2KhroYpzAv4hfxvZKZ4lQhdM1p1bX+PRSJgO6bTcC/Eznk+wjsnkpSz
         uRrz64pXV+Os2k6RkW9E4BNxSbOFa2K4lPgLJoEZvbQrd5Cym+s6K+9+2++Y94HXwISU
         b3TA9hHy2rOaWUM5j7QKOa+1OTXA/d+GfkqFSQG4BRswWGA0yJANkHDVlsmQmQY9I3KR
         EfgCZrDclDT1iPWqKalKG9yJBpderbItTEdFWkGD9nT9dJlD/6neH0aR80i6pz3dId7k
         qLxQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776128173; x=1776732973; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ALvfb/xM9NzyOiSdrffQV62MeEy+q68iWYXwc1mIBkE=;
        b=SAftWlN2/tTEgeEnyZ53dMlWWthPzGC8q3V6EFji1BunH8KihYTXunS3upPr/nIE25
         gkgCMOfINf3WcbSHfBjNuaTFsX3f/ofOCXwK2R2fS5Yf233FwgIoyKPWIB3A5A6xjtsJ
         x0Y98PimTLX0Ajq6I6EKWbDvbBddi59Blngxf5RlgbFhQEKgZ5kRFomkEnfdzuEOalXV
         RqAx7NfGOTKK6Uk5O47/UpZGNmBkZxFN5Uu6ReqKJvel5/DvAIaxC8Ka2jt8GlCz+37j
         t4KFOl571PYKcsNanlw69X+m8STBZhM09vZOFnsW/txdCq4Si4tdzbmEhVgDlbTiYizt
         V8qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776128173; x=1776732973;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ALvfb/xM9NzyOiSdrffQV62MeEy+q68iWYXwc1mIBkE=;
        b=V7O6UqEBXmlT5W+DuLq14MGMod/v8vtNqA4n1C5MtclIyiYZSiuqyKkbCslgiw+6mE
         HJXdoJlQi3ZfmXoWMDvELtDejjoGPycoJAGcbFaHU4f7fXJVnwPkDpZeT+aWBtgVWa1l
         xk9v1nYN2b6eHBWG5MRq7lwP/LyuWrln/xGpucrUnZ0E6Oyjiue7nXzvBcZsblhB07R4
         nx2ObpyPrd/i/A0iBuh0K5hpza49d5k7o+T86gErwpcSFSC3Eqa5zMxE0xgsEvwyoOjR
         /zvpl8YwsNh+fGhGWf7dpUfB9rskPiBzjKLGTHsgESrGz5a3uG1XUCvk6HDgFZz7MrX3
         w/PA==
X-Forwarded-Encrypted: i=1; AFNElJ8xsOpjFeqMl/kjD/GssDn/FnVi55ma3eMf4l7JZODbdftD35LnKjvkxpp7c+fj8lVbago29+VUew==@vger.kernel.org
X-Gm-Message-State: AOJu0YxbIGQpqrxvfNsSseiVAC61DiNt9OUEBtRCKuVQ7Zz6Hc6YxhAD
	FZWhNKEsg9w2dvgxfE23igtTau2mGgAlnV79xwbBwTF573NBH0WZY0tafu/1SmzFj66nMqiwAFY
	+TfQPuZVk7XT2BMb6LUOqohLksfQ3Xkc=
X-Gm-Gg: AeBDiet7lteqjdBvp6BIsQq7IO8Net+TnNCgYECybgdV7ORE4/FXc7yRkEGAmP7vN4r
	ZP74EUbgDfIojQyj8/7AgQ/zQ5TaK284KvUNyTOxUlIjweAfi3ara7jf29ThYAlQEOpLCRGoGzF
	MNKNDTGdWQ44fyN/jS99KIi3mnYwLYaGTAEEJ/HDwlp3y2sXsOF6X6h9XFDv0znmEbgEwORf2KF
	P/BDP/N4RPQ/eGIUZGvV3HLFsQK/1mZtfcgE3X3MH0ZrrvoLNagPPaaN56tRDlcf2FjZSh+1zFB
	4Y+P6A==
X-Received: by 2002:a05:6000:24c2:b0:43b:8f30:39bb with SMTP id
 ffacd0b85a97d-43d642ab9a7mr21513670f8f.24.1776128173330; Mon, 13 Apr 2026
 17:56:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <18936160-308a-4817-a295-54eef43707a3@niova.io>
In-Reply-To: <18936160-308a-4817-a295-54eef43707a3@niova.io>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 13 Apr 2026 17:56:01 -0700
X-Gm-Features: AQROBzBnMmFdOWWID1hWI3m5zWA1RGTzSCqJVLAJUC4BPrTd247iOe6Ovc9QqEI
Message-ID: <CAJnrk1ZknZJQDdJwE5WBK-yZzocMCN_eiCUzxqfHss5ZKBZQ4Q@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13035-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[lists.linux.dev,vger.kernel.org,kernel.dk,gmail.com,redhat.com,szeredi.hu];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[7];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DF3A13F4AB7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, Apr 13, 2026 at 2:33=E2=80=AFPM Bernd Schubert <bernd@niova.io> wro=
te:
>
> Hi Joanne, et al,
>
> this is a bit of duplication of the discussion we had before, but I was
> badly distracted with other work and also switching employer - didn't
> manage to reply [1].
>
>
> I'm still not too happy about kBuf and its restriction of locked-only
> memory. Right now I'm reviewing your patches from the view of what needs
> to be done for ublk (for my current employer) and also for fuse to
> support different buffer sizes. Let's say fuse only support kBuf and its
> restriction of pinned memory, I think we would be forced to add support
> for different buffer sizes to the current ring-entry-provides-the-buffer
> and the new kBuf interface - from my point of view code dup.
> If we would allow pBuf for fuse, we could put the current
> 'ring-entry-provides-the-buffer' interface into maintenance mode and
> support new features with the new interface only. I know you disagree on
> using pBuf [1] with the argument that userspace could free the buffer.
> Well, if it does, it does something totally wrong and the same could
> happen today over /dev/fuse and also the existing fuse-over-io-uring.
> Just the window is smaller, as the pages are extracted from the buffer
> during the copy.
>
> I was looking into what would be needed to support pBuf and I think
> io-uring could extract pages from pBuf when the buffer is obtained - it
> would limit the window when userspace can do something wrong in a
> similar way current fuse and ublk works.
>
> Suggested changes:
>
> io_uring:
>
>   - io_pin_pages() gets a 'bool longterm' parameter.
> The new pBuf path would pass false, every other exsting caller true.
>
>   - io_ring_buf_pin_user() / io_ring_buf_unpin_user()
>   - io_ring_buf_get_pages()/io_ring_buf_put_pages() -> fills the
> provided bvec
>   - New struct io_ring_buf (in cmd.h)
>
> struct io_ring_buf {
>        size_t                  len;
>        unsigned int            buf_id;
>        unsigned int            nr_bvecs;
>
>        /* private */
>        u64                     addr;
>        u8                      is_pinned;
> };
>
>
> Fuse changes:
>
>   - fuse_ring_ent (bufring union side): payload_kvec and ringbuf_buf_id
>     replaced by io_ring_buf + pre-allocated bvec array.
>   - Buffer selection under queue->lock removed.  The lock only protects
>     request dequeue and entry state transitions.  Page access happens
>     after the lock is dropped, in the context where the copy runs.
>   - setup_fuse_copy_state bufring branch: is_kaddr/kaddr replaced by
>     iov_iter_bvec() and would continue to use iov_iter_get_pages2()
>
> What do you think?
>
> And my current primary goal is to let ublk to support multiple buffer
> sizes - ublk would also need to get support for kBuf/pBuf and I'm
> current assuming that fuse and ublk rings should just get multiple
> kBufs/pBufs and a config options that mapps bufs to io-size. I'm still
> looking into details for that.

Hi Bernd,

Thanks for your email. There were some changes made from v1 -> v2, so
please see the v2 "fuse: add io-uring buffer rings and zero-copy"
patchset [1], as I think this will hopefully address your concerns
about mlock. In short, what changed from v1 -> v2 is that I dropped
the approach where kernel-managed buffers is an io-uring native
infrastructure. I realized when trying to implement integration
between the io-uring networking layer and kmbuf rings that kmbufs
didn't tie in as nicely as I'd thought with io-uring native requests,
and fuse has too many constraints for the kmbuf ring (locking
semantics, request lifecycle, etc.) that it made the io-uring side
less clean; this made me realize this logic would be better off not
part of io-uring infrastructure and instead self-contained in fuse, as
Pavel had suggested.

In v2, the fuse headers and payload buffers are passed as user
allocations during registration time through the sqe iovs and
server-side has control over whether to pin the headers or payload
buffers or both (or pin neither), eg bufrings can be used without
pinning (no mlock requirement) and pinning is an opt-in optimization.
Zero-copy requires pinning both headers and payload buffers, as zero
copy requires CAP_SYS_ADMIN privileges anyways. In this design, the
buffers are only recyclable by the kernel (unlike pbufs). Unlike pbufs
where the api contract is that any buffers not explicitly put into the
ring by userspace are under the full control of userspace and not
touched by the kernel, this design continues the existing-fuse-uring
contract that any buffers passed in through sqe iovs during
registration will be copied to/from the kernel as long as the fuse
connection is alive. In the future, if the buffers need to be
kernel-allocated for dma contiguity or other reasons, that could be
added separately if/when it becomes necessary.

Does this address your concerns?

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/20260402162840.2989717-1-joannelk=
oong@gmail.com/T/#mb8f96895aa2773424005ee06bb62ae980e95e604

>
>
> Thanks,
> Bernd
>
>
> [1]
> https://lore.kernel.org/r/CAJnrk1armV9VzBqrrdfr15K5ySBx2YJRk_P0okGnkzyMx_=
eDOw@mail.gmail.com
>
>

