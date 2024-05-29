Return-Path: <io-uring+bounces-1985-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 581AE8D29C6
	for <lists+io-uring@lfdr.de>; Wed, 29 May 2024 03:09:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A8FB7B2092F
	for <lists+io-uring@lfdr.de>; Wed, 29 May 2024 01:09:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54E7614EC51;
	Wed, 29 May 2024 01:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GoGqMe+a"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEF7D2FE
	for <io-uring@vger.kernel.org>; Wed, 29 May 2024 01:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716944948; cv=none; b=AgAp0ZSHaVYEO97yPSyFslI51moQhOqf79yAHrRIVNiXhpZBXN+0/ikkYZdcHvMH7nci1lnk03gEiaU1XpYYhCWgT4Q3Ue0mTwNKWR5FLxFzdVWto+Pb3kec2cVznfphsz2WoxSDPfYMYvhxOq7XjrVw0Pqwwh0vU0aYMIMB11k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716944948; c=relaxed/simple;
	bh=aiboj3zeszYbjgeh/MiTVn9ov5/55CZfLnGZykobtHs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YiOWGdvk4XUC9I3liaqurknVSQ0i4vtN89uedxNgX0WcztQQSjPVqGwEWVT2zjyBmyHzSkx4Gqf2vTK3zCnn0CQxrVq7a83sb2Q10e0twib+Xk60NkzuBKBbXr49AVK4s5m4zOlnlzQMZ91FKeSSiYdoslbOXZ83tAYl6ove6aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GoGqMe+a; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716944945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=miNt96yt4B7n9JYHGkq928jE/azZnrF+REW2kBxuEIE=;
	b=GoGqMe+aixcNpUF1DOL2Dj+CwqjwRnT99DRX7W7BigmcX06tvFiCg+VXtXQ9pHR6dzZELT
	ivbl77dzrxXzLARHwzHBueHauMAJMjGcEZhOn8wGFI7Sgp2Z1dyBhe9fbYeZz6fVpMDUpc
	sDEhTzmLA9EISeMQ/meRWkcDeB/Vt84=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-502-Of3ZcPVpOueAEdvCXuma4g-1; Tue, 28 May 2024 21:09:03 -0400
X-MC-Unique: Of3ZcPVpOueAEdvCXuma4g-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2bf8fa43fe2so1400771a91.2
        for <io-uring@vger.kernel.org>; Tue, 28 May 2024 18:09:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716944942; x=1717549742;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=miNt96yt4B7n9JYHGkq928jE/azZnrF+REW2kBxuEIE=;
        b=G7+tiIwGuqvfaHKDvVw7ZZP7wXPp65+PYdVU7gmSGVBMQF3Ty8NQeQOG7wwlMXbpWo
         VAeNd1aRDR3uPSqQ3gcD+I0fw1y+Hv2xoiXUX+jZffVCPDGta+Wk8XNjLZq6LrYWizC3
         KziZeyYjrgm8C12PtBEKvp143fnSX3Wkk+ODJ9d2goirPLR5LxvgykvDZvXu2DIOyj7f
         j48GOZVHU0NIL89LYhSbCJzjDM0BbIJ4G//DqC3ksQdR5xHu0Y9oFoe/CwCgtbgH5Dz2
         0czWLf69NYL23cIebPayJtzgNwoWQq8V9a72X3qZj4O9qsz0UnaMugF6F6SjZIhXdYFk
         t/jg==
X-Forwarded-Encrypted: i=1; AJvYcCWsDYI+6osUkAC3Ga5JFd7gh5bXiywOyqaq5dszjUTPD67TRb9k8JK5X/N1R7dfrqP5azdEzpWZWCoMu0gZI/P+zO+/3FzxMdg=
X-Gm-Message-State: AOJu0YyphYxgp9Dk6piAWYsVgqfwu/6HziBaXwWCR65amg/PPfLY6AqC
	zxiLwNeGK/RRmlAnUZEgBrjLAv0IlJhywRvF3Z+ziDeQBCUMIqwTNA++U3qz8VxltbjSmTS5GQa
	h88tlBYr5mDm1zwori1oOso113JN1FGcXCV8MuVixQwGoIsMLK7fO7qHklWRFUtq7UD66iABxjk
	Dv05E4OXqGj/T/wEn+wYnWZHXllptSsQc=
X-Received: by 2002:a17:90b:188f:b0:2bd:e0dd:f232 with SMTP id 98e67ed59e1d1-2bf5e138e72mr12249447a91.8.1716944942272;
        Tue, 28 May 2024 18:09:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFHaHDCPp3vlcPGcJc34gT5/1hLrOGURfcWA2g34IBO6jwJ8RllaceVTXRk6pEDsouGkkqmP6ksnYS+m9VdFY=
X-Received: by 2002:a17:90b:188f:b0:2bd:e0dd:f232 with SMTP id
 98e67ed59e1d1-2bf5e138e72mr12249422a91.8.1716944941809; Tue, 28 May 2024
 18:09:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGVVp+UvLiS+bhNXV-h2icwX1dyybbYHeQUuH7RYqUvMQf6N3w@mail.gmail.com>
 <4b9986cf-003b-0ad2-75be-5745e979d36d@huaweicloud.com> <9bb4beb1-06d4-2127-31aa-003c555653d4@huaweicloud.com>
In-Reply-To: <9bb4beb1-06d4-2127-31aa-003c555653d4@huaweicloud.com>
From: Changhui Zhong <czhong@redhat.com>
Date: Wed, 29 May 2024 09:08:50 +0800
Message-ID: <CAGVVp+WEMvyUj_0JKM=DmgYO4xFfbQPY55EQX6EtXae54tzOpw@mail.gmail.com>
Subject: Re: [bug report] WARNING: CPU: 2 PID: 3445306 at drivers/block/ublk_drv.c:2633
 ublk_ctrl_start_recovery.constprop.0+0x74/0x180
To: Li Nan <linan666@huaweicloud.com>
Cc: Linux Block Devices <linux-block@vger.kernel.org>, io-uring@vger.kernel.org, 
	Ming Lei <ming.lei@redhat.com>, "yangerkun@huawei.com" <yangerkun@huawei.com>, 
	"yukuai (C)" <yukuai3@huawei.com>, "houtao1@huawei.com" <houtao1@huawei.com>, 
	"yi.zhang@huawei.com" <yi.zhang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 25, 2024 at 3:19=E2=80=AFPM Li Nan <linan666@huaweicloud.com> w=
rote:
>
>
>
> =E5=9C=A8 2024/5/24 17:45, Li Nan =E5=86=99=E9=81=93:
> >
> >
> > =E5=9C=A8 2024/5/24 11:49, Changhui Zhong =E5=86=99=E9=81=93:
> >> Hello,
> >>
> >> I hit the kernel panic when running test ubdsrv  generic/005=EF=BC=8C
> >> please help check it and let me know if you need any info/testing for
> >> it, thanks.
> >>
>
> Can you test the following patch? WARN will still be triggered, but the
> NULL pointer dereference will be fixed.
>
> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> index 4e159948c912..99b621b2d40f 100644
> --- a/drivers/block/ublk_drv.c
> +++ b/drivers/block/ublk_drv.c
> @@ -2630,7 +2630,8 @@ static void ublk_queue_reinit(struct ublk_device *u=
b,
> struct ublk_queue *ubq)
>   {
>         int i;
>
> -       WARN_ON_ONCE(!(ubq->ubq_daemon && ubq_daemon_is_dying(ubq)));
> +       if (WARN_ON_ONCE(!(ubq->ubq_daemon && ubq_daemon_is_dying(ubq))))
> +               return;
>
>         /* All old ioucmds have to be completed */
>         ubq->nr_io_ready =3D 0;
>
> --
> Thanks,
> Nan
>

Hi,Nan

Thanks for your patch,
as you said, after applying your patch,  the "NULL pointer
dereference" has been fixed, and only triggered the warning.

[ 6965.073785] ------------[ cut here ]------------
[ 6965.078414] WARNING: CPU: 0 PID: 86434 at
drivers/block/ublk_drv.c:2633
ublk_ctrl_start_recovery.constprop.0+0x60/0x1a0
[ 6965.089192] Modules linked in: ext4 mbcache jbd2 loop tls
rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace netfs
rfkill sunrpc vfat fat dm_multipath ipmi_ssif intel_rapl_msr
intel_rapl_common intel_uncore_frequency intel_uncore_frequency_common
i10nm_edac nfit libnvdimm x86_pkg_temp_thermal intel_powerclamp
coretemp kvm_intel kvm mgag200 rapl dax_hmem i2c_algo_bit cxl_acpi
intel_cstate drm_shmem_helper iTCO_wdt cxl_core iTCO_vendor_support
acpi_power_meter dcdbas mei_me drm_kms_helper dell_smbios intel_th_gth
intel_uncore pcspkr einj i2c_i801 ipmi_si dell_wmi_descriptor wmi_bmof
isst_if_mmio isst_if_mbox_pci mei intel_th_pci acpi_ipmi
isst_if_common intel_pch_thermal intel_vsec intel_th i2c_smbus
ipmi_devintf ipmi_msghandler drm fuse xfs libcrc32c sd_mod t10_pi sg
ahci crct10dif_pclmul crc32_pclmul libahci crc32c_intel libata tg3
ghash_clmulni_intel wmi dm_mirror dm_region_hash dm_log dm_mod [last
unloaded: null_blk]
[ 6965.171508] CPU: 0 PID: 86434 Comm: iou-wrk-86420 Not tainted 6.10.0-rc1=
+ #1
[ 6965.178555] Hardware name: Dell Inc. PowerEdge R650xs/0PPTY2, BIOS
1.4.4 10/07/2021
[ 6965.186206] RIP: 0010:ublk_ctrl_start_recovery.constprop.0+0x60/0x1a0
[ 6965.192645] Code: 85 48 01 00 00 66 41 83 7c 24 1c 02 0f 85 3b 01
00 00 66 41 83 7c 24 18 00 0f 84 b8 00 00 00 45 31 ed 41 be ff ff ff
ff eb 15 <0f> 0b 41 0f b7 44 24 18 41 83 c5 01 41 39 c5 0f 8d 98 00 00
00 44
[ 6965.211390] RSP: 0018:ff5798fa0e1f7ce0 EFLAGS: 00010246
[ 6965.216617] RAX: 0000000000000002 RBX: ff43a5a306a28000 RCX: 00000000000=
00000
[ 6965.223750] RDX: ff43a5a313e82040 RSI: ffffffff84c4ee00 RDI: 00000000000=
00000
[ 6965.230884] RBP: ff43a5a313956c68 R08: 0000000000000000 R09: ffffffff850=
e35e0
[ 6965.238016] R10: 0000000000000000 R11: 0000000000000000 R12: ff43a5a3139=
56800
[ 6965.245149] R13: 0000000000000000 R14: 00000000ffffffff R15: ff43a5a30b9=
ec080
[ 6965.252281] FS:  00007fc05ee44740(0000) GS:ff43a5a66f600000(0000)
knlGS:0000000000000000
[ 6965.260366] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6965.266115] CR2: 00007f92f07fca50 CR3: 0000000113266006 CR4: 00000000007=
71ef0
[ 6965.273246] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[ 6965.280378] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[ 6965.287510] PKRU: 55555554
[ 6965.290225] Call Trace:
[ 6965.292678]  <TASK>
[ 6965.294783]  ? __warn+0x7f/0x120
[ 6965.298015]  ? ublk_ctrl_start_recovery.constprop.0+0x60/0x1a0
[ 6965.303850]  ? report_bug+0x18a/0x1a0
[ 6965.307514]  ? handle_bug+0x3c/0x70
[ 6965.311008]  ? exc_invalid_op+0x14/0x70
[ 6965.314846]  ? asm_exc_invalid_op+0x16/0x20
[ 6965.319032]  ? ublk_ctrl_start_recovery.constprop.0+0x60/0x1a0
[ 6965.324865]  ublk_ctrl_uring_cmd+0x4f7/0x6c0
[ 6965.329138]  ? pick_next_task_idle+0x26/0x40
[ 6965.333412]  io_uring_cmd+0x9a/0x1b0
[ 6965.336991]  io_issue_sqe+0x18f/0x3f0
[ 6965.340655]  io_wq_submit_work+0x9b/0x390
[ 6965.344671]  io_worker_handle_work+0x165/0x360
[ 6965.349114]  io_wq_worker+0xcb/0x2f0
[ 6965.352694]  ? finish_task_switch.isra.0+0x203/0x290
[ 6965.357659]  ? finish_task_switch.isra.0+0x203/0x290
[ 6965.362628]  ? __pfx_io_wq_worker+0x10/0x10
[ 6965.366814]  ret_from_fork+0x2d/0x50
[ 6965.370402]  ? __pfx_io_wq_worker+0x10/0x10
[ 6965.374587]  ret_from_fork_asm+0x1a/0x30
[ 6965.378513]  </TASK>
[ 6965.380704] ---[ end trace 0000000000000000 ]---

Thanks=EF=BC=8C
Changhui


