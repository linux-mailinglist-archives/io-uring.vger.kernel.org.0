Return-Path: <io-uring+bounces-9677-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C5F7B502B6
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 18:33:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 33E544E0375
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 16:32:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2B642DCF4D;
	Tue,  9 Sep 2025 16:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="TKbJWLwd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4C3272E7B
	for <io-uring@vger.kernel.org>; Tue,  9 Sep 2025 16:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757435573; cv=none; b=Db5i3pbDkeW/bmQMflJPFfDWgso6M2LKIJUZrVxcYSYrvpaIEgPgSkbqQlOmaBmQnMv8eFfl8/+t6LGbnDMaumiqoRQo76FnP0VNFhTSw4f+ojUVeSX0PVbJ8Jxkg6bJVr+2jE0i8j4ZxXWjxtC/e5YVYIEOi/Ac8+G9nbxFYdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757435573; c=relaxed/simple;
	bh=Xr5CK1P1XT9HWsAVQ36j0qp4IoJaLvfcdx8ETfqbHlU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ItLxfdCmLSBCl3CtxI77hjoBTr1qLnZFZJcaKrTSIud62dGYhTPiVlG1ebXVbxgifq0ImCr6TrDZjHOwEP/mwYhP/UStQuQ6++jke9XQl1v8O0Tp0Sa20qpKZKw51+tQQdohpA8ZB2SSR7dHfL5EtODPARQflUJh/LMILZV9waw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=TKbJWLwd; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-77240e78306so443280b3a.0
        for <io-uring@vger.kernel.org>; Tue, 09 Sep 2025 09:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1757435571; x=1758040371; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RQ1B1pGE+pkvFzuUpWI8zKRsZeCqGkc9CUgwCxkxLiw=;
        b=TKbJWLwdnlPJdeZ203S9yixdFsuGDCG3jj+I6DcsZRWsxSZ76ymjEC80PrCXSURifh
         nZctyuPSoQs6Y3sf2xaBA/kmbxFJKwwNsa1dwJVn/xw7ifNdhogM+eB1iHvB+z+SpQH/
         DbYiyEc2rkUlMCrbtcnTGbRNmwn7cfaxGlkuZCxkhHMy+MfzOw9xIuOrPIaX+YzmZedF
         T9QeKSShAwg7nmNGGNcgFEM6rkl0lOZDwCMtlOOjsdCvf7Y5680sx/WTKRMM3fnvPy93
         qmMcTjDkktL+ZdyPOjBO1k5kQYFIKM2BlgeEE1YC1BXJLJHHI1X3ctUKhl8mbPW0oUh4
         nkXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757435571; x=1758040371;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RQ1B1pGE+pkvFzuUpWI8zKRsZeCqGkc9CUgwCxkxLiw=;
        b=KeHmslxtS9/NLIYQAARu/Vt8RRoJeLCkktNqkupI82k0oI0IXEAFeI/EF4eKXc44KK
         Dk3zl/Fuf8meXNP6FuYERI5S6xTYFnr0kNJMJV4YUG5QFeXk03G+0/fZ9MvHv77K2N6C
         3J1ilDi9i+Nks3djDQbLW+YjfCMxa+cFFraDY3lTQiL7h1PE7wlB2c70F5nM7tzLDTls
         hpUYHP/lE3K3LdbnIxu3WTQjV76w987w+TsTkjt+ZwdIpKn/Cg7TG8O9Zbolcc+aRTGB
         ItD94oK27Lc0rpcUT1xxgWhjO8q3xM5+uJ0YxEHV9Zv0ArJinwdJ59ZJkWiScDdgg9ir
         kfIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTa4v3oN6agW2DZkLZ4rbUyTzSslCIC3x3rTCqRPMSLBB1Uy6YSHfsDo7fdTUX+PIOUE5TW1/GJg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyOFbnR/VUKoYb2GKGXNDKBZOTX8YZKPBij1m3BwDAUZKlHSGgj
	AgVhTsaPsJ65+HsoO8cynnP20kb87jUqBySBwQdTK5rEvYyW00Iygxw2xyv/XsrvfzXliKDAd30
	vZFpdf4q8T0SS2aYtEq4D3JC2o24Iz/A2N+3hAwa2hQ==
X-Gm-Gg: ASbGncs15t7rI7B/1zcwkux3SGg6Ga9jwxOwQOtMywFEiXi22F2aBrBzs+YNnNwNKnV
	GMK92vcIp7t9Go40MImzVur2kI8YELiRzSCczApu1RvTRRbwMf9GD2KUeu1eQge1hHED4yrLWWp
	bLTn97F/fCgZb+2LfNpEW9WLsHARRiHebbTail5khk+D0vlz5nf5f/rhUe8gbI0LXHTIilIiNk6
	XaynWHeiG7jnl4fz48=
X-Google-Smtp-Source: AGHT+IFOHORFtmcadaEdXDJCDsNUJ5Id6tlwIgyVdiSH9C3Gd4752s8eNPUfJ8V45hIoag4PqOtmYWXrNrLFAMvFs9k=
X-Received: by 2002:a17:903:184:b0:253:a668:b638 with SMTP id
 d9443c01a7336-253a668b76fmr80815055ad.2.1757435570778; Tue, 09 Sep 2025
 09:32:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250822125555.8620-1-sidong.yang@furiosa.ai> <20250822125555.8620-3-sidong.yang@furiosa.ai>
 <CADUfDZpsePAbEON_90frzrPCPBt-a=1sW2Q=i8BGS=+tZhudFA@mail.gmail.com>
 <aLbFiChBnTNLBAyV@sidongui-MacBookPro.local> <CADUfDZpPvj3R7kzWC9bQVV0iuCBOnKsNUFn=B3ivf7De5wCB8g@mail.gmail.com>
 <aLxFAamglufhUvq0@sidongui-MacBookPro.local> <CADUfDZruwQyOcAeOXkXMLX+_HgOBeYdHUmgnJdT5pGQEmXt9+g@mail.gmail.com>
 <aMA8_MuU0V-_ja5O@sidongui-MacBookPro.local>
In-Reply-To: <aMA8_MuU0V-_ja5O@sidongui-MacBookPro.local>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 9 Sep 2025 09:32:37 -0700
X-Gm-Features: Ac12FXzQvujRvBk7BrdPEq7wsRrBxTuBzt1uAroiqCSXJie2MYSfaQTK2iLj2rc
Message-ID: <CADUfDZppdnM2QAeX37OmZsXqd7sO7KvyLnNPUYOgLpWMb+FpoQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/5] io_uring/cmd: zero-init pdu in
 io_uring_cmd_prep() to avoid UB
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: Jens Axboe <axboe@kernel.dk>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Benno Lossin <lossin@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 9, 2025 at 7:43=E2=80=AFAM Sidong Yang <sidong.yang@furiosa.ai>=
 wrote:
>
> On Mon, Sep 08, 2025 at 12:45:58PM -0700, Caleb Sander Mateos wrote:
> > On Sat, Sep 6, 2025 at 7:28=E2=80=AFAM Sidong Yang <sidong.yang@furiosa=
.ai> wrote:
> > >
> > > On Tue, Sep 02, 2025 at 08:31:00AM -0700, Caleb Sander Mateos wrote:
> > > > On Tue, Sep 2, 2025 at 3:23=E2=80=AFAM Sidong Yang <sidong.yang@fur=
iosa.ai> wrote:
> > > > >
> > > > > On Mon, Sep 01, 2025 at 05:34:28PM -0700, Caleb Sander Mateos wro=
te:
> > > > > > On Fri, Aug 22, 2025 at 5:56=E2=80=AFAM Sidong Yang <sidong.yan=
g@furiosa.ai> wrote:
> > > > > > >
> > > > > > > The pdu field in io_uring_cmd may contain stale data when a r=
equest
> > > > > > > object is recycled from the slab cache. Accessing uninitializ=
ed or
> > > > > > > garbage memory can lead to undefined behavior in users of the=
 pdu.
> > > > > > >
> > > > > > > Ensure the pdu buffer is cleared during io_uring_cmd_prep() s=
o that
> > > > > > > each command starts from a well-defined state. This avoids ex=
posing
> > > > > > > uninitialized memory and prevents potential misinterpretation=
 of data
> > > > > > > from previous requests.
> > > > > > >
> > > > > > > No functional change is intended other than guaranteeing that=
 pdu is
> > > > > > > always zero-initialized before use.
> > > > > > >
> > > > > > > Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> > > > > > > ---
> > > > > > >  io_uring/uring_cmd.c | 1 +
> > > > > > >  1 file changed, 1 insertion(+)
> > > > > > >
> > > > > > > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > > > > > > index 053bac89b6c0..2492525d4e43 100644
> > > > > > > --- a/io_uring/uring_cmd.c
> > > > > > > +++ b/io_uring/uring_cmd.c
> > > > > > > @@ -203,6 +203,7 @@ int io_uring_cmd_prep(struct io_kiocb *re=
q, const struct io_uring_sqe *sqe)
> > > > > > >         if (!ac)
> > > > > > >                 return -ENOMEM;
> > > > > > >         ioucmd->sqe =3D sqe;
> > > > > > > +       memset(&ioucmd->pdu, 0, sizeof(ioucmd->pdu));
> > > > > >
> > > > > > Adding this overhead to every existing uring_cmd() implementati=
on is
> > > > > > unfortunate. Could we instead track the initialized/uninitializ=
ed
> > > > > > state by using different types on the Rust side? The io_uring_c=
md
> > > > > > could start as an IoUringCmd, where the PDU field is MaybeUnini=
t,
> > > > > > write_pdu<T>() could return a new IoUringCmdPdu<T> that guarant=
ees the
> > > > > > PDU has been initialized.
> > > > >
> > > > > I've found a flag IORING_URING_CMD_REISSUE that we could initiali=
ze
> > > > > the pdu. In uring_cmd callback, we can fill zero when it's not re=
issued.
> > > > > But I don't know that we could call T::default() in miscdevice. I=
f we
> > > > > make IoUringCmdPdu<T>, MiscDevice also should be MiscDevice<T>.
> > > > >
> > > > > How about assign a byte in pdu for checking initialized? In uring=
_cmd(),
> > > > > We could set a byte flag that it's not initialized. And we could =
return
> > > > > error that it's not initialized in read_pdu().
> > > >
> > > > Could we do the zero-initialization (or T::default()) in
> > > > MiscdeviceVTable::uring_cmd() if the IORING_URING_CMD_REISSUE flag
> > > > isn't set (i.e. on the initial issue)? That way, we avoid any
> > > > performance penalty for the existing C uring_cmd() implementations.
> > > > I'm not quite sure what you mean by "assign a byte in pdu for check=
ing
> > > > initialized".
> > >
> > > Sure, we could fill zero when it's the first time uring_cmd called wi=
th
> > > checking the flag. I would remove this commit for next version. I als=
o
> > > suggests that we would provide the method that read_pdu() and write_p=
du().
> > > In read_pdu() I want to check write_pdu() is called before. So along =
the
> > > 20 bytes for pdu, maybe we could use a bytes for the flag that pdu is
> > > initialized?
> >
> > Not sure what you mean about "20 bytes for pdu".
> > It seems like it would be preferable to enforce that write_pdu() has
> > been called before read_pdu() using the Rust type system instead of a
> > runtime check. I was thinking a signature like fn write_pdu(cmd:
> > IoUringCmd, value: T) -> IoUringCmdPdu<T>. Do you feel there's a
> > reason that wouldn't work and a runtime check would be necessary?
>
> I didn't think about make write_pdu() to return IoUringCmdPdu<T> before.
> I think it's good way to pdu is safe without adding a new generic param f=
or
> MiscDevice. write_pdu() would return IoUringCmdPdu<T> and it could call
> IoUringCmdPdu<T>::pdu(&mut self) -> &mut T safely maybe.

Yes, that's what I was thinking.

>
> >
> > >
> > > But maybe I would introduce a new struct that has Pin<&mut IoUringCmd=
> and
> > > issue_flags. How about some additional field for pdu is initialized l=
ike below?
> > >
> > > struct IoUringCmdArgs {
> > >   ioucmd: Pin<&mut IoUringCmd>,
> > >   issue_flags: u32,
> > >   pdu_initialized: bool,
> > > }
> >
> > One other thing I realized is that issue_flags should come from the
> > *current* context rather than the context the uring_cmd() callback was
> > called in. For example, if io_uring_cmd_done() is called from task
> > work context, issue_flags should match the issue_flags passed to the
> > io_uring_cmd_tw_t callback, not the issue_flags originally passed to
> > the uring_cmd() callback. So it probably makes more sense to decouple
> > issue_flags from the (owned) IoUringCmd. I think you could pass it by
> > reference (&IssueFlags) or with a phantom reference lifetime
> > (IssueFlags<'_>) to the Rust uring_cmd() and task work callbacks to
> > ensure it can't be used after those callbacks have returned.
>
> I have had no idea about task work context. I agree with you that
> it would be better to separate issue_flags from IoUringCmd. So,
> IoUringCmdArgs would have a only field Pin<&mut IoUringCmd>?

"Task work" is a mechanism io_uring uses to queue work to run on the
thread that submitted an io_uring operation. It's basically a
per-thread atomic queue of callbacks that the thread will process
whenever it returns from the kernel to userspace (after a syscall or
an interrupt). This is the context where asynchronous uring_cmd
completions are generally processed (see
io_uring_cmd_complete_in_task() and io_uring_cmd_do_in_task_lazy()). I
can't speak to the history of why io_uring uses task work, but my
guess would be that it provides a safe context to acquire the
io_ring_ctx uring_lock mutex (e.g. nvme_uring_cmd_end_io() can be
called from an interrupt handler, so it's not allowed to take a
mutex). Processing all the task work at once also provides natural
opportunities for batching.
Yes, we probably don't need to bundle anything else with the
IoUringCmd after all. As I mentioned earlier, I don't think Pin<&mut
IoUringCmd> will work for uring_cmds that complete asynchronously, as
they will need to outlive the uring_cmd() call. So uring_cmd() needs
to transfer ownership of the struct io_uring_cmd.

Best,
Caleb

