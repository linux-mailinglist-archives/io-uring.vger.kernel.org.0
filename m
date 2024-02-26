Return-Path: <io-uring+bounces-732-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C27018677AD
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 15:05:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1EB17B2626B
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 14:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE0DF12C556;
	Mon, 26 Feb 2024 14:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SKjZYONL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB4512CD92
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 14:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708956147; cv=none; b=oI/1TSLieSQYmkHoFWMBET5/iZ0NzCJ4y4437LaoOXcRzalD9Nn0WFk836l/R608qTrbk0fhoURSn4IKe2KGVdMUrpdlCRPWWgK+J8nZPyYx+5yHlrsUfbCpsuFC9mPDYl0aGEXbdDYBUuBzTN12/iJLHMJIizYzNtvPDPL1Ryw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708956147; c=relaxed/simple;
	bh=H25m1x10d764Pk/nQDE+B8oISWlRBVee6qFUx8F+054=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cbnIT5FYaFGrXe9xqOpWopquWc7z/0NFgiy6c0eEZrTmpdnuZO1oF6cZXhVlqeTRTPHdVLiBxePSScIaBYUxkF64VzOx7VuGMATpcxFIM8xCsc/Xc4I0f6SvaV69YmT47f6Wu9ON7G7KYV9F5Gtbu5ISRa3p0N5yyar4gvrc0kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SKjZYONL; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3c132695f1bso1935385b6e.2
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 06:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708956144; x=1709560944; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H25m1x10d764Pk/nQDE+B8oISWlRBVee6qFUx8F+054=;
        b=SKjZYONLpXoqN/37geqKYPPpxZcgXLbOm9JzVXoiliQy7J9CmAfStLaRhKaoK+mTTn
         T/WpyMw0IDoD59uaghaMv1QfzCWN2ERZ2B9TOcfDi3j/ZalfDBDlwNMYiDFA3H6+y9dI
         I6Lczu8fw35Gdw+tbwcRgJQSQWec/BcaGLQjQieRNkZSkKxDuFSBPc8XeXLSYYeGEs54
         nGhJqbjFd3GNrHegDvDHGO27P9OSG01MGQn3fxZoRfgoqT2SliU/Jp3fsNkOY+0bJItj
         +LNgQEhLGOZJn3+IwiYrc8cIFpPvh/DmDokl0KNCca41BG4H2W+nrS+WSnTvZbMyqCNX
         84Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708956144; x=1709560944;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H25m1x10d764Pk/nQDE+B8oISWlRBVee6qFUx8F+054=;
        b=Hi2U5FqpqlLXsb2gOiCndO6IiqPEAgWkUnmyrIeGly3fCtUNgv2yBY13rAcxKsgCuu
         AvPKirqkC5Kp+gy0d2FDjH7TI4DwCZIVMOb2V1SrKJpTOiSpBlcQBdELdFc8BMwuMCG4
         4l9apv6ey8UjjmsLqWBX103uypfqpdcLNzpjFxRiG53+iWObTsUca5iE0asFfH9GEiSM
         InHR9N6C3zchp6dRw49Nx9gkfbnqnRt6twiZ+qcC2snpNjlFHWQW7/903ccqBeMRB2Cs
         NmYhG6xQ8OkC2Cl7Hv+BhxXYKOEPO1zecfJ4k8ujS/cFkqQdJn//DaX3xXeDBQBB7YfU
         MtKA==
X-Gm-Message-State: AOJu0YxtlT9Q0lCs25GpbiJ4+7TnFDG7PL53M534LjAGfPjTfVihpbMT
	EFyh50Ig3gXgXtdGPuA7ueotnZuyM7NJUtCOfPVR24PPBYBo3Sr5IY630nA708Xczx8wHNm95lf
	fIdluU6FBsCRSCVz4M6zK7fwuvUc8er7wkL0=
X-Google-Smtp-Source: AGHT+IEuu9kwS3oxHC3tDL0zIiIHbeJwve9GewDjTkbERdZIP5g+2EwelLMEkDo/YtVg9vDbAQyJCTGaVHfCSRkSmNM=
X-Received: by 2002:a05:6808:2191:b0:3c1:81ad:f45f with SMTP id
 be17-20020a056808219100b003c181adf45fmr11240639oib.28.1708956144317; Mon, 26
 Feb 2024 06:02:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240225003941.129030-1-axboe@kernel.dk> <20240225003941.129030-7-axboe@kernel.dk>
 <CAO_YeojZHSnx471+HKKFgRo-yy5cv=OmEg_Ri48vMUOwegvOqg@mail.gmail.com> <63859888-5602-41fb-9a42-4edc6132766f@kernel.dk>
In-Reply-To: <63859888-5602-41fb-9a42-4edc6132766f@kernel.dk>
From: Dylan Yudaken <dyudaken@gmail.com>
Date: Mon, 26 Feb 2024 14:02:15 +0000
Message-ID: <CAO_YeoiTpPALaeiQiCjoW1VSr6PMPDUrH5xT3dTD19=OK1ytPg@mail.gmail.com>
Subject: Re: [PATCH 6/8] io_uring/net: support multishot for send
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 26, 2024 at 1:38=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2/26/24 3:47 AM, Dylan Yudaken wrote:
> > On Sun, Feb 25, 2024 at 12:46?AM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> This works very much like the receive side, except for sends. The idea
> >> is that an application can fill outgoing buffers in a provided buffer
> >> group, and then arm a single send that will service them all. For now
> >> this variant just terminates when we are out of buffers to send, and
> >> hence the application needs to re-arm it if IORING_CQE_F_MORE isn't
> >> set, as per usual for multishot requests.
> >>
> >
> > This feels to me a lot like just using OP_SEND with MSG_WAITALL as
> > described, unless I'm missing something?
>
> How so? MSG_WAITALL is "send X amount of data, and if it's a short send,
> try again" where multishot is "send data from this buffer group, and
> keep sending data until it's empty". Hence it's the mirror of multishot
> on the receive side. Unless I'm misunderstanding you somehow, not sure
> it'd be smart to add special meaning to MSG_WAITALL with provided
> buffers.
>

_If_ you have the data upfront these are very similar, and only differ in t=
hat
the multishot approach will give you more granular progress updates.
My point was that this might not be a valuable API to people for only this
use case.

You do make a good point about MSG_WAITALL though - multishot send
doesn't really make sense to me without MSG_WAITALL semantics.
I cannot imagine a useful use case where the first buffer being partially s=
ent
will still want the second buffer sent.

> > I actually could imagine it being useful for the previous patches' use
> > case of queuing up sends and keeping ordering,
> > and I think the API is more obvious (rather than the second CQE
> > sending the first CQE's data). So maybe it's worth only
> > keeping one approach?
>
> And here you totally lost me :-)

I am suggesting here that you don't really need to support buffer
lists on send without multishot.

It's a slightly confusing API (to me) that you queue PushBuffer(A),
Send(A), PushBuffer(B), Send(B)
and get back Res(B), Res(A) which are in fact in order A->B.

Instead you could queue up PushBuffer(A), Send(Multishot),
PushBuffer(B), and get back Res(Multishot), Res(Multishot)
which are in order A -> B.

The downside here is that userspace has to handle requeueing the SQE
if A completes before B is pushed. I leave it to you
if that is not desirable. I can see arguments for both sides.

