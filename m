Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 045517077ED
	for <lists+io-uring@lfdr.de>; Thu, 18 May 2023 04:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbjERCQq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 May 2023 22:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjERCQp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 May 2023 22:16:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3EB92112
        for <io-uring@vger.kernel.org>; Wed, 17 May 2023 19:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684376158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K4DhnB/Mb2qNxRJ3dsE4nmeKE6kddWJ9OIHGaovDSrY=;
        b=bECWHKc7YTJqE+AVF19f0j5CA0bjz1WAlSlrMmxKDs6+K9+KCdoAIbV1oIisKUBcjTZJGF
        bTDRXJOgN1I7OY/McQU6+K1jqQjK3YkskFqth2MUTUOQHeOVo9qp59qeNcGbwU/sz6Qjyi
        MfPcTQgGkG+PmONOkF5lAU17w2/hNdk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-260-iKt4YJhNO2qHogQuhPRxig-1; Wed, 17 May 2023 22:15:54 -0400
X-MC-Unique: iKt4YJhNO2qHogQuhPRxig-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2D2E185A79C;
        Thu, 18 May 2023 02:15:53 +0000 (UTC)
Received: from ovpn-8-16.pek2.redhat.com (ovpn-8-25.pek2.redhat.com [10.72.8.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1EDDEC16024;
        Thu, 18 May 2023 02:15:47 +0000 (UTC)
Date:   Thu, 18 May 2023 10:15:42 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        kbusch@kernel.org, sagi@grimberg.me, joshi.k@samsung.com,
        ming.lei@redhat.com
Subject: Re: [PATCH for-next 2/2] nvme: optimise io_uring passthrough
 completion
Message-ID: <ZGWKTpRLIJ0NBPIt@ovpn-8-16.pek2.redhat.com>
References: <cover.1684154817.git.asml.silence@gmail.com>
 <ecdfacd0967a22d88b7779e2efd09e040825d0f8.1684154817.git.asml.silence@gmail.com>
 <20230517072314.GC27026@lst.de>
 <9367cc09-c8b4-a56c-a61a-d2c776c05a1c@gmail.com>
 <84e1ce69-d6d5-5509-4665-2d153e294fc8@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84e1ce69-d6d5-5509-4665-2d153e294fc8@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 17, 2023 at 01:31:00PM -0600, Jens Axboe wrote:
> On 5/17/23 6:32 AM, Pavel Begunkov wrote:
> > On 5/17/23 08:23, Christoph Hellwig wrote:
> >> On Mon, May 15, 2023 at 01:54:43PM +0100, Pavel Begunkov wrote:
> >>> Use IOU_F_TWQ_LAZY_WAKE via iou_cmd_exec_in_task_lazy() for passthrough
> >>> commands completion. It further delays the execution of task_work for
> >>> DEFER_TASKRUN until there are enough of task_work items queued to meet
> >>> the waiting criteria, which reduces the number of wake ups we issue.
> >>
> >> Why wouldn't you just do that unconditionally for
> >> io_uring_cmd_complete_in_task?
> > 
> > 1) ublk does secondary batching and so may produce multiple cqes,
> > that's not supported. I believe Ming sent patches removing it,
> > but I'd rather not deal with conflicts for now.
> 
> Ming, what's the status of those patches? Looks like we'll end up
> with a dependency regardless of the ordering of these. Since these
> patches are here now, sanest approach seems to move forward with
> this series and defer the conflict resolving to the ublk side.

I didn't send patch to remove the batch in ublk, such as, the following
line code:

ublk_queue_cmd():
	...
	if (!llist_add(&data->node, &ubq->io_cmds))
		return;
	...

But I did want to kill it given __io_req_task_work_add() can do batching
process, but we have to re-order request in this list, so can't remove it
now simply, see commit:

	7d4a93176e01 ("ublk_drv: don't forward io commands in reserve order")

Pavel must have misunderstood the following one as the batch removal:

https://lore.kernel.org/linux-block/20230427124414.319945-2-ming.lei@redhat.com/

	

thanks,
Ming

