Return-Path: <io-uring+bounces-9851-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DD07B89EFC
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 16:27:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2DA061CC2F32
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 14:26:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91C993148D4;
	Fri, 19 Sep 2025 14:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kMAxtBZR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4678315D32
	for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 14:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758291938; cv=none; b=nbB5YJ/EWFV1RgjL/26hM8EbETOxkdq2DyG6LtG0fSoyCCxkRvUdXKtBR4EcSVODWsuXFStnL9MEZqqX7rlLlAoCE4hJH8e4vqUFCqMGyncrhFsUID98T6/ORCdf6LqYXiwgfNEGUSWC9OA/jWL0S4W4euVIYGeygd/H09Mbf4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758291938; c=relaxed/simple;
	bh=eB+PcYvBZVG/k2JZDS1ixdgXjEi4s1QRcpA+Fysv1Ok=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k6/wAMHqZfL59bGKW5vHS3PTFdfFRc6Dqohb+4jhys1TLYnfJg1cmVyin8PkEmhU+Hqae+M/lTTDTm3l0T3l8bFpI2y29cz6fM9P4LAmwUUo2zfT/sO60DIm1Zw4c5hfCLI1xVXjtvWZ0qXy1EYyBLnXLZn2bpHuuAU6KrNd4zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kMAxtBZR; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-3305aceab00so1325692fac.2
        for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 07:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758291936; x=1758896736; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wEObToCwEhK7VFcZgLny4Obray6ian1wf5eg76S619M=;
        b=kMAxtBZRTbfpYaN/ovc2oARsNiL9xCtmtUMKlHtlfqhmDKDNLWG56OlzgBC85YYu9v
         Op1GUNT3gjcMLHALTUzCnqmqq9sHsGFuGU0LWLOCIF6Yeo98Z+lSVlecfbFzbkBp+z8Y
         hc5twnSe/YrvhZimg7/fjqH/2WipDmO/m/savRWgH5ehYTwJBGuWB0y7wFCie+y4qebk
         pI+FUIW0SBsXwQ3czDH3FLPBHP0Q6fNBPsI7tsEFFJypP5rWDZT3LAfP9BsA9a+FgKhM
         CqwJ9mgRWpp1fa1AJ+2MG4nHLXKmnIm+S1NWQy4CiO16v45YsTHHF2T0HALKhvbivkFI
         ev0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758291936; x=1758896736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wEObToCwEhK7VFcZgLny4Obray6ian1wf5eg76S619M=;
        b=jafpdyH2fhDMM7IxTht1kV09+/x1oE/hT7W+YhCBpgd+PibzVwFRTcGzVaGLpIz+V3
         868K92wpZpmntZf7FvZZZnX//BbpFoH3N2bkwCtcYv/rVlOd/F1u4gqLmFpl/K1ESRWd
         LzHLtYB5krn9/KDWuoL7siefIE/nesyzMS7pTOc8TaYh9DczxHXOckZk0Lxeq0EudD9d
         QmoJsn3C7DvkFRqBuaCuT0cJ0RMItPmEwxrFXBLz2d6vjr6i1qjZJzFuSVMguYTIFpUV
         4xsXb9ZWgUBYmmtfLoJrC0vhfNbov+RWq90aXyEBdnMCMMlnDreuYB1Zbmj0GRzfbudo
         AHYA==
X-Forwarded-Encrypted: i=1; AJvYcCXbC2rPtN6SjPcsyx5hPVW1RDa9GGZ02cPYKSkSpnADlttJTJEr0T9FcKdJYQfqTVcjjsR74sMciQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy66d7XcP1yjijYO7aljEBt/AjMttGHYFaoUTU4QUtGS5Wede2m
	/zecrEE6fwJI0DGvRNgGN2cl1fcJJFGwmhxv5g51rEmmUE8KekDrsvPIYDcScep6QFM0mq8fEam
	IbQUWiVCVfqiG+gg6Jlf8Jk01l55CXEk=
X-Gm-Gg: ASbGncsyPWrXFSin9musujIwC1oZIllNwaqCgxrzePF3kI9udKH/TOVLlvDnuOrf5uA
	C2qkPUA1cyQlBfhC5XM6+c5VeS2tt2Fz/y+i9RPLYmnXQ/NgOb7fi2Sz9cfnZ9RmLD2oaVq3YZr
	D7YOyOsIsLCJjGcXbi42ocvdt/q167+lhpDODR2Q66e/nejvlG/UfjZFT48Kzs3oyPyzDXM+wIv
	w473SsHIP9ND8cp
X-Google-Smtp-Source: AGHT+IEpdQuUQJvuca2OGeQs0l+uEgL96+5pzKLvpCjwfkhO9zdiuc4IVAES4bBBAm7f3CEiZWi/bHFGko+HmJRhDr8=
X-Received: by 2002:a05:6870:5b83:b0:314:9684:fe0f with SMTP id
 586e51a60fabf-33bb4420d32mr1620156fac.42.1758291935622; Fri, 19 Sep 2025
 07:25:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250919090352.2725950-1-yangxiuwei2025@163.com>
 <152d553e-de56-4758-ab34-ba9b9cb08714@gmail.com> <CAAZOf24YaETroWiDjmTxu=2b2KVTxA1+rq_p5uxqtJqTVBfsJw@mail.gmail.com>
 <CAAZOf251fh-McW=7xdEQiWyQ-XfOC1tRTUnyTD4EHVaLG-2pvA@mail.gmail.com> <1e5ff80d-73f8-4acd-8518-3f10c93b4e40@gmail.com>
In-Reply-To: <1e5ff80d-73f8-4acd-8518-3f10c93b4e40@gmail.com>
From: David Kahurani <k.kahurani@gmail.com>
Date: Fri, 19 Sep 2025 17:28:24 +0300
X-Gm-Features: AS18NWCr3F-hcukfA3J7i1PrztFkwV8-MeXSrJjkpq03oY8eAiNHdoC8i02h1cY
Message-ID: <CAAZOf250CqN67DTXF+74-8q3JbRCAuaW=XbrxqoNaq09RNUOJA@mail.gmail.com>
Subject: Re: [PATCH] io_uring: fix incorrect io_kiocb reference in io_link_skb
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Yang Xiuwei <yangxiuwei2025@163.com>, axboe@kernel.dk, io-uring@vger.kernel.org, 
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 19, 2025 at 5:14=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 9/19/25 12:25, David Kahurani wrote:
> ...>>>> Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
> >>>>
> >>>> diff --git a/io_uring/notif.c b/io_uring/notif.c
> >>>> index 9a6f6e92d742..ea9c0116cec2 100644
> >>>> --- a/io_uring/notif.c
> >>>> +++ b/io_uring/notif.c
> >>>> @@ -85,7 +85,7 @@ static int io_link_skb(struct sk_buff *skb, struct=
 ubuf_info *uarg)
> >>>>                return -EEXIST;
> >>>>
> >>>>        prev_nd =3D container_of(prev_uarg, struct io_notif_data, uar=
g);
> >>>> -     prev_notif =3D cmd_to_io_kiocb(nd);
> >>>> +     prev_notif =3D cmd_to_io_kiocb(prev_nd);
> >>>>
> >>>>        /* make sure all noifications can be finished in the same tas=
k_work */
> >>>>        if (unlikely(notif->ctx !=3D prev_notif->ctx ||
> >>>
> >>> --
> >>> Pavel Begunkov
> >>>
> >>>
> >
> > This is something unrelated but just bringing it up because it is in
> > the same locality.
> >
> > It doesn't seem like the references(uarg->refcnt) are well accounted
> > for io_notif_data. Any node that gets passed to 'io_tx_ubuf_complete'
> > will gets it's refcnt decremented but assuming there's a list of
> > nodes, some of the nodes in the list will not get their reference
> > count decremented and
>
> And not supposed to. Children reference the head, and the head dies
> last.

I am not sure about the mechanics of this. This is only based on
analysing the code but it seems, if a child node gets completed, it
will pull all the other nodes in that link by jumping to the head
node. But, I trust that you know better :-)

What do you mean it's not supposed to? All the nodes eventually go
through 'io_notif_tw_complete' to be queued back into request queues,
if any nodes whose reference was not handled(all nodes get a reference
of 1 at allocation) goes through the method, then the warning will
trigger.

>
> > that will trigger the lockdep_assert in
> > 'io_notif_tw_complete'
>
> Did you see it trigger? If so, please attach the warning splat.
>
> > It doesn't look that this will have any consequences beyond triggering
> > the lockderp_assert, though.
>
> --
> Pavel Begunkov
>

