Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B5B1E31DF
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2020 00:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390522AbgEZWBB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 18:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390021AbgEZWBA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 18:01:00 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3EDC061A0F
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 15:01:00 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id b6so22365144qkh.11
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 15:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZwwzxO17+0f92xu+E65BbQScQx/AP5VwvKaIskut9zM=;
        b=rFVM4x23qV4X2fbjmMbDbfW8BE//O63dwEI83+nf9RiCn82u2vgmzBe6uxrjX9diHX
         Xis+D4mIpGZRy+VlXibr+nvav1bnmleWViRSlsBZbD6wO47YqoG+xJKzT0DyENfn2Cf3
         6eH0qeuBR+szG69rgDH9mR+95W9t/Easz1XIfT4+usugiBihB/u2LH+4KhvPlPSr6Pl2
         aJHuPtBN+BCaPr1W1q6XU+kLH6gjPHrEtOY6dFLu/uf9aVt8HRLBgSZGW2/0FvllyUIc
         dOIHqAcLpDPd/13wn4sX0h2UaZVOwpuQqu30SmaFsjuZkRUvfkp8ypGkNZ9dK7vl6fsD
         RWYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZwwzxO17+0f92xu+E65BbQScQx/AP5VwvKaIskut9zM=;
        b=Jo4mKg3E6ytkNGuPTOp066bQI01J9roBDW5EkReEjQobM8XnpzGPdvj5X91Q6dOmyX
         xlay5RMIotjZO/+lc22G482ekgq5kfrmVFfKcSQaqsJ+xkuX5BfRNVvhnlb7x9fxyToW
         SrZ0bwyxjRw75NFc291L80EUBJrQfV0LsSTPdgq/l6pkMwKY2riSG50dscVz8nlNFTdn
         m5a/V04qxbAhUGYoo9JFIZJFFqRcPJzlijwiikxH34UanYDW6bz+tpemewKoFVKfSw9i
         CwR8o4RbA3yQMB0iAttKF9XQmyWixZNcq0eQerL77f7WWgVrB0IqrpBgDLV5X9Xk4aAB
         hCoQ==
X-Gm-Message-State: AOAM531UrrlAfNYmUdv5Nlfwsngpd3MtWgOKIiMz1eMg4KKBDZUUX+ED
        VnakxQm4JInbDLx23WbKU+bvVA==
X-Google-Smtp-Source: ABdhPJwcs2lIFlebvMOJB532DIwuMysc4GxK7bOpNwv2KuUaNVUQmNah4iqFU4gIgoC9RjiPlBugyw==
X-Received: by 2002:a05:620a:13b0:: with SMTP id m16mr1032459qki.292.1590530459566;
        Tue, 26 May 2020 15:00:59 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:2921])
        by smtp.gmail.com with ESMTPSA id a7sm841053qth.61.2020.05.26.15.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 15:00:58 -0700 (PDT)
Date:   Tue, 26 May 2020 18:00:35 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 05/12] mm: support async buffered reads in
 generic_file_buffered_read()
Message-ID: <20200526220035.GD6781@cmpxchg.org>
References: <20200526195123.29053-1-axboe@kernel.dk>
 <20200526195123.29053-6-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526195123.29053-6-axboe@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 26, 2020 at 01:51:16PM -0600, Jens Axboe wrote:
> Use the async page locking infrastructure, if IOCB_WAITQ is set in the
> passed in iocb. The caller must expect an -EIOCBQUEUED return value,
> which means that IO is started but not done yet. This is similar to how
> O_DIRECT signals the same operation. Once the callback is received by
> the caller for IO completion, the caller must retry the operation.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
