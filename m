Return-Path: <io-uring+bounces-13055-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qA8AJbPp4Gl/nQAAu9opvQ
	(envelope-from <io-uring+bounces-13055-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 16 Apr 2026 15:52:51 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 948E940F391
	for <lists+io-uring@lfdr.de>; Thu, 16 Apr 2026 15:52:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5FD143004608
	for <lists+io-uring@lfdr.de>; Thu, 16 Apr 2026 13:49:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B22B3D412C;
	Thu, 16 Apr 2026 13:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cf62XgbF";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="qe+7C0Ja"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367493D349F
	for <io-uring@vger.kernel.org>; Thu, 16 Apr 2026 13:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776347381; cv=pass; b=btxWRjf9ZFUTi3uy98zn0kic4aoyo3b8Y2hQtJXBLsfYOMFAM33UsO8HUczca7dUO+F/rH/2YwqW0Un1UHYdKJ5r1sRKCQYLEGMjpfDGTByEDXn8p9s52dNvqcpeT6W5L8HeEeBQodjzLYFIYyMJ/yUIkWOGgoKOI9kQHUKcfAs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776347381; c=relaxed/simple;
	bh=Z0i7dR1qW8QN1sVk3QQ5xgZCNm5RCBy7MydE8xtg/rI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N+hCDHjZ2Iz/o4ExdfKldE2AiWxhkn6WNUxc9x/+ug71ujIvcMcIQB0fA3UQMeH4N56FQf5CpKeELgjgXdsg4Sr3k1A/fPtGtdqiLMPKbcM7EMF9NCORwhAAQMwoiB3nl71btzk6x8gGAHw9UO4+Tv/WlaND750WL96iyzBoTIY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cf62XgbF; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=qe+7C0Ja; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776347378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P8FEgUgpQ2ISixaYIydOnHi/p4L1N5t+4Tzt+CMNzn0=;
	b=cf62XgbFlDSEuaUI+fjgr0UJxMImJ2b2+GSCtbi8yjbOQvKR2S7z7aGWS3qoDaQgG0nV+d
	/i0ThyMUoD9CossCuu63rJ7WZMZ9/97pzxkU85/KljVMUKVdGJs4uUvztFvv0Fh3Tn2Dss
	QjSiohOtOJtLyFClSdy2trKloM5+v/Y=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-492-F0tvM-uIP-yY5W0_fdKL2w-1; Thu, 16 Apr 2026 09:49:36 -0400
X-MC-Unique: F0tvM-uIP-yY5W0_fdKL2w-1
X-Mimecast-MFC-AGG-ID: F0tvM-uIP-yY5W0_fdKL2w_1776347376
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-950bdef305bso13484371241.3
        for <io-uring@vger.kernel.org>; Thu, 16 Apr 2026 06:49:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776347376; cv=none;
        d=google.com; s=arc-20240605;
        b=KsKP0rRTGlfLdZPwBw60l0HB15PD37PTe2y6fbuiZG1SGqEa/aY8M7b2qzLecL2z+a
         0R/yf6Bj/ZgVvYZisoj9pzX9UgDD93VngvjcLckQ5YevGvCSBypZxHYzGaL1w7Yg6g+Y
         ImA2miKT632No6DXZsk5mpJON+hEXkrrvcxJ/21UjwGpT1kOxLtayS986v1tNhIXqG4U
         VbDUeMGjxGgUhTaTdt1IDWVCMsfSaJMNwZixOvpUGPEbTdx8PowUxen3ZMwv1G0ZGdSK
         DX7B5HUU5wUD41yCIENmgGPAatMBSLarH3k9WolqNYkYxmFxCAuHbjFISuUo00HKp1EV
         0+AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P8FEgUgpQ2ISixaYIydOnHi/p4L1N5t+4Tzt+CMNzn0=;
        fh=aAh26v33rkMz3Sibosac6kwRNp112ZVjDbLFOUHu4o8=;
        b=RvmmLfGa2IQpLK+Xu57VOCcEZlFuEdtdC2+r3OTpy9cpUZeti+pHLSFl6NfOtDLnnw
         LCOFtcDO4dphLgKPw403i8a7TUy8I0iZ1V/W3IGRyr0wHpgDTJ4CPqKa/vIbLkGbSdxn
         A+7WItttXE4efzyGJnhPD8MnGxRiv6Bd4YZcwsiPvxPcuKQbka11xuH0EBQofdEZwr0s
         ob1Z/dgkifxmkg8AepRWplWnRZFZDAec2dgiUnrufQwTSAtMPhANcc3EQg2YZsxdwR+C
         X7xNnl3kklA5sty+v0PkQioYYAGcgoOfOJW8GhFw5BZZchDH5YCQom2kRBKGGU171/t/
         NnRw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776347376; x=1776952176; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P8FEgUgpQ2ISixaYIydOnHi/p4L1N5t+4Tzt+CMNzn0=;
        b=qe+7C0JaOkPcW4cPcwpf1tstSG8gl3lxb6UYy3QhIONMdyaJGFjgJ6yjBQPDgd5sDb
         YXh5nPafKBJi396bHUvBmZmccF2wmjZHN5Cgwp2frxuu+wKAfTY6uKA8uIdoXK4EBBkm
         BeI9WzFOtwgySBpMEDBOlOxZPInjT2xKUvNJTIet2uVsGL1zcmjGQC5Y7H2C7UfuAPGF
         FFNXXXn4OpryzxaGRJRYp8oNtktpcaKLzNsXuTExaCCGG6QIOCxpuJuqTnwIGcSrzPu2
         xo3nrqRsxe59HsvG5OwlJMl+zWM8/gUiWtR7LXRHn3gYTQyiYXYZOKAohK+anf8duFmv
         R8iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776347376; x=1776952176;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P8FEgUgpQ2ISixaYIydOnHi/p4L1N5t+4Tzt+CMNzn0=;
        b=Ygc89Kk338XJDlWHU6gn/ZlzrQCPRx5PvHPjdDL8jbgSX53jEj3gZL4h3ahBRLLHRt
         Vg9hn+AVP0gIqLzlpZ6xJiYcj1m5+/kjATxv6Z5reLbch10rBfbX8q5QrB0X+vbavqQx
         r+u9nkbBEWZF7jHDRubOtT4jtTSOWPED1oiC1Q+SdLJFFWldlIfN9tbn26COydYe9l0k
         TSTEbaXIYbDuDjuZGvnqPF/IDc9c2Ho7Tl+X54MPo4xAdIWq38QiE7W+rW/+IdtlEaag
         J8wTGoU/A3A/bSQKRQApSxX74JH9ke4jGBKeKY0cVozAqHVO/96q+ZNSqE7lC5K4manB
         BCdg==
X-Forwarded-Encrypted: i=1; AFNElJ/7Wai7SE7dCfcFJIXxqmBovhn+N2Ypcbd49mzpifDgF215fgDdOlNC1aW7dob9WDV3jriLoEBULA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxXjQpKYf4zAjqkc3x58OQad0+2pNQYXKmMaMnlINWIH0C3rjQ0
	2w7lvvS4Z4v2lNqIcdN+mG6bc6n8JBAq/ej4OXqfZzPuMGON2EUUWaZGiy78w+mD3McJVRnUbNb
	rH3zkmCM0pF214L7FYPFMxteWio9BQqg3oEftWPLxJJvRBpP3g/OKbJolFzOSBjd+xMn97UsfX8
	gxsY77st7TuXz05Jq1qwa0yczSwT0OtCziK9s=
X-Gm-Gg: AeBDiesjBjyE31gmuS5n42dMjI6NNEa60TvL+6hGwvJE3ltjbb1LvA7OFo2r4OpEbzj
	9XFW4Jo5lBnee6F+KwDu39tfHJjzBZJNCID0ZsH5XfmJ4wDhCzhSCfWTP3imDUXg0bWn0qhcBC6
	+b89y97oEWJPrAC9ek4pP5nwuZ7EDpzp0l+rp4QuXBx+txLQvc5DbLDDhMYuqapf1kHb9nJFDft
	pOQBuCS1DZVipcRvHiaqirJGLOMr74Lp4cu6tt04r6lWuPs1ig=
X-Received: by 2002:a05:6102:5ccb:b0:611:b9be:1199 with SMTP id ada2fe7eead31-611b9be29c9mr6055067137.14.1776347376357;
        Thu, 16 Apr 2026 06:49:36 -0700 (PDT)
X-Received: by 2002:a05:6102:5ccb:b0:611:b9be:1199 with SMTP id
 ada2fe7eead31-611b9be29c9mr6055049137.14.1776347375919; Thu, 16 Apr 2026
 06:49:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <18936160-308a-4817-a295-54eef43707a3@niova.io>
In-Reply-To: <18936160-308a-4817-a295-54eef43707a3@niova.io>
From: Ming Lei <ming.lei@redhat.com>
Date: Thu, 16 Apr 2026 21:49:24 +0800
X-Gm-Features: AQROBzCIol7RE0DDxLQaR6r4Mq7i-AWBn2vORSsKLH8h7_cokENW_lNLW9f-hKA
Message-ID: <CAFj5m9LeM4S82QEsRQ0uQiXj1eWCFAW3v2fLTxUj1YM7UO-V9g@mail.gmail.com>
Subject: Re: fuse/io-uring: Proposal to support pBuf in additon to kBuf
To: Bernd Schubert <bernd@niova.io>
Cc: fuse-devel@lists.linux.dev, Joanne Koong <joannelkoong@gmail.com>, 
	io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	"Lei, Ming" <tom.leiming@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[lists.linux.dev,gmail.com,vger.kernel.org,kernel.dk,szeredi.hu];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13055-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ming.lei@redhat.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 948E940F391
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Bernd,

On Tue, Apr 14, 2026 at 5:33=E2=80=AFAM Bernd Schubert <bernd@niova.io> wro=
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

Ublk server is just one liburing application, and it supports all generic
io_uring buffer types, so kbuf/pbuf should be fine for your ublk server
in theory.

It really depends on how your ublk server is implemented.

Maybe you can share your motivation first before discussing kbuf/pbuf suppo=
rt.
If it is for DMA,  there are other candidates too, such as hugepage,
recent added
UBLK_U_CMD_REG_BUF, ...


Thanks,
Ming


