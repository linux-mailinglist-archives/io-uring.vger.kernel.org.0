Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9EB72FC885
	for <lists+io-uring@lfdr.de>; Wed, 20 Jan 2021 04:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbhATDMK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 22:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbhATDLl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 22:11:41 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C94C061575
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 19:11:01 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id w14so4584467pfi.2
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 19:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DJ7XLKWlkPXD3hRutcH+411CcW7f8fn1Apf/TFX89uA=;
        b=lNUCoQViRzGuh6jKsWAzmnRrTFVj8FaI+RmSvEKeOqpQNqL+coeLelbc7QPrB81ffs
         /SHtZ0eLd9eUvUGjGpo5wZDieRsr54igM+nPnLypNyH+0unv+9f8GyTNzmXryHjVEJ4y
         /Sm0+PQ4okVCc+rxlZ2OjU0G94I6HBew1v0TuQ2RlyXaYVGI4kZV8CmQIJOTFtGf0Dwo
         jeB5ZadFgKtnyduj8uAo9JVuVCfwqRVMBiWE9hqElf47AYFSTX7wXwl/AWf19fcphB9S
         n869dHEANQD4EcmffxxtNiVjUC7n7HlYrsXnMSv1JrqY1o8iRlsip762z2y+kJMe4H9Y
         nVEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DJ7XLKWlkPXD3hRutcH+411CcW7f8fn1Apf/TFX89uA=;
        b=F7Ypop5QwnW/ZYX5K0fkqAgBik3XBWckTxij3vogpTie42KvRcKa6AelE2XDaQz05x
         QTVLVsocXVgUBBwWD+FYmjapxFRcMzeBuHeEt96PflEKb6z2eJ1q0ye7gFZshOLjm9Rq
         Gy90ii3C54RbPD/cFTLabm3StQsDCibepV2jsCC9kKhPKineCkNO/JlmhyZVfgKo3ylv
         iKbLO9bVo+6i/DGv7mfwtqSqBryToMlAineFE3Woq+oljrk7bb3gztJJ5xP2OEJKBRfW
         LUs9amvX3Jd/FqxzD7IKOmZkhtbjtnfJqZvADg4WmEbFaVzCbUS4ref4QhHPo7cKnY2O
         sUTw==
X-Gm-Message-State: AOAM530DqmUN73EIRZ6Uf7n4K+eBAppYa4msoeMlT8iO5c+jDrUYApsw
        lTXvaDxWqjTGwrLdfvYbSE7AXw==
X-Google-Smtp-Source: ABdhPJxeKtSKenYlvVIjoXQ2Pog2P9WrLBf8HMAK6fCOzN9XrkXHXHeVVZygom50poJgkL2fBgCW+A==
X-Received: by 2002:aa7:8eda:0:b029:19e:c8c3:ed74 with SMTP id b26-20020aa78eda0000b029019ec8c3ed74mr7151710pfr.66.1611112260742;
        Tue, 19 Jan 2021 19:11:00 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id w11sm403915pge.28.2021.01.19.19.10.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 19:11:00 -0800 (PST)
Subject: Re: [PATCH] io_uring: simplify io_remove_personalities()
To:     Yejune Deng <yejune.deng@gmail.com>, viro@zeniv.linux.org.uk
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1608778940-16049-1-git-send-email-yejune.deng@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5f1d4f0f-9f1e-b532-6970-cfe0805205be@kernel.dk>
Date:   Tue, 19 Jan 2021 20:10:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1608778940-16049-1-git-send-email-yejune.deng@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/23/20 8:02 PM, Yejune Deng wrote:
> The function io_remove_personalities() is very similar to
> io_unregister_personality(),so implement io_remove_personalities()
> calling io_unregister_personality().

Better late than never, applied for 5.12. Thanks.

-- 
Jens Axboe

