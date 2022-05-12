Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E74C552481C
	for <lists+io-uring@lfdr.de>; Thu, 12 May 2022 10:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351681AbiELIot (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 May 2022 04:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351673AbiELIos (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 May 2022 04:44:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7214F2265C7
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 01:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652345082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c8Uv33sQzQ6sncxKZAh6lI3KSUSZf2EKQdApwYwgjD4=;
        b=MHyFK+OfYSsNUs5/MmVYHVSV+YLMVUNYibrXHwwNFuwAeX3+jVGLiaADOC9k+TojohzUIP
        sLaG4DjSzCUBu6nh2K7l7FzMdhHGJAkC26prEo8RjJ9aocf6S4P2ApmMGNWl5++BiSbI/K
        jxWrkIqoB/Eq5uu/813i1jlmKuxtpIU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-292-HPDrJzHyN6mGuunDkRHdWQ-1; Thu, 12 May 2022 04:44:41 -0400
X-MC-Unique: HPDrJzHyN6mGuunDkRHdWQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 51ED43C161A6;
        Thu, 12 May 2022 08:44:40 +0000 (UTC)
Received: from T590 (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E4BFCC28106;
        Thu, 12 May 2022 08:44:33 +0000 (UTC)
Date:   Thu, 12 May 2022 16:44:28 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, mcgrof@kernel.org, shr@fb.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
Subject: Re: [PATCH v5 2/6] block: wire-up support for passthrough plugging
Message-ID: <YnzI7CgI+KOHNKPb@T590>
References: <20220511054750.20432-1-joshi.k@samsung.com>
 <CGME20220511055310epcas5p46650f5b6fe963279f686b8f50a98a286@epcas5p4.samsung.com>
 <20220511054750.20432-3-joshi.k@samsung.com>
 <YnyaRB+u1x6nIVp1@T590>
 <20220512080912.GA26882@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512080912.GA26882@lst.de>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 12, 2022 at 10:09:12AM +0200, Christoph Hellwig wrote:
> On Thu, May 12, 2022 at 01:25:24PM +0800, Ming Lei wrote:
> > This way may cause nested plugging, and breaks xfstests generic/131.
> > Also may cause io hang since request can't be polled before flushing
> > plug in blk_execute_rq().
> 
> Looking at this again, yes blk_mq_request_bypass_insert is probably the
> wrong place.
> 
> > I'd suggest to apply the plug in blk_execute_rq_nowait(), such as:
> 
> Do we really need the use_plug parameter and the extra helper?  If
> someone holds a plug over passthrough command submission I think
> we can assume they actually do want to use it.  Otherwise this does
> indeed look like the better plan.

use_plug is just for avoiding hang in blk_rq_poll_completion(), so
I think we can bypass plug if one polled rq is executed inside
blk_execute_rq().


Thanks,
Ming

