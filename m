Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315951D6894
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2020 17:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbgEQPXC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 May 2020 11:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727973AbgEQPXC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 May 2020 11:23:02 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE45C061A0C
        for <io-uring@vger.kernel.org>; Sun, 17 May 2020 08:23:01 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id 5so508522pjd.0
        for <io-uring@vger.kernel.org>; Sun, 17 May 2020 08:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ARcj1uUB48FbteuMdUsFLSwb4pQE/AQvlz9aFRa1Ftk=;
        b=mFk49No5ggCzuCtMIXt9quTeqnBXTqM6tkZWOR/lJ73iZJoq/oI69Kac4pJ0I43ynh
         6pgP0N7dSuD6fP7YFJ27TN8C6nkVy1FlEWAkupwYEiK3eOOIkVDevxQEnrNu5NhgkuSv
         019kz+XIxIf/NSaer4esWvHHFeyEobF0S0SnyDzRxkieMgqz6+EHU98iGyDQ/BuOKrsY
         4+wPIWpmmK6eDSbaY/eCVTAx65Te7fM2UAgSuNTYTmXkOfkyFu8BVah4H9m8C9Y07l8d
         0qzCL4oJ8kEqmysCltdf5r74/kC+vhQODpk2xDrFlI6//Kjj+1mCh7RfH6eggRCi1FNS
         nUyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ARcj1uUB48FbteuMdUsFLSwb4pQE/AQvlz9aFRa1Ftk=;
        b=MpHFYG73JjfYSZa41vIlFZ1tr+wud918EmDyJnrCHDilDM1DQoFutTWLMxJvc4kbAg
         CdxdoRkjjJ/4O0bTBpw8jkrxAY5Y037ctr6v9KiTheqYVXatO4IbJew46FceSk82HZnc
         sbImTwxaOBrI0PGOUlU4V00DqTgSAAT2mRc6Nyu1MOINM2G0GFlX+QYyEXoE9WGIIXCi
         rRdTTvK/de+Z2Ut4Z9YKJCp0fQkAsfEsMaXCOO9m4EhYFtO2Qwnl6DxHBcsGWFxEccGQ
         NvUAuk4DhvAzTzCTgaE01HQZdrZ9ilJFt7B8oLlRL+v1banT5LESzT/AWmLmLzulAZcx
         CBlQ==
X-Gm-Message-State: AOAM533fe0qIWiFQRcpyvprXYjVmS1jxkMULAXZrtiAgIDOfZQYxYfRl
        nJ5QSIlDg4Ucte6O+9fIXPjhHg==
X-Google-Smtp-Source: ABdhPJxhlCgouCxFptr4eXyvWHC/HFKOrCWJ1DYR/hvquk54lcIgQPa1DipIYjqTKKb8IPEZLRPy8g==
X-Received: by 2002:a17:90a:1aa2:: with SMTP id p31mr14124234pjp.233.1589728981510;
        Sun, 17 May 2020 08:23:01 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:91d6:39a4:5ac7:f84a? ([2605:e000:100e:8c61:91d6:39a4:5ac7:f84a])
        by smtp.gmail.com with ESMTPSA id u9sm6407821pfn.197.2020.05.17.08.23.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 May 2020 08:23:01 -0700 (PDT)
Subject: Re: [PATCH for-5.7 0/2] fortify async punt preparation
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1589712727.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5ccf5342-c3f3-feff-f92d-dd580199ce30@kernel.dk>
Date:   Sun, 17 May 2020 09:23:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <cover.1589712727.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/17/20 5:02 AM, Pavel Begunkov wrote:
> [2] fixes FORCE_ASYNC. I don't want to go through every bit, so
> not sure whether this is an actual issue with [1], but it's just
> safer this way. Please, consider it for-5.7

LGTM, applied.

-- 
Jens Axboe

