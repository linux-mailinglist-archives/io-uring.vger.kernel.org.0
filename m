Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B258376400E
	for <lists+io-uring@lfdr.de>; Wed, 26 Jul 2023 21:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjGZT5e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Jul 2023 15:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjGZT5e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Jul 2023 15:57:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C73B213E
        for <io-uring@vger.kernel.org>; Wed, 26 Jul 2023 12:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690401407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mEpXvvU90l0RthnJ6+S/VSU0zkOQwcnlRrI1p7pRhb8=;
        b=KFVTrbtcn9ms3BmDKrPuGAixF8h5NXquKJqOs/tFNcuJvsGkFxWhmU0q8zEOTtqKIWYOo4
        hV55tKAhSVnux6alJauG/s3VJTM7ev0CCMZZZfdRcOT9BMF3i3LKbuQwBogPf2S8wNVz8f
        VwawzA58B/YSl8dzBvVWC1jRb471TwA=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-sAGTV80hP06kYxAGLDLjHg-1; Wed, 26 Jul 2023 15:56:42 -0400
X-MC-Unique: sAGTV80hP06kYxAGLDLjHg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BCA8D1C0904A;
        Wed, 26 Jul 2023 19:56:41 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 26A082166B25;
        Wed, 26 Jul 2023 19:56:40 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Andres Freund <andres@anarazel.de>
Cc:     Matteo Rizzo <matteorizzo@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        axboe@kernel.dk, asml.silence@gmail.com, corbet@lwn.net,
        akpm@linux-foundation.org, keescook@chromium.org,
        ribalda@chromium.org, rostedt@goodmis.org, jannh@google.com,
        chenhuacai@kernel.org, gpiccoli@igalia.com, ldufour@linux.ibm.com,
        evn@google.com, poprdi@google.com, jordyzomer@google.com,
        krisman@suse.de
Subject: Re: [PATCH v3 1/1] io_uring: add a sysctl to disable io_uring system-wide
References: <20230630151003.3622786-1-matteorizzo@google.com>
        <20230630151003.3622786-2-matteorizzo@google.com>
        <20230726174549.cg4jgx2d33fom4rb@awork3.anarazel.de>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Wed, 26 Jul 2023 16:02:26 -0400
In-Reply-To: <20230726174549.cg4jgx2d33fom4rb@awork3.anarazel.de> (Andres
        Freund's message of "Wed, 26 Jul 2023 10:45:49 -0700")
Message-ID: <x49fs5awiel.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi, Andres,

Andres Freund <andres@anarazel.de> writes:

> Hi,
>
> On 2023-06-30 15:10:03 +0000, Matteo Rizzo wrote:
>> Introduce a new sysctl (io_uring_disabled) which can be either 0, 1,
>> or 2. When 0 (the default), all processes are allowed to create io_uring
>> instances, which is the current behavior. When 1, all calls to
>> io_uring_setup fail with -EPERM unless the calling process has
>> CAP_SYS_ADMIN. When 2, calls to io_uring_setup fail with -EPERM
>> regardless of privilege.
>
> Hm, is there a chance that instead of requiring CAP_SYS_ADMIN, a certain group
> could be required (similar to hugetlb_shm_group)? Requiring CAP_SYS_ADMIN
> could have the unintended consequence of io_uring requiring tasks being run
> with more privileges than needed... Or some other more granular way of
> granting the right to use io_uring?

That's fine with me, so long as there is still an option to completely
disable io_uring.

> ISTM that it'd be nice if e.g. a systemd service specification could allow
> some services to use io_uring, without allowing it for everyone, or requiring
> to run services effectively as root.

Do you have a proposal for how that would work?  Why is this preferable
to using a group?

Cheers,
Jeff

