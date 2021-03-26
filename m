Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3AA034AC0C
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 16:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhCZPzx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 11:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbhCZPz2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 11:55:28 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF4FC0613AA
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:55:28 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id j11so5371381ilu.13
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=kquiMmqts0E2PMB1rq3dbOqz2Pw0pa0AZK5DCLBOA+c=;
        b=1XPGeonl34s/6K8KNjNKG3kQ398Pq/j6aSoriaBkmzxOaDNIStUtutRxycRm5wp9QZ
         5n60XXaD+VA6iOgkIaB3v9MWr5oXUKPNEZa2Vi58zhbb67uuwMYF+Gh/JwEDr3s6nsAj
         TRUW3X40Q2gOWYTYwBtycOUkJjLdRoVZaqJx5gWe/IQb1lEYw4+uhriykyhaTTrVt0c/
         uvl8lnGt8Y8huuXf3gKJToq0xpi5fXeeDkGmaEufiQPIk1VPAOItun6KVdCKiT5rYYxp
         qBECX8ebz4itlcwyKkl8YltxEWyf+fUjcwKFOuSdAiPLZA5KWjNNvdqzKU2c3acb9qCG
         sHBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kquiMmqts0E2PMB1rq3dbOqz2Pw0pa0AZK5DCLBOA+c=;
        b=oKFPCW2Lko69htRLsoiQ0yiSKFFrnmXdgi5I/BvzBU7BiSnVO3jMTHdmLq8Twd0gfl
         mYvOBsfUNMRedKEY1otU4zS2DOeoSPjSFv+QbyWs67ejRdj9WuUVBblZ5x4AZ8f4DkIh
         bjhksRWd4RvG5tojovcXKCbepzAtNgdK5pZ2jxmbVeIGTOQ6ykGF57XqwJJ3PDdbHSGu
         og6ykV9JokAAqBwYwlb58MAEUOYcHhgv4ATseSlSD6MC8Mj7k27wc4kFDTtm6pqr+Z0F
         TF87tRioSyRUm8xvHRMantwUd1O+G4zac4ILH147hOqZV7Uxp8q336BWiuebgvcereYc
         6caA==
X-Gm-Message-State: AOAM533eJrcGyO43uzibn51/Lo45X0pwFZzhgRmBk5SkZo8jLK+FDAUG
        9hIG0NjdU50/jeWxcgrFNsspeL2ap7axqg==
X-Google-Smtp-Source: ABdhPJxk93xQklnWMFyq9i9wVWvxumkG4Og42MlJGtqK1/x5oxo97lMkAFhYbxeABmhwNaY4Johd/g==
X-Received: by 2002:a05:6e02:ec9:: with SMTP id i9mr5363964ilk.161.1616774127277;
        Fri, 26 Mar 2021 08:55:27 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h12sm4696260ilj.41.2021.03.26.08.55.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 08:55:26 -0700 (PDT)
Subject: Re: [PATCH 1/1] tests: more cancellation tests
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <914c86e2d94aafe7e623c07f4e39c7eba0c04228.1616696841.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6e23a5b8-1ea4-9a7d-a865-abb3ba493e65@kernel.dk>
Date:   Fri, 26 Mar 2021 09:55:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <914c86e2d94aafe7e623c07f4e39c7eba0c04228.1616696841.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/25/21 12:28 PM, Pavel Begunkov wrote:
> Add a test checking we don't cancel extra on exit() cancellation.

Applied, thanks.

-- 
Jens Axboe

