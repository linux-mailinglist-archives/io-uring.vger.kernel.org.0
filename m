Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE79D698EA0
	for <lists+io-uring@lfdr.de>; Thu, 16 Feb 2023 09:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjBPIY2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Feb 2023 03:24:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjBPIY1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Feb 2023 03:24:27 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D68A3C25;
        Thu, 16 Feb 2023 00:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1676535862; i=deller@gmx.de;
        bh=6Pdh1R+6n0Ck2b9ZjAmZILJrULyIMji4BrDAVbJsV84=;
        h=X-UI-Sender-Class:Date:Subject:To:References:From:In-Reply-To;
        b=fhUcBday27i4FgeAEcNSoMohUsrhRXpsLZVNlvLslT5MvPiznP8fP8AvJWyJtWezl
         s3nj2xp1swSPyCYlcZDvhG+Ti0smq3k7gJwD+9WsrYCj7qGlgxSZcXQUlmk08I12nB
         UZZOpy32xyVn0wBD8V72mU+Hx9ptoQZbMREipxfCYgzM6XDj6ClXGn0RlnoUANaT39
         Cq2CVZiUoOTc54yvYdemkaGJO1DdO8U1HZ0o6RukgzoYNpiMC4fqzfk1HqmKFRvw4j
         BJtdlnBrE65AzJXiAfmh915pGXCeugULZnruLwq6PFt5Hd1nlrf5ML5e8v+OjZ4DGM
         /wvj8oUMNNJ3g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([92.116.164.173]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MZTqW-1p5wcy2A9m-00WTEa; Thu, 16
 Feb 2023 09:24:22 +0100
Message-ID: <c70ef9b0-4100-fbc2-237d-5830e32bd519@gmx.de>
Date:   Thu, 16 Feb 2023 09:24:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: io_uring failure on parisc with VIPT caches
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        John David Anglin <dave.anglin@bell.net>,
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
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <3a7e342c-844e-8071-7dde-86b88bbb2dc4@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:lQlJ1c8kr0QsydlJGjnitht49qTArEi+vo2bbsjD25dg0l3+9Li
 szY+s3qv99Xp6nheTAnWVnk41HN/fsMlTiSz3Zsh0QKlerNmQtUz1kMWI15+SkKO1ouRRwT
 TZPZwikTk2R6gbImV4lGb75d3fXf+pwmztwjPyVCSvB1FzDRxCUfS4+WhT2viUM/+qGsDaS
 2XGA2HoYpn9BDUS5OQjXg==
UI-OutboundReport: notjunk:1;M01:P0:m1m4Va7wlOE=;mdypW8HSr5wX5cNwxaexy57NHOs
 gqWG6cbvhIRgY5C3zJXdnPZAW9aC7lwkrTDtckIeDBkzZLoPbhOqOyIoPxA0uHdxZUsyQvGN1
 GXgIYH7EKktFknlOFt0S9UmggtP/YBgQjAjTwk6he4Ojcwo6xs5shSDpW854j8grmUKzmOLgm
 0GHvxdcqfeccRnZXeloB1Z+cRjB5xl5KnLsMTSHAT+VZ3Y4mTOMu/suYwLjoYYFr6OXcJoGIc
 Jd8NpIA1fWGmXQpbZpGBkX/TsCQA9Wdm9drTmSRqS9f/E389rWrX/SwQfiL/aTdj0qJe6E3aG
 ytxsCHU+sxDfgKh+VvLNQaAEaSvrfBEVzYib2SIECFqtR4icAwc5f3DzZknckZ5etaU7xAzKV
 BgAqB068L8XwfcXC1p2PBqql430zyLCtMKpY1vglnKxmYPcQIqdlWb4Soi78tRrBu2ujfq6oj
 J2hqQpMWbvPnD/fJMrmKTfFvxVL92wob2/mafUq2ZMhIgbyLVvL3XLQWzujFzHDE078fTSzgb
 gVeqVrgaWdHbQik978jgCRhdhYntkXJ95Dyby70IiMDO73kb/qUdQTUOm4oyAvWEjkgE2dxdh
 xgZsAbNazuyydI+x1j8jx9WiG2DVkV+PwsmH/UNe1z5ICbM/fcrcUW1X+4O82ttuRCc0S+feU
 StlaRLzxTYdhqZKjBr0aVG1Yu1hCT9X21Cz0OEjjLxBRFLa9Xv5ra4/YLwsWMNQsT0P22yULw
 O2XExnPS5BoIih1jdsTDqvQEFJ2bGm1Kl5+kmQUsTOlBZk3NgtOM9S/3xHsgyEyqQzlceJ9a8
 t+v2BCVt5ArTBEXC8GQ9HPX7szz6DrTPNwLQAklT2D/A4HbN7g61rtETyxueegHUkI5yI5/R0
 1tQ9NPLqGQfBzMG+WGbBz0T9Kgg1iHDpwx2gXZ2oOYkrF5XaHet4+h6xJ8X43oXF0rL3TWnSw
 TLdQPZHA+Vea0ogZZXftIVfIkCc=
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/16/23 03:50, Jens Axboe wrote:
> On 2/15/23 7:40=E2=80=AFPM, John David Anglin wrote:
>> On 2023-02-15 6:02 p.m., Jens Axboe wrote:
>>> This is not related to Helge's patch, 6.1-stable is just still missing=
:
>>>
>>> commit fcc926bb857949dbfa51a7d95f3f5ebc657f198c
>>> Author: Jens Axboe<axboe@kernel.dk>
>>> Date:=C2=A0=C2=A0 Fri Jan 27 09:28:13 2023 -0700
>>>
>>>  =C2=A0=C2=A0=C2=A0=C2=A0 io_uring: add a conditional reschedule to th=
e IOPOLL cancelation loop
>>>
>>> and I'm guessing you're running without preempt.
>> With 6.2.0-rc8+, I had a different crash running poll-race-mshot.t:
>>
>> Backtrace:
>>
>>
>> Kernel Fault: Code=3D15 (Data TLB miss fault) at addr 0000000000000000
>> CPU: 0 PID: 18265 Comm: poll-race-mshot Not tainted 6.2.0-rc8+ #1
>> Hardware name: 9000/800/rp3440
>>
>>  =C2=A0=C2=A0=C2=A0=C2=A0 YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
>> PSW: 00010000001001001001000111110000 Not tainted
>> r00-03=C2=A0 00000000102491f0 ffffffffffffffff 000000004020307c fffffff=
fffffffff
>> r04-07=C2=A0 ffffffffffffffff ffffffffffffffff ffffffffffffffff fffffff=
fffffffff
>> r08-11=C2=A0 ffffffffffffffff 000000000407ef28 000000000407f838 8400000=
000800000
>> r12-15=C2=A0 0000000000000000 0000000040c424e0 0000000040c424e0 0000000=
040c424e0
>> r16-19=C2=A0 000000000407fd68 0000000063f08648 0000000040c424e0 0000000=
00a085000
>> r20-23=C2=A0 00000000000d6b44 000000002faf0800 00000000000000ff 0000000=
000000002
>> r24-27=C2=A0 000000000407fa30 000000000407fd68 0000000000000000 0000000=
040c1e4e0
>> r28-31=C2=A0 400000000000de84 0000000000000000 0000000000000000 0000000=
000000002
>> sr00-03=C2=A0 0000000004081000 0000000000000000 0000000000000000 000000=
0004081de0
>> sr04-07=C2=A0 0000000004081000 0000000000000000 0000000000000000 000000=
00040815a8
>>
>> IASQ: 0000000004081000 0000000000000000 IAOQ: 0000000000000000 00000000=
04081590
>>  =C2=A0IIR: 00000000=C2=A0=C2=A0=C2=A0 ISR: 0000000000000000=C2=A0 IOR:=
 0000000000000000
>>  =C2=A0CPU:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0 CR3=
0: 000000004daf5700 CR31: ffffffffffffefff
>>  =C2=A0ORIG_R28: 0000000000000000
>>  =C2=A0IAOQ[0]: 0x0
>>  =C2=A0IAOQ[1]: linear_quiesce+0x0/0x18 [linear]
>>  =C2=A0RP(r2): intr_check_sig+0x0/0x3c
>> Backtrace:
>>
>> Kernel panic - not syncing: Kernel Fault
>
> This means very little to me, is it a NULL pointer deref? And where's
> the backtrace?

I see iopoll.t triggering the kernel to hang on 32-bit kernel.
System gets unresponsive, bug with sysrq-l I get:

[  880.020641] sysrq: Show backtrace of all active CPUs
[  880.024123] sysrq: CPU0:
[  880.024123] CPU: 0 PID: 7549 Comm: kworker/u32:7 Not tainted 6.1.12-32b=
it+ #1595
[  880.024123] Hardware name: 9000/785/C3700
[  880.024123] Workqueue: events_unbound io_ring_exit_work
[  880.024123]
[  880.024123]      YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
[  880.024123] PSW: 00000000000011001111111100001111 Not tainted
[  880.024123] r00-03  000cff0f 19610540 104f7b70 19610540
[  880.024123] r04-07  1921a278 00000000 192c8400 1921b508
[  880.024123] r08-11  00000003 0000002e 195fd050 00000004
[  880.024123] r12-15  192c8710 10a77000 00000000 00002000
[  880.024123] r16-19  1921a210 1240c000 1240c060 1924aff0
[  880.024123] r20-23  00000002 00000000 104b4384 00000020
[  880.024123] r24-27  00000003 19610548 1921a210 10aba968
[  880.024123] r28-31  1094f5c0 0000000e 196105c0 104f7b70
[  880.024123] sr00-03  00000000 00001695 00000000 00001695
[  880.024123] sr04-07  00000000 00000000 00000000 00000000
[  880.024123]
[  880.024123] IASQ: 00000000 00000000 IAOQ: 104f7b6c 104b4384
[  880.024123]  IIR: 081f0242    ISR: 00002000  IOR: 00000000
[  880.024123]  CPU:        0   CR30: 195fd050 CR31: d237ffff
[  880.024123]  ORIG_R28: 00000000
[  880.024123]  IAOQ[0]: io_do_iopoll+0xb4/0x3a4
[  880.024123]  IAOQ[1]: iocb_bio_iopoll+0x0/0x50
[  880.024123]  RP(r2): io_do_iopoll+0xb8/0x3a4
[  880.024123] Backtrace:
[  880.024123]  [<1092a2b0>] io_uring_try_cancel_requests+0x184/0x3b0
[  880.024123]  [<1092a57c>] io_ring_exit_work+0xa0/0x4c4
[  880.024123]  [<101cb448>] process_one_work+0x1c4/0x3cc
[  880.024123]  [<101cb7d8>] worker_thread+0x188/0x4b4
[  880.024123]  [<101d5910>] kthread+0xec/0xf4
[  880.024123]  [<1018801c>] ret_from_kernel_thread+0x1c/0x24

Helge
