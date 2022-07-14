Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E18AF575027
	for <lists+io-uring@lfdr.de>; Thu, 14 Jul 2022 15:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240367AbiGNN6K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jul 2022 09:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240396AbiGNN5y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jul 2022 09:57:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 588B066BAB
        for <io-uring@vger.kernel.org>; Thu, 14 Jul 2022 06:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657806933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KhtmeoLhSVw8TxG3EM8WGDxXWprw20ODCHZnU0rs1oc=;
        b=GxLX5E7PV31+0ZbyLD8LO/zId7RETKoBxK67usXF/eYe3cC13GJLJ+FmG/qIdiyFXxbNFz
        jTepadlQ4neozSNrrMIe/d1tpkB4GiJXdnq7pW1UuqaWSBqBjOgJ6Wyy5ioNs9Si0vvo8h
        cURdxiub35WrtuiHqLJLDlT9ZMQ1iK4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-267-JLYhTxIqP1mO5l_seL57XQ-1; Thu, 14 Jul 2022 09:55:32 -0400
X-MC-Unique: JLYhTxIqP1mO5l_seL57XQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96B5A80418F;
        Thu, 14 Jul 2022 13:55:30 +0000 (UTC)
Received: from T590 (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1618A2026D64;
        Thu, 14 Jul 2022 13:55:22 +0000 (UTC)
Date:   Thu, 14 Jul 2022 21:55:17 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     hch@lst.de, sagi@grimberg.me, kbusch@kernel.org, axboe@kernel.dk,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, asml.silence@gmail.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com,
        ming.lei@redhat.com
Subject: Re: [PATCH for-next 1/4] io_uring, nvme: rename a function
Message-ID: <YtAgReh6PnevFwzX@T590>
References: <20220711110155.649153-1-joshi.k@samsung.com>
 <CGME20220711110800epcas5p3d338dd486fd778c5ba5bfe93a91ec8bd@epcas5p3.samsung.com>
 <20220711110155.649153-2-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711110155.649153-2-joshi.k@samsung.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jul 11, 2022 at 04:31:52PM +0530, Kanchan Joshi wrote:
> io_uring_cmd_complete_in_task() is bit of a misnomer. It schedules a
> callback function for execution in task context. What callback does is
> private to provider, and does not have to be completion. So rename it to
> io_uring_cmd_execute_in_task() to allow more generic use.
> 
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>

ublk driver has same usage, and this change makes sense:

Reviewed-by: Ming Lei <ming.lei@redhat.com>

thanks,
Ming

