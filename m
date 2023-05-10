Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 963BA6FD754
	for <lists+io-uring@lfdr.de>; Wed, 10 May 2023 08:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjEJGnu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 May 2023 02:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjEJGnt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 May 2023 02:43:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44FA421D
        for <io-uring@vger.kernel.org>; Tue,  9 May 2023 23:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683700980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uUO+GadAv8+CiSraXg0aRiOtPyiinll1bmflSFNqiGA=;
        b=U9pUHZcukRYeUvaZVEz+NmuDY2AWCNDLaKuSvba/fBE0E+fv516CG3kbqnPNPvnJX6j/iz
        /H0dEe01HaKMmBt/l2658Abzq+DhoeYpS0gD6dga0ynAOaNSB279+Jzwo+giIL2Y+OdQsz
        kaGWShn53278JN/8F+U0o+CWCmAQaao=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-446-MnZrY7yLPlOeXZ23moBw-g-1; Wed, 10 May 2023 02:39:29 -0400
X-MC-Unique: MnZrY7yLPlOeXZ23moBw-g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 84DD5870820;
        Wed, 10 May 2023 06:39:28 +0000 (UTC)
Received: from fedora (unknown [10.22.50.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 16BC418EC1;
        Wed, 10 May 2023 06:39:25 +0000 (UTC)
Date:   Wed, 10 May 2023 14:39:23 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Guangwu Zhang <guazhang@redhat.com>
Cc:     Yu Kuai <yukuai1@huaweicloud.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Jan Kara <jack@suse.cz>,
        Paolo Valente <paolo.valente@linaro.org>,
        "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [bug report] BUG: kernel NULL pointer dereference, address:
 0000000000000048
Message-ID: <ZFs8G9RmHLYZ2Q0N@fedora>
References: <CAGS2=YosaYaUTEMU3uaf+y=8MqSrhL7sYsJn8EwbaM=76p_4Qg@mail.gmail.com>
 <ecb54b0d-a90e-a2c9-dfe5-f5cec70be928@huaweicloud.com>
 <cde5d326-4dcb-5b9c-9d58-fb1ef4b7f7a8@huaweicloud.com>
 <007af59f-4f4c-f779-a1b6-aaa81ff640b3@huaweicloud.com>
 <1155743b-2073-b778-1ec5-906300e0570a@kernel.dk>
 <7def2fca-c854-f88e-3a77-98a999f7b120@huaweicloud.com>
 <CAGS2=YocNy9PkgRzzRdHAK1gGdjMxzA--PYS=sPrX_nCe4U6QA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGS2=YocNy9PkgRzzRdHAK1gGdjMxzA--PYS=sPrX_nCe4U6QA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 10, 2023 at 12:05:07PM +0800, Guangwu Zhang wrote:
> HI,
> after apply your patch[1], the system will panic after reboot.
> 

Maybe you can try the following patch?

diff --git a/block/blk-mq.c b/block/blk-mq.c
index f6dad0886a2f..d84174a7e997 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1303,7 +1303,7 @@ void blk_execute_rq_nowait(struct request *rq, bool at_head)
         * device, directly accessing the plug instead of using blk_mq_plug()
         * should not have any consequences.
         */
-       if (current->plug && !at_head) {
+       if (current->plug && !at_head && rq->bio) {
                blk_add_rq_to_plug(current->plug, rq);
                return;
        }


thanks, 
Ming

