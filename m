Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7839D35FE9A
	for <lists+io-uring@lfdr.de>; Thu, 15 Apr 2021 01:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhDNXtR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Apr 2021 19:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbhDNXtQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Apr 2021 19:49:16 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4375AC061574
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 16:48:52 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 12so11477149wmf.5
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 16:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y+S3oLJ5ewdk8Dp7hRVVrZSMiHl/8RvUbBIsvHr8iWM=;
        b=h2F5GRJMKjt4wwbLYqSgH9IqEcPZtRe5OAzbmP+KK3AWmYtHvR93YnCM+w2sw1Jz5m
         LI0+H+xGDO3Svo1wdXQ+XnqWMO2s3r8ZHkMSgSsRl95jOtczsVesDg1uP3H1jBB4+f+N
         GZBvGZ4JPK7W+5qfiNsQq8dM55UIiqhy3arslCBiknY7P/INPzYiLKk9HleXAh91uniX
         LXmuExNvefaex+ZtucJa8D0W2ylhhFqntL9Dv63kHgOP9SZEuQ9AT1esi0qn6UtKvJfU
         IJQLbA0pbDZUxBy2XmwAGiWQqFKo/mMFwP/Le/VHKIymIqZ5zBeBDPQrV9oINvLWVMg4
         pK9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y+S3oLJ5ewdk8Dp7hRVVrZSMiHl/8RvUbBIsvHr8iWM=;
        b=NXGAxScy+Ldb4uadONL7eXVk8qNiKF4oKwfeiGc+rWwGhC/aw4YHFIVHS0Rem6qR26
         zMmWlE6zD1kfAXbfGies3PjpGll9ZRknD2pHfRH3+J7rOZngWxBTwTnx5DfbvZIlQqc1
         M1AesVcPaXUmrFTxNGp40L4rmNGD5ioDk5IMvtG3jvanAmrSxVG8wGgDbn3KMck60LAC
         fByVcisPTfBX3TunznICA8WuO/oxK0WX2xpJBX/Y3g4KXLHT/zu+WE2Si4D/fYXZEuJP
         yfBvq5uH8RljIPl9xewVzLBt2rHkxs08rJaNI+y9rcHuyCxQDvSEVQuPLG5XP+al864P
         Ol2w==
X-Gm-Message-State: AOAM531Ox+b8K1W4n63hdjSS782OB+g0sn+sbBP0DkBYQ+opk6fG1LGx
        Zlqdcb0MLxGuwHQKXvMxL9L0GL+v58Laiw==
X-Google-Smtp-Source: ABdhPJybxu0/hT5kbl5ttcxTmw8aHoFQm/NpWkTYSfdqagg2plCcaXLNr4U1FDMWjy+1ap1bcqWSrQ==
X-Received: by 2002:a05:600c:4fcb:: with SMTP id o11mr323266wmq.117.1618444130865;
        Wed, 14 Apr 2021 16:48:50 -0700 (PDT)
Received: from [192.168.8.186] ([185.69.144.21])
        by smtp.gmail.com with ESMTPSA id g12sm818659wru.47.2021.04.14.16.48.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Apr 2021 16:48:50 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <3d7646712081cf84346f13d94098cda257cab11a.1618442414.git.asml.silence@gmail.com>
 <33532d00-2e39-508c-28cc-2f5a0ed27251@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH liburing] tests/poll: poll update as a part of poll remove
Message-ID: <cfdb2520-f87c-1de7-eb8b-913c51ac05d9@gmail.com>
Date:   Thu, 15 Apr 2021 00:44:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <33532d00-2e39-508c-28cc-2f5a0ed27251@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 15/04/2021 00:29, Jens Axboe wrote:
> On 4/14/21 5:22 PM, Pavel Begunkov wrote:
>> Fix up poll-mshot-update test doing poll updates as we moved poll
>> updates under IORING_OP_POLL_REMOVE. And add a helper for updates.
> 
> Applied, thanks. Now it just need a documentation update, but it's not
> the only one... I'll make a pass at that soonish.

Perfect, we can now ask Joakim to update his tests to use the helper.

-- 
Pavel Begunkov
