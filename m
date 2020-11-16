Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE122B4B30
	for <lists+io-uring@lfdr.de>; Mon, 16 Nov 2020 17:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732068AbgKPQbL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Nov 2020 11:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730815AbgKPQbL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Nov 2020 11:31:11 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BC3C0613CF
        for <io-uring@vger.kernel.org>; Mon, 16 Nov 2020 08:31:11 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id j23so2142233iog.6
        for <io-uring@vger.kernel.org>; Mon, 16 Nov 2020 08:31:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Ja1q1MetQPTtM3W3MfJB5YQ7BmnjpMvI+apFCuMyXfU=;
        b=MLaDfmX8ToUk/0yTwvHavKqI+8XSSvld6UykUzeRVz54MmkY+8J8b8VP7EUhkkrri8
         ct6Raz6DscK7Z4d9AZ0G661XLfQx19zG4JwMKWOQxtLQ/f0E5s00kOUSUOnEsyl3mdnF
         /4t0z2AZEqSaLYbsm9UXmOeWZ7LrFamfcdz+UxLIVeGQmynJBT0ZsLJ3d93CpQvGM76T
         ATckIPnSsVujSypp1CMUlQWUuOWgP8GGnZh1vj0Cbuhu/0VW44eOxQM+72ic9uRYniFH
         HLlUkusM7X82gVKTBlUBKhMtY0lSq9PgoTJEQfnfq92tDkfL64aqp3XuqJPXOKPHnorC
         BLyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ja1q1MetQPTtM3W3MfJB5YQ7BmnjpMvI+apFCuMyXfU=;
        b=shWDDwZ7IkeJES5FWhx+VdiYL5XDY7Bd2WwMMD7LpW0Pws1MXYNBQvSW3fDhBXBs/P
         iZyop4SEnLg/pOtxdy+RNlGIgO87A7uFnSyWmge8o2yspbarWd92AXWFs2jsGU+cIx39
         NS6xp8Chsd06CfKz60bq6LGgba3bq2PtCYNUFdUcDNvDVNa2nTF6iuCZQm5Z6kG2ERMt
         QH0u4kuMf1r5IfnX4f4tDnJ1C/qTTuzaoBalv+p2ElHTh7eey+epGi67JbPagJpJsx8x
         kxVsHSld0+d3ZruD1wcCePwQiqIU7lsfD7+oUVuxbHFHPsPjB82kxQavPNJ+crog/zno
         +OHA==
X-Gm-Message-State: AOAM533S+qMFq90F82zpHih5QcTHhuGZYFcHdcMPYtCxx32c9fraD6p9
        GL54JhB1Q0qKAVLNIKMCqXsxQUwDfyHXlA==
X-Google-Smtp-Source: ABdhPJxKIFDWZpvSKujsJQ3voqYb4rxjS23nAtvhgq2IWMqyeGZm71LG2A724XZ4i3Olajfbl3/RCQ==
X-Received: by 2002:a6b:d603:: with SMTP id w3mr8546292ioa.103.1605544270231;
        Mon, 16 Nov 2020 08:31:10 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b1sm10402376iog.14.2020.11.16.08.31.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 08:31:09 -0800 (PST)
Subject: Re: [PATCH liburing] test: long iov recvmsg()/copy
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <f613395a7bf9c7a70f956d96e9d7a5a9101992c4.1605522519.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <56d5b0c1-94db-f3b8-619a-2162b3fda83c@kernel.dk>
Date:   Mon, 16 Nov 2020 09:31:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f613395a7bf9c7a70f956d96e9d7a5a9101992c4.1605522519.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/16/20 3:29 AM, Pavel Begunkov wrote:
> Pass in a long iov (larger than on-stack cache)  to test that it's
> allocated correctly, and copied well if inline execution failed with
> -EAGAIN.

Applied, thanks.

-- 
Jens Axboe

