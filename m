Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE200403051
	for <lists+io-uring@lfdr.de>; Tue,  7 Sep 2021 23:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244484AbhIGVdG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Sep 2021 17:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243883AbhIGVdG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Sep 2021 17:33:06 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21846C061575;
        Tue,  7 Sep 2021 14:31:59 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id g74so122748wmg.5;
        Tue, 07 Sep 2021 14:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=COYD3Y2szh6y3ZHhT8fAtKXqXu8FfFvWcnTthORBujE=;
        b=TFAxO5xCZsHjvRS0yp2WjIxYvGrg7uAYl0mOgc3A7X8gNi7Q4TiQDnCdXjnKtfghtv
         s1MX3b5TRFXc538t+BuwczseNHifwfgZaW9wKBaOfdiNRsAhZmMNvAMwTH5/nHNCpnaK
         s3YwMRhXp2FN3LlhkDxMhGj0Hf8w4Pw6tnly7FmyzI1+HvUARrVQweVmP6oPrdmSV952
         jrTGGQICW21Vg4/XSrwKoeqPQ91cF/qtLJ5LoJq74iarEyrIZz0ftqf5bNwib+X31nlO
         vxo4Des3OE5nTVYos4KsRkEWi14pdo7vl0i0E79+QranFcd8+fNZqloQQC1dyBkK+qSr
         BSJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=COYD3Y2szh6y3ZHhT8fAtKXqXu8FfFvWcnTthORBujE=;
        b=JSdY6DazJUpDUlumb/XyIHhPY13HQKRSTfGGPEeMZB0RrSI3wAwPJnhz80ukO4Jt4L
         dm6Ni5vVTTNhBx9LU/SNx8PCpA/Cwd/JdGA9NiXJYQ3wQfjC/CP1yiHrirmKRcdxCBh7
         BVYqt8pDOomUyvlNyj2UTpdlJYCp/74D72fEywpmx6K7ugSnTlWpCJNhcIRj4MatmlJo
         oWwWOuMaN6lixOPGO+S0sgf5I7/wta8qo/JB9BHwVF7miOsLnSTu3FheCau/F90kF9ap
         momRUZIU+0TRA9X2v2mW42zp15cdFgCK64x+piIg+kQkPmYkHkEwavG9NU4xDfLcBzm0
         TR6A==
X-Gm-Message-State: AOAM5301ywfXtvZ6aNSUS6zJC+dLxmQs8OWHfV6wu7bt6CE8CcUd6R6d
        fIPUN8kSSxVVUFptAhulNajhhmG9GgE=
X-Google-Smtp-Source: ABdhPJwDqUMv5YBewE9mkew9rVXf7rHEcXPhAUnrfp8Q9uDepKaiTnyy5a0uCnOEfoNpt8ZyW6dVcA==
X-Received: by 2002:a1c:28b:: with SMTP id 133mr256358wmc.138.1631050317396;
        Tue, 07 Sep 2021 14:31:57 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.232])
        by smtp.gmail.com with ESMTPSA id s15sm173102wrb.22.2021.09.07.14.31.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 14:31:56 -0700 (PDT)
Subject: Re: INFO: task hung in io_uring_cancel_generic
To:     Jens Axboe <axboe@kernel.dk>, Hao Sun <sunhao.th@gmail.com>,
        io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <CACkBjsbs2tahJMC_TBZhQUBQiFYhLo-CW+kyzNxyUqgs5NCaXA@mail.gmail.com>
 <df072429-3f45-4d9d-c81d-73174aaf2e7d@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <e5ac817b-bc96-bea6-aadb-89d3c201446d@gmail.com>
Date:   Tue, 7 Sep 2021 22:31:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <df072429-3f45-4d9d-c81d-73174aaf2e7d@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/7/21 8:30 PM, Jens Axboe wrote:
> On 9/7/21 5:50 AM, Hao Sun wrote:
>> Hello,
>>
>> When using Healer to fuzz the latest Linux kernel, the following crash
>> was triggered.
>>
>> HEAD commit: 7d2a07b76933 Linux 5.14
>> git tree: upstream
>> console output:
>> https://drive.google.com/file/d/1c8uRooM0TwJiTIwEviOCB4RC-hhOgGHR/view?usp=sharing
>> kernel config: https://drive.google.com/file/d/1XD9WYDViQLSXN7RGwH8AGGDvP9JvOghx/view?usp=sharing
>> Similar report:
>> https://groups.google.com/u/1/g/syzkaller-bugs/c/FvdcTiJIGtY/m/PcXkoenUAAAJ
>>
>> Sorry, I don't have a reproducer for this crash, hope the symbolized
>> report can help.
>> If you fix this issue, please add the following tag to the commit:
>> Reported-by: Hao Sun <sunhao.th@gmail.com>
> 
> Would be great with a reproducer for this one, though...

And syzbot usually sends an execution log with all syz programs
it run, which may be helpful. Any chance you have anything similar
left?

-- 
Pavel Begunkov
