Return-Path: <io-uring+bounces-9781-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C7E8EB555AE
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 19:56:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C67016EB79
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 17:56:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D007F30C375;
	Fri, 12 Sep 2025 17:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="YP7MCHxt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64C0329F13
	for <io-uring@vger.kernel.org>; Fri, 12 Sep 2025 17:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757699806; cv=none; b=OHCWoadPiDae0gvttOe0QnYhYD38DgzorWGOOFMEpwVfPIWNurJKB980p1vkuccZ5VP4gl7PdFyMknPmvNaaWx55C6JNgevOC+z0iwwU06eYKaszfLtqHq/Av6YUZrFGahiRIc0bDgbLVa0oOk2+c+FKZ2z14/wD/cgqo/id10Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757699806; c=relaxed/simple;
	bh=2qpBmQ6Y/YLJGxVmpppaLAaPntBnERSHtn9ISE7GTxw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uJCH9U9QQC7cGeZ1qYVoYuReIn8WXd5k833ikmx3jyQAMDt5GsOu9AMSwT9TpVs7MgHrp3MK9EHX9wkDidr5sShbz51E8BV3wjm8uAHr7K3XyTixTIJE8WqecqZdhPF3/X4doNAuvVLHJUjZzx7cdYpjn38Z2O/yOPEPIgUr+GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=YP7MCHxt; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-24602f6d8b6so3479785ad.1
        for <io-uring@vger.kernel.org>; Fri, 12 Sep 2025 10:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1757699804; x=1758304604; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hxVuZzFkMjgyUqLxWsknwrPPaVV1iqBOeboDVtrRimE=;
        b=YP7MCHxtNdZ7R2hRdekjL6lRcC46AboOxCN/txcvDwHItiovCDXPH0q5t7LsnMmtzh
         E1UG9poG/L2z9pd/nBhYqEv6w7FFJLlwOZWTDI0uMKla2e5s9qP+y7vUrEc4ownJdrIg
         bNAh8AWwg3dnka8U4AMg/cuVxCIQ8aDJxIMgmwm4JOif+9dSZWRZMrpXn12eNM6kP7NC
         a8kQ+41GPh90CGVvmbZ0YQvrM3n7hF9w5htJEQgHoShImeNo/wSMUVAspzBNFfUfKOLY
         eTdADdVgcM4UYHgv0OUH65zXc9qqHjr4AkbDApXjAT18xg2z+kpcmBqgpGgRcAW2pdU9
         V7kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757699804; x=1758304604;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hxVuZzFkMjgyUqLxWsknwrPPaVV1iqBOeboDVtrRimE=;
        b=EnFnRJKLebfqEjmHAwjHUBGlQaQNnypl+08e6ToUX5TwQtk+iBqgiTVN6K+ZK6VJbx
         ClzgoWlZPzuY8VgCwm1hwc7kKMu43rE+xXBpbXjck3+Kh8Jue2iCTf0BCCf/lMrwVES+
         wsbf2YMlClJKt1pR+krCB2fhQBes2wdsQOUh+Lk8wlx8CetmLDYz4U7Yx4bBqoIGL58D
         VUcIMilQCQsFmpTqjU1ZLcN2bKPAqMImtBTFD6J6WZR+MOSEMoD34TrrsrpeZ85pG2Rd
         WfbO4AR/cqN6d8ItIhTRl+HA5YOz81gu4sEATcd4U7LRsnWxUy8reMAmJ46FmlgP0wKp
         ZrSw==
X-Forwarded-Encrypted: i=1; AJvYcCX/bgmtALD2bf4qLvc2C7tOE52OgzQspPCT8KTRuT1CpsEPnBg4D0XcQzMSpqTbFMOZ3xPhIp3T8Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/IozH/GOEz1BGOM7v/6DTd3KRqpZl6yjZuZG1q+t4HOeoc9Jh
	7427wwrRHkkSYWuXcRwjz0wXKq0EIvLvYGVbNUp82uN0cj9ieH0zsd8Y3MXuM+fIeAJXJOmug5Z
	8kz95x1rmdvf+E9T4nGDdAf/Sux2IrBZyPBkkv8Wt3g==
X-Gm-Gg: ASbGncuJR//6JgT3cAb6SnN5CMiD4i/K7fCbcvUgh/1pCHa0Ca2DECV2dGsylxorbLD
	NHtphrKtVWLnkNMHyZv0YQXrdDueC+bJtEpfmXL8F76CI8SunsYTNjmenLeotQQxN22E8d3sdt8
	QHzdbAmd79D4CRrUdof9uuQqYdcr7bKGee1xOPXnEwDE76F6z+N1f/W2UDEHhzliQtKI0GFaugC
	kSSeeAAmYOttguTDQsZ+WHmilk5sU4q7Xq1PuYl
X-Google-Smtp-Source: AGHT+IFUJDBU2DERIneFwVu8OQOfXHWry8fF9euvfc9rp0cH3Vvmx1l6fb7UueGLUXXhw6ujj64hiihHDJQtAG568LQ=
X-Received: by 2002:a17:903:110e:b0:257:3283:b859 with SMTP id
 d9443c01a7336-25d2782cb52mr23652285ad.9.1757699803543; Fri, 12 Sep 2025
 10:56:43 -0700 (PDT)
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
 <aMA8_MuU0V-_ja5O@sidongui-MacBookPro.local> <CADUfDZppdnM2QAeX37OmZsXqd7sO7KvyLnNPUYOgLpWMb+FpoQ@mail.gmail.com>
 <aMRNSBHDM4nkewHO@sidongui-MacBookPro.local>
In-Reply-To: <aMRNSBHDM4nkewHO@sidongui-MacBookPro.local>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 12 Sep 2025 10:56:31 -0700
X-Gm-Features: Ac12FXyhk2Yvgk3UuF5OSZLQra6cpOxXuL73wLdKxtNoHcnsBECPFSzyeU9KYM0
Message-ID: <CADUfDZrHse9nDxfd0UDkxOEmVRg-b=KDEUZ9Hz08eojXJvgtng@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/5] io_uring/cmd: zero-init pdu in
 io_uring_cmd_prep() to avoid UB
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: Jens Axboe <axboe@kernel.dk>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Benno Lossin <lossin@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 12, 2025 at 9:42=E2=80=AFAM Sidong Yang <sidong.yang@furiosa.ai=
> wrote:
>
> On Tue, Sep 09, 2025 at 09:32:37AM -0700, Caleb Sander Mateos wrote:
> > On Tue, Sep 9, 2025 at 7:43=E2=80=AFAM Sidong Yang <sidong.yang@furiosa=
.ai> wrote:
> > >
> > > On Mon, Sep 08, 2025 at 12:45:58PM -0700, Caleb Sander Mateos wrote:
> > > > On Sat, Sep 6, 2025 at 7:28=E2=80=AFAM Sidong Yang <sidong.yang@fur=
iosa.ai> wrote:
> > > > >
> > > > > On Tue, Sep 02, 2025 at 08:31:00AM -0700, Caleb Sander Mateos wro=
te:
> > > > > > On Tue, Sep 2, 2025 at 3:23=E2=80=AFAM Sidong Yang <sidong.yang=
@furiosa.ai> wrote:
> > > > > > >
> > > > > > > On Mon, Sep 01, 2025 at 05:34:28PM -0700, Caleb Sander Mateos=
 wrote:
> > > > > > > > On Fri, Aug 22, 2025 at 5:56=E2=80=AFAM Sidong Yang <sidong=
.yang@furiosa.ai> wrote:
> > > > > > > > >
> > > > > > > > > The pdu field in io_uring_cmd may contain stale data when=
 a request
> > > > > > > > > object is recycled from the slab cache. Accessing uniniti=
alized or
> > > > > > > > > garbage memory can lead to undefined behavior in users of=
 the pdu.
> > > > > > > > >
> > > > > > > > > Ensure the pdu buffer is cleared during io_uring_cmd_prep=
() so that
> > > > > > > > > each command starts from a well-defined state. This avoid=
s exposing
> > > > > > > > > uninitialized memory and prevents potential misinterpreta=
tion of data
> > > > > > > > > from previous requests.
> > > > > > > > >
> > > > > > > > > No functional change is intended other than guaranteeing =
that pdu is
> > > > > > > > > always zero-initialized before use.
> > > > > > > > >
> > > > > > > > > Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> > > > > > > > > ---
> > > > > > > > >  io_uring/uring_cmd.c | 1 +
> > > > > > > > >  1 file changed, 1 insertion(+)
> > > > > > > > >
> > > > > > > > > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > > > > > > > > index 053bac89b6c0..2492525d4e43 100644
> > > > > > > > > --- a/io_uring/uring_cmd.c
> > > > > > > > > +++ b/io_uring/uring_cmd.c
> > > > > > > > > @@ -203,6 +203,7 @@ int io_uring_cmd_prep(struct io_kiocb=
 *req, const struct io_uring_sqe *sqe)
> > > > > > > > >         if (!ac)
> > > > > > > > >                 return -ENOMEM;
> > > > > > > > >         ioucmd->sqe =3D sqe;
> > > > > > > > > +       memset(&ioucmd->pdu, 0, sizeof(ioucmd->pdu));
> > > > > > > >
> > > > > > > > Adding this overhead to every existing uring_cmd() implemen=
tation is
> > > > > > > > unfortunate. Could we instead track the initialized/uniniti=
alized
> > > > > > > > state by using different types on the Rust side? The io_uri=
ng_cmd
> > > > > > > > could start as an IoUringCmd, where the PDU field is MaybeU=
ninit,
> > > > > > > > write_pdu<T>() could return a new IoUringCmdPdu<T> that gua=
rantees the
> > > > > > > > PDU has been initialized.
> > > > > > >
> > > > > > > I've found a flag IORING_URING_CMD_REISSUE that we could init=
ialize
> > > > > > > the pdu. In uring_cmd callback, we can fill zero when it's no=
t reissued.
> > > > > > > But I don't know that we could call T::default() in miscdevic=
e. If we
> > > > > > > make IoUringCmdPdu<T>, MiscDevice also should be MiscDevice<T=
>.
> > > > > > >
> > > > > > > How about assign a byte in pdu for checking initialized? In u=
ring_cmd(),
> > > > > > > We could set a byte flag that it's not initialized. And we co=
uld return
> > > > > > > error that it's not initialized in read_pdu().
> > > > > >
> > > > > > Could we do the zero-initialization (or T::default()) in
> > > > > > MiscdeviceVTable::uring_cmd() if the IORING_URING_CMD_REISSUE f=
lag
> > > > > > isn't set (i.e. on the initial issue)? That way, we avoid any
> > > > > > performance penalty for the existing C uring_cmd() implementati=
ons.
> > > > > > I'm not quite sure what you mean by "assign a byte in pdu for c=
hecking
> > > > > > initialized".
> > > > >
> > > > > Sure, we could fill zero when it's the first time uring_cmd calle=
d with
> > > > > checking the flag. I would remove this commit for next version. I=
 also
> > > > > suggests that we would provide the method that read_pdu() and wri=
te_pdu().
> > > > > In read_pdu() I want to check write_pdu() is called before. So al=
ong the
> > > > > 20 bytes for pdu, maybe we could use a bytes for the flag that pd=
u is
> > > > > initialized?
> > > >
> > > > Not sure what you mean about "20 bytes for pdu".
> > > > It seems like it would be preferable to enforce that write_pdu() ha=
s
> > > > been called before read_pdu() using the Rust type system instead of=
 a
> > > > runtime check. I was thinking a signature like fn write_pdu(cmd:
> > > > IoUringCmd, value: T) -> IoUringCmdPdu<T>. Do you feel there's a
> > > > reason that wouldn't work and a runtime check would be necessary?
> > >
> > > I didn't think about make write_pdu() to return IoUringCmdPdu<T> befo=
re.
> > > I think it's good way to pdu is safe without adding a new generic par=
am for
> > > MiscDevice. write_pdu() would return IoUringCmdPdu<T> and it could ca=
ll
> > > IoUringCmdPdu<T>::pdu(&mut self) -> &mut T safely maybe.
> >
> > Yes, that's what I was thinking.
>
> Good, I'll change api in this way. Thanks!
>
> >
> > >
> > > >
> > > > >
> > > > > But maybe I would introduce a new struct that has Pin<&mut IoUrin=
gCmd> and
> > > > > issue_flags. How about some additional field for pdu is initializ=
ed like below?
> > > > >
> > > > > struct IoUringCmdArgs {
> > > > >   ioucmd: Pin<&mut IoUringCmd>,
> > > > >   issue_flags: u32,
> > > > >   pdu_initialized: bool,
> > > > > }
> > > >
> > > > One other thing I realized is that issue_flags should come from the
> > > > *current* context rather than the context the uring_cmd() callback =
was
> > > > called in. For example, if io_uring_cmd_done() is called from task
> > > > work context, issue_flags should match the issue_flags passed to th=
e
> > > > io_uring_cmd_tw_t callback, not the issue_flags originally passed t=
o
> > > > the uring_cmd() callback. So it probably makes more sense to decoup=
le
> > > > issue_flags from the (owned) IoUringCmd. I think you could pass it =
by
> > > > reference (&IssueFlags) or with a phantom reference lifetime
> > > > (IssueFlags<'_>) to the Rust uring_cmd() and task work callbacks to
> > > > ensure it can't be used after those callbacks have returned.
> > >
> > > I have had no idea about task work context. I agree with you that
> > > it would be better to separate issue_flags from IoUringCmd. So,
> > > IoUringCmdArgs would have a only field Pin<&mut IoUringCmd>?
> >
> > "Task work" is a mechanism io_uring uses to queue work to run on the
> > thread that submitted an io_uring operation. It's basically a
> > per-thread atomic queue of callbacks that the thread will process
> > whenever it returns from the kernel to userspace (after a syscall or
> > an interrupt). This is the context where asynchronous uring_cmd
> > completions are generally processed (see
> > io_uring_cmd_complete_in_task() and io_uring_cmd_do_in_task_lazy()). I
> > can't speak to the history of why io_uring uses task work, but my
> > guess would be that it provides a safe context to acquire the
> > io_ring_ctx uring_lock mutex (e.g. nvme_uring_cmd_end_io() can be
> > called from an interrupt handler, so it's not allowed to take a
> > mutex). Processing all the task work at once also provides natural
> > opportunities for batching.
>
> Thanks, I've checked io_uring_cmd_complete_in_task() that it receives
> callback that has issue_flags different with io_uring_cmd(). I'll try to =
add
> a api that wrapping io_uring_cmd_complete_in_task() for next version.
>
> >
> > Yes, we probably don't need to bundle anything else with the
> > IoUringCmd after all. As I mentioned earlier, I don't think Pin<&mut
> > IoUringCmd> will work for uring_cmds that complete asynchronously, as
> > they will need to outlive the uring_cmd() call. So uring_cmd() needs
> > to transfer ownership of the struct io_uring_cmd.
>
> I can't think that how to take ownership of struct io_uring_cmd. The
> struct allocated with io_alloc_req() and should be freed with io_free_req=
().
> If taking ownership means having pointer of struct io_uring_cmd, I think
> it's no difference with current version. Also could it be called with
> mem::forget() if it has ownership?

I don't mean ownership of the io_uring_cmd allocation; that's the
responsibility of the io_uring layer. But once the io_uring_cmd is
handed to the uring_cmd() implementation, it belongs to that layer
until it completes the command back to io_uring. Maybe a better way to
describe it would be as ownership of the "executing io_uring_cmd". The
problem with Pin<&mut IoUringCmd> is that it is a borrowed reference
to the io_uring_cmd, so it can't outlive the uring_cmd() callback.
Yes, it's possible to leak the io_uring_cmd by never calling
io_uring_cmd_done() to return it to the io_uring layer.

I would imagine something like this:

#[derive(Clone, Copy)]
struct IssueFlags<'a>(c_uint, PhantomData<&'a ()>);

// Indicates ownership of the io_uring_cmd between uring_cmd() and
io_uring_cmd_done()
struct IoUringCmd(NonNull<bindings::io_uring_cmd>);

impl IoUringCmd {
        // ...

        fn done(self, ret: i32, res2: u64, issue_flags: IssueFlags<'_>) {
                let cmd =3D self.0.as_ptr();
                let issue_flags =3D issue_flags.0;
                unsafe {
                        bindings::io_uring_cmd_done(cmd, ret, res2, issue_f=
lags)
                }
        }
}

// Can choose whether to complete the command synchronously or asynchronous=
ly.
// If take_async() is called, IoUringCmd::done() needs to be called to
complete the command.
// If take_async() isn't called, the command is completed synchronously
// with the return value from MiscDevice::uring_cmd().
struct UringCmdInput<'a>(&mut Option<NonNull<bindings::io_uring_cmd>>);

impl UringCmdInput<'_> {
        fn take_async(self) -> IoUringCmd {
                IoUringCmd(self.0.take().unwrap())
        }
}

trait MiscDevice {
        // ...

        fn uring_cmd(
                _device: <Self::Ptr as ForeignOwnable>::Borrowed<'_>,
                _cmd: UringCmdInput<'_>,
                _ issue_flags: IssueFlags <'_>,
        ) -> Result<i32> {
                build_error!(VTABLE_DEFAULT_ERROR)
        }
}

impl<T: MiscDevice> MiscdeviceVTable<T> {
        // ...

        unsafe extern "C" fn uring_cmd(
                ioucmd: *mut bindings::io_uring_cmd,
                issue_flags: c_uint,
        ) -> c_int {
                let raw_file =3D unsafe { (*ioucmd).file };
                let private =3D unsafe { (*raw_file).private_data }.cast();
                let device =3D unsafe { <T::Ptr as
ForeignOwnable>::borrow(private) };
                let mut ioucmd =3D Some(NonNull::new(ioucmd).unwrap());
                let issue_flags =3D IssueFlags(issue_flags, PhantomData);
                let ret =3D T::uring_cmd(device, UringCmdInput(&mut
ioucmd), issue_flags);
                // -EIOCBQUEUED indicates ownership of io_uring_cmd
has been taken
                if iou_cmd.is_none() {
                        return -bindings::EIOCBQUEUED;
                }

                let ret =3D from_result(|| ret);
                if ret =3D=3D -bindings::EIOCBQUEUED {
                        -bindings::EINVAL
                } else {
                        ret
                }
        }
}

Best,
Caleb

