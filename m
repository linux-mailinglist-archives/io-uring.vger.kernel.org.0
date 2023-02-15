Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E98A6987AB
	for <lists+io-uring@lfdr.de>; Wed, 15 Feb 2023 23:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjBOWKT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Feb 2023 17:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjBOWKS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Feb 2023 17:10:18 -0500
Received: from cmx-torrgo001.bell.net (mta-tor-003.bell.net [209.71.212.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF9A42DFA;
        Wed, 15 Feb 2023 14:10:16 -0800 (PST)
X-RG-CM-BuS: 0
X-RG-CM-SC: 0
X-RG-CM: Clean
X-Originating-IP: [174.88.80.151]
X-RG-Env-Sender: dave.anglin@bell.net
X-RG-Rigid: 63EA076D004C1B48
X-CM-Envelope: MS4xfMOVgNfIS14IIhx+PMGUAUkRXZ5OAtItDJ/4tbDbEX20uhtWLlJjMRvYWbMQXfAwM3IwM2Xj831q6DLHZ9nQgRPT5zggmQ17rEf7dhN/2vpquAABUuhL
 ruzqM9HFgkiXG8ZIioiff3nnewycNcW5j/DEGJnIda48UVEE9yQ5gUpRnLatMEuALda41zPEKsAPGZZk1x5wOWFQryJZGFF1e7difr7yg4TssTpVPEnvGSjG
 pHhEXN8csduIszjlXUApL8qWheGdzPV5lLH0Tk0FJtSSFqtrAWcl5lN49aO1DMcWZueY7DXl3NkNZQ51nsvPSHaIO2IwWTemSh2up56l70b64Sckv/Dq0re3
 XvSP1pazu8GmfqT8+r8ENho29DrAWpVoN10uQAFnXDC6IrDVPQc=
X-CM-Analysis: v=2.4 cv=M8Iulw8s c=1 sm=1 tr=0 ts=63ed5842
 a=6Iw0JHgwQEnu+SgMJEJdFQ==:117 a=6Iw0JHgwQEnu+SgMJEJdFQ==:17
 a=IkcTkHD0fZMA:10 a=FBHGMhGWAAAA:8 a=XzT94glyh8IH5fLVOosA:9 a=QEXdDO2ut3YA:10
 a=9gvnlMMaQFpL9xblJ6ne:22
Received: from [192.168.2.49] (174.88.80.151) by cmx-torrgo001.bell.net (5.8.814) (authenticated as dave.anglin@bell.net)
        id 63EA076D004C1B48; Wed, 15 Feb 2023 17:10:10 -0500
Message-ID: <c100a264-d897-1b9e-0483-22272bccd802@bell.net>
Date:   Wed, 15 Feb 2023 17:10:11 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: io_uring failure on parisc with VIPT caches
Content-Language: en-US
From:   John David Anglin <dave.anglin@bell.net>
To:     Jens Axboe <axboe@kernel.dk>, Helge Deller <deller@gmx.de>,
        io-uring@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
References: <Y+wUwVxeN87gqN6o@p100>
 <006e8db4-336f-6717-ecb0-d01a0e9bc483@kernel.dk>
 <626cee6f-f542-b7eb-16ca-1cf4e3808ca6@bell.net>
 <5f02fa8b-7fd8-d98f-4876-f1a89024b888@kernel.dk>
 <2b89f252-c430-1c44-7b30-02d927d2c7cb@gmx.de>
 <f7c3ef57-f16c-7fe3-30b7-8ca6a9ef00ee@kernel.dk>
 <0bfe6cdb-2749-c08d-a1b2-ef46fed1ded3@bell.net>
 <a03d75b9-a9b8-b950-c53d-6df85fe8adc4@kernel.dk>
 <07810314-94f6-0e9a-984b-0a286cbb59d3@kernel.dk>
 <4f4f9048-b382-fa0e-8b51-5a0f0bb08402@kernel.dk>
 <99a41070-f334-f3cb-47cd-8855c938d71f@bell.net>
 <d8dc9156-c001-8181-a946-e9fdfe13f165@kernel.dk>
 <c7725c80-ba8c-1182-7adc-bc107f4f5b75@bell.net>
 <5e72c1fc-1a7b-a4ed-4097-96816b802e6d@bell.net>
In-Reply-To: <5e72c1fc-1a7b-a4ed-4097-96816b802e6d@bell.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023-02-15 4:39 p.m., John David Anglin wrote:
> On 2023-02-15 4:06 p.m., John David Anglin wrote:
>> On 2023-02-15 3:37 p.m., Jens Axboe wrote:
>>>> System crashes running test buf-ring.t.
>>> Huh, what's the crash?
>> Not much info.  System log indicates an HPMC occurred. Unfortunately, recovery code doesn't work.
> The following occurred running buf-ring.t under gdb:
>
> INFO: task kworker/u64:9:18319 blocked for more than 123 seconds.
>       Not tainted 6.1.12+ #4
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:kworker/u64:9   state:D stack:0     pid:18319 ppid:2 flags:0x00000000
> Workqueue: events_unbound io_ring_exit_work
> Backtrace:
>  [<0000000040b5c210>] __schedule+0x2e8/0x7f0
>  [<0000000040b5c7d0>] schedule+0xb8/0x1d0
>  [<0000000040b66534>] schedule_timeout+0x11c/0x1b0
>  [<0000000040b5d71c>] __wait_for_common+0x194/0x2e8
>  [<0000000040b5d8ac>] wait_for_completion+0x3c/0x50
>  [<0000000040b46508>] io_ring_exit_work+0x3d8/0x4d0
>  [<0000000040268da8>] process_one_work+0x238/0x520
>  [<00000000402692a4>] worker_thread+0x214/0x778
>  [<0000000040276f94>] kthread+0x24c/0x258
>  [<0000000040202020>] ret_from_kernel_thread+0x20/0x28
>
> INFO: task kworker/u64:10:18320 blocked for more than 123 seconds.
>       Not tainted 6.1.12+ #4
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:kworker/u64:10  state:D stack:0     pid:18320 ppid:2 flags:0x00000000
> Workqueue: events_unbound io_ring_exit_work
> Backtrace:
>  [<0000000040b5c210>] __schedule+0x2e8/0x7f0
>  [<0000000040b5c7d0>] schedule+0xb8/0x1d0
>  [<0000000040b66534>] schedule_timeout+0x11c/0x1b0
>  [<0000000040b5d71c>] __wait_for_common+0x194/0x2e8
>  [<0000000040b5d8ac>] wait_for_completion+0x3c/0x50
>  [<0000000040b46508>] io_ring_exit_work+0x3d8/0x4d0
>  [<0000000040268da8>] process_one_work+0x238/0x520
>  [<00000000402692a4>] worker_thread+0x214/0x778
>  [<0000000040276f94>] kthread+0x24c/0x258
>  [<0000000040202020>] ret_from_kernel_thread+0x20/0x28
>
> gdb was sitting at a break at line 328.
With Helge's latest patch, we get a software lockup:

TCP: request_sock_TCP: Possible SYN flooding on port 31309. Sending cookies.  Check SNMP counters.
watchdog: BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u64:13:14621]
Modules linked in: binfmt_misc ext4 crc16 jbd2 ext2 mbcache sg ipmi_watchdog ipmi_si ipmi_poweroff ipmi_devintf ipmi_msghandler fuse nfsd 
ip_tables x_tables ipv6 autofs4 xfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c 
crc32c_generic raid1 raid0 multipath linear md_mod sd_mod t10_pi ses enclosure scsi_transport_sas crc64_rocksoft crc64 sr_mod uas usb_storage 
cdrom ohci_pci ehci_pci ohci_hcd pata_cmd64x ehci_hcd sym53c8xx libata scsi_transport_spi usbcore tg3 scsi_mod scsi_common usb_common
CPU: 0 PID: 14621 Comm: kworker/u64:13 Not tainted 6.1.12+ #5
Hardware name: 9000/800/rp3440
Workqueue: events_unbound io_ring_exit_work

      YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
PSW: 00001000001011001111111100001111 Not tainted
r00-03  000000ff082cff0f 00000000670cc880 00000000406e64f0 00000000670cc990
r04-07  0000000040c099c0 00000000629d1158 0000000000000000 000000006a406800
r08-11  00000000629d10e0 00000000629d1d98 0000000000000003 00000000670cc888
r12-15  00000000670cc960 000000000000002e 0000000040c709c0 0000000000000000
r16-19  0000000040c709c0 0000000040c709c0 0000000059dc6d60 0000000000000000
r20-23  0000000000000001 0000000000000001 0000000000000000 0000000064252110
r24-27  0000000000000003 00000000670cc888 0000000000000000 0000000040c099c0
r28-31  0000000059dc6d60 00000000670cc960 00000000670cca10 0000000000000001
sr00-03  000000000116c400 000000000116c400 0000000000000000 000000000116c400
sr04-07  0000000000000000 0000000000000000 0000000000000000 0000000000000000

IASQ: 0000000000000000 0000000000000000 IAOQ: 0000000040683df0 0000000040683e38
  IIR: 0f5010df    ISR: 0000000000000000  IOR: 00000000670ccbc0
  CPU:        0   CR30: 0000000059dc6d60 CR31: ffffffffffffefff
  ORIG_R28: 0000000040203070
  IAOQ[0]: iocb_bio_iopoll+0x30/0x80
  IAOQ[1]: iocb_bio_iopoll+0x78/0x80
  RP(r2): io_do_iopoll+0xa8/0x4b0
Backtrace:
  [<00000000406e64f0>] io_do_iopoll+0xa8/0x4b0
  [<0000000040b45d88>] io_uring_try_cancel_requests+0x2a0/0x6a8
  [<0000000040b4628c>] io_ring_exit_work+0xfc/0x4d0
  [<0000000040268da8>] process_one_work+0x238/0x520
  [<00000000402692a4>] worker_thread+0x214/0x778
  [<0000000040276f94>] kthread+0x24c/0x258
  [<0000000040202020>] ret_from_kernel_thread+0x20/0x28

watchdog: BUG: soft lockup - CPU#0 stuck for 49s! [kworker/u64:13:14621]
Modules linked in: binfmt_misc ext4 crc16 jbd2 ext2 mbcache sg ipmi_watchdog ipmi_si ipmi_poweroff ipmi_devintf ipmi_msghandler fuse nfsd 
ip_tables x_tables ipv6 autofs4 xfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c 
crc32c_generic raid1 raid0 multipath linear md_mod sd_mod t10_pi ses enclosure scsi_transport_sas crc64_rocksoft crc64 sr_mod uas usb_storage 
cdrom ohci_pci ehci_pci ohci_hcd pata_cmd64x ehci_hcd sym53c8xx libata scsi_transport_spi usbcore tg3 scsi_mod scsi_common usb_common
CPU: 0 PID: 14621 Comm: kworker/u64:13 Tainted: G             L 6.1.12+ #5
Hardware name: 9000/800/rp3440
Workqueue: events_unbound io_ring_exit_work

      YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
PSW: 00001000000001001111111100001111 Tainted: G             L
r00-03  000000ff0804ff0f 00000000670cc880 00000000406e64f0 00000000670cc880
r04-07  0000000040c099c0 00000000629d1f58 0000000000000000 000000006a406800
r08-11  00000000629d1b60 00000000629d1bd8 0000000000000003 00000000670cc888
r12-15  00000000670cc960 000000000000002e 0000000040c709c0 0000000000000000
r16-19  0000000040c709c0 0000000040c709c0 0000000059dc6d60 0000000000000000
r20-23  0000000000000001 0000000000000001 0000000000000000 0000000064252110
r24-27  0000000000000003 00000000670cc888 00000000670cc888 0000000040c099c0
r28-31  00000000629d1f58 00000000670cc960 00000000670cc990 0000000059dc6d60
sr00-03  000000000116c400 000000000116c400 0000000000000000 000000000116c400
sr04-07  0000000000000000 0000000000000000 0000000000000000 0000000000000000

IASQ: 0000000000000000 0000000000000000 IAOQ: 00000000406e6528 00000000406e652c
  IIR: 50bf3f11    ISR: 000000000116c400  IOR: 0000000000000000
  CPU:        0   CR30: 0000000059dc6d60 CR31: ffffffffffffefff
  ORIG_R28: 0000000000000000
  IAOQ[0]: io_do_iopoll+0xe0/0x4b0
  IAOQ[1]: io_do_iopoll+0xe4/0x4b0
  RP(r2): io_do_iopoll+0xa8/0x4b0
Backtrace:
  [<0000000040b45d88>] io_uring_try_cancel_requests+0x2a0/0x6a8
  [<0000000040b4628c>] io_ring_exit_work+0xfc/0x4d0
  [<0000000040268da8>] process_one_work+0x238/0x520
  [<00000000402692a4>] worker_thread+0x214/0x778
  [<0000000040276f94>] kthread+0x24c/0x258
  [<0000000040202020>] ret_from_kernel_thread+0x20/0x28

rcu: INFO: rcu_sched self-detected stall on CPU
rcu:    0-....: (5979 ticks this GP) idle=b23c/1/0x4000000000000002 softirq=36165/36165 fqs=2989
         (t=6000 jiffies g=69677 q=1954 ncpus=4)
CPU: 0 PID: 14621 Comm: kworker/u64:13 Tainted: G             L 6.1.12+ #5
Hardware name: 9000/800/rp3440
Workqueue: events_unbound io_ring_exit_work

      YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
PSW: 00001000000001001111111100001111 Tainted: G             L
r00-03  000000ff0804ff0f 00000000670cc880 00000000406e64f0 00000000670cc990
r04-07  0000000040c099c0 0000000069aa6d98 0000000000000000 000000006a406800
r08-11  0000000069aa6d20 00000000629d1f58 0000000000000003 00000000670cc888
r12-15  00000000670cc960 000000000000002e 0000000040c709c0 0000000000000000
r16-19  0000000040c709c0 0000000040c709c0 0000000059dc6d60 0000000000000000
r20-23  0000000000000001 0000000000000001 0000000000000000 0000000064252110
r24-27  0000000000000003 00000000670cc888 0000000000000000 0000000040c099c0
r28-31  0000000000000000 00000000670cc960 00000000670cca10 0000000059dc6d60
sr00-03  000000000116c400 000000000116c400 0000000000000000 000000000116c400
sr04-07  0000000000000000 0000000000000000 0000000000000000 0000000000000000

IASQ: 0000000000000000 0000000000000000 IAOQ: 0000000040683e24 0000000040683e28
  IIR: 0c6110c2    ISR: 00000000670cc850  IOR: 00000000670ccbc0
  CPU:        0   CR30: 0000000059dc6d60 CR31: ffffffffffffefff
  ORIG_R28: 0000000040c709c0
  IAOQ[0]: iocb_bio_iopoll+0x64/0x80
  IAOQ[1]: iocb_bio_iopoll+0x68/0x80
  RP(r2): io_do_iopoll+0xa8/0x4b0
Backtrace:
  [<00000000406e64f0>] io_do_iopoll+0xa8/0x4b0
  [<0000000040b45d88>] io_uring_try_cancel_requests+0x2a0/0x6a8
  [<0000000040b4628c>] io_ring_exit_work+0xfc/0x4d0
  [<0000000040268da8>] process_one_work+0x238/0x520
  [<00000000402692a4>] worker_thread+0x214/0x778
  [<0000000040276f94>] kthread+0x24c/0x258
  [<0000000040202020>] ret_from_kernel_thread+0x20/0x28

watchdog: BUG: soft lockup - CPU#0 stuck for 82s! [kworker/u64:13:14621]
Modules linked in: binfmt_misc ext4 crc16 jbd2 ext2 mbcache sg ipmi_watchdog ipmi_si ipmi_poweroff ipmi_devintf ipmi_msghandler fuse nfsd 
ip_tables x_tables ipv6 autofs4 xfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c 
crc32c_generic raid1 raid0 multipath linear md_mod sd_mod t10_pi ses enclosure scsi_transport_sas crc64_rocksoft crc64 sr_mod uas usb_storage 
cdrom ohci_pci ehci_pci ohci_hcd pata_cmd64x ehci_hcd sym53c8xx libata scsi_transport_spi usbcore tg3 scsi_mod scsi_common usb_common
CPU: 0 PID: 14621 Comm: kworker/u64:13 Tainted: G             L 6.1.12+ #5
Hardware name: 9000/800/rp3440
Workqueue: events_unbound io_ring_exit_work

      YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
PSW: 00001000000001001111111100001111 Tainted: G             L
r00-03  000000ff0804ff0f 00000000670cc880 00000000406e64f0 00000000670cc880
r04-07  0000000040c099c0 00000000629d1078 0000000000000000 000000006a406800
r08-11  00000000629d1000 00000000629d1158 0000000000000003 00000000670cc888
r12-15  00000000670cc960 000000000000002e 0000000040c709c0 0000000000000000
r16-19  0000000040c709c0 0000000040c709c0 0000000059dc6d60 0000000000000000
r20-23  0000000000000001 0000000000000001 0000000000000000 0000000064252110
r24-27  0000000000000003 00000000670cc888 00000000629d1000 0000000040c099c0
r28-31  0000000040ba7940 00000000670cc960 00000000670cc990 0000000000000002
sr00-03  000000000116c400 000000000116c400 0000000000000000 000000000116c400
sr04-07  0000000000000000 0000000000000000 0000000000000000 0000000000000000

IASQ: 0000000000000000 0000000000000000 IAOQ: 00000000406e64e4 00000000406e64e8
  IIR: 53820020    ISR: 000000000116c400  IOR: 0000000000000000
  CPU:        0   CR30: 0000000059dc6d60 CR31: ffffffffffffefff
  ORIG_R28: 0000000000000000
  IAOQ[0]: io_do_iopoll+0x9c/0x4b0
  IAOQ[1]: io_do_iopoll+0xa0/0x4b0
  RP(r2): io_do_iopoll+0xa8/0x4b0
Backtrace:
  [<0000000040b45d88>] io_uring_try_cancel_requests+0x2a0/0x6a8
  [<0000000040b4628c>] io_ring_exit_work+0xfc/0x4d0
  [<0000000040268da8>] process_one_work+0x238/0x520
  [<00000000402692a4>] worker_thread+0x214/0x778
  [<0000000040276f94>] kthread+0x24c/0x258
  [<0000000040202020>] ret_from_kernel_thread+0x20/0x28

watchdog: BUG: soft lockup - CPU#0 stuck for 108s! [kworker/u64:13:14621]
Modules linked in: binfmt_misc ext4 crc16 jbd2 ext2 mbcache sg ipmi_watchdog ipmi_si ipmi_poweroff ipmi_devintf ipmi_msghandler fuse nfsd 
ip_tables x_tables ipv6 autofs4 xfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c 
crc32c_generic raid1 raid0 multipath linear md_mod sd_mod t10_pi ses enclosure scsi_transport_sas crc64_rocksoft crc64 sr_mod uas usb_storage 
cdrom ohci_pci ehci_pci ohci_hcd pata_cmd64x ehci_hcd sym53c8xx libata scsi_transport_spi usbcore tg3 scsi_mod scsi_common usb_common
CPU: 0 PID: 14621 Comm: kworker/u64:13 Tainted: G             L 6.1.12+ #5
Hardware name: 9000/800/rp3440
Workqueue: events_unbound io_ring_exit_work

      YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
PSW: 00001000001011001111111100001111 Tainted: G             L
r00-03  000000ff082cff0f 00000000670cc880 00000000406e64f0 00000000670cc990
r04-07  0000000040c099c0 0000000069aa63f8 0000000000000000 000000006a406800
r08-11  0000000069aa6380 0000000069aa6d98 0000000000000003 00000000670cc888
r12-15  00000000670cc960 000000000000002e 0000000040c709c0 0000000000000000
r16-19  0000000040c709c0 0000000040c709c0 0000000059dc6d60 0000000000000000
r20-23  0000000000000001 0000000000000001 0000000000000000 0000000064252110
r24-27  0000000000000003 00000000670cc888 0000000000000000 0000000040c099c0
r28-31  0000000059dc6d60 00000000670cc960 00000000670cca10 0000000000000001
sr00-03  000000000116c400 000000000116c400 0000000000000000 000000000116c400
sr04-07  0000000000000000 0000000000000000 0000000000000000 0000000000000000

IASQ: 0000000000000000 0000000000000000 IAOQ: 0000000040683df0 0000000040683e38
  IIR: 0f5010df    ISR: 00000000670cc850  IOR: 0000000000000001
  CPU:        0   CR30: 0000000059dc6d60 CR31: ffffffffffffefff
  ORIG_R28: 0000000040c709c0
  IAOQ[0]: iocb_bio_iopoll+0x30/0x80
  IAOQ[1]: iocb_bio_iopoll+0x78/0x80
  RP(r2): io_do_iopoll+0xa8/0x4b0
Backtrace:
  [<00000000406e64f0>] io_do_iopoll+0xa8/0x4b0
  [<0000000040b45d88>] io_uring_try_cancel_requests+0x2a0/0x6a8
  [<0000000040b4628c>] io_ring_exit_work+0xfc/0x4d0
  [<0000000040268da8>] process_one_work+0x238/0x520
  [<00000000402692a4>] worker_thread+0x214/0x778
  [<0000000040276f94>] kthread+0x24c/0x258
  [<0000000040202020>] ret_from_kernel_thread+0x20/0x28

watchdog: BUG: soft lockup - CPU#0 stuck for 134s! [kworker/u64:13:14621]
Modules linked in: binfmt_misc ext4 crc16 jbd2 ext2 mbcache sg ipmi_watchdog ipmi_si ipmi_poweroff ipmi_devintf ipmi_msghandler fuse nfsd 
ip_tables x_tables ipv6 autofs4 xfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c 
crc32c_generic raid1 raid0 multipath linear md_mod sd_mod t10_pi ses enclosure scsi_transport_sas crc64_rocksoft crc64 sr_mod uas usb_storage 
cdrom ohci_pci ehci_pci ohci_hcd pata_cmd64x ehci_hcd sym53c8xx libata scsi_transport_spi usbcore tg3 scsi_mod scsi_common usb_common
CPU: 0 PID: 14621 Comm: kworker/u64:13 Tainted: G             L 6.1.12+ #5
Hardware name: 9000/800/rp3440
Workqueue: events_unbound io_ring_exit_work

      YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
PSW: 00001000001011001111111100001111 Tainted: G             L
r00-03  000000ff082cff0f 00000000670cc880 00000000406e64f0 00000000670cc990
r04-07  0000000040c099c0 00000000629d1e78 0000000000000000 000000006a406800
r08-11  00000000629d1e00 00000000629d1938 0000000000000003 00000000670cc888
r12-15  00000000670cc960 000000000000002e 0000000040c709c0 0000000000000000
r16-19  0000000040c709c0 0000000040c709c0 0000000059dc6d60 0000000000000000
r20-23  0000000000000001 0000000000000001 0000000000000000 0000000064252110
r24-27  0000000000000003 00000000670cc888 0000000000000000 0000000040c099c0
r28-31  0000000059dc6d60 00000000670cc960 00000000670cca10 0000000000000001
sr00-03  000000000116c400 000000000116c400 0000000000000000 000000000116c400
sr04-07  0000000000000000 0000000000000000 0000000000000000 0000000000000000

IASQ: 0000000000000000 0000000000000000 IAOQ: 0000000040683df0 0000000040683e38
  IIR: 0f5010df    ISR: 0000000000000000  IOR: 0000000040c709c0
  CPU:        0   CR30: 0000000059dc6d60 CR31: ffffffffffffefff
  ORIG_R28: 0000000040203070
  IAOQ[0]: iocb_bio_iopoll+0x30/0x80
  IAOQ[1]: iocb_bio_iopoll+0x78/0x80
  RP(r2): io_do_iopoll+0xa8/0x4b0
Backtrace:
  [<00000000406e64f0>] io_do_iopoll+0xa8/0x4b0
  [<0000000040b45d88>] io_uring_try_cancel_requests+0x2a0/0x6a8
  [<0000000040b4628c>] io_ring_exit_work+0xfc/0x4d0
  [<0000000040268da8>] process_one_work+0x238/0x520
  [<00000000402692a4>] worker_thread+0x214/0x778
  [<0000000040276f94>] kthread+0x24c/0x258
  [<0000000040202020>] ret_from_kernel_thread+0x20/0x28

Running test 232c93d07b74.t 4 sec [5]
Running test 35fa71a030ca.t 5 sec [5]
Running test 500f9fbadef8.t 25 sec [25]
Running test 7ad0e4b2f83c.t 1 sec [1]
Running test 8a9973408177.t 0 sec [1]
Running test 917257daa0fe.t 0 sec [0]
Running test a0908ae19763.t 0 sec [0]
Running test a4c0b3decb33.t Test a4c0b3decb33.t timed out (may not be a failure)
Running test accept.t 2 sec [1]
Running test accept-link.t 0 sec [1]
Running test accept-reuse.t 0 sec [0]
Running test accept-test.t 0 sec [0]
Running test across-fork.t 0 sec [0]
Running test b19062a56726.t 0 sec [0]
Running test b5837bd5311d.t 0 sec [0]
Running test buf-ring.t bad run 0/0 = -233
test_running(1) failed
Test buf-ring.t failed with ret 1
Running test ce593a6c480a.t 1 sec [1]
Running test close-opath.t 0 sec [0]
Running test connect.t 0 sec [0]
Running test cq-full.t 0 sec [0]
Running test cq-overflow.t 11 sec [12]
Running test cq-peek-batch.t 0 sec [0]
Running test cq-ready.t 1 sec [0]
Running test cq-size.t 0 sec [0]
Running test d4ae271dfaae.t 0 sec [0]
Running test d77a67ed5f27.t 0 sec [0]
Running test defer.t 3 sec [4]
Running test defer-taskrun.t 1 sec [0]
Running test double-poll-crash.t Skipped
Running test drop-submit.t 0 sec [0]
Running test eeed8b54e0df.t 0 sec [0]
Running test empty-eownerdead.t 0 sec [0]
Running test eploop.t 0 sec [0]
Running test eventfd.t 0 sec [0]
Running test eventfd-disable.t 0 sec [0]
Running test eventfd-reg.t 0 sec [0]
Running test eventfd-ring.t 0 sec [1]
Running test evloop.t 0 sec [0]
Running test exec-target.t 0 sec [0]
Running test exit-no-cleanup.t 1 sec [0]
Running test fadvise.t 0 sec [0]
Running test fallocate.t 0 sec [0]
Running test fc2a85cb02ef.t Test needs failslab/fail_futex/fail_page_alloc enabled, skipped
Skipped
Running test fd-pass.t 0 sec [0]
Running test file-register.t 3 sec [4]
Running test files-exit-hang-poll.t 1 sec [1]
Running test files-exit-hang-timeout.t 1 sec [1]
Running test file-update.t 0 sec [0]
Running test file-verify.t Found 2784, wanted 527072
Buffered novec reg test failed
Test file-verify.t failed with ret 1
Running test fixed-buf-iter.t 0 sec [0]
Running test fixed-link.t 0 sec [0]
Running test fixed-reuse.t 0 sec [0]
Running test fpos.t 1 sec [0]
Running test fsnotify.t Skipped
Running test fsync.t 0 sec [0]
Running test hardlink.t 0 sec [0]
Running test io-cancel.t 3 sec [3]
Running test iopoll.t 7 sec [2]
Running test iopoll-leak.t 0 sec [0]
Running test iopoll-overflow.t 1 sec [1]
Running test io_uring_enter.t 1 sec [0]
Running test io_uring_passthrough.t Skipped
Running test io_uring_register.t Unable to map a huge page.  Try increasing /proc/sys/vm/nr_hugepages by at least 1.
Skipping the hugepage test

Message from syslogd@mx3210 at Feb 15 22:04:15 ...
  kernel:watchdog: BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u64:13:14621]

Message from syslogd@mx3210 at Feb 15 22:04:43 ...
  kernel:watchdog: BUG: soft lockup - CPU#0 stuck for 49s! [kworker/u64:13:14621]
Test io_uring_register.t timed out (may not be a failure)
Running test io_uring_setup.t 0 sec [0]
Running test lfs-openat.t 0 sec [0]
Running test lfs-openat-write.t 0 sec [0]
Running test link.t 0 sec [0]
Running test link_drain.t 3 sec [3]
Running test link-timeout.t 1 sec [1]
Running test madvise.t
Message from syslogd@mx3210 at Feb 15 22:05:19 ...
  kernel:watchdog: BUG: soft lockup - CPU#0 stuck for 82s! [kworker/u64:13:14621]

Message from syslogd@mx3210 at Feb 15 22:05:47 ...
  kernel:watchdog: BUG: soft lockup - CPU#0 stuck for 108s! [kworker/u64:13:14621]
^C^C^C^C^C^C^C^C
Message from syslogd@mx3210 at Feb 15 22:06:15 ...
  kernel:watchdog: BUG: soft lockup - CPU#0 stuck for 134s! [kworker/u64:13:14621]

-- 
John David Anglin  dave.anglin@bell.net

