Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4D12CB58E
	for <lists+io-uring@lfdr.de>; Wed,  2 Dec 2020 08:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgLBHN0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Dec 2020 02:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgLBHN0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Dec 2020 02:13:26 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A03C0613CF;
        Tue,  1 Dec 2020 23:12:46 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id u2so613397pls.10;
        Tue, 01 Dec 2020 23:12:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ya+0u8oPqKce5WddvEwrQ5QUESHFPHjBSXzdciQAiSg=;
        b=oJkuYre15ItUH3uiytzTvI1fFm1DG6GG6D2TqWyjB5ddSDMva5f5RJetckeiTDvHQ+
         OGVdu33ohScQl5hmzhlEaqsmw+IjRPUbGNnhHqIuc11lwx9bSyNYYLSGaHWFPksbLPcJ
         Bubib2ummhxJonw4bFv2brG/dQKxgS9tXCpPg921MPqb+gYJtBD9yo1roMNEIAGZ+QTg
         2oYaDntyyrKnTTcKujwpHdZ5io/lf+Xy/wokhnHLRKZhhB+66rd23+j5wRKVZTclfdwF
         iv8qpO59tj5pM0kOWpFCYBOXcEUn2FdOHoHmb98Fd1Tu87oVMN9p96OLBUAkoa3B8fSK
         EVzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ya+0u8oPqKce5WddvEwrQ5QUESHFPHjBSXzdciQAiSg=;
        b=da3OgdnH5R2L0Di+tEj8IlmdKkMzOwvF/Ba9HYjEl1QO1WQEwBq+7zCbaco1Vw4jwR
         bC0vlkOk+ExjngJB+gBuA7O2BGG2a8DogIdAd85U5H6MyDGx7LLhv2OdVdKzHorL7Xe8
         sqc+pjzstUzBhQrkjMBT2IPDIR16M1gcBupjtNNHR+uZpiaq0GtUa2eYDGknWx4VIcER
         EaDkWjd1Suxb7brQOTRWwy7mJG4yQE/3gnJUg9YJePgEGO5SEAnWoqL7rhq73+3EmHki
         bfAx6FbI9irzTizM3W9ZqQaTNBZ5jYVUQW7xh9yeTwWIbOMJLpQ8U3ihP390hze65Vmq
         1Ygw==
X-Gm-Message-State: AOAM531h0U90k/Vg782scGVBc7XCtinyQh1HpkfDG2c9k+dxR4YtYxbq
        rThMnMejSU+cej0IKeInv4l+Ws6QruTSQg==
X-Google-Smtp-Source: ABdhPJxFlSWiJUnyMAbdS77a6OqK9xSZe2X2wwa/cT4W47hkn0BlkITY9J3HdtHjl/w7hvyxb6UFUw==
X-Received: by 2002:a17:90a:bb91:: with SMTP id v17mr1111477pjr.231.1606893165171;
        Tue, 01 Dec 2020 23:12:45 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:2c16:d412:96a3:80fc? ([2601:647:4700:9b2:2c16:d412:96a3:80fc])
        by smtp.gmail.com with ESMTPSA id e23sm1111590pfd.64.2020.12.01.23.12.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Dec 2020 23:12:43 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [RFC PATCH 11/13] fs/userfaultfd: complete write asynchronously
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20201129004548.1619714-12-namit@vmware.com>
Date:   Tue, 1 Dec 2020 23:12:42 -0800
Cc:     Jens Axboe <axboe@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Transfer-Encoding: 7bit
Message-Id: <8405A413-239A-47E8-9D46-B6060EF86A68@gmail.com>
References: <20201129004548.1619714-1-namit@vmware.com>
 <20201129004548.1619714-12-namit@vmware.com>
To:     linux-fsdevel@vger.kernel.org
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> On Nov 28, 2020, at 4:45 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
> 
> From: Nadav Amit <namit@vmware.com>
> 
> Userfaultfd writes can now be used for copy/zeroing. When using iouring
> with userfaultfd, performing the copying/zeroing on the faulting thread
> instead of the handler/iouring thread has several advantages:
> 
> (1) The data of the faulting thread will be available on the local
> caches, which would make subsequent memory accesses faster.
> 
> (2) find_vma() would be able to use the vma-cache, which cannot be done
> from a different process or io-uring kernel thread.
> 
> (3) The page is more likely to be allocated on the correct NUMA node.
> 
> To do so, userfaultfd work queue structs are extended to hold the
> information that is required for the faulting thread to copy/zero. The
> handler wakes one of the faulting threads to perform the copy/zero and
> that thread wakes the other threads after the zero/copy is done.

I noticed some bugs of mine in this patch, but more importantly I realized
that the there may be a more performant solution to do the copying on the
faulting thread - without async-writes.

Please do not review this patch and the next one (12/13).

Feedback for the rest of the series is of course welcomed.

Regards,
Nadav
