Return-Path: <io-uring+bounces-9177-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1FC5B300AD
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 19:02:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9884F7A4E36
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 17:01:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D3F026FDA6;
	Thu, 21 Aug 2025 17:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Kcoa8Fpt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCCA2FB625
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 17:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755795751; cv=none; b=S7Pt90etd1dXQrIIH5WScIBkCJ09kimvMBIIeNjT96oru1PvL8RtykgK/W7MfMJ8qWjRapmlaIcjTDhYJr0OSwVk3ZggyQMEGiPzM8FaguRSge0vVYoBMQFg1kPlqxv38jSa5Jmggy8XwCK2qDHHU+Sldz1KvpSUBNJHG/A+b/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755795751; c=relaxed/simple;
	bh=MJFOXzkjtZLb7O8vPIDVjGkppH7We5ykolR8obeN8jE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=szW5F6y+CPeSLFQF9OKWxkawayGFENruQx/iC3twIOAPSdjm3FK00qN8YVtOORCeTh4a5WscYK0M+PiBcw6f26bWtXNDLpVWyEGvSJFBtjP4s6/JHYY0V3egfPAF0SbUeluVt3qS9KZgI27nKO524kGo8iUj9uMyo1dE9G4i9WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Kcoa8Fpt; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-24616371160so1263395ad.1
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 10:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1755795749; x=1756400549; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GOfHRGgdepZUoxPJh+Rvt4PGAAWpuGYGcJF+hpILaz0=;
        b=Kcoa8FptLVPCqDeeZAxzbR2ojXFAGCRillT+Nd51ox/NHIB+GeTMl1bkQSpVE/SiKB
         Qcb1syNroO4ePQP5xvA1eySt5Ba2cT0NodyNZsqvR8KrBZjYWXFDrbDtjirA9ZrjGkB0
         Y6WnsOCbnLUCGRZjRt5iCWWnlsXsaKa59RwYYuul1ETaamnSyh4iOvlDeKyIBWOybh/T
         U1Ndvs7NdoCdjGRDJFxSjtZwMAalYucKwjxmtnrJmwVt3elJFGlGZ7nD7lH4KNOiibMH
         iRKqsfuyCbLXrELXVbQ6vUPRtX1jSPNN2ndnO6Q4l8TLb+KvzJIqxNsZCa1D4bls+gjC
         PgyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755795749; x=1756400549;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GOfHRGgdepZUoxPJh+Rvt4PGAAWpuGYGcJF+hpILaz0=;
        b=vQsK6dHtdOrtz6rmfa4FIJDreHl92a1b8IR1KbLjd0DQqO834i4m7rc2i4dGI0eTzD
         peI5+e8VRmDpbz62GQPb70Pqd+iQUrIRbwK6fN7fiTuBqtc7i58HLvDYhfE4nD4NTawQ
         2KlP4+9w7VUONhYIuXvTAX3nbmvsM626QdzFe74znNddx/nZx/hTLR7JG/A3Rs4rqWU2
         vrxAmm241qTGHb/EikIWFkEw1BjoQ1ka7H0SWq/zBNIAzqCpjVlUVMpobYTOPBlaYeGl
         YhszGcjkOvHW0iugadOwzM0r0gVTSqSiVa33qAwu+iWsnyhx8euIJD57Vvh14Uf/9Xg7
         ok4g==
X-Gm-Message-State: AOJu0Yx/obX5APsIh1MCF1kIp4onKvKHGzpcWrCb4muTj9FVoMZhk4VK
	p1sJSNQMBDfKEBw4IQj6xTj/kVrOXPi9I/ZEyS6ckuhg1GgrDzjWnGAKCtmOIi55jXvJUq/VNrv
	ymonkSKGdtvW3qzuVhAqUn7ilwvvidfMqvrJyiqhHfA==
X-Gm-Gg: ASbGncsAVG4kLlOSBPjjpvql0ueqAkZDeRZuQSCq6LAguIOMHn7ZpwI+aI1lM7q9k/j
	uHSzFs/dNjRFqDMbElql8aHoH10+vFk2LAoH8/PGFFVLNuf1TMmMX9x/C5AgHWvo8kjLuGXTXkH
	tFJKhQ3c/BnQElmJpbc4417ung5/YLpNpxfEjlCHCpO5sm0GjI9tykgTausszwJ6AG4eJbJxFBF
	o7hYs4dmZnwQGzG5Xw=
X-Google-Smtp-Source: AGHT+IF7GBBQherP54ExqpJrH/hYFvtYwLpjy/DUXx8UspfapVmzGmqU+srgLgjYrVCz28kiBD0zP1MrcslKgjLg6l8=
X-Received: by 2002:a17:902:e888:b0:240:8717:e393 with SMTP id
 d9443c01a7336-2462ee8e35dmr696785ad.5.1755795748392; Thu, 21 Aug 2025
 10:02:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821141957.680570-1-axboe@kernel.dk>
In-Reply-To: <20250821141957.680570-1-axboe@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 21 Aug 2025 10:02:16 -0700
X-Gm-Features: Ac12FXyHHuMzkNeuakIIpn1EeOT7UT6WF0qwFGQphZ0Pi2K-vCirXOp30gdfZ3U
Message-ID: <CADUfDZragMLiHkkw0Y+HAeEWZX8vBpPpWjgwdai8SjCuiLw0gQ@mail.gmail.com>
Subject: Re: [PATCHSET v2 0/8] Add support for mixed sized CQEs
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2025 at 7:28=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> Hi,
>
> Currently io_uring supports two modes for CQEs:
>
> 1) The standard mode, where 16b CQEs are used
> 2) Setting IORING_SETUP_CQE32, which makes all CQEs posted 32b
>
> Certain features need to pass more information back than just a single
> 32-bit res field, and hence mandate the use of CQE32 to be able to work.
> Examples of that include passthrough or other uses of ->uring_cmd() like
> socket option getting and setting, including timestamps.
>
> This patchset adds support for IORING_SETUP_CQE_MIXED, which allows
> posting both 16b and 32b CQEs on the same CQ ring. The idea here is that
> we need not waste twice the space for CQ rings, or use twice the space
> per CQE posted, if only some of the CQEs posted require the use of 32b
> CQEs. On a ring setup in CQE mixed mode, 32b posted CQEs will have
> IORING_CQE_F_32 set in cqe->flags to tell the application (or liburing)
> about this fact.

This makes a lot of sense. Have you considered something analogous for
SQEs? Requiring all SQEs to be 128 bytes when an io_uring is used for
a mix of 64-byte and 128-byte SQEs also wastes memory, probably even
more since SQEs are 4x larger than CQEs.

Best,
Caleb

>
> This is mostly trivial to support, with the corner case being attempting
> to post a 32b CQE when the ring is a single 16b CQE away from wrapping.
> As CQEs must be contigious in memory, that's simply not possible. The
> solution taken by this patchset is to add a special CQE type, which has
> IORING_CQE_F_SKIP set. This is a pad/nop CQE, which should simply be
> ignored, as it carries no information and serves no other purpose than
> to re-align the posted CQEs for ring wrap.
>
> If used with liburing, then both the 32b vs 16b postings and the skip
> are transparent.
>
> liburing support and a few basic test cases can be found here:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/liburing.git/log/?h=
=3Dcqe-mixed
>
> including man page updates for the newly added setup and CQE flags, and
> the patches posted here can also be found at:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/log=
/?h=3Dio_uring-cqe-mix
>
> Patch 1 is just a prep patch, and patch 2 adds the cqe flags so that the
> core can be adapted before support is actually there. Patches 3 and 4
> are exactly that, and patch 5 finally adds support for the mixed mode.
> Patch 6 adds support for NOP testing of this, and patches 7/8 allow
> IORING_SETUP_CQE_MIXED for uring_cmd/zcrx which previously required
> IORING_SETUP_CQE32 to work.
>
>  Documentation/networking/iou-zcrx.rst |  2 +-
>  include/linux/io_uring_types.h        |  6 ---
>  include/trace/events/io_uring.h       |  4 +-
>  include/uapi/linux/io_uring.h         | 17 ++++++
>  io_uring/cmd_net.c                    |  3 +-
>  io_uring/fdinfo.c                     | 22 ++++----
>  io_uring/io_uring.c                   | 78 +++++++++++++++++++++------
>  io_uring/io_uring.h                   | 49 ++++++++++++-----
>  io_uring/nop.c                        | 17 +++++-
>  io_uring/register.c                   |  3 +-
>  io_uring/uring_cmd.c                  |  2 +-
>  io_uring/zcrx.c                       |  5 +-
>  12 files changed, 152 insertions(+), 56 deletions(-)
>
> Changes since v1:
> - Various little cleanups
> - Rebase on for-6.18/io_uring
>
> --
> Jens Axboe
>
>

