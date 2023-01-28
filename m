Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C16C67F9DB
	for <lists+io-uring@lfdr.de>; Sat, 28 Jan 2023 18:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbjA1R10 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Jan 2023 12:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbjA1R1Z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Jan 2023 12:27:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2871717B
        for <io-uring@vger.kernel.org>; Sat, 28 Jan 2023 09:26:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674926798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bftJH4fJ+THD4FtLr/L0BORTyC3B8rjTKcnZ2OMpq+o=;
        b=B7bEcgENzZ2s4FoMt1gKL7YZH6fI9jrQgmskAjNdtDqFEGxPZZs3/AFIoUfYD+GcHbhgpP
        ePacfskYB+kpCk16XifNOlfzd/t1alTC20OYuw3rF+to0DMTLZUmp6kIUbsA8/RIYDfx3v
        8xw3QLf7abEa3VIBAmHwDsbeW5zUGBI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-48-NyeTHxZ4OkSJyzLzLo9GVw-1; Sat, 28 Jan 2023 12:26:33 -0500
X-MC-Unique: NyeTHxZ4OkSJyzLzLo9GVw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0260A1C04321;
        Sat, 28 Jan 2023 17:26:33 +0000 (UTC)
Received: from x2.localnet (unknown [10.22.8.91])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7DC99492B06;
        Sat, 28 Jan 2023 17:26:32 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>, Stefan Roesch <shr@fb.com>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v1 2/2] io_uring,audit: do not log IORING_OP_*GETXATTR
Date:   Sat, 28 Jan 2023 12:26:31 -0500
Message-ID: <13202484.uLZWGnKmhe@x2>
Organization: Red Hat
In-Reply-To: <CAHC9VhQiy9vP7BdQk+SXG7gQKAqOAqbYtU+c9R0_ym0h4bgG7g@mail.gmail.com>
References: <cover.1674682056.git.rgb@redhat.com>
 <f602429ce0f419c2abc3ae5a0e705e1368ac5650.1674682056.git.rgb@redhat.com>
 <CAHC9VhQiy9vP7BdQk+SXG7gQKAqOAqbYtU+c9R0_ym0h4bgG7g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Friday, January 27, 2023 5:43:02 PM EST Paul Moore wrote:
> On Fri, Jan 27, 2023 at 12:24 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > Getting XATTRs is not particularly interesting security-wise.
> > 
> > Suggested-by: Steve Grubb <sgrubb@redhat.com>
> > Fixes: a56834e0fafe ("io_uring: add fgetxattr and getxattr support")
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> > io_uring/opdef.c | 2 ++
> > 1 file changed, 2 insertions(+)
> 
> Depending on your security policy, fetching file data, including
> xattrs, can be interesting from a security perspective.  As an
> example, look at the SELinux file/getattr permission.
> 
> https://github.com/SELinuxProject/selinux-notebook/blob/main/src/object_cla
> sses_permissions.md#common-file-permissions

We're mostly interested in setting attributes because that changes policy. 
Reading them is not interesting unless the access fails with EPERM.

I was updating the user space piece recently and saw there was a bunch of 
"new" operations. I was commenting that we need to audit 5 or 6 of the "new" 
operations such as IORING_OP_MKDIRATor IORING_OP_SETXATTR. But now that I see 
the patch, it looks like they are auditable and we can just let a couple be 
skipped. IORING_OP_MADVISE is not interesting as it just gives hiints about 
the expected access patterns of memory. If there were an equivalent of 
mprotect, that would be of interest, but not madvise.

There are some I'm not sure about such as IORING_OP_MSG_RING and 
IORING_OP_URING_CMD. What do they do?

-Steve


