Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771E31A6B58
	for <lists+io-uring@lfdr.de>; Mon, 13 Apr 2020 19:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732780AbgDMR0n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Apr 2020 13:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732778AbgDMR0m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Apr 2020 13:26:42 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E7FC0A3BDC
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 10:26:42 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id y12so3321680pll.2
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 10:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=onQLPHqKfBqwY5c0/DwuP7FcKzuXmwJhJ1O6LA9f3bM=;
        b=mGnkkKOS4b5DQECbU6hmNYWkb3DRmDB/3dZr/6HWLOn04YPZNeykGUpW9GU+X3iM68
         OcMcqR507gVUKCiFY9a/I4ptQIYkb06VIna3dWJY0atBXaeKVE+LSOCB8MfeLQz7Rg5h
         ZNcXQv8hyJ8fqXLU4HIyxICFnq30vQlJ5JsIa6+Npb205HuMArtLj8Xzh4eWMfKZbWO9
         mTlsH4IpSMOcLKQB1KAKKJhQ8auM3ypDKU9HHcsJTRATwHIRmmyVL6/GBgxE5/qIC0MG
         GnJC17fzIUaK7IPkfCeoO906Bfms2qCSA0GHF+sOIFQoqCv9MvpjwAKpoeZvMLPSDJgl
         3V1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=onQLPHqKfBqwY5c0/DwuP7FcKzuXmwJhJ1O6LA9f3bM=;
        b=ff9Hn1Rwb23d06hsPMnU1VUgcuTUJNbv5TYa9A0DujbV6Wmnn6alYXfeg8+0GZuky1
         OojHzpoP0A+HmZtRIh1VQgy37L6FHr/jU0mThWtAnadQLxRApmg1g4yEOiXsCLV9m+Ng
         fblPH/EQb5fuayx9nGfJA+4axVgYlMedrKf9uSBs9L0prtvd74LSdsY2ABFvx2qmO8RA
         aQf6a7Fin2KDWRpt8jz/zZnqpBeoOqEb6lKNMEiLhdkukmL7tmPCNRrhN1d137mdPPwr
         yKorfl7nlzx77HbN1U29rkH9+cuE8wEDeatISYqQ27WtNxsBIQTZTi7coi0ahVO0/nkb
         b8ig==
X-Gm-Message-State: AGi0PuYOTjcdUgooij57/jzbuC1zCzxx05VJmeubApIgUnVZkGW45hTF
        JGmFnyEzZHldLc+AcP99m5rNq8wTm8GqHQ==
X-Google-Smtp-Source: APiQypKLXrYy8islFSHmaqXEg/2jxJKyZHzmXrb3LGBIRmgfNhz1uBblDmkMUT8JkiVyNF+T+DgRmQ==
X-Received: by 2002:a17:90b:384c:: with SMTP id nl12mr22275602pjb.87.1586798800878;
        Mon, 13 Apr 2020 10:26:40 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id e7sm9266413pfj.97.2020.04.13.10.26.39
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2020 10:26:40 -0700 (PDT)
Subject: Re: [PATCHSET 0/2] io_uring async poll fixes
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
References: <20200413172158.8126-1-axboe@kernel.dk>
Message-ID: <cbd57dda-a32d-b5e3-c123-92233cbef2ca@kernel.dk>
Date:   Mon, 13 Apr 2020 11:26:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200413172158.8126-1-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/13/20 11:21 AM, Jens Axboe wrote:
> Just two minor fixes here that should go into 5.7:
> 
> - Honor async request cancelation instead of trying to re-issue when
>   it triggers
> 
> - Apply same re-wait approach for async poll that we do for regular poll,
>   in case we get spurious wakeups.

Please see v2 instead:

https://lore.kernel.org/io-uring/20200413172606.8836-1-axboe@kernel.dk/T/#u

-- 
Jens Axboe

