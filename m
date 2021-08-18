Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77FED3F04CE
	for <lists+io-uring@lfdr.de>; Wed, 18 Aug 2021 15:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237870AbhHRN31 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Aug 2021 09:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239148AbhHRN3V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Aug 2021 09:29:21 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20A8C061A06
        for <io-uring@vger.kernel.org>; Wed, 18 Aug 2021 06:27:41 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id g14so2130122pfm.1
        for <io-uring@vger.kernel.org>; Wed, 18 Aug 2021 06:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WPh0AUDeFGPoIS6JNbGxTuKAKhuF7QPahclxV98pNsU=;
        b=ZH5nQ67OU+nVj0iFcEM+GHfntaf0PqWTGaBAwvONWjDtM2XBbgfAAoCYtLDyFHO91p
         F9PBu3Hxz1Ym8V/mUqjkb00GlURI9uojs/Kcz0HTq5BlzLhTxKfMDPyyP7ZM/DmK0jie
         MRaw9cBAWP8lNzk9++8+0pWtrBgohcXjOE9uiG9qpgDZehUpDtEm/NI6GAx8QyLQtB+p
         bPqZubbtBixBSHMGeGbLTFJDHwFLZnJY4haUeF3UgTz2fv0K8OIruH5IyIZZopv5yEN/
         m9+NUZc1uIQiSbHTNpMbuC/lDwONnCiYwNKmt5h4yg2+ixPoVdGMUO+82um2lYDJWlUU
         nDYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WPh0AUDeFGPoIS6JNbGxTuKAKhuF7QPahclxV98pNsU=;
        b=f/iztu9Tub9hlaOVA+w0Oq4+vlwlD60iTQAi9eDzHLg61V7eZoalP9hanFTmjec2r9
         Mysmr7eMsUXwrTI00lLFOud/1btz6AD5V0Fm2fA5xN/KXlx/EXwSPvAl+RskOIiEmjqQ
         bUwBIEDzuuW6B242+xrNcl9jqkBzn+JJSaJAcyxrTNmaFrKBt2JnxiDmr4ZLYYOM7fpE
         FF9c09IHn0rzaQJkewqnfzHoR4AQ4aaWuxjFp3F0pcI+3zrGCBq00bvkOuSySpZZe8OF
         31/f5qouDDuHw1zArjwxp4k5POvNQNyER7s6uwiMtZNdkw00m3R0tsqdW1hpI9ntULgm
         iXYw==
X-Gm-Message-State: AOAM532S+RgiYHXUgdn9pIUq/1/jDuJAF3zwxnm2bmJi6CQeOAO7CCnX
        g4nVMnzCTSfctpGEu3ExjgvZ3g==
X-Google-Smtp-Source: ABdhPJzNGBxq39ewC1qXMPPT8LFdL03pyHtF/lhQNVTnE3wGuIBG2VsZuuuACys+SSPA0jWA54YChA==
X-Received: by 2002:a63:8ac2:: with SMTP id y185mr8870529pgd.179.1629293261235;
        Wed, 18 Aug 2021 06:27:41 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id j17sm6720005pfn.148.2021.08.18.06.27.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 06:27:40 -0700 (PDT)
Subject: Re: [PATCH for-5.15] io-wq: move nr_running and worker_refs out of
 wqe->lock protection
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210810125554.99229-1-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2cbb13f3-4ec2-8bd4-9cfd-0fee25954a3c@kernel.dk>
Date:   Wed, 18 Aug 2021 07:27:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210810125554.99229-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/21 6:55 AM, Hao Xu wrote:
> We don't need to protect nr_running and worker_refs by wqe->lock, so
> narrow the range of raw_spin_lock_irq - raw_spin_unlock_irq

Applied, thanks.

-- 
Jens Axboe

