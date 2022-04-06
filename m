Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0A24F651E
	for <lists+io-uring@lfdr.de>; Wed,  6 Apr 2022 18:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237433AbiDFQLU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Apr 2022 12:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237509AbiDFQLN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Apr 2022 12:11:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 295D0FD25
        for <io-uring@vger.kernel.org>; Tue,  5 Apr 2022 20:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649217444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l1hic86CSR5VLwQg06HH/TXIw0Roul04b2qrqSXwaU4=;
        b=Lr1WH206HzDzNTAkiUM443Y40q6toBoZnluyIWagCyU98WqoBewZlTfUQkdl/u5tVVloKH
        ptqJsRKjJkAVyE/2XjPO5hmRPOhyriOEZNAwV7L8KVpqeOns2r0/Rq/v46G7sEnruiFEgG
        qKqeppind0EiIa829i9M0xHe6n17SFQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-147-WWxBWJEEMuu3YojVXd3GeA-1; Tue, 05 Apr 2022 23:57:19 -0400
X-MC-Unique: WWxBWJEEMuu3YojVXd3GeA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6FAF63811A29;
        Wed,  6 Apr 2022 03:57:19 +0000 (UTC)
Received: from T590 (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A095F403D1DD;
        Wed,  6 Apr 2022 03:57:15 +0000 (UTC)
Date:   Wed, 6 Apr 2022 11:57:09 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>
Subject: Re: [RFC PATCH] io_uring: reissue in case -EAGAIN is returned after
 io issue returns
Message-ID: <Yk0PlfaGooaFdvmm@T590>
References: <20220403114532.180945-1-ming.lei@redhat.com>
 <f2819e9f-4445-5c5a-2a68-1d85f4bc341a@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2819e9f-4445-5c5a-2a68-1d85f4bc341a@kernel.dk>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Apr 05, 2022 at 08:20:24PM -0600, Jens Axboe wrote:
> On 4/3/22 5:45 AM, Ming Lei wrote:
> > -EAGAIN still may return after io issue returns, and REQ_F_REISSUE is
> > set in io_complete_rw_iopoll(), but the req never gets chance to be handled.
> > io_iopoll_check doesn't handle this situation, and io hang can be caused.
> > 
> > Current dm io polling may return -EAGAIN after bio submission is
> > returned, also blk-throttle might trigger this situation too.
> 
> I don't think this is necessarily safe. Handling REQ_F_ISSUE from within
> the issue path is fine, as the request hasn't been submitted yet and
> hence we know that passed in structs are still stable. Once you hit it
> when polling for it, the io_uring_enter() call to submit requests has
> potentially already returned, and now we're in a second call where we
> are polling for requests. If we're doing eg an IORING_OP_READV, the
> original iovec may no longer be valid and we cannot safely re-import
> data associated with it.

Yeah, this reissue is really not safe, thanks for the input.

I guess the only way is to complete the cqe for this situation.

> 
> Hence I don't think the patch is safe and we cannot reliably handle this
> scenario. dm would need to retry internally for this.

Another scenario might be bio throttle, which may delay submit_bio into kthrotld
wq context, where request allocation can return -EAGAIN too.

But I don't reproduce the problem in this scenario yet.


Thanks,
Ming

