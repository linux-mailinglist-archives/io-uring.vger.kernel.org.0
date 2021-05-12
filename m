Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177C437EE83
	for <lists+io-uring@lfdr.de>; Thu, 13 May 2021 00:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236677AbhELVv5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 May 2021 17:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390033AbhELVEl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 May 2021 17:04:41 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506EAC0610E6
        for <io-uring@vger.kernel.org>; Wed, 12 May 2021 13:57:02 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id l129so23647891qke.8
        for <io-uring@vger.kernel.org>; Wed, 12 May 2021 13:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=fUmgKpvM3TjwZN8rVbl/N4SL7bVVAib9UaaWICf1ILY=;
        b=FHpF2OM+ci2rPHyJS+qWdbL0Aj9VeLmpZozeDD1oCaI3xemzonLoJFHsV3Up/zcOMz
         ROdUXXeN2BMpaoa7nAhSXFctB02ZyewGnnLzEDHxOrZQeouFNbBrYrJDuyVYBNhJPHvu
         71wY6YzwejXNOqUHCqByMglYVAhrrGh2XqfmWc74MW+qGcagRALNmRT96QoX/qosuc9D
         4tJjyxgjryzxMzWzvJYBWFMn/FY+GGTzisnarhc4Ca0zkBU+W0bDI9dbtA05ex4c27jf
         3mEaMWYah1snwm4cQ1scQn77yIE+t3GGT9yp0l9cf4uADyxuPIp8+JRkVcJqIi+zo9WE
         NuDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fUmgKpvM3TjwZN8rVbl/N4SL7bVVAib9UaaWICf1ILY=;
        b=phN61FL//qo++fuW6pxBOW1Qj72ZHBsL+hs1fKWIts6/VZhLRsZFQevzQESwj//Nnn
         cKiL7gxXKvkkehv/+vJkEKMgiIsPiCaIOWCOxxWrjHc0ovSYma6EmTef58abojjQq5Qo
         5l63DODQ+KIBMKPIGMyBwSE4Ft3BLc2xNY628O1bYbwQd2oZVAw7oTtJ8h2va10FdNMo
         SGyuzaGX6d1t0PCZwbU25U64+XppSe3x49a/pJyBc1P7f1vsVUj0xrxsOvhivKTpga10
         5P0RHCaS+02VaKMEAWrC5TLVytjHrdSHNH+i4xfh+uRxC9K37FeHJdD6ozoT41DMQzcx
         ipwA==
X-Gm-Message-State: AOAM53330opXbGOgFeTqxbbpcDMkJaVC8vOj8nNnWzG8AjD0+lfObtPE
        GaWS4XM1SRk1ELFO5LAmcHYhAA==
X-Google-Smtp-Source: ABdhPJzY5dLOqY/MyBJw6D0GtpD0+Wwnyh8zcY6kSOe6AwquwAjt2P4UmnSjxJXKA4s/sMFCnFWlvw==
X-Received: by 2002:a37:a4c6:: with SMTP id n189mr30270865qke.221.1620853021523;
        Wed, 12 May 2021 13:57:01 -0700 (PDT)
Received: from [172.19.131.127] ([8.46.72.121])
        by smtp.gmail.com with ESMTPSA id l6sm889767qkk.130.2021.05.12.13.56.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 13:57:01 -0700 (PDT)
Subject: Re: [syzbot] WARNING in io_link_timeout_fn
To:     syzbot <syzbot+5a864149dd970b546223@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <0000000000004d849405c227da64@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bb6f7045-863c-ca86-3925-7d65dc90d5b7@kernel.dk>
Date:   Wed, 12 May 2021 14:56:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0000000000004d849405c227da64@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/12/21 2:28 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    88b06399 Merge tag 'for-5.13-rc1-part2-tag' of git://git.k..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13c0d265d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=807beec6b4d66bf1
> dashboard link: https://syzkaller.appspot.com/bug?extid=5a864149dd970b546223
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10436223d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1715208bd00000
> 
> The issue was bisected to:
> 
> commit 91f245d5d5de0802428a478802ec051f7de2f5d6
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Tue Feb 9 20:48:50 2021 +0000
> 
>     io_uring: enable kmemcg account for io_uring requests

Don't think that's right...

> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=144fbb23d00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=164fbb23d00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=124fbb23d00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+5a864149dd970b546223@syzkaller.appspotmail.com
> Fixes: 91f245d5d5de ("io_uring: enable kmemcg account for io_uring requests")

I think this one is already fixed:

#syz test: git://git.kernel.dk/linux-block.git io_uring-5.13

-- 
Jens Axboe

