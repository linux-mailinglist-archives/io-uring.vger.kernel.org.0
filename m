Return-Path: <io-uring+bounces-37-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E3DC27E28BA
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 16:31:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CFE6280FC3
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 15:31:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A87B28E09;
	Mon,  6 Nov 2023 15:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iza8Jq4T"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B876E28E07
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 15:31:36 +0000 (UTC)
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741AD184
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 07:31:35 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id 38308e7fff4ca-2c59a4dd14cso62112391fa.2
        for <io-uring@vger.kernel.org>; Mon, 06 Nov 2023 07:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699284693; x=1699889493; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x9QxfZ+Ls8EMKh9oDonb3sgkTQ/mMy8Zu2/Y77oDg/g=;
        b=Iza8Jq4TLkOuiXT5wQCNEfsXgmJ4g4KOdlJZk1OmCB7ThKqCnIi1loS64XKvf2FOA/
         2LCTu5Wmiif6L6aZf3WmLmxpdWhNEMjLmBsPcONtMV01ioVAfQBiuidtovlSRaONL0zp
         nIaTs16uJdnATm77nA0lNKLeS295mJn46/ZM2FfR8Lh4zFGae16rI5ObmxEVCWd/78Lz
         hoyrjfINh3IyUcy4UBsPvXFHEk59S9LIJlrqIUVJ8pNN9coLuBkoN1zvumexym/EhwoK
         8lwWFlB116/oNo/dDZZ6SbFtySb1Kw+dTWXJv/pzgakXGbrmhDCk1VJFdVvKY/FySQCl
         G5lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699284693; x=1699889493;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x9QxfZ+Ls8EMKh9oDonb3sgkTQ/mMy8Zu2/Y77oDg/g=;
        b=f9oPqDGnhMyBmBGoVF/wWVed3P/iepCAhuBNAQyLH+0t6ryf1xnhAL+m76aVY0zJrR
         N/yVe4eRRlTQM7DuqRINv9IuOW0t7Uh0nQXR04KNkkt3/JKzoxLuL5bhuWwrJvN8QHiG
         Hk3eNTfZ29FjI36wDeaQig13TQHoMvyJ8lMgjpwKBbAuoe0U6lRUkP5ruVVfSRlkbcgp
         zikWijnV8eX4gnX7Yw/z2kMh9QCCqJ0vlOjiYyj75NASS1ymli07ob7K8rnXRvVCbTZ8
         8s/5O9bySlSYNBVhvIUBPNkGZkPrl2TEtYHc/Uiowwj3GmqoOeoHh+ileV1PPk1BtJ7s
         j/Ww==
X-Gm-Message-State: AOJu0YxSWsby4Ex2pWyRU6VqwBAXiBMGSrGByrRCyD2Kv5PxJMC1rwZE
	T+MxyOlTZ4YKDY7bSztUSRAVf8LUBNmwyF9QlqE1fa6I
X-Google-Smtp-Source: AGHT+IH1POcQJ4e54ltnhGoMcbz9zb+LnNXGIrO/xF2TEP+PW+umKe6kM/fPwArjnYXgEhLOUSymiFln0MV5RU4uMzw=
X-Received: by 2002:a05:651c:210e:b0:2b6:df71:cff1 with SMTP id
 a14-20020a05651c210e00b002b6df71cff1mr29079028ljq.52.1699284693255; Mon, 06
 Nov 2023 07:31:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231105223008.125563-1-dyudaken@gmail.com> <20231105223008.125563-2-dyudaken@gmail.com>
 <d6cbb872-b1fc-4e91-96f9-46d814a94974@kernel.dk> <2699f7c9-3d56-4ce4-be49-be8b2903ac11@kernel.dk>
In-Reply-To: <2699f7c9-3d56-4ce4-be49-be8b2903ac11@kernel.dk>
From: Dylan Yudaken <dyudaken@gmail.com>
Date: Mon, 6 Nov 2023 15:31:21 +0000
Message-ID: <CAO_YeohFBDFSsnBEyb2G-1SrMsrO-b+DuN=2HqTF9Kvd2Loipw@mail.gmail.com>
Subject: Re: [PATCH 1/2] io_uring: do not allow multishot read to set addr or len
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 6, 2023 at 2:51=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 11/6/23 7:32 AM, Jens Axboe wrote:
> > On 11/5/23 3:30 PM, Dylan Yudaken wrote:
> >> For addr: this field is not used, since buffer select is forced. But b=
y forcing
> >> it to be zero it leaves open future uses of the field.
> >>
> >> len is actually usable, you could imagine that you want to receive
> >> multishot up to a certain length.
> >> However right now this is not how it is implemented, and it seems
> >> safer to force this to be zero.
> >>
> >> Fixes: fc68fcda0491 ("io_uring/rw: add support for IORING_OP_READ_MULT=
ISHOT")
> >> Signed-off-by: Dylan Yudaken <dyudaken@gmail.com>
> >> ---
> >>  io_uring/rw.c | 7 +++++++
> >>  1 file changed, 7 insertions(+)
> >>
> >> diff --git a/io_uring/rw.c b/io_uring/rw.c
> >> index 1c76de483ef6..ea86498d8769 100644
> >> --- a/io_uring/rw.c
> >> +++ b/io_uring/rw.c
> >> @@ -111,6 +111,13 @@ int io_prep_rw(struct io_kiocb *req, const struct=
 io_uring_sqe *sqe)
> >>      rw->len =3D READ_ONCE(sqe->len);
> >>      rw->flags =3D READ_ONCE(sqe->rw_flags);
> >>
> >> +    if (req->opcode =3D=3D IORING_OP_READ_MULTISHOT) {
> >> +            if (rw->addr)
> >> +                    return -EINVAL;
> >> +            if (rw->len)
> >> +                    return -EINVAL;
> >> +    }
> >
> > Should we just put these in io_read_mshot_prep() instead? Ala the below=
.
> > In general I think it'd be nice to have a core prep_rw, and then each
> > variant will have its own prep. Then we can get away from random opcode
> > checking in there.
> >
> > I do agree with the change in general, just think we can tweak it a bit
> > to make it a bit cleaner.
>
> Sent out two cleanups that take it in this direction in general, fwiw.

Yes - I think this approach is better, will rebase on these

