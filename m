Return-Path: <io-uring+bounces-8257-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A764AD0780
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 19:29:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A03203B19A2
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 17:29:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0443D28A1FC;
	Fri,  6 Jun 2025 17:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="L9pJJPI/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2745712CDBE
	for <io-uring@vger.kernel.org>; Fri,  6 Jun 2025 17:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749230988; cv=none; b=f0sYg+CNlnw5zEKrK6WMpjTAC6eWUQkrvRzR1xv7Y6d/rqel5q90gY1RkQ1OJpQRbpYDh0VC99ZEWm9ENyOWlq/O5UqV/eHqjRnd9C7aC3KepdcY1amBqcrl2alMgPEhvYg1GFnAmxTUmAjcLWLAsC9Q7aUUy1XnKee/cmvTeCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749230988; c=relaxed/simple;
	bh=QGa/r4NvxxBUOuLFkmnFO/aFQspYw5McwDjicNaVcSs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ujNM5Nke8+i7xKLCGoGCWaNofQ3gyCTFPrbOpQJ6QAIBqvlf3sBoswsyG/yn3zufH9sncbBL+Nx8G5ZaPdzS8FCmrFmqCJ54kQCigOZcHt450ad7Lew07SvSL/se81Bx3+johiJ/z9WFObR22AxK02lixj3xnwV/GhWeQNt16fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=L9pJJPI/; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b2f0fcee268so255308a12.3
        for <io-uring@vger.kernel.org>; Fri, 06 Jun 2025 10:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1749230986; x=1749835786; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nMFW2j4wIp2oeYGfJIUIHO+7IhFhpheSjLwv4P4KCYg=;
        b=L9pJJPI/+gO7qU8Qy2TQIJGdIomFvv0YubDujo5UnMtlnVrgFS4qNeEkprUpL8FiVF
         S7OG8GX37g8+YjJ6Zza+TiFErh+e90rSmqrfhwO32P5hCR5BKH/ObnrX4J35wilYtagh
         bGIkx3DnJwXpJ8vYnekOH4sQFSulluNqzsfjYRnVRSTYh6ITnxbapPXyEN0tckOuG53M
         +/OeK9bi56peHhJDKwrppRzvLjcuaLi8AjDIs+bOOXG1lnI2JtVLt/Wu2KdYCQ3vvzoY
         uyP+qPlMMK35+uBmVOqxJGXLzKUYsdRYwT5n+jqej39T6pVcttGr4I2Y3FqmW7UQd8N5
         +Gbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749230986; x=1749835786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nMFW2j4wIp2oeYGfJIUIHO+7IhFhpheSjLwv4P4KCYg=;
        b=GFj1ygT8jY0uH4FXdiuAJGQcK8RjVGuSN+zVVesxfbNgtt0WQHhw65iT4nlNyrFegr
         +VNqriWp9OXcfooL16J7YPXiDWHiDe2XFdxjcOHerBGKr6y84bc7UfbAzf7qF0jvT8Ww
         O+aIGaxCutHm9zC/pe+aVe9Zhq25mdDQAorHOn3PQxURYdu1XySPui8kLx2sZ3QnYFF3
         ISc3+KNBc+pTlpSI/VYTAu5cJFSATFQNKV5B2A/6GTAyyv6jMG1JfxtpDU2qanEdhow0
         Tik8ZnohBhb5wTSmqpnEu+IJnMFdvdb04aYnaIYUSaO1dtsIElsTU8dvoghWHdVXN5hK
         ZNwg==
X-Gm-Message-State: AOJu0YwlKS5h/b7O9+swtmMGCBixkKmbH5FiYHrSoKqZtAwJoaHIUiPn
	SaSK99i7QsGfswdFBazkHWKVugYR/yXelysMERCv8O4G2GUSMjyEsDJ/3EjmYWR2O0d7iu1MABr
	1VUPmZfmcHuyuI16D9oL/AuLsLZEoHLbaavwCbi5MX1vdwGpxnY/j
X-Gm-Gg: ASbGncukfehFZF99KHbPLBGOmAUsbcRbQvzYCOzRw2W5q/TZfzHXmZkqk0eT4/G3ifo
	zW7y/b+v/WyJGpdXrkvP68giYgEJM6IZAbZSEzozVdq++rGICU/G7UTwNw6kC43fxhBH4Mzna6b
	OQoT9TxNf4Aj/njc8GDVP6heZN5TzfuSl9VQbrPTR067ZhS2OhuxwACQ==
X-Google-Smtp-Source: AGHT+IGOcGPW8kgVurrC3GkIU/UG83SaDkRmxQppW2+SprBNMSy8sRkQx4q7erxD+Kxp7TUdumsLM1NflrvLjSffdxU=
X-Received: by 2002:a17:902:e54a:b0:234:a66d:ccd7 with SMTP id
 d9443c01a7336-236040387b1mr16476755ad.7.1749230986168; Fri, 06 Jun 2025
 10:29:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605194728.145287-1-axboe@kernel.dk>
In-Reply-To: <20250605194728.145287-1-axboe@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 6 Jun 2025 10:29:34 -0700
X-Gm-Features: AX0GCFvUT64HJE2ROsqf2n4rMkEOHlbEEK6RP94C1S72aCxLi0xevpEg8QzO9bo
Message-ID: <CADUfDZrSAUYtd2988vSUryNt2voSUbngXtBcAU3Cb+JqYuuxTg@mail.gmail.com>
Subject: Re: [PATCHSET RFC v2 0/4] uring_cmd copy avoidance
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 5, 2025 at 12:47=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> Hi,
>
> Currently uring_cmd unconditionally copies the SQE at prep time, as it
> has no other choice - the SQE data must remain stable after submit.
> This can lead to excessive memory bandwidth being used for that copy,
> as passthrough will often use 128b SQEs, and efficiency concerns as
> those copies will potentially use quite a lot of CPU cycles as well.
>
> As a quick test, running the current -git kernel on a box with 23
> NVMe drives doing passthrough IO, memcpy() is the highest cycle user
> at 9.05%, which is all off the uring_cmd prep path. The test case is
> a 512b random read, which runs at 91-92M IOPS.
>
> With these patches, memcpy() is gone from the profiles, and it runs
> at 98-99M IOPS, or about 7-8% faster.
>
> Before:
>
> IOPS=3D91.12M, BW=3D44.49GiB/s, IOS/call=3D32/32
> IOPS=3D91.16M, BW=3D44.51GiB/s, IOS/call=3D32/32
> IOPS=3D91.18M, BW=3D44.52GiB/s, IOS/call=3D31/32
> IOPS=3D91.92M, BW=3D44.88GiB/s, IOS/call=3D32/32
> IOPS=3D91.88M, BW=3D44.86GiB/s, IOS/call=3D32/32
> IOPS=3D91.82M, BW=3D44.83GiB/s, IOS/call=3D32/31
> IOPS=3D91.52M, BW=3D44.69GiB/s, IOS/call=3D32/32
>
> with the top perf report -g --no-children being:
>
> +    9.07%  io_uring  [kernel.kallsyms]  [k] memcpy
>
> and after:
>
> # bash run-peak-pass.sh
> [...]
> IOPS=3D99.30M, BW=3D48.49GiB/s, IOS/call=3D32/32
> IOPS=3D99.27M, BW=3D48.47GiB/s, IOS/call=3D31/32
> IOPS=3D99.60M, BW=3D48.63GiB/s, IOS/call=3D32/32
> IOPS=3D99.68M, BW=3D48.67GiB/s, IOS/call=3D32/31
> IOPS=3D99.80M, BW=3D48.73GiB/s, IOS/call=3D31/32
> IOPS=3D99.84M, BW=3D48.75GiB/s, IOS/call=3D32/32
>
> with memcpy not even in profiles. If you do the actual math of 100M
> requests per second, and 128b of copying per IOP, then it's almost
> 12GB/sec of reduced memory bandwidth.
>
> Even for lower IOPS production testing, Caleb reports that memcpy()
> overhead is in the realm of 1.1% of CPU time.
>
> v2 of this patchset takes a different approach than v1 did - rather
> than have the core mark a request as being potentially issued
> out-of-line, this one adds an io_cold_def ->sqe_copy() helper, and
> puts the onus on io_uring core to call it appropriately. Outside of
> that, it also adds an IO_URING_F_INLINE flag so that the copy helper
> _knows_ if it may sanely copy the SQE, or whether there's a bug in
> the core and it should just be ended with -EFAULT. Where possible,
> the actual SQE is also passed in.

I like the ->sqe_copy() approach. I'm not totally convinced the
complexity of computing and checking IO_URING_F_INLINE is worth it for
what's effectively an assertion, but I'm not strongly opposed to it
either.

Thanks,
Caleb


>
> I think this approach is saner, and in fact it can be extended to
> reduce over-eager copies in other spots. For now I just did uring_cmd,
> and verified that the memcpy's are still gone from my test.
>
> Can also be found here:
>
> https://git.kernel.dk/cgit/linux/log/?h=3During_cmd.2
>
>  include/linux/io_uring_types.h |  2 ++
>  io_uring/io_uring.c            | 35 +++++++++++++++------
>  io_uring/opdef.c               |  1 +
>  io_uring/opdef.h               |  1 +
>  io_uring/uring_cmd.c           | 57 ++++++++++++++++++----------------
>  io_uring/uring_cmd.h           |  2 ++
>  6 files changed, 63 insertions(+), 35 deletions(-)
>
> --
> Jens Axboe
>

