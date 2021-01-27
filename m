Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD4530577C
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 10:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235705AbhA0JzI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 04:55:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235125AbhA0Jwq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jan 2021 04:52:46 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77BEC061786
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 01:52:04 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id d22so1679674edy.1
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 01:52:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J1sqKthrtDk9qvMNTWpQIA8zgJ7f72N82ypS6x6glnE=;
        b=ck0dZpM3wUkMebJtM7qtUIBk66xtZ025rvZTG9Ls66lCU05Rjs4bC3CV21YhMeNqBq
         lgiCyxnR7aD1pkIV2DR1Wrqf0VHIVoEMOMsiYgRITW1i/nYuYgouoMQkY8zOLaEMcjZr
         l3c5XoXPbSGOJc5Y2So9Nk++L6zK5K23tTKgHetoGJQniEj40hNO5OIPCbIIcimNGlB9
         moRTQrNIg3QVxZUz4fln1YRjx5/Nz1hlf9CXDPz2LEtsP/0pMJGfZyUcc+Eoar1UIDhV
         8IlZw4XTB6XwPcLVPdtnfJvNyTLxk7emMq3lIaBo8aKYyyLiplWL4GNeNuxqTamxbWwE
         Dkcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J1sqKthrtDk9qvMNTWpQIA8zgJ7f72N82ypS6x6glnE=;
        b=myXiP29iUul+nDn9/wV0Xk/VPHU3QapKNnYNGeMXWWMJCAz0XPW/Bqf8cfIdqKUhJg
         /1m8bBNdBircJdWIQ/i1l/h86+EloLT2bcvI8I7C7FveccYFrvySbCxqbBornu5gP6nF
         pI1Uoe44Q4ZyCUivizeVfaXME6f50NQVuM4SsdIX4r/cBGGv0rpfX3ys/twY69yjMDk3
         7cylRII/7nVKHq3D2nJL+KsjRQip+7AzUDhAi8CWgIZ3IlKHYoLVCiJLdmIU6aMyAVWM
         2f2MSiPf2bdz69vsWWxq+rgoXn2fRAJ7E4Js9Z2sdBGxrskrbIHxiPB7JpEjx87yY1HK
         VOCg==
X-Gm-Message-State: AOAM532XObS7vKa9m79CCHb4LXxcDQ2RFaF7n2XdL4+i1ej+KbMOLbWt
        HnCGBo6D74+bur/raTseIZ31jA28f+g=
X-Google-Smtp-Source: ABdhPJxxr7pvHUaQKx0HyaSEx05yEFguzggKE0Lp1FyrnPJN92a7X7iwyOvF2xHfIDZmkOdX9D0fAw==
X-Received: by 2002:a05:6402:1341:: with SMTP id y1mr8152718edw.273.1611741123368;
        Wed, 27 Jan 2021 01:52:03 -0800 (PST)
Received: from [192.168.8.159] ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id u3sm552582eje.63.2021.01.27.01.52.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 01:52:02 -0800 (PST)
Subject: Re: [PATCH v2] MAINTAINERS: update io_uring section
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <4a6a96702bfef97cb5e6c8e7b5f05074d001a484.1611710680.git.asml.silence@gmail.com>
 <37700cc3-88ef-4b57-2ad4-004c136dc68f@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <20cd91a7-f72f-2bac-4e6d-12e0e0163fb7@gmail.com>
Date:   Wed, 27 Jan 2021 09:48:22 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <37700cc3-88ef-4b57-2ad4-004c136dc68f@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 27/01/2021 04:08, Jens Axboe wrote:
> On 1/26/21 6:25 PM, Pavel Begunkov wrote:
>> - add a missing file
>> - add a reviewer
>> - don't spam fsdevel
> 
> Applied, with an actual commit message :-)

I admit, my message was terrible. But now we have a funny
commit where I talk about myself in a third-person way.

-- 
Pavel Begunkov

