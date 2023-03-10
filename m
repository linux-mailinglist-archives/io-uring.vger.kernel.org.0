Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8C706B33BF
	for <lists+io-uring@lfdr.de>; Fri, 10 Mar 2023 02:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjCJBjW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Mar 2023 20:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCJBjV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Mar 2023 20:39:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D68E9CDE
        for <io-uring@vger.kernel.org>; Thu,  9 Mar 2023 17:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678412311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0v72dESVYSGGv27pu4ub94GblrzWhsnb8rDLG0PvhaA=;
        b=DEdvlu3MqpTCM7zF+Do+1gDPoM9AyAptB4SeMuikq4fYzTqXaor3c7VdabAWwS2IycioXi
        FI2YJvQ6p4iWETRaM4z2q9dmswNvYpLkaMYcUHOtq6MwVUrKjBy33yfoWb3YODy+NTRziD
        S2v5TI02+l0S5JLe6afGkvHPnF0zdqI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-98-le5osTAqOvCpv1naBwe8Vw-1; Thu, 09 Mar 2023 20:38:29 -0500
X-MC-Unique: le5osTAqOvCpv1naBwe8Vw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7545B1C0513A;
        Fri, 10 Mar 2023 01:38:29 +0000 (UTC)
Received: from ovpn-8-16.pek2.redhat.com (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 709E3400D796;
        Fri, 10 Mar 2023 01:38:26 +0000 (UTC)
Date:   Fri, 10 Mar 2023 09:38:21 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     io-uring@vger.kernel.org, axboe@kernel.dk, ming.lei@redhat.com
Subject: Re: Resizing io_uring SQ/CQ?
Message-ID: <ZAqKDen5HtSGSXzd@ovpn-8-16.pek2.redhat.com>
References: <20230309134808.GA374376@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309134808.GA374376@fedora>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 09, 2023 at 08:48:08AM -0500, Stefan Hajnoczi wrote:
> Hi,
> For block I/O an application can queue excess SQEs in userspace when the
> SQ ring becomes full. For network and IPC operations that is not
> possible because deadlocks can occur when socket, pipe, and eventfd SQEs
> cannot be submitted.

Can you explain a bit the deadlock in case of network application? io_uring
does support to queue many network SQEs via IOSQE_IO_LINK, at least for
send.

> 
> Sometimes the application does not know how many SQEs/CQEs are needed upfront
> and that's when we face this challenge.

When running out of SQEs,  the application can call io_uring_enter() to submit
queued SQEs immediately without waiting for get events, then once
io_uring_enter() returns, you get free SQEs for moving one.

> 
> A simple solution is to call io_uring_setup(2) with a higher entries
> value than you'll ever need. However, if that value is exceeded then
> we're back to the deadlock scenario and that worries me.

Can you please explain the deadlock scenario?


Thanks, 
Ming

