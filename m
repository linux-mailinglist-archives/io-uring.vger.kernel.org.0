Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6FFD3A9CD8
	for <lists+io-uring@lfdr.de>; Wed, 16 Jun 2021 16:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233697AbhFPOET (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Jun 2021 10:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233674AbhFPOES (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Jun 2021 10:04:18 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3751C061574;
        Wed, 16 Jun 2021 07:02:11 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id l7-20020a05600c1d07b02901b0e2ebd6deso1785260wms.1;
        Wed, 16 Jun 2021 07:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=oxY0GQVk3+mhuNFcdWASnvkCwJYL3XKMxNNz6CvkGVE=;
        b=ucFe8uEGrCRlTEyxb9M7BOPpht4bV7diI9wCcf6+UBEBNFLxPgTcuISfTzyYVpW4OL
         8XvFLGafSMSxc1P5bt/ddLuMeQKE3HLJvLOB4OnZOTQzz9Z9sKn8JeX8D4IV8duB2ULJ
         8Z5cDkU88eO7uu/AZK7E1Nh/lu4o30xVxU/qhFMxcrH1WmW2gT8RuatrhtxqsX77MtR/
         IP8hIcNcIdEmz0zFxtrd+yUPFEX3iYkD1krLj5RsSq2cZJyYiQ7KxkgFStXE0p9L4r1y
         290FsoCA4qlNbdiVsaUBInLDgbaFTlD4cL3LeeXYWE/0rsaKmXhYbD6Jz7dpkQlhnnZO
         WX0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oxY0GQVk3+mhuNFcdWASnvkCwJYL3XKMxNNz6CvkGVE=;
        b=doXPccjxIX2QapbuycvD1arUZpYD80ufwJ+sG8PwDXJFkMbDIOkneeETvEuqdHgqBg
         bcbU8We3ViC/qr5wEHrZv9cv2fQv+oI8spNKZnXN0uNlfSfrd+vnhebidMbbfB9/n80u
         ayCdEOEJgwYTdOPyVEXcEZ1VYltyv12CaPk+f09EL3h7C6NXOXAb+nhDMiVsUpqZontd
         IO08X+ItFN6LwsmMhp/fvRyW2gNNau/g6xRVvekpvp0OfrvhNswKcqRmtMesdx3acO9b
         OVHq51Jr/uygLH6APKTwR7GU9WkIZBVUnDcaIJfGvtC0hljCqDFosTNqRL9SZDszAJzK
         5GSQ==
X-Gm-Message-State: AOAM530RLzLMgJDYB+aicibwqJNCf70pcYjA+MGVvdWD8I7nS0o+wc76
        UQ+bNW1YLE/WXrt43LPJOVqb/2TvSLh4PQ==
X-Google-Smtp-Source: ABdhPJydSNfzdRcG+xi6F8zzi6+B7T+flbgvOPaf9jf3Lx/N6e4wwtQ5YnzDHXKK7yHzqEZuQnjnXQ==
X-Received: by 2002:a1c:f60f:: with SMTP id w15mr11531818wmc.5.1623852130112;
        Wed, 16 Jun 2021 07:02:10 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.128.74])
        by smtp.gmail.com with ESMTPSA id q19sm5010731wmf.22.2021.06.16.07.02.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 07:02:09 -0700 (PDT)
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <60c83c12.1c69fb81.e3bea.0806SMTPIN_ADDED_MISSING@mx.google.com>
 <93256513-08d8-5b15-aa98-c1e83af60b54@gmail.com>
 <b5b37477-985e-54da-fc34-4de389112365@kernel.dk>
 <4f32f06306eac4dd7780ed28c06815e3d15b43ad.camel@trillion01.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring: store back buffer in case of failure
Message-ID: <af2f7aa0-271f-ba70-8c6b-f6c6118e6f1f@gmail.com>
Date:   Wed, 16 Jun 2021 15:01:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <4f32f06306eac4dd7780ed28c06815e3d15b43ad.camel@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/16/21 2:42 PM, Olivier Langlois wrote:
> On Tue, 2021-06-15 at 15:51 -0600, Jens Axboe wrote:
>> Ditto for this one, don't see it in my email nor on the list.
>>
> I can resend you a private copy of this one but as Pavel pointed out,
> it contains fatal flaws.
> 
> So unless someone can tell me that the idea is interesting and has
> potential and can give me some a hint or 2 about how to address the
> challenges to fix the current flaws, it is pretty much a show stopper
> to me and I think that I am going to let it go...

It'd need to go through some other context, e.g. task context.
task_work_add() + custom handler would work, either buf-select
synchronisation can be reworked, but both would rather be
bulky and not great.

I'm more curious if we ever hit REQ_F_BUFFER_SELECTED branch in
io_clean_op(), because it would just drop the id on the floor...
It might use a WARN_ONCE.

-- 
Pavel Begunkov
