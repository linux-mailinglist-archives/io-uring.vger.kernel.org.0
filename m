Return-Path: <io-uring+bounces-7213-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C99E8A6CFEC
	for <lists+io-uring@lfdr.de>; Sun, 23 Mar 2025 16:55:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B94D16CFAF
	for <lists+io-uring@lfdr.de>; Sun, 23 Mar 2025 15:55:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D3E52E338A;
	Sun, 23 Mar 2025 15:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="R9qTzYeJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEDF17E
	for <io-uring@vger.kernel.org>; Sun, 23 Mar 2025 15:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742745340; cv=none; b=ljEiccjYBninprHsapPad+2CoSHatf5PfC3tAQ0LE5NUQiHIm2VLUOzureUxFLR2ZUWeftngwRWEkyRjuq01atQPsoolXRbCOvOOGrpZgfVM0sPIxowHsh+fxIH/mzPWrbIp6Zl7qCqfmCsVSuORfXhDBZyJhwCpZjs457sINSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742745340; c=relaxed/simple;
	bh=28046s0FBlmMShbO8RveCyTg27EUrpBAt4nlPDdpvkE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H0KeYm4ciwSXw1sWT6nsfZ8VWPeFfetWeENwL97IjAXL57z03i58M23vz94betv9KYWubHc9KHrO6Ka1/xhjeCI4eGBHsxoNObFEc8Y0fd6B+oAr2aKjuDSKcgU4cERkTPzEDqAOEpE/TAEA2t6c3zemcpWJHpgWdlBeRUslpmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=R9qTzYeJ; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2ff67f44fcaso993469a91.3
        for <io-uring@vger.kernel.org>; Sun, 23 Mar 2025 08:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1742745337; x=1743350137; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=28046s0FBlmMShbO8RveCyTg27EUrpBAt4nlPDdpvkE=;
        b=R9qTzYeJ7DanittdPbywKTwhq9yY2iJznOg7wdluxnHzUI+FJ1bSpKpHQc+3vQIRHp
         YB79q1OgnwuTsCOhwDQMF0NRl6Af8nc5HY96EZPGh7pokrdI4Fs+eKHtufIoe2dOhnEP
         DQ6iPfJkjETmWlWyXmqF5ojJJvT4Kv0nsVwcnYJf99mn6aEze1TaTNw3KHT/FkwCD4KA
         PtU+xV27ICg75yVjOfnFEI7jVd8Ct8/oYfoEWifgMGh462Xm5vZ53Os90VrwMPsszSYs
         kSM7RGOvCqAP197qm6IZniehRqy6D4vBINtyh4fnhOwKlUK0Wdi5mlvRV4iKiMvhbjxg
         YV5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742745337; x=1743350137;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=28046s0FBlmMShbO8RveCyTg27EUrpBAt4nlPDdpvkE=;
        b=LqT0Ovg08+CpIgjEWxdtpmehIJNQdNT/byeDma1iGHUYa0Lms0O40C0w7on2YFeRYS
         IhLlWa8XSiaFK1r9Oqw6K3bdpaCFxtM5wGCpncYGR/qQ8YEQIiip3EdAWhu/+c8eddVH
         GiOoTRgcpGK2O+JowKYLyh7QdGFrhnScxajGDs+HpE97vZ8kDK90VoVE51tM6nZoqaGn
         aYVvb6TDPPa9eYvNKfMa6UZ9LtJicZZ7AQDLQHrdhmPKal7SBAFUqy9q1myGM0VjGlCE
         6qWQ83swvppwkdHUDIfp42eYO2GUVB4H+BTK9rWygdD1Wsi7g5lzUXA+WXs5rYgJZ/xW
         LyyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWiYS1wLUkfzucxcS/0cuPcj1azaTtuSnQq346BqjICgAx92WW4O1Gk3vHjB/8K3XYYmzy7vV/PWw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwBpHXLWyz6cXTAd86wvN92jrdVCjI8VrPqfKVVFd0+EyW3iE71
	E7eP3UmeyQjXCcL2qzGaBpJybMjxag/bXHYo+K35/dRoYSTYqTpEUuheooaYiEABdc9fMvkRuTX
	1z3GQeI6X3s9UPR14CIWWS92ZDf0CEjeWSY+87A0uyN54CmIGK5mYSQ==
X-Gm-Gg: ASbGncsuyKOIGUNSMvrqziL67WUxbE9aLPuKQwIB6pTauYi/HgP5ehoqg0lxSNsP7iV
	xkF4gwyXUZroZr9IRaMKScmYR5NcwVTlQXpm5jHk4IpJpDywbbCpBnbF3wDQRQKAFAEjfwFCHlL
	ChpzjlNetWG4wO2aJJ9jS2aM41
X-Google-Smtp-Source: AGHT+IHvy3Da0mfdAcgelwBmCE7WFogxvHF3UR91WXM95GeOiicpQeUMX7A4UGeI8X1LLCZlSVmGwry6drWvO+91V4E=
X-Received: by 2002:a17:90b:1811:b0:2ff:6bcf:5411 with SMTP id
 98e67ed59e1d1-3030fe52827mr6173435a91.1.1742745337560; Sun, 23 Mar 2025
 08:55:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250322075625.414708-1-ming.lei@redhat.com> <CADUfDZp2TwVuLW+s+WEPOy=gHE8R7-JWEtxZhbmVeRy6CrGh6g@mail.gmail.com>
 <Z99Q_RQob_GBe8WO@fedora>
In-Reply-To: <Z99Q_RQob_GBe8WO@fedora>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Sun, 23 Mar 2025 08:55:25 -0700
X-Gm-Features: AQ5f1JpzcI_gh3rkodhA_XJxG4AkbItWCe2DBGHYlQD-nkq3bs7AnUcOhLRRD7k
Message-ID: <CADUfDZp9J_0QEJDpD=X0i2jUUs6TM7S8KsvUOPO+psOKSnjr8Q@mail.gmail.com>
Subject: Re: [PATCH] io_uring: zero remained bytes when reading to fixed
 kernel buffer
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 22, 2025 at 5:09=E2=80=AFPM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> On Sat, Mar 22, 2025 at 11:10:23AM -0700, Caleb Sander Mateos wrote:
> > On Sat, Mar 22, 2025 at 12:56=E2=80=AFAM Ming Lei <ming.lei@redhat.com>=
 wrote:
> > >
> > > So far fixed kernel buffer is only used for FS read/write, in which
> > > the remained bytes need to be zeroed in case of short read, otherwise
> > > kernel data may be leaked to userspace.
> >
> > I'm not sure I have all the background to understand whether kernel
> > data can be leaked through ublk requests, but I share Pavel and
> > Keith's questions about whether this scenario is even possible. If it
> > is possible, I don't think this patch would cover all the affected
> > cases:
> > - Registered ublk buffers can be used with any io_uring operation, not
> > just read/write. Wouldn't the same issue apply when using the ublk
> > buffer with, say, a socket recv or an NVMe passthru operation?
>
> IORING_RECVSEND_FIXED_BUF isn't handled for recv yet, so looks socket rec=
v
> isn't enabled...

True, that specific example doesn't work. But my point was just that
the issue (if it exists) wouldn't be specific to read/write
operations. In fact, the ublk server could complete the read request
without performing any I/O at all to fill in its buffer.

>
> > - Wouldn't the same issue apply if the ublk server completes a ublk
> > read request without performing any I/O (zero-copy or not) to read
> > data into its buffer?
>
> Yes, it needs ublk zc server implementation to be trusted, and ublk zc
> can't work in unprivileted mode.
>
> For non-zc, no such risk because request buffer is filled with user data.

The issue doesn't appear specific to zero-copy. If the ublk device is
configured with UBLK_F_USER_COPY, a buggy/malicious ublk server that
doesn't fill in the read request's full buffer would also leak the
existing contents of the buffers. But both UBLK_F_USER_COPY and
UBLK_F_SUPPORT_ZERO_COPY require CAP_SYS_ADMIN. So I think it's
reasonable to say that we are trusting any privileged ublk server to
fully initialize read requests' buffers.

Best,
Caleb

