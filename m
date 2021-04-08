Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51FFB358D9F
	for <lists+io-uring@lfdr.de>; Thu,  8 Apr 2021 21:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbhDHTnb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Apr 2021 15:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbhDHTna (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Apr 2021 15:43:30 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB19C061760
        for <io-uring@vger.kernel.org>; Thu,  8 Apr 2021 12:43:19 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id ep1-20020a17090ae641b029014d48811e37so1969519pjb.4
        for <io-uring@vger.kernel.org>; Thu, 08 Apr 2021 12:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E9M5KeILaLL2DX4wfYwCCBsqzscZxy2gc8zICwtanXk=;
        b=cd2isfYsbhE4d4Fq/QWNSBdRy9nv0/o/63vwQ8SHwwgOUl7MxMm1f3LDntIrAACkA/
         XHhv7UAPcnv1iRX6lOovanhhF9rE+pfYPtP/4m+wl27NZRyLUSETa9+R4NoH0WWYixPQ
         cY6tjohpXq3USIDbesxcwP0T9rDElGG/DqCNUldLrXuUCiQHq0avzcW5J+U6d5nSQh1D
         2OHBJV1MnzePCD594Vt+jvvQ+woM1FsNK7m7EL40r1+4i642IR2M/125+7esXUB/MdKO
         /cCgzMed0kmWa1/szbWaicYHr1JTQGE/WR1Z3LwzkbgcNgFKPTU0xR4m0nYhvBmOGwvM
         GICA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E9M5KeILaLL2DX4wfYwCCBsqzscZxy2gc8zICwtanXk=;
        b=gCLwlrzy77mT7NdTlzSnG83r8n3HXLIKIXwlqdQgY4rI8zjZhvPk9ev/BSJeHZuban
         AHK8ZKC628e7jUAizHsQyTOSPQkOoNQNjE7mh12R8evAPNO0eZrZh/kkhtlhIVfViWVW
         Jij0Lx2SQ42hShEnqQflQtm885ttnZ3KCvnQpsnLN7XkbXRCPG+1DyliQVTh/TVjDy5Z
         xjxVJ/j9cViBSyfl/CST+lZJodKjxKhlwYv7M39M5FGXd3q6aiI90vFnrLqEnXEar2Ca
         Ah/QbjsI0eDVrSyaLFHTvrgo0ND+G1YnygsUgCdWiJCv4X2i7RhYvLQPY7SeXUxLXa9F
         zK0w==
X-Gm-Message-State: AOAM533h7f11oD1FTjIW5BtgCoaHm/BeON50SkCf+GlVtdtjJbjWXi2p
        rJAqtrU8WONLvi/6NUzyQosJOE0nJiEwyw==
X-Google-Smtp-Source: ABdhPJyVrUFStDtvz2k0wishikZ9tsR5d3JDh26XKD0FanAazRRVwTsiNSqVeQf5PxcfZfRxB6BpGw==
X-Received: by 2002:a17:90a:8815:: with SMTP id s21mr9950762pjn.200.1617910998777;
        Thu, 08 Apr 2021 12:43:18 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id p17sm246558pfn.62.2021.04.08.12.43.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 12:43:18 -0700 (PDT)
Subject: Re: [PATCH] io-wq: Fix io_wq_worker_affinity()
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <YG7QkiUzlEbW85TU@hirez.programming.kicks-ass.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c30520c7-6c20-6a32-e9ce-3673285ebc4d@kernel.dk>
Date:   Thu, 8 Apr 2021 13:43:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YG7QkiUzlEbW85TU@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/8/21 3:44 AM, Peter Zijlstra wrote:
> 
> Do not include private headers and do not frob in internals.
> 
> On top of that, while the previous code restores the affinity, it
> doesn't ensure the task actually moves there if it was running,
> leading to the fun situation that it can be observed running outside
> of its allowed mask for potentially significant time.
> 
> Use the proper API instead.

Applied, thanks Peter.

-- 
Jens Axboe

