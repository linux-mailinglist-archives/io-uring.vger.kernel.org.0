Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6031F618D50
	for <lists+io-uring@lfdr.de>; Fri,  4 Nov 2022 01:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiKDApw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Nov 2022 20:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiKDApv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Nov 2022 20:45:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667FA22BE6
        for <io-uring@vger.kernel.org>; Thu,  3 Nov 2022 17:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667522701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hk17a/wyGHMD3AVv8URE6uxov/rnnGs5lYtB0Nz527o=;
        b=Y+shUiXWNGR5tlp/xB69n/O1d1onBr4tbuHtc1nn13Ehcj6Aj6fI3B7et/ImM9tPgH3T0j
        t/wKsvBw2/ryx1m9rGYrKxsjGTl+gjewk6DwzwWd9cQQIqh9VLVpl6V4fwAhSEGMzS+8kv
        DYwt8D3ViAO9hK6sBj1BmrEWbHqA50g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-217-VXyfvujDOkW7XH9WHCu37A-1; Thu, 03 Nov 2022 20:44:58 -0400
X-MC-Unique: VXyfvujDOkW7XH9WHCu37A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B62DC1C08981;
        Fri,  4 Nov 2022 00:44:57 +0000 (UTC)
Received: from T590 (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 14B6A2166B26;
        Fri,  4 Nov 2022 00:44:49 +0000 (UTC)
Date:   Fri, 4 Nov 2022 08:44:42 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bernd Schubert <bernd.schubert@fastmail.fm>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>
Subject: Re: [RFC PATCH 4/4] ublk_drv: support splice based read/write zero
 copy
Message-ID: <Y2Rgem8+oYafTLVO@T590>
References: <20221103085004.1029763-1-ming.lei@redhat.com>
 <20221103085004.1029763-5-ming.lei@redhat.com>
 <712cd802-f3bb-9840-e334-385cd42325f2@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <712cd802-f3bb-9840-e334-385cd42325f2@fastmail.fm>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Nov 03, 2022 at 11:28:29PM +0100, Bernd Schubert wrote:
> 
> 
> On 11/3/22 09:50, Ming Lei wrote:
> > Pass ublk block IO request pages to kernel backend IO handling code via
> > pipe, and request page copy can be avoided. So far, the existed
> > pipe/splice mechanism works for handling write request only.
> > 
> > The initial idea of using splice for zero copy is from Miklos and Stefan.
> > 
> > Read request's zero copy requires pipe's change to allow one read end to
> > produce buffers for another read end to consume. The added SPLICE_F_READ_TO_READ
> > flag is for supporting this feature.
> > 
> > READ is handled by sending IORING_OP_SPLICE with SPLICE_F_DIRECT |
> > SPLICE_F_READ_TO_READ. WRITE is handled by sending IORING_OP_SPLICE with
> > SPLICE_F_DIRECT. Kernel internal pipe is used for simplifying userspace,
> > meantime potential info leak could be avoided.
> 
> 
> Sorry to ask, do you have an ublk branch that gives an example how to use
> this?

Follows the ublk splice-zc branch:

https://github.com/ming1/ubdsrv/commits/splice-zc

which is mentioned in cover letter, but I guess it should be added to
here too, sorry for that, so far only ublk-loop supports it by:

   ublk add -t loop -f $BACKING -z

without '-z', ublk-loop is created with zero copy disabled.

> 
> I still have several things to fix in my branches, but I got basic fuse
> uring with copies working. Adding back splice would be next after posting
> rfc patches. My initial assumption was that I needed to duplicate everything
> splice does into the fuse .uring_cmd handler - obviously there is a better
> way with your patches.
> 
> This week I have a few days off, by end of next week or the week after I
> might have patches in an rfc state (one thing I'm going to ask about is how
> do I know what is the next CQE in the kernel handler - ublk does this with
> tags through mq, but I don't understand yet where the tag is increased and
> what the relation between tag and right CQE order is).

tag is one attribute of io request, which is originated from ublk
driver, and it is unique for each request among one queue. So ublksrv
won't change it at all, just use it, and ublk driver guarantees that
it is unique.

In ublkserv implementation, the tag info is set in cqe->user_data, so
we can retrieve the io request via tag part of cqe->user_data.

Also I may not understand your question of 'the relation between tag and right
CQE order', io_uring provides IOSQE_IO_DRAIN/IOSQE_IO_LINK for ordering
SQE, and ublksrv only applies IOSQE_IO_LINK in ublk-qcow2, so care to
explain it in a bit details about the "the relation between tag and right
CQE order"?

Thanks,
Ming

