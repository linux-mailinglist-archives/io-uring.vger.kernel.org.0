Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2119A699DD9
	for <lists+io-uring@lfdr.de>; Thu, 16 Feb 2023 21:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbjBPUgL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Feb 2023 15:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjBPUgJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Feb 2023 15:36:09 -0500
Received: from cmx-mtlrgo002.bell.net (mta-mtl-003.bell.net [209.71.208.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF96196AA;
        Thu, 16 Feb 2023 12:36:04 -0800 (PST)
X-RG-CM-BuS: 0
X-RG-CM-SC: 0
X-RG-CM: Clean
X-Originating-IP: [174.88.80.151]
X-RG-Env-Sender: dave.anglin@bell.net
X-RG-Rigid: 63E35FA800DF2409
X-CM-Envelope: MS4xfGJI5yBVtbpEAS+uxDX3XaD5hxkcSVc/o3eE4lPNju57qCkgnJFBL64RZIte5zhnmk0GH0og98n4XWc3TUhJARZ3YHe6cDtM2UyL7RdivshuacPnNrPr
 k3qYXmfpxaZPws2J2dPgMQXPF+AvYuH3I+HQARttm1TzKlJlJyjdLl+NgeB/xAmXw74vTRCX77V+zprCLdGzo668TJ1fKI2L+6WUhQXtA7L3DfxiaT+IJK/V
 cuVfIlmMLr0GEwP7agbpl0S9/my73ND4aNC0+szqqvY3Fazy1TWEytpGqZS7mSdD/jikwvSp3nbvGaEarhhB6sUeomlzCnnnnZe3jOW8QLY=
X-CM-Analysis: v=2.4 cv=GcB0ISbL c=1 sm=1 tr=0 ts=63ee93ae
 a=6Iw0JHgwQEnu+SgMJEJdFQ==:117 a=6Iw0JHgwQEnu+SgMJEJdFQ==:17
 a=IkcTkHD0fZMA:10 a=FBHGMhGWAAAA:8 a=Wk9uKQLQGnSBQQzVoy0A:9 a=QEXdDO2ut3YA:10
 a=9gvnlMMaQFpL9xblJ6ne:22
Received: from [192.168.2.49] (174.88.80.151) by cmx-mtlrgo002.bell.net (5.8.814) (authenticated as dave.anglin@bell.net)
        id 63E35FA800DF2409; Thu, 16 Feb 2023 15:35:58 -0500
Message-ID: <9e71536a-cf72-77cc-60d1-fb3872227fea@bell.net>
Date:   Thu, 16 Feb 2023 15:35:59 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: io_uring failure on parisc with VIPT caches
To:     Helge Deller <deller@gmx.de>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-parisc@vger.kernel.org
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
 <c100a264-d897-1b9e-0483-22272bccd802@bell.net>
 <73566dc4-317b-5808-a5a5-78dc195ebd77@kernel.dk>
 <1237dc53-2495-a145-37bf-47366ca75e71@bell.net>
 <3a7e342c-844e-8071-7dde-86b88bbb2dc4@kernel.dk>
 <c70ef9b0-4100-fbc2-237d-5830e32bd519@gmx.de>
Content-Language: en-US
From:   John David Anglin <dave.anglin@bell.net>
In-Reply-To: <c70ef9b0-4100-fbc2-237d-5830e32bd519@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023-02-16 3:24 a.m., Helge Deller wrote:
> On 2/16/23 03:50, Jens Axboe wrote:
>> On 2/15/23 7:40 PM, John David Anglin wrote:
>>> On 2023-02-15 6:02 p.m., Jens Axboe wrote:
>>>> This is not related to Helge's patch, 6.1-stable is just still missing:
>>>>
>>>> commit fcc926bb857949dbfa51a7d95f3f5ebc657f198c
>>>> Author: Jens Axboe<axboe@kernel.dk>
>>>> Date:   Fri Jan 27 09:28:13 2023 -0700
>>>>
>>>>       io_uring: add a conditional reschedule to the IOPOLL cancelation loop
>>>>
>>>> and I'm guessing you're running without preempt.
>>> With 6.2.0-rc8+, I had a different crash running poll-race-mshot.t:
>>>
>>> Backtrace:
>>>
>>>
>>> Kernel Fault: Code=15 (Data TLB miss fault) at addr 0000000000000000
>>> CPU: 0 PID: 18265 Comm: poll-race-mshot Not tainted 6.2.0-rc8+ #1
>>> Hardware name: 9000/800/rp3440
>>>
>>>       YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
>>> PSW: 00010000001001001001000111110000 Not tainted
>>> r00-03  00000000102491f0 ffffffffffffffff 000000004020307c ffffffffffffffff
>>> r04-07  ffffffffffffffff ffffffffffffffff ffffffffffffffff ffffffffffffffff
>>> r08-11  ffffffffffffffff 000000000407ef28 000000000407f838 8400000000800000
>>> r12-15  0000000000000000 0000000040c424e0 0000000040c424e0 0000000040c424e0
>>> r16-19  000000000407fd68 0000000063f08648 0000000040c424e0 000000000a085000
>>> r20-23  00000000000d6b44 000000002faf0800 00000000000000ff 0000000000000002
>>> r24-27  000000000407fa30 000000000407fd68 0000000000000000 0000000040c1e4e0
>>> r28-31  400000000000de84 0000000000000000 0000000000000000 0000000000000002
>>> sr00-03  0000000004081000 0000000000000000 0000000000000000 0000000004081de0
>>> sr04-07  0000000004081000 0000000000000000 0000000000000000 00000000040815a8
>>>
>>> IASQ: 0000000004081000 0000000000000000 IAOQ: 0000000000000000 0000000004081590
>>>   IIR: 00000000    ISR: 0000000000000000  IOR: 0000000000000000
>>>   CPU:        0   CR30: 000000004daf5700 CR31: ffffffffffffefff
>>>   ORIG_R28: 0000000000000000
>>>   IAOQ[0]: 0x0
>>>   IAOQ[1]: linear_quiesce+0x0/0x18 [linear]
>>>   RP(r2): intr_check_sig+0x0/0x3c
>>> Backtrace:
>>>
>>> Kernel panic - not syncing: Kernel Fault
>>
>> This means very little to me, is it a NULL pointer deref? And where's
>> the backtrace?
>
> I see iopoll.t triggering the kernel to hang on 32-bit kernel.
> System gets unresponsive, bug with sysrq-l I get:
>
> [  880.020641] sysrq: Show backtrace of all active CPUs
> [  880.024123] sysrq: CPU0:
> [  880.024123] CPU: 0 PID: 7549 Comm: kworker/u32:7 Not tainted 6.1.12-32bit+ #1595
> [  880.024123] Hardware name: 9000/785/C3700
> [  880.024123] Workqueue: events_unbound io_ring_exit_work
> [  880.024123]
> [  880.024123]      YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
> [  880.024123] PSW: 00000000000011001111111100001111 Not tainted
> [  880.024123] r00-03  000cff0f 19610540 104f7b70 19610540
> [  880.024123] r04-07  1921a278 00000000 192c8400 1921b508
> [  880.024123] r08-11  00000003 0000002e 195fd050 00000004
> [  880.024123] r12-15  192c8710 10a77000 00000000 00002000
> [  880.024123] r16-19  1921a210 1240c000 1240c060 1924aff0
> [  880.024123] r20-23  00000002 00000000 104b4384 00000020
> [  880.024123] r24-27  00000003 19610548 1921a210 10aba968
> [  880.024123] r28-31  1094f5c0 0000000e 196105c0 104f7b70
> [  880.024123] sr00-03  00000000 00001695 00000000 00001695
> [  880.024123] sr04-07  00000000 00000000 00000000 00000000
> [  880.024123]
> [  880.024123] IASQ: 00000000 00000000 IAOQ: 104f7b6c 104b4384
> [  880.024123]  IIR: 081f0242    ISR: 00002000  IOR: 00000000
> [  880.024123]  CPU:        0   CR30: 195fd050 CR31: d237ffff
> [  880.024123]  ORIG_R28: 00000000
> [  880.024123]  IAOQ[0]: io_do_iopoll+0xb4/0x3a4
> [  880.024123]  IAOQ[1]: iocb_bio_iopoll+0x0/0x50
> [  880.024123]  RP(r2): io_do_iopoll+0xb8/0x3a4
> [  880.024123] Backtrace:
> [  880.024123]  [<1092a2b0>] io_uring_try_cancel_requests+0x184/0x3b0
> [  880.024123]  [<1092a57c>] io_ring_exit_work+0xa0/0x4c4
> [  880.024123]  [<101cb448>] process_one_work+0x1c4/0x3cc
> [  880.024123]  [<101cb7d8>] worker_thread+0x188/0x4b4
> [  880.024123]  [<101d5910>] kthread+0xec/0xf4
> [  880.024123]  [<1018801c>] ret_from_kernel_thread+0x1c/0x24
I had updated to 6.2.0-rc8+ to avoid this issue.

I agree there's not a lot of helpful info in the dump.  Somehow, the code has branched to
location 0 and attempted to execute instruction 0.  RP points at intr_check_sig but not to
a valid return point for a call instruction.  In the dump above, SP is 0.  Maybe the stack
overflowed for the process?

I have run the test multiple times by itself.  It consistently generates a HPMC check.  The PIM
dump provides no more info than the above dump (i.e., kernel has tried to execute location 0).
It didn't appear SP had been clobbered in the PIM dump that I looked at.

Running the test under strace gives different points where the trace stops:

io_uring_setup(64, {flags=0, sq_thread_cpu=0, sq_thread_idle=0, sq_entries=64, cq_entries=128, 
features=IORING_FEAT_SINGLE_MMAP|IORING_FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_FEAT_CUR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|0x1f80, 
sq_off={head=0, tail=16, ring_mask=64, ring_entries=72, flags=84, dropped=80, array=2144}, cq_off={head=32, tail=48, ring_mask=68, 
ring_entries=76, overflow=92, cqes=96, flags=0x58 /* IORING_CQ_??? */}}) = 3

io_uring_enter(3, 64, 0, 0, NULL, 8)    = 64

io_uring_setup(64, {flags=0, sq_thread_cpu=0, sq_thread_idle=0, sq_entries=64, cq_entries=128, 
features=IORING_FEAT_SINGLE_MMAP|IORING_FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_FEAT_CUR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|0x1f80, 
sq_off={head=0, tail=16, ring_mask=64, ring_entries=72, flags=84, dropped=80, array=2144}, cq_off={head=32, tail=48, ring_mask=68, 
ring_entries=76, overflow=92, cqes=96, flags=0x58 /* IORING_CQ_??? */}}) = 3
mmap2(NULL, 2400, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0) = 0xf8cad000
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0x10000000

-- 
John David Anglin  dave.anglin@bell.net

