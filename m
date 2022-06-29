Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D92D055F291
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 03:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbiF2BAn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 21:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiF2BAm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 21:00:42 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B35193EB
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 18:00:42 -0700 (PDT)
Received: from [192.168.88.254] (unknown [180.245.197.13])
        by gnuweeb.org (Postfix) with ESMTPSA id B69FE7FC32;
        Wed, 29 Jun 2022 01:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656464441;
        bh=khJ8FNllSQ/hOXJ+b2Nlkm/pJRhxyq1BD9zY8iElbEA=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=j9laaVcvd+XVrERFz597kGqf9vL9CpCuGfY/AeEXdaxykJsLVRsRUK4rOkUvfryw0
         UrGavE3CktqfnfYWnQzMiggApSGqAoXqbsgQbMEvNeMUKO078HlAMdtm4FM60xTkq9
         8mMNG9HSL0PDeyJC2qzlG8BDBXIr/PXZUUvvYQalYhri/IIL3eMI4ZrsC2WpR1zQCp
         kTPaLw/piR8Yvvu7vCpb60VhqkjILm+Ud4MKBfPGXD/O2ptVppv1Uq857OzirK2dRy
         Sq5HSi6RuxIlL2IQBCy1INLV3Uzm5tnQ2Rty8MYzxHLnqJGKD0JhjCRx/fj7Jgw59t
         xqzAkFsR2YaLA==
Message-ID: <1f690153-1b0c-b9fc-4c2e-6084ebe1c0af@gnuweeb.org>
Date:   Wed, 29 Jun 2022 08:00:27 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <howeyxu@tencent.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>
References: <20220629002028.1232579-1-ammar.faizi@intel.com>
 <20220629002028.1232579-3-ammar.faizi@intel.com>
 <CAOG64qOpHNUO3WP6ve98P3zGEAaykpZP_quo6nce-7=H63s8-w@mail.gmail.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing v1 2/9] setup: Handle `get_page_size()` failure
 (for aarch64 nolibc support)
In-Reply-To: <CAOG64qOpHNUO3WP6ve98P3zGEAaykpZP_quo6nce-7=H63s8-w@mail.gmail.com>
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

On 6/29/22 7:50 AM, Alviro Iskandar Setiawan wrote:
> On Wed, Jun 29, 2022 at 7:28 AM Ammar Faizi wrote:
>>          page_size = get_page_size();
>> +       if (page_size < 0)
>> +               return page_size;
>> +
>>          return rings_size(p, entries, cq_entries, page_size);
>>   }
> 
> the current error handling fallback to 4K if fail on sysconf(_SC_PAGESIZE):
> https://github.com/axboe/liburing/blob/68103b731c34a9f83c181cb33eb424f46f3dcb94/src/arch/generic/lib.h#L10-L19
> with this patch, get_page_size() is only possible to return negative
> value on aarch64.

Ah right, this one needs a revision. Either we fallback to 4K, or
return error if we fail.

> i don't understand why the current master branch code fallback to 4K when fail?

Neither do I. Maybe because 4K is widely used page size?

Jens, can you shed some light on this?

   The current upstream does this:

      - For x86/x86-64, it's hard-coded to 4K. So it can't fail.
      - For other archs, if sysconf(_SC_PAGESIZE) fails, we fallback to 4K.

Now we are going to add aarch64, it uses a group of syscalls to get the page
size. So it may fail. What should we do when we fail?

Fallback to 4K? Or return error code from syscall?
       
-- 
Ammar Faizi
