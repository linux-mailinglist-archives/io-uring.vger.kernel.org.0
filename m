Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 088AF7BA874
	for <lists+io-uring@lfdr.de>; Thu,  5 Oct 2023 19:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbjJERu7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Oct 2023 13:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbjJERuv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Oct 2023 13:50:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB44BC6
        for <io-uring@vger.kernel.org>; Thu,  5 Oct 2023 10:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696528199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=qp3yUup3Gf8+DHS7/smF1TYS38a/HixcY7xP+MuWznE=;
        b=hcimXfMETd6gQB4vObzI2kGL66QA2sNT51OYWUZtKJOCO0OTXGxK36u9tjXbH2mTFEqpyX
        ekziG1KZ1nSZm6PUPVYmjf9CWPrutvNluBCmE7wys0WrjXW1lDVEzMko/JHLDkwmeaAtSC
        497kjW36znWf8cJ0dIv5YppWIheBGCg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-136-9nT1r7RbOCaiRE0jv9NCyA-1; Thu, 05 Oct 2023 13:49:47 -0400
X-MC-Unique: 9nT1r7RbOCaiRE0jv9NCyA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D95953C170AB;
        Thu,  5 Oct 2023 17:49:46 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BF667C15BB8;
        Thu,  5 Oct 2023 17:49:46 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk
Subject: [patch] io-wq: fully initialize wqe before calling cpuhp_state_add_instance_nocalls()
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Thu, 05 Oct 2023 13:55:31 -0400
Message-ID: <x49y1ghnecs.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I received a bug report with the following signature:

[ 1759.937637] BUG: unable to handle page fault for address: ffffffffffffff=
e8
[ 1759.944564] #PF: supervisor read access in kernel mode
[ 1759.949732] #PF: error_code(0x0000) - not-present page
[ 1759.954901] PGD 7ab615067 P4D 7ab615067 PUD 7ab617067 PMD 0
[ 1759.960596] Oops: 0000 1 PREEMPT SMP PTI
[ 1759.964804] CPU: 15 PID: 109 Comm: cpuhp/15 Kdump: loaded Tainted: G X -=
------ =E2=80=94 5.14.0-362.3.1.el9_3.x86_64 #1
[ 1759.976609] Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380 Gen10=
, BIOS U30 06/20/2018
[ 1759.985181] RIP: 0010:io_wq_for_each_worker.isra.0+0x24/0xa0
[ 1759.990877] Code: 90 90 90 90 90 90 0f 1f 44 00 00 41 56 41 55 41 54 55 =
48 8d 6f 78 53 48 8b 47 78 48 39 c5 74 4f 49 89 f5 49 89 d4 48 8d 58 e8 <8b=
> 13 85 d2 74 32 8d 4a 01 89 d0 f0 0f b1 0b 75 5c 09 ca 78 3d 48
[ 1760.009758] RSP: 0000:ffffb6f403603e20 EFLAGS: 00010286
[ 1760.015013] RAX: 0000000000000000 RBX: ffffffffffffffe8 RCX: 00000000000=
00000
[ 1760.022188] RDX: ffffb6f403603e50 RSI: ffffffffb11e95b0 RDI: ffff9f73b09=
e9400
[ 1760.029362] RBP: ffff9f73b09e9478 R08: 000000000000000f R09: 00000000000=
00000
[ 1760.036536] R10: ffffffffffffff00 R11: ffffb6f403603d80 R12: ffffb6f4036=
03e50
[ 1760.043712] R13: ffffffffb11e95b0 R14: ffffffffb28531e8 R15: ffff9f7a6fb=
df548
[ 1760.050887] FS: 0000000000000000(0000) GS:ffff9f7a6fbc0000(0000) knlGS:0=
000000000000000
[ 1760.059025] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1760.064801] CR2: ffffffffffffffe8 CR3: 00000007ab610002 CR4: 00000000007=
706e0
[ 1760.071976] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[ 1760.079150] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[ 1760.086325] PKRU: 55555554
[ 1760.089044] Call Trace:
[ 1760.091501] <TASK>
[ 1760.093612] ? show_trace_log_lvl+0x1c4/0x2df
[ 1760.097995] ? show_trace_log_lvl+0x1c4/0x2df
[ 1760.102377] ? __io_wq_cpu_online+0x54/0xb0
[ 1760.106584] ? __die_body.cold+0x8/0xd
[ 1760.110356] ? page_fault_oops+0x134/0x170
[ 1760.114479] ? kernelmode_fixup_or_oops+0x84/0x110
[ 1760.119298] ? exc_page_fault+0xa8/0x150
[ 1760.123247] ? asm_exc_page_fault+0x22/0x30
[ 1760.127458] ? __pfx_io_wq_worker_affinity+0x10/0x10
[ 1760.132453] ? __pfx_io_wq_worker_affinity+0x10/0x10
[ 1760.137446] ? io_wq_for_each_worker.isra.0+0x24/0xa0
[ 1760.142527] __io_wq_cpu_online+0x54/0xb0
[ 1760.146558] cpuhp_invoke_callback+0x109/0x460
[ 1760.151029] ? __pfx_io_wq_cpu_offline+0x10/0x10
[ 1760.155673] ? __pfx_smpboot_thread_fn+0x10/0x10
[ 1760.160320] cpuhp_thread_fun+0x8d/0x140
[ 1760.164266] smpboot_thread_fn+0xd3/0x1a0
[ 1760.168297] kthread+0xdd/0x100
[ 1760.171457] ? __pfx_kthread+0x10/0x10
[ 1760.175225] ret_from_fork+0x29/0x50
[ 1760.178826] </TASK>
[ 1760.181022] Modules linked in: rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_res=
olver nfs lockd grace fscache netfs rfkill sunrpc vfat fat dm_multipath int=
el_rapl_msr intel_rapl_common isst_if_common ipmi_ssif nfit libnvdimm mgag2=
00 i2c_algo_bit ioatdma drm_shmem_helper drm_kms_helper acpi_ipmi syscopyar=
ea x86_pkg_temp_thermal sysfillrect ipmi_si intel_powerclamp sysimgblt ipmi=
_devintf coretemp acpi_power_meter ipmi_msghandler rapl pcspkr dca intel_pc=
h_thermal intel_cstate ses lpc_ich intel_uncore enclosure hpilo mei_me mei =
acpi_tad fuse drm xfs sd_mod sg bnx2x nvme nvme_core crct10dif_pclmul crc32=
_pclmul nvme_common ghash_clmulni_intel smartpqi tg3 t10_pi mdio uas libcrc=
32c crc32c_intel scsi_transport_sas usb_storage hpwdt wmi dm_mirror dm_regi=
on_hash dm_log dm_mod
[ 1760.248623] CR2: ffffffffffffffe8=20

A cpu hotplug callback was issued before wq->all_list was initialized.
This results in a null pointer dereference.  The fix is to fully setup
the io_wq before calling cpuhp_state_add_instance_nocalls().

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 1ecc8c748768..522196dfb0ff 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1151,9 +1151,6 @@ struct io_wq *io_wq_create(unsigned bounded, struct i=
o_wq_data *data)
 	wq =3D kzalloc(sizeof(struct io_wq), GFP_KERNEL);
 	if (!wq)
 		return ERR_PTR(-ENOMEM);
-	ret =3D cpuhp_state_add_instance_nocalls(io_wq_online, &wq->cpuhp_node);
-	if (ret)
-		goto err_wq;
=20
 	refcount_inc(&data->hash->refs);
 	wq->hash =3D data->hash;
@@ -1186,13 +1183,14 @@ struct io_wq *io_wq_create(unsigned bounded, struct=
 io_wq_data *data)
 	wq->task =3D get_task_struct(data->task);
 	atomic_set(&wq->worker_refs, 1);
 	init_completion(&wq->worker_done);
+	ret =3D cpuhp_state_add_instance_nocalls(io_wq_online, &wq->cpuhp_node);
+	if (ret)
+		goto err;
+
 	return wq;
 err:
 	io_wq_put_hash(data->hash);
-	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
-
 	free_cpumask_var(wq->cpu_mask);
-err_wq:
 	kfree(wq);
 	return ERR_PTR(ret);
 }

