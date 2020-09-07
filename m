Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F1426052E
	for <lists+io-uring@lfdr.de>; Mon,  7 Sep 2020 21:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbgIGTel (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Sep 2020 15:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728622AbgIGTek (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Sep 2020 15:34:40 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0AEC061573
        for <io-uring@vger.kernel.org>; Mon,  7 Sep 2020 12:34:40 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id b17so4713515pji.1
        for <io-uring@vger.kernel.org>; Mon, 07 Sep 2020 12:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=2f0YKLV6lJkUAsHIzHpdPY7Q2MsoZV9diQXrIJMqpvM=;
        b=lRnGgE+PcLm17KtXMFIfP1yb3tANtMQyfJb/h4n2UMmTia6y/iTkG0rZVcdg1zv4+T
         8smTXsSV+hKbpBBlAASI34F3J5HNvOizKFmzzei91gvfMtNagvZgLGb1FvVK0npwjSf5
         xXuofG9Yrz8xwQUkwLCZNOlC1Ypg4KJOzSNXPD02ulIEMc0hdIfzkymyFw3TMUNYdmCM
         bBiwYj7QdNvkfmIZZLJKvTP1Qvg2npnkUWJK7WlRxV72OmMoxn0sgwG8KCh+sxgOuIV6
         BRgHAQOvcoq6gO/YTb3JtkfqCHZ4j5QAE5Avnnl2gqBlbLKKO6iI15vbV20IvueISxTj
         EDeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2f0YKLV6lJkUAsHIzHpdPY7Q2MsoZV9diQXrIJMqpvM=;
        b=kwP1oZb8p4XMwlAc3RX3wjUH6FYiPRf8NCqHyxzA5pWFcbNjyssbQV9Xb+/CQh2Fb5
         htBgXxSRxPsmiap0q7ZF9/4LskMv0dXsKffAfNBvrmDl77yha9gz10Yct5o4RWEvTFNU
         TnkXHY2lrnCXSHNNwMPrbVEh7npUoKgoBujc643YH3WGLVfo6hkXs1exZbBAB5b96+HM
         dL4ECUDE1NOv1eLs1Oqs4wujiBeNQMMmzngKMxJgLzKwJJfOHXot1nChRKSbIOe4eAIb
         FziBL3gFx1Bvykkx5yAqJ5GbyJIXRzGRIK2drF1vRmfkWXdraLN8A1JdTixh1FWJZWbM
         bTYA==
X-Gm-Message-State: AOAM530+ubY49ZSmRJQU5PHvSSC8YH3VnPfaM3j2kewrxvkpY6/+w/yS
        B9lC6BQVO+YWFnYs5HLBZRlKv7zCfhDwABJn
X-Google-Smtp-Source: ABdhPJzYSsBlclZEiaqiM/Mi66PXuKug+8Lt9H6HwEqlVzbOeHph1LiLrX5XOL/7f4yvnRsQWoAiUQ==
X-Received: by 2002:a17:90a:658a:: with SMTP id k10mr707792pjj.48.1599507279741;
        Mon, 07 Sep 2020 12:34:39 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x192sm12054431pfc.142.2020.09.07.12.34.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 12:34:39 -0700 (PDT)
Subject: Re: [PATCH 2/2] runtests: add ability to exclude tests
To:     Lukas Czerner <lczerner@redhat.com>, io-uring@vger.kernel.org
References: <20200907132225.4181-1-lczerner@redhat.com>
 <20200907132225.4181-2-lczerner@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9123fe5b-f57c-258a-64c3-71fa4859040b@kernel.dk>
Date:   Mon, 7 Sep 2020 13:34:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200907132225.4181-2-lczerner@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/7/20 7:22 AM, Lukas Czerner wrote:
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

This patch really needs some justification. I generally try to make sure
that older kernel skip tests appropriately, sometimes I miss some and I
fix them up when I find them.

So just curious what the use case is here for skipping tests? Not
adverse to doing it, just want to make sure it's for the right reasons.

-- 
Jens Axboe

