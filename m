Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE18252A22B
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 14:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345513AbiEQMzj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 08:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243754AbiEQMzj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 08:55:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5543C21834
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 05:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652792137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CCBYm7JRURrb8ISptdPCXIyZxDNW+RgvRlpoFcroHpc=;
        b=Vcnzkr5Sm5A+VjeYv6CEcWTWb5+WL0i86lE/N8WGn92c1uo+7NMelAm0YDqgo4TCIl0cIN
        ENWBue1xjcr6wDxKhGn7FUeeCyxor2Cbs+Qye9Rs6oH5ISXWq/3VmhHxz0c+cwiAT39VkG
        laTEqm/uA98zsdOrD/bvyoUQ2tdkNNQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-QoLd5d2PMYWgONyitcW1ZQ-1; Tue, 17 May 2022 08:55:32 -0400
X-MC-Unique: QoLd5d2PMYWgONyitcW1ZQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A900C811E84;
        Tue, 17 May 2022 12:55:31 +0000 (UTC)
Received: from T590 (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D81F140CF8F6;
        Tue, 17 May 2022 12:55:25 +0000 (UTC)
Date:   Tue, 17 May 2022 20:55:20 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harris James R <james.r.harris@intel.com>,
        io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH V2 1/1] ubd: add io_uring based userspace block driver
Message-ID: <YoObOMur7x/u0w1C@T590>
References: <20220517055358.3164431-1-ming.lei@redhat.com>
 <20220517055358.3164431-2-ming.lei@redhat.com>
 <55d724a8-ed7d-ae92-ca6d-3582e13587db@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55d724a8-ed7d-ae92-ca6d-3582e13587db@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 17, 2022 at 06:00:57PM +0800, Ziyang Zhang wrote:
> On 2022/5/17 13:53, Ming Lei wrote:
> 
> > +
> > +static void ubd_cancel_queue(struct ubd_queue *ubq)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < ubq->q_depth; i++) {
> > +		struct ubd_io *io = &ubq->ios[i];
> > +
> > +		if (io->flags & UBD_IO_FLAG_ACTIVE) {
> > +			io->flags &= ~UBD_IO_FLAG_ACTIVE;
> > +			io_uring_cmd_done(io->cmd, UBD_IO_RES_ABORT, 0);
> > +		}
> > +	}
> > +}
> 
> Hi Ming,
> 
> When ubdsrv sends STOP_DEV and all active IOs in ubd_drv are done(UBD_IO_RES_ABORT),
> there may be still some IOs handled by ubdsrv(UBD_IO_FLAG_ACTIVE not set).
> When these IOs complete and return to ubd_drv, how to handle them?

Either UBD_IO_COMMIT_AND_FETCH_REQ or UBD_IO_COMMIT_REQ will be sent to ubd_drv
for completing these IOs. And finally ubd_cancel_dev() in ubd driver will
cancel all pending io commands, so io_uring can be exited. I guess
UBD_IO_COMMIT_REQ can be removed too.

> I find that UBD_IO_FETCH_REQ are still set,
> so will these IOs be issued to ubdsrv again or canceled?
> (I see ubd_drv fails IOs when the daemon is dying 
> but maybe here the daemon is still alive)

If daemon is alive, ubd_drv will rely on ubq_daemon for completing
all inflight IOs. Otherwise, the monitor work will be triggered for
completing/failing inflight IOs. The mechanism is actually very simple:

static void ubd_stop_dev(struct ubd_device *ub)
{
        mutex_lock(&ub->mutex);
        if (!disk_live(ub->ub_disk))
                goto unlock;

        del_gendisk(ub->ub_disk);	// drain & wait in-flight IOs
        ub->dev_info.state = UBD_S_DEV_DEAD;
        ub->dev_info.ubdsrv_pid = -1;
        ubd_cancel_dev(ub);	   //No IO is possible now, so cancel pending io commands
 unlock:
        mutex_unlock(&ub->mutex);
        cancel_delayed_work_sync(&ub->monitor_work);
}

When waiting for IO completion in del_gendisk(), in case that ubq_daemon
is exiting/dying, monitor work will be triggered to call ubd_abort_queue() to
fail in-flight requests for making forward progress. ubd_abort_queue() may
looks a bit tricky to try using task work for aborting request, that
is just for sync with ubd_rq_task_work_fn().


Thanks, 
Ming

