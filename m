Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB9CD27BED0
	for <lists+io-uring@lfdr.de>; Tue, 29 Sep 2020 10:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbgI2IFh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Sep 2020 04:05:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54506 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726944AbgI2IFg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Sep 2020 04:05:36 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601366735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6jB6xqUc5C8dBBPfY3VJWwjDLk6S5LuGBEtBA/TKKP0=;
        b=a/Ymr3W0jy0RsBRKO2z+afJWmfO4rliL75Kd4wrsiaNZDsrRmwiHmuhBmSlJ10qI7+Soj0
        VMWdn3ZWfKWPWsfmRWkEVlvZGDcYL5+bqe6veMYmaBF8ZLIgCWrao48gxjuiXvqQixXItE
        ICjUic2Ymn/2JZXzGKy3MK1gKg5a1Hk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-ZnorHEuAO52y4gt_yc29UA-1; Tue, 29 Sep 2020 04:05:31 -0400
X-MC-Unique: ZnorHEuAO52y4gt_yc29UA-1
Received: by mail-wm1-f72.google.com with SMTP id r10so3071827wmh.0
        for <io-uring@vger.kernel.org>; Tue, 29 Sep 2020 01:05:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6jB6xqUc5C8dBBPfY3VJWwjDLk6S5LuGBEtBA/TKKP0=;
        b=U3GLc2fypBN4WkjUxj8BhQlsANSyjJjBSob0PdS4K0usi1olWL/bNpQkpjjuaSFsaG
         XY3z+YLXb6eIdpclwKtzk+EqoEodl1L+IOIY5RI+f3iFaUJOK3JH88K/1jWHeIhVOrxA
         PK7uybMpNF9FaJkTLGUxrosFH7R/v+c+BTgLOwC+7GaZBKnToSpbSQr5A37fkxtQdx68
         FAc5w0O+mygYt+K3d++lg0AnKj7d0BVIce2mLM+eihyLC7H2pURJAMZULuFjX0HdnEuP
         WtbeFzvX7dJ69O+0OUND3LWtmNA5V5P/k42TrEeBU5/Gnxv8XwpQAhPkpO7jqYNASEFN
         cxYA==
X-Gm-Message-State: AOAM5309oGU38JX7xSQhdoC5flqLHHWzJIIQwuAfNkxxgqAVQiyuIdiI
        0AcDiKl4EahaCdDyp4a9deqsPlBlSdwPJctXjafewcAlnvNOlRFDSqphMwmLkmn1A0/+NUGS74c
        n+DGKsELFyvOYtDYZWNI=
X-Received: by 2002:a5d:470f:: with SMTP id y15mr2712254wrq.420.1601366729789;
        Tue, 29 Sep 2020 01:05:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy9xNKhM7SgBLeJJhGr8DFrhDyLtI8I3lDZZIQZ+dotV/kTywcUOey50KJVg+gYUx+0VCRX6A==
X-Received: by 2002:a5d:470f:: with SMTP id y15mr2712229wrq.420.1601366729612;
        Tue, 29 Sep 2020 01:05:29 -0700 (PDT)
Received: from steredhat (host-79-27-201-176.retail.telecomitalia.it. [79.27.201.176])
        by smtp.gmail.com with ESMTPSA id p3sm4080775wmm.40.2020.09.29.01.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 01:05:29 -0700 (PDT)
Date:   Tue, 29 Sep 2020 10:05:26 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH liburing] man/io_uring_enter.2: split ERRORS section in
 two sections
Message-ID: <20200929080526.gbgdrnea6rgpzpow@steredhat>
References: <20200918161402.87962-1-sgarzare@redhat.com>
 <9ec4c68b-94dd-a844-dc8a-dcd9ceeae212@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ec4c68b-94dd-a844-dc8a-dcd9ceeae212@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Sep 28, 2020 at 02:44:42PM -0600, Jens Axboe wrote:
> On 9/18/20 10:14 AM, Stefano Garzarella wrote:
> > This patch creates a new 'CQE ERRORS' section to better divide the
> > errors returned by the io_uring_enter() system call from those
> > returned by the CQE.
> 
> Thanks, this is a great start, applied.
> 

Thanks!

I'll rebase restrictions man pages on top of master, and I'll try to
find new CQE errors ;-)

Stefano

