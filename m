Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E71323289
	for <lists+io-uring@lfdr.de>; Tue, 23 Feb 2021 21:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbhBWU4h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Feb 2021 15:56:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47768 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232731AbhBWU4f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Feb 2021 15:56:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614113706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3KQm+JOWkfPiKVoQVNaYknjcLG60hXdaozKJjWzOFB4=;
        b=Fdm0gUmPJq/hexoeZVg10qD58t5eetnmjWBEn0xjjfNh6HMfjRuUwoZWxXZ+s4BmiHC5y5
        Kfaj7rV9MiZndDCctd2TF1cN+6neqU03+OUKA3u2SI5f8ZlsAeNa85y6frApb5qE+MVvp1
        BLiPanwN+fJxGAXiLDH2sRq65A9lB80=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-RA_jcdehPuyLDWI0HEbfYA-1; Tue, 23 Feb 2021 15:54:46 -0500
X-MC-Unique: RA_jcdehPuyLDWI0HEbfYA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3C17835E22;
        Tue, 23 Feb 2021 20:54:44 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 51A6D5D9D3;
        Tue, 23 Feb 2021 20:54:35 +0000 (UTC)
Date:   Tue, 23 Feb 2021 15:54:34 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     JeffleXu <jefflexu@linux.alibaba.com>
Cc:     axboe@kernel.dk, hch@lst.de, ming.lei@redhat.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        io-uring@vger.kernel.org, joseph.qi@linux.alibaba.com,
        caspar@linux.alibaba.com, Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v4 00/12] dm: support IO polling
Message-ID: <20210223205434.GB25684@redhat.com>
References: <20210220110637.50305-1-jefflexu@linux.alibaba.com>
 <e3b3fc0a-cd07-a09c-5a8d-2d81c5d00435@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3b3fc0a-cd07-a09c-5a8d-2d81c5d00435@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Feb 22 2021 at 10:55pm -0500,
JeffleXu <jefflexu@linux.alibaba.com> wrote:

> 
> 
> On 2/20/21 7:06 PM, Jeffle Xu wrote:
> > [Changes since v3]
> > - newly add patch 7 and patch 11, as a new optimization improving
> > performance of multiple polling processes. Now performance of multiple
> > polling processes can be as scalable as single polling process (~30%).
> > Refer to the following [Performance] chapter for more details.
> > 
> 
> Hi Mike, would please evaluate this new version patch set? I think this
> mechanism is near maturity, since multi-thread performance is as
> scalable as single-thread (~30%) now.

OK, can do. But first I think you need to repost with a v5 that
addresses Mikulas' v3 feedback:

https://listman.redhat.com/archives/dm-devel/2021-February/msg00254.html
https://listman.redhat.com/archives/dm-devel/2021-February/msg00255.html

Mike

