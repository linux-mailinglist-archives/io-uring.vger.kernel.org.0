Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 198AD4D248A
	for <lists+io-uring@lfdr.de>; Tue,  8 Mar 2022 23:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240107AbiCHW77 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 17:59:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiCHW77 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 17:59:59 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD332C113
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 14:59:02 -0800 (PST)
Received: from [192.168.43.69] (unknown [182.2.69.180])
        by gnuweeb.org (Postfix) with ESMTPSA id D34BF7E6D7;
        Tue,  8 Mar 2022 22:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646780341;
        bh=WXMxlLPqVKFg6/YnSugbjNo6Oq8sez3cxwTMR34sN34=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=gVK++JLVdIiOsSzZ/NGLGxAeQ4eF7Vrc8DOraxo05WGhINWPeG6er4XE8A3PPgo+W
         rVMafJAGv1bm3Wwui1FLT5p9b7B1PgFiuiwNZbaV6trH5fbDwJ2sewSFtYktI57Lo3
         TNbLgs0xJZkQZKhDLVhSet7OYSHYlcpPEA8g+nr8ErLH5l1U2oR+kMrA//mfiH5yyX
         xXFRBUMb1iUep0gYt2oDmv1oXFxM/0h9ef0AbOX0csWXU57hM5w4Jcx343cmfdqqJV
         jIxNMmVJZ/Cm9Wz9FLi5i2qn3KQXrmXmwnbZyIV6hg8h0qSTuxZoIswHytgfGM7t/s
         8wCaKukhqjIcw==
Message-ID: <756bf7eb-ed5a-ea69-ba0a-685418125bfe@gnuweeb.org>
Date:   Wed, 9 Mar 2022 05:58:55 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH liburing 2/2] src/Makefile: Add header files as dependency
Content-Language: en-US
To:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        io-uring@vger.kernel.org, gwml@vger.gnuweeb.org
References: <20220308224002.3814225-1-alviro.iskandar@gnuweeb.org>
 <20220308224002.3814225-3-alviro.iskandar@gnuweeb.org>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20220308224002.3814225-3-alviro.iskandar@gnuweeb.org>
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

On 3/9/22 5:40 AM, Alviro Iskandar Setiawan wrote:
> When the header files are modified, the compiled object are not going
> to be recompiled because the header files are not marked as dependency
> for the objects. Add those header files as dependency so it is safe
> not to do "make clean" after changing those files.

Another missing part is the test files, they should also be recompiled
when changes to files in src/ are made. With this change, they are not.

The same also for examples/.

-- 
Ammar Faizi
