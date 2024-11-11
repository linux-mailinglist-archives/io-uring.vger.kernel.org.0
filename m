Return-Path: <io-uring+bounces-4593-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B9249C38F3
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 08:20:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD1DB2808F7
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 07:20:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C497F136A;
	Mon, 11 Nov 2024 07:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cA/1Aym4"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5D950276
	for <io-uring@vger.kernel.org>; Mon, 11 Nov 2024 07:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731309641; cv=none; b=lTBmh4tq5ErBnBD+KeDo0gnNGYF1P/QzZ6PcuGPbQi2s/hOa8bBdB34klCgW3UWeZpNoD/zb99sNw8sxtpMFuauUrphhjuy+abC9jwROyYfRZVRGqcxtGDap+DDeqSbpkSO8iwZp0VeYd4JgytpDHj2OyM5O7Zz4npdUjrZyTrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731309641; c=relaxed/simple;
	bh=2BApFlK1J/dcKJTFvdQMMeBu4sujMW4HYzzpTBwqlus=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Uq2tDI+l2sYDXcIBuX8LhdHpkog2pABrDzdf5PesqVOSYv/Y5IknNHOQPZ/GKD42JrMQC0TXqvqfS0JRP+aNLz4/0Wt5naSAcxr3H16NtvDMUdDS25t7QCnagw9WspXX1X3Q1fHMe8bFs4TUB9Bq4ESpet+oo4QrBo7JRKPGENk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cA/1Aym4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731309638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=GJ1AuVG23mOikcqNf/gsqClWSrvCjqTRMPTWIiYeHOA=;
	b=cA/1Aym4MdtLYJCUKoLSIkJS3uv40nbYPvHkNnLDFFwKGwI2vVeB7fMHhZB4jL0CuNZM27
	Bq1Db8aq8LkgljxyBwk5HXku2uYf2HYcEIsIqthZqWZhQyp4yyuhd0Uec3dMMGzWBWlXEB
	/m2jVuVSNdXBhSKcA1aKAb2wiTye+4A=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-VNTg__S1PseGHJPW54vntA-1; Mon, 11 Nov 2024 02:20:36 -0500
X-MC-Unique: VNTg__S1PseGHJPW54vntA-1
X-Mimecast-MFC-AGG-ID: VNTg__S1PseGHJPW54vntA
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a9a1be34c68so363011266b.1
        for <io-uring@vger.kernel.org>; Sun, 10 Nov 2024 23:20:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731309634; x=1731914434;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GJ1AuVG23mOikcqNf/gsqClWSrvCjqTRMPTWIiYeHOA=;
        b=IvwZpb0Z1pgRGIpNu0jK5OiDQnceHgkLgKpOZxGrT5/wKvaBK2oXFx5cg78P9I8F4H
         YAONMe1rUL6OWbUp+RQ596BxkJUb+T3GyGKBairvw6zXFlgLA929Uw7Po3RC92GyG5y0
         mnBRXfCyFvjXY7vjJ6ed+8Lb5SLZubIS7bMcGiQp8FM6clrd2WRLVfZxmdUHwVRWWEcq
         VleaL1z5NQ6MK8x9xcy9K8vVGlVcEFtBLZTjn/jBuM+90YKpkRDvuEl4R09UQ8fIGODd
         0iGxmMXBtDrNkKlU87AWFTs0Oiwv1wwkRcQE9IgXSTGmG9OhXXtAaB4K5jnAE701ID9i
         IL+g==
X-Forwarded-Encrypted: i=1; AJvYcCXdEAU8ZNZ13VZ4UGdD3WKyiKUM1JsY4d0TkJ+VrVEJ71xmWXLVnTqbw4dRfouuHKR1lyovhZzSVw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0hiRvYOYdgMlz8aqQjrkVJwEPF57yOCTjDYL2l7b3x6NtdIhR
	GMwjjH2VjZVP/Pnko4ksHxkoSzBHuZ56IPVtjeDJbCECdHB05HYFUbV8iysxKHYv4ATEBMCd80s
	RahC/n4ciNk7jIP4CmOy3nHPCPEGAcILq95yXyO/E84KXjI0y6O33vR6F6h3+95W+17zZktJh2n
	T/wikaCFC9Q859+DBlOseJbShlW+hoX0BHEaB1dCGybA==
X-Received: by 2002:a17:907:6d24:b0:a99:36ab:d843 with SMTP id a640c23a62f3a-a9eefff1217mr1159370166b.38.1731309633496;
        Sun, 10 Nov 2024 23:20:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGMYVEoVq7kx6QoXmygKFXHUtL99RMAa6gitdjwB2OtPN3Cxl32/faHQAGrIP2fFtyK0SPUVand6r0EykMNFIE=
X-Received: by 2002:a17:907:6d24:b0:a99:36ab:d843 with SMTP id
 a640c23a62f3a-a9eefff1217mr1159367866b.38.1731309633145; Sun, 10 Nov 2024
 23:20:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Guangwu Zhang <guazhang@redhat.com>
Date: Mon, 11 Nov 2024 15:20:22 +0800
Message-ID: <CAGS2=YqYbvNi6zu8e9e=R+gZMKwY_LegK2vi2MSgdsL1pMyDLA@mail.gmail.com>
Subject: [bug report] fio failed with --fixedbufs
To: linux-block@vger.kernel.org, io-uring@vger.kernel.org, 
	Ming Lei <ming.lei@redhat.com>, Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Hi,

Get the fio error like below, please have a look if something wrong  here,
can not reproduce it if remove "--fixedbufs".

Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
Commit: 51b3526f50cf5526b73d06bd44a0f5e3f936fb01

# fio --numjobs=1 --ioengine=io_uring_cmd --runtime='300'
--size='300G' --filename=/dev/ng1n1 --rw='randrw' --name='fio_test'
--iodepth=64 --bs=8k --group_reporting=1 --cmd_type='nvme'
--md_per_io_size='4K'  --fixedbufs
fio_test: (g=0): rw=randrw, bs=(R) 8192B-8192B, (W) 8192B-8192B, (T)
8192B-8192B, ioengine=io_uring_cmd, iodepth=64
fio-3.38-13-gf241
Starting 1 process
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=314721697792, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=278937288704, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=211560456192, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=166314262528, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=194210742272, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=314948960256, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=4652392448, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=72851734528, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=105412198400, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=269298982912, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=217188352000, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=182140698624, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=306352644096, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=123246698496, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=4156350464, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=240869728256, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=257956913152, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=157641924608, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=248337874944, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=192326352896, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=59785117696, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=159764578304, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=113134592000, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=162308825088, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=150173917184, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=14641209344, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=271883075584, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=55705149440, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=258477580288, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=34678931456, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=311085285376, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=129028251648, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=195086909440, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=300242763776, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=310458490880, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=91683938304, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=142651342848, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=225977384960, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=271599779840, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=52967882752, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=303015387136, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=273026170880, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=318919712768, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=185858064384, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=291365412864, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=170794999808, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=31619899392, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=240495542272, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=185245155328, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=65555390464, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=290169774080, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=199942692864, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=11003101184, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=147007119360, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=48097304576, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=178375688192, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=138726440960, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=239489859584, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=142543421440, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=73279242240, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: read
offset=16768991232, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=252541501440, buflen=8192
fio: io_u error on file /dev/ng1n1: Bad address: write
offset=269492428800, buflen=8192
fio: pid=112524, err=14/file:io_u.c:1976, func=io_u error, error=Bad address

fio_test: (groupid=0, jobs=1): err=14 (file:io_u.c:1976, func=io_u
error, error=Bad address): pid=112524: Mon Nov 11 02:05:53 2024
  write: IOPS=35.0k, BW=8000KiB/s (8192kB/s)(8192B/1msec); 0 zone resets
    slat (nsec): min=576, max=20959, avg=1331.14, stdev=3417.56
    clat (nsec): min=59294, max=59294, avg=59294.00, stdev= 0.00
     lat (nsec): min=80253, max=80253, avg=80253.00, stdev= 0.00
    clat percentiles (nsec):
     |  1.00th=[59136],  5.00th=[59136], 10.00th=[59136], 20.00th=[59136],
     | 30.00th=[59136], 40.00th=[59136], 50.00th=[59136], 60.00th=[59136],
     | 70.00th=[59136], 80.00th=[59136], 90.00th=[59136], 95.00th=[59136],
     | 99.00th=[59136], 99.50th=[59136], 99.90th=[59136], 99.95th=[59136],
     | 99.99th=[59136]
  lat (usec)   : 100=1.56%
  cpu          : usr=0.00%, sys=0.00%, ctx=0, majf=0, minf=9
  IO depths    : 1=1.6%, 2=3.1%, 4=6.2%, 8=12.5%, 16=25.0%, 32=50.0%, >=64=1.6%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=66.7%, 8=0.0%, 16=0.0%, 32=0.0%, 64=33.3%, >=64=0.0%
     issued rwts: total=29,35,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
  WRITE: bw=8000KiB/s (8192kB/s), 8000KiB/s-8000KiB/s
(8192kB/s-8192kB/s), io=8192B (8192B), run=1-1msec




-- 
Guangwu Zhang
Thanks


