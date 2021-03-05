Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E309132E720
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 12:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbhCELT4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Mar 2021 06:19:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhCELTq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Mar 2021 06:19:46 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C18EC061574
        for <io-uring@vger.kernel.org>; Fri,  5 Mar 2021 03:19:46 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id n22so1107783wmc.2
        for <io-uring@vger.kernel.org>; Fri, 05 Mar 2021 03:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qZTepjVssCZk9eK969kfbhdPdbUiQ5oH1S5Al5Mx/C8=;
        b=RbVbtd2ZxdKGI8BXj/upoMRN6djZzaKe4FtOJkSpK4XGUxvH/nAupya4uEnSB7Lxkm
         qwlZl0zsji3mTain+EYxtLsEBpwNPXpM+GhjABekgTZXLTUjzJKeTEielTc7yv8BaPdL
         RMIdyAHVZ1vgEQwaf8SqC/6W5apsg6nx3ubfe5zGt4PpQ6maMwsqo4GQY0IwLZvYji65
         Q8UT7fP+aZ3m/yuO+rX72JRaMn0H+15V56IjiI6G+I1KOAci0jx/ZTxrLVkH4WB+YbS2
         uqENNHNoaVLika3oonD6jybf6a6SkO852ldYAhDII3QXxWvV4DdrLRB6LUqGrCfKlYYM
         50ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qZTepjVssCZk9eK969kfbhdPdbUiQ5oH1S5Al5Mx/C8=;
        b=dyRFn56Hc7LDnBzkuucfPt7kAo3sfef39I5AzvS8CcsJxTY+OurO4RTvnFoL/yYMqE
         jdlh/n/ZVhjZZpaCI8tWhb9kOJeSIPnmvZEqKdm+TQ4GkTvSYF2FWtlEcX2r7XWny2SM
         CJokyIk8Fag+dJW1LfLNg5E4Gkr9CCsEkQxWrw8Z0Xv33uTiUcymRUQfiyAjm3w9tHLf
         MDZ//GDUOmg6YCadbKuplnIqeMWP3nn1WUvTlDbM2uK+0GNc7hrSlRNW4VHRjq2WCa+0
         dFshENRwDvxg8NdMAURA9wGEmoAWOG6OdByUigNR5LSh17ecUoBAeFyCV+C1DWNbwRRi
         VXwg==
X-Gm-Message-State: AOAM532Fy7Iku7MhWZbIV7cIJVsVsFpnnWK7usQLVNl/H2MOh9XmTqnq
        YVEuRqJf0YWJJtHSFiamV5eG93LWT7EvPg==
X-Google-Smtp-Source: ABdhPJwce4+GbRdnZvYu0NOpcej4Obrb6RHDX2+1+30HMOFNqOydh7UBYbP09olyLi5/ndqYyExMzg==
X-Received: by 2002:a1c:66c4:: with SMTP id a187mr8399985wmc.164.1614943184644;
        Fri, 05 Mar 2021 03:19:44 -0800 (PST)
Received: from [192.168.8.104] ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id b186sm4198024wmc.44.2021.03.05.03.19.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 03:19:43 -0800 (PST)
Subject: Re: [PATCH 8/8] io_uring: warn when ring exit takes too long
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1614866085.git.asml.silence@gmail.com>
 <4bc9b29f2f5b7952b313be604f43b131a2dfe277.1614866085.git.asml.silence@gmail.com>
 <2eed01be-1148-86da-b4ea-dcb349f04476@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <17ce8fb4-d400-d9ab-2c80-b766fb8dffc1@gmail.com>
Date:   Fri, 5 Mar 2021 11:15:50 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <2eed01be-1148-86da-b4ea-dcb349f04476@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 05/03/2021 04:25, Jens Axboe wrote:
> On 3/4/21 6:59 AM, Pavel Begunkov wrote:
>> We use system_unbound_wq to run io_ring_exit_work(), so it's hard to
>> monitor whether removal hang or not. Add WARN_ONCE to catch hangs.
> 
> Minor nit, but I'd just use jiffies for this. Ala:
> 
> unsigned long timeout = jiffies + 60 * HZ;
> 
> if (time_after(jiffies, timeout))
>     complain();
> 
> That's a well known idiom, and we don't need better precision than that.

And also looks much nicer, thanks

-- 
Pavel Begunkov
