Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA897692E7B
	for <lists+io-uring@lfdr.de>; Sat, 11 Feb 2023 06:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjBKFPA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Feb 2023 00:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjBKFO7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Feb 2023 00:14:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BF53E0A9
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 21:14:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676092451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s8KnautA2Fk0+EDa7LcXrrB9n7OHEmNwB3VAKuuw6ZY=;
        b=EDleRg0RQ5/zo5AzpqS+ECE+rJJPNjO9Opb73sWbeNWlFuIoQn/zLuR8wPdvqf06q0HAXo
        Ynw770K9yJYmmyb/9H5XwXJy1hmc6L8rrVB+6vGadTm1bo+gbZSgOM4mdXHRz2S/Y5SEGU
        UO82aKfh/kT4Vp7H/vm8uFSkCYW38Kk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-XF7v7h2lNxGSI4WA4TepBQ-1; Sat, 11 Feb 2023 00:14:08 -0500
X-MC-Unique: XF7v7h2lNxGSI4WA4TepBQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A05D2811E6E;
        Sat, 11 Feb 2023 05:14:07 +0000 (UTC)
Received: from T590 (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D4CAC35453;
        Sat, 11 Feb 2023 05:14:00 +0000 (UTC)
Date:   Sat, 11 Feb 2023 13:13:55 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
        ming.lei@redhat.com
Subject: Re: [PATCH 0/4] io_uring: add IORING_OP_READ[WRITE]_SPLICE_BUF
Message-ID: <Y+ckE5Fly4gt7q2d@T590>
References: <20230210153212.733006-1-ming.lei@redhat.com>
 <95efc2bd-2f23-9325-5a38-c01cc349eb4a@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <95efc2bd-2f23-9325-5a38-c01cc349eb4a@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 10, 2023 at 02:54:29PM -0700, Jens Axboe wrote:
> On 2/10/23 8:32 AM, Ming Lei wrote:
> > Hello,
> > 
> > Add two OPs which buffer is retrieved via kernel splice for supporting
> > fuse/ublk zero copy.
> > 
> > The 1st patch enhances direct pipe & splice for moving pages in kernel,
> > so that the two added OPs won't be misused, and avoid potential security
> > hole.
> > 
> > The 2nd patch allows splice_direct_to_actor() caller to ignore signal
> > if the actor won't block and can be done in bound time.
> > 
> > The 3rd patch add the two OPs.
> > 
> > The 4th patch implements ublk's ->splice_read() for supporting
> > zero copy.
> > 
> > ublksrv(userspace):
> > 
> > https://github.com/ming1/ubdsrv/commits/io_uring_splice_buf
> >     
> > So far, only loop/null target implements zero copy in above branch:
> >     
> > 	ublk add -t loop -f $file -z
> > 	ublk add -t none -z
> > 
> > Basic FS/IO function is verified, mount/kernel building & fio
> > works fine, and big chunk IO(BS: 64k/512k) performance gets improved
> > obviously.
> 
> Do you have any performance numbers?

Simple test on ublk-loop over image in btrfs shows the improvement is
100% ~ 200%.

> Also curious on liburing regression
> tests, would be nice to see as it helps with review.

It isn't easy since it requires ublk device so far, it looks like
read to/write from one device buffer.

Thanks,
Ming

