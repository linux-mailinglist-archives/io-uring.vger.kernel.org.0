Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDC3C14144F
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2020 23:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbgAQWuz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jan 2020 17:50:55 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36543 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728760AbgAQWuy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jan 2020 17:50:54 -0500
Received: by mail-pg1-f194.google.com with SMTP id k3so12351125pgc.3
        for <io-uring@vger.kernel.org>; Fri, 17 Jan 2020 14:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=FLv2ZspmtqwV150G96rF061vfchfrzmz1i+ZdELex5I=;
        b=jUTxxjoN9jxxAGky9QPAtlkhKfjJdSN0eX88usA1girItO518AlegdysipQKmKs2td
         0Mc2Dl31yrUS3Gg2FUuKqBvAv6xgRLYrnvYcrk/qec0Z3qxhktOUJ69JcwpGfMhO/rz+
         hHSzIEZy9S/XhZ9WdFzu8kqHkAMKvNIdY3hFCv3hBzAGURg58s17qfurCfXONAbxFicH
         RWwqOH42l7zV5ozTOY0mykRT2lbWswyq8cxIv9Lz+6FwPThf9ve4UR/t0fwCWrGBRQh6
         dn/ooZjo6QxHXxgsTH7iydAjdEyOLfuK0707huw80XZXE3P//cvSzTW0sirPqRk4pApK
         2skw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FLv2ZspmtqwV150G96rF061vfchfrzmz1i+ZdELex5I=;
        b=OOV8w5pP89GEhcX4u40fNvjTwkfPIXYehC1F01AFjl3XDJ1lRtnLCNTveX8t4V5o1D
         jjrYBkTHGLJADPBlIzGMo1PCiI9/VXsjw9XPVmc4w81f7hynMDJqjuQjzfIC45liVD8M
         l9Lz7NNYiMemeLpZNcLclqrCPJrYkraxNg/DeZSpmoZRssKze3pxzxJQQE0K1Za8ivpz
         oR/Bdi1ExiBvczaWBTIUdUK54Fe2qI8c0VFzvFnaEZU2rJ0J5uxMoSbRujMDqqdAOCKM
         MJXAqIXu6Gtnitjdb8IBbip7OU7XMV2hgiZv6ViKhIldZmU56aO8WXujzOdT3qv7arxX
         YVdQ==
X-Gm-Message-State: APjAAAW4+vgqL4KUBfBBknruVsLmN5eX8W/+NUEjrTEMuyVG/bLtbH8+
        ydZvXSqD+302hD7DHgHfMbYJgA==
X-Google-Smtp-Source: APXvYqyLbHa29ExwxlYeQgQQ5kJdJHWOTl/fbP1w9Af9NS/b86mmk0Allegw/taWsqzBnhqvNw5A9w==
X-Received: by 2002:a62:e512:: with SMTP id n18mr5320769pff.50.1579301454363;
        Fri, 17 Jan 2020 14:50:54 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id iq22sm8774088pjb.9.2020.01.17.14.50.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2020 14:50:53 -0800 (PST)
Subject: Re: [PATCH 1/2] io_uring: remove REQ_F_IO_DRAINED
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <37a04c11e980f49cb17a4fd071d2d71a291a8fd5.1579299684.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8ba5eff5-891c-a02b-7c8f-62cc3365c710@kernel.dk>
Date:   Fri, 17 Jan 2020 15:50:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <37a04c11e980f49cb17a4fd071d2d71a291a8fd5.1579299684.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/17/20 3:22 PM, Pavel Begunkov wrote:
> A request can get into the defer list only once, there is no need for
> marking it as drained, so remove it. This probably was left after
> extracting __need_defer() for use in timeouts.

Applied - waiting with 2/2 until we're done discussing the approach
there.

-- 
Jens Axboe

