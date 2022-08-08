Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7458558C45D
	for <lists+io-uring@lfdr.de>; Mon,  8 Aug 2022 09:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235769AbiHHHqD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Aug 2022 03:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241995AbiHHHpz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Aug 2022 03:45:55 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D00E0E2;
        Mon,  8 Aug 2022 00:45:51 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0VLfdfxM_1659944747;
Received: from 30.227.91.246(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VLfdfxM_1659944747)
          by smtp.aliyun-inc.com;
          Mon, 08 Aug 2022 15:45:48 +0800
Message-ID: <ddf90347-5f71-031a-90a7-62da57a75c59@linux.alibaba.com>
Date:   Mon, 8 Aug 2022 15:45:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Subject: [bug report] ublk: re-issued blk-mq request may reference a freed
 io_uring context
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi, all

We are running test on ublk to verify its stability. While running
tests/generic/002 in ublksrv[1] which kills ublksrv daemon while
running fio at the same time, we find a null-deference error.

[1] https://github.com/ming1/ubdsrv

***********************
DMESG:
***********************

[ 1396.090924] BUG: kernel NULL pointer dereference, address: 0000000000000000
[ 1396.098770] ublk_ctrl_uring_cmd: cmd done ret 0 cmd_op 2, dev id 0 qid 65535
[ 1396.105714] #PF: supervisor write access in kernel mode
[ 1396.105716] #PF: error_code(0x0002) - not-present page
[ 1396.105718] PGD 800000013c762067 P4D 800000013c762067 PUD 634c8d067 PMD 0 
[ 1396.132122] Oops: 0002 [#1] PREEMPT SMP PTI
[ 1396.136613] CPU: 33 PID: 27341 Comm: kworker/33:2 Kdump: loaded Tainted: G S         OE      5.19.0 #121
[ 1396.146382] Hardware name: Inventec     K900G3-10G/B900G3, BIOS A2.20 06/23/2017
[ 1396.154069] Workqueue: events io_fallback_req_func
[ 1396.159169] RIP: 0010:percpu_ref_get_many+0x23/0x30
[ 1396.164360] Code: 0f 1f 80 00 00 00 00 55 48 89 f5 53 48 89 fb e8 83 93 be ff 48 8b 03 a8 03 75 0b 65 48 01 28 5b 5d e9 b1 f5 be ff 48 8b 43 08 <f0> 48 01 28 5b 5d e9 a2 f5 be ff 66 90 41 54 49 89 d4 55 48 89 f5
[ 1396.183754] RSP: 0018:ffffae20e37c7e48 EFLAGS: 00010206
[ 1396.189301] RAX: 0000000000000000 RBX: ffff9e966730d800 RCX: 0000000000000000
[ 1396.196754] RDX: ffff9e9651ca9180 RSI: 0000000000000001 RDI: ffff9e966730d800
[ 1396.204214] RBP: 0000000000000001 R08: 61626c6c61665f6f R09: 665f7165725f6b63
[ 1396.211671] R10: 666562203a636e75 R11: 7265746920657269 R12: ffff9e965da36700
[ 1396.219143] R13: ffff9e965da36788 R14: 0000000000000000 R15: ffff9ed4bf876905
[ 1396.226607] FS:  0000000000000000(0000) GS:ffff9ed4bf840000(0000) knlGS:0000000000000000
[ 1396.235026] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1396.241110] CR2: 0000000000000000 CR3: 000000068cf9c001 CR4: 00000000003706e0
[ 1396.248587] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1396.256054] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1396.263523] Call Trace:
[ 1396.266313]  <TASK>
[ 1396.268747]  io_fallback_req_func+0x61/0x126
[ 1396.273354]  process_one_work+0x1df/0x3b0
[ 1396.277705]  worker_thread+0x49/0x2e0
[ 1396.281712]  ? rescuer_thread+0x390/0x390
[ 1396.286060]  kthread+0xe5/0x110
[ 1396.289534]  ? kthread_complete_and_exit+0x20/0x20
[ 1396.294644]  ret_from_fork+0x1f/0x30
[ 1396.298551]  </TASK>
[ 1396.301055] Modules linked in: ublk_drv(OE) tcp_diag(E) udp_diag(E) inet_diag(E) ip6_tables(E) iptable_filter(E) ebtable_nat(E) ebtables(E) binfmt_misc(E) intel_rapl_msr(E) intel_rapl_common(E) iosf_mbi(E) x86_pkg_temp_thermal(E) coretemp(E) bonding(E) tls(E) kvm_intel(E) kvm(E) irqbypass(E) crct10dif_pclmul(E) crc32_pclmul(E) ghash_clmulni_intel(E) aesni_intel(E) iTCO_wdt(E) crypto_simd(E) iTCO_vendor_support(E) cryptd(E) mxm_wmi(E) mei_me(E) i2c_i801(E) lpc_ich(E) pcspkr(E) sg(E) i2c_smbus(E) mfd_core(E) mei(E) acpi_ipmi(E) ipmi_si(E) ipmi_devintf(E) ipmi_msghandler(E) wmi(E) acpi_power_meter(E) ip_tables(E) ast(E) i2c_algo_bit(E) drm_vram_helper(E) drm_kms_helper(E) syscopyarea(E) sysfillrect(E) sysimgblt(E) fb_sys_fops(E) drm_ttm_helper(E) ttm(E) crc32c_intel(E) drm(E) nvme(E) i2c_core(E) ixgbe(E) nvme_core(E) mdio(E) dca(E) sd_mod(E) t10_pi(E) crc64_rocksoft(E) crc64(E) ahci(E) libahci(E) libata(E) [last unloaded: ublk_drv]
[ 1396.386209] CR2: 0000000000000000

***********************
DESCRIPTION 1:
***********************

Here in percpu_ref_get_many():atomic_long_add(nr, &ref->data->count),
ref->data is actually freed because io_uring's ctx->refs is freed at that
time. We analyze ublk_drv.c and find a reason, assume there is only one
tag per blk-mq queue:

      CPU 0                     CPU 1                        CPU2                       CPU3

__ublk_rq_task_work()               

io_uring_cmd_done(io->cmd)

****task crash****                                                                           
                                                                                  io_ring_exit_work()
                                                                           /* Now io_uring ctx can be freed
                                                                           since all ioucmd(only one) are done */
                                                                                     

                      ublk_daemon_monitor_work()               
                 blk_mq_end_request(req, BLK_STS_IOERR);
  
                                              
              
                                                       ublk_queue_rq() /* fio re-issue req because of IO error */
                                                      ubq_daemon_is_dying() /* NOT SEE PF_EXITING */
                                                 io_uring_cmd_complete_in_task(io->cmd) /* the io_uring ctx is freed! */
                                                    io_fallback_req_func() /* io_uring fallback */
                                                     percpu_ref_get_many() /* null-deref! */

***********************
DESCRIPTION 2:
***********************


I describe the above data flow here again:
(1) After the ioucmd are io_uring_cmd_done(), a crash happens.

(2) The io_uring context is freed (at least part
    of it, e.g. ctx->refs) because we don't reference it anymore.

(3) Then, monitor_work aborts the blk-mq request and fio re-tries
    because of the I/O error.

(4) After that, ublk_queue_rq() is called for the re-issued request
    but it does not see PF_EXITING!(Since ublk_queue_rq() is called
    in another task different from ubq_daemon or ioucmd's task)

(5) io_uring_cmd_complete_in_task() is called, and the ioucmd is
    still the old one because the tag does not change.

(6) io_fallback_req_func(), and ref->data is NULL while calling
    atomic_long_add(nr, &ref->data->count).

The root cause is that:

(1) io_uring_cmd_complete_in_task() does not
    immediately try to call task_work_add(), but puts the ioucmd's
    task_work into a llist for batching. If task_work_add() is called
    immediately in ublk_queue_rq(), this situation can be avoided.

(2) In ublk_drv.c:ublk_queue_rq(), check on PF_EXITING is added:

	 if (unlikely(ubq_daemon_is_dying(ubq))) {
  fail:
	      	 mod_delayed_work(system_wq, &ubq->dev->monitor_work, 0);
		 return BLK_STS_IOERR;
	 }

    However, this check on PF_EXITING is unsafe since ublk_queue_rq() runs in
    another task other than ubq_daemon(ioucmd's task). ublk_queue_rq() may not
    see PF_EXITING after the ubq_daemon(ioucmd's task) crashes. With this
    check, the above null-deref error rarely happens. But if we comment it out,
    We are more likely to trigger this error.

***********************
HOW TO REPRODUCE:
***********************

(1) Forbid check on PF_EXITING. In ublk_drv.c:ublk_queue_rq(), comment out:
	
	if (unlikely(ubq_daemon_is_dying(ubq))) {
 fail:
		mod_delayed_work(system_wq, &ubq->dev->monitor_work, 0);
		return BLK_STS_IOERR;
	}

    This makes sense because this check is unsafe and we are more likely to re-produce
    this error without this check.

(2) Then, run:

    make test T=generic/002

    It may fail after running several times.

Please point out my mistake because this bug is really complicated for me :)


Regards,
Zhang
