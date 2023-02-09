Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B2B6913C6
	for <lists+io-uring@lfdr.de>; Thu,  9 Feb 2023 23:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbjBIWzZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Feb 2023 17:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjBIWzY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Feb 2023 17:55:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB935AB0E
        for <io-uring@vger.kernel.org>; Thu,  9 Feb 2023 14:54:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675983277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rfD7NeSXZta8SHUt4UbDCpgoZEDuhLecN/18yWyfjg0=;
        b=AkjqNEfcQ05YAkL1hsds8r9IMDRvKF1we+kEXGbv2FQ42DSfK8QT0bcJHgYOMqFgNW4OdR
        QJ1PPy/LTAMbam9FIMM8Ldfga3b8ImSuwxuadzePKTj3nX09BUAqJi6VCNAbgh/rw77zIZ
        6HA8CCkGrajXdvsVSvFY6aPPdFpYbtY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-261-QjKExhHlOVuGBiTAVInpog-1; Thu, 09 Feb 2023 17:54:26 -0500
X-MC-Unique: QjKExhHlOVuGBiTAVInpog-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF1343C02536;
        Thu,  9 Feb 2023 22:54:25 +0000 (UTC)
Received: from x2.localnet (unknown [10.22.33.104])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 663DB401014C;
        Thu,  9 Feb 2023 22:54:25 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Christian Brauner <brauner@kernel.org>,
        Stefan Roesch <shr@fb.com>
Subject: Re: [PATCH v2] io_uring,audit: don't log IORING_OP_MADVISE
Date:   Thu, 09 Feb 2023 17:54:24 -0500
Message-ID: <13293926.uLZWGnKmhe@x2>
Organization: Red Hat
In-Reply-To: <CAHC9VhTNb4gOpk9=49-ABtYs1DFKqqwXPSc-2bhJX7wcZ82o=g@mail.gmail.com>
References: <b5dfdcd541115c86dbc774aa9dd502c964849c5f.1675282642.git.rgb@redhat.com>
 <Y+VrSLZKZoAGikUS@madcap2.tricolour.ca>
 <CAHC9VhTNb4gOpk9=49-ABtYs1DFKqqwXPSc-2bhJX7wcZ82o=g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thursday, February 9, 2023 5:37:22 PM EST Paul Moore wrote:
> On Thu, Feb 9, 2023 at 4:53 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2023-02-01 16:18, Paul Moore wrote:
> > > On Wed, Feb 1, 2023 at 3:34 PM Richard Guy Briggs <rgb@redhat.com> 
wrote:
> > > > fadvise and madvise both provide hints for caching or access pattern
> > > > for file and memory respectively.  Skip them.
> > > 
> > > You forgot to update the first sentence in the commit description :/
> > 
> > I didn't forget.  I updated that sentence to reflect the fact that the
> > two should be treated similarly rather than differently.
> 
> Ooookay.  Can we at least agree that the commit description should be
> rephrased to make it clear that the patch only adjusts madvise?  Right
> now I read the commit description and it sounds like you are adjusting
> the behavior for both fadvise and madvise in this patch, which is not
> true.
> 
> > > I'm still looking for some type of statement that you've done some
> > > homework on the IORING_OP_MADVISE case to ensure that it doesn't end
> > > up calling into the LSM, see my previous emails on this.  I need more
> > > than "Steve told me to do this".
> > > 
> > > I basically just want to see that some care and thought has gone into
> > > this patch to verify it is correct and good.
> > 
> > Steve suggested I look into a number of iouring ops.  I looked at the
> > description code and agreed that it wasn't necessary to audit madvise.
> > The rationale for fadvise was detemined to have been conflated with
> > fallocate and subsequently dropped.  Steve also suggested a number of
> > others and after investigation I decided that their current state was
> > correct.  *getxattr you've advised against, so it was dropped.  It
> > appears fewer modifications were necessary than originally suspected.
> 
> My concern is that three of the four changes you initially proposed
> were rejected, which gives me pause about the fourth.  You mention
> that based on your reading of madvise's description you feel auditing
> isn't necessary - and you may be right - but based on our experience
> so far with this patchset I would like to hear that you have properly
> investigated all of the madvise code paths, and I would like that in
> the commit description.

I think you're being unnecessarily hard on this. Yes, the commit message 
might be touched up. But madvise is advisory in nature. It is not security 
relevant. And a grep through the security directory doesn't turn up any 
hooks.

-Steve


