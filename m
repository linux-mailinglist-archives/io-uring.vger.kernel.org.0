Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A667417C25
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 22:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347111AbhIXUHy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 16:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348353AbhIXUHw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 16:07:52 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64AF1C061613
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 13:06:19 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id x2so11739807ilm.2
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 13:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=WQMLl6k9zD637LuK2ODCrsD+8jNepGZ/dUM2MKrxjbY=;
        b=8Db+vmYcbYMiXeE/y88nKhgnJll5jVoIIUmL4CZy+A9yPuXytxacwrVfkofnVs+kqh
         A7jIV9eORZkdMXOfJetREmK0JNklhrmT/lgH5r8yQl2ws0jzE5Rjdhsb1MEXZmFkhx9s
         cs87GBSmEpg4QirBh51A75FjpnAG8BmK480v7cGGyw0MVPtTMYopTu2NsChB8+FvwhN2
         uHS5qkjFB3E6nhtRrhsRkWpiU9DIW2vRewjDkTnIiZl0ofva71cgcOJeQU15INT2gsam
         nT35xD7+QmDJl/ToCUoZSpgq9AiaeoMPRRXcG2kARWDI4uYBmLqvT06R5/JjiJmdEMfm
         ZFFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WQMLl6k9zD637LuK2ODCrsD+8jNepGZ/dUM2MKrxjbY=;
        b=7T2BF5zGqC3i6Dfq0Sypr3PmATCF914Ajx+h2Qobe8aQlpVK1hu5+w3sdGaBJH+vtJ
         KEBCzjItr0x4/W8OfCszFZz0aCrI8G2d3qECGYTIGFIdXH7DfW9CEvk987FLVz6e8Lsc
         cdK5X/wnu4am8wl9+OFFZVODpM4WXENcbemmjpZaWerksxcFpWAC6UAQMYz5o/S/w8ki
         dMyKN5L4lx7Bu4RFAU/vxLvFkhlK3DDQLKqeX4JozWxNahj7aOgvavuxJB2pTO+lHLH/
         gsLI7AUeoP1z7nF2o+bMXMDkZdt6eVg6oCkbMPiOUen7HHQM5kpiHVjwLeOeZ/Kpz3iE
         GcIw==
X-Gm-Message-State: AOAM530Mp16JrcnmkwBAnC9sBmRJhCsBn22JzIMbOVJHDQd6csScD96n
        ZI0gXzXOW20sZAMrCDEclb5r2a9RrlviaFEjqRk=
X-Google-Smtp-Source: ABdhPJzeYHeGrdgVQnEFXZg0eikjKzcnrnY44cyL2IWmMMzQ8qaQjh5GxPsC3RK3fs2dY0IibDbZTg==
X-Received: by 2002:a05:6e02:eb0:: with SMTP id u16mr9967221ilj.178.1632513978509;
        Fri, 24 Sep 2021 13:06:18 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p14sm4688624ilc.78.2021.09.24.13.06.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 13:06:18 -0700 (PDT)
Subject: Re: [PATCH] io_uring: make OP_CLOSE consistent direct open
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <2b8a74c47ef43bfe03fba1973630f7704851dbdc.1632510251.git.asml.silence@gmail.com>
 <30d37840-1e3d-3f68-2311-68bd7cac4320@kernel.dk>
Message-ID: <923961d5-28f6-c3d0-680b-035560c9e52a@kernel.dk>
Date:   Fri, 24 Sep 2021 14:06:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <30d37840-1e3d-3f68-2311-68bd7cac4320@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/24/21 1:57 PM, Jens Axboe wrote:
> On 9/24/21 1:04 PM, Pavel Begunkov wrote:
>> From recently open/accept are now able to manipulate fixed file table,
>> but it's inconsistent that close can't. Close the gap, keep API same as
>> with open/accept, i.e. via sqe->file_slot.
> 
> I really think we should do this for 5.15 to make the API a bit more
> sane from the user point of view, folks definitely expect being able
> to use IORING_OP_CLOSE with a fixed file that they got with IORING_OP_OPEN,
> for example.
> 
> How about this small tweak, basically making it follow the same rules
> as other commands that do fixed files:
> 
> 1) Require IOSQE_FIXED_FILE to be set for a direct close. sqe->file_index
>    will be the descriptor to close in that case. If sqe->fd is set, we
>    -EINVAL the request.
> 
> 2) If IOSQE_FIXED_FILE isn't set, it's a normal close. As before, if
>    sqe->file_index is set and IOSQE_FIXED_FILE isn't, then we -EINVAL
>    the request.
> 
> Basically this incremental on top of yours.

Hmm, we don't require that for open or accept. Why not? Seems a bit
counter intuitive. But maybe it's better we do this one as-is, and then
do a followup patch that solidifies the fact that IOSQE_FIXED_FILE
should be set for direct open/accept/close.

-- 
Jens Axboe

