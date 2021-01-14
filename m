Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A342F6EF0
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 00:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbhANX2v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jan 2021 18:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbhANX2v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jan 2021 18:28:51 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F999C061575
        for <io-uring@vger.kernel.org>; Thu, 14 Jan 2021 15:28:10 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id b5so4125506pjl.0
        for <io-uring@vger.kernel.org>; Thu, 14 Jan 2021 15:28:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=9UH65BnMUS+bh/GGiSIoPZK7j3GyrWdHmAKQGGKZ+PY=;
        b=g8prDejS4ZlMjvTEGM8149dyt0L/PsFkQp5I6oZWCISVCHQ2QIbg+nbg62IlLTPe+S
         KS4sotD/XR2mcrs3GWa2ML/Zw+kBb37wHh3CWb3WAlg/58CjEnazDC8EHy9FO7HDNPoj
         Kejgd/wG97CGhDOAIhAQcEtFaE3x/j5Ad3LeuTWb94AQuZyCmlJmsezNYLHitxBxpGLQ
         USdqKjh1HGsdAGxmXJTZiE6Wew7vjbiSHn+my8BiHhIby9zVzAncNVnfgO7oZcjgb5S6
         j+c7bWhZVDXY5+/xDgIXKKYvCw+RrZ3xMYLj9mSrgGVewUXJdRAADCGiiT8UJPjoHnni
         JrSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9UH65BnMUS+bh/GGiSIoPZK7j3GyrWdHmAKQGGKZ+PY=;
        b=TVwNOFxWrc06IykQbKP/qY01n8sW1HsI0aJCONhqH8IwNxy5TUrt1q+oScl24Sikjy
         CJapQOD49HmDMxpCDmOwwuK1jTO7yUok3Nt2ipuIb/NgysuARqyNVJ2itQjtkNVj3VfM
         DQUIQta8IDz9Nz3YgQ8hBf+fBUhL4F6knCvD2xdixDBcrnL4h93bGxzLbS3+FKp7fS6y
         BvIq1HV2j1Kv30Tp4BUr/FQC6rBjLi5d/NuREkpBmmNeEglmCgyNoKIJXsFcAYVXDwid
         EhdJ7Bj+eLyNUWPO9RjtqH0trtRKLWC9Pdo2apngLdi3CEJqaznLhE3GPvBypUfRiDMR
         tX2A==
X-Gm-Message-State: AOAM532tPnUVBF6B/aSk7dLFoe3D88fcZdzUGCmSGxcL7qwdQMXRksgZ
        +f7RHPqTX+8687NdQQicjWlQ3TPVjA14QQ==
X-Google-Smtp-Source: ABdhPJxnIfcAP/AQUsa4QW6CJ16wkOE/TbWpnV5Q6PkoIp+LzjmVS7MN5IHF/rZjMHqlSCZxUU+dkg==
X-Received: by 2002:a17:90b:46d2:: with SMTP id jx18mr7461607pjb.106.1610666889368;
        Thu, 14 Jan 2021 15:28:09 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id k125sm7021365pga.57.2021.01.14.15.28.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jan 2021 15:28:08 -0800 (PST)
Subject: Re: [PATCH for-current 0/2] sqo files/mm fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1610337318.git.asml.silence@gmail.com>
 <1c14686f-2dec-7544-5fa6-51e5a2977beb@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <013686d9-2692-9154-d9f0-fc54f1cbb63d@kernel.dk>
Date:   Thu, 14 Jan 2021 16:28:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1c14686f-2dec-7544-5fa6-51e5a2977beb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/14/21 2:12 PM, Pavel Begunkov wrote:
> On 11/01/2021 04:00, Pavel Begunkov wrote:
>> Neither of issues is confirmed, but should be a good hardening in any
>> case. Inefficiencies will be removed for-next.
> 
> A reminder just in case it was lost

Maybe I forgot to send out a reply, but they are in the io_uring-5.11
branch.

-- 
Jens Axboe

