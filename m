Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECEEA772EBD
	for <lists+io-uring@lfdr.de>; Mon,  7 Aug 2023 21:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjHGTeA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Aug 2023 15:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjHGTd7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Aug 2023 15:33:59 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E6A1717;
        Mon,  7 Aug 2023 12:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de;
 s=s31663417; t=1691436830; x=1692041630; i=deller@gmx.de;
 bh=fwhgox9M7yLe834P8oP6raswlbzuzvK7JV5fojo4xBQ=;
 h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
 b=bjGY8+6agVlc2AubHOu3JpWuNTH00zzTpATGRBL3lgzxqAepHvCm8Z7yyXydGvjDTJ3I7N9
 eXLh9db2OhyjiAzue38oVG+6LdnqRyKTLsGG1wgvNtHes4dULGdgKDjUhrGpunTQHVG2hZsJS
 qNNdaSWMrS3xPfCQNdcyO8h2iMX/8crrXtFsPnQZM8Q604yyadR5Xd5YlvREIa2Jd2ZBAotwH
 wqPRFBzl274WNU0DUm2n4ybaI061at/u/F08IozturqfCewPlLGaAThY0CUKr8Z/6BHoUs+bz
 foOO7KaM/aMH7LwQ02I6l4MH8O30vwSJbZCgXt1VtymxvWKWhX8Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([94.134.150.52]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M4s0j-1qUSlN13jT-001zKv; Mon, 07
 Aug 2023 21:33:50 +0200
Message-ID: <1eb94cc3-1286-4e30-f891-a6b6dfa11ba9@gmx.de>
Date:   Mon, 7 Aug 2023 21:33:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] io_uring/parisc: Adjust pgoff in io_uring mmap() for
 parisc
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>,
        linux-parisc@vger.kernel.org, io-uring@vger.kernel.org
Cc:     Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>
References: <ZMle513nIspxquF5@mail.manchmal.in-ulm.de>
 <ZMooZAKcm8OtKIfx@kernel.org> <1691003952@msgid.manchmal.in-ulm.de>
 <1691349294@msgid.manchmal.in-ulm.de>
 <f361955c-bcea-a424-b3d5-927910ab5f1d@gmx.de>
 <b9a15934-ea29-ef54-a272-671859d2bc02@gmx.de> <ZNEyGV0jyI8kOOfz@p100>
 <169143328422.48417.10714588491936026372.b4-ty@kernel.dk>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <169143328422.48417.10714588491936026372.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:j58OK2ecLfR4e2eD/YtSRxbdhT1jAdXVPTQq9MhF5qtz9y8tNuM
 Hk/5qG6u0haBgjJDIva97pdZb2YwPyN5fuG9L/UM+QxlraV5U+dSxmo7imN7R9+HWFErMeI
 dl+S7KgIxYSx1q9jQAQwX1wUkdvtgQ0u679GwfT54k4FW/x0ti/z9VETY4pzI77zexx/wWo
 +zhIZGnuOGE5z6Jjhyqew==
UI-OutboundReport: notjunk:1;M01:P0:ggksDTgw9I4=;4uCVBgPoecewCIfzHWpsqbjMdSR
 kiFwv495MC4P9pkFtzGltFgii+EwjHGiCWjZ40ASFLZlBFBaCh5Tta6TRk7REv6PclqlY8cCy
 e4H6P2VCFwxHwLoQK63vKQx4cdR5mfBV/HitKLls6CDBembA2Py0rOmTfoxFXEzCWrGkBuvIZ
 dRCJN5VQUtoy5pTPZF3DroDBOgAg/HH5F8m/5pX7dTW9Jd8XzHokiXWoXolsr8vyr0FOQB//w
 Bfgw4XaO8j8nBc3/PVAjjyBVgBvjKdCwzMqE+6baTCuy7vp+3ADE0giYK0zF8iqmVaz+PJ7I3
 X6ecsU7QEDFPgCzozljcZlJ9uwCqM5L/Qn+eGXrKE0H2dkDS8d3ztVkavDvwuGdmOiN9299P8
 cbjYZqktmO4CerUNeQTxHhjs/NGgSR4ku7fVVyurakVgswyqVUz6NpN+Sjx9id82ED+ljoc3h
 BRiQiOfg9em6pEbhcP2qAs6wLys376OPIEsRUYFa3tXN7HVtu+ObW8o0k3ZuS7NtogCSsbGIi
 uFBFOYdt/mWIu0kzBbluopgoWHqo8S++MRWC1Wh9s27u1tfSku3XpZqPZ8WjgZL6R3Ryjz7dr
 fBLRMpBUA1Lfgdp4OrYhnNY7N7ojXCa1V2LDeuYy283nt8kbNT9Q+0LwKnS2amstJACLiQY+G
 8cR5R3t3R8l5fqhKHSVa9QTsz+TN97vEPDJPopTXIr5GUJRSZSmb/XYYH6pvjwdIzLqld1WB3
 SMFhOmqsMvZw+V1PPUaTJOjg2l4miXUZaDAVs322/KzEXv3/XFVbs9aEmh14LOmmB0hKNdC5v
 /B85vwSp1xx9UD5ds/+eVuIgB3dgnOXXK/+T9E7Ytq5cngEKtfHl+QY9iBx3E7E5jfxcaoZgU
 hn7JNKGQ43hrZvqOUPJcfb77eQ0hyomX2b72UCf9gxFOR2PVAXg8E8m9ajDOmb/9aktLZ9V+w
 S8XU4TufmHX35XH784eyzZQjb6M=
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/7/23 20:34, Jens Axboe wrote:
>
> On Mon, 07 Aug 2023 20:04:09 +0200, Helge Deller wrote:
>> The changes from commit 32832a407a71 ("io_uring: Fix io_uring mmap() by
>> using architecture-provided get_unmapped_area()") to the parisc
>> implementation of get_unmapped_area() broke glibc's locale-gen
>> executable when running on parisc.
>>
>> This patch reverts those architecture-specific changes, and instead
>> adjusts in io_uring_mmu_get_unmapped_area() the pgoff offset which is
>> then given to parisc's get_unmapped_area() function.  This is much
>> cleaner than the previous approach, and we still will get a coherent
>> addresss.
>>
>> [...]
>
> Applied, thanks!

That was fast :-)
Actually I had hoped for some more testing from Christoph and other
parisc guys first.
Anyway, since you have a parisc machine in your test ring, you will
notice if something breaks,

What's important:
Please add to the patch:
Cc: stable@vger.kernel.org # 6.4

Thank you!
Helge

> [1/1] io_uring/parisc: Adjust pgoff in io_uring mmap() for parisc
>        commit: ce11a0688e67aae1e9ba6c8843d7e8b7dd791ead

