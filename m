Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16F81698092
	for <lists+io-uring@lfdr.de>; Wed, 15 Feb 2023 17:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjBOQSS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Feb 2023 11:18:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjBOQSR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Feb 2023 11:18:17 -0500
Received: from cmx-mtlrgo002.bell.net (mta-mtl-003.bell.net [209.71.208.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E2F2BEF5;
        Wed, 15 Feb 2023 08:18:16 -0800 (PST)
X-RG-CM-BuS: 0
X-RG-CM-SC: 0
X-RG-CM: Clean
X-Originating-IP: [174.88.80.151]
X-RG-Env-Sender: dave.anglin@bell.net
X-RG-Rigid: 63E35FA800BA4B2E
X-CM-Envelope: MS4xfNC3txz8B+Q9TzEvyDNIM8qSoUjyhqp0F+nq+pW2n9gpPbN+AdKM845B0/n7o99B27H4Qr5snvh8dvO96dAfJs1v/BjpMkp2FlTw1n/5Xi21wUezX7yO
 pVgyN8VfiNgPJakfCEX9r9DykEyvN2XhH7Igm4LgdAQ/dcY2qpeSLmsLWyo/OY2RyruXHhCCqzPPcp5HL+qyGVlrOtWa3MjJnUlL29QBgCQyXMJv/1+8Hvg0
 KU87stChKidGOhfSRdKqiWc7cGY6uS9MiCLyYF+Fskk4XYwV2k3fQ0+bhJygVWAAyDbCziqKkHzEnwhRqAFOG/NPybRfOVppc4dAlS+ddjh8wNJSK9I3gRTN
 nRbRLEaAKCiOrVtQU5D4iTINOYIOlSi5WIKLvyvGbN0RdZwllIw=
X-CM-Analysis: v=2.4 cv=GcB0ISbL c=1 sm=1 tr=0 ts=63ed05c2
 a=6Iw0JHgwQEnu+SgMJEJdFQ==:117 a=6Iw0JHgwQEnu+SgMJEJdFQ==:17
 a=IkcTkHD0fZMA:10 a=FBHGMhGWAAAA:8 a=CPwiehgnZW1YgXo-czIA:9 a=QEXdDO2ut3YA:10
 a=9gvnlMMaQFpL9xblJ6ne:22
Received: from [192.168.2.49] (174.88.80.151) by cmx-mtlrgo002.bell.net (5.8.814) (authenticated as dave.anglin@bell.net)
        id 63E35FA800BA4B2E; Wed, 15 Feb 2023 11:18:10 -0500
Message-ID: <1b3f7db4-7770-188c-f316-be4b42c3f6b7@bell.net>
Date:   Wed, 15 Feb 2023 11:18:10 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: io_uring failure on parisc with VIPT caches
To:     Helge Deller <deller@gmx.de>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
References: <Y+wUwVxeN87gqN6o@p100>
 <006e8db4-336f-6717-ecb0-d01a0e9bc483@kernel.dk>
 <626cee6f-f542-b7eb-16ca-1cf4e3808ca6@bell.net>
 <5f02fa8b-7fd8-d98f-4876-f1a89024b888@kernel.dk>
 <2b89f252-c430-1c44-7b30-02d927d2c7cb@gmx.de>
Content-Language: en-US
From:   John David Anglin <dave.anglin@bell.net>
In-Reply-To: <2b89f252-c430-1c44-7b30-02d927d2c7cb@gmx.de>
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

On 2023-02-15 10:52 a.m., Helge Deller wrote:
>>>> Are they from the kernel side, if the lower bits mean we end up
>>>> with the same coloring? Because I think this is a bit of a big
>>>> hammer, in terms of overhead for flushing. As an example, on arm64
>>>> that is perfectly fine with the existing code, it's about a 20-25%
>>>> performance hit.
>>>
>>> The io_uring-test testcase still works on rp3440 with the kernel
>>> flushes removed.
>>
>> That's what I suspected, the important bit here is just aligning it for
>> identical coloring. Can you confirm if the below works for you? Had to
>> fiddle it a bit to get it to work without coloring.
>
> Yes, the patch works for me on 32- and 64-bit, even with PA8900 CPUs...
>
> Is there maybe somewhere a more detailled testcase which I could try too?
We need to look at liburing and mariadb testsuites.  Mariadb testsuite failed last night
on rp3440.  So, I don't think we have a full solution for machines with PA8800 and PA8900
CPUs.

As I have said in the past, I don't think we have a consistent alias boundary for these
machines because of their L2 cache design.

-- 
John David Anglin  dave.anglin@bell.net

