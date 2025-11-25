Return-Path: <io-uring+bounces-10779-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BD8EC82FE2
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 02:13:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C0CE134BB8D
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 01:13:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AD75238C23;
	Tue, 25 Nov 2025 01:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AKyX29CX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6495F226CF6
	for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 01:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764033203; cv=none; b=Da/TJoNNw0zOpUGjb/ztFTvwH4CCSbvB3PnP+1RoZzBkQ3IyAkqQOm7vcfQwGtZr6boIl4U+l9IA/d6AAkJLmnPSeZo77qVRHk6ZvYIMmK3Nm3S2uaQJkG0EXlBPyEpuZvU0ihu1woI8Ze0AL8W0NNio5hyWBg8m3ScMkHZVXMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764033203; c=relaxed/simple;
	bh=FXsVBXiX1kiZzenJQi2ZXPubfS+K4obDqCMl+cW7/zo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PcEFh36vxDk9I0D15oBW2OgPTDt+UFdDAdMIhvnVOji0gmiJogfSpKc0nPtpr35XBtNioNO+77KSy2PYasmySm3IKEigCRpzbF87+XEv7qFOATnsjUQ69LaDGbGKpWxZfQHVpcKUput+5VeohbC0Qe/pLHFZCogugizt0u3Wxoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AKyX29CX; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8a479c772cfso310918785a.0
        for <io-uring@vger.kernel.org>; Mon, 24 Nov 2025 17:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764033196; x=1764637996; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qXJPuvJYSJPXLSXVwpM6hUiZsuUEDCAhyfsh9rnu3hU=;
        b=AKyX29CXQvbuXuBktjhi3j4dovM2tBSN4S0XTCeToS/zu0udyqnoZoeyx3ekNYvN4S
         gLjT+XCn6O3Pla8tB88wPM+hDxBJQFZFw2a3ZDDt8R08QoiMKBtI1Ml9v/bW/e8g3hpP
         LVGU2aaVWnZ65/oVPOtXc94XDTzAkp7IBFYcI9Ox4RzZN4OuPHrusT7nIH40Ty2Runw+
         lFpH3Hjf2RqtQA/6/Vql4S9UPodvimrG4bRnWdaPWLqywA/DCetpMvxvaE/m3fkxS3Ty
         tAwl9T0Vcc8R2JQkOJVOFspIUEm/aZS0j1n4/0nxm5HbTOslQlyJ1JQKzITnDdDDM5jq
         Uqgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764033196; x=1764637996;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qXJPuvJYSJPXLSXVwpM6hUiZsuUEDCAhyfsh9rnu3hU=;
        b=BcpYQgeLWmFPY57e1q15my5XSiEd9zZs1EG1Aae3g1p48UymDxuud93ZheeMe/ZMio
         6QtutcYIpvLC7uyXDQyU2m/+d0DBhkKmyzTDEQ0Do8588yAPJzMdAMD58xbE2ubVvLfr
         rqDrXl/jj+3wthdtqCgLiYEKqsYTTvg6+5TRIrgdQxmOCHBPQIz9E6PZPxUuCoia/39I
         pmxPzCtqASBaexzEZDV7waBI9sG+IKnZzH6Xh3LWSfDdo0nWXqB3zf4UqyYZMP37houc
         dxeQpg36WJeaURLYVqOfOT1lx2HbTPOEJ2v6ARjhmdZCBqPeg6Qp2uJnomqtmcs+1KMQ
         RC+w==
X-Forwarded-Encrypted: i=1; AJvYcCX7wRGhlBt9NzJhQO0S8ig2fOPvYop2J6Um51ehOp3goKLZQ38sq3tpPMFvt6TyjZ69gsnB0jwV7Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxy8GExlwPy9hiA8gyE9db4zAy0ytfJb3xy34uXgHjnyy/iNygs
	vxeKUEo1NbkGb6+YNs9ORZgUNYIpZP9Yni4eAK3AYwC+OwM3hYUeahWb2Ba3raPtW3I+2CyxLUg
	pC5BP9q+xBSR2GwGRog+pT2PFFpNRuF0=
X-Gm-Gg: ASbGncuWuyeTfsO64DopxS8kFnsEOnTK4UR8YW/pzv+PAHCjjTa+3/EIbqCN2MDa2Ty
	ukLnXhEEGzE7Cx6mVDgO3tx4wa/FvLhtzNZ3fOHSXiUpsMUwCzKsK+4Ryvey9UbV6HpckrhKdcm
	HS54OZABCsYKw3ZzQK/4+22nDQpQXq1YlBuUjKd+0XfwJA1qu6fym4d7SIDlN9thyMoodsevx8s
	0HJIZ7y+2BUHXxzoaj1eqmLuwc+M9USm25sr7CWPckGUgEZoWvmJrsTmEIImOxbHcM5bQ==
X-Google-Smtp-Source: AGHT+IGBgajgVQ/LK+bdJwNqQE8qpwboVLBDQYoBxiIiZ+6iof+nBVQ8iNGRWNY/dmaEIWHHv8yusGWTZOwabPzOCYU=
X-Received: by 2002:a05:622a:1486:b0:4ed:a9c0:1e30 with SMTP id
 d75a77b69052e-4efbd8f51ccmr16691381cf.25.1764033195624; Mon, 24 Nov 2025
 17:13:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
 <20251027222808.2332692-9-joannelkoong@gmail.com> <a335fd2c-03ca-4201-abcf-74809b84c426@bsbernd.com>
 <CAJnrk1YPEDUbOu2N0EjfrkwK3Ge2XrNeaCY0YKL+E1t7Z8Xtvg@mail.gmail.com> <941f06eb-2429-4752-bf56-fbc413da436f@bsbernd.com>
In-Reply-To: <941f06eb-2429-4752-bf56-fbc413da436f@bsbernd.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 24 Nov 2025 17:13:04 -0800
X-Gm-Features: AWmQ_bkt46EaiSF-efS_-s1HPcceEXijoTxbKXySGjofO-UXnziEbX4E2h2WlOc
Message-ID: <CAJnrk1b3TUgVJz7dTtGjOu4vuSkx2_POh671PpkACZnp9FOkrw@mail.gmail.com>
Subject: Re: [PATCH v2 8/8] fuse: support io-uring registered buffers
To: Bernd Schubert <bernd@bsbernd.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, linux-fsdevel@vger.kernel.org, 
	bschubert@ddn.com, asml.silence@gmail.com, io-uring@vger.kernel.org, 
	xiaobing.li@samsung.com, csander@purestorage.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 23, 2025 at 12:12=E2=80=AFPM Bernd Schubert <bernd@bsbernd.com>=
 wrote:
>
>
>
> On 11/7/25 00:09, Joanne Koong wrote:
> > On Thu, Nov 6, 2025 at 11:48=E2=80=AFAM Bernd Schubert <bernd@bsbernd.c=
om> wrote:
> >>
> >> On 10/27/25 23:28, Joanne Koong wrote:
> >>> Add support for io-uring registered buffers for fuse daemons
> >>> communicating through the io-uring interface. Daemons may register
> >>> buffers ahead of time, which will eliminate the overhead of
> >>> pinning/unpinning user pages and translating virtual addresses for ev=
ery
> >>> server-kernel interaction.
> >>>
> >>> To support page-aligned payloads, the buffer is structured such that =
the
> >>> payload is at the front of the buffer and the fuse_uring_req_header i=
s
> >>> offset from the end of the buffer.
> >>>
> >>> To be backwards compatible, fuse uring still needs to support non-reg=
istered
> >>> buffers as well.
> >>>
> >>> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> >>> ---
> >>>  fs/fuse/dev_uring.c   | 200 +++++++++++++++++++++++++++++++++-------=
--
> >>>  fs/fuse/dev_uring_i.h |  27 +++++-
> >>>  2 files changed, 183 insertions(+), 44 deletions(-)
> >>>
> >>> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> >>> index c6b22b14b354..f501bc81f331 100644
> >>> --- a/fs/fuse/dev_uring.c
> >>> +++ b/fs/fuse/dev_uring.c
> >>>
> >>> +/*
> >>> + * Prepare fixed buffer for access. Sets up the payload iter and kma=
ps the
> >>> + * header.
> >>> + *
> >>> + * Callers must call fuse_uring_unmap_buffer() in the same scope to =
release the
> >>> + * header mapping.
> >>> + *
> >>> + * For non-fixed buffers, this is a no-op.
> >>> + */
> >>> +static int fuse_uring_map_buffer(struct fuse_ring_ent *ent)
> >>> +{
> >>> +     size_t header_size =3D sizeof(struct fuse_uring_req_header);
> >>> +     struct iov_iter iter;
> >>> +     struct page *header_page;
> >>> +     size_t count, start;
> >>> +     ssize_t copied;
> >>> +     int err;
> >>> +
> >>> +     if (!ent->fixed_buffer)
> >>> +             return 0;
> >>> +
> >>> +     err =3D io_uring_cmd_import_fixed_full(ITER_DEST, &iter, ent->c=
md, 0);
> >>
> >> This seems to be a rather expensive call, especially as it gets
> >> called twice (during submit and fetch).
> >> Wouldn't be there be a possibility to check if the user buffer changed
> >> and then keep the existing iter? I think Caleb had a similar idea
> >> in patch 1/8.
> >
> > I think the best approach is to get rid of the call entirely by
> > returning -EBUSY to the server if it tries unregistering the buffers
> > while a connection is still alive. Then we would just have to set this
> > up once at registration time, and use that for the lifetime of the
> > connection. The discussion about this with Pavel is in [1] - I'm
> > planning to do this as a separate follow-up.
> >
> > [1] https://lore.kernel.org/linux-fsdevel/9f0debb1-ce0e-4085-a3fe-0da7a=
8fd76a6@gmail.com/
> >
> >>
> >>> +     if (err)
> >>> +             return err;
> >>> +
> >>> +     count =3D iov_iter_count(&iter);
> >>> +     if (count < header_size || count & (PAGE_SIZE - 1))
> >>> +             return -EINVAL;
> >>
> >> || !PAGE_ALIGNED(count)) ?
> >
> > Nice, I didn't realize this macro existed. Thanks.
> >
> >>
> >>> +
> >>> +     /* Adjust the payload iter to protect the header from any overw=
rites */
> >>> +     ent->payload_iter =3D iter;
> >>> +     iov_iter_truncate(&ent->payload_iter, count - header_size);
> >>> +
> >>> +     /* Set up the headers */
> >>> +     iov_iter_advance(&iter, count - header_size);
> >>> +     copied =3D iov_iter_get_pages2(&iter, &header_page, header_size=
, 1, &start);
> >>
> >> The iter is later used for the payload, but I miss a reset? iov_iter_r=
evert()?
> >
> > This iter is separate from the payload iter and doesn't affect the
> > payload iter's values because the "ent->payload_iter =3D iter;"
> > assignment above shallow copies that out first.
> >
> >>
> >>> +     if (copied < header_size)
> >>> +             return -EFAULT;
> >>> +     ent->headers =3D kmap_local_page(header_page) + start;
> >>
> >> My plan for the alternative pinning patch (with io-uring) was to let t=
he
> >> header be shared by multiple entries. Current libfuse master handles
> >> a fixed page size buffer for the payload (prepared page pinning - I
> >> didn't expect I was blocked for 9 months on other work), missing is to
> >> share it between ring entries.
> >> I think this wouldn't work with registered buffer approach - it
> >> always needs one full page?
> >
> > I've been working on the patches for zero-copy and that has required
> > the design for registered buffers in this patch to change, namely that
> > the payload and the headers must be separated out. For v3, I have them
> > separate now.
> >>
> >> I would also like to discuss dynamic multiple payload sizes per queue.
> >> For example to have something like
> >>
> >> 256 x 4K
> >> 8 x 128K
> >> 4 x 1M
> >
> > I think zero-copy might obviate the need for this. The way I have it
> > right now, it uses sparse buffers for payloads, which prevents the
> > server from needing to allocate the 1M buffer per ent. I'm hoping to
> > send out the patches for this as part of v3 at the end of next week or
> > next next week.
> >
> > Thanks,
> > joanne
> >
> >>
> >> I think there are currently two ways to do that
> >>
> >> 1) Sort entries into pools
> >> 2) Sort buffers into pools and let entries use these. Here the header
> >> would be fixed and payload would come from a pool.
> >>
> >> With the appraoch to have payload and header in one buffer we couldn't
> >> use 2). Using 1) should be fine, though.
> >>
> >>>
> >>>  /*
> >>> @@ -1249,20 +1358,29 @@ static void fuse_uring_send_in_task(struct io=
_uring_cmd *cmd,
> >>>  {
> >>>       struct fuse_ring_ent *ent =3D uring_cmd_to_ring_ent(cmd);
> >>>       struct fuse_ring_queue *queue =3D ent->queue;
> >>> +     bool send_ent =3D true;
> >>>       int err;
> >>>
> >>> -     if (!(issue_flags & IO_URING_F_TASK_DEAD)) {
> >>> -             err =3D fuse_uring_prepare_send(ent, ent->fuse_req);
> >>> -             if (err) {
> >>> -                     if (!fuse_uring_get_next_fuse_req(ent, queue))
> >>> -                             return;
> >>> -                     err =3D 0;
> >>> -             }
> >>> -     } else {
> >>> -             err =3D -ECANCELED;
> >>> +     if (issue_flags & IO_URING_F_TASK_DEAD) {
> >>> +             fuse_uring_send(ent, cmd, -ECANCELED, issue_flags);
> >>> +             return;
> >>> +     }
> >>> +
> >>> +     err =3D fuse_uring_map_buffer(ent);
> >>> +     if (err) {
> >>> +             fuse_uring_req_end(ent, ent->fuse_req, err);
> >>> +             return;
> >>
> >> I think this needs to abort the connection now. There could be multipl=
e
> >> commands on the queue and they would be stuck now and there is no
> >> notification to fuse server either.
> >
> > This approach makes sense to me and makes things a bit simpler. I'll
> > add this to v3.
>
> This is a just heads up, while I'm testing sync FUSE_INIT I'm running
> in several issues. Part of it needs to be a re-send on -EGAIN and -EINTR
> in libfuse - had slipped through so far, but another is related to our
> page pinning. I just thought I can easy abort the connection when
> that fails, but that results in a double lock, because so far we
> assumed IO_URING_F_UNLOCKED in teardown context.
> I'm going to submit a patch to teardown in uring task context, so that
> we are sure about the flags.
>
> I.e. I think my suggestion to abort here would run into the same
> issue as below.
>
>
> [10375.669761] fuse: FUSE_IO_URING_CMD_REGISTER returned -4
> [10375.670632] fuse: FUSE_IO_URING_CMD_REGISTER failed err=3D-4
>
> [10375.671922] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [10375.672754] WARNING: possible recursive locking detected
> [10375.673577] 6.8.12+ #6 Tainted: G        W  O
> [10375.674377] --------------------------------------------
> [10375.675208] fuse-ring-0/7658 is trying to acquire lock:
> [10375.676022] ffff8881040910b0 (&ctx->uring_lock){+.+.}-{4:4}, at: io_ur=
ing_cmd_done+0x14f/0x210
> [10375.677335]
>                but task is already holding lock:
> [10375.678292] ffff8881040910b0 (&ctx->uring_lock){+.+.}-{4:4}, at: __x64=
_sys_io_uring_enter+0x68a/0xbf0
> [10375.679678]
>                other info that might help us debug this:
> [10375.680722]  Possible unsafe locking scenario:
>
> [10375.681692]        CPU0
> [10375.682156]        ----
> [10375.682633]   lock(&ctx->uring_lock);
> [10375.683260]   lock(&ctx->uring_lock);
> [10375.683879]
>                 *** DEADLOCK ***
>
> [10375.684916]  May be due to missing lock nesting notation
>
> [10375.685994] 1 lock held by fuse-ring-0/7658:
> [10375.686699]  #0: ffff8881040910b0 (&ctx->uring_lock){+.+.}-{4:4}, at: =
__x64_sys_io_uring_enter+0x68a/0xbf0
> [10375.688141]
>                stack backtrace:
> [10375.688923] CPU: 0 PID: 7658 Comm: fuse-ring-0 Tainted: G        W  O =
      6.8.12+ #6
> [10375.690150] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1=
.16.3-debian-1.16.3-2 04/01/2014
> [10375.691534] Call Trace:
> [10375.692019]  <TASK>
> [10375.692445]  dump_stack_lvl+0x66/0x90
> [10375.695219]  __lock_acquire+0x13b8/0x25c0
> [10375.695901]  lock_acquire+0xb7/0x290
> [10375.696507]  ? io_uring_cmd_done+0x14f/0x210
> [10375.697226]  ? __lock_acquire+0x459/0x25c0
> [10375.697913]  __mutex_lock+0x7d/0xae0
> [10375.698530]  ? io_uring_cmd_done+0x14f/0x210
> [10375.699251]  ? io_uring_cmd_done+0x14f/0x210
> [10375.699967]  ? lock_acquire+0xb7/0x290
> [10375.700606]  ? fuse_uring_stop_list_entries+0x1c2/0x280 [fuse]
> [10375.701508]  ? io_uring_cmd_done+0x14f/0x210
> [10375.702210]  ? lock_release+0x24b/0x390
> [10375.702862]  io_uring_cmd_done+0x14f/0x210
> [10375.703546]  fuse_uring_stop_list_entries+0x24f/0x280 [fuse]
> [10375.704439]  fuse_uring_stop_queues+0xf7/0x240 [fuse]
> [10375.705251]  fuse_abort_conn+0x3e6/0x3f0 [fuse]
> [10375.705998]  fuse_uring_cmd+0x8de/0xf40 [fuse]
> [10375.706742]  ? lock_acquired+0xb1/0x320
> [10375.707415]  io_uring_cmd+0x6b/0x170
> [10375.708080]  io_issue_sqe+0x4e/0x460
> [10375.708705]  io_submit_sqes+0x22e/0x710
> [10375.709356]  __x64_sys_io_uring_enter+0x696/0xbf0
> [10375.710109]  do_syscall_64+0x6a/0x130
> [10375.710743]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
> [10375.711541] RIP: 0033:0x7f31a073db95
> [10375.712160] Code: 00 00 00 44 89 d0 41 b9 08 00 00 00 83 c8 10 f6 87 d=
0 00 00 00 01 8b bf cc 00 00 00 44 0f 45 d0 45 31 c0 b8 aa 01 00 00 0f 05 <=
c3> 66 2e 0f 1f 84 00 00 00 00 00 41 83 e2 02 74 c2 f0 48 83 0c 24
> [10375.714772] RSP: 002b:00007f319a4f4c88 EFLAGS: 00000246 ORIG_RAX: 0000=
0000000001aa
> [10375.715946] RAX: ffffffffffffffda RBX: 00007f31992f5060 RCX: 00007f31a=
073db95
> [10375.717000] RDX: 0000000000000001 RSI: 0000000000000008 RDI: 000000000=
0000006
> [10375.718056] RBP: 00007f319a4f4d60 R08: 0000000000000000 R09: 000000000=
0000008
> [10375.719113] R10: 0000000000000001 R11: 0000000000000246 R12: 00007f319=
92f5000
> [10375.720162] R13: 00000fe63325ea00 R14: 0000000000000000 R15: 00007f319=
a4f4cd0
> [10375.721223]  </TASK>
>

Thanks for the update, Bernd!

>
> Thanks,
> Bernd
>

