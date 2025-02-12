Return-Path: <io-uring+bounces-6395-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ED5CA3332E
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 00:07:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 955633A71A5
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 23:07:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F37EF20459F;
	Wed, 12 Feb 2025 23:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="N0NXUrXm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12B51FF7D8
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 23:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739401664; cv=none; b=cdE6nRLwvw0AxQRF6PDYkFjib26dxI/iwzIfwmLMOjur4QHkd5jQwWBxdNkMhPfpfMvOy/QnEniHjhbHe/j8prliFt7OGfbDGW+YP54HbF2B6zwC8OgZY1cQQgfhHTFFobE58g16fPozDpLPgRc2Y4sWc1wQc62K6VslpvjbztA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739401664; c=relaxed/simple;
	bh=sSjQOJNXF0LFrxiIWxeimjabbT4SnO3Og/iVcBr3eRg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mzxwLMX+4HMGnrzi62TGTroWmwZs8RA32JcjQeuj41bBVRtbwapkL5Q+DD3yBfj7/2+oPN3h7bIH2KuUCbaBhIKvQfHke6XXqezLAsJyJMN9gJjY2iW8nAmTAEhKNgEJMFitzTxP9x/6phKzm5+FF+8nw2txt2vjh7NOVuF2cGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=N0NXUrXm; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-220c3e25658so489085ad.1
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 15:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739401662; x=1740006462; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sSjQOJNXF0LFrxiIWxeimjabbT4SnO3Og/iVcBr3eRg=;
        b=N0NXUrXmv0Dyew2vxdZ3LWqCDVB0jviFiw9XTG8PMxX9A4lbscVZPkVxZx5mhzAAFz
         WOMXC9dUf32gpUWSp/L0qXsbR3THFZXE28GMs1gQPKTsTfeOJ2abrgcWJnpx2wm17rYJ
         aHZtyAB7JT/VamCGkVk/9FwmSAhsdlBvbISDGfikTHDC8GsOr7kru1PpVXAiLxWZsATj
         lqC0E37dXvsMguVJMXg6HL1Q/y8etFy+lyOpJDnKuFRReol6VBeT7FEd/v3OLEyzBhAQ
         dsn9Qtzyo6Iy+F1LbhH92ot0XtDUw9H/Y1XqIqpEqLSKp7qhhvH/yuWo+1DcfBDV5fEW
         icYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739401662; x=1740006462;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sSjQOJNXF0LFrxiIWxeimjabbT4SnO3Og/iVcBr3eRg=;
        b=ZuT5YSimg9hev5+NMYhmmDM2kr6eVTvTmdONBfnhPVhsWiXinHgpnrTRmvJnDRU3+W
         Q3QUf/cncJSkWsMXo1tlT5ztR8LL5FaZznEN0xXECejdrpE1t2oDgQ4JHITl7ZTYq+DS
         BhLAK98WgJDYKmP8HBHQYC9PNuGXislhUt2Hu8s809vbzg1FbNbUxK8CxAK+5ZZJvmhU
         D+Kh/tRljyYuh1WRak1nIWa+8uJ1aJeKX1qBnEbDfFQardWKdFdelYsjiZum+JnkGa9J
         +LxDJpDsQbrf6pPND/gdjHZ3BkgMZ6yl1Ah+Kt3uzclYoGsrS2/m1yrOzZ0/VI269ow8
         jn8w==
X-Forwarded-Encrypted: i=1; AJvYcCW56+Y7CVlsbk9b5czQrv6ORYT8Y5p8Kktz5KMc/l5fo6PZHfIO+8sNuywKOKQkEtvQg0NzDTaubg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxabYeAdzflPrnoz2ooXFUpp0r756d6Y5VcdbWQCRNfUENNU5Xi
	KnXPolZJRnVTfJaFTT9yNL6Tmxw4l2GCczw8Uc498giJk40IdWXxNXsn+3/gFqJrB0qcCSaNsTv
	fLrFZJiH2W1v1YRYCW4WaejMKrsl7RJtj8dPNkQ==
X-Gm-Gg: ASbGncspxevXQwo8CkJHWazzcMeNiPjivvEOG9y94jCiHD/cyAXJw8rPZQGptF9un0B
	HB/9sUr3HOxIr/6epeF3Qqpb2x6wDp7ehZ4N0wPELCp9ta+1AehZAeMqNilNA5FKXff9IUPg=
X-Google-Smtp-Source: AGHT+IH7VLdWjihMAx9WM/FmERYIOKQfyQOAysSAO0oWnBRS9Mg564AjYVOY7rZU4KxS5rVgnJFB538dbW+pTmgtmDg=
X-Received: by 2002:a17:902:ea02:b0:215:3862:603a with SMTP id
 d9443c01a7336-220bbb465f2mr32184595ad.10.1739401662121; Wed, 12 Feb 2025
 15:07:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250212204546.3751645-1-csander@purestorage.com>
 <401f9f7a-b813-43b0-b97f-0165072e2758@kernel.dk> <CADUfDZqK9+GLsRSdFVd47eZTsz863B3m16GtHc+Buiqdr7Jttg@mail.gmail.com>
 <999d55a6-b039-4a76-b0f6-3d055e91fd48@kernel.dk>
In-Reply-To: <999d55a6-b039-4a76-b0f6-3d055e91fd48@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 12 Feb 2025 15:07:30 -0800
X-Gm-Features: AWEUYZk9IUMPS2CIZxWWriPyPqCaap2wzuNv8zszbmWESSPhiPRjVLDc5n1Bxl4
Message-ID: <CADUfDZrjDF+xH1F98mMdR6brnPMARZ64yomfTYZ=5NStFM5osQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] uring_cmd SQE corruptions
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Riley Thomasson <riley@purestorage.com>, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 12, 2025 at 2:39=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2/12/25 2:54 PM, Caleb Sander wrote:
> > On Wed, Feb 12, 2025 at 12:55?PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 2/12/25 1:45 PM, Caleb Sander Mateos wrote:
> >>> In our application issuing NVMe passthru commands, we have observed
> >>> nvme_uring_cmd fields being corrupted between when userspace initiali=
zes
> >>> the io_uring SQE and when nvme_uring_cmd_io() processes it.
> >>>
> >>> We hypothesized that the uring_cmd's were executing asynchronously af=
ter
> >>> the io_uring_enter() syscall returned, yet were still reading the SQE=
 in
> >>> the userspace-mapped SQ. Since io_uring_enter() had already increment=
ed
> >>> the SQ head index, userspace reused the SQ slot for a new SQE once th=
e
> >>> SQ wrapped around to it.
> >>>
> >>> We confirmed this hypothesis by "poisoning" all SQEs up to the SQ hea=
d
> >>> index in userspace upon return from io_uring_enter(). By overwriting =
the
> >>> nvme_uring_cmd nsid field with a known garbage value, we were able to
> >>> trigger the err message in nvme_validate_passthru_nsid(), which logge=
d
> >>> the garbage nsid value.
> >>>
> >>> The issue is caused by commit 5eff57fa9f3a ("io_uring/uring_cmd: defe=
r
> >>> SQE copying until it's needed"). With this commit reverted, the poiso=
ned
> >>> values in the SQEs are no longer seen by nvme_uring_cmd_io().
> >>>
> >>> Prior to the commit, each uring_cmd SQE was unconditionally memcpy()e=
d
> >>> to async_data at prep time. The commit moved this memcpy() to 2 cases
> >>> when the request goes async:
> >>> - If REQ_F_FORCE_ASYNC is set to force the initial issue to go async
> >>> - If ->uring_cmd() returns -EAGAIN in the initial non-blocking issue
> >>>
> >>> This patch set fixes a bug in the EAGAIN case where the uring_cmd's s=
qe
> >>> pointer is not updated to point to async_data after the memcpy(),
> >>> as it correctly is in the REQ_F_FORCE_ASYNC case.
> >>>
> >>> However, uring_cmd's can be issued async in other cases not enumerate=
d
> >>> by 5eff57fa9f3a, also leading to SQE corruption. These include reques=
ts
> >>> besides the first in a linked chain, which are only issued once prior
> >>> requests complete. Requests waiting for a drain to complete would als=
o
> >>> be initially issued async.
> >>>
> >>> While it's probably possible for io_uring_cmd_prep_setup() to check f=
or
> >>> each of these cases and avoid deferring the SQE memcpy(), we feel it
> >>> might be safer to revert 5eff57fa9f3a to avoid the corruption risk.
> >>> As discussed recently in regard to the ublk zero-copy patches[1], new
> >>> async paths added in the future could break these delicate assumption=
s.
> >>
> >> I don't think it's particularly delicate - did you manage to catch the
> >> case queueing a request for async execution where the sqe wasn't alrea=
dy
> >> copied? I did take a quick look after our out-of-band conversation, an=
d
> >> the only missing bit I immediately spotted is using SQPOLL. But I don'=
t
> >> think you're using that, right? And in any case, lifetime of SQEs with
> >> SQPOLL is the duration of the request anyway, so should not pose any
> >> risk of overwriting SQEs. But I do think the code should copy for that
> >> case too, just to avoid it being a harder-to-use thing than it should
> >> be.
> >
> > Yes, even with the EAGAIN case fixed, nvme_validate_passthru_nsid() is
> > still catching the poisoned nsids. However, the log lines now come
> > from the application thread rather than the iou-wrk thread.
> > Indeed, we are not using SQPOLL. But we are using IOSQE_SQE_GROUP from
> > Ming's SQE group patch set[1]. Like IOSQE_IO_LINK, subsequent
> > operations in a group are issued only once the first completes. The
> > first operation in the group is a UBLK_IO_PROVIDE_IO_BUF from Ming's
> > other patch set[2], which should complete synchronously. The
> > completion should be processed in __io_submit_flush_completions() ->
> > io_free_batch_list() and queue the remaining grouped operations to be
> > issued in task work. And all the pending task work should be processed
> > during io_uring_enter()'s return to userspace.
> > But some NVMe passthru operations must be going async because they are
> > observing the poisoned values the application thread writes into the
> > io_uring SQEs after io_uring_enter() returns. We don't yet have an
> > explanation for how they end up being issued async; ftrace shows that
> > in the typical case, all the NVMe passthru operations in the group are
> > issued during task work before io_uring_enter() returns to userspace.
> > Perhaps a pending signal could short-circuit the task work processing?
>
> I think it'd be a good idea to move testing to the newer patchset, as
> the sqe grouping was never really fully vetted or included. It's not
> impossible that it's a side effect of that, even though it very well
> cold be a generic issue that exists already without those patches. In
> any case, that'd move us all to a closer-to-upstream test base, without
> having older patches that aren't upstream in the mix.

Yes, we completely agree. We are working on incorporating Keith's
patchset now. It looks like there is still an open question about
whether userspace will need to enforce ordering between the requests
(either using linked operations or waiting for completions before
submitting the subsequent operations).
Ming's "grouped" requests seem to be based on linked requests, which
is why I suspect we would hit the same SQE corruption upstream if we
were using linked requests.

>
> How are the rings setup for what you're testing? I'm specifically
> thinking of the task_work related flags. Is it using DEFER_TASKRUN, or
> is it using the older signal style task_work?

The io_uring is set up with only the IORING_SETUP_SQE128 and
IORING_SETUP_CQE32 flags, so they are probably using the older task
work implementation. There's no particular reason not to use
IORING_SETUP_DEFER_TASKRUN, we just haven't tried it out yet.

Thanks,
Caleb

>
> --
> Jens Axboe

