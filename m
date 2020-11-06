Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45492A9709
	for <lists+io-uring@lfdr.de>; Fri,  6 Nov 2020 14:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727342AbgKFNfX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Nov 2020 08:35:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727214AbgKFNfW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Nov 2020 08:35:22 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E567C0613CF
        for <io-uring@vger.kernel.org>; Fri,  6 Nov 2020 05:35:22 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id 2so1360752ljj.13
        for <io-uring@vger.kernel.org>; Fri, 06 Nov 2020 05:35:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+r2b3AQkHkqwV7y2mPUX5IkHcX00znUbYOR6m97vuFg=;
        b=OE0MziPlWdQXlt4O5Wvz4LUIQF803CJG6twD4BvbnoAUIkqZp5IJbe3rt7LFWKY0C5
         j/BFw+gTHc3A1GZ4l0/Ty29Rz4eqza3n6U6kDRvCZFZbE7IJ2MrCYkq7WYbuKcqGkD73
         xiCZDUFOUF8MUEUya5FGEISgR+eiueI4PY8Ofm0C0zwOpL8sIBqYuJJOKN8mfAPTC5Y7
         0A1WA6FCx3uLvpvJwWL6ZS86pXQj/mKpo1qrFCCETT8DUnDaXqkmIpzGYGRhSXWKFdO7
         ar90kZq7FLJDmvIOUQzfB3I4V/ysa2MybSJWGrbneRM9aEU4abkK8KiXvPfVw4bsKaFc
         OkXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+r2b3AQkHkqwV7y2mPUX5IkHcX00znUbYOR6m97vuFg=;
        b=Igq1+WU6pvzmvLJLkRxZ8vFG2AdETHY2qCjcQxJMt8ZM8/7zUpESfo4/tOLiv+1Py1
         ZcJFDmmWp0771IGgK6r0BVAYUbMQsVNEljCYSGNKZZiVB5gySLDYVEroHaUI8zhxsu78
         0w7whQsgcYrG3pfw4hJMazY7ekSMMBuWlJr63Vtjqksfdwhs83LtKF/bhXbkhd5BsbXv
         0fdv5g6VKmchb8UdBDQEvebQfn/lbRZ5ZJCceZOzosnhUQ1zy+kjHVdNSYoixfgis17v
         b+yPPjNe38ivzmtDvbBzQBCbFSld3hcagTpSn3d4g0mExf0X+LSjyV11rDgwgUAYvufQ
         7jNg==
X-Gm-Message-State: AOAM533gf3vaf/pw35K9R+/bIhcUzNCNfhJW9d+xffC/EZpXR/xBNJY/
        yFxj8dfTIKCey91gG2BeoIo=
X-Google-Smtp-Source: ABdhPJy/qt1uZmjT68n02njMtQIQexTXUahELgjll16gP0tAx3PgYVnVZ59S9jfypkqjTPjupBHNvA==
X-Received: by 2002:a2e:8ec8:: with SMTP id e8mr747218ljl.140.1604669720851;
        Fri, 06 Nov 2020 05:35:20 -0800 (PST)
Received: from carbon.v ([94.143.149.146])
        by smtp.gmail.com with ESMTPSA id g15sm167574lfh.63.2020.11.06.05.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 05:35:19 -0800 (PST)
Date:   Fri, 6 Nov 2020 20:35:17 +0700
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: Use of disowned struct filename after 3c5499fa56f5?
Message-ID: <20201106133517.GA4039595@carbon.v>
References: <97810ccb-2f85-9547-e7c1-ce1af562924d@kernel.dk>
 <38141659-e902-73c6-a320-33b8bf2af0a5@gmail.com>
 <361ab9fb-a67b-5579-3e7b-2a09db6df924@kernel.dk>
 <9b52b4b1-a243-4dc0-99ce-d6596ca38a58@gmail.com>
 <266e0d85-42ed-e0f8-3f0b-84bcda0af912@kernel.dk>
 <ae71b04d-b490-7055-900b-ebdbe389c744@gmail.com>
 <20201106100800.GA3431563@carbon.v>
 <b6e9eb08-86cd-b952-1c3a-4933a2f19404@gmail.com>
 <20201106131506.GA3989306@carbon.v>
 <e510e624-c6d0-4f02-c539-33ffcce4f7c2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e510e624-c6d0-4f02-c539-33ffcce4f7c2@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Nov 06, 2020 at 01:27:51PM +0000, Pavel Begunkov wrote:
> On 06/11/2020 13:15, Dmitry Kadashev wrote:
> > On Fri, Nov 06, 2020 at 12:49:05PM +0000, Pavel Begunkov wrote:
> >> On 06/11/2020 10:08, Dmitry Kadashev wrote:
> >>> On Thu, Nov 05, 2020 at 08:57:43PM +0000, Pavel Begunkov wrote:
> >>> That's pretty much what do_unlinkat() does btw. Thanks Pavel for looking
> >>> into this!
> >>>
> >>> Can I pick your brain some more? do_mkdirat() case is slightly
> >>> different:
> >>>
> >>> static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
> >>> {
> >>> 	struct dentry *dentry;
> >>> 	struct path path;
> >>> 	int error;
> >>> 	unsigned int lookup_flags = LOOKUP_DIRECTORY;
> >>>
> >>> retry:
> >>> 	dentry = user_path_create(dfd, pathname, &path, lookup_flags);
> >>>
> >>> If we just change @pathname to struct filename, then user_path_create
> >>> can be swapped for filename_create(). But the same problem on retry
> >>> arises. Is there some more or less "idiomatic" way to solve this?
> >>
> >> I don't think there is, fs guys may have a different opinion but
> >> sometimes it's hard to get through them.
> >>
> >> I'd take a filename reference before "retry:"
> > 
> > How do I do that? Just `++name.refcnt` or is there a helper function /
> > better way?
> 
> I don't know, take a look around if there is one. In the end, a review and
> guys familiar with this code will hopefully suggest a better way (if any).

OK, thanks Pavel! I'll look around.

-- 
Dmitry
