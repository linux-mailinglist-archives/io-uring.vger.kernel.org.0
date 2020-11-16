Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F06A2B3C35
	for <lists+io-uring@lfdr.de>; Mon, 16 Nov 2020 05:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgKPEmw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Nov 2020 23:42:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbgKPEmw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Nov 2020 23:42:52 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF267C0613CF
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 20:42:51 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id b17so18617341ljf.12
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 20:42:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XMLoePN16xENZisp/5yLizFGTvIxXsbSRAjXR+Vhu8Q=;
        b=U3+hYCDlSP4Yo02RQsEhHeFx3pQfTrOQV/nPPURhmjwuku9wAZ+I5EehGRwMeYesAQ
         AsVC8LqZOrc/DV5IKvXONl65HDu8W/zq9yYAD812NRxaVfw16gvUfg1Wlrj4aJLo/F6p
         BLK5LICxALiVa1/Zb+STjMPriCxSTubk2mcCO4d2os2SOg62UVpBTlMot9pg2RajswbU
         M/kvlkLJU0XZocIVXxUZAL9ZWtXmFG8eg90hV4ZvKIoHpT8dYO2RZpXFUWjIV7BuEzw1
         fXBVel9E9yNCqYa98c9q8CGJ1EBmq1qB9g1jBflu4ZPqfyPKkjgIcVUpO5yK52uNMaR3
         YP6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XMLoePN16xENZisp/5yLizFGTvIxXsbSRAjXR+Vhu8Q=;
        b=KmYaGP4XiWxkgyjoTUUvDG+ywgwsynC6jcmlQLdEU1lK1peY6RV/x1BWoybT/gd0Ip
         Z3C9vI+CUZ4Q9hDStJH4S7zgeVaiPe0DAjIClGcl/lhTi7uWy2WEe4t22Z/yun6lybBY
         HuNEx3hFBTRNa6tZANNX0VkB7lSaVGhdz1cf4/DnO5WLEDVkFueh7BOdvm/GI6W5lc2H
         vZWcMbr1/+8QK+DxZfP/RARIR70KNa1XIsWI4QSL+C6nnZcoS/Z9X8lcaHUdylsuI9hi
         3UbukDc+7Z8vNqMya9khq7OcruN/XrKAEN2EzUy3BOqffaes/ndT/TaeDXgFIiXHQNyd
         1x7A==
X-Gm-Message-State: AOAM530aruH/3hy4EJIHE1EtCnnC3OVmiQeOSXCBdrb8PCizYuSBv6vX
        DqtSCjub4RdG2dCxOa+P4CtHIVIfxTo+Mg==
X-Google-Smtp-Source: ABdhPJwcZ+dd7TOCVBVhBSMEd0AbtwypiYhkrVPcaCc0yfW4hssr8b2kbDpO4WbNJa7l8e5J6Czw9g==
X-Received: by 2002:a2e:97ce:: with SMTP id m14mr5292132ljj.49.1605501770529;
        Sun, 15 Nov 2020 20:42:50 -0800 (PST)
Received: from carbon.v ([94.143.149.146])
        by smtp.gmail.com with ESMTPSA id t10sm2575483lfc.258.2020.11.15.20.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 20:42:49 -0800 (PST)
Date:   Mon, 16 Nov 2020 11:42:47 +0700
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH 0/2] io_uring: add mkdirat support
Message-ID: <20201116044247.GA979204@carbon.v>
References: <20201111132551.3536296-1-dkadashev@gmail.com>
 <06d8f82f-e406-9fa3-b8a1-7ff865c9b064@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06d8f82f-e406-9fa3-b8a1-7ff865c9b064@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Nov 13, 2020 at 04:57:13PM -0700, Jens Axboe wrote:
> On 11/11/20 6:25 AM, Dmitry Kadashev wrote:
> > This adds mkdirat support to io_uring and is heavily based on recently
> > added renameat() / unlinkat() support.
> > 
> > The first patch is preparation with no functional changes, makes
> > do_mkdirat accept struct filename pointer rather than the user string.
> > 
> > The second one leverages that to implement mkdirat in io_uring.
> 
> Looks good to me - you should send the first patch to linux-fsdevel (and
> CC Al Viro), really needs to be acked on that side before it can go in.

I'll resend the whole series with Al Viro and linux-fsdevel CCed, hope
that is OK, gives them a bit more context and they can ignore the
io_uring part. Hope that is OK.

> Also, have you written some test cases?

Yes, as part of liburing change - I'll send that shortly.

-- 
Dmitry Kadashev
