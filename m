Return-Path: <io-uring+bounces-9780-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F2B74B554D3
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 18:42:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F242588509
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 16:42:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCA9C31C567;
	Fri, 12 Sep 2025 16:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="NW+5Ac7w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDAA31B126
	for <io-uring@vger.kernel.org>; Fri, 12 Sep 2025 16:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757695321; cv=none; b=jp1zq32v2y8+mP3GtdRdy885PSUnFfZ6+w+J54KD5KwBqBG3+0MQRqVSvereE78DlC2Ru4XcrYP8BIJmkqvLXjPGxe2vChO50y/TCzE6rJgGCh5gHT1DOcJep1b1Kok/1oVcmEYKqCDhA84UtAjUyxLGmVKaNWBogt8WURC7E7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757695321; c=relaxed/simple;
	bh=iYOckhXvoXHI89aZgEd+P0bhwExKnzLKVvLjUbSKj3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S8z9KjwRFCnfA0+1ZZSFuXxQGRca1Txq6hIIixuOlKv7KkPgy0AcnbXZC+ncpVXsb0+SZCsYwP7/CFd8Y/Ob5ClbcM3V0CPkaVTty1VjygNWShi24ZAvxIJN2MAogRsHKy8NucJeteGIZ4tKWx1O+eBxczmVHxO3rlm5dFYi7r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=NW+5Ac7w; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7761b83fd01so629670b3a.3
        for <io-uring@vger.kernel.org>; Fri, 12 Sep 2025 09:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1757695319; x=1758300119; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eUzTaaKQdM78ZqXpIezMElUSzU7VXjFq6bGRx3LctHs=;
        b=NW+5Ac7wBU3jLuW4Je3egpX7udJ9A1sqenRMhhOBxh0GS5dpAJ77vTgwN1BlOKxR4m
         pCnFcIl0K8XDYkBorXUDTJhocRANny2atAWmIXBrd3kVdTlndHVH5qCs5xR/p866RTdI
         FogH0m2zzqDTOcMsOp9t50DOkrni6t/EDLsuU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757695319; x=1758300119;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eUzTaaKQdM78ZqXpIezMElUSzU7VXjFq6bGRx3LctHs=;
        b=PdfhscPIJhWCclV28IwqI49ov+NCC3NexGQfSO/4c6jPFR9zNxB943UNs4/QR4Km8+
         y29aBm2pkWI6VuF4TvUA+cvDPrzTVucohklorKv1cXoBWGKvrvXzei1vz2TMR3pFrfXr
         DJngfRRRehniyoSJw09Z7FDHf8P5w5tQkeLM1lWcvWIu9RUnZP13o6U4xqAms4pMCkrY
         ixEAy5r/Muhv0cNlUlIcK84cmcSAWSz5yjjX8Xd8XelyHjjbvCp4vIUUgGqDF0RSXvjH
         HTxYMW6omDFcVMKDurt/oTjRURJWwwjnZIgc989LwCjUtX+gOfvMwt6zxofTgH3xIR9E
         e7Uw==
X-Forwarded-Encrypted: i=1; AJvYcCVLUu2Pcl7Vmtb3bs0jR3FsR0OyLANe30GBuzJoAY24M3rZe2ve8CF9vROuL6EZB3i3eNLWUt4xxw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxeg3nMlPpzXg6flJGcH7iIaMifbzIL8bk8rTxAPDyP9hly5wPD
	flHIMx68MY9XF9uXAKeUxdLcg347JDxdmi4p4PlfZFaMhPxGJTomQ3B2jHb1PWVJmpZyvtf0Kbz
	YB8XbnP4=
X-Gm-Gg: ASbGncs5Tb8CXFyq4y36MicLqhMx5nOGZnHdNop4cfxFcx4aDw7UrdFSMHAhK/B/Gug
	9tgzqjxzfZ/XoKEazz6yY3uIbQatCtFJS7IDf0bItKDzCmuZAP+O8qu34+yp0+gxTH+pUkUuvEb
	kcg5dYd7y6PpMa/8LCG/t1G7qwxF6EQ6NvkGsZzxAyZjxzkGw2DvLoCnMO9iYd3TsruoQicxNel
	Ppy8s1zqpwTycP0thMUdL1YouLlu4pfXOvH2/DbqhVtxJVv2ftLb4lwyfHaSRcFdoMH6P/asyY9
	w141IRd/T/bnjG0/RNlXKtOYwKfzPs1tiu7XQ6E/mC4YKiEDZX5SrFMJT9JLZEHCjTPnCCA+3Bu
	M16bnoDNUR0WfLlR+dVtx22rxF3eMUPNnj0boHZZPGzJ/y/djfbB4bMkv
X-Google-Smtp-Source: AGHT+IH+5x9DuKFx9PMoW08FbBeZtXn84JaYEDOdb8DYH7O2d5sqqNiM+uDN2bMJC7MuYFmvHxIQtw==
X-Received: by 2002:a05:6a00:a8a:b0:771:ec42:1c1e with SMTP id d2e1a72fcca58-77612168e3emr3844530b3a.16.1757695319263;
        Fri, 12 Sep 2025 09:41:59 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77607b17e23sm5970153b3a.55.2025.09.12.09.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 09:41:58 -0700 (PDT)
Date: Sat, 13 Sep 2025 01:41:44 +0900
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
Message-ID: <aMRNSBHDM4nkewHO@sidongui-MacBookPro.local>
References: <20250822125555.8620-1-sidong.yang@furiosa.ai>
 <20250822125555.8620-3-sidong.yang@furiosa.ai>
 <CADUfDZpsePAbEON_90frzrPCPBt-a=1sW2Q=i8BGS=+tZhudFA@mail.gmail.com>
 <aLbFiChBnTNLBAyV@sidongui-MacBookPro.local>
 <CADUfDZpPvj3R7kzWC9bQVV0iuCBOnKsNUFn=B3ivf7De5wCB8g@mail.gmail.com>
 <aLxFAamglufhUvq0@sidongui-MacBookPro.local>
 <CADUfDZruwQyOcAeOXkXMLX+_HgOBeYdHUmgnJdT5pGQEmXt9+g@mail.gmail.com>
 <aMA8_MuU0V-_ja5O@sidongui-MacBookPro.local>
 <CADUfDZppdnM2QAeX37OmZsXqd7sO7KvyLnNPUYOgLpWMb+FpoQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZppdnM2QAeX37OmZsXqd7sO7KvyLnNPUYOgLpWMb+FpoQ@mail.gmail.com>

On Tue, Sep 09, 2025 at 09:32:37AM -0700, Caleb Sander Mateos wrote:
> On Tue, Sep 9, 2025 at 7:43 AM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> >
> > On Mon, Sep 08, 2025 at 12:45:58PM -0700, Caleb Sander Mateos wrote:
> > > On Sat, Sep 6, 2025 at 7:28 AM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> > > >
> > > > On Tue, Sep 02, 2025 at 08:31:00AM -0700, Caleb Sander Mateos wrote:
> > > > > On Tue, Sep 2, 2025 at 3:23 AM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> > > > > >
> > > > > > On Mon, Sep 01, 2025 at 05:34:28PM -0700, Caleb Sander Mateos wrote:
> > > > > > > On Fri, Aug 22, 2025 at 5:56 AM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> > > > > > > >
> > > > > > > > The pdu field in io_uring_cmd may contain stale data when a request
> > > > > > > > object is recycled from the slab cache. Accessing uninitialized or
> > > > > > > > garbage memory can lead to undefined behavior in users of the pdu.
> > > > > > > >
> > > > > > > > Ensure the pdu buffer is cleared during io_uring_cmd_prep() so that
> > > > > > > > each command starts from a well-defined state. This avoids exposing
> > > > > > > > uninitialized memory and prevents potential misinterpretation of data
> > > > > > > > from previous requests.
> > > > > > > >
> > > > > > > > No functional change is intended other than guaranteeing that pdu is
> > > > > > > > always zero-initialized before use.
> > > > > > > >
> > > > > > > > Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> > > > > > > > ---
> > > > > > > >  io_uring/uring_cmd.c | 1 +
> > > > > > > >  1 file changed, 1 insertion(+)
> > > > > > > >
> > > > > > > > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > > > > > > > index 053bac89b6c0..2492525d4e43 100644
> > > > > > > > --- a/io_uring/uring_cmd.c
> > > > > > > > +++ b/io_uring/uring_cmd.c
> > > > > > > > @@ -203,6 +203,7 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> > > > > > > >         if (!ac)
> > > > > > > >                 return -ENOMEM;
> > > > > > > >         ioucmd->sqe = sqe;
> > > > > > > > +       memset(&ioucmd->pdu, 0, sizeof(ioucmd->pdu));
> > > > > > >
> > > > > > > Adding this overhead to every existing uring_cmd() implementation is
> > > > > > > unfortunate. Could we instead track the initialized/uninitialized
> > > > > > > state by using different types on the Rust side? The io_uring_cmd
> > > > > > > could start as an IoUringCmd, where the PDU field is MaybeUninit,
> > > > > > > write_pdu<T>() could return a new IoUringCmdPdu<T> that guarantees the
> > > > > > > PDU has been initialized.
> > > > > >
> > > > > > I've found a flag IORING_URING_CMD_REISSUE that we could initialize
> > > > > > the pdu. In uring_cmd callback, we can fill zero when it's not reissued.
> > > > > > But I don't know that we could call T::default() in miscdevice. If we
> > > > > > make IoUringCmdPdu<T>, MiscDevice also should be MiscDevice<T>.
> > > > > >
> > > > > > How about assign a byte in pdu for checking initialized? In uring_cmd(),
> > > > > > We could set a byte flag that it's not initialized. And we could return
> > > > > > error that it's not initialized in read_pdu().
> > > > >
> > > > > Could we do the zero-initialization (or T::default()) in
> > > > > MiscdeviceVTable::uring_cmd() if the IORING_URING_CMD_REISSUE flag
> > > > > isn't set (i.e. on the initial issue)? That way, we avoid any
> > > > > performance penalty for the existing C uring_cmd() implementations.
> > > > > I'm not quite sure what you mean by "assign a byte in pdu for checking
> > > > > initialized".
> > > >
> > > > Sure, we could fill zero when it's the first time uring_cmd called with
> > > > checking the flag. I would remove this commit for next version. I also
> > > > suggests that we would provide the method that read_pdu() and write_pdu().
> > > > In read_pdu() I want to check write_pdu() is called before. So along the
> > > > 20 bytes for pdu, maybe we could use a bytes for the flag that pdu is
> > > > initialized?
> > >
> > > Not sure what you mean about "20 bytes for pdu".
> > > It seems like it would be preferable to enforce that write_pdu() has
> > > been called before read_pdu() using the Rust type system instead of a
> > > runtime check. I was thinking a signature like fn write_pdu(cmd:
> > > IoUringCmd, value: T) -> IoUringCmdPdu<T>. Do you feel there's a
> > > reason that wouldn't work and a runtime check would be necessary?
> >
> > I didn't think about make write_pdu() to return IoUringCmdPdu<T> before.
> > I think it's good way to pdu is safe without adding a new generic param for
> > MiscDevice. write_pdu() would return IoUringCmdPdu<T> and it could call
> > IoUringCmdPdu<T>::pdu(&mut self) -> &mut T safely maybe.
> 
> Yes, that's what I was thinking.

Good, I'll change api in this way. Thanks!

> 
> >
> > >
> > > >
> > > > But maybe I would introduce a new struct that has Pin<&mut IoUringCmd> and
> > > > issue_flags. How about some additional field for pdu is initialized like below?
> > > >
> > > > struct IoUringCmdArgs {
> > > >   ioucmd: Pin<&mut IoUringCmd>,
> > > >   issue_flags: u32,
> > > >   pdu_initialized: bool,
> > > > }
> > >
> > > One other thing I realized is that issue_flags should come from the
> > > *current* context rather than the context the uring_cmd() callback was
> > > called in. For example, if io_uring_cmd_done() is called from task
> > > work context, issue_flags should match the issue_flags passed to the
> > > io_uring_cmd_tw_t callback, not the issue_flags originally passed to
> > > the uring_cmd() callback. So it probably makes more sense to decouple
> > > issue_flags from the (owned) IoUringCmd. I think you could pass it by
> > > reference (&IssueFlags) or with a phantom reference lifetime
> > > (IssueFlags<'_>) to the Rust uring_cmd() and task work callbacks to
> > > ensure it can't be used after those callbacks have returned.
> >
> > I have had no idea about task work context. I agree with you that
> > it would be better to separate issue_flags from IoUringCmd. So,
> > IoUringCmdArgs would have a only field Pin<&mut IoUringCmd>?
> 
> "Task work" is a mechanism io_uring uses to queue work to run on the
> thread that submitted an io_uring operation. It's basically a
> per-thread atomic queue of callbacks that the thread will process
> whenever it returns from the kernel to userspace (after a syscall or
> an interrupt). This is the context where asynchronous uring_cmd
> completions are generally processed (see
> io_uring_cmd_complete_in_task() and io_uring_cmd_do_in_task_lazy()). I
> can't speak to the history of why io_uring uses task work, but my
> guess would be that it provides a safe context to acquire the
> io_ring_ctx uring_lock mutex (e.g. nvme_uring_cmd_end_io() can be
> called from an interrupt handler, so it's not allowed to take a
> mutex). Processing all the task work at once also provides natural
> opportunities for batching.

Thanks, I've checked io_uring_cmd_complete_in_task() that it receives
callback that has issue_flags different with io_uring_cmd(). I'll try to add
a api that wrapping io_uring_cmd_complete_in_task() for next version.

>
> Yes, we probably don't need to bundle anything else with the
> IoUringCmd after all. As I mentioned earlier, I don't think Pin<&mut
> IoUringCmd> will work for uring_cmds that complete asynchronously, as
> they will need to outlive the uring_cmd() call. So uring_cmd() needs
> to transfer ownership of the struct io_uring_cmd.

I can't think that how to take ownership of struct io_uring_cmd. The
struct allocated with io_alloc_req() and should be freed with io_free_req().
If taking ownership means having pointer of struct io_uring_cmd, I think
it's no difference with current version. Also could it be called with
mem::forget() if it has ownership?

Thanks,
Sidong
 
> Best,
> Caleb

