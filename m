Return-Path: <io-uring+bounces-12626-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MOtVNAtnsGloigIAu9opvQ
	(envelope-from <io-uring+bounces-12626-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 19:46:35 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 95CD7256A1C
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 19:46:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 20216304EECE
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 18:45:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20DD73D88F6;
	Tue, 10 Mar 2026 18:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hxsOLcqt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2668E3D813B
	for <io-uring@vger.kernel.org>; Tue, 10 Mar 2026 18:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773168175; cv=pass; b=nTisjOcGYGNB0XyMVhaCbVgKogoRTnGofmmKQtsduDrNxBIHjQ0UG4zCYxAl/cI8ZagskG3N4QfJ94GkeKZblFygIZCKkp/Pst0JyrgJM2R/ccTN30I51KfBS+Nt8dUTvyZLVZJJF34KhOsrtuqWczTPzguecAhwazLaNjnaq7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773168175; c=relaxed/simple;
	bh=L4EbhfEMf03O6+RTWJV20RPmyvPimJNh4oJi3nHf7J0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FtGHCsp9y6iWvAqock49/ussbnCShVYcOdSbxjIb/jGKZGP2ii5x/nXmbzXoL4yMvIJ2wLvnFLosmudjkpWqgLz21h54nwhFrnPRRWBiwJiEvWh1p0fbHjJzpbYsUl7yEab1SgN2pOJXS5t0Za+z5n1FLMqOb1opRYxcKC+4qBA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hxsOLcqt; arc=pass smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b942b36de08so36200466b.1
        for <io-uring@vger.kernel.org>; Tue, 10 Mar 2026 11:42:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773168170; cv=none;
        d=google.com; s=arc-20240605;
        b=OJ3RhCtjxXCogFbHGnVj6biFi1vgDSzCOAgUb9kED1XuAFbDvVQBA6qRbC1ltxEthd
         MJ3TJW1DB0iZ05P4kEre4ANZGRFk7rk3DzWayOzd3i0ydJGZMKxhEB9JLLOLol4YQQP9
         wK/7qMegAC9u5PWf/jA9M9JOaeXwzZHhAyYCgEsX1NJsOfuDZnKJz7EhBvtSW3yAAK/9
         EtJV6nzsf008+toW0hMMSmQYWAHNXcvwjaAL5tOUSuZ5eecgSMe22tobg8nWnV/bQMBZ
         3+RtDL2G3ack3EH+lJmLDrWADXnhUxDpgAwnRgqnMg0Wws1d34ffUALMUgH+Jvzu4QKD
         ATyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lQNkMBSGJ2hgvrh7Pd/zMKJv6xTaiwI+JSE9cgtfEr8=;
        fh=uVf5YuuU/F+B1YHA8skKqx1mQhSL53yKZ8/hH98wKNM=;
        b=QpLInuZHuDe8MiTYmyQI7NpAa3IBLmHcZF/0PbzanwSVQV016OGQv0XXcw9CeZxIg9
         0YXu5crLwoVNPhiwbs0Y6ZT9Um9x5rr6aKKoGRHp86nGVWv0T3i2oYgfpeui5QHqgI2X
         QIPV4+tq9tmv78jheo27eD83tPv5G5q+xN9Nhj9dKBbuARNgRbakRblyBkXx1W8fDoy0
         NECGecs8K97fK5yKgHvGPsAPtQA0HEcwcGvzvqEUPxsxUHVdA8derWs/fPaMRnODsBlu
         sDrwW7pk4kENuVvTcHNsms+xum3hiwrImLIAZsyxoe9J/kVnLgQDIQ8taa8t7N9kST2e
         cr/Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773168170; x=1773772970; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lQNkMBSGJ2hgvrh7Pd/zMKJv6xTaiwI+JSE9cgtfEr8=;
        b=hxsOLcqtqfV+NH35FHb3cnaMPBM5znVAzJpiRvFLJrBTUu51wZHHbld/JiRj511YhJ
         fRcYKJOOzjJtLlPg9GXaGSmekg1aB/oY1WtCWiYOL6/vV7xkAOnbdNj600fYFA9FPJQb
         iTHYBM2vJlEIdBbLv0gtYlfVXy/McjDrHF5sTXKNJSXSF7nK1IY/9bT4id7AAQGSajsQ
         bZQRtkMbv81CwxX650L7ZlRBL+bcGdjISTVf0lbQCns4WiE5ebLqcgoSiKbw9uri8enP
         BUmoI+tLlUsbDgzdO3fojjU1tqriAPr9BpVR2B42LVDpSe9ip5LsRAyQTui7c2bC0774
         xJrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773168170; x=1773772970;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lQNkMBSGJ2hgvrh7Pd/zMKJv6xTaiwI+JSE9cgtfEr8=;
        b=DHArsGsaEauymjubBC96SSTv4DVvgVQIubbzz6Aac7/UIa6PGiNQa+8DitGNHo1RzR
         A/Y7/aLAtJkpQLzHTzBoBpvCxdgTSq/qAE1dgQuPcuS2RjWwagm5IIXrtZB6RK2a5eGk
         fsGVk86jfC3x8XRT+7ObzCYEsAkxVgScXBr1gibeqzt6PPjpq04V5PdixcELxuOawb29
         BOVhi+94FloUds1km9pt3J7kGQk+3pI8bill6MctnQzTNOrKbXLL80/TwzqMb0iGWrOi
         v+m+iOfuFPV/2tnXIhmMPp6CSzyOyeYj0bl1GNcowexCsSKj3okP2Spo0jt2Zq8Othn5
         gmCA==
X-Gm-Message-State: AOJu0YyFwBtxOaL2YCdlETs38ISWfwmEMdSKe3k3ZtP+7z75YrdxJLDN
	ofl2uAbJ9Tmf8T61+Ck3VuEofwB+4LGMeibZ33ctBdS+z848xehJmNtsbl5oifSzIefSmjUlrdO
	eW7DvMlyXSeSdzLm3d8Z3klKzxHa47dkffm02UAk=
X-Gm-Gg: ATEYQzwgvbD2gmItDVP6OSQ1uWeHCMlfpYgxIj0mMZjc8QDpO5pvj6AT51omA83xiuT
	iohgl1gThQRI142ltao5qq4jxEYl7/6KHJ+39FzE2bOovbfdtSMTqiXnD/qMCACUJ/WMtW3KVqB
	q8mjsGa+whhwxlWU3LlK4nLjbH/gPdR3MWkC/XdQpx+3KooV/W7RGwzORc0tSya8phonQSsoJEr
	LhGXpoyGwt2GfihDNRWwkeM+wExrVYT8VEOsaqd1eoNC+TQDGwM11z9Ej785+P16eD+GKyY3cpq
	W22E9w==
X-Received: by 2002:a17:907:d0b:b0:b94:82e:55e7 with SMTP id
 a640c23a62f3a-b9711a31e48mr273843166b.25.1773168169784; Tue, 10 Mar 2026
 11:42:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260310154933.2500971-1-daniele.di.proietto@gmail.com> <c29a339d-67c5-4e8a-a1c9-2388aa9f28d5@kernel.dk>
In-Reply-To: <c29a339d-67c5-4e8a-a1c9-2388aa9f28d5@kernel.dk>
From: Daniele Di Proietto <daniele.di.proietto@gmail.com>
Date: Tue, 10 Mar 2026 18:42:38 +0000
X-Gm-Features: AaiRm50yQdQQDu2iJBdFN5TsIvODfvB3eGjATcSMaDrtlfYryix5-1kJ4Mp5Ddg
Message-ID: <CAExiqTKBFeyxE4nwSxd3muOuZkP5YDSoweYwns4wb64w8efPVQ@mail.gmail.com>
Subject: Re: [PATCH] io_uring: Add IORING_OP_DUP
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 95CD7256A1C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12626-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[danielediproietto@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Mar 10, 2026 at 4:24=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 3/10/26 9:49 AM, Daniele Di Proietto wrote:
> > The new operation is like dup3(). The source file can be a regular file
> > descriptor or a direct descriptor. The destination is a regular file
> > descriptor.
> >
> > The direct descriptor variant is useful to move a descriptor to an fd
> > and close the existing fd with a single acquisition of the `struct
> > files_struct` `file_lock`. Combined with IORING_OP_ACCEPT or
> > IORING_OP_OPENAT2 with direct descriptors, it can reduce lock contentio=
n
> > for multithreaded applications.
>
> Overall comment - how does this interact with direct descriptors? Feels
> like this should support both, rather than just normal file descriptors.

As implemented, the operation supports:
1. src: direct, dst: normal (this is the use case I mostly care about)
2. src: normal, dst: normal ()

I can extend it to also support
3. src: direct, dst: direct
4, src: normal, dst: direct

I can use IOSQE_FIXED_FILE to pick the source and I guess I can use a
bit in dup_flags (something like IORING_DUP_DIRECT) to decide whether
the destination is a direct descriptor or normal.

Does that make sense?

>
> > @@ -446,3 +452,46 @@ int io_pipe(struct io_kiocb *req, unsigned int iss=
ue_flags)
> >               fput(files[1]);
> >       return ret;
> >  }
> > +
> > +int io_dup_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> > +{
> > +     unsigned int flags;
> > +     struct io_dup *id;
> > +     int new_fd;
> > +
> > +     if (sqe->off || sqe->addr || sqe->len || sqe->buf_index || sqe->a=
ddr3)
> > +             return -EINVAL;
> > +
> > +     flags =3D READ_ONCE(sqe->dup_flags);
> > +     if (flags & ~IORING_DUP_NO_CLOEXEC)
> > +             return -EINVAL;
> > +
> > +     new_fd =3D READ_ONCE(sqe->dup_new_fd);
> > +     if (new_fd < 0)
> > +             return -EBADF;
>
> Is this necessary? Yes it'll help fail early, but do we care about that?

You're right, we don't really care about that. I'll remove it.

>
> > +     /* ensure the task's creds are used when installing/receiving fds=
 */
> > +     if (req->flags & REQ_F_CREDS)
> > +             return -EPERM;
>
> Not sure that's sane. Let's say you mark this request as IOSQE_ASYNC,
> then it'd fail even if REQ_F_CREDS would then be set, and creds would
> match the original task.

I'm not sure either, I mostly added this because it's in
io_install_fixed_fd_prep, I assume the same rationale applies here,
right?

>
>
> > +
> > +     id =3D io_kiocb_to_cmd(req, struct io_dup);
> > +     id->o_flags =3D O_CLOEXEC;
> > +     if (flags & IORING_DUP_NO_CLOEXEC)
> > +             id->o_flags =3D 0;
> > +     id->new_fd =3D new_fd;
> > +
> > +     return 0;
> > +}
> > +
> > +int io_dup(struct io_kiocb *req, unsigned int issue_flags)
> > +{
> > +     struct io_dup *id;
> > +     int ret;
> > +
> > +     id =3D io_kiocb_to_cmd(req, struct io_dup);
> > +     ret =3D replace_fd(id->new_fd, id->file, id->o_flags);
> > +     if (ret < 0)
> > +             req_set_fail(req);
> > +     io_req_set_res(req, ret, 0);
> > +     return IOU_COMPLETE;
>
> And like Keith said here, we might need to punt it to io-wq if the file
> has a ->flush() method.

Makes sense, thanks.

Thanks for the review!

>
> --
> Jens Axboe

