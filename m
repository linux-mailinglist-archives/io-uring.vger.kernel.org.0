Return-Path: <io-uring+bounces-2355-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C5F0F9182C2
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 15:40:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0547B1C21D6F
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 13:40:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74ED1181BB8;
	Wed, 26 Jun 2024 13:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JQUjrFFw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3642183066;
	Wed, 26 Jun 2024 13:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719409203; cv=none; b=WrJiITZ3JEa4YjV3ZCL0VeW3ndGEP24TpJIwxEllrkBOekY95M3HDHRJxBBoci23pO3Rj5RmXqOK4WUxr8MED/XCBNkD/EaU6rnZpem4cpPsYSleXYETCCbr8VrJeswxGeYtVbO7M3rmZT2Roo8gNLn//lghioPv61WeRHjOazk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719409203; c=relaxed/simple;
	bh=Gqu0PPKIwlu8QuP2Vr7fBcBkhvn7fHduxivYLrhRASU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p1auwMc18h77Ayxiep+2pttP3eHH2s6leIvXgWKJgfpcqDCcYtMmrF4pgphbApu/hDcaXa+eOJNO4kV89UAltEmz32Ps6LouuBawbQW5RfZWwaXD29MGZnPI1yQiFhwMVlyiVoGfAvRXk5geMuU15umfzg8eoc/uBMie5PspgPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JQUjrFFw; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2ec17eb4493so91299731fa.2;
        Wed, 26 Jun 2024 06:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719409200; x=1720014000; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z2rgHVkzSP1+jy0s2RuB1Mh0tkpnHZ/bSgJ6vFvgRzo=;
        b=JQUjrFFwf1IYGzamdeC1Hkq11d6+RjpcdnSulrmokNdkR8QOF0//ku3N12PAboUKEb
         LAR+mhQrNEaNTGX98EpL/thcT7x/H9WKOtqxK2iTNmV4xl1QXg22updh29RtBozat4DX
         b6pQXRvgdWDTfzSJg4f+5RGBylBm7yj5n1m2C24pjCFTVeMsnnG1eqLXtsK3WmfBAT7D
         uq7yQH7kVW52ZTDMwETRfVAb7Ft7WnmvM9V97fz8lNC00wCcbPl6yBYNUC8H8qNCu1Eg
         YqNneAzYohqaDjwwqapSrjFhgiyGtal5YOh2k8tE/vs/ddQFCzEAsGX986I0MrUvrFYa
         wt1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719409200; x=1720014000;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z2rgHVkzSP1+jy0s2RuB1Mh0tkpnHZ/bSgJ6vFvgRzo=;
        b=wAClwnQASP9qqMGpXdnVCbsAecWhiRUSivK8bZ9A/ZxNhxY986R2ZzzhTwU8JpjyJO
         s3S1rC0UweP+yhSsWkxOCGDCHIgYZ2b5D2xyA8mfwBoIRUsZL4BplLJ0rZMGk96ZZC80
         ks54Vm5HCf1/PPRWDZM+00z2ua6uoxTz24qXihttsqELBu1034ytDaJPsHWHAx6DZpQR
         ZCP47VTZt1+moPiZ3MNc/pslvjz/bsD9nm113LtFIJxwEIYhpViBN9MKOYda8Z/ImWMg
         NRyLiA863lYXDRBb5rnBGvxKMLPXYZh0Y7171oHZZhRi211v+XNbdtjUukovw0qzaWTX
         0YAA==
X-Forwarded-Encrypted: i=1; AJvYcCWFopAOCTkla4a5pTgtD8UcdIDK2cCFJSCdr0B+TkUNAL3r68/jelPkcuHqrq6JKA0IwHZQLx6Iq6w3pkV3W50fAbVzyZdrb7bHYOZa0S5sH8pczKeXDhJEM/rvVhy9FtVgGomImEF9L2irRJcKWXZkFuX7P2lUY/oVE6XhUERlHfRdBX2D
X-Gm-Message-State: AOJu0YzLVIzKxK9BUurJPE6nA5tw+S4EX0u56BtyyrWsk3vlFK4gz1pO
	9+iBdlRV9oQxqndtBo8N2jFPTx6o35zqJ5+YkORJVnN7Q3/GbuV29oBZyhOU0bAdtFs44Z6yVR1
	jXRZIttCAwdY6PcmkyzKMQTltOY/nDxmq
X-Google-Smtp-Source: AGHT+IGk0pHam1HcXl3oj5p0qyRebtuWcVPso250LB/Bc8g6Hkc3v3sN/kBayKvUzph5ne4gUS0Lvblrc1cqdICkuqo=
X-Received: by 2002:a2e:7c07:0:b0:2ec:4f0c:36f9 with SMTP id
 38308e7fff4ca-2ec5b31d140mr86286441fa.36.1719409199559; Wed, 26 Jun 2024
 06:39:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240625151807.620812-1-mjguzik@gmail.com> <0763d386dfd0d4b4a28744bac744b5e823144f0b.camel@xry111.site>
In-Reply-To: <0763d386dfd0d4b4a28744bac744b5e823144f0b.camel@xry111.site>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 26 Jun 2024 15:39:47 +0200
Message-ID: <CAGudoHH4LORQUXp18s8CPPLHQMi=qG9aHsCXTp2cXuT6J9PK6A@mail.gmail.com>
Subject: Re: [PATCH v3] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
To: Xi Ruoyao <xry111@xry111.site>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, axboe@kernel.dk, torvalds@linux-foundation.org, 
	loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2024 at 4:59=E2=80=AFAM Xi Ruoyao <xry111@xry111.site> wrot=
e:
>
> On Tue, 2024-06-25 at 17:18 +0200, Mateusz Guzik wrote:
> > +     if ((sx->flags & (AT_EMPTY_PATH | AT_STATX_SYNC_TYPE)) =3D=3D
> > +         (AT_EMPTY_PATH | AT_STATX_SYNC_TYPE) &&
> > +         vfs_empty_path(sx->dfd, path)) {
> >               sx->filename =3D NULL;
> > -             return ret;
>
> AT_STATX_SYNC_TYPE =3D=3D AT_STATX_FORCE_SYNC | AT_STATX_DONT_SYNC but
> AT_STATX_FORCE_SYNC and AT_STATX_DONT_SYNC obviously contradicts with
> each other.  Thus valid uses of statx won't satisfy this condition.
>

I don't know wtf I was thinking, this is indeed bogus.

> And I guess the condition here should be same as the condition in
> SYSCALL_DEFINE5(statx) or am I wrong?
>

That I disagree with. The AUTOMOUNT thing is a glibc-local problem for
fstatat. Unless if you mean the if should be of similar sort modulo
the flag. :)

I am going to fix this up and write a io_uring testcase, then submit a
v4. Maybe today or tomorrow.

> --
> Xi Ruoyao <xry111@xry111.site>
> School of Aerospace Science and Technology, Xidian University



--=20
Mateusz Guzik <mjguzik gmail.com>

