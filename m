Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5CEF360B39
	for <lists+io-uring@lfdr.de>; Thu, 15 Apr 2021 15:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbhDOOAR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Apr 2021 10:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbhDOOAR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Apr 2021 10:00:17 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59395C061574
        for <io-uring@vger.kernel.org>; Thu, 15 Apr 2021 06:59:54 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id q14-20020a17090a430eb02901503aaee02bso1694445pjg.3
        for <io-uring@vger.kernel.org>; Thu, 15 Apr 2021 06:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=pLnujoTCd1xADbqoUGoodO0/OaBlb+Qy8FG4CcvGxyk=;
        b=mVqqnyyFUV2xpQHIJsXXPqWemg5qhp4GIoNF7jHablKxxKCg0sOkqPqAejrBue7qts
         QNy/HQj90BLiIDOby3hy/mq3TIqyPG/LvM3NJalkx9iA8iONPIjoCCnMRvhmZBDzoqTt
         qt1b2VhcqidM625rVyYJYBp6dmIOOLxLYPDjuei8dTsn3bMKa6D9k+G1u5d4bg8FU8rZ
         kaFgpqBAJB970SmKPsEl+2Km5/u2foRZoZWTv0uy0S/rt9BBxUxFnMs5Oxsi7vXi+k9l
         c49R/hzzXWlCb/I6AOJ/6Nh/uzoyjO/jQzV05M1iXC6efwmV468aXaWH/n0+wnMgrE57
         CAEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pLnujoTCd1xADbqoUGoodO0/OaBlb+Qy8FG4CcvGxyk=;
        b=Oe3bki2fM7qkxnQYKCAXGnQGD+PfMGXi+Zp/j9z4TWm15C/G62F4oFolTYAOpPEYTM
         RCO+Gphcffdb2RNtn9durnhdD0HopQEFWQBMWsFZdYe8QcNGdkyk2e7/WkqSSqIXc4W8
         RBI0bKcexnIiO+uNloyB1YzD8sIqDP1sFPl6J8SX7Q2OJVU/rr5KcivXfVVfYL3r9i89
         ut+vaEiXrI44dm7dkQzcaG1E8Nu4mCSUiHxzhavOUH2DxTAkfNpL2MDxBhzn2Vw9BKK4
         muic0cOswWBn5V+2Oo6w6y2eaZUdg3vzY7+VhM7PlaeJIHf+HR8PcdcQ0ll3n0VFIy9X
         NqAg==
X-Gm-Message-State: AOAM533gZ7STXqrVAHkV9T4GHgAzyZzw17VmysfuUYv4L0y1zzZSofas
        Jcb9Embmwnd4RRfEL/atF5wKezASwV6hig==
X-Google-Smtp-Source: ABdhPJxUhIb1vgAQt+bFUdavSyhhmFlaMoHMa2Bl0tKn6rRyvaR0Y2V/rn3cO4VCtZrmT2KkSXav8A==
X-Received: by 2002:a17:90b:4c0c:: with SMTP id na12mr3937283pjb.117.1618495193553;
        Thu, 15 Apr 2021 06:59:53 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21e8::1132? ([2620:10d:c090:400::5:f31c])
        by smtp.gmail.com with ESMTPSA id f6sm2941403pgd.61.2021.04.15.06.59.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 06:59:53 -0700 (PDT)
Subject: Re: [RFC] io_uring: submit even with overflow backlog
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <0933f5027f3b7b7eea8a7ece353db9c516816b1b.1618489868.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <eefa3df5-faa2-8220-8f7c-ac548c76fd84@kernel.dk>
Date:   Thu, 15 Apr 2021 07:59:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0933f5027f3b7b7eea8a7ece353db9c516816b1b.1618489868.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/15/21 6:40 AM, Pavel Begunkov wrote:
> Not submitting when have requests in overflow backlog looks artificial,
> and limits users for no clear purpose, especially since requests with
> resources are now not locked into it but it consists for a small memory
> area. Remove the restriction.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> 
> Mainly for discussion. It breaks several tests, and so in theory
> userspace, but can't think this restriction not being just a
> nuisance to the userspace. IMHO much more convenient to allow it,
> userspace can take care of it itself if needed, but for those
> who don't care and use rings in parallel (e.g. different threads
> for submission and completion), it will be hell of a synchronisation.

I think we can kill it, with the main change enabling that being the
cgroup memory accounting. This was kind of a safe guard to avoid having
silly cases just go way overboard, but I do agree that this is really
up to the application to manage. And it may have an easier time doing
so without -EBUSY on overflow being set on submit.

-- 
Jens Axboe

