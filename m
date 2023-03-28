Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931B46CB30D
	for <lists+io-uring@lfdr.de>; Tue, 28 Mar 2023 03:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbjC1BR6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 21:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjC1BR5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 21:17:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43C01997
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 18:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679966230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IwxeZGW5YVnlucvXX3uaJlGZ00LAxfwDci1nwLOV/ps=;
        b=EPqp1vMeCr4kSpi5rM3C4oFh+koBLPXsS/GUAr5VPIkVsFCBNann/3SjJwuPszP4Al+z6Q
        auVcGEqwr3VL+DN8ARlmDlyPUY6aEidTGUDCU5cwInOdMD9GE50AYKbAQqgTjGVl5dF5CU
        4UZCqucd8n57f+UTocmfmjtlQsKr1/Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-yezJs16sNfeifGoeJt7QAg-1; Mon, 27 Mar 2023 21:17:07 -0400
X-MC-Unique: yezJs16sNfeifGoeJt7QAg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0EFC285A588;
        Tue, 28 Mar 2023 01:17:07 +0000 (UTC)
Received: from ovpn-8-20.pek2.redhat.com (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B5C9F492B01;
        Tue, 28 Mar 2023 01:16:59 +0000 (UTC)
Date:   Tue, 28 Mar 2023 09:16:54 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, ming.lei@redhat.com
Subject: Re: [PATCH V4 00/17] io_uring/ublk: add IORING_OP_FUSED_CMD
Message-ID: <ZCJABlFshb0UmTMv@ovpn-8-20.pek2.redhat.com>
References: <20230324135808.855245-1-ming.lei@redhat.com>
 <642236912a229_29cc2942c@dwillia2-xfh.jf.intel.com.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <642236912a229_29cc2942c@dwillia2-xfh.jf.intel.com.notmuch>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Dan,

On Mon, Mar 27, 2023 at 05:36:33PM -0700, Dan Williams wrote:
> Ming Lei wrote:
> > Hello Jens,
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
> Hi Ming,
> 
> io_uring and ublk are starting to be more on my radar these days. I
> wanted to take a look at this series, but could not get past the
> distracting "master"/"slave" terminology in this lead-in paragraph let
> alone start looking at patches.
> 
> Frankly, the description sounds more like "head"/"tail", or even
> "fuse0"/"fuse1" because, for example, who is to say you might not have

The term "master/slave" is from patches.

The master command not only provides buffer for slave request, but also requires
slave request for serving master command, and master command is always completed
after all slave request are done.

That is why it is named as master/slave. Actually Jens raised the similar concern
and I hate the name too, but it is always hard to figure out perfect name, or
any other name for reflecting the relation? (head/tail, fuse0/1 can't
do that, IMO)

> larger fused ops in the future and need terminology to address
> "fuse{0,1,2,3}"?

Yeah, definitely, the interface can be extended in future to support
multiple "slave" requests.

Thanks,
Ming

