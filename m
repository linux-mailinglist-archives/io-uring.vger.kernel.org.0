Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D90673BA0
	for <lists+io-uring@lfdr.de>; Thu, 19 Jan 2023 15:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbjASOY3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Jan 2023 09:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjASOY3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Jan 2023 09:24:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6559B7A9D
        for <io-uring@vger.kernel.org>; Thu, 19 Jan 2023 06:23:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674138220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=xcrjXPZDX7R9jSoNCpV3rPeVgVzgUf1s0d7wCqmxknY=;
        b=Sf4Nxo+Bu3pPjxmP37Nz5xABb582QCpVFlmgcc9ySpu+v4L0j8kv89/rU6zQ6tBZWPmisu
        OIjYotdbK7ZBJD+05ZasSKR+Aiy6JElJJFZIJi63RtFGyJXH2Xy4uV6qGlKW/MYWheYWLf
        3yYbnYUCdHYA9K2bTnF+KSArimSywtw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-428-4vCX5u6kOv-DIqVNu1Hkpw-1; Thu, 19 Jan 2023 09:23:39 -0500
X-MC-Unique: 4vCX5u6kOv-DIqVNu1Hkpw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6ECC7181E3F5;
        Thu, 19 Jan 2023 14:23:38 +0000 (UTC)
Received: from T590 (ovpn-8-27.pek2.redhat.com [10.72.8.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F0AD40C6EC4;
        Thu, 19 Jan 2023 14:23:33 +0000 (UTC)
Date:   Thu, 19 Jan 2023 22:23:28 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, nbd@other.debian.org
Cc:     ming.lei@redhat.com
Subject: ublk-nbd: ublk-nbd is avaialbe
Message-ID: <Y8lSYBU9q5fjs7jS@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

ublk-nbd[1] is available now.

Basically it is one nbd client, but totally implemented in userspace,
and wrt. current nbd-client in [2], the transmission phase is done
by linux block nbd driver.

The handshake implementation is borrowed from nbd project[2], so
basically ublk-nbd just adds new code for implementing transmission
phase, and it can be thought as moving linux block nbd driver into
userspace.

The added new code is basically in nbd/tgt_nbd.cpp, and io handling
is based on liburing[3], and implemented by c++20 coroutine, so
everything is done in single pthread totally lockless, meantime turns
out it is pretty easy to design & implement, attributed to ublk framework,
c++20 coroutine and liburing.

ublk-nbd supports both tcp and unix socket, and allows to enable io_uring
send zero copy via command line '--send_zc', see details in README[4].

No regression is found in xfstests by using ublk-nbd as both test device
and scratch device, and builtin test(make test T=nbd) runs well.

Fio test("make test T=nbd") shows that ublk-nbd performance is
basically same with nbd-client/nbd driver when running fio on real
ethernet link(1g, 10+g), but ublk-nbd IOPS is higher by ~40% than
nbd-client(nbd driver) with 512K BS, which is because linux nbd
driver sets max_sectors_kb as 64KB at default.

But when running fio over local tcp socket, it is observed in my test
machine that ublk-nbd performs better than nbd-client/nbd driver,
especially with 2 queue/2 jobs, and the gap could be 10% ~ 30%
according to different block size.

Any comments are welcome!

[1] https://github.com/ming1/ubdsrv/blob/master/nbd
[2] https://github.com/NetworkBlockDevice/nbd
[3] https://github.com/axboe/liburing
[4] https://github.com/ming1/ubdsrv/blob/master/nbd/README.rst

Thanks,
Ming

