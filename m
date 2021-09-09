Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF994058F6
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 16:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245192AbhIIOZ5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Sep 2021 10:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344697AbhIIOZv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Sep 2021 10:25:51 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A99C120D7C
        for <io-uring@vger.kernel.org>; Thu,  9 Sep 2021 05:58:16 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id g9so2113333ioq.11
        for <io-uring@vger.kernel.org>; Thu, 09 Sep 2021 05:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xtXEmCkgLjj2ICcn/5G5ZZlK2SnZW1IcakfDyVuInEA=;
        b=hB6xV2U22F35EshU9H4Y6s6DCeylbHAC/VYNgUqb5P03tlfg8suiMyms6Ulz+KWw7o
         PGzgv8eA5+p9RnyJctVqWIv2Xyf++kBehqOOaYe34EIRSDjYzfjAwYE3HiYVyhQ9rHGU
         boS/wzrrgtIefOtlhcfW/UrPgIZFc0qHYbxhFQF1HmcbKBGk5vTqPQBtLqHXV0Pd45IC
         niqe22DM+7zzFfTjKljcBcDwdfJq1boitMqFKRGjL+tVpI8xaH8VYiHRnMcbSrt3Fj7g
         ALLEfHozSHiTTSc6fvxJNa/e/ifhwub0NnAkAsAT1DcOUWiLPQW+vaBKX8V1oNghIb+5
         90cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xtXEmCkgLjj2ICcn/5G5ZZlK2SnZW1IcakfDyVuInEA=;
        b=4UnyGflc+eq4WnMuwctKEOa6PQu1WJOG/lUFGg8ZprpiCW0GpqJ1iWpAkHkNMcRdjg
         KyKCwY+EVH2YTKN5qM8eh6fhKyS/4jEkmXYsVswrcYd/bY3JqOzcqCkwiqqJh3HbuXiE
         KV6yoOoOAcVF/EKzs5mCqtuRYpILP763izy/6Z99dNPmu4yDqiYjt4dINDhibPakm3N1
         qU/4tUHdSD6DfijUJLN2Tb6ifRPutyaGHG5puJxVf9r2KDr0VXLJ/TvwP2Lx5T6MynYR
         yolw9F/DBaRiDhIfwR6AaNCZzD+tpKiSWNnOdV7SktBFf6XwcS64zO9QgFcM0WznbquA
         HKaw==
X-Gm-Message-State: AOAM531tihYHO52/fjHyL2613K1Fb8TDqz+U7JdLPxoBt1qActstl0GG
        +mPFsO68mOLYv98L1NJKYKJD8g==
X-Google-Smtp-Source: ABdhPJyC9BpbGwDqu0GxL7mOtDLS4R168asvGRVWOhfSos1bWN9ugSXqhGImveQTNEcWGV/AFqBQZg==
X-Received: by 2002:a6b:905:: with SMTP id t5mr2566323ioi.209.1631192296197;
        Thu, 09 Sep 2021 05:58:16 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id a4sm837736ioe.19.2021.09.09.05.58.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 05:58:15 -0700 (PDT)
Subject: Re: [PATCH -next] io-wq: Fix memory leak in create_io_worker
To:     Bixuan Cui <cuibixuan@huawei.com>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, john.wanghui@huawei.com
References: <20210909084919.29644-1-cuibixuan@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2a63f105-c2a9-7c57-3101-ba7779cccb6d@kernel.dk>
Date:   Thu, 9 Sep 2021 06:58:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210909084919.29644-1-cuibixuan@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/9/21 2:49 AM, Bixuan Cui wrote:
> If io_should_retry_thread is false, free the worker before goto fails.

This one is incomplete, see other postings.

-- 
Jens Axboe

