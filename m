Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1F1698776
	for <lists+io-uring@lfdr.de>; Wed, 15 Feb 2023 22:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjBOVj0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Feb 2023 16:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjBOVj0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Feb 2023 16:39:26 -0500
Received: from cmx-mtlrgo001.bell.net (mta-mtl-005.bell.net [209.71.208.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44D52C655;
        Wed, 15 Feb 2023 13:39:24 -0800 (PST)
X-RG-CM-BuS: 0
X-RG-CM-SC: 0
X-RG-CM: Clean
X-Originating-IP: [174.88.80.151]
X-RG-Env-Sender: dave.anglin@bell.net
X-RG-Rigid: 63E35DF700C26604
X-CM-Envelope: MS4xfC3IQMkdXBhu0u3KzBuLwxQnc588ETT/IIKZWdSOasJEKDXxObhaBd+yl7I8srew9beDjsAqJtSkczrwKgvIMYv1E14LZIx8r/U+vy8Dp9APmhVJQApx
 nHVDa9XkmIYBxo/j9ouootP/o24x9CyJY5rJQt+n31scXOLArk6pEzCZ7xv09q/OdM3sLAXp/4iHxKbcf9508NXmsEjPpaBLynFyuMOzVJL4zLmdQenJOU13
 IjWfibFSrTEcmnq0jaK6x4+CrsTr/K/5z88VHHvEFBY1TzFXKHmIk/DejJCvIObonyo60AV5yxQPbJdv7mtmQ9wWLQeHLSdp4ovM/jlFaxxo3AhuuoO3H8Vi
 Nt2f1gwRGVg7QrABbn4dRB9AcAr8Smu4wXMRBjsCS6RbvFczSe4=
X-CM-Analysis: v=2.4 cv=AuWNYMxP c=1 sm=1 tr=0 ts=63ed5109
 a=6Iw0JHgwQEnu+SgMJEJdFQ==:117 a=6Iw0JHgwQEnu+SgMJEJdFQ==:17
 a=IkcTkHD0fZMA:10 a=FBHGMhGWAAAA:8 a=6tV3kuHN6HInf6AXVRMA:9 a=QEXdDO2ut3YA:10
 a=9gvnlMMaQFpL9xblJ6ne:22
Received: from [192.168.2.49] (174.88.80.151) by cmx-mtlrgo001.bell.net (5.8.814) (authenticated as dave.anglin@bell.net)
        id 63E35DF700C26604; Wed, 15 Feb 2023 16:39:21 -0500
Message-ID: <5e72c1fc-1a7b-a4ed-4097-96816b802e6d@bell.net>
Date:   Wed, 15 Feb 2023 16:39:22 -0500
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
In-Reply-To: <c7725c80-ba8c-1182-7adc-bc107f4f5b75@bell.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023-02-15 4:06 p.m., John David Anglin wrote:
> On 2023-02-15 3:37 p.m., Jens Axboe wrote:
>>> System crashes running test buf-ring.t.
>> Huh, what's the crash?
> Not much info.  System log indicates an HPMC occurred. Unfortunately, recovery code doesn't work.
The following occurred running buf-ring.t under gdb:

INFO: task kworker/u64:9:18319 blocked for more than 123 seconds.
       Not tainted 6.1.12+ #4
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u64:9   state:D stack:0     pid:18319 ppid:2 flags:0x00000000
Workqueue: events_unbound io_ring_exit_work
Backtrace:
  [<0000000040b5c210>] __schedule+0x2e8/0x7f0
  [<0000000040b5c7d0>] schedule+0xb8/0x1d0
  [<0000000040b66534>] schedule_timeout+0x11c/0x1b0
  [<0000000040b5d71c>] __wait_for_common+0x194/0x2e8
  [<0000000040b5d8ac>] wait_for_completion+0x3c/0x50
  [<0000000040b46508>] io_ring_exit_work+0x3d8/0x4d0
  [<0000000040268da8>] process_one_work+0x238/0x520
  [<00000000402692a4>] worker_thread+0x214/0x778
  [<0000000040276f94>] kthread+0x24c/0x258
  [<0000000040202020>] ret_from_kernel_thread+0x20/0x28

INFO: task kworker/u64:10:18320 blocked for more than 123 seconds.
       Not tainted 6.1.12+ #4
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u64:10  state:D stack:0     pid:18320 ppid:2 flags:0x00000000
Workqueue: events_unbound io_ring_exit_work
Backtrace:
  [<0000000040b5c210>] __schedule+0x2e8/0x7f0
  [<0000000040b5c7d0>] schedule+0xb8/0x1d0
  [<0000000040b66534>] schedule_timeout+0x11c/0x1b0
  [<0000000040b5d71c>] __wait_for_common+0x194/0x2e8
  [<0000000040b5d8ac>] wait_for_completion+0x3c/0x50
  [<0000000040b46508>] io_ring_exit_work+0x3d8/0x4d0
  [<0000000040268da8>] process_one_work+0x238/0x520
  [<00000000402692a4>] worker_thread+0x214/0x778
  [<0000000040276f94>] kthread+0x24c/0x258
  [<0000000040202020>] ret_from_kernel_thread+0x20/0x28

gdb was sitting at a break at line 328.

-- 
John David Anglin  dave.anglin@bell.net

