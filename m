Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7366B13E3BA
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2020 18:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387849AbgAPRDt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jan 2020 12:03:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26607 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388619AbgAPRDs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jan 2020 12:03:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579194227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dwuqMFEPkLVf1SB1Qby1DH0sArybWQvfhVUygmsr0E4=;
        b=MA7M7xNedg4uST0aneGIEwk6MS6vmk+Ir+mla1IMUSZAWFzolUmgsnKf2j04/5xUgYuOrX
        rDOwcxcDHPPoRqvTi6Hu5XD/Vi7dH99H2Qk2zlgr9+LO7mSN+67roNbQ2TM67R7WIGMPVn
        m71gRMVJLl+xv5jt4o/8s/I+J4H98ZI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-q09_he4QMyGDOeYFaQaA3g-1; Thu, 16 Jan 2020 12:03:46 -0500
X-MC-Unique: q09_he4QMyGDOeYFaQaA3g-1
Received: by mail-wm1-f71.google.com with SMTP id q206so1417547wme.9
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2020 09:03:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dwuqMFEPkLVf1SB1Qby1DH0sArybWQvfhVUygmsr0E4=;
        b=QAhqom3Fj1GdfB80f5GgOFhv1fL6ob6z++1u0g/IqHDTCWHWCmTv8bkyD8Fpwwtl9h
         vH7uxV0GEjMgy6I62+Az62i6vzj1dUl08Qd45uJJrL43gCoOrQfbymrGuYSl411/xCr/
         ifs38YnGP/RBdm7yFqVKX4RtOQ52LwF9u2xYLab5jcnyew2GYq7KxSOMTAUKRwj5xvmN
         9dJm0937BmgvLilEWP2dqkQ3jD3Hsy32lOYxpEB2hdLHOwn605xiRhRQYhkTdxTLZQz5
         Bbys9K07Pr6oqbmsw4jbh4C2MlefBJL3zkKyAvvM7XdnFLCjm1Zdx/PJagwj63FLEtoZ
         fGOA==
X-Gm-Message-State: APjAAAXz6mFU0gbVWaAFnfVqgyhTeC5mbM/PNknaOATh5/aaBuwU9xXV
        zgPHH/2/ou9BM6nxlMV+/cEdGC0mqTN8yFBwIYL4m89bwp6jssR6CKtaIdoZ1Y3DKH5HY0ZTH4r
        SX+nP7L3KtJn8BQPqGak=
X-Received: by 2002:adf:ce87:: with SMTP id r7mr4222758wrn.245.1579194225147;
        Thu, 16 Jan 2020 09:03:45 -0800 (PST)
X-Google-Smtp-Source: APXvYqwmahambFLYvDPNDfSiuwfj+RNjJ2awrp8kvOtBAw+JLe5Wbrx78e1fRaCj45Q555ccQHKFSw==
X-Received: by 2002:adf:ce87:: with SMTP id r7mr4222739wrn.245.1579194224894;
        Thu, 16 Jan 2020 09:03:44 -0800 (PST)
Received: from steredhat (host84-49-dynamic.31-79-r.retail.telecomitalia.it. [79.31.49.84])
        by smtp.gmail.com with ESMTPSA id q15sm29985051wrr.11.2020.01.16.09.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 09:03:44 -0800 (PST)
Date:   Thu, 16 Jan 2020 18:03:42 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] io_uring: wakeup threads waiting for EPOLLOUT events
Message-ID: <20200116170342.4jvkhbbw4x6z3txn@steredhat>
References: <20200116134946.184711-1-sgarzare@redhat.com>
 <2d2dda92-3c50-ee62-5ffe-0589d4c8fc0d@kernel.dk>
 <20200116155557.mwjc7vu33xespiag@steredhat>
 <5723453a-9326-e954-978e-910b8b495b38@kernel.dk>
 <20200116162630.6r3xc55kdyyq5tvz@steredhat>
 <a02a58dc-bf23-ed74-aec6-52c85360fe00@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a02a58dc-bf23-ed74-aec6-52c85360fe00@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jan 16, 2020 at 09:30:12AM -0700, Jens Axboe wrote:
> On 1/16/20 9:26 AM, Stefano Garzarella wrote:
> >> Since the use case is mostly single submitter, unless you're doing
> >> something funky or unusual, you're not going to be needing POLLOUT ever.
> > 
> > The case that I had in mind was with kernel side polling enabled and
> > a single submitter that can use epoll() to wait free slots in the SQ
> > ring. (I don't have a test, maybe I can write one...)
> 
> Right, I think that's the only use case where it makes sense, because
> you have someone else draining the sq side for you. A test case would
> indeed be nice, liburing has a good arsenal of test cases and this would
> be a good addition!

Sure, I'll send a test to liburing for this case!

Thanks,
Stefano

