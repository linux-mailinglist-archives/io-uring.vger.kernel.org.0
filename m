Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552FD67F2A2
	for <lists+io-uring@lfdr.de>; Sat, 28 Jan 2023 01:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbjA1AHB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 19:07:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjA1AHA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 19:07:00 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C0E8B7A7
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 16:06:40 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d9so6534354pll.9
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 16:06:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8g/ThgcNbD2/aX07jf+/YqhhYrBFTriZoMIQ/MFUbWI=;
        b=eqFtSh1QLj+acU2gwXnpxbAelvLB58DPeB4DQAski2quWDZzuDDp9OPNjo0x7PfRkL
         vxvKQ6AcUSbD9BqrQCnovg4LVVxN2voFYwt2Oom/gUHLAys4N4VdIZLmWuHHo78/oQMe
         wfZu6/kE0w2HGoJ/mmSVAeqxyk0FpRY2SMLAufOLipcWNSTWOMIhOhXBJSJ1eE86T9fY
         DHnBL+Rvox8zzYn+VugXoB2athS7utYT0LgF2MDmBWP6LONR+IjVl0F9Qgy1yteUF8yQ
         IvzDKeY/gy/ED2IvlSgXCYIKkbD1AYwESob6Z4B+xNPd6CgQ2CZtYFyq47G6W4jU+Vyj
         +hnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8g/ThgcNbD2/aX07jf+/YqhhYrBFTriZoMIQ/MFUbWI=;
        b=qcqcuyAaH01xJnkraGMf+CtKttHnWDyLFsTQtXspwHlBEeGE+LDcoh+HXWH97e5+4l
         BivUMxq46WbVLmDb9TI562Mz8OQlP23CfuaoUaVAQarmVRiW6Ps6FRCZvoHQLZIZ4ml9
         eG6w5wvoGDPlQvm/DMOc9XoXG1ULCOWWijycdWgLhiXCfWl4Qs/GeiQWja3OPXz8xUY0
         JlchOduzehEnJawf1fbLlEC1oMVHcjwT4LKJDMGEsH6agUqHA3LGgD8DDksuGpdwdkjA
         +hc+LKbd1+8k6osvzKc3YxFCF3Rar7bJ5Y3PZBbRGTSoJ/lhN9av1y1HTmYKGJeoM4LE
         9U1w==
X-Gm-Message-State: AFqh2krkbpsgEcDphyK8d4H8ubPMtFAZ+WJVWqel4YSdKorJkSVtAtkM
        d7wEVXqmhtPXuk9ToErnwh1+3Z1mp7UHlj4whuAB
X-Google-Smtp-Source: AMrXdXvd2n9LymBXSkWurnSC6yLqKTNaVZHkRdO3cpr85aGd59eC4S1pbTeWxWCVZHBbNBrCPS7QoA7JXjF/sJC/xPU=
X-Received: by 2002:a17:90a:5b0c:b0:223:fa07:7bfb with SMTP id
 o12-20020a17090a5b0c00b00223fa077bfbmr5401548pji.38.1674864399412; Fri, 27
 Jan 2023 16:06:39 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674682056.git.rgb@redhat.com> <f602429ce0f419c2abc3ae5a0e705e1368ac5650.1674682056.git.rgb@redhat.com>
 <CAHC9VhQiy9vP7BdQk+SXG7gQKAqOAqbYtU+c9R0_ym0h4bgG7g@mail.gmail.com> <Y9RX0QhHKfWv3TGL@madcap2.tricolour.ca>
In-Reply-To: <Y9RX0QhHKfWv3TGL@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 27 Jan 2023 19:06:28 -0500
Message-ID: <CAHC9VhSN+XSYGh0TBsCPftNvVNBN1JHugrrsp3gbF-in5S1PoA@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] io_uring,audit: do not log IORING_OP_*GETXATTR
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>, Stefan Roesch <shr@fb.com>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jan 27, 2023 at 6:01 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2023-01-27 17:43, Paul Moore wrote:
> > On Fri, Jan 27, 2023 at 12:24 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > Getting XATTRs is not particularly interesting security-wise.
> > >
> > > Suggested-by: Steve Grubb <sgrubb@redhat.com>
> > > Fixes: a56834e0fafe ("io_uring: add fgetxattr and getxattr support")
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > >  io_uring/opdef.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> >
> > Depending on your security policy, fetching file data, including
> > xattrs, can be interesting from a security perspective.  As an
> > example, look at the SELinux file/getattr permission.
> >
> > https://github.com/SELinuxProject/selinux-notebook/blob/main/src/object_classes_permissions.md#common-file-permissions
>
> The intent here is to lessen the impact of audit operations.  Read and
> Write were explicitly removed from io_uring auditing due to performance
> concerns coupled with the denial of service implications from sheer
> volume of records making other messages harder to locate.  Those
> operations are still possible for syscall auditing but they are strongly
> discouraged for normal use.

We need to balance security needs and performance needs.  You are
correct that general read() and write() operations are not audited,
and generally not checked from a LSM perspective as the auditing and
access control happens at open() time instead (access to fds is
revalidated when they are passed).  However, in the case of getxattr
and fgetxattr, these are not normal file read operations, and do not
go through the same code path in the kernel; there is a reason why we
have xattr_permission() and security_inode_getxattr().

We need to continue to audit IORING_OP_FGETXATTR and IORING_OP_GETXATTR.

-- 
paul-moore.com
