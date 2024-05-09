Return-Path: <io-uring+bounces-1839-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 641948C0A54
	for <lists+io-uring@lfdr.de>; Thu,  9 May 2024 06:03:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 237A428444A
	for <lists+io-uring@lfdr.de>; Thu,  9 May 2024 04:03:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DAD6147C71;
	Thu,  9 May 2024 04:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TY2ybP3q"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918B213B5A9
	for <io-uring@vger.kernel.org>; Thu,  9 May 2024 04:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715227404; cv=none; b=Ok5PrG3Jvot9vISR9e8HBgm8rtOZ6sKBWlyDiRrwqCkhj9qT1Btgkc4SXVkDCNr3bkujjYJFjQ8ANPgdGlpqC458yL1EWjVz/NV7Aeuc4PGceYpyu9D1s6XcV+Gl4+SEsGpmXqGq/8atjAYQzBMvdypdZPCUAxRsCDh6Ha6pTyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715227404; c=relaxed/simple;
	bh=gPX/W7Ue9d1q4zUosmv9i1yvLKUrVHJpKBU2dr4q7g4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LDlnTqVsdII2eY9zl8Ir+N4RhxUO3Lz9PCfZsSht975kMVokt+VzcZWNY670uAhaLZFYbDewgSBhXaWBAuB+ojrI/PTXnaNKtYfSkmYwgiUw/aykYWiUorJNvyzpT5UnnlCoSIOSIl1OOL54UJJ96q/eDFk1x+k+Lyml/xzLAwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TY2ybP3q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715227401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gPX/W7Ue9d1q4zUosmv9i1yvLKUrVHJpKBU2dr4q7g4=;
	b=TY2ybP3qitNhxACrn8obhzXO4DykD/JhRPHcbd4kyu6cdL6QuqPhOpGjBze/i/okvtdrpM
	wfopG8H8SWirtnP+fj0OMQ4hh9MVjsh8gtBNAbDkmgYQvsQo4G2fVP9Jyab01YQFsr7Cgh
	Etb3yURvRw70ydpum9rf/FhcK57s8H0=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-qDzbjncTMfik5C_W98ceMA-1; Thu, 09 May 2024 00:03:19 -0400
X-MC-Unique: qDzbjncTMfik5C_W98ceMA-1
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-47f00fb581eso51569137.2
        for <io-uring@vger.kernel.org>; Wed, 08 May 2024 21:03:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715227399; x=1715832199;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gPX/W7Ue9d1q4zUosmv9i1yvLKUrVHJpKBU2dr4q7g4=;
        b=v5YQAM0vGaPKa4tzAXKc/nKSK89NRbyP8T7qa+qVCExnOwnJ/jUsuD532f63S34Hg3
         85AfYEITTljAp8aj8aD0IhaNKW/vgITkX41iNV+AuQE7CqT4yHobEq24X5PA4cKqxbHD
         NAjSMpDqgZ34nGRQUAV8cwPBbhDekPWbh5yscL2AX4QfM+B8DHCBfW/ok1xAMkwd7KQZ
         gcUvduJL7wex1Eb1K2dGQQLaJEd7MESWcQa4YbdkYY+rlJb5Ej1avHqa0AiG1OqbzDKG
         EeMvYOw1ibqjnuQq/I+AThMqeeDdsWlKo+4D4Tc9uYO6BhnDCVAt/RFOcfXQYRFSIR7G
         uhdw==
X-Gm-Message-State: AOJu0YxccZN0ZI00a6TPc69CYs4NeT28+3tISz8a7tsk+Dszr2jDdJp2
	dd8KIna4bNgAgVbS8kn3aNv4aJYhYdeB9VM8CnlCy3eFnaPGCs3KLP2xcowZYrOo33sPeCXnSyg
	n+eTBoIdBCHDJpMJ7HCHCbeZ2tfeA57UJkokqt5lR56td6HLOuyZNiiE5CZgpehRJ65kBsh7L86
	7CGLUJkw9rzjoaFOmTN5cJheD6XkBHsd0=
X-Received: by 2002:a05:6102:224e:b0:47c:1777:c4a2 with SMTP id ada2fe7eead31-47f3c38e71emr4176794137.3.1715227399372;
        Wed, 08 May 2024 21:03:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFA1b1jxLio5OFfTH6YcqxXqurZC1C2Kg/tGVviamGa9743Q+l/tkCoEIm7QCtfa2ycfRzPaoyBb1ODHSYlFwc=
X-Received: by 2002:a05:6102:224e:b0:47c:1777:c4a2 with SMTP id
 ada2fe7eead31-47f3c38e71emr4176781137.3.1715227399046; Wed, 08 May 2024
 21:03:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240509023413.4124075-1-ming.lei@redhat.com> <1f411b88-f597-40b0-b4c9-257b029d3c9e@kernel.dk>
 <Zjw9jIHtan4FAc9D@fedora>
In-Reply-To: <Zjw9jIHtan4FAc9D@fedora>
From: Ming Lei <ming.lei@redhat.com>
Date: Thu, 9 May 2024 12:03:07 +0800
Message-ID: <CAFj5m9+QvchnhUgs3reCTXFEosR2H8NFoq9A-pZoewAg=_OMkQ@mail.gmail.com>
Subject: Re: [PATCH] io_uring: add IORING_OP_NOP_FAIL
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 9, 2024 at 11:05=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> On Wed, May 08, 2024 at 08:55:09PM -0600, Jens Axboe wrote:
> > On 5/8/24 8:34 PM, Ming Lei wrote:
> > > Add IORING_OP_NOP_FAIL so that it is easy to inject failure from
> > > userspace.
> > >
> > > Like IORING_OP_NOP, the main use case is test, and it is very helpful
> > > for covering failure handling code in io_uring core change.
> >
> > Rather than use a new opcode for this, why don't we just add it to
> > the existing NOP? I know we don't check for flags in currently, so
> > you would not know if it worked, but we could add that and just
> > backport that one-liner as well.
>
> Yeah, it is just for avoiding to break existed tests which may not build
> over liburing.
>
> I will switch to this way, looks one-line backporting can solve it.

I guess backporting can't work, because application code expects
NOP to complete successfully with and w/o non-zero sqe->rw_flags.

However, the backport has to fail NOP in case of non-zero sqe->rw_flags.

Thanks.


