Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 204C14D45EB
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 12:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241659AbiCJLlW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 06:41:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbiCJLlU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 06:41:20 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AEFF1451C0
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 03:40:19 -0800 (PST)
Received: from [192.168.43.69] (unknown [114.10.7.234])
        by gnuweeb.org (Postfix) with ESMTPSA id E5F897E2B2;
        Thu, 10 Mar 2022 11:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646912419;
        bh=q/POEDL6M0wezE8X8/8AiLVvJQW0zAPrRuXPRI2X+xA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=TGauRgAhgTm0zUIUa8NlD+l9IHVPN+cfaNiaoHx/pXOvGcWtmGH5OGyhbPrOKVFuF
         QR5UDTJchHOk4R4++n+MMXy6WicZGv6GjG6exxICsIxDx1GSYPEZt9Wmw4vu6lcbZW
         geeP+gbpKtpxJR4nOjIvYoNj15Ay2wj+36Paut5jtUqNWmt9XdjWAR3ssKZv2hcoF4
         N55vNvfz04JCS2Xwrxi5ifxb6M/5EYcslzJdpRJvB0pZ1XANj3IWjXCGxIAyS8TGJy
         Tyyoqrw3DDIgZbebleies7uxTa8SsVlh4zdxpjkFscAZMmKDgcSRI5bJz+ffAVg7gv
         5Lg54b4R7WDNg==
Message-ID: <ab6cfcd1-3a3f-1233-99ac-1270b29e93e3@gnuweeb.org>
Date:   Thu, 10 Mar 2022 18:40:11 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH liburing v3 0/4] Changes for Makefile
Content-Language: en-US
To:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        io-uring <io-uring@vger.kernel.org>, gwml <gwml@vger.gnuweeb.org>
References: <20220310111231.1713588-1-alviro.iskandar@gnuweeb.org>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20220310111231.1713588-1-alviro.iskandar@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/10/22 6:12 PM, Alviro Iskandar Setiawan wrote:
> Hello sir,
> 
> This patchset (v3) changes Makefile. 4 patches here:
> 
> 1. Remove -fomit-frame-pointer flag, because it's already covered
>     by the -O2 optimization flag.
> 
> 2. When the header files are modified, the compiled objects are
>     not going to be recompiled because the header files are not
>     marked as a dependency for the objects.
> 
>    - Instruct the compiler to generate dependency files.
> 
>    - Include those files from src/Makefile. Ensure if any changes are
>      made, files that depend on the changes are recompiled.
> 
> 3. The test binaries statically link liburing using liburing.a file.
>     When liburing.a is recompiled, make sure the tests are also
>     recompiled to ensure changes are applied to the test binary. It
>     makes "make clean" command optional when making changes.
> 
> 4. Same as no. 3, but for examples.
> 
> please review,
> thx

I think this series looks good.

-- 
Ammar Faizi
