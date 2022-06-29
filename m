Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DED395603AF
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 17:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbiF2PAK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jun 2022 11:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiF2PAK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jun 2022 11:00:10 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9151AF02
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 08:00:09 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id m14-20020a17090a668e00b001ee6ece8368so10438270pjj.3
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 08:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=w+80gF+SO9xyDAn4+qCBK5ze6aqaEVxwGa/jlqvAzFs=;
        b=R9EUHaQYZBN4iLDwTwMInU88QN+rz655fgOBGBl8HkgvtLMWrgRy1oWDP2HK2bfR11
         ckCxVc4bf1kQ7IzAhUaTgG9BdjrTdduAEzk3hW89YMh8DLWuPrPzB97ULzdTtXgYGvwm
         wnRVR5WCSw/+O9ofIjRLN3+lrjBW57Gpq+PV9B3/P2ZxiPs++2K3R57gBFwwHGj2ooF8
         GTcKFh3N1kJbBGmsT+k0Je4nJ3imRQJ8Dpc7xZrqWSHtLMacAVB4zZ6knv75YMlvnfjP
         zltPoDU58laVQJ61H0lM805594VQd9U7IxWu4OUP3UDEmvMK7xK7QvyZfEUIStnfcQJT
         ooqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=w+80gF+SO9xyDAn4+qCBK5ze6aqaEVxwGa/jlqvAzFs=;
        b=m6JUEwMhTWo9R7SSaXcMyR5aA4Q02x7MyKei2L4xlkItbLL2pYgXI+NZLGhrVtFRaX
         eO+n+G9bikkm0fGYrF18OL/yPSoI6d2d/8j8K2cLnAg8jp7YVF0umAqDHlAjhQBD7d7h
         o3aKpqNFcvy5gbEx1MQdE6i9e3wmoaGOBXZsttlc8DX+EjhD/luv+bR70ZdIZO2i62m+
         vEuszYyr4rRoCWK1chgQyJKed0EUHaS5DCCFnJ4gfnEzOGVmZPaVMgRLpNLafiUhI09o
         PrL8DGwFUGcFO+qp+4AF7KonMeH7CiLyB0p0/CCZ/1MK9a230V2A8B3A7oQd8ARp0jMW
         Pxbw==
X-Gm-Message-State: AJIora9Py0Yuqi22fBAXD84JDSnT6wTYRKoJ51fINYarra4OW7yNM/BE
        fAoloofAZNsDikj4s5Cwj+XhJg==
X-Google-Smtp-Source: AGRyM1uHSOYlVXycTNSpnziuEk4n9wYfylaqmDcKSxDBjItQRqcIEhzAmiXw/drVQxAxKkCRKKFmMg==
X-Received: by 2002:a17:903:1246:b0:16b:7f81:138 with SMTP id u6-20020a170903124600b0016b7f810138mr10672666plh.141.1656514808958;
        Wed, 29 Jun 2022 08:00:08 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x4-20020a63db44000000b003fc4cc19414sm11574124pgi.45.2022.06.29.08.00.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 08:00:08 -0700 (PDT)
Message-ID: <3895dbe1-8d5f-cf53-e94b-5d1545466de1@kernel.dk>
Date:   Wed, 29 Jun 2022 09:00:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH liburing v1 2/9] setup: Handle `get_page_size()` failure
 (for aarch64 nolibc support)
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Cc:     Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <howeyxu@tencent.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>
References: <20220629002028.1232579-1-ammar.faizi@intel.com>
 <20220629002028.1232579-3-ammar.faizi@intel.com>
 <CAOG64qOpHNUO3WP6ve98P3zGEAaykpZP_quo6nce-7=H63s8-w@mail.gmail.com>
 <1f690153-1b0c-b9fc-4c2e-6084ebe1c0af@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1f690153-1b0c-b9fc-4c2e-6084ebe1c0af@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/28/22 7:00 PM, Ammar Faizi wrote:
> On 6/29/22 7:50 AM, Alviro Iskandar Setiawan wrote:
>> On Wed, Jun 29, 2022 at 7:28 AM Ammar Faizi wrote:
>>>          page_size = get_page_size();
>>> +       if (page_size < 0)
>>> +               return page_size;
>>> +
>>>          return rings_size(p, entries, cq_entries, page_size);
>>>   }
>>
>> the current error handling fallback to 4K if fail on sysconf(_SC_PAGESIZE):
>> https://github.com/axboe/liburing/blob/68103b731c34a9f83c181cb33eb424f46f3dcb94/src/arch/generic/lib.h#L10-L19
>> with this patch, get_page_size() is only possible to return negative
>> value on aarch64.
> 
> Ah right, this one needs a revision. Either we fallback to 4K, or
> return error if we fail.
> 
>> i don't understand why the current master branch code fallback to 4K when fail?
> 
> Neither do I. Maybe because 4K is widely used page size?
> 
> Jens, can you shed some light on this?
> 
>   The current upstream does this:
> 
>      - For x86/x86-64, it's hard-coded to 4K. So it can't fail.
>      - For other archs, if sysconf(_SC_PAGESIZE) fails, we fallback to 4K.
> 
> Now we are going to add aarch64, it uses a group of syscalls to get the page
> size. So it may fail. What should we do when we fail?
> 
> Fallback to 4K? Or return error code from syscall?

4k is the most common page size, by far, so makes sense to have that as
a fallback rather than just error out. Perhaps the application will then
fail differently, but there's also a chance that it'll just work.

So I think just falling back to 4k if we fail for whatever reason is the
sanest recourse.

-- 
Jens Axboe

