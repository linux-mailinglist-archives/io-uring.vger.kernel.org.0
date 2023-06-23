Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0644273B6E4
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 14:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjFWMJA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 08:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjFWMI7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 08:08:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3631724
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 05:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687522092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1AEjcOBxlhN8YL3o+HlZeUJLTTinjpyN/sBEzg1OQhA=;
        b=WCAAnfJEyAVKXLAKi4yl12TmifZ0f1BcYcK/Ms0/fpHM84hju1qtzOqFubDHru34S3oCIK
        0y4poedI9G0zJEM2ok4I9igqaaSzNDNG/Zd6gM6F1ETETZuCJiO0AM5MZtL30k+77axDog
        vbM80tUreWhJECNI5PXBvN2dZbH/8Q0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-397-wM5yeBrjPumhV8_r3hec2g-1; Fri, 23 Jun 2023 08:08:10 -0400
X-MC-Unique: wM5yeBrjPumhV8_r3hec2g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E91C185A78F;
        Fri, 23 Jun 2023 12:08:08 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F1D340C2071;
        Fri, 23 Jun 2023 12:08:08 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Guangwu Zhang <guazhang@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [bug report] BUG: KASAN: out-of-bounds in io_req_local_work_add+0x3b1/0x4a0
References: <CAGS2=YrvrD0hf7WGjQd4Me772=m9=E6J92aGtG0PAoF4yD6dTw@mail.gmail.com>
        <e92a19fa-74cc-2b9f-3173-6a04557a6534@kernel.dk>
        <ZJMDWIZv5kuJ7nGl@ovpn-8-23.pek2.redhat.com>
        <e7562fe1-0dd5-a864-cc0d-32701dac943c@kernel.dk>
        <CAGS2=Yqe3+jerR8sm47H++KKyXNJbAbTS0o3PFqJ24=QOQ2ChQ@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Fri, 23 Jun 2023 08:14:00 -0400
In-Reply-To: <CAGS2=Yqe3+jerR8sm47H++KKyXNJbAbTS0o3PFqJ24=QOQ2ChQ@mail.gmail.com>
        (Guangwu Zhang's message of "Fri, 23 Jun 2023 13:51:41 +0800")
Message-ID: <x49sfai9y0n.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Guangwu Zhang <guazhang@redhat.com> writes:

> Just hit the bug one time with liburing testing, so it hard to said
> which case triggered the issue,
> here is the test steps
> 1) enable kernel KASAN module
> 2) mkfs and mount with sda and set TEST_FILES=/dev/sda
> 3) copy all liburing cases to mount point
> 4) make runtests as root

Just a note on the test procedure: you shouldn't mount sda *and* set
TEST_FILES to sda.  You can leave TEST_FILES empty for this case.

-Jeff

