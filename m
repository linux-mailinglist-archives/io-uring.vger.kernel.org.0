Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77A51C1715
	for <lists+io-uring@lfdr.de>; Fri,  1 May 2020 16:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730159AbgEAN5K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 May 2020 09:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730564AbgEANe1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 May 2020 09:34:27 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91320C061A0C
        for <io-uring@vger.kernel.org>; Fri,  1 May 2020 06:34:27 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id hi11so2300209pjb.3
        for <io-uring@vger.kernel.org>; Fri, 01 May 2020 06:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+bmrtSHAyFI7P6ziJ3xGe8cTwBT8YOneJTOxmYdhGZc=;
        b=sWO4PNY9YAPlMcmQTFYRy58u3AGk/QRym0idM1ioVic2+sgGTcaVvxbRjP529xqfKo
         QIY5xGGj0avqcE8fEdZEcmZttXUyjQhoKQFJR8zc9ocM8keWbLpJ0KDLD+j8WjDDtsdI
         dhgVsmF0w2V2wqVrSe1MY711Uebu0smXDe3nolZ7UvkpSYjcA29No4nXX1zShE5IrBmO
         uZcnPFpxjsowt25d6A/HMu+4gw5oTHDNekrJ6CNLntaDKePyVY0pXPTh1+kG2osYMl+H
         B+RXPJVdTonCU3tSlVFljHkrXOVfL+OHrakrJolGC6ifg5LdN24VKGVbQyp3In3GQjpl
         TvPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+bmrtSHAyFI7P6ziJ3xGe8cTwBT8YOneJTOxmYdhGZc=;
        b=GQOescM7jYqIeemHcYisZfhjJF+HrmO78NeYJG3sBfFJ53RZOMv4sB+PHPLMW5iTQl
         QyVbatMSPqypErg1cBpdP49q0ed8hPwFZoPhKNTx8WOF5cC+oX15RbPTDHOJJwWdKlDG
         qv0XBgpi/Vdi9rLXl4Qs6F7KApuGehMXQJk2Zoq8QYsnalQ7z40IsvqBi1yLShwHONzo
         Bfz7TZYdTyIhP7iq7tJwASqy/H9w8yx98GDtvVCd0eGCV76QMfsq1JB7nXYH+CjbV3/B
         ehZkxHS/dlhRfYo3XcXUxnZ5y8s0DlEKBOxVFIMqLALoW/qeCZIMHywCFW1b7MA2dMDx
         VITw==
X-Gm-Message-State: AGi0Pua/gWZtCY89IYtb7g5YIicvshoJzWe3pn5sgzAjs4yoPd/dIE2c
        rvC5jY3MyBMalBdKaytbhYIv/+iqdp1c0A==
X-Google-Smtp-Source: APiQypLxg0DxSuXSZ6n95JDcUikNRX6xaAN5w06xsc1r2DmCej7hLmZ2BDXQTy8ezdmV4N/JvVd9Ag==
X-Received: by 2002:a17:902:20b:: with SMTP id 11mr4070767plc.209.1588340067042;
        Fri, 01 May 2020 06:34:27 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id i190sm2323153pfe.114.2020.05.01.06.34.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2020 06:34:26 -0700 (PDT)
Subject: Re: [PATCH 0/5] timeout fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1588253029.git.asml.silence@gmail.com>
 <8665e87d-98f8-5973-d11a-03cca3fdf66f@gmail.com>
 <8d9b5e06-4100-c49a-c9ca-0efc389edaf3@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c7aefe37-d740-5324-905f-1b095cfb4ea7@kernel.dk>
Date:   Thu, 30 Apr 2020 22:26:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <8d9b5e06-4100-c49a-c9ca-0efc389edaf3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/1/20 3:38 AM, Pavel Begunkov wrote:
> On 01/05/2020 11:21, Pavel Begunkov wrote:
>> On 30/04/2020 22:31, Pavel Begunkov wrote:
>>> [1,2] are small random patches.
>>> [3,4] are the last 2 timeout patches, but with 1 var renamed.
>>> [5] fixes a timeout problem related to batched CQ commits. From
>>> what I see, this should be the last fixing timeouts.
>>
>> Something gone wrong with testing or rebasing. Never mind this.
> 
> io_uring-5.7 hangs the first test in link_timeout.c. I'll debug it today,
> but by any chance, does anyone happen to know something?

That's not your stuff, see:

https://lore.kernel.org/linux-fsdevel/269ef3a5-e30f-ceeb-5f5e-58563e7c5367@kernel.dk/T/#ma61d47f59eaaa7f04ae686c117fab69c957e0d7d

which then just turned into a modification to a patch in io_uring-5.7
instead. Just force rebase that branch and it should work fine.

-- 
Jens Axboe

