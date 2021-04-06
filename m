Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4652C35581C
	for <lists+io-uring@lfdr.de>; Tue,  6 Apr 2021 17:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbhDFPgb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Apr 2021 11:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242497AbhDFPgQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Apr 2021 11:36:16 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5A4C06174A
        for <io-uring@vger.kernel.org>; Tue,  6 Apr 2021 08:36:08 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id il9-20020a17090b1649b0290114bcb0d6c2so9894039pjb.0
        for <io-uring@vger.kernel.org>; Tue, 06 Apr 2021 08:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WdYzIWWPT1zEKOS52e14gOou58H5K/Zid4PzKRvhcSI=;
        b=AONoYLHXNNtSReKnVmVYFfS1JWGOXf28I8DL9s2Pf6V4xnd0GKJYSG490qWTYQiEvo
         8wpiGkBPo0ANo/2Bdeyso/412ISdpaVa2HEVrBob4+lfKB9A0bfU2NvVLbSyhdJnv6mC
         TvevvC19Mkyifo3t8Zr6W3wPWZKAJNh39B+LFBAnTkTeQhauPbm5VY5Tnw022poIStmT
         EGcWhTGRddo6h2eaNGOj49KDL2FJvbfq8aJT97tEdspw6NHPY00rv6L+zyRJDKIg7+rP
         AwZ2b19c0hveG+iNFWvUl9HF3hdqvIf6Zf3h7i5HKUnZMAPWbDeoQGydIXVh0lRneO0y
         8XDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WdYzIWWPT1zEKOS52e14gOou58H5K/Zid4PzKRvhcSI=;
        b=EL0ZG/5CTSFgKvPsBtDbTAlvrvNoqNa8QwsCHGxgZJhUCAVVxOoeOlxtn9/3/ouBv3
         6AyjnLoJMuPwiqwJFHMKPulkPkwgLC/XY8nInmrFL+smUqrkdfVTJgFCso1p93RzgDLD
         njy08ZuMxGS7WbTeQflKst+wO1JULGBOqxbjhx0WeLF6YUJXy/IJWvqpzh+C5BAGRD6N
         rp5UVbo9jYTcb2sq/cjKX1tkqh/TiWdMT6rPe2iSMBSFrdLephMkwD+4p0Edu/6pJstb
         IJ+xCICzE3F+MLD2E/RM6igo4VumUg0k34zsFYQgLH73uQ9odQ543ljWXZz/AisX1qTx
         4qLQ==
X-Gm-Message-State: AOAM533daHKM2ufi3J2F1M4bxT+SsnUj0e/HZ8hS7GAOYDvgn48l9Zx9
        BNKcXg2tyTW45/tcV4DTmtr8sYel6ZnEvA==
X-Google-Smtp-Source: ABdhPJzM3OglZ3luH60VD5bS7Awbh5SlZR4uJCvxN0PLB3HSE1+zhG5PCekWMK+gesUiYNCtcT5QOg==
X-Received: by 2002:a17:902:348:b029:e8:dea9:f026 with SMTP id 66-20020a1709020348b02900e8dea9f026mr14680745pld.19.1617723367930;
        Tue, 06 Apr 2021 08:36:07 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id p1sm18564272pfn.22.2021.04.06.08.36.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Apr 2021 08:36:07 -0700 (PDT)
Subject: Re: [PATCH v4] io-wq: simplify code in __io_worker_busy
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <c1f66f6e-64b1-4c65-3b0c-e87d705adb26@kernel.dk>
 <1617678525-3129-1-git-send-email-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <317149f8-e8e5-b03b-be6a-961de2cf19d6@kernel.dk>
Date:   Tue, 6 Apr 2021 09:36:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1617678525-3129-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/5/21 9:08 PM, Hao Xu wrote:
> leverage xor to simplify code in __io_worker_busy

Applied, thanks.

-- 
Jens Axboe

