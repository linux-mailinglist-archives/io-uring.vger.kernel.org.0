Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3F224AA66
	for <lists+io-uring@lfdr.de>; Thu, 20 Aug 2020 01:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgHSX7P (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Aug 2020 19:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgHSX7O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Aug 2020 19:59:14 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17D7C061757
        for <io-uring@vger.kernel.org>; Wed, 19 Aug 2020 16:59:14 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id 2so165877pjx.5
        for <io-uring@vger.kernel.org>; Wed, 19 Aug 2020 16:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j725WwtlabuWLqYj1RC375p05vg0VyfQqgbjcc1E20U=;
        b=gpbMdWDd1F41eqn99wPm8l1j+W+XZF0hntjY+itZgt1YrMn3B0aYpfCz8ntslu455t
         zCA3i8tvlgm86rWGc9kby93dNCmPT4UZiXntTOyW0UgDRGlkSxEofeSqiJmS9Huo9ciu
         +evIAm85FN7LOrEj6vCWYsGTs6oROLaWqdpq6f2Q9PseuFdAbXeJ6sDoLMa8KZ4rAERk
         TakB4nUZINTiPR8I3+GZq9XK0W7PsZ58paVDPEpWm0lz9NOM/qOrtxGwUilLN4pOVHPi
         Tb+ZHSqwtUC9L80dOHq8IOA3Z9bZNDMjd7bn83pYzDLZzpcf3DbWsGO1slw0rHB4EvQ6
         HLdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j725WwtlabuWLqYj1RC375p05vg0VyfQqgbjcc1E20U=;
        b=uYCYc9UE7a5FPZ5am+GmcFlmVpo08Zxfpp5PG0Y4O1gG9Q6qrb8BcpWZxlCokaYn1q
         Yh0zOP+ztAc+HT6sMqtKm/ysHXb2mlU2ltQoAziaU6skOFHyJ8tP9E0IMLBdZE2ouJ9J
         WWW2pX1Jewl2QVpfHwnELmMBnyIBHXeD+Mj6qmSoExdK05OGkxBNuhvZhWCIG3hsSNK6
         /IIgGRgnri4+lM4+vjr+xylsruYnm3a4NWt7KumKXVR9hrAepScu8jqcKJKc30Zx+mQW
         oOXd+oEN63LVPkjWz5y8iufU+YL51kRVgkaWwTkTO0GiveJO2/DxxF/jFkhR+i+VrwqP
         ZQxQ==
X-Gm-Message-State: AOAM532zLU1mKpcfj3Sao7wXKq737BLJ9c92aanDWvPZAKS4/WD81jyu
        V2mJDce5NzyoiURie2LNGe1ihA==
X-Google-Smtp-Source: ABdhPJw3hq4CSx5myJjCPwUfsMlICDiiKHt0KId3QeTo6QktX+l2OW2kI7gcZxdmBb5Y0K2woEiiAA==
X-Received: by 2002:a17:902:d883:: with SMTP id b3mr508688plz.154.1597881553795;
        Wed, 19 Aug 2020 16:59:13 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 22sm300501pgd.59.2020.08.19.16.59.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2020 16:59:13 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
To:     Sasha Levin <sashal@kernel.org>, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, stable@vger.kernel.org
References: <20200808183439.342243-3-axboe@kernel.dk>
 <20200819235703.AA48120B1F@mail.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <073069ae-6de9-811d-b22e-c4d992ba3110@kernel.dk>
Date:   Wed, 19 Aug 2020 17:59:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200819235703.AA48120B1F@mail.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/19/20 4:57 PM, Sasha Levin wrote:
> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: 5.7+
> 
> The bot has tested the following trees: v5.8.1, v5.7.15.
> 
> v5.8.1: Failed to apply! Possible dependencies:
>     3fa5e0f33128 ("io_uring: optimise io_req_find_next() fast check")
>     4503b7676a2e ("io_uring: catch -EIO from buffered issue request failure")
>     7c86ffeeed30 ("io_uring: deduplicate freeing linked timeouts")
>     9b0d911acce0 ("io_uring: kill REQ_F_LINK_NEXT")
>     9b5f7bd93272 ("io_uring: replace find_next() out param with ret")
>     a1d7c393c471 ("io_uring: enable READ/WRITE to use deferred completions")
>     b63534c41e20 ("io_uring: re-issue block requests that failed because of resources")
>     bcf5a06304d6 ("io_uring: support true async buffered reads, if file provides it")
>     c2c4c83c58cb ("io_uring: use new io_req_task_work_add() helper throughout")
>     c40f63790ec9 ("io_uring: use task_work for links if possible")
>     e1e16097e265 ("io_uring: provide generic io_req_complete() helper")
> 
> v5.7.15: Failed to apply! Possible dependencies:
>     0cdaf760f42e ("io_uring: remove req->needs_fixed_files")
>     310672552f4a ("io_uring: async task poll trigger cleanup")
>     3fa5e0f33128 ("io_uring: optimise io_req_find_next() fast check")
>     405a5d2b2762 ("io_uring: avoid unnecessary io_wq_work copy for fast poll feature")
>     4a38aed2a0a7 ("io_uring: batch reap of dead file registrations")
>     4dd2824d6d59 ("io_uring: lazy get task")
>     7c86ffeeed30 ("io_uring: deduplicate freeing linked timeouts")
>     7cdaf587de7c ("io_uring: avoid whole io_wq_work copy for requests completed inline")
>     7d01bd745a8f ("io_uring: remove obsolete 'state' parameter")
>     9b0d911acce0 ("io_uring: kill REQ_F_LINK_NEXT")
>     9b5f7bd93272 ("io_uring: replace find_next() out param with ret")
>     c2c4c83c58cb ("io_uring: use new io_req_task_work_add() helper throughout")
>     c40f63790ec9 ("io_uring: use task_work for links if possible")
>     d4c81f38522f ("io_uring: don't arm a timeout through work.func")
>     f5fa38c59cb0 ("io_wq: add per-wq work handler instead of per work")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

It's already queued for 5.7 and 5.8 stable. At least it should be, I'll double
check!

-- 
Jens Axboe

