Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 998416F8DAB
	for <lists+io-uring@lfdr.de>; Sat,  6 May 2023 03:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbjEFBjR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 May 2023 21:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232505AbjEFBjO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 May 2023 21:39:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7938468F
        for <io-uring@vger.kernel.org>; Fri,  5 May 2023 18:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683337112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mAqtXf2OpHZh/aPmso1gikHVJkWfhblGK7GUt1MWQkc=;
        b=EkzOCBmjXt/1kse/qop1nixHneF4n3QkAWgH7MirHS8mr9WcXZWD5TMNfRfYB3UdTvABRX
        p5dqMLtTxSgcfq8f1qChfi8V6zT8OIg8rosO5Z823LIJLaLO+gVJLrZ6vcnVJdyxD6opRX
        C+bsvD0Ua8yK08uLA0iY5gegoPwnvug=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-75-BPpM903FMwiyv21hONGl9A-1; Fri, 05 May 2023 21:38:29 -0400
X-MC-Unique: BPpM903FMwiyv21hONGl9A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3EBB3185A78B;
        Sat,  6 May 2023 01:38:29 +0000 (UTC)
Received: from ovpn-8-16.pek2.redhat.com (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F0A63492B00;
        Sat,  6 May 2023 01:38:22 +0000 (UTC)
Date:   Sat, 6 May 2023 09:38:17 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bernd Schubert <bschubert@ddn.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [LSF/MM/BPF TOPIC] ublk & io_uring: ublk zero copy support
Message-ID: <ZFWviQb7eKn/eBi9@ovpn-8-16.pek2.redhat.com>
References: <ZEx+h/iFf46XiWG1@ovpn-8-24.pek2.redhat.com>
 <41cfb9c2-9774-e9e1-d8e7-4999a710f2e7@ddn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41cfb9c2-9774-e9e1-d8e7-4999a710f2e7@ddn.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, May 05, 2023 at 09:57:47PM +0000, Bernd Schubert wrote:
> Hi Ming,
> 
> On 4/29/23 04:18, Ming Lei wrote:
> > Hello,
> > 
> > ublk zero copy is observed to improve big chunk(64KB+) sequential IO performance a
> > lot, such as, IOPS of ublk-loop over tmpfs is increased by 1~2X[1], Jens also observed
> > that IOPS of ublk-qcow2 can be increased by ~1X[2]. Meantime it saves memory bandwidth.
> > 
> > So this is one important performance improvement.
> > 
> > So far there are three proposal:
> 
> looks like there is no dedicated session. Could we still have a 
> discussion in a free slot, if possible?

Sure, and we can invite Pavel to the talk too if he is in this lsfmm.


thanks,
Ming

