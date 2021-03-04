Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8421632D085
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 11:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238370AbhCDKP7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 05:15:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56015 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238405AbhCDKPt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 05:15:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614852864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T9wLNs0hY9LPW8i/bbOeiyn0/hKvk++/9L1iE/B+NAI=;
        b=g85vQaqtGqInmZEPJza2WS8xP7PvzJ7RzZdGi/54sOVHz1qZqTSDg/QaVLU06oPHG16ATH
        wlwCzpPGOVO2lfSNJSk1028IqVhPhGj+XDrJyL9/CEpxONtKbSXZblHJeBQ+jvT/DIYP7/
        FNDOIS+2vVCy20XZIpqPOA+DOomG6i8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-x_5YU6v_O-uljnGm4Wrmpw-1; Thu, 04 Mar 2021 05:14:20 -0500
X-MC-Unique: x_5YU6v_O-uljnGm4Wrmpw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6A9B107465E;
        Thu,  4 Mar 2021 10:14:18 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A700639A73;
        Thu,  4 Mar 2021 10:14:15 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 124AEFOQ008051;
        Thu, 4 Mar 2021 05:14:15 -0500
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 124AEFO1008046;
        Thu, 4 Mar 2021 05:14:15 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Thu, 4 Mar 2021 05:14:15 -0500 (EST)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Jens Axboe <axboe@kernel.dk>
cc:     JeffleXu <jefflexu@linux.alibaba.com>,
        Mike Snitzer <msnitzer@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        caspar@linux.alibaba.com, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
        dm-devel@redhat.com, hch@lst.de
Subject: Re: [PATCH 1/4] block: introduce a function
 submit_bio_noacct_mq_direct
In-Reply-To: <8424036e-fba9-227e-4173-8f6d05562ee3@kernel.dk>
Message-ID: <alpine.LRH.2.02.2103040511050.7400@file01.intranet.prod.int.rdu2.redhat.com>
References: <20210302190551.473015400@debian-a64.vm> <8424036e-fba9-227e-4173-8f6d05562ee3@kernel.dk>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On Wed, 3 Mar 2021, Jens Axboe wrote:

> On 3/2/21 12:05 PM, Mikulas Patocka wrote:
> 
> There seems to be something wrong with how this series is being sent
> out. I have 1/4 and 3/4, but both are just attachments.
> 
> -- 
> Jens Axboe

I used quilt to send it. I don't know what's wrong with it - if you look 
at archives at 
https://listman.redhat.com/archives/dm-devel/2021-March/thread.html , it 
seems normal.

Mikulas

