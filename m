Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9792436B562
	for <lists+io-uring@lfdr.de>; Mon, 26 Apr 2021 17:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbhDZPFG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Apr 2021 11:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233573AbhDZPFE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Apr 2021 11:05:04 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1347C061574
        for <io-uring@vger.kernel.org>; Mon, 26 Apr 2021 08:04:21 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id t21so5471629iob.2
        for <io-uring@vger.kernel.org>; Mon, 26 Apr 2021 08:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=6lhnpvMAH5HQlkr9mQ9bdVEThT/5dRtaDfV+/pvaNWc=;
        b=Ktj3v+SQQphxUE5vcd7QLTWUBHcO4kMmxpRXFpq+uOCeUXeJzDAql1/fTWYsva4+/o
         yNHo+YvoG8McIg+1fHECBz1+a2/wMK7mv41V+gQ5GMVBbMKpMdLk08FT25/DeoaOGQU5
         LGw5T16dStxsd8DaY5xMk3fLuvjqDtPjf7U1wP/GdIWIVlWU1QM3U7dC0v/mLDrH2rVN
         nAr0PU9P9pnk6iQSS3mY5A/w/We4pmXBWa7TQz8dMLyHYbmWCCROUOmxDL9J2/hkucWr
         eP21Tj8iiRp5R6G+mz6/Pd231d2UvFP+7Q0qLSwQzN4nFgFE0y5IUWxb+PW7ku9iCuru
         //BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6lhnpvMAH5HQlkr9mQ9bdVEThT/5dRtaDfV+/pvaNWc=;
        b=rLJvcb3fwnnJPZrmi9YMvfLzaHQSRpYo8WXZQxOQBpM0oSbJvlSut2UlqfStN/34Oq
         QI5gZifsEHlDEB+aWcZxcswgcIkv6giIbwqdBfQCwioSVz6eAlKcR/1JdukTe8qjO1G9
         On4iNXeWWqcx062RT0FVDTP96b0sJRg4KOJCplOFSNCxLuRv80dbdsILc5Dtf2yfERDQ
         Yc28XFLqG/1Vry9dbUYT9J+p8zck6fiT3PQvVCBy0SPbE65/t1avW2hrVJ6a3lER5skL
         P7fUJAR6otjWzIA5wF77exU7ENO4XOE/5uQlVPoUda5QCHIX5ZoBEUYs9pZk2aBH3J/u
         +Sew==
X-Gm-Message-State: AOAM532Ba97d697O5yEAsxEwZ8HcDm4clkatJRAlXuaXISpuHhce357+
        5h9xaLMTDBziOurbKs/HI3P47tnpu7bSww==
X-Google-Smtp-Source: ABdhPJxPHEYiYj79dXFp/vBE3qOscuL8EM3dplrGbo0rD0TStiJFlQmg16ffbK/vPkfYjDz9Er5IiQ==
X-Received: by 2002:a5d:924b:: with SMTP id e11mr14862391iol.133.1619449460934;
        Mon, 26 Apr 2021 08:04:20 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id x14sm68595ill.74.2021.04.26.08.04.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 08:04:20 -0700 (PDT)
Subject: Re: [PATCH 5.13] io_uring: fix NULL reg-buffer
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <830020f9c387acddd51962a3123b5566571b8c6d.1619446608.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <488d60ff-8020-8c11-d3e0-715b071c32ec@kernel.dk>
Date:   Mon, 26 Apr 2021 09:04:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <830020f9c387acddd51962a3123b5566571b8c6d.1619446608.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/26/21 8:17 AM, Pavel Begunkov wrote:
> io_import_fixed() doesn't expect a registered buffer slot to be NULL and
> would fail stumbling on it. We don't allow it, but if during
> __io_sqe_buffers_update() rsrc removal succeeds but following register
> fails, we'll get such a situation.
> 
> Do it atomically and don't remove buffers until we sure that a new one
> can be set.

Applied, thanks.

-- 
Jens Axboe

