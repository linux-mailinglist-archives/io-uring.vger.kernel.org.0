Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5ECA6BFB32
	for <lists+io-uring@lfdr.de>; Sat, 18 Mar 2023 16:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjCRPZN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Mar 2023 11:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjCRPZM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Mar 2023 11:25:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3850F11152
        for <io-uring@vger.kernel.org>; Sat, 18 Mar 2023 08:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679153064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8MGgXv/RAmGO9QGKYr0U7pOcCt5cvIziOdzHGIhgrsc=;
        b=GoB+ieSzKacyi5GjDZ4SITcuEzhS6OquEMIATX0wEwe4Jxz/GCCAem5rbrYehiG8J9LpQJ
        oJRUzdIXXlxlmBmfUki2IzZn+rjXssczRSwSH6iGzKfvkrXBpf//+zrlkCCE7GOQUEpNw4
        b8voZFfne4Y4snrJbQj0UAo+b50BTPM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-576-AYQ4fit7OHiVdr7hVqXaAw-1; Sat, 18 Mar 2023 11:24:20 -0400
X-MC-Unique: AYQ4fit7OHiVdr7hVqXaAw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83CC180C8C2;
        Sat, 18 Mar 2023 15:24:19 +0000 (UTC)
Received: from ovpn-8-18.pek2.redhat.com (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 123B01121315;
        Sat, 18 Mar 2023 15:24:12 +0000 (UTC)
Date:   Sat, 18 Mar 2023 23:24:07 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>, ming.lei@redhat.com
Subject: Re: [PATCH V3 02/16] io_uring: add IORING_OP_FUSED_CMD
Message-ID: <ZBXXl1hftxHI46hV@ovpn-8-18.pek2.redhat.com>
References: <20230314125727.1731233-1-ming.lei@redhat.com>
 <20230314125727.1731233-3-ming.lei@redhat.com>
 <e92b121c-553a-b699-11ca-746ff2522d7e@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e92b121c-553a-b699-11ca-746ff2522d7e@kernel.dk>
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

On Sat, Mar 18, 2023 at 08:31:44AM -0600, Jens Axboe wrote:
> On 3/14/23 6:57?AM, Ming Lei wrote:
> > Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
> > be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
> > 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
> > to support slave OP, io_issue_defs[op].fused_slave has to be set as 1,
> > and its ->issue() needs to retrieve buffer from master request's
> > fused_cmd_kbuf.
> 
> Since we'd be introducing this as a new concept, probably makes sense to
> name it something other than master/slave. What about primary and
> secondary? Producer/consumer?

Either of the two looks fine for me, and I will take secondary in next
version if no one objects.

> 
> > +static inline bool io_fused_slave_write_to_buf(u8 op)
> > +{
> > +	switch (op) {
> > +	case IORING_OP_READ:
> > +	case IORING_OP_READV:
> > +	case IORING_OP_READ_FIXED:
> > +	case IORING_OP_RECVMSG:
> > +	case IORING_OP_RECV:
> > +		return 1;
> > +	default:
> > +		return 0;
> > +	}
> > +}
> 
> Maybe add a data direction bit to the hot opdef part? Any command that
> has fused support should ensure that it is set correctly.

Good idea!

> 
> > +int io_import_kbuf_for_slave(unsigned long buf_off, unsigned int len, int dir,
> > +		struct iov_iter *iter, struct io_kiocb *slave)
> > +{
> 
> The kbuf naming should probably also change, as it kind of overlaps with
> the kbufs we already have and which are not really related.

How about _bvec_buf_ or simply _buf_?

Thanks,
Ming

