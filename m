Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF51621CE3
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 20:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiKHTTL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Nov 2022 14:19:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbiKHTSx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 14:18:53 -0500
Received: from isrv.corpit.ru (isrv.corpit.ru [86.62.121.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA80D15A2C
        for <io-uring@vger.kernel.org>; Tue,  8 Nov 2022 11:18:49 -0800 (PST)
Received: from tsrv.corpit.ru (tsrv.tls.msk.ru [192.168.177.2])
        by isrv.corpit.ru (Postfix) with ESMTP id C8C1940142;
        Tue,  8 Nov 2022 22:18:48 +0300 (MSK)
Received: from [192.168.177.130] (mjt.wg.tls.msk.ru [192.168.177.130])
        by tsrv.corpit.ru (Postfix) with ESMTP id 2534330C;
        Tue,  8 Nov 2022 22:18:53 +0300 (MSK)
Message-ID: <82a3df48-69ce-fe1d-1c7b-4deabc323eae@msgid.tls.msk.ru>
Date:   Tue, 8 Nov 2022 22:18:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: samba does not work with liburing 2.3
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Stefan Metzmacher <metze@samba.org>
Cc:     Caleb Sander <csander@purestorage.com>,
        Samba Technical Mailing List 
        <samba-technical@lists.samba.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <5a3d3b11-0858-e85f-e381-943263a92202@msgid.tls.msk.ru>
 <df789124-d596-cec3-1ca0-cdebf7b823da@msgid.tls.msk.ru>
 <6dde692a-145f-63bd-95bd-1eb1c1b108ce@samba.org>
 <6360ecfb-8f71-72c5-d903-f7d1531a1f6d@gnuweeb.org>
From:   Michael Tokarev <mjt@tls.msk.ru>
In-Reply-To: <6360ecfb-8f71-72c5-d903-f7d1531a1f6d@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

08.11.2022 16:43, Ammar Faizi wrote:
> 
> + Adding Caleb Sander <csander@purestorage.com> to the CC list.
> 
> On 11/8/22 8:26 PM, Stefan Metzmacher wrote:
>> Am 08.11.22 um 13:56 schrieb Michael Tokarev via samba-technical:
>>> 08.11.2022 13:25, Michael Tokarev via samba-technical wrote:
>>>> FWIW, samba built against the relatively new liburing-2.3 does not
>>>> work right, io_uring-enabled samba just times out in various i/o
>>>> operations (eg from smbclient) when liburing used at compile time
>>>> was 2.3. It works fine with liburing 2.2.
>>>
>>> This turned out to be debian packaging issue, but it might affect
>>> others too. liburing 2.3 breaks ABI by changing layout of the main
>>> struct io_uring object in a significant way.
>>>
>>> http://bugs.debian.org/1023654
>>
>> I don't see where this changes the struct size:
>>
>> -       unsigned pad[4];
>> +       unsigned ring_mask;
>> +       unsigned ring_entries;
>> +
>> +       unsigned pad[2];
>>
>> But I see a problem when you compile against 2.3 and run against 2.2
>> as the new values are not filled.
>>
>> The problem is the mixture of inline and non-inline functions...
>>
>> The packaging should make sure it requires the version is build against...

As has been pointed out before, this is an issue with debian packaging of
liburing.

2.3 actually appears to be backwards-compatible with previous 2.2, in other
words, programs compiled with 2.2 will continue to work after liburing is
upgraded to 2.3  - at least it *seems* to be the case, which is might be not
what I initially wrote.

The problem happens when you compile a program against liburing 2.3, and
try to run it against the previous liburing-2.2, in other words, going
backwards at runtime.

In order to ensure we have "sufficiently new" library at runtime, there
are package dependencies, - all package managers have them in one way
or another.  Usually it is done by having a table with symbol names
and library versions where/when each symbol appeared, so if a program
uses symbol foo which first appeared in version 1.2 of library lib,
this program is marked as Depends: lib >= 1.2.

But in this case, the symbols are all the same (not counting really new
symbols which actually appeared in 2.3 for the first time).  Yet, the
interface changed somehow for the *newly* compiled programs. In other
words, once a program is compiled against liburing 2.3, it will need
a >=2.3 version of liburing, even if the same symbol it uses first
appeared in earlier version.

This is not something which happens often.  To remedy (assuming the
new lib is really binary compatible with programs compiled with the
old version), Debian needs to change the symbol-version table to list
2.3 version for all symbols, not just for the newly-appeared symbols, -
this way, even if the symbols itself isn't really new, but the newly
compiled program require a more recent version of the interface and
wont work with older symbols of the same name.

This is because of the inline wrappers which gets compiled into the
program, who expects the new struct layout, while the old lib only
provides old layout.

While the new lib works with either layout, so will - hopefully -
work with the now-deprecated structure members too, the same way
it was worked before.

The situation here is rather unusual, and I guess it's rare enough
so that all involved parties were prepared for it. It's easy to
solve at the downstream packaging step, but this has to be done.

It has nothing to do with samba, but with proper packaging of
liburing which - in this case - needs a bit of extra care.

Thanks,

/mjt
