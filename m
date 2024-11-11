Return-Path: <io-uring+bounces-4607-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 814C39C3F21
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 14:04:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D275AB229A9
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 13:04:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B428C19CCEC;
	Mon, 11 Nov 2024 13:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YzLuTKDs"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6788F77
	for <io-uring@vger.kernel.org>; Mon, 11 Nov 2024 13:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731330100; cv=none; b=sIqMYztsuzqHjlc+WFyg51QuVInHW1uFVEGBSl7k5TQ8Q0I00VHo53LZr+PPfu1AWKQu8I2Qzpg3H4uwm3VvWYx0U8ovMSdnmgjOULbdCQqhMIvmu96JqDwuB9UQjx5A8bu6iYK89UkHD8tyAnyV3oIKuuA0eXvgSSj6G4yZkkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731330100; c=relaxed/simple;
	bh=z1ZZagzUieFXuCrwNucPb3aoRSa/jZNnKPoqD30utlU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bSuIQUfFqWjb8dHBFOrmb+n+tBa8tPM91FbifwRYCg6n4J6mqlCnQSTu0d87PgLo5fzeuwDghJ0Tp8q5HFUSgP940MvV+bguKn/gOaK5s8yi4akTz/t8inoS3jT6ioF0sJ+/aoNG1wveS3LmlMKzsJsLu41fccPIGM05Zc2q5Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YzLuTKDs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731330097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pPtQepbnqHmI828IwqwqYCeFmxOpLdmVqebn/Kj0opw=;
	b=YzLuTKDsTL1b1ai4WN+B1V6kNakFh2z89I8BJcaw1Vr7pbrhEb1jgM8z9qsZ3gaGr7oXcY
	dxKo7yDLrImXW1QGMHPaPi8GhTsU0a2rGYGKI3kqeh5QIu3pBiL2bqxKhvslO0Yqixr3a9
	sIrbXW889laNmULu+has8Y/i2AEhiTs=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-235-arbfiTXAOB2Tn9g8NQscrw-1; Mon, 11 Nov 2024 08:01:34 -0500
X-MC-Unique: arbfiTXAOB2Tn9g8NQscrw-1
X-Mimecast-MFC-AGG-ID: arbfiTXAOB2Tn9g8NQscrw
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a99fd71e777so394779566b.2
        for <io-uring@vger.kernel.org>; Mon, 11 Nov 2024 05:01:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731330093; x=1731934893;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pPtQepbnqHmI828IwqwqYCeFmxOpLdmVqebn/Kj0opw=;
        b=Uc+tDC1AljeIv+dbjeQ7F2o64YTWSpy4BzsdaIw1B9CDuwNv4fiVKtXxYWEdot89t6
         cMKgwHK8hRGxIyLlI6/5shvhGtQxTWcKYm7lydCHsoixOQo3GAD6l2DarvO7XrfUmGc1
         c1N+FU36g9aE4shesFHS8xJgb8j8SwJFLPmAEfdUYPOwHb2t1YO1zCzXcltYcH0ntCbS
         nWX7xtgHjoC9PE2keCY+MqsqXQ/HVI7Rc2ONFICuTc7Edc/UTnHqNcImZwqLD/w78w3R
         oIprOsym5ISfaodlpxm0EdP6WsOoMLrB1CNdwJOOWN2THQ+N6bk7TqnlDiIO942N6lLt
         Zxxw==
X-Forwarded-Encrypted: i=1; AJvYcCUtXtt3hh8fJLPDRv5Zl/H8sWeDcd+QqSsVFQe+EHhaLfupOH5wC7Tvcvg7vyaiSeBbgJGmrmVqpw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyoQgUq1VLBN6C6oLsgfV7oO8MOJAKoPHDUTY1AeKdVPgNrmvUs
	tIZZ76NQDktphLW3xyFFm8bJ+QKQAMfjrwtdHRZTnHCVtpy1SE8sb54Y5J3GLv737HovK3SOdXZ
	HF/4AbQyG4/pX3FTIpF3sB9P9iFXvOJ9WUWcoWpxIJs5uigh/qQ1hwlupsmDYORnvluIjEFuQoV
	YAo8Q3fB7Zqu++xNn6gMLGp56FYRnJsjw=
X-Received: by 2002:a17:906:730d:b0:a9e:2ff8:c440 with SMTP id a640c23a62f3a-a9eefeb1271mr1095266066b.9.1731330092453;
        Mon, 11 Nov 2024 05:01:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IETpftFc+0EFa6WW+Z/qi2L4gm+U96UJWFXYyMz8PIj/8dQ7DvCVw0pX7HjwlExakJMoFjzEY/szANCL7/yWx4=
X-Received: by 2002:a17:906:730d:b0:a9e:2ff8:c440 with SMTP id
 a640c23a62f3a-a9eefeb1271mr1095261266b.9.1731330091903; Mon, 11 Nov 2024
 05:01:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241111101318.1387557-1-ming.lei@redhat.com> <CACzX3Av5sjUUX5Hz6n3Q-afZ14yFcA0g8Z=--tSuAyh2Sd_+Sw@mail.gmail.com>
In-Reply-To: <CACzX3Av5sjUUX5Hz6n3Q-afZ14yFcA0g8Z=--tSuAyh2Sd_+Sw@mail.gmail.com>
From: Guangwu Zhang <guazhang@redhat.com>
Date: Mon, 11 Nov 2024 21:01:20 +0800
Message-ID: <CAGS2=Yra0=sz_4TDi8iJDqW=6nu7DjDk3VJ9ePVkGJ51rmeQ9g@mail.gmail.com>
Subject: Re: [PATCH] io_uring/uring_cmd: fix buffer index retrieval
To: Anuj gupta <anuj1072538@gmail.com>
Cc: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	Pavel Begunkov <asml.silence@gmail.com>, Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

test pass after apply the patch.
Tested-by: Guangwu Zhang <guazhang@redhat.com>

# fio --numjobs=3D1 --ioengine=3Dio_uring_cmd --runtime=3D'300'
--size=3D'300G' --filename=3D/dev/ng0n1 --rw=3D'randrw' --name=3D'fio_test'
--iodepth=3D64 --bs=3D8k --group_reporting=3D1 --cmd_type=3D'nvme'
--md_per_io_size=3D'4K'  --fixedbufs
fio_test: (g=3D0): rw=3Drandrw, bs=3D(R) 8192B-8192B, (W) 8192B-8192B, (T)
8192B-8192B, ioengine=3Dio_uring_cmd, iodepth=3D64
fio-3.38-13-gf241
Starting 1 process
Jobs: 1 (f=3D1): [m(1)][100.0%][r=3D1109MiB/s,w=3D1106MiB/s][r=3D142k,w=3D1=
42k
IOPS][eta 00m:00s]
fio_test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4664: Mon Nov 11 07:52:0=
0 2024
  read: IOPS=3D142k, BW=3D1112MiB/s (1166MB/s)(150GiB/138132msec)
    slat (nsec): min=3D1520, max=3D894021, avg=3D2704.11, stdev=3D1197.90
    clat (usec): min=3D15, max=3D1145, avg=3D223.54, stdev=3D13.09
     lat (usec): min=3D18, max=3D1148, avg=3D226.25, stdev=3D13.09
    clat percentiles (usec):
     |  1.00th=3D[  212],  5.00th=3D[  215], 10.00th=3D[  217], 20.00th=3D[=
  219],
     | 30.00th=3D[  219], 40.00th=3D[  221], 50.00th=3D[  221], 60.00th=3D[=
  223],
     | 70.00th=3D[  225], 80.00th=3D[  227], 90.00th=3D[  231], 95.00th=3D[=
  235],
     | 99.00th=3D[  289], 99.50th=3D[  318], 99.90th=3D[  363], 99.95th=3D[=
  379],
     | 99.99th=3D[  416]
   bw (  MiB/s): min=3D 1099, max=3D 1131, per=3D100.00%, avg=3D1112.40,
stdev=3D 5.29, samples=3D276
   iops        : min=3D140748, max=3D144770, avg=3D142386.64, stdev=3D677.2=
6,
samples=3D276
  write: IOPS=3D142k, BW=3D1112MiB/s (1166MB/s)(150GiB/138132msec); 0 zone =
resets
    slat (nsec): min=3D1550, max=3D916951, avg=3D3027.13, stdev=3D1290.29
    clat (usec): min=3D7, max=3D1141, avg=3D219.38, stdev=3D11.06
     lat (usec): min=3D9, max=3D1146, avg=3D222.41, stdev=3D11.12
    clat percentiles (usec):
     |  1.00th=3D[  172],  5.00th=3D[  212], 10.00th=3D[  215], 20.00th=3D[=
  217],
     | 30.00th=3D[  219], 40.00th=3D[  219], 50.00th=3D[  221], 60.00th=3D[=
  221],
     | 70.00th=3D[  223], 80.00th=3D[  225], 90.00th=3D[  229], 95.00th=3D[=
  231],
     | 99.00th=3D[  237], 99.50th=3D[  245], 99.90th=3D[  269], 99.95th=3D[=
  281],
     | 99.99th=3D[  314]
   bw (  MiB/s): min=3D 1100, max=3D 1126, per=3D100.00%, avg=3D1112.15,
stdev=3D 4.92, samples=3D276
   iops        : min=3D140822, max=3D144244, avg=3D142355.08, stdev=3D629.2=
8,
samples=3D276
  lat (usec)   : 10=3D0.01%, 20=3D0.01%, 50=3D0.01%, 100=3D0.03%, 250=3D98.=
76%
  lat (usec)   : 500=3D1.20%, 750=3D0.01%, 1000=3D0.01%
  lat (msec)   : 2=3D0.01%
  cpu          : usr=3D20.74%, sys=3D54.54%, ctx=3D2887, majf=3D0, minf=3D1=
1
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D0.=
1%, >=3D64=3D100.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.1%, >=3D64=3D0.0%
     issued rwts: total=3D19662985,19658615,0,0 short=3D0,0,0,0 dropped=3D0=
,0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D64

Run status group 0 (all jobs):
   READ: bw=3D1112MiB/s (1166MB/s), 1112MiB/s-1112MiB/s
(1166MB/s-1166MB/s), io=3D150GiB (161GB), run=3D138132-138132msec
  WRITE: bw=3D1112MiB/s (1166MB/s), 1112MiB/s-1112MiB/s
(1166MB/s-1166MB/s), io=3D150GiB (161GB), run=3D138132-138132msec




Anuj gupta <anuj1072538@gmail.com> =E4=BA=8E2024=E5=B9=B411=E6=9C=8811=E6=
=97=A5=E5=91=A8=E4=B8=80 20:35=E5=86=99=E9=81=93=EF=BC=9A
>
> Looks good:
> Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
>


--=20
Guangwu Zhang
Thanks


