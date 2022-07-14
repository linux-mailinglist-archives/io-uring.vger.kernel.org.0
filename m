Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4CDB5741FC
	for <lists+io-uring@lfdr.de>; Thu, 14 Jul 2022 05:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbiGNDlK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jul 2022 23:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbiGNDlJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jul 2022 23:41:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 37FD725EB3
        for <io-uring@vger.kernel.org>; Wed, 13 Jul 2022 20:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657770067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3PqAwSujQrcFKBakWmxqsGxJDNIOKr6UoNvVqvwCEF4=;
        b=MmiaS8OhO/Vw1XlnNVqWgs3gEhj97Q7Sx6uOnFsK9mxfvdD89wnWszme+dI0amE20DB+MP
        jZ+5erJ/1KUERAHAEcA3jnYsSNZud1grxLfSQiu+Cg3lWIW8EUgRr4omOsn85YwyUVT0cB
        tgEggFpgb4/bD4Bgv3KydFir7DTO+/4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498-lj0l3Q0eN2CkbUOOcky_hw-1; Wed, 13 Jul 2022 23:41:00 -0400
X-MC-Unique: lj0l3Q0eN2CkbUOOcky_hw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E77CB1C14487;
        Thu, 14 Jul 2022 03:40:59 +0000 (UTC)
Received: from T590 (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D52C40CF8EE;
        Thu, 14 Jul 2022 03:40:51 +0000 (UTC)
Date:   Thu, 14 Jul 2022 11:40:46 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>,
        hch@lst.de, kbusch@kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        asml.silence@gmail.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com, ming.lei@redhat.com
Subject: Re: [PATCH for-next 3/4] io_uring: grow a field in struct
 io_uring_cmd
Message-ID: <Ys+QPjYBDoByrfw1@T590>
References: <20220711110155.649153-1-joshi.k@samsung.com>
 <CGME20220711110824epcas5p22c8e945cb8c3c3ac46c8c2b5ab55db9b@epcas5p2.samsung.com>
 <20220711110155.649153-4-joshi.k@samsung.com>
 <2b644543-9a54-c6c4-fd94-f2a64d0701fa@kernel.dk>
 <43955a42-7185-2afc-9a55-80cc2de53bf9@grimberg.me>
 <96fcba9a-76ad-8e04-e94e-b6ec5934f84e@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96fcba9a-76ad-8e04-e94e-b6ec5934f84e@grimberg.me>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jul 11, 2022 at 09:22:54PM +0300, Sagi Grimberg wrote:
> 
> > > > Use the leftover space to carve 'next' field that enables linking of
> > > > io_uring_cmd structs. Also introduce a list head and few helpers.
> > > > 
> > > > This is in preparation to support nvme-mulitpath, allowing multiple
> > > > uring passthrough commands to be queued.
> > > 
> > > It's not clear to me why we need linking at that level?
> > 
> > I think the attempt is to allow something like blk_steal_bios that
> > nvme leverages for io_uring_cmd(s).
> 
> I'll rephrase because now that I read it, I think my phrasing is
> confusing.
> 
> I think the attempt is to allow something like blk_steal_bios that
> nvme leverages, but for io_uring_cmd(s). Essentially allow io_uring_cmd
> to be linked in a requeue_list.

io_uring_cmd is 1:1 with pt request, so I am wondering why not retry on
io_uring_cmd instance directly via io_uring_cmd_execute_in_task().

I feels it isn't necessary to link io_uring_cmd into list.


Thanks,
Ming

