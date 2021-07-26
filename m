Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D573D646D
	for <lists+io-uring@lfdr.de>; Mon, 26 Jul 2021 18:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239829AbhGZP6R (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Jul 2021 11:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237400AbhGZP5e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Jul 2021 11:57:34 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423B9C061757
        for <io-uring@vger.kernel.org>; Mon, 26 Jul 2021 09:38:02 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id l19so13746132pjz.0
        for <io-uring@vger.kernel.org>; Mon, 26 Jul 2021 09:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=aP8D0bxiz7Fu3dK9RtTnqJuO0NIT1Y1pgsXb2gYEP6Q=;
        b=JW69RSYwrcnA2WU0xFP8RSf2TXDuGvsSfaX2LsXMyf4Zv+xwHBI7AuotsVoyU9odw2
         vnOwC5wWVYZ46ImLwyr7BRemt1p52qYGFVeQeE9+O9wXfeLlkYPQNCrGsrdyzruXVISH
         3oCvvNftGxps4aqaOX4h354KAyca1MIBUl9V8SODedGrsLLuWiGYQDDOcKEbeZzNud9A
         VzchBQs28js7YOFCeJS1FImtpLFbHUWnuJiM0qn/xyDJvKpY8Pi7EmfIQcTQEx9+Kza0
         Vb9bNCu67qU1btL6RScLe1tMg94JaqbC8cYx+iFqBfHORgRmGrg3iJ+8hEVPh0NaPLu7
         n/Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aP8D0bxiz7Fu3dK9RtTnqJuO0NIT1Y1pgsXb2gYEP6Q=;
        b=NPx2FDUznUuZqCZrl9nriKxlOqcm1akI+ZohgbCCCJM9szsiSUy9CePBocdkKk2N4Y
         gPbf+qE4yxqg1u65yJp3x7fBc5noSJ+LXAhilnQNoU78uihQDZX2i5M+ZOFh+5XNMV02
         MKXpRKGh6Ax6W1Gn5xb9sLuv+6qUObaCupkXcwoxqkxZ8wuRiPsOm9R11c3E041vdSe8
         0CgVjR7s5z2VdAtZ2UnA2o5VbRD7/Xq7jE4r8biGt0BFdc2Q8gQakQjFMNIgPw9MI0dm
         6N6yovfdBeGPd+RKvvhydDyOQ/5k7i1L0vd5hm7XIK6Zg8KZL09Lx26jx7Ev/Lw6Jic5
         43tg==
X-Gm-Message-State: AOAM533WMux2t175w0skJNr3fuKLccrdYWMiU7KCxL70HnkOw/1X8GF0
        Kg9eYsdCmorHqKeu/A9+/201eM2IFJ/pPTlm
X-Google-Smtp-Source: ABdhPJxHwfMRDo54kG3jlYmuC8rje2PsH+pdWUArQQVaM2Z8PTytB9E8ETJg50ZlMcQzARnAon0J5g==
X-Received: by 2002:a63:770c:: with SMTP id s12mr18990506pgc.339.1627317481424;
        Mon, 26 Jul 2021 09:38:01 -0700 (PDT)
Received: from [192.168.1.187] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id h5sm473603pfv.145.2021.07.26.09.38.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 09:38:00 -0700 (PDT)
Subject: Re: [PATCH liburing] tests: fix poll update compatibility check
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <2a5f83d0cda642d97ea633b55ba0d53e82cbb064.1627314599.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bcefdf7d-a4b8-04b6-ec54-32f4325c641f@kernel.dk>
Date:   Mon, 26 Jul 2021 10:37:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2a5f83d0cda642d97ea633b55ba0d53e82cbb064.1627314599.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/26/21 9:50 AM, Pavel Begunkov wrote:
> Compatibility checks in poll-mshot-update doesn't always work well, and
> so the test can fail even if poll updates are not supported. Do the
> check separately and at the beginning.

Applied, thanks.

-- 
Jens Axboe

