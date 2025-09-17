Return-Path: <io-uring+bounces-9830-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FB93B8057A
	for <lists+io-uring@lfdr.de>; Wed, 17 Sep 2025 17:03:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA7B51C81C93
	for <lists+io-uring@lfdr.de>; Wed, 17 Sep 2025 14:58:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0042330D25;
	Wed, 17 Sep 2025 14:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="oiCeZZ6P"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E8F32E73E
	for <io-uring@vger.kernel.org>; Wed, 17 Sep 2025 14:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758120983; cv=none; b=G559asFI6JPI0+M3+Nvkin4ci44W7L/Ee5XNPwfcQUJlO0lQTfqbHFejVIlyvjTh2wKCuR89uqZ1Ye/NGWNcb+8uRPqVcapsWMafi8sLKsKGDMOi4dLHGTnchTa6ngDiKxLfYVv36NELjaLeImUhdjm7OPpEMsie8xepBxoGcZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758120983; c=relaxed/simple;
	bh=gicOMBaesdNTccvEzddk/YN/oDXQeNuzFolMvo4isZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BYX5Cf+GNFN57TGlfn4xT9SyyGvHbUk3GGRyppGFeCumLAjYPsdhSweWAZnOcXkhD+p/lkb9WtraoAkKjp0uqZ4kwEROS86OKq/5ZjiwNH2eGrAQYMDLjL0PxnFvZ6qrGg8FNxdgxuL/2WfxY36yJlNZjKOTGqzejZpENVVpV7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=oiCeZZ6P; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7762021c574so4334079b3a.0
        for <io-uring@vger.kernel.org>; Wed, 17 Sep 2025 07:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1758120980; x=1758725780; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vGgjTNK+wdbeCWY6KMOb7s+5s0orqzod2SL7Bz5GX80=;
        b=oiCeZZ6P3v1RY/DC/aT0/k64vHpcg+rmZ2WEzpger9u5LevHFgP87BPM/qEoqLJRCZ
         RwPcvSWibYB9QJNIatvtrgO9JvgBpXrWlFGTws9S3N5pzMAjS6gvohm6UCK1ckqAhrCT
         5oO6h2E793pbV82qF/AaVpIjwRJ2wf8qtP1O4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758120980; x=1758725780;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vGgjTNK+wdbeCWY6KMOb7s+5s0orqzod2SL7Bz5GX80=;
        b=V7OLV6fYXxmhIrGfZRrjBAW0Ofao//nzkr1AIow2HuaGxhwjVaIP9uRhfB3eztSoA2
         ZlKpSpaSwJxKuT88WOF5LkY4fT60yQFemyw07fFb5TX1JQStbqxxaBLp9w9GVWTpHRYs
         phtltBQGH3xX1gDmDrHqyzmqEHlP4+roD6jslvm7CbteUKZcwjG0A/ZKe86QQjFmZGsK
         EUiKYrmK6MfyDi37/uXJzLOpf9iq1c3EFWHjDAUEWGqfrl03lJnR3K/BNsyV8xSDaev5
         ygsDlu5R3AG32pjqhgaM1eRonHM7xmfKQIo7myZVUy5xD1D9Lw8rUCnVwNP969x7OS/l
         BY8Q==
X-Forwarded-Encrypted: i=1; AJvYcCW/AC1L1kkN79m6XjDNrw5wMJWpbioBowNYRRjjqe8dc5e5d7ICDcZXqiipD4K0vX36lzPGoB/19A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxhZEM9SsdeY5xO9oFmbaOptlIaxCUMLayU5ONGb1GOqcQC0jig
	o/vWeKD4oKxO7pirgu7BRY+FxUbndRC0g87JSC62DOXQXSu22byJLFlnGKP+MnErETA=
X-Gm-Gg: ASbGnctCU+uT5wrIGQXagnBjFcH1ZnCvAEcE63NQeZDHHsJTVy5rAndEQUNdNYbxqhz
	lhqKe1eDHZt/8Qo1OU0zsChsYLsa4brn/HtdJEWH1hZdhRxBA0gGP3ris1Qxvejgs6jYyFF9upx
	ak5BiPzflvCyArx2u6+LJNo+QGhHYOcB1F8ByR7kFpCAFB/KOMG1Xaw5AG18qLuPYZRNGPFbtk2
	TV1p4H1Ho7RZI0kOZjtxVnNiPBKyqOBmp12CXiLQzX1gFI5gKpLDdtIiI6CJovAImUJ3l5U0tOL
	Mz3EnQZ9NcyTUhkj6ejuIF9K/PztuIbXjbIxfF1J5pQfiEFSQFJH0FCqtzifTYJr2k4ujFKNFho
	cI8zmVykDGssWtQuEA+0XjKNbQLwFuUUN6vWH70M4shX7MmaXJZxca1Chy/le3HZjVPo=
X-Google-Smtp-Source: AGHT+IF38AXPY34Cdzv56BftkQZDZ9qSIcFh807nJJKWx6fVTWK3/9fTFBZvhx6xdeQWZibqjDWecQ==
X-Received: by 2002:a05:6a00:986:b0:771:e4b0:4641 with SMTP id d2e1a72fcca58-77bf6dcfe59mr2978340b3a.1.1758120979976;
        Wed, 17 Sep 2025 07:56:19 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77607c49fe4sm19473921b3a.101.2025.09.17.07.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Sep 2025 07:56:18 -0700 (PDT)
Date: Wed, 17 Sep 2025 23:56:13 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Benno Lossin <lossin@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v3 2/5] io_uring/cmd: zero-init pdu in
 io_uring_cmd_prep() to avoid UB
Message-ID: <aMrMDd4kjxim0CkA@sidongui-MacBookPro.local>
References: <aLbFiChBnTNLBAyV@sidongui-MacBookPro.local>
 <CADUfDZpPvj3R7kzWC9bQVV0iuCBOnKsNUFn=B3ivf7De5wCB8g@mail.gmail.com>
 <aLxFAamglufhUvq0@sidongui-MacBookPro.local>
 <CADUfDZruwQyOcAeOXkXMLX+_HgOBeYdHUmgnJdT5pGQEmXt9+g@mail.gmail.com>
 <aMA8_MuU0V-_ja5O@sidongui-MacBookPro.local>
 <CADUfDZppdnM2QAeX37OmZsXqd7sO7KvyLnNPUYOgLpWMb+FpoQ@mail.gmail.com>
 <aMRNSBHDM4nkewHO@sidongui-MacBookPro.local>
 <CADUfDZrHse9nDxfd0UDkxOEmVRg-b=KDEUZ9Hz08eojXJvgtng@mail.gmail.com>
 <aMVmm1Ydt4iOfxu5@sidongui-MacBookPro.local>
 <CADUfDZrULTJj99Bik3OhUEorMSnL5cWgJ-VqoHePZ6WWDoukTQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZrULTJj99Bik3OhUEorMSnL5cWgJ-VqoHePZ6WWDoukTQ@mail.gmail.com>

On Mon, Sep 15, 2025 at 09:54:50AM -0700, Caleb Sander Mateos wrote:
> On Sat, Sep 13, 2025 at 5:42 AM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> >
> > On Fri, Sep 12, 2025 at 10:56:31AM -0700, Caleb Sander Mateos wrote:
> > > On Fri, Sep 12, 2025 at 9:42 AM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> > > >
> > > > On Tue, Sep 09, 2025 at 09:32:37AM -0700, Caleb Sander Mateos wrote:
> > > > > On Tue, Sep 9, 2025 at 7:43 AM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> > > > > >
> > > > > > On Mon, Sep 08, 2025 at 12:45:58PM -0700, Caleb Sander Mateos wrote:
> > > > > > > On Sat, Sep 6, 2025 at 7:28 AM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> > > > > > > >
> > > > > > > > On Tue, Sep 02, 2025 at 08:31:00AM -0700, Caleb Sander Mateos wrote:
> > > > > > > > > On Tue, Sep 2, 2025 at 3:23 AM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> > > > > > > > > >
> > > > > > > > > > On Mon, Sep 01, 2025 at 05:34:28PM -0700, Caleb Sander Mateos wrote:
> > > > > > > > > > > On Fri, Aug 22, 2025 at 5:56 AM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> > > > > > > > > > > >
> > > > > > > > > > > > The pdu field in io_uring_cmd may contain stale data when a request
> > > > > > > > > > > > object is recycled from the slab cache. Accessing uninitialized or
> > > > > > > > > > > > garbage memory can lead to undefined behavior in users of the pdu.
> > > > > > > > > > > >
> > > > > > > > > > > > Ensure the pdu buffer is cleared during io_uring_cmd_prep() so that
> > > > > > > > > > > > each command starts from a well-defined state. This avoids exposing
> > > > > > > > > > > > uninitialized memory and prevents potential misinterpretation of data
> > > > > > > > > > > > from previous requests.
> > > > > > > > > > > >
> > > > > > > > > > > > No functional change is intended other than guaranteeing that pdu is
> > > > > > > > > > > > always zero-initialized before use.
> > > > > > > > > > > >
> > > > > > > > > > > > Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> > > > > > > > > > > > ---
> > > > > > > > > > > >  io_uring/uring_cmd.c | 1 +
> > > > > > > > > > > >  1 file changed, 1 insertion(+)
> > > > > > > > > > > >
> > > > > > > > > > > > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > > > > > > > > > > > index 053bac89b6c0..2492525d4e43 100644
> > > > > > > > > > > > --- a/io_uring/uring_cmd.c
> > > > > > > > > > > > +++ b/io_uring/uring_cmd.c
> > > > > > > > > > > > @@ -203,6 +203,7 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> > > > > > > > > > > >         if (!ac)
> > > > > > > > > > > >                 return -ENOMEM;
> > > > > > > > > > > >         ioucmd->sqe = sqe;
> > > > > > > > > > > > +       memset(&ioucmd->pdu, 0, sizeof(ioucmd->pdu));
> > > > > > > > > > >
> > > > > > > > > > > Adding this overhead to every existing uring_cmd() implementation is
> > > > > > > > > > > unfortunate. Could we instead track the initialized/uninitialized
> > > > > > > > > > > state by using different types on the Rust side? The io_uring_cmd
> > > > > > > > > > > could start as an IoUringCmd, where the PDU field is MaybeUninit,
> > > > > > > > > > > write_pdu<T>() could return a new IoUringCmdPdu<T> that guarantees the
> > > > > > > > > > > PDU has been initialized.
> > > > > > > > > >
> > > > > > > > > > I've found a flag IORING_URING_CMD_REISSUE that we could initialize
> > > > > > > > > > the pdu. In uring_cmd callback, we can fill zero when it's not reissued.
> > > > > > > > > > But I don't know that we could call T::default() in miscdevice. If we
> > > > > > > > > > make IoUringCmdPdu<T>, MiscDevice also should be MiscDevice<T>.
> > > > > > > > > >
> > > > > > > > > > How about assign a byte in pdu for checking initialized? In uring_cmd(),
> > > > > > > > > > We could set a byte flag that it's not initialized. And we could return
> > > > > > > > > > error that it's not initialized in read_pdu().
> > > > > > > > >
> > > > > > > > > Could we do the zero-initialization (or T::default()) in
> > > > > > > > > MiscdeviceVTable::uring_cmd() if the IORING_URING_CMD_REISSUE flag
> > > > > > > > > isn't set (i.e. on the initial issue)? That way, we avoid any
> > > > > > > > > performance penalty for the existing C uring_cmd() implementations.
> > > > > > > > > I'm not quite sure what you mean by "assign a byte in pdu for checking
> > > > > > > > > initialized".
> > > > > > > >
> > > > > > > > Sure, we could fill zero when it's the first time uring_cmd called with
> > > > > > > > checking the flag. I would remove this commit for next version. I also
> > > > > > > > suggests that we would provide the method that read_pdu() and write_pdu().
> > > > > > > > In read_pdu() I want to check write_pdu() is called before. So along the
> > > > > > > > 20 bytes for pdu, maybe we could use a bytes for the flag that pdu is
> > > > > > > > initialized?
> > > > > > >
> > > > > > > Not sure what you mean about "20 bytes for pdu".
> > > > > > > It seems like it would be preferable to enforce that write_pdu() has
> > > > > > > been called before read_pdu() using the Rust type system instead of a
> > > > > > > runtime check. I was thinking a signature like fn write_pdu(cmd:
> > > > > > > IoUringCmd, value: T) -> IoUringCmdPdu<T>. Do you feel there's a
> > > > > > > reason that wouldn't work and a runtime check would be necessary?
> > > > > >
> > > > > > I didn't think about make write_pdu() to return IoUringCmdPdu<T> before.
> > > > > > I think it's good way to pdu is safe without adding a new generic param for
> > > > > > MiscDevice. write_pdu() would return IoUringCmdPdu<T> and it could call
> > > > > > IoUringCmdPdu<T>::pdu(&mut self) -> &mut T safely maybe.
> > > > >
> > > > > Yes, that's what I was thinking.
> > > >
> > > > Good, I'll change api in this way. Thanks!
> > > >
> > > > >
> > > > > >
> > > > > > >
> > > > > > > >
> > > > > > > > But maybe I would introduce a new struct that has Pin<&mut IoUringCmd> and
> > > > > > > > issue_flags. How about some additional field for pdu is initialized like below?
> > > > > > > >
> > > > > > > > struct IoUringCmdArgs {
> > > > > > > >   ioucmd: Pin<&mut IoUringCmd>,
> > > > > > > >   issue_flags: u32,
> > > > > > > >   pdu_initialized: bool,
> > > > > > > > }
> > > > > > >
> > > > > > > One other thing I realized is that issue_flags should come from the
> > > > > > > *current* context rather than the context the uring_cmd() callback was
> > > > > > > called in. For example, if io_uring_cmd_done() is called from task
> > > > > > > work context, issue_flags should match the issue_flags passed to the
> > > > > > > io_uring_cmd_tw_t callback, not the issue_flags originally passed to
> > > > > > > the uring_cmd() callback. So it probably makes more sense to decouple
> > > > > > > issue_flags from the (owned) IoUringCmd. I think you could pass it by
> > > > > > > reference (&IssueFlags) or with a phantom reference lifetime
> > > > > > > (IssueFlags<'_>) to the Rust uring_cmd() and task work callbacks to
> > > > > > > ensure it can't be used after those callbacks have returned.
> > > > > >
> > > > > > I have had no idea about task work context. I agree with you that
> > > > > > it would be better to separate issue_flags from IoUringCmd. So,
> > > > > > IoUringCmdArgs would have a only field Pin<&mut IoUringCmd>?
> > > > >
> > > > > "Task work" is a mechanism io_uring uses to queue work to run on the
> > > > > thread that submitted an io_uring operation. It's basically a
> > > > > per-thread atomic queue of callbacks that the thread will process
> > > > > whenever it returns from the kernel to userspace (after a syscall or
> > > > > an interrupt). This is the context where asynchronous uring_cmd
> > > > > completions are generally processed (see
> > > > > io_uring_cmd_complete_in_task() and io_uring_cmd_do_in_task_lazy()). I
> > > > > can't speak to the history of why io_uring uses task work, but my
> > > > > guess would be that it provides a safe context to acquire the
> > > > > io_ring_ctx uring_lock mutex (e.g. nvme_uring_cmd_end_io() can be
> > > > > called from an interrupt handler, so it's not allowed to take a
> > > > > mutex). Processing all the task work at once also provides natural
> > > > > opportunities for batching.
> > > >
> > > > Thanks, I've checked io_uring_cmd_complete_in_task() that it receives
> > > > callback that has issue_flags different with io_uring_cmd(). I'll try to add
> > > > a api that wrapping io_uring_cmd_complete_in_task() for next version.
> > > >
> > > > >
> > > > > Yes, we probably don't need to bundle anything else with the
> > > > > IoUringCmd after all. As I mentioned earlier, I don't think Pin<&mut
> > > > > IoUringCmd> will work for uring_cmds that complete asynchronously, as
> > > > > they will need to outlive the uring_cmd() call. So uring_cmd() needs
> > > > > to transfer ownership of the struct io_uring_cmd.
> > > >
> > > > I can't think that how to take ownership of struct io_uring_cmd. The
> > > > struct allocated with io_alloc_req() and should be freed with io_free_req().
> > > > If taking ownership means having pointer of struct io_uring_cmd, I think
> > > > it's no difference with current version. Also could it be called with
> > > > mem::forget() if it has ownership?
> > >
> > > I don't mean ownership of the io_uring_cmd allocation; that's the
> > > responsibility of the io_uring layer. But once the io_uring_cmd is
> > > handed to the uring_cmd() implementation, it belongs to that layer
> > > until it completes the command back to io_uring. Maybe a better way to
> > > describe it would be as ownership of the "executing io_uring_cmd". The
> > > problem with Pin<&mut IoUringCmd> is that it is a borrowed reference
> > > to the io_uring_cmd, so it can't outlive the uring_cmd() callback.
> > > Yes, it's possible to leak the io_uring_cmd by never calling
> > > io_uring_cmd_done() to return it to the io_uring layer.
> >
> > Thanks, I understood that IoUringCmd could be outlive uring_cmd callback.
> > But it's sad that it could be leaked without any unsafe code.
> 
> Safety in Rust doesn't require destructors to run, which means any
> resource can be safely leaked
> (https://faultlore.com/blah/everyone-poops/ has some historical
> background on why Rust decided leaks had to be considered safe).
> Leaking an io_uring_cmd is analogous to leaking a Box, both are
> perfectly possible in safe Rust.

Thanks for the reference. If driver just drops `IoUringCmd` without taking,
the request wouldn't be completed until io-uring instance deinitialized.
I understood that we cannot handle this.

> 
> >
> > >
> > > I would imagine something like this:
> > >
> > > #[derive(Clone, Copy)]
> > > struct IssueFlags<'a>(c_uint, PhantomData<&'a ()>);
> > >
> > > // Indicates ownership of the io_uring_cmd between uring_cmd() and
> > > io_uring_cmd_done()
> > > struct IoUringCmd(NonNull<bindings::io_uring_cmd>);
> > >
> > > impl IoUringCmd {
> > >         // ...
> > >
> > >         fn done(self, ret: i32, res2: u64, issue_flags: IssueFlags<'_>) {
> > >                 let cmd = self.0.as_ptr();
> > >                 let issue_flags = issue_flags.0;
> > >                 unsafe {
> > >                         bindings::io_uring_cmd_done(cmd, ret, res2, issue_flags)
> > >                 }
> > >         }
> > > }
> > >
> > > // Can choose whether to complete the command synchronously or asynchronously.
> > > // If take_async() is called, IoUringCmd::done() needs to be called to
> > > complete the command.
> > > // If take_async() isn't called, the command is completed synchronously
> > > // with the return value from MiscDevice::uring_cmd().
> > > struct UringCmdInput<'a>(&mut Option<NonNull<bindings::io_uring_cmd>>);
> >
> > Thanks for a detailed example!
> >
> > But rather than this, We could introduce new return type that has a callback that
> > user could take IoUringCmd instead of returning -EIOCBQUEUED.
> 
> I'm not following what you're suggesting, maybe a code sample would help?

maybe like below...

#[vtable]
pub trait MiscDevice: Sized {
    /// ...

    /// If user returns `EIOCBQUEUED`, this function would be called for
    /// users who want to take `IoUringCmdAsync`. It could call `done()` for complete
    /// request.
    fn uring_cmd_async_prep(
          device: <Self::Ptr as ForeignOwnable>::Borrowed<'_>,
          io_uring_cmd_async: IoUringCmdAsync);
    /// ...
}

impl<T: MiscDevice> MiscdeviceVTable<T> {
    // ...
    unsafe extern "C" fn uring_cmd(
          ioucmd: *mut bindings::io_uring_cmd,
          issue_flags: ffi::c_uint,
      ) -> c_int {
          // ...
          let result = T::uring_cmd(device, ioucmd, issue_flags);

          if let Err(EIOCBQUEUED) = result {
              T::uring_cmd_async_prep(device, ioucmd.to_async());
          }

          from_result(|| result)
      }
}
> 
> >
> > But I prefer that we provide just one type IoUringCmd without UringCmdInput.
> > Although UringCmdInput, user could call done() in uring_cmd callback and
> > it makes confusion that whether task_async() called and returning -EIOCBQUEUED
> > is mismatched that returns -EINVAL. We don't need to make it complex.
> 
> Sure, if you only want to support asynchronous io_uring_cmd
> completions, than you can just pass IoUringCmd to
> MiscDevice::uring_cmd() and require it to call IoUringCmd::done() to
> complete the command. There's a small performance overhead to that
> over just returning the result from the uring_cmd() callback for
> synchronous completions (and it's more verbose), but I think that
> would be fine for an initial implementation.

I appreciate for your understanding. I think it would be good to have just one
simple struct `IoUringCmd`. I'll make next version patch soon.

Thanks,
Sidong

> 
> Best,
> Caleb

