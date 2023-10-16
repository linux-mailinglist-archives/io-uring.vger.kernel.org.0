Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE21B7CB727
	for <lists+io-uring@lfdr.de>; Tue, 17 Oct 2023 01:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233835AbjJPXsQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Oct 2023 19:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232873AbjJPXsP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Oct 2023 19:48:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41EE79F
        for <io-uring@vger.kernel.org>; Mon, 16 Oct 2023 16:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697500047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sAGcVE/fH0nRsrqW2OgxpuB+P9KPasHe0w9jHkYhKZo=;
        b=Ou2f6CeHbm37i6Kb0g2sar6vPIrLOLJlhksSm4q9RkukI3AH2Dnvb4103GVwvqGYx2uOcB
        cWDRRJyye3vNhpap+1ZC41bsILXoq7MQdCybsac2pQDvo29ABpNDvEkXhuuy+n3FQU6ntm
        gz6Yzt00gyNd3MlFeCouBBDALH7lxJ0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-352-wQBGl_BrM6--zXOYC2qzqw-1; Mon, 16 Oct 2023 19:47:23 -0400
X-MC-Unique: wQBGl_BrM6--zXOYC2qzqw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 920F63821346;
        Mon, 16 Oct 2023 23:47:23 +0000 (UTC)
Received: from fedora (unknown [10.72.120.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2EF2440C6F79;
        Mon, 16 Oct 2023 23:47:20 +0000 (UTC)
Date:   Tue, 17 Oct 2023 07:47:16 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH for-6.7/io_uring 0/7] ublk: simplify abort with
 cancelable uring_cmd
Message-ID: <ZS3LhEInXtaO+O1y@fedora>
References: <20231009093324.957829-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231009093324.957829-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Oct 09, 2023 at 05:33:15PM +0800, Ming Lei wrote:
> Hello,
> 
> Simplify ublk request & io command aborting handling with the new added
> cancelable uring_cmd. With this change, the aborting logic becomes
> simpler and more reliable, and it becomes easy to add new feature, such
> as relaxing queue/ublk daemon association.
> 
> Pass `blktests ublk` test, and pass lockdep when running `./check ublk`
> of blktests.

Hello Guys,

Ping...


Thanks,
Ming

