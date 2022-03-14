Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33D04D86FC
	for <lists+io-uring@lfdr.de>; Mon, 14 Mar 2022 15:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235702AbiCNOf3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Mar 2022 10:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234542AbiCNOf3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Mar 2022 10:35:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 338B938780
        for <io-uring@vger.kernel.org>; Mon, 14 Mar 2022 07:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647268458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y8HXqoZS0yakVP1rRgpLH13VjxuiqLVz2udIjsoRQfM=;
        b=hKzWUxHBY1SHZ8PrWp9zuCtYZBHJo8JGQPelbFxlf52r9hkjL30yhjwGk3wrwP0ZQGFJgi
        WevUq3ETcT3ayfMJ9tfcU5hf5JAQzlCohf6/BKS51I5K2PXvoqAXyPpx0V8KR0rlPmISuq
        E4U2EpXknlWB2VPK4gzJl6hR8uLp5ZQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-YmGGBlXHNb-y4s2yNYNVQQ-1; Mon, 14 Mar 2022 10:34:12 -0400
X-MC-Unique: YmGGBlXHNb-y4s2yNYNVQQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10280804186;
        Mon, 14 Mar 2022 14:34:12 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0208E404C309;
        Mon, 14 Mar 2022 14:34:02 +0000 (UTC)
Date:   Mon, 14 Mar 2022 22:33:57 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk,
        kbusch@kernel.org, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, pankydev8@gmail.com, javier@javigon.com,
        mcgrof@kernel.org, a.manzanares@samsung.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
Subject: Re: [PATCH 09/17] io_uring: plug for async bypass
Message-ID: <Yi9SVXAs8TlIcIkU@T590>
References: <20220308152105.309618-1-joshi.k@samsung.com>
 <CGME20220308152711epcas5p31de5d63f5de91fae94e61e5c857c0f13@epcas5p3.samsung.com>
 <20220308152105.309618-10-joshi.k@samsung.com>
 <20220310083303.GC26614@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310083303.GC26614@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 10, 2022 at 09:33:03AM +0100, Christoph Hellwig wrote:
> On Tue, Mar 08, 2022 at 08:50:57PM +0530, Kanchan Joshi wrote:
> > From: Jens Axboe <axboe@kernel.dk>
> > 
> > Enable .plug for uring-cmd.
> 
> This should go into the patch adding the
> IORING_OP_URING_CMD/IORING_OP_URING_CMD_FIXED.

Plug support for passthrough rq is added in the following patch, so
this one may be put after patch 'block: wire-up support for plugging'.


Thanks,
Ming

