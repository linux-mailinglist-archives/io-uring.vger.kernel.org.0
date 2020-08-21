Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3E424C9C5
	for <lists+io-uring@lfdr.de>; Fri, 21 Aug 2020 03:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgHUB5n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Aug 2020 21:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgHUB5l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Aug 2020 21:57:41 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2184C061385
        for <io-uring@vger.kernel.org>; Thu, 20 Aug 2020 18:57:41 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id d4so136856pjx.5
        for <io-uring@vger.kernel.org>; Thu, 20 Aug 2020 18:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ZdHxIpFnJnE4SQXDnf56TBzsZjfHWRza2evXa2ElUWc=;
        b=UuR52SF5bQ7+X2utKQ10l44jrFcot/C66vLR3kDEQJLvhQvqGp9pGStvv8xahUxhrW
         REMGgh2um5Ke/Pn3ZAcKBc9RApqaHGo2bA9W/AeIRuDGu2QygFOnWgMC8LlxXWRWC4Lt
         eKRY1TY1BBKw1+hY+076J+WPvz0L5la5FbV+LMKypi8p/AnYJgyYPp5qS/SmuTgAKv2y
         PuBoWmXImjfxphr2dfQQIy++J0Vv5OUofep7Fqz7uB0j8L89PmFMxPzUnva2OawM235d
         oAqdN0MKVnPSxNcotAN7ZfVvju+afnr4Eo4ZMEze0XiixC6iaqlEVLZKZSrcBhM160n0
         rtmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZdHxIpFnJnE4SQXDnf56TBzsZjfHWRza2evXa2ElUWc=;
        b=AQPpbGBrafMBBJMI2Zy8XHUQtueSrnTv5F5TMvZjXGnyTwCmdDxBkfGWWoou9D/iza
         htLbBDxTWnOegvaCIaoTJbC+Og/67ddj3CBmkiR7wg4EYfpFgNPVLMnj8QxPvLAz22zD
         pF8z70wipykj37jsFTrdi6a+kitSTBQt5AYadrWMcLe+VawcFWmWug4odS08p/v6MYCA
         0yKAh34svXGM3fFE23lU6IboenJ8a6VV9dPCgcHghSNhG3XiztzxhWezEZDbPC9HHueh
         sJYduNsXWyRSYQff1050jn76qVdalmPPVYPhPk3HLcKHwu8d4XiVYn4xsubJuGaOOnAY
         dUUA==
X-Gm-Message-State: AOAM531bu/pExgu+oxCwINiIiVdKu9oHfXlyXhr+6rMNPaeEDFX1lc4s
        iNhescqYZUgxHP7PsoHxVSIknA==
X-Google-Smtp-Source: ABdhPJw1QSgtMHrM3wE5R/Pib8lAjnHZpVhRQvhpmBZq9/husimrJh09By4MB0Y222kVJnz7sKDP0Q==
X-Received: by 2002:a17:90b:509:: with SMTP id r9mr540171pjz.228.1597975059557;
        Thu, 20 Aug 2020 18:57:39 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b6sm176642pjz.33.2020.08.20.18.57.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 18:57:38 -0700 (PDT)
Subject: Re: Poll ring behavior broken by
 f0c5c54945ae92a00cdbb43bdf3abaeab6bd3a23
To:     Glauber Costa <glauber.costa@datadoghq.com>,
        io-uring@vger.kernel.org, xiaoguang.wang@linux.alibaba.com
References: <CAMdqtNXQbQazseOuyNC_p53QjstsVqUz_6BU2MkAWMMrxEuJ=A@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8d8870de-909a-d05d-51a5-238f5c59764d@kernel.dk>
Date:   Thu, 20 Aug 2020 19:57:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAMdqtNXQbQazseOuyNC_p53QjstsVqUz_6BU2MkAWMMrxEuJ=A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/20/20 6:46 PM, Glauber Costa wrote:
> I have just noticed that the commit in $subject broke the behavior I
> introduced in
> bf3aeb3dbbd7f41369ebcceb887cc081ffff7b75
> 
> In this commit, I have explained why and when it does make sense to
> enter the ring if there are no sqes to submit.
> 
> I guess one could argue that in that case one could call the system
> call directly, but it is nice that the application didn't have to
> worry about that, had to take no conditionals, and could just rely on
> io_uring_submit as an entry point.
> 
> Since the author is the first to say in the patch that the patch may
> not be needed, my opinion is that not only it is not needed but in
> fact broke applications that relied on previous behavior on the poll
> ring.
> 
> Can we please revert?

Yeah let's just revert it for now. Any chance you can turn this into
a test case for liburing? Would help us not break this in the future.

-- 
Jens Axboe

