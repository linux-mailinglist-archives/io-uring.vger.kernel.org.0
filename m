Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57EFD693583
	for <lists+io-uring@lfdr.de>; Sun, 12 Feb 2023 02:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjBLBtb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Feb 2023 20:49:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjBLBta (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Feb 2023 20:49:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5B314EA0
        for <io-uring@vger.kernel.org>; Sat, 11 Feb 2023 17:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676166520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZaggVVaHvrWc+KyU+6eoEfqlbIXbTruhLVKeRsl67Fg=;
        b=Vl+u0B7/XLgz04LzMEeU7Og13ue5Bg/ll8JUmIXE8jeDDBophlrXxIT5hmh5u+kr1S6Mkz
        sjZ1CjlR+v1iuqjFHN3KdBwK5x4iWH8MqQWXcEFWC5yF5XqPgK9jmdfztqWZtPopA9vSBw
        XfcHKLK8b646O9Zz3tjkSgJmEsLI6SQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-316-CyeOiEpQPamJT12URdGq9g-1; Sat, 11 Feb 2023 20:48:34 -0500
X-MC-Unique: CyeOiEpQPamJT12URdGq9g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E914A3C0D869;
        Sun, 12 Feb 2023 01:48:33 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D12561121318;
        Sun, 12 Feb 2023 01:48:26 +0000 (UTC)
Date:   Sun, 12 Feb 2023 09:48:21 +0800
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
Subject: Re: [PATCH 3/4] io_uring: add IORING_OP_READ[WRITE]_SPLICE_BUF
Message-ID: <Y+hFZaFte9YyfVwR@T590>
References: <20230210153212.733006-1-ming.lei@redhat.com>
 <20230210153212.733006-4-ming.lei@redhat.com>
 <7323fbef-4790-3975-9c43-7ba4b7809c33@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7323fbef-4790-3975-9c43-7ba4b7809c33@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Feb 11, 2023 at 10:13:37AM -0700, Jens Axboe wrote:
> On 2/10/23 8:32?AM, Ming Lei wrote:
> 
> One more comment on this.
> 
> > +static int __io_prep_rw_splice_buf(struct io_kiocb *req,
> > +				   struct io_rw_splice_buf_data *data,
> > +				   struct file *splice_f,
> > +				   size_t len,
> > +				   loff_t splice_off)
> > +{
> > +	unsigned flags = req->opcode == IORING_OP_READ_SPLICE_BUF ?
> > +			SPLICE_F_KERN_FOR_READ : SPLICE_F_KERN_FOR_WRITE;
> > +	struct splice_desc sd = {
> > +		.total_len = len,
> > +		.flags = flags | SPLICE_F_NONBLOCK | SPLICE_F_KERN_NEED_CONFIRM,
> > +		.pos = splice_off,
> > +		.u.data = data,
> > +		.ignore_sig = true,
> > +	};
> > +
> > +	return splice_direct_to_actor(splice_f, &sd,
> > +			io_splice_buf_direct_actor);
> 
> Is this safe? We end up using current->splice_pipe here, which should be
> fine as long as things are left in a sane state after every operation.
> Which they should be, just like a syscall would. Just wanted to make
> sure you've considered that part.

Yeah.

Direct pipe is always left as empty when splice_direct_to_actor()
returns. Pipe buffers(pages) are produced from ->splice_read()
called from splice_direct_to_actor(), and consumed by
io_splice_buf_direct_actor().

If any error is returned, direct pipe is empty too, and we just
need to drop reference of sliced pages by io_rw_cleanup_splice_buf().


Thanks,
Ming

