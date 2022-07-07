Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE30F569C37
	for <lists+io-uring@lfdr.de>; Thu,  7 Jul 2022 09:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbiGGHuM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jul 2022 03:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbiGGHuL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jul 2022 03:50:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 21467B45
        for <io-uring@vger.kernel.org>; Thu,  7 Jul 2022 00:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657180208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G+GK0m59h5LAkU0zG9fs2Rj6b2ZwvcuWU/BmMtKvyjk=;
        b=Q5je867q4dXihrFvJvvHYY53IbwcqDJKMK1tSFjhP5GjruoB56wylez1K7/2yjdjZ+oLoi
        kAwJJ3iTM925pT2Gl19+Ecg+IQ7dG5G3VKqR/ETATB67XCvf9fUPQ2VMNiJHwqxiPRHg/X
        n4Z1utLSQRjkVi5X6LY4G108NSvj0dk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-21-zejxw8LnMIC7a967odLosQ-1; Thu, 07 Jul 2022 03:50:05 -0400
X-MC-Unique: zejxw8LnMIC7a967odLosQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF731101A588;
        Thu,  7 Jul 2022 07:50:04 +0000 (UTC)
Received: from T590 (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D7E742EF99;
        Thu,  7 Jul 2022 07:49:57 +0000 (UTC)
Date:   Thu, 7 Jul 2022 15:49:52 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Harris James R <james.r.harris@intel.com>,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, ming.lei@redhat.com
Subject: Re: [PATCH V3 1/1] ublk: add io_uring based userspace block driver
Message-ID: <YsaQIGbyRKLAOoqR@T590>
References: <20220628160807.148853-1-ming.lei@redhat.com>
 <20220628160807.148853-2-ming.lei@redhat.com>
 <8735fg4jhb.fsf@collabora.com>
 <YsPw+HS8ssmVw86u@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsPw+HS8ssmVw86u@T590>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 05, 2022 at 04:06:16PM +0800, Ming Lei wrote:
> On Mon, Jul 04, 2022 at 06:10:40PM -0400, Gabriel Krisman Bertazi wrote:
> > Ming Lei <ming.lei@redhat.com> writes:

...
> 
> > 
> > 
> > > +			__func__, cmd->cmd_op, ub_cmd->q_id, tag,
> > > +			ub_cmd->result);
> > > +
> > > +	if (!(issue_flags & IO_URING_F_SQE128))
> > > +		goto out;
> > > +
> > > +	ubq = ublk_get_queue(ub, ub_cmd->q_id);
> > > +	if (!ubq || ub_cmd->q_id != ubq->q_id)
> > 
> > q_id is coming from userspace and is used to access an array inside
> > ublk_get_queue().  I think you need to ensure qid < ub->dev_info.nr_hw_queues
> > before calling ublk_get_queue() to protect from a kernel bad memory
> > access triggered by userspace.
> 
> Good catch!

Turns out the check on 'qid < ub->dev_info.nr_hw_queues' isn't needed,
since the condition of 'ub_cmd->q_id != ubq->q_id' is more strict.


Thanks,
Ming

