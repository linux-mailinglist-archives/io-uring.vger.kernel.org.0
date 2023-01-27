Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84EF467F208
	for <lists+io-uring@lfdr.de>; Sat, 28 Jan 2023 00:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbjA0XIn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 18:08:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232696AbjA0XIj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 18:08:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA08FF20
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 15:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674860869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZfIXJ+yJYjJIGSWbN403aqXVs6a7C5E6asSXYzrpvgk=;
        b=HHBZA4VPLflWMqr2QBCfgo3PHMpSYR332/2dhQ/+d6gUzHwPwKVRSwa4FAIr299X+gQ3Pd
        tLbXljCgxpgL5E9q+R+aRpRz1sxPMpmed03HOqVZaanae5wRdZx3yXpjeutgfOnnvlVGBA
        pJf76fRAajO/rtIY109Odd6c9efX0so=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-ZQ3TuZo1MK2x2B6pEylPTw-1; Fri, 27 Jan 2023 18:07:44 -0500
X-MC-Unique: ZQ3TuZo1MK2x2B6pEylPTw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B13E3C0252A;
        Fri, 27 Jan 2023 23:07:44 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-0-3.rdu2.redhat.com [10.22.0.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D68A40C945A;
        Fri, 27 Jan 2023 23:07:42 +0000 (UTC)
Date:   Fri, 27 Jan 2023 18:07:40 -0500
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Paul Moore <paul@paul-moore.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>, Stefan Roesch <shr@fb.com>,
        Christian Brauner <brauner@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v1 0/2] two suggested iouring op audit updates
Message-ID: <Y9RZPFTA8UUam12R@madcap2.tricolour.ca>
References: <cover.1674682056.git.rgb@redhat.com>
 <da695bf4-bd9b-a03d-3fbc-686724a7b602@kernel.dk>
 <CAHC9VhSRbay5bEUMJngpj+6Ss=WLeRoyJaNNMip+TyTkTJ6=Lg@mail.gmail.com>
 <24fbe6cb-ee80-f726-b260-09f394ead764@kernel.dk>
 <CAHC9VhRuvV9vjhmTM4eGJkWmpZmSkgVaoQ=L6g3cahej-F52tQ@mail.gmail.com>
 <d9da8035-ed81-fb28-bf3a-f98c8a1e044a@kernel.dk>
 <CAHC9VhRpu7WZDqWKcLDj18A0Z5FJdUU=eUL3wbJH1CnEBWB4GA@mail.gmail.com>
 <7904e869-f885-e406-9fe6-495a6e9790e4@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7904e869-f885-e406-9fe6-495a6e9790e4@kernel.dk>
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

On 2023-01-27 16:02, Jens Axboe wrote:
> On 1/27/23 3:53 PM, Paul Moore wrote:
> > On Fri, Jan 27, 2023 at 5:46 PM Jens Axboe <axboe@kernel.dk> wrote:
> >> On 1/27/23 3:38 PM, Paul Moore wrote:
> >>> On Fri, Jan 27, 2023 at 2:43 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>> On 1/27/23 12:42 PM, Paul Moore wrote:
> >>>>> On Fri, Jan 27, 2023 at 12:40 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>>> On 1/27/23 10:23 AM, Richard Guy Briggs wrote:
> >>>>>>> A couple of updates to the iouring ops audit bypass selections suggested in
> >>>>>>> consultation with Steve Grubb.
> >>>>>>>
> >>>>>>> Richard Guy Briggs (2):
> >>>>>>>   io_uring,audit: audit IORING_OP_FADVISE but not IORING_OP_MADVISE
> >>>>>>>   io_uring,audit: do not log IORING_OP_*GETXATTR
> >>>>>>>
> >>>>>>>  io_uring/opdef.c | 4 +++-
> >>>>>>>  1 file changed, 3 insertions(+), 1 deletion(-)
> >>>>>>
> >>>>>> Look fine to me - we should probably add stable to both of them, just
> >>>>>> to keep things consistent across releases. I can queue them up for 6.3.
> >>>>>
> >>>>> Please hold off until I've had a chance to look them over ...
> >>>>
> >>>> I haven't taken anything yet, for things like this I always let it
> >>>> simmer until people have had a chance to do so.
> >>>
> >>> Thanks.  FWIW, that sounds very reasonable to me, but I've seen lots
> >>> of different behaviors across subsystems and wanted to make sure we
> >>> were on the same page.
> >>
> >> Sounds fair. BTW, can we stop CC'ing closed lists on patch
> >> submissions? Getting these:
> >>
> >> Your message to Linux-audit awaits moderator approval
> >>
> >> on every reply is really annoying.
> > 
> > We kinda need audit related stuff on the linux-audit list, that's our
> > mailing list for audit stuff.
> 
> Sure, but then it should be open. Or do separate postings or something.
> CC'ing a closed list with open lists and sending email to people that
> are not on that closed list is bad form.

I've made an inquiry.

> Jens Axboe

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

