Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B102347C3
	for <lists+io-uring@lfdr.de>; Fri, 31 Jul 2020 16:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbgGaOan (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jul 2020 10:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728697AbgGaOam (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jul 2020 10:30:42 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84484C061574
        for <io-uring@vger.kernel.org>; Fri, 31 Jul 2020 07:30:42 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id f24so11135296ejx.6
        for <io-uring@vger.kernel.org>; Fri, 31 Jul 2020 07:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Vkkn4BQ5txLC/pJtc5esZh75a6kQHNkWmrEgmeceKN8=;
        b=p/Zf9Z9t2CmgIhwiKN1Nb2gllNukDQzYq8BckezIWYn/mgz80pPH1ExzzjrwiVoQNV
         hptU1hjG15JO7biHGrcz9MAGnhfJXX/D6P6CrLlz0Rs+eYg2D2/DdV03FTAkZq4HWJb9
         wPc3WI03cG2YGFa/r/wMiPWWvIWdT/DfAewsn30Ll3T94wlh2dglwKfXQiQ2ccrBfxSL
         +AzD5ZnBVHHaWJM+BuODHiFdHN3F+LTt4eo7TbXl/DwFllO9b+vM2fH+VRkQF0sg/jqM
         Gs9UV1qZXqZE0kBDFSO9yg6JtlUc9t5ukP/cNugVz4nE35kKR03DfThCHYSo+7vtqHpH
         ilIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vkkn4BQ5txLC/pJtc5esZh75a6kQHNkWmrEgmeceKN8=;
        b=h8jDPbzxUCmRkkkIvMoZ7n1kRYiY8JX3ABB0r8YLEQCEXmE13tCnpDbEpSx33Nm5t8
         fz/YGuHT7YnX6SNBZx/dqH1smL+lFJZVYcfenTovu2MwNtjGI2p/P2Zy7BheeV+WJTHm
         opDiX+iKS1Avf3DBGgSppV9ddHmytbKLWMGQKcSaloJjIOW3RR4UZ0Uq/eFG9yzWglBj
         w6lvzJqxPIhV/5jtPGS1hkJNZ7zLniQ9wDwGtaQRYpIZa6fk6jW2jJuBjTf7Bkn6eRQa
         uQRaNbyhFr1w7wr6i9lyGVDQZ8+aIMECpIYU1A4U96AEvK1mzk8P4j8dpQ27QabO5J6w
         DBKg==
X-Gm-Message-State: AOAM5302YNlrGlj8pWdDNZmuWSs57w1Zawz4JxRCa3Rct8G1KNXuUf/x
        5ck+iOobRJmzoSZXsKKyEjcKPlLPxYs=
X-Google-Smtp-Source: ABdhPJxQRnAgVkapo3un7OP+NTZODzjPrcjxlQNU+pGzaTfYFPRc8mQhLp5nMHlqUrwtVUKsbra65w==
X-Received: by 2002:a17:906:ca4f:: with SMTP id jx15mr4528210ejb.449.1596205840960;
        Fri, 31 Jul 2020 07:30:40 -0700 (PDT)
Received: from [192.168.43.105] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id m6sm9125453ejq.85.2020.07.31.07.30.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2020 07:30:40 -0700 (PDT)
Subject: Re: [PATCH 0/6] 5.9 small cleanups/fixes
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1596123376.git.asml.silence@gmail.com>
 <3f481017-bfc8-d0ac-fbb1-b4fbac781eb1@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <ccea0f83-8ef3-018f-a590-ef8fad255b94@gmail.com>
Date:   Fri, 31 Jul 2020 17:28:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <3f481017-bfc8-d0ac-fbb1-b4fbac781eb1@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 30/07/2020 21:08, Jens Axboe wrote:
> On 7/30/20 9:43 AM, Pavel Begunkov wrote:
>> [1/1] takes apart the union, too much trouble and there is no reason
>> left for keeping it. Probably for 5.10 we can reshuffle the layout as
>> discussed.
> 
> Let's hope so, because I do think this is the safest option, but it does
> incur a 5% drop for me.

Hmm, any ideas why? If your test doesn't use neither apoll/poll/io-wq,
then it looks like either something related to slab (e.g. partial zeroing),
or magic with @task_work moved from 4th to 3rd cacheline.

> 
> We could probably make this work for 5.9 as well, depending on if there
> is an -rc8 or not. Seems like there will be, hence we're a week and a
> half out from the merge window.
> 

-- 
Pavel Begunkov
