Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89335621253
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 14:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbiKHN0I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Nov 2022 08:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233775AbiKHN0H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 08:26:07 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B0D18B02
        for <io-uring@vger.kernel.org>; Tue,  8 Nov 2022 05:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:To:Date:Message-ID:CC;
        bh=7Ckc7jMDPd9YeuBri1f4ih67bDnjtNql4LJnh2S4a9k=; b=F333cTBKPAitqzKKOIMoOSfZAp
        U14tZcSunSnUWvZ6sjl06tz4PGlD8r2Di+EZ0dbMtCAP0e+OA7EeBhbXv8dugePxAWWiWb4C+F018
        krSzWtpd9WqYIDBcylMbQwrAdtAVAcHi+tENS2Mv5+rjOp3u0GYlPyIglh59IZTZtYJP4goiqzCmm
        Jk4c2iIGpZ/MxyyCjKRhp5V2stYbcJJVEgTV+mBodTG4tP7xlIcvEm9q6MpP8xi4UmM8/sY7J9bMh
        YJGIGWhmVYNZ8p2Na6n9GT4YR3aZ+Vtq8+5D/YHMOfEeAjNbI/rUPATcZkSttsN/UM1/QHLHoNuou
        bW/nyGYuSSr2mTKh1leXT/nLTDu+jrO38EsudaiEQpsC0724mXggC5bVvTIQtoIemPlqk1En8R8Ry
        Gn9UfdnhIJyAADxqbf+DHNbA71xuys79A/pNkbP7RLgEwgQnBB++EJLap+UPVPSHHjiJs3g/4/DbM
        0VY9FlmYoKBIIl5/siYXyWY5;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1osOc7-007hrN-0n; Tue, 08 Nov 2022 13:26:03 +0000
Message-ID: <6dde692a-145f-63bd-95bd-1eb1c1b108ce@samba.org>
Date:   Tue, 8 Nov 2022 14:26:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: samba does not work with liburing 2.3
Content-Language: en-US
To:     Michael Tokarev <mjt@tls.msk.ru>, samba-technical@lists.samba.org,
        io-uring <io-uring@vger.kernel.org>
References: <5a3d3b11-0858-e85f-e381-943263a92202@msgid.tls.msk.ru>
 <df789124-d596-cec3-1ca0-cdebf7b823da@msgid.tls.msk.ru>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <df789124-d596-cec3-1ca0-cdebf7b823da@msgid.tls.msk.ru>
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

Am 08.11.22 um 13:56 schrieb Michael Tokarev via samba-technical:
> 08.11.2022 13:25, Michael Tokarev via samba-technical wrote:
>> FWIW, samba built against the relatively new liburing-2.3 does not
>> work right, io_uring-enabled samba just times out in various i/o
>> operations (eg from smbclient) when liburing used at compile time
>> was 2.3. It works fine with liburing 2.2.
> 
> This turned out to be debian packaging issue, but it might affect
> others too. liburing 2.3 breaks ABI by changing layout of the main
> struct io_uring object in a significant way.
> 
> http://bugs.debian.org/1023654

I don't see where this changes the struct size:

-       unsigned pad[4];
+       unsigned ring_mask;
+       unsigned ring_entries;
+
+       unsigned pad[2];

But I see a problem when you compile against 2.3 and run against 2.2
as the new values are not filled.

The problem is the mixture of inline and non-inline functions...

The packaging should make sure it requires the version is build against...

metze


