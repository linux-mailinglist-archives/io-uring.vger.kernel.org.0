Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E37B7565635
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 14:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234662AbiGDMxt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 08:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234725AbiGDMxT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 08:53:19 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2F012610
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 05:53:01 -0700 (PDT)
Received: from [192.168.88.254] (unknown [36.81.65.188])
        by gnuweeb.org (Postfix) with ESMTPSA id A8E84801D5;
        Mon,  4 Jul 2022 12:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656939180;
        bh=cOJmV6xfl1xSAwgR6tgDtiEivB0NprVgM91G/d8e4fs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Lc+RNSHv1Pi7d0Ckni+jcw5gXCi7cD1r9TCedd7MH3i0YRlXx+fggbyIBadrL5vS/
         RvnIqmRYXRchxLN9RgyHoPMgwU4B4PamiXBM4gDD/lgFJxhtDTuM/JfXB1k36lS2R3
         xl1Z/mocYUyVqnwFC/sbkmk1e5av/w+Zu9z/pyqceXwJ1Msz1/BUkfVMYL6jh2ydBw
         rtgjtnnwd1BzCuCMy07f+XVBJHI/LWn5+xSfdDZ/Sq2o12hKh7qocL7ca7ftQhUmHF
         h8r4xavGKuGVMK22nwTeCM0Yg4DC43vmTe2qGzGzQhJjdOoqEP6ocNoknb3PUsHkt2
         E8zOUdnUBsBJQ==
Message-ID: <073c02c4-bddc-ab35-545f-fe81664fac13@gnuweeb.org>
Date:   Mon, 4 Jul 2022 19:52:53 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH liburing v2 0/8] aarch64 support
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <howeyxu@tencent.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>
References: <20220629175255.1377052-1-ammar.faizi@intel.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20220629175255.1377052-1-ammar.faizi@intel.com>
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

On 6/30/22 12:58 AM, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> 
> Hi Jens,
> 
> This is v2 revision of aarch64 support.
> 
> This series contains nolibc support for aarch64 and one extra irrelevant
> cleanup (patch #1). The missing bit from aarch64 is get_page_size()
> which is a bit complicated to implement without libc.
> 
> aarch64 supports three values of page size: 4K, 16K, and 64K which are
> selected at kernel compilation time. Therefore, we can't hard code the
> page size for this arch. In this series we utilize open(), read() and
> close() syscall to find the page size from /proc/self/auxv.
> 
> The auxiliary vector contains information about the page size, it is
> located at `AT_PAGESZ` keyval pair.

This no longer applies, I will send v3 revision soon. If you have some
comments, let me know so I can address it together with the rebase.

-- 
Ammar Faizi
