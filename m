Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A653040C5D2
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 15:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbhIONDz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 09:03:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27725 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232940AbhIONDy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 09:03:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631710955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QU7fHv53N2feOgWqJhePxh84C1Ua+RZDyIy4tjr3YnQ=;
        b=G8FYOYp/e/3aTT+uGV6l3Ph6SDnbocmU3irQrck+lIkwdCbMmOVCFVake7bi21esxY6My/
        2RCxAZGLIovSHQ2h4e9KKTGhUSuzCTiZPTlyCJxL7BYjU0Mi507mRFaIf1R1NH8LpGjUdB
        b1ZjChUZZv+cdWRFp9hfnfvUluFPuqM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-Qd2euMMPNb2OyUgWsrDEkQ-1; Wed, 15 Sep 2021 09:02:33 -0400
X-MC-Unique: Qd2euMMPNb2OyUgWsrDEkQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 647EE802936;
        Wed, 15 Sep 2021 13:02:32 +0000 (UTC)
Received: from x2.localnet (unknown [10.22.8.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A0CF67A8D8;
        Wed, 15 Sep 2021 13:02:12 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>,
        Richard Guy Briggs <rgb@redhat.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC PATCH v2 0/9] Add LSM access controls and auditing to io_uring
Date:   Wed, 15 Sep 2021 09:02:12 -0400
Message-ID: <2635005.mvXUDI8C0e@x2>
Organization: Red Hat
In-Reply-To: <20210915122907.GM490529@madcap2.tricolour.ca>
References: <CAHC9VhTkZ-tUdrFjhc2k1supzW1QJpY-15pf08mw6=ynU9yY5g@mail.gmail.com> <CAHC9VhTUKsijBVV-a3eHajYyOFYLQPWTTqxJ812NnB3_Y=UMeQ@mail.gmail.com> <20210915122907.GM490529@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wednesday, September 15, 2021 8:29:08 AM EDT Richard Guy Briggs wrote:
> I was in the middle of reviewing the v2 patchset to add my acks when I
> forgot to add the comment that you still haven't convinced me that ses=
> isn't needed or relevant if we are including auid=.

The session id is needed to disambiguate which login the event belongs to. It 
is necessary sometimes to trace an event back to the login because it was a 
remote login from an unexpected IP address.

-Steve


