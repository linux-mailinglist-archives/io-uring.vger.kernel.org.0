Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B78851E4A6
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 08:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiEGGk6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 02:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445545AbiEGGk4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 02:40:56 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082835A2CA;
        Fri,  6 May 2022 23:37:11 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id a11so7990713pff.1;
        Fri, 06 May 2022 23:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=XVfJ8nCtUSBBvI+zDOE/2bDYhHDKVITWrA5qgxBXiTY=;
        b=Ky30jMVp0A5EloSd/uvgoVZWJMggqEBvSHIvF8qkkqBUmHYOTv/0oaXT9rXHY5ZRCr
         2HboNER3xMVsdYi5xDf5DUPksp4lYmjGhDGbnd6Gd8/ZBhaI8KZhkjD4WU9a6pD1iHJE
         d0kc6wkfS6wh+g+SRhFThwDLKlNld5ZJe867jI1BMjoq1y92K8wNJ9Vapwl4WNqGFj5i
         tQ9Eoxwk0PwL5qRoX1TRu8o61SgCVMgnH8pHFi4CeNZeLoAlZbK2tg/vGuyp0TYp1+3V
         JVAZEhDWvm0vB192UuHA9m6I1pjjGkgvmAoB1ECRYzZklvtYlQsJHg6bz5mkJt/qOxlh
         zckQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XVfJ8nCtUSBBvI+zDOE/2bDYhHDKVITWrA5qgxBXiTY=;
        b=sXvpvNZ/3DGvO5Db/Hfx3wWvI5VbjaqjxphIltONT/uP5ls3cO9a1g388LTX+d0bjl
         eU4oHnplaRoI0mRUAo1ubb7bRbAHDoKEOTa71qJ27KCo4As2nEBpkiHE27y0HUyIWndX
         sq89Zj4lvdY0MM1Ui7HdiaYa5Dt2iXQh2PxAlna/8jpAOJzNXcfvC6bOxa/6hDOG02Wm
         KSQTmZe53ScX9+VLMAaYV9E904gbrpvAewp84KMWEBAdVb83ujkEWdc+22mLQnwpXy37
         DrISgisvSlNyrLq5yqcwKdlqrNGgHI6wDHUJX3Iss/PNJMKoplBIfzsVAmYYAI9lLhsx
         f4TA==
X-Gm-Message-State: AOAM533OKXA62mQIDRFW1gUvWwzp0FMvszgIb5VcXZg45m0ki8TM+3X1
        UTc3R4WQw5rhqg2xRw9V0Go=
X-Google-Smtp-Source: ABdhPJxiso2UD2UL3k/fmkVCNB4D3llu6b96K3fxRnmTTQ1LCQlJVOfh0KHpp1j1w1H454XdkLXF2g==
X-Received: by 2002:a65:60d3:0:b0:39c:f431:5859 with SMTP id r19-20020a6560d3000000b0039cf4315859mr5679923pgv.442.1651905430555;
        Fri, 06 May 2022 23:37:10 -0700 (PDT)
Received: from [192.168.255.10] ([106.53.4.151])
        by smtp.gmail.com with ESMTPSA id 16-20020a056a00071000b0050dc76281efsm4459770pfl.201.2022.05.06.23.37.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 23:37:10 -0700 (PDT)
Message-ID: <2551f97c-aa19-cb36-bb6f-fae93cc86f17@gmail.com>
Date:   Sat, 7 May 2022 14:37:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH 4/5] io_uring: add a helper for poll clean
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
 <20220506070102.26032-5-haoxu.linux@gmail.com>
 <7ea9cb04-3f80-d8a0-ab3c-40cf5049f614@kernel.dk>
From:   Hao Xu <haoxu.linux@gmail.com>
In-Reply-To: <7ea9cb04-3f80-d8a0-ab3c-40cf5049f614@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2022/5/6 下午10:36, Jens Axboe 写道:
> On 5/6/22 1:01 AM, Hao Xu wrote:
>> From: Hao Xu <howeyxu@tencent.com>
>>
>> Add a helper for poll clean, it will be used in the multishot accept in
>> the later patches.
> 
> Should this just go into io_clean_op()? Didn't look at it thoroughly,
> but it'd remove some cases from the next patch if it could.
> 
Actually this was my first version, here I put it in io_accept() to make
it happen as early as possible. I rethinked about this, seems it's ok to
put it into the io_clean_op().
