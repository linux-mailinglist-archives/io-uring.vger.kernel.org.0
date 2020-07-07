Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D86C216ED0
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2020 16:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgGGOdB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 10:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgGGOdB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 10:33:01 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611D0C08C5E2
        for <io-uring@vger.kernel.org>; Tue,  7 Jul 2020 07:33:01 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id i18so36172310ilk.10
        for <io-uring@vger.kernel.org>; Tue, 07 Jul 2020 07:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t2REejmbIqx/5hvdnEI6PCmIhL36dOj62WbnFSfaaQ0=;
        b=XZ1WuhDVQiSrLfIP0FKympvpl4bstkObpCbL6vF76IHkWc88bmgy4outeSIQtQRzkO
         fvV5SM/sjwKJMxXuPnpmx7ChxWsU8RGUvHXoZwwll69eLf38WeC52qnqs2tizWWzn2nJ
         PK6WitSB6Rp1aufZLLpbBRtLukXuuH38zejhFnlRXXHkq9ZY20OxAgeoXWukMRHgYoLD
         nL6JpT+wulFHnOWD2uBPay0hGewQXP88h2iyz+nRS+9K3Vsl4WhgES0M+fVauNW4LEZr
         cZGE9iCQAptiNRJCYPXcPYgzRoYPjcX7KKW6MRmTdD4zIkpnbzPpyEygbBA5YgeLvLJM
         bIXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t2REejmbIqx/5hvdnEI6PCmIhL36dOj62WbnFSfaaQ0=;
        b=Q4Kp5+u0AL7KM0QRP252dKBUBAshzv4set5L0yz86/1WPWR0zVksKL6bCP2AR74zoA
         eYi5OXTvmrTME7gFhnj93Watgxi0n4hgsZimCHXToW1C9k/uPEDaU5aNMqvzbHfloapJ
         3x0NjzEq0JDggUH7m3f/6loww+LcT3nm825WnsH468lJgSfQDMvA5zLJHFxHaUJ5HpLR
         L7AJMURcnFA9t6gaado9GT4laVAXj7oqsrBY4ylcSuZDtLOlbsmvn4uTJiE90tytKZat
         c/nKU8598R6rpxsIp7kfO4Km3zbpjEbuuud1Cu2Vs6uEH/pl0ilnIJF1a7x7okLXvoP8
         Y9rA==
X-Gm-Message-State: AOAM532T0dApTxWS4wdhYwt4bwQOzc5EEdybKdKL5atJc+K4+t/9qv9o
        E7p2MdBR5C2KDaXnW7Mu2rSgg+vmpGmNgA==
X-Google-Smtp-Source: ABdhPJzexj9+QX9mdPcyCoEq+eUXGvYhTdzOtduCkU5WgZNqqvlj/pcwEI8lt/jRRuhiaNbafQfRuA==
X-Received: by 2002:a05:6e02:f85:: with SMTP id v5mr29994311ilo.31.1594132380754;
        Tue, 07 Jul 2020 07:33:00 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z78sm13494303ilk.72.2020.07.07.07.32.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 07:33:00 -0700 (PDT)
Subject: Re: [PATCH 07/15] mm: add support for async page locking
To:     =?UTF-8?Q?Andreas_Gr=c3=bcnbacher?= <andreas.gruenbacher@gmail.com>
Cc:     io-uring@vger.kernel.org,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>
References: <20200618144355.17324-1-axboe@kernel.dk>
 <20200618144355.17324-8-axboe@kernel.dk>
 <CAHpGcM+iUnrLg+2jLzUPS45+E0ne8EiNEHt81Bjqko51u--+CA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3eb94b6c-eebd-8c0d-fe29-365df50b8949@kernel.dk>
Date:   Tue, 7 Jul 2020 08:32:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAHpGcM+iUnrLg+2jLzUPS45+E0ne8EiNEHt81Bjqko51u--+CA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/7/20 5:32 AM, Andreas Grünbacher wrote:
>> @@ -2131,6 +2166,11 @@ ssize_t generic_file_buffered_read(struct kiocb *iocb,
>>                 }
>>
>>  readpage:
>> +               if (iocb->ki_flags & IOCB_NOWAIT) {
>> +                       unlock_page(page);
>> +                       put_page(page);
>> +                       goto would_block;
>> +               }
> 
> This hunk should have been part of "mm: allow read-ahead with
> IOCB_NOWAIT set" ...

It probably should have... Oh well, it's been queued up multiple weeks
at this point, not worth rebasing to move this hunk.

-- 
Jens Axboe

