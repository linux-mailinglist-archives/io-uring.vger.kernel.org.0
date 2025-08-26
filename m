Return-Path: <io-uring+bounces-9298-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CD6DB36FA8
	for <lists+io-uring@lfdr.de>; Tue, 26 Aug 2025 18:13:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 707015E336F
	for <lists+io-uring@lfdr.de>; Tue, 26 Aug 2025 16:10:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF5B027703A;
	Tue, 26 Aug 2025 16:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Otnk78S+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEBC1B85F8
	for <io-uring@vger.kernel.org>; Tue, 26 Aug 2025 16:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756224629; cv=none; b=COv/j6SfnfbFQEBtJ/zhxyzMM7lmN39xVSOzI0ckDNMA8U0Ap2GSqltT5Va4Fd1jNBUcwtxBtFIvIfxwzE4ewmmZf2Xn+XZ1V6Vui76nklfTVwD9i8anGsR2pimyDVvHaMavvrU3S7kvtUGH7kpLnCrauzrn5+WuV+gbpgIjENE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756224629; c=relaxed/simple;
	bh=ljgWQ0I9OKATQWlaTFoUzeTiJb9vnyii4a6+JizfhkY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VAqalUlhr19T1EepALh1BBfg9unUPKk2JDe1navVHENjMpYh/rx8BWuGsY8GGOSzSHN9obETlwd9pQ4Y4fLLrteASqzJbSvJ9OjEV4jxGJAiPMv+xFVVz8320LAk9ev+gIW48iysmXkp1uDwjahq1SDYj1K2sBKlLmq9bHm4wPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Otnk78S+; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2463d76f04aso6267745ad.1
        for <io-uring@vger.kernel.org>; Tue, 26 Aug 2025 09:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1756224627; x=1756829427; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=75BK7+ZwEvHCGrtEN3fqhyAEsT33fTNuQnhz7clnX5c=;
        b=Otnk78S+XPgeWYTVmgwP1wn7YOarhVA2qyzpjwoAx4Aj8D2Lv6ssIp1Vq04VQtYJ5J
         3Ih/f/cQT1opSFpfyeoj1R7lPJAykCIFpulqxmwMM+5IG6GLQQ871F/armkB6aqD/8dJ
         HQKD+WuWWholkM43eZhaqEMHKS4m+CMRowMz4/jyNhR1kEiQ+BeQQIAXjqoi011iNrwD
         FVDADCMY/GmusL0qF9xfJrHZx0emQOxAPPuirmAeLNiI1/YZmCpm6NU7X7dCwmrUUeDx
         1JnH4pO7xpxseoeeDhC2x3H6XYx4MGnoCK173FzDsJZO/WQ2T7ELVkleEmKxbVMtDVbp
         Ipnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756224627; x=1756829427;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=75BK7+ZwEvHCGrtEN3fqhyAEsT33fTNuQnhz7clnX5c=;
        b=u2E0+sUL1G7Hf/vgHWzVuALlacde3bdGEGM8u5M2fG5P7i7nyqSKUDclg8RNe5VPwR
         2jKTvzWay83JaWfqZkRItZ7yUaNU6kX7fisN2Rc0K8ltLcFGO57IUL2RVyd8JZsOXTHb
         0Q3eNezbFdZxm0+gu/PAkjixkCU4CL4et1Q1VaCiRUQ7fwJtjnqyGo2zPzpCA2KC0J39
         KPk2O0RH4ecGb/Odq6PxLfD6fA/YjqeCj7PsJsz0OZmWWYxWRhPU72tRl/AlteMLAdZy
         lca7DzExYkCcdUSG3XXZIXIBwob5QZz4a7cFBpnTeX7I8M6Iy/geIw/S2lwgqj8SXzHB
         ukmw==
X-Gm-Message-State: AOJu0Yx8s/2Iu+ge/K5v2KeqRCT3AtUJ0w/IwhRJMxWFpLiuaDrirzr8
	N//9CQbcTOIiD1e4DZUvYzYQue4+liu81U4rpUPdp9XyQrp6PjzFQxLgHb0f0vURbtAIImOZoQT
	bqK1Mju9gRlKVKlLmgHtH9cFzt3xSWqK1VuXCdnceOB2j6ns7AmkLf0qmvA==
X-Gm-Gg: ASbGnctFi/NZvMifKkb6RrkNcwsb3Bgy1OXyR/7Nu+76PL2+FsdsKT/yOT+lvNAeAUh
	D51hGshzQnk/0eCYlvby3i48svnnb9VTA/I1QARUHYrT2C1mV5PEmtvV4A9avc8rEtZnOUJQ3MB
	iLABRSE27zFEj/UaKIKS/0fVuMZYMs1otgnDk9Bml8jFVG6u5pCuwhggJzegGSwsG19jv7b3fYR
	PdNGEkjbxJ0qPu5YywdP6c=
X-Google-Smtp-Source: AGHT+IHBqgM/+Jz9mOHgsuMuJitRXsMyS7uQLs9vlpFK4KD6S3jtITFsk+KyB4xxjZqseLNXScD6rWXximRprEulLbg=
X-Received: by 2002:a17:902:e888:b0:240:280a:5443 with SMTP id
 d9443c01a7336-2462ee5d589mr103737715ad.3.1756224626600; Tue, 26 Aug 2025
 09:10:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c93fcc03-ff41-4fe5-bea1-5fe3837eef73@kernel.dk>
 <CADUfDZqcgkpbdY5jH8UwQNc5RBi-QKR=sw2fsgALPFzKBNcbUw@mail.gmail.com> <810863fb-4479-46ff-9a2b-1b0e3293ee71@kernel.dk>
In-Reply-To: <810863fb-4479-46ff-9a2b-1b0e3293ee71@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 26 Aug 2025 09:10:14 -0700
X-Gm-Features: Ac12FXwpoc5xTM-IjAEL2G9ThBaW6vsYpZC85HuPTTFQ7agJFJeyYhC6TN1fcG8
Message-ID: <CADUfDZonRMM5kKm-PvOzLwjsEUeRKWv08FN8tOwExS9UQCndsw@mail.gmail.com>
Subject: Re: [PATCH for-next] io_uring: add async data clear/free helpers
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2025 at 9:04=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 8/26/25 9:27 AM, Caleb Sander Mateos wrote:
> >> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> >> index 2e4f7223a767..86613b8224bd 100644
> >> --- a/io_uring/io_uring.h
> >> +++ b/io_uring/io_uring.h
> >> @@ -281,6 +281,19 @@ static inline bool req_has_async_data(struct io_k=
iocb *req)
> >>         return req->flags & REQ_F_ASYNC_DATA;
> >>  }
> >>
> >> +static inline void io_req_async_data_clear(struct io_kiocb *req,
> >> +                                          io_req_flags_t extra_flags)
> >> +{
> >> +       req->flags &=3D ~(REQ_F_ASYNC_DATA|extra_flags);
> >> +       req->async_data =3D NULL;
> >> +}
> >> +
> >> +static inline void io_req_async_data_free(struct io_kiocb *req)
> >> +{
> >> +       kfree(req->async_data);
> >> +       io_req_async_data_clear(req, 0);
> >> +}
> >
> > Would it make sense to also add a helper for assigning async_data that
> > would also make sure to set REQ_F_ASYNC_DATA?
>
> I did consider that, but it's only futex that'd use it and just in those
> two spots. So decided against it. At least for now.

Makes sense. I think it could also be used in
io_uring_alloc_async_data(), but it's true there are fewer sites
assigning to async_data than clearing it.

Best,
Caleb

>
> >> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> >> index ff1d029633b8..09f2a47a0020 100644
> >> --- a/io_uring/uring_cmd.c
> >> +++ b/io_uring/uring_cmd.c
> >> @@ -37,8 +37,7 @@ static void io_req_uring_cleanup(struct io_kiocb *re=
q, unsigned int issue_flags)
> >>
> >>         if (io_alloc_cache_put(&req->ctx->cmd_cache, ac)) {
> >>                 ioucmd->sqe =3D NULL;
> >> -               req->async_data =3D NULL;
> >> -               req->flags &=3D ~(REQ_F_ASYNC_DATA|REQ_F_NEED_CLEANUP)=
;
> >> +               io_req_async_data_clear(req, 0);
> >
> > Looks like the REQ_F_NEED_CLEANUP got lost here. Other than that,
>
> Oops indeed, added back.
>
> > Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
>
> Thanks for the review!
>
> --
> Jens Axboe

