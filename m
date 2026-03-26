Return-Path: <io-uring+bounces-12871-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8BXxJrCPxWlG/QQAu9opvQ
	(envelope-from <io-uring+bounces-12871-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 26 Mar 2026 20:57:36 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 211C233B2D6
	for <lists+io-uring@lfdr.de>; Thu, 26 Mar 2026 20:57:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6ADEB3027B4E
	for <lists+io-uring@lfdr.de>; Thu, 26 Mar 2026 19:55:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACF2A39A7FD;
	Thu, 26 Mar 2026 19:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mYrwleOl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD3634CFDA
	for <io-uring@vger.kernel.org>; Thu, 26 Mar 2026 19:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774554927; cv=pass; b=KDttZt1isE/X/qdcrcajgkKoHU572vs7RvK+ZtKLOeTckHCYxk9l34htjHSWXxQTgdK305bF7kB5jn/czrXBlQfJ1zW2rhCVOmJRVfb1t6kZBeXkfZXRUV3b7P7E1O7cKuG30NJzsYfDQA7dbX6NX/rpKAqhjCivLYAIx36gg+U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774554927; c=relaxed/simple;
	bh=qJB8SEu5Gzh2X/aY5+g1o/ERDdeeYta/+1GGVuE/JHA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uS2S3mDP7M1inZdYRS/zd9CiAAOjci/IoYj8XbnghdAHkmSXUjpoIwWpVDvlRouT12+dzsSjP8zHLhtTJuxNVpeXkNuYugzYSuPQxCTnwUzSOScFPiQGyIRf0Zpwby2EW+tlbO4tKw7YJHex9cbPPYhEO829+CLoJpX1NTUs758=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mYrwleOl; arc=pass smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-486fd5360d4so17189415e9.1
        for <io-uring@vger.kernel.org>; Thu, 26 Mar 2026 12:55:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774554924; cv=none;
        d=google.com; s=arc-20240605;
        b=De3yEtppGX+WiuIFKhEc15k2i8x6409pGDL0M48tsflofDRrIhh9wuYHu5c8akw591
         2ZV9ZzL/lPHc7y919lg5yct//SLZ3Nbtzpe/GCAv0q3PntPYlCJFO2NNOddQGOpiWw/z
         PcjwD4BAgWkGqf8yh2J9X7RHHdm/84TRxFkplKJcIJTY1XgOsc/w6/mmg/1Qx3tYYPFA
         qUBLo25TzKk0lPKh2h4IAnYC3EXr2w/cb1Btrqt+gWwKt7KfvGKwtzEVxgFqWuNxTCTH
         lZl2q4Fzo1oxI9B7axGAJqAI3K9mlJ6tmTvwVGUC4dLCwdVbtVU09Bf+F01TQ6WXncpj
         O5vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lkPPHiKupVPWpO71CuQgtbfFz/Cj/q7S+eUyMYfo/8A=;
        fh=8+OG2Xm7aCyOyCtvu2Xo1j8GLk7WIs0TpvbpSrhW8rQ=;
        b=jINPCPMisaeRotQnLPbvI8WFaiIBb0CObPxySix4ztOew/xYUCtNc+KA+gCUuNkNsP
         nIwqe9nlE6Va44Nz1oVyXH0SfpUc4SNDUB32dagJbKPQ1uGGSQpBBTSpjgqvpSQ85zUB
         r8EIdy5dA1M+WfqYhUwjSkszT1hCFE+C10ZUgK+AncMmDmOwhCIXNhCHawS2kDFAaJyP
         cL6bTD53PV7EQSF7Ddj4AlomLMFcykW3rNJTge4pMBei/WAfIx+jqsGDBU7Gzwx9h1YL
         oxkCLAA/0ramgzievONS13sFYYjYxe6t3Iw3KmjdyYTxA62+Uj9lHeZdESYSncfMLrDt
         ojMg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774554924; x=1775159724; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lkPPHiKupVPWpO71CuQgtbfFz/Cj/q7S+eUyMYfo/8A=;
        b=mYrwleOlB+2c/4hBh7bxJ9oWEr4uP9gGuh1SPStTNWJVXvJnwi0BX6GGKhIFy/G8Me
         yE5FvInNPrSFkTObcxtt4MM+bvXJz53c1jEu0Gra0S6R2Sp4TY7t0zSoE7NsjBkTl0MT
         XHqaePRqma5nk0drV6w9fjYNxVX/mabHMM3gTnoNUspRljD0AQRB1sHP0TAEhADlfmi7
         1XjY9LdIj8ojkHGL1GQTStHft3/350xUuhtPeBezTTBiNciqM10A1R6sTy0854DAcjjV
         G6VceX/iXOZ07Zy8VqybF7sKKkFpYMyGIm7Gi9RM9U5MYEPwTYTelHQKpAzloLtur7AV
         KAig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774554924; x=1775159724;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lkPPHiKupVPWpO71CuQgtbfFz/Cj/q7S+eUyMYfo/8A=;
        b=NGOUEJfUz8HQUHb0MhUsCD0MocJwWzRO/PEV8V7TIp2EWZw77e7Uiktiveg9lDyCtu
         PuzQIqj4LRn8pEsY3LlZG7jIEttA9IUGHsfNo1eSUyLhBbQUJf6mBuspRsoh0pUix6Gq
         9TN9y3X4Bi6bdrSiC2djPLHxGocCXnHQYDkJ79jiLBfUoGGtEgzwtqm4JTm3DyY8poDS
         h36Y/JWc0fZ9V1PxbzVmObjCLvjEXJ0V88W9AlK0DqxXz13Ppy0aN2dfMLvcbu3U75eI
         YWmSFVyf97TIY0qzN8UucVCzvBiBK5GR27OJzqBdYH6ry5BLDPMQu1g7RF2H+YeDl5PF
         Oj8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUSbne0IOiwbwciEQSArdNxr15JS4n3SkTHrDVqeW49rg7DqC5giaEqVUcBEXIMVcBTkOVnai2uUA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwwR4kRfXIF05nJ6DxCySXXdgkeuY83EUkh2rJWiOijx/cxhf2S
	Ca5RV0kBbB7JGxDFztSrTjfGPamorDyfFqc2FDTkyeC9ttmWka4C0BAa8AzNpIQzeii7IolR9KN
	t71Cr2e57aimU4gagXT0vy4YIs7bcxOE=
X-Gm-Gg: ATEYQzzto9pIuakAMceIND2gIhsa1otU3CKtPBaXTPP5WqGojreg0J1MBlS5ScEZQFt
	Mu42MirGYW1k97/rSwpwWprTcmL4fNXi8yLrNjTWLKKEpsX6j5G5+zPsExjDvEtXGVrJkNlUBzp
	bnr2BYWiZRle6D+4fcZL44zlUeWemwC0YJzBU39YRGtlAIM1v10rgN6bwTXJh39Q21Afgh7UhqH
	7kEsbEqHonDO+nRICZ5crcEeSbJ4siSGct9XlXEK31kiw7Q5mQpu1P64a89fNR5szryelOhLDQZ
	xHM7GA==
X-Received: by 2002:a05:600c:8b31:b0:485:30f7:6e88 with SMTP id
 5b1f17b1804b1-487160881a5mr142368355e9.31.1774554924176; Thu, 26 Mar 2026
 12:55:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306003224.3620942-1-joannelkoong@gmail.com> <CAG48ez0H_Z-NQvfOeczECz_sO=MzVDvu+8m+msB55rcAPfQOgQ@mail.gmail.com>
In-Reply-To: <CAG48ez0H_Z-NQvfOeczECz_sO=MzVDvu+8m+msB55rcAPfQOgQ@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 26 Mar 2026 12:55:12 -0700
X-Gm-Features: AQROBzBznLpAcriYs7FOg-wSZ9wJOdMDsPqfGWaCCg1zWSKC80EiZ9XGhT4z_sg
Message-ID: <CAJnrk1aTnoDwDVdgYrcN3tHm-_j79GKYY=8q_Lu=xi8=Cxi4bg@mail.gmail.com>
Subject: Re: [PATCH v3 0/8] io_uring: add kernel-managed buffer rings
To: Jann Horn <jannh@google.com>
Cc: axboe@kernel.dk, hch@infradead.org, asml.silence@gmail.com, 
	bernd@bsbernd.com, csander@purestorage.com, krisman@suse.de, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12871-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,infradead.org,gmail.com,bsbernd.com,purestorage.com,suse.de,vger.kernel.org];
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
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_FROM(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 211C233B2D6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Mar 26, 2026 at 12:33=E2=80=AFPM Jann Horn <jannh@google.com> wrote=
:
>
> On Fri, Mar 6, 2026 at 1:32=E2=80=AFAM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
> > Currently, io_uring buffer rings require the application to allocate an=
d
> > manage the backing buffers. This series introduces buffer rings where t=
he
> > kernel allocates and manages the buffers on behalf of the application. =
From
> > the uapi side, this goes through the pbuf ring interface, through the
> > IOU_PBUF_RING_KERNEL_MANAGED flag.
> >
> > There was a long discussion with Pavel on v1 [1] regarding the design. =
The
> > alternatives were to have the buffers allocated and registered through =
a
> > memory region or through the registered buffers interface and have fuse
> > implement ring buffer logic internally outside of io-uring. However, be=
cause
> > the buffers need to be contiguous for DMA and some high-performance fus=
e
> > servers may need non-fuse io-uring requests to use the buffer ring dire=
ctly,
> > v3 keeps the design.
>
> I'm looking at the next-20260324 tree and trying to understand what
> happens if normal userspace (without FUSE) tries to use
> IOBL_KERNEL_MANAGED.
>
> For a buffer list with IOBL_KERNEL_MANAGED, io_ring_buffer_select()
> will write a kernel pointer into sel.kaddr, but nothing in this series
> seems to ever read out of sel.kaddr; that only happens in
> fuse_uring_select_buffer() in the FUSE series
> (https://github.com/joannekoong/linux/commit/fae19be22ab629b1301f37f2a942=
d5d84b45cc5c).
>
> Instead, looking at the reverse call graph of io_ring_buffer_select():
>
> io_ring_buffer_select
>   io_buffer_select
>     io_recvmsg
>     io_recv_buf_select
>     __io_import_rw_buffer
>
>  - io_recvmsg() passes sel.addr into iov_iter_ubuf(), which creates an IT=
ER_UBUF
>  - io_recv_buf_select() passes sel.addr into import_ubuf(), which does
> an access_ok() check before creating an ITER_UBUF
>  - __io_import_rw_buffer() also passes sel.addr into import_ubuf()
>
> I think that means io_recv_buf_select() and __io_import_rw_buffer()
> will first access the union through the wrong member, then fail on
> access_ok().
> io_recvmsg() will create an ITER_UBUF pointing to kernel memory (which
> AFAIK isn't supposed to happen?), which I think will then cause a
> later failure when you actually try to access the iterator (because
> copy_to_user_iter() checks access_ok()).
>
> Am I missing something that prevents normal io_uring operations from
> grabbing IOBL_KERNEL_MANAGED buffers and accessing the wrong union
> member?

Hi Jann,

I am going to be submitting the changes for kernel-managed pbufring
compatibility with normal (non-fuse) io-uring requests as part of a
separate patchset. You're right that there is a functional gap right
now where trying to use kernel-managed pbuf rings fails with errors.
In those patches, an iter_kvec will be constructed for
IOBL_KERNEL_MANAGED rings instead of an iter_ubuf. I'm intending to
submit that patchset upstream in time for the 7.1 merge window before
it closes in mid-April.

Thanks,
Joanne

