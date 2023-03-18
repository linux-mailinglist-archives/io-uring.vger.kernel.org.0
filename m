Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6CD86BFB75
	for <lists+io-uring@lfdr.de>; Sat, 18 Mar 2023 17:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjCRQO2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Mar 2023 12:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjCRQO2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Mar 2023 12:14:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9F93C0A
        for <io-uring@vger.kernel.org>; Sat, 18 Mar 2023 09:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679156021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q+k9L2H9s4mgdoaZmrjXApwmLJJ38lrqPLlYtXtAVOU=;
        b=CgwtTSutnSxnbmzGyYJjI1G9CV3EZrA9Ct1zW2cUuSvS0IB4FrHiUYqDIrGkRpNmR0paWt
        riyiyKN37aP7+aXDH2ng+7/f4RvCAmJxcRoKZIVNoMbPesWKws2Mgj0mx+oOL4ipqabWOx
        RmSGmhmbf9LduXu9BIz/cSDuzqWWXbw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-6G72wSVoOESC48OX935YQw-1; Sat, 18 Mar 2023 12:13:30 -0400
X-MC-Unique: 6G72wSVoOESC48OX935YQw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 03C1429AA384;
        Sat, 18 Mar 2023 16:13:30 +0000 (UTC)
Received: from ovpn-8-18.pek2.redhat.com (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0851E492B00;
        Sat, 18 Mar 2023 16:13:24 +0000 (UTC)
Date:   Sun, 19 Mar 2023 00:13:19 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>, ming.lei@redhat.com
Subject: Re: [PATCH V3 02/16] io_uring: add IORING_OP_FUSED_CMD
Message-ID: <ZBXjH5ipRUwtYIVF@ovpn-8-18.pek2.redhat.com>
References: <20230314125727.1731233-1-ming.lei@redhat.com>
 <20230314125727.1731233-3-ming.lei@redhat.com>
 <e92b121c-553a-b699-11ca-746ff2522d7e@kernel.dk>
 <ZBXXl1hftxHI46hV@ovpn-8-18.pek2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBXXl1hftxHI46hV@ovpn-8-18.pek2.redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Mar 18, 2023 at 11:24:07PM +0800, Ming Lei wrote:
> On Sat, Mar 18, 2023 at 08:31:44AM -0600, Jens Axboe wrote:
> > On 3/14/23 6:57?AM, Ming Lei wrote:
> > > Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
> > > be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
> > > 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
> > > to support slave OP, io_issue_defs[op].fused_slave has to be set as 1,
> > > and its ->issue() needs to retrieve buffer from master request's
> > > fused_cmd_kbuf.
> > 
> > Since we'd be introducing this as a new concept, probably makes sense to
> > name it something other than master/slave. What about primary and
> > secondary? Producer/consumer?
> 
> Either of the two looks fine for me, and I will take secondary in next
> version if no one objects.

Thinking of further, probably master/slave is still better since slave
OP can be thought as part of master command, and it does serve for
master command.

That said master command not only provides buffer reference to slave OP,
but also requires slave OP to consume the buffer reference and complete the OP.

> > How about _bvec_buf_ or simply _buf_?

> Either one is fine, buf probably good enough and makes it a bit shorter.

OK.


Thanks, 
Ming

