Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 918766BBDC4
	for <lists+io-uring@lfdr.de>; Wed, 15 Mar 2023 21:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbjCOUHp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Mar 2023 16:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232916AbjCOUHn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Mar 2023 16:07:43 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD39C62860;
        Wed, 15 Mar 2023 13:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1678910859; i=deller@gmx.de;
        bh=GWOjALxUs5xbHgtwa/uqgPgJ2Y//Nh1FvMv2pyJyH1Y=;
        h=X-UI-Sender-Class:Date:Subject:From:To:References:In-Reply-To;
        b=qug4Ml7kOP+tPl65AYKIo57NqWluei2TP81GrfK+dJIGfvHdAop+zc3iksBLCCtxX
         i2b46EWtqB+i00f7n5p5v2N6K+op32NBgNxOBGohkhSIbcSX/eVQjOajtdh1lHxtLk
         jQIL28jlvR6EgXlbX8faQeZT9M/uf3ZI/moa5B6VsdiCpzIJ0mv/s8M8J0ZEg5/4Gt
         xL0dNTXezRz1tPVqwcnNp/GWldFeeTJ9/yxNiaxlefZObcDKKUvn2lM0Sc2gxLHd93
         djCQTgw1CY1clAa5xNlCgOKrHJCRF+Nouo+pvUlre4aI+LCdinx1kK4q2Wwxfvf2uO
         MoYp2vcKmoXSg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([94.134.153.118]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M3DJv-1pg7F80YIf-003ZtV; Wed, 15
 Mar 2023 21:07:39 +0100
Message-ID: <3dcf3e0c-d393-cb95-86ab-00b4d8cf3c75@gmx.de>
Date:   Wed, 15 Mar 2023 21:07:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCHSET 0/5] User mapped provided buffer rings
Content-Language: en-US
From:   Helge Deller <deller@gmx.de>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-parisc <linux-parisc@vger.kernel.org>
References: <20230314171641.10542-1-axboe@kernel.dk>
 <0eeed691-9ea1-9516-c403-5ba22554f8e7@gmx.de>
In-Reply-To: <0eeed691-9ea1-9516-c403-5ba22554f8e7@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:kcx1w+KZhs9zgHCPgJunIAE6+xP4+XOwx+5qnetZ5meBbQdOxI3
 NZgsTFA6IE9sE6kAlFI/4/bB8Mfdafql8OwEBgxT2drZXHVXaPKm9zRFjyFzMW+K/MEqGAY
 Wd2Do99rcOT2x6julhbj6q1QrV2wG20aZ2kyAbzQwvF8UdwxXDV0CmghkJ24SblE/ozf+Da
 mQlp+WTxx4GjR41NP9PEQ==
UI-OutboundReport: notjunk:1;M01:P0:wq+buM5C7q8=;uaUFAnLriwrLDwoRFoSkfYvGiF6
 qpizYH1P3JFAjfG7FCLeTHePXoVfk/9Lr5EscUjWSjC3aAF5folEHDI181qLTx/sBpch2GIfQ
 TV3Xxo/xY3WUZnfqOrOTNOeHrbXA3XgeIa2SJHrXtH5GUP6a5kHf45rfb8OI22w9W23BhxR4P
 WUA5pY61n2RThyvEJFbHFc+gnD1VUA9438EgYS/7YEfMdu4SeF7mdpon9MFyY79p+QPGSDB31
 00uV6N3AcXGaz9uvGb0NfbcXUX502BKuncbtu0BvOCtNUy9qwZi73aDT3j3SQAGzj09iWxSt9
 LhARprQx4gWfZJOrmrT6xGm5cFgRDtjRraAgv623MJurCxCAPiOAEcPi3B2jUFrsw3oHexCSL
 NOYaePbTT5N5bQYoERAieK0ocZsMUIYhJn3UlMXcKFGFkgUUy+GqAUgwirjGIiv85lgKZbqBk
 ENvgpc4H1RebCJVIa5kRpzK9MaOB+7GMpSl41Kl+q8YwNcgzJR3uPLQpn0ufCDlRWK/Ke2x3t
 jckL/QHj0cwKIhB4TJgOfdcTJ3B56YJ3NxTqKOBMlL2m4FBy35Z4qeO5KTGl+oM7aGPWxmRx6
 TFs96W9fNC6OLfXb07fYvYA6vCFYL1TtB2A159vOyNmrxkINlg0mv/kG6h5ygGgsbGz2Z3Cq2
 9EXq2jSl7VEENKlF+2tJ17LjDmX0GUh6NRIINiPwbI29p9hBp4I0VZR5B9rGTwJLDrac9zTP4
 PqajBBcMxwrF4cpU6tm9rmyKrqgjJNvDYU8ZdXNCGDuoZA+KnvLEij3/FtWnVqgst2MUqfyl3
 BPwX3beYifRt6Bgxi7ou8m+d6H9uM76zzFlzbfqKGT3GRP39qO29/9VfkXrFWWLTv2ueq9G5I
 EpPFLwld5tRmVavgSc0pCDN7pvJviIK/6YtUdp0oO6TxOCrtB3mRiGDm7dvAodtyDi7CHteYL
 wV/KMamjsMbNSSlb3IU7g2XPZR0=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/15/23 21:03, Helge Deller wrote:
> Hi Jens,
>
> Thanks for doing those fixes!
>
> On 3/14/23 18:16, Jens Axboe wrote:
>> One issue that became apparent when running io_uring code on parisc is
>> that for data shared between the application and the kernel, we must
>> ensure that it's placed correctly to avoid aliasing issues that render
>> it useless.
>>
>> The first patch in this series is from Helge, and ensures that the
>> SQ/CQ rings are mapped appropriately. This makes io_uring actually work
>> there.
>>
>> Patches 2..4 are prep patches for patch 5, which adds a variant of
>> ring mapped provided buffers that have the kernel allocate the memory
>> for them and the application mmap() it. This brings these mapped
>> buffers in line with how the SQ/CQ rings are managed too.
>>
>> I'm not fully sure if this ONLY impacts archs that set SHM_COLOUR,
>> of which there is only parisc, or if SHMLBA setting archs (of which
>> there are others) are impact to any degree as well...
>
> It would be interesting to find out. I'd assume that other arches,
> e.g. sparc, might have similiar issues.
> Have you tested your patches on other arches as well?

By the way, I've now tested this series on current git head on an
older parisc box (with PA8700 / PCX-W2 CPU).

Results of liburing testsuite:
Tests timed out (1): <send-zerocopy.t> - (may not be a failure)
Tests failed (5): <buf-ring.t> <file-verify.t> <poll-race-mshot.t> <ringbu=
f-read.t> <send_recvmsg.t>

Helge
