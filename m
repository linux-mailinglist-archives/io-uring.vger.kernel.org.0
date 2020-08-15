Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B927245325
	for <lists+io-uring@lfdr.de>; Sat, 15 Aug 2020 23:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728887AbgHOV6v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Aug 2020 17:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728940AbgHOVvz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Aug 2020 17:51:55 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D42CC0612ED
        for <io-uring@vger.kernel.org>; Fri, 14 Aug 2020 20:39:33 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g33so5441153pgb.4
        for <io-uring@vger.kernel.org>; Fri, 14 Aug 2020 20:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/Bj4o9pDib5Ybtf3Dv2iMx/u8MnqGFZ+DHFUynerhSY=;
        b=g2zPTO3aNnSr4iNZJTG6vRbSehQJDnx7dXAm+ALTqF6vK98FA0ZWMmH6GuuVxtKayX
         et31R0/sf0g56rl+WyzsGmiVFc23syMvkxp/D2yXGwopaO2CEeqzslBsgx7QcJxqJgAY
         q+Rde9WsJBqyO7bM/WsgIcqePAHoUZAcuyVGmYQECC5MPe1D3dPjjAhCo2l5XF9+eUQr
         2kKROdCXjEToTIy/b6suTrNd+O0w6K3b+dduL8SrrmM6HqDB0Xqw8sn6if/pQ3NHciD4
         VoF/jH/fOcC0C0zCUNsK1xcCvf0QL0aFgN2nydQinVVs9Or95rF6I1n8oIL12fbhBNRw
         8qmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/Bj4o9pDib5Ybtf3Dv2iMx/u8MnqGFZ+DHFUynerhSY=;
        b=hnNWx1ksvXrzU3c8CIEUg3sgs4dX9gXP112vpA9MlpBW8ilRX1Cdu63lcG/OA23qrl
         NNf6XjELi5yQgbf5uy2LD+yINofKYq2FIt1cB8SfKjFBYWG8GLvDjwkWvCtNw2026sv7
         zrsBmnfnec1WPfqiyGCtAydXGEc5uLoW2gLggS0E38t1mNB1StamPUzOXaCsm6vD+5pw
         FKssA5D8VlDki00DuTcrMHv//psNy7seRkLR6PNyel38aATawY1tMhHQZ9ansViSbeaB
         B8h2QA7wVu3H0SGG7Gc/2POjox/8eADVvpt9AJTMqYuvQ2j0XMiIBk4fqnQMo31QkRU0
         XFYw==
X-Gm-Message-State: AOAM5308nVw2clNdJMqXdKEmGllNr0V7TwlTjOLjAevQRXDvI7E2rGbG
        /CF07lpGZBk46gvuWQIuIpxzQA==
X-Google-Smtp-Source: ABdhPJwz2akceWT1kySNWZG25VKmmx3lru8Q05rrAMJe2USXvhglR77WkuEyePJwNvQ7Bg11keV2qw==
X-Received: by 2002:a65:6108:: with SMTP id z8mr3636999pgu.266.1597462772747;
        Fri, 14 Aug 2020 20:39:32 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:1d3c:200:51e5:4912? ([2605:e000:100e:8c61:1d3c:200:51e5:4912])
        by smtp.gmail.com with ESMTPSA id l62sm9705270pjb.7.2020.08.14.20.39.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Aug 2020 20:39:32 -0700 (PDT)
Subject: Re: [PATCH] io_uring: NULL check before kfree() is not needed
To:     Wu Bo <wubo40@huawei.com>
Cc:     io-uring@vger.kernel.org, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com
References: <1597461912-262969-1-git-send-email-wubo40@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ee1e6a97-ccd4-9d2a-3e4d-853524f4907f@kernel.dk>
Date:   Fri, 14 Aug 2020 20:39:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1597461912-262969-1-git-send-email-wubo40@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/14/20 8:25 PM, Wu Bo wrote:
> NULL check before kfree() is not needed

While it's not needed, it's also slower. Particularly on AMD it seems.
It's on my list to ensure that kfree() is an inline that checks for
non-NULL before calling the real freeing function.

Should get around to that soon, as this is probably the third time
someone has sent this patch :-)

-- 
Jens Axboe

