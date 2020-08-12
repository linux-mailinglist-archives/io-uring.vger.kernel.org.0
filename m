Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABDE242B61
	for <lists+io-uring@lfdr.de>; Wed, 12 Aug 2020 16:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgHLOaI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Aug 2020 10:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbgHLOaH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Aug 2020 10:30:07 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE98C061383
        for <io-uring@vger.kernel.org>; Wed, 12 Aug 2020 07:30:07 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id d4so1224078pjx.5
        for <io-uring@vger.kernel.org>; Wed, 12 Aug 2020 07:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i6aqQcgNbWaD8PhNpr/CiuKZABvJoItQi5zxev4aRto=;
        b=0F4v9/1yuInWm6ll0E61OoLAqhwOYWZBBx6ZhwCoON2QSFIfTnNQDQomoLdh57aFg+
         4kQiLDDxVwZtThSHc2eaFxDwYolUAsxaMasXgU7RtzPIou24qi5YjmXnlmpaPfNvabLx
         K7uHZQuUbwdYhm7hrYucDRwh3lALoPtUUc1wT636sSMYASeFJbfB2S0iQQFF4TqH+My4
         0xGGCheSFryMJcIN8etpvkqcshJy/WqPHyjlgS4mMoOr6U5V5ocCt97LJd+p7mXH9+ul
         4zRVeXwsDLHvwMePL1FPEdrgU5PUz7U71rlBNaDQHm/UZj2iHVfELwuo1VmflSJ/PEh9
         Hj2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i6aqQcgNbWaD8PhNpr/CiuKZABvJoItQi5zxev4aRto=;
        b=soInkmYjCoOMa7xLTyau1VWdi5ajSBFGl2PAE6Wg2QaU2XvVFaqX3NWEPuVelOXk2l
         Rtm7FVSfFkzcWGiMfYejTR4mVxFAJQo5RkJVHviA7pZEIJlWhzWnf23xGWpbfbpsZays
         9+m4WXALAlnW1GvSq+F1+Lpgp8FPO1UVhfz401yTzCH5hHVGsaUEmeZX+0CoyqFMB6bF
         Fy7G0SdU8ZrT/XN8EIDIql+TVvm45hMjwFrzCo526usoAkZ5uqs9KCcbSzV4GAROg68R
         YprqI0QS/CzzsFi9Ix4wEdk3AfDQXlAy4cRR9Vzp+BXWUWVuOnkKwScl9l5zpYL9kMtS
         FOjA==
X-Gm-Message-State: AOAM530Fqoml19Ip6XRXr+QmN0AFIBQLL2kmlr5yEdKLAyxWZ3fdONRb
        LZrCDtAWknycFYZCkav+Fh9AOmiSxsA=
X-Google-Smtp-Source: ABdhPJz1L4DqTVBkgbkfTvZSNoLB+LeUiMQFpaw+yxLWrwg7POBIuWKXBJjSnosY896P7nzYP9rleQ==
X-Received: by 2002:a17:90b:1484:: with SMTP id js4mr265430pjb.186.1597242605918;
        Wed, 12 Aug 2020 07:30:05 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id h65sm2823576pfb.210.2020.08.12.07.30.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2020 07:30:05 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fail poll arm on queue proc failure
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <6d9ed36f-c55a-9907-179d-3b1b82b56e90@kernel.dk>
 <20200812083937.m5zmmnnavfdlqlrv@steredhat>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6af806fc-214f-6a99-03ce-188607d32b66@kernel.dk>
Date:   Wed, 12 Aug 2020 08:30:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200812083937.m5zmmnnavfdlqlrv@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/12/20 2:39 AM, Stefano Garzarella wrote:
> On Tue, Aug 11, 2020 at 09:52:55AM -0600, Jens Axboe wrote:
>> Check the ipt.error value, it must have been either cleared to zero or
>> set to another error than the default -EINVAL if we don't go through the
>> waitqueue proc addition. Just give up on poll at that point and return
>> failure, this will fallback to async work.
>>
>> io_poll_add() doesn't suffer from this failure case, as it returns the
>> error value directly.
>>
>> Cc: stable@vger.kernel.org # v5.7+
>> Reported-by: syzbot+a730016dc0bdce4f6ff5@syzkaller.appspotmail.com
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> LGTM:
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks for the review, added.

-- 
Jens Axboe

