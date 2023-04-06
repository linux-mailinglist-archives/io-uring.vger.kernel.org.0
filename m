Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5A046D8DBE
	for <lists+io-uring@lfdr.de>; Thu,  6 Apr 2023 04:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235313AbjDFCzL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Apr 2023 22:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235139AbjDFCyh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Apr 2023 22:54:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F226187
        for <io-uring@vger.kernel.org>; Wed,  5 Apr 2023 19:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680749629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0EtrX3Gh35VlslUqsN5Sc0w2Tb7N7aDs5RNQUwJgpn8=;
        b=G/7LEUFcI8cHZPTVs3WWxG6124FixEqaFl+jqq8/j9dJno3pu6L8ahhJ8hW3iQyFOpv2uH
        z2wH497VrZrRyy7kXvcVt0SVObIPNfA9m6DqeYpXrJgK3IWgc09GTjhxmZd8aNtDszRW4M
        PWypDsTCtk5ZrE2X+jLsOE5Pi9zQwL8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-416-fIO6PIDTP1KlbRBqC5ip_A-1; Wed, 05 Apr 2023 22:53:44 -0400
X-MC-Unique: fIO6PIDTP1KlbRBqC5ip_A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4491101A54F;
        Thu,  6 Apr 2023 02:53:43 +0000 (UTC)
Received: from ovpn-8-16.pek2.redhat.com (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DD606C158BA;
        Thu,  6 Apr 2023 02:53:40 +0000 (UTC)
Date:   Thu, 6 Apr 2023 10:53:35 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH] ublk: read any SQE values upfront
Message-ID: <ZC40LzYzBQJ2OVOx@ovpn-8-16.pek2.redhat.com>
References: <4ea9c4da-5eb8-c9b1-46de-93697291baa5@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ea9c4da-5eb8-c9b1-46de-93697291baa5@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 05, 2023 at 08:03:57PM -0600, Jens Axboe wrote:
> Since SQE memory is shared with userspace, we should only be reading it
> once. We cannot read it multiple times, particularly when it's read once
> for validation and then read again for the actual use.
> 
> ublk_ch_uring_cmd() is safe when called as a retry operation, as the
> memory backing is stable at that point. But for normal issue, we want
> to ensure that we only read ublksrv_io_cmd once. Wrap the function in
> a helper that reads the value into an on-stack copy of the struct.
> 
> Cc: stable@vger.kernel.org # 6.0+
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Reviewed-by: Ming Lei <ming.lei@redhat.com>


Thanks,
Ming

