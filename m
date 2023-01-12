Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F173066699D
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 04:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235771AbjALD3A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Jan 2023 22:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbjALD3A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Jan 2023 22:29:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F7EF58C
        for <io-uring@vger.kernel.org>; Wed, 11 Jan 2023 19:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673494093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZqATCBylmzIm5uA7MHR7B6YsmXFJ81vSn/K1fYPQxmI=;
        b=Qu+Q6iJ8POUCiWBDskSRktFYthWxpZIVmnUep5z2DTghS7wqEMKhVnfd65K7QCGXi93HKs
        gS89qcLg0a4PXcNt7TL0AoFJA4GFYBSoq6NNltNMcvsfA6AidPtFgWtYygkoRNeMyFgMiF
        i8MjH8V8nEJbbdsf72ZA2KqqDglTdsU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-568-wAt01hg5MEuTSViogdhs9Q-1; Wed, 11 Jan 2023 22:28:09 -0500
X-MC-Unique: wAt01hg5MEuTSViogdhs9Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6080485A588;
        Thu, 12 Jan 2023 03:28:09 +0000 (UTC)
Received: from T590 (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7989F492B00;
        Thu, 12 Jan 2023 03:28:04 +0000 (UTC)
Date:   Thu, 12 Jan 2023 11:27:59 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@gmail.com>,
        ming.lei@redhat.com
Subject: Re: IOSQE_IO_LINK vs. short send of SOCK_STREAM
Message-ID: <Y79+P4EyU1O0bJPh@T590>
References: <Y77VIB1s6LurAvBd@T590>
 <b8011ec8-8d43-9b9b-4dcc-53b6cb272354@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8011ec8-8d43-9b9b-4dcc-53b6cb272354@samba.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Stefan and Jens,

Thanks for the help.

BTW, the issue is observed when I write ublk-nbd:

https://github.com/ming1/ubdsrv/commits/nbd

and it isn't completed yet(multiple send sqe chains not serialized
yet), the issue is triggered when writing big chunk data to ublk-nbd.

On Wed, Jan 11, 2023 at 05:32:00PM +0100, Stefan Metzmacher wrote:
> Hi Ming,
> 
> > Per my understanding, a short send on SOCK_STREAM should terminate the
> > remainder of the SQE chain built by IOSQE_IO_LINK.
> > 
> > But from my observation, this point isn't true when using io_sendmsg or
> > io_sendmsg_zc on TCP socket, and the other remainder of the chain still
> > can be completed after one short send is found. MSG_WAITALL is off.
> 
> This is due to legacy reasons, you need pass MSG_WAITALL explicitly
> in order to a retry or an error on a short write...
> It should work for send, sendmsg, sendmsg_zc, recv and recvmsg.

Turns out there is another application bug in which recv sqe may cut in the
send sqe chain.

After the issue is fixed, if MSG_WAITALL is set, short send can't be
observed any more. But if MSG_WAITALL isn't set, short send can be
observed and the send io chain still won't be terminated.

So if MSG_WAITALL is set, will io_uring be responsible for retry in case
of short send, and application needn't to take care of it?

> 
> For recv and recvmsg MSG_WAITALL also fails the link for MSG_TRUNC and MSG_CTRUNC.

OK, thanks for the sharing of recvmsg MSG_WAITALL.


Thanks,
Ming

