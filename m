Return-Path: <io-uring+bounces-8969-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 63943B27D90
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 11:54:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E4A43A8ED6
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 09:52:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEB8A2FC86D;
	Fri, 15 Aug 2025 09:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AN5wKq9r"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D592E2F1E;
	Fri, 15 Aug 2025 09:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755251553; cv=none; b=sea620NXouhc03sn5yoUxcYA45dH9I+uWfPDz584ovmLph/ZeO1GGRmhciwfRDmT32fBC8lLsUejcHHqnBoupHXn6/B7Nn0R1r4rMU+RM5k/UvorYxN226eIPaXrMtgvfCtjUBA3UAR8J1IDArcU0smdxhr5Axurtt8HKIbVWZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755251553; c=relaxed/simple;
	bh=rK0LrA4zSH9O3dZ4jH9jEs9yueXGcZLsdHBrnZIcYuU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FDqiUorOb0kHoHR2C54RgsHPUdG+bffbsuXH4e9OhAkzoSep0Qce2oXSHuYpOh98CsxYNnc9wFnUKx9zHbXeTjotoGVa6/IRYl3X7qLjMicXtVW1DfUKBCWFNmqRMzINfAKVORtgw7rI7P9v3Tusft7WKhZ6NdWwVzVTy51nmxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AN5wKq9r; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-618690a80e8so4161396a12.1;
        Fri, 15 Aug 2025 02:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755251550; x=1755856350; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AnpDR0b7uzGMP+NK7SOaQ07XY0U63GM3V7Y+bWzIhIs=;
        b=AN5wKq9r+NhixE6OTAk04unDPWlwVs5o6F6NewRNNC8Oji7ZVijlp+m1ZRAgcgvmw3
         uvzeeDwOOVDnMoy5A85nUyERkHTudH1jUXRzDaC1lOVZNBB/7c/y05oQDi6lFLFnTVdA
         jkDroWZUEr+xXJxQXK8+ljIQyBNtAiQpl8FOU+3+IqE4SAM9C+rLkoJxL4WTPfWP3Xj8
         TKUARQbdru0ImxDOw81es1HcVDaWLsWsnrz4C4e/uLIXc988eoSDwiuOK/pMkCo2KnCI
         zHR8bROR35vHQFqBW5dw2AqLbDuKdaoCdW0pxCp9uKS6UxDtSMs/R4UgH186Idh3KvZh
         K+2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755251550; x=1755856350;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AnpDR0b7uzGMP+NK7SOaQ07XY0U63GM3V7Y+bWzIhIs=;
        b=GUW1oVKJDuC3cl0yFxOGEwu3foszRBiSu7I57/zwLOHg+v8IjHiRlQNTVyOd6UtXoH
         +Nz+QzQz7Tcwp6hYinvr371EyC+FeocjwkSS/fyHsd/c7tiB3hr7JkrAUZjELOaDCaxm
         TqPfHOiNKKCLMEev5jVbgKr3n11VeLa8J2T6VuySBn52ryvVOzrrrBf+6G505iouZAeX
         YPzzangW8dm3yooLJGem+L+KNWk7438cBGINjgNOjCUQ7fNnlr4Z6ZbYcYyuyhcgOQPG
         qexTCy7SQnjGGtiWqeWSkNbnZ0DdqGB5my6FZQFqhOzh8aADkt/KRaLok8vWot5kPQs9
         aTyQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/5xmWQIgDMPQacg4SnDjLMUoswmQHWWgy25aVOun5lUsi8KuZL5exjbFrBPs3TxaQJdlI4kBrS0Dl@vger.kernel.org, AJvYcCXEtCJ9ynepsM6HFziNjPOT1krSApeGzk5MZsDUJKn+89Qb5CmYEty7mg0439lCPwBcEnull6AazH0P9do6@vger.kernel.org
X-Gm-Message-State: AOJu0YyfHcLrALRdd3fF4FidFmbB+CMB8hEAWplZSsxQdDK17ey9bnr1
	2IwdEvArqe3K+vpR92BEINz2GPUW3PGWdng1A0KgQvuTF0zvoP62fjPI0a/J24d7KkkzfFNqj+1
	5P2fEl4Jq9DKKUABIVLBifzJ7wb7vYwY=
X-Gm-Gg: ASbGncvd83oRSW+pu3ciQMkdcseRapzcJ4ixFQBAkppEJA+ASjVDKCcxCxEhpupNnhK
	XhJ5esZk61NJkfjWf0yc9nFFL03wESMCl+zzq/F5lRN5qnJBDAgc9MoRfTrvKzMFdhnTDywzUll
	GVuOojtq2xRrc9uDxk1uUA7b7+/FrEMxlIOHHadd1merXWKjVurGNkNL6rIKCCatj1SR9JemLOp
	Jr21Xo=
X-Google-Smtp-Source: AGHT+IExSbuXWYH0j7gS9fP+6TCMuhSbfMKdNcI/x10kAMTAzTZXZv4tZoCmn7/tNiOxDS9H61lK6BRFyy6hdMIBTYY=
X-Received: by 2002:a05:6402:1941:b0:615:a5f0:2704 with SMTP id
 4fb4d7f45d1cf-618aed27465mr1306756a12.17.1755251549937; Fri, 15 Aug 2025
 02:52:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250814235431.995876-1-tahbertschinger@gmail.com>
In-Reply-To: <20250814235431.995876-1-tahbertschinger@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 15 Aug 2025 11:52:18 +0200
X-Gm-Features: Ac12FXzLUFABMGMXFMpZDhNVxn8oRYBasH8TVJRvOD796bRN0oySsL2R8qX35As
Message-ID: <CAOQ4uxij17qNiTq6Gjy0Q_aOv8-k9ggsZ3vFA1Uz-tw-gS7xxQ@mail.gmail.com>
Subject: Re: [PATCHSET RFC 0/6] add support for name_to, open_by_handle_at(2)
 to io_uring
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 15, 2025 at 1:50=E2=80=AFAM Thomas Bertschinger
<tahbertschinger@gmail.com> wrote:
>
> This series adds support for name_to_handle_at() and open_by_handle_at()
> to io_uring. The idea is for these opcodes to be useful for userspace
> NFS servers that want to use io_uring.
>
> name_to_handle_at()
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Support for name_to_handle_at() is added in patches 1 and 2.
>
> In order to do a non-blocking name_to_handle_at(), a new helper
> do_name_to_handle_at() is created that takes a lookup_flags argument.
>
> This is to support non-blocking lookup when called with
> IO_URING_F_NONBLOCK--user_path_at() will be called with LOOKUP_CACHED
> in that case.
>
> Aside from the lookup, I don't think there is anything else that
> do_name_to_handle_at() does that would be a problem in the non-blocking
> case. There is a GFP_KERNEL allocation:
>
> do_name_to_handle_at()
>   -> do_path_to_handle()
>     -> kzalloc(..., GFP_KERNEL)
>
> But I think that's OK? Let me know if there's anything else I'm
> missing...
>
> open_by_handle_at()
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Patch 3 is a fixup to fhandle.c:do_handle_open() that (I believe) fixes
> a bug and can exist independently of this series, but it fits in with
> these changes so I'm including it here.
>
> Support for open_by_handle_at() is added in patches 4 - 6.
>
> A helper __do_handle_open() is created that does the file open without
> installing a file descriptor for it. This is needed because io_uring
> needs to decide between using a file descriptor or a fixed file.
>
> No attempt is made to support a non-blocking open_by_handle_at()--the
> attempt is always immediately returned with -EAGAIN if
> IO_URING_F_NONBLOCK is set.
>
> This isn't ideal and it would be nice to add support for non-blocking
> open by handle in the future. This would presumably require updates to
> the ->encode_fh() implementation for filesystems that want to
> support this.

Correction: ->encode_fh() is for name_to_handle()
You want to say that ->fh_to_dentry() need to support cached lookup,
but FWIW, the blocking code is more likely to come from the
lookup in exportfs_decode_fh_raw() =3D> ... reconnect_one()
not from the filesystem code.

The fs would "only" need to be taught to return an alias to a
cached inode and generic code would "only" need to be taught
to give up on a disconnected dir dentry.

Doesn't sound too hard (famous last words).

Thanks,
Amir.

>
> I see that lack of support for non-blocking operation was a dealbreaker
> for adding getdents to io_uring previously:
>
> https://lore.kernel.org/io-uring/20230428050640.GA1969623@dread.disaster.=
area/
>
> On the other hand, AFAICT, support for openat() was originally added in
> 15b71abe7b52 (io_uring: add support for IORING_OP_OPENAT) without a non-
> blocking lookup, and the possibility of non-blocking lookup later added
> in 3a81fd02045c (io_uring: enable LOOKUP_CACHED path resolution for
> filename lookups).
>
> (To be honest I'm a little confused by the history here. The commit
> message of 15b71abe7b52 says
>
> > For the normal case of a non-blocking path lookup this will complete
> > inline. If we have to do IO to perform the open, it'll be done from
> > async context.
>
> but from the commit contents this would NOT appear to be the case:
>
> > +       if (force_nonblock) {
> > +               req->work.flags |=3D IO_WQ_WORK_NEEDS_FILES;
> > +               return -EAGAIN;
> > +       }
>
> until the support is really added in the later commit. Am I confused or
> is the commit message wrong?)
>
> In any event, based on my reading of the history, it would appear to be
> OK to add open_by_handle_at() initially without support for inline
> completion, and then later add that when the filesystem implementations
> can be updated to support this.
>
> Please let me know if I am wrong on my interpretation of the history or
> if anyone disagrees with the conclusion.
>
> Testing
> =3D=3D=3D=3D=3D=3D=3D
>
> A liburing branch that includes support for the new opcodes, as well as
> a test, is available at:
>
> https://github.com/bertschingert/liburing/tree/open_by_handle_at
>
> To run the test:
>
> $ ./test/open_by_handle_at.t
>
> Thomas Bertschinger (6):
>   fhandle: create helper for name_to_handle_at(2)
>   io_uring: add support for IORING_OP_NAME_TO_HANDLE_AT
>   fhandle: do_handle_open() should get FD with user flags
>   fhandle: create __do_handle_open() helper
>   io_uring: add __io_open_prep() helper
>   io_uring: add support for IORING_OP_OPEN_BY_HANDLE_AT
>
>  fs/fhandle.c                  |  85 ++++++++++++---------
>  fs/internal.h                 |   9 +++
>  include/uapi/linux/io_uring.h |   2 +
>  io_uring/opdef.c              |  14 ++++
>  io_uring/openclose.c          | 137 +++++++++++++++++++++++++++++++---
>  io_uring/openclose.h          |   5 ++
>  6 files changed, 209 insertions(+), 43 deletions(-)
>
> --
> 2.50.1
>
>

