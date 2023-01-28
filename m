Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955FF67F9A7
	for <lists+io-uring@lfdr.de>; Sat, 28 Jan 2023 17:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjA1Qsw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Jan 2023 11:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbjA1Qsv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Jan 2023 11:48:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4A92917D
        for <io-uring@vger.kernel.org>; Sat, 28 Jan 2023 08:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674924484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I1EjAIx8G7GhvdK7BBuhDAeV72p2jMNx9oprxbDgh0U=;
        b=cnMowFjW4BZitNwDlZynJRgzxQQn5OuMj1Z1JzMv/K8KYoEQrFRbsBV+1+3qPsvzAlq33J
        hh6NotfILkYYLFDcdyc2jMJNSY70Qo7x8rUkJC72IchJnGut2T4aTOhBCEgtXa7he3k6dD
        NvulspZm2dYKYhre2Y1a521Zsyr9KVk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-274-uGIAixPTNFWHG9av_Chc4Q-1; Sat, 28 Jan 2023 11:47:58 -0500
X-MC-Unique: uGIAixPTNFWHG9av_Chc4Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30A03185A78B;
        Sat, 28 Jan 2023 16:47:58 +0000 (UTC)
Received: from x2.localnet (unknown [10.22.8.91])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 82425400F8F0;
        Sat, 28 Jan 2023 16:47:57 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Paul Moore <paul@paul-moore.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>, Stefan Roesch <shr@fb.com>,
        Christian Brauner <brauner@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v1 0/2] two suggested iouring op audit updates
Date:   Sat, 28 Jan 2023 11:47:56 -0500
Message-ID: <12151218.O9o76ZdvQC@x2>
Organization: Red Hat
In-Reply-To: <CAHC9VhRpu7WZDqWKcLDj18A0Z5FJdUU=eUL3wbJH1CnEBWB4GA@mail.gmail.com>
References: <cover.1674682056.git.rgb@redhat.com>
 <d9da8035-ed81-fb28-bf3a-f98c8a1e044a@kernel.dk>
 <CAHC9VhRpu7WZDqWKcLDj18A0Z5FJdUU=eUL3wbJH1CnEBWB4GA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Friday, January 27, 2023 5:53:24 PM EST Paul Moore wrote:
> On Fri, Jan 27, 2023 at 5:46 PM Jens Axboe <axboe@kernel.dk> wrote:
> > On 1/27/23 3:38=E2=80=AFPM, Paul Moore wrote:
> > > On Fri, Jan 27, 2023 at 2:43 PM Jens Axboe <axboe@kernel.dk> wrote:
> > >> On 1/27/23 12:42=E2=80=AFPM, Paul Moore wrote:
> > >>> On Fri, Jan 27, 2023 at 12:40 PM Jens Axboe <axboe@kernel.dk> wrote:
> > >>>> On 1/27/23 10:23=E2=80=AFAM, Richard Guy Briggs wrote:
> > >>>>> A couple of updates to the iouring ops audit bypass selections
> > >>>>> suggested in consultation with Steve Grubb.
> > >>>>>=20
> > >>>>> Richard Guy Briggs (2):
> > >>>>>   io_uring,audit: audit IORING_OP_FADVISE but not IORING_OP_MADVI=
SE
> > >>>>>   io_uring,audit: do not log IORING_OP_*GETXATTR
> > >>>>> =20
> > >>>>>  io_uring/opdef.c | 4 +++-
> > >>>>>  1 file changed, 3 insertions(+), 1 deletion(-)
> > >>>>=20
> > >>>> Look fine to me - we should probably add stable to both of them,
> > >>>> just to keep things consistent across releases. I can queue them up
> > >>>> for 6.3.
> > >>>=20
> > >>> Please hold off until I've had a chance to look them over ...
> > >>=20
> > >> I haven't taken anything yet, for things like this I always let it
> > >> simmer until people have had a chance to do so.
> > >=20
> > > Thanks.  FWIW, that sounds very reasonable to me, but I've seen lots
> > > of different behaviors across subsystems and wanted to make sure we
> > > were on the same page.
> >=20
> > Sounds fair. BTW, can we stop CC'ing closed lists on patch
> > submissions? Getting these:
> >=20
> > Your message to Linux-audit awaits moderator approval
> >=20
> > on every reply is really annoying.
>=20
> We kinda need audit related stuff on the linux-audit list, that's our
> mailing list for audit stuff.
>=20
> However, I agree that it is crap that the linux-audit list is
> moderated, but unfortunately that isn't something I control (I haven't
> worked for RH in years, and even then the list owner was really weird
> about managing the list).  Occasionally I grumble about moving the
> kernel audit development to a linux-audit list on vger but haven't
> bothered yet, perhaps this is as good a reason as any.
>=20
> Richard, Steve - any chance of opening the linux-audit list?

Unfortunately, it really has to be this way. I deleted 10 spam emails=20
yesterday. It seems like some people subscribed to this list are compromise=
d.=20
Because everytime there is a legit email, it's followed in a few seconds by=
 a=20
spam email.

Anyways, all legit email will be approved without needing to be subscribed.

=2DSteve


