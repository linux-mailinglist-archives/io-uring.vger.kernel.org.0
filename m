Return-Path: <io-uring+bounces-9784-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AB6D7B560DF
	for <lists+io-uring@lfdr.de>; Sat, 13 Sep 2025 14:42:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B99EC1C80E88
	for <lists+io-uring@lfdr.de>; Sat, 13 Sep 2025 12:42:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 238D52ECD2C;
	Sat, 13 Sep 2025 12:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="ffeKwQDH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B26E2ECD27
	for <io-uring@vger.kernel.org>; Sat, 13 Sep 2025 12:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757767332; cv=none; b=SWsrCttacirAxATocqFSWy23FPxr1ANJRYh7uwgmzkFRlYYZ8DVitXaP8Snp1VZjipHdLXomvkXCr1GwuBcMW6hDLVhayR9VZ/3B+zHru1mrbxrN4P68858bkx9DEXbbpgbEhNdSOm6c8J8MrBIoKlcFhhSujzev4LNiAWlcEo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757767332; c=relaxed/simple;
	bh=kIhxFXQIQTNc+Iy/xvLDG6uUq5A0jNQrqhGjefi8q94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L6TIA2slOl7/wGtPoLcfpgvRL3gr6WJ2CghByqrz/cHVeROypbSB6syrBBMrahtguflXhic76lmc7+tQmca2K3HEcGEkkORObvN4bAQ1ogxgOhr3aYRqtykemlvdzIDw2BO2ayr26t+83qrtXD/+zGRlLzUHZSYiKd2qhkyVq8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=ffeKwQDH; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-24c9a399346so21126425ad.0
        for <io-uring@vger.kernel.org>; Sat, 13 Sep 2025 05:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1757767329; x=1758372129; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/9duoDwLODdQr2eNa1OtOkxFDQUPt6wjgx1Athkl2o0=;
        b=ffeKwQDHukvgU7T9sFTLQx5IBJdmrcYRYVaM9TWpuHu0HOrWgJOimG094wIPTBsg7y
         VEtxlZvRjAmw+2xdQRe6LoBacxOfmnUcN+UCEqsLcvqhaMfzz3G223DsHqPZf/8hZY+Q
         FZw3KFZ0hwQVJ1XQp3sL9VBumq/ABmBxHHnLM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757767329; x=1758372129;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/9duoDwLODdQr2eNa1OtOkxFDQUPt6wjgx1Athkl2o0=;
        b=A3Szz3HyeK8hUNXzYOeE7Ztj79OEXQgd6TLcRsc6LlZfXGH0yYb9YXJ0Pz71w42Y6g
         r0GQI1paixnMBSKWApuJMRSN2ikX360Xpf0acHaRvwvI06Dx4VNq64K7z/NNT4ILo5ZA
         t2YEeIkqhYPqxL+Z7qFM9R+VlDbL0/0BWwSy9Cy01TLf+0wquY/J4ezmmmLEg75oGnwF
         2S8JpVwg4ZQWVs+/YyDd67U1bnM+fmgrJwW2uSsdZhjZbFwPPlyad21zXaLiab83Bf6D
         XGTEPy75vVPWEnAfzVcpm0fc/5FQcjTCcjylGsUYH/qfMY1lIzmV0YtE7Dzt0ofph+2L
         +L4w==
X-Forwarded-Encrypted: i=1; AJvYcCX/7v/7BADa7F9UReT6dlGrojSJr24jaSfg0dMwSCEXsRnjZn+YnQ0tRzhuyz1RPywalUTNrEL4Sw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyH2iu93BRorlTBpUEdAamGHUCuT/mME74DX+MBH/l8gKlYI7N3
	jwwISR5Jj81T6QybBfMsVPWs+Xot2Kzhl6zhD1rHduWfPkoRWEP34ON5PFd7hk8p07w=
X-Gm-Gg: ASbGncteDDHxoPnQr9Qg3jQ6sTacKThnHtcxtRDngdte37wAHRKg8C7gMEcUJW6umfb
	Ss+/2OCDSVqQOGkCWW8yn6J3I6narKXM9pPfHc66gJGqWfbgSe5qrOxmGyLBRZUU2BSLOH3in6X
	pjXLoknLAEioWsh8Afrn1/eXL447N44ZBTF5SPZ5hFehzGpCzYaxUTRC3v6qvVza2G6iTlcDHLe
	NH7MJq7fjsB5XNOzEsV7DjftbLmQyrEqx1kFUgxhSDbix14+yxIFVchL07odUgGGDzTg8vrgAVx
	0qUGieLdrwTQDhFnKh1Pi+O8Pi1+EBEXahXAbXpcOtziarKtIa6q2SqwuR4yQPW8PsaYv+CEAh3
	s91CAlUIXwgq7sekLdJwM5cEHpOKJVcjBiwcceKIbsomxH7T7nbByIJ+ZoI09tgrvmt0=
X-Google-Smtp-Source: AGHT+IEfGVve+qOntlhQUD55T5Er2IYX9b3WcF5xwrm+kFXlXuC2bwamQsqYr8LU2tYzB+cRguk2Iw==
X-Received: by 2002:a17:902:db04:b0:262:d081:96c with SMTP id d9443c01a7336-262d0810e05mr11980195ad.17.1757767329394;
        Sat, 13 Sep 2025 05:42:09 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25c3ad2fa37sm74210085ad.111.2025.09.13.05.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Sep 2025 05:42:08 -0700 (PDT)
Date: Sat, 13 Sep 2025 21:42:03 +0900
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
Message-ID: <aMVmm1Ydt4iOfxu5@sidongui-MacBookPro.local>
References: <20250822125555.8620-3-sidong.yang@furiosa.ai>
 <CADUfDZpsePAbEON_90frzrPCPBt-a=1sW2Q=i8BGS=+tZhudFA@mail.gmail.com>
 <aLbFiChBnTNLBAyV@sidongui-MacBookPro.local>
 <CADUfDZpPvj3R7kzWC9bQVV0iuCBOnKsNUFn=B3ivf7De5wCB8g@mail.gmail.com>
 <aLxFAamglufhUvq0@sidongui-MacBookPro.local>
 <CADUfDZruwQyOcAeOXkXMLX+_HgOBeYdHUmgnJdT5pGQEmXt9+g@mail.gmail.com>
 <aMA8_MuU0V-_ja5O@sidongui-MacBookPro.local>
 <CADUfDZppdnM2QAeX37OmZsXqd7sO7KvyLnNPUYOgLpWMb+FpoQ@mail.gmail.com>
 <aMRNSBHDM4nkewHO@sidongui-MacBookPro.local>
 <CADUfDZrHse9nDxfd0UDkxOEmVRg-b=KDEUZ9Hz08eojXJvgtng@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZrHse9nDxfd0UDkxOEmVRg-b=KDEUZ9Hz08eojXJvgtng@mail.gmail.com>

On Fri, Sep 12, 2025 at 10:56:31AM -0700, Caleb Sander Mateos wrote:
> On Fri, Sep 12, 2025 at 9:42 AM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> >
> > On Tue, Sep 09, 2025 at 09:32:37AM -0700, Caleb Sander Mateos wrote:
> > > On Tue, Sep 9, 2025 at 7:43 AM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> > > >
> > > > On Mon, Sep 08, 2025 at 12:45:58PM -0700, Caleb Sander Mateos wrote:
> > > > > On Sat, Sep 6, 2025 at 7:28 AM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> > > > > >
> > > > > > On Tue, Sep 02, 2025 at 08:31:00AM -0700, Caleb Sander Mateos wrote:
> > > > > > > On Tue, Sep 2, 2025 at 3:23 AM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> > > > > > > >
> > > > > > > > On Mon, Sep 01, 2025 at 05:34:28PM -0700, Caleb Sander Mateos wrote:
> > > > > > > > > On Fri, Aug 22, 2025 at 5:56 AM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> > > > > > > > > >
> > > > > > > > > > The pdu field in io_uring_cmd may contain stale data when a request
> > > > > > > > > > object is recycled from the slab cache. Accessing uninitialized or
> > > > > > > > > > garbage memory can lead to undefined behavior in users of the pdu.
> > > > > > > > > >
> > > > > > > > > > Ensure the pdu buffer is cleared during io_uring_cmd_prep() so that
> > > > > > > > > > each command starts from a well-defined state. This avoids exposing
> > > > > > > > > > uninitialized memory and prevents potential misinterpretation of data
> > > > > > > > > > from previous requests.
> > > > > > > > > >
> > > > > > > > > > No functional change is intended other than guaranteeing that pdu is
> > > > > > > > > > always zero-initialized before use.
> > > > > > > > > >
> > > > > > > > > > Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> > > > > > > > > > ---
> > > > > > > > > >  io_uring/uring_cmd.c | 1 +
> > > > > > > > > >  1 file changed, 1 insertion(+)
> > > > > > > > > >
> > > > > > > > > > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > > > > > > > > > index 053bac89b6c0..2492525d4e43 100644
> > > > > > > > > > --- a/io_uring/uring_cmd.c
> > > > > > > > > > +++ b/io_uring/uring_cmd.c
> > > > > > > > > > @@ -203,6 +203,7 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> > > > > > > > > >         if (!ac)
> > > > > > > > > >                 return -ENOMEM;
> > > > > > > > > >         ioucmd->sqe = sqe;
> > > > > > > > > > +       memset(&ioucmd->pdu, 0, sizeof(ioucmd->pdu));
> > > > > > > > >
> > > > > > > > > Adding this overhead to every existing uring_cmd() implementation is
> > > > > > > > > unfortunate. Could we instead track the initialized/uninitialized
> > > > > > > > > state by using different types on the Rust side? The io_uring_cmd
> > > > > > > > > could start as an IoUringCmd, where the PDU field is MaybeUninit,
> > > > > > > > > write_pdu<T>() could return a new IoUringCmdPdu<T> that guarantees the
> > > > > > > > > PDU has been initialized.
> > > > > > > >
> > > > > > > > I've found a flag IORING_URING_CMD_REISSUE that we could initialize
> > > > > > > > the pdu. In uring_cmd callback, we can fill zero when it's not reissued.
> > > > > > > > But I don't know that we could call T::default() in miscdevice. If we
> > > > > > > > make IoUringCmdPdu<T>, MiscDevice also should be MiscDevice<T>.
> > > > > > > >
> > > > > > > > How about assign a byte in pdu for checking initialized? In uring_cmd(),
> > > > > > > > We could set a byte flag that it's not initialized. And we could return
> > > > > > > > error that it's not initialized in read_pdu().
> > > > > > >
> > > > > > > Could we do the zero-initialization (or T::default()) in
> > > > > > > MiscdeviceVTable::uring_cmd() if the IORING_URING_CMD_REISSUE flag
> > > > > > > isn't set (i.e. on the initial issue)? That way, we avoid any
> > > > > > > performance penalty for the existing C uring_cmd() implementations.
> > > > > > > I'm not quite sure what you mean by "assign a byte in pdu for checking
> > > > > > > initialized".
> > > > > >
> > > > > > Sure, we could fill zero when it's the first time uring_cmd called with
> > > > > > checking the flag. I would remove this commit for next version. I also
> > > > > > suggests that we would provide the method that read_pdu() and write_pdu().
> > > > > > In read_pdu() I want to check write_pdu() is called before. So along the
> > > > > > 20 bytes for pdu, maybe we could use a bytes for the flag that pdu is
> > > > > > initialized?
> > > > >
> > > > > Not sure what you mean about "20 bytes for pdu".
> > > > > It seems like it would be preferable to enforce that write_pdu() has
> > > > > been called before read_pdu() using the Rust type system instead of a
> > > > > runtime check. I was thinking a signature like fn write_pdu(cmd:
> > > > > IoUringCmd, value: T) -> IoUringCmdPdu<T>. Do you feel there's a
> > > > > reason that wouldn't work and a runtime check would be necessary?
> > > >
> > > > I didn't think about make write_pdu() to return IoUringCmdPdu<T> before.
> > > > I think it's good way to pdu is safe without adding a new generic param for
> > > > MiscDevice. write_pdu() would return IoUringCmdPdu<T> and it could call
> > > > IoUringCmdPdu<T>::pdu(&mut self) -> &mut T safely maybe.
> > >
> > > Yes, that's what I was thinking.
> >
> > Good, I'll change api in this way. Thanks!
> >
> > >
> > > >
> > > > >
> > > > > >
> > > > > > But maybe I would introduce a new struct that has Pin<&mut IoUringCmd> and
> > > > > > issue_flags. How about some additional field for pdu is initialized like below?
> > > > > >
> > > > > > struct IoUringCmdArgs {
> > > > > >   ioucmd: Pin<&mut IoUringCmd>,
> > > > > >   issue_flags: u32,
> > > > > >   pdu_initialized: bool,
> > > > > > }
> > > > >
> > > > > One other thing I realized is that issue_flags should come from the
> > > > > *current* context rather than the context the uring_cmd() callback was
> > > > > called in. For example, if io_uring_cmd_done() is called from task
> > > > > work context, issue_flags should match the issue_flags passed to the
> > > > > io_uring_cmd_tw_t callback, not the issue_flags originally passed to
> > > > > the uring_cmd() callback. So it probably makes more sense to decouple
> > > > > issue_flags from the (owned) IoUringCmd. I think you could pass it by
> > > > > reference (&IssueFlags) or with a phantom reference lifetime
> > > > > (IssueFlags<'_>) to the Rust uring_cmd() and task work callbacks to
> > > > > ensure it can't be used after those callbacks have returned.
> > > >
> > > > I have had no idea about task work context. I agree with you that
> > > > it would be better to separate issue_flags from IoUringCmd. So,
> > > > IoUringCmdArgs would have a only field Pin<&mut IoUringCmd>?
> > >
> > > "Task work" is a mechanism io_uring uses to queue work to run on the
> > > thread that submitted an io_uring operation. It's basically a
> > > per-thread atomic queue of callbacks that the thread will process
> > > whenever it returns from the kernel to userspace (after a syscall or
> > > an interrupt). This is the context where asynchronous uring_cmd
> > > completions are generally processed (see
> > > io_uring_cmd_complete_in_task() and io_uring_cmd_do_in_task_lazy()). I
> > > can't speak to the history of why io_uring uses task work, but my
> > > guess would be that it provides a safe context to acquire the
> > > io_ring_ctx uring_lock mutex (e.g. nvme_uring_cmd_end_io() can be
> > > called from an interrupt handler, so it's not allowed to take a
> > > mutex). Processing all the task work at once also provides natural
> > > opportunities for batching.
> >
> > Thanks, I've checked io_uring_cmd_complete_in_task() that it receives
> > callback that has issue_flags different with io_uring_cmd(). I'll try to add
> > a api that wrapping io_uring_cmd_complete_in_task() for next version.
> >
> > >
> > > Yes, we probably don't need to bundle anything else with the
> > > IoUringCmd after all. As I mentioned earlier, I don't think Pin<&mut
> > > IoUringCmd> will work for uring_cmds that complete asynchronously, as
> > > they will need to outlive the uring_cmd() call. So uring_cmd() needs
> > > to transfer ownership of the struct io_uring_cmd.
> >
> > I can't think that how to take ownership of struct io_uring_cmd. The
> > struct allocated with io_alloc_req() and should be freed with io_free_req().
> > If taking ownership means having pointer of struct io_uring_cmd, I think
> > it's no difference with current version. Also could it be called with
> > mem::forget() if it has ownership?
> 
> I don't mean ownership of the io_uring_cmd allocation; that's the
> responsibility of the io_uring layer. But once the io_uring_cmd is
> handed to the uring_cmd() implementation, it belongs to that layer
> until it completes the command back to io_uring. Maybe a better way to
> describe it would be as ownership of the "executing io_uring_cmd". The
> problem with Pin<&mut IoUringCmd> is that it is a borrowed reference
> to the io_uring_cmd, so it can't outlive the uring_cmd() callback.
> Yes, it's possible to leak the io_uring_cmd by never calling
> io_uring_cmd_done() to return it to the io_uring layer.

Thanks, I understood that IoUringCmd could be outlive uring_cmd callback.
But it's sad that it could be leaked without any unsafe code.

> 
> I would imagine something like this:
> 
> #[derive(Clone, Copy)]
> struct IssueFlags<'a>(c_uint, PhantomData<&'a ()>);
> 
> // Indicates ownership of the io_uring_cmd between uring_cmd() and
> io_uring_cmd_done()
> struct IoUringCmd(NonNull<bindings::io_uring_cmd>);
> 
> impl IoUringCmd {
>         // ...
> 
>         fn done(self, ret: i32, res2: u64, issue_flags: IssueFlags<'_>) {
>                 let cmd = self.0.as_ptr();
>                 let issue_flags = issue_flags.0;
>                 unsafe {
>                         bindings::io_uring_cmd_done(cmd, ret, res2, issue_flags)
>                 }
>         }
> }
> 
> // Can choose whether to complete the command synchronously or asynchronously.
> // If take_async() is called, IoUringCmd::done() needs to be called to
> complete the command.
> // If take_async() isn't called, the command is completed synchronously
> // with the return value from MiscDevice::uring_cmd().
> struct UringCmdInput<'a>(&mut Option<NonNull<bindings::io_uring_cmd>>);

Thanks for a detailed example!

But rather than this, We could introduce new return type that has a callback that
user could take IoUringCmd instead of returning -EIOCBQUEUED. 

But I prefer that we provide just one type IoUringCmd without UringCmdInput.
Although UringCmdInput, user could call done() in uring_cmd callback and 
it makes confusion that whether task_async() called and returning -EIOCBQUEUED
is mismatched that returns -EINVAL. We don't need to make it complex.

Thanks,
Sidong
> 
> impl UringCmdInput<'_> {
>         fn take_async(self) -> IoUringCmd {
>                 IoUringCmd(self.0.take().unwrap())
>         }
> }
> 
> trait MiscDevice {
>         // ...
> 
>         fn uring_cmd(
>                 _device: <Self::Ptr as ForeignOwnable>::Borrowed<'_>,
>                 _cmd: UringCmdInput<'_>,
>                 _ issue_flags: IssueFlags <'_>,
>         ) -> Result<i32> {
>                 build_error!(VTABLE_DEFAULT_ERROR)
>         }
> }
> 
> impl<T: MiscDevice> MiscdeviceVTable<T> {
>         // ...
> 
>         unsafe extern "C" fn uring_cmd(
>                 ioucmd: *mut bindings::io_uring_cmd,
>                 issue_flags: c_uint,
>         ) -> c_int {
>                 let raw_file = unsafe { (*ioucmd).file };
>                 let private = unsafe { (*raw_file).private_data }.cast();
>                 let device = unsafe { <T::Ptr as
> ForeignOwnable>::borrow(private) };
>                 let mut ioucmd = Some(NonNull::new(ioucmd).unwrap());
>                 let issue_flags = IssueFlags(issue_flags, PhantomData);
>                 let ret = T::uring_cmd(device, UringCmdInput(&mut
> ioucmd), issue_flags);
>                 // -EIOCBQUEUED indicates ownership of io_uring_cmd
> has been taken
>                 if iou_cmd.is_none() {
>                         return -bindings::EIOCBQUEUED;
>                 }
> 
>                 let ret = from_result(|| ret);
>                 if ret == -bindings::EIOCBQUEUED {
>                         -bindings::EINVAL
>                 } else {
>                         ret
>                 }
>         }
> }
> 
> Best,
> Caleb

