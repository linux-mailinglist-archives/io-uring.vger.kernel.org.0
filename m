Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04345665F0C
	for <lists+io-uring@lfdr.de>; Wed, 11 Jan 2023 16:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbjAKP1c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Jan 2023 10:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235423AbjAKP1Z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Jan 2023 10:27:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55253B5
        for <io-uring@vger.kernel.org>; Wed, 11 Jan 2023 07:26:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673450802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=DKrTkLQNr7Smr8b421JTg/8Uo/KecpxZ8mj2y2ftGmE=;
        b=jKuCokoOyx542DxQ8H1Uci87z9mvj4ixspccPUwhpJM3c/1NLSbCAJSbGalWZ6Gd3K1PTf
        VtBcpKZRr+Md7Aj7xAsHllwrdVI4a7kcK/+WvQDWbLC1nLKFOxNrj7eXlzo/b1kn8vBzZr
        t6fbi8BkEVIJGY16kLnSpcayCPQe820=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-nZ1Bt5PvOLqZ2iMXXUzd7A-1; Wed, 11 Jan 2023 10:26:37 -0500
X-MC-Unique: nZ1Bt5PvOLqZ2iMXXUzd7A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 604D9101B44E;
        Wed, 11 Jan 2023 15:26:37 +0000 (UTC)
Received: from T590 (ovpn-8-28.pek2.redhat.com [10.72.8.28])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C0230140EBF4;
        Wed, 11 Jan 2023 15:26:30 +0000 (UTC)
Date:   Wed, 11 Jan 2023 23:26:24 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     ming.lei@redhat.com, Stefan Metzmacher <metze@samba.org>,
        David Ahern <dsahern@gmail.com>
Subject: IOSQE_IO_LINK vs. short send of SOCK_STREAM
Message-ID: <Y77VIB1s6LurAvBd@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Guy,

Per my understanding, a short send on SOCK_STREAM should terminate the
remainder of the SQE chain built by IOSQE_IO_LINK.

But from my observation, this point isn't true when using io_sendmsg or
io_sendmsg_zc on TCP socket, and the other remainder of the chain still
can be completed after one short send is found. MSG_WAITALL is off.

For SOCK_STREAM, IOSQE_IO_LINK probably is the only way of io_uring for
sending data correctly in batch. However, it depends on the assumption
of chain termination by short send.

Appreciate any comment.

Thanks,
Ming

