Return-Path: <io-uring+bounces-9843-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B9AE0B893FB
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 13:22:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6383D1C25E36
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 11:23:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1860730ACF5;
	Fri, 19 Sep 2025 11:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cP+hWh2v"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669B119D082
	for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 11:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758280950; cv=none; b=Svgf4mQshItQgum7T5Q08hqf4CTxYON6m7xzIfNrvIalhx4TP+OE9OSmIH0SZ1sIwCcQvKodoITuikxlYj4PEYfx7XuZqsWmo2BEvp81OGf8U92882LRGz3owi8PecYu59haQyi3OQfuOs28Q5v/isQacMmg4dCiOouLuIihiT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758280950; c=relaxed/simple;
	bh=xqfNcyFjMeQTlz04BLbT7AfC0WImpsJRY67rVwDfgIw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tWFOs/c0pzcJL1r1Wr0Or5FaeGia4mOhGZXhekG8s7ECUfs0fd6lqBIY4rfJbO3zXBe7m6RCH4D379aafB6bCNRveyGV2uwdAIpqCajxLIKIa+ivODtVHCXYPurj46DurqEK/AoSkD3WfUnjAhmJx43mWQjdjxPWDVU6fCByeHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cP+hWh2v; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-30cce8c3afaso1554097fac.1
        for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 04:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758280947; x=1758885747; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O2b6lkwHmzdEZ9rVa6idtxaJ42fUXXMbf3f4Nbvq/zU=;
        b=cP+hWh2vpdpW4zuHTH3764Ks405IZur0ERYt1XlHhzK0lqyuShVOTIJVqIx/eb+lTM
         1P0wlYMutaMZcG6TnLTcfxqgSOSqF/9utIJL9ONbV9p7VhsOhuy06wcTDNxVbYukecs8
         Z6ZKJ5mexkU1181lLq1jK62E8g29SosqWFgJ5Cks82f/iPyZPY9q/MMOfp5PTp3/pHbv
         gEPUfNWfLqNJJl9jDSlyxCLSetciwth7KSiDsaRPJ+p5EdHVphTA5RvTUsksYGPHX60e
         q33CVx8FVQG5P5+6bUhdXxxcd3+p+plsCGqsMJA5GYfIb9tag/oqXplkpUXwUyhDiChM
         LMrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758280947; x=1758885747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O2b6lkwHmzdEZ9rVa6idtxaJ42fUXXMbf3f4Nbvq/zU=;
        b=ti1Aqh17T0ElUmpAX4b0s3XvpIo/b8Tmhniui/9nMY1DurRzf6BFQwnlPxlgVesfAM
         0DIqN/d7PYbk+lC1vQQaDH1JWXRt7sOiUT5lHfOGGvdu65m8gjH0TlMfrP0GFXnbDwMY
         FagzSD4fc6yIzTk0p5jiMM/GNSsnefQLgHtk1bIoqnskfDKXJv++gAJuEhJXsnz3ngRf
         nxWlodsMmAKMb0Yyy5j9to0oyC2jdJnoAo5Wklb2dkP751CZbJx0QomoFRWdpj/inaxx
         vbITb4vSgFSKLTu/+eFvRLWnjxh0ji+iK9xYDsylCfjonpy+lXYNT7h2crPyozmqTWPi
         V4VQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5vcgeddruUO+K2XIZ0iW6LN7iQSjdEpR1GPx3SYdQWoDkbLHtjWq+uqrsCpJynl6PV6vc3eJeAw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzHoQmq2P6WnfXkKqIfOP42dahRnpicEPpcNFUPJmQwekWu3skt
	eQNA401J4XCMA+IdcY7Jejz3ONZGLw7Z941YXxT+yuIdb2/M8QXY9x/5SQ30+Sfw97dV0ro+8tU
	2oUmq+6NsLEClnCIq0ZoDe0kOlrcGKDw=
X-Gm-Gg: ASbGncuWpFRYsDoxP23jZdJ+vsEshk/qx0HFlC3BSDanKj66VDY69iDpTVDOcDJFqG1
	AIwt/bs52L+TJ+6PiOcTSzR53hGq9lMZRTXLrPSyCMGbVfjhDUN9FfjUN3RK7rpBojx91oo6dzA
	2m4NzhhhnVzQV/4kvW33QKtt/b63PwcrtUUo4DDchcM0DJKzDlCcrkpO65u4br6s3bvb+YYmMXm
	D4UMQ==
X-Google-Smtp-Source: AGHT+IGGP6kWf1/9bBM/TrtpawTO/ddRT+BcKAbP1uWmz4yJ/oySIDGTyb9QCB5qXXzbi0psUzYnC/nljWLqNvMHuyM=
X-Received: by 2002:a05:6871:4609:b0:321:80a7:a1ae with SMTP id
 586e51a60fabf-33bb25e9cb4mr1637044fac.14.1758280947454; Fri, 19 Sep 2025
 04:22:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250919090352.2725950-1-yangxiuwei2025@163.com>
 <152d553e-de56-4758-ab34-ba9b9cb08714@gmail.com> <CAAZOf24YaETroWiDjmTxu=2b2KVTxA1+rq_p5uxqtJqTVBfsJw@mail.gmail.com>
In-Reply-To: <CAAZOf24YaETroWiDjmTxu=2b2KVTxA1+rq_p5uxqtJqTVBfsJw@mail.gmail.com>
From: David Kahurani <k.kahurani@gmail.com>
Date: Fri, 19 Sep 2025 14:25:16 +0300
X-Gm-Features: AS18NWAKO0tCFV08N5BvozOdfl3-6-qo3npWVrYGM6yTrpAAhkAiUEgj3_pugaU
Message-ID: <CAAZOf251fh-McW=7xdEQiWyQ-XfOC1tRTUnyTD4EHVaLG-2pvA@mail.gmail.com>
Subject: Re: [PATCH] io_uring: fix incorrect io_kiocb reference in io_link_skb
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Yang Xiuwei <yangxiuwei2025@163.com>, axboe@kernel.dk, io-uring@vger.kernel.org, 
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 19, 2025 at 2:23=E2=80=AFPM David Kahurani <k.kahurani@gmail.co=
m> wrote:
>
> This is something unrelated but just bringing it up because it is in the =
same locality.
>
> It doesn't seem like the references(uarg->refcnt) are well accounted for =
io_notif_data. Any node that gets passed to 'io_tx_ubuf_complete' will gets=
 its refcnt decremented but assuming there's a list of nodes, some of the n=
odes in the list will not get their reference count decremented and that wi=
ll trigger the lockdep_assert in 'io_notif_tw_complete'
>
> It doesn't look that this will have any consequences beyond triggering th=
e lockderp_assert, though.
>
> Maybe my analysis is wrong?
>
>
> On Fri, Sep 19, 2025 at 2:16=E2=80=AFPM Pavel Begunkov <asml.silence@gmai=
l.com> wrote:
>>
>> On 9/19/25 10:03, Yang Xiuwei wrote:
>> > From: Yang Xiuwei <yangxiuwei@kylinos.cn>
>> >
>> > In io_link_skb function, there is a bug where prev_notif is incorrectl=
y
>> > assigned using 'nd' instead of 'prev_nd'. This causes the context
>> > validation check to compare the current notification with itself inste=
ad
>> > of comparing it with the previous notification.
>> >
>> > Fix by using the correct prev_nd parameter when obtaining prev_notif.
>>
>> Good catch,
>>
>> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
>> Fixes: 6fe4220912d19 ("io_uring/notif: implement notification stacking")
>> Cc: stable@vger.kernel.org
>>
>>
>> > Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
>> >
>> > diff --git a/io_uring/notif.c b/io_uring/notif.c
>> > index 9a6f6e92d742..ea9c0116cec2 100644
>> > --- a/io_uring/notif.c
>> > +++ b/io_uring/notif.c
>> > @@ -85,7 +85,7 @@ static int io_link_skb(struct sk_buff *skb, struct u=
buf_info *uarg)
>> >               return -EEXIST;
>> >
>> >       prev_nd =3D container_of(prev_uarg, struct io_notif_data, uarg);
>> > -     prev_notif =3D cmd_to_io_kiocb(nd);
>> > +     prev_notif =3D cmd_to_io_kiocb(prev_nd);
>> >
>> >       /* make sure all noifications can be finished in the same task_w=
ork */
>> >       if (unlikely(notif->ctx !=3D prev_notif->ctx ||
>>
>> --
>> Pavel Begunkov
>>
>>

This is something unrelated but just bringing it up because it is in
the same locality.

It doesn't seem like the references(uarg->refcnt) are well accounted
for io_notif_data. Any node that gets passed to 'io_tx_ubuf_complete'
will gets it's refcnt decremented but assuming there's a list of
nodes, some of the nodes in the list will not get their reference
count decremented and that will trigger the lockdep_assert in
'io_notif_tw_complete'

It doesn't look that this will have any consequences beyond triggering
the lockderp_assert, though.

