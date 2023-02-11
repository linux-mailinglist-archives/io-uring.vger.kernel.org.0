Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A439C692DF1
	for <lists+io-uring@lfdr.de>; Sat, 11 Feb 2023 04:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjBKDfC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 22:35:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBKDfB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 22:35:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904FD85B2F
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 19:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676086401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PurHXbJRnHGbSagoMpDJx9A09qf7W54g6forVImCpXk=;
        b=JuuT5ju5ZuRpfvUpiBYJKHVnr9M/Fv8oSEtPUIoFLKdfiQRk7iWMVN6tY3OQSF7eifkuPV
        18ai6atAGoLS0VnUAAGaiCMqUaYVbriG/dxqZWXLltVZicEI3LEzuNxhdvXxobkOu2NTiv
        Fr5//YzoqIyPTQWFwgOqteCIEUj0GsU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-340-aDWqqMpUOYWrKotzjDrxww-1; Fri, 10 Feb 2023 22:33:15 -0500
X-MC-Unique: aDWqqMpUOYWrKotzjDrxww-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0509229A9D3B;
        Sat, 11 Feb 2023 03:33:15 +0000 (UTC)
Received: from T590 (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A5442026D4B;
        Sat, 11 Feb 2023 03:33:08 +0000 (UTC)
Date:   Sat, 11 Feb 2023 11:33:04 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     lsf-pc@lists.linux-foundation.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
        axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, ming.lei@redhat.com
Subject: Re: [LSF/MM/BPF ATTEND][LSF/MM/BPF Topic] Non-block IO
Message-ID: <Y+cMcE8D9+fDVe+A@T590>
References: <CGME20230210180226epcas5p1bd2e1150de067f8af61de2bbf571594d@epcas5p1.samsung.com>
 <20230210180033.321377-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210180033.321377-1-joshi.k@samsung.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 10, 2023 at 11:30:33PM +0530, Kanchan Joshi wrote:
> is getting more common than it used to be.
> NVMe is no longer tied to block storage. Command sets in NVMe 2.0 spec
> opened an excellent way to present non-block interfaces to the Host. ZNS
> and KV came along with it, and some new command sets are emerging.
> 
> OTOH, Kernel IO advances historically centered around the block IO path.
> Passthrough IO path existed, but it stayed far from all the advances, be
> it new features or performance.
> 
> Current state & discussion points:
> ---------------------------------
> Status-quo changed in the recent past with the new passthrough path (ng
> char interface + io_uring command). Feature parity does not exist, but
> performance parity does.
> Adoption draws asks. I propose a session covering a few voices and
> finding a path-forward for some ideas too.
> 
> 1. Command cancellation: while NVMe mandatorily supports the abort
> command, we do not have a way to trigger that from user-space. There
> are ways to go about it (with or without the uring-cancel interface) but
> not without certain tradeoffs. It will be good to discuss the choices in
> person.
> 
> 2. Cgroups: works for only block dev at the moment. Are there outright
> objections to extending this to char-interface IO?

But recently the blk-cgroup change towards to associate with disk only,
which may become far away from supporting cgroup for pt IO.

Another thing is io scheduler, I guess it isn't important for nvme any
more?

Also IO accounting.

> 
> 3. DMA cost: is high in presence of IOMMU. Keith posted the work[1],
> with block IO path, last year. I imagine plumbing to get a bit simpler
> with passthrough-only support. But what are the other things that must
> be sorted out to have progress on moving DMA cost out of the fast path?
> 
> 4. Direct NVMe queues - will there be interest in having io_uring
> managed NVMe queues?  Sort of a new ring, for which I/O is destaged from
> io_uring SQE to NVMe SQE without having to go through intermediate
> constructs (i.e., bio/request). Hopefully,that can further amp up the
> efficiency of IO.

Interesting!

There hasn't bio for nvme io_uring command pt, but request is still
here. If SQE can provide unique ID, request may reuse it as tag.


Thanks,
Ming

