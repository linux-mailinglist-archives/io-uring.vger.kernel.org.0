Return-Path: <io-uring+bounces-9862-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 65077B928F3
	for <lists+io-uring@lfdr.de>; Mon, 22 Sep 2025 20:09:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19DAD2A6F7B
	for <lists+io-uring@lfdr.de>; Mon, 22 Sep 2025 18:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20B0731770F;
	Mon, 22 Sep 2025 18:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="F6j5jjRm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F277C2DD60E
	for <io-uring@vger.kernel.org>; Mon, 22 Sep 2025 18:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758564592; cv=none; b=IZNyJwsuOpL8c1ggIfLspkHl13TY58rANDleGs2u+TG7FkSqRb4JKsKyGlpgj0tEThKeo1r0dS9X6JLphyaua3phBfRapBB9mNUBcoPDg8oHqKliLEBx70PY4ze6uBHE9Zi/T64dOxuXDv2IGkcGVKxBZcKiibReayINpH/v3zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758564592; c=relaxed/simple;
	bh=ikGo23UXT52fyqCqqKczOtS5pYsO/F+ZDJfBM0EiP7Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=do9k612k8R37XZULd7szEPOgj7Hst2ldoe54DGz8paIwaP/ijiVSGEdupoue0HYLgseQQ+QxPpn1GQgretikapUs5sdGyVDeZyPI3hs/NNLm+0x0DdjDfMz2RWXC9h7haQszNdcwtPftEBz4ewoDW8mYgE/inRSRQ+UsKiKeTCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=F6j5jjRm; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-32ecc60c9e6so391757a91.0
        for <io-uring@vger.kernel.org>; Mon, 22 Sep 2025 11:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1758564589; x=1759169389; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LHWOHNoonAkc7Bu2eu/keJgFCNZ8MjJWtgk79xBJxjY=;
        b=F6j5jjRm2eKpkmTgozgxcVb8yFfEm2t2ZNOD7ojK82ehVCZVGPr3eELOLRhaRYvSD9
         KtXbUZsrKlqTy8l1xyNkFlv+ZuYA7z8svALGZ9avc4MxxpggkUxiznMZQ3nVZIWq2Y4U
         VY05fQsk0tQaaxArLl7W9DQKltXTbLUNaF+ypl9yi3yJheLuwTsxRKPmxxhb8XApUdfQ
         KvAJK0Jwn5RJkFsOIgx8BC6qQgRNSxiSE12w3Npkz9QaLKZDJF8y8DlZmWOv2oSiOh3a
         o5RBRgP2oUEnLH0HNJRebh0/UJ2+Cs8un6njzcK+7KGktis/v6L4QCkcLzCj6Dc5EeQG
         PcOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758564589; x=1759169389;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LHWOHNoonAkc7Bu2eu/keJgFCNZ8MjJWtgk79xBJxjY=;
        b=rjLrWR6X4GtxF4ka9Pk9lKoziFgWF3wc1LvBg0mzsn6RdNl7c5B6tZWrjNg5LJYi9Y
         KBOOyO6T3D4WAy/2JPsY32mIEWMkXgZyq2akI9rdVDun635+KqQERwPhmNepZzONgTfH
         DUvWfrp3mW+iPIAVqs3Tj6ReRzccckEpqrfeAlePVuqRQWZjIze26sp2hi3MAHB0q26X
         HEPSH/PQLjUPxce5YpPbDjyZUKEgGMFNynIhpzRKQln9StlCmDUAHU6wTwaIRwN1pg9W
         5aFY2M1UiPue+DkzEEMJAn+W6cTJYBmcVznWh5FDHDdr5B2r8LXebses3gziSRFXIQdg
         Hg0g==
X-Forwarded-Encrypted: i=1; AJvYcCUPeukSyer9VKDhadOOc2Y3dQUnLd4iqbVqcrc7eOP/VMnrPSd+CJAgF8nVaQZ/Ns4A67FKM4h+Ag==@vger.kernel.org
X-Gm-Message-State: AOJu0YwUCr4+h7jc5/yFJrEeIS7Si+9y08gUYGlxAH/SNagGLdMJgDUJ
	esKdETfdB/B0bJWoep0pYh+ezlqalsZMNgG32n0JMUGTf3xhUiap+UzzOmR7x9tMrcwTn8h5Wky
	ScZYHknEcrxmXFCOXIjzPxorUaa8sb24xVKcNCABiPw==
X-Gm-Gg: ASbGncttPmpcw8GOvNrr2ZLgCbt8Fvc9rVQYJK8Om2orcbpL4J3vjtaW45QZBzD88+p
	OManIkqh+/dUoNmjZCpNmaTnOUznB4zwfdn4t6q7pQI4lsuX/dhHhJHl1h99KhcpdNyPOK4/8rt
	bhyorfxAG7gpTBRvuMXDra8QJR0RQx8eimHIx7QU929m27lc1V6qje9Eei/LBujwANPt60mNg9G
	phsIeV/K36RSoCu24wIM/xTFpDte9gtdI0gRrrf86u5poO6Phs=
X-Google-Smtp-Source: AGHT+IFNMTUh7ZkzIOMLg4r6PD0ixHIMphfbUzlf46DNy5lqedP+FcRxVhmucdxi8Sz//x8P4qguzZL22TZRRcq4JUE=
X-Received: by 2002:a17:90b:1d8a:b0:32e:1213:1ec1 with SMTP id
 98e67ed59e1d1-330982458afmr8756491a91.3.1758564588958; Mon, 22 Sep 2025
 11:09:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aLbFiChBnTNLBAyV@sidongui-MacBookPro.local> <CADUfDZpPvj3R7kzWC9bQVV0iuCBOnKsNUFn=B3ivf7De5wCB8g@mail.gmail.com>
 <aLxFAamglufhUvq0@sidongui-MacBookPro.local> <CADUfDZruwQyOcAeOXkXMLX+_HgOBeYdHUmgnJdT5pGQEmXt9+g@mail.gmail.com>
 <aMA8_MuU0V-_ja5O@sidongui-MacBookPro.local> <CADUfDZppdnM2QAeX37OmZsXqd7sO7KvyLnNPUYOgLpWMb+FpoQ@mail.gmail.com>
 <aMRNSBHDM4nkewHO@sidongui-MacBookPro.local> <CADUfDZrHse9nDxfd0UDkxOEmVRg-b=KDEUZ9Hz08eojXJvgtng@mail.gmail.com>
 <aMVmm1Ydt4iOfxu5@sidongui-MacBookPro.local> <CADUfDZrULTJj99Bik3OhUEorMSnL5cWgJ-VqoHePZ6WWDoukTQ@mail.gmail.com>
 <aMrMDd4kjxim0CkA@sidongui-MacBookPro.local>
In-Reply-To: <aMrMDd4kjxim0CkA@sidongui-MacBookPro.local>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 22 Sep 2025 11:09:37 -0700
X-Gm-Features: AS18NWDeqJjYdY44RI-SgmdWrVXuWWfC58XsrzHKvCwljR8rDS3z-VVA8yS43NM
Message-ID: <CADUfDZpqP--N4OWx+h4yzWL_hghBwhhCKs4==1VnV4oz5F-brg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/5] io_uring/cmd: zero-init pdu in
 io_uring_cmd_prep() to avoid UB
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: Jens Axboe <axboe@kernel.dk>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Benno Lossin <lossin@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025 at 7:56=E2=80=AFAM Sidong Yang <sidong.yang@furiosa.ai=
> wrote:
>
> On Mon, Sep 15, 2025 at 09:54:50AM -0700, Caleb Sander Mateos wrote:
> > On Sat, Sep 13, 2025 at 5:42=E2=80=AFAM Sidong Yang <sidong.yang@furios=
a.ai> wrote:
> > >
> > > On Fri, Sep 12, 2025 at 10:56:31AM -0700, Caleb Sander Mateos wrote:
> > > > On Fri, Sep 12, 2025 at 9:42=E2=80=AFAM Sidong Yang <sidong.yang@fu=
riosa.ai> wrote:
> > > > >
> > > > > On Tue, Sep 09, 2025 at 09:32:37AM -0700, Caleb Sander Mateos wro=
te:
> > > > > > On Tue, Sep 9, 2025 at 7:43=E2=80=AFAM Sidong Yang <sidong.yang=
@furiosa.ai> wrote:
> > > > > > >
> > > > > > > On Mon, Sep 08, 2025 at 12:45:58PM -0700, Caleb Sander Mateos=
 wrote:
> > > > > > > > On Sat, Sep 6, 2025 at 7:28=E2=80=AFAM Sidong Yang <sidong.=
yang@furiosa.ai> wrote:
> > > > > > > > >
> > > > > > > > > On Tue, Sep 02, 2025 at 08:31:00AM -0700, Caleb Sander Ma=
teos wrote:
> > > > > > > > > > On Tue, Sep 2, 2025 at 3:23=E2=80=AFAM Sidong Yang <sid=
ong.yang@furiosa.ai> wrote:
> > > > > > > > > > >
> > > > > > > > > > > On Mon, Sep 01, 2025 at 05:34:28PM -0700, Caleb Sande=
r Mateos wrote:
> > > > > > > > > > > > On Fri, Aug 22, 2025 at 5:56=E2=80=AFAM Sidong Yang=
 <sidong.yang@furiosa.ai> wrote:
> > > > > > > > > > > > >
> > > > > > > > > > > > > The pdu field in io_uring_cmd may contain stale d=
ata when a request
> > > > > > > > > > > > > object is recycled from the slab cache. Accessing=
 uninitialized or
> > > > > > > > > > > > > garbage memory can lead to undefined behavior in =
users of the pdu.
> > > > > > > > > > > > >
> > > > > > > > > > > > > Ensure the pdu buffer is cleared during io_uring_=
cmd_prep() so that
> > > > > > > > > > > > > each command starts from a well-defined state. Th=
is avoids exposing
> > > > > > > > > > > > > uninitialized memory and prevents potential misin=
terpretation of data
> > > > > > > > > > > > > from previous requests.
> > > > > > > > > > > > >
> > > > > > > > > > > > > No functional change is intended other than guara=
nteeing that pdu is
> > > > > > > > > > > > > always zero-initialized before use.
> > > > > > > > > > > > >
> > > > > > > > > > > > > Signed-off-by: Sidong Yang <sidong.yang@furiosa.a=
i>
> > > > > > > > > > > > > ---
> > > > > > > > > > > > >  io_uring/uring_cmd.c | 1 +
> > > > > > > > > > > > >  1 file changed, 1 insertion(+)
> > > > > > > > > > > > >
> > > > > > > > > > > > > diff --git a/io_uring/uring_cmd.c b/io_uring/urin=
g_cmd.c
> > > > > > > > > > > > > index 053bac89b6c0..2492525d4e43 100644
> > > > > > > > > > > > > --- a/io_uring/uring_cmd.c
> > > > > > > > > > > > > +++ b/io_uring/uring_cmd.c
> > > > > > > > > > > > > @@ -203,6 +203,7 @@ int io_uring_cmd_prep(struct =
io_kiocb *req, const struct io_uring_sqe *sqe)
> > > > > > > > > > > > >         if (!ac)
> > > > > > > > > > > > >                 return -ENOMEM;
> > > > > > > > > > > > >         ioucmd->sqe =3D sqe;
> > > > > > > > > > > > > +       memset(&ioucmd->pdu, 0, sizeof(ioucmd->pd=
u));
> > > > > > > > > > > >
> > > > > > > > > > > > Adding this overhead to every existing uring_cmd() =
implementation is
> > > > > > > > > > > > unfortunate. Could we instead track the initialized=
/uninitialized
> > > > > > > > > > > > state by using different types on the Rust side? Th=
e io_uring_cmd
> > > > > > > > > > > > could start as an IoUringCmd, where the PDU field i=
s MaybeUninit,
> > > > > > > > > > > > write_pdu<T>() could return a new IoUringCmdPdu<T> =
that guarantees the
> > > > > > > > > > > > PDU has been initialized.
> > > > > > > > > > >
> > > > > > > > > > > I've found a flag IORING_URING_CMD_REISSUE that we co=
uld initialize
> > > > > > > > > > > the pdu. In uring_cmd callback, we can fill zero when=
 it's not reissued.
> > > > > > > > > > > But I don't know that we could call T::default() in m=
iscdevice. If we
> > > > > > > > > > > make IoUringCmdPdu<T>, MiscDevice also should be Misc=
Device<T>.
> > > > > > > > > > >
> > > > > > > > > > > How about assign a byte in pdu for checking initializ=
ed? In uring_cmd(),
> > > > > > > > > > > We could set a byte flag that it's not initialized. A=
nd we could return
> > > > > > > > > > > error that it's not initialized in read_pdu().
> > > > > > > > > >
> > > > > > > > > > Could we do the zero-initialization (or T::default()) i=
n
> > > > > > > > > > MiscdeviceVTable::uring_cmd() if the IORING_URING_CMD_R=
EISSUE flag
> > > > > > > > > > isn't set (i.e. on the initial issue)? That way, we avo=
id any
> > > > > > > > > > performance penalty for the existing C uring_cmd() impl=
ementations.
> > > > > > > > > > I'm not quite sure what you mean by "assign a byte in p=
du for checking
> > > > > > > > > > initialized".
> > > > > > > > >
> > > > > > > > > Sure, we could fill zero when it's the first time uring_c=
md called with
> > > > > > > > > checking the flag. I would remove this commit for next ve=
rsion. I also
> > > > > > > > > suggests that we would provide the method that read_pdu()=
 and write_pdu().
> > > > > > > > > In read_pdu() I want to check write_pdu() is called befor=
e. So along the
> > > > > > > > > 20 bytes for pdu, maybe we could use a bytes for the flag=
 that pdu is
> > > > > > > > > initialized?
> > > > > > > >
> > > > > > > > Not sure what you mean about "20 bytes for pdu".
> > > > > > > > It seems like it would be preferable to enforce that write_=
pdu() has
> > > > > > > > been called before read_pdu() using the Rust type system in=
stead of a
> > > > > > > > runtime check. I was thinking a signature like fn write_pdu=
(cmd:
> > > > > > > > IoUringCmd, value: T) -> IoUringCmdPdu<T>. Do you feel ther=
e's a
> > > > > > > > reason that wouldn't work and a runtime check would be nece=
ssary?
> > > > > > >
> > > > > > > I didn't think about make write_pdu() to return IoUringCmdPdu=
<T> before.
> > > > > > > I think it's good way to pdu is safe without adding a new gen=
eric param for
> > > > > > > MiscDevice. write_pdu() would return IoUringCmdPdu<T> and it =
could call
> > > > > > > IoUringCmdPdu<T>::pdu(&mut self) -> &mut T safely maybe.
> > > > > >
> > > > > > Yes, that's what I was thinking.
> > > > >
> > > > > Good, I'll change api in this way. Thanks!
> > > > >
> > > > > >
> > > > > > >
> > > > > > > >
> > > > > > > > >
> > > > > > > > > But maybe I would introduce a new struct that has Pin<&mu=
t IoUringCmd> and
> > > > > > > > > issue_flags. How about some additional field for pdu is i=
nitialized like below?
> > > > > > > > >
> > > > > > > > > struct IoUringCmdArgs {
> > > > > > > > >   ioucmd: Pin<&mut IoUringCmd>,
> > > > > > > > >   issue_flags: u32,
> > > > > > > > >   pdu_initialized: bool,
> > > > > > > > > }
> > > > > > > >
> > > > > > > > One other thing I realized is that issue_flags should come =
from the
> > > > > > > > *current* context rather than the context the uring_cmd() c=
allback was
> > > > > > > > called in. For example, if io_uring_cmd_done() is called fr=
om task
> > > > > > > > work context, issue_flags should match the issue_flags pass=
ed to the
> > > > > > > > io_uring_cmd_tw_t callback, not the issue_flags originally =
passed to
> > > > > > > > the uring_cmd() callback. So it probably makes more sense t=
o decouple
> > > > > > > > issue_flags from the (owned) IoUringCmd. I think you could =
pass it by
> > > > > > > > reference (&IssueFlags) or with a phantom reference lifetim=
e
> > > > > > > > (IssueFlags<'_>) to the Rust uring_cmd() and task work call=
backs to
> > > > > > > > ensure it can't be used after those callbacks have returned=
.
> > > > > > >
> > > > > > > I have had no idea about task work context. I agree with you =
that
> > > > > > > it would be better to separate issue_flags from IoUringCmd. S=
o,
> > > > > > > IoUringCmdArgs would have a only field Pin<&mut IoUringCmd>?
> > > > > >
> > > > > > "Task work" is a mechanism io_uring uses to queue work to run o=
n the
> > > > > > thread that submitted an io_uring operation. It's basically a
> > > > > > per-thread atomic queue of callbacks that the thread will proce=
ss
> > > > > > whenever it returns from the kernel to userspace (after a sysca=
ll or
> > > > > > an interrupt). This is the context where asynchronous uring_cmd
> > > > > > completions are generally processed (see
> > > > > > io_uring_cmd_complete_in_task() and io_uring_cmd_do_in_task_laz=
y()). I
> > > > > > can't speak to the history of why io_uring uses task work, but =
my
> > > > > > guess would be that it provides a safe context to acquire the
> > > > > > io_ring_ctx uring_lock mutex (e.g. nvme_uring_cmd_end_io() can =
be
> > > > > > called from an interrupt handler, so it's not allowed to take a
> > > > > > mutex). Processing all the task work at once also provides natu=
ral
> > > > > > opportunities for batching.
> > > > >
> > > > > Thanks, I've checked io_uring_cmd_complete_in_task() that it rece=
ives
> > > > > callback that has issue_flags different with io_uring_cmd(). I'll=
 try to add
> > > > > a api that wrapping io_uring_cmd_complete_in_task() for next vers=
ion.
> > > > >
> > > > > >
> > > > > > Yes, we probably don't need to bundle anything else with the
> > > > > > IoUringCmd after all. As I mentioned earlier, I don't think Pin=
<&mut
> > > > > > IoUringCmd> will work for uring_cmds that complete asynchronous=
ly, as
> > > > > > they will need to outlive the uring_cmd() call. So uring_cmd() =
needs
> > > > > > to transfer ownership of the struct io_uring_cmd.
> > > > >
> > > > > I can't think that how to take ownership of struct io_uring_cmd. =
The
> > > > > struct allocated with io_alloc_req() and should be freed with io_=
free_req().
> > > > > If taking ownership means having pointer of struct io_uring_cmd, =
I think
> > > > > it's no difference with current version. Also could it be called =
with
> > > > > mem::forget() if it has ownership?
> > > >
> > > > I don't mean ownership of the io_uring_cmd allocation; that's the
> > > > responsibility of the io_uring layer. But once the io_uring_cmd is
> > > > handed to the uring_cmd() implementation, it belongs to that layer
> > > > until it completes the command back to io_uring. Maybe a better way=
 to
> > > > describe it would be as ownership of the "executing io_uring_cmd". =
The
> > > > problem with Pin<&mut IoUringCmd> is that it is a borrowed referenc=
e
> > > > to the io_uring_cmd, so it can't outlive the uring_cmd() callback.
> > > > Yes, it's possible to leak the io_uring_cmd by never calling
> > > > io_uring_cmd_done() to return it to the io_uring layer.
> > >
> > > Thanks, I understood that IoUringCmd could be outlive uring_cmd callb=
ack.
> > > But it's sad that it could be leaked without any unsafe code.
> >
> > Safety in Rust doesn't require destructors to run, which means any
> > resource can be safely leaked
> > (https://faultlore.com/blah/everyone-poops/ has some historical
> > background on why Rust decided leaks had to be considered safe).
> > Leaking an io_uring_cmd is analogous to leaking a Box, both are
> > perfectly possible in safe Rust.
>
> Thanks for the reference. If driver just drops `IoUringCmd` without takin=
g,
> the request wouldn't be completed until io-uring instance deinitialized.
> I understood that we cannot handle this.
>
> >
> > >
> > > >
> > > > I would imagine something like this:
> > > >
> > > > #[derive(Clone, Copy)]
> > > > struct IssueFlags<'a>(c_uint, PhantomData<&'a ()>);
> > > >
> > > > // Indicates ownership of the io_uring_cmd between uring_cmd() and
> > > > io_uring_cmd_done()
> > > > struct IoUringCmd(NonNull<bindings::io_uring_cmd>);
> > > >
> > > > impl IoUringCmd {
> > > >         // ...
> > > >
> > > >         fn done(self, ret: i32, res2: u64, issue_flags: IssueFlags<=
'_>) {
> > > >                 let cmd =3D self.0.as_ptr();
> > > >                 let issue_flags =3D issue_flags.0;
> > > >                 unsafe {
> > > >                         bindings::io_uring_cmd_done(cmd, ret, res2,=
 issue_flags)
> > > >                 }
> > > >         }
> > > > }
> > > >
> > > > // Can choose whether to complete the command synchronously or asyn=
chronously.
> > > > // If take_async() is called, IoUringCmd::done() needs to be called=
 to
> > > > complete the command.
> > > > // If take_async() isn't called, the command is completed synchrono=
usly
> > > > // with the return value from MiscDevice::uring_cmd().
> > > > struct UringCmdInput<'a>(&mut Option<NonNull<bindings::io_uring_cmd=
>>);
> > >
> > > Thanks for a detailed example!
> > >
> > > But rather than this, We could introduce new return type that has a c=
allback that
> > > user could take IoUringCmd instead of returning -EIOCBQUEUED.
> >
> > I'm not following what you're suggesting, maybe a code sample would hel=
p?
>
> maybe like below...
>
> #[vtable]
> pub trait MiscDevice: Sized {
>     /// ...
>
>     /// If user returns `EIOCBQUEUED`, this function would be called for
>     /// users who want to take `IoUringCmdAsync`. It could call `done()` =
for complete
>     /// request.
>     fn uring_cmd_async_prep(
>           device: <Self::Ptr as ForeignOwnable>::Borrowed<'_>,
>           io_uring_cmd_async: IoUringCmdAsync);
>     /// ...
> }
>
> impl<T: MiscDevice> MiscdeviceVTable<T> {
>     // ...
>     unsafe extern "C" fn uring_cmd(
>           ioucmd: *mut bindings::io_uring_cmd,
>           issue_flags: ffi::c_uint,
>       ) -> c_int {
>           // ...
>           let result =3D T::uring_cmd(device, ioucmd, issue_flags);
>
>           if let Err(EIOCBQUEUED) =3D result {
>               T::uring_cmd_async_prep(device, ioucmd.to_async());
>           }

I see. Yes, this could work, but I worry separating the implementation
into 2 calls makes it difficult to pass state between them. If
T::uring_cmd() can determine whether the command will complete
synchronously or asynchronously just by inspecting the
io_uring_cmd/device, it may be a convenient interface. But if
T::uring_cmd() performs a bunch of work before deciding the command
should go async, it may be a pain to pass those computed values to
T::uring_cmd_async_prep().

>
>           from_result(|| result)
>       }
> }
> >
> > >
> > > But I prefer that we provide just one type IoUringCmd without UringCm=
dInput.
> > > Although UringCmdInput, user could call done() in uring_cmd callback =
and
> > > it makes confusion that whether task_async() called and returning -EI=
OCBQUEUED
> > > is mismatched that returns -EINVAL. We don't need to make it complex.
> >
> > Sure, if you only want to support asynchronous io_uring_cmd
> > completions, than you can just pass IoUringCmd to
> > MiscDevice::uring_cmd() and require it to call IoUringCmd::done() to
> > complete the command. There's a small performance overhead to that
> > over just returning the result from the uring_cmd() callback for
> > synchronous completions (and it's more verbose), but I think that
> > would be fine for an initial implementation.
>
> I appreciate for your understanding. I think it would be good to have jus=
t one
> simple struct `IoUringCmd`. I'll make next version patch soon.

Yeah, I think it will probably be easiest for an initial
implementation to always transfer ownership of the io_uring_cmd to
MiscDevice::uring_cmd() and requiring it to call IoUringCmd::done().
The synchronous case could be optimized in the future, but that's not
the primary io_uring_cmd use case.

Best,
Caleb

