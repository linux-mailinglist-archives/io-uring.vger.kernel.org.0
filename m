Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C7C321934
	for <lists+io-uring@lfdr.de>; Mon, 22 Feb 2021 14:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhBVNoO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Feb 2021 08:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbhBVNlC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Feb 2021 08:41:02 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032BEC06174A
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 05:40:22 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id e6so585470pgk.5
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 05:40:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DrA5z8COmcoHf40X8aYrpFjyoaTw3sNPCWnlWiiL4ik=;
        b=M9k9Ij/9tj9iE05599VLlIAIjxdMxledHwbsdpFbVwQtNgLdA/1cvWFAcWHAC9s77Y
         YOLP6U8ht3nMDXTvjal2nEmXGJniZRah4YYvgPiUwFUQbFmrHWDSpQNRj92uSfwu7UZB
         bFvbjJ0Up4c6vnTDvgPFHzj9qn8GXSDlRsy8BhkWNPqmyTNDD0hM3h5dqv6LByaMSPY2
         LhTU3VXWkgt//9lR/rPC7mH4h5qYLZ9jwczwS0irSv4n+RHgMCrGwy95YxL0qr3DzRdU
         M/ZLENgSv5xfjuxUgoq+hzlKGdterw63kpTNFlJMNbquTN36wcCV2NX586vhP1UT71Wf
         phDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DrA5z8COmcoHf40X8aYrpFjyoaTw3sNPCWnlWiiL4ik=;
        b=N1ghABqalH8ESfND90ECTNOCddDrq4AXtAYVaTMAFX7XaTuDNAQvdP4kdyslaUPUfa
         Xc51nz1QOUBPUAUdSSFFdkNzB2zzwAu+HiQYH8bMt5sgdJt19XwwsGVg81oTsUu+y1Lh
         yNwwTPHepmD/jSgXj2Yj1zpcNoMSFRKe/m0pOb8vZ9qnaYdnK18/6tNERf2gYqvQ1UKn
         dnNnslm4bOBsLFfATg0aKD1n+8gWGYx8vbcdHsFRmaAh/tLTiFcN91yyZIC/VlPsOWwq
         3Nb0GZgsZ72ELuay9HeZ5XzUC06a9eHWLu/rejgJycCpjwgghZauPa6kQnLJ1teEBMR0
         PYlg==
X-Gm-Message-State: AOAM5314LNczPm4VhxwfSRReDfqrjlov8y+V49VdOidyAxfwi/pvfDFq
        0FH9OrCh3kgbyYCk2OvXwh/CZI255xrVrQ==
X-Google-Smtp-Source: ABdhPJylBpFvlZLsCQ5qUkFRkLmxKfyy1QlVatJDMeH4jCua6UnI5i4ip27RIQsUYmZeMY008hKovg==
X-Received: by 2002:a63:397:: with SMTP id 145mr19745749pgd.171.1614001222199;
        Mon, 22 Feb 2021 05:40:22 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id s16sm8552732pfs.39.2021.02.22.05.40.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Feb 2021 05:40:21 -0800 (PST)
Subject: Re: [PATCH] block: fix potential IO hang when turning off io_poll
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        joseph.qi@linux.alibaba.com
References: <20210222065452.21897-1-jefflexu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9b4dfa03-060b-dcd7-f897-106dc395fd3c@kernel.dk>
Date:   Mon, 22 Feb 2021 06:40:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210222065452.21897-1-jefflexu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/21/21 11:54 PM, Jeffle Xu wrote:
> QUEUE_FLAG_POLL flag will be cleared when turning off 'io_poll', while
> at that moment there may be IOs stuck in hw queue uncompleted. The
> following polling routine won't help reap these IOs, since blk_poll()
> will return immediately because of cleared QUEUE_FLAG_POLL flag. Thus
> these IOs will hang until they finnaly time out. The hang out can be
> observed by 'fio --engine=io_uring iodepth=1', while turning off
> 'io_poll' at the same time.
> 
> To fix this, freeze and flush the request queue first when turning off
> 'io_poll'.

Applied, thanks. Fixed up the braces.

-- 
Jens Axboe

