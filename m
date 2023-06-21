Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 679F373847A
	for <lists+io-uring@lfdr.de>; Wed, 21 Jun 2023 15:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbjFUNJy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Jun 2023 09:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbjFUNJj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Jun 2023 09:09:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BBD19BD
        for <io-uring@vger.kernel.org>; Wed, 21 Jun 2023 06:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687352929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1JgrEcS0Br0aefCiXM+emWG3xNpewBxr3AH6tu5AYTo=;
        b=P6GKTzQ/7ej5iO8lKnI2zd7rPTb1sjOIEDkV4mjaV/xZAOLr4v99dSx8fC4GMEf2IfMTEG
        5tu7BdY/fMcuyqGU//t4g2+kbUrNwQrpP7A64S0UyYS/sZxh1IbCYzz6rfyhdGLvfFeDC4
        uOrV++X5ShjYiiwKvgxOBwrTJy/jq7I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-383-K8hnjCZmPfeWHQqffw8J8A-1; Wed, 21 Jun 2023 09:08:45 -0400
X-MC-Unique: K8hnjCZmPfeWHQqffw8J8A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C1B003C108DA;
        Wed, 21 Jun 2023 13:08:44 +0000 (UTC)
Received: from ovpn-8-23.pek2.redhat.com (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6AFC12166B32;
        Wed, 21 Jun 2023 13:08:41 +0000 (UTC)
Date:   Wed, 21 Jun 2023 21:08:36 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Guangwu Zhang <guazhang@redhat.com>
Cc:     linux-block@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        io-uring@vger.kernel.org, John Meneghini <jmeneghi@redhat.com>
Subject: Re: [bug report] system will hung up when cpu hot plug
Message-ID: <ZJL2VCYcmUxpkXte@ovpn-8-23.pek2.redhat.com>
References: <CAGS2=YoVrLmiFADaLJJCerGdyRZJk2qKXhQL1qpH61YpCMqJFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGS2=YoVrLmiFADaLJJCerGdyRZJk2qKXhQL1qpH61YpCMqJFw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 21, 2023 at 12:11:24PM +0800, Guangwu Zhang wrote:
> Hello
> 
> We found this kernel issue with latest linux-block/for-next, let me
> know if you need more info/testing, thanks
> 
> kernel repo:
>     Merge branch 'for-6.5/block' into for-next
>     * for-6.5/block:
>       reiserfs: fix blkdev_put() warning from release_journal_dev()
> 
> test steps:
> 1. run cpu online/offline in background
> 2. run fio with ioengine=io_uring_cmd
> 

Hi Guangwu,

I have looked at dmesg log and it happens in case of io scheduler & pt request.

Please try the following patch, and the issue should be introduced from
d97217e7f024 ("blk-mq: don't queue plugged passthrough requests into scheduler").


diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4c02c28b4835..0433fb43223b 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2750,7 +2750,12 @@ static void blk_mq_dispatch_plug_list(struct blk_plug *plug, bool from_sched)

        percpu_ref_get(&this_hctx->queue->q_usage_counter);
        /* passthrough requests should never be issued to the I/O scheduler */
-       if (this_hctx->queue->elevator && !is_passthrough) {
+       if (is_passthrough) {
+               spin_lock(&this_hctx->lock);
+               list_splice_tail_init(&list, &this_hctx->dispatch);
+               spin_unlock(&this_hctx->lock);
+               blk_mq_run_hw_queue(this_hctx, from_sched);
+       } if (this_hctx->queue->elevator) {
                this_hctx->queue->elevator->type->ops.insert_requests(this_hctx,
                                &list, 0);
                blk_mq_run_hw_queue(this_hctx, from_sched);


Thanks, 
Ming

