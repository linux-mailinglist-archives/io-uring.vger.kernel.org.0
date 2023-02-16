Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071F4698A93
	for <lists+io-uring@lfdr.de>; Thu, 16 Feb 2023 03:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjBPCk2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Feb 2023 21:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBPCk1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Feb 2023 21:40:27 -0500
Received: from cmx-torrgo001.bell.net (mta-tor-005.bell.net [209.71.212.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7AF30B2F;
        Wed, 15 Feb 2023 18:40:24 -0800 (PST)
X-RG-CM-BuS: 0
X-RG-CM-SC: 0
X-RG-CM: Clean
X-Originating-IP: [174.88.80.151]
X-RG-Env-Sender: dave.anglin@bell.net
X-RG-Rigid: 63EA076D00525091
X-CM-Envelope: MS4xfCh4gRp0/tCUXLg1rQI5lTkO7q5a2aciVK4znEo7vfbRqUBapF1TBSC8mgiKiP04pHhHY6BVkCC9zQ7+lN5zijofcgh7DH4pYZu4PlgKdAFiql23f87I
 FhApDn112kT9tqGA+DbXra3laz+EkKWAzpUuuVxAHoxNNCcaBrmNYiIhbXSe071S0Sz4YdtmycCR4MXQ1Cn3AirBI7wfSqHkDE2KAKnVpt6boIainTDb46mi
 H66YijEF68L4pXt64E/UtSVzphjbqFEx8iWSCvFUuWI89nN8XRhuf5BfjPlSvthnVEfSPVDkNRBBO+xYM36yAouJer7L2cT8R1ouN8XU5wkL8CkXDkT0CHv4
 jUg2QW38/JoW//8NsCk4zRkt1s1elPxZnHc1AJocwQEllo3M0Yw=
X-CM-Analysis: v=2.4 cv=M8Iulw8s c=1 sm=1 tr=0 ts=63ed9794
 a=6Iw0JHgwQEnu+SgMJEJdFQ==:117 a=6Iw0JHgwQEnu+SgMJEJdFQ==:17
 a=IkcTkHD0fZMA:10 a=FBHGMhGWAAAA:8 a=JVLGN14q-YJdKCZ9VrIA:9 a=QEXdDO2ut3YA:10
 a=9gvnlMMaQFpL9xblJ6ne:22
Received: from [192.168.2.49] (174.88.80.151) by cmx-torrgo001.bell.net (5.8.814) (authenticated as dave.anglin@bell.net)
        id 63EA076D00525091; Wed, 15 Feb 2023 21:40:20 -0500
Message-ID: <1237dc53-2495-a145-37bf-47366ca75e71@bell.net>
Date:   Wed, 15 Feb 2023 21:40:20 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: io_uring failure on parisc with VIPT caches
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
 <c100a264-d897-1b9e-0483-22272bccd802@bell.net>
 <73566dc4-317b-5808-a5a5-78dc195ebd77@kernel.dk>
Content-Language: en-US
From:   John David Anglin <dave.anglin@bell.net>
In-Reply-To: <73566dc4-317b-5808-a5a5-78dc195ebd77@kernel.dk>
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

On 2023-02-15 6:02 p.m., Jens Axboe wrote:
> This is not related to Helge's patch, 6.1-stable is just still missing:
>
> commit fcc926bb857949dbfa51a7d95f3f5ebc657f198c
> Author: Jens Axboe<axboe@kernel.dk>
> Date:   Fri Jan 27 09:28:13 2023 -0700
>
>      io_uring: add a conditional reschedule to the IOPOLL cancelation loop
>
> and I'm guessing you're running without preempt.
With 6.2.0-rc8+, I had a different crash running poll-race-mshot.t:

Backtrace:


Kernel Fault: Code=15 (Data TLB miss fault) at addr 0000000000000000
CPU: 0 PID: 18265 Comm: poll-race-mshot Not tainted 6.2.0-rc8+ #1
Hardware name: 9000/800/rp3440

      YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
PSW: 00010000001001001001000111110000 Not tainted
r00-03  00000000102491f0 ffffffffffffffff 000000004020307c ffffffffffffffff
r04-07  ffffffffffffffff ffffffffffffffff ffffffffffffffff ffffffffffffffff
r08-11  ffffffffffffffff 000000000407ef28 000000000407f838 8400000000800000
r12-15  0000000000000000 0000000040c424e0 0000000040c424e0 0000000040c424e0
r16-19  000000000407fd68 0000000063f08648 0000000040c424e0 000000000a085000
r20-23  00000000000d6b44 000000002faf0800 00000000000000ff 0000000000000002
r24-27  000000000407fa30 000000000407fd68 0000000000000000 0000000040c1e4e0
r28-31  400000000000de84 0000000000000000 0000000000000000 0000000000000002
sr00-03  0000000004081000 0000000000000000 0000000000000000 0000000004081de0
sr04-07  0000000004081000 0000000000000000 0000000000000000 00000000040815a8

IASQ: 0000000004081000 0000000000000000 IAOQ: 0000000000000000 0000000004081590
  IIR: 00000000    ISR: 0000000000000000  IOR: 0000000000000000
  CPU:        0   CR30: 000000004daf5700 CR31: ffffffffffffefff
  ORIG_R28: 0000000000000000
  IAOQ[0]: 0x0
  IAOQ[1]: linear_quiesce+0x0/0x18 [linear]
  RP(r2): intr_check_sig+0x0/0x3c
Backtrace:

Kernel panic - not syncing: Kernel Fault

Dave

-- 
John David Anglin  dave.anglin@bell.net

