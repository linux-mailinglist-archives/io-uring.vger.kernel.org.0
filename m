Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7086AFBC8
	for <lists+io-uring@lfdr.de>; Wed,  8 Mar 2023 02:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjCHBJQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Mar 2023 20:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjCHBJP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Mar 2023 20:09:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B69A226F
        for <io-uring@vger.kernel.org>; Tue,  7 Mar 2023 17:08:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678237699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dYDAMHZIsmMwagaEDhVssXFOJ/xumgqcigzIaKITBKw=;
        b=c7sBBmMbRvp+px6Z7ZEwHWEMOhAAUXrVEMe/nQfv8+7lo3qhoJQzTf0zOQ6ds+Fh8xN537
        vAkDyuR2TOIGKrz0kqzxnnLqroOiJYkEwof1O38d2HVqkBtTrVu57wnAluZuYsJUjZsmFq
        J+6+DT33+9q0FNfj0wJWPt/cktVXPuo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-361-qPPHIJrrNG2baLDLN2RsjA-1; Tue, 07 Mar 2023 20:08:16 -0500
X-MC-Unique: qPPHIJrrNG2baLDLN2RsjA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B3E1185A794;
        Wed,  8 Mar 2023 01:08:16 +0000 (UTC)
Received: from ovpn-8-16.pek2.redhat.com (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 37F9E2026D4B;
        Wed,  8 Mar 2023 01:08:10 +0000 (UTC)
Date:   Wed, 8 Mar 2023 09:08:06 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>, ming.lei@redhat.com
Subject: Re: [PATCH V2 00/17] io_uring/ublk: add IORING_OP_FUSED_CMD
Message-ID: <ZAff9usDuyXxIPt9@ovpn-8-16.pek2.redhat.com>
References: <20230307141520.793891-1-ming.lei@redhat.com>
 <7e05882f-9695-895d-5e83-61006e54c4b2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e05882f-9695-895d-5e83-61006e54c4b2@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 07, 2023 at 03:37:21PM +0000, Pavel Begunkov wrote:
> On 3/7/23 14:15, Ming Lei wrote:
> > Hello,
> > 
> > Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
> > be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
> > 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
> > to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
> > and its ->issue() can retrieve/import buffer from master request's
> > fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
> > this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
> > submits slave OP just like normal OP issued from userspace, that said,
> > SQE order is kept, and batching handling is done too.
> 
> From a quick look through patches it all looks a bit complicated
> and intrusive, all over generic hot paths. I think instead we

Really? The main change to generic hot paths are adding one 'true/false'
parameter to io_init_req(). For others, the change is just check on
req->flags or issue_flags, which is basically zero cost.

> should be able to use registered buffer table as intermediary and
> reuse splicing. Let me try it out

I will take a look at you patch, but last time, Linus has pointed out that
splice isn't one good way, in which buffer ownership transferring is one big
issue for writing data to page retrieved from pipe.

https://lore.kernel.org/linux-block/CAJfpeguQ3xn2-6svkkVXJ88tiVfcDd-eKi1evzzfvu305fMoyw@mail.gmail.com/


Thanks, 
Ming

