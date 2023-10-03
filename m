Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127CD7B70A8
	for <lists+io-uring@lfdr.de>; Tue,  3 Oct 2023 20:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbjJCSTb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Oct 2023 14:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbjJCSTb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Oct 2023 14:19:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9445A83
        for <io-uring@vger.kernel.org>; Tue,  3 Oct 2023 11:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696357121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ujno44uN38TJ6v9sX5LBJoWOcWyxfyko7zJqPs45iPc=;
        b=Jup0AToDx8NG7DrnqayK9iC8UXNROpjOZkZ1OIUaYOSnMBIC0WoIDI/2sAr+bD7LBT+83E
        K97y5R3po2F+iFc4iNZRld06nek/0pQLCwj8RevmsnqC2lVIEGQCrMUECD0AWleRkSTE3N
        oJtrinEc71G3XbbRS7DCVTg//+6MCrs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646--Lvc-vhcOgegyk-uNRr0ww-1; Tue, 03 Oct 2023 14:18:38 -0400
X-MC-Unique: -Lvc-vhcOgegyk-uNRr0ww-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11FD4101A550;
        Tue,  3 Oct 2023 18:18:38 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ED5F11006B70;
        Tue,  3 Oct 2023 18:18:37 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring: don't allow IORING_SETUP_NO_MMAP rings on highmem pages
References: <4c9eddf5-75d8-44cf-9365-a0dd3d0b4c05@kernel.dk>
        <x49edibpt2t.fsf@segfault.boston.devel.redhat.com>
        <08c0b5de-cf5e-432f-b8d6-a60204308d3a@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Tue, 03 Oct 2023 14:24:22 -0400
In-Reply-To: <08c0b5de-cf5e-432f-b8d6-a60204308d3a@kernel.dk> (Jens Axboe's
        message of "Tue, 3 Oct 2023 10:27:29 -0600")
Message-ID: <x49a5szpns9.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 10/3/23 10:30 AM, Jeff Moyer wrote:
>> Hi, Jens,
>> 
[snip]
>> What do you think about throwing a printk_once in there that explains
>> the problem?  I'm worried that this will fail somewhat randomly, and it
>> may not be apparent to the user why.  We should also add documentation,
>> of course, and encourage developers to add fallbacks for this case.
>
> For both cases posted, it's rather more advanced use cases. And 32-bit
> isn't so prevalent anymore, thankfully. I was going to add to the man
> pages explaining this failure case. Not sure it's worth adding a printk
> for though.

I try not to make decisions based on how prevalent I think a particular
configuration is (mainly because I'm usually wrong).  Anyway, it's not a
big deal, I'm glad you gave it some thought.

> FWIW, once I got an arm32 vm setup, it fails everytime for me. Not sure
> how it'd do on 32-bit x86, similarly or more randomly. But yeah it's
> definitely at the mercy of how things are mapped.

...and potentially the load on the system.  Anyway, it's fine with me to
keep it as is.  We can always add a warning later if it ends up being a
problem.

Thanks!
Jeff

