Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A7677AFC6
	for <lists+io-uring@lfdr.de>; Mon, 14 Aug 2023 04:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbjHNC56 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Aug 2023 22:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbjHNC5n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Aug 2023 22:57:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F8CE6A
        for <io-uring@vger.kernel.org>; Sun, 13 Aug 2023 19:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691981811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=6Ouz6lpPfb5SvxjYTBP38rdfStyrfdgPblSJkeBMVTw=;
        b=HDp0dXFhB+KZKpkRT+3RBNhpVEnIhI1RRxoUpClc/40/0ATuEiIIsUBYENsN3LCMmQ9dOM
        YoVHPEcqS22rWpMGpQn0GkQPcKPuDQSGNh0bziAMRsnGPawHB/5z4E4euSLR03VGUCKBsM
        q8nF5nMF4mjU9eMGLqEjMxEPkOOvFuo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-175-RroH1CaVOVSQ3y3dRh3tvA-1; Sun, 13 Aug 2023 22:56:47 -0400
X-MC-Unique: RroH1CaVOVSQ3y3dRh3tvA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 608318DC671;
        Mon, 14 Aug 2023 02:56:47 +0000 (UTC)
Received: from fedora (unknown [10.72.120.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 65C34C15BAD;
        Mon, 14 Aug 2023 02:56:41 +0000 (UTC)
Date:   Mon, 14 Aug 2023 10:56:37 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     linux-block@vger.kernel.org, io-uring <io-uring@vger.kernel.org>,
        Andreas Hindborg <nmi@metaspace.dk>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        German Maglione <gmaglione@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Joe Thornber <ethornbe@redhat.com>
Cc:     ming.lei@redhat.com
Subject: Libublk-rs v0.1.0
Message-ID: <ZNmX5UQev4qvFMaq@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

Libublk-rs(Rust)[1][2] 0.1.0 is released.

The original idea is to use Rust to write ublk target for covering all
kinds of block queue limits/parameters combination easily when talking
with Andreas and Shinichiro about blktests in LSFMM/BPF 2023.

Finally it is evolved into one generic library. Attributed to Rust's
some modern language features, libublk interfaces are pretty simple:

- one closure(tgt_init) for user to customize device by providing all
  kind of parameter

- the other closure(io handling) for user to handling IO which is
  completely io_uring CQE driven: a) IO command CQE from ublk driver,
  b) target IO CQE originated from target io handling code, c) eventfd
  CQE if IO is offloaded to other context

With low level APIs, <50 LoC can build one ublk-null, and if high level
APIs are used, 30 LoC is enough.

Performance is basically aligned with pure C ublk implementation[3].

The library has been verified on null, ramdisk, loop and zoned target.
The plan is to support async/await in 0.2 or 0.3 so that libublk can
be used to build complicated target easily and efficiently.

Thanks Andreas for reviewing and providing lots of good ideas for
improvement & cleanup. Thanks German Maglione for some suggestions, such
as eventfd support. Thanks Joe for providing excellent Rust programming
guide.

Any feedback is welcome!

[1] https://crates.io/crates/libublk 
[2] https://github.com/ming1/libublk-rs
[3] https://github.com/osandov/blktests/blob/master/src/miniublk.c

Thanks,
Ming

