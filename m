Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82F2F7CF75C
	for <lists+io-uring@lfdr.de>; Thu, 19 Oct 2023 13:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345383AbjJSLsJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Oct 2023 07:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345357AbjJSLsI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Oct 2023 07:48:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E7EBE
        for <io-uring@vger.kernel.org>; Thu, 19 Oct 2023 04:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697716041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LNdv/kHaXFOXJY1h3e7cqa6UPo1xkIol1sMM5WDpnd0=;
        b=gTu5oInnG+tdqB0aqRMoUbJoquDtuEJGxUV2kcaTShaRikZtpulld+uvVIFmOqX6X4fNG/
        /ZLSjVHbxelgugnBq0lWCvc2q/C+G0jKRfMobPywm6sLT1l60xBOAXYbXnGz4NtOqBBXog
        nuFe7B6q2OC/b0wNv32XYuVI/MDQiDQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-423-ek_u5AS3PbC-XCN1tHo4sg-1; Thu, 19 Oct 2023 07:47:18 -0400
X-MC-Unique: ek_u5AS3PbC-XCN1tHo4sg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E50A987A9F5;
        Thu, 19 Oct 2023 11:47:17 +0000 (UTC)
Received: from fedora (unknown [10.72.120.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 20BB940C6F7B;
        Thu, 19 Oct 2023 11:47:14 +0000 (UTC)
Date:   Thu, 19 Oct 2023 19:47:10 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Guang Wu <guazhang@redhat.com>,
        ming.lei@redhat.com
Subject: Re: [v6.4 Regression] rust/io_uring: tests::net::test_tcp_recv_multi
 hangs
Message-ID: <ZTEXPlB70Eqe3WOJ@fedora>
References: <ZTDjhCk8TC47oBdZ@fedora>
 <aa10bf89-779c-4383-a36c-5615f73dc6a4@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa10bf89-779c-4383-a36c-5615f73dc6a4@kernel.dk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 19, 2023 at 05:31:11AM -0600, Jens Axboe wrote:
> On 10/19/23 2:06 AM, Ming Lei wrote:
> > Hello Jens,
> > 
> > Guang Wu found that tests::net::test_tcp_recv_multi in rust:io_uring
> > hangs, and no such issue in RH test kernel.
> > 
> > - git clone https://github.com/tokio-rs/io-uring.git
> > - cd io-uring
> > - cargo run --package io-uring-test
> > 
> > I figured out that it is made by missing the last CQE with -ENOBUFS,
> > which is caused by commit a2741c58ac67 ("io_uring/net: don't retry recvmsg()
> > unnecessarily").
> > 
> > I am not sure if the last CQE should be returned and that depends how normal
> > recv_multi is written, but IORING_CQE_F_MORE in the previous CQE shouldn't be
> > returned at least.
> 
> Is this because it depends on this spurious retry? IOW, it adds N
> buffers and triggers N receives, then depends on an internal extra retry
> which would then yield -ENOBUFS? Because that sounds like a broken test.

Yeah, that is basically what the test does. 

The test gets two recv CQEs, both have IORING_CQE_F_MORE. And it waits for 3
CQEs, and never return because there isn't the 3rd CQE after
a2741c58ac67 ("io_uring/net: don't retry recvmsg() unnecessarily")
is merged.

> As long as the recv triggers successfully, IORING_CQE_F_MORE will be
> set. Only if it his some terminating condition would it trigger a CQE
> without the MORE flag set. If it remains armed and ready to trigger
> again, it will have MORE set. I'll take a look, this is pure guesswork
> on my side right now.

.B IORING_CQE_F_MORE
If set, the application should expect more completions from the request. This
is used for requests that can generate multiple completions, such as multi-shot
requests, receive, or accept.

I understand that if one CQE is received with IORING_CQE_F_MORE, it is
reasonable for userspace to wait for one extra CQE, is this expectation
correct? Or the documentation needs to be updated?


Thanks,
Ming

