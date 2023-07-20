Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A0D75BAF8
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 01:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjGTXCA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 19:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjGTXB7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 19:01:59 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F9C92;
        Thu, 20 Jul 2023 16:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de;
 s=s31663417; t=1689894115; x=1690498915; i=deller@gmx.de;
 bh=NLW57MKbuSFqkweYp1SSc7U/sQ5F1Uv49Q59sFSA9Zg=;
 h=X-UI-Sender-Class:Date:Subject:To:References:From:In-Reply-To;
 b=EHidxgHSi+iWotq7d2kvx3fRDAG7zSobqhZU8Jocz6KuSMVXPHV9M3Oft05OJf4O4TEUqJC
 JKpBk5/fjJL7zOuMA+KzbwXQz7ZzO2cwtaz2sY3jpnuB9JOFzn/pRCdHrkuK7nzprTpy9gADD
 2a37H9wkHdBVKR2B1xwvXfMC2UW4ofsRB7PHaop1t1PfWyYePMUdhN8VsXvVGH9piahYvm5Q+
 p1bkmo5wQ6IpB4FkB//bjrHS9Pc4NdAB/Ab+9Y9METGYmu2FSeoJytfG4fspKt+gvJPwM0vhM
 akBNh63YRiqviy/9JxrN0Yss9paHgpyAHY6GOm79uYpoEbH0UAOA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([94.134.153.9]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M72oB-1qHN4G0h1r-008aj9; Fri, 21
 Jul 2023 01:01:55 +0200
Message-ID: <9ed73ae3-7990-1084-9656-8295e1b7fcfb@gmx.de>
Date:   Fri, 21 Jul 2023 01:01:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH][RFC] io_uring: Fix io_uring_mmu_get_unmapped_area() for
 IA-64
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-ia64@vger.kernel.org, matoro_mailinglist_kernel@matoro.tk,
        linux-parisc@vger.kernel.org
References: <ZLhTuTPecx2fGuH1@p100>
 <0a242157-6dd6-77fd-b218-52e3ba06e450@kernel.dk>
 <be208704-b312-f04d-4548-90853a638752@gmx.de>
 <6dfbaa5b-5894-bfc9-f9a9-09d019c335d9@kernel.dk>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <6dfbaa5b-5894-bfc9-f9a9-09d019c335d9@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:q1FlcaJQPJA5CpcKiVyDflKpqsn9MUai+i+tvkbNl2D/LaVYABv
 ATcRxmHtIjWSW9egSFcTwb7UHa58zaouG6s3QowS8uRj7G+AAa41puCjWCmWggNMmTqmTxL
 Sn7hymdmfyxGxtzze5ppLMGEHEb+0k2Aw607ba3AVGtyjbUDUh6vHpz/BNl+ZF/boc7PZei
 borLcuMVHHkiPCdhIja9Q==
UI-OutboundReport: notjunk:1;M01:P0:XSB0TfHZTVc=;HAhVS/oNgolV6glgUcdY3k+KeEy
 VK0FWjef+AjxTkK537ox5y0yXFUs6x/XBUzO1U0RdzVYez7NZCLaWZ3ukPKaDQa6e5+y/bouQ
 s2wzHESOsjumkC8qPTpgVDi7bZJB6Dxn7Ikk0MuiOzYZFJKOtAbQCqcQPMGQDQhixisNLwBt2
 7LtFxi4T6TNaGUoSzoqpDNCS0TYksMUpev9sbrqS0StsZ8ZS1Mv0xjbq83bJsdzqh4TC+hS4u
 cWn2EBWNXcGHZzCFBuo85zqeKlHY1Jtyp1PNsP3Hu5g0sQSzGuBcgOdgHVvkG0Frv/VCHWOUP
 8BLuFz9uea6DblrgyGeTIAs3fsV8EIqdCw4TVDQ3vdMC9eZS+lVStn23iAOImxRpQ1ufgLPnx
 xWVvVr9QgqA9EB6izRm3qKXSa8BivT5uv3I7uXthHdVuZK/hCXQHqT03OGATGvcu0YC/Hse+6
 eCGKyGph3MiJa2DsXXLknUtbSIcZXuBPEy4nZEcEynxulYLKncMQzldPKvGrl9bRBEQmj1+rj
 v7nbdFXZBHSyPW0UFDw4twEzzNJuEPX+j4jAykuuIfJXX3YSZGa1U82kCzVivqSOGYfyZNYGZ
 TdmwVbyAgAIGacazIa6PGdE/DK2/GMRK4oIAitFGgKUVv0yv8wHRWlGwbhpiXLwMr0pDMUtBp
 4sLv1PKoHJynpl3CX/GCxDhzqGopbl+Ms0H7I1+8TcgeTQkIimxPeOq2Q6X7OBzu5PlWdEPJS
 t8p7Qobm7BkezWuYif9eS4FpEJ8aLRvnONHmfoynge1RgriUc6ilLPzqCei1dOI7ZhlHtLdxD
 xBO/clQzkM/2dfg1XDyVkYDmXIDrN4tVOVNtaRWoV67EKL+GiwxDy8CZbrELwucv2p/qSW2Io
 UmNytZYz1rlr8ulzNe11lqAspao1aqcdDODSd3E2agU5l6+T6EypRzDoOh3gwbscsM/+UhyES
 GDh5RJqxi9/gZMuTklr6NIaPCfg=
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/21/23 00:43, Jens Axboe wrote:
> On 7/20/23 4:38?PM, Helge Deller wrote:
>> On 7/21/23 00:30, Jens Axboe wrote:
>>> On 7/19/23 3:20?PM, Helge Deller wrote:
>>>> The io_uring testcase is broken on IA-64 since commit d808459b2e31
>>>> ("io_uring: Adjust mapping wrt architecture aliasing requirements").
>>>>
>>>> The reason is, that this commit introduced an own architecture
>>>> independend get_unmapped_area() search algorithm which doesn't suite =
the
>>>> memory region requirements for IA-64.
>>>>
>>>> To avoid similar problems in the future it's better to switch back to
>>>> the architecture-provided get_unmapped_area() function and adjust the
>>>> needed input parameters before the call.  Additionally
>>>> io_uring_mmu_get_unmapped_area() will now become easier to understand
>>>> and maintain.
>>>>
>>>> This patch has been tested on physical IA-64 and PA-RISC machines,
>>>> without any failures in the io_uring testcases. On PA-RISC the
>>>> LTP mmmap testcases did not report any regressions either.
>>>>
>>>> I don't expect issues for other architectures, but it would be nice i=
f
>>>> this patch could be tested on other machines too.
>>>
>>> Any comments from the IA64 folks?
>>
>> matoro tested it on ia64 at least...
>>
>>> Helge, should this be split into three patches? One for hppa, one for
>>> ia64, and then the io_uring one?
>>
>> If we split up, I would prefer to split it into 2 patches: One for
>> io_uring together with the hppa patch, since they should go in
>> together.
>
> OK, that makes sense. Want to spin a new version done like that?

Yes.
I'll send it tomorrow.
(now that we know it works on the major platforms)

Helge
