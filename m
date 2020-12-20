Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADC32DF665
	for <lists+io-uring@lfdr.de>; Sun, 20 Dec 2020 19:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbgLTSGK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Dec 2020 13:06:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgLTSGJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Dec 2020 13:06:09 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A30C061248
        for <io-uring@vger.kernel.org>; Sun, 20 Dec 2020 10:05:13 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id x126so5132683pfc.7
        for <io-uring@vger.kernel.org>; Sun, 20 Dec 2020 10:05:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=UcLembSIIjWuHTj1SUyZFz6EkqWHGF1NM1kkxn3IcEQ=;
        b=D2yKl4q3m19+tusNqAewuFQNekXd9qQseRkKPlkNLu/Zn1h3ShhVlpIHHlnZpFGS/r
         +Pr+DANE0BQa3pANperwaBNSXpO6896XqA31DiMqEYLQlhE2qe0sfjAWD8sNdnOd2Mrb
         4jzzBap7wtSHO0NI/U/OFMuEtw7BFJoXQdfHUZjPE54Ya65xnfeJCY+RTVxlNca3VNSS
         f7PnUV1+S3zLxpNrXy+KHVHBh2/NqkfT0nPf/SWJQ8272axCaOhiTMVieV4rifDrUTJw
         O43BXk7JQnxab1OAGBcch6eZJBTjThwmM1gI/z1qvojTWfgt6+kbI4qirc7/SbqGqsIl
         c2Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UcLembSIIjWuHTj1SUyZFz6EkqWHGF1NM1kkxn3IcEQ=;
        b=ZM8pqPYWLIvTMrRIsdYcpm1c04Sj2++MeYkI9ET/+5FHor2Vm9HmSTshg+BgVlD6cL
         zIb/tf+2Ijde4lhV48WlLQajk/lnyOtpmvkHah0klZeHbfVu3buXqAjlvNFZ+qk70smd
         JTy4GtFb4N5bC9dMbAXGj8ecehEY3hf7aLatORd9ec7HSnEdw0WkZUx8R0KI2p0l6/xS
         RXbk0w3jJt0uWupNXGa7oYce8hmFVBNWLWuQILkbHu/zVeiZj0gyvonPs26k7pqOK0oN
         YyshuSTzmkXwSU43vZ0bvq2Ilav7hQdVPjJ04MvpIr6SLKN9LqMUuyCSe9Lz7Yu+R6Gb
         u79w==
X-Gm-Message-State: AOAM531xSAwaOJSOYdQYBJvcej5D79hC+lQ7ioAy9l695KamwGgSGa+4
        qOAHbMolrYmLc9W/ztpPw6/YssvI5UV3Qg==
X-Google-Smtp-Source: ABdhPJzsel5gkf/YKJtpbMeCcoum0ef79OecoGi5cPw2JnU0C1dy8pAwCwqigYacEwwaRia7fzF88A==
X-Received: by 2002:a62:2cc:0:b029:1a8:4d9b:8e8d with SMTP id 195-20020a6202cc0000b02901a84d9b8e8dmr12508306pfc.8.1608487512922;
        Sun, 20 Dec 2020 10:05:12 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t1sm13235102pfg.212.2020.12.20.10.05.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Dec 2020 10:05:12 -0800 (PST)
Subject: Re: [PATCH 0/3] task/files cancellation fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1608469706.git.asml.silence@gmail.com>
 <b6795a97-9384-e105-7f64-7af821aed641@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <24fd5a4a-e5fa-0806-ec52-f8ffc0245a78@kernel.dk>
Date:   Sun, 20 Dec 2020 11:05:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b6795a97-9384-e105-7f64-7af821aed641@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/20/20 11:01 AM, Pavel Begunkov wrote:
> On 20/12/2020 13:21, Pavel Begunkov wrote:
>> First two are only for task cancellation, the last one for both.
>>
>> Jens, do you remember the exact reason why you added the check
>> removed in [3/3]? I have a clue, but that stuff doesn't look
>> right regardless. See "exit: do exit_task_work() before shooting
>> off mm" thread.
> 
> The question is answered, the bug is still here, but that's too
> early for 3/3. Please consider first 2 patches.

Yep, first two look good to me, thanks!

-- 
Jens Axboe

