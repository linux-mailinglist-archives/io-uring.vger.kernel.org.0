Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29A5C13DF51
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2020 16:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgAPP4F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jan 2020 10:56:05 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30588 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726440AbgAPP4E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jan 2020 10:56:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579190164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=59rSP/4nG5ysgfDP2nwJUgUTFNS/i6M0+YH8HiBE7YE=;
        b=MzQ7ulmhiE7+yz0UAnyTG3LAv7hAGbDW9Hy6+U07nPNWxEgc3BRS2zN7MdTafpmLRT55g7
        Fs3F92o3t6VwMCBqizxW7nzd5/H9Q3EaEarBO9KqL1nkR1q7qzwVy1vnQ07l9JHp/DK1G8
        HVEYqFZs5N22dOIq0LQUvlIvyFnkbj8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-tg4RzZGNOp-nrGEPk9pzQg-1; Thu, 16 Jan 2020 10:56:02 -0500
X-MC-Unique: tg4RzZGNOp-nrGEPk9pzQg-1
Received: by mail-wr1-f72.google.com with SMTP id j4so9394297wrs.13
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2020 07:56:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=59rSP/4nG5ysgfDP2nwJUgUTFNS/i6M0+YH8HiBE7YE=;
        b=I2G7yuGGRziL/ItlyFDTToul6vgQW/cZiRj22qZfg/P7APcKe8LBHRBQc4Fd283Pwd
         0+y0Qm7/+yfTSIil+QI769py4Ssq0NSFOZx8YKSWoOLvkZGcuNMuyA0dkbKdGbpRJwms
         UZsSkl03Xmx+HN44DNGHfrz4wt79jTCyS1qsG0WEUhbwK1uVayt/YZOf/QuiO9PLUb3q
         niFnlsMKFJE4hXBn3Aw1go3wN9D62RFyuYO6I9RSwEuczY9Esq17JXuqB3dn5c/dBGhi
         EnS2ZvSrC7g3XoJurhzB898yl13r7DhwxVFNOHjmvve1oIP9RjpJ920mon46XUrVEmfG
         I4fw==
X-Gm-Message-State: APjAAAXaJb/0OgQWu44J5jbwjtMX4lt8o7e20vQ9TO41C9XkctBEQHbh
        3u2YPXuiGb6QmhdFhxSmX7GE7A/Xp+7m90LcvJg3iwMJBAjUdXL67vxI/Ft8k6YnktoQZ8SNF73
        oQyl+A4GUf1J2+nV/dfU=
X-Received: by 2002:a1c:488a:: with SMTP id v132mr4002wma.153.1579190160200;
        Thu, 16 Jan 2020 07:56:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqyARJugJk6ZQ7MpUK2INr7v0S3I+70oMKj69iGSMkRzx4xa29/fG8xCm60wqugTUISWTMXsWQ==
X-Received: by 2002:a1c:488a:: with SMTP id v132mr3985wma.153.1579190159959;
        Thu, 16 Jan 2020 07:55:59 -0800 (PST)
Received: from steredhat (host84-49-dynamic.31-79-r.retail.telecomitalia.it. [79.31.49.84])
        by smtp.gmail.com with ESMTPSA id n67sm5422048wmf.46.2020.01.16.07.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 07:55:59 -0800 (PST)
Date:   Thu, 16 Jan 2020 16:55:57 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] io_uring: wakeup threads waiting for EPOLLOUT events
Message-ID: <20200116155557.mwjc7vu33xespiag@steredhat>
References: <20200116134946.184711-1-sgarzare@redhat.com>
 <2d2dda92-3c50-ee62-5ffe-0589d4c8fc0d@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d2dda92-3c50-ee62-5ffe-0589d4c8fc0d@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jan 16, 2020 at 08:29:07AM -0700, Jens Axboe wrote:
> On 1/16/20 6:49 AM, Stefano Garzarella wrote:
> > io_uring_poll() sets EPOLLOUT flag if there is space in the
> > SQ ring, then we should wakeup threads waiting for EPOLLOUT
> > events when we expose the new SQ head to the userspace.
> > 
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > ---
> > 
> > Do you think is better to change the name of 'cq_wait' and 'cq_fasync'?
> 
> I honestly think it'd be better to have separate waits for in/out poll,
> the below patch will introduce some unfortunate cacheline traffic
> between the submitter and completer side.

Agree, make sense. I'll send a v2 with a new 'sq_wait'.

About fasync, do you think could be useful the POLL_OUT support?
In this case, maybe is not simple to have two separate fasync_struct,
do you have any advice?

Thanks,
Stefano

