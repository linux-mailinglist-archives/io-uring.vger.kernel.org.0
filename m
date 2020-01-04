Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C02E13038C
	for <lists+io-uring@lfdr.de>; Sat,  4 Jan 2020 17:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgADQ2L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Jan 2020 11:28:11 -0500
Received: from mail-pj1-f48.google.com ([209.85.216.48]:50719 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbgADQ2L (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Jan 2020 11:28:11 -0500
Received: by mail-pj1-f48.google.com with SMTP id r67so5785892pjb.0
        for <io-uring@vger.kernel.org>; Sat, 04 Jan 2020 08:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=HR8fn/Kui9dOlctvDsihMbg4IEAJWsL25SAPKCnkgAM=;
        b=P26v2AhzKZVyrWYolHOp5wmUkdd8/DQ66xtT7zgET9tjgZI5V5nmFOx19+dt8/CZcj
         voDNfmlRM0pStOju54lCQVnJkXdvo2tKeYO/UlXUijRz2gXraKZFEoiz7rO1C8K+g9F2
         ciik4196jYtNrlDZL3zBrXf+TwQuGnsI0n8rYMjKgxaCotwS5f04QHM2D6TMP8Bf61iI
         dPd0PoOjc2ZBE5m7bHa9axPSd0RMpWmYPerIpNX13Ikl4KmgDVZ2DT3p0WjqdQD3qXe8
         6ehxu4WllQInGFTzkdr/ovj1SzqkiDbhXxdLudfeY1jTewcccBii0VCBI6YrDbxIG4XM
         f83Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HR8fn/Kui9dOlctvDsihMbg4IEAJWsL25SAPKCnkgAM=;
        b=SeOlEKPjH69rR/g7QgjecqL4IJuZRFlOiyVJs/9o3zquGK3pAF5Uhlo6BpjG7yUlCe
         wxmQsVyVMjB8WIUiyjxilWMSj8DtADMRob4iASMFhkMQqeronMgRvq8OlynIeFMfihEq
         jbm8Abyqcou89dfX41MqdZOcx/eCVI/3mD81A7yJFUo7rP4kJb/DTNs9GP57wpn7OiaH
         /eJMQrpFzAzPZtQltdiZ69IDQk0iZjiFduhxVmvoqycDPuUavmuj8d8hUoeXB7bCP9yq
         pM25R6yPj4ajoL35KYvTb/3MeFM1rUHr1L2jb+pXKARrwyXh3oV+EKt+k7ZvWM2IORBq
         X7/g==
X-Gm-Message-State: APjAAAXjNQI1dUd9+Wu+LY63I12iIBMubxfz5nx8FTdJr+XWBx2NeFj4
        6LnlYLtlf0T+oeFN+uulfYk16GQ5NePz3w==
X-Google-Smtp-Source: APXvYqwNizOHo1icih1JIMEISrJdAvBefAlJ3GaEEi4WJRSb9MRXn0wUL3+8yyQbLbDoE2tIluYfRw==
X-Received: by 2002:a17:902:9695:: with SMTP id n21mr76749529plp.192.1578155290435;
        Sat, 04 Jan 2020 08:28:10 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:c432:634e:2cbb:b7c? ([2605:e000:100e:8c61:c432:634e:2cbb:b7c])
        by smtp.gmail.com with ESMTPSA id v10sm60524635pgk.24.2020.01.04.08.28.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Jan 2020 08:28:09 -0800 (PST)
Subject: Re: SQPOLL behaviour with openat
To:     wdauchy@gmail.com, io-uring@vger.kernel.org
References: <20200104162211.9008-1-wdauchy@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fad9c723-88ed-355f-6938-71db6db948b4@kernel.dk>
Date:   Sat, 4 Jan 2020 09:28:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200104162211.9008-1-wdauchy@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/4/20 9:22 AM, wdauchy@gmail.com wrote:
> Hello,
> 
> I am trying to understand SQPOLL behaviour using liburing. I modified the
> test in liburing (see below). The test is failing when we use `openat` 
> with SQPOLL:
> 
> cqe res -9
> test_io failed 0/0/1/0/0
> 
> Is `openat` supported with SQPOLL? If not I would expect -EINVAL as a
> return value, but maybe I'm missing something.
> note: I also tested without io_uring_register_files call.

sqpoll requires the use of fixed files for any sqe, at least for now.
That's why it returns -EBADF if the request doesn't have fixed files
specified.

So it cannot be used with opcodes that create (or close) file
descriptors either.

-- 
Jens Axboe

