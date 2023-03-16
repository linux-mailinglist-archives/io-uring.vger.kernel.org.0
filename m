Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85CB36BCC55
	for <lists+io-uring@lfdr.de>; Thu, 16 Mar 2023 11:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjCPKSZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Mar 2023 06:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbjCPKSY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Mar 2023 06:18:24 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08F826851;
        Thu, 16 Mar 2023 03:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1678961896; i=deller@gmx.de;
        bh=SBXPKDzuZZfFGMrYb3LjDl1gDF+p48WKKOIO5JV2inQ=;
        h=X-UI-Sender-Class:Date:Subject:To:References:From:In-Reply-To;
        b=drTKG8Y6nqNsTXcHxQiVL60HROzUKsbMQfQf2pbh0R7CKAqRqEOePWpQqTC1QnzmX
         40JNzbSdCMdCAsKMDerHPZAAYOuW5o6FeThg4qjOKF2NAwvMb1/BNBiQMTsbAlHYiO
         3yVfs60TqHBtOVGWQJ+ornrFkBAFFkkkuU3CWaOnVieKttPBau1bqBN4muSaEi0emZ
         XJtk9WA4BI1oRS215jV+xxdy+QZ+uj/mNpJxEdCc7WcTmbQf1lfX6hjQwmjC2U6hfX
         Fux6TbH3f3mCQqfD49i8kJo98tiBnW83F9D/uS34mu8buzMowJp+yPXuHDu740+Jt4
         669SkT9jOI57g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([94.134.149.95]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MqaxO-1qGC6K1X0q-00maBw; Thu, 16
 Mar 2023 11:18:16 +0100
Message-ID: <619c16b8-1844-0287-40ee-7efaeea36b09@gmx.de>
Date:   Thu, 16 Mar 2023 11:18:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCHSET 0/5] User mapped provided buffer rings
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-parisc <linux-parisc@vger.kernel.org>
References: <20230314171641.10542-1-axboe@kernel.dk>
 <0eeed691-9ea1-9516-c403-5ba22554f8e7@gmx.de>
 <3dcf3e0c-d393-cb95-86ab-00b4d8cf3c75@gmx.de>
 <88b273f6-a747-7d2e-7981-3d224fdac7be@kernel.dk>
 <41a23244-a77a-01c4-46de-76b85a6f4d63@kernel.dk>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <41a23244-a77a-01c4-46de-76b85a6f4d63@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:kNtsjd4d1PkWkuUidycw18kPmgmHsvFcD31lWM/ondOXAKohZjQ
 LgJDgdnyGFSYaVYC0kPmH7eJH+2v0WghrOaA8d4kJtMiEg1TfeTPEutLm4gsVgRkOWafbs1
 iC/gNIjbS+A/VATZl/AnApalyvxzzQAh1vj4NuecZAIkR9wbPKjI4A9HZ8q/xFL8HO9UfSf
 5Niyeg3hu7fgXJR6kgo7Q==
UI-OutboundReport: notjunk:1;M01:P0:wPJRajn5y00=;S9IKB2qyeQVWYuGi9H8e3Rql0sf
 oKz3AWelpXkArRDzVRNxYiwmVLz1HMojjl4c52XMnJn1LIdrBcv02T2312LnMA16obaoe8TOM
 EfClLswesIFA2txaErmhnp0rDLHSZxhCMCLzWmG8eOmpxDJacbiB0OOqEMiD9L/ezB8vQhmU2
 1Iz2P+iPH9YuktJTVF7d7bs0Q7Zl92XC0+4qSWfycIWXIV2u7g3RSTo35C1aIbUP4QhGAyLd9
 7yvxbMNK95H9nPbYtd2nBqee46DWGeIqJ1H9M6xArEpUa/Erxb5tSxUIiZ3LkzvlR0u8YDNjW
 96QePY+sidSMCuQ2U/pbDuEeyim2tQ+ZySk4VwmEWeIcpVt/99j0bWkMhD81Wql6OqfBBTKcf
 DPhd6takSvJRw6PE78QrXHzGajNRlkZwf5X7vh0K4Jm9zBEVrPGfrtS/wBQbiciUq7YGA4BsU
 BbfKeDQbrPH1LLBN997xqFJkhY5ycOO/a3yTF3HWBqpL86+Shk6sREHDPsgAY8DwBH703nW0c
 KGOJOX3VVqaEEksdL2R52K/TL/lOPTLgGUJqzL0f/3jCsXzR7swBacXQFp74bt9EUByQ/X0vf
 AA4QQv0wm/IVSOMZyFeevwzM1GQdq+bRjzHTyrqRaVLmwbMAMmaup1LjxWQahKG9HpiE4Gl5R
 Fmhhv1sWy7sYived88ghHHJazDnIGMCDLzmeY+L10PVEXJYO9j3188inXPzhblZHxzeNOpiln
 sC88Yvx9fefXaVSjmR6PlPiFNq42wLj3YNBBjoeKijMmFkKeHqvvGB1Un0ELXTE1NiWwP52TM
 CZq/ksB2Lohw48wmGOUx6ZUB+FHlQMn30AaCuL3QVp/pgkQzOhcB9mkiWlKKF17608Fqem9mM
 ErnKoLlYBBVkEvtKVXxG5xkDqi7+JYjUp8EZi3UfmiF11VzQs0Li0mqQD61nTY/TbCUCB+gQf
 tzLl8fKdtPO/s1cujP6ev8AdVZ0=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/15/23 22:18, Jens Axboe wrote:
> On 3/15/23 2:38=E2=80=AFPM, Jens Axboe wrote:
>> On 3/15/23 2:07?PM, Helge Deller wrote:
>>> On 3/15/23 21:03, Helge Deller wrote:
>>>> Hi Jens,
>>>>
>>>> Thanks for doing those fixes!
>>>>
>>>> On 3/14/23 18:16, Jens Axboe wrote:
>>>>> One issue that became apparent when running io_uring code on parisc =
is
>>>>> that for data shared between the application and the kernel, we must
>>>>> ensure that it's placed correctly to avoid aliasing issues that rend=
er
>>>>> it useless.
>>>>>
>>>>> The first patch in this series is from Helge, and ensures that the
>>>>> SQ/CQ rings are mapped appropriately. This makes io_uring actually w=
ork
>>>>> there.
>>>>>
>>>>> Patches 2..4 are prep patches for patch 5, which adds a variant of
>>>>> ring mapped provided buffers that have the kernel allocate the memor=
y
>>>>> for them and the application mmap() it. This brings these mapped
>>>>> buffers in line with how the SQ/CQ rings are managed too.
>>>>>
>>>>> I'm not fully sure if this ONLY impacts archs that set SHM_COLOUR,
>>>>> of which there is only parisc, or if SHMLBA setting archs (of which
>>>>> there are others) are impact to any degree as well...
>>>>
>>>> It would be interesting to find out. I'd assume that other arches,
>>>> e.g. sparc, might have similiar issues.
>>>> Have you tested your patches on other arches as well?
>>>
>>> By the way, I've now tested this series on current git head on an
>>> older parisc box (with PA8700 / PCX-W2 CPU).
>>>
>>> Results of liburing testsuite:
>>> Tests timed out (1): <send-zerocopy.t> - (may not be a failure)
>>> Tests failed (5): <buf-ring.t> <file-verify.t> <poll-race-mshot.t> <ri=
ngbuf-read.t> <send_recvmsg.t>
>
> If you update your liburing git copy, switch to the ring-buf-alloc branc=
h,
> then all of the above should work:
>
> axboe@c8000 ~/g/liburing (ring-buf-alloc)> test/buf-ring.t
> axboe@c8000 ~/g/liburing (ring-buf-alloc)> test/send_recvmsg.t
> axboe@c8000 ~/g/liburing (ring-buf-alloc)> test/ringbuf-read.t
> axboe@c8000 ~/g/liburing (ring-buf-alloc)> test/poll-race-mshot.t
> axboe@c8000 ~/g/liburing (ring-buf-alloc)> git describe
> liburing-2.3-245-g8534193

Yes, verified. All tests in that branch pass now.

Thanks!
Helge
