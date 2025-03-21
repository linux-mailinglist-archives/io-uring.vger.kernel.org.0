Return-Path: <io-uring+bounces-7187-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAA66A6C548
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 22:38:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3CEB3174CEF
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 21:38:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DB5022FDEE;
	Fri, 21 Mar 2025 21:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="D3YWjS1N"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559C91F0E29
	for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 21:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742593112; cv=none; b=asq1mtfxBS8Ep1zvRUN3Gf8Fy9R+23ZTJ0eR/9HMacCciYdxjenVjjmV9H0SdZy3OwGfbAxs0TkUaA0fO2upf8At5aG1bzEdgbfy33iwdWmnIyh4jNanaKxzw5vY01v7QDct8g93QKFr71Sg0sLP7fpdzCg2k2qCt63mhkjtqbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742593112; c=relaxed/simple;
	bh=0s8PHm04p4vmMdRlrDb7etA3hydAU6JK9t4r3Yd98L8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T0OmpjI7jci4Sban+38AMuoVQMb/Z8wAC5is5DZsIar5GLSNr5bh30QAvOMRtGXvlmntoT1uxTH/oBTrCKm4Dv0O3AB3LNMp56QD+01ZjNPqcE55/49kZ9LuqNtGkeFmLzDOiIjRR/puafPoYj0SPwarTsCo5XbGSLksCh+96ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=D3YWjS1N; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2260202c2a1so5660845ad.3
        for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 14:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1742593110; x=1743197910; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0s8PHm04p4vmMdRlrDb7etA3hydAU6JK9t4r3Yd98L8=;
        b=D3YWjS1NLsOrQQgbH7niTFYfhZE0Njg3cCEj01M2mCK3fDbRsGWAP+kVkScg8jXePb
         6Pzo3q5IwnaRm4YCaru+xtjxTLS1A8iF8OGFAxtceJYxoHQMnJ6eVxnPUJzz1TWHcB2O
         fKCkkh04HcG7FOpKKvy7wfXPTgEkxiGX5gOwA1VQUAjYDDHqYNPOSGaXhNYebj+Pymgr
         ILiwVRYYoZlpqgl3X0PMNpVjT5axrDs9dsFk75R6leq4hJc47nTk3/fb2If2aCKo8IJD
         A+ZzFGMNixKLEe+i6s+VOqJAphwpw/OpDJqg4tpTM0+VDbNbmhXpqFt0Ba8NooHCKlBd
         2dnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742593110; x=1743197910;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0s8PHm04p4vmMdRlrDb7etA3hydAU6JK9t4r3Yd98L8=;
        b=E83DIYM3iyagPg9yK2miAvXKEQ43YfaLow6sLZ/8V30wDK/nkIzWIsTcsPThbdxuEk
         R0v4MVE/Z4hjFN+QgWdNvySRx6GjGLF/QsG7n1HLQAb+YX8/Cd8QIXyq4JExFzqInjUb
         RF36ZEs5xzlTOjRi6aXjwLv0s95rMwV/NAo7oZHPd/BJdE7VvJ0jaXhtbaECbixP8lr7
         I5sb/TK1FZAGq+athFOgotlnXF1hJiVY+4YKNT/+q2xPsBydWnZnxkcdXM2iQRmCUWEi
         8hvbBxUdX20wKvdbhyPSDYeV39ewrdh7wi81y2XE3t6u40ke8VLi0OSgpAWPyMmrLj4r
         4ylQ==
X-Forwarded-Encrypted: i=1; AJvYcCXbsv8wHqrZuu//0aAF0CcqCMAy57hEfno7RrTUOYVWqa3NvDQ0xIbIwWnkXktqHreI3teFlqeWLg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzK/eA18vfqXFrnxA12IPloMnwEwibOXARcMuWy/4knEsJ+3BbB
	L7sRhFYxoXoZPWHWlw6f45NtlH8IQIjm+7ldCdthcntTVFnL06MEOKtDFZA13heXLGBa6Nt0gMB
	jfXoR0ybLDU54892/KN4cbs30rIwmOmrIOxClRg==
X-Gm-Gg: ASbGncsi2ISJDek4iUNTVSg2cWTlG1dZ4g2/49in8KVOOpor8VnHr+E2YSnlCR+rMJN
	wCpUXMNUPJFrXM2tk+HNVYVXkNeq+UoPU2Jx0hgIucHJ3Xp6shO8bWDJ4eYlQLHvyiW2Sykjrx2
	iNpehDSeHEOXqmpBMwtyNzCPCB
X-Google-Smtp-Source: AGHT+IGSk+bsBxz+JO9UqX1StGRAOw80slB+xBi/7szzHuQU/IKincKxZ1fz09uQ/n1u+YujF0fQ7TN14YtlTnBH7/c=
X-Received: by 2002:a17:902:db0e:b0:21b:b115:1dd9 with SMTP id
 d9443c01a7336-22780c7cad0mr28361055ad.5.1742593110608; Fri, 21 Mar 2025
 14:38:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250321184819.3847386-1-csander@purestorage.com>
 <20250321184819.3847386-4-csander@purestorage.com> <8338ac70-ed0b-4df5-a052-9ab1dfec9e26@gmail.com>
In-Reply-To: <8338ac70-ed0b-4df5-a052-9ab1dfec9e26@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 21 Mar 2025 14:38:19 -0700
X-Gm-Features: AQ5f1JqF7084HWCX45pZ6paHlx6q6XUtczTCEEBO8pEFGjQNkwueLYbERoxLSfY
Message-ID: <CADUfDZoELiri8Fuq3tHSsKf1XhPVaZ1eoCzfXK7g994VY4o9Vg@mail.gmail.com>
Subject: Re: [PATCH 3/3] io_uring/uring_cmd: import fixed buffer before going async
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, 
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Xinyu Zhang <xizhang@purestorage.com>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 21, 2025 at 1:34=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 3/21/25 18:48, Caleb Sander Mateos wrote:
> > For uring_cmd operations with fixed buffers, the fixed buffer lookup
> > happens in io_uring_cmd_import_fixed(), called from the ->uring_cmd()
> > implementation. A ->uring_cmd() implementation could return -EAGAIN on
> > the initial issue for any reason before io_uring_cmd_import_fixed().
> > For example, nvme_uring_cmd_io() calls nvme_alloc_user_request() first,
> > which can return -EAGAIN if all tags in the tag set are in use.
>
> That's up to command when it resolves the buffer, you can just
> move the call to io_import_reg_buf() earlier in nvme cmd code
> and not working it around at the io_uring side.
>
> In general, it's a step back, it just got cleaned up from the
> mess where node resolution and buffer imports were separate
> steps and duplicate by every single request type that used it.

Yes, I considered just reordering the steps in nvme_uring_cmd_io().
But it seems easy for a future change to accidentally introduce
another point where the issue can go async before it has looked up the
fixed buffer. And I am imagining there will be more uring_cmd fixed
buffer users added (e.g. btrfs). This seems like a generic problem
rather than something specific to NVMe passthru.
My other feeling is that the fixed buffer lookup is an io_uring-layer
detail, whereas the use of the buffer is more a concern of the
->uring_cmd() implementation. If only the opcodes were consistent
about how a fixed buffer is requested, we could do the lookup in the
generic io_uring code like fixed files already do.
But I'm open to implementing a different fix here if Jens would prefer.

Best,
Caleb

