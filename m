Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7AF304D20
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 00:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731617AbhAZXC4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 18:02:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393903AbhAZSBO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jan 2021 13:01:14 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8267C061573
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 09:59:30 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id cq1so2443639pjb.4
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 09:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Uuq4cBYCEVzA2iYkfUNGUOW9ea4xCO0RmrPc6dG3Bv8=;
        b=oHuH8WXrjo0usPpGtU+R0DrGAP078vYNgHUk/TM6HTMl+Z+j2SlxdCrq30Sirb6qsv
         +vYFKhbmDuIvfhnh7xcFHstGIZLIXUQhqyUXPMYnD8DHmzVXx6fyKlUoP1nRgC7ehdxs
         +Y4ytPJZl7uB8Y/oXixFkcFfyZ8g1UhftYZw27f1NDVU2OQ/EvDk3gyklzoVRtYDGRa0
         yiSitW2NHoRbBYeqEPYKqAj4pA0trLo+WRtspVuFttW62OSC/fvS386i+QFiWrjeXSOy
         mxwGLfCrYBZ2g0b4whjtHSg5fr4arkjQQWFx3GJUoczMNJibOhqMgFRQ/bKo9ubLLG9w
         AwrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Uuq4cBYCEVzA2iYkfUNGUOW9ea4xCO0RmrPc6dG3Bv8=;
        b=tXPmCXRPguEYYqNh1EAYDvoQeL/R8Ie3rF86G7kpczOTNFcb5YIZBSovB1P2OcHR5/
         z0j8eteU6CaCUOlQfkRZckkYXuR2XANFwoZZ6jxXqR1dIr67/W9MmgoWEhLX9Ck85gqR
         0JPrbWsgrCgwYgJfx1TiK5dTq+ZKvoLFAQe6kN0WmpWuXMKrTLvXKlucGYI0ffaRQ/my
         c8Xxu2f9WazdDZRpoEMPeBGqSw724R5y2PT6ob5FIRPCJYeHgx4pADvFdKNEPXIsLG17
         0B9J6+LmJzJLxVGbes4n0xscPP2TtY1UHUJRjuEriDL/LrR009J728ptOuMDY+w7JUdo
         36Qg==
X-Gm-Message-State: AOAM532MJIvpBG/nEp4UrQ6xhTIcIE4bKdDqXRstf7CmeKEtNZPIYEXN
        e4bgmxp7waO2oxw0835SjbWwxl12YwM6DQ==
X-Google-Smtp-Source: ABdhPJzVr1hwMfvoSTmo14Na0mEaLBS9VWNOnIbr/VOlFX62drWyZqzoT+4nCxgu8oVTTD3sQKwXEw==
X-Received: by 2002:a17:902:7b98:b029:db:fab3:e74b with SMTP id w24-20020a1709027b98b02900dbfab3e74bmr7282925pll.27.1611683970377;
        Tue, 26 Jan 2021 09:59:30 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id v6sm2832028pjc.57.2021.01.26.09.59.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 09:59:29 -0800 (PST)
Subject: Re: [PATCH liburing] test: use a map to define test files / devices
 we need
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1607430489-10020-1-git-send-email-haoxu@linux.alibaba.com>
 <12018281-f8d4-7a67-3ffc-49d6a1c721b8@linux.alibaba.com>
 <87b3001f-0984-3890-269b-1a069704e374@linux.alibaba.com>
 <81cf9b02-a6e6-6b9e-3053-a5a34d3cffb6@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fecb3d93-1dba-8c81-f835-1fa9a98042f0@kernel.dk>
Date:   Tue, 26 Jan 2021 10:59:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <81cf9b02-a6e6-6b9e-3053-a5a34d3cffb6@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/25/21 11:18 PM, Hao Xu wrote:
> 在 2020/12/22 上午11:03, Hao Xu 写道:
>> 在 2020/12/15 上午10:44, Hao Xu 写道:
>>> 在 2020/12/8 下午8:28, Hao Xu 写道:
>>> ping...
>> Hi Jens,
>> I'm currently develop a test which need a device arg, so I
>> leverage TEST_FILES, I found it may be better to form
>> TEST_FILES as a key-value structure.
>> Thanks && Regards,
>> Hao
> ping again..

Sorry about the delay - I have applied it, thanks.

-- 
Jens Axboe

