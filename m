Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A92D86D4063
	for <lists+io-uring@lfdr.de>; Mon,  3 Apr 2023 11:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbjDCJXu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Apr 2023 05:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbjDCJXo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Apr 2023 05:23:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15622EC4C
        for <io-uring@vger.kernel.org>; Mon,  3 Apr 2023 02:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680513746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LxZ9/V62aRV4MHBcdF0RXnCsBbp2tO2Tl22tusojnlg=;
        b=WLW9VAz8/FMQDiG2Y8jzDcBSxtgDWDKu8W5n8nPHi9YMvkFqkF8UGbfiD6xRz4BlVwW6hV
        Y+g+Q97GlC56pJNIEdnAPRb4o7w4wPhUH4AicMGnDZrNMsJ0jTx4nGAGLNE98SWsEzI5PJ
        gOMTcnHOKLeXANKZ2zs5ogN+CwmVKRA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-184-YCBs7t7aN5Ckf_chgGq9rg-1; Mon, 03 Apr 2023 05:22:22 -0400
X-MC-Unique: YCBs7t7aN5Ckf_chgGq9rg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90922185A794;
        Mon,  3 Apr 2023 09:22:21 +0000 (UTC)
Received: from ovpn-8-18.pek2.redhat.com (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8AA9840C20FA;
        Mon,  3 Apr 2023 09:22:14 +0000 (UTC)
Date:   Mon, 3 Apr 2023 17:22:09 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Cc:     linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dan Williams <dan.j.williams@intel.com>, ming.lei@redhat.com
Subject: Re: [PATCH V5 16/16] block: ublk_drv: apply io_uring FUSED_CMD for
 supporting zero copy
Message-ID: <ZCqawZweb2UG6o3z@ovpn-8-18.pek2.redhat.com>
References: <20230328150958.1253547-1-ming.lei@redhat.com>
 <20230328150958.1253547-17-ming.lei@redhat.com>
 <2e3c20e0-a0be-eaf3-b288-c3c8fa31d1fa@linux.alibaba.com>
 <ZCP+L0ADCxHo5vSg@ovpn-8-26.pek2.redhat.com>
 <08b047a8-c577-a717-81a8-db8fca8ebab6@linux.alibaba.com>
 <ZCQYVhStekJXpvK1@ovpn-8-26.pek2.redhat.com>
 <1d74e886-89af-bbbb-9bae-37d20ce07fb2@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d74e886-89af-bbbb-9bae-37d20ce07fb2@linux.alibaba.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 03, 2023 at 04:38:30PM +0800, Ziyang Zhang wrote:
> On 2023/3/29 18:52, Ming Lei wrote:
> > On Wed, Mar 29, 2023 at 06:01:16PM +0800, Ziyang Zhang wrote:
> >> On 2023/3/29 17:00, Ming Lei wrote:
> >>> On Wed, Mar 29, 2023 at 10:57:53AM +0800, Ziyang Zhang wrote:
> >>>> On 2023/3/28 23:09, Ming Lei wrote:
> >>>>> Apply io_uring fused command for supporting zero copy:
> >>>>>
> >>>>
> >>>> [...]
> >>>>
> >>>>>  
> >>>>> @@ -1374,7 +1533,12 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
> >>>>>  	if (!ubq || ub_cmd->q_id != ubq->q_id)
> >>>>>  		goto out;
> >>>>>  
> >>>>> -	if (ubq->ubq_daemon && ubq->ubq_daemon != current)
> >>>>> +	/*
> >>>>> +	 * The fused command reads the io buffer data structure only, so it
> >>>>> +	 * is fine to be issued from other context.
> >>>>> +	 */
> >>>>> +	if ((ubq->ubq_daemon && ubq->ubq_daemon != current) &&
> >>>>> +			(cmd_op != UBLK_IO_FUSED_SUBMIT_IO))
> >>>>>  		goto out;
> >>>>>  
> >>>>
> >>>> Hi Ming,
> >>>>
> >>>> What is your use case that fused io_uring cmd is issued from another thread?
> >>>> I think it is good practice to operate one io_uring instance in one thread
> >>>> only.
> >>>
> >>> So far we limit io command has to be issued from the queue context,
> >>> which is still not friendly from userspace viewpoint, the reason is
> >>> that we can't get io_uring exit notification and ublk's use case is
> >>> very special since the queued io command may not be completed forever,
> >>
> >> OK, so UBLK_IO_FUSED_SUBMIT_IO is guaranteed to be completed because it is
> >> not queued. FETCH_REQ and COMMIT_AMD_FETCH are queued io commands and could
> >> not be completed forever so they have to be issued from ubq_daemon. Right?
> > 
> > Yeah, any io command should be issued from ubq daemon context.
> > 
> >>
> >> BTW, maybe NEED_GET_DATA can be issued from other context...
> > 
> > So far it won't be supported.
> > 
> > As I mentioned in the link, if io_uring can provide io_uring exit
> > callback, we may relax this limit.
> > 
> 
> Hi, Ming
> 
> Sorry, I do not understand... I think UBLK_IO_NEED_GET_DATA is normal IO just like
> UBLK_IO_FUSED_SUBMIT_IO. It is issued from one pthread(ubq_daemon for now) and
> is completed just in time(not queued). So I think we can allow UBLK_IO_NEED_GET_DATA
> to be issued from other context.
 
No, it isn't.

UBLK_IO_FUSED_SUBMIT_IO is actually for handling target IO, and this
command just reads/provides IO buffer meta to io_uring in read-only
approach, and io buffer meta won't be changed, and any io state won't
be changed, so it is fine to call concurrently.

UBLK_IO_NEED_GET_DATA is still part of io commands, in which io->addr
needs to be set, and io->flags is touched, and it can't be done safely
concurrently.

Also after zero-copy is supported, UBLK_IO_NEED_GET_DATA may become
legacy code path, because ublk server can read/write io data directly
in userspace via read()/write(), and there isn't buffer allocation issue
any more.


Thanks,
Ming

