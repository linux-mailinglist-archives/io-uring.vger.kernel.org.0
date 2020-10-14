Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE15828DD46
	for <lists+io-uring@lfdr.de>; Wed, 14 Oct 2020 11:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbgJNJXg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Oct 2020 05:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731251AbgJNJWz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Oct 2020 05:22:55 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E8FC0A88B5
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 18:13:04 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id n9so889129pgf.9
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 18:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i6l17IWUIHeG0JJi9EHuTxxaZYUhR7nZYchjbmwdA0Q=;
        b=Q/ibQe+/zf+A8HNC+WcPb450sabTWuleCAieAdauosw3pAKWmIqjcGpzbznwAm7E2d
         j5zZOX+6rGedd3rNaYQdMAVMLMNKBnpzivGbP9TUzdNdIZDMm6Vy1hMZoFbFFS9HthXq
         J+DyYA8Y1T9vLrJJEXG0fL3+MzVzWwOn2HdN8/hZxTlNKEfBAVn5Exr100MkLJ9T/u3n
         xIgpy1wZhCQlbHdQ51qwNxT6IFp+dHhi1w8QZKg88/L/ZQD0n74gQLYkxgpaBu/TlghU
         jmZ46b03+UhAe4k1wRZ2dkXoS+ZMaX4byyKzb41262LVQ21v0yFVZvENHZ2G+3t2MNyU
         dOuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i6l17IWUIHeG0JJi9EHuTxxaZYUhR7nZYchjbmwdA0Q=;
        b=NN2VNJMdb3D8VJlkpkSy1E3EoCaII8o7K705XrL3hJaz/mKOdiDXcuGDnAq1Lv9Wt4
         bljRLGamMSDRSJqDVtupEYi6P2fAxFzMvvEb3jmOuh0u7AceaHUhfq0oqf+Jk8zDfWHz
         qptjsOjPHtfQRDMR7YzIZzVI6sx1eVDB+PuPDl8TDh0DBYHoWaVYSmE7QaKMwte+umL1
         UOAM9LA6zs93t6YBCc6ZI3N098/cL1i29QWpuSiySwXqUCtwfgE/LdYrVN9iREnjyIcm
         anP57ZWvGTYvPwOb4iMycHZ7CbfeueruPDA/5zTlWIgg1ChUD1oxqZXW3YXxkDhMVZBT
         duVg==
X-Gm-Message-State: AOAM533w4XTBkVLeqOyRlzKD2BbWzr9fHfAkZxtv157jlfcbR57Y7zco
        o7qnvADK7PJhZHaLhPHOyOQj5g==
X-Google-Smtp-Source: ABdhPJw4uF/pgegPbye435k/v1lUkoVwUYQoowompXaynV/gKBuhgsvu+u1kv1ECHRO05RH4OempVw==
X-Received: by 2002:a05:6a00:44:b029:155:18ee:a71e with SMTP id i4-20020a056a000044b029015518eea71emr2250049pfk.1.1602637984192;
        Tue, 13 Oct 2020 18:13:04 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x23sm989951pfc.47.2020.10.13.18.13.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2020 18:13:03 -0700 (PDT)
Subject: Re: [PATCH 1/4] tracehook: clear TIF_NOTIFY_RESUME in
 tracehook_notify_resume()
To:     Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com
References: <87eem1d7hw.fsf@nanos.tec.linutronix.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9e5c4784-26bd-3761-f282-7173df3e0ac8@kernel.dk>
Date:   Tue, 13 Oct 2020 19:13:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87eem1d7hw.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/13/20 5:35 PM, Thomas Gleixner wrote:
> On Thu, Oct 08 2020 at 09:27, Jens Axboe wrote:
>> All the callers currently do this, clean it up and move the clearing
>> into tracehook_notify_resume() instead.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> Nice cleanup!
> 
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

Thanks! Added.

-- 
Jens Axboe

