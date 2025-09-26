Return-Path: <io-uring+bounces-9883-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 76536BA53D6
	for <lists+io-uring@lfdr.de>; Fri, 26 Sep 2025 23:46:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FA906210D8
	for <lists+io-uring@lfdr.de>; Fri, 26 Sep 2025 21:46:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CB01277016;
	Fri, 26 Sep 2025 21:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nU/3u12f"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C8A22127E
	for <io-uring@vger.kernel.org>; Fri, 26 Sep 2025 21:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758923198; cv=none; b=aUEeZJPPEmw2Hmdviyp0lyizTNWcWJH8m436/V3B0BjAP46x/n4yLMCW29LgX487mdw/gpXBAC9+gzjuMEq0GC8FvdgHAXLWLvjXa9cO4O+EYOYeU6Gzyh7oWz9y7CHy1Wwjr8LMZg66gqeG5BJ2ri7MgxrPtAPmJ0BUNvb0/XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758923198; c=relaxed/simple;
	bh=aLQmgrcBCD7Jirq1emaSTIekKmA+nntsn5bAl9SViAg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZulxIxK0AWZ1zo4Slu2ASQHX1rRWDpuDTQZijmHLtYqU+y9Z9Y+C3ObHbohUj7iL4vyjUV54/nsWe/8fMHxz6igCcQJmgssUYJ5Hl3u4x/5T1+TQ9so26HZjn2omVjlkdb70AJBBbIhvzo04WOSMP8SfrFvO6gQGwtYFHyLLvXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nU/3u12f; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-36a6a3974fdso3179011fa.0
        for <io-uring@vger.kernel.org>; Fri, 26 Sep 2025 14:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758923195; x=1759527995; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aLQmgrcBCD7Jirq1emaSTIekKmA+nntsn5bAl9SViAg=;
        b=nU/3u12fhiOxGD2MIQ2ZtJqzo1sQilgxmx+Uv5+phrTrDCKwZ4PblsqLDg5QG4wk0n
         A0aYYuAmnicDRqTTHSfOAVxWB5HqkPjdcLJidoHivjDtnG0THrHdRL4wz8HI4hMR1bVP
         VNgNZpg+2htL1TTPkaO2Ui6W1KYBXh0Tkt5RtdKSXLR0i4cknSuOUDTsTCY+7w16wf7z
         8DzW+GEY+aY3XQ/kKGSLZX8QkC2OLziOPkWjNRY48gD2aqSVRduEaSZKYCNdZsS8x/fU
         4CpwsDCfX+YfHYMV6Yix8n7DjGOYjsNULP0CGuGorFtbjTGjYwQoGXmWfBFs3MCcPcWJ
         gh+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758923195; x=1759527995;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aLQmgrcBCD7Jirq1emaSTIekKmA+nntsn5bAl9SViAg=;
        b=IknpHhlYTO6xD5kOO+s/CnlmjG91DNrX89KDBDwup48lFgVm2Fz23USyOLRSNdOrjb
         yM2qfMRZ3/fem0uV0qHgVyslXP5EYEMEHsoPxiP+OyppGd7atBMmMarN+q+sPShXl0Hh
         R00b6/SgiMsL/BGarSVs46UeR8rIS3mSBS2dDz3RrJuIa8eAtnNw512KFHKzbnSAviA6
         R+kGfccZNYbUjFhlfy/5TEkEog6DEMVj9qkTa/TOAr/92116szSNWg4dMtzupj2wlTjI
         Iv1n+aLCv4Q9OGZu69PTd2I4YyfGnKg8LESsX20RFMXTenSScW8DFFxHCtijo2WgTJmA
         D6fw==
X-Forwarded-Encrypted: i=1; AJvYcCU5EmuD7Fnt9ZrBgLheRDzjGDI3F3lic4MBFF4vnzkNn+PxO004zqY9P59CKUoapgE66OPbXfQx6A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1LXFv6GgOWNEcqJu3AkbKJC8ghfLqv+s18VG/NeSG7P9ayvt+
	sPyvw1H5cR9bWQfR2SaLR27oSJHHsmTUyZ5Vy+0IQ3F5IuFOettVpHLvrC1bGj9nr1N+8xORK6+
	mSC9wclPxrvpUGjsexphfQm5DRGsEgzc=
X-Gm-Gg: ASbGncuwcuHoHZ1AnTffWXo8oU5a81kWGZ+Jb/Swg5Op+vxvVsH6DILI4pfQcSsl/t0
	yWX31NQMQ6XyBilNpTHvKNrAOEb96Gzq1UwELujgyG8pU2eRAdRroKV25IWt9EpX9hHcVCzfI4G
	3Qni8X8dOeBi5deSf50t1Ka3tmGAJ16/kPo79O8UlTQM2bi3pZkfUxslTBxk63kNUP7axXJuXFy
	rHeTw==
X-Google-Smtp-Source: AGHT+IEgLRa6CxdJA234UGmlehWF98uCwILnvU82N3MOI8NAYq0uYYpRpaW8WSitvHRRwH+XcY/nNNDQlaQtYATZIvU=
X-Received: by 2002:a05:651c:549:b0:36c:3b69:2cc7 with SMTP id
 38308e7fff4ca-36f79bf2043mr27315221fa.0.1758923194655; Fri, 26 Sep 2025
 14:46:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAERsGfiZ9YVeXMGk=dL+orN3o2HXJ0Oy9EQhVwK43MMDUSA-WQ@mail.gmail.com>
 <CAERsGfgCA7iFwLQ2L+=QyEg0=KuwK4hq62QcYpnY5R4h9abZMg@mail.gmail.com>
 <CAERsGfg8tHjtYQvDY5=rufh+PMGBNGCFxiYsNwMGn94o0e0VDA@mail.gmail.com> <1394af5d-ca1c-453f-8a66-f0f3a53702cf@kernel.dk>
In-Reply-To: <1394af5d-ca1c-453f-8a66-f0f3a53702cf@kernel.dk>
From: Vincent Fu <vincentfu@gmail.com>
Date: Fri, 26 Sep 2025 17:46:23 -0400
X-Gm-Features: AS18NWDSTVFRJ9ZbovoWyLmvQ9CnX5PP7rxmdta6z2pHmfQOsFgffX3f43xV4yQ
Message-ID: <CAOp=CXk-nuKPqf9d94ikWJPC9OoTGPcfTtA_kDYNrjqAptvz0A@mail.gmail.com>
Subject: Re: Fwd: fio: ruh info failed
To: Jens Axboe <axboe@kernel.dk>
Cc: Shivashekar Murali Shankar <ssdtshiva@gmail.com>, 
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>, "fio@vger.kernel.org" <fio@vger.kernel.org>, 
	Ankit Kumar <ankit.kumar@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 26, 2025 at 5:43=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 9/26/25 1:30 PM, Shivashekar Murali Shankar wrote:
> > Hi,
> >
> > I am currently testing fio with io_uring on an FDP-capable drive, but
> > I see failures such as =E2=80=9Cfio: ruh info failed=E2=80=9D when tryi=
ng to run FDP
> > job files. This is run on an XFS file system on a mounted drive. Do we
> > have support for this?
> >
> > Below is my fio job file:
> >
> > [global]
> > ioengine=3Dio_uring
> > direct=3D1
> > bs=3D4k
> > iodepth=3D32
> > rw=3Dwrite
> > numjobs=3D1
> > group_reporting
> > fdp=3D1
> >
> > [largedata]
> > filename=3D/mnt/nvme/largedata
> > size=3D30G
> > fdp_pli=3D1
>

FDP support is currently only available for NVMe character devices.
See the example here:

https://github.com/axboe/fio/blob/master/examples/uring-cmd-fdp.fio

> It's generally a good idea to CC the folks that worked on this, and
> probably use the fio list rather than the io_uring list...
>
> Adding them.
>
> --
> Jens Axboe
>

