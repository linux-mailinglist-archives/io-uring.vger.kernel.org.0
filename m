Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B2073B05A
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 07:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjFWFvk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 01:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbjFWFva (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 01:51:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3032268C
        for <io-uring@vger.kernel.org>; Thu, 22 Jun 2023 22:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687499438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sV3QgCj6yd4PKIWzH3IRDRythUtZzsSB4A6GOYDhAHM=;
        b=CRlN+K4ngGbAXCWf/hR8zWqIYHWdQxIxg0mxUaDLcX1QFd8a+7ZXMvPhUhbYXFMZuzppMQ
        G3ns+FsJixMwC2qXpoevE2jr+hLIRrH4JJr51/4v6syu5/xuCDgOlm/T1BCT1U1f2GjkkY
        mV4QuSsZ/pmzsoEzQdrw88fuWLDNIDw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169-hWPgFb_TM-mcJOS33xtccw-1; Fri, 23 Jun 2023 01:50:36 -0400
X-MC-Unique: hWPgFb_TM-mcJOS33xtccw-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-51a49eb6000so155910a12.2
        for <io-uring@vger.kernel.org>; Thu, 22 Jun 2023 22:50:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687499435; x=1690091435;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sV3QgCj6yd4PKIWzH3IRDRythUtZzsSB4A6GOYDhAHM=;
        b=GLSitZhFJwr3zjzU9DiJX6o/WTj67RzYalyNEf7916ZA75PPFctmxB0NtUojpehzBE
         UUrBl2qwQINlPSyVcRXQ+UimBotmvz9KbIujGcwB+17Z1Y+clvuKioMcHud2fkHdisAp
         +S6oJ6keg3JrEN7hixsRNNsqYfpetECTzt1hbL88XDVJd/Pb+PR1uvERozEdN68/I1Fk
         bWDCDqEtKTyylmPifRzIdfYro8BOu6smsZoi+Jewgha9SPpRJ/+m+9XHNuDLatKUAMqJ
         7pUmMkVQ3MZotThqbj4eIfnU0C0JW6QMFr2NmpWLCaJi6AH4zgTpOtTEWiK1/mPvyQkr
         mrgQ==
X-Gm-Message-State: AC+VfDw+3zkhKFbZz8ZpDbaBs+aL7b1i1cHeK0+d/Cc6RU5okdGhttMz
        Dv1ntskr0+eMhyqoksxcFU9RKRneW6c2wdk3PahGRWOk2Cyb52CXyg8d6TVIIYPADaFt9gNtdIM
        cjtocnZb2h3uuxlgssxULJ7dPIT1ycQYJ5iQ=
X-Received: by 2002:a05:6402:498:b0:519:b784:b157 with SMTP id k24-20020a056402049800b00519b784b157mr12537006edv.12.1687499434841;
        Thu, 22 Jun 2023 22:50:34 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7T7/O9rKwxPt4b0r3d+KFB+8vUlLl7Pat8pUNc3Y5XikpzgKmD0Sy8deGiOwXsVD7eXv0QsiRqOXzcXcPOUX8=
X-Received: by 2002:a05:6402:498:b0:519:b784:b157 with SMTP id
 k24-20020a056402049800b00519b784b157mr12536973edv.12.1687499434430; Thu, 22
 Jun 2023 22:50:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAGS2=YrvrD0hf7WGjQd4Me772=m9=E6J92aGtG0PAoF4yD6dTw@mail.gmail.com>
 <e92a19fa-74cc-2b9f-3173-6a04557a6534@kernel.dk> <ZJMDWIZv5kuJ7nGl@ovpn-8-23.pek2.redhat.com>
 <e7562fe1-0dd5-a864-cc0d-32701dac943c@kernel.dk>
In-Reply-To: <e7562fe1-0dd5-a864-cc0d-32701dac943c@kernel.dk>
From:   Guangwu Zhang <guazhang@redhat.com>
Date:   Fri, 23 Jun 2023 13:51:41 +0800
Message-ID: <CAGS2=Yqe3+jerR8sm47H++KKyXNJbAbTS0o3PFqJ24=QOQ2ChQ@mail.gmail.com>
Subject: Re: [bug report] BUG: KASAN: out-of-bounds in io_req_local_work_add+0x3b1/0x4a0
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Just hit the bug one time with liburing testing, so it hard to said
which case triggered the issue,
here is the test steps
1) enable kernel KASAN module
2) mkfs and mount with sda and set TEST_FILES=3D/dev/sda
3) copy all liburing cases to mount point
4) make runtests as root

here is other testing more easy to reproduce the error.
refer the test steps
1) enable kernel KASAN module
2) get a nvme disk with nvme over fc
3) fio with  io_uring_cmd

fio --numjobs=3D1 --ioengine=3Dio_uring_cmd --runtime=3D'300' --size=3D'300=
G'
--filename=3D/dev/ng5n1 --rw=3D'randrw' --name=3D'fio_test'  --iodepth=3D64
--bs=3D8k --group_reporting=3D1 --cmd_type=3D'nvme'   --fixedbufs
fio_test: (g=3D0): rw=3Drandrw, bs=3D(R) 8192B-8192B, (W) 8192B-8192B, (T)
8192B-8192B, ioengine=3Dio_uring_cmd, iodepth=3D64
fio-3.34-100-g50875
Starting 1 process
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D119259136, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D7563542528, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D23744880640, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D11413504000, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D22324764672, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D27687174144, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D49106542592, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D49600675840, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D48269828096, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D39076798464, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D47050080256, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D18889048064, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D41649799168, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D37820571648, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D15420358656, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D1672372224, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D13677133824, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D50066644992, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D40153137152, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D19285647360, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D8948129792, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D2271256576, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D29889617920, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D19249717248, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D17358807040, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D39550853120, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D45227081728, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D32457154560, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D44406554624, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D17701838848, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D25463160832, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D45162758144, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D11501166592, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D19937656832, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D42879565824, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D16697352192, buflen=3D8192
fio: io_u error on file /dev/ng5n1: Unknown error -17024: write
offset=3D5585068032, buflen=3D8192
fio: pid=3D2451, err=3D-17024/file:io_u.c:1889, func=3Dio_u error,
error=3DUnknown error -17024

fio_test: (groupid=3D0, jobs=3D1): err=3D-17024 (file:io_u.c:1889, func=3Di=
o_u
error, error=3DUnknown error -17024): pid=3D2451: Fri Jun 23 01:45:45 2023
  read: IOPS=3D20.2k, BW=3D158MiB/s (165MB/s)(230MiB/1461msec)
    slat (usec): min=3D2, max=3D466, avg=3D11.90, stdev=3D19.43
    clat (usec): min=3D167, max=3D738890, avg=3D1333.54, stdev=3D19954.27
     lat (usec): min=3D176, max=3D738894, avg=3D1345.44, stdev=3D19954.17
    clat percentiles (usec):
     |  1.00th=3D[   359],  5.00th=3D[   457], 10.00th=3D[   502], 20.00th=
=3D[   562],
     | 30.00th=3D[   611], 40.00th=3D[   676], 50.00th=3D[   742], 60.00th=
=3D[   816],
     | 70.00th=3D[   881], 80.00th=3D[   947], 90.00th=3D[  1037], 95.00th=
=3D[  1156],
     | 99.00th=3D[  1434], 99.50th=3D[  1598], 99.90th=3D[  3097], 99.95th=
=3D[700449],
     | 99.99th=3D[700449]
   bw (  KiB/s): min=3D163696, max=3D307856, per=3D100.00%, avg=3D235776.00=
,
stdev=3D101936.51, samples=3D2
   iops        : min=3D20462, max=3D38482, avg=3D29472.00, stdev=3D12742.06=
, samples=3D2
  write: IOPS=3D20.2k, BW=3D158MiB/s (165MB/s)(230MiB/1461msec); 0 zone res=
ets
    slat (usec): min=3D2, max=3D489, avg=3D12.08, stdev=3D18.99
    clat (usec): min=3D276, max=3D697804, avg=3D906.93, stdev=3D5743.07
     lat (usec): min=3D321, max=3D697810, avg=3D919.01, stdev=3D5742.89
    clat percentiles (usec):
     |  1.00th=3D[  453],  5.00th=3D[  537], 10.00th=3D[  586], 20.00th=3D[=
  652],
     | 30.00th=3D[  709], 40.00th=3D[  783], 50.00th=3D[  840], 60.00th=3D[=
  906],
     | 70.00th=3D[  963], 80.00th=3D[ 1029], 90.00th=3D[ 1139], 95.00th=3D[=
 1287],
     | 99.00th=3D[ 1516], 99.50th=3D[ 1631], 99.90th=3D[ 2442], 99.95th=3D[=
 3064],
     | 99.99th=3D[ 6194]
   bw (  KiB/s): min=3D163936, max=3D307936, per=3D100.00%, avg=3D235936.00=
,
stdev=3D101823.38, samples=3D2
   iops        : min=3D20492, max=3D38492, avg=3D29492.00, stdev=3D12727.92=
, samples=3D2
  lat (usec)   : 250=3D0.04%, 500=3D6.04%, 750=3D37.07%, 1000=3D37.96%
  lat (msec)   : 2=3D18.64%, 4=3D0.14%, 10=3D0.01%, 750=3D0.04%
  cpu          : usr=3D2.60%, sys=3D48.15%, ctx=3D575, majf=3D0, minf=3D13
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D0.=
1%, >=3D64=3D99.9%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.1%, >=3D64=3D0.0%
     issued rwts: total=3D29496,29531,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D64

Run status group 0 (all jobs):
   READ: bw=3D158MiB/s (165MB/s), 158MiB/s-158MiB/s (165MB/s-165MB/s),
io=3D230MiB (242MB), run=3D1461-1461msec
  WRITE: bw=3D158MiB/s (165MB/s), 158MiB/s-158MiB/s (165MB/s-165MB/s),
io=3D230MiB (242MB), run=3D1461-1461msec

[  820.367682] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  820.374911] Disabling lock debugging due to kernel taint
[ 2624.630806] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[ 2624.638050] BUG: KASAN: out-of-bounds in io_req_local_work_add+0x3b1/0x4=
a0
[ 2624.644942] Read of size 4 at addr ffff8885102bf3d8 by task iou-wrk-2451=
/2479
[ 2624.652077]
[ 2624.653576] CPU: 26 PID: 2479 Comm: iou-wrk-2451 Kdump: loaded
Tainted: G    B              6.4.0-rc3.kasan+ #1
[ 2624.663663] Hardware name: Dell Inc. PowerEdge R640/06NR82, BIOS
2.17.1 11/15/2022
[ 2624.671227] Call Trace:
[ 2624.673681]  <IRQ>
[ 2624.675701]  dump_stack_lvl+0x33/0x50
[ 2624.679364]  print_address_description.constprop.0+0x2c/0x3e0
[ 2624.685112]  print_report+0xb5/0x270
[ 2624.688690]  ? kasan_addr_to_slab+0x9/0xa0
[ 2624.692786]  ? io_req_local_work_add+0x3b1/0x4a0
[ 2624.697407]  kasan_report+0xcf/0x100
[ 2624.700985]  ? io_req_local_work_add+0x3b1/0x4a0
[ 2624.705605]  io_req_local_work_add+0x3b1/0x4a0
[ 2624.710052]  ? __pfx_io_req_local_work_add+0x10/0x10
[ 2624.715015]  ? bio_uninit+0x73/0x1f0
[ 2624.718596]  ? bio_endio+0x3bc/0x530
[ 2624.722174]  ? __pfx_nvme_uring_task_cb+0x10/0x10 [nvme_core]
[ 2624.727944]  __io_req_task_work_add+0x1bc/0x270
[ 2624.732480]  nvme_uring_cmd_end_io+0x1c2/0x300 [nvme_core]
[ 2624.737981]  ? __pfx_nvme_uring_cmd_end_io+0x10/0x10 [nvme_core]
[ 2624.744003]  __blk_mq_end_request+0xf4/0x460
[ 2624.748276]  nvme_fc_complete_rq+0x23b/0x320 [nvme_fc]
[ 2624.753426]  blk_complete_reqs+0xa7/0xe0
[ 2624.757349]  __do_softirq+0x19b/0x59a
[ 2624.761016]  __irq_exit_rcu+0x170/0x1d0
[ 2624.764855]  sysvec_call_function_single+0x6f/0x90
[ 2624.769646]  </IRQ>
[ 2624.771753]  <TASK>
[ 2624.773858]  asm_sysvec_call_function_single+0x16/0x20
[ 2624.778997] RIP: 0010:unwind_next_frame+0x9b9/0x1ea0
[ 2624.783963] Code: 40 38 f2 40 0f 9e c6 84 d2 0f 95 c2 40 84 d6 0f
85 3a 0e 00 00 83 e0 07 38 c1 0f 9e c2 84 c9 0f 95 c0 84 c2 0f 85 25
0e 00 00 <41> 0f b6 41 04 c0 e8 04 3c 01 0f 84 b8 01 00 00 3c 04 0f 84
02 08
[ 2624.802708] RSP: 0018:ffff88848f367158 EFLAGS: 00000246
[ 2624.807932] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 00000000000=
00000
[ 2624.815064] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88848f3=
67238
[ 2624.822197] RBP: ffff88848f367228 R08: ffff88848f367210 R09: ffffffff9f9=
98abc
[ 2624.829329] R10: ffffffff9f998ac0 R11: ffff88848f367528 R12: ffff88848f3=
67218
[ 2624.836462] R13: ffff88848f367230 R14: ffff88848f367530 R15: ffff88848f3=
671d0
[ 2624.843594]  ? unwind_next_frame+0x8c2/0x1ea0
[ 2624.847953]  ? kasan_set_track+0x21/0x30
[ 2624.851878]  ? kasan_set_track+0x21/0x30
[ 2624.855802]  ? __pfx_stack_trace_consume_entry+0x10/0x10
[ 2624.861117]  arch_stack_walk+0x88/0xf0
[ 2624.864870]  ? __kasan_slab_alloc+0x83/0x90
[ 2624.869055]  stack_trace_save+0x91/0xd0
[ 2624.872893]  ? __pfx_stack_trace_save+0x10/0x10
[ 2624.877424]  ? ret_from_fork+0x29/0x50
[ 2624.881179]  ? __pfx_stack_trace_consume_entry+0x10/0x10
[ 2624.886490]  ? arch_stack_walk+0x88/0xf0
[ 2624.890415]  kasan_save_stack+0x1e/0x40
[ 2624.894254]  ? kasan_save_stack+0x1e/0x40
[ 2624.898268]  ? kasan_set_track+0x21/0x30
[ 2624.902192]  ? ret_from_fork+0x29/0x50
[ 2624.905944]  ? stack_trace_save+0x91/0xd0
[ 2624.909957]  ? __pfx_stack_trace_save+0x10/0x10
[ 2624.914488]  ? __stack_depot_save+0x34/0x350
[ 2624.918762]  ? kasan_save_stack+0x2e/0x40
[ 2624.922773]  ? kasan_save_stack+0x1e/0x40
[ 2624.926786]  ? kasan_set_track+0x21/0x30
[ 2624.930712]  ? __kasan_slab_alloc+0x83/0x90
[ 2624.934896]  ? kmem_cache_alloc+0x190/0x3a0
[ 2624.939082]  ? mempool_alloc+0x100/0x2d0
[ 2624.943008]  ? bio_alloc_bioset+0x1a9/0x770
[ 2624.947195]  ? blk_rq_map_user_iov+0x4a0/0xa60
[ 2624.951640]  ? nvme_map_user_request+0x1dc/0x590 [nvme_core]
[ 2624.957317]  ? nvme_uring_cmd_io+0x8c0/0xcd0 [nvme_core]
[ 2624.962645]  ? io_uring_cmd+0x1f1/0x3d0
[ 2624.966485]  ? io_issue_sqe+0x4ff/0xe80
[ 2624.970324]  ? io_wq_submit_work+0x23e/0xa00
[ 2624.974597]  ? io_worker_handle_work+0x404/0xa80
[ 2624.979217]  ? io_wq_worker+0x6c5/0x9d0
[ 2624.983055]  ? ret_from_fork+0x29/0x50
[ 2624.986806]  ? __pfx_newidle_balance+0x10/0x10
[ 2624.991252]  kasan_set_track+0x21/0x30
[ 2624.995006]  __kasan_slab_alloc+0x83/0x90
[ 2624.999016]  kmem_cache_alloc+0x190/0x3a0
[ 2625.003029]  mempool_alloc+0x100/0x2d0
[ 2625.006782]  ? __pfx_mempool_alloc+0x10/0x10
[ 2625.011054]  ? dma_direct_map_sg+0x1b6/0x3a0
[ 2625.015325]  ? __pfx_dma_direct_map_sg+0x10/0x10
[ 2625.019947]  qla2xxx_get_qpair_sp.constprop.0+0x8b/0x2b0 [qla2xxx]
[ 2625.026186]  qla_nvme_post_cmd+0x273/0x7c0 [qla2xxx]
[ 2625.031202]  nvme_fc_start_fcp_op.part.0+0x5f9/0x1650 [nvme_fc]
[ 2625.037130]  ? finish_wait+0x9a/0x230
[ 2625.040797]  ? __pfx_nvme_fc_start_fcp_op.part.0+0x10/0x10 [nvme_fc]
[ 2625.047159]  nvme_fc_queue_rq+0x3b7/0x730 [nvme_fc]
[ 2625.052044]  ? __pfx_nvme_fc_queue_rq+0x10/0x10 [nvme_fc]
[ 2625.057452]  blk_mq_dispatch_rq_list+0x3d8/0x13c0
[ 2625.062158]  ? __blk_mq_alloc_requests+0x8b0/0xc30
[ 2625.066951]  ? bio_associate_blkg_from_css+0x2fc/0xaf0
[ 2625.072088]  ? __pfx_blk_mq_dispatch_rq_list+0x10/0x10
[ 2625.077227]  ? _raw_spin_lock+0x81/0xe0
[ 2625.081067]  ? __pfx__raw_spin_lock+0x10/0x10
[ 2625.085425]  __blk_mq_sched_dispatch_requests+0x19c/0x480
[ 2625.090825]  ? __pfx___blk_mq_sched_dispatch_requests+0x10/0x10
[ 2625.096743]  ? __pfx_blk_mq_alloc_request+0x10/0x10
[ 2625.101623]  ? __pfx_blk_mq_insert_request+0x10/0x10
[ 2625.106588]  blk_mq_sched_dispatch_requests+0xdd/0x130
[ 2625.111726]  blk_mq_run_hw_queue+0x3dd/0x4e0
[ 2625.115999]  ? __pfx_nvme_uring_cmd_end_io+0x10/0x10 [nvme_core]
[ 2625.122022]  nvme_uring_cmd_io+0x826/0xcd0 [nvme_core]
[ 2625.127180]  ? __pfx_nvme_uring_cmd_io+0x10/0x10 [nvme_core]
[ 2625.132853]  ? __update_idle_core+0x59/0x360
[ 2625.137128]  ? __schedule+0x616/0x1530
[ 2625.140878]  ? native_queued_spin_lock_slowpath+0x163/0xa90
[ 2625.146453]  io_uring_cmd+0x1f1/0x3d0
[ 2625.150117]  io_issue_sqe+0x4ff/0xe80
[ 2625.153782]  io_wq_submit_work+0x23e/0xa00
[ 2625.157881]  io_worker_handle_work+0x404/0xa80
[ 2625.162328]  io_wq_worker+0x6c5/0x9d0
[ 2625.165993]  ? __pfx_io_wq_worker+0x10/0x10
[ 2625.170180]  ? _raw_spin_lock_irq+0x82/0xe0
[ 2625.174365]  ? __pfx_io_wq_worker+0x10/0x10
[ 2625.178549]  ret_from_fork+0x29/0x50
[ 2625.182131]  </TASK>
[ 2625.184320]
[ 2625.185820] Allocated by task 2451:
[ 2625.189313]  kasan_save_stack+0x1e/0x40
[ 2625.193153]  kasan_set_track+0x21/0x30
[ 2625.196906]  __kasan_slab_alloc+0x83/0x90
[ 2625.200917]  kmem_cache_alloc_bulk+0x13a/0x1e0
[ 2625.205361]  __io_alloc_req_refill+0x238/0x510
[ 2625.209807]  io_submit_sqes+0x65a/0xcd0
[ 2625.213648]  __do_sys_io_uring_enter+0x4e9/0x830
[ 2625.218266]  do_syscall_64+0x59/0x90
[ 2625.221846]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[ 2625.226896]
[ 2625.228397] The buggy address belongs to the object at ffff8885102bf340
[ 2625.228397]  which belongs to the cache io_kiocb of size 224
[ 2625.240640] The buggy address is located 152 bytes inside of
[ 2625.240640]  224-byte region [ffff8885102bf340, ffff8885102bf420)
[ 2625.252367]
[ 2625.253865] The buggy address belongs to the physical page:
[ 2625.259439] page:00000000fe3a9582 refcount:1 mapcount:0
mapping:0000000000000000 index:0x0 pfn:0x5102bc
[ 2625.268824] head:00000000fe3a9582 order:2 entire_mapcount:0
nr_pages_mapped:0 pincount:0
[ 2625.276910] memcg:ffff888495973401
[ 2625.280313] flags:
0x57ffffc0010200(slab|head|node=3D1|zone=3D2|lastcpupid=3D0x1fffff)
[ 2625.287706] page_type: 0xffffffff()
[ 2625.291200] raw: 0057ffffc0010200 ffff888109159040 dead000000000122
0000000000000000
[ 2625.298938] raw: 0000000000000000 0000000000330033 00000001ffffffff
ffff888495973401
[ 2625.306675] page dumped because: kasan: bad access detected
[ 2625.312250]
[ 2625.313747] Memory state around the buggy address:
[ 2625.318540]  ffff8885102bf280: 00 00 00 00 00 00 00 00 00 00 00 00
fc fc fc fc
[ 2625.325760]  ffff8885102bf300: fc fc fc fc fc fc fc fc 00 00 00 00
00 00 00 00
[ 2625.332978] >ffff8885102bf380: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[ 2625.340196]                                                        ^
[ 2625.346548]  ffff8885102bf400: 00 00 00 00 fc fc fc fc fc fc fc fc
fc fc fc fc
[ 2625.353766]  ffff8885102bf480: fc fc fc fc fc fc fc fc fc fc fc fc
fc fc fc fc
[ 2625.360986] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D



Jens Axboe <axboe@kernel.dk> =E4=BA=8E2023=E5=B9=B46=E6=9C=8821=E6=97=A5=E5=
=91=A8=E4=B8=89 23:56=E5=86=99=E9=81=93=EF=BC=9A
>
> On 6/21/23 8:04?AM, Ming Lei wrote:
> > On Wed, Jun 21, 2023 at 07:40:49AM -0600, Jens Axboe wrote:
> >> On 6/21/23 1:38?AM, Guangwu Zhang wrote:
> >>> HI,
> >>> Found the io_req_local_work_add error when run  liburing testing.
> >>>
> >>> kernel repo :
> >>>     Merge branch 'for-6.5/block' into for-next
> >>>     * for-6.5/block:
> >>>       reiserfs: fix blkdev_put() warning from release_journal_dev()
> >>>
> >>> [ 1733.389012] BUG: KASAN: out-of-bounds in io_req_local_work_add+0x3=
b1/0x4a0
> >>> [ 1733.395900] Read of size 4 at addr ffff888133320458 by task
> >>> iou-wrk-97057/97138
> >>> [ 1733.403205]
> >>> [ 1733.404706] CPU: 4 PID: 97138 Comm: iou-wrk-97057 Kdump: loaded No=
t
> >>> tainted 6.4.0-rc3.kasan+ #1
> >>> [ 1733.413404] Hardware name: Dell Inc. PowerEdge R740/06WXJT, BIOS
> >>> 2.13.3 12/13/2021
> >>> [ 1733.420972] Call Trace:
> >>> [ 1733.423425]  <TASK>
> >>> [ 1733.425533]  dump_stack_lvl+0x33/0x50
> >>> [ 1733.429207]  print_address_description.constprop.0+0x2c/0x3e0
> >>> [ 1733.434959]  print_report+0xb5/0x270
> >>> [ 1733.438539]  ? kasan_addr_to_slab+0x9/0xa0
> >>> [ 1733.442639]  ? io_req_local_work_add+0x3b1/0x4a0
> >>> [ 1733.447258]  kasan_report+0xcf/0x100
> >>> [ 1733.450839]  ? io_req_local_work_add+0x3b1/0x4a0
> >>> [ 1733.455456]  io_req_local_work_add+0x3b1/0x4a0
> >>> [ 1733.459903]  ? __pfx_io_req_local_work_add+0x10/0x10
> >>> [ 1733.464871]  ? __schedule+0x616/0x1530
> >>> [ 1733.468622]  __io_req_task_work_add+0x1bc/0x270
> >>> [ 1733.473156]  io_issue_sqe+0x55a/0xe80
> >>> [ 1733.476831]  io_wq_submit_work+0x23e/0xa00
> >>> [ 1733.480930]  io_worker_handle_work+0x2f5/0xa80
> >>> [ 1733.485384]  io_wq_worker+0x6c5/0x9d0
> >>> [ 1733.489051]  ? __pfx_io_wq_worker+0x10/0x10
> >>> [ 1733.493246]  ? _raw_spin_lock_irq+0x82/0xe0
> >>> [ 1733.497430]  ? __pfx_io_wq_worker+0x10/0x10
> >>> [ 1733.501616]  ret_from_fork+0x29/0x50
> >>> [ 1733.505204]  </TASK>
> >>> [ 1733.507396]
> >>> [ 1733.508894] Allocated by task 97057:
> >>> [ 1733.512475]  kasan_save_stack+0x1e/0x40
> >>> [ 1733.516313]  kasan_set_track+0x21/0x30
> >>> [ 1733.520068]  __kasan_slab_alloc+0x83/0x90
> >>> [ 1733.524080]  kmem_cache_alloc_bulk+0x13a/0x1e0
> >>> [ 1733.528526]  __io_alloc_req_refill+0x238/0x510
> >>> [ 1733.532971]  io_submit_sqes+0x65a/0xcd0
> >>> [ 1733.536810]  __do_sys_io_uring_enter+0x4e9/0x830
> >>> [ 1733.541430]  do_syscall_64+0x59/0x90
> >>> [ 1733.545010]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> >>> [ 1733.550071]
> >>> [ 1733.551571] The buggy address belongs to the object at ffff8881333=
203c0
> >>> [ 1733.551571]  which belongs to the cache io_kiocb of size 224
> >>> [ 1733.563816] The buggy address is located 152 bytes inside of
> >>> [ 1733.563816]  224-byte region [ffff8881333203c0, ffff8881333204a0)
> >>> [ 1733.575544]
> >>> [ 1733.577042] The buggy address belongs to the physical page:
> >>> [ 1733.582617] page:00000000edbe178c refcount:1 mapcount:0
> >>> mapping:0000000000000000 index:0x0 pfn:0x133320
> >>> [ 1733.592011] head:00000000edbe178c order:1 entire_mapcount:0
> >>> nr_pages_mapped:0 pincount:0
> >>> [ 1733.600096] memcg:ffff88810cd49001
> >>> [ 1733.603501] flags:
> >>> 0x17ffffc0010200(slab|head|node=3D0|zone=3D2|lastcpupid=3D0x1fffff)
> >>> [ 1733.610896] page_type: 0xffffffff()
> >>> [ 1733.614390] raw: 0017ffffc0010200 ffff888101222280 ffffea000447390=
0
> >>> 0000000000000002
> >>> [ 1733.622128] raw: 0000000000000000 0000000000190019 00000001fffffff=
f
> >>> ffff88810cd49001
> >>> [ 1733.629866] page dumped because: kasan: bad access detected
> >>> [ 1733.635439]
> >>> [ 1733.636938] Memory state around the buggy address:
> >>> [ 1733.641731]  ffff888133320300: 00 00 00 00 00 00 00 00 00 00 00 00
> >>> fc fc fc fc
> >>> [ 1733.648952]  ffff888133320380: fc fc fc fc fc fc fc fc 00 00 00 00
> >>> 00 00 00 00
> >>> [ 1733.656169] >ffff888133320400: 00 00 00 00 00 00 00 00 00 00 00 00
> >>> 00 00 00 00
> >>> [ 1733.663389]                                                       =
 ^
> >>> [ 1733.669743]  ffff888133320480: 00 00 00 00 fc fc fc fc fc fc fc fc
> >>> fc fc fc fc
> >>> [ 1733.676961]  ffff888133320500: 00 00 00 00 00 00 00 00 00 00 00 00
> >>> 00 00 00 00
> >>
> >> I appreciate you running tests and sending in failures, but can you
> >> please be more specific about what exactly was run? We seem to need to
> >> do this dance every time, which is just wasting time. So:
> >>
> >> 1) What test triggered this?
> >> 2) Was it invoked with any arguments?
> >
> > I can see the whole dmesg log, and it seems from "sq-full-cpp.c /dev/sd=
a":
> >
> > [ 1340.918880] Running test sq-full-cpp.t:
> > [ 1341.009225] Running test sq-full-cpp.t /dev/sda:
> > [ 1342.025292] restraintd[1061]: *** Current Time: Tue Jun 20 21:17:57 =
2023  Localwatchdog at: Wed Jun 21 01:03:56 2023
> > [ 1402.053433] restraintd[1061]: *** Current Time: Tue Jun 20 21:18:57 =
2023  Localwatchdog at: Wed Jun 21 01:03:56 2023
> > [ 1462.047970] restraintd[1061]: *** Current Time: Tue Jun 20 21:19:57 =
2023  Localwatchdog at: Wed Jun 21 01:03:56 2023
> > [-- MARK -- Wed Jun 21 01:20:00 2023]
> > [ 1522.029598] restraintd[1061]: *** Current Time: Tue Jun 20 21:20:57 =
2023  Localwatchdog at: Wed Jun 21 01:03:56 2023
> > [ 1582.029278] restraintd[1061]: *** Current Time: Tue Jun 20 21:21:57 =
2023  Localwatchdog at: Wed Jun 21 01:03:56 2023
> > [ 1642.034617] restraintd[1061]: *** Current Time: Tue Jun 20 21:22:57 =
2023  Localwatchdog at: Wed Jun 21 01:03:56 2023
> > [ 1702.034344] restraintd[1061]: *** Current Time: Tue Jun 20 21:23:57 =
2023  Localwatchdog at: Wed Jun 21 01:03:56 2023
> > [ 1733.381782] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > [ 1733.389012] BUG: KASAN: out-of-bounds in io_req_local_work_add+0x3b1=
/0x4a0
> > [ 1733.395900] Read of size 4 at addr ffff888133320458 by task iou-wrk-=
97057/97138
>
> I don't think that's right - sq-full-cpp doesn't do anything if passed
> an argument, and you also have a lot of time passing in between that
> test being run and the warning being spewed. Maybe the tests are run
> both as root and non-root? The root run ones will add the dmesg spew on
> which test is being run, the non-root will not.
>
> --
> Jens Axboe
>


--=20
Guangwu Zhang
Thanks

