Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A384C620B32
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 09:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbiKHIav (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Nov 2022 03:30:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233452AbiKHIas (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 03:30:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3397027B2B
        for <io-uring@vger.kernel.org>; Tue,  8 Nov 2022 00:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667896188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lRojnfWUfsm0W6BCKt9OPdRubDtRX5uWnsoCtEuq6co=;
        b=UogpboCjYi6z4Y6EWbd51cAHGXGzttXNqppMB2j7D3sBaEyKPBwb8I44fV8x2W0KPN4SyX
        dDf2O5CiNnCYtXd7eGwGxzsEkQDDNpgfK5oMHWu1KWuNoeCSnbPjN72VIGkpzgVYt9Mu7o
        sDPYT1Uza/SfVGEbYUGJUTIID9yNzXc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-150-sZtXfLYaMcOmamX5MVNXpw-1; Tue, 08 Nov 2022 03:29:43 -0500
X-MC-Unique: sZtXfLYaMcOmamX5MVNXpw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D28ED101A52A;
        Tue,  8 Nov 2022 08:29:42 +0000 (UTC)
Received: from T590 (ovpn-8-32.pek2.redhat.com [10.72.8.32])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A813440C94AA;
        Tue,  8 Nov 2022 08:29:30 +0000 (UTC)
Date:   Tue, 8 Nov 2022 16:29:24 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>
Subject: Re: [RFC PATCH 3/4] io_uring/splice: support splice from
 ->splice_read to ->splice_read
Message-ID: <Y2oTZEZiXFT4po+8@T590>
References: <20221103085004.1029763-1-ming.lei@redhat.com>
 <20221103085004.1029763-4-ming.lei@redhat.com>
 <Y2oJAlV3xwqmJK0o@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2oJAlV3xwqmJK0o@infradead.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Nov 07, 2022 at 11:45:06PM -0800, Christoph Hellwig wrote:
> On Thu, Nov 03, 2022 at 04:50:03PM +0800, Ming Lei wrote:
> > The 1st ->splice_read produces buffer to the pipe of
> > current->splice_pipe, and the 2nd ->splice_read consumes the buffer
> > in this pipe.
> 
> This looks really ugly.  I think you want Linus and Al to look over
> it at very least.

OK, I will Cc Linus and Al in V2.

It is just another case of pipe's producer/consumer model, IMO.

> 
> Also, what is going to happen if your ->splice_read instance does not
> support the flag to magically do something entirely different?

If the ->splice_read() instance doesn't support this feature, then the new
added pipe flag won't be set, this API will return -EINVAL.



thanks, 
Ming

