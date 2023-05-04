Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B90A6F6DBB
	for <lists+io-uring@lfdr.de>; Thu,  4 May 2023 16:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbjEDOaK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 May 2023 10:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbjEDOaI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 May 2023 10:30:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12511212B
        for <io-uring@vger.kernel.org>; Thu,  4 May 2023 07:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683210565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2oqt9w9se5xqD0xq3HO1YVubTWdxt3SKIiZ823pUMhM=;
        b=irX0wxQesxx67GX+wgxOuhkqkYnTsD694+7DQPWh9Zf5DYzLzwD8HVjHkQdt3CjwtwzBSP
        Lafh4Q6waqOl6nLu9SBkjwWV4TBeLJqbKXUdUESboHowo7Xy1cG2w5hlrFUCID7D2wmgcD
        2GSCFuC89AhIjdocWTX9jmzVpnYowdE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-A0_kp1gJPtGgj9ECZFr1Qw-1; Thu, 04 May 2023 10:29:22 -0400
X-MC-Unique: A0_kp1gJPtGgj9ECZFr1Qw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F22685C6E2;
        Thu,  4 May 2023 14:29:21 +0000 (UTC)
Received: from ovpn-8-16.pek2.redhat.com (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D29801121331;
        Thu,  4 May 2023 14:29:14 +0000 (UTC)
Date:   Thu, 4 May 2023 22:29:09 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Breno Leitao <leitao@debian.org>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, hch@lst.de, axboe@kernel.dk, leit@fb.com,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        sagi@grimberg.me, joshi.k@samsung.com, kbusch@kernel.org
Subject: Re: [PATCH v4 2/3] io_uring: Pass whole sqe to commands
Message-ID: <ZFPBNWx6ZqYxiqB/@ovpn-8-16.pek2.redhat.com>
References: <20230504121856.904491-1-leitao@debian.org>
 <20230504121856.904491-3-leitao@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230504121856.904491-3-leitao@debian.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 04, 2023 at 05:18:55AM -0700, Breno Leitao wrote:
> Currently uring CMD operation relies on having large SQEs, but future
> operations might want to use normal SQE.
> 
> The io_uring_cmd currently only saves the payload (cmd) part of the SQE,
> but, for commands that use normal SQE size, it might be necessary to
> access the initial SQE fields outside of the payload/cmd block.  So,

Looks fine,

Reviewed-by: Ming Lei <ming.lei@redhat.com>

BTW, there might be risk[1] when accessing SQE fields which were read by
io_uring core code, and I'd suggest to document it in future.

[1] https://lore.kernel.org/io-uring/ZDlcXd4K+a2iGbnv@ovpn-8-21.pek2.redhat.com/

Thanks,
Ming

