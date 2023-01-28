Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1C167F31A
	for <lists+io-uring@lfdr.de>; Sat, 28 Jan 2023 01:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbjA1AWf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 19:22:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbjA1AWe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 19:22:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509D68B059
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 16:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674865178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i7aOq9W3XOqSSPllVutX9bvOB7c6GyK6o1GuE+eflv8=;
        b=OXgt13U60eq1T1JlzaEoo+aTAzg5BRnoOgiljWxmDaktm/BaNxSzEw5U/+8vV0xKsIqOxx
        RZM32Sc+Yx08BdgbRICQfbkQpyiwwA7cEy/A8fMa/v8cydpLrhRH0p1zGaUxpCAKb3jYyG
        v5Ob4OKkyMFWGcbvgrnwM4QTPxD7oUA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-227-UufeiL1FOwGQEKbF0x3Nag-1; Fri, 27 Jan 2023 19:19:35 -0500
X-MC-Unique: UufeiL1FOwGQEKbF0x3Nag-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD4491C05EBC;
        Sat, 28 Jan 2023 00:19:34 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-0-3.rdu2.redhat.com [10.22.0.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2430D7AD4;
        Sat, 28 Jan 2023 00:19:33 +0000 (UTC)
Date:   Fri, 27 Jan 2023 19:19:31 -0500
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>, Stefan Roesch <shr@fb.com>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v1 2/2] io_uring,audit: do not log IORING_OP_*GETXATTR
Message-ID: <Y9RqEz/qQYmp5jD+@madcap2.tricolour.ca>
References: <cover.1674682056.git.rgb@redhat.com>
 <f602429ce0f419c2abc3ae5a0e705e1368ac5650.1674682056.git.rgb@redhat.com>
 <CAHC9VhQiy9vP7BdQk+SXG7gQKAqOAqbYtU+c9R0_ym0h4bgG7g@mail.gmail.com>
 <Y9RX0QhHKfWv3TGL@madcap2.tricolour.ca>
 <CAHC9VhSN+XSYGh0TBsCPftNvVNBN1JHugrrsp3gbF-in5S1PoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhSN+XSYGh0TBsCPftNvVNBN1JHugrrsp3gbF-in5S1PoA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023-01-27 19:06, Paul Moore wrote:
> On Fri, Jan 27, 2023 at 6:01 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2023-01-27 17:43, Paul Moore wrote:
> > > On Fri, Jan 27, 2023 at 12:24 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > Getting XATTRs is not particularly interesting security-wise.
> > > >
> > > > Suggested-by: Steve Grubb <sgrubb@redhat.com>
> > > > Fixes: a56834e0fafe ("io_uring: add fgetxattr and getxattr support")
> > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > > ---
> > > >  io_uring/opdef.c | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > >
> > > Depending on your security policy, fetching file data, including
> > > xattrs, can be interesting from a security perspective.  As an
> > > example, look at the SELinux file/getattr permission.
> > >
> > > https://github.com/SELinuxProject/selinux-notebook/blob/main/src/object_classes_permissions.md#common-file-permissions
> >
> > The intent here is to lessen the impact of audit operations.  Read and
> > Write were explicitly removed from io_uring auditing due to performance
> > concerns coupled with the denial of service implications from sheer
> > volume of records making other messages harder to locate.  Those
> > operations are still possible for syscall auditing but they are strongly
> > discouraged for normal use.
> 
> We need to balance security needs and performance needs.  You are
> correct that general read() and write() operations are not audited,
> and generally not checked from a LSM perspective as the auditing and
> access control happens at open() time instead (access to fds is
> revalidated when they are passed).  However, in the case of getxattr
> and fgetxattr, these are not normal file read operations, and do not
> go through the same code path in the kernel; there is a reason why we
> have xattr_permission() and security_inode_getxattr().
> 
> We need to continue to audit IORING_OP_FGETXATTR and IORING_OP_GETXATTR.

Fair enough.  This would be similar reasoning to send/recv vs
sendmsg/recvmsg.  I'll drop this patch.  Thanks for the reasoning and
feedback.

> paul-moore.com

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

