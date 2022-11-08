Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3812621379
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 14:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234665AbiKHNuj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Nov 2022 08:50:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234594AbiKHNuf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 08:50:35 -0500
X-Greylist: delayed 465 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Nov 2022 05:50:29 PST
Received: from isrv.corpit.ru (isrv.corpit.ru [86.62.121.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1301BC9C
        for <io-uring@vger.kernel.org>; Tue,  8 Nov 2022 05:50:29 -0800 (PST)
Received: from tsrv.corpit.ru (tsrv.tls.msk.ru [192.168.177.2])
        by isrv.corpit.ru (Postfix) with ESMTP id 5337B40115;
        Tue,  8 Nov 2022 16:42:41 +0300 (MSK)
Received: from [192.168.177.130] (mjt.wg.tls.msk.ru [192.168.177.130])
        by tsrv.corpit.ru (Postfix) with ESMTP id 2CBE930C;
        Tue,  8 Nov 2022 16:42:46 +0300 (MSK)
Message-ID: <dc57ecfe-0058-e0c6-f75c-e4274da0f1ee@msgid.tls.msk.ru>
Date:   Tue, 8 Nov 2022 16:42:40 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: samba does not work with liburing 2.3
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>,
        samba-technical@lists.samba.org,
        io-uring <io-uring@vger.kernel.org>
References: <5a3d3b11-0858-e85f-e381-943263a92202@msgid.tls.msk.ru>
 <df789124-d596-cec3-1ca0-cdebf7b823da@msgid.tls.msk.ru>
 <6dde692a-145f-63bd-95bd-1eb1c1b108ce@samba.org>
From:   Michael Tokarev <mjt@tls.msk.ru>
In-Reply-To: <6dde692a-145f-63bd-95bd-1eb1c1b108ce@samba.org>
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

08.11.2022 16:26, Stefan Metzmacher wrote:

>> http://bugs.debian.org/1023654
> 
> I don't see where this changes the struct size:

Yeah, I noticed that too after filing that bugreport,
indeed, the problem not in the size of the structures,
but in the changed way - old inline functions used the
deprecated ring_kmask & ring_kentries, while the new
ones uses new ring_mask & ring_entries.

> -       unsigned pad[4];
> +       unsigned ring_mask;
> +       unsigned ring_entries;
> +
> +       unsigned pad[2];
> 
> But I see a problem when you compile against 2.3 and run against 2.2
> as the new values are not filled.
> 
> The problem is the mixture of inline and non-inline functions...

Yeah.

> The packaging should make sure it requires the version is build against...

It is either Depends: liburing2 > $version, or, if the ABI is broken like
this, it is Depends: liburing3 > $newversion (with the soname bump).

At any rate, this is not exactly samba problem, but it affects samba.

Thanks,

/mjt

