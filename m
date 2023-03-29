Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A589E6CD7F1
	for <lists+io-uring@lfdr.de>; Wed, 29 Mar 2023 12:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjC2KxI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Mar 2023 06:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjC2KxH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Mar 2023 06:53:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2F21BF0
        for <io-uring@vger.kernel.org>; Wed, 29 Mar 2023 03:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680087142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vt4GbeiJahK3rYATBBFKElTyofWu9KBjUwoqXIAEnS0=;
        b=QXyCgCqGBj+8siJwRYwWP3yPzSuorPHZBKwbdJltraaYsp2Tizm/PJ2EVldXYQ5x/3ISzZ
        9WV/nEkLMAjnyGDAmAnYGvuM0Ul7wXTPUfy5g/ZFh+H8aMfDtLkSfG2eR0JiU8rUlT1pJM
        nN6c/ljA1W60cNZhhoZb+uPjj1XupmE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-176-Y6_TOEgZN4umpv5DAoQyUg-1; Wed, 29 Mar 2023 06:52:19 -0400
X-MC-Unique: Y6_TOEgZN4umpv5DAoQyUg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B7131C07822;
        Wed, 29 Mar 2023 10:52:18 +0000 (UTC)
Received: from ovpn-8-26.pek2.redhat.com (ovpn-8-26.pek2.redhat.com [10.72.8.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5CB7718EC2;
        Wed, 29 Mar 2023 10:52:10 +0000 (UTC)
Date:   Wed, 29 Mar 2023 18:52:06 +0800
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
Message-ID: <ZCQYVhStekJXpvK1@ovpn-8-26.pek2.redhat.com>
References: <20230328150958.1253547-1-ming.lei@redhat.com>
 <20230328150958.1253547-17-ming.lei@redhat.com>
 <2e3c20e0-a0be-eaf3-b288-c3c8fa31d1fa@linux.alibaba.com>
 <ZCP+L0ADCxHo5vSg@ovpn-8-26.pek2.redhat.com>
 <08b047a8-c577-a717-81a8-db8fca8ebab6@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08b047a8-c577-a717-81a8-db8fca8ebab6@linux.alibaba.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 29, 2023 at 06:01:16PM +0800, Ziyang Zhang wrote:
> On 2023/3/29 17:00, Ming Lei wrote:
> > On Wed, Mar 29, 2023 at 10:57:53AM +0800, Ziyang Zhang wrote:
> >> On 2023/3/28 23:09, Ming Lei wrote:
> >>> Apply io_uring fused command for supporting zero copy:
> >>>
> >>
> >> [...]
> >>
> >>>  
> >>> @@ -1374,7 +1533,12 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
> >>>  	if (!ubq || ub_cmd->q_id != ubq->q_id)
> >>>  		goto out;
> >>>  
> >>> -	if (ubq->ubq_daemon && ubq->ubq_daemon != current)
> >>> +	/*
> >>> +	 * The fused command reads the io buffer data structure only, so it
> >>> +	 * is fine to be issued from other context.
> >>> +	 */
> >>> +	if ((ubq->ubq_daemon && ubq->ubq_daemon != current) &&
> >>> +			(cmd_op != UBLK_IO_FUSED_SUBMIT_IO))
> >>>  		goto out;
> >>>  
> >>
> >> Hi Ming,
> >>
> >> What is your use case that fused io_uring cmd is issued from another thread?
> >> I think it is good practice to operate one io_uring instance in one thread
> >> only.
> > 
> > So far we limit io command has to be issued from the queue context,
> > which is still not friendly from userspace viewpoint, the reason is
> > that we can't get io_uring exit notification and ublk's use case is
> > very special since the queued io command may not be completed forever,
> 
> OK, so UBLK_IO_FUSED_SUBMIT_IO is guaranteed to be completed because it is
> not queued. FETCH_REQ and COMMIT_AMD_FETCH are queued io commands and could
> not be completed forever so they have to be issued from ubq_daemon. Right?

Yeah, any io command should be issued from ubq daemon context.

> 
> BTW, maybe NEED_GET_DATA can be issued from other context...

So far it won't be supported.

As I mentioned in the link, if io_uring can provide io_uring exit
callback, we may relax this limit.

> 
> > see:
> > 
> > https://lore.kernel.org/linux-fsdevel/ZBxTdCj60+s1aZqA@ovpn-8-16.pek2.redhat.com/
> > 
> > I remember that people raised concern about this implementation.
> > 
> > But for normal IO, it could be issued from io wq simply because of
> > link(dependency) or whatever, and userspace is still allowed to submit
> > io from another pthread via same io_uring ctx.
> 
> Yes, we can submit to the same ctx from different pthread but lock may be required.

Right.

> IMO, users may only choose ubq_daemon as the only submitter.

At least any io command should be issued from ubq daemon now, but normal
io can be issued from any context.


Thanks,
Ming

