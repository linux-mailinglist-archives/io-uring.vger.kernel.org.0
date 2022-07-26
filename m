Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C82A25811E8
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 13:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238495AbiGZL3N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 07:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238875AbiGZL3N (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 07:29:13 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7193F3135B
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 04:29:12 -0700 (PDT)
Received: from [192.168.88.254] (unknown [125.160.106.238])
        by gnuweeb.org (Postfix) with ESMTPSA id C05B080615;
        Tue, 26 Jul 2022 11:29:10 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1658834952;
        bh=EM7H6QwM39knffPItK5J9kQZviiwplatFt/HmxLc9Ig=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=rK0bte+CmJvOvSLRcGR0K2SeefkPKi63bc1LOtWtLwM/4Ulykc62o1uRox6/MEw+F
         BgKUdocAi3dAFVX+JJH4FmvcSqizylkVe5gsU4p4WAXtiY/XLt2yY9/C/8ZURgR07Y
         nEDHz2SGS2olnhFe/Ro3uuAU0EnqfReKflFpD14GbeH2Q6Knzsp5iS5y/3hDR0bOxW
         kWV6ToasjJS6GFVxjrumoNPJnPDPZRfPW9Yqw0SPDxOTsdTjokoSI8VAMZM12Xl5Nh
         xUDr5b6lFs1o+8Yh7/qgeQNfg3ApxKHdUFxnWXs26/q2FMpv4lvdmYclXQOEOQAJtF
         8xbLvyT+H4lvA==
Message-ID: <c57e012d-8e4a-5161-1d23-5d39ad0aefa9@gnuweeb.org>
Date:   Tue, 26 Jul 2022 18:29:05 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH liburing] arch/syscall: Use __NR_mmap2 existence for
 preprocessor condition
Content-Language: en-US
To:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20220726111851.3608291-1-alviro.iskandar@gnuweeb.org>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20220726111851.3608291-1-alviro.iskandar@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/26/22 6:18 PM, Alviro Iskandar Setiawan wrote:
> Now __NR_mmap2 is only used for i386. But it is also needed for other
> archs like ARM and RISCV32. Decide to use it based on the __NR_mmap2
> definition as it's not defined on other archs. Currently, this has no
> effect because other archs use the generic mmap definition from libc.
> 
> Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

Acked-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

-- 
Ammar Faizi

