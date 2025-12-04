Return-Path: <io-uring+bounces-10963-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A7E66CA54A2
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 21:26:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 784C73064CDD
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 20:26:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F0D435E539;
	Thu,  4 Dec 2025 20:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hV7dZ/Hq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FF635CBD7
	for <io-uring@vger.kernel.org>; Thu,  4 Dec 2025 20:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764878856; cv=none; b=iadXtvMNto5UYKNN1Gx5fzmkmb7NdrUAc+mnJ+pLArMyQH2iL+gbFMw/Rc60YDuwHa9qUdT/HQ12AxXG/bgIf4lPzwHkeuJGSWo3Vj7T7QtnCUDtRpAjeMzrnqh1s8H2UGMRpjEb7GptS6njhH3Y2j39fzbgP91BnrpVBjM8tig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764878856; c=relaxed/simple;
	bh=kvi7FCnVZBJHiZFCI56K+4gEMINy97n0zL3WTC+sf0U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bjBpz3OQv5j7eKHBEkhbKz/dpzb34Mm1Lt8Qm4h3XSNV9QEKiUfaA2mIIYhOseGFeoTuMuEBXYviLGPBL7k/brkK3omJHP+rasBguWObD7I1JwNfYlRRLQbSWh9aiNEND56XDXEKUYHOWVULT/wsnlveIoWb0XUZJg/0Qk4yi8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hV7dZ/Hq; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ee1fca7a16so11640001cf.3
        for <io-uring@vger.kernel.org>; Thu, 04 Dec 2025 12:07:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764878853; x=1765483653; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kvi7FCnVZBJHiZFCI56K+4gEMINy97n0zL3WTC+sf0U=;
        b=hV7dZ/HqdoLt8abmvJq5OBhsXNdbo3DNfrL4JFl74F0Tnnx++Njxz3dUlIWlaijio+
         Z6WMwTpBgm80GJwrrO+F/YYqeRuRz16s2lymRZRj8joX7KKHet4PSNgbnlOOnNdLxkSQ
         TP5I/UmD9fPwms8QV4R0ghyFcaVLaO3Ayn/ijIguef3UHZ0AkBykG38D79NUuBA8pJjb
         qD+yunC2JRf9RtMiFknWbJO1oR0yM4IDfOZD+yX6Z2lShyY7pAgfbNFEdd6OeV/0a1M3
         rGkcGXgDuNSY3XY9aEq/Qq4YFvvkqR/ukPdQGx4Oic5GHdT1T3g0/XD/DVM6eVQkyIkY
         itjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764878853; x=1765483653;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kvi7FCnVZBJHiZFCI56K+4gEMINy97n0zL3WTC+sf0U=;
        b=V7fgqKfoMSf5JVhYp0ruMhdwQZxGEpbcl2V3DUIfX0CFc16wK6DddZQLsWKs0/FkSk
         Q/7cP170UgQcb+G7wWrlkrJyev/6CcNBOYLX4bIXmRaXPn/nY5VsH1tmbHH8mhyoypKS
         0ggL+vRfDF81xblZBkiHcEViSvucL4ONeWAWpCzzPv55s8vTQJCArtB+Fbz6t+ntETAM
         tl54fadu/1wpcpakQHrvRKBjdaYHtAuFuFGq+n9N46z3gkc+K8NfMGEwMQboUZD1XIHa
         /81nY8EBG3fB+5ocADL3jratf0h9sIKN7443BWCutWXOZC34jJeCd28fgX6aTX+k9MoG
         65KA==
X-Forwarded-Encrypted: i=1; AJvYcCVkaNY7JCBGzK2qQHc57e3+fUcZsSCzweyDJehUg4fWKuP6sBDj+L9lw+tFdvhqiVctlzR4ONpDnQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxz3jIZb72YbC1SB1rP030hEiuPD9Q4UKojGidb+Pk0xpYxaHkM
	U/FZ3ZNpmSntlxN0ceUGyAZpC6uF20GbLEjKVo5trz04Lo2gE0IuNM0OcyUSLLA7WXVMeGrWvhM
	qEPKxjotZstXhKEOC+/SfryLYMWZSq58=
X-Gm-Gg: ASbGncspEoUjtANp9e9iuTr6GYsyNgaBaaq5HldJOAIugfb71DKlrR15xGKz0nATgVE
	kxJl1To66lqtqRhCM5OFQLG76fQIH7CsEEd0x4dG6Y/LjH1Q2fUZkhvyYW4hYXhtzGZe8b75eDp
	6jvHFgMp20lC7FiM4sPBWkKc95m9SqAQj7jtlHGHmaYMl3bQ0QhCAqKmG56ezkJ/O/CBmD/CSx1
	Xg9yv7LTaJoYjiMct7fdNr6cJTEg8PeXFDoeY5v4AikqZZfFizZGoFHEtwqk7/OKVML1Q==
X-Google-Smtp-Source: AGHT+IEBHkBXVSPZAh8Xy8Ci7UlUKESOBShoCazEYWOR3elyKtXi0tGoaZbnV8Zc8tjWmGcHB0hyPurNz+6Ph4fhLzs=
X-Received: by 2002:a05:622a:1b8d:b0:4ed:5f45:42c0 with SMTP id
 d75a77b69052e-4f023aad79fmr70943781cf.62.1764878853293; Thu, 04 Dec 2025
 12:07:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
 <20251203003526.2889477-8-joannelkoong@gmail.com> <CADUfDZosVLf4vGm4_kNFReaNH3wSi2RoLXwZBc6TN0Jw__s1OQ@mail.gmail.com>
 <CAJnrk1Z_UZxmppmXXQr3joGzMSdU4ycnnGt=SacQT+6DbALDmA@mail.gmail.com> <CADUfDZov3Nk81k8cvdz1ZoXrbTDJfJryHjNza3ZUJyXtfE5YgQ@mail.gmail.com>
In-Reply-To: <CADUfDZov3Nk81k8cvdz1ZoXrbTDJfJryHjNza3ZUJyXtfE5YgQ@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 4 Dec 2025 12:07:22 -0800
X-Gm-Features: AWmQ_blccX-H9e4ecrJGu4Ex3cEXJQIduCiGV8IDwXQtQCH6M9fEVphQj2NjKNo
Message-ID: <CAJnrk1ZmJ8V3MOpcEYks5i3dG431C7PmB14J7N2k22rn41ROuw@mail.gmail.com>
Subject: Re: [PATCH v1 07/30] io_uring/rsrc: add fixed buffer table pinning/unpinning
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 3, 2025 at 5:24=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Wed, Dec 3, 2025 at 2:52=E2=80=AFPM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
> >
> > On Tue, Dec 2, 2025 at 8:49=E2=80=AFPM Caleb Sander Mateos
> > <csander@purestorage.com> wrote:
> > >
> > > On Tue, Dec 2, 2025 at 4:36=E2=80=AFPM Joanne Koong <joannelkoong@gma=
il.com> wrote:
> > > >
> > > > Add kernel APIs to pin and unpin the buffer table for fixed buffers=
,
> > > > preventing userspace from unregistering or updating the fixed buffe=
rs
> > > > table while it is pinned by the kernel.
> > > >
> > > > This has two advantages:
> > > > a) Eliminating the overhead of having to fetch and construct an ite=
r for
> > > > a fixed buffer per every cmd. Instead, the caller can pin the buffe=
r
> > > > table, fetch/construct the iter once, and use that across cmds for
> > > > however long it needs to until it is ready to unpin the buffer tabl=
e.
> > > >
> > > > b) Allowing a fixed buffer lookup at any index. The buffer table mu=
st be
> > > > pinned in order to allow this, otherwise we would have to keep trac=
k of
> > > > all the nodes that have been looked up by the io_kiocb so that we c=
an
> > > > properly adjust the refcounts for those nodes. Ensuring that the bu=
ffer
> > > > table must first be pinned before being able to fetch a buffer at a=
ny
> > > > index makes things logistically a lot neater.
> > >
> > > Why is it necessary to pin the entire buffer table rather than
> > > specific entries? That's the purpose of the existing io_rsrc_node ref=
s
> > > field.
> >
> > How would this work with userspace buffer unregistration (which works
> > at the table level)? If buffer unregistration should still succeed
> > then fuse would need a way to be notified that the buffer has been
> > unregistered since the buffer belongs to userspace (eg it would be
> > wrong if fuse continues using it even though fuse retains a refcount
> > on it). If buffer unregistration should fail, then we would need to
> > track this pinned state inside the node instead of relying just on the
> > refs field, as buffers can be unregistered even if there are in-flight
> > refs (eg we would need to differentiate the ref being from a pin vs
> > from not a pin), and I think this would make unregistration more
> > cumbersome as well (eg we would have to iterate through all the
> > entries looking to see if any are pinned before iterating through them
> > again to do the actual unregistration).
>
> Not sure I would say buffer unregistration operates on the table as a
> whole. Each registered buffer node is unregistered individually and

I'm looking at the liburing interface for it and I'm only seeing
io_uring_unregister_buffers() / IORING_UNREGISTER_BUFFERS which works
on the entire table, so I'm wondering how that interface would work if
pinning/unpinning was at the entry level?

> stores its own reference count. io_put_rsrc_node() will be called on
> each buffer node in the table. However, io_put_rsrc_node() just
> removes the one reference from the buffer node. If there are other
> references on the buffer node (such as an inflight io_uring request
> using it), io_free_rsrc_node() won't be called to free the buffer node
> until all those references are dropped too. So fuse holding a
> reference on the buffer node would allow it to be unregistered, but
> prevent it from being freed until fuse dropped its reference.
> I'm not sure I understand the problem with fuse continuing to hold
> onto a registered buffer node after userspace has unregistered it from
> the buffer table. (It looks like the buffer node in question is the

For fuse, it holds the reference to the buffer for the lifetime of the
connection, which could be a very long time. I'm not seeing how we
could let userspace succeed in unregistering with fuse continuing to
hold that reference, since as I understand it conceptually,
unregistering the buffer should give ownership of the buffer
completely back to userspace.

> one at FUSE_URING_FIXED_HEADERS_INDEX?) Wouldn't pinning the buffer

Yep you have that right, the buffer node in question is the one at
FUSE_URING_FIXED_HEADERS_INDEX which is where all the headers for
requests are placed.

> table present similar issues? How would userspace get fuse to drop its

I don't think pinning the buffer table has a similar issue because we
disallow unregistration if it's pinned.

> pin if it wants to modify the buffer registrations? I would imagine

For the fuse use case, the server never really modifies its buffer
registrations as it sets up everything before initiating the
connection. But if it wanted to in the future, the server could send a
fuse notification to the kernel to unpin the buf table.

> the code path that calls io_uring_buf_table_unpin() currently could
> instead call into io_put_rsrc_node() (maybe by completing an io_uring
> request that has imported the registered buffer) to release its
> reference on the buffer node. For ublk, userspace can request to stop
> a ublk device or the kernel will do so automatically if userspace
> drops its file handle (e.g. if the process exits), which will release
> any io_uring resources the ublk device is using.

Fuse has something similar where the server can abort the connection,
and that will release the pin / other io uring resources.

Thanks,
Joanne

>
> >
> > >
> > > >

