Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7B2051C144
	for <lists+io-uring@lfdr.de>; Thu,  5 May 2022 15:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbiEENwh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 May 2022 09:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245639AbiEENwg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 May 2022 09:52:36 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AFBE657B13
        for <io-uring@vger.kernel.org>; Thu,  5 May 2022 06:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651758536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sTalr6Pg3F2/2+cacFsBsNozWQqUkCIZIMTm6+AC2o8=;
        b=Ti3U6IoU1eYHS7BWCkULJ++CmS3Z4HctmgrXiA1Y48Qtqojta88/sQwu8fxBSZTxqiL0Ay
        i/4bXrCkJpLi7iXwY32ZAbvzvaTE4nM6XnyUhd1b8PTBFyhRaNTJew3y8leuqCmwUBnDdf
        bTMZfb4oMawrnHk0Ctw3nFr9STIjUxM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-8vY9OnD9NfGyWiCbQLWgAA-1; Thu, 05 May 2022 09:48:50 -0400
X-MC-Unique: 8vY9OnD9NfGyWiCbQLWgAA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3AC10185A7A4;
        Thu,  5 May 2022 13:48:50 +0000 (UTC)
Received: from T590 (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F274C28103;
        Thu,  5 May 2022 13:48:43 +0000 (UTC)
Date:   Thu, 5 May 2022 21:48:38 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, mcgrof@kernel.org, shr@fb.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
Subject: Re: [PATCH v4 1/5] fs,io_uring: add infrastructure for uring-cmd
Message-ID: <YnPVtiRbYBYCGkCi@T590>
References: <20220505060616.803816-1-joshi.k@samsung.com>
 <CGME20220505061144epcas5p3821a9516dad2b5eff5a25c56dbe164df@epcas5p3.samsung.com>
 <20220505060616.803816-2-joshi.k@samsung.com>
 <f9051783-5105-45ba-99b3-bc5d9254656d@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9051783-5105-45ba-99b3-bc5d9254656d@kernel.dk>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 05, 2022 at 06:52:25AM -0600, Jens Axboe wrote:
> On 5/5/22 12:06 AM, Kanchan Joshi wrote:
> > From: Jens Axboe <axboe@kernel.dk>
> > 
> > file_operations->uring_cmd is a file private handler.
> > This is somewhat similar to ioctl but hopefully a lot more sane and
> > useful as it can be used to enable many io_uring capabilities for the
> > underlying operation.
> > 
> > IORING_OP_URING_CMD is a file private kind of request. io_uring doesn't
> > know what is in this command type, it's for the provider of ->uring_cmd()
> > to deal with. This operation can be issued only on the ring that is
> > setup with both IORING_SETUP_SQE128 and IORING_SETUP_CQE32 flags.
> 
> One thing that occured to me that I think we need to change is what you
> mention above, code here:
> 
> > +static int io_uring_cmd_prep(struct io_kiocb *req,
> > +			     const struct io_uring_sqe *sqe)
> > +{
> > +	struct io_uring_cmd *ioucmd = &req->uring_cmd;
> > +	struct io_ring_ctx *ctx = req->ctx;
> > +
> > +	if (ctx->flags & IORING_SETUP_IOPOLL)
> > +		return -EOPNOTSUPP;
> > +	/* do not support uring-cmd without big SQE/CQE */
> > +	if (!(ctx->flags & IORING_SETUP_SQE128))
> > +		return -EOPNOTSUPP;
> > +	if (!(ctx->flags & IORING_SETUP_CQE32))
> > +		return -EOPNOTSUPP;
> > +	if (sqe->ioprio || sqe->rw_flags)
> > +		return -EINVAL;
> > +	ioucmd->cmd = sqe->cmd;
> > +	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
> > +	return 0;
> > +}
> 
> I've been thinking of this mostly in the context of passthrough for
> nvme, but it originally started as a generic feature to be able to wire
> up anything for these types of commands. The SQE128/CQE32 requirement is
> really an nvme passthrough restriction, we don't necessarily need this
> for any kind of URING_CMD. Ditto IOPOLL as well. These are all things
> that should be validated further down, but there's no way to do that
> currently.
> 
> Let's not have that hold up merging this, but we do need it fixed up for
> 5.19-final so we don't have this restriction. Suggestions welcome...

The validation has to be done in consumer of SQE128/CQE32(nvme). One way is
to add SQE128/CQE32 io_uring_cmd_flags and pass them via ->uring_cmd(issue_flags).


Thanks,
Ming

