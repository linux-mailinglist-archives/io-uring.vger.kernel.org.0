Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90F867F2AD
	for <lists+io-uring@lfdr.de>; Sat, 28 Jan 2023 01:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbjA1AHl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 19:07:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232284AbjA1AHj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 19:07:39 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753E38BBB5
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 16:07:29 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id g9so2281143pfk.13
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 16:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2A/Zg0V6mGpRrWbIuZ1WrswW+49OQc7hs6M62c327v4=;
        b=bKX0PfG9IW1cUXUKM7Mxe7p2uhDtsdSaiECHRswG7K80hHqwsUZHSCcOONA7KTGoKn
         WoLwxBWXZQPke5jVRofxheCvsoJpsyd7/hbQ3EbHG5KQo6PZ+3q+Nb0+blE4gPy/yaRj
         jkBHtcyxxOOnSeI+H+tEw77v8oLsIxqT0kAlZyVT+2HVAYGgSaYR12HRgJSfY6blCmHZ
         cJbV4KPl31+QqiXVZgKIQe3fGnwxEI8E2IJU2CdAu6ucriD5Ab5lcfe7xUVEeAdmLa/Z
         5jA6iNfsqB5XHL5cxxAMvd53HjQbttZ5rDlp6NoOeh9TT8hLxq0XLi5xe3RxyebD6xTg
         CrEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2A/Zg0V6mGpRrWbIuZ1WrswW+49OQc7hs6M62c327v4=;
        b=xRH/zAXkekmB/wvRB95FNbqXmfoenUHB3ecNkOio1gIu1flxS0wb+31d2Ds5TPtIok
         fpn8F7enezrhVdbYnK+LfjfwcqeTyTZbg9fV3T6UC0/IwJXl41ManRi/GQT/tk7/9N2y
         MV/ZgM7q5raSND1kZk9vJpyFm7IOQw5yXdWYJTHRR/dAvBcrRwBl2876S/iMEgFvzVna
         Bnt+SGIPOJc6DibQtkJVQKXlWBFtexyZGurn2LICDqLukMNxdXrdGN4mBpiHIOicH0o9
         nnEFJqdmpSdHw5G5tu5tHFX8byeLUYsL0W6hVoMQJ7oxalQFq0nypoeIq6ccxR/VKBb/
         MIuQ==
X-Gm-Message-State: AFqh2kpQtdlrfef0za1zKq8b0iKgdBcHDPilv7GhFUvobeVEu263mdnr
        Rq31drhxaIwRxAl2Ok9xOm0AQdErJ01siyK7O9zy
X-Google-Smtp-Source: AMrXdXu4JO49N65C/MOynyZpgVpmlsh4riJCNBfaQ5OEUTtGhSYC7W10mjEhYOOv27I64fmXzLHkjjfsYpdMGPAGwO4=
X-Received: by 2002:a65:58c1:0:b0:4d0:1233:d369 with SMTP id
 e1-20020a6558c1000000b004d01233d369mr4575134pgu.88.1674864448918; Fri, 27 Jan
 2023 16:07:28 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674682056.git.rgb@redhat.com> <f602429ce0f419c2abc3ae5a0e705e1368ac5650.1674682056.git.rgb@redhat.com>
 <CAHC9VhQiy9vP7BdQk+SXG7gQKAqOAqbYtU+c9R0_ym0h4bgG7g@mail.gmail.com>
 <Y9RX0QhHKfWv3TGL@madcap2.tricolour.ca> <5270af37-5544-42de-4e3f-c437889944dd@kernel.dk>
In-Reply-To: <5270af37-5544-42de-4e3f-c437889944dd@kernel.dk>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 27 Jan 2023 19:07:17 -0500
Message-ID: <CAHC9VhRCN9HHDkcp1xPJ7QwGq=_UG95ZCot9HRY7w5FCM2XtFg@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] io_uring,audit: do not log IORING_OP_*GETXATTR
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>, Stefan Roesch <shr@fb.com>,
        Christian Brauner <brauner@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jan 27, 2023 at 6:05 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 1/27/23 4:01=E2=80=AFPM, Richard Guy Briggs wrote:
> > On 2023-01-27 17:43, Paul Moore wrote:
> >> On Fri, Jan 27, 2023 at 12:24 PM Richard Guy Briggs <rgb@redhat.com> w=
rote:
> >>> Getting XATTRs is not particularly interesting security-wise.
> >>>
> >>> Suggested-by: Steve Grubb <sgrubb@redhat.com>
> >>> Fixes: a56834e0fafe ("io_uring: add fgetxattr and getxattr support")
> >>> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> >>> ---
> >>>  io_uring/opdef.c | 2 ++
> >>>  1 file changed, 2 insertions(+)
> >>
> >> Depending on your security policy, fetching file data, including
> >> xattrs, can be interesting from a security perspective.  As an
> >> example, look at the SELinux file/getattr permission.
> >>
> >> https://github.com/SELinuxProject/selinux-notebook/blob/main/src/objec=
t_classes_permissions.md#common-file-permissions
> >
> > The intent here is to lessen the impact of audit operations.  Read and
> > Write were explicitly removed from io_uring auditing due to performance
> > concerns coupled with the denial of service implications from sheer
> > volume of records making other messages harder to locate.  Those
> > operations are still possible for syscall auditing but they are strongl=
y
> > discouraged for normal use.
> >
> > If the frequency of getxattr io_uring ops is so infrequent as to be no
> > distraction, then this patch may be more of a liability than a benefit.
>
> (audit list removed)
>
> Right now the xattr related functions are io-wq driven, and hence not
> super performance sensitive. But I'd greatly prefer to clean these up
> regardless, because once opcodes get upgraded from needing io-wq, then
> we don't have to go through the audit discussion at that point. Better
> to do it upfront, like now, regardless of expectation of frequency of
> calls.

See my reply to Richard, but unfortunately we need to continue to
audit the getxattr ops.

--=20
paul-moore.com
