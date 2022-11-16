Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF78662C97D
	for <lists+io-uring@lfdr.de>; Wed, 16 Nov 2022 21:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiKPUDy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Nov 2022 15:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238503AbiKPUD1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Nov 2022 15:03:27 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A69ABD6;
        Wed, 16 Nov 2022 12:03:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=YigzlxxeJjxXIbL/TgXgAM5VzyMGwLAab2ukVyPPzhM=; b=PrXf1Flye6WZoQud15lA/kOMVw
        smxOr1ZkohIfIVZwLTVKFVEqkhZe1+jLW4HNiR+oLyJpw7XQ3F6BoWlgj+r2hZg7O5rXlhPvEDu0B
        eMTnJ0JdUvvZjGrCV19PIqM5Kud4Vyn0gjcBjfP0zavV53Cx/OFVSxJvxxsJP+73soP0QIS5rF82w
        SDaxwyFpT7fTeN1VrDOGYbmEzIIGm7ttFsIVzTPZD3s+UgEwD8BW8OSlohXtwXUG1nmH5HTdoaBz1
        wXZLTZ6th16Q1NLmDIFALb8zUTDIlcFVxp95TzGnbnXkQ+1lQG1+1839PXLKYl4ksdrRdZrSRdmg5
        tT5bo4UForV42qV004cG9R0OX9WXikdjQv/qla8HzUW0DThjxFb2AWgkvD9pHSzyvKm+o7RZhVacs
        9N19+Ws8gTznagiP4eP9PRtxn5d5dNACJ6Wp1JXMAZGOt+zA9ksEIrGkDKrUo4GAIO6shbk3Wsuzj
        mEeASCbjo8kbyEfZSdrL8B4X;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1ovOd0-008wht-Nm; Wed, 16 Nov 2022 20:03:22 +0000
Message-ID: <b57ad090-c84d-d650-d847-cd7fdda5e951@samba.org>
Date:   Wed, 16 Nov 2022 21:03:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: (subset) [PATCH v1 0/2] io_uring uapi updates
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <20221115212614.1308132-1-ammar.faizi@intel.com>
 <166855408973.7702.1716032255757220554.b4-ty@kernel.dk>
 <61293423-8541-cb8b-32b4-9a4decb3544f@gnuweeb.org>
 <fe9b695d-7d64-9894-b142-2228f4ba7ae5@kernel.dk>
 <69d39e98-71fb-c765-e8b9-b02933c524a9@samba.org>
 <b46b01a1-ed6e-6824-9b4b-c6af82bb60f0@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <b46b01a1-ed6e-6824-9b4b-c6af82bb60f0@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 16.11.22 um 20:46 schrieb Jens Axboe:
> On 11/16/22 7:22 AM, Stefan Metzmacher wrote:
>> Am 16.11.22 um 14:50 schrieb Jens Axboe:
>>> On 11/15/22 11:34 PM, Ammar Faizi wrote:
>>>> On 11/16/22 6:14 AM, Jens Axboe wrote:
>>>>> On Wed, 16 Nov 2022 04:29:51 +0700, Ammar Faizi wrote:
>>>>>> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>>>>>>
>>>>>> Hi Jens,
>>>>>>
>>>>>> io_uring uapi updates:
>>>>>>
>>>>>> 1) Don't force linux/time_types.h for userspace. Linux's io_uring.h is
>>>>>> ???? synced 1:1 into liburing's io_uring.h. liburing has a configure
>>>>>> ???? check to detect the need for linux/time_types.h (Stefan).
>>>>>>
>>>>>> [...]
>>>>>
>>>>> Applied, thanks!
>>>>>
>>>>> [1/2] io_uring: uapi: Don't force linux/time_types.h for userspace
>>>>> ??????? commit: 958bfdd734b6074ba88ee3abc69d0053e26b7b9c
>>>>
>>>> Jens, please drop this commit. It breaks the build:
>>>
>>> Dropped - please actually build your patches, or make it clear that
>>> they were not built at all. None of these 2 patches were any good.
>>
>> Is it tools/testing/selftests/net/io_uring_zerocopy_tx.c that doesn't build?
> 
> Honestly not sure, but saw a few reports come in. Here's the one from
> linux-next:
> 
> https://lore.kernel.org/all/20221116123556.79a7bbd8@canb.auug.org.au/

Yes, but the output is pretty useless as it doesn't show what
.c file and what command is failing.

>> and needs a '#define HAVE_LINUX_TIME_TYPES_H 1'

Just guessing, but adding this into the commit has a chance to work...

--- a/tools/testing/selftests/net/io_uring_zerocopy_tx.c
+++ b/tools/testing/selftests/net/io_uring_zerocopy_tx.c
@@ -15,6 +15,7 @@
  #include <arpa/inet.h>
  #include <linux/errqueue.h>
  #include <linux/if_packet.h>
+#define HAVE_LINUX_TIME_TYPES_H 1
  #include <linux/io_uring.h>
  #include <linux/ipv6.h>
  #include <linux/socket.h>

>> BTW, the original commit I posted was here:
>> https://lore.kernel.org/io-uring/c7782923deeb4016f2ac2334bc558921e8d91a67.1666605446.git.metze@samba.org/
>>
>> What's the magic to compile tools/testing/selftests/net/io_uring_zerocopy_tx.c ?
> 
> Some variant of make kselftests-foo?
> 
>> My naive tries both fail (even without my patch):
> 
> Mine does too, in various other tests. Stephen?

Pavel, as you created that file, do you remember how you build it?

metze

