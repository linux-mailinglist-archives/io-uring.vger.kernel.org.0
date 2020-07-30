Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91339233820
	for <lists+io-uring@lfdr.de>; Thu, 30 Jul 2020 20:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgG3SIT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jul 2020 14:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgG3SIS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jul 2020 14:08:18 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E60FC061574
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 11:08:18 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id i138so17326461ild.9
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 11:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=afv5hWEmyqO0/X6Rw5q7oG+N3FNTfBrUSPlTFcQjaAo=;
        b=B7P8xKa8B7KZHclhgziraAKO8MVBjCpMzodfncZuyOoAbvFbRSiDaY89o6PeDEz9Mg
         eKgLfRND0R/x280G0fawv+FGXbvYvoM2rKgZqU+ngnCQPmlPwB/0u7lqFKWw+OsT5RFo
         J34Dw0ruGYe6RFtdVMaDKnsRo4E07JvrGOR1EfVidLYJKF2i2MwekEmJMtdC+2q6pQBa
         PFtL32uAcfgbYFO+qXTUKfaBheaUxUIvhFjZ6shltPUs33nhq7hoIZdqULs650mR0R5i
         CH7CJ7zRwsAj5ZJQcEvydKfRLonig6Nfne+W5rzGKe/bOJa19McbDxBZiA+D4pD8bgjx
         M1vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=afv5hWEmyqO0/X6Rw5q7oG+N3FNTfBrUSPlTFcQjaAo=;
        b=etm5Z7p3VaNctJeq82fMYGT1tN3sKS9QUv0dt0BkPkCqqWxgxHfdtDqoCqF55U64g3
         6ogRdZ8IMvQck2/0ZEibgTzgYWVIi7dpNMy081JZ6TAa1QZElmvd1MUvNl9iQaVl+8rm
         gfuFeazZxzJqRBqu0eAS4JmffshP6oWlnW52HoasGataXHlMk4JV1AhLyRkVAQtBHd9L
         PMIQmWUmGx42rZJiuR2dEuZrR9w0o34OBFXs8rNTYUvAISLq/7dzvGnkxJ6RR08j+Wla
         flXasH+myWe+B33BxpqhDdZVQPCLb/SagEeD0ar0VtLG4HKlHpxWwI2hGjgb0hs7h5rO
         2GYg==
X-Gm-Message-State: AOAM533mzKiRoD3k7+AhOuhbOirNgR7f9Lyp78QpXtOuGwgjL7k9yEIl
        GtaEVLE2E+xxmIaUMR/4sqV1F/2tIf4=
X-Google-Smtp-Source: ABdhPJzudvvBkevPNDGca7GS5bkKoe8IoaQs/wiF2/5X8YDHn7AxmGmUMCd+HIuuTdgOUYeNPtMcsw==
X-Received: by 2002:a92:bbda:: with SMTP id x87mr26071148ilk.242.1596132497313;
        Thu, 30 Jul 2020 11:08:17 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c13sm3448355ilg.27.2020.07.30.11.08.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 11:08:16 -0700 (PDT)
Subject: Re: [PATCH 0/6] 5.9 small cleanups/fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1596123376.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3f481017-bfc8-d0ac-fbb1-b4fbac781eb1@kernel.dk>
Date:   Thu, 30 Jul 2020 12:08:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1596123376.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/30/20 9:43 AM, Pavel Begunkov wrote:
> [1/1] takes apart the union, too much trouble and there is no reason
> left for keeping it. Probably for 5.10 we can reshuffle the layout as
> discussed.

Let's hope so, because I do think this is the safest option, but it does
incur a 5% drop for me.

We could probably make this work for 5.9 as well, depending on if there
is an -rc8 or not. Seems like there will be, hence we're a week and a
half out from the merge window.

-- 
Jens Axboe

