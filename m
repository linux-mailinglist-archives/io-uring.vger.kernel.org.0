Return-Path: <io-uring+bounces-10523-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AA298C503A1
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 02:44:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9821D4E49DD
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 01:44:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2B4027E045;
	Wed, 12 Nov 2025 01:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="YVia3w17"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8E327B348
	for <io-uring@vger.kernel.org>; Wed, 12 Nov 2025 01:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762911872; cv=none; b=AJH0ZccXuOZcdshe4rLI4zUQYkiIff+XL/xVeOUJ8o78KYyBCOD3Tv/ZMZrN4ipWY55wdQZwjv/8amHt/RJZqGPPGqg4niTMrbANfbYuRJYh9Dvhn4yjoaLMoOQCxHFi45DSRvcpZbbrZS9jwHh3AT29DUUbBk9A0hp1GWXIFUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762911872; c=relaxed/simple;
	bh=HGl4RmpFu84gj76U4PQa4Vp95wD0o4Jckxg3KXNlwxI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SOWK8r8iWYPuMjoZuervLS8Kemyzm1opIUFdm6ojloQdR190p+2V4p3we+7SB20xCFfqEcseVtqpj7h5TU++at6NsGtdwgcUp6Cr7N0d6M9dM409XtwTfcVchJY0MDh0ejtDPsOGPlCpUuBuCDQGR+mCw4fH1fLNuuZiDtjyAKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=YVia3w17; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3437ef3c9a4so48431a91.3
        for <io-uring@vger.kernel.org>; Tue, 11 Nov 2025 17:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1762911870; x=1763516670; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HGl4RmpFu84gj76U4PQa4Vp95wD0o4Jckxg3KXNlwxI=;
        b=YVia3w171u5knPgbighujbP5v9rBubbB2FNrtOBtVV5O47YWrXyc/Pn5Ci56qYqy7C
         wtsq5ItmPRXn/THYU9nemte8nEXv1P7GjvARUNNGn98Ycti1mrsQA08bsc5N95BC8W/4
         3TFfadCa3EH5l0GKBq4hcqXsPsKkBlVGpo6wFb+UgbCczuhwZQsba5Adv+Xq04us3clD
         /I9xYN/3+JyiTDKshSDHkyRxH49LmEEAPHILn6ZfAuDl5xmlh0lYxveQS2degWpS2g/g
         YO+cj/rLUQEE0eK7KYnJ2zi4/ITzTAJYV8wLC3bk4AdnQCWjeePPHwNhiYzZBpwu5Jy+
         vicg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762911870; x=1763516670;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HGl4RmpFu84gj76U4PQa4Vp95wD0o4Jckxg3KXNlwxI=;
        b=CtDYG7/mUkdS3L6RR5KMbXWi9GjYAbbOq3cxcCUeV+QSEXApveZBDnPy4jKSkpZNbH
         KSNvTrtNKyQeYj71B6M3MStweAtoJqh87WGunjlk50B4OomhBbdOEEyclemV/T8yTrjn
         ENOzqWy1eAoLKoWp7p+WZXuS+UrBpWv2LwLow27io/LSH78Qx6S7o6gRfrkrvzOdHfDi
         MH5qs5ktgZCrCJ6BqFjE2hHCBWcWQSISARjufvoIDZsjypSBs15dEnYjuXQKaXPyml8A
         QkT8/S1OeTGYHvr00Cj34iYZXOo9eGMnAIRiRbDBbCn2Ag0sO4m0k2dj4dB4geQXBUo8
         ExgQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWMkrV5IgkZoEuQ4J44dSokhHGv6+LG+0jGRxVATwSo7vAc1/0D9p5mbSbiMnGKOnildBUMsmisQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw15rwbEdUGQO5bPGSheCrn9RvQWgBPKQQAnX/cz512mahDe1CB
	OaUSfy2eV11GLuvllmNyiIsGKoClBONjWeuy/Kms3ll0am6BNsjeop8A0Wo76MI3rga/Vh2vO4/
	uAhdABjxkDGFA3O+JoQfxa/AjVKu/ZhjFkF5NMopV/A==
X-Gm-Gg: ASbGncs/8Mj84x31CzT7A0NnvkXN3ZN33UAp7olaWe5+gRn7Y4vBtkO6U5D1m5paLC3
	zhohrAgUQOfjfd2OP+3wra0fxy8Q55nIFjiW0oiqL7QnQ1ClvuGKrorxOEWNK84JQ/0HJEF89g1
	TzJowaeuaTlx0kMwB+z8/ex+QpOpeA+KA/NC4ziOLuyKQgp25Ms9Rv15a0G80ZV1k16mufAM667
	WoaJWDv12nYGWWvfHj/jM2+F/j65Qpv2utQhPfZzSUjQE20RzXBY/P5XzYxv56vB2JbIcyZ
X-Google-Smtp-Source: AGHT+IGGJzsPUNQafoq4PvUv0D7ILT2uewqou7SB/zBZxjLSeaobS11qhsqkImiirH/dj7vmyyEFOkI6mNDh5iM3Jto=
X-Received: by 2002:a17:902:c951:b0:295:f926:c030 with SMTP id
 d9443c01a7336-2984ed34944mr9164955ad.2.1762911870295; Tue, 11 Nov 2025
 17:44:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251111191530.1268875-1-csander@purestorage.com> <aRPcdmpZoet2fwbu@fedora>
In-Reply-To: <aRPcdmpZoet2fwbu@fedora>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 11 Nov 2025 17:44:18 -0800
X-Gm-Features: AWmQ_bn5L0BHdz5rRKs386fOtrXPE9SRJa4pEt-kLJPqzJYTQF4qFEB9j2C4mwg
Message-ID: <CADUfDZovn5fPh_E6GGvGkPYbW12L2z6BS4jPkpQjuEjNd=bRGA@mail.gmail.com>
Subject: Re: [PATCH] io_uring/rsrc: don't use blk_rq_nr_phys_segments() as
 number of bvecs
To: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@kernel.org>, Chaitanya Kulkarni <kch@nvidia.com>, Jens Axboe <axboe@kernel.dk>, 
	linux-block@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 11, 2025 at 5:01=E2=80=AFPM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> On Tue, Nov 11, 2025 at 12:15:29PM -0700, Caleb Sander Mateos wrote:
> > io_buffer_register_bvec() currently uses blk_rq_nr_phys_segments() as
> > the number of bvecs in the request. However, bvecs may be split into
> > multiple segments depending on the queue limits. Thus, the number of
> > segments may overestimate the number of bvecs. For ublk devices, the
> > only current users of io_buffer_register_bvec(), virt_boundary_mask,
> > seg_boundary_mask, max_segments, and max_segment_size can all be set
> > arbitrarily by the ublk server process.
> > Set imu->nr_bvecs based on the number of bvecs the rq_for_each_bvec()
> > loop actually yields. However, continue using blk_rq_nr_phys_segments()
> > as an upper bound on the number of bvecs when allocating imu to avoid
> > needing to iterate the bvecs a second time.
> >
> > Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> > Fixes: 27cb27b6d5ea ("io_uring: add support for kernel registered bvecs=
")
>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
>
> BTW, this issue may not be a problem because ->nr_bvecs is only used in
> iov_iter_bvec(), in which 'offset' and 'len' can control how far the
> iterator can reach, so the uninitialized bvecs won't be touched basically=
.

I see your point, but what about iov_iter_extract_bvec_pages()? That
looks like it only uses i->nr_segs to bound the iteration, not
i->count. Hopefully there aren't any other helpers relying on nr_segs.
If you really don't think it's a problem, I'm fine deferring the patch
to 6.19. We haven't encountered any problems caused by this bug, but
we haven't tested with any non-default virt_boundary_mask,
seg_boundary_mask, max_segments, or max_segment_size on the ublk
device.

>
> Otherwise, the issue should have been triggered somewhere.
>
> Also the bvec allocation may be avoided in case of single-bio request,
> which can be one future optimization.

I'm not sure what you're suggesting. The bio_vec array is a flexible
array member of io_mapped_ubuf, so unless we add another pointer
indirection, I don't see how to reuse the bio's bi_io_vec array.
io_mapped_ubuf is also used for user registered buffers, where this
optimization isn't possible, so it may not be a clear win.

Best,
Caleb

