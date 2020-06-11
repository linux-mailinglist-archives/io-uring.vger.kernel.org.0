Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6D41F6950
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2020 15:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgFKNqk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Jun 2020 09:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgFKNqj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Jun 2020 09:46:39 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEAD1C03E96F
        for <io-uring@vger.kernel.org>; Thu, 11 Jun 2020 06:46:38 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id r9so5033742wmh.2
        for <io-uring@vger.kernel.org>; Thu, 11 Jun 2020 06:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y0QIiWvcLOohoGmGt+pbZwsCayw/KG1w/o+WSPHDqrY=;
        b=M7Q7KctP3WkWME9FFlOFHkAonmH9J9y7T1IbuPKhYOO8niWQjdZ0Lzk8ItN/aWTQVb
         jBtJcVWlzLO30wgsOCbln2p/exLjTaHuqaUf3KQoHsuLDq43DRyW6jkZzSwJHrBUT5He
         4S1W3+z0rifqdMhpVxigKbj96gd6vhLjFbIqUpUxZAQln9EavIKYKUreHD5PVTrpmV2F
         RHMPqoosJq4Vdi8Ps7Tvopb5tFqy0oNpcZ1GwoWlx2mMaD/PwD8G8qMh3YEGxdFjj77O
         ZJH7VWBf2kkd7xNb6DWxNSz0H2Rzv5YDH0SDTPs3QYicvdU9XWeXafkQKrYIIafQ+C0V
         PW8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=y0QIiWvcLOohoGmGt+pbZwsCayw/KG1w/o+WSPHDqrY=;
        b=E0wX0Blqxhs43Qsmb/lMQYZrTKPplZqarQOgZ/gT6YHom0VoAMIGFPQO8g/qQyZ77q
         MIvAAZhO0sfMGwn0UBZjX0BYV6uXNNJyKilfVl+iXBtXwp5Z5K1dy1K7Kmh5Iqf07rGM
         ruLjjVAR0RLSLWyrCU4epcVJzj13jaGT74WmxicEtL81oVrklkt5VuweFXWpc2yK1FE5
         HQ1mlSZjDG7++sfvdtqPp6yqXehcfeX0vpZNb/K9PeHi2LIIq+Jsc0XwIp+msXbya0VD
         4tnx19wvSsb0XJQh8R7W8BiujeWBHHIqWPYFGLWJsiq/QRX7Hh0X9AkpcYcDthBzqGHG
         L+dA==
X-Gm-Message-State: AOAM533cPs5Hg3Z6gROQjZP9RcWhf13KZVJt1+W/XzCTmrrUmAwd5DKK
        yaYqi+hL2ZDwbHGKppVKNW7ndnLy
X-Google-Smtp-Source: ABdhPJy2AdX8p7p3Dh6WSRYr+IodgJLYIKlFfrS2iXr7WFcavbk9p5vLuZJlaTwI7eiXF0XYsmC1RA==
X-Received: by 2002:a1c:bad7:: with SMTP id k206mr8172048wmf.11.1591883194828;
        Thu, 11 Jun 2020 06:46:34 -0700 (PDT)
Received: from [192.168.43.53] ([5.100.209.134])
        by smtp.gmail.com with ESMTPSA id a126sm4176691wme.28.2020.06.11.06.46.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2020 06:46:34 -0700 (PDT)
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200609082512.19053-1-xiaoguang.wang@linux.alibaba.com>
 <c4f10448-0199-85d3-3ab5-b5931dad00f0@gmail.com>
 <3803a578-a13c-07e7-37f1-fee691dd888f@kernel.dk>
 <4d5b9706-9abf-55c4-1f01-d87d536e5b45@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v6 1/2] io_uring: avoid whole io_wq_work copy for requests
 completed inline
Message-ID: <fe30e2a3-d18b-d2fc-6618-bb07639c6880@gmail.com>
Date:   Thu, 11 Jun 2020 16:45:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <4d5b9706-9abf-55c4-1f01-d87d536e5b45@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/06/2020 14:39, Xiaoguang Wang wrote:
>> On 6/9/20 10:44 AM, Pavel Begunkov wrote:
>>> On 09/06/2020 11:25, Xiaoguang Wang wrote:
>>>> If requests can be submitted and completed inline, we don't need to
>>>> initialize whole io_wq_work in io_init_req(), which is an expensive
>>>> operation, add a new 'REQ_F_WORK_INITIALIZED' to control whether
>>>> io_wq_work is initialized.
>>>
>>> Basically it's "call io_req_init_async() before touching ->work" now.
>>> This shouldn't be as easy to screw as was with ->func.
>>>
>>> The only thing left that I don't like _too_ much to stop complaining
>>> is ->creds handling. But this one should be easy, see incremental diff
>>> below (not tested). If custom creds are provided, it initialises
>>> req->work in req_init() and sets work.creds. And then we can remove
>>> req->creds.
>>>
>>> What do you think? Custom ->creds (aka personality) is a niche feature,
>>> and the speedup is not so great to care.
>>
>> Thanks for reviewing, I agree. Xiaoguang, care to fold in that change
>> and then I think we're good to shove this in.
> Yeah, I'll send new version soon.
> Pavel, thanks for your great work, and really appreciate both of you and jens' patience.

You're welcome. It lead us to rethinking and cleaning some parts, that's
great! And there are more such places, it's definitely worth to look into.

-- 
Pavel Begunkov
