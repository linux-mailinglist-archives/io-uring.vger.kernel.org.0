Return-Path: <io-uring+bounces-2333-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6B439168A6
	for <lists+io-uring@lfdr.de>; Tue, 25 Jun 2024 15:14:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 58A39B2675C
	for <lists+io-uring@lfdr.de>; Tue, 25 Jun 2024 13:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD9AD158D81;
	Tue, 25 Jun 2024 13:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DKgdR4K0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A809156C72;
	Tue, 25 Jun 2024 13:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719321234; cv=none; b=pBq+nzuUXVfNdRpdBp1aizR3tykKkTrPQZUvv0OhjPEylg5SURPrUcanDa1PQH39bPwBkiggpS29r3t687eCaQibyBT5f1nQL9AMpL9YaQHIVFYauvb1AcjRqj2SszSdkxtg3JB0Lxxv3pygNERK0aIA6QMbelqns/qFTA1wcb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719321234; c=relaxed/simple;
	bh=LenyA9+Q6yORuJax1aNhoSGTHebJWb0mapvIs+m1FOo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K3ZejqJdXVGLrk+ppanamguXhTfx0su3lvbz4HVyE/DMjd5zC9sjByZfpBJ3ODVViBlHY6ZSLCu63Gr0tlw+h7VnJteMjSoyPtc07o3LsE0ktu8agWgmz5IoCetAzvoAUM0Hk6igncoRfI+f1LsU17AP40rYe3NAu/7tFg0ctWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DKgdR4K0; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-57d1679ee6eso9470737a12.1;
        Tue, 25 Jun 2024 06:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719321231; x=1719926031; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QGzpktfJRyUxPQFZpXSO9yzkCznXX9uHT8bGtJuHl7k=;
        b=DKgdR4K0MHWAuLjMlbK2cwmvCVFRJoGcdMgkuWs/HN+tUbS+WhmojP1a3deTJ44BNu
         mxI9wanEnMGT8BV4am4ocOfOPO1oJsXVezQASBbBpe3iqcMRaVOqW5Q0DgZDtvurb7Sy
         oihla/VXFWKnMoAx/C5CbY1TP1Cx0CeNNjZOCxw/1AiXxCR9iQkR2Q+S6yLs/hypg7FR
         4fWk1p+hDeY9pPdaDEBmIYRgPnt5WcnQns9yADMk51qyST24FFpPX5EdiKOp7bpGlU+L
         afYoSaupJJk6XHP+fQQWz9G1wU2a2SqCPHiaQmI7V7UrYVT6gXiwkXddWcXcAVWsj1m1
         XKMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719321231; x=1719926031;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QGzpktfJRyUxPQFZpXSO9yzkCznXX9uHT8bGtJuHl7k=;
        b=O8pdrS9dRguCL1zB9bOKXbRcuYKeu1SHjOdld7xcu6xYugyJYQUHtmJMGbCb2q4Wdp
         obxGyeYahvNUxlGcSUilJaO/VewVsk0/BDLvlONNiLIUpsMs+lcJ4OqmNq+Dc3oYrmtq
         KPsvT20FldCYw2uRf1Fx1CvvJjkFDxUaTAnpI2jaiC3IxjLE7nBhAGTWU8C7IHpq6SqZ
         /CxFcnLwHWyfsMlNsLrM6WTNyBsGx63c03Rhglrjnz3FsfUUyUPhHisvkFI3NRoNmPD7
         v4hcBLKLjW5b0F2fd3gGjgB3+TBxhCU0Z6aZXOzvrklkaWXKXRZO9BU6cv4Hh7MiJk90
         VRsA==
X-Forwarded-Encrypted: i=1; AJvYcCU63bH4mNmSgo5I+ioCSrrtADOoJSWTX3qPJrGX1ls9A/A8fPtk6YRcbVsxiCmDzkYwotw2U8MI5wVfkDL+kOE7GuAwxNoFrbysP7c2qKg4SjG728rR9vcg1mMoGFAKAg7cxOrDbIyflg0rU7kVDoQ+LTNVBw4Syw+spNlgfuVDdJwUQyoV
X-Gm-Message-State: AOJu0YxTACt2/TGlx2eMqyhlxKzlX3AcVQ0FeKv29FjNhxBF0WRPPsPF
	dBfMZKcHXtSNpP9le6NasfDGlB6SQPaW3bxyOT79Ky4YtSySmQHTQPAm+MHz2EtLWIqkoLDjnVU
	x2dA9ngQdu5kYX66Q8B5v/x4faJk=
X-Google-Smtp-Source: AGHT+IHh0ZN6yJu8kV5hXz37pyRTo/0xrpIijyxYdmwWm/0ViHT6iwVzEMCIC7Y/3WlXQk5jm4DyBBE4cruOAxFPnnw=
X-Received: by 2002:a50:d547:0:b0:57d:3e48:165d with SMTP id
 4fb4d7f45d1cf-57d701ba9c2mr1894059a12.4.1719321231250; Tue, 25 Jun 2024
 06:13:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240625110029.606032-1-mjguzik@gmail.com> <20240625110029.606032-2-mjguzik@gmail.com>
 <19ec107368c8c8dd4e627b404106c30b73132cb0.camel@xry111.site>
In-Reply-To: <19ec107368c8c8dd4e627b404106c30b73132cb0.camel@xry111.site>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Tue, 25 Jun 2024 15:13:38 +0200
Message-ID: <CAGudoHGNU3V6+4N+zEsQKUczJqgi6vbtJ2pWowVhZZR7cYDbSw@mail.gmail.com>
Subject: Re: [PATCH 1/2] vfs: add CLASS fd_raw
To: Xi Ruoyao <xry111@xry111.site>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, axboe@kernel.dk, torvalds@linux-foundation.org, 
	loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2024 at 2:23=E2=80=AFPM Xi Ruoyao <xry111@xry111.site> wrot=
e:
>
> On Tue, 2024-06-25 at 13:00 +0200, Mateusz Guzik wrote:
> > Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
> > ---
> >  include/linux/file.h | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/include/linux/file.h b/include/linux/file.h
> > index 169692cb1906..45d0f4800abd 100644
> > --- a/include/linux/file.h
> > +++ b/include/linux/file.h
> > @@ -84,6 +84,7 @@ static inline void fdput_pos(struct fd f)
> >  }
> >
> >  DEFINE_CLASS(fd, struct fd, fdput(_T), fdget(fd), int fd)
> > +DEFINE_CLASS(fd_raw, struct fd, fdput(_T), fdget_raw(fd), int fd)
> >
> >  extern int f_dupfd(unsigned int from, struct file *file, unsigned flag=
s);
> >  extern int replace_fd(unsigned fd, struct file *file, unsigned flags);
>
> FWIW this change is already in the mainline kernel as
> a0fde7ed05ff020c3e7f410d73ce4f3a72b262d6.
>

Thanks.

I guess I should have rebased that branch before adding stuff on top
of it, no damage done though. :)

--=20
Mateusz Guzik <mjguzik gmail.com>

