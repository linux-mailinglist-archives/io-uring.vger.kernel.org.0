Return-Path: <io-uring+bounces-9793-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7636DB5829C
	for <lists+io-uring@lfdr.de>; Mon, 15 Sep 2025 18:55:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63AA93A3F7D
	for <lists+io-uring@lfdr.de>; Mon, 15 Sep 2025 16:55:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FF07284684;
	Mon, 15 Sep 2025 16:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Y61lWOO3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C9B27D77A
	for <io-uring@vger.kernel.org>; Mon, 15 Sep 2025 16:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757955306; cv=none; b=a5gu/phPIXV9Yunec+lHVNXfAgpBFrsGtJXRVNI3Okqa7Dl/8/dl5f58yGfB7BoOgf9NFllRtZRZwUxJ9BrADpZfLYUAwHWJRjF3aqF1rKZyYTf4RN9r4xXf4GgahBaIGPzNrlL7UFeTkTnOkWqunOi638eCMxIQUMkg1qzw+Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757955306; c=relaxed/simple;
	bh=J59w39RBpPTW2BK9vj32fr6jhKBI3HhYaa7/Gd2qRbk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BJACs7FI3Ap7fxDkkNp5NlPvyWzm4m/J2CjHP0TUO9ikfZpHRTvElxjbvbRwE0xuNfxaVbuh8J6833ceMr+1peCm9AUjm4tKtXDAq7u4rWOfbc0aSlKq/TQApiEP6TzRyL1JNIjFT+p9VJcpX+TyZLoggsdE5c6PluH03bfi+FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Y61lWOO3; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-76e2eb5c9c9so360391b3a.3
        for <io-uring@vger.kernel.org>; Mon, 15 Sep 2025 09:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1757955303; x=1758560103; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/YjN8qvwhiHU8tintgshBZavETAbRta16kugFoyEbLI=;
        b=Y61lWOO3lhK+3FJ9HLZSIcmUOe1j3nbhO7Ks2yOseRtyABQ8rZibtPTfWWulhn4ORE
         WUV0YZ62J1cFI1rZcvLpTOmcgQRAjqDkvD76Kf5drMT2M+aMu1rpGoPPQd5A/dPL94nZ
         m/Q0oATaMYHk9qYnQTX5E9aZVtxlBadd1O4oW0wP9pgu19uWacMi5chBwwBsQa/qA7pm
         7N37WrbJNSoTfOM/0Gnm9pLc2vvBFFFfBIp6mY9cXDuNYOza78ZHRda+jZzAnlcHORTN
         bXAKsKdomJS3xH3CJc6TCs8wVZOwJe66HUxiu2z96ACHQJvxSV0duB/yCkY8XwVnFbQ8
         DuIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757955303; x=1758560103;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/YjN8qvwhiHU8tintgshBZavETAbRta16kugFoyEbLI=;
        b=bcxa4Rvcm7UTet9X/PvWFEbfnbfH5jZmJKsJX5fgVI/hblVFoPY7BFALcI6Te/rRWf
         waIJQYdCOPy8bINhAUzpxcQeH7zVa/j+z9DcLgqOeRvDNTwTwxHvVsU/JaokpGVqWCJm
         pAJlduhVYIWB1LjGzFc1fA33S7fGHHzCuQ+4D8U4dyBjCDRG5A+fI6GFSwUYTlR72F+T
         XBADi1V0p8a6I/Lyx4+D6GnQtmKJVhB8opChyCzXGP3NP0VSg/25B0xZBXvtLzjOGaM6
         95MYgm+jiEVoquJZB/tzUOIMTmzY3QBkyEsHUJTqCAR9LCG2twG1M6Y1kc+qILFMCzH+
         iCbA==
X-Forwarded-Encrypted: i=1; AJvYcCVPTslcova2e6G+1+Q1cs75byMzPGYmSLNy+QQ09cVQYBpqshHmcEWNCCAXGdY8sguUVKFK4I02Ng==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxlv0IoKDQ5fAjMflwohxa3zxFEwuQLunCBotuZNgLRGXwG/hHC
	q9vIkisrTZ7996qhE9CpHxLyKSQISSVBkpkVQ+yOV5+SyL3rTnw/MM02rrB5wzvEaqcNaDbJUA4
	QtcnZAfrufkwUAiKjArya/NerUleBxPy9pf7LqaDKcQ==
X-Gm-Gg: ASbGncscpOB8eQopO+wxef/skK3d38XHb0xoDjEOaUf1mM8gxqI4JnFlXPchC6tlubs
	ZdxAHaf56AMwebYEIwCi3rPBd20f0GoYcQq3vsdCmc+aINpeWlim4Du4g+H3Ak0Wy7WnuUht5Z4
	aat+0LwsHMSAE6kFnMce3oV1BCUHkTltDxUNe4FzHK9Ce+QwZCnNwp+Z2bLpdQLMVbtCyr9EAID
	8Eugm5xAPUlxEMxJkY9fE0RyDt3ZTHH48ryDTjR6iIy72eorxE=
X-Google-Smtp-Source: AGHT+IHMAwA6cEL7MUPdfl7PV4ovMCbIEezc+HuF9md65upZSvgRXkEpjLiGdatB0iTxFeYFQgmYrxcSkTbFlYOukTU=
X-Received: by 2002:a17:902:ec85:b0:267:bd8d:1b6 with SMTP id
 d9443c01a7336-267bd8d09c0mr3771115ad.6.1757955302499; Mon, 15 Sep 2025
 09:55:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250822125555.8620-3-sidong.yang@furiosa.ai> <CADUfDZpsePAbEON_90frzrPCPBt-a=1sW2Q=i8BGS=+tZhudFA@mail.gmail.com>
 <aLbFiChBnTNLBAyV@sidongui-MacBookPro.local> <CADUfDZpPvj3R7kzWC9bQVV0iuCBOnKsNUFn=B3ivf7De5wCB8g@mail.gmail.com>
 <aLxFAamglufhUvq0@sidongui-MacBookPro.local> <CADUfDZruwQyOcAeOXkXMLX+_HgOBeYdHUmgnJdT5pGQEmXt9+g@mail.gmail.com>
 <aMA8_MuU0V-_ja5O@sidongui-MacBookPro.local> <CADUfDZppdnM2QAeX37OmZsXqd7sO7KvyLnNPUYOgLpWMb+FpoQ@mail.gmail.com>
 <aMRNSBHDM4nkewHO@sidongui-MacBookPro.local> <CADUfDZrHse9nDxfd0UDkxOEmVRg-b=KDEUZ9Hz08eojXJvgtng@mail.gmail.com>
 <aMVmm1Ydt4iOfxu5@sidongui-MacBookPro.local>
In-Reply-To: <aMVmm1Ydt4iOfxu5@sidongui-MacBookPro.local>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 15 Sep 2025 09:54:50 -0700
X-Gm-Features: Ac12FXwmoh35IByx-sSqLbzTFKdFSm8mcEsw5Ger2WP3BbuSlGRbjwsXJOYIDJU
Message-ID: <CADUfDZrULTJj99Bik3OhUEorMSnL5cWgJ-VqoHePZ6WWDoukTQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/5] io_uring/cmd: zero-init pdu in
 io_uring_cmd_prep() to avoid UB
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: Jens Axboe <axboe@kernel.dk>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Benno Lossin <lossin@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 13, 2025 at 5:42=E2=80=AFAM Sidong Yang <sidong.yang@furiosa.ai=
> wrote:
>
> On Fri, Sep 12, 2025 at 10:56:31AM -0700, Caleb Sander Mateos wrote:
> > On Fri, Sep 12, 2025 at 9:42=E2=80=AFAM Sidong Yang <sidong.yang@furios=
a.ai> wrote:
> > >
> > > On Tue, Sep 09, 2025 at 09:32:37AM -0700, Caleb Sander Mateos wrote:
> > > > On Tue, Sep 9, 2025 at 7:43=E2=80=AFAM Sidong Yang <sidong.yang@fur=
iosa.ai> wrote:
> > > > >
> > > > > On Mon, Sep 08, 2025 at 12:45:58PM -0700, Caleb Sander Mateos wro=
te:
> > > > > > On Sat, Sep 6, 2025 at 7:28=E2=80=AFAM Sidong Yang <sidong.yang=
@furiosa.ai> wrote:
> > > > > > >
> > > > > > > On Tue, Sep 02, 2025 at 08:31:00AM -0700, Caleb Sander Mateos=
 wrote:
> > > > > > > > On Tue, Sep 2, 2025 at 3:23=E2=80=AFAM Sidong Yang <sidong.=
yang@furiosa.ai> wrote:
> > > > > > > > >
> > > > > > > > > On Mon, Sep 01, 2025 at 05:34:28PM -0700, Caleb Sander Ma=
teos wrote:
> > > > > > > > > > On Fri, Aug 22, 2025 at 5:56=E2=80=AFAM Sidong Yang <si=
dong.yang@furiosa.ai> wrote:
> > > > > > > > > > >
> > > > > > > > > > > The pdu field in io_uring_cmd may contain stale data =
when a request
> > > > > > > > > > > object is recycled from the slab cache. Accessing uni=
nitialized or
> > > > > > > > > > > garbage memory can lead to undefined behavior in user=
s of the pdu.
> > > > > > > > > > >
> > > > > > > > > > > Ensure the pdu buffer is cleared during io_uring_cmd_=
prep() so that
> > > > > > > > > > > each command starts from a well-defined state. This a=
voids exposing
> > > > > > > > > > > uninitialized memory and prevents potential misinterp=
retation of data
> > > > > > > > > > > from previous requests.
> > > > > > > > > > >
> > > > > > > > > > > No functional change is intended other than guarantee=
ing that pdu is
> > > > > > > > > > > always zero-initialized before use.
> > > > > > > > > > >
> > > > > > > > > > > Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> > > > > > > > > > > ---
> > > > > > > > > > >  io_uring/uring_cmd.c | 1 +
> > > > > > > > > > >  1 file changed, 1 insertion(+)
> > > > > > > > > > >
> > > > > > > > > > > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cm=
d.c
> > > > > > > > > > > index 053bac89b6c0..2492525d4e43 100644
> > > > > > > > > > > --- a/io_uring/uring_cmd.c
> > > > > > > > > > > +++ b/io_uring/uring_cmd.c
> > > > > > > > > > > @@ -203,6 +203,7 @@ int io_uring_cmd_prep(struct io_k=
iocb *req, const struct io_uring_sqe *sqe)
> > > > > > > > > > >         if (!ac)
> > > > > > > > > > >                 return -ENOMEM;
> > > > > > > > > > >         ioucmd->sqe =3D sqe;
> > > > > > > > > > > +       memset(&ioucmd->pdu, 0, sizeof(ioucmd->pdu));
> > > > > > > > > >
> > > > > > > > > > Adding this overhead to every existing uring_cmd() impl=
ementation is
> > > > > > > > > > unfortunate. Could we instead track the initialized/uni=
nitialized
> > > > > > > > > > state by using different types on the Rust side? The io=
_uring_cmd
> > > > > > > > > > could start as an IoUringCmd, where the PDU field is Ma=
ybeUninit,
> > > > > > > > > > write_pdu<T>() could return a new IoUringCmdPdu<T> that=
 guarantees the
> > > > > > > > > > PDU has been initialized.
> > > > > > > > >
> > > > > > > > > I've found a flag IORING_URING_CMD_REISSUE that we could =
initialize
> > > > > > > > > the pdu. In uring_cmd callback, we can fill zero when it'=
s not reissued.
> > > > > > > > > But I don't know that we could call T::default() in miscd=
evice. If we
> > > > > > > > > make IoUringCmdPdu<T>, MiscDevice also should be MiscDevi=
ce<T>.
> > > > > > > > >
> > > > > > > > > How about assign a byte in pdu for checking initialized? =
In uring_cmd(),
> > > > > > > > > We could set a byte flag that it's not initialized. And w=
e could return
> > > > > > > > > error that it's not initialized in read_pdu().
> > > > > > > >
> > > > > > > > Could we do the zero-initialization (or T::default()) in
> > > > > > > > MiscdeviceVTable::uring_cmd() if the IORING_URING_CMD_REISS=
UE flag
> > > > > > > > isn't set (i.e. on the initial issue)? That way, we avoid a=
ny
> > > > > > > > performance penalty for the existing C uring_cmd() implemen=
tations.
> > > > > > > > I'm not quite sure what you mean by "assign a byte in pdu f=
or checking
> > > > > > > > initialized".
> > > > > > >
> > > > > > > Sure, we could fill zero when it's the first time uring_cmd c=
alled with
> > > > > > > checking the flag. I would remove this commit for next versio=
n. I also
> > > > > > > suggests that we would provide the method that read_pdu() and=
 write_pdu().
> > > > > > > In read_pdu() I want to check write_pdu() is called before. S=
o along the
> > > > > > > 20 bytes for pdu, maybe we could use a bytes for the flag tha=
t pdu is
> > > > > > > initialized?
> > > > > >
> > > > > > Not sure what you mean about "20 bytes for pdu".
> > > > > > It seems like it would be preferable to enforce that write_pdu(=
) has
> > > > > > been called before read_pdu() using the Rust type system instea=
d of a
> > > > > > runtime check. I was thinking a signature like fn write_pdu(cmd=
:
> > > > > > IoUringCmd, value: T) -> IoUringCmdPdu<T>. Do you feel there's =
a
> > > > > > reason that wouldn't work and a runtime check would be necessar=
y?
> > > > >
> > > > > I didn't think about make write_pdu() to return IoUringCmdPdu<T> =
before.
> > > > > I think it's good way to pdu is safe without adding a new generic=
 param for
> > > > > MiscDevice. write_pdu() would return IoUringCmdPdu<T> and it coul=
d call
> > > > > IoUringCmdPdu<T>::pdu(&mut self) -> &mut T safely maybe.
> > > >
> > > > Yes, that's what I was thinking.
> > >
> > > Good, I'll change api in this way. Thanks!
> > >
> > > >
> > > > >
> > > > > >
> > > > > > >
> > > > > > > But maybe I would introduce a new struct that has Pin<&mut Io=
UringCmd> and
> > > > > > > issue_flags. How about some additional field for pdu is initi=
alized like below?
> > > > > > >
> > > > > > > struct IoUringCmdArgs {
> > > > > > >   ioucmd: Pin<&mut IoUringCmd>,
> > > > > > >   issue_flags: u32,
> > > > > > >   pdu_initialized: bool,
> > > > > > > }
> > > > > >
> > > > > > One other thing I realized is that issue_flags should come from=
 the
> > > > > > *current* context rather than the context the uring_cmd() callb=
ack was
> > > > > > called in. For example, if io_uring_cmd_done() is called from t=
ask
> > > > > > work context, issue_flags should match the issue_flags passed t=
o the
> > > > > > io_uring_cmd_tw_t callback, not the issue_flags originally pass=
ed to
> > > > > > the uring_cmd() callback. So it probably makes more sense to de=
couple
> > > > > > issue_flags from the (owned) IoUringCmd. I think you could pass=
 it by
> > > > > > reference (&IssueFlags) or with a phantom reference lifetime
> > > > > > (IssueFlags<'_>) to the Rust uring_cmd() and task work callback=
s to
> > > > > > ensure it can't be used after those callbacks have returned.
> > > > >
> > > > > I have had no idea about task work context. I agree with you that
> > > > > it would be better to separate issue_flags from IoUringCmd. So,
> > > > > IoUringCmdArgs would have a only field Pin<&mut IoUringCmd>?
> > > >
> > > > "Task work" is a mechanism io_uring uses to queue work to run on th=
e
> > > > thread that submitted an io_uring operation. It's basically a
> > > > per-thread atomic queue of callbacks that the thread will process
> > > > whenever it returns from the kernel to userspace (after a syscall o=
r
> > > > an interrupt). This is the context where asynchronous uring_cmd
> > > > completions are generally processed (see
> > > > io_uring_cmd_complete_in_task() and io_uring_cmd_do_in_task_lazy())=
. I
> > > > can't speak to the history of why io_uring uses task work, but my
> > > > guess would be that it provides a safe context to acquire the
> > > > io_ring_ctx uring_lock mutex (e.g. nvme_uring_cmd_end_io() can be
> > > > called from an interrupt handler, so it's not allowed to take a
> > > > mutex). Processing all the task work at once also provides natural
> > > > opportunities for batching.
> > >
> > > Thanks, I've checked io_uring_cmd_complete_in_task() that it receives
> > > callback that has issue_flags different with io_uring_cmd(). I'll try=
 to add
> > > a api that wrapping io_uring_cmd_complete_in_task() for next version.
> > >
> > > >
> > > > Yes, we probably don't need to bundle anything else with the
> > > > IoUringCmd after all. As I mentioned earlier, I don't think Pin<&mu=
t
> > > > IoUringCmd> will work for uring_cmds that complete asynchronously, =
as
> > > > they will need to outlive the uring_cmd() call. So uring_cmd() need=
s
> > > > to transfer ownership of the struct io_uring_cmd.
> > >
> > > I can't think that how to take ownership of struct io_uring_cmd. The
> > > struct allocated with io_alloc_req() and should be freed with io_free=
_req().
> > > If taking ownership means having pointer of struct io_uring_cmd, I th=
ink
> > > it's no difference with current version. Also could it be called with
> > > mem::forget() if it has ownership?
> >
> > I don't mean ownership of the io_uring_cmd allocation; that's the
> > responsibility of the io_uring layer. But once the io_uring_cmd is
> > handed to the uring_cmd() implementation, it belongs to that layer
> > until it completes the command back to io_uring. Maybe a better way to
> > describe it would be as ownership of the "executing io_uring_cmd". The
> > problem with Pin<&mut IoUringCmd> is that it is a borrowed reference
> > to the io_uring_cmd, so it can't outlive the uring_cmd() callback.
> > Yes, it's possible to leak the io_uring_cmd by never calling
> > io_uring_cmd_done() to return it to the io_uring layer.
>
> Thanks, I understood that IoUringCmd could be outlive uring_cmd callback.
> But it's sad that it could be leaked without any unsafe code.

Safety in Rust doesn't require destructors to run, which means any
resource can be safely leaked
(https://faultlore.com/blah/everyone-poops/ has some historical
background on why Rust decided leaks had to be considered safe).
Leaking an io_uring_cmd is analogous to leaking a Box, both are
perfectly possible in safe Rust.

>
> >
> > I would imagine something like this:
> >
> > #[derive(Clone, Copy)]
> > struct IssueFlags<'a>(c_uint, PhantomData<&'a ()>);
> >
> > // Indicates ownership of the io_uring_cmd between uring_cmd() and
> > io_uring_cmd_done()
> > struct IoUringCmd(NonNull<bindings::io_uring_cmd>);
> >
> > impl IoUringCmd {
> >         // ...
> >
> >         fn done(self, ret: i32, res2: u64, issue_flags: IssueFlags<'_>)=
 {
> >                 let cmd =3D self.0.as_ptr();
> >                 let issue_flags =3D issue_flags.0;
> >                 unsafe {
> >                         bindings::io_uring_cmd_done(cmd, ret, res2, iss=
ue_flags)
> >                 }
> >         }
> > }
> >
> > // Can choose whether to complete the command synchronously or asynchro=
nously.
> > // If take_async() is called, IoUringCmd::done() needs to be called to
> > complete the command.
> > // If take_async() isn't called, the command is completed synchronously
> > // with the return value from MiscDevice::uring_cmd().
> > struct UringCmdInput<'a>(&mut Option<NonNull<bindings::io_uring_cmd>>);
>
> Thanks for a detailed example!
>
> But rather than this, We could introduce new return type that has a callb=
ack that
> user could take IoUringCmd instead of returning -EIOCBQUEUED.

I'm not following what you're suggesting, maybe a code sample would help?

>
> But I prefer that we provide just one type IoUringCmd without UringCmdInp=
ut.
> Although UringCmdInput, user could call done() in uring_cmd callback and
> it makes confusion that whether task_async() called and returning -EIOCBQ=
UEUED
> is mismatched that returns -EINVAL. We don't need to make it complex.

Sure, if you only want to support asynchronous io_uring_cmd
completions, than you can just pass IoUringCmd to
MiscDevice::uring_cmd() and require it to call IoUringCmd::done() to
complete the command. There's a small performance overhead to that
over just returning the result from the uring_cmd() callback for
synchronous completions (and it's more verbose), but I think that
would be fine for an initial implementation.

Best,
Caleb

