Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3C86212D8
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 14:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbiKHNnV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Nov 2022 08:43:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234200AbiKHNnU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 08:43:20 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B2C5288E
        for <io-uring@vger.kernel.org>; Tue,  8 Nov 2022 05:43:19 -0800 (PST)
Received: from [10.7.7.5] (unknown [182.253.88.158])
        by gnuweeb.org (Postfix) with ESMTPSA id 36FE5814AD;
        Tue,  8 Nov 2022 13:43:16 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1667914999;
        bh=FfkY917Pk5lEu17blLjRVd2joBbvDpflxtNHAFaslJ0=;
        h=Date:Subject:To:References:Cc:From:In-Reply-To:From;
        b=fPSpWqs3+GEvbQYKTp97e721fg/3DZNBAVPljlU3/oeqFmH0GJjX2P2GhMGDVWJji
         /bFIQOy++xARxcbDXmfIC7cpaMqOf02irBt9zTuQlSIu2YczK6/U26c/msQJVH4yjL
         tE4S7SqMxUWdDee6grAE8Kn9qfkwR5oqQEQxuwb30DP1GS1ok+GwYMK40hgobnX87F
         f7x/BBPj0wcQi+ff2+Bvv1nSqSJVsu/f5de7g7PABBIqOIfO7+9eiusR+VBz/q0e48
         utTYdvPoUUU/q6aAuTt/WgsrK0b5iGUvody7JdlI3iUckf+kNbkg17ggSTL7dWrpUN
         ZZsnbzkq1Z2/A==
Message-ID: <6360ecfb-8f71-72c5-d903-f7d1531a1f6d@gnuweeb.org>
Date:   Tue, 8 Nov 2022 20:43:14 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: samba does not work with liburing 2.3
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>
References: <5a3d3b11-0858-e85f-e381-943263a92202@msgid.tls.msk.ru>
 <df789124-d596-cec3-1ca0-cdebf7b823da@msgid.tls.msk.ru>
 <6dde692a-145f-63bd-95bd-1eb1c1b108ce@samba.org>
Cc:     Caleb Sander <csander@purestorage.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Samba Technical Mailing List 
        <samba-technical@lists.samba.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <6dde692a-145f-63bd-95bd-1eb1c1b108ce@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


+ Adding Caleb Sander <csander@purestorage.com> to the CC list.

On 11/8/22 8:26 PM, Stefan Metzmacher wrote:
> Am 08.11.22 um 13:56 schrieb Michael Tokarev via samba-technical:
>> 08.11.2022 13:25, Michael Tokarev via samba-technical wrote:
>>> FWIW, samba built against the relatively new liburing-2.3 does not
>>> work right, io_uring-enabled samba just times out in various i/o
>>> operations (eg from smbclient) when liburing used at compile time
>>> was 2.3. It works fine with liburing 2.2.
>>
>> This turned out to be debian packaging issue, but it might affect
>> others too. liburing 2.3 breaks ABI by changing layout of the main
>> struct io_uring object in a significant way.
>>
>> http://bugs.debian.org/1023654
> 
> I don't see where this changes the struct size:
> 
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
> 
> The packaging should make sure it requires the version is build against...

-- 
Ammar Faizi

