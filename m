Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477E86E2641
	for <lists+io-uring@lfdr.de>; Fri, 14 Apr 2023 16:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbjDNOyY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Apr 2023 10:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbjDNOyV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Apr 2023 10:54:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E956199
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 07:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681484016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lsxFDj8F0TxtwoPG0xcYRvT6Pci1oiKeyn76AgQV7pA=;
        b=fP45iT4SHQ4qn5YHhKwWsfSDBVQ+kWWpARzPkkSuFqDu90YhMx3iIidBi6fAEwYYw1lVTU
        ZlyLz28y/YCDlQVa2ttFhCKNsPZ9iXCKbxa625rGnMxB38+0XG61RnPAukfstQSOnic6Bi
        bf1bYu+JHIZCg4qVQ0OFke6zxHQtwJg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-ps2ZCw50MjGK87JWrnTjjg-1; Fri, 14 Apr 2023 10:53:30 -0400
X-MC-Unique: ps2ZCw50MjGK87JWrnTjjg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57DC83C0E211;
        Fri, 14 Apr 2023 14:53:30 +0000 (UTC)
Received: from ovpn-8-21.pek2.redhat.com (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A3821492B00;
        Fri, 14 Apr 2023 14:53:25 +0000 (UTC)
Date:   Fri, 14 Apr 2023 22:53:20 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        ming.lei@redhat.com
Subject: Re: [PATCH] io_uring: complete request via task work in case of
 DEFER_TASKRUN
Message-ID: <ZDlo4NbtCCpuBRt3@ovpn-8-21.pek2.redhat.com>
References: <20230414075313.373263-1-ming.lei@redhat.com>
 <68ddddc0-fb0e-47b4-9318-9dd549d851a1@gmail.com>
 <CGME20230414135423epcas5p356635b820c297c1d3a5b806ba8340bfb@epcas5p3.samsung.com>
 <ZDlay1++tidiKv+n@ovpn-8-21.pek2.redhat.com>
 <20230414141315.GC5049@green5>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414141315.GC5049@green5>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Apr 14, 2023 at 07:43:15PM +0530, Kanchan Joshi wrote:
> On Fri, Apr 14, 2023 at 09:53:15PM +0800, Ming Lei wrote:
> > On Fri, Apr 14, 2023 at 02:01:26PM +0100, Pavel Begunkov wrote:
> > > On 4/14/23 08:53, Ming Lei wrote:
> > > > So far io_req_complete_post() only covers DEFER_TASKRUN by completing
> > > > request via task work when the request is completed from IOWQ.
> > > >
> > > > However, uring command could be completed from any context, and if io
> > > > uring is setup with DEFER_TASKRUN, the command is required to be
> > > > completed from current context, otherwise wait on IORING_ENTER_GETEVENTS
> > > > can't be wakeup, and may hang forever.
> > > 
> > > fwiw, there is one legit exception, when the task is half dead
> > > task_work will be executed by a kthread. It should be fine as it
> > > locks the ctx down, but I can't help but wonder whether it's only
> > > ublk_cancel_queue() affected or there are more places in ublk?
> > 
> > No, it isn't.
> > 
> > It isn't triggered on nvme-pt just because command is always done
> > in task context.
> > 
> > And we know more uring command cases are coming.
> 
> FWIW, the model I had in mind (in initial days) was this -
> 1) io_uring_cmd_done is a simple API, it just posts one/two results into
> reuglar/big SQE
> 2) for anything complex completion (that requires task-work), it will
> use another API io_uring_cmd_complete_in_task with the provider-specific
> callback (that will call above simple API eventually)
 
IMO, the current two APIs type are fine, from ublk viewpoint at least.

io_uring setup/setting is transparent/invisible to driver, and it is reasonable
for the two interfaces to hide any io_uring implementation details.

Meantime driver should be free to choose either of the two.


Thanks, 
Ming

