Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD913F3657
	for <lists+io-uring@lfdr.de>; Sat, 21 Aug 2021 00:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbhHTWYa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Aug 2021 18:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232835AbhHTWY3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Aug 2021 18:24:29 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D32DC061575
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 15:23:51 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id v16so10948133ilo.10
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 15:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YwlCDWTPdBi4X23XirM49xlY90VtXkrawL2Lc+0Ilzo=;
        b=nvRjoXe6/MpWoS5tc/07Efdn8QPPA8uC4dddJc0wxVpBmscsjr267sJB3Vpec0BUlA
         ROt2wV7qXQ4HJdFwQXw2xu9B1YwBioQ0lUsSk0BiJJJCewyJRK199XhGyvTHmVS/vG69
         fssQwznsLxo1nf5zVHFqADrbCfzckx80YFvnzVPAlC+5fSVkVcUxi2yfVA612iKK1B4b
         v1//4LOhffRPOGVaqFPBlfiH83/iAdvmqXiFMVKXrJYlpVHf6fDQnU1Z+RLwlzF4Bdvq
         ahlWSv1PRXo2HHEZeXOt8fiLmJiMAzcDoRFby/OED5m1hUZtoEFVxsLPfCU4DP4vCWK+
         my/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YwlCDWTPdBi4X23XirM49xlY90VtXkrawL2Lc+0Ilzo=;
        b=Qb1Wta240cfnVZ1869LqkmhB2bzS2CEjGHwvYkkiVIcg8ERmHSa+2GkhxP54jCfZRj
         JglrKhtW/2yltoxARJ2yCFHqqcHpfsunjjwTQeVMUSH9NW4G+J7AunY+CsQALDgZSNbC
         pVCDlWGfWg+1OT0XG/RGB1HDsknjA9Esi5zxkCDEOCw/OdO4cXrCqOSQgAhJJgIUH10p
         wD6572EAOKBkpY6TGjl19xtW3WSmR31ox5NMXJuJzlI2Rcpptt4IHnEej/jqoJjSbLK7
         1FXUY8G84xlBrsz0YDNiBMT0BdjC23YLdF1QVSL2Xg3LJ6HHmZa0LCwd+jxmgJRf1sO0
         iuCg==
X-Gm-Message-State: AOAM530aBlw6QxZz2X5wMOmf8x57WK2Lks2XjaF+MSjJFlXAOv6KZMvQ
        0gH/eAWlWyYOYnTPkPlX9Q96lg==
X-Google-Smtp-Source: ABdhPJxcisGfkqFNp9qRJV/du0mBbBV8Pp7IYUs0XcqJNBJetKLq7Oozr1yHusRU8KDaQD2ZSqmzbw==
X-Received: by 2002:a92:1944:: with SMTP id e4mr15272061ilm.186.1629498230286;
        Fri, 20 Aug 2021 15:23:50 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id s18sm420999ilp.83.2021.08.20.15.23.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 15:23:49 -0700 (PDT)
Subject: Re: [PATCH for-5.15 v2] io_uring: fix lacking of protection for
 compl_nr
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210820221954.61815-1-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <787db207-fc62-430c-d0ff-4fc15e957b48@kernel.dk>
Date:   Fri, 20 Aug 2021 16:23:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210820221954.61815-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/20/21 4:19 PM, Hao Xu wrote:
> coml_nr in ctx_flush_and_put() is not protected by uring_lock, this
> may cause problems when accessing it parallelly:
> 
> say coml_nr > 0
> 
>   ctx_flush_and put                  other context
>    if (compl_nr)                      get mutex
>                                       coml_nr > 0
>                                       do flush
>                                           coml_nr = 0
>                                       release mutex
>         get mutex
>            do flush (*)
>         release mutex
> 
> in (*) place, we call io_cqring_ev_posted() and users likely get
> none events there.

Applied, thanks.

-- 
Jens Axboe

