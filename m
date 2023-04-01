Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04E996D3163
	for <lists+io-uring@lfdr.de>; Sat,  1 Apr 2023 16:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjDAOg4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Apr 2023 10:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjDAOgz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Apr 2023 10:36:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EFBC678
        for <io-uring@vger.kernel.org>; Sat,  1 Apr 2023 07:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680359764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HV6/OHVclbGiO335z21XsKMkjGpi6QM03ig/0pOY3VQ=;
        b=M8y23xULVWzqS82mAn8pJcazqhkDvGm2jl9oehA7d4OInWoTVZNLGL5gP9itYFN9FTqelp
        g5/wOtWepDXIeD0wcTAyiK9Uko5G8msL1xWkN6TEB25B90b6cCgS/ZBq4bK+sruhEcrscL
        be7l594zljG8ub2fsNjElqKQrx1klzY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-FZbD6ekWNoGRjMLDkTehCQ-1; Sat, 01 Apr 2023 10:36:01 -0400
X-MC-Unique: FZbD6ekWNoGRjMLDkTehCQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B57B85A5A3;
        Sat,  1 Apr 2023 14:36:00 +0000 (UTC)
Received: from ovpn-8-19.pek2.redhat.com (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C78054020C82;
        Sat,  1 Apr 2023 14:35:52 +0000 (UTC)
Date:   Sat, 1 Apr 2023 22:35:47 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>, ming.lei@redhat.com
Subject: Re: [PATCH V6 03/17] io_uring: add generic IORING_OP_FUSED_CMD
Message-ID: <ZChBQ3EJ/VWFBnF3@ovpn-8-19.pek2.redhat.com>
References: <20230330113630.1388860-1-ming.lei@redhat.com>
 <20230330113630.1388860-4-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330113630.1388860-4-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 30, 2023 at 07:36:16PM +0800, Ming Lei wrote:
> Multiple requests submitted as one whole request logically, and the 1st one
> is primary command(IORING_OP_FUSED_CMD), and the others are secondary
> requests, which number can be retrieved from primary SQE.
> 
> Primary command is responsible for providing resources and submitting
> secondary requests, which depends on primary command's resources, and
> primary command won't be completed until all secondary requests are done.
> 
> The provided resource has same lifetime with primary command, and it
> lifetime won't cross multiple OPs, and this way provides safe way for
> secondary OPs to use the resource.
> 
> Add generic IORING_OP_FUSED_CMD for modeling this primary/secondary
> relationship among requests.

BTW, this model also solves 1:N dependency problem of io_uring.

Current io_uring can't handle this kind of dependency(1:N) efficiently,
and simply convert it into one linked list:

- N requests(1~n) depends on one request(0), and there isn't dependency among
these N requests

- current io_uring converts the dependency to linked list of (N + 1) requests
(0, 1, ...., n), in which all requests are just issued one by one from 0 to n,
inefficiently

The primary/secondary model solves it by issuing request 0 first, then issues
all other N requests concurrently.


Thanks,
Ming

