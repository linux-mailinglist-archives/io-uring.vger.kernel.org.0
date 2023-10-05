Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 177B17BAB4C
	for <lists+io-uring@lfdr.de>; Thu,  5 Oct 2023 22:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjJEUM7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Oct 2023 16:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjJEUM7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Oct 2023 16:12:59 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00EC695
        for <io-uring@vger.kernel.org>; Thu,  5 Oct 2023 13:12:57 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1c72e235debso2354105ad.0
        for <io-uring@vger.kernel.org>; Thu, 05 Oct 2023 13:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1696536777; x=1697141577; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7vJauW0/PTh9eTuIKftBqYsEI0Bkc/prS2C3u6/V/Zo=;
        b=BIqIvvOnvXPNqdQhifvPQ39+4Rx0ULlsAVtbSoS4ajGxLbGGZt7bZlJ4qdfC0ZnuwQ
         CGUrM86B3Fjb0NXUG/n2y2ujJocvvuz72BQfF2aD8iK6SIEunpsISyInby0rfBQjfiYk
         r2VFpJYGEq9RpY7joFhQw3jHH+C8LQ7tVxLM6xT0/b4v5DUWygVAlK2lslZ2acyU3iPI
         w+3yv6fQcfsvxm+WQahjQgRR9kczx3GS8G1mFyA61CBNS5nFIJ4AKeSsgEjlpeEYdKWr
         sWKgkCWplu7Na9MhESLcxnAVmak/cXuyA9XsWB98s9GYf7KLTry261cWen+ppKlau5A7
         71+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696536777; x=1697141577;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7vJauW0/PTh9eTuIKftBqYsEI0Bkc/prS2C3u6/V/Zo=;
        b=rMFgJB/7z4lNC7FX4AQ1DoO2oGAMwe5jJJVH9opP+saV3XktfiwBfFC0Gp4G3JYK/1
         473A/ErdkJavHEdme/adD2Nr5HlAKSsKy55X+gfc5OPuq4s6NUMz+BoHvP5Qj0ipdpSf
         z071WKhJFwYez+k4ZbcO2CvGJsmOeMDtsiVsSiqUFhex3r+m0tjel7COgslJquyMqSdC
         BJKfRsDdVe7SHdQZQSXqlcqiaIu8DjiARdWWaEWdB7KO1lRzGM1QTtSyrmnFtJn7OCJs
         JweK1yu0j4nxgsmufqvqYpcphOb6pUnGfp6TomFz+xLJfUeYC2SRMKa0ZdjoIYWKZwUI
         GP3g==
X-Gm-Message-State: AOJu0Yy16TWhszyRP0XGi2IAspRXDxTweqS+rPL+udYgK7zyHkfxoLTH
        KVnX0EDuLznA9xVIM/dPY+7TUxrWW6otBmp3dFupbg==
X-Google-Smtp-Source: AGHT+IG6Sh/+YCPkIQJVBiaKZBvdg4kif4eHZQM9KrFwZNanyPI9SpZPPiI+JAfC5SRYr+jCBSOjeg==
X-Received: by 2002:a17:902:da8d:b0:1c1:fbec:bc3f with SMTP id j13-20020a170902da8d00b001c1fbecbc3fmr6691633plx.5.1696536777182;
        Thu, 05 Oct 2023 13:12:57 -0700 (PDT)
Received: from [127.0.0.1] ([2600:380:4b38:61c1:f2dc:fa2c:4b0:15e1])
        by smtp.gmail.com with ESMTPSA id v10-20020a1709028d8a00b001c5f0fe64c2sm2149040plo.56.2023.10.05.13.12.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 13:12:56 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>
In-Reply-To: <x49y1ghnecs.fsf@segfault.boston.devel.redhat.com>
References: <x49y1ghnecs.fsf@segfault.boston.devel.redhat.com>
Subject: Re: [patch] io-wq: fully initialize wqe before calling
 cpuhp_state_add_instance_nocalls()
Message-Id: <169653677571.126187.4374875152347260651.b4-ty@kernel.dk>
Date:   Thu, 05 Oct 2023 14:12:55 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.13-dev-034f2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Thu, 05 Oct 2023 13:55:31 -0400, Jeff Moyer wrote:
> I received a bug report with the following signature:
> 
> [ 1759.937637] BUG: unable to handle page fault for address: ffffffffffffffe8
> [ 1759.944564] #PF: supervisor read access in kernel mode
> [ 1759.949732] #PF: error_code(0x0000) - not-present page
> [ 1759.954901] PGD 7ab615067 P4D 7ab615067 PUD 7ab617067 PMD 0
> [ 1759.960596] Oops: 0000 1 PREEMPT SMP PTI
> [ 1759.964804] CPU: 15 PID: 109 Comm: cpuhp/15 Kdump: loaded Tainted: G X ------- — 5.14.0-362.3.1.el9_3.x86_64 #1
> [ 1759.976609] Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380 Gen10, BIOS U30 06/20/2018
> [ 1759.985181] RIP: 0010:io_wq_for_each_worker.isra.0+0x24/0xa0
> [ 1759.990877] Code: 90 90 90 90 90 90 0f 1f 44 00 00 41 56 41 55 41 54 55 48 8d 6f 78 53 48 8b 47 78 48 39 c5 74 4f 49 89 f5 49 89 d4 48 8d 58 e8 <8b> 13 85 d2 74 32 8d 4a 01 89 d0 f0 0f b1 0b 75 5c 09 ca 78 3d 48
> [ 1760.009758] RSP: 0000:ffffb6f403603e20 EFLAGS: 00010286
> [ 1760.015013] RAX: 0000000000000000 RBX: ffffffffffffffe8 RCX: 0000000000000000
> [ 1760.022188] RDX: ffffb6f403603e50 RSI: ffffffffb11e95b0 RDI: ffff9f73b09e9400
> [ 1760.029362] RBP: ffff9f73b09e9478 R08: 000000000000000f R09: 0000000000000000
> [ 1760.036536] R10: ffffffffffffff00 R11: ffffb6f403603d80 R12: ffffb6f403603e50
> [ 1760.043712] R13: ffffffffb11e95b0 R14: ffffffffb28531e8 R15: ffff9f7a6fbdf548
> [ 1760.050887] FS: 0000000000000000(0000) GS:ffff9f7a6fbc0000(0000) knlGS:0000000000000000
> [ 1760.059025] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1760.064801] CR2: ffffffffffffffe8 CR3: 00000007ab610002 CR4: 00000000007706e0
> [ 1760.071976] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1760.079150] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 1760.086325] PKRU: 55555554
> [ 1760.089044] Call Trace:
> [ 1760.091501] <TASK>
> [ 1760.093612] ? show_trace_log_lvl+0x1c4/0x2df
> [ 1760.097995] ? show_trace_log_lvl+0x1c4/0x2df
> [ 1760.102377] ? __io_wq_cpu_online+0x54/0xb0
> [ 1760.106584] ? __die_body.cold+0x8/0xd
> [ 1760.110356] ? page_fault_oops+0x134/0x170
> [ 1760.114479] ? kernelmode_fixup_or_oops+0x84/0x110
> [ 1760.119298] ? exc_page_fault+0xa8/0x150
> [ 1760.123247] ? asm_exc_page_fault+0x22/0x30
> [ 1760.127458] ? __pfx_io_wq_worker_affinity+0x10/0x10
> [ 1760.132453] ? __pfx_io_wq_worker_affinity+0x10/0x10
> [ 1760.137446] ? io_wq_for_each_worker.isra.0+0x24/0xa0
> [ 1760.142527] __io_wq_cpu_online+0x54/0xb0
> [ 1760.146558] cpuhp_invoke_callback+0x109/0x460
> [ 1760.151029] ? __pfx_io_wq_cpu_offline+0x10/0x10
> [ 1760.155673] ? __pfx_smpboot_thread_fn+0x10/0x10
> [ 1760.160320] cpuhp_thread_fun+0x8d/0x140
> [ 1760.164266] smpboot_thread_fn+0xd3/0x1a0
> [ 1760.168297] kthread+0xdd/0x100
> [ 1760.171457] ? __pfx_kthread+0x10/0x10
> [ 1760.175225] ret_from_fork+0x29/0x50
> [ 1760.178826] </TASK>
> [ 1760.181022] Modules linked in: rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache netfs rfkill sunrpc vfat fat dm_multipath intel_rapl_msr intel_rapl_common isst_if_common ipmi_ssif nfit libnvdimm mgag200 i2c_algo_bit ioatdma drm_shmem_helper drm_kms_helper acpi_ipmi syscopyarea x86_pkg_temp_thermal sysfillrect ipmi_si intel_powerclamp sysimgblt ipmi_devintf coretemp acpi_power_meter ipmi_msghandler rapl pcspkr dca intel_pch_thermal intel_cstate ses lpc_ich intel_uncore enclosure hpilo mei_me mei acpi_tad fuse drm xfs sd_mod sg bnx2x nvme nvme_core crct10dif_pclmul crc32_pclmul nvme_common ghash_clmulni_intel smartpqi tg3 t10_pi mdio uas libcrc32c crc32c_intel scsi_transport_sas usb_storage hpwdt wmi dm_mirror dm_region_hash dm_log dm_mod
> [ 1760.248623] CR2: ffffffffffffffe8
> 
> [...]

Applied, thanks!

[1/1] io-wq: fully initialize wqe before calling cpuhp_state_add_instance_nocalls()
      commit: 0f8baa3c9802fbfe313c901e1598397b61b91ada

Best regards,
-- 
Jens Axboe



