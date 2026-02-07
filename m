Return-Path: <io-uring+bounces-12088-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sBOcIpyOhmlTOwQAu9opvQ
	(envelope-from <io-uring+bounces-12088-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 07 Feb 2026 02:00:12 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E37F8104635
	for <lists+io-uring@lfdr.de>; Sat, 07 Feb 2026 02:00:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7D6423018285
	for <lists+io-uring@lfdr.de>; Sat,  7 Feb 2026 01:00:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5E8623AB88;
	Sat,  7 Feb 2026 01:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FVfxEwv+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991E319E97B
	for <io-uring@vger.kernel.org>; Sat,  7 Feb 2026 01:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770426009; cv=pass; b=H9CoArwWmTy2cm0pCqhpUpJVwFcRefB9jVfPvt6qHpbm3v16eVLjg5aP2C/6z0GeLDzV248vM7r/S1gAbU4ZL866FslpjQbpvwtH3wbmmSfV+jS8qxXw4cbzGfXb5W1Na2a9r1/bbzpegrHo3ZcsURGppj+5ZLvOlA0QGyn5ekw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770426009; c=relaxed/simple;
	bh=GOl+yzQfvJ81Mb6nX6vbSK9P6JDhNobzBh6AGciU+3w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d0itJW6yA1pCGZEQc2dhMMI6oVeUcXp/cPcqIY6o5KxmzrEcDB1QoSdR0cwPvV7VnJgAEZn9mHYT0THDuxfeHJipG5fn0JJZmlYwUBe5h8gruasN1N9U/l/A6rIq5Ml/Z0HwEhTrujQDZkJhStyuzwVk2UUGuMNCeWPybj/OUSo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FVfxEwv+; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5036d7d14easo15668781cf.1
        for <io-uring@vger.kernel.org>; Fri, 06 Feb 2026 17:00:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770426008; cv=none;
        d=google.com; s=arc-20240605;
        b=HfCumhFs51eIOmyfFwyOJJu+yR3cLvgu+QwLWRXesU6Lq4pWN/mKgP1fF9TGiiP6ws
         JCFjlDIcHnSgrBmFNPSa+sIlJFOFXxaAjl5Duf+ZmiYgz3YohHr/oD/dOBLsUHd0Z9r9
         JyzCtGiMVk3qD6KfPtAORwVp3Du+8OVGIGVWko1R6kHvkxGFMqcyzMKQHaXdJ0qtIhHl
         Kfd3I+b1R2ikz/fCvQUCkdefBIBrirofsZi9eHQ0lElYPxddl0GG6Z55Eie+unNLz+R1
         Kpat6qyfUdLaiDNd5xail1iiN+GTr9B8rwBXadh7XcqjxT/eayfQ9e0Uupr3SxO9xclB
         idmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=c1LvKaDQsF5i0nG7aNyREL0Jo4Gh027d3YlThpa0ie0=;
        fh=lSbIekN/dmtbRZKIO8zGv/WExRTbvdtjC4hY5wp2SG8=;
        b=ICI6GtO3iLLHAre6S60yUAOzL/gXZKX3OkM5D+Rf6FadH0ycdPRDVuCxsmxQ8V8AbW
         553PVtt2F+YL29PYGWSvz6qywixOvufLzvEUeVTc/ZIGr4ZSgvVn0FHlGpBigcGHS3JN
         uLWd+NrUsRA/K4MERJzJ5LounAN9hL/iU2GN6DLKro9h3cbzD5Wnep1SlfbGaMCW+zD9
         eKwoR2eD4kbxnwlAUG60F3nssvXEf4La5qSa8umvUDvNJGWgwUT1BVaEIk77lsqJSvZb
         xxTuuYj8jLz+msqlkW47859MsG6a8FJAKUTTYjWS4ZGU+cZkQIqv1OcRgOJTtNfxNRIj
         z3BQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770426008; x=1771030808; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c1LvKaDQsF5i0nG7aNyREL0Jo4Gh027d3YlThpa0ie0=;
        b=FVfxEwv+oLG5Q37djnIvLjV4T45XqNvD41n7lOmHmlgddF5EyUJMszYKDBJvpiFBni
         s84CKsKciJpVCQ1qE8l5Ju9xXKpC5F8pQjeoG9YkEz3JxR5D9tr5C5AevNJxucP8e7ed
         7dbCoQrmMuRkjkMUQGr9vVt6qt0y3EbhlUvKYOFmweuY/l4gXR9y2I7I4Nf7ivLTng1K
         S7Bp4ZKkET+9G7rZ6tFAbbduGI2y98TVsREQDb9yFrCX6AQrAKS7fRjYJd6tz+b3gyeu
         FpOQEUMVOWJQJ9Y49KgSYblUIm3RHw+eS0AI+T9wdVp6LxcaxqGsO3MK4FirqpZJ/N8S
         5CMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770426008; x=1771030808;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c1LvKaDQsF5i0nG7aNyREL0Jo4Gh027d3YlThpa0ie0=;
        b=pqvw986ZtfE99AzRerYR7rj6Ix2dgmPIPnkNousOeWHwzNZRXRe3JgU+ZAfQvBQcn3
         KEF4zZLiegboEp0wC94Mj97qlK3TtzuxhO6GrZqWFvi9YWOdyyJsmQ5Zg/CK4WijUI5D
         SedxJJcRwqcoFK2GgTr+7oqGXILmAIo0U/my954RT6os0nN/tKEYvO4D5F01A0A4h6eM
         J1VNgqBDe+mB3dFPTtnFdxvt6W2NQoGkRYtiLL50IvixvidI1HQP6+Iia/vNEg33qroI
         IcW3XAwG5lhNCwtIUR7h8Lr4pkhvLA4RposK9OTwPQzyak55aIRPCgY3ELRzQlrDHr3u
         wKNg==
X-Forwarded-Encrypted: i=1; AJvYcCU8cvF4G8M2ZePJMRhYz4q2h7xoD3u3NF3LTqOF+6k2alzmPwVnjFN4J3I6stZVoVfagxQ3+YKFHA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwGGB5jgejHjNsbiF9GeDh6yoY1P3TEbjOoAtFrlXX10GplesMU
	NziUGfNiYdF88d1pWAxBMalws+8Yjw3BICQPIV9HS1euaBoa1n5rqkFC+5lNDCUoGSikS7W5nSd
	Vh+wx9frDW1jb8xym5G082k11ZxwIu64=
X-Gm-Gg: AZuq6aIgl8Ymc/Ub6yo1NIrbFvJthz/Xw05v975o7aarh8XMTxBHfcEplkfjRWHNmw3
	poLBRlytsIkb75xRtlFXsc5xSV7IQvZqqw4pvoHNlebfUItIzUZ6s2SMdXU6DeZjFzNi91p8QPU
	pf6RIMgcJDlQFOx0P/DFy0Pl00F885uvZXSS01CtC5KwBGEgm3KtD2nLZaEAVxTVEHwPQ88wGBL
	358cZ3z7XESEyxdtaPXCaFKZ7p8w0XU+GqGdXsg7f1kB/GsxG5jui2r1LXn7ZkI6aIfyg==
X-Received: by 2002:a05:622a:11c4:b0:506:1edb:2cdc with SMTP id
 d75a77b69052e-5063985d90cmr74178351cf.6.1770426008435; Fri, 06 Feb 2026
 17:00:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
 <20260116233044.1532965-4-joannelkoong@gmail.com> <aYWeErf9bgQJANRF@infradead.org>
In-Reply-To: <aYWeErf9bgQJANRF@infradead.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 6 Feb 2026 16:59:57 -0800
X-Gm-Features: AZwV_QjA22_fkxfGyhpbiz3lWbfC4zoePSjfcxG5s9BV6ISHh6yLvJ0zx7a8uAM
Message-ID: <CAJnrk1Z7PDBEEOmwABCPisvX+-zFGvVvw118vBGUq3J4n0Kgag@mail.gmail.com>
Subject: Re: [PATCH v4 03/25] io_uring/kbuf: add support for kernel-managed
 buffer rings
To: Christoph Hellwig <hch@infradead.org>
Cc: axboe@kernel.dk, miklos@szeredi.hu, bschubert@ddn.com, 
	csander@purestorage.com, krisman@suse.de, io-uring@vger.kernel.org, 
	asml.silence@gmail.com, xiaobing.li@samsung.com, safinaskar@gmail.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12088-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,szeredi.hu,ddn.com,purestorage.com,suse.de,vger.kernel.org,gmail.com,samsung.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[11];
	FREEMAIL_FROM(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid,infradead.org:email]
X-Rspamd-Queue-Id: E37F8104635
X-Rspamd-Action: no action

On Thu, Feb 5, 2026 at 11:53=E2=80=AFPM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Fri, Jan 16, 2026 at 03:30:22PM -0800, Joanne Koong wrote:
> > The implementation follows the same pattern as pbuf ring registration,
> > reusing the validation and buffer list allocation helpers introduced in
> > earlier refactoring. The IOBL_KERNEL_MANAGED flag marks buffer lists as
> > kernel-managed for appropriate handling in the I/O path.
>
> Do you have a man page or other documentation for the uapi somewhere?

No, but I will tidy up the liburing side changes I have for this and
add the documentation to liburing/man.
>
> > +int io_register_kmbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
> > +{
> > +     struct io_uring_buf_reg reg;
> > +     struct io_buffer_list *bl;
> > +     int ret;
> > +
> > +     lockdep_assert_held(&ctx->uring_lock);
> > +
> > +     if (copy_from_user(&reg, arg, sizeof(reg)))
> > +             return -EFAULT;
> > +
> > +     ret =3D io_validate_buf_reg(&reg, 0);
> > +     if (ret)
> > +             return ret;
>
> Probably more a comment for patch 1, but wouldn't it make sense
> to combine copy from user and vaidation into a single helper?

I'll rename this function to io_copy_and_validate_buf_reg() and move
the copying into that.

>
> > +     ret =3D io_alloc_new_buffer_list(ctx, &reg, &bl);
> > +     if (ret)
> > +             return ret;
>
> Return the buffer list from io_alloc_new_buffer_list or an ERR_PTR
> to simplify this a bit?

Sounds good, I'll make this change.

>
> > +     ret =3D io_setup_kmbuf_ring(ctx, bl, &reg);
> > +     if (ret) {
> > +             kfree(bl);
> > +             return ret;
> > +     }
> > +
> > +     bl->flags |=3D IOBL_KERNEL_MANAGED;
>
> Should io_setup_kmbuf_ring set IOBL_KERNEL_MANAGED as it is the one
> creating the kernel managed buffers?

That's a good point, I'll move this line into io_setup_kmbuf_ring()
(and do the same for moving pbuf's IOBL_INC flag setting to
io_setup_pbuf_ring()).
>
> > +{
> > +     gfp_t gfp =3D GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN;
>
> Isn't this really a GFP_USER allocation and should account towardas the
> callers memory cgroup limit?

I think __GFP_ACCOUNT is what accounts the memory towards the caller's
mem cgroup limit and GFP_KERNEL_ACCOUNT sets that whereas GFP_USER
doesn't. GFP_USER sets __GFP_HARDWALL though which seems like it's
also useful, but elsewhere in the io uring code, GFP_KERNEL_ACCOUNT is
used for other userspace-facing allocations (eg pbufring's buffer
metadata). But maybe this should be GFP_USER | __GFP_ACCOUNT.

>
> > +     if (WARN_ON_ONCE(mr->pages || mr->ptr || mr->nr_pages))
> > +             return -EFAULT;
> > +
> > +     if (WARN_ON_ONCE(!nr_bufs || !buf_size))
> > +             return -EINVAL;
> > +
> > +     nr_pages =3D ((size_t)buf_size * nr_bufs) >> PAGE_SHIFT;
> > +     if (nr_pages > UINT_MAX)
> > +             return -E2BIG;
>
> This looks overflow prone, and probably should use check_mul_overflow.

Okay yeah I think you're right that the (size_t) casting only protects
against overflow on 64-bit systems but could still overflow 32-bit
systems. I'll change this to use check_mul_overflow.

Thanks,
Joanne
>

