Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95FE5262806
	for <lists+io-uring@lfdr.de>; Wed,  9 Sep 2020 09:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbgIIHJo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Sep 2020 03:09:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32879 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726060AbgIIHJk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Sep 2020 03:09:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599635377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sbNdgPGbXHtzNZzICD+kjhviJAeGSAESo3O2fIQqjns=;
        b=iO84z27jpCNN3zPraC61ysbcmhTtf53E1Yp5lQiJ17aCOk91qHX0Bk1WwPAyFdYtUt3jXK
        QQxpzyYOBZS/dgKy8EFyKEFOifVQ6HKU0MLFeW0aosxam2YUxCi/Wh26TljJK4QR1N7wXn
        VdUY6dFj9hlCAVSro41EAHGMByww/L4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-0hzJc50OPKWQxN0oBLw_Uw-1; Wed, 09 Sep 2020 03:09:35 -0400
X-MC-Unique: 0hzJc50OPKWQxN0oBLw_Uw-1
Received: by mail-wr1-f70.google.com with SMTP id j7so615863wro.14
        for <io-uring@vger.kernel.org>; Wed, 09 Sep 2020 00:09:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sbNdgPGbXHtzNZzICD+kjhviJAeGSAESo3O2fIQqjns=;
        b=pDq74cZOXJ8mOYXqdvOqUJWusgsMHnuUqlVqA86QJPNeQbpfTMD0nIbyGOPmFXwc3o
         UFV4eqqyu8R9b2LkAkXxNOqe3pQiin0fJdm/bdchKSVn4Tzx4Qong7x2n6+Fach1SK1H
         DMBMXk4VkVp1gLB2AZpdmwG9UH8pgGx+5L/lLlHH0Hnhx1+FlaNplEhMiTVNuKx074oW
         7nWXLMjclU9IJv3M7gkdbEuMwZhK/CBDU/i8Nh735GeNW8pm10lOdcp571+haQFtwe56
         wyxJL3tO0/lbd7oJz/8tonMmF+M3NqsS3HsI2StmPqtBOxDW2cb5uhhFXHjfilS2rStM
         FomA==
X-Gm-Message-State: AOAM532bZvFuQc73WlqWMkMngPhUNERrxfAmHX5NdWk5KZvvcZCS+cZj
        tNiE6q2HOYDZNZOif7cSgaydfPT6JF2izZUlKhKSets/iwSVSEVfOHgSfTyfHe0pdK/iromtUD/
        5r8aEUCMH9i9j/FyyBJI=
X-Received: by 2002:a7b:c015:: with SMTP id c21mr2067386wmb.87.1599635373596;
        Wed, 09 Sep 2020 00:09:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJLuHsYjEO/DZDcJ9fpG8m8GGKEsIJck/ZRUcpgnZH8FyK9x7ubj3A2yaHiurY8F0uZqsI3w==
X-Received: by 2002:a7b:c015:: with SMTP id c21mr2067369wmb.87.1599635373328;
        Wed, 09 Sep 2020 00:09:33 -0700 (PDT)
Received: from steredhat (host-79-53-225-185.retail.telecomitalia.it. [79.53.225.185])
        by smtp.gmail.com with ESMTPSA id t4sm2631177wrr.26.2020.09.09.00.09.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 00:09:32 -0700 (PDT)
Date:   Wed, 9 Sep 2020 09:09:30 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-next] io_uring: return EBADFD when ring isn't in the
 right state
Message-ID: <20200909070930.mdbm7aeh7z5ckwhq@steredhat>
References: <20200908165242.124957-1-sgarzare@redhat.com>
 <6e119be3-d9a3-06ea-1c76-4201816dde46@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e119be3-d9a3-06ea-1c76-4201816dde46@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Sep 08, 2020 at 11:02:48AM -0600, Jens Axboe wrote:
> On 9/8/20 10:52 AM, Stefano Garzarella wrote:
> > This patch uniforms the returned error (EBADFD) when the ring state
> > (enabled/disabled) is not the expected one.
> > 
> > The changes affect io_uring_enter() and io_uring_register() syscalls.
> 
> I added a Fixes line:
> 
> Fixes: 7ec3d1dd9378 ("io_uring: allow disabling rings during the creation")

Oh right, I forgot!

> 
> and applied it, thanks!
> 
> > https://github.com/stefano-garzarella/liburing (branch: fix-disabled-ring-error)
> 
> I'll check and pull that one too.
> 

Thanks,
Stefano

