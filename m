Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9DF5659FD
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 17:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234362AbiGDPhF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 11:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233970AbiGDPhE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 11:37:04 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF91101CE
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 08:37:02 -0700 (PDT)
Received: from [192.168.88.254] (unknown [36.81.65.188])
        by gnuweeb.org (Postfix) with ESMTPSA id F32747FC8C;
        Mon,  4 Jul 2022 15:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656949022;
        bh=y8iUX5O7f9uNub2KUk23qVq7ccR7itTPOeLpKhjCFLg=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=puamP3I9AqnfqqZ2MIiD8DS71AUk4DEmt6zHCyNJeQmivSxb1LhiYIQmhfm0gD4hV
         RPnm0ik3Sxmh22jlnMTmMb5o1L+qI9cZdEAgdWZV04o6yntiqObNHroaD9Lou6Q4ff
         o6xEBc83sh3HgZlgo0ENcRns+7+R93zo0Tq7dnE6WlsA5f1pLgHDJKUqMC2o+TvNBb
         IWyn30ZCRU+5tgOI41TQv3bj49uRi5UHCn6mBxV2Qt3aVmkiq+IzKFI+Hpr8XiDkxm
         Yp51lYUMqIbhvtz+pKIzY0QoxY8YTCDhS60gLuHbfqBshOP4SjWy9pDREWJ/Rordh6
         iK6/Ii/H1Marg==
Message-ID: <cf2d0519-0fc8-0e17-a5b7-0548ef2868e6@gnuweeb.org>
Date:   Mon, 4 Jul 2022 22:36:54 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <howeyxu@tencent.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>
References: <20220629175255.1377052-1-ammar.faizi@intel.com>
 <073c02c4-bddc-ab35-545f-fe81664fac13@gnuweeb.org>
 <49ed1c4c-46ca-15c4-f288-f6808401b0ff@kernel.dk>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing v2 0/8] aarch64 support
In-Reply-To: <49ed1c4c-46ca-15c4-f288-f6808401b0ff@kernel.dk>
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

On 7/4/22 8:05 PM, Jens Axboe wrote:
> On 7/4/22 6:52 AM, Ammar Faizi wrote:
>> This no longer applies, I will send v3 revision soon. If you have some
>> comments, let me know so I can address it together with the rebase.
> 
> Just send a v3, didn't have time to go fully over it yet. One note,
> though - for patch 5, I'd split get_page_size() into two pieces so you
> just do:
> 
> static inline long get_page_size(void)
> {
> 	static long cache_val;
> 
> 	if (cache_val)
> 		return cache_val;
> 
> 	return __get_page_size();
> }
> 
> With that, we can have __get_page_size() just do that one thing, open
> the file and read the value.
> 
> No need to init static variables to 0.
> 
> And finally, if the read/open/whatever fails in __get_page_size(),
> assign cache_val to the fallback value as well. I don't see a point in
> retrying the same operation later and expect a different result.

OK, I got the idea, folded that in.

Also, it seems we don't have any test that hits that get_page_size()
path. Do we?

I am going to create a new test:

    test/nolibc.c

That file will test the nolibc functionality, let's do get_page_size()
for starting. We can compare the result with a libc function like:

   long a = sysconf(_SC_PAGESIZE);
   long b = get_page_size();
   if (a != b) {
         fprintf(stderr, "get_page_size() fails, %ld != %ld", a, b);
         return T_EXIT_FAIL;
   }

-- 
Ammar Faizi
