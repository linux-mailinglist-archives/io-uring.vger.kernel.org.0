Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1790E7B16B5
	for <lists+io-uring@lfdr.de>; Thu, 28 Sep 2023 10:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbjI1I5M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Sep 2023 04:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbjI1I4y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Sep 2023 04:56:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C09F1B2
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 01:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695891362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YXyf93SGNji8Nitj6XE+tI3+Pd3NN3XDXLxTEgunQ8A=;
        b=OeqG9KbHtA6Ci1NMkL1fiF0u2narto7Z1e84nJF0vLm1X4UXkTzBZYxHvpuVUgvg8bOGvO
        vJjpZS1phMgB5Q3vcxnkQIn2kEuUwGrIHrVC1vzBAOCTHN7Rp99+dW8YXkrAD4QQrbyAGs
        e9GPK67xQ2vjnNR0uGH05HndnNKncns=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-360--waToYCTOSmmEpPy-SPqAw-1; Thu, 28 Sep 2023 04:55:59 -0400
X-MC-Unique: -waToYCTOSmmEpPy-SPqAw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18C453814599;
        Thu, 28 Sep 2023 08:55:58 +0000 (UTC)
Received: from fedora (unknown [10.72.120.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 107CB10005D2;
        Thu, 28 Sep 2023 08:55:54 +0000 (UTC)
Date:   Thu, 28 Sep 2023 16:55:50 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@suse.de>
Subject: Re: [PATCH V4 2/2] io_uring: cancelable uring_cmd
Message-ID: <ZRU/lkGwzxVeRes7@fedora>
References: <20230923025006.2830689-1-ming.lei@redhat.com>
 <20230923025006.2830689-3-ming.lei@redhat.com>
 <c4598c93-fe5d-49d3-b737-e78b7abcea77@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4598c93-fe5d-49d3-b737-e78b7abcea77@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 28, 2023 at 02:38:32AM -0600, Jens Axboe wrote:
> On 9/22/23 8:50 PM, Ming Lei wrote:
> > diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> > index ae08d6f66e62..a0307289bdc7 100644
> > --- a/include/linux/io_uring.h
> > +++ b/include/linux/io_uring.h
> > @@ -20,9 +20,13 @@ enum io_uring_cmd_flags {
> >  	IO_URING_F_SQE128		= (1 << 8),
> >  	IO_URING_F_CQE32		= (1 << 9),
> >  	IO_URING_F_IOPOLL		= (1 << 10),
> > +
> > +	/* set when uring wants to cancel one issued command */
> > +	IO_URING_F_CANCEL		= (1 << 11),
> >  };
> 
> I'd make that comment:
> 
> /* set when uring wants to cancel a previously issued command */

OK.

> 
> > @@ -125,6 +132,15 @@ static inline int io_uring_cmd_sock(struct io_uring_cmd *cmd,
> >  {
> >  	return -EOPNOTSUPP;
> >  }
> > +static inline int io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
> > +		unsigned int issue_flags)
> > +{
> > +	return -EOPNOTSUPP;
> > +}
> 
> Do we need this to return an error? Presumably this will never get
> called if IO_URING isn't defined, but if it does, it obviously doesn't
> need to do anything anyway. Seems like it should just be a void, and
> ditto for the enabled version which can't return an error anyway.

Indeed, 'void' is better.

> 
> >  	return ret;
> >  }
> >  
> > +static bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
> > +		struct task_struct *task, bool cancel_all)
> > +{
> > +	struct hlist_node *tmp;
> > +	struct io_kiocb *req;
> > +	bool ret = false;
> > +
> > +	lockdep_assert_held(&ctx->uring_lock);
> > +
> > +	hlist_for_each_entry_safe(req, tmp, &ctx->cancelable_uring_cmd,
> > +			hash_node) {
> > +		struct io_uring_cmd *cmd = io_kiocb_to_cmd(req,
> > +				struct io_uring_cmd);
> > +		struct file *file = req->file;
> > +
> > +		if (WARN_ON_ONCE(!file->f_op->uring_cmd))
> > +			continue;
> 
> That check belongs in the function that marks it cancelable and adds it
> to the list.

io_uring_cmd_mark_cancelable() is actually called from ->uring_cmd(), so
the check isn't necessary.



thanks,
Ming

