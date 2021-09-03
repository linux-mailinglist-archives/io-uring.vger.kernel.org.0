Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB63F4001A5
	for <lists+io-uring@lfdr.de>; Fri,  3 Sep 2021 17:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhICPCt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Sep 2021 11:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbhICPCt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Sep 2021 11:02:49 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50050C061575
        for <io-uring@vger.kernel.org>; Fri,  3 Sep 2021 08:01:49 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id e186so7083068iof.12
        for <io-uring@vger.kernel.org>; Fri, 03 Sep 2021 08:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vsAdjRKEHGV750YfdrCYBFH7TmnfsM+ZoUvUOontDc8=;
        b=F0oe/0fo4UVwJ86M7TXHL/IEonUATUHerLveqD0nGFuoNFAIfybttIlJHR4RC7lkbp
         Bp3SzjyelqgI4z6EHpKil9oO00IJ1LRInMUsS0lM07GqeJmXQl0endxCAkUFRrlER1De
         MA5kZmQF5SAm2MkslAJdWh6BARj3vlRld2c+tnPdXDg2BfUQK65nW4KH0MjxDBCqz6Mc
         sGwBzlRleB77K4ON7+GqYYkmA+wsd27Vo6WjuZVj42+fzGdNb8wMj3XaFUXW+5co7HPv
         4kbRGSO55hQ4krMI+JGYcv8OBLd7O/tf91nZB9cj6gCmauYoPJpD4jh651rgpGuMREHg
         ZJXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vsAdjRKEHGV750YfdrCYBFH7TmnfsM+ZoUvUOontDc8=;
        b=D9oCFgDnrxsohjvq1At8rJoclK6D3dGX/19CA1b8Cm1XDU+JXTKUlYrtScfYYUN3Fj
         Jr5lGlc1VJWFLDdkSpAotgyprVyWe9iX65rZcCX3UIg6lhKGAW7ramiXNv0fR5dvYACs
         DtwjFWGDluK3KOS8Dmv4dVkYwKAUvxpvlmbSUts13qSWSzvkLdI1odYDvicBA5fsxLt5
         08DY4DGf+Yr6YflVYFzmHOkqVgzs/Y4xUy4+aNN1kl8fKubZBwHa9uHZGPmL2sNOmQCA
         AOG/wN33gJr3aaB7witgjz4g+dPrVLUaTsgp98+XU1KZs2frbs0ks4PYpDnjld13q7Zx
         ponQ==
X-Gm-Message-State: AOAM533TYqfqX5c3dQyhvzmPNrB0p8pDB1CoQH7728flUdPhEvg9QnJR
        ISrGCK77DJPMhKHOK58GQPFptw==
X-Google-Smtp-Source: ABdhPJyqNpeii+tThw9D+lT/nBw9hSmXi5wcUCwrjX5/uSDnJgc4fJASKpAPL4TawW8mJaLGhctn+g==
X-Received: by 2002:a5e:d80a:: with SMTP id l10mr3402237iok.36.1630681308649;
        Fri, 03 Sep 2021 08:01:48 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g23sm2816585ioc.8.2021.09.03.08.01.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 08:01:48 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: fix possible poll event lost in multi shot
 mode
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20210903142436.5767-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0201c058-38da-fdb7-764c-f8786d77aec5@kernel.dk>
Date:   Fri, 3 Sep 2021 09:01:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210903142436.5767-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/3/21 8:24 AM, Xiaoguang Wang wrote:
> IIUC, IORING_POLL_ADD_MULTI is similar to epoll's edge-triggered mode,
> that means once one pure poll request returns one event(cqe), we'll
> need to read or write continually until EAGAIN is returned, then I think
> there is a possible poll event lost race in multi shot mode:
> 
> t1  poll request add |                         |
> t2                   |                         |
> t3  event happens    |                         |
> t4  task work add    |                         |
> t5                   | task work run           |
> t6                   |   commit one cqe        |
> t7                   |                         | user app handles cqe
> t8                   |   new event happen      |
> t9                   |   add back to waitqueue |
> t10                  |
> 
> After t6 but before t9, if new event happens, there'll be no wakeup
> operation, and if user app has picked up this cqe in t7, read or write
> until EAGAIN is returned. In t8, new event happens and will be lost,
> though this race window maybe small.
> 
> To fix this possible race, add poll request back to waitqueue before
> committing cqe.

Applied, thanks.

-- 
Jens Axboe

