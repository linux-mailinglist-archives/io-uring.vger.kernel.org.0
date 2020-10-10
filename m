Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9590528A3E2
	for <lists+io-uring@lfdr.de>; Sun, 11 Oct 2020 01:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389475AbgJJWzo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Oct 2020 18:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731391AbgJJTRx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Oct 2020 15:17:53 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B9BC0613BD
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 12:17:44 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id l18so1101768pgg.0
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 12:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=rNxjTadVUnT9PUmXBaYZ0yyb+TLBMZ3qgtb35bVLsHM=;
        b=MRRY2S33WYX/koM/uMpuEIICAmwLMEVmC+Dh2yuhY2pq6Tsth54jVifTaG3DVHpWI6
         rbuMfcQKWbiZxNI2OoyV+Ga0bO9qLmvprNoBEPav3V82wEc19Xj3nXsT5eJiGeVtkWd+
         bLH92thnytI2X+Tn4PLJLbr+hAWpI0gN0DUFkiRXzbyL4QRIsXpKVw9gGPSyt8TAN57W
         lPMsy+FbIZPMA54bUEyNXXGQxcErcE0gW82hk/0PT8InsUrFznUAu4Eo47bjL1XP2hGO
         5BQ2drI/H9uuEtZLQlg6mdlZgpYY34OaS1ROV8rh6hasVZgO8QjUyxhY6yA8N3RXPu9C
         GryA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rNxjTadVUnT9PUmXBaYZ0yyb+TLBMZ3qgtb35bVLsHM=;
        b=cUOu5itqW6sRoFmcBrpS+ZvXf7k+DagN2KYnsUT89F0O0ZWWaIV5z2TYgNCZFm2/97
         U65TWKbGumrkVMCgHnpQ50N6Wjh5BKOK5PhnX2EUk5m1uF6kqOKe3k6FJK+pQJBG6I5U
         VqcMex42rtBSOgYPD8gcDuIH313OqX6jWdgM4Pd/qaUx5dz1nP/E4ZddQ9rNkOhKesna
         aJ2KNEbehJPrQvy0yDsj7ziWy/PfPT2SWtByGQBAUCU3aDnB3Zz7GIAWKYYiW2Dqn6oA
         Jhwwqp5B4JdAMRI0xazew0ghFiXw/mzyuE22jsXbvKvo+5r2FFAF+JlIA8coUePuwm+Z
         ND3A==
X-Gm-Message-State: AOAM532YgUfUOGhKdR83sP1m/Sxcc557EBRk085HZRVr/DGThWidJJNP
        omyZt4RmDpgXKvZ+l8DRLxqn4Pl6g1XedA==
X-Google-Smtp-Source: ABdhPJyUXSCHganiFTiHBY+wWnJMY74Wo71HQFsYwn/uEudixxip5OG7k3r7xpVYivrQM20GSZpiXQ==
X-Received: by 2002:a63:524a:: with SMTP id s10mr8121301pgl.40.1602357462958;
        Sat, 10 Oct 2020 12:17:42 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21c1::1171? ([2620:10d:c090:400::5:2695])
        by smtp.gmail.com with ESMTPSA id ep11sm16026203pjb.55.2020.10.10.12.17.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Oct 2020 12:17:42 -0700 (PDT)
Subject: Re: [Question] testing results of support async buffered reads
 feature
To:     Hao_Xu <haoxu@linux.alibaba.com>, io-uring@vger.kernel.org
References: <f810df0d-e920-3183-f0eb-dbb17c60f157@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1d99941e-d980-10c3-d27d-c18fa5ff2d67@kernel.dk>
Date:   Sat, 10 Oct 2020 13:17:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f810df0d-e920-3183-f0eb-dbb17c60f157@linux.alibaba.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/10/20 3:39 AM, Hao_Xu wrote:
> Hi Jens,
> I've done some testing for io_uring async buffered reads with fio. But I 
> found something strange to me.
> - when readahead is exactly turned off, the async buffered reads feature 
> appears to be worse than the io-wq method in terms of IOPS.
> - when readahead is on, async buffered reads works better but the 
> optimization rate seems to be related with the size of readahead.
> I'm wondering why.

I don't think these are necessarily unexpected. By and large, the async
buffered reads are faster, have lower latencies, and are a lot more
efficient in terms of CPU usage. But there are cases where the old
thread offload will be quicker, as you're essentially spreading the
copying over more cores and can get higher bandwidth that way.

If you're utilizing a single ring for your application, then there might
be gains to be had at the higher end of the IOPS or bandwidth spectrum
by selectively using IOSQE_ASYNC for a (small) subset of the issued
reads. 

-- 
Jens Axboe

