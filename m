Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E16D62CAE3
	for <lists+io-uring@lfdr.de>; Wed, 16 Nov 2022 21:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbiKPUcs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Nov 2022 15:32:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbiKPUcr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Nov 2022 15:32:47 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E395C2126B;
        Wed, 16 Nov 2022 12:32:45 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id fn7-20020a05600c688700b003b4fb113b86so2379690wmb.0;
        Wed, 16 Nov 2022 12:32:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ql6gbryNV6i+XAhsM2xarVLT5+wQUPTj9o9nHmrg+nY=;
        b=le2Nk+1YX0V3rbtkeWSMh+Tb4D8AeX7uVpJxfN3brmkxEg+L1kKg+Sw//N2ca6COt5
         q3VKfjF0Fll2OdKSo4fVkpdQ/frOckQyuZR0Zy+v4AGTzkr+z1nLAOP7orqfZiwZ4zZf
         iqFUF0VSsg9fG1CfSvLv5sEemyG8Lkw1uhmfezdeZZE8KUM1qjIIoIkoeXEOFt0dfn4e
         LQcrw3rh2NlwvMMiT+3J1NjVMm5sV8YLpPC5BJef8j/YgK7V6n1Wc9RcuhY1C8luYxJp
         vmHKfDCaRhLluJu+S5E2D9lfcmkRy5gTqukTR5YBgwkWaYUl9yuAE6qihj1K3wH4uJo1
         1Qag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ql6gbryNV6i+XAhsM2xarVLT5+wQUPTj9o9nHmrg+nY=;
        b=J9VscXy3kVhqmwQA1OQgPQRKBXYZJ9SxwOD/i88/z5MzKJVG2EN4bLhGLhQ21U5WVC
         5DjMdx2UP/Cl/fYtMS+0LmUuZTO7awpTX6eltJCxk+b2aPAYL8I2T5irEOsOsEzz+AHl
         JQDmcbAlgKdVTdqCXe0hoW/QOmrAV3YhoUV+yXjylPdIADeVuI1wQhkGGJwJ1FEZctKw
         /syNqfigHjrDNHpmv7WGC1gWu6ULLnRzG9twSsBblO1VlGX+XQZPgRMofLjL/kVqLffT
         YfgkQ+wT1I51NJ96DEiNrYp0u8VRvJejsD6QPqZ+RVy1EuPEgNk1gHuqy1kFzvW6hszy
         SOdg==
X-Gm-Message-State: ANoB5pnHHOuKQYudNvelG5mGZZgkjzhf9zdgXVuXciVKjZRS7aymohvi
        /L2evdSCs5DJJzTvPwYUYBrDHxXcUhc=
X-Google-Smtp-Source: AA0mqf7GoI/Zfiv9uvNENFG8wBBY2Nofa+SH0Dyyn6XyuUnUMgsJYqt4myTwIPtTcsnMn0h1Wsk9KA==
X-Received: by 2002:a05:600c:35c7:b0:3cf:7dc1:f432 with SMTP id r7-20020a05600c35c700b003cf7dc1f432mr3176438wmq.148.1668630764380;
        Wed, 16 Nov 2022 12:32:44 -0800 (PST)
Received: from [192.168.8.100] (188.28.224.148.threembb.co.uk. [188.28.224.148])
        by smtp.gmail.com with ESMTPSA id j7-20020adfb307000000b0023c8026841csm16096891wrd.23.2022.11.16.12.32.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 12:32:44 -0800 (PST)
Message-ID: <2ca5622b-88e6-4271-0986-9c9a07bc0148@gmail.com>
Date:   Wed, 16 Nov 2022 20:31:32 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: (subset) [PATCH v1 0/2] io_uring uapi updates
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <20221115212614.1308132-1-ammar.faizi@intel.com>
 <166855408973.7702.1716032255757220554.b4-ty@kernel.dk>
 <61293423-8541-cb8b-32b4-9a4decb3544f@gnuweeb.org>
 <fe9b695d-7d64-9894-b142-2228f4ba7ae5@kernel.dk>
 <69d39e98-71fb-c765-e8b9-b02933c524a9@samba.org>
 <b46b01a1-ed6e-6824-9b4b-c6af82bb60f0@kernel.dk>
 <b57ad090-c84d-d650-d847-cd7fdda5e951@samba.org>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b57ad090-c84d-d650-d847-cd7fdda5e951@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/16/22 20:03, Stefan Metzmacher wrote:
> Am 16.11.22 um 20:46 schrieb Jens Axboe:
>> On 11/16/22 7:22 AM, Stefan Metzmacher wrote:
>>> Am 16.11.22 um 14:50 schrieb Jens Axboe:
>>>> On 11/15/22 11:34 PM, Ammar Faizi wrote:
>>>>> On 11/16/22 6:14 AM, Jens Axboe wrote:
>>>>>> On Wed, 16 Nov 2022 04:29:51 +0700, Ammar Faizi wrote:
>>>>>>> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>>>>>>>
>>>>>>> Hi Jens,
>>>>>>>
>>>>>>> io_uring uapi updates:
>>>>>>>
>>>>>>> 1) Don't force linux/time_types.h for userspace. Linux's io_uring.h is
>>>>>>> ???? synced 1:1 into liburing's io_uring.h. liburing has a configure
>>>>>>> ???? check to detect the need for linux/time_types.h (Stefan).
>>>>>>>
>>>>>>> [...]
>>>>>>
>>>>>> Applied, thanks!
>>>>>>
>>>>>> [1/2] io_uring: uapi: Don't force linux/time_types.h for userspace
>>>>>> ??????? commit: 958bfdd734b6074ba88ee3abc69d0053e26b7b9c
>>>>>
>>>>> Jens, please drop this commit. It breaks the build:
>>>>
>>>> Dropped - please actually build your patches, or make it clear that
>>>> they were not built at all. None of these 2 patches were any good.
>>>
>>> Is it tools/testing/selftests/net/io_uring_zerocopy_tx.c that doesn't build?
>>
>> Honestly not sure, but saw a few reports come in. Here's the one from
>> linux-next:
>>
>> https://lore.kernel.org/all/20221116123556.79a7bbd8@canb.auug.org.au/
> 
> Yes, but the output is pretty useless as it doesn't show what
> .c file and what command is failing.
> 
>>> and needs a '#define HAVE_LINUX_TIME_TYPES_H 1'
> 
> Just guessing, but adding this into the commit has a chance to work...
> 
> --- a/tools/testing/selftests/net/io_uring_zerocopy_tx.c
> +++ b/tools/testing/selftests/net/io_uring_zerocopy_tx.c
> @@ -15,6 +15,7 @@
>   #include <arpa/inet.h>
>   #include <linux/errqueue.h>
>   #include <linux/if_packet.h>
> +#define HAVE_LINUX_TIME_TYPES_H 1
>   #include <linux/io_uring.h>
>   #include <linux/ipv6.h>
>   #include <linux/socket.h>
> 
>>> BTW, the original commit I posted was here:
>>> https://lore.kernel.org/io-uring/c7782923deeb4016f2ac2334bc558921e8d91a67.1666605446.git.metze@samba.org/
>>>
>>> What's the magic to compile tools/testing/selftests/net/io_uring_zerocopy_tx.c ?
>>
>> Some variant of make kselftests-foo?
>>
>>> My naive tries both fail (even without my patch):
>>
>> Mine does too, in various other tests. Stephen?
> 
> Pavel, as you created that file, do you remember how you build it?

make headers_install
make -C tools/testing/selftests/net/


IIRC, it uses system uapi headers and apparently yours don't have
IORING_CQE_F_NOTIF, etc. And I don't think it uses the right Makefile,
so -C executes it from the selftest/net folder.

-- 
Pavel Begunkov
