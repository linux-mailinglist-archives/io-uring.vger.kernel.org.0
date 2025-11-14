Return-Path: <io-uring+bounces-10645-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C9E1C5FA53
	for <lists+io-uring@lfdr.de>; Sat, 15 Nov 2025 01:00:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2420A4E2AD4
	for <lists+io-uring@lfdr.de>; Sat, 15 Nov 2025 00:00:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81AC530F81A;
	Sat, 15 Nov 2025 00:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HhrVLHzT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5BE30F53F
	for <io-uring@vger.kernel.org>; Sat, 15 Nov 2025 00:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763164808; cv=none; b=VoVCQ610ZGQst2NlGa43uabEwOdcwcKbNL3G+7YzyRFKpage+4K5OjbY55NGwEzosTEXUuduKtxMm9cfA4lQt+ZiFDrVmb/azulV/JCeHOYxjTEr4+OAJ3mwGZtsTwLcx9cgrrXCj357CycQTKlKM1YJ1F9na9i8NMN+D7lwQcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763164808; c=relaxed/simple;
	bh=eUj6MJne0yoSVBbdK6TfheRVbwmwWQqzr8OkId+ZdLk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b2yXYOa8X7FB5S6qrJMY79wWujhczGTT04dAOKDqclPZBOQPBNG6FzWfOEFuPnHimOOcoyb9hU6ecN5iizuiOpvDg/EhY5U4uyznX3PXM+VodGikUX5VAq0w59XITbXt5CNgB8AnSI1vHax0kr9m/ZGd5lS1Zmq1Ofp4tS7VmZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HhrVLHzT; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4e88ed3a132so27584711cf.0
        for <io-uring@vger.kernel.org>; Fri, 14 Nov 2025 16:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763164803; x=1763769603; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qGbzfgmT3B3HxmKWif+aRE4qTK2l+Ffa1Yg6PfdTFSc=;
        b=HhrVLHzTt9Jf6lADk1vcuCzOWct7rT/ge5XE9kC5fo1d8lYduzG9U1lwjU1E8zrBkY
         /myPxKAbZIPW3NBX5ompSQnOMHSbTH/Uw7Vrp5hVq1FEX7lPp6bNhEBo8rH57/WT5tkm
         +GacyqG5TwS6uIJzD+Rt3XZFqfQ1YtcT0FY3yM6d2EWxChr9zqSt89UdQVGy+6GcvxUu
         McYZ5r15p1utyFw6zVBALELzve3+M2PlH2sBqaYojySaqfdg8V3dRT64GI27RWqrw5t+
         TsbftT1r0rHAY1Men+4k6fNjBm3sbi2O3/z4sj6R5J5S8i69WMXAJ2siLhHpJQWQX34N
         vxWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763164803; x=1763769603;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qGbzfgmT3B3HxmKWif+aRE4qTK2l+Ffa1Yg6PfdTFSc=;
        b=P9ELbmraOlnzbF7d7nWZX3rVVPShFtZ/Z8zbdyvcxTOJpSGT3jTa0HEISicMM3SbXb
         qxJR8FtZPCzWc1htCi440/JWzMHKqqIPqG8bWJcPbx8DGRjt4U+GqRoq4ZBx0nzbIUSX
         vroICaOdDgwvlVlkIdPjXq23npKiq1DHS71tIA74imSwPB8YS2DLTQU52f9Wa3/LLBOP
         mEQo0FRK+iUak4xnsUQ6CqwKfNVNbYiBrCR0jYy2NqmL52sxmfzQlxOs720PtDu0nUA+
         D26ZPql070rF5TS88dP5C7ZR9JFpXtDkBJIqUNEq/JNaykOOmzgRoqilw66ogx6BK44W
         7yKg==
X-Forwarded-Encrypted: i=1; AJvYcCVjc6VCI/keb/kjS+bWyiYNJPK+YrwkhsH3XMKEd4QpKWny9D8Fh2OdWSK02+hozWpbbnbThkvupQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7jz2bJuzdMUoTl3th/1jNucwOtcABJwujrgQIaTAWs9vMLG56
	kyNQ+iRZqeHxU5pfVGFHhZWuXGlQLpZoh1x3MWqIg3mS22YL/+uZJbXR8+YZG2faQqerAwF3BWV
	DWr4p8IISzpPYZ+/Xm6EwBeEYQco9iT8=
X-Gm-Gg: ASbGncupL4noDeBC2mUwVioFZABxDU7yqJ9yAaHH6U18isxyAT48i+s94IJXRxy646F
	LnoNcsbMrzXAmBU8fSL/eXgkjoZNi2YJp3LDq5wCLPf3/tPumaCbdups73IM/T3abm5AfD975Ej
	8w7TMONau60NaugC7mmqPXj2jlGk2Vd6lqrej23yWlwHpRygAlnLZx+KGO4FjUjDVZwunsVq1Zl
	KUhcsq/1UC6ibFf7hVOdTsfjTqCwUGgAMdEk9DX+Hx8QcPb2Q0hOq9cYIU=
X-Google-Smtp-Source: AGHT+IFuXiTIheMG3+4gmC1q+oV5Yb6/nZ5Dj/15NZpvhB9K3y74K4FlHz1GdbdRouCeDasOvS1IpwzwFM/b3I71HzM=
X-Received: by 2002:a05:622a:1818:b0:4b7:ad20:9393 with SMTP id
 d75a77b69052e-4edf206c3d3mr76294551cf.4.1763164802938; Fri, 14 Nov 2025
 16:00:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
In-Reply-To: <20251027222808.2332692-1-joannelkoong@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 14 Nov 2025 15:59:52 -0800
X-Gm-Features: AWmQ_bmRlXebUAoVOMZ3KYImfI2XMgqsAutH5pwXFp2qmwPO8Oe22i50fOp_O8A
Message-ID: <CAJnrk1bG7fAX8MfwJL_D2jzMNv5Rj9=1cgQvVpqC1=mGaeAwOg@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] fuse: support io-uring registered buffers
To: miklos@szeredi.hu, axboe@kernel.dk
Cc: linux-fsdevel@vger.kernel.org, bschubert@ddn.com, asml.silence@gmail.com, 
	io-uring@vger.kernel.org, xiaobing.li@samsung.com, csander@purestorage.com, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2025 at 3:29=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> This patchset adds fuse support for io-uring registered buffers.
> Daemons may register buffers ahead of time, which will eliminate the over=
head
> of pinning/unpinning user pages and translating virtual addresses for eve=
ry
> server-kernel interaction.

Registered buffers helps with the I/O overhead, but there's still
significant memory waste within each buffer. Each entry in a queue
allocates a dedicated buffer of at least 1 MB (for some performant
servers like passthrough_hp, each entry's buffer is 4 MB, which adds
up (eg with the libfuse default queue depth of 8 on a 64-core machine,
that's 2 GB of buffers per fuse connection)) but most of this space
goes unused. In practice, entries on a queue will rarely consume their
full buffer capacity simultaneously.

Instead of using registered buffers, I think it's better if we go with
a kernel managed ring buffer. It'll have the same advantages in
reducing I/O overhead as registered buffers but also give us
optionality later on to support IORING_CQE_F_BUF_MORE for incremental
buffer consumption or add multiple different-sized ring buffer pools
(eg for large payloads vs small payloads, which is also something we
have to differentiate between for zero-copy), whereas we would have no
way of supporting that with registered buffers.

For v3, I'm going to go this direction.

Thanks,
Joanne

>
> The main logic for fuse registered buffers is in the last patch (patch 8/=
8).
> Patch 1/8 adds an io_uring api for fetching the registered buffer and pat=
ches
> (2-7)/8 refactors the fuse io_uring code, which additionally will make ad=
ding
> in the logic for registered buffers neater.
>
> The libfuse changes can be found in this branch:
> https://github.com/joannekoong/libfuse/tree/registered_buffers. The libfu=
se
> implementation first tries registered buffers during registration and if =
this
> fails, will retry with non-registered buffers. This prevents having to ad=
d a
> new init flag (but does have the downside of printing dmesg errors for th=
e
> failed registrations when trying the registered buffers). If using regist=
ered
> buffers and the daemon for whatever reason unregisters the buffers midway
> through, then this will sever server-kernel communication. Libfuse will n=
ever
> do this. Libfuse will only unregister the buffers when the entire session=
 is
> being destroyed.
>
> Benchmarks will be run and posted.
>
> Thanks,
> Joanne
>
> v1: https://lore.kernel.org/linux-fsdevel/20251022202021.3649586-1-joanne=
lkoong@gmail.com/
> v1 -> v2:
> * Add io_uring_cmd_import_fixed_full() patch
> * Construct iter using io_uring_cmd_import_fixed_full() per cmd instead o=
f recyling
>   iters.
> * Kmap the header instead of using bvec iter for iterating/copying. This =
makes
>   the code easier to read.
>
> Joanne Koong (8):
>   io_uring/uring_cmd: add io_uring_cmd_import_fixed_full()
>   fuse: refactor io-uring logic for getting next fuse request
>   fuse: refactor io-uring header copying to ring
>   fuse: refactor io-uring header copying from ring
>   fuse: use enum types for header copying
>   fuse: add user_ prefix to userspace headers and payload fields
>   fuse: refactor setting up copy state for payload copying
>   fuse: support io-uring registered buffers
>
>  fs/fuse/dev_uring.c          | 366 +++++++++++++++++++++++++----------
>  fs/fuse/dev_uring_i.h        |  27 ++-
>  include/linux/io_uring/cmd.h |   3 +
>  io_uring/rsrc.c              |  14 ++
>  io_uring/rsrc.h              |   2 +
>  io_uring/uring_cmd.c         |  13 ++
>  6 files changed, 316 insertions(+), 109 deletions(-)
>
> --
> 2.47.3
>

