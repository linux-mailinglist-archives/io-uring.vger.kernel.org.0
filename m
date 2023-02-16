Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C738B6998B7
	for <lists+io-uring@lfdr.de>; Thu, 16 Feb 2023 16:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjBPPWw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Feb 2023 10:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjBPPWv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Feb 2023 10:22:51 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED72654561
        for <io-uring@vger.kernel.org>; Thu, 16 Feb 2023 07:22:42 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id u8so839555ilq.13
        for <io-uring@vger.kernel.org>; Thu, 16 Feb 2023 07:22:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1676560962;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NmFbLlKUdk+Ikt+LouvYtjRE14+P/joqH+1P557eF4A=;
        b=hlfCMlGSCjytrpOGK0PpuSsgrhB5m7xa/fUccCriKu2vFql/mmhjBDAaJMoLwrOMrH
         ivPL8wP8a13n4evCoyDjJtd1FRo+Tx5F5azFQ7SXHx8uZqhSDB7JF3148132/crDZh1H
         tzdK+XoVXyNVS20sVva8aIS8O7mML/qAduXQgbfp6MHKJEUlp7resoVDkmOTSVnxzwuR
         e8r8gNTo0u7G0LOcygnbdhrp9afHhLa+YSB/MqZ71+aA+D4CGKEA9QfWfqwOfqQ2ZIqA
         D7+zATChVvE+HVcAqR8tTiMPIeYjb7ZmimxVT88Cjui/AWqatMmN5ivujoRiLoIDxTZb
         qD4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676560962;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NmFbLlKUdk+Ikt+LouvYtjRE14+P/joqH+1P557eF4A=;
        b=kBZIta7Onu3/ILxi48+4BbWrgiV/lFgz5Bha1WQYxJalNPz3DD3zjWL7oyPboxoYvQ
         NWYPI50xsOha4nXC44s9WDekuJTx79GKuLzaNkI5ju/wl/1QLQJgbl+89HEMG6DoQ+u0
         TEr+YrRxkEYgZzNluBnENsiSyvThJUyAAzLIdu7M03hkPuVfv5fs4pmqTQoMHNfgn0So
         gW6PL22CCcfXIXFUvqMjDt2cWR0x7/ekQ6QJtFZysEMZ4ccElyAQhZHpDpI4F8mlplqh
         sxLAym9MIoBK8fpFwGLkD6TcGqfiMqGU+dd1dvgoBnYWe0eqGymu+bhb7oyqQNHFkLa4
         UuRA==
X-Gm-Message-State: AO0yUKXx7BexRk26u8NS7E3TW1SqbHaKjbuDbinLPZun24mdXleW8h8e
        AWndBn9XT4Cd6Dw5KEXwK/aE8LXwBuiDn+GJ
X-Google-Smtp-Source: AK7set8EBEzuAa9OgFqfivEU5aDH1rr5nFLinmdea48RhxBefOxDj40RhnHXdg1TmpUZ/a+ddb4BOg==
X-Received: by 2002:a92:ac0c:0:b0:315:363e:b140 with SMTP id r12-20020a92ac0c000000b00315363eb140mr4049501ilh.1.1676560962137;
        Thu, 16 Feb 2023 07:22:42 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l20-20020a02ccf4000000b003c4859c9dc0sm604981jaq.110.2023.02.16.07.22.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 07:22:41 -0800 (PST)
Message-ID: <a9f0f6d0-5530-f494-b021-34553c56ddc7@kernel.dk>
Date:   Thu, 16 Feb 2023 08:22:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: io_uring failure on parisc with VIPT caches
Content-Language: en-US
To:     Helge Deller <deller@gmx.de>,
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
 <c70ef9b0-4100-fbc2-237d-5830e32bd519@gmx.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c70ef9b0-4100-fbc2-237d-5830e32bd519@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/16/23 1:24 AM, Helge Deller wrote:
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

See the other email, a patch for that has been in the 6.3 for a
while and marked for backport.

-- 
Jens Axboe


