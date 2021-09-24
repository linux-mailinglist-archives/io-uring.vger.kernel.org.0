Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3A6D417C09
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 21:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348270AbhIXT77 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 15:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348267AbhIXT75 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 15:59:57 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA3DC061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 12:58:23 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id 134so14087630iou.12
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 12:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=yYRPHf8bJEeBmXfAfHR6DEcbGm4X2XvVozN5CU6eCl0=;
        b=C5B7InS15SdWOF5QhpvyiD+6P0mHeQyEelkraRMPM+2d1eh+E9TgHZqvlkieOnkndz
         Egv5KGxc3LGbHgho3jr7TNrtRkwgnLtA9UZ6LVZ7Gyhk4RckIVRwFViQ/u0xK61Z78CY
         KWoUibrssS1nbZbxf2vrDobK47YMs9LbfmtyAckPXqMFnilEp0J5eqnrUvpLLBz3n9DV
         mZcXrtsb+x2buLgO17/FXKYmN/cPdFXUoHNaQfFkVL0Q9ZAC+7Sw1TKbQ63NK2Fcgk6S
         yHsd5BAxtxMVDO2MAaSElk7LOsdwL2xhyuXbmUYGYHrhgxN6andk4zKlfuZJT5xSS29D
         2vQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yYRPHf8bJEeBmXfAfHR6DEcbGm4X2XvVozN5CU6eCl0=;
        b=GYMB4ACNUDOlkPikzcnVxPFOqVbDhniuBMaklDtgYk28ZvsNlxk2b61J17Tgh/xzNT
         P3+but1QeWK5NDC8K/yJWZ+3OEoRIiLorKu43KneZF2l8B6j2CFj+HLiJiPyTAYfMU3R
         V3XPW3ZLDN8R8NXS9x1i9V2MUycEsi/fD6t8rRnxZLqwvfZ3LZa5Lq+jaUWmFd42eKrF
         bTkFUNp1stnMN/6BALh8dbIb17vBpsa2KYsGWWUBHTSkp5UTaotGZU5K9a9b8theSeq6
         /6+FqSqTfRmXD6+PPhG0F5ztTdlNKEUk37MVX6JchXEbykKemEQQ6mZZDUId3QbY2hk2
         Lo/g==
X-Gm-Message-State: AOAM530ResvwoiXrMmRqaOOxbmVVh+8w9sZMBddmPJwbhN8iqNHd7WNA
        8ZjkCAHRc5iKZ3Dbj0qIIuyjOqf0Q6FFq8oZCKc=
X-Google-Smtp-Source: ABdhPJxQhv6CqC84702hMrku+UftfRH2FCDXeLMJFjKyjOYPL+J1QwbVc8SXoqHmMbZMYpCfbT7S5w==
X-Received: by 2002:a05:6638:2722:: with SMTP id m34mr11033366jav.49.1632513502659;
        Fri, 24 Sep 2021 12:58:22 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id d14sm4680820iod.18.2021.09.24.12.58.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 12:58:22 -0700 (PDT)
Subject: Re: [PATCH] io_uring: make OP_CLOSE consistent direct open
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <2b8a74c47ef43bfe03fba1973630f7704851dbdc.1632510251.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8a673462-9ad2-75c7-b7c2-5bdadadb09ac@kernel.dk>
Date:   Fri, 24 Sep 2021 13:58:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2b8a74c47ef43bfe03fba1973630f7704851dbdc.1632510251.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/24/21 1:04 PM, Pavel Begunkov wrote:
> From recently open/accept are now able to manipulate fixed file table,
> but it's inconsistent that close can't. Close the gap, keep API same as
> with open/accept, i.e. via sqe->file_slot.

Applied, thanks.

-- 
Jens Axboe

