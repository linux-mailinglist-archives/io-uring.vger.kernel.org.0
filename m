Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3570588BAC
	for <lists+io-uring@lfdr.de>; Wed,  3 Aug 2022 14:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237483AbiHCMAJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Aug 2022 08:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237606AbiHCMAJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Aug 2022 08:00:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EEB7451A0D
        for <io-uring@vger.kernel.org>; Wed,  3 Aug 2022 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659528006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u51y8lvI4jIGHzaIcj17vuVT3EdSyextzm1tmfDOnHg=;
        b=EIzgztZm/X1BWRqdCLem6KRwlELBYvQd+RfBpai0xd5U94hZSsksEiryX4bfDz0y5y45Vr
        myrf/jzr3H5+sd3P+kNkHA7qkEdg2am80Hf5DPJauJLhODno9dTXVkXLKhi9SD+vs4MP2x
        57UnWB3+e8qoQC7TUAKLX7xw4NxgFiw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-Pup0sDaBNiiV1kOqfV3Mlg-1; Wed, 03 Aug 2022 08:00:05 -0400
X-MC-Unique: Pup0sDaBNiiV1kOqfV3Mlg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CDE5C85A589;
        Wed,  3 Aug 2022 12:00:04 +0000 (UTC)
Received: from T590 (ovpn-8-26.pek2.redhat.com [10.72.8.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 56A70492C3B;
        Wed,  3 Aug 2022 12:00:01 +0000 (UTC)
Date:   Wed, 3 Aug 2022 19:59:57 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring: pass correct parameters to io_req_set_res
Message-ID: <YupjPW8rSwVu6UHR@T590>
References: <20220803110938.1564772-1-ming.lei@redhat.com>
 <48b58f2b-014c-cbc6-36c3-29be42040fa0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48b58f2b-014c-cbc6-36c3-29be42040fa0@gmail.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 03, 2022 at 12:40:17PM +0100, Pavel Begunkov wrote:
> On 8/3/22 12:09, Ming Lei wrote:
> > The two parameters of 'res' and 'cflags' are swapped, so fix it.
> > Without this fix, 'ublk del' hangs forever.
> 
> Looks good, but the "Fixes" tag is not right
> 
> Fixes: de23077eda61f ("io_uring: set completion results upfront")

Indeed, the issue is firstly added in above commit.


Thanks,
Ming

