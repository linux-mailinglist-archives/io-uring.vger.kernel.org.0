Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17F3669538E
	for <lists+io-uring@lfdr.de>; Mon, 13 Feb 2023 23:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjBMWFZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Feb 2023 17:05:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBMWFY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Feb 2023 17:05:24 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA33E1F901;
        Mon, 13 Feb 2023 14:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1676325915; bh=FvHQQNWNKL3I3Wa147G/PVZ6g7Gv9AFHPZZy9Xwo7S0=;
        h=X-UI-Sender-Class:Date:To:Cc:References:From:Subject:In-Reply-To;
        b=b5Q8RPlAGpMbXD1yg43dHkL9nwvyTXYl0/VPMS4cnTbJa0Wen6/evj5X/eyAfpnCP
         cHQWb8mBfpdRtMBCh6VQ85W3smU80GSC08UakJryd3SOecyZEJj0IvQ3QLOIVqEkIE
         Sh0W2itYVV13dSkCUczENMTWEMBrtHoSfewvdcK4YNBkgN1VlfCVuhX6yb75YF5KEl
         iepcgnGQjepJNM5RRGRssZ7+Kv8PGciZoQpJ7VnWNuufIuWYRuzqK+QLOL1vCwybbB
         DNUXehqVD6KlDLwGicOUQ3QmSZqoctw/bkze1Vto6R8k6e9r/jeME17bUNOMVEG0D/
         gur0CGjDsA6sg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([92.116.143.195]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MmlT2-1ok4TN0K1O-00jtjG; Mon, 13
 Feb 2023 23:05:15 +0100
Message-ID: <587c828a-6155-f850-63f1-f2e6bc097fda@gmx.de>
Date:   Mon, 13 Feb 2023 23:05:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     John David Anglin <dave.anglin@bell.net>,
        linux-parisc <linux-parisc@vger.kernel.org>
References: <216beccc-8ce7-82a2-80ba-1befa7b3bc91@gmx.de>
 <159bfaee-cba0-7fba-2116-2af1a529603c@kernel.dk>
 <c1581c21-631d-94dd-1c0d-822fb9f19cd1@gmx.de>
 <d7345188-3e58-35e9-2c8f-657f8f813ad5@kernel.dk>
 <4a9a986b-b0f9-8dad-1fc1-a00ea8723914@gmx.de>
 <835f9206-f404-0402-35fe-549d2017ec62@gmx.de>
 <0b1946e4-1678-b442-695e-84443e7f2a86@kernel.dk>
 <ee1e92d5-6117-003a-3313-48d906dafba8@gmx.de>
 <05b6adc3-db63-022e-fdec-6558bdb83972@kernel.dk>
 <c5dcfbf1-bf00-2d2a-dba6-241f316efb92@gmx.de>
 <d37e2b43-f405-fe6f-15c4-7c9b08a093e1@gmx.de>
 <8f21a6bd-c66a-169b-6278-34a66dbcfee7@kernel.dk>
 <721b23a1-91f8-3f98-6448-6b9a70119eba@gmx.de>
 <96a542dc-c3a0-65ec-3bd0-fa1175b9bf87@kernel.dk>
From:   Helge Deller <deller@gmx.de>
Subject: Re: io_uring failure on parisc (32-bit userspace and 64-bit kernel)
In-Reply-To: <96a542dc-c3a0-65ec-3bd0-fa1175b9bf87@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:DE3nJsfE+YfgMB3vPq1ZosmBZDkU3wtLxSHS5TyOVyD6TtS6aiL
 fFbW605MvvinL9hGnUkDT68RiZbA9/6qjUtOJpeQFxSdOdeX9EZQFNndUtwdxF+9QY8tgTH
 xYiIlVab8NNuOmLKEKC/kYQjFF3QlvKso0Q/IAd/WKYnOfATLzr3u273dBJdDSvs3wjFx3L
 y9xXKKQWfqp9dnGKZscdg==
UI-OutboundReport: notjunk:1;M01:P0:fqWGE1+hsT8=;/rDwNN+4FtoEaXcfNrDj7ykrmaP
 z7S58VNs0z+5dRJR2SvqHL4m1LZALnpwccmf5BkDCf/Jd275wTGOqwHu9mOmRrCSIYxED2+Nw
 fmRtlmh2VIrWESpWEiAW6YSC3dP4BWp0n06x1lDrZE7nRhf4Nxf4Az+RuNM/xQA2QWJWUj9Yd
 D6LmpWHoDpRicNeDtPbHhtbjZYEo1lkjKynk1BVZJRabxYDDE3dhelmf/kSkjns52zRQUD3bW
 UO0I0YYbgIbEDFkXc7nttqziSOnFN+6Zj4pUY/8fA05CAGZFg8/5fl5NFucwNtTiMUI/YIM2F
 gasYrV2HKKEDZvge3gXx9d3FK67gC02W4iLDAlwWSbYk+tu1I5FfWz7njHP6bwzG41NU85CRN
 4ww3wQSsZpYNNNBmcVSQFD0N5YtZEcz0WT84W52ZmvKOjcf1a7tHmDdJ5hCOO5vhvpTT1qtdk
 /2kM9mRcB4zcjsXzlFzFfGsg3Q0eStU5URR7KS1su5UJKlEmeplRp24yUiRGBVYFd8/qI8ELM
 4xf9uS4fLukf1H68e+zKLJ6xCq4+c2pGe7Ga9WgQ4vbXnjEQ3Ej4OTUNLFeyUZPuobj2WeV70
 HVa9yKwBeM9AgaUdoZbZh+EgDYzKAWQlbzHeTCFvTjno8Ks77/PSvpsWyq9F3A+iJHwS8SuJq
 Eez0rMsTh8M7xkBEimpdQAmjtdhy+md5IGAG+hasB96jb7oOmQLGhEKSJL/QH8X9dBomewuxQ
 3tjTHST3IAZcbONmO2UxRMZ/+5WMzCZsCo+l5HI0cnltRJYOmtbCy/p6EMP8ncq1qXZz8ssIF
 GiyMst2eiLs8TMN33/M/b9S2VRhpX+FKieei03VVJf929gq3C0u9PSApSvAIDAkjLgEc+hiUB
 Oo1bMtjTV49lccMRs/N3DMlADAvZsG5x2moraSfWUEngc/fBd+YVYHePB0po7K45vja9KHr41
 tG0PAQ==
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/13/23 22:05, Jens Axboe wrote:
> On 2/13/23 1:59?PM, Helge Deller wrote:
>>> Yep sounds like it. What's the caching architecture of parisc?
>>
>> parisc is Virtually Indexed, Physically Tagged (VIPT).
>
> That's what I assumed, so virtual aliasing is what we're dealing with
> here.
>
>> Thanks for the patch!
>> Sadly it doesn't fix the problem, as the kernel still sees
>> ctx->rings->sq.tail as being 0.
>> Interestingly it worked once (not reproduceable) directly after bootup,
>> which indicates that we at least look at the right address from kernel =
side.
>>
>> So, still needs more debugging/testing.
>
> It's not like this is untested stuff, so yeah it'll generally be
> correct, it just seems that parisc is a bit odd in that the virtual
> aliasing occurs between the kernel and userspace addresses too. At least
> that's what it seems like.

True.

> But I wonder if what needs flushing is the user side, not the kernel
> side? Either that, or my patch is not flushing the right thing on the
> kernel side.
>
> Is it possible to flush it from the userspace side? Presumable that's
> what we'd need on the sqe side, and then the kernel side for the cqe
> filling. So probably the patch is half-way correct :-)

I hacked up in __io_uring_flush_sq() in liburing/src/queue.c this code
(which I hope is correct):
                 if (!(ring->flags & IORING_SETUP_SQPOLL))
                         IO_URING_WRITE_ONCE(*sq->ktail, tail);
                 else
                         io_uring_smp_store_release(sq->ktail, tail);
         } /* ADDED: */
         { int i;  unsigned long p =3D (unsigned long)sq->ktail & ~(4096-1=
);
           fprintf(stderr, "FLUSH CACHE OF PAGE %lx\n", p);
           for (i=3D0; i < 4096; i +=3D 8)
                 asm volatile("fdc 0(%0)" : : "r" (p+i));
         }

The kernel sometimes sees the tail value now (it fails afterwards, but tha=
t's ok for now).
But I'm not sure yet if this is really the effect of the fdc (flush data c=
ache instruction),
or pure luck because the aliasing of the userspace address and kernel addr=
ess matches in
a sucessful run.
For me it seems as it's the aliasing which makes it work sometimes.

In this regard I wonder why we don't provide the cacheflush syscall on par=
isc....

Helge
